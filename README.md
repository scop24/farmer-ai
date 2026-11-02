# farmer-ai (KisanSathi)

Farmer-focused demo app: a farmer photographs a crop leaf, the app checks it
and shows simple advice in plain language. Tomato only, for the Meta Global
AI Developer Hackathon 2026 ("Build for Your World", Indie track).

Live demo: https://app-kisansathi-dev.azurewebsites.net

## Honest status — read this first

This is a working front-end demo, not a finished diagnosis product:

- Camera and microphone are real (photo preview on Scan; browser speech
  listening and spoken replies on Voice).
- Prices and diagnosis results are DEMO data, labelled "Demo data" in the app.
  Diagnosis has no trained model behind it yet; the backend diagnosis slice
  and fine-tuned model are later phases.
- Below 60% confidence the app shows no treatment — only an uncertain
  result, a retake prompt, and the expert note: "This is AI guidance for
  demo purposes. Please confirm with a local agriculture expert before
  using any medicine."
- No treatment advice comes from the app beyond the verified list; nothing
  here is a dose, spray interval, or pre-harvest interval.

## What lives here

- `app/` — Flutter app (package `kisansathi`, Flutter 3.47.8, Riverpod):
  6 screens — Welcome/Language (7 languages, Hindi pre-selected), Home
  dashboard (forecast chart, crop chips), Crop Prices (search, sparklines),
  Scan (real camera photo preview), Diagnosis (both confidence variants),
  Voice (Flyer Chat UI, chat history saved on-device, real mic/TTS).
- `backend/` — FastAPI backend (planned; not in this push until its go-ahead).
- `infra/` — Azure setup files (foundation live: App Service, Storage,
  Key Vault, PostgreSQL — see below; not in this push).

## Running it

- Flutter 3.47.8, Dart SDK ^3.13.7. From `app/`: `flutter pub get`,
  `flutter analyze`, `flutter test` (12/12 at last verification, 2026-11-01),
  `flutter run` / `flutter build web --release`.

## Cloud foundation (already live, not code in this repo)

- Azure App Service `app-kisansathi-dev` serving the web demo (link above).
- Storage, Key Vault, Log Analytics / App Insights, and PostgreSQL
  (`psql-kisansathi-2`, East Asia) in resource group `rg-farmer-ai-dev`.

## Rules

- Never commit secrets, keys, passwords or tokens into this repo.
  Secrets live in Azure Key Vault or GitHub Secrets, never in code.
- Reuse means permissively licensed packages (MIT/Apache), not whole
  copied apps — camera, mic, charts and chat UI are packages, wired to
  KisanSathi's own screens and safety rules.
