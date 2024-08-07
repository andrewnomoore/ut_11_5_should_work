///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СообщениеОбмена Экспорт; // При получении - имя полученного файла во ВременныйКаталог. При отправке - имя файла, который необходимо отправить
Перем ВременныйКаталог Экспорт; // Временный каталог для сообщений обмена.
Перем ИдентификаторКаталога Экспорт;
Перем Корреспондент Экспорт;
Перем ИмяПланаОбмена Экспорт;
Перем ИмяПланаОбменаКорреспондента Экспорт;
Перем СообщениеОбОшибке Экспорт;
Перем СообщениеОбОшибкеЖР Экспорт;

Перем ШаблоныИменДляПолученияСообщения Экспорт;
Перем ИмяСообщенияДляОтправки Экспорт;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ОтправитьДанные
Функция ОтправитьДанные(СообщениеДляСопоставленияДанных = Ложь) Экспорт
	
	Попытка
		Результат = ОтправитьСообщениеОбмена(СообщениеДляСопоставленияДанных);
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ВыгрузкаДанных");
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПолучитьДанные
Функция ПолучитьДанные() Экспорт

	Попытка
		Результат = ПолучитьСообщениеОбмена();
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПараметрыКорреспондента
Функция ПараметрыКорреспондента(НастройкиПодключения) Экспорт
	
	Результат = ТранспортСообщенийОбмена.СтруктураРезультатаПолученияПараметровКорреспондента();
	Результат.Вставить("ИмяПланаОбменаКорреспондента", ИмяПланаОбменаКорреспондента);
	
	HTTPСоединение = HTTPСоединение();
	
	Параметры = Новый Структура;
	Параметры.Вставить("ExchangePlanName", ИмяПланаОбменаКорреспондента);
	Параметры.Вставить("NodeCode", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел().Код);
	Параметры.Вставить("IsXDTOExchangePlan", ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена));
	Параметры.Вставить("SettingID", НастройкиПодключения.ИдентификаторНастройки);
	
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "GET", "GetIBParameters", Параметры);
	
	Если ОтветЭтоОшибка(Ответ) Тогда
		
		Результат.ПодключениеУстановлено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		
		Возврат Результат;

	КонецЕсли;
	
	Тело = Ответ.ПолучитьТелоКакСтроку();
	РезультатЗапроса = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
		
	ПараметрыКорреспондента = Новый Структура;
	
	ПараметрыКорреспондента.Вставить("ПланОбменаСуществует", РезультатЗапроса["ExchangePlanExists"]);
	ПараметрыКорреспондента.Вставить("ПрефиксИнформационнойБазы", РезультатЗапроса["InfobasePrefix"]);
	ПараметрыКорреспондента.Вставить("ПрефиксИнформационнойБазыПоУмолчанию", РезультатЗапроса["DefaultInfobasePrefix"]);
	ПараметрыКорреспондента.Вставить("НаименованиеИнформационнойБазы", РезультатЗапроса["InfobaseDescription"]);
	ПараметрыКорреспондента.Вставить("НаименованиеИнформационнойБазыПоУмолчанию", РезультатЗапроса["DefaultInfobaseDescription"]);
	ПараметрыКорреспондента.Вставить("НастройкиПараметровУчетаЗаданы", РезультатЗапроса["AccountingParametersSettingsAreSpecified"]);
	ПараметрыКорреспондента.Вставить("КодЭтогоУзла", РезультатЗапроса["ThisNodeCode"]); 
	ПараметрыКорреспондента.Вставить("ВерсияКонфигурации", РезультатЗапроса["ConfigurationVersion"]);
	ПараметрыКорреспондента.Вставить("УзелСуществует", РезультатЗапроса["NodeExists"]);
	ПараметрыКорреспондента.Вставить("ВерсияФорматаНастроекОбменаДанными", РезультатЗапроса["DataExchangeSettingsFormatVersion"]);
	ПараметрыКорреспондента.Вставить("ИспользоватьПрефиксыДляНастройкиОбмена", РезультатЗапроса["UsePrefixesForExchangeSettings"]);
	ПараметрыКорреспондента.Вставить("ФорматОбмена", РезультатЗапроса["ExchangeFormat"]);
	ПараметрыКорреспондента.Вставить("ИмяПланаОбмена", РезультатЗапроса["ExchangePlanName"]);
	ПараметрыКорреспондента.Вставить("ВерсииФорматаОбмена", РезультатЗапроса["ExchangeFormatVersions"]);
	ПараметрыКорреспондента.Вставить("НастройкаСинхронизацииДанныхЗавершена", РезультатЗапроса["DataSynchronizationSetupCompleted"]);
	ПараметрыКорреспондента.Вставить("ПолученоСообщениеДляСопоставленияДанных", РезультатЗапроса["MessageReceivedForDataMapping"]);
	ПараметрыКорреспондента.Вставить("ПоддерживаетсяСопоставлениеДанных", РезультатЗапроса["DataMappingSupported"]);
	
	Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена) Тогда
		
		ОбъектыФормата = ТранспортСообщенийОбмена.ТаблицаИзМассива_ПоддерживаемыеОбъектыФормата(
			РезультатЗапроса["SupportedObjectsInFormat"],
			РезультатЗапроса["ExchangeFormatVersions"]);
	
		ПараметрыКорреспондента.Вставить("ПоддерживаемыеОбъектыФормата", ОбъектыФормата);
		
	КонецЕсли;

	Результат.ПодключениеУстановлено = Ложь;
	
 	Если Не ПараметрыКорреспондента.ПланОбменаСуществует Тогда
		
		Текст = НСтр("ru = 'В корреспонденте не найден план обмена ""%1"".
			|Убедитесь, что
			| - выбран правильный вид приложения для настройки обмена;
			| - указан правильный адрес приложения в Интернете.'");
		
		СообщениеОбОшибке = СтрШаблон(Текст, ИмяПланаОбмена);
		
		Результат.ПодключениеУстановлено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		
		Возврат Результат;
		
	КонецЕсли;
	
	Результат.ПараметрыКорреспондентаПолучены = Истина;
	Результат.ПараметрыКорреспондента = ПараметрыКорреспондента;
	Результат.ИмяПланаОбменаКорреспондента = ПараметрыКорреспондента.ИмяПланаОбмена;
	Результат.ПодключениеУстановлено = Истина;
	
	Отказ = Ложь;
	СообщениеОбОшибке = "";
	
	ВерсияКонфигурации = Результат.ПараметрыКорреспондента.ВерсияКонфигурации;
	
	ТранспортСообщенийОбмена.ПриПодключенииККорреспонденту(Отказ, ИмяПланаОбмена, ВерсияКонфигурации, СообщениеОбОшибке);
		
	Если Отказ Тогда
		
		Результат.ПодключениеРазрешено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		
		Возврат Результат;
		
	КонецЕсли;
	
	ТранспортСообщенийОбмена.ПроверитьДублированиеСинхронизаций(ИмяПланаОбмена, ПараметрыКорреспондента, Результат);
	
	Результат.ПодключениеРазрешено = Истина;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПередВыгрузкойДанных
Функция ПередВыгрузкойДанных(СообщениеДляСопоставленияДанных = Ложь) Экспорт
	
	Возврат ПодключениеУстановлено();
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.СохранитьНастройкиВКорреспонденте
Функция СохранитьНастройкиВКорреспонденте(НастройкиПодключения) Экспорт
	
	HTTPСоединение = HTTPСоединение();
	
	НастройкиПодключенияВJSON = ТранспортСообщенийОбмена.НастройкиПодключенияВJSON(НастройкиПодключения);
	
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "POST", "CreateExchangeNode", , НастройкиПодключенияВJSON);
	
	Если ОтветЭтоОшибка(Ответ) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ТребуетсяАутентификация
