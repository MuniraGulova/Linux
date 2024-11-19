#!/bin/bash

#Запрашиваем число
echo "Enter number: "
#сохраняем ввод в переменную 
read number
#Условие проверки

#проверяем, введенное число положительно
if [ $number -gt  0 ]; then
	#вывод, что число положителен
	echo "$number is positive"
#число отрицателен
elif [ $number -lt  0 ]; then
	#вывод, что число отрицателен
	echo "$number is negative"
#иначе ноль
else 
	echo "zero"
#закрываем блок
fi
#успешное окончание скрипта
exit 0
