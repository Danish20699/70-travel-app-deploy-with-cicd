# ==============================================================
# Dockerfile: Travel App Web Service (Apache + PHP 8.2 + PostgreSQL)
# ==============================================================

# 1. Base Image: Official PHP 8.2 with Apache Web Server
FROM php:8.2-apache

# 2. Install PostgreSQL C-libraries & compile PHP PDO PostgreSQL extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    && docker-php-ext-install pgsql pdo_pgsql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 3. Document the internal container listening port
EXPOSE 80

# 4. Default Environment Variables
ENV DB_HOST=travel-db \
    DB_PORT=5432 \
    POSTGRES_DB=travel_db \
    POSTGRES_USER=danish

# 5. Copy application source code into Apache document root
COPY ./src /var/www/html

# 6. Set proper ownership and permissions for Apache web server user
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

