FROM node:20-slim
WORKDIR /app
# Copy dependency files first
COPY package*.json ./
# Install only production dependencies
RUN npm ci
# Security: Don't run as root
RUN addgroup --system --gid 1001 expressjs && adduser --system --uid 1001 expressjs
USER expressjs
WORKDIR /app

# Copy source code
COPY . .

EXPOSE 3000
CMD ["node", "index.js"]
