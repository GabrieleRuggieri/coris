# Strategia di testing e validazione clinica

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [ML_MODEL.md](ML_MODEL.md) e [REGULATORY.md](REGULATORY.md).

| Livello | Cosa si verifica | Come | Scope |
|---|---|---|---|
| Unit test | Correttezza funzioni singole (calcolo feature, parsing FHIR) | pytest / Jest, coverage minimo target 80% su codice non-ML | Prototipo |
| Integration test | Corretta comunicazione tra servizi (API ↔ ML serving ↔ DB) | Test end-to-end su ambiente staging con dati sintetici | Prototipo |
| Model validation | Performance del modello su dati mai visti | Hold-out set; validazione esterna solo quando esiste una coorte indipendente | Prototipo + futuro clinico |
| Fairness testing | Assenza di degrado sistematico su sottogruppi | Audit disaggregato automatizzato ad ogni release del modello | Prototipo, nei limiti dei dati |
| Adversarial/robustness testing | Comportamento su input malformati o fuori distribuzione | OOD detection testing, fuzzing degli input API | Prototipo |
| Shadow mode testing | Comportamento in condizioni reali senza impatto clinico | Deploy parallelo al workflow clinico esistente, confronto predizioni vs esiti reali, nessuna azione clinica basata sul sistema | Futuro clinico |
| Validazione clinica prospettica | Impatto reale sulle decisioni e sugli esiti paziente | Studio clinico con comitato etico, misurato su outcome (non solo accuratezza tecnica) | Futuro clinico |
| Security testing | Vulnerabilità exploitabili | Scanning automatico nel prototipo; penetration testing indipendente prima di un pilota | Prototipo + futuro clinico |

## Un punto chiave

La validazione tecnica del modello (AUROC alto) **non è sufficiente**. Un modello accurato può comunque peggiorare gli esiti clinici se, ad esempio, genera troppi falsi allarmi e causa "alert fatigue" nei medici. La validazione clinica prospettica misura l'impatto reale, non solo la metrica statistica.

## Criteri di uscita per ogni fase

- Prima di passare da *shadow mode* a *uso clinico interventistico*: performance stabile su almeno 2 cicli di ri-validazione consecutivi, nessun bias significativo rilevato nell'audit di sottogruppo, feedback qualitativo positivo dal team clinico pilota
- Prima di ogni rilascio in produzione di una nuova versione del modello: confronto A/B controllato contro la versione corrente, non solo miglioramento medio ma nessun peggioramento su nessun sottogruppo monitorato
