#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.ЗаголовокВопроса;
	Элементы.ТекстВопроса.Заголовок = Параметры.ТекстВопроса;
	Элементы.Кнопка1.Видимость = Параметры.СписокКнопок.Количество() > 0;
	Элементы.Кнопка2.Видимость = Параметры.СписокКнопок.Количество() > 1;
	Элементы.Кнопка3.Видимость = Параметры.СписокКнопок.Количество() > 2;
	Если Параметры.СписокКнопок.Количество() > 0 Тогда
		Элементы.Кнопка1.Заголовок = Параметры.СписокКнопок[0].Представление;
	КонецЕсли;
	Если Параметры.СписокКнопок.Количество() > 1 Тогда
		Элементы.Кнопка2.Заголовок = Параметры.СписокКнопок[1].Представление;
	КонецЕсли;
	Если Параметры.СписокКнопок.Количество() > 2 Тогда
		Элементы.Кнопка3.Заголовок = Параметры.СписокКнопок[2].Представление;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
	
&НаКлиенте
Процедура Кнопка1(Команда)
	
	Результат = Параметры.СписокКнопок[0].Значение;
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка2(Команда)
	
	Результат = Параметры.СписокКнопок[1].Значение;
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка3(Команда)
	
	Результат = Параметры.СписокКнопок[2].Значение;
	Закрыть(Результат);
	
КонецПроцедуры
	
#КонецОбласти