Функция ТребуетсяАутентификация() Экспорт
	
	Возврат НЕ ЗапомнитьПароль;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.УдалитьНастройкуСинхронизацииВКорреспонденте
Функция УдалитьНастройкуСинхронизацииВКорреспонденте() Экспорт
	
	HTTPСоединение = HTTPСоединение();
	
	Параметры = Новый Структура;
	Параметры.Вставить("ExchangePlanName", ИмяПланаОбменаКорреспондента);
	Параметры.Вставить("NodeCode", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел().Код);
	
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "DELETE", "RemoveExchangeNode", Параметры);
	
	Если ОтветЭтоОшибка(Ответ) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодключениеУстановлено() Экспорт
	
	HTTPСоединение = HTTPСоединение();
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресВебСервиса);
	АдресРесурса = СтруктураURI.ПутьНаСервере + "/hs/exchange/version";
		
	Заголовки = Новый Соответствие();
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Ответ = HTTPСоединение.Получить(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		
		Возврат Истина;
		
	Иначе
		
		СообщениеОбОшибке = НСтр("ru = 'Аутентификация пользователя не выполнена.'");
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект,,Ответ.ПолучитьТелоКакСтроку());
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ОтправитьСообщениеОбмена(СообщениеДляСопоставленияДанных)
		
	HTTPСоединение = HTTPСоединение(180);
	
	Если Не ЗначениеЗаполнено(Корреспондент) Тогда
		ИдентификаторФайлаУИД = ПоместитьФайлВХранилищеВСервисе(HTTPСоединение, СообщениеОбмена, 1024);
		Возврат Истина;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ExchangePlanName", ИмяПланаОбменаКорреспондента);
	Параметры.Вставить("NodeCode", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел().Код);
	Параметры.Вставить("IsXDTOExchangePlan", ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена));
	
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "GET", "GetIBParameters", Параметры);
	
	Если ОтветЭтоОшибка(Ответ, "ВыгрузкаДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Тело = Ответ.ПолучитьТелоКакСтроку();
	СостояниеНастройки = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
	ИдентификаторФайлаУИД = ПоместитьФайлВХранилищеВСервисе(HTTPСоединение, СообщениеОбмена, 1024);
	
	ИдентификаторФайлаСтрокой = Строка(ИдентификаторФайлаУИД);
	
	Если СообщениеДляСопоставленияДанных
		И (СостояниеНастройки["DataMappingSupported"]
		Или Не СостояниеНастройки["DataSynchronizationSetupCompleted"]) Тогда
			
		Параметры = Новый Структура;
		Параметры.Вставить("ExchangePlanName", ИмяПланаОбменаКорреспондента);
		Параметры.Вставить("NodeCode", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел().Код);
		Параметры.Вставить("FileID", ИдентификаторФайлаСтрокой);
		
		Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "POST", "PutMessageForDataMatching", Параметры);
		
		Если ОтветЭтоОшибка(Ответ, "ВыгрузкаДанных") Тогда
			Возврат Ложь;
		КонецЕсли;
		
	Иначе
		
		Параметры = Новый Структура;
		Параметры.Вставить("ExchangePlanName", ИмяПланаОбменаКорреспондента);
		Параметры.Вставить("NodeCode", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел().Код);
		Параметры.Вставить("FileID", ИдентификаторФайлаСтрокой);
		Параметры.Вставить("TimeConsumingOperationAllowed", Истина);
		
		Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "POST", "DownloadData", Параметры);
		
		Тело = Ответ.ПолучитьТелоКакСтроку();
		
		Если ОтветЭтоОшибка(Ответ, "ВыгрузкаДанных") Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Результат = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
		
		ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
		ПараметрыОбмена.ИнтервалОжиданияНаСервере = 15;
		ПараметрыОбмена.ДлительнаяОперация = Результат["TimeConsumingOperation"];
		ПараметрыОбмена.ИдентификаторОперации = Результат["OperationID"];
		
		Если ПараметрыОбмена.ДлительнаяОперация Тогда
			
			ОжиданиеЗавершенияОперации(HTTPСоединение, ПараметрыОбмена, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
			
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

Функция ПоместитьФайлВХранилищеВСервисе(HTTPСоединение, Знач ИмяФайла, 
	Знач РазмерЧастиКБ = 1024, ИдентификаторФайла = Неопределено) Экспорт
	
	Если HTTPСоединение = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru ='Не определен WS-прокси передачи файла выгрузки в базу приемник. 
			|Обратитесь к администратору.'", ОбщегоНазначения.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	КаталогФайлов = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогФайлов);
	
	// Архивирование файла.
	ИмяНеразделенногоФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогФайлов, "data.zip");
	Архиватор = Новый ЗаписьZipФайла(ИмяНеразделенногоФайла,,,, УровеньСжатияZIP.Максимальный);
	Архиватор.Добавить(ИмяФайла);
	Архиватор.Записать();
	
	// Разделение файла на части.
	ИдентификаторСессии = Новый УникальныйИдентификатор;
	
	РазмерЧастиВБайтах = РазмерЧастиКБ * 1024;
	ИменаФайлов = РазделитьФайл(ИмяНеразделенногоФайла, РазмерЧастиВБайтах);
		
	КоличествоЧастей = ИменаФайлов.Количество();
	Для НомерЧасти = 1 По КоличествоЧастей Цикл
		
		ИмяФайлаЧасти = ИменаФайлов[НомерЧасти - 1];
		ДанныеФайла = Новый ДвоичныеДанные(ИмяФайлаЧасти);

		Параметры = Новый Структура;
		Параметры.Вставить("SessionID", ИдентификаторСессии);
		Параметры.Вставить("PartNumber", НомерЧасти);
		
		Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "POST", "PutFilePart", Параметры, ДанныеФайла);
		
		Если ОтветЭтоОшибка(Ответ, "ВыгрузкаДанных") Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Попытка
		УдалитьФайлы(КаталогФайлов);
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	Параметры = Новый Структура;
	Параметры.Вставить("SessionID", ИдентификаторСессии);
	Параметры.Вставить("PartCount", КоличествоЧастей);
	
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "POST", "SaveFileFromParts", Параметры);
	
	Если ОтветЭтоОшибка(Ответ, "ВыгрузкаДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Тело = Ответ.ПолучитьТелоКакСтроку();
	Результат = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
	
	Возврат Результат["FileID"]; 
	
КонецФункции

Процедура ОжиданиеЗавершенияОперации(HTTPСоединение, ПараметрыОбмена, ДействиеПриОбменеВЭтойИБ = Неопределено) Экспорт
	
	Если ПараметрыОбмена.ИнтервалОжиданияНаСервере = 0 Тогда
		
		Если ДействиеПриОбменеВЭтойИБ <> Неопределено Тогда
			
			// В этой ИБ "Загрузка", значит в корреспонденте "Выгрузка"
			Если ДействиеПриОбменеВЭтойИБ = Перечисления.ДействияПриОбмене.ЗагрузкаДанных Тогда
				
				ДействиеВКорреспондентеСтрокой = НСтр("ru ='выгрузка'", ОбщегоНазначения.КодОсновногоЯзыка());
				
			Иначе
				
				ДействиеВКорреспондентеСтрокой = НСтр("ru ='загрузка'", ОбщегоНазначения.КодОсновногоЯзыка());
				
			КонецЕсли;
			
			ШаблонСообщения = НСтр("ru = 'Ожидание выполнения операции (%1 данных в базе-корреспонденте)...'", ОбщегоНазначения.КодОсновногоЯзыка());
			Сообщение = СтрШаблон(ШаблонСообщения, ДействиеВКорреспондентеСтрокой);
			ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект,, Сообщение, Ложь);
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	Пока ПараметрыОбмена.ДлительнаяОперация Цикл // Замена рекурсии
		
		ОбменДаннымиСервер.Пауза(ПараметрыОбмена.ИнтервалОжиданияНаСервере);
		
		СтрокаСообщенияОбОшибке = "";
			
		Параметры = Новый Структура;
		Параметры.Вставить("OperationID",  ПараметрыОбмена.ИдентификаторОперации);
		
		Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "GET", "GetContinuousOperationStatus", Параметры);
		
		Если ОтветЭтоОшибка(Ответ) Тогда
			СостояниеОперации = "";
		Иначе
			Тело = Ответ.ПолучитьТелоКакСтроку();
			Результат = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
			СостояниеОперации = Результат["ActionState"];
		КонецЕсли;
			
		Если СостояниеОперации = "Active" Тогда
			
			ПараметрыОбмена.ИнтервалОжиданияНаСервере = Мин(ПараметрыОбмена.ИнтервалОжиданияНаСервере + 30, 180);
			
		ИначеЕсли СостояниеОперации = "Completed" Тогда
			
			ПараметрыОбмена.ИнтервалОжиданияНаСервере = 15;
			ПараметрыОбмена.ДлительнаяОперация = Ложь; 
			ПараметрыОбмена.ИдентификаторОперации = Неопределено;
			
		Иначе
			
			ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка в базе-корреспонденте:%1 %2'"), Символы.ПС, СтрокаСообщенияОбОшибке);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСообщениеОбмена()
	
	HTTPСоединение = HTTPСоединение(180);
	
	Если Не ЗначениеЗаполнено(Корреспондент) Тогда
		СообщениеОбмена = ПолучитьФайлИзХранилищаВСервисе(HTTPСоединение, ШаблоныИменДляПолученияСообщения[0], 1024);
		Возврат Истина;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ExchangePlanName", ИмяПланаОбменаКорреспондента);
	Параметры.Вставить("NodeCode", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел().Код);
	Параметры.Вставить("TimeConsumingOperationAllowed", Истина);
	
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "POST", "UploadData", Параметры);
	
	Если ОтветЭтоОшибка(Ответ, "ЗагрузкаДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Тело = Ответ.ПолучитьТелоКакСтроку();
	
	Результат = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
		
	ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
	ПараметрыОбмена.ДлительнаяОперацияРазрешена = Истина;
	ПараметрыОбмена.ИнтервалОжиданияНаСервере = 15;
	ПараметрыОбмена.ИдентификаторФайла = Результат["FileID"];
	ПараметрыОбмена.ДлительнаяОперация = Результат["TimeConsumingOperation"];
	ПараметрыОбмена.ИдентификаторОперации = Результат["OperationID"];
	
	Если ПараметрыОбмена.ДлительнаяОперация Тогда
		
		ОжиданиеЗавершенияОперации(HTTPСоединение, ПараметрыОбмена, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
		
	КонецЕсли;
	
	УИДФайлаСообщения = Новый УникальныйИдентификатор(ПараметрыОбмена.ИдентификаторФайла);
	
	СообщениеОбмена = ПолучитьФайлИзХранилищаВСервисе(HTTPСоединение, УИДФайлаСообщения, 1024);
		
	Если ОтветЭтоОшибка(Ответ, "ЗагрузкаДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

Функция ПолучитьФайлИзХранилищаВСервисе(HTTPСоединение, Знач ИдентификаторФайла, Знач РазмерЧасти = 1024) Экспорт
	
	// Возвращаемое значение функции.
	ИмяФайлаРезультата = "";
	
	Параметры = Новый Структура;
	Параметры.Вставить("FileID", ИдентификаторФайла);
	Параметры.Вставить("BlockSize", Формат(РазмерЧасти, "ЧГ="));
	
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "POST", "PrepareGetFile", Параметры);
	
	Если ОтветЭтоОшибка(Ответ, "ЗагрузкаДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Тело = Ответ.ПолучитьТелоКакСтроку();
	
	Результат = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
	
	ИдентификаторСессии = Результат["SessionID"];
	КоличествоЧастей = Результат["PartCount"];
	
	ИменаФайлов = Новый Массив;
	
	КаталогСборки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогСборки);
	
	ШаблонИмениФайла = "data.zip.[n]";
	
	ШаблонСообщения = НСтр("ru = 'Начало получения сообщения обмена из Интернета (количество частей файла %1).'");
	Сообщение = СтрШаблон(ШаблонСообщения, Формат(КоличествоЧастей, "ЧН=0; ЧГ=0"));
	ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных", Сообщение, Ложь);
		
	Для НомерЧасти = 1 По КоличествоЧастей Цикл
		ДанныеЧасти = Неопределено; // ДвоичныеДанные
		
		Параметры = Новый Структура;
		Параметры.Вставить("SessionID", ИдентификаторСессии);
		Параметры.Вставить("PartNumber", НомерЧасти);
		
		Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "GET", "GetFilePart", Параметры);
		
		Если ОтветЭтоОшибка(Ответ, "ЗагрузкаДанных") Тогда
			
			Параметры = Новый Структура;
			Параметры.Вставить("SessionID", ИдентификаторСессии);
			
			ВыполнитьHTTPЗапрос(HTTPСоединение, "DELETE", "ReleaseFile", Параметры);
			
			Возврат Ложь;
			
		Иначе
			
			ДанныеЧасти = Ответ.ПолучитьТелоКакДвоичныеДанные();
			
		КонецЕсли;
		
		ИмяФайла = СтрЗаменить(ШаблонИмениФайла, "[n]", Формат(НомерЧасти, "ЧГ=0"));
		ИмяФайлаЧасти = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогСборки, ИмяФайла);
		
		ДанныеЧасти.Записать(ИмяФайлаЧасти);
		ИменаФайлов.Добавить(ИмяФайлаЧасти);
		
	КонецЦикла;
	
	ДанныеЧасти = Неопределено;
		
	Параметры = Новый Структура;
	Параметры.Вставить("SessionID", ИдентификаторСессии);
			
	Ответ = ВыполнитьHTTPЗапрос(HTTPСоединение, "DELETE", "ReleaseFile", Параметры);
			
	Если ОтветЭтоОшибка(Ответ, "ЗагрузкаДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИмяАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогСборки, "data.zip");
	
	ОбъединитьФайлы(ИменаФайлов, ИмяАрхива);
		
	Разархиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	Если Разархиватор.Элементы.Количество() = 0 Тогда
		Попытка
			УдалитьФайлы(КаталогСборки);
		Исключение
			ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
			ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
		КонецПопытки;
		ВызватьИсключение(НСтр("ru = 'Файл архива не содержит данных.'"));
	КонецЕсли;
	
	// Протоколирование событий обмена.
	ФайлАрхива = Новый Файл(ИмяАрхива);
	
	ШаблонСообщения = НСтр("ru = 'Окончание получения сообщения обмена из Интернета (размер сжатого сообщения обмена %1 Мб).'");
	Сообщение = СтрШаблон(ШаблонСообщения, Формат(Окр(ФайлАрхива.Размер() / 1024 / 1024, 3), "ЧН=0; ЧГ=0"));
	ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных", Сообщение, Ложь);
	
	ЭлементАрхива = Разархиватор.Элементы.Получить(0);
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогСборки, ЭлементАрхива.Имя);
	
	Разархиватор.Извлечь(ЭлементАрхива, КаталогСборки);
	Разархиватор.Закрыть();
	
	Файл = Новый Файл(ИмяФайла);
	
	ВременныйКаталог = ПолучитьИмяВременногоФайла(); //АПК:441 удаление каталога происходит при получении данных обмена в другой ИБ
	СоздатьКаталог(ВременныйКаталог);
	
	ИмяФайлаРезультата = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, Файл.Имя);
	
	ПереместитьФайл(ИмяФайла, ИмяФайлаРезультата);
	
	Попытка
		УдалитьФайлы(КаталогСборки);
	Исключение
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
	КонецПопытки;
		
	Возврат ИмяФайлаРезультата;
	
КонецФункции

Функция HTTPСоединение(Таймаут = 20)
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресВебСервиса);
	
	Если НРег(СтруктураURI.Схема) = НРег("https") Тогда
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	КонецЕсли;
	
	Возврат Новый HTTPСоединение(СтруктураURI.ИмяСервера,,ИмяПользователя, Пароль,,Таймаут, ЗащищенноеСоединение);
	
КонецФункции

Функция ВыполнитьHTTPЗапрос(HTTPСоединение, ВидЗапроса, Метод, Параметры = Неопределено, Тело = Неопределено)
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресВебСервиса);
		
	АдресРесурсаШаблон = "/%1/hs/exchange/v1/%2?%3";
	ПараметрыСтрокой = "";
	
	Если ЗначениеЗаполнено(Параметры) Тогда
		
		Для Каждого КлючИЗначение Из Параметры Цикл
		
			Если ПараметрыСтрокой <> "" Тогда
				ПараметрыСтрокой = ПараметрыСтрокой + "&"
			КонецЕсли;
			
			ПараметрыСтрокой = ПараметрыСтрокой + КлючИЗначение.Ключ + "=" + КлючИЗначение.Значение
		
		КонецЦикла;
		
	КонецЕсли;
	
	АдресРесурса = СтрШаблон(АдресРесурсаШаблон, СтруктураURI.ПутьНаСервере, Метод, ПараметрыСтрокой); 
	
	Заголовки = Новый Соответствие();
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Если ТипЗнч(Тело) = Тип("Строка") Тогда
		Запрос.УстановитьТелоИзСтроки(Тело);
	ИначеЕсли ТипЗнч(Тело) = Тип("ДвоичныеДанные") Тогда
		Запрос.УстановитьТелоИзДвоичныхДанных(Тело);
	КонецЕсли;
	
	Если НРег(ВидЗапроса) = "post" Тогда 
		Ответ = HTTPСоединение.ОтправитьДляОбработки(Запрос);
	ИначеЕсли НРег(ВидЗапроса) = "get" Тогда 
		Ответ = HTTPСоединение.Получить(Запрос);
	ИначеЕсли НРег(ВидЗапроса) = "delete" Тогда
		Ответ = HTTPСоединение.Удалить(Запрос);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ОтветЭтоОшибка(Ответ, ДействиеПриОбмене = Неопределено)
	
	Если Ответ.КодСостояния <> 200 Тогда
		
		Тело = Ответ.ПолучитьТелоКакСтроку();
		
		Попытка
			СообщениеОбОшибке = ТранспортСообщенийОбмена.JSONВЗначение(Тело)["message"];
		Исключение
			СообщениеОбОшибке = Тело;
		КонецПопытки;
		
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, ДействиеПриОбмене);
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
	
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ВременныйКаталог = Неопределено;
СообщенияОбмена = Неопределено;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли