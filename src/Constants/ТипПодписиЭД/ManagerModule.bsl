
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Включает константу ТипПодписиЭД.
//
// Параметры:
//  Параметры - Структура - параметры обработчика обновления.
//                          См. документацию по подсистеме СтандартныеПодсистемы.ОбновлениеВерсииИБ.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Параметры.ПрогрессВыполнения.ВсегоОбъектов = 1;
	
	МетаданныеОбъекта = Метаданные.Константы.ТипПодписиЭД;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ОбработанныхОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Записать = Ложь;
		
		МенеджерЗначения = СоздатьМенеджерЗначения();
		МенеджерЗначения.Прочитать();
		
		Если Не ЗначениеЗаполнено(МенеджерЗначения.Значение) Тогда
			МенеджерЗначения.Значение = Перечисления.ТипыПодписиКриптографии.СМеткойДоверенногоВремениCAdEST;
			Записать = Истина;
		КонецЕсли;
		
		Если Записать Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
		Иначе
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(МенеджерЗначения, ПараметрыОтметкиВыполнения);
		КонецЕсли;
		
		ОбработанныхОбъектов = ОбработанныхОбъектов + 1;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
		ТекстСообщения =
			НСтр("ru = 'Не удалось обработать константу ""Тип подписи электронного документа"" по причине:'")
			+ Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение, МетаданныеОбъекта, , ТекстСообщения);
		
	КонецПопытки;
		
	Если ОбработанныхОбъектов = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось обработать константу ""Тип подписи электронного документа"".'");
		ВызватьИсключение ТекстСообщения;
	Иначе
		ТекстСообщения = НСтр("ru = 'Обработана константа ""Тип подписи электронного документа"".'");
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, МетаданныеОбъекта, , ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов
		+ ОбработанныхОбъектов;
	
	Параметры.ОбработкаЗавершена = (ОбработанныхОбъектов > 0);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецЕсли