FROM node:latest

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

ENV PORT $DEFAULT_PORT

ARG DEFAULT_PORT=80

EXPOSE $PORT

CMD ["npm", "start"]