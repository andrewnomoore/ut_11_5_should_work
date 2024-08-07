
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ОтборСрокВозврата) Тогда
		Актуальность = НСтр("ru='Любой'");
	КонецЕсли;
	
	УстановитьТекстЗапросаПринятаяТара();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ПринятаяТара,
		"ДатаВозврата",
		НачалоДня(ТекущаяДатаСеанса()));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ПринятаяТара,
		"ПриобретениеДоступно",
		ПравоДоступа("Просмотр", Метаданные.Документы.ПриобретениеТоваровУслуг));
		
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДокументыВозвратаТары,
		"Менеджер",
		ОтборМенеджер,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборМенеджер));
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(ДокументыВозвратаТары);
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(ДокументыВыкупаТары);

	Если ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ДокументыВозвратаТарыЕстьОшибкиПроверкиКонтрагентов.Видимость = Истина;
		Элементы.ДокументыВыкупаТарыЕстьОшибкиПроверкиКонтрагентов.Видимость   = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами 
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = ДокументыВозвратаТары.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ДокументыВозвратаТарыКоманднаяПанель;
	ПараметрыРазмещения.ПрефиксГрупп = "ДокументыВозвратаТары";
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	СписокТипов = ДокументыВыкупаТары.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ДокументыВыкупаТарыКоманднаяПанель;
	ПараметрыРазмещения.ПрефиксГрупп = "ДокументыВыкупаТары";

	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ДокументыВозвратаТары.Дата", Элементы.ДокументыВозвратаТарыДата.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ДокументыВыкупаТары.Дата", Элементы.ДокументыВыкупаТарыДата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборМенеджер     = Настройки.Получить("ОтборМенеджер");
	ОтборПартнер      = Настройки.Получить("ОтборПартнер");
	ОтборДатаВозврата = Настройки.Получить("ОтборДатаВозврата");
	ОтборСрокВозврата = Настройки.Получить("ОтборСрокВозврата");
	
	УстановитьОтборПоМенеджеру();
	УстановитьОтборПоПартнеру();
	УстановитьОтборВСпискеПоСрокуВозврата(ПринятаяТара, ОтборСрокВозврата);
	УстановитьОтборВСпискеПоДатеВозврата(ПринятаяТара, ОтборДатаВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПриобретениеТоваровУслуг"
		Или ИмяСобытия = "Запись_ВозвратТоваровПоставщику"
		Или ИмяСобытия = "Запись_ВыкупМногооборотнойТарыУПоставщика" Тогда
		Элементы.ПринятаяТара.Обновить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСрокВозвратаПриИзменении(Элемент)

	ПриИзмененииОтбораПоСрокуВозврата(ПринятаяТара, ОтборСрокВозврата, ОтборДатаВозврата);

КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВозвратаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "Истекает на дату" Тогда
		
		ОткрытьФорму(
			"ОбщаяФорма.ВыборДаты",
			Новый Структура("НачальноеЗначение"),,,,,
			Новый ОписаниеОповещения("ПриВыбореСрокаВозвратаВыборДатыЗавершение", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВозвратаОчистка(Элемент, СтандартнаяОбработка)
	
	ПриОчисткеОтбораПоСрокуВозврата(ПринятаяТара, ОтборСрокВозврата, ОтборДатаВозврата, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПартнерПриИзменении(Элемент)
	
	УстановитьОтборПоПартнеру();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
	
	УстановитьОтборПоМенеджеру();
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятаяТараВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ПринятаяТара.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, Элементы.ПринятаяТара.ТекущиеДанные.ДокументПоступления);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьВозвратТары(Команда)
	
	ОформитьДокумент("Возврат");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВыкупТары(Команда)
	
	ОформитьДокумент("Выкуп");
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВозвратаТары Тогда
		ТекущийСписок = Элементы.ДокументыВозвратаТары;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВыкупаТары Тогда
		ТекущийСписок = Элементы.ДокументыВыкупаТары;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийСписок);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВозвратаТары Тогда
		ТекущийСписок = Элементы.ДокументыВозвратаТары;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВыкупаТары Тогда
		ТекущийСписок = Элементы.ДокументыВыкупаТары;
	КонецЕсли;
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, ТекущийСписок, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВозвратаТары Тогда
		ТекущийСписок = Элементы.ДокументыВозвратаТары;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВыкупаТары Тогда
		ТекущийСписок = Элементы.ДокументыВыкупаТары;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ТекущийСписок);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СообщитьОбОшибкахФормированияДанныхЗаполненияВозвратаВыкупаТары(ВыборкаРеквизиты)
	
	Отказ = Ложь;
	
	ТекстСообщения = НСтр("ru='У выделенных строк в документе приобретения отличается поле ""%ПредставлениеПоля%""'");
	
	Если ВыборкаРеквизиты.ЕстьОтличияПартнер Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Поставщик'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	
	Если ВыборкаРеквизиты.ЕстьОтличияКонтрагент Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Контрагент'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияОрганизация Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Организация'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияСоглашение Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Соглашение'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияНаправлениеДеятельности Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Направление деятельности'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
		
	Если ВыборкаРеквизиты.ЕстьОтличияДоговор Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Договор'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияХозяйственнаяОперация Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Операция'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияВалюта Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Валюта'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияВалютаВзаиморасчетов Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Валюта взаиморасчетов'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияНалогообложениеНДС Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Налогообложение НДС'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияПредусмотренЗалогЗаТару Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Предусмотрен залог'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаКлиенте
Процедура ПриВыбореСрокаВозвратаВыборДатыЗавершение(ДатаВозврата, ДополнительныеПараметры) Экспорт
	
	ОтборДатаВозврата = ДатаВозврата;
	
	Если ЗначениеЗаполнено(ДатаВозврата) Тогда
		
		ОтборСрокВозврата = НСтр("ru='Истекает на %Дата%'");
		ОтборСрокВозврата = СтрЗаменить(ОтборСрокВозврата, "%Дата%", Формат(ДатаВозврата, "ДЛФ=D"));
		
	КонецЕсли;
	
	ПриИзмененииОтбораПоСрокуВозврата(ПринятаяТара, ОтборСрокВозврата, ОтборДатаВозврата);
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОчисткеОтбораПоСрокуВозврата(Список, СрокВозврата, ДатаВозврата, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если СрокВозврата <> "Любой" Тогда
		СрокВозврата = НСтр("ru='Любой'");
		ПриИзмененииОтбораПоСрокуВозврата(Список, СрокВозврата, ДатаВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОтбораПоСрокуВозврата(Список, СрокВозврата, ДатаВозврата)
	
	УстановитьОтборВСпискеПоСрокуВозврата(Список, СрокВозврата);
	
	НеПоказыватьВсе = (СрокВозврата <> "Любой");
	
	Если Не НеПоказыватьВсе Тогда
		ДатаВозврата = Дата(1,1,1);
	КонецЕсли;
	
	УстановитьОтборВСпискеПоДатеВозврата(Список, ДатаВозврата);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеПоСрокуВозврата(Список, СрокВозврата)
	
	ЗначениеОтбора = (СрокВозврата = "Просрочен" Или СтрНайти(СрокВозврата, "Истекает на") > 0);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Просрочен",
		ЗначениеОтбора,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СрокВозврата) И СрокВозврата <> "Любой");
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеПоДатеВозврата(Список, ДатаВозврата)
	
	Если ЗначениеЗаполнено(ДатаВозврата) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ДатаВозврата", ДатаВозврата);
	Иначе
		#Если Клиент Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ДатаВозврата", НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()));
		#Иначе
			Список.Параметры.УстановитьЗначениеПараметра("ДатаВозврата", НачалоДня(ТекущаяДатаСеанса()));
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьДокумент(ТипОперации)
	
	Если Элементы.ПринятаяТара.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив();
	
	
	Для Каждого ТекСтрока Из Элементы.ПринятаяТара.ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ТекСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Элементы.ПринятаяТара.ДанныеСтроки(ТекСтрока);
		МассивСтрок.Добавить(ДанныеСтроки);
		
	КонецЦикла;
	
	
	Если ТипОперации = "Выкуп" Тогда
		ИмяФормыДокумента = "Документ.ВыкупВозвратнойТарыУПоставщика.Форма.ФормаДокумента";
	Иначе // "Возврат"
		ИмяФормыДокумента = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента";
	КонецЕсли;
	
	Если МассивСтрок.Количество() > 0 Тогда
		
		ОчиститьСообщения();
		СтруктураРеквизитов = ПоместитьТаруВоВременноеХранилищеСервер(МассивСтрок);
		Если СтруктураРеквизитов <> Неопределено Тогда
			ОткрытьФорму(ИмяФормыДокумента, Новый Структура("Основание", СтруктураРеквизитов));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТаруВоВременноеХранилищеСервер(МассивСтрок)
	
	ТипПоступления = Новый ОписаниеТипов("ДокументСсылка.ПриобретениеТоваровУслуг");
	
	ТаблицаТары = Новый ТаблицаЗначений();
	ТаблицаТары.Колонки.Добавить("Партнер",                 Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
	ТаблицаТары.Колонки.Добавить("Номенклатура",            Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТары.Колонки.Добавить("Характеристика",          Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТары.Колонки.Добавить("Количество",              Новый ОписаниеТипов("Число"));
	ТаблицаТары.Колонки.Добавить("Сумма",                   Новый ОписаниеТипов("Число"));
	ТаблицаТары.Колонки.Добавить("ДокументПоступления",     ТипПоступления);
	ТаблицаТары.Колонки.Добавить("ПредусмотренЗалогЗаТару", Новый ОписаниеТипов("Булево"));
	
	Для Каждого ТекСтрока Из МассивСтрок Цикл
		
		НоваяСтрока = ТаблицаТары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		НоваяСтрока.Количество = ТекСтрока.КоличествоОстаток;
		НоваяСтрока.Сумма = ТекСтрока.СуммаОстаток;
		НоваяСтрока.ДокументПоступления = ТекСтрока.ДокументПоступления;
		НоваяСтрока.ПредусмотренЗалогЗаТару = ТекСтрока.ПредусмотренЗалогЗаТару;
		
	КонецЦикла;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТары.Партнер                 КАК Партнер,
	|	ТаблицаТары.Номенклатура            КАК Номенклатура,
	|	ТаблицаТары.Характеристика          КАК Характеристика,
	|	ТаблицаТары.Количество              КАК Количество,
	|	ТаблицаТары.ДокументПоступления     КАК ДокументПоступления,
	|	ТаблицаТары.ПредусмотренЗалогЗаТару КАК ПредусмотренЗалогЗаТару
	|ПОМЕСТИТЬ
	|	втТаблицаТары
	|ИЗ
	|	&ТаблицаТары КАК ТаблицаТары
	|;
	|ВЫБРАТЬ
	|	МИНИМУМ(втТаблицаТары.Партнер)                                        КАК Партнер,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.Контрагент)                 КАК Контрагент,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.Договор)                    КАК Договор,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.Организация)                КАК Организация,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.Подразделение)              КАК Подразделение,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.Соглашение)                 КАК Соглашение,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.НаправлениеДеятельности)    КАК НаправлениеДеятельности,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.ХозяйственнаяОперация)      КАК ХозяйственнаяОперация,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.Валюта)                     КАК Валюта,
	|	МИНИМУМ(ВЫБОР
	|				КОГДА втТаблицаТары.ДокументПоступления ССЫЛКА Документ.ПриобретениеТоваровУслуг 
	|					ТОГДА втТаблицаТары.ДокументПоступления.ВалютаВзаиморасчетов
	|				ИНАЧЕ втТаблицаТары.ДокументПоступления.Валюта
	|			КОНЕЦ)                                                        КАК ВалютаВзаиморасчетов,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.Соглашение.ФормаОплаты)     КАК ФормаОплаты,
	|	МИНИМУМ(ВЫБОР 
	|				КОГДА НЕ втТаблицаТары.ДокументПоступления.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) 
	|					ТОГДА втТаблицаТары.ДокументПоступления.Договор.ОплатаВВалюте
	|				ИНАЧЕ втТаблицаТары.ДокументПоступления.Соглашение.ОплатаВВалюте
	|			КОНЕЦ)                                                        КАК ОплатаВВалюте,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.НалогообложениеНДС)         КАК НалогообложениеНДС,
	|	МИНИМУМ(втТаблицаТары.ДокументПоступления.ЦенаВключаетНДС)            КАК ЦенаВключаетНДС,
	|	МИНИМУМ(втТаблицаТары.ПредусмотренЗалогЗаТару)                        КАК ПредусмотренЗалогЗаТару,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Склад) = 1 И
	|			МАКСИМУМ(втТаблицаТары.ДокументПоступления.Склад.ЭтоГруппа) = ЛОЖЬ
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументПоступления.Склад)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	КОНЕЦ КАК Склад,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.Партнер) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияПартнер,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Контрагент) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияКонтрагент,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Организация) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияОрганизация,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Соглашение) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияСоглашение,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Договор) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияДоговор,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.НаправлениеДеятельности) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияНаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.ХозяйственнаяОперация) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Валюта) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияВалюта,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|									КОГДА втТаблицаТары.ДокументПоступления ССЫЛКА Документ.ПриобретениеТоваровУслуг 
	|										ТОГДА втТаблицаТары.ДокументПоступления.ВалютаВзаиморасчетов
	|									ИНАЧЕ втТаблицаТары.ДокументПоступления.Валюта
	|								КОНЕЦ) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияВалютаВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.НалогообложениеНДС) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияНалогообложениеНДС,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ПредусмотренЗалогЗаТару) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияПредусмотренЗалогЗаТару,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументПоступления.БанковскийСчетОрганизации <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументПоступления.БанковскийСчетОрганизации
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1 И
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Организация) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументПоступления.БанковскийСчетОрганизации)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетОрганизации,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументПоступления.БанковскийСчетКонтрагента <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументПоступления.БанковскийСчетКонтрагента
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1 И
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументПоступления.Контрагент) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументПоступления.БанковскийСчетКонтрагента)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетКонтрагента,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументПоступления.Грузоотправитель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументПоступления.Грузоотправитель
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументПоступления.Грузоотправитель)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	КОНЕЦ КАК Грузополучатель,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументПоступления.БанковскийСчетГрузоотправителя <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументПоступления.БанковскийСчетГрузоотправителя
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1 И
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументПоступления.Грузоотправитель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументПоступления.Грузоотправитель
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументПоступления.БанковскийСчетГрузоотправителя)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетГрузополучателя
	|ИЗ
	|	втТаблицаТары КАК втТаблицаТары
	|");
	
	Запрос.УстановитьПараметр("ТаблицаТары", ТаблицаТары);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаРеквизиты = РезультатЗапроса.Выбрать();
	ВыборкаРеквизиты.Следующий();
	
	Если СообщитьОбОшибкахФормированияДанныхЗаполненияВозвратаВыкупаТары(ВыборкаРеквизиты) Тогда
		
		ТекстОшибки = НСтр("ru='Ввод одного документа по выделенным строкам невозможен'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Возврат Неопределено;
		
	Иначе
		
		РеквизитыШапки = Новый Структура();
		РеквизитыШапки.Вставить("Партнер",                       ВыборкаРеквизиты.Партнер);
		РеквизитыШапки.Вставить("Контрагент",                    ВыборкаРеквизиты.Контрагент);
		РеквизитыШапки.Вставить("Договор",                       ВыборкаРеквизиты.Договор);
		РеквизитыШапки.Вставить("Организация",                   ВыборкаРеквизиты.Организация);
		РеквизитыШапки.Вставить("Подразделение",                 ВыборкаРеквизиты.Подразделение);
		РеквизитыШапки.Вставить("Склад",                         ВыборкаРеквизиты.Склад);
		РеквизитыШапки.Вставить("Соглашение",                    ВыборкаРеквизиты.Соглашение);
		РеквизитыШапки.Вставить("НаправлениеДеятельности",       ВыборкаРеквизиты.НаправлениеДеятельности);
		РеквизитыШапки.Вставить("ХозяйственнаяОперация",         ЗакупкиСервер.ПолучитьХозяйственнуюОперациюВозвратаПоПоступлению(ВыборкаРеквизиты.ХозяйственнаяОперация));
		РеквизитыШапки.Вставить("Валюта",                        ВыборкаРеквизиты.Валюта);
		РеквизитыШапки.Вставить("ВалютаВзаиморасчетов",          ВыборкаРеквизиты.ВалютаВзаиморасчетов);
		РеквизитыШапки.Вставить("ФормаОплаты",                   ВыборкаРеквизиты.ФормаОплаты);
		РеквизитыШапки.Вставить("ОплатаВВалюте",                 ВыборкаРеквизиты.ОплатаВВалюте);
		РеквизитыШапки.Вставить("НалогообложениеНДС",            ВыборкаРеквизиты.НалогообложениеНДС);
		РеквизитыШапки.Вставить("ЦенаВключаетНДС",               ВыборкаРеквизиты.ЦенаВключаетНДС);
		РеквизитыШапки.Вставить("Грузополучатель",               ВыборкаРеквизиты.Грузополучатель);
		РеквизитыШапки.Вставить("БанковскийСчетГрузополучателя", ВыборкаРеквизиты.БанковскийСчетГрузополучателя);
		РеквизитыШапки.Вставить("БанковскийСчетОрганизации",     ВыборкаРеквизиты.БанковскийСчетОрганизации);
		РеквизитыШапки.Вставить("БанковскийСчетКонтрагента",     ВыборкаРеквизиты.БанковскийСчетКонтрагента);
		РеквизитыШапки.Вставить("ПредусмотренЗалогЗаТару",       ВыборкаРеквизиты.ПредусмотренЗалогЗаТару);
		
		АдресТарыВоВременномХранилище = ПоместитьВоВременноеХранилище(ТаблицаТары, УникальныйИдентификатор);
		Возврат Новый Структура(
						"РеквизитыШапки,АдресТарыВоВременномХранилище,ЗаполнитьПоПринятойТаре",
						РеквизитыШапки,
						АдресТарыВоВременномХранилище);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоПартнеру()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПринятаяТара,          "Партнер", ОтборПартнер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПартнер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВозвратаТары, "Партнер", ОтборПартнер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПартнер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВыкупаТары,   "Партнер", ОтборПартнер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПартнер));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоМенеджеру()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПринятаяТара,          "ДокументПоступления.Менеджер", ОтборМенеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборМенеджер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВозвратаТары, "Менеджер", ОтборМенеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборМенеджер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВыкупаТары,   "Менеджер", ОтборМенеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборМенеджер));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗапросаПринятаяТара()
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТИПЗНАЧЕНИЯ(НЕОПРЕДЕЛЕНО) КАК ДоступныйТип
	|ПОМЕСТИТЬ ДоступныеТипыПоступлений
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТИП(Документ.ПриобретениеТоваровУслуг) КАК ДоступныйТип
	|ГДЕ
	|	&ПриобретениеДоступно
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.Номенклатура КАК Номенклатура,
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.Характеристика КАК Характеристика,
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.Партнер КАК Партнер,
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.ПредусмотренЗалог КАК ПредусмотренЗалогЗаТару,
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.ДокументПоступления КАК ДокументПоступления,
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.ДокументПоступления.ДатаВозвратаМногооборотнойТары КАК ДатаВозвратаМногооборотнойТары,
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|	РегистрНакопленияПринятаяВозвратнаяТараОстатки.СуммаОстаток КАК СуммаОстаток,
	|	ВЫБОР
	|		КОГДА РегистрНакопленияПринятаяВозвратнаяТараОстатки.ДокументПоступления.ДатаВозвратаМногооборотнойТары <= КОНЕЦПЕРИОДА(&ДатаВозврата, ДЕНЬ)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Просрочен
	|ИЗ
	|	РегистрНакопления.ПринятаяВозвратнаяТара.Остатки(
	|			,
	|			ТИПЗНАЧЕНИЯ(ДокументПоступления) В
	|				(ВЫБРАТЬ
	|					ДоступныйТип
	|				ИЗ
	|					ДоступныеТипыПоступлений)
	|		) КАК РегистрНакопленияПринятаяВозвратнаяТараОстатки
	|";
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, ПринятаяТара);
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.ПринятаяТара, СвойстваСписка);
	
КонецПроцедуры

#КонецОбласти
