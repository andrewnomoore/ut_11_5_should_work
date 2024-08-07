////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьКлиент.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обновление информацию о новых документах в сервисе "1С:Бизнес-сеть".
//  См. процедуру БизнесСеть.ПодключитьОповещениеОНовыхДокументахВСервисе.
//
// Параметры:
//  Контекст   - ФормаКлиентскогоПриложения - форма, в контексте которой происходит обновление информации.
//  ИмяСобытия - Строка - имя события при оповещении формы. Необязательный.
//
Процедура ОбновитьИнформациюОНовыхДокументахВСервисе(Знач Контекст, Знач ИмяСобытия = "") Экспорт
	
	ИмяРеквизитаИспользованияПодсистемы = БизнесСетьКлиентСервер.ИмяРеквизитаИспользоватьОбменБизнесСеть();
	
	Если Не Контекст[ИмяРеквизитаИспользованияПодсистемы]
		Или (Не ПустаяСтрока(ИмяСобытия)
		И ИмяСобытия <> "ОбновитьСписокВходящихДокументов1СБизнесСеть") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаОперации      = БизнесСетьКлиентСервер.ИмяРеквизитаОперацииПодбораДокументовИзСервиса();
	ИмяРеквизитаВидаДокумента = БизнесСетьКлиентСервер.ИмяРеквизитаВидаДокументаСервиса();
	
	Если Контекст[ИмяРеквизитаОперации] = Неопределено Тогда
		
		ПараметрыОбновления = Новый Структура;
		ПараметрыОбновления.Вставить("ИдентификаторФормы", Контекст.УникальныйИдентификатор);
		ПараметрыОбновления.Вставить("ВидыДокументов",     Контекст[ИмяРеквизитаВидаДокумента].ВыгрузитьЗначения());
		
		Контекст[ИмяРеквизитаОперации] = БизнесСетьВызовСервера.ОбновитьИнформациюОНовыхДокументахВСервисеАсинхронно(
			ПараметрыОбновления);
		
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Контекст);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения      = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания            = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения               = Ложь;
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("Контекст", Контекст);
	
	ЗавершениеОбновления = Новый ОписаниеОповещения("ОбновитьИнформациюОНовыхДокументахВСервисеЗавершение",
		БизнесСетьСлужебныйКлиент, ПараметрыЗавершения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Контекст[ИмяРеквизитаОперации],
		ЗавершениеОбновления, ПараметрыОжидания);
	
	Контекст[ИмяРеквизитаОперации] = Неопределено;
	
КонецПроцедуры

// Обработчик подключаемой команды подбора новых документов из сервиса "1С:Бизнес-сеть".
//  См. процедуру БизнесСеть.ПодключитьОповещениеОНовыхДокументахВСервисе.
//
// Параметры:
//  Контекст - ФормаКлиентскогоПриложения - форма, из которой инициируется подбор.
//
Процедура ПодобратьДокументыИзСервисаБизнесСеть(Знач Контекст) Экспорт
	
	ИмяРеквизитаИспользованияПодсистемы = БизнесСетьКлиентСервер.ИмяРеквизитаИспользоватьОбменБизнесСеть();
	
	Если Не Контекст[ИмяРеквизитаИспользованияПодсистемы] Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВидДокумента", Контекст[БизнесСетьКлиентСервер.ИмяРеквизитаВидаДокументаСервиса()].ВыгрузитьЗначения());
	
	БизнесСетьСлужебныйКлиент.ОткрытьСписокДокументовОбмена("Входящие", Отбор);
	
КонецПроцедуры

#Область QRКоды

// Отправляет документ в сервис 1С:Бизнес-сеть и получает QR-коды по успешно отправленным документам.
// Результат передается в параметре оповещения:
//   * ДанныеQRКодовПоДокументам         - Соответствие - данные по QR-кодам по документам:
//      ** Ключ     - ДокументСсылка - ссылка на документ учета.
//      ** Значение - Структура      - см. БизнесСеть.НовыйДанныеQRКода.
//   * ИдентификаторыСервисаПоДокументам - Соответствие - идентификаторы документов в сервисе 1С:Бизнес-сеть:
//      ** Ключ     - ДокументСсылка - ссылка на документ учета.
//      ** Значение - Число          - идентификатор документа в сервисе 1С:Бизнес-сеть.
//
// Параметры:
//  ВладелецФормы           - ФормаКлиентскогоПриложения - владелец открываемой формы, которому будет отправлено оповещение о выборе.
//  СсылкиНаДокументы       - Массив из ЛюбаяСсылка - ссылки на документы, по которым необходимо получить данные по QR-кодам.
//  ОповещениеПриЗавершении - ОписаниеОповещения    - оповещение, которое необходимо вызвать после завершения метода.
//
Процедура ОтправитьДокументИПолучитьQRКодЧерезБизнесСеть(Знач ВладелецФормы, Знач СсылкиНаДокументы, Знач ОповещениеПриЗавершении) Экспорт
	
	ОчиститьСообщения();
	
	НесколькоДокументов = СсылкиНаДокументы.Количество() > 1;
	
	НеЗарегистрированныеОрганизации = Новый Массив();
	ДанныеДокументовНаОбработку     = Новый Массив();
	СписокДокументов                = Новый Массив();
	ПроверитьПодключениеОрганизацийКБизнесСети(СсылкиНаДокументы, НеЗарегистрированныеОрганизации, ДанныеДокументовНаОбработку, СписокДокументов);
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВладелецФормы", ВладелецФормы);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);

	Если НесколькоДокументов Тогда
		Для Каждого ЭлементОрганизация Из НеЗарегистрированныеОрганизации Цикл
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Не удалось отправить документ по причине отсутствия подключения организации %1 к сервису 1С:Бизнес-сеть.'"), ЭлементОрганизация));
		КонецЦикла;
	ИначеЕсли ЗначениеЗаполнено(НеЗарегистрированныеОрганизации) Тогда
		
		ДанныеДокумента = БизнесСетьКлиентСервер.ДанныеДокументаДляПолученияQRКода(СсылкиНаДокументы[0], НеЗарегистрированныеОрганизации[0]);
		ДанныеДокументовНаОбработку.Добавить(ДанныеДокумента);
		
		СписокДокументов.Добавить(СсылкиНаДокументы[0]);
		
		ДополнительныеПараметры.Вставить("ДокументыНаОбработку", ДанныеДокументовНаОбработку);
		ДополнительныеПараметры.Вставить("СписокДокументов", СписокДокументов);
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьФормуПодключенияОрганизацииПродолжение", ЭтотОбъект, ДополнительныеПараметры);
		БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(НеЗарегистрированныеОрганизации[0], ЭтотОбъект, Оповещение);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеДокументовНаОбработку) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ДокументыНаОбработку", ДанныеДокументовНаОбработку);
	ДополнительныеПараметры.Вставить("СписокДокументов", СписокДокументов);
	
	ОтправитьДокументИПолучитьQRКодЧерезБизнесСетьПродолжение(ДополнительныеПараметры);

КонецПроцедуры

// Получает QR-коды по отправленным документам в сервис 1С:Бизнес-сеть, по которым публичные временные ссылки активны.
// Активными QR-коды считываются, если с момента отправки документа в сервис 1С:Бизнес-сеть
// не истек срок 3 месяца или после отправки документа документ просматривали через поиск по QR-коду.
// Если организация не подключена в документе к сервису 1С:Бизнес-сеть - выполняться поиск QR-кода по документу не будет.
// Метод выполняется в фоне.
// Результат передается в параметре оповещения:
//   * ДанныеQRКодовПоДокументам - Соответствие - данные по QR-кодам по документам:
//      ** Ключ     - ДокументСсылка - ссылка на документ учета.
//      ** Значение - Структура      - см. БизнесСеть.НовыйДанныеQRКода.
//
// Параметры:
//  ВладелецФормы           - ФормаКлиентскогоПриложения - владелец открываемой формы, которому будет отправлено оповещение о выборе.
//  СсылкиНаДокументы       - Массив из ЛюбаяСсылка - ссылки на документы, по которым необходимо получить данные по QR-кодам.
//  ОповещениеПриЗавершении - ОписаниеОповещения    - оповещение, которое необходимо вызвать после завершения метода.
//
Процедура ПолучитьQRКодыПоДокументам(Знач ВладелецФормы, Знач СсылкиНаДокументы, Знач ОповещениеПриЗавершении) Экспорт
	
	ОчиститьСообщения();
	
	НеЗарегистрированныеОрганизации = Новый Массив();
	ДокументыНаОбработку            = Новый Массив();
	ПроверитьПодключениеОрганизацийКБизнесСети(СсылкиНаДокументы, НеЗарегистрированныеОрганизации, ДокументыНаОбработку);
		
	Если Не ЗначениеЗаполнено(ДокументыНаОбработку) Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Новый Структура("ДанныеQRКодовПоДокументам"));
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = БизнесСетьВызовСервера.ПолучениеQRКодовПоДокументамВФоне(Новый УникальныйИдентификатор,
																					ДокументыНаОбработку);

	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ВладелецФормы);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения      = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания            = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения               = Ложь;
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
		
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("ПолучитьQRКодыДляДокументовЗавершение",
		ЭтотОбъект, ДополнительныеПараметры);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ДлительнаяОперацияЗавершение, ПараметрыОжидания);
	
КонецПроцедуры

// Открывает форму поиска документа по QR-коду через сервис 1С:Бизнес-сеть.
//
Процедура ОткрытьФормуПоискаДокументаПоQRКоду() Экспорт
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПоискДокументаПоQRКоду", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ТребуетсяПовторноеПодключениеОрганизации(Организация) Экспорт
	
	Возврат БизнесСетьВызовСервера.ТребуетсяПовторноеПодключениеОрганизации(Организация);
	
КонецФункции

Процедура ПолучитьПредставлениеДокументаСервиса(Знач Идентификатор,
												Знач ПредставлениеДокумента,
												Знач Организация,
												Знач РежимИсходящихДокументов,
												Знач УникальныйИдентификатор) Экспорт
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторыДокументов = Новый Массив;
	ИдентификаторыДокументов.Добавить(Идентификатор);
	ДанныеДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(
		Организация, ИдентификаторыДокументов, Не РежимИсходящихДокументов, УникальныйИдентификатор, Истина);
	
	Если Не ЗначениеЗаполнено(ДанныеДокументов) Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФайлПредставленияДокумента(ДанныеДокументов[0], ПредставлениеДокумента);
		
КонецПроцедуры

Процедура ОткрытьФайлПредставленияДокумента(АдресХранилищаПредставления, ПредставлениеДокумента) Экспорт
	
	// Открытие файла.
	ДанныеФайла = Новый Структура;
	ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",  АдресХранилищаПредставления);
	ДанныеФайла.Вставить("ДатаМодификацииУниверсальная", ОбщегоНазначенияКлиент.ДатаСеанса());
	ДанныеФайла.Вставить("ОтносительныйПуть", "");
	ДанныеФайла.Вставить("ИмяФайла",          ПредставлениеДокумента + ".pdf");
	ДанныеФайла.Вставить("Наименование",      ПредставлениеДокумента);
	ДанныеФайла.Вставить("Расширение",        "pdf");
	ДанныеФайла.Вставить("ДляРедактирования", Ложь);
	ДанныеФайла.Вставить("Редактирует",       Неопределено);
	ДанныеФайла.Вставить("Версия",            ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
	ДанныеФайла.Вставить("ТекущаяВерсия",     ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
	ДанныеФайла.Вставить("ХранитьВерсии",     Ложь);
	ДанныеФайла.Вставить("РабочийКаталогВладельца",        "");
	ДанныеФайла.Вставить("ПолноеИмяФайлаВРабочемКаталоге", "");
	ДанныеФайла.Вставить("ВРабочемКаталогеНаЧтение",       Ложь);
	ДанныеФайла.Вставить("ПолноеНаименованиеВерсии",       "");
	ДанныеФайла.Вставить("НаЧтение",   Истина);
	ДанныеФайла.Вставить("Зашифрован", Ложь);
	ДанныеФайла.Вставить("Размер",     РазмерФайла(АдресХранилищаПредставления));
	ДанныеФайла.Вставить("Ссылка",     ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);

КонецПроцедуры

Процедура ОтправитьУведомлениеОбОтправкиДокументаВСервис(Знач ВладелецФормы, Знач УникальныйИдентификатор,
				Знач ПараметрыМетода, Знач ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ДлительнаяОперация = БизнесСетьВызовСервера.ОтправкаУведомленияОбВыгрузкиДокумента(УникальныйИдентификатор,
																						ПараметрыМетода);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ВладелецФормы);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Если ОповещениеПриЗавершении <> Неопределено Тогда
		ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
		ОповещениеПриЗавершении.ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеПриЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

// Организация не подключена или трубуется повторное подключение.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - проверяемая организация.
// 
// Возвращаемое значение:
//  Булево - требуется подключение.
//
Функция ОрганизацияНеПодключенаТребуетсяПовторноеПодключение(Организация) Экспорт
	Возврат БизнесСетьВызовСервера.ОрганизацияНеПодключенаТребуетсяПовторноеПодключение(Организация);
КонецФункции

// Открывает форму подключения организации к Бизнес-сети.
//
// Параметры:
//  Организация					 - ОпределяемыйТип.Организация - подключаемая организация.
//  Владелец					 - ФормаКлиентскогоПриложения - владелец формы.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения - описание оповещения о закрытии формы.
//
Процедура ОткрытьФормуПодключенияОрганизации(Организация, 
			Владелец = Неопределено, 
			ОписаниеОповещенияОЗакрытии = Неопределено)  Экспорт
	
	БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(Организация, Владелец, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Открытие форму подключения организации после проверки подключения.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - подключаемая Организация.
//  Владелец - Неопределено - Владелец формы.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - оповещение которое будет открыто после закрытия открываемой формы.
//  Результат - Булево - признак необходимости подключения организации.
//
Процедура ОткрытьФормуПодключенияОрганизацииСПроверкойПодключения(
	Организация, Владелец = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено, Результат = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОрганизацияНеПодключенаТребуетсяПовторноеПодключение(Организация) Тогда
		Результат = Истина;
		ОткрытьФормуПодключенияОрганизации(
			Организация, Владелец, ОписаниеОповещенияОЗакрытии);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Открывает полученный документ из сервиса 1С:Бизнес-сеть по публичной временной ссылке из QR-кода.
//
// Параметры:
//  ВладелецФормы           - ФормаКлиентскогоПриложения - владелец открываемой формы, которому будет отправлено оповещение о выборе.
//  УникальныйИдентификатор - УникальныйИдентификатор    - уникальный идентификатор.
//  ПубличнаяСсылкаQRкода   - Строка                     - сокращенная публичная ссылка.
//  ОписаниеПриЗавершении   - ОписаниеОповещения         - оповещение, которое необходимо вызвать после завершения метода. 
//
Процедура ПолучитьДанныеДокументаПоQRКоду(Знач ВладелецФормы, Знач УникальныйИдентификатор, Знач ПубличнаяСсылкаQRкода,
											Знач ОписаниеПриЗавершении = Неопределено) Экспорт
	
	АдресРесурса = СтрЗаменить(ПубличнаяСсылкаQRкода, "https://1c.ru/m/", "");
	
	ДлительнаяОперация = БизнесСетьВызовСервера.ПолучитьДанныеДокументаПоQRКодуВФоне(УникальныйИдентификатор, АдресРесурса);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ВладелецФормы);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения    = Истина;
		
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеПриЗавершении, ПараметрыОжидания);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область QRКоды

Процедура ПроверитьПодключениеОрганизацийКБизнесСети(Знач СсылкиНаДокументы, НеЗарегистрированныеОрганизации, ДокументыНаОбработку, СписокДокументов = Неопределено)
	
	БизнесСетьВызовСервера.ПроверитьПодключениеОрганизацийКБизнесСети(СсылкиНаДокументы, НеЗарегистрированныеОрганизации,
		ДокументыНаОбработку, СписокДокументов);
	
КонецПроцедуры

Процедура ОткрытьФормуПодключенияОрганизацииПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Или ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("СтатусПодключения") И Результат.СтатусПодключения = "Подключена" Тогда
		ОтправитьДокументИПолучитьQRКодЧерезБизнесСетьПродолжение(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьДокументИПолучитьQRКодЧерезБизнесСетьПродолжение(ДополнительныеПараметры)

	ДлительнаяОперация = БизнесСетьВызовСервера.ОтправлениеИПолучениеQRКодовЧерезБизнесСетьВФоне(Новый УникальныйИдентификатор,
																								ДополнительныеПараметры.СписокДокументов);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ДополнительныеПараметры.ВладелецФормы);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения      = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания            = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
	ПараметрыОжидания.ВыводитьСообщения               = Истина;
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
		
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("ОтправитьДокументИПолучитьQRКодЧерезБизнесСетьЗавершение",
		ЭтотОбъект, ДополнительныеПараметры);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ДлительнаяОперацияЗавершение, ПараметрыОжидания);

КонецПроцедуры

Функция ДанныеРезультатаДлительнойОперацииПоQRКодам(Результат)
	
	Если Результат = Неопределено Или ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Результат.Свойство("Статус") И Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для Каждого Сообщение Из Результат.Сообщения Цикл
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
КонецФункции

Процедура ОтправитьДокументИПолучитьQRКодЧерезБизнесСетьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеРезультата          = ДанныеРезультатаДлительнойОперацииПоQRКодам(Результат);
	ДанныеQRКодовПоДокументам = Неопределено;
	
	Если ДанныеРезультата <> Неопределено Тогда
		ДанныеРезультата.Свойство("ДанныеQRКодовПоДокументам", ДанныеQRКодовПоДокументам);
		
		Если ДанныеРезультата.Свойство("Ошибки") И ДанныеРезультата.Ошибки.Количество() Тогда
			
			Для Каждого ТекстОшибки Из ДанныеРезультата.Ошибки Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
			КонецЦикла;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеРезультата = Неопределено
		Или ДанныеQRКодовПоДокументам = Неопределено Тогда
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеРезультата);
		Возврат;
	КонецЕсли;
	
	ТекстОповещения = НСтр("ru = 'Отправка выполнена.'");
	ТекстПояснения  = НСтр("ru = 'Отправлен документ через сервис 1С:Бизнес-сеть.'");
	КартинкаБизнесСеть = БиблиотекаКартинок.БизнесСеть;
	
	Для Каждого СсылкаНаДокумент Из ДанныеРезультата.ИдентификаторыСервисаПоДокументам Цикл
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(СсылкаНаДокумент.Ключ),
			ТекстПояснения, КартинкаБизнесСеть);
	КонецЦикла;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеРезультата);
	
КонецПроцедуры

Процедура ПолучитьQRКодыДляДокументовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеРезультата = ДанныеРезультатаДлительнойОперацииПоQRКодам(Результат);
	
	Если ДанныеРезультата = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении,
								Новый Структура("ДанныеQRКодовПоДокументам", ДанныеРезультата));
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция РазмерФайла(АдресХранилища)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ДвоичныеДанные = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат ДвоичныеДанные.Размер();
	
КонецФункции

Процедура ПередЗакрытиемФормы(
	Форма, ПрограммноеЗакрытие, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка) Экспорт
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПрограммноеЗакрытие И Форма.Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОСохраненииИзмененныхДанных", Форма);
		
		ТекстВопроса = НСтр("ru = 'Данные модифицированы. Сохранить изменения?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

