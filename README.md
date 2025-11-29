# AddiPi-Infrastructure

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

---

Jeśli chcesz, żebym dodał `wait-for`/`wait-for-it` do konkretnych usług (`printer`, `files`, `queue`) — wybierz które i czy modyfikować też Dockerfile'y w odpowiednich repo (`../AddiPi-Printer-Service`, `../AddiPi-Files-Service`, `../AddiPi-Queue-Service`).
