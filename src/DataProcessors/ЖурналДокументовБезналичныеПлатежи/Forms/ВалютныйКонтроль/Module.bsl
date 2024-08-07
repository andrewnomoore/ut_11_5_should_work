
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.СтруктураБыстрогоОтбора) = Тип("Структура") Тогда
		СтруктураБыстрогоОтбора = Новый Структура;
		СтруктураБыстрогоОтбора.Вставить("Организация",             Справочники.Организации.ПустаяСсылка());
		СтруктураБыстрогоОтбора.Вставить("БанковскийСчетОтбор",     Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка());
		СтруктураБыстрогоОтбора.Вставить("КонтрагентПредставление", "");
		ЗаполнитьЗначенияСвойств(СтруктураБыстрогоОтбора, Параметры.СтруктураБыстрогоОтбора);
	
		Организация             = СтруктураБыстрогоОтбора.Организация;
		БанковскийСчетОтбор     = СтруктураБыстрогоОтбора.БанковскийСчетОтбор;
		КонтрагентПредставление = СтруктураБыстрогоОтбора.КонтрагентПредставление;
		
		Если ЗначениеЗаполнено(Организация) Тогда
			ОрганизацияПриИзмененииСервер(Ложь);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВидимость();
	УстановитьОтборДинамическихСписков();
	СохранитьРабочиеЗначенияПолейФормы(Истина);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ИспользуемыеТипыДокументов = Новый Массив;
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.СправкаОПодтверждающихДокументах"));
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ДокументыВалютногоКонтроляКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(
		ЭтотОбъект, "ДокументыВалютногоКонтроля.Дата", Элементы.ДокументыВалютногоКонтроляДата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ПараметрыСозданияФормыСпискаСП = ОбменСБанкамиКлиентСервер.ПараметрыСозданияФормыСписка();
	ПараметрыСозданияФормыСпискаСП.СписокДокументов.ИмяЭлемента = "ДокументыВалютногоКонтроля";
	
	ОбменСБанкамиКлиент.ОбработатьОповещениеФормыСписка(ЭтотОбъект, ИмяСобытия, Параметр, Источник, ПараметрыСозданияФормыСпискаСП);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер(ИзменитьОтбор = Истина)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов") Тогда
		БанковскийСчетОтбор = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ИзменитьОтбор Тогда
		УстановитьОтборДинамическихСписков();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетОтборПриИзменении(Элемент)
	
	БанковскийСчетОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура БанковскийСчетОтборПриИзмененииСервер()
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОтборПриИзменении(Элемент)
	
	КонтрагентОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентОтборПриИзмененииСервер()
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыВалютногоКонтроляПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыВалютногоКонтроляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанкамиКлиент.ПриВыбореСтрокиИзСпискаДокументов(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтборДиректБанкНажатие(Элемент)
	
	ОтборДиректБанкНажатиеНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ОтборДиректБанкНажатиеНаСервере(ИмяЭлемента)
	
	ОтборСостоянияДиректБанк.Очистить();
	
	Если ИмяЭлемента = "НадписьДиректБанкНеОтправлен" Тогда
		ОтборСостоянияДиректБанк.Добавить(Перечисления.СостоянияОбменСБанками.НеСформирован);
		ОтборСостоянияДиректБанк.Добавить(Перечисления.СостоянияОбменСБанками.НаПодписи);
		ОтборСостоянияДиректБанк.Добавить(Перечисления.СостоянияОбменСБанками.ТребуетсяОтправка);
		ОтборСостоянияДиректБанк.Добавить(Неопределено);
	ИначеЕсли ИмяЭлемента = "НадписьДиректБанкСОшибкой" Тогда
		ОтборСостоянияДиректБанк.Добавить(Перечисления.СостоянияОбменСБанками.Отклонен);
	ИначеЕсли ИмяЭлемента = "НадписьДиректБанкОбрабатываетсяБанком" Тогда
		ОтборСостоянияДиректБанк.Добавить(Перечисления.СостоянияОбменСБанками.ОжидаетсяИзвещениеОПолучении);
		ОтборСостоянияДиректБанк.Добавить(Перечисления.СостоянияОбменСБанками.ОжидаетсяИсполнение);
	ИначеЕсли ИмяЭлемента = "НадписьДиректБанкПодтвержден" Тогда
		ОтборСостоянияДиректБанк.Добавить(Перечисления.СостоянияОбменСБанками.ПлатежИсполнен);
	КонецЕсли;
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСПД(Команда)
	
	ОткрытьФорму("Документ.СправкаОПодтверждающихДокументах.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСПДПомощник(Команда)
	
	ОткрытьФорму("Документ.СправкаОПодтверждающихДокументах.Форма.ПомощникСоздания");
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСБанками

&НаКлиенте
Процедура Подключаемый_ВыполнитьСинхронизациюДиректБанк(Команда)
	
	Если ЗначениеЗаполнено(БанковскийСчетОтбор) Тогда
		ПараметрыБанковскогоСчета = ПараметрыБанковскогоСчета(БанковскийСчетОтбор);
		ОбменСБанкамиКлиент.СинхронизироватьСБанком(ПараметрыБанковскогоСчета.Владелец, ПараметрыБанковскогоСчета.Банк);
	Иначе
		ОбменСБанкамиКлиент.СинхронизироватьСБанком();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьСобытиеДиректБанк(
	Параметр1 = Неопределено,
	Параметр2 = Неопределено,
	Параметр3 = Неопределено)
	
	ОбменСБанкамиКлиент.ОбработатьСобытиеНаФормеСписка(Параметр1, Параметр2, Параметр3)
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСБанками

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ДокументыВалютногоКонтроля);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ДокументыВалютногоКонтроля, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ДокументыВалютногоКонтроля);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимость()
	
	ВидимостьЭлементов = Новый Соответствие;
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("БанковскийСчетОтбор");
	ВидимостьЭлементов.Вставить(МассивЭлементов, ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов"));
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ОрганизацияОтбор");
	ВидимостьЭлементов.Вставить(МассивЭлементов, ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"));
	
	Для каждого ЭлементСоответствия Из ВидимостьЭлементов Цикл
		Для каждого ИмяЭлемента Из ЭлементСоответствия.Ключ Цикл
			Элементы[ИмяЭлемента].Видимость = ЭлементСоответствия.Значение;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	Если ЗначениеЗаполнено(БанковскийСчетОтбор) Тогда
		РеквизитыСчета = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчетОтбор);
		Организация = РеквизитыСчета.Организация;
		ВалютаСчета = РеквизитыСчета.Валюта;
		Банк        = РеквизитыСчета.Банк;
		
		Если ЗначениеЗаполнено(Организация) Тогда
			СвязиПараметровВыбора = Новый Массив;
			СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация"));
			Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
		Иначе
			Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Организация) Тогда
		
		РеквизитыОрганизации = Справочники.Организации.ПолучитьРеквизитыОрганизации(Организация);
		БанковскийСчетОтбор = Неопределено;
		ВалютаСчета         = Неопределено;
		Банк                = Неопределено;
		
		СвязиПараметровВыбора = Новый Массив;
		СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация"));
		Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	Иначе
		
		Организация = Неопределено;
		ВалютаСчета = Неопределено;
		Банк        = Неопределено;
		Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	СписокОрганизаций = Обработки.ЖурналДокументовБезналичныеПлатежи.СвязанныеОрганизации(Организация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДокументыВалютногоКонтроля,
		"Банк",
		Банк,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Банк));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДокументыВалютногоКонтроля,
		"Организация",
		СписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДокументыВалютногоКонтроля,
		"КонтрагентПредставление",
		КонтрагентПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,,
		ЗначениеЗаполнено(КонтрагентПредставление));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДокументыВалютногоКонтроля,
		"Состояние",
		ОтборСостоянияДиректБанк,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ОтборСостоянияДиректБанк.Количество());
	
	ОбновитьНадписиОтборовВалютногоКонтроля();
	
	СохранитьРабочиеЗначенияПолейФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписиОтборовВалютногоКонтроля()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Элементы.НадписьДиректБанкНеОтправлен.Гиперссылка                  = (ОтборСостоянияДиректБанк.НайтиПоЗначению(Перечисления.СостоянияОбменСБанками.НеСформирован) = Неопределено);
	Элементы.НадписьДиректБанкСОшибкой.Гиперссылка                     = (ОтборСостоянияДиректБанк.НайтиПоЗначению(Перечисления.СостоянияОбменСБанками.Отклонен) = Неопределено);
	Элементы.НадписьДиректБанкОбрабатываетсяБанком.Гиперссылка         = (ОтборСостоянияДиректБанк.НайтиПоЗначению(Перечисления.СостоянияОбменСБанками.ОжидаетсяИсполнение) = Неопределено);
	Элементы.НадписьДиректБанкПодтвержден.Гиперссылка                  = (ОтборСостоянияДиректБанк.НайтиПоЗначению(Перечисления.СостоянияОбменСБанками.ПлатежИсполнен) = Неопределено);
	
	Если ОтборСостоянияДиректБанк.Количество() Тогда
		Элементы.НадписьДиректБанкПоказатьВсе.Гиперссылка = Истина;
		Элементы.НадписьДиректБанкПоказатьВсе.ЦветТекста = ЦветаСтиля.ГиперссылкаЦвет;
	Иначе
		Элементы.НадписьДиректБанкПоказатьВсе.Гиперссылка = Ложь;
		Элементы.НадписьДиректБанкПоказатьВсе.ЦветТекста = ЦветаСтиля.ЦветТекстаПоля;
	КонецЕсли;
	
	Если Не Элементы.НадписьДиректБанкНеОтправлен.Гиперссылка Тогда
		Элементы.ДокументыВалютногоКонтроля.Заголовок = НСтр("ru = 'Документы валютного контроля, не отправленные в банк'");
	ИначеЕсли Не Элементы.НадписьДиректБанкСОшибкой.Гиперссылка Тогда
		Элементы.ДокументыВалютногоКонтроля.Заголовок = НСтр("ru = 'Документы валютного контроля с ошибкой отправки в банк'");
	ИначеЕсли Не Элементы.НадписьДиректБанкОбрабатываетсяБанком.Гиперссылка Тогда
		Элементы.ДокументыВалютногоКонтроля.Заголовок = НСтр("ru = 'Документы валютного контроля в процессе обработки банком'");
	ИначеЕсли Не Элементы.НадписьДиректБанкПодтвержден.Гиперссылка Тогда
		Элементы.ДокументыВалютногоКонтроля.Заголовок = НСтр("ru = 'Документы валютного контроля, подтвержденные банком'");
	ИначеЕсли Не Элементы.НадписьДиректБанкПоказатьВсе.Гиперссылка Тогда
		Элементы.ДокументыВалютногоКонтроля.Заголовок = НСтр("ru = 'Документы валютного контроля'");
	КонецЕсли;
	
	СКД = Элементы.ДокументыВалютногоКонтроля.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.ДокументыВалютногоКонтроля.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Настройки.Отбор, "Состояние",,, ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, Настройки);
	
	ЗапросСписка = Новый СхемаЗапроса;
	ЗапросСписка.УстановитьТекстЗапроса(МакетКомпоновки.НаборыДанных.НаборДанныхДинамическогоСписка.Запрос);
	
	Пакет = ЗапросСписка.ПакетЗапросов[0];
	
	ВыбираемыеПоля = Пакет.Операторы[0].ВыбираемыеПоля;
	ВыбираемыеПоля.Очистить();
	
	ШаблонПоляСостояние = "
	|ЕСТЬNULL(СУММА(ВЫБОР
	|		КОГДА ЕСТЬNULL(СостоянияОбменСБанками.Состояние, НЕОПРЕДЕЛЕНО) В %1
	|		ТОГДА 1
	|		ИНАЧЕ 0
	|		КОНЕЦ), 0)
	|";
	
	ВыбираемыеПоля.Добавить(СтрШаблон(ШаблонПоляСостояние,
		"(ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.НеСформирован),
		|ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.НаПодписи),
		|ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.ТребуетсяОтправка),
		|НЕОПРЕДЕЛЕНО)"));
	ВыбираемыеПоля.Добавить(СтрШаблон(ШаблонПоляСостояние,
		"(ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.Отклонен))"));
	ВыбираемыеПоля.Добавить(СтрШаблон(ШаблонПоляСостояние,
		"(ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.ОжидаетсяИзвещениеОПолучении),
		|ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.ОжидаетсяИсполнение))"));
	ВыбираемыеПоля.Добавить(СтрШаблон(ШаблонПоляСостояние,
		"(ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.ПлатежИсполнен))"));
	
	Пакет.Колонки[0].Псевдоним = "КоличествоНеОтправлен";
	Пакет.Колонки[1].Псевдоним = "КоличествоСОшибкой";
	Пакет.Колонки[2].Псевдоним = "КоличествоОбрабатываетсяБанком";
	Пакет.Колонки[3].Псевдоним = "КоличествоПодтвержден";
	
	Запрос = Новый Запрос(ЗапросСписка.ПолучитьТекстЗапроса());
	Для каждого ПараметрМакета Из МакетКомпоновки.ЗначенияПараметров Цикл
		Запрос.УстановитьПараметр(ПараметрМакета.Имя, ПараметрМакета.Значение);
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Элементы.НадписьДиректБанкНеОтправлен.Заголовок =
		СтрШаблон(НСтр("ru = 'Не отправлен (%1)'"), Выборка.КоличествоНеОтправлен);
	Элементы.НадписьДиректБанкСОшибкой.Заголовок =
		СтрШаблон(НСтр("ru = 'С ошибкой отправки (%1)'"), Выборка.КоличествоСОшибкой);
	Элементы.НадписьДиректБанкОбрабатываетсяБанком.Заголовок =
		СтрШаблон(НСтр("ru = 'Обрабатывается банком (%1)'"), Выборка.КоличествоОбрабатываетсяБанком);
	Элементы.НадписьДиректБанкПодтвержден.Заголовок =
		СтрШаблон(НСтр("ru = 'Подтвержден банком (%1)'"), Выборка.КоличествоПодтвержден);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыБанковскогоСчета(БанковскийСчет)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БанковскийСчет, "Владелец, Банк");
	
КонецФункции

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущийБанковскийСчет", "", ?(СохранитьНеопределено, Неопределено, БанковскийСчетОтбор));
	
КонецПроцедуры

#КонецОбласти