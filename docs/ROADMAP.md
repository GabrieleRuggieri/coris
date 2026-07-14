# Team, timeline, costi e rischi

> Parte di [CORIS](../README.md). Stato e criteri delle milestone in [STATUS.md](STATUS.md). Vedi anche [REGULATORY.md](REGULATORY.md).

Durate, team e costi sono ipotesi da aggiornare dopo il primo vertical slice e la verifica di accesso ai dati.

## Team e competenze necessarie

| Ruolo | Perché serve |
|---|---|
| Clinical lead (cardio-oncologo) | Validazione clinica del modello, definizione soglie di rischio, credibilità presso i centri |
| ML engineer / Data scientist (2-3) | Sviluppo modelli, validazione, monitoraggio drift |
| Backend engineer (2-3) | API, integrazione FHIR, servizi dati |
| Frontend engineer (1-2) | Dashboard clinica, cohort builder |
| Data engineer | Pipeline dati, data warehouse ricerca, qualità dati |
| DevOps/Platform engineer | Kubernetes, sicurezza infrastrutturale, CI/CD |
| Regulatory affairs specialist | Percorso MDR/SaMD, documentazione tecnica |
| Data protection officer / legale privacy | GDPR, consenso informato, accordi con centri |
| UX researcher (con background clinico se possibile) | Workflow clinico realistico, riduzione automation bias |
| Project/product manager | Coordinamento multi-centro, roadmap |

Per l'MVP tecnico (senza percorso regolatorio completo) un team ridotto di 5-7 persone (clinical lead part-time incluso) è realistico. Il percorso SaMD completo richiede coinvolgimento di regulatory affairs e legale fin dalle fasi iniziali, non aggiunto a posteriori.

## Timeline e milestone (indicativa)

| Fase | Durata stimata | Output |
|---|---|---|
| Concept validation + data feasibility | 2-3 mesi | Accesso dati confermato, validazione preliminare su dati pubblici |
| MVP tecnico (shadow mode, no uso clinico) | 6-9 mesi | Piattaforma funzionante, modello v1 validato retrospettivamente |
| Studio pilota prospettico (shadow mode reale) | 6-12 mesi | Dati di performance reale, primo model card |
| Validazione clinica prospettica interventistica | 12-24 mesi | Evidenza di impatto clinico, base per fascicolo MDR |
| Fascicolo regolatorio + Notified Body | 6-18 mesi (parallelo/sequenziale) | Marcatura CE |
| Espansione multi-centro (federated learning) | Successiva alla baseline centralizzata; demo locale anticipabile | Modello più robusto, coorte di ricerca ampliata |

Timeline complessiva realistica per un primo deployment clinico certificato: **3-5 anni**, coerente con gli standard reali del settore SaMD (non è un progetto "veloce" per costruzione, anche se lo stack tecnico è realizzabile in mesi).

## Stima costi infrastrutturali (ordine di grandezza)

**Fase demo (obiettivo)**: nessun costo obbligatorio per servizi cloud o licenze applicative; lo stack pianificato dovrà girare self-hosted in Docker Compose su hardware locale. Hardware, energia e tempo operativo non sono inclusi. Dettagli in [DEPLOYMENT.md](DEPLOYMENT.md).

**Fase pilota clinico e oltre** (1-3 centri, poche migliaia di pazienti), quando si passa a infrastruttura gestita/cloud per motivi di affidabilità e compliance — stima indicativa, **da verificare con un vero cost model** prima di qualunque decisione di budget:

- **Infrastruttura cloud/on-prem** (compute per training + inferenza, storage DICOM): ordine di grandezza decine di migliaia di € /anno in fase pilota, cresce significativamente con l'aggiunta di centri e con l'imaging ad alta risoluzione
- **Licenze/strumenti** (MLOps, osservabilità, sicurezza): variano molto in base a scelta open source vs enterprise
- **Costo regolatorio** (Notified Body, consulenza regolatoria, studi clinici): tipicamente la voce di costo più significativa per un vero SaMD, spesso superiore ai costi di sviluppo software puro

> Questa stima è volutamente qualitativa: un vero budget richiede un dimensionamento preciso (numero pazienti, frequenza esami, retention dati immagine) che va oltre lo scopo di un documento di concept.

## Rischi e mitigazioni

| Rischio | Mitigazione |
|---|---|
| Dataset di training limitati (cardiotossicità è evento raro) | Federated learning multi-centro + data augmentation + transfer learning da dataset pubblici |
| Bias su sottopopolazioni (età, etnia, sesso) | Audit di fairness sistematico, reporting per sottogruppo, model card obbligatoria |
| Sfiducia clinica verso "black box" | Explainability come requisito di design, non feature aggiuntiva |
| Integrazione con EHR eterogenei tra ospedali | Adozione stretta di HL7 FHIR, adapter per sistemi legacy |
| Responsabilità clinico-legale delle predizioni | Sistema resta decision-support, mai autonomo; workflow di validazione umana obbligatoria |
| Automation bias (fiducia eccessiva nel modello) | UI che forza contesto/spiegazione, audit dei casi di discostamento |
| Data poisoning / attacchi al federated learning | Robust aggregation, anomaly detection sugli update |
| Tempi e costi regolatori sottostimati | Coinvolgimento regulatory affairs fin dalla fase concept, non a posteriori |
