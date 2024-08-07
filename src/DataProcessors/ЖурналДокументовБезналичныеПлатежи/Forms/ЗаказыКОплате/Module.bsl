
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
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
	ИнициализироватьРеквизиты();
	УстановитьОтборДинамическихСписков();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СохранитьРабочиеЗначенияПолейФормы(Истина);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(
		ЭтотОбъект, "ЗаказыКОплате.Дата", Элементы.ЗаказыКОплатеДата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ДатаКОплате               = Настройки.Получить("ДатаКОплате");
	
	СписокОпераций            = Настройки.Получить("СписокОперацийОплаты");
	ИнициализироватьСписокОперацийОплаты();
	Если СписокОпераций <> Неопределено Тогда
		Для каждого Операция Из СписокОпераций Цикл
			Если Операция.Пометка Тогда
				ОперацияСписка = СписокОперацийОплаты.НайтиПоЗначению(Операция.Значение);
				Если ОперацияСписка <> Неопределено Тогда
					ОперацияСписка.Пометка = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	СписокОперацийОплатыПредставление = СписокОперацийПредставление(СписокОперацийОплаты);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИменаСобытийОбновленияСпискаКОплате = Новый Массив;
	ИменаСобытийОбновленияСпискаКОплате.Добавить("Запись_СписаниеБезналичныхДенежныхСредств");
	ИменаСобытийОбновленияСпискаКОплате.Добавить("Запись_РасходныйКассовыйОрдер");
	ИменаСобытийОбновленияСпискаКОплате.Добавить("Запись_ОперацияПоПлатежнойКарте");
	ИменаСобытийОбновленияСпискаКОплате.Добавить("Запись_ЗаявкаНаРасходованиеДенежныхСредств");
	ИменаСобытийОбновленияСпискаКОплате.Добавить("Запись_РаспоряжениеНаПеремещениеДенежныхСредств");
	
	Если ИменаСобытийОбновленияСпискаКОплате.Найти(ИмяСобытия) <> Неопределено Тогда
		ОбновитьИтоги();
		Элементы.ЗаказыКОплате.Обновить();
	КонецЕсли;
	
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
Процедура ДатаПлатежаПриИзменении(Элемент)
	
	ДатаПлатежаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДатаПлатежаПриИзмененииНаСервере()
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийКОплатеОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Перечисление.ХозяйственныеОперации.Форма.ФормаВыбораОперации",
		Новый Структура("СписокОпераций", СписокОперацийОплаты), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийКОплатеОтборОчистка(Элемент, СтандартнаяОбработка)
	
	СписокОперацийОплаты.ЗаполнитьПометки(Ложь);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийКОплатеОтборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		
		СписокОперацийОплаты = ВыбранноеЗначение;
	Иначе
		
		Для Каждого ЭлементСписка Из СписокОперацийОплаты Цикл
			ЭлементСписка.Пометка = (ЭлементСписка.Значение = ВыбранноеЗначение);
		КонецЦикла;
	КонецЕсли;
	
	СписокОперацийОплатыПредставление = СписокОперацийПредставление(СписокОперацийОплаты);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ВспомогательныйСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Ссылка = Элемент.ТекущиеДанные.Ссылка;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПоказатьЗначение(, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Оплатить(Команда)
	
	ДенежныеСредстваКлиент.ОплатитьСтрокиГрафика(Элементы.ЗаказыКОплате, "СписаниеБезналичныхДенежныхСредств");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗаказыКОплатеДатаПлатежа.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗаказыКОплате.ДатаПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ВидимостьЭлементов = Новый Соответствие;
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ЗаказыКОплатеВалюта");
	ВидимостьЭлементов.Вставить(МассивЭлементов, ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют"));
	
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
Процедура ИнициализироватьРеквизиты()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов") Тогда
		БанковскийСчетОтбор = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Неопределено);
	КонецЕсли;
	
	ИнициализироватьСписокОперацийОплаты();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСписокОперацийОплаты()
	
	СписокОпераций = Новый СписокЗначений;
	
	СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.РасчетыСПоставщиками);
	СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.ВозвратыКлиентам);
	СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.КредитыИлиЗаймыПолученные);
	СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.Депозиты);
	СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.ЗаймыВыданные);
	СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.Аренда);
	
	Для каждого Операция Из СписокОперацийОплаты Цикл
		Если Операция.Пометка Тогда
			ОперацияСписка = СписокОпераций.НайтиПоЗначению(Операция.Значение);
			Если ОперацияСписка <> Неопределено Тогда
				ОперацияСписка.Пометка = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СписокОперацийОплаты = СписокОпераций;
	
	Элементы.СписокОперацийКОплатеОтбор.СписокВыбора.Очистить();
	Для каждого Операция Из СписокОперацийОплаты Цикл
		Элементы.СписокОперацийКОплатеОтбор.СписокВыбора.Добавить(Операция.Значение, Операция.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	Если ЗначениеЗаполнено(БанковскийСчетОтбор) Тогда
		РеквизитыСчета = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчетОтбор);
		Организация = РеквизитыСчета.Организация;
		Если РеквизитыСчета.ЭтоГруппа Тогда
			ТекстНадписи = СтрШаблон(НСтр("ru = 'Банковские счета каталога ""%1"" по организации %2'"),
										БанковскийСчетОтбор, РеквизитыСчета.Организация);
			Элементы.НадписьБанковскийСчет.Заголовок = ТекстНадписи;
		Иначе
			Элементы.НадписьБанковскийСчет.Заголовок =
				СтрШаблон(НСтр("ru = 'Банковский счет %1, %2'"), Строка(РеквизитыСчета.Валюта), СокрЛП(БанковскийСчетОтбор));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Организация) Тогда
			СвязиПараметровВыбора = Новый Массив;
			СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация"));
			Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
		Иначе
			Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Организация) Тогда
		
		БанковскийСчетОтбор = Неопределено;
		Элементы.НадписьБанковскийСчет.Заголовок = НСтр("ru = '<Банковский счет не задан>'");
		
		СвязиПараметровВыбора = Новый Массив;
		СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация"));
		Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	Иначе
		
		Организация = Неопределено;
		Элементы.НадписьБанковскийСчет.Заголовок = НСтр("ru = '<Банковский счет не задан>'");
		Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	СписокОрганизаций = Обработки.ЖурналДокументовБезналичныеПлатежи.СвязанныеОрганизации(Организация);
	
	СписокСчетов = Новый СписокЗначений;
	
	СписокСчетовПоСчету = Справочники.БанковскиеСчетаОрганизаций.БанковскиеСчетаКаталога(БанковскийСчетОтбор);
	
	Если СписокСчетовПоСчету.Количество() <> 0 Тогда
		СписокСчетов.ЗагрузитьЗначения(СписокСчетовПоСчету);
	КонецЕсли;
	
	СписокСчетов.Добавить(БанковскийСчетОтбор);
	СписокСчетов.Добавить(Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка());
	СписокСчетов.Добавить(Неопределено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаказыКОплате,
		"Организация",
		СписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаказыКОплате,
		"БанковскийСчет",
		СписокСчетов,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ЗначениеЗаполнено(БанковскийСчетОтбор));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаказыКОплате,
		"КонтрагентПредставление",
		КонтрагентПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,,
		ЗначениеЗаполнено(КонтрагентПредставление));
		
	Граница = ?(ЗначениеЗаполнено(ДатаКОплате), КонецДня(ДатаКОплате), Дата('39990101'));
	ЗаказыКОплате.Параметры.УстановитьЗначениеПараметра("ДатаПлатежа", Граница);
	
	ОбластиПланирования = Новый Массив;
	Для каждого ЭлементСписка Из СписокОперацийОплаты Цикл
		Если ЭлементСписка.Пометка Тогда
			ОбластиПланирования.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаказыКОплате,
		"ОбластьПланирования",
		ОбластиПланирования,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ОбластиПланирования.Количество());
		
	ОбновитьИтоги();
	
	СохранитьРабочиеЗначенияПолейФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоги()
	
	ОбновитьОстаткиДенежныхСредств();
	ОбновитьКОплате();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиДенежныхСредств()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДенежныеСредстваБезналичные.СуммаОстаток        КАК ТекущийОстаток,
	|	ДенежныеСредстваБезналичные.КСписаниюОстаток    КАК КСписаниюВсего
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваБезналичные.Остатки(, БанковскийСчет = &БанковскийСчет) КАК ДенежныеСредстваБезналичные
	|";
	
	Если ЗначениеЗаполнено(БанковскийСчетОтбор) ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчетОтбор);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "БанковскийСчет = &БанковскийСчет", "Организация = &Организация");
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекущийОстаток = Выборка.ТекущийОстаток;
		КСписаниюВсего = Выборка.КСписаниюВсего;
	Иначе
		ТекущийОстаток = 0;
		КСписаниюВсего = 0;
	КонецЕсли;
	
	ДоступноВсего = ТекущийОстаток - КСписаниюВсего;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКОплате()
	
	Если Не ЗначениеЗаполнено(БанковскийСчетОтбор) Тогда
		КОплатеВсего = 0;
		ДоступноМинусКОплате = 0;
		Возврат;
	КонецЕсли;
	
	СКД = Элементы.ЗаказыКОплате.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.ЗаказыКОплате.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	Настройки.Структура.Очистить();
	
	ДетальныеЗаписи = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных("СуммаКОплате");
	ПолеИтога = ФинансоваяОтчетностьСервер.НовыйРесурс(СКД, "СуммаКОплате");
	
	РезультатСКД = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СКД, Настройки);
	КОплатеВсего = РезультатСКД[0].СуммаКОплате;
	
	ДоступноМинусКОплате = ДоступноВсего - КОплатеВсего;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокОперацийПредставление(СписокОпераций)
	
	СписокОперацийПредставление = "";
	Для Каждого ЭлементСписка Из СписокОпераций Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокОперацийПредставление = СписокОперацийПредставление
				+ ?(ЗначениеЗаполнено(СписокОперацийПредставление), ", ", "")
				+ ?(ЗначениеЗаполнено(ЭлементСписка.Представление), ЭлементСписка.Представление, ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокОперацийПредставление;
	
КонецФункции

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущийБанковскийСчет", "", ?(СохранитьНеопределено, Неопределено, БанковскийСчетОтбор));
	
КонецПроцедуры

#КонецОбласти