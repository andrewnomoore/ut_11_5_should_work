#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИПроверитьПереданныеПараметры(Отказ);
	УстановитьБыстрыйОтборСервер();
	
	СобытияФормЗЕРНО.ПриСозданииНаСервереФормыСпискаСправочников(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ИнтеграцияИС.УстановитьПризнакПравоИзмененияФормыСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПодборОрганизацииЗавершение", ЭтотОбъект);
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПодборОрганизацииЗавершение", ЭтотОбъект);
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииПриИзменении(Элемент)
	
	ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Статус", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапроситьПартии(Команда)
	
	ЗапросСДИЗЗавершение = Новый ОписаниеОповещения("Подключаемый_ЗапросПартийЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = ИнтеграцияЗЕРНОСлужебныйКлиент.ПараметрыОткрытияФормыЗапросаСправочника();
	ПараметрыФормы.ВидЗапроса = 2;
	ПараметрыФормы.ТипЗапроса = "Партии";
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		ПараметрыФормы.СсылкаНаОбъект = ПредопределенноеЗначение("Справочник.РеестрПартийЗЕРНО.ПустаяСсылка");
	Иначе
		ПараметрыФормы.СсылкаНаОбъект = Элементы.Список.ТекущаяСтрока;
		ПараметрыФормы.Идентификатор  = Элементы.Список.ТекущиеДанные.Идентификатор;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы.Организация = Организация;
	КонецЕсли;
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОткрытьФормуЗапросаСправочника(ПараметрыФормы, ЭтотОбъект, ЗапросСДИЗЗавершение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ЗапросПартийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры(Отказ);
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.МножественныйВыбор <> Неопределено Тогда
		Элементы.Список.МножественныйВыбор = Параметры.МножественныйВыбор;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Организации", Организации);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			ОбновитьКлючиРеквизитовОрганизацийНаСервере();
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"ВладелецПартии",
				КлючиРеквизитовОрганизаций,,,
				Истина);
			ОрганизацииПредставление = Строка(Организации);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам()
	
	СобытияФормЗЕРНО.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКлючиРеквизитовОрганизацийНаСервере()
	
	МассивОрганизаций = Организации.ВыгрузитьЗначения();
	КлючиРеквизитовОрганизаций.ЗагрузитьЗначения(
		Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(МассивОрганизаций));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОрганизаций(Форма, Результат, ПрименятьОтбор, Префикс = Неопределено, Префиксы = Неопределено)
	
	ИнтеграцияИСКлиентСервер.НастроитьОтборПоОрганизации(ЭтотОбъект, Результат, Префикс, Префиксы);
	
	Если ПрименятьОтбор Тогда
		ОбновитьКлючиРеквизитовОрганизацийНаСервере();
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"ВладелецПартии", КлючиРеквизитовОрганизаций, ВидСравненияКомпоновкиДанных.ВСписке,, Организации.Количество() > 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборОрганизацииЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьКлючиРеквизитовОрганизацийНаСервере();
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ВладелецПартии", КлючиРеквизитовОрганизаций, ВидСравненияКомпоновкиДанных.ВСписке, , Организации.Количество() > 0);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт

	Элементы.Список.Обновить();

КонецПроцедуры

#КонецОбласти
