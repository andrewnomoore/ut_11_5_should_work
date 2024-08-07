#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Наименование = Параметры.Наименование;
	Описание = Параметры.Описание;
	
	Если ТолькоПросмотр Тогда
		Элементы.Наименование.ТолькоПросмотр = ТолькоПросмотр;
		Элементы.Описание.ТолькоПросмотр = ТолькоПросмотр;
		
		Элементы.Готово.Видимость = Ложь;
		Элементы.Отмена.Заголовок = НСтр("ru = 'Закрыть'");
		Элементы.Отмена.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоОписание") Тогда
		Элементы.Наименование.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Особое описание задачи'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("Описание", Описание);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти
