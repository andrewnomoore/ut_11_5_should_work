
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ПроверкаПройдена Тогда
		Элементы.РезультатПроверкиПодключения.Картинка = БиблиотекаКартинок.Успешно32;
		Элементы.РезультатПроверкиПодключения.Подсказка = "Проверка подключения пройдена успешно";
		
		Элементы.ДоступностьAPI.Картинка = БиблиотекаКартинок.Успешно32;
		Элементы.ДоступностьAPI.Подсказка = "Прямая выгрузка данных - доступна";
	Иначе
		Элементы.РезультатПроверкиПодключения.Картинка = БиблиотекаКартинок.Ошибка32;
		Элементы.РезультатПроверкиПодключения.Подсказка = "При проверке подключения возникла ошибка";
				
		Элементы.ДоступностьAPI.Картинка = БиблиотекаКартинок.Ошибка32;
		Элементы.ДоступностьAPI.Подсказка = "Прямая выгрузка данных - недоступна";
	КонецЕсли;
	
	Элементы.ДоступностьExcel.Картинка = БиблиотекаКартинок.Успешно32;
	Элементы.ДоступностьExcel.Подсказка = "Выгрузка в Excel - доступна";
	
КонецПроцедуры

#КонецОбласти