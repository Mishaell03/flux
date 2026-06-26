# Flux Frontend

Flutter client for Flux.

## Run

Install dependencies:

```bash
flutter pub get
```

Run on web:

```bash
flutter run -d chrome
```

Run on another device:

```bash
flutter devices
flutter run -d <device-id>
```

## Generate Code

Drift generated files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Localizations:

```bash
flutter gen-l10n
```

## Web Storage

The app uses Drift with SQLite WASM on web. These files must be present in `web/`:

```text
web/sqlite3.wasm
web/drift_worker.dart
web/drift_worker.js
```

If `drift_worker.js` or `sqlite3.wasm` is missing, the browser serves `index.html` instead and notes will not save or load.

Rebuild the worker after Drift upgrades:

```bash
HOME="$PWD" DART_SUPPRESS_ANALYTICS=1 dart compile js web/drift_worker.dart -o web/drift_worker.js
```

## Structure

```text
lib/
├── core/
│   ├── api/          HTTP helpers and API config
│   ├── components/   theme, markdown and secure helpers
│   ├── db/           Drift database and tables
│   ├── router/       GoRouter shell and routes
│   ├── sync/         sync models and services
│   └── widgets/      shared widgets
├── futures/
│   ├── graph/        MapGraph feature
│   ├── home/         dashboard
│   ├── loading/      first launch session check
│   ├── login/        auth flow
│   ├── notes/        notes and reminders
│   └── profile/      profile and sessions
└── l10n/             ARB localization files
```

## Frontend Rules

- User-facing text must come from `AppLocalizations`.
- Colors must come from `context.colors`.
- Text styles must come from `AppText`.
