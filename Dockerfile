FROM node:20-alpine AS frontend-build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build
# Debug: Check if build was successful
RUN ls -la build/ && echo "Build directory contents:" && find build -type f | head -10

FROM node:20-alpine AS backend-deps
WORKDIR /app
COPY backend/package*.json ./
RUN npm ci --omit=dev

FROM node:20-alpine
RUN apk add --no-cache nginx

WORKDIR /app
COPY --from=frontend-build /app/build /usr/share/nginx/html
# Debug: Check if files were copied correctly
RUN ls -la /usr/share/nginx/html/ && echo "Nginx html directory contents:" && find /usr/share/nginx/html -type f | head -10
COPY --from=backend-deps /app/node_modules /app/backend/node_modules
COPY backend/package.json /app/backend/
COPY backend/ /app/backend/

ARG MONGODB_URI
ARG JWT_SECRET
ENV NODE_ENV=production
ENV MONGODB_URI=$MONGODB_URI
ENV JWT_SECRET=$JWT_SECRET

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/http.d/default.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh && \
    mkdir -p /var/cache/nginx /var/log/nginx && \
    rm -rf /etc/nginx/http.d/*.conf /etc/nginx/conf.d/*.conf && \
    chmod -R 777 /var/cache/nginx /var/log/nginx /usr/share/nginx/html

EXPOSE 80 5000

CMD ["/start.sh"]
