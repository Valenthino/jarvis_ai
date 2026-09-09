# Coolify deployment

This repository can run as a normal Coolify Nixpacks application. Coolify handles
TLS and WebSocket forwarding, so the Jarvis process listens on plain HTTP port
`8765` inside the container.

## Coolify application settings

* Repository: `Valenthino/jarvis_ai`
* Branch: `main`
* Build pack: `Nixpacks`
* Exposed port: `8765`
* Health check path: `/hud/`
* Health check port: `8765`
* Health check scheme: `http`
* Start command: supplied by `nixpacks.toml`
* Domain: use an HTTPS domain such as `https://jarvis.vavqo.com`

Coolify's proxy supports the `/ws` WebSocket endpoint. Do not add a second TLS
listener or generate self signed certificates for the Coolify deployment.

## Required runtime variables

Set these in Coolify Environment Variables. Never commit their values.

| Variable | Purpose |
| --- | --- |
| `JARVIS_HERMES_BASE_URL` | HTTPS base URL of the Hermes API server, for example `https://agent.example.com` |
| `API_SERVER_KEY` | Bearer key accepted by that Hermes API server |
| `JARVIS_HUD_TOKEN` | Token requested by the HUD and used for API and WebSocket auth |
| `ELEVENLABS_API_KEY` | ElevenLabs TTS API key |
| `ELEVENLABS_VOICE_ID` | ElevenLabs voice ID |
| `JARVIS_VOICE_NAME` | Display name for the selected voice |
| `JARVIS_PUBLIC_HOST` | Hostname only, such as `jarvis.vavqo.com`; no scheme or path |

`JARVIS_HERMES_BASE_URL` and `API_SERVER_KEY` must point to the same Hermes
instance. The Jarvis server uses the Hermes Sessions API, not the WebUI login.

## First verification

After deployment, Coolify should report the application healthy at `/health`.
Open the HTTPS domain and enter `JARVIS_HUD_TOKEN` in the access prompt. Test
text chat before microphone access. Then click the voice ring.

The first startup downloads the local `small.en` Whisper model and can take a
few minutes. Give the application at least 512 MB RAM, preferably 1 GB or more.

## Known limits

The upstream project was originally tested on macOS. Linux and Coolify are
supported by this runtime layer, but the optional macOS dashboard proxy and
local machine panel are intentionally disabled. The existing Hermes dashboard
can remain on its own Coolify domain.
