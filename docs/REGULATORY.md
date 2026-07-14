# Percorso regolatorio (SaMD)

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [SECURITY.md](SECURITY.md) ed [ETHICS.md](ETHICS.md).

Questa è un'analisi preliminare, non una valutazione regolatoria formale. Il prototipo è destinato esclusivamente a dimostrazione tecnica e ricerca esplorativa: non è un dispositivo medico, non è marcato CE e non deve essere usato per diagnosi, terapia, monitoraggio clinico o decisioni su pazienti reali.

Un futuro sistema che fornisse risk score utilizzati per decisioni cliniche rientrerebbe verosimilmente nella definizione di **Software as a Medical Device (SaMD)** secondo il **Regolamento UE 2017/745 (MDR)**.

## Classificazione attesa

Probabile **Classe IIa o IIb** secondo la Regola 11 dell'MDR (software che fornisce informazioni usate per decisioni diagnostiche/terapeutiche) — la classificazione esatta dipende dal fatto che il sistema informi decisioni "critiche" o meno; **va confermata con un consulente regolatorio**, non è auto-dichiarabile con certezza in questa fase di concept.

## Fasi tipiche del percorso (indicative, non uno standard rigido)

1. **Fase pre-clinica**: sviluppo e validazione tecnica del modello su dati storici/pubblici, senza uso clinico reale
2. **Studio di validazione retrospettiva**: validazione delle performance del modello su coorti storiche reali di uno o più centri, con protocollo approvato da comitato etico
3. **Studio pilota prospettico** (shadow mode): il sistema genera predizioni ma **non influenza ancora le decisioni cliniche** — si confrontano le predizioni con gli esiti reali
4. **Studio clinico prospettico interventistico**: il sistema viene effettivamente usato come supporto decisionale, con misurazione dell'impatto clinico (non solo accuratezza del modello, ma outcome paziente)
5. **Fascicolo tecnico MDR e Notified Body**: documentazione completa (risk management file secondo ISO 14971, clinical evaluation report, post-market surveillance plan)
6. **Marcatura CE e immissione sul mercato**
7. **Post-market surveillance continuo**: monitoraggio obbligatorio delle performance in produzione, incluso il model drift

## Standard tecnici di riferimento

- **ISO 14971**: gestione del rischio per dispositivi medici
- **IEC 62304**: ciclo di vita del software per dispositivi medici
- **ISO 13485**: sistema di gestione qualità per dispositivi medici
- **IEC 62366**: usabilità dei dispositivi medici (rilevante per l'interfaccia clinica)

## Note importanti

- Questo percorso richiede tipicamente **anni**, non mesi, e una competenza regolatoria dedicata (Regulatory Affairs), da coinvolgere fin dalla fase di concept.
- Nessuna versione deve essere usata per decisioni cliniche reali senza classificazione formale, sistema qualità, evidenze cliniche e autorizzazioni applicabili; la sola validazione prospettica non equivale alla marcatura CE.
- Il coinvolgimento di un comitato etico è necessario già a partire dallo studio di validazione retrospettiva su dati reali, non solo per lo studio interventistico.
