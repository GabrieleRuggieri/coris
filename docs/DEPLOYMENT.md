# Deployment: demo gratuita e percorso verso produzione

> Parte di [CORIS](../README.md). Stato corrente in [STATUS.md](STATUS.md). Vedi anche [ARCHITECTURE.md](ARCHITECTURE.md).

## 1. Principio guida

La demo dovrà girare **senza servizi cloud a pagamento**, senza carta di credito e senza account obbligatori. La scelta prevista è **Docker Compose in locale**: ogni componente dello stack ha un equivalente open source self-hostabile. Restano esclusi dal “costo zero” hardware, energia e tempo operativo.

Questo avrà anche un vantaggio architetturale, non solo economico: girando in locale, nessun dato della demo dovrà lasciare la macchina, coerentemente con il principio di data locality descritto in [SECURITY.md](SECURITY.md).

## 2. Mappatura target produzione → prototipo

| Componente | Produzione (futuro) | Prototipo locale | Note |
|---|---|---|---|
| Orchestrazione | Kubernetes (cloud/on-prem) | Docker Compose | Migrazione facilitata scrivendo da subito immagini container standard, senza dipendenze da servizi gestiti proprietari |
| Object storage | Amazon S3 / equivalente | **MinIO** (self-hosted, API S3-compatibile) | Un client basato sullo standard S3 riduce, ma non elimina, le differenze di configurazione e comportamento |
| Database clinico | PostgreSQL gestito (RDS/Cloud SQL) | **PostgreSQL** via immagine Docker ufficiale | Identico motore, solo hosting diverso |
| Time-series (ECG/vitali) | TimescaleDB gestito | **TimescaleDB** via immagine Docker | Estensione di PostgreSQL, stesso approccio |
| Data warehouse ricerca | ClickHouse Cloud | **ClickHouse** via immagine Docker | Versione open source completa |
| PACS/DICOM | Orthanc su infrastruttura ospedaliera | **Orthanc** via immagine Docker | Già open source in entrambi i casi |
| Identity/OAuth2/OIDC | Provider enterprise (Okta/Auth0) | **Keycloak** (self-hosted, open source) | Evita fin da subito il lock-in su provider a pagamento |
| ML experiment tracking | MLflow gestito | **MLflow** via immagine Docker | Stesso strumento, hosting diverso |
| Federated learning | Flower su cluster multi-ospedale | **Flower** in locale con client simulati (container multipli sulla stessa macchina) | Per la demo si simulano 2-3 "ospedali" come container separati sullo stesso host |
| Osservabilità | Prometheus + Grafana gestiti | **Prometheus + Grafana** via immagine Docker | Stesso stack di base, con requisiti operativi diversi |
| CI/CD | ArgoCD su cluster reale | GitHub Actions (piano free per repo pubblici/limite generoso su privati) | Sufficiente per una demo, non richiede cluster |

I componenti proposti sono disponibili in edizioni open source; licenze e versioni effettive dovranno essere verificate e registrate con un SBOM durante l'implementazione.

## 3. Struttura Docker Compose (esempio concettuale)

```yaml
# docker-compose.yml (estratto concettuale, da completare in fase di implementazione)
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: coris
    volumes: [pgdata:/var/lib/postgresql/data]

  timescaledb:
    image: timescale/timescaledb:${TIMESCALEDB_TAG:?pin-required}
    volumes: [tsdata:/var/lib/postgresql/data]

  clickhouse:
    image: clickhouse/clickhouse-server:${CLICKHOUSE_TAG:?pin-required}
    volumes: [chdata:/var/lib/clickhouse]

  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    volumes: [miniodata:/data]

  orthanc:
    image: orthancteam/orthanc
    volumes: [orthancdata:/var/lib/orthanc/db]

  keycloak:
    image: quay.io/keycloak/keycloak:${KEYCLOAK_TAG:?pin-required}
    command: start-dev

  mlflow:
    image: ghcr.io/mlflow/mlflow
    command: mlflow server --host 0.0.0.0

  api-gateway:
    build: ./services/api-gateway   # NestJS/TypeScript
    depends_on: [postgres, keycloak]

  ml-service:
    build: ./services/ml-service    # FastAPI/Python
    depends_on: [mlflow]

  frontend:
    build: ./frontend               # React/TypeScript
    depends_on: [api-gateway]

  prometheus:
    image: prom/prometheus
  grafana:
    image: grafana/grafana

volumes:
  pgdata:
  tsdata:
  chdata:
  miniodata:
  orthancdata:
```

**Criterio di completamento pianificato:** quando gli artefatti saranno implementati, `docker compose up` dovrà avviare gateway, servizi ML, frontend e i componenti demo selezionati con un solo comando. L'esempio sopra non è direttamente eseguibile.

Nel primo vertical slice è sufficiente avviare frontend, gateway, servizio ML e PostgreSQL; gli altri servizi possono essere introdotti tramite profili Compose separati, così il prototipo completo non obbliga ogni sviluppatore ad avviare l'intero stack.

## 4. Variante opzionale: demo condivisibile via link (cloud free-tier)

Se in futuro serve mostrare la demo a qualcuno senza fargli installare Docker, un'alternativa è un sottoinsieme minimale su servizi cloud gratuiti — con i limiti espliciti di ciascuno:

| Servizio | Piano free tipico | Limite da considerare |
|---|---|---|
| Frontend (React) | Vercel / Netlify free | Generalmente generoso, adatto a demo |
| API gateway (NestJS) | Render free web service | Cold-start dopo inattività (~15 min) |
| Postgres | Neon / Supabase free | Storage limitato (~0.5-1GB), sufficiente per dati demo sintetici |
| Object storage | Cloudflare R2 free tier | Limite di operazioni/mese generoso per una demo |

Questa via è **secondaria**: utile solo se serve un link pubblico, ma introduce dipendenze da account esterni e limiti che la versione locale non ha. Per sviluppo e validazione tecnica, Docker Compose in locale è la scelta primaria pianificata.

## 5. Percorso di migrazione verso produzione

La scelta di usare fin da subito immagini Docker standard (non servizi proprietari) rende la migrazione un cambio di *infrastruttura*, non di *codice applicativo*:

1. **MinIO → S3 reale**: endpoint e credenziali cambiano; eventuali differenze di compatibilità vanno coperte da test d'integrazione
2. **Docker Compose → Kubernetes**: i Dockerfile restano gli stessi, si aggiungono manifest K8s (Deployment, Service, Ingress) o un Helm chart
3. **Postgres/TimescaleDB self-hosted → gestiti (RDS/Cloud SQL/Timescale Cloud)**: dump/restore standard, nessuna modifica allo schema
4. **Keycloak self-hosted → provider enterprise (se richiesto da policy ospedaliera)**: OIDC limita il lock-in, ma claim, ruoli, logout e policy richiedono test di compatibilità
5. **GitHub Actions → ArgoCD/GitOps su cluster reale**: si aggiunge un livello di deploy continuo, la pipeline di test/build resta la stessa

> Principio chiave di design: **non legarsi mai ad API proprietarie di un singolo cloud provider** fin dalla fase demo. Usare sempre standard aperti (S3 API, OIDC, SQL standard) anche quando il backend è self-hosted gratuito: è ciò che rende la migrazione a produzione un'operazione infrastrutturale a basso rischio invece di una riscrittura.
