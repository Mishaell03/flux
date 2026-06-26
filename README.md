# Flux

Flux — это кроссплатформенное приложение для заметок, напоминаний и построения графа.

Репозиторий содержит две основные части:

* `front/` — Flutter-клиент для мобильных устройств, десктопа и веба.
* `back-flux/` — backend на FastAPI, схема PostgreSQL и Docker-инфраструктура.

## Быстрый старт

### Backend

```bash
cd back-flux
cp .env.example .env
docker compose up --build
```

Документация API:

```text
http://127.0.0.1:8000/docs
```

### Frontend

```bash
cd front
flutter pub get
flutter run -d chrome
```

Для десктопа или мобильных устройств:

```bash
flutter devices
flutter run -d <device-id>
```

## Структура проекта

```text
.
├── front/      Flutter-клиент
└── back-flux/  FastAPI backend и инфраструктура
```

Подробнее:

* [Документация frontend](front/README.md)
* [Документация backend](back-flux/README.md)

## Примечания

* URL API во frontend настраивается в `front/lib/core/api/api_config.dart`.
* Веб-клиент использует Drift + SQLite WASM. Требуются файлы `front/web/sqlite3.wasm` и `front/web/drift_worker.js`.
* Docker Compose backend поднимает PostgreSQL, миграции Flyway и контейнер API.
