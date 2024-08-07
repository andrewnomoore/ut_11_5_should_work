
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; // используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	СписокВыбораНалогообложенияНДС = Элементы.НалогообложениеНДС.СписокВыбора;
	СписокВыбораНалогообложенияНДС.Очистить();
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС,        НСтр("ru = 'Облагаемая НДС'"));
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС,      НСтр("ru = 'Не облагаемая НДС'"));
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт,            НСтр("ru = 'Экспорт'"));
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД,       НСтр("ru = 'Облагаемая ЕНВД'"));
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.ПоФактическомуИспользованию, НСтр("ru = 'По фактическому использованию'"));
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг, НСтр("ru = 'Экспорт сырьевых товаров, работ'"));
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров,    НСтр("ru = 'Экспорт несырьевых товаров'"));
	СписокВыбораНалогообложенияНДС.Добавить(Перечисления.ТипыНалогообложенияНДС.Космос,                      НСтр("ru = 'Космическая деятельность'"));
	
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Документ.КорректировкаВидаДеятельностиНДС.Форма.ПодборПоОстаткам" Тогда
		
		ЗаполнитьДокументРезультатомПодбора(ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов" Тогда	
		
		ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение);
		
	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураДействий);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
		ЭтотОбъект,
		ТекущийОбъект,
		ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	АктуализироватьНовоеНалогообложениеНДС();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	ТекущаяСтрока.Назначение = Объект.Назначение;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	
	Элементы.Товары.ТекущиеДанные.Назначение = Объект.Назначение;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущаяСтрока.Назначение = Объект.Назначение;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура НазначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораНазначения", ЭтаФорма);
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("Организация", Объект.Организация);
	ОткрытьФорму("Документ.КорректировкаВидаДеятельностиНДС.Форма.ФормаВыбораНазначения", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНазначения(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.Назначение = Результат;
		Для Каждого Строка Из Объект.Товары Цикл
			Строка.Назначение = Результат;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЗапасов(Команда)
	
	ПараметрыРедактированияВидовЗапасов = ПоместитьТоварыИВидыЗапасовВХранилище();
	
	ФинансыКлиент.ОткрытьВидыЗапасов(ЭтотОбъект, ПараметрыРедактированияВидовЗапасов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткамТоваровОрганизаций(Команда)
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("Организация",        НСтр("ru = 'Организация'"));
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("Склад",              НСтр("ru = 'Склад'"));
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("НалогообложениеНДС", НСтр("ru = 'Налогообложение НДС'"));
	Оповещение = Новый ОписаниеОповещения("ПодборПоОстаткамТоваровОрганизацийЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткамТоваровОрганизацийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	АдресПлатежейВХранилище = ПоместитьТоварыВХранилище(
		Объект.Товары,
		УникальныйИдентификатор);
		
	ПараметрыПодбора = Новый Структура();
	ПараметрыПодбора.Вставить("АдресПлатежейВХранилище", АдресПлатежейВХранилище);
	ПараметрыПодбора.Вставить("Организация",             Объект.Организация);
	ПараметрыПодбора.Вставить("Склад",                   Объект.Склад);
	ПараметрыПодбора.Вставить("Назначение",              Объект.Назначение);
	ПараметрыПодбора.Вставить("НалогообложениеНДС",      Объект.НалогообложениеНДС);
	ПараметрыПодбора.Вставить("Период",                  Объект.Дата);
	
	ОткрытьФорму(
		"Документ.КорректировкаВидаДеятельностиНДС.Форма.ПодборПоОстаткам",
		ПараметрыПодбора, 
		ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда,
		ЭтотОбъект,
		Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура АктуализироватьНовоеНалогообложениеНДС(ПроверитьКорректность = Истина)
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС();
	ПараметрыЗаполнения.Организация = Объект.Организация;
	ПараметрыЗаполнения.Дата = Объект.Дата;
	ПараметрыЗаполнения.КорректировкаВидаДеятельностиНДС = Истина;
	
	Если ПроверитьКорректность Тогда
		
		УчетНДСУП.ЗаполнитьВидДеятельностиНДС(
			Объект.НовоеНалогообложениеНДС, 
			ПараметрыЗаполнения,
			УчетНДСКэшированныеЗначенияПараметров);
		
	КонецЕсли;
	
	УчетНДСУП.ЗаполнитьСписокВыбораВидаДеятельностиНДС(
		Элементы.НовоеНалогообложениеНДС, 
		Объект.НовоеНалогообложениеНДС, 
		ПараметрыЗаполнения, 
		УчетНДСКэшированныеЗначенияПараметров);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПодбораПоОстаткам()
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		ДатаПроверки = ТекущаяДатаСеанса();
	Иначе
		ДатаПроверки = Объект.Дата;
	КонецЕсли;
	Элементы.ТоварыПодборПоОстаткамТоваров.Видимость = РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(ДатаПроверки);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");

КонецПроцедуры

#Область ПодборыИОбработкаПроверкиКоличества

&НаСервере
Функция ПоместитьТоварыВХранилище(Знач Товары, УникальныйИдентификатор)

	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(
		Товары.Выгрузить(,"Номенклатура, Характеристика, Серия, Назначение, Количество"),
		УникальныйИдентификатор);
		
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

&НаСервере
Функция ПоместитьТоварыИВидыЗапасовВХранилище()
	
	Возврат ЗапасыСервер.ПоместитьТоварыИВидыЗапасовВХранилище(ЭтотОбъект);
		
КонецФункции

&НаСервере
Процедура ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение)
	
	ЗапасыСервер.ОбработатьВводВидовЗапасовВручную(ВыбранноеЗначение, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресПлатежейВХранилище)
	
	Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураДействий);
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументРезультатомПодбора(РезультатВыбора)

	ПолучитьТоварыИзХранилища(РезультатВыбора.АдресПлатежейВХранилище);
	
	Объект.НалогообложениеНДС = РезультатВыбора.НалогообложениеНДС;
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "")
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст)Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураДействий);
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(
									НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.КорректировкаВидаДеятельностиНДС));
	
	АктуализироватьНовоеНалогообложениеНДС(Ложь);
	УстановитьВидимостьПодбораПоОстаткам();
	
КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект,
																									Документы.КорректировкаВидаДеятельностиНДС));
		
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	АктуализироватьНовоеНалогообложениеНДС();
	УстановитьВидимостьПодбораПоОстаткам();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
