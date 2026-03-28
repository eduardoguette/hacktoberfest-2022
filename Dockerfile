# ===== DEPENDENCIES =====
FROM node:18-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci --only=production --ignore-scripts && \
    npm cache clean --force

# ===== BUILDER =====
FROM node:18-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run build

# ===== RUNNER =====
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3001

# Crear usuario no-root para seguridad
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 astro

# Solo copiar lo necesario para ejecutar en producción
COPY --from=builder --chown=astro:nodejs /app/dist ./dist
COPY --from=builder --chown=astro:nodejs /app/package.json ./
COPY --from=deps --chown=astro:nodejs /app/node_modules ./node_modules

USER astro

EXPOSE 3001

# Usar el comando preview de Astro
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "3001"]