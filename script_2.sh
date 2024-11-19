#!/bin/bash

#Автоматизация изменения владельца, группы  и прав доступа для файлов и каталогов
# Для всех файлов и каталогов указанной директории 
# Запрашиваем у юзера путь к каталогу
echo "Enter the path to the directory "

#Читаем введенный путь и присваеваем переменной 'catalog_name'
read catalog_name

# проверка на пустоту
if [ -z "$catalog_name" ]; then
	#вывод сообщение об ошибке
	echo "Error: directory path not specified!"
	exit 1
fi

# проверяем, существует ли указанный каталог. Если не существует,
# выводим сообщение об ошибке и завершаем выполнение скрипта с кодом 1(ошибка)
if [ ! -d "$catalog_name" ]; then
	echo "Error: directory $catalog_name does not exist "
	exit 1
fi
# изменение проиходит от имени суперпользователя
# меняем владельцa на user1, а группу на labgroup рекурсивно для всех объектов
sudo chown -R user1:labgroup $catalog_name
#выводим сообщение об изменении
echo "Change user and group"

#меняем права доступа для рекурсивно: владелец - все права, для группы - чтения и запись,
# а для остальных - только чтение
sudo chmod -R 764 $catalog_name
# вывод сообщения об изменении прав
echo "Permossions and owners have been successfully updated! :) "

# успешное выполнение
exit 0
