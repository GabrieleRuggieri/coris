# Stato del progetto

> Fonte unica per lo stato di [CORIS](../README.md). I documenti tematici descrivono requisiti e architettura; questo file indica cosa esiste realmente.

## Fase attuale

**Concept documentato; implementazione non ancora iniziata.** Il repository contiene la specifica del prototipo e della visione di prodotto, ma non ancora codice, modelli addestrati, infrastruttura eseguibile o validazioni cliniche.

## Legenda

| Stato | Significato |
|---|---|
| **Pianificato** | Definito nei documenti, ma senza artefatto eseguibile |
| **Implementato** | Presente nel repository e avviabile o verificabile |
| **Simulato** | Implementato per la demo con dati, servizi o nodi fittizi |
| **Validato** | Verificato con test o evidenze dichiarate e riproducibili |

Lo stato viene assegnato solo in presenza di evidenze nel repository. Una funzione non diventa **Simulata**, **Implementata** o **Validata** finché il relativo artefatto non esiste.

## Stato delle aree

| Area | Stato attuale | Obiettivo del prototipo | Evidenza richiesta |
|---|---|---|---|
| Dashboard clinica e timeline | Pianificato | Implementata con pazienti sintetici | Frontend avviabile e test end-to-end |
| API e import FHIR R4 | Pianificato | Implementati su un profilo minimo documentato | OpenAPI/schema, validazione e test |
| Risk score pre-terapia + spiegazione | Pianificato | Baseline principale implementata | Pipeline, modello versionato, hold-out e model card |
| Monitoraggio longitudinale | Pianificato | Sperimentale o simulato | Dataset sequenziale e confronto con baseline |
| Analisi immagini | Pianificato | Dimostrativa, non clinicamente validata | Pipeline DICOM e test su dataset pubblico |
| Federated learning | Pianificato | Simulato localmente con 2-3 nodi | Log esperimenti e confronto centralizzato |
| Dati sintetici | Pianificato | Generati e versionati | Generatore, schema e seed riproducibile |
| Dataset pubblici | Pianificato | Acquisiti secondo licenza | Provenienza, licenza, versione e trasformazioni |
| Dati clinici reali | Pianificato | Fuori scope del prototipo | Governance, autorizzazioni e partner clinico |
| Docker Compose | Pianificato | Stack locale riproducibile | Compose, Dockerfile, `.env.example` e smoke test |
| Sicurezza e osservabilità | Pianificato | Controlli tecnici dimostrativi | Configurazioni e test automatici |
| Test software | Pianificato | Unit, integrazione, robustness e security scanning | Comandi e risultati riproducibili |
| Validazione clinica e conformità MDR | Pianificato | Fuori scope del prototipo | Studi, sistema qualità e valutazione regolatoria formale |
| Analisi competitiva | Pianificato | Ricerca strutturata di mercato e brevetti | Metodo, fonti e data di aggiornamento |

## Perimetro tecnico

| Livello | Componenti |
|---|---|
| Core da implementare | Frontend React, API gateway NestJS, servizio FastAPI, PostgreSQL, autenticazione e audit essenziale |
| Dimostrativo o sperimentale | Modello longitudinale, imaging DICOM, osservabilità e client federati locali |
| Target produzione | Kubernetes multi-cluster, datastore specializzati, alta disponibilità, mTLS completo e GitOps |

TimescaleDB, ClickHouse, Orthanc, MinIO e il layer federato saranno aggiunti progressivamente; non sono prerequisiti per il primo vertical slice.

## Criteri delle milestone

| Milestone | Criterio minimo di completamento |
|---|---|
| Vertical slice | Paziente sintetico → API → risk score versionato → spiegazione → dashboard, avviabile localmente |
| Prototipo completo | Funzioni core implementate, componenti avanzati marcati come sperimentali o simulati, test automatici e documentazione aggiornata |
| Baseline ML | Dataset e pipeline versionati, hold-out separato, metriche misurate e model card |
| Federated demo | Almeno 2 client locali simulati e confronto documentato con training centralizzato |
| Candidato a pilota | Partner e dati autorizzati, valutazione regolatoria, sicurezza e protocollo di validazione formalizzati |

## Regole di aggiornamento

1. Aggiornare questo file nella stessa modifica che introduce o rimuove un artefatto.
2. Collegare ogni passaggio di stato a file, test o report riproducibili.
3. Non usare **Validato** per metriche obiettivo o valutazioni esclusivamente interne.
4. Mantenere distinti prototipo tecnico, pilota clinico e prodotto certificato.

Ultimo aggiornamento dello stato: **14 luglio 2026**.
