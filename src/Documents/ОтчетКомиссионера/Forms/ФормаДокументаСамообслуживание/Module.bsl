#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; // используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	ВзаиморасчетыСервер.ФормаПриСозданииНаСервере(ЭтаФорма);
	
	Если Объект.Ссылка.Пустая() Тогда
		
		СамообслуживаниеСервер.ФормыСамообслуживаниеПриСозданииНаСервере(ЭтаФорма, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;

		ПриЧтенииСозданииНаСервере();
		УстановитьЗаголовокДокумента(Истина);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаКомандСтандартные);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		
		Отказ = Истина;
		СамообслуживаниеКлиент.ПечатьДокументОтчетКомиссионера(Объект.Ссылка);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если ТекущийОбъект.Проведен Тогда
		ТребуетсяОткрытиеПечатнойФормы = Истина;
		Возврат;
	КонецЕсли;
	
	ВзаиморасчетыСервер.ФормаПриЧтенииНаСервере(ЭтаФорма);
	
	ПриЧтенииСозданииНаСервере();
	УстановитьЗаголовокДокумента(Ложь);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ПодборПоТоварамПереданнымНаКомиссию" Тогда
		
		ПолучитьТоварыИзХранилища(ВыбранноеЗначение);
		
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
	
	СтруктураХарактеристикиНоменклатуры = Новый Структура;
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",	Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакАртикул",	Новый Структура("Номенклатура", "Артикул"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураХарактеристикиНоменклатуры);
	ВзаиморасчетыСервер.ФормаПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект.ДополнительныеСвойства);
	
	УстановитьЗаголовокДокумента(Ложь);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ВзаиморасчетыКлиент.ФормаПослеЗаписи(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ПроверитьЗаполнение() Тогда
	
		Отказ = Истина;
	Иначе
		ВзаиморасчетыСервер.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Соглашение.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано соглашение'"),
		                                                  ,
		                                                  "Объект.Соглашение",
		                                                  ,
		                                                  Отказ);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПередЗаписьюНаКлиентеСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаКлиентеСервер()
	
	ВзаиморасчетыВызовСервера.ФормаПередЗаписьюНаКлиентеСервер(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьЭтапыОплатыНажатие(Элемент, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("НадписьЭтапыОплатыНажатиеЗавершение", ЭтотОбъект);
	ПоместитьЭтапыОплатыВоВременноеХранилище(Элемент.Имя);
	ВзаиморасчетыКлиент.НадписьЭтапыОплатыНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка, Оповещение );
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьЭтапыОплатыВоВременноеХранилище(ИмяЭлемента)
	ВзаиморасчетыСервер.ПоместитьЭтапыОплатыВоВременноеХранилище(ЭтаФорма, ИмяЭлемента);
КонецПроцедуры

&НаСервере
Процедура ОтразитьИзмененияПравилОплаты(ИзмененныеРеквизиты)
	
	ВзаиморасчетыСервер.ЗагрузитьЭтапыОплатыИзВременногоХранилища(ЭтаФорма);
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, ИзмененныеРеквизиты, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЭтапыОплатыНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ИзмененныеРеквизиты = Результат.СтарыеЗначенияИзмененныхРеквизитов;
		ОтразитьИзмененияПравилОплаты(ИзмененныеРеквизиты);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Партнер",Объект.Партнер);
	ПараметрыФормы.Вставить("Соглашение",Объект.Соглашение);
	ПараметрыФормы.Вставить("ХозяйственнаяОперация",ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию"));
	
	РезультатВыбора = Неопределено;

	
	ОткрытьФорму("Обработка.СамообслуживаниеПартнеров.Форма.ВыборСоглашения",
	                                       ПараметрыФормы,
	                                       ЭтаФорма,,,, Новый ОписаниеОповещения("СоглашениеНачалоВыбораПослеВыбора", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбораПослеВыбора(Результат, ДополнительныеПараметры) Экспорт
    
    РезультатВыбора = Результат;
    Если РезультатВыбора <> Неопределено И РезультатВыбора.Соглашение <> Объект.Соглашение Тогда
        
        Если Объект.Товары.Количество() > 0 Тогда
            ТекстВопроса = НСтр("ru = 'Соглашение было изменено, ""Товары"" будут очищены, Продолжить?'");
            Ответ = Неопределено;
            
            ПоказатьВопрос(Новый ОписаниеОповещения("СоглашениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("РезультатВыбора", РезультатВыбора)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
            Возврат;
        КонецЕсли;
        
        СоглашениеНачалоВыбораФрагмент(РезультатВыбора);
        
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбораЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    РезультатВыбора = ДополнительныеПараметры.РезультатВыбора;
    
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    Иначе
        Объект.Товары.Очистить();
    КонецЕсли;
    
    СоглашениеНачалоВыбораФрагмент(РезультатВыбора);

КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбораФрагмент(Знач РезультатВыбора)
    
    Объект.Соглашение = РезультатВыбора.Соглашение;
    СоглашениеПриИзмененииСервер(РезультатВыбора);

КонецПроцедуры

&НаКлиенте
Процедура СоглашениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииСервер()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ТоварыНоменклатура" 
		ИЛИ Поле.Имя = "ТоварыХарактеристика"
		ИЛИ Поле.Имя = "ТоварыАртикул" Тогда
		
		ОткрытьКарточкуНоменклатуры();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	КомиссионнаяТорговляКлиент.ОтчетКомиссионераТоварыУпаковкаПриИзменении(Объект, ТекущаяСтрока, 
		ИспользоватьСоглашенияСКлиентами, КэшированныеЗначения);
	
	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	КомиссионнаяТорговляКлиент.ОтчетКомиссионераТоварыКоличествоУпаковокПриИзменении(Объект, ТекущаяСтрока, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПродажиПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	КомиссионнаяТорговляКлиент.ОтчетКомиссионераТоварыЦенаПродажиПриИзменении(ТекущаяСтрока, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект));
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", Новый Структура("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС));
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажиНДС");
	СтруктураДействий.Вставить("ОчиститьСуммуВознаграждения");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

	РассчитыватьВознаграждение = Истина;
	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма);
	ВзаиморасчетыКлиент.ОбновитьТекстГиперссылкиЭтапыОплаты(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "НачалоПериода", "КонецПериода"));

КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткам(Команда)
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("Организация", НСтр("ru = 'Организация'"));
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("Партнер",     НСтр("ru = 'Комиссионер'"));
	Оповещение = Новый ОписаниеОповещения("ПодборПоОстаткамЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткамЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	АдресПлатежейВХранилище = ПоместитьТоварыВХранилище(
		Объект.Товары,
		УникальныйИдентификатор);
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресПлатежейВХранилище", АдресПлатежейВХранилище);
	ПараметрыПодбора.Вставить("Организация", Объект.Организация);
	ПараметрыПодбора.Вставить("Партнер", Объект.Партнер);
	ПараметрыПодбора.Вставить("Соглашение", Объект.Соглашение);
	ПараметрыПодбора.Вставить("Дата", Объект.КонецПериода);
	ПараметрыПодбора.Вставить("ПоРезультатамИнвентаризации", Объект.ПоРезультатамИнвентаризации);
	ПараметрыПодбора.Вставить("СкрыватьОтбор", Истина);
	
	ОткрытьФорму(
		"ОбщаяФорма.ПодборПоТоварамПереданнымНаКомиссию",
		ПараметрыПодбора, 
	ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	
	Если Объект.Соглашение.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано соглашение'"),
		                                                  ,
		                                                  "Объект.Соглашение",
		                                                  ,
		                                                  Отказ);
		Возврат;
	КонецЕсли;
	
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуТовара(Команда)
	
	ОткрытьКарточкуНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы  = Элементы.Товары;
	ДанныеТаблицы = Объект.Товары;
	
	ПараметрыРазбиенияСтроки = РаботаСТабличнымиЧастямиКлиент.ПараметрыРазбиенияСтроки();
	ПараметрыРазбиенияСтроки.РазрешитьНулевоеКоличество = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.РазбитьСтроку(ДанныеТаблицы, ТаблицаФормы, Оповещение, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт 
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если НоваяСтрока <> Неопределено Тогда
		
		СтруктураДействий = Новый Структура;
		СамообслуживаниеКлиентСервер.ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокОтчетКомиссионера(СтруктураДействий, Объект);
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
		
		РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

КонецПроцедуры

#Область ПриИзмененииРеквизитовНаСервере

&НаСервере
Процедура СоглашениеПриИзмененииСервер(Данные)
	
	Объект.Организация = Данные.Организация;
		
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьУсловияПродажПоСоглашению();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Соглашение");
	
	УправлениеДоступностьюИзменениеСоглашения(Данные);
	
	СтруктураХарактеристикиНоменклатуры = Новый Структура;
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",	Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакАртикул",	Новый Структура("Номенклатура", "Артикул"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураХарактеристикиНоменклатуры);
	
	ВалютаДокумента = Объект.Валюта;
	
	СамообслуживаниеКлиентСервер.РассчитатьСуммуВознаграждения(Объект);
	УправлениеЭлементамиФормы();
	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма, Ложь);
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииСервер()
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Контрагент");
	СамообслуживаниеСервер.УправлениеЭлементомФормыДоговор(Объект, Элементы.Договор, ИспользуютсяДоговорыКонтрагентов);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступностьюРеквизитовФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ОтчетКомиссионера.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект.СпособРасчетаВознаграждения,
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации,
		Истина);
	ДенежныеСредстваСервер.УстановитьДоступностьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Элементы.ТоварыСумма.Видимость = Не Объект.ЦенаВключаетНДС;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюИзменениеСоглашения(Данные)
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТоварыПодборПоОстаткам",
	                                                               "Доступность", ЗначениеЗаполнено(Объект.Соглашение));
	СамообслуживаниеСервер.СформироватьТекстовыеПредставленияПолейФормыДокумента(ЭтаФорма);
	
	Если Данные = Неопределено Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Договор", 
		                                                               "Доступность", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Контрагент",
		                                                               "Доступность", Ложь);
		Возврат;
	КонецЕсли;
	
	ИспользуютсяДоговорыКонтрагентов = Данные.ИспользуютсяДоговорыКонтрагентов;
	
	СамообслуживаниеСервер.УправлениеЭлементомФормыКонтрагент(Объект, Данные, Элементы.Контрагент);
	СамообслуживаниеСервер.УправлениеЭлементомФормыДоговор(Объект, Элементы.Договор, ИспользуютсяДоговорыКонтрагентов);
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеИВыводИнформацииНаФорму

