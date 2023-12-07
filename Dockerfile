FROM node:18.16.1-alpine AS node-build
WORKDIR /usr/src/app
COPY package.json ./
COPY yarn.lock ./
COPY src ./src
COPY public ./public
RUN yarn install --frozen-lockfile --check-files --network-timeout 600000
RUN yarn build --noninteractive
RUN yarn install --frozen-lockfile --check-files --production --modules-folder node_modules_prod --network-timeout 600000

FROM node:18.16.1-alpine
WORKDIR /usr/src/app
ENV NODE_ENV production
RUN mkdir -p /node_modules
COPY --from=node-build /usr/src/app/build ./build
COPY --from=node-build /usr/src/app/node_modules_prod ./node_modules
COPY link-logo.png /usr/src/app/build/public/static/media/
COPY favicon-logo.png /usr/src/app/build/public/static/media/
EXPOSE 3000
CMD [ "node", "build/server.js" ]

