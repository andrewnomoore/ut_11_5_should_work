///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСписок(Параметры.Доверенности);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеСтроки.Ошибка <> Неопределено Тогда
		КонтекстОшибки = МашиночитаемыеДоверенностиФНССлужебныйКлиент.КонтекстДляОбработкиОшибкиРР();
		КонтекстОшибки.ЗаголовокПредупреждения = ДанныеСтроки.Ошибка.ЗаголовокОшибки;
		КонтекстОшибки.Форма = ЭтотОбъект;
		МашиночитаемыеДоверенностиФНССлужебныйКлиент.ОбработатьОшибкуВзаимодействияРР(ДанныеСтроки.Ошибка, КонтекстОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписок(Доверенности)
	Если Доверенности <> Неопределено Тогда
		Список.Очистить();
		Для Каждого Доверенность Из Доверенности Цикл
			НоваяСтрока = Список.Добавить();
			НоваяСтрока.Доверенность = Доверенность.Ключ;
			ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НоваяСтрока.Доверенность, "Код, НомерДоверенности");
			НоваяСтрока.НомерДоверенности = ЗначенияРеквизитов.НомерДоверенности;
			НоваяСтрока.КодДоверенности = ЗначенияРеквизитов.Код;
			Если Доверенность.Значение.ДанныеОшибкиЗапросаСтатуса = Неопределено Тогда
				НоваяСтрока.ИндексСостояния = 0;
				НоваяСтрока.Результат = Доверенность.Значение.ОписаниеСостояния;
			Иначе
				НоваяСтрока.Результат = Доверенность.Значение.ДанныеОшибкиЗапросаСтатуса.ТекстОшибки;
				НоваяСтрока.ИндексСостояния = 1;
				НоваяСтрока.Ошибка = Доверенность.Значение.ДанныеОшибкиЗапросаСтатуса;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти