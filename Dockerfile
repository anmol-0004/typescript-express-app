FROM node:17.9.0 as base
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

#lint
FROM base as linter
WORKDIR /app
RUN npm run lint

#build
FROM linter as builder 
WORKDIR /app
RUN npm run build

FROM node:17.9.0-alpine3.15
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /app/dist ./
EXPOSE 3000
ENTRYPOINT ["node","./app.js"]
