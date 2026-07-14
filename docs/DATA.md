# Dati: fonti, schema, standard

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [ARCHITECTURE.md](ARCHITECTURE.md) e [ML_MODEL.md](ML_MODEL.md).

Ogni dataset aggiunto dovrà avere provenienza, licenza/base giuridica, versione, schema, trasformazioni e limiti documentati.

## 1. Fonti dati per bootstrap e validazione iniziale del modello

Prima di poter usare dati reali di un ospedale (che richiedono governance e tempo), il modello va prototipato e validato su dataset pubblici/semi-pubblici esistenti, tra cui:

- **MIMIC-IV** (PhysioNet): dati ICU/ospedalieri strutturati, utile per validare pipeline tecniche (non specifico cardio-oncologia, ma standard de facto per prototipazione ML clinico)
- Coorti pubblicate in letteratura cardio-oncologica (es. studi osservazionali ESC Cardio-Oncology Registry) — non sempre disponibili come dataset scaricabile, spesso serve collaborazione diretta con i centri autori
- Dataset ecocardiografici pubblici per il training del modulo di estrazione automatica del GLS (es. CAMUS dataset per segmentazione ecocardiografica)

> Nota di trasparenza: non esiste oggi un dataset pubblico grande e specifico "chemioterapia + esiti cardiaci longitudinali". Questo rende strategica una futura collaborazione multi-centro, potenzialmente federata, ma il federated learning non è un prerequisito per il prototipo né sostituisce l'accesso a coorti clinicamente adeguate.

## 2. Standard di interoperabilità

- **HL7 FHIR R4** come modello dati canonico per lo scambio con gli EHR ospedalieri
- **OMOP CDM v5.4** come schema target per il data warehouse di ricerca (permette di riusare strumenti standard OHDSI per analisi di coorte)
- **DICOM** per le immagini ecocardiografiche/cardio-RM

Per il prototipo sarà definito un profilo FHIR minimo con almeno `Patient`, `Observation` e `MedicationRequest`; il supporto FHIR non dovrà essere dichiarato completo finché mapping, validazione e test di conformità non saranno versionati.

## 3. Entità dati principali (schema concettuale)

```
Paziente (1) ---- (N) EpisodioTerapia
Paziente (1) ---- (N) MisurazioneCardiaca (ECG, Echo/GLS, Troponina, NT-proBNP)
Paziente (1) ---- (N) FattoreRischio (comorbidità, storia familiare)
Paziente (1) ---- (0..1) ProfiloGenomico
EpisodioTerapia (1) ---- (N) SomministrazioneFarmaco (farmaco, dose, data)
EpisodioTerapia (1) ---- (N) RiskAssessment (score, timestamp, spiegazione SHAP, versione modello)
RiskAssessment (1) ---- (N) FeatureContributo (nome feature, peso, direzione)
```

Ogni `RiskAssessment` è **immutabile e versionato**: non si sovrascrive mai una predizione storica, si aggiunge la nuova. Questo è essenziale sia per audit clinico-legale sia per tracciare la performance del modello nel tempo (model drift).

## 4. Data governance

- **Data minimization**: si raccoglie solo ciò che è strettamente necessario per il task di predizione o per l'analisi di ricerca dichiarata
- **Pseudonimizzazione** a livello di storage clinico, con chiave di re-identificazione separata e accessibile solo a ruoli autorizzati
- **Data lineage tracciabile**: ogni dato usato per addestrare un modello deve essere ricostruibile (da dove viene, quando è stato raccolto, con quale consenso)
- **Retention policy** allineata agli obblighi di conservazione della documentazione sanitaria (in Italia tipicamente ≥10 anni), da conciliare con il diritto all'oblio — punto da definire con consulenza legale specifica, non risolvibile solo a livello architetturale
