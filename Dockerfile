# Creating multi-stage build for production
FROM node:18-alpine as build
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev > /dev/null 2>&1
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm config set network-timeout 600000 -g && npm install --only=production
ENV PATH /opt/node_modules/.bin:$PATH
WORKDIR /opt/app
COPY . .
RUN npm run build

# Creating final production image
FROM node:18-alpine
RUN apk add --no-cache vips-dev
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV PATH /opt/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["npm", "run", "start"]



#FROM strapi/base
#
## Let WatchTower know to ignore this container for checking
#LABEL com.centurylinklabs.watchtower.enable="false"
#
#RUN mkdir -p /usr/src/strapi-app
#WORKDIR /usr/src/strapi-app
#
#COPY ./package*.json ./
#
#RUN npm ci
#
#COPY . /usr/src/strapi-app/
#
#ENV NODE_ENV production
#
#RUN npm run build
#
#EXPOSE 1337
#
#CMD ["npm", "start"]
# Creating multi-stage build for production
