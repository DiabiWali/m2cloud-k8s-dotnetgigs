FROM node:22-alpine

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY src ./src

ENV NODE_ENV=production
ENV PORT=${{ values.port }}

EXPOSE ${{ values.port }}

USER node

CMD ["npm", "start"]
