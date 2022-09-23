FROM node:lts-alpine as build-stage

RUN mkdir -p /app

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

ARG VITE_APIM_SUBSCRIPTION_KEY="FOOBAR"
ARG VITE_APIM_LOGIC_URL="FOOBAR"

ENV VITE_APIM_SUBSCRIPTION_KEY=${VITE_APIM_SUBSCRIPTION_KEY}
ENV VITE_APIM_LOGIC_URL=${VITE_APIM_LOGIC_URL}

RUN npm run build

#-------------------------------------------

FROM nginx:stable-alpine as production-stage

EXPOSE 80

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build-stage /app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]