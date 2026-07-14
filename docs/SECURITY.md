# Sicurezza e privacy

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [REGULATORY.md](REGULATORY.md).

Il prototipo dovrà usare esclusivamente dati sintetici, pubblici o correttamente anonimizzati e non sarà autorizzato a trattare dati sanitari reali. RBAC, cifratura, audit e scanning implementati nella demo saranno controlli dimostrativi: non costituiscono da soli conformità GDPR, sicurezza ospedaliera o idoneità clinica.

La sicurezza non è un layer aggiuntivo: è un requisito strutturale per l'eventuale prodotto, perché tratterebbe **dati sanitari** (categoria speciale ex Art. 9 GDPR) e produrrebbe **output capaci di influenzare decisioni cliniche**.

## Threat model

| Vettore di minaccia | Rischio | Mitigazione |
|---|---|---|
| Accesso non autorizzato ai dati paziente | Violazione privacy, sanzioni GDPR | RBAC granulare per ruolo (oncologo vede solo i suoi pazienti), MFA obbligatoria, audit log immutabile di ogni accesso |
| Esfiltrazione dati via API | Data breach su larga scala | Rate limiting, anomaly detection sui pattern di query, encryption in transit (TLS 1.3) e at rest (AES-256) |
| Re-identificazione da dati "anonimizzati" per ricerca | Violazione privacy anche su dati aggregati | K-anonymity/differential privacy sui dataset di export, revisione periodica del rischio di re-identificazione |
| Data poisoning nel federated learning | Un centro malevolo/compromesso corrompe il modello globale | Robust aggregation (es. trimmed mean invece di media semplice), anomaly detection sugli update dei pesi, validazione centralizzata prima del rilascio di ogni nuova versione |
| Model inversion / membership inference attack | Ricostruzione di dati paziente dai pesi del modello condiviso | Differential privacy sui gradienti, limiti su precisione dei pesi condivisi |
| Adversarial input sulle immagini (Echo/DICOM) | Predizione manipolata o errata su input malformato | Validazione input rigorosa, detection di input fuori distribuzione (OOD detection) prima dell'inferenza |
| Compromissione credenziali cliniche | Accesso fraudolento con identità legittima | MFA, session timeout aggressivo, alert su pattern di accesso anomali (orario, geolocalizzazione) |
| Vulnerabilità supply chain (librerie ML/dipendenze) | Backdoor o falle in componenti terzi | SBOM (Software Bill of Materials), scanning automatico dipendenze (Snyk/Dependabot), pinning versioni |

## Principi di sicurezza da applicare

I principi seguenti sono requisiti di progettazione. Il loro stato dovrà essere collegato a test e artefatti verificabili durante l'implementazione.

- **Privacy by design e by default** (Art. 25 GDPR): minimizzazione dati raccolti, pseudonimizzazione ove possibile, default sempre restrittivi
- **Zero trust interno**: anche i servizi interni si autenticano tra loro (mTLS), nessun "trust implicito" perché si è dentro il perimetro di rete
- **Segregazione ambienti**: dati di produzione mai in ambienti di sviluppo/test; per il testing si usano dati sintetici o completamente anonimizzati
- **Diritto all'oblio gestibile**: architettura dati progettata per permettere la cancellazione effettiva di un paziente (non solo soft-delete), tenendo conto dell'obbligo di conservazione della documentazione sanitaria — tensione normativa da gestire con consulenza legale specifica
- **Incident response plan**: procedura da documentare per la gestione e, ove applicabile, la notifica di un breach entro i termini GDPR; runbook per isolamento rapido di un componente compromesso

## Sicurezza organizzativa (non solo tecnica)

- Formazione periodica obbligatoria del personale clinico e IT su phishing e social engineering (spesso il vettore di attacco reale in ambito sanitario, più della vulnerabilità tecnica)
- Accordi di data processing (DPA) formalizzati con ogni centro partecipante al federated learning
- Penetration testing periodico da terze parti indipendenti, non solo scanning automatico interno
