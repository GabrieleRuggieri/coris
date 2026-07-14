# Etica, bias e fattore umano

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [ML_MODEL.md](ML_MODEL.md) e [REGULATORY.md](REGULATORY.md).

Le misure descritte sono requisiti per il futuro prodotto. Nel prototipo dovranno essere rese visibili attraverso disclaimer, dati non clinici, spiegazioni contestuali e assenza di azioni automatiche; non rappresentano da sole una validazione etica o clinica.

## Fairness e bias

- **Audit sistematico per sottogruppo**: performance del modello (AUROC, calibrazione) misurate separatamente per età, sesso, etnia, tipo tumore — non solo in aggregato. Un modello con buone performance medie può essere sistematicamente peggiore su una sottopopolazione sottorappresentata nei dati di training.
- **Model card obbligatoria** già per ogni modello dimostrativo e per ogni futura versione in produzione: popolazione di training, limiti noti, sottopopolazioni non adeguatamente rappresentate, performance disaggregata.
- **Processo di revisione periodica**: non basta validare una volta — la popolazione clinica cambia (nuovi farmaci, nuove linee guida), serve un processo ricorrente di ri-validazione.

## Autonomia clinica e responsabilità

- Il sistema è progettato esplicitamente come **decision-support**, mai come sostituto del giudizio clinico. Nessun output è "prescrittivo" nel senso di azione automatica.
- **Nessuna azione clinica automatica**: il sistema non modifica mai dosi, non annulla mai terapie autonomamente. Genera solo informazione e alert per un medico che decide.
- Va sempre chiaro chi è responsabile legalmente della decisione finale (il medico), un punto da formalizzare in accordo con l'ufficio legale e risk management dell'ospedale, non qualcosa che il software può "risolvere" da solo.

## Rischio di over-reliance ("automation bias")

- Rischio reale: un medico può iniziare a fidarsi ciecamente dello score senza esercitare giudizio critico, specialmente sotto pressione di tempo.
- Mitigazione di design: l'interfaccia non deve mai presentare un numero isolato senza il contesto della spiegazione; workflow che richiede una conferma esplicita e motivata quando il medico si discosta dalla raccomandazione (per audit, non per "punire" il dissenso clinico).

## Comunicazione col paziente

- Se il paziente chiede informazioni sul proprio risk score, serve un layer di comunicazione pensato con linguaggio non ansiogeno e comprensibile — un "34% di rischio" comunicato male può generare angoscia sproporzionata. Questo richiede coinvolgimento di psico-oncologi nella progettazione dell'interfaccia paziente (se mai prevista in versioni future).

## Consenso informato

- I pazienti devono essere informati che i loro dati contribuiscono (in forma aggregata/federata) a un sistema di ricerca, con possibilità di opt-out che non pregiudichi le cure standard.
- Il consenso deve distinguere chiaramente tra uso clinico diretto del dato (necessario alle cure) e uso secondario per ricerca/training del modello (che richiede una base giuridica e un consenso distinti).

## Equità di accesso

- Un rischio spesso trascurato: se il sistema è disponibile solo in centri accademici avanzati, rischia di ampliare le disuguaglianze di cura invece di ridurle. Andrebbe pensato un percorso di adozione che includa anche centri periferici, non solo hub di eccellenza.
