# Flux Backend

Backend на FastAPI для Flux.

## Запуск через Docker

Создайте env файл:

```bash
cp .env.example .env
```

Запуск PostgreSQL, миграций и API:

```bash
docker compose up --build
```

Документация API:

```text
http://127.0.0.1:8000/docs
```

Опционально pgAdmin:

```bash
docker compose --profile admin up pgadmin
```

## Локальный запуск сервиса

Запускается только PostgreSQL и миграции:

```bash
docker compose up postgres migrate
```

Запуск API:

```bash
cd service
cp .env.example .env
pip install -r requirements.txt
python main.py
```

## Миграции

Миграции:

```text
infra/postgres/flux_db/migrations/
```

Seeds:

```text
infra/postgres/flux_db/seeds/
```

Docker Compose запускает Flyway перед стартом API. Ручной запуск миграций:

```bash
make migrate
make seed
```

## Структура

```text
back-flux/
├── docker-compose.yaml
├── Makefile
├── infra/
│   └── postgres/
│       ├── init/                 инициализация базы данных
│       └── flux_db/
│           ├── migrations/       миграции схемы
│           └── seeds/            повторяемые seed-данные
└── service/
    ├── main.py                   точка входа FastAPI
    ├── requirements.txt
    └── app/
        ├── api/v1/routes/        API эндпоинты
        ├── api/v1/schemas/       Pydantic схемы
        ├── core/                 конфиг, авторизация, ошибки
        └── db/                   модели SQLAlchemy / сессия
```

## Окружение

Основные переменные описаны в `.env.example`:

* `POSTGRES_USER`, `POSTGRES_PASSWORD` — учетные данные базы данных для Docker.
* `SECRET` — JWT секрет.
* `YANDEX_CLIENT_ID`, `YANDEX_CLIENT_SECRET` — OAuth учетные данные.
* `YANDEX_REDIRECT_*` — OAuth redirect адреса.

Для локальной разработки настройки по умолчанию в `service/app/core/config.py` указывают на `127.0.0.1:5432`.
