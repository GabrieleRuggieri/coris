# Approccio ML e metriche di validazione

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [DATA.md](DATA.md) e [TESTING.md](TESTING.md).

Le metriche indicate in questo documento sono criteri obiettivo; i risultati misurati e gli artefatti disponibili sono registrati in [STATUS.md](STATUS.md).

## Task 1 — Risk stratification pre-terapia

- **Modello**: Gradient Boosting (XGBoost/LightGBM) su feature tabellari
- **Input**: età, comorbidità, FEVS basale, dose cumulativa pianificata, farmaci concomitanti, genomica se disponibile
- **Output**: probabilità di cardiotossicità a 6/12/24 mesi + intervallo di confidenza
- **Target metriche minime future per considerare il modello candidato a un pilota clinico**:
  - AUROC ≥ 0.75 su validazione esterna (non solo cross-validation interna)
  - Calibrazione: Brier score monitorato, calibration plot verificato per fascia di rischio (un modello con buon AUROC ma scarsa calibrazione è pericoloso in clinica)
  - Sensibilità prioritaria su specificità nella fascia "alto rischio" (costo di un falso negativo > costo di un falso positivo in questo contesto)

## Task 2 — Monitoraggio longitudinale

- **Modello**: Temporal Fusion Transformer o LSTM con attention
- **Input**: sequenza multivariata (visite, labs, feature ECG estratte)
- **Output**: traiettoria di rischio aggiornata + rilevamento deviazioni anomale
- **Metrica chiave**: tempo di anticipo dell'alert rispetto all'evento clinico osservato (obiettivo: settimane, non giorni, di anticipo rispetto al calo di FEVS visibile)

## Task 3 — Analisi immagini cardiache

- **Modello**: CNN/Vision Transformer per estrazione automatica di GLS (global longitudinal strain), biomarcatore precoce spesso non calcolato di routine
- **Metrica**: concordanza (correlazione, limiti di Bland-Altman) con misurazione manuale di un cardiologo esperto — non solo accuratezza tecnica ma accordo inter-osservatore

## Explainability

- SHAP / Integrated Gradients per modelli tabellari e sequenziali
- Layer di "traduzione clinica": converte output tecnico in narrativa comprensibile (es. non "feature_12: 0.34" ma "dose cumulativa antracicline sopra soglia raccomandata")

## Federated learning

- Framework scelto per il prototipo: Flower
- Ogni centro allena localmente, si condividono solo gli aggiornamenti dei pesi
- **Differential privacy** sui gradienti condivisi (rumore calibrato per impedire la ricostruzione di dati individuali dai pesi condivisi)
- Aggregazione centrale tramite algoritmi tipo FedAvg, con monitoraggio della "client drift" (un centro con popolazione molto diversa non deve degradare il modello globale)

## Monitoraggio in produzione

Questa sezione descrive requisiti target successivi al prototipo, non capacità attualmente operative.

- **Model drift monitoring** continuo: le distribuzioni delle feature e delle predizioni vanno confrontate periodicamente con quelle del training set
- **Re-training trigger**: definire soglie oggettive (es. calo di calibrazione oltre una soglia) che attivano un processo di ri-validazione, non un re-training automatico non supervisionato
- Ogni nuova versione del modello richiede una nuova model card (vedi [ETHICS.md](ETHICS.md)) prima del rilascio
