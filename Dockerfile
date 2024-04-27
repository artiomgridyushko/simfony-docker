# Используем официальный образ PHP с Apache
FROM php:8.2-apache

# Устанавливаем необходимые расширения PHP
RUN docker-php-ext-install pdo_mysql

# Настройка Apache
RUN a2enmod rewrite

# Устанавливаем Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Копируем файлы проекта в контейнер
COPY . .

# Устанавливаем зависимости через Composer
RUN composer install --no-scripts --no-autoloader

# Копируем файлы конфигурации Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Настраиваем переменные среды
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Expose port
EXPOSE 80

# Запускаем Apache при старте контейнера
CMD ["apache2-foreground"]