&НаСервере
Процедура УстановитьЗаголовокДокумента(ЭтоНовыйОбъект)
	
	Если ЭтоНовыйОбъект Тогда
		
		Заголовок = НСтр("ru = 'Отчет комиссионера (создание)'");
		
	Иначе
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отчет комиссионера %1 от %2'"), Объект.Номер, Объект.Дата);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиОтчетаКомиссионера(Форма, РассчитыватьДанныеДокумента = Истина)
	
	Если РассчитыватьДанныеДокумента Тогда
		СамообслуживаниеКлиентСервер.РассчитатьСуммуВознаграждения(Форма.Объект);
	КонецЕсли;
	
	ОтображатьИтогСуммыНДС = УчетНДСУПКлиентСервер.ОтображатьНДСВИтогахДокументаПродажи(Форма.Объект.НалогообложениеНДС);
	
	Если ОтображатьИтогСуммыНДС Тогда
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница   = Форма.Элементы.СтраницаСНДС;
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоСНДС;
	Иначе
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница   = Форма.Элементы.СтраницаБезНДС;
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоБезНДС;
	КонецЕсли;
	
	Если Форма.Объект.СпособРасчетаВознаграждения = ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается") Тогда
		Форма.Элементы.СуммаВознаграждения.Видимость      = Ложь;
		Форма.Элементы.ПроцентВознаграждения.Видимость    = Ложь;
		Форма.Элементы.НадписьУдержатьВознаграждение.Видимость = Ложь;
	Иначе
		Форма.Элементы.СуммаВознаграждения.Видимость      = Истина;
		Форма.Элементы.ПроцентВознаграждения.Видимость    = Истина;
		Форма.Элементы.НадписьУдержатьВознаграждение.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ПоместитьТоварыВХранилище(Знач Товары, УникальныйИдентификатор)

	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(
		Товары.Выгрузить(,"Номенклатура, Характеристика, НомерГТД, Количество, КоличествоПоРНПТ"),
		УникальныйИдентификатор);
		
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище)
	
	Перем КэшированныеЗначения;
	
	ПодобранныеТовары = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	ДобавленныеСтроки = Новый Массив;
	
	// Удалим строки, у которых сняли галочки в подборе
	СтрокиКУдалению = Новый Массив;
	Для Каждого СтрокаТовар Из Объект.Товары Цикл
		
		ПараметрыОтбора = Новый Структура("Номенклатура, Характеристика", СтрокаТовар.Номенклатура, СтрокаТовар.Характеристика);
		НайденныеСтроки = ПодобранныеТовары.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокиКУдалению.Добавить(СтрокаТовар);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
		Объект.Товары.Удалить(СтрокаКУдалению);
	КонецЦикла;
	
	Для Каждого СтрокаПодобранныйТовар Из ПодобранныеТовары Цикл
		ПараметрыОтбора = Новый Структура("Номенклатура, Характеристика",
		                                  СтрокаПодобранныйТовар.Номенклатура,
		                                  СтрокаПодобранныйТовар.Характеристика);
		НайденныеСтроки = Объект.Товары.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПодобранныйТовар);
			ДобавленныеСтроки.Добавить(НоваяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Дата", ?(ЗначениеЗаполнено(Объект.КонецПериода), Объект.КонецПериода, Объект.Дата));
	ПараметрыЗаполнения.Вставить("Организация", Объект.Организация);
	ПараметрыЗаполнения.Вставить("Валюта", Объект.Валюта);
	ПараметрыЗаполнения.Вставить("Соглашение", Объект.Соглашение);
	ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС, ВидЦены");
	
	ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(
	Объект.Товары, // Табличная часть
	, // Массив строк или структура отбора
	ПараметрыЗаполнения ,
	Новый Структура( // Структура действий с измененными строками
		"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
		"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы));
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажиПоСуммеСНДС");
	СтруктураДействий.Вставить("ПересчитатьЦенуПродажиПоСуммеПродажи");
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажиНДС");
	СтруктураДействий.Вставить("ОчиститьСуммуВознаграждения");

	Для Каждого ДобавленнаяСтрока Из ДобавленныеСтроки Цикл
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ДобавленнаяСтрока, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
	СтруктураХарактеристикиНоменклатуры = Новый Структура;
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",	Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакАртикул",	Новый Структура("Номенклатура", "Артикул"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураХарактеристикиНоменклатуры);
			
	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ИспользоватьСоглашенияСКлиентами  = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	ИспользоватьГрафикиОплаты         = ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиОплаты");
	ИспользоватьУпрощеннуюСхемуОплаты = ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВПродажах");
	
	Если Не Объект.Соглашение.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СоглашенияСКлиентами.ИспользуютсяДоговорыКонтрагентов,
		|	СоглашенияСКлиентами.ФормаОплаты,
		|	СоглашенияСКлиентами.Контрагент,
		|	&Партнер,
		|	СоглашенияСКлиентами.ПорядокРасчетов,
		|	СоглашенияСКлиентами.СегментНоменклатуры,
		|	СоглашенияСКлиентами.ХозяйственнаяОперация
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|ГДЕ
		|	СоглашенияСКлиентами.Ссылка = &Соглашение";
		
		Запрос.УстановитьПараметр("Соглашение", Объект.Соглашение);
		Запрос.УстановитьПараметр("Партнер", Объект.Партнер);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
	Иначе
		
		Выборка = СамообслуживаниеСервер.ПолучитьСоглашениеПартнераПоУмолчанию(Объект.Партнер, Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
		Если Выборка <> Неопределено Тогда
			Объект.Соглашение = Выборка.Ссылка;
			СоглашениеПриИзмененииСервер(Выборка);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеДоступностьюИзменениеСоглашения(Выборка);
	
	ВалютаДокумента = Объект.Валюта;
	УправлениеЭлементамиФормы();
	ПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Объект.СтавкаНДСВознаграждения);
	
	СтруктураХарактеристикиНоменклатуры = Новый Структура;
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",	Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакАртикул",	Новый Структура("Номенклатура", "Артикул"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураХарактеристикиНоменклатуры);
	
	РассчитатьИтоговыеПоказателиОтчетаКомиссионера(ЭтаФорма, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНоменклатуры()

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Номенклатура);
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#КонецОбласти
