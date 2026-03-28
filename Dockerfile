# Use the Node.js 18 slim image for the build stages

FROM node:18-slim AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

FROM node:18-slim AS build
WORKDIR /app
COPY . .
RUN npm run build

FROM node:18-slim AS runner
WORKDIR /app
COPY --from=build /app/dist ./dist
CMD ["node", "dist/index.js"]
