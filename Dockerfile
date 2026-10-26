# =============================================================================
# OpenCode Docker image — FULL access (create sessions, read/write files)
# Base: Ubuntu 24.04 (small Linux)
# Deploy target: Render (Docker web service)
# Password: 12345  (username: opencode)
# =============================================================================
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV OPENCODE_PASSWORD=12345
ENV PORT=3000
ENV HOSTNAME=0.0.0.0
# Workspace directory where OpenCode can read/write files and create sessions
ENV WORKSPACE=/workspace

# Install curl, ca-certificates, gnupg
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 24
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode CLI
RUN npm install -g @opencode/cli

# Create OpenCode config dir and set password to 12345
RUN mkdir -p /root/.config/opencode \
    && echo '{"password": "12345"}' > /root/.config/opencode/service.json

# Create workspace directory (files live here; sessions are created here)
RUN mkdir -p ${WORKSPACE}
WORKDIR ${WORKSPACE}

# Expose the port Render routes traffic to
EXPOSE 3000

COPY entrypoint.sh /usr/local/bin/opencode-entrypoint.sh
RUN chmod +x /usr/local/bin/opencode-entrypoint.sh

# Foreground process for Render
ENTRYPOINT ["/usr/local/bin/opencode-entrypoint.sh"]
