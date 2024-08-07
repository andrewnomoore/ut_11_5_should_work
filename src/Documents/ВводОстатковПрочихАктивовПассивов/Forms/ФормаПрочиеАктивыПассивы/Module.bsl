
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьУчетПрочихАктивовПассивов = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов");
	Если НЕ ИспользоватьУчетПрочихАктивовПассивов Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаСтр                  = Строка(ВалютаУправленческогоУчета);

	СтрокаЗаголовка = "%1 (%2)";
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'Сумма'"), ВалютаСтр);
	Элементы.ПрочиеАктивыПассивыСумма.Заголовок = ЗаголовокСумма;
	
	ИспользуетсяНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если Не (ИспользуетсяНесколькоОрганизаций ИЛИ ЗначениеЗаполнено(Объект.Организация)) Тогда
		Объект.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	УстановитьЗаголовок();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковПрочихАктивовПассивов.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковПрочихАктивовПассивов.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	ИсправлениеДокументовКлиент.ПослеЗаписи(Объект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочиеАктивыПассивы

&НаКлиенте
Процедура ПрочиеАктивыПассивыСтатьяПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАктивыПассивыСтатьяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАктивыПассивыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	СтрокаТаблицы = Элементы.ПрочиеАктивыПассивы.ТекущиеДанные;
	ДоходыИРасходыКлиентСервер.ПриДобавленииСтрокиВТаблицу(ЭтотОбъект, СтрокаТаблицы, "Объект.ПрочиеАктивыПассивы");
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеАктивыПассивыАналитикаПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.АналитикаАктивовПассивовПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	Объект.Валюта = ЗначениеНастроекПовтИсп.ВалютаУправленческогоУчета();
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	
	Заголовок = ВводОстатковВызовСервера.ЗаголовокДокументаВводОстатковПоХозяйственнойОперации(Объект.Ссылка,
		Объект.Номер,
		Объект.Дата,
		Объект.ХозяйственнаяОперация);
	
КонецПроцедуры
	
#КонецОбласти
