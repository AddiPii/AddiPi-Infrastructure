# AddiPi-Infrastructure

Short description and local run instructions for the AddiPi microservices environment.

**Contents**
- `printer` — service that handles printers
- `files` — service for storing and serving files
- `queue` — job queue service
- `auth` — authentication and authorization service

**Requirements**
- `docker` and `docker-compose` (compatible with the included `docker-compose.yml`)

**Environment configuration**
- Create or copy a `.env` file in the `AddiPi-Infrastructure` directory with required variables (e.g. `PORT`, DB connection, keys).
- Note: values from `.env` are read as strings — convert to numbers in your code (e.g. `Number(process.env.PORT)`).

**Run locally**
Open PowerShell in the `AddiPi-Infrastructure` directory and run:

```powershell
docker-compose up --build
```

Or run in background:

```powershell
docker-compose up -d --build
docker-compose logs -f
```

To stop and remove containers:

```powershell
docker-compose down
```

**Healthchecks and readiness**
- A `healthcheck` is added for the `auth` service in `docker-compose.yml` that hits `GET /health` on port `3001`.
- `healthcheck` helps diagnostics (`healthy`/`unhealthy` visible in `docker ps`), but in Compose v3 `depends_on` does NOT wait for `healthy` — it only controls start order.

**`depends_on` — important note**
- `depends_on` makes Docker Compose start the referenced services before the dependent ones (and stop them in reverse order). It does not guarantee the service is ready to accept requests.
- If your application requires `auth` to be fully available before other services start, use one of the following approaches:
  - Add retry/backoff in the client code (recommended)
  - Use a startup wrapper like `wait-for-it.sh` / `wait-for` / `dockerize` in client images to wait for a specific endpoint/port before launching the app
  - Ensure `auth` exposes a simple health endpoint (`/health`) that returns 200 when ready

Example `wait-for` usage in a `Dockerfile` / entrypoint (schematic):

```dockerfile
# copy wait-for-it into the image and use it as an entrypoint wrapper
COPY wait-for-it.sh /usr/local/bin/wait-for-it
ENTRYPOINT ["/usr/local/bin/wait-for-it", "auth:3001", "--", "npm", "start"]
```

Or a simple `wait-for-auth.sh` wrapper example:

```bash
# wait-for-auth.sh
set -e
host="$1"
shift
until curl -sSf "http://$host/health" > /dev/null; do
  echo "Waiting for auth at $host..."
  sleep 2
done
exec "$@"
```

**Best practices**
- Do not rely only on `depends_on` for readiness guarantees.
- Add healthchecks, implement retry with backoff in clients, or use `wait-for` wrappers in entrypoints.
- Monitor logs with `docker-compose logs -f` for quick diagnostics.

**Debug / Troubleshooting**
- Check health status: `docker inspect --format='{{json .State.Health}}' <container>` or `docker ps`.
- If a service does not start, inspect logs: `docker-compose logs <service>`.

**Next steps (optional)**
- I can add an example `wait-for-auth.sh` to this repo and modify selected services' Dockerfiles to use it as a startup wrapper.
- I can also add small local integration checks (a script that validates health endpoints after startup).
- I added a Terraform baseline in [terraform/](terraform) that matches the live Azure resources I found with Azure CLI and includes import blocks.


# [PL] AddiPi-Infrastructure

Krótki opis i instrukcja uruchomienia środowiska lokalnego dla mikroserwisów AddiPi.

**Zawartość**
- `printer` — serwis obsługujący drukarki
- `files` — serwis do przechowywania i udostępniania plików
- `queue` — serwis kolejkowania zadań
- `auth` — serwis autoryzacji i uwierzytelniania

**Wymagania**
- `docker` oraz `docker-compose` (wersja kompatybilna z plikiem `docker-compose.yml`)
- dostęp do sieci lokalnej (porty zdefiniowane w `docker-compose.yml`)

**Konfiguracja środowiska**
- Skopiuj lub przygotuj plik `.env` w katalogu `AddiPi-Infrastructure` z wymaganymi zmiennymi (np. `PORT`, dane do DB, klucze itp.).
- Uwaga: wartości z `.env` są wczytywane jako stringi — konwertuj do liczb w kodzie (np. `Number(process.env.PORT)`).

**Uruchomienie lokalne**
Otwórz PowerShell i w katalogu `AddiPi-Infrastructure` uruchom:

```powershell
docker-compose up --build
```

Lub w tle:

```powershell
docker-compose up -d --build
docker-compose logs -f
```

