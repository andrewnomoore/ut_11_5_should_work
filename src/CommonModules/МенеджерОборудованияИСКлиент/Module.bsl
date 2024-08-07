#Область СлужебныйПрограммныйИнтерфейс

#Область RFID

// Заполняет структуру параметров записи метки RFID.
// 
// Возвращаемое значение:
//  Структура.
//
Функция ПараметрыЗаписиМеткиRFID() Экспорт; 
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаСчитывательRFID() Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеСчитывательRFIDКлиент");
	Иначе
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
	КонецЕсли;
	Возврат Модуль.ПараметрыЗаписиМеткиRFID();
	
КонецФункции

// Начать открытие сессии считывателя RFID.
//
Процедура НачатьОткрытиеСессииСчитывателяRFID(ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаСчитывательRFID() Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеСчитывательRFIDКлиент");
	Иначе
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
	КонецЕсли;
	
	Модуль.НачатьОткрытиеСессииСчитывателяRFID(
		ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства);
	
КонецПроцедуры

// Начать закрытие сессии считывателя RFID.
//
Процедура НачатьЗакрытиеСессииСчитывателяRFID(ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаСчитывательRFID() Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеСчитывательRFIDКлиент");
	Иначе
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
	КонецЕсли;
	
	Модуль.НачатьЗакрытиеСессииСчитывателяRFID(
		ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства);
	
КонецПроцедуры

// Начать запись данных в метку RFID.
Процедура НачатьЗаписьДанныхВМеткуRFID(ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства, ПараметрыЗаписи, ДополнительныеПараметры = Неопределено) Экспорт 
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаСчитывательRFID() Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеСчитывательRFIDКлиент");
		Модуль.НачатьЗаписьДанныхВМеткуRFID(
			ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства, ПараметрыЗаписи, ДополнительныеПараметры);
	Иначе
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		Модуль.НачатьЗаписьДанныхВМеткуRFID(
			ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства, ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ТСД

// Начать загрузку данных из терминала сбора данных.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьЗагрузкуДанныеИзТСД(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства = Неопределено, ПараметрыОперации = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаТерминалыСбораДанных() Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеТерминалыСбораДанныхКлиент");
		Модуль.НачатьЗагрузкуДанныеИзТСД( 
			ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперации, ДополнительныеПараметры);
	Иначе
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		Модуль.НачатьЗагрузкуДанныеИзТСД(
			ОповещениеПриЗавершении, ИдентификаторКлиента);
	КонецЕсли;
	
КонецПроцедуры

// Начать выгрузку данных в терминал сбора данных.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//                           - Произвольный - данные операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьВыгрузкуДанныеВТСД(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперации, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаТерминалыСбораДанных() Тогда
		МодульОборудованиеТерминалыСбораДанныхКлиент       = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеТерминалыСбораДанныхКлиент");
		МодульОборудованиеТерминалыСбораДанныхКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеТерминалыСбораДанныхКлиентСервер");
		ПараметрыОперацииТСД = МодульОборудованиеТерминалыСбораДанныхКлиентСервер.ПараметрыВыгрузкиВТСД();
		ПараметрыОперацииТСД.ТаблицаТоваров    = ПараметрыОперации;
		ПараметрыОперацииТСД.ЧастичнаяВыгрузка = Ложь;
		МодульОборудованиеТерминалыСбораДанныхКлиент.НачатьВыгрузкуДанныеВТСД( 
			ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперацииТСД, ДополнительныеПараметры);
	Иначе
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		Модуль.НачатьВыгрузкуДанныеВТСД(
			ОповещениеПриЗавершении, ИдентификаторКлиента, ПараметрыОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЭлектронныеВесы

// Получает вес с электронных весов.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьПолученияВесаСЭлектронныхВесов(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства = Неопределено, ПараметрыОперации = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаВесовоеОборудование() Тогда
		МодульОборудованиеВесовоеОборудованиеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеВесовоеОборудованиеКлиент");
		МодульОборудованиеВесовоеОборудованиеКлиент.НачатьПолученияВесаСЭлектронныхВесов(
			ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперации, ДополнительныеПараметры);
	Иначе
		МенеджерОборудованияКлиент.НачатьПолученияВесаСЭлектронныхВесов(
			ОповещениеПриЗавершении,
			ИдентификаторКлиента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ККТ

// Осуществляет запрос КМ.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - обработчик результата.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор формы.
//  Параметры - Структура - Содержит параметры выполнения операции.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Устройство.
//
Процедура НачатьЗапросКМ(ОповещениеПриЗавершении, УникальныйИдентификатор, Параметры, ИдентификаторУстройства = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаЧекопечатающиеУстройства() Тогда
		МодульМенеджерОборудованияКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
		МодульОборудованиеЧекопечатающиеУстройстваКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиент");
		МодульОборудованиеЧекопечатающиеУстройстваКлиент.НачатьЗапросКМ(
			ОповещениеПриЗавершении,
			УникальныйИдентификатор,
			ИдентификаторУстройства,
			Параметры,
			МодульМенеджерОборудованияКлиентСервер.ДополнительныеПараметрыОперации(Истина));
	Иначе
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьЗапросКМ(
			ОповещениеПриЗавершении,
			УникальныйИдентификатор,
			Параметры,
			ИдентификаторУстройства);
	КонецЕсли;
	
КонецПроцедуры

// Начать получения результатов запроса КМ.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - обработчик результата.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор формы.
//  Параметры - Структура - Содержит параметры выполнения операции.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Устройство.
//
Процедура НачатьПолученияРезультатовЗапросаКМ(ОповещениеПриЗавершении, УникальныйИдентификатор, Параметры, ИдентификаторУстройства = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройстваКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиент");
		МодульОборудованиеЧекопечатающиеУстройстваКлиент.НачатьПолученияРезультатовЗапросаКМ(
			ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства, Параметры);
	Иначе
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьПолученияРезультатовЗапросаКМ(
			ОповещениеПриЗавершении,
			УникальныйИдентификатор,
			Параметры,
			ИдентификаторУстройства);
	КонецЕсли;
	
КонецПроцедуры

// Начать подтверждение КМ.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - обработчик результата.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор формы.
//  Параметры - Структура - Содержит параметры выполнения операции.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Устройство.
//
Процедура НачатьПодтверждениеКМ(ОповещениеПриЗавершении, УникальныйИдентификатор, Параметры, ИдентификаторУстройства = Неопределено) Экспорт
	
	Если МенеджерОборудованияИСКлиентПовтИсп.ИспользуетсяПодсистемаЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройстваКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиент");
		МодульОборудованиеЧекопечатающиеУстройстваКлиент.НачатьПодтверждениеКМ(
			ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства, Параметры);
	Иначе
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьПодтверждениеКМ(
			ОповещениеПриЗавершении,
			УникальныйИдентификатор,
			Параметры,
			ИдентификаторУстройства);
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает идентификатор открытой сессии для фискального устройства.
// 
// Параметры:
//  ИдентификаторУстройства - УникальныйИдентификатор - Идентификатор устройства
// 
// Возвращаемое значение:
//  Неопределено - Сессия проверки кодов маркировки
Функция СессияПроверкиКодовМаркировки(ИдентификаторУстройства) Экспорт
	
	Возврат МенеджерОборудованияКлиент.СессияПроверкиКодовМаркировки(ИдентификаторУстройства);
	
КонецФункции

// Результат проверки кода маркировки.
// 
// Параметры:
//  ИдентификаторУстройства - УникальныйИдентификатор - Идентификатор устройства
//  ИдентификаторСессии - УникальныйИдентификатор - Идентификатор сессии
//  ПараметрыЗапросаКМ -Структура - Параметры запроса КМ.
// 
// Возвращаемое значение:
//  Неопределено - Результат проверки кода маркировки
Функция РезультатПроверкиКодаМаркировки(ИдентификаторУстройства, ИдентификаторСессии, ПараметрыЗапросаКМ) Экспорт
	
	Возврат МенеджерОборудованияКлиент.РезультатПроверкиКодаМаркировки(
		ИдентификаторУстройства,
		ИдентификаторСессии,
		ПараметрыЗапросаКМ);
	
КонецФункции

#КонецОбласти

#КонецОбласти