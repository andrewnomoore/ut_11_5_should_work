///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Подключает на сервере 1С:Предприятия внешнюю компоненту из хранилища внешних компонент,
// выполненную по технологии Native API или COM.
// В модели сервиса разрешено только подключение общих внешних компонент, одобренных администратором сервиса.
//
// Параметры:
//  ИмяОбъекта - Строка - идентификатор объекта внешней компоненты.
//  ПолноеИмяМакета - Строка - имя макет где содержится компонента.
//
// Возвращаемое значение:
//  ПодключаемыйМодуль - ОбъектВнешнейКомпоненты - экземпляр объекта внешней компоненты;
//
Функция ПодключитьКомпоненту(Знач ИмяОбъекта, Знач ПолноеИмяМакета) Экспорт
	
	ВнешняяКомпонента = Неопределено;
	
	Изолированно = ВнешниеКомпонентыБПО.ИзолированноеПодключенияВнешнихКомпонентНаСервере();
	
#Если НЕ МобильноеПриложениеСервер Тогда
	УстановитьОтключениеБезопасногоРежима(Истина);
	
		// Вызов БСП
	Если ОбщегоНазначенияБПО.ДоступноИспользованиеРазделенныхДанных() 
		И ОбщегоНазначенияБПО.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
			
		МодульВнешниеКомпонентыСервер = ОбщегоНазначенияБПО.ОбщийМодуль("ВнешниеКомпонентыСервер");
		ПараметрыПодключения = МодульВнешниеКомпонентыСервер.ПараметрыПодключения();
		ПараметрыПодключения.Изолированно = Изолированно;
		
		РезультатПодключения = МодульВнешниеКомпонентыСервер.ПодключитьКомпоненту(ИмяОбъекта, , ПараметрыПодключения);
		Если РезультатПодключения.Подключено Тогда
			ВнешняяКомпонента = РезультатПодключения.ПодключаемыйМодуль;
		КонецЕсли;
			
	КонецЕсли;
	// Конец Вызов БСП
#КонецЕсли
	
	Если ВнешняяКомпонента = Неопределено Тогда 
		ВнешняяКомпонента = ВнешниеКомпонентыБПО.ПодключитьКомпонентуИзМакета(ИмяОбъекта, ПолноеИмяМакета, Изолированно);
	КонецЕсли;
	
	Возврат ВнешняяКомпонента;
	
КонецФункции