Aby zatrzymać i usunąć kontenery:

```powershell
docker-compose down
```

**Healthchecks i readiness**
- W `docker-compose.yml` dodany jest `healthcheck` dla serwisu `auth`, który sprawdza endpoint `GET /health` na porcie `3001`.
- `healthcheck` pomaga w diagnostyce (statusy `healthy`/`unhealthy` widoczne w `docker ps`), ale w Compose v3 `depends_on` NIE czeka na `healthy` — jedynie ustawia kolejność uruchamiania.

**`depends_on` — ważna uwaga**
- `depends_on` powoduje, że Docker Compose uruchomi wskazane usługi przed zależnymi (i zatrzyma je w odwrotnej kolejności). Nie gwarantuje jednak, że usługa jest gotowa do obsługi żądań.
- Jeśli Twój kod wymaga, żeby `auth` był w pełni dostępny zanim inne serwisy się uruchomią, zastosuj jedną z poniższych metod:
	- Dodaj retry/backoff po stronie klienta (najlepsza praktyka)
	- Użyj skryptu startowego `wait-for-it.sh` / `wait-for` / `dockerize` w obrazach klienckich, aby czekać na konkretny endpoint/port przed startem aplikacji
	- Upewnij się, że serwis `auth` expose'uje prosty endpoint health (`/health`) zwracający 200 po starcie

Przykład użycia `wait-for` w `Dockerfile`/entrypoint (schemat):

```dockerfile
# pobierz wait-for-it.sh do obrazu i ustaw jako entrypoint wrapper
COPY wait-for-it.sh /usr/local/bin/wait-for-it
ENTRYPOINT ["/usr/local/bin/wait-for-it", "auth:3001", "--", "npm", "start"]
```

Lub prosty skrypt `wait-for-auth.sh` (przykład):

```bash
# wait-for-auth.sh
set -e
host="$1"
shift
until curl -sSf "http://$host/health" > /dev/null; do
	echo "Waiting for auth at $host..."
	sleep 2
done
exec "$@"
```

**Dobre praktyki**
- Nie polegaj tylko na `depends_on` dla gwarancji gotowości.
- Dodaj healthchecky, retry z backoff w klientach oraz (jeśli chcesz) `wait-for` w entrypointach obrazów.
- Monitoruj logi przy pomocy `docker-compose logs -f` dla szybkiej diagnostyki.

**Debug / Troubleshooting**
- Sprawdź statusy health: `docker inspect --format='{{json .State.Health}}' <container>` lub `docker ps`.
- Jeśli usługa nie startuje, sprawdź logi: `docker-compose logs <service>`.

**Następne kroki (opcjonalne)**
- Mogę dodać przykładowy `wait-for-auth.sh` do tego repo i zmodyfikować `Dockerfile` wybranych usług, żeby używały go jako wrappera startowego.
- Mogę też dodać krótkie testy integracyjne uruchamiane lokalnie (np. skrypt sprawdzający health endpointy po starcie).

**Aktualizacje (maj 2026)**
- Dodano skrypty wdrożeniowe: `deploy.sh` oraz `deploy-files-service.sh` (budowanie obrazów, push do ACR i uruchomienie ACI).
- Dodano skrypt `infra.sh` i `cosmos.sh` do szybkiego tworzenia zasobów Azure (Resource Group, ACR, Cosmos DB itp.).
- W repo pojawił się manifest Kubernetes: `addipi-pod.yml` (przykładowy pod z kilkoma serwisami i referencją do sekretów).
- Dodano wariant `docker-compose.ghcr.yml` do uruchamiania usług z obrazów hostowanych w GHCR (możliwość użycia zmiennych środowiskowych dla obrazów).
- Dodano katalog `terraform-oci/` z konfiguracją Terraform dla Oracle Cloud (dodatkowa opcja infrastruktury obok Azure).
- W `terraform/` znajduje się baseline dla zasobów Azure (Storage, Service Bus, Cosmos DB, IoT Hub) oraz pliki pomocnicze (`variables.tf`, `outputs.tf`, `terraform.tfvars.example`).
- Dodano plik przykładowy `.env.example` z listą wymaganych zmiennych środowiskowych.

Jeśli chcesz, mogę:
- rozszerzyć tę sekcję o dokładniejsze instrukcje użycia nowych skryptów,
- dodać przykładowe wartości do `.env.example`,
- albo zautomatyzować krótką sekcję "Szybkie wdrożenie" opartą o `deploy.sh`.
