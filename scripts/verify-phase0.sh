#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

docker compose config
docker compose up -d postgres

echo "Waiting for PostgreSQL..."
for i in $(seq 1 30); do
  if docker compose exec -T postgres pg_isready -U "${POSTGRES_USER:-coris}" -d "${POSTGRES_DB:-coris}" >/dev/null 2>&1; then
    echo "PostgreSQL is ready on port ${POSTGRES_PORT:-5432}"
    docker compose ps
    exit 0
  fi
  sleep 2
done

echo "PostgreSQL failed to become ready"
docker compose logs postgres
exit 1
