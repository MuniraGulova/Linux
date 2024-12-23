#!/bin/bash

#отсортировывоние содержимого введеного файла и перенаправление в другой файл

#Запрашиваем имя файла либо путь 
echo "Enter file name or path of the file: "

# присваеваем введеное значение переменной file_name
read file_name

#проверка на пустоту
if [ -z "$file_name" ]; then
	# ввывод, что ничего не введено
	echo "Error: file "$file_name" not specified! "
	#завершение ошибкой
	exit 1

# либо иначе проверка на существования файла
elif [ ! -f "$file_name" ]; then
	#выводим, что файл не сущестует 
	echo "$file_name does not exist"
	exit 1
#иначе
else 
 	# Запрашиваем название  файла для перенаправления
	echo "Name of new file: "
	# присваеваем введенное значение переменной
	read new_file
	# Переписать отсортированные значения либо добавить к существующим
	echo "Rewrite(1) or add(2):"
	# в переменной choose хранится выбор пользователя для способа перенаправления
	read choose
	#условие для вывода, подходящее для юзера
	if [ "$choose" = 1 ]; then
		# сортировка и перенаправление в другой файл(переписываем значения)
		sort $file_name >  $new_file
	else
		# иначе сортировка и перенаправление в другой файл(добавление к существующим)
		sort $file_name >> $new_file
	fi
	# вывод об окончании сортировки
	echo "Sorted! "
	#Запрашиваем пользователя хочет ли он просмотреть содержание нового файла 
	echo "show $new_file(1 - yes, 2 - no)?  " 
	# запись в переменную
	read bool
	#условие для показа файла
	if [ "$bool" = "1" ]; then
		cat $new_file
	else
		exit 0
	fi 
# закрытие блока
fi

# успешное окончание скрипта
exit 0


 

