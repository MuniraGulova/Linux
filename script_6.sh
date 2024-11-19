#!/bin/bash

#в переменной path_archive будет храниться  путь к папке, которую мы хотим архивировать
path_archive=$1

#path_save будет хранить место, куда мы  сохраним  архив
path_save=$2

#Получаем текущую дату с помощью команды date
#+%Y-%m-%d ->  выводим дату в формате год-месяц-день
date=$(date +%Y-%m-%d)

# название архива (состоит из текущей даты и расширения .tar.gz)
archive_name="$date.tar.gz"

# Архивирование с помощью команды tar в формате .tar.gz
# Используем флаги: 
# -c: создать новый архив
# -z: сжать архив с помощью gzip
# -f: указать имя архива
# Опция -C "$(dirname "$path_archive")" позволяет перейти в родительский каталог, где находится папка, которую мы архивируем
# $(basename "$path_archive") указывает на имя самой папки, которую нужно заархивировать
tar -czf "$path_save/$archive_name" -C "$(dirname "$path_archive")" "$(basename "$path_archive")"

echo "Source directory: $path_archive"
echo "Target directory: $path_save"
echo "Archive name: $path_save/$archive_name"

