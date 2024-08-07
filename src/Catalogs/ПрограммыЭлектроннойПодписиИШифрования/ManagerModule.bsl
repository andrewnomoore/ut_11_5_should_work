///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("ПоказатьСтраницу", "Программы");
		ВыбраннаяФорма = Метаданные.ОбщиеФормы.НастройкиЭлектроннойПодписиИШифрования;
		
	ИначеЕсли Параметры.Свойство("Ключ")
	        И Параметры.Ключ.ЭтоВстроенныйКриптопровайдер
	        И Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "Обработка.ПрограммыЭлектроннойПодписиИШифрования.Форма.ВстроенныйКриптопровайдер";
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса() Тогда
		Параметры.Отбор.Вставить("ЭтоВстроенныйКриптопровайдер", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. ЭлектроннаяПодписьСлужебный.ПоставляемыеНастройкиПрограмм
Функция ПоставляемыеНастройкиПрограмм() Экспорт
	
	Настройки = ЭлектроннаяПодписьСлужебный.ПоставляемыеНастройкиПрограмм();
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбработкаПрограммыЭлектроннойПодписиИШифрования = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			"Обработка.ПрограммыЭлектроннойПодписиИШифрования");
		ОбработкаПрограммыЭлектроннойПодписиИШифрования.ДобавитьПоставляемыеНастройкиПрограмм(Настройки);
	Иначе
		ДобавитьНастройкиMicrosoftEnhancedCSP(Настройки);
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

Процедура ДобавитьНастройкиMicrosoftEnhancedCSP(Настройки) Экспорт
	
	// Microsoft Enhanced CSP
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Microsoft Enhanced CSP'");
	Настройка.ИмяПрограммы        = "Microsoft Enhanced Cryptographic Provider v1.0";
	Настройка.ТипПрограммы        = 1;
	Настройка.АлгоритмПодписи     = "RSA_SIGN"; // Один вариант.
	Настройка.АлгоритмХеширования = "MD5";      // Варианты: SHA-1, MD2, MD4, MD5.
	Настройка.АлгоритмШифрования  = "RC2";      // Варианты: RC2, RC4, DES, 3DES.
	Настройка.Идентификатор       = "MicrosoftEnhanced";
	
	Настройка.АлгоритмыПодписи.Добавить("RSA_SIGN");
	Настройка.АлгоритмыХеширования.Добавить("SHA-1");
	Настройка.АлгоритмыХеширования.Добавить("MD2");
	Настройка.АлгоритмыХеширования.Добавить("MD4");
	Настройка.АлгоритмыХеширования.Добавить("MD5");
	Настройка.АлгоритмыШифрования.Добавить("RC2");
	Настройка.АлгоритмыШифрования.Добавить("RC4");
	Настройка.АлгоритмыШифрования.Добавить("DES");
	Настройка.АлгоритмыШифрования.Добавить("3DES");
	Настройка.НетВLinux = Истина;
	Настройка.НетВMacOS = Истина;
	
	// Microsoft Enhanced RSA and AES CSP
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Microsoft Enhanced RSA and AES CSP'");
	Настройка.ИмяПрограммы        = "Microsoft Enhanced RSA and AES Cryptographic Provider";
	Настройка.ТипПрограммы        = 24;
	Настройка.АлгоритмПодписи     = "RSA_SIGN"; // Один вариант.
	Настройка.АлгоритмХеширования = "SHA-256";  // Варианты: SHA-256, SHA-1, MD2, MD4, MD5.
	Настройка.АлгоритмШифрования  = "3DES";     // Варианты: RC2, RC4, DES, 3DES.
	Настройка.Идентификатор       = "MicrosoftEnhanced_RSA_AES";
	
	Настройка.АлгоритмыПодписи.Добавить("RSA_SIGN");
	Настройка.АлгоритмыХеширования.Добавить("SHA-256");
	Настройка.АлгоритмыХеширования.Добавить("SHA-1");
	Настройка.АлгоритмыХеширования.Добавить("MD2");
	Настройка.АлгоритмыХеширования.Добавить("MD4");
	Настройка.АлгоритмыХеширования.Добавить("MD5");
	Настройка.АлгоритмыШифрования.Добавить("RC2");
	Настройка.АлгоритмыШифрования.Добавить("RC4");
	Настройка.АлгоритмыШифрования.Добавить("DES");
	Настройка.АлгоритмыШифрования.Добавить("3DES");
	Настройка.НетВLinux = Истина;
	Настройка.НетВMacOS = Истина;
	
КонецПроцедуры

Функция ПоставляемыеПутиКМодулямПрограмм() Экспорт
	
	ПутиКМодулям = ЭлектроннаяПодписьСлужебный.ПоставляемыеПутиКМодулямПрограмм();
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбработкаПрограммыЭлектроннойПодписиИШифрования = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			"Обработка.ПрограммыЭлектроннойПодписиИШифрования");
		ОбработкаПрограммыЭлектроннойПодписиИШифрования.ДобавитьПоставляемыеПутиКМодулямПрограмм(ПутиКМодулям);
	КонецЕсли;
	
	Возврат ПутиКМодулям;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

Процедура ЗаполнитьНачальныеНастройки(Программы = Неопределено, БезВстроенногоКриптопровайдера = Ложь) Экспорт
	
	Если Программы = Неопределено Тогда
		Программы = Новый Соответствие;
	КонецЕсли;
	
	ОписаниеПрограмм = Новый Массив;
	Для Каждого КлючИЗначение Из Программы Цикл
		ОписаниеПрограмм.Добавить(ЭлектроннаяПодпись.НовоеОписаниеПрограммы(
			КлючИЗначение.Ключ, КлючИЗначение.Значение));
	КонецЦикла;
	
	ЭлектроннаяПодпись.ЗаполнитьСписокПрограмм(ОписаниеПрограмм);
	
	Если БезВстроенногоКриптопровайдера Тогда
		Возврат;
	КонецЕсли;
	
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбработкаПрограммыЭлектроннойПодписиИШифрования = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			"Обработка.ПрограммыЭлектроннойПодписиИШифрования");
		ОбработкаПрограммыЭлектроннойПодписиИШифрования.ОбновитьВстроенныйКриптопровайдер();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
	|ГДЕ
	|	НЕ ПрограммыЭлектроннойПодписиИШифрования.ЭтоВстроенныйКриптопровайдер";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	ВыборкаДетальныеЗаписи = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь,
		"Справочник.ПрограммыЭлектроннойПодписиИШифрования");
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	ПоставляемыеНастройки = ПоставляемыеНастройкиПрограмм();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбновитьДанныеПрограммыОтложенно(ВыборкаДетальныеЗаписи.Ссылка,
			ОбъектовОбработано, ПроблемныхОбъектов, ПоставляемыеНастройки);
	КонецЦикла;
	
	ДозаполнитьНачальныеНастройкиОтложенно(ОбъектовОбработано, ПроблемныхОбъектов);
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ПрограммыЭлектроннойПодписиИШифрования") Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые приложения электронной подписи (пропущены): %1'"), 
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ПрограммыЭлектроннойПодписиИШифрования,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработана очередная порция приложений электронной подписи: %1'"),
				ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;

КонецПроцедуры

// Параметры:
//  Программа - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования
//
Процедура ОбновитьДанныеПрограммыОтложенно(Программа, ОбъектовОбработано, ПроблемныхОбъектов, ПоставляемыеНастройки)
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Справочник.ПрограммыЭлектроннойПодписиИШифрования");
	
	ПредставлениеСсылки = Строка(Программа);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Свойства = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Программа,
			"ИмяПрограммы, ТипПрограммы, Наименование, ЭтоВстроенныйКриптопровайдер, ПометкаУдаления, РежимИспользования");
		
		Отбор = Новый Структура("ИмяПрограммы, ТипПрограммы", Свойства.ИмяПрограммы, Свойства.ТипПрограммы);
		Строки = ПоставляемыеНастройки.НайтиСтроки(Отбор);
		
		Если Не Свойства.ЭтоВстроенныйКриптопровайдер
		   И Строки.Количество() = 1
		   И (Строки[0].Представление <> Свойства.Наименование Или Не ЗначениеЗаполнено(Свойства.РежимИспользования)) Тогда
			
			ПрограммаОбъект = Программа.ПолучитьОбъект();
			ПрограммаОбъект.Наименование = Строки[0].Представление;
			Если Не ЗначениеЗаполнено(Свойства.РежимИспользования) Тогда
				ПрограммаОбъект.РежимИспользования = ?(Свойства.ПометкаУдаления,
					Перечисления.РежимыИспользованияПрограммыЭлектроннойПодписи.НеИспользуется,
					Перечисления.РежимыИспользованияПрограммыЭлектроннойПодписи.Настроена)
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрограммаОбъект);
		ИначеЕсли Не ЗначениеЗаполнено(Свойства.РежимИспользования) Тогда
			
			ПрограммаОбъект = Программа.ПолучитьОбъект();
			ПрограммаОбъект.РежимИспользования = ?(Свойства.ПометкаУдаления,
				Перечисления.РежимыИспользованияПрограммыЭлектроннойПодписи.НеИспользуется,
				Перечисления.РежимыИспользованияПрограммыЭлектроннойПодписи.Настроена);
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрограммаОбъект);
			
		КонецЕсли;
		
		ОбъектовОбработано = ОбъектовОбработано + 1;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОшибкуВЖурналРегистрации(
			Программа,
			ПредставлениеСсылки,
			ИнформацияОбОшибке());
		Возврат;
	КонецПопытки;
	
	ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Программа);
	
КонецПроцедуры

Процедура ДозаполнитьНачальныеНастройкиОтложенно(ОбъектовОбработано, ПроблемныхОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрограммыЭлектроннойПодписиИШифрования.ИмяПрограммы КАК ИмяПрограммы,
	|	ПрограммыЭлектроннойПодписиИШифрования.ТипПрограммы КАК ТипПрограммы
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
	|ГДЕ
	|	ПрограммыЭлектроннойПодписиИШифрования.ЭтоВстроенныйКриптопровайдер";
	
	Программы = Новый Соответствие;
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Справочник.ПрограммыЭлектроннойПодписиИШифрования");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Программы.Получить(Выборка.ИмяПрограммы) = Выборка.ТипПрограммы Тогда
				Программы.Удалить(Выборка.ИмяПрограммы);
			КонецЕсли;
		КонецЦикла;
		
		ЗаполнитьНачальныеНастройки(Программы, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось дозаполнить начальные настройки приложения по причине:
			|%1'"), ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбработкаПрограммыЭлектроннойПодписиИШифрования = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			"Обработка.ПрограммыЭлектроннойПодписиИШифрования");
		ОбработкаПрограммыЭлектроннойПодписиИШифрования.ОбновитьВстроенныйКриптопровайдер(Истина,
			ОбъектовОбработано, ПроблемныхОбъектов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
