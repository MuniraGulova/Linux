#!/bin/bash

#Запрашиваем имя либо путь к файлу
echo "Input file name or path to the file: "
# присваеваем переменной
read file_name

# проверяем на пустоту
if [ -z "$file_name" ]; then
	# вывод ошибки что файл не указан 
	echo "Error: file not specified"
# проверка что файл это файл :) 
elif [ -f "$file_name" ]; then 
	#выводим, что это файл
	echo "$file_name is file"
# проверка что это каталог
elif  [ -d "$file_name" ]; then\
	#вывод что это каталог
	echo "This file is directory"
fi
# классная функция для вывода полной информации о файле 
stat "$file_name"

#завершение скрипта
exit 0
