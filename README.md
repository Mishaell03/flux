# Flux

Flux is a cross-platform notes, reminders and knowledge graph app.

The repository contains two main parts:

- `front/` - Flutter client for mobile, desktop and web.
- `back-flux/` - FastAPI backend, PostgreSQL schema and Docker infrastructure.

## Quick Start

### Backend

```bash
cd back-flux
cp .env.example .env
docker compose up --build
```

API docs:

```text
http://127.0.0.1:8000/docs
```

### Frontend

```bash
cd front
flutter pub get
flutter run -d chrome
```

For desktop or mobile:

```bash
flutter devices
flutter run -d <device-id>
```

## Structure

```text
.
├── front/      Flutter client
└── back-flux/  FastAPI backend and infrastructure
```

More details:

- [Frontend documentation](front/README.md)
- [Backend documentation](back-flux/README.md)

## Notes

- The frontend API URL is configured in `front/lib/core/api/api_config.dart`.
- The web client uses Drift + SQLite WASM. Required files are `front/web/sqlite3.wasm` and `front/web/drift_worker.js`.
- The backend Docker Compose stack runs PostgreSQL, Flyway migrations and the API container.
