# Architettura tecnica e stack

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [DATA.md](DATA.md) e [ML_MODEL.md](ML_MODEL.md).

## 1. Diagramma d'architettura

Il diagramma seguente rappresenta la **visione target completa**.

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND (React/TS)                       │
│   Vista Clinica            Vista Ricerca (Cohort Builder)        │
└───────────────┬───────────────────────────┬──────────────────────┘
                │ GraphQL/REST               │ GraphQL
┌───────────────▼───────────────────────────▼──────────────────────┐
│                   API GATEWAY (Node.js/NestJS)                   │
│         AuthN/AuthZ (OIDC, RBAC) · Rate limiting · Audit log     │
└───────────────┬───────────────────────────┬──────────────────────┘
                │                            │
┌───────────────▼─────────────┐  ┌───────────▼──────────────────────┐
│   SERVIZI CLINICI            │  │   SERVIZI ML (FastAPI)            │
│   - Gestione pazienti        │  │   - Risk scoring (XGBoost)        │
│   - Timeline/alerting        │  │   - Modello longitudinale (TFT)   │
│   - Integrazione FHIR        │  │   - GLS extraction (CNN)          │
└───────────────┬──────────────┘  │   - Explainability (SHAP)         │
                │                  └───────────┬────────────────────┘
┌───────────────▼──────────────────────────────▼────────────────────┐
│                         DATA LAYER                                 │
│  PostgreSQL (clinico)  ·  TimescaleDB (ECG/vitali)                │
│  ClickHouse+OMOP CDM (ricerca)  ·  Orthanc/DICOM (immagini)        │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│         LAYER FEDERATED LEARNING (multi-ospedale)                 │
│  Ospedale A [train locale] ─┐                                     │
│  Ospedale B [train locale] ─┼──► Aggregatore centrale (pesi only) │
│  Ospedale C [train locale] ─┘        + Differential Privacy       │
└──────────────────────────────────────────────────────────────────┘
```

Principio architetturale chiave: **i dati paziente grezzi non attraversano mai i confini organizzativi**. Solo pesi di modello (federated learning) o dati aggregati/anonimizzati (ricerca) escono dal perimetro del singolo ospedale.

## 2. Stack tecnologico

### Backend
- **Linguaggio**: Python (servizi ML) + **Node.js/NestJS con TypeScript** (API gateway)
- **API**: GraphQL (query flessibili per ricerca) + REST per integrazioni EHR/HL7 FHIR
- **ML serving**: FastAPI + ONNX Runtime / TorchServe per inferenza a bassa latenza
- **Orchestrazione training**: MLflow per experiment tracking e model registry
- **Federated learning**: Flower framework, orchestrato su Kubernetes multi-cluster (uno per ospedale) in produzione

> **Perché NestJS e non Go**: il gateway è un carico prevalentemente I/O-bound (routing, auth, orchestrazione verso servizi ML/DB), non CPU-bound — il calcolo pesante è già delegato a Python. NestJS offre: (1) TypeScript condiviso con il frontend React, riducendo attrito e duplicazione di tipi; (2) un ecosistema GraphQL (Apollo) molto più maturo di quello Go (gqlgen richiede più boilerplate per schema, subscriptions, federation); (3) struttura "batteries-included" (moduli, DI, guard, interceptor) che accelera l'implementazione di RBAC, validazione e audit logging — tutti requisiti critici qui. Go resterebbe la scelta migliore solo se il collo di bottiglia reale fosse il throughput puro del gateway, cosa non prevista in questo dominio: il vincolo reale è la latenza di inferenza ML, non il routing HTTP.

### Data layer
- **Dati clinici strutturati**: PostgreSQL con estensione per storicizzazione (temporal tables)
- **Standard interoperabilità**: HL7 FHIR (R4) come modello dati canonico
- **Data warehouse ricerca**: OMOP CDM su un DB colonnare (es. ClickHouse)
- **Time-series (ECG, vitali continui)**: TimescaleDB
- **Immagini mediche**: PACS/DICOM storage (Orthanc open source) + object storage (S3-compatible)

### Frontend
- **Framework**: React + TypeScript
- **Visualizzazione clinica**: componenti custom timeline paziente, D3.js per traiettorie di rischio
- **Cohort builder ricerca**: query builder visuale (drag&drop) tipo "no-code"

### Infrastruttura & DevOps
- **Deploy (produzione)**: Kubernetes (on-prem per compliance ospedaliera, opzione ibrida cloud per il layer di ricerca anonimizzato)
- **Deploy (demo gratuita, pianificato)**: i componenti selezionati per il prototipo saranno orchestrati con Docker Compose in locale — vedi [DEPLOYMENT.md](DEPLOYMENT.md)
- **Sicurezza**: OAuth2/OIDC + RBAC granulare, audit log immutabile (append-only). Dettagli completi in [SECURITY.md](SECURITY.md)
- **Osservabilità**: Prometheus + Grafana, tracing OpenTelemetry
- **CI/CD**: GitOps (ArgoCD), pipeline di validazione modelli con model drift monitoring (Evidently AI)

## 3. API design (estratto)

Gli endpoint seguenti sono esempi di contratto e dovranno essere formalizzati in una specifica OpenAPI e in uno schema GraphQL versionati.

### REST — integrazione EHR (ingestion)
```
POST /api/v1/fhir/Patient
POST /api/v1/fhir/Observation        # labs, vitali, ECG features
POST /api/v1/fhir/MedicationRequest  # regime chemioterapico
GET  /api/v1/patients/{id}/risk-timeline
```

### GraphQL — vista clinica e ricerca
```graphql
query PatientRiskProfile($patientId: ID!) {
  patient(id: $patientId) {
    demographics { age sex }
    riskAssessments(last: 5) {
      timestamp
      score
      confidenceInterval
      explanation { feature contribution direction }
    }
    alerts(status: ACTIVE) { severity message triggeredAt }
  }
}

mutation RunRiskAssessment($patientId: ID!, $episodeId: ID!) {
  runRiskAssessment(patientId: $patientId, episodeId: $episodeId) {
    assessmentId
    status  # QUEUED | COMPLETED | FAILED
  }
}
```

### Considerazioni di design API
- Ogni risposta che include predizioni ML porta obbligatoriamente `modelVersion` e `explanation` — mai uno score "nudo"
- Idempotenza garantita su tutte le mutation cliniche (un retry di rete non deve duplicare un ordine/alert)
- Versionamento esplicito dell'API (`/v1/`) con deprecation policy dichiarata, dato che i client EHR ospedalieri si aggiornano lentamente
