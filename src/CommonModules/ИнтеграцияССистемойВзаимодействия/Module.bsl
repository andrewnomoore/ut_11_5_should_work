#Область ПрограммныйИнтерфейс

// Данные для управления системой взаимодействия.
// 
// Возвращаемое значение: 
//  Строка
Функция ДанныеДляУправленияСистемойВзаимодействия() Экспорт
	
	ДанныеИзХранилища = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеДляУправленияСистемойВзаимодействия", 
		"ДанныеДляУправленияСистемойВзаимодействия");
	
	Возврат Строка(ДанныеИзХранилища);
	
КонецФункции

// Доступно подключение к системе взаимодействия в модели сервиса.
// 
// Возвращаемое значение:
//  Булево - Ложь
Функция ДоступноПодключениеКСистемеВзаимодействияВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает результат запроса к http-сервису для управления системой взаимодействия
//
// Параметры:
//  АдресПубликацииСервисаУправления - Строка
//  КодУправления					 - Строка
//  ИмяМетода						 - Строка
//  ПараметрыЗапроса				 - Структура
// 
// Возвращаемое значение:
//  Структура - результат запроса в сервис с полями:
//		* Успешно - Булево
//		* ТекстСообщения - Строка
//		* ДанныеРезультата - Структура
//
Функция ЗапросВСервис(АдресПубликацииСервисаУправления, КодУправления, ИмяМетода, ПараметрыЗапроса = Неопределено)
	
	Результат = Новый Структура;
	Результат.Вставить("Успешно", Ложь);
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("ДанныеРезультата", Неопределено);
	
	Попытка
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресПубликацииСервисаУправления);
		Хост = СтруктураURI.Хост;
		ПутьНаСервере = СтруктураURI.ПутьНаСервере;
		Порт = СтруктураURI.Порт;
		ЗащищенноеСоединение = 
			ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(, Новый СертификатыУдостоверяющихЦентровОС);
		
		Соединение = Новый HTTPСоединение(
			Хост,
			Порт,
			,
			,
			ПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURI.Схема),
			,
			ЗащищенноеСоединение);
		
		ДанныеЗапроса = Новый Структура;
		ДанныеЗапроса.Вставить("control_code", КодУправления);
		ДанныеЗапроса.Вставить("method", ИмяМетода);
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, ДанныеЗапроса);
		
		СтрокаЗапроса = ЗаписьJSON.Закрыть();
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
		
		Запрос = Новый HTTPЗапрос(ПутьНаСервере, Заголовки);
		Запрос.УстановитьТелоИзСтроки(СтрокаЗапроса);
		
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
		
		Если Ответ.КодСостояния <> 200 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка %1'", ОбщегоНазначения.КодОсновногоЯзыка()), Строка(Ответ.КодСостояния));
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON;
		
		СтрокаТелаОтвета = Ответ.ПолучитьТелоКакСтроку();
		ЧтениеJSON.УстановитьСтроку(СтрокаТелаОтвета);
		
		Попытка
			ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON, Ложь);	
		Исключение
			ВызватьИсключение СтрокаТелаОтвета;
		КонецПопытки;
		
		Если ДанныеОтвета.error Тогда
			Результат.ТекстСообщения = ДанныеОтвета.message;
			Возврат Результат;
		КонецЕсли;
		
		Если ИмяМетода = ИмяМетодаРегистрацияБазы() Тогда
			
			ИмяБазы = ПараметрыЗапроса.ИмяБазы;
			ПараметрыРегистрации = Новый(ТипПараметрыРегистрацииИБ()); // ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия
			ПараметрыРегистрации.АдресСервера = ДанныеОтвета.ServerAddress;
			ПараметрыРегистрации.АдресЭлектроннойПочты = ДанныеОтвета.SubscriberID;
			ПараметрыРегистрации.ИмяИнформационнойБазы = ИмяБазы;
			ПараметрыРегистрации.КодАктивации = ДанныеОтвета.ActivationCode;
			
			РезультатРегистрации = 
				ИнтеграцияССистемойВзаимодействия.ОбъектСистемыВзаимодействия().ВыполнитьРегистрациюИнформационнойБазы(
					ПараметрыРегистрации);
			
			Если РезультатРегистрации.РегистрацияВыполнена Тогда
				Результат.Успешно = Истина;
				Результат.ДанныеРезультата = Новый Структура;
				Результат.ДанныеРезультата.Вставить("ДанныеПользователей", ДанныеОтвета.Users);
			Иначе
				Результат.ТекстСообщения = РезультатРегистрации.ТекстСообщения;
			КонецЕсли;
			
		ИначеЕсли ИмяМетода = ИмяМетодаСписокПользователей() Тогда
			
			Результат.Успешно = Истина;
			Результат.ДанныеРезультата = Новый Структура;
			Результат.ДанныеРезультата.Вставить("ДанныеПользователей", ДанныеОтвета.Users);
			
		КонецЕсли;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(
			СтрШаблон("%1.%2", ИмяСобытияЖурналаРегистрации(), НСтр("ru = 'Регистрация базы через сервис'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке));
		
		Результат.ТекстСообщения = ТехнологияСервиса.КраткийТекстОшибки(ИнформацияОбОшибке);
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Зарегистрировать базу через сервис
// 
// Параметры: 
//  АдресПубликацииСервисаУправления - Строка
//  КодУправления - Строка
//  ИмяБазы - Строка
// 
// Возвращаемое значение: см. ЗапросВСервис
Функция ЗарегистрироватьБазуЧерезСервис(АдресПубликацииСервисаУправления, КодУправления, ИмяБазы) Экспорт
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ИмяБазы", ИмяБазы);
	Возврат ЗапросВСервис(
		АдресПубликацииСервисаУправления, 
		КодУправления, 
		ИмяМетодаРегистрацияБазы(), 
		ПараметрыЗапроса);
	
КонецФункции

// Используется интеграция с системой взаимодействия в модели сервиса.
// 
// Возвращаемое значение:
//  Булево
Функция ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Объект системы взаимодействия.
// 
// Возвращаемое значение: 
//  МенеджерСистемыВзаимодействия
Функция ОбъектСистемыВзаимодействия() Экспорт
	
	Возврат СистемаВзаимодействия;
	
КонецФункции

// Получить данные о пользователях сервиса.
// 
// Параметры: 
//  АдресПубликацииСервисаУправления - Строка
//  КодУправления - Строка
// 
// Возвращаемое значение: см. ЗапросВСервис
//
Функция ПолучитьДанныеОПользователяхСервиса(АдресПубликацииСервисаУправления, КодУправления) Экспорт
	
	Возврат ЗапросВСервис(
		АдресПубликацииСервисаУправления, 
		КодУправления, 
		ИмяМетодаСписокПользователей());
	
КонецФункции

// Возвращает расшифрованные данные, предназначенные для управления системой взаимодействия через http-сервис.
//
// Параметры:
//  ДанныеДляУправления - Строка - зашифрованные данные
// 
// Возвращаемое значение:
//  Структура - результат расшифровки с полями:
//	* ТекстСообщения - Строка - сообщение, сформированное при расшифровке
//	* Расшифровано - Булево - признак успешной расшифровки
//	* Данные - Структура - расшифрованные данные:
//	  ** АдресПубликацииСервисаУправления - Строка
//	  ** КодУправления - Строка
//
Функция РасшифроватьДанныеДляУправления(ДанныеДляУправления) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Расшифровано", Ложь);
	Результат.Вставить("Данные", Неопределено);
	
	Попытка
	
		ДвоичныеДанные = base64UrlDecode(ДанныеДляУправления);
		
		ЧтениеДанных = Новый ЧтениеДанных(ДвоичныеДанные);
		РезультатЧтения = "";
		Пока Не ЧтениеДанных.ЧтениеЗавершено Цикл
			СтрокаЧтения = ЧтениеДанных.ПрочитатьСтроку();
			РезультатЧтения = РезультатЧтения + СтрокаЧтения + Символы.ПС;
		КонецЦикла;
		ЧтениеДанных.Закрыть();
		
		СтруктураДанных = СтруктураИзСтрокиJSON(РезультатЧтения);
		
		Результат.Данные = СтруктураДанных;
		Результат.Расшифровано = Истина;
	
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Результат.ТекстСообщения = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		
		Возврат Результат;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Тип коллекция идентификаторов приложений.
// 
// Возвращаемое значение:
//  Тип - Тип
Функция ТипКоллекцияИдентификаторовПриложений() Экспорт
	
	Возврат Тип("КоллекцияИдентификаторовПриложенийСистемыВзаимодействия");
	
КонецФункции

// Тип параметры регистрации ИБ.
// 
// Возвращаемое значение:
//  Тип - Тип
Функция ТипПараметрыРегистрацииИБ() Экспорт
	
	Возврат Тип("ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия");
	
КонецФункции

// Тип совместное использование приложений.
// 
// Возвращаемое значение:
//  Тип - Тип
Функция ТипСовместноеИспользованиеПриложений() Экспорт
	
	Возврат Тип("СовместноеИспользованиеПриложенийСистемыВзаимодействия");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция base64UrlDecode(Знач Строка)
	
	Пока СтрДлина(Строка) % 4 <> 0 Цикл
		Строка = Строка + "=";
	КонецЦикла;
	
	Строка = СтрЗаменить(Строка, "-", "+");
	Строка = СтрЗаменить(Строка, "_", "/");
	
	Возврат Base64Значение(Строка);
	
КонецФункции

Функция ИмяМетодаРегистрацияБазы()
	
	Возврат "register";
	
КонецФункции

Функция ИмяМетодаСписокПользователей()
	
	Возврат "users_list";
	
КонецФункции

Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Система взаимодействия'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция СтруктураИзСтрокиJSON(Строка, СвойстваТипаДата = Неопределено)
    
	ЧтениеJSON = Новый ЧтениеJSON;
    ЧтениеJSON.УстановитьСтроку(Строка);
    Ответ = ПрочитатьJSON(ЧтениеJSON,, СвойстваТипаДата, ФорматДатыJSON.ISO); 
    Возврат Ответ
    
КонецФункции

#КонецОбласти