///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ДействиеВыбрано;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачальноеЗначение = Параметры.НачальноеЗначение;
	
	Если Не ЗначениеЗаполнено(НачальноеЗначение) Тогда
		НачальноеЗначение = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Элементы.Календарь.НачалоПериодаОтображения = Параметры.НачалоПериодаОтображения;
	Элементы.Календарь.КонецПериодаОтображения = Параметры.КонецПериодаОтображения;
	
	Календарь = НачальноеЗначение;

	Заголовок = Параметры.Заголовок;
	Элементы.ПоясняющийТекст.Заголовок = Параметры.ПоясняющийТекст;
	Элементы.ПоясняющийТекст.Видимость = ЗначениеЗаполнено(Параметры.ПоясняющийТекст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Если ДействиеВыбрано <> Истина Тогда
		ОповеститьОВыборе(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КалендарьВыбор(Элемент, ВыбраннаяДата)
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(ВыбраннаяДата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
	
	Если ВыделенныеДаты.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Дата не выбрана.'"));
		Возврат;
	КонецЕсли;
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(ВыделенныеДаты[0]);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

