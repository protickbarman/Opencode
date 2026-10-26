# OpenCode on Docker + Render — FULL ACCESS

Runs OpenCode with password `12345` inside Ubuntu. Supports:
- ✅ Creating new sessions via the web UI or API
- ✅ Reading/writing files in the workspace
- ✅ Listing sessions (`GET /api/session`)
- ✅ Sending prompts (`POST /api/session/{id}/prompt`)
- ✅ Serving to the internet via Render

## Folder layout

```
opencode-render/
├── Dockerfile          # Ubuntu 24.04 + Node 24 + OpenCode CLI
├── entrypoint.sh       # Sets password 12345, starts opencode serve
├── render.yaml         # Render blueprint (optional)
├── .dockerignore
└── README.md
```

## Build & run locally

```bash
cd opencode-render

# Build the image
docker build -t opencode-render .

# Run with a local workspace folder (files persist on your machine)
mkdir -p ./workspace
docker run -p 3000:3000 \
  -e OPENCODE_PASSWORD=12345 \
  -v "$(pwd)/workspace:/workspace" \
  opencode-render
```

Open: `http://localhost:3000`

Login:
- **Username:** `opencode`
- **Password:** `12345`

## Deploy on Render

1. Push this folder to GitHub.
2. Render → **New Web Service** → connect your repo → **Docker** environment.
3. Settings:
   - **Dockerfile path:** `./Dockerfile`
   - **Env vars:** `OPENCODE_PASSWORD=12345`, `PORT=3000`, `WORKSPACE=/workspace`
   - **Health check path:** `/`
4. (Optional) Add a **Render Disk** mounted at `/workspace` to persist sessions/files across deploys.
5. Deploy. Render gives you a public URL like `https://opencode-xyz.onrender.com`.

## What you can do once deployed

Open your Render URL in a browser, log in with `opencode` / `12345`:

| Action | How |
|--------|-----|
| Create a session | Click "New session" in the UI, or `POST /api/session` |
| List sessions | `GET /api/session` |
| Read files | Browse workspace files in the UI |
| Write files | Create/edit files in the UI terminal or file tree |
| Send prompts | `POST /api/session/{id}/prompt` with your message |

### Example API calls

```bash
# List sessions (auth required)
curl -u "opencode:12345" https://your-app.onrender.com/api/session

# Create a new session
curl -u "opencode:12345" -X POST https://your-app.onrender.com/api/session \
  -H "Content-Type: application/json" \
  -d '{"title":"My new session"}'

# Send a prompt to a session
curl -u "opencode:12345" -X POST https://your-app.onrender.com/api/session/SES_ID/prompt \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello, create a file called hello.txt"}'
```

## Notes

- **Base image:** `ubuntu:24.04`. For an even smaller image, change `FROM ubuntu:24.04` to `FROM debian:bookworm-slim` and install Node manually.
- **File persistence:** By default, files/sessions live inside the container and are lost when it restarts. Add a Render Disk or Docker volume at `/workspace` to persist them.
- **Both Cloudflare tunnel and Replit preview are unnecessary** — Render gives you a direct public URL with HTTPS.
