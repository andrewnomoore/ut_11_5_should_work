#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ТипОбъектаДО", ТипОбъектаДО);
	
	Если Параметры.ЭтоТаблица Тогда
		Заголовок =  НСтр("ru = 'Выбор таблицы 1С:Документооборота'");
	Иначе
		Заголовок =  НСтр("ru = 'Выбор реквизита 1С:Документооборота'");
	КонецЕсли;
	
	ЗаполнитьДеревоРеквизитов(
		Параметры.РеквизитыОбъектаДО,
		Параметры.ИмяРеквизитаОбъектаДО,
		Параметры.ПредставлениеРеквизитаОбъектаИС,
		Параметры.ЭтоТаблица,
		Параметры.Таблица);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоРеквизитов

&НаКлиенте
Процедура ДеревоРеквизитовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ВыбратьЗначениеРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРеквизитовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьЗначениеРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьЗначениеРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьЗначениеРеквизита()
	
	ТекущиеДанные = Элементы.ДеревоРеквизитов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
			Или (ТекущиеДанные.Имя = "" И Не ТекущиеДанные.ЭтоДополнительныйРеквизитДО)
			Или ТекущиеДанные.Недоступно Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Имя", ?(ЗначениеЗаполнено(ТекущиеДанные.Таблица),
		СтрШаблон("%1.%2", ТекущиеДанные.Таблица, ТекущиеДанные.Имя),
		ТекущиеДанные.Имя));
	Результат.Вставить("Представление", ТекущиеДанные.Представление);
	Результат.Вставить("ЭтоДополнительныйРеквизитДО", ТекущиеДанные.ЭтоДополнительныйРеквизитДО);
	Результат.Вставить("ДополнительныйРеквизитДОID", ТекущиеДанные.ДополнительныйРеквизитДОID);
	Результат.Вставить("ДополнительныйРеквизитДОТип", ТекущиеДанные.ДополнительныйРеквизитДОТип);
	Результат.Вставить("ЭтоТаблица", ТекущиеДанные.ЭтоТаблица);
	Результат.Вставить("Таблица", ТекущиеДанные.Таблица);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоРеквизитов(РеквизитыОбъектаДО, ИмяРеквизитаОбъектаДО, ПредставлениеРеквизитаОбъектаИС,
		ЭтоТаблица, Таблица)
	
	Дерево = РеквизитФормыВЗначение("ДеревоРеквизитов");
	
	УровеньДерева = Дерево.Строки;
	
	Для Каждого Реквизит Из РеквизитыОбъектаДО Цикл // см. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеРеквизита
		
		// Таблицы заполняются только таблицами.
		Если ЭтоТаблица И Не Реквизит.ЭтоТаблица Тогда
			Продолжить;
		КонецЕсли;
		
		Если Реквизит.Таблица = "" Тогда
			УровеньДерева = Дерево.Строки;
		КонецЕсли;
		
		НоваяСтрока = УровеньДерева.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Реквизит);
		Если Реквизит.ЭтоТаблица Тогда
			УровеньДерева = НоваяСтрока.Строки;
			НоваяСтрока.Тип = НСтр("ru = 'Таблица'");
		Иначе
			НоваяСтрока.Тип = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПредставлениеТипаОбъектаXDTO(
				Строка(Реквизит.Тип));
		КонецЕсли;
		
		// Реквизит таблицы нельзя заполнить реквизитом другой таблицы.
		Если ЗначениеЗаполнено(Таблица) И ЗначениеЗаполнено(Реквизит.Таблица) И Таблица <> Реквизит.Таблица Тогда
			НоваяСтрока.Недоступно = Истина;
		КонецЕсли;
		
		// Реквизит нельзя заполнить другой таблицей.
		Если Реквизит.ЭтоТаблица И Не ЭтоТаблица Тогда
			НоваяСтрока.Недоступно = Истина;
		КонецЕсли;
		
		// Обычный реквизит нельзя заполнить реквизитом таблицы или самой таблицей.
		Если Не ЗначениеЗаполнено(Таблица) И Не ЭтоТаблица
				И (ЗначениеЗаполнено(Реквизит.Таблица) Или Реквизит.ЭтоТаблица) Тогда
			НоваяСтрока.Недоступно = Истина;
		КонецЕсли;
		
		НоваяСтрока.Выделено = ЗначениеЗаполнено(Таблица) И Реквизит.ЭтоТаблица И Таблица = Реквизит.Имя;
		
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоТаблица, Представление");
	
	Для Каждого Строка Из Дерево.Строки Цикл
		Если Строка.ЭтоТаблица Тогда
			Строка.Строки.Сортировать("Представление");
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоРеквизитов");
	
	// Найдем таблицу.
	Если ЗначениеЗаполнено(Таблица) Тогда
		Для Каждого ЭлементДерева Из ДеревоРеквизитов.ПолучитьЭлементы() Цикл
			Если ЭлементДерева.ЭтоТаблица
				И ЭлементДерева.Имя = Таблица Тогда
				Элементы.ДеревоРеквизитов.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Найдем ранее выбранный реквизит.
	Если ЗначениеЗаполнено(ИмяРеквизитаОбъектаДО) Тогда
		Для Каждого ЭлементДерева Из ДеревоРеквизитов.ПолучитьЭлементы() Цикл
			Если ЭлементДерева.Имя = ИмяРеквизитаОбъектаДО
				И ЭлементДерева.Таблица = Таблица Тогда
				Элементы.ДеревоРеквизитов.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
				Возврат;
			КонецЕсли;
			Если ЭлементДерева.ЭтоТаблица Тогда
				Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
					Если СтрШаблон("%1.%2", ПодчиненныйЭлемент.Таблица, ПодчиненныйЭлемент.Имя) = ИмяРеквизитаОбъектаДО Тогда
						Элементы.ДеревоРеквизитов.ТекущаяСтрока = ПодчиненныйЭлемент.ПолучитьИдентификатор();
						Возврат;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Найдем подходящий по представлению.
	Для Каждого ЭлементДерева Из ДеревоРеквизитов.ПолучитьЭлементы() Цикл
		Если ЭлементДерева.Представление = ПредставлениеРеквизитаОбъектаИС
			И ЭлементДерева.Таблица = Таблица Тогда
			Элементы.ДеревоРеквизитов.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
		КонецЕсли;
		Если ЭлементДерева.ЭтоТаблица Тогда
			Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
				Если ПодчиненныйЭлемент.Представление = ПредставлениеРеквизитаОбъектаИС
					И ПодчиненныйЭлемент.Таблица = Таблица Тогда
					Элементы.ДеревоРеквизитов.ТекущаяСтрока = ПодчиненныйЭлемент.ПолучитьИдентификатор();
					Возврат;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти