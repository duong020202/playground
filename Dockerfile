FROM node:17-alpine as builder
WORKDIR /app
COPY ./my-app/package.json .
COPY ./my-app/package-lock.json .
RUN npm install
COPY ./my-app .
RUN yarn build

FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/build .
ENTRYPOINT ["nginx", "-g", "daemon off;"]