#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого СтрокаБыстрыйПоиск Из Параметры.БыстрыйПоиск Цикл
		НоваяСтрокаПоиска = БыстрыйПоиск.Добавить();
		ЗаполнитьЗначенияСвойств(
			НоваяСтрокаПоиска,
			СтрокаБыстрыйПоиск,
			ИнтеграцияС1СДокументооборот3КлиентСервер.КолонкиБыстрогоПоиска());
	КонецЦикла;
	
	СпискиВыбораБыстрогоПоиска = Параметры.СпискиВыбораБыстрогоПоиска;
	
	ОбновитьПредставлениеБыстрогоПоиска();
	
	ИнтеграцияС1СДокументооборот3.УстановитьУсловноеОформлениеТаблицыБыстрыйПоиск(
		УсловноеОформление,
		Элементы.БыстрыйПоиск,
		Элементы.БыстрыйПоискЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыБыстрыйПоиск

&НаКлиенте
Процедура БыстрыйПоискПриИзменении(Элемент)
	
	БыстрыйПоискПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискПриАктивизацииСтроки(Элемент)
	
	Если Элементы.БыстрыйПоиск.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.БыстрыйПоиск.ТекущиеДанные;
	
	Элементы.БыстрыйПоискЗначение.СписокВыбора.Очистить();
	Если СпискиВыбораБыстрогоПоиска.Свойство(ТекущиеДанные.Параметр) Тогда
		
		СписокВыбораПараметра = СпискиВыбораБыстрогоПоиска[ТекущиеДанные.Параметр];
		Для Каждого ЭлементВыбора Из СписокВыбораПараметра Цикл
			Элементы.БыстрыйПоискЗначение.СписокВыбора.Добавить(
				ЭлементВыбора.Значение,
				ЭлементВыбора.Представление,,
				ЭлементВыбора.Картинка);
		КонецЦикла;
		
		Элементы.БыстрыйПоискЗначение.КнопкаВыпадающегоСписка = Истина;
		Элементы.БыстрыйПоискЗначение.КнопкаВыбора = Ложь;
		Элементы.БыстрыйПоискЗначение.РежимВыбораИзСписка = Истина;
		
	Иначе
		
		Элементы.БыстрыйПоискЗначение.КнопкаВыпадающегоСписка = Неопределено;
		Элементы.БыстрыйПоискЗначение.КнопкаВыбора = Истина;
		Элементы.БыстрыйПоискЗначение.РежимВыбораИзСписка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискЗначениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Элемент.СписокВыбора.Количество() > 0 И Не ЗначениеЗаполнено(Элемент.СписокВыбора[0].Значение) Тогда
		Элемент.СписокВыбора.Очистить();
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.БыстрыйПоиск.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
			Или Не ЗначениеЗаполнено(Текст)
			Или Элемент.РежимВыбораИзСписка
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Число")
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Дата")
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
		ТекущиеДанные.Тип,
		ДанныеВыбора,
		Текст,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискЗначениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.СписокВыбора.Количество() > 0 И Не ЗначениеЗаполнено(Элемент.СписокВыбора[0].Значение) Тогда
		Элемент.СписокВыбора.Очистить();
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.БыстрыйПоиск.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
			Или Элемент.РежимВыбораИзСписка
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Число")
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Дата")
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
		ТекущиеДанные.Тип,
		ДанныеВыбора,
		Текст,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Элемент.СписокВыбора.Количество() > 0 И Не ЗначениеЗаполнено(Элемент.СписокВыбора[0].Значение) Тогда
		Элемент.СписокВыбора.Очистить();
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.БыстрыйПоиск.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
			Или Элемент.РежимВыбораИзСписка
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Число")
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Дата")
			Или ТипЗнч(ТекущиеДанные.Значение) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	МассивТипов = СтрРазделить(ТекущиеДанные.Тип, ";", Ложь);
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьЗначениеРеквизитаДОЗавершениеВводаЗначения", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыбратьЗначениеРеквизитаДО(
		ЭтотОбъект,
		Элементы.БыстрыйПоискЗначение,
		МассивТипов,
		ТекущиеДанные.ПредставлениеЗначения,
		ТекущиеДанные.Значение,
		ТекущиеДанные.ЗначениеID,
		ТекущиеДанные.ЗначениеТип,
		Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаДОЗавершениеВводаЗначения(Результат, ПараметрыОповещения) Экспорт
	
	ТекущиеДанные = Элементы.БыстрыйПоиск.ТекущиеДанные;
	
	Если Результат <> Неопределено Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			ТекущиеДанные.Значение = Результат.РеквизитПредставление;
			ТекущиеДанные.ЗначениеID = Результат.РеквизитID;
			ТекущиеДанные.ЗначениеТип = Результат.РеквизитТип;
		Иначе
			ТекущиеДанные.Значение = Результат;
		КонецЕсли;
		БыстрыйПоискПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.БыстрыйПоиск.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ТекущиеДанные.Параметр = "Состояние" И ВыбранноеЗначение = НСтр("ru = 'Выбрать несколько...'") Тогда
		
		ДопПараметры = Новый Структура("ТекущиеДанные", ТекущиеДанные);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"БыстрыйПоискВыборСостоянияЗавершение",
			ЭтотОбъект,
			ДопПараметры);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТекущиеДанныеЗначение", ТекущиеДанные.Значение);
		ПараметрыОткрытия.Вставить("ТекущиеДанныеЗначениеID", ТекущиеДанные.ЗначениеID);
		ПараметрыОткрытия.Вставить("ТекущиеДанныеЗначениеТип", ТекущиеДанные.ЗначениеТип);
		ПараметрыОткрытия.Вставить("Состояния", СпискиВыбораБыстрогоПоиска["Состояние"]);
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот3.Форма.БыстрыйПоискВыборСостояния",
			ПараметрыОткрытия,,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
		Возврат;
		
	КонецЕсли;
	
	ВыбранноеЗначениеВТекущиеДанные(ТекущиеДанные, ВыбранноеЗначение);
	
	БыстрыйПоискПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискВыборСостоянияЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Или ВыбранноеЗначение = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДополнительныеПараметры.ТекущиеДанные;
	
	ВыбранноеЗначениеВТекущиеДанные(ТекущиеДанные, ВыбранноеЗначение);
	
	БыстрыйПоискПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.БыстрыйПоиск.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные.Значение = ТекущиеДанные.ЗначениеПоУмолчанию;
	ТекущиеДанные.ЗначениеID = ТекущиеДанные.ЗначениеПоУмолчаниюID;
	ТекущиеДанные.ЗначениеТип = ТекущиеДанные.ЗначениеПоУмолчаниюID;
	
	БыстрыйПоискПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Закрыть(БыстрыйПоиск);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьОтбор(Команда)
	
	СброситьОтборНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбранноеЗначениеВТекущиеДанные(ТекущиеДанные, ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Свойство("name")
				И ВыбранноеЗначение.Свойство("ID")
				И ВыбранноеЗначение.Свойство("type") Тогда
			ТекущиеДанные.Значение = ВыбранноеЗначение.name;
			ТекущиеДанные.ЗначениеID = ВыбранноеЗначение.ID;
			ТекущиеДанные.ЗначениеТип = ВыбранноеЗначение.type;
		ИначеЕсли ВыбранноеЗначение.Свойство("Наименование")
				И ВыбранноеЗначение.Свойство("ID")
				И ВыбранноеЗначение.Свойство("Тип") Тогда
			ТекущиеДанные.Значение = ВыбранноеЗначение.Наименование;
			ТекущиеДанные.ЗначениеID = ВыбранноеЗначение.ID;
			ТекущиеДанные.ЗначениеТип = ВыбранноеЗначение.Тип;
		КонецЕсли;
	Иначе
		ТекущиеДанные.Значение = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура БыстрыйПоискПриИзмененииНаСервере()
	
	ОбновитьПредставлениеБыстрогоПоиска();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеБыстрогоПоиска()
	
	ИнтеграцияС1СДокументооборот3.ОбновитьПредставлениеБыстрогоПоиска(
		БыстрыйПоиск,
		Элементы.СброситьОтбор);
	
КонецПроцедуры

&НаСервере
Процедура СброситьОтборНаСервере()
	
	ИнтеграцияС1СДокументооборот3.СброситьБыстрыйПоиск(БыстрыйПоиск, Элементы.СброситьОтбор);
	
КонецПроцедуры

#КонецОбласти