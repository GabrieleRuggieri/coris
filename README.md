# CORIS — Cardio Oncology Risk Intelligence System

**Piattaforma predittiva di ML per la stratificazione del rischio di cardiotossicità indotta da terapie oncologiche**

---

## Indice del progetto

Questo repository di documentazione è diviso per argomento, così ogni file resta focalizzato e consultabile in autonomia:

| File | Contenuto |
|---|---|
| `README.md` (questo file) | Overview, problema, idea, utenti, roadmap funzionale |
| [`docs/STATUS.md`](docs/STATUS.md) | Stato corrente, legenda, perimetro e criteri di completamento |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Architettura tecnica, stack tecnologico, API design |
| [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) | Stack gratuito per la demo (Docker Compose) e percorso verso k8s/S3 in produzione |
| [`docs/DATA.md`](docs/DATA.md) | Fonti dati, schema entità, standard di interoperabilità |
| [`docs/ML_MODEL.md`](docs/ML_MODEL.md) | Approccio ML per ciascun task, metriche di validazione |
| [`docs/SECURITY.md`](docs/SECURITY.md) | Sicurezza, privacy, threat model |
| [`docs/REGULATORY.md`](docs/REGULATORY.md) | Percorso regolatorio SaMD/MDR |
| [`docs/ETHICS.md`](docs/ETHICS.md) | Etica, bias, fattore umano |
| [`docs/TESTING.md`](docs/TESTING.md) | Strategia di testing e validazione clinica |
| [`docs/COMPETITIVE_ANALYSIS.md`](docs/COMPETITIVE_ANALYSIS.md) | Posizionamento competitivo |
| [`docs/ROADMAP.md`](docs/ROADMAP.md) | Team, timeline, costi, rischi |

---

## Stato del progetto

Il riepilogo aggiornato di componenti, modelli, dati e milestone è mantenuto in [`docs/STATUS.md`](docs/STATUS.md), unica fonte per gli stati di avanzamento.

Per “prototipo completo” si intende una dimostrazione end-to-end con dati non clinici. **Non è un dispositivo medico, non è certificato e non deve supportare decisioni cliniche reali.**

---

## 1. Il problema

Molte terapie oncologiche salvavita (antracicline, anti-HER2 come trastuzumab, inibitori delle tirosin-chinasi, radioterapia toracica, immunoterapia con checkpoint inhibitor) sono **cardiotossiche**: possono causare cardiomiopatia, scompenso cardiaco, aritmie o eventi ischemici, anche a distanza di mesi o anni dal trattamento.

Oggi la sorveglianza cardiologica dei pazienti oncologici è per lo più:
- **reattiva**, non predittiva (si interviene quando il danno è già visibile all'ecocardiogramma)
- **standardizzata su protocolli generici**, non personalizzata sul singolo paziente
- **frammentata** tra oncologia e cardiologia, con scarsa condivisione strutturata dei dati
- povera di strumenti che permettano ai ricercatori di aggregare coorti multi-centriche per studiare biomarcatori precoci di cardiotossicità

Questo è esattamente il problema che la **cardio-oncologia** (disciplina clinica riconosciuta da ESC e ASCO) cerca di risolvere — ma mancano strumenti digitali predittivi maturi.

## 2. L'idea

**CORIS** è la visione di una piattaforma clinica che:

1. **Predice il rischio individuale di cardiotossicità** prima e durante la terapia oncologica, integrando dati multimodali (clinici, laboratoristici, strumentali, genomici, terapeutici).
2. **Traccia la traiettoria di rischio nel tempo** — modello longitudinale che si aggiorna a ogni visita/esame, non uno score statico.
3. **Spiega le proprie predizioni** (Explainable AI), per decisioni condivise tra oncologo e cardiologo.
4. **Abilita la ricerca multi-centrica** tramite federated learning, senza mai far uscire i dati dei pazienti dal perimetro dell'ospedale.

Dettagli tecnici completi in [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) e [`docs/ML_MODEL.md`](docs/ML_MODEL.md).

### Perché è innovativa

- **Predizione longitudinale, non uno snapshot**
- **Multimodalità reale**: dati strutturati, time-series (ECG), immagini (ecocardiogramma), genomica
- **Explainability clinicamente utile**, non un grafico tecnico astratto
- **Federated learning tra centri**: coorti ampie senza centralizzare dati sensibili
- **Doppio target nativo**: vista clinica (assistenza) e vista ricerca (data scientist)

## 3. Utenti target

| Utente | Bisogno principale |
|---|---|
| Oncologo ospedaliero | Sapere se un regime è sicuro per quel paziente, ricevere alert tempestivi |
| Cardiologo (cardio-oncologo) | Prioritizzare i pazienti ad alto rischio, capire il "perché" del rischio |
| Ricercatore clinico / farma | Coorti aggregate multi-centriche, esportazione dati anonimizzati |
| Data manager / IT ospedaliero | Integrazione con EHR esistente, conformità normativa |

### Caso d'uso narrato — "giornata tipo"

*Dr.ssa Rossi, oncologa*, sta per iniziare un ciclo di doxorubicina su una paziente di 62 anni con storia di ipertensione. Il sistema mostra un risk score pre-terapia con spiegazione: "il rischio è guidato principalmente da: dose cumulativa pianificata, ipertensione non ben controllata, età". Suggerisce una consulenza cardio-oncologica prima dell'avvio.

*Dr. Bianchi, cardiologo*, riceve la richiesta con già pronta la timeline della paziente. Decide se avviare cardioprotezione o solo intensificare il monitoraggio.

Durante il trattamento, ogni nuovo esame aggiorna automaticamente la traiettoria di rischio. Se il modello rileva una deviazione anomala, genera un alert prioritizzato — non un'alluvione di notifiche.

*Dr. Verdi, ricercatore clinico*, usa il cohort builder per estrarre dati aggregati e anonimizzati, e valida un nuovo biomarcatore genomico su dati multi-centrici via federated learning.

## 4. Funzionalità (MVP → Vision)

### MVP
- Import dati da EHR (HL7 FHIR) + inserimento manuale assistito
- Calcolo risk score iniziale pre-terapia
- Dashboard clinica con timeline paziente e alert soglia
- Modulo di spiegabilità (feature importance tradotta clinicamente)

### V2
- Modello longitudinale aggiornato ad ogni ecocardiogramma/labs
- Integrazione ECG continuo (wearable/holter) con detection automatica di anomalie precoci
- Raccomandazioni di cardioprotezione basate su linee guida ESC (decision-support, non prescrittivo)

### V3 (Ricerca)
- Modulo federated learning multi-centro
- Cohort builder per ricercatori
- Export dataset conformi a standard OMOP CDM
- API per integrazione in trial clinici

---

*Documento overview — versione 3.0 (documentazione modulare, vedi cartella `docs/`)*
