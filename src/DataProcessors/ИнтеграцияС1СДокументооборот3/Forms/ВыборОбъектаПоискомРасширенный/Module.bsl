#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипОбъектаВыбора = Параметры.ТипОбъектаВыбора;
	
	РеквизитыОбъектаДО = Справочники.ПравилаИнтеграцииС1СДокументооборотом3.РеквизитыОбъектаДО(
		ТипОбъектаВыбора,
		Неопределено,
		Истина);
	
	Для Каждого Реквизит Из РеквизитыОбъектаДО Цикл
		Если Реквизит.ИмяРеквизитаВДО = "" Тогда
			Продолжить;
		КонецЕсли;
		ДобавитьРеквизитПоиска(Реквизит.Имя, Реквизит.Представление, Реквизит.Тип);
	КонецЦикла;
	
	РеквизитыПоиска.Сортировать("Представление");
	
	ИскатьСразу = Ложь;
	
	// в параметрах могут быть предустановленные условия
	Если Параметры.Свойство("Отбор") И Параметры.Отбор <> Неопределено Тогда
		Для Каждого ПредустановленноеУсловие Из Параметры.Отбор Цикл
			ИмяРеквизита = ПредустановленноеУсловие.Ключ;
			ОписаниеУсловия = ПредустановленноеУсловие.Значение;
			СтруктураОтбора = Новый Структура("Имя", ИмяРеквизита);
			СтрокиУсловия = РеквизитыПоиска.НайтиСтроки(СтруктураОтбора);
			Если СтрокиУсловия.Количество() > 0 Тогда
				СтрокаУсловия = СтрокиУсловия[0];
				СтрокаУсловия.ОператорСравнения = "=";
				Если ТипЗнч(ОписаниеУсловия) = Тип("Структура") Тогда // сложное условие
					ЗаполнитьЗначенияСвойств(СтрокаУсловия, ОписаниеУсловия);
				Иначе // значение отбора указано напрямую
					СтрокаУсловия.Значение = ОписаниеУсловия;
				КонецЕсли;
				СобратьПредставлениеУсловия(СтрокаУсловия);
			КонецЕсли;
		КонецЦикла;
		ИскатьСразу = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ИскатьСразу") Тогда
		ИскатьСразу = Параметры.ИскатьСразу;
	КонецЕсли;
	
	Если ИскатьСразу Тогда
		Обработки.ИнтеграцияС1СДокументооборот3.ВыполнитьПоискПоРеквизитам(
			ТипОбъектаВыбора,
			СтруктураОтбора(),
			АдресВоВременномХранилище,
			КоличествоРезультатов,
			ПредельноеКоличествоРезультатов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ИскатьСразу Или КоличествоРезультатов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработатьРезультатПоиска", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПростойПоискНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ТипОбъектаВыбора);
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора());
	ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
	Закрыть();
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот3.Форма.ВыборОбъектаПоиском",
		ПараметрыФормы,
		ЭтотОбъект,
		Новый УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРеквизитыПоиска

&НаКлиенте
Процедура РеквизитыПоискаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.РеквизитыПоиска.ТекущиеДанные;
	ЭлементПредставлениеУсловия = Элементы.РеквизитыПоискаПредставлениеУсловия;
	
	ЭлементПредставлениеУсловия.ОграничениеТипа = Новый ОписаниеТипов("Строка");
	
	Если ТекущиеДанные.РеквизитТип.Количество() > 1 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЗначениеТип = "Строка" Тогда
		ЭлементПредставлениеУсловия.ОграничениеТипа = Новый ОписаниеТипов("Строка");
		ПредставлениеУсловия = ТекущиеДанные.Значение;
		Если Лев(ПредставлениеУсловия, 1) = "%" Тогда
			ПредставлениеУсловия = Сред(ПредставлениеУсловия, 2);
		КонецЕсли;
		Если Прав(ПредставлениеУсловия, 1) = "%" Тогда
			ПредставлениеУсловия = Лев(ПредставлениеУсловия, СтрДлина(ПредставлениеУсловия) - 1);
		КонецЕсли;
		ТекущиеДанные.ПредставлениеУсловия = ПредставлениеУсловия;
		
	ИначеЕсли ТекущиеДанные.ЗначениеТип = "Число" Тогда
		ЭлементПредставлениеУсловия.ОграничениеТипа = Новый ОписаниеТипов(ТекущиеДанные.ЗначениеТип);
		ТекущиеДанные.ПредставлениеУсловия = ТекущиеДанные.Значение;
		
	ИначеЕсли ТекущиеДанные.ЗначениеТип = "Дата" Тогда
		ЭлементПредставлениеУсловия.ОграничениеТипа = Новый ОписаниеТипов(
			"Дата",,, Новый КвалификаторыДаты(ЧастиДаты.Дата));
		ТекущиеДанные.ПредставлениеУсловия = ТекущиеДанные.Значение;
		
	ИначеЕсли ТекущиеДанные.ЗначениеТип = "Булево" Тогда
		ЭлементПредставлениеУсловия.ОграничениеТипа = Новый ОписаниеТипов("Булево");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПоискаПриАктивизацииСтроки(Элемент)
	
	Тип = "";
	Если Элементы.РеквизитыПоиска.ТекущиеДанные.РеквизитТип.Количество() = 1 Тогда
		Тип = Элементы.РеквизитыПоиска.ТекущиеДанные.РеквизитТип[0].Значение
	КонецЕсли;
	
	Элементы.РеквизитыПоискаПредставлениеУсловия.РедактированиеТекста =
		Тип = "Строка" Или Тип = "Число" Или Тип = "Дата";
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПоискаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.РеквизитыПоиска.ТекущиеДанные;
	
	Если ТекущиеДанные.РеквизитТип.Количество() > 1 Тогда
		Возврат;
	КонецЕсли;
	
	ВведенноеЗначение = ТекущиеДанные.ПредставлениеУсловия;
	Если Не ЗначениеЗаполнено(ВведенноеЗначение) Тогда // считаем очистку вручную отказом от поиска
		ТекущиеДанные.ОператорСравнения = "";
		
	ИначеЕсли Не ЗначениеЗаполнено(ТекущиеДанные.ОператорСравнения) Тогда // назначим условие
		Если ТекущиеДанные.ЗначениеТип = "Строка" Тогда
			ТекущиеДанные.ОператорСравнения = "LIKE";
			ТекущиеДанные.Значение = "%" + ВведенноеЗначение + "%";
		ИначеЕсли ТекущиеДанные.ЗначениеТип = "Дата" Тогда
			ТекущиеДанные.ОператорСравнения = ">=";
			ТекущиеДанные.Значение = ВведенноеЗначение;
		ИначеЕсли ТекущиеДанные.ЗначениеТип = "Число" Тогда
			ТекущиеДанные.ОператорСравнения = "=";
			ТекущиеДанные.Значение = ВведенноеЗначение;
		КонецЕсли;
		
	Иначе // условие уже есть, меняется только значение
		Если ТекущиеДанные.ЗначениеТип = "Строка" И ТекущиеДанные.ОператорСравнения = "LIKE" Тогда
			// сохраним нюансы поиска по подобию
			ТекущиеДанные.Значение = ?(Лев(ТекущиеДанные.Значение, 1) = "%", "%", "")
				+ ВведенноеЗначение + ?(Прав(ТекущиеДанные.Значение, 1) = "%", "%", "");
		Иначе
			ТекущиеДанные.Значение = ВведенноеЗначение;
		КонецЕсли;
		
	КонецЕсли;
	
	СобратьПредставлениеУсловия(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПоискаПредставлениеУсловияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.РеквизитыПоиска.ТекущиеДанные;
	
	Если ТекущиеДанные.ЗначениеТип <> "" Тогда
		ВыбратьЗначениеТипаРеквизитаЗавершение(ТекущиеДанные.ЗначениеТип, СтандартнаяОбработка);
		
	ИначеЕсли ТекущиеДанные.РеквизитТип.Количество() = 1 Тогда
		Значение = ТекущиеДанные.РеквизитТип[0].Значение;
		ВыбратьЗначениеТипаРеквизитаЗавершение(Значение, СтандартнаяОбработка);
		
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыбратьЗначениеТипаРеквизитаЗавершение",
			ЭтотОбъект,
			СтандартнаяОбработка);
		ПоказатьВыборИзСписка(ОписаниеОповещения, ТекущиеДанные.РеквизитТип, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеТипаРеквизитаЗавершение(Знач ЗначениеТипа, СтандартнаяОбработка) Экспорт
	
	ТекущиеДанные = Элементы.РеквизитыПоиска.ТекущиеДанные;
	
	Если ТипЗнч(ЗначениеТипа) = Тип("ЭлементСпискаЗначений") Тогда
		ЗначениеТипа = ЗначениеТипа.Значение;
	КонецЕсли;
	
	Если ЗначениеТипа = "Булево" Тогда // стандартный выпадающий список годится
		ТекущиеДанные.ЗначениеТип = "Булево";
		Элементы.РеквизитыПоискаПредставлениеУсловия.ОграничениеТипа = Новый ОписаниеТипов("Булево");
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ЗначениеТип = "";
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("РеквизитыПоискаПредставлениеУсловияЗавершениеВыбора",
		ЭтотОбъект,
		Элементы.РеквизитыПоиска);
	
	Если ЗначениеТипа = "Строка" Или ЗначениеТипа = "Дата" Или ЗначениеТипа = "Число" Тогда
		
		ИмяФормыВвода = СтрШаблон(
			"Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВводРеквизитаПоиска%1",
			ЗначениеТипа);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", ТекущиеДанные.Представление);
		ПараметрыФормы.Вставить("Значение", ТекущиеДанные.Значение);
		ПараметрыФормы.Вставить("ОператорСравнения", ТекущиеДанные.ОператорСравнения);
		ПараметрыФормы.Вставить("Значение2", ТекущиеДанные.Значение2);
		ПараметрыФормы.Вставить("ОператорСравнения2", ТекущиеДанные.ОператорСравнения2);
		ОткрытьФорму(
			ИмяФормыВвода,
			ПараметрыФормы,
			ЭтотОбъект,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли ЗначениеЗаполнено(ЗначениеТипа) Тогда // ссылочный тип ДО
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТипОбъектаВыбора", ЗначениеТипа);
		
		Если ЗначениеЗаполнено(ТекущиеДанные.ЗначениеID) Тогда
			ПараметрыФормы.Вставить("ВыбранныйЭлемент", ТекущиеДанные.ЗначениеID);
		КонецЕсли;
		
		Если ИнтеграцияС1СДокументооборот3КлиентПовтИсп.ЭтоДокументДО3(ЗначениеТипа)
				Или ЗначениеТипа = "DMCorrespondent" Или ЗначениеТипа = "DMMeeting" Тогда
			// объектов ДО потенциально много, нужен выбор поиском
			Отбор = Новый Структура;
			Если ЗначениеЗаполнено(ТекущиеДанные.Значение) Тогда
				Отбор.Вставить("name", СокрЛП(ТекущиеДанные.Значение));
				ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
			КонецЕсли;
			ПараметрыФормы.Вставить("Отбор", Отбор);
			
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот3.Форма.ВыборОбъектаПоиском",
				ПараметрыФормы,
				ЭтотОбъект,
				УникальныйИдентификатор,,,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			
		Иначе
			// обычный выбор из списка
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВыборИзСписка",
				ПараметрыФормы,
				ЭтотОбъект,
				Новый УникальныйИдентификатор,,,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПоискаПредставлениеУсловияОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.РеквизитыПоиска.ТекущиеДанные;
	
	ТекущиеДанные.ОператорСравнения = "";
	ТекущиеДанные.Значение = "";
	ТекущиеДанные.ЗначениеID = "";
	ТекущиеДанные.Значение2 = "";
	ТекущиеДанные.ОператорСравнения2 = "";
	ТекущиеДанные.ПредставлениеУсловия = "";
	
	Если ТекущиеДанные.РеквизитТип.Количество() = 1 Тогда
		ТекущиеДанные.ЗначениеТип = ТекущиеДанные.РеквизитТип[0].Значение;
	Иначе
		ТекущиеДанные.ЗначениеТип = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПоискаПредставлениеУсловияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РеквизитыПоиска.ТекущиеДанные;
	Если ТекущиеДанные.ЗначениеТип = "Булево" Тогда
		ТекущиеДанные.ОператорСравнения = "=";
		ТекущиеДанные.Значение = ТекущиеДанные.ПредставлениеУсловия;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Искать(Команда)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьРезультатПоиска()
	
	Если КоличествоРезультатов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Заданные условия поиска не дали ни одного результата.'"));
		
	ИначеЕсли ПредельноеКоличествоРезультатов <> 0 Тогда
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, СтрШаблон(
			НСтр("ru = 'Да, показать первые %1'"),
				Формат(ПредельноеКоличествоРезультатов, "ЧГ=0")));
		Кнопки.Добавить(Ложь, НСтр("ru = 'Нет, уточнить условия'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПоискЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru = 'Заданные условия поиска дали слишком много результатов. Показать результаты?'"),
			Кнопки);
		
	Иначе
		ПерейтиКРезультатамПоиска();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРеквизитПоиска(Имя, Представление, Тип)
	
	СтрокаРеквизита = РеквизитыПоиска.Добавить();
	СтрокаРеквизита.Имя = Имя;
	СтрокаРеквизита.Представление = Представление;
	СтрокаРеквизита.РеквизитТип = Тип;
	
	Если Тип.Количество() = 1 Тогда
		СтрокаРеквизита.ЗначениеТип = Тип[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

// Собирает представление условия поиска из значения и оператора сравнения
//
&НаКлиентеНаСервереБезКонтекста
Процедура СобратьПредставлениеУсловия(ТекущиеДанные)
	
	Тип = ТекущиеДанные.ЗначениеТип;
	Оператор = ТекущиеДанные.ОператорСравнения;
	Оператор2 = ТекущиеДанные.ОператорСравнения2;
	Значение = ТекущиеДанные.Значение;
	Значение2 = ТекущиеДанные.Значение2;
	Если ЗначениеЗаполнено(Оператор) Тогда
		Если Тип = "Строка" Тогда
			Если Оператор = "=" Тогда
				Представление = СтрШаблон(НСтр("ru = 'равно ""%1""'"), Значение);
				
			ИначеЕсли Оператор = "LIKE" Тогда
				Если Лев(Значение, 1) = "%" И Прав(Значение, 1) = "%" Тогда
					Представление = СтрШаблон(
						НСтр("ru = 'содержит ""%1""'"), Сред(Значение, 2, СтрДлина(Значение) - 2));
					
				ИначеЕсли Лев(Значение, 1) = "%" Тогда
					Представление = СтрШаблон(НСтр("ru = 'заканчивается на ""%1""'"), Сред(Значение,2));
					
				ИначеЕсли Прав(Значение, 1) = "%" Тогда
					Представление = СтрШаблон(
						НСтр("ru = 'начинается с ""%1""'"), Лев(Значение, СтрДлина(Значение) - 1));
					
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли Тип = "Число" Тогда
			Если Оператор = "=" Тогда
				Представление = Значение;
				
			ИначеЕсли ЗначениеЗаполнено(Оператор2) Тогда
				Представление = СтрШаблон(НСтр("ru = 'между %1 и %2'"), Значение, Значение2);
				
			ИначеЕсли Оператор = "<=" Тогда
				Представление = СтрШаблон(НСтр("ru = 'по %1'"), Значение);
				
			ИначеЕсли Оператор = ">=" Тогда
				Представление = СтрШаблон(НСтр("ru = 'от %1'"), Значение);
				
			КонецЕсли;
			
		ИначеЕсли Тип = "Дата" Тогда
			Если Оператор = "=" Тогда
				Если ЗначениеЗаполнено(Значение) Тогда
					Представление = Формат(Значение, "ДЛФ=D");
				Иначе
					Представление = "(" + НСтр("ru = 'пустая'") + ")";
				КонецЕсли;
				
			ИначеЕсли ЗначениеЗаполнено(Оператор2) Тогда
				Представление = СтрШаблон(
					НСтр("ru = 'между %1 и %2'"), Формат(Значение, "ДЛФ=D"), Формат(Значение2, "ДЛФ=D"));
				
			ИначеЕсли Оператор = "<=" Тогда
				Представление = СтрШаблон(НСтр("ru = 'по %1'"), Формат(Значение, "ДЛФ=D"));
				
			ИначеЕсли Оператор = ">=" Тогда
				Представление = СтрШаблон(НСтр("ru = 'с %1'"), Формат(Значение, "ДЛФ=D"));
				
			КонецЕсли;
			
		Иначе // ссылочный тип или Булево
			Представление = Строка(Значение);
			
		КонецЕсли;
		
	Иначе // оператор не указан
		Представление = "";
		
	КонецЕсли;
	
	ТекущиеДанные.ПредставлениеУсловия = Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПоискаПредставлениеУсловияЗавершениеВыбора(Результат, Элемент) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если Результат.Свойство("РеквизитID") Тогда // ссылочный тип
		Если Результат.РеквизитТип = "DMFileFolder"
				Или Результат.РеквизитТип = "DMDocumentFolder"
				Или Результат.РеквизитТип = "DMMeetingFolder" Тогда
			ТекущиеДанные.ОператорСравнения = "IN HIERARCHY";
		Иначе
			ТекущиеДанные.ОператорСравнения = "=";
		КонецЕсли;
		ТекущиеДанные.Значение = Результат.РеквизитПредставление;
		ТекущиеДанные.ЗначениеID = Результат.РеквизитID;
		ТекущиеДанные.ЗначениеТип = Результат.РеквизитТип;
		
	Иначе // примитивный тип
		ТекущиеДанные.Значение = Результат.Значение;
		ТекущиеДанные.ЗначениеТип = Строка(ТипЗнч(Результат.Значение));
		Если Результат.Свойство("ОператорСравнения") Тогда
			ТекущиеДанные.ОператорСравнения = Результат.ОператорСравнения;
		КонецЕсли;
		Если Результат.Свойство("ОператорСравнения2") Тогда
			ТекущиеДанные.ОператорСравнения2 = Результат.ОператорСравнения2;
		КонецЕсли;
		Если Результат.Свойство("Значение2") Тогда
			ТекущиеДанные.Значение2 = Результат.Значение2;
		КонецЕсли;
		
	КонецЕсли;
	
	СобратьПредставлениеУсловия(ТекущиеДанные);
	Элемент.ЗакончитьРедактированиеСтроки(Истина);
	Если Результат.Свойство("НайтиСразу") И Результат.НайтиСразу Тогда
		ВыполнитьПоиск();
	КонецЕсли;
	
КонецПроцедуры

// Упаковывает параметры отбора в структуру, предназначенную для передачи в открываемые формы
//
&НаСервере
Функция СтруктураОтбора()
	
	Отбор = Новый Структура;
	Для Каждого РеквизитПоиска Из РеквизитыПоиска Цикл
		Если ЗначениеЗаполнено(РеквизитПоиска.ОператорСравнения) Тогда
			Значение = Новый Структура;
			Значение.Вставить("Представление", РеквизитПоиска.Представление);
			Значение.Вставить("Значение", РеквизитПоиска.Значение);
			Значение.Вставить("ЗначениеТип", РеквизитПоиска.ЗначениеТип);
			Значение.Вставить("ЗначениеID", РеквизитПоиска.ЗначениеID);
			Значение.Вставить("ОператорСравнения", РеквизитПоиска.ОператорСравнения);
			Если ЗначениеЗаполнено(РеквизитПоиска.ОператорСравнения2) Тогда
				Значение.Вставить("ОператорСравнения2", РеквизитПоиска.ОператорСравнения2);
				Значение.Вставить("Значение2", РеквизитПоиска.Значение2);
			КонецЕсли;
			Значение.Вставить("ПредставлениеУсловия", РеквизитПоиска.ПредставлениеУсловия);
			Отбор.Вставить(РеквизитПоиска.Имя, Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Отбор;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	ВыполнитьПоискНаСервере(
		ТипОбъектаВыбора,
		АдресВоВременномХранилище,
		КоличествоРезультатов,
		ПредельноеКоличествоРезультатов);
	ОбработатьРезультатПоиска();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискЗавершение(Результат, Параметры) Экспорт
	
	Если Результат Тогда
		ПерейтиКРезультатамПоиска();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРезультатамПоиска()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ТипОбъектаВыбора);
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора());
	ПараметрыФормы.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	Закрыть();
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот3.Форма.ВыборОбъектаПоискомРезультаты",
		ПараметрыФормы,
		ЭтотОбъект,
		Новый УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНаСервере(ТипОбъектаВыбора, АдресВоВременномХранилище, КоличествоРезультатов, ПредельноеКоличествоРезультатов)
	
	Обработки.ИнтеграцияС1СДокументооборот3.ВыполнитьПоискПоРеквизитам(
		ТипОбъектаВыбора,
		СтруктураОтбора(),
		АдресВоВременномХранилище,
		КоличествоРезультатов,
		ПредельноеКоличествоРезультатов);
	
КонецПроцедуры

#КонецОбласти