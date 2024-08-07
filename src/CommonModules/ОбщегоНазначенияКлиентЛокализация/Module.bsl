
#Область ПрограммныйИнтерфейс

// Выполняется перед интерактивным началом работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПередНачаломРаботыСистемы.
//
// см. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	//++ Локализация
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.Свойство("ВозможенЗапускБазовойВерсии")
	 И НЕ ПараметрыРаботыКлиента.ВозможенЗапускБазовойВерсии Тогда
		Параметры.Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Базовая версия может использоваться только в файловом однопользовательском режиме.'");
	КонецЕсли;
	

	//-- Локализация
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПриНачалеРаботыСистемы.
//
// см. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	//++ Локализация
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		#Если НЕ ВебКлиент Тогда
		Если НЕ ПараметрыРаботыКлиента.РазделениеВключено
			И ПараметрыРаботыКлиента.ЭтоГлавныйУзел Тогда
			// ИнтернетПоддержкаПользователей
			ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы(Параметры);
			// Конец ИнтернетПоддержкаПользователей
		КонецЕсли;
		#КонецЕсли
		
		
		// Маг1С
		Маг1СКлиент.ПриНачалеРаботыСистемы();
		// Конец Маг1С
		
	КонецЕсли;
	
	ПланГлобальногоПоиска = ГлобальныйПоиск.ПолучитьПлан();
	ПланГлобальногоПоиска.Добавить("ДобавитьПоискНаИТС", "ОбщегоНазначенияКлиентЛокализация", Ложь, , 95);
	ГлобальныйПоиск.УстановитьПлан(ПланГлобальногоПоиска);
	
	//-- Локализация
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// 
// см. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	//++ Локализация
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
	
		// ЭлектронноеВзаимодействие
		ЭлектронноеВзаимодействиеКлиент.ПослеНачалаРаботыСистемы();
		// Конец ЭлектронноеВзаимодействие
	
		ИнтеграцияИСМПКлиент.ПодключитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
		ИнтеграцияЗЕРНОКлиент.ПослеНачалаРаботыСистемы();
		ОбщегоНазначенияЕГАИСКлиент.ПослеНачалаРаботыСистемы();
		
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

// см. ОбщегоНазначенияКлиентПереопределяемый.ПередПериодическойОтправкойДанныхКлиентаНаСервер
Процедура ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры) Экспорт
	
	//++ Локализация
	
	ИнтеграцияЗЕРНОКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры);
	ОбщегоНазначенияЕГАИСКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры);
	
	//-- Локализация
	
КонецПроцедуры

// см. ОбщегоНазначенияКлиентПереопределяемый.ПослеПериодическогоПолученияДанныхКлиентаНаСервере
Процедура ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты) Экспорт
	
	//++ Локализация
	
	ИнтеграцияЗЕРНОКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты);
	ОбщегоНазначенияЕГАИСКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты);
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

//++ Локализация

#Область СлужебныеПроцедурыФункции

// Добавляет в результаты глобального поиска поиск на ИТС
// 
// Параметры:
//  СтрокаПоиска - Строка - Строка поиска
//  РезультатПоиска - РезультатГлобальногоПоиска - Результаты глобального поиска
//
Процедура ДобавитьПоискНаИТС(СтрокаПоиска, РезультатПоиска) Экспорт
	
	ПараметрКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();

	Конфигурация = "";
	Если ПараметрКлиента.ИмяКонфигурации = "УправлениеТорговлей" Тогда
		Конфигурация = "УТ%2011";
	ИначеЕсли ПараметрКлиента.ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда
		РазрядыВерсии = СтрРазделить(ПараметрКлиента.ВерсияКонфигурации, ".");
		Конфигурация = "КА%20" + РазрядыВерсии[0] + "." + РазрядыВерсии[1];
	ИначеЕсли ПараметрКлиента.ИмяКонфигурации = "УправлениеПредприятием" Тогда
		РазрядыВерсии = СтрРазделить(ПараметрКлиента.ВерсияКонфигурации, ".");
		Конфигурация = "ERP%20" + РазрядыВерсии[0] + "." + РазрядыВерсии[1];
	КонецЕсли;
	
	Если Конфигурация <> "" Тогда
			
		НачалоURL = "https://its.1c.ru/db/morphmerged#search:its:";
		Отбор = "?attributes[dbnick]=&attributes[conf][]=";
		КонецURL = "&attribute=conf";
		
		URL = НачалоURL + СтрокаПоиска + Отбор + Конфигурация + КонецURL;
		Результат = Новый ЭлементРезультатаГлобальногоПоиска(
							URL,
							НСтр("ru = 'Найти на сайте 1С:ИТС'"),
							БиблиотекаКартинок.ЛоготипИТС);
							
		РезультатПоиска.Добавить(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//-- Локализация