// Информация о внешней компоненте по идентификатору и версии.
//
// Параметры:
//  Идентификатор - Строка - идентификатор объекта внешней компоненты.
//  Версия - Строка - версия компоненты. 
//
// Возвращаемое значение:
//  Структура:
//      * Существует - Булево - признак отсутствия компоненты.
//      * ДоступноРедактирование - Булево - признак того, что компоненту может изменить администратор области.
//      * ОписаниеОшибки - Строка - краткое описание ошибки.
//      * Идентификатор - Строка - идентификатор объекта внешней компоненты.
//      * Версия - Строка - версия компоненты.
//      * Наименование - Строка - наименование и краткая информация о компоненте.
//
Функция ИнформацияОКомпоненте(Идентификатор, Версия = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяБСП() Тогда
		
		// Вызов БСП
		МодульВнешниеКомпонентыВызовСервера = ОбщегоНазначенияБПО.ОбщийМодуль("ВнешниеКомпонентыВызовСервера");
		Результат = МодульВнешниеКомпонентыВызовСервера.ИнформацияОКомпоненте(Идентификатор, Версия);
		// Конец Вызов БСП
		
	Иначе
		Результат = РезультатИнформацияОКомпоненте();
		Результат.Идентификатор = Идентификатор;
		Результат.Существует = Ложь;
		Результат.ОписаниеОшибки = НСтр("ru = 'Внешняя компонента не найдена'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает информацию о компоненте из файла внешней компоненты.
//
// Параметры:
//  ДвоичныеДанные - ДвоичныеДанные - двоичные данные файла компоненты.
//  ВыполнятьРазборИнфоФайла - Булево - требуется ли дополнительно анализировать
//          данные файла INFO.XML, если он есть.
//  ПараметрыПоискаДополнительнойИнформации - см. ВнешниеКомпонентыБПОКлиент.ПараметрыЗагрузки.
//
// Возвращаемое значение:
//  Структура:
//      * Разобрано - Булево - Истина, если информация о компоненте успешно извлечена.
//      * Реквизиты - см. РеквизитыКомпоненты
//      * ДвоичныеДанные - ДвоичныеДанные - выгрузка файла компоненты.
//      * ДополнительнаяИнформация - Соответствие - информация, полученная по переданным параметрам поиска.
//      * ОписаниеОшибки - Строка - текст ошибки в случае, если Разобрано = Ложь.
//
Функция ИнформацияОКомпонентеИзФайла(ДвоичныеДанные, ВыполнятьРазборИнфоФайла = Истина,
	Знач ПараметрыПоискаДополнительнойИнформации = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Разобрано", Ложь);
	Результат.Вставить("Реквизиты", Новый Структура);
	Результат.Вставить("ДвоичныеДанные", Неопределено);
	Результат.Вставить("ДополнительнаяИнформация", Новый Соответствие);
	Результат.Вставить("ОписаниеОшибки", "");
	
	Если ОбщегоНазначенияБПО.ИспользуетсяБСП() Тогда
		// Вызов БСП
		Если ОбщегоНазначенияБПО.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
			МодульВнешниеКомпонентыСлужебный = ОбщегоНазначенияБПО.ОбщийМодуль("ВнешниеКомпонентыСлужебный");
			Результат = МодульВнешниеКомпонентыСлужебный.ИнформацияОКомпонентеИзФайла(
				ДвоичныеДанные, ВыполнятьРазборИнфоФайла, ПараметрыПоискаДополнительнойИнформации);
		КонецЕсли;
		// Конец Вызов БСП
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Подключает компоненту, выполненную по технологии Native API и COM.
// Компонента должна храниться в макете конфигурации в виде ZIP-архива.
//
// Параметры:
//  Идентификатор   - Строка - идентификатор объекта внешней компоненты.
//  ПолноеИмяМакета - Строка - полное имя макета конфигурации, хранящего ZIP-архив.
//  Изолированно - ТипПодключенияВнешнейКомпоненты
//
// Возвращаемое значение:
//   Неопределено, ОбъектВнешнейКомпоненты - экземпляр объекта внешней компоненты;
//
Функция ПодключитьКомпонентуИзМакета(Знач Идентификатор, Знач ПолноеИмяМакета, Знач Изолированно = Ложь) Экспорт

	Если ОбщегоНазначенияБПО.ИспользуетсяБСП() Тогда
		
		// Вызов БСП
		ОбщегоНазначенияМодуль = ОбщегоНазначенияБПО.ОбщийМодуль("ОбщегоНазначения");
		Возврат ОбщегоНазначенияМодуль.ПодключитьКомпонентуИзМакета(Идентификатор, ПолноеИмяМакета, Изолированно);
		// Конец Вызов БСП
		
	Иначе
		ПодключаемыйМодуль = Неопределено;
		
		Если Не МакетСуществует(ПолноеИмяМакета) Тогда 
			ВызватьИсключение СтрШаблон(
				НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на сервере
				           |из %2
				           |по причине:
				           |Подключение на сервере не из макета запрещено'"),
				Идентификатор,
				ПолноеИмяМакета);
		КонецЕсли;
		
		Местоположение = ПолноеИмяМакета;
		СимволическоеИмя = Идентификатор + "SymbolicName";
		
		#Если Не МобильноеПриложениеСервер Тогда
		Результат = ПодключитьВнешнююКомпоненту(Местоположение, СимволическоеИмя, , ТипПодключенияКомпоненты(Изолированно));
		#Иначе
		Результат = ПодключитьВнешнююКомпоненту(Местоположение, СимволическоеИмя);
		#КонецЕсли
	
		Если Результат Тогда
			
			Попытка
				ПодключаемыйМодуль = Новый("AddIn." + СимволическоеИмя + "." + Идентификатор);
				Если ПодключаемыйМодуль = Неопределено Тогда 
					ВызватьИсключение НСтр("ru = 'Оператор Новый вернул Неопределено'");
				КонецЕсли;
			Исключение
				ПодключаемыйМодуль = Неопределено;
				ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;
			
			Если ПодключаемыйМодуль = Неопределено Тогда
				
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'Не удалось создать объект внешней компоненты ""%1"", подключенной на сервере
					           |из макета ""%2"",
					           |по причине:
					           |%3'"),
					Идентификатор,
					Местоположение,
					ТекстОшибки);
				ОбщегоНазначенияБПО.ЗаписатьОшибкуВЖурналРегистрации(
					НСтр("ru = 'Подключение внешней компоненты на сервере'", ОбщегоНазначенияБПО.КодОсновногоЯзыка()),
					ТекстОшибки);
			КонецЕсли;
			
		Иначе
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на сервере
				           |из макета ""%2""
				           |по причине:
				           |Платформа вернула Ложь при подключении внешней компоненты.'"),
				Идентификатор,
				Местоположение);
			ОбщегоНазначенияБПО.ЗаписатьОшибкуВЖурналРегистрации(
				НСтр("ru = 'Подключение внешней компоненты на сервере'", ОбщегоНазначенияБПО.КодОсновногоЯзыка()),
				ТекстОшибки);
		КонецЕсли;
		
		Возврат ПодключаемыйМодуль;
	КонецЕсли;
	
КонецФункции

// Изолированное подключения внешних компонент на сервере 
// Возвращаемое значение:
//  Булево - Изолированно
//
Функция ИзолированноеПодключенияВнешнихКомпонентНаСервере() Экспорт
	
	Изолированно = Ложь;
	СтандартнаяОбработка = Истина;                                                       
	ВнешниеКомпонентыБПОПереопределяемый.ИзолированноеПодключенияВнешнихКомпонентНаСервере(Изолированно, СтандартнаяОбработка);
	Результат = ?(СтандартнаяОбработка, Ложь, Изолированно); 
	Возврат Результат;
	
КонецФункции

// Изолированное подключения внешних компонент на сервере 
// Возвращаемое значение:
//  Булево - Изолированно
//
Функция ИзолированноеПодключенияВнешнихКомпонентНаКлиенте() Экспорт
	
	Изолированно = Неопределено;
	СтандартнаяОбработка = Истина;                                                       
	ВнешниеКомпонентыБПОПереопределяемый.ИзолированноеПодключенияВнешнихКомпонентНаКлиенте(Изолированно, СтандартнаяОбработка);
	Результат = ?(СтандартнаяОбработка, Неопределено, Изолированно); 
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РезультатИнформацияОКомпоненте()
	
	Результат = Новый Структура;
	Результат.Вставить("Существует", Ложь);
	Результат.Вставить("ДоступноРедактирование", Ложь);
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("Версия", "");
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ОписаниеОшибки", "");
	
	Возврат Результат;
	
КонецФункции

// Проверка существования макета по метаданным конфигурации и расширений.
//
// Параметры:
//  ПолноеИмяМакета - Строка - полное имя макета.
//
// Возвращаемое значение:
//  Булево - признак существования макета.
//
Функция МакетСуществует(ПолноеИмяМакета)
	
	Макет = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМакета);
	Если ТипЗнч(Макет) = Тип("ОбъектМетаданных") Тогда 
		
		Шаблон = Новый Структура("ТипМакета");
		ЗаполнитьЗначенияСвойств(Шаблон, Макет);
		ТипМакета = Неопределено;
		Если Шаблон.Свойство("ТипМакета", ТипМакета) Тогда 
			Возврат ТипМакета <> Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ТипПодключенияКомпоненты(Изолированно) Экспорт
	
	Если Изолированно = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	#Если Не МобильноеПриложениеСервер И Не МобильныйАвтономныйСервер Тогда
		
	Если Изолированно Тогда
		Возврат ТипПодключенияВнешнейКомпоненты.Изолированно;
	КонецЕсли;
	
	Возврат ТипПодключенияВнешнейКомпоненты.НеИзолированно;
	
	#Иначе
	
	Возврат Неопределено;
	
	#КонецЕсли
	
КонецФункции

#КонецОбласти