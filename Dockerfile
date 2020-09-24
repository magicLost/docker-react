# Build phase
FROM node:alpine as builder

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

# Run phase
FROM nginx

COPY --from=builder /app/build /usr/share/nginx/html

COPY default.conf.template /etc/nginx/conf.d/default.conf.template

CMD /bin/bash -c “envsubst ‘\$PORT’ < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf” && nginx -g ‘daemon off;’