# Stato del progetto

> Fonte unica per lo stato di [CORIS](../README.md). I documenti tematici descrivono requisiti e architettura; questo file indica cosa esiste realmente e cosa resta da fare.

## Fase attuale

**Fase 0 completata — prossimo step: fase 1 (vertical slice).** Scaffold repository, PostgreSQL via Docker Compose, variabili ambiente e CI base sono pronti.

## Legenda

| Stato | Significato |
|---|---|
| **Pianificato** | Definito nei documenti, ma senza artefatto eseguibile |
| **In corso** | Implementazione attiva, artefatto non ancora completo |
| **Implementato** | Presente nel repository e avviabile o verificabile |
| **Simulato** | Implementato per la demo con dati, servizi o nodi fittizi |
| **Validato** | Verificato con test o evidenze dichiarate e riproducibili |

Lo stato viene assegnato solo in presenza di evidenze nel repository.

## Mappa della documentazione

| Documento | Cosa definisce | Quando consultarlo in sviluppo |
|---|---|---|
| [README.md](../README.md) | Problema, idea, utenti, MVP→V3 | Allineamento funzionale e priorità prodotto |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Stack, diagramma, API REST/GraphQL | Scelte tecniche, confini tra servizi |
| [DATA.md](DATA.md) | Fonti dati, entità, FHIR/OMOP/DICOM | Schema DB, ingestione, dati sintetici |
| [ML_MODEL.md](ML_MODEL.md) | Task ML, metriche, explainability | Pipeline training/inferenza, model card |
| [DEPLOYMENT.md](DEPLOYMENT.md) | Docker Compose, migrazione prod | Infra locale, variabili, profili Compose |
| [TESTING.md](TESTING.md) | Piramide test, shadow mode | Criteri di uscita e tipi di test |
| [SECURITY.md](SECURITY.md) | Threat model, GDPR | Auth, audit, segregazione dati |
| [REGULATORY.md](REGULATORY.md) | Percorso MDR/SaMD | Disclaimer prototipo, vincoli d'uso |
| [ETHICS.md](ETHICS.md) | Bias, decision-support | UI, spiegazioni, model card |
| [ROADMAP.md](ROADMAP.md) | Team, timeline, rischi | Pianificazione a medio termine |

## Stato delle aree

| Area | Stato | Obiettivo prototipo | Evidenza |
|---|---|---|---|
| Repository e struttura codice | Implementato | Cartelle servizi, `.gitignore`, README per modulo | `services/`, `frontend/`, `scripts/`, `.gitignore` |
| Dashboard clinica e timeline | Pianificato | Vista paziente con pazienti sintetici | Frontend avviabile + test E2E |
| API e import FHIR R4 | Pianificato | Profilo minimo `Patient`, `Observation`, `MedicationRequest` | OpenAPI + test |
| Risk score pre-terapia + spiegazione | Pianificato | Baseline XGBoost + SHAP | Pipeline, modello, hold-out, model card |
| Monitoraggio longitudinale | Pianificato | Sperimentale o simulato | Dataset sequenziale documentato |
| Analisi immagini | Pianificato | Pipeline dimostrativa | Test su dataset pubblico |
| Federated learning | Pianificato | 2-3 nodi locali simulati | Log esperimenti |
| Dati sintetici | Pianificato | Generati e versionati | Generatore + seed riproducibile |
| Dataset pubblici | Pianificato | Acquisiti secondo licenza | Provenienza e versione documentate |
| Docker Compose (core) | In corso | Postgres attivo; gateway, ML e frontend in fase 1 | `docker-compose.yml`, `scripts/verify-phase0.sh` |
| Sicurezza e osservabilità | Pianificato | Auth dimostrativa + audit base | Config + test |
| Test software | Pianificato | Unit + integrazione | Comandi riproducibili in CI |
| Validazione clinica / MDR | Pianificato | Fuori scope prototipo | — |

## Backlog di sviluppo

Ordine consigliato. Aggiornare **Stato** e **Evidenza** a ogni task completato.

### Fase 0 — Scaffold

| ID | Task | Stato | Doc | Evidenza attesa |
|---|---|---|---|---|
| 0.1 | Struttura repository (`services/`, `frontend/`, `.gitignore`) | Implementato | ARCHITECTURE, DEPLOYMENT | `services/`, `frontend/`, `scripts/`, `.gitignore` |
| 0.2 | `docker-compose.yml` minimo (solo PostgreSQL) | Implementato | DEPLOYMENT | `docker compose up -d postgres` |
| 0.3 | `.env.example` con variabili documentate | Implementato | DEPLOYMENT, SECURITY | `.env.example` in root |
| 0.4 | Workflow CI base (lint/test su PR) | Implementato | TESTING | `.github/workflows/ci.yml` |

### Fase 1 — Vertical slice (priorità massima)

| ID | Task | Stato | Doc | Evidenza attesa |
|---|---|---|---|---|
| 1.1 | Schema PostgreSQL + migrazioni (entità da DATA.md) | Pianificato | DATA, ARCHITECTURE | DDL/migrazioni versionate |
| 1.2 | Generatore pazienti sintetici | Pianificato | DATA | Script + seed fisso |
| 1.3 | `ml-service`: endpoint risk score + SHAP (baseline) | Pianificato | ML_MODEL, ARCHITECTURE | `POST /predict`, model card |
| 1.4 | `api-gateway`: CRUD paziente + proxy verso ML | Pianificato | ARCHITECTURE | REST documentato |
| 1.5 | Ingestione FHIR minima (3 risorse) | Pianificato | DATA, ARCHITECTURE | Test parsing/validazione |
| 1.6 | `frontend`: dashboard paziente + timeline rischio | Pianificato | README (caso d'uso) | UI collegata alle API |
| 1.7 | Test integrazione end-to-end del flusso completo | Pianificato | TESTING, STATUS (milestone) | Test automatico verde |

**Criterio milestone Vertical slice:** paziente sintetico → API → risk score versionato con spiegazione → dashboard, avviabile in locale.

### Fase 2 — Prototipo completo dimostrativo

| ID | Task | Stato | Doc | Evidenza attesa |
|---|---|---|---|---|
| 2.1 | Auth OIDC (Keycloak) + RBAC base | Pianificato | SECURITY, DEPLOYMENT | Login demo + ruoli |
| 2.2 | Alert su soglia di rischio | Pianificato | README (MVP) | API alert + UI |
| 2.3 | Modello longitudinale (sperimentale) | Pianificato | ML_MODEL | Endpoint + confronto baseline |
| 2.4 | Pipeline DICOM dimostrativa | Pianificato | DATA, ML_MODEL | Orthanc + inferenza stub |
| 2.5 | Federated learning simulato (2-3 client) | Pianificato | ML_MODEL, ARCHITECTURE | Script Flower + report |
| 2.6 | Prometheus + Grafana base | Pianificato | DEPLOYMENT, ARCHITECTURE | Dashboard metriche |
| 2.7 | OpenAPI pubblicata + GraphQL schema v1 | Pianificato | ARCHITECTURE | File versionati in repo |

### Fase 3 — Fuori scope prototipo

| ID | Task | Stato | Doc |
|---|---|---|---|
| 3.1 | Dati clinici reali e governance | Pianificato | DATA, REGULATORY |
| 3.2 | Shadow mode in ambiente ospedaliero | Pianificato | TESTING, REGULATORY |
| 3.3 | Percorso MDR / marcatura CE | Pianificato | REGULATORY |
| 3.4 | Analisi competitiva strutturata | Pianificato | COMPETITIVE_ANALYSIS |

## Log avanzamento

Registrare qui ogni step completato (data, task ID, nota breve).

| Data | Task | Nota |
|---|---|---|
| 2026-07-15 | — | Sviluppo avviato; backlog e scaffold repository creati |
| 2026-07-15 | 0.1–0.4 | Fase 0 completata: Compose (Postgres), `.env.example`, CI, script verifica |

## Regole di aggiornamento

1. Aggiornare questo file nella stessa modifica che introduce o completa un artefatto.
2. Un task passa a **Implementato** solo con evidenza nel repository (file, test, comando).
3. Non usare **Validato** per obiettivi futuri o metriche non ancora misurate.
4. Mantenere distinti prototipo tecnico, pilota clinico e prodotto certificato.

Ultimo aggiornamento: **15 luglio 2026**.
