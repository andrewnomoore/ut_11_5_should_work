
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждения = НСтр("ru = 'Документ ввод остатков необходимо создавать из рабочего места Начальное заполнение'");
	ОбщегоНазначения.СообщитьПользователю(ТекстПредупреждения);
	Отказ = Истина;
	Возврат;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	
	ДоступныеТипыОпераций = Документы.ВводОстатков.ДоступныеТипыОпераций(Ложь);
	Если Параметры.Свойство("ОтборПоТипамОпераций") И Параметры.ОтборПоТипамОпераций.Количество() > 0 Тогда
		Для Каждого ХозяйственнаяОперация Из Параметры.ОтборПоТипамОпераций Цикл
			Если ДоступныеТипыОпераций.Найти(ХозяйственнаяОперация.Значение) <> Неопределено Тогда
				СписокТиповОпераций.Добавить(ХозяйственнаяОперация.Значение);
			КонецЕсли;
		КонецЦикла;
	Иначе
		СписокТиповОпераций.ЗагрузитьЗначения(ДоступныеТипыОпераций);
	КонецЕсли;
	СписокТиповОпераций.СортироватьПоЗначению();
	
	
	Если Параметры.Свойство("Организация") Тогда
		Объект.Организация = Параметры.Организация;
	КонецЕсли;
	Если Параметры.Свойство("ОтражатьВОперативномУчете") Тогда
		Объект.ОтражатьВОперативномУчете = Параметры.ОтражатьВОперативномУчете;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Модифицированность = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)
	
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

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписоктиповопераций

&НаКлиенте
Процедура СписокТиповОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОбработкаВыбораТипаОперации();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораТипаОперации()

	СтрокаТаблицы = Элементы.СписокТиповОпераций.ТекущиеДанные;
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация",     СтрокаТаблицы.Значение);
		ЗначенияЗаполнения.Вставить("Организация",               Объект.Организация);
		ЗначенияЗаполнения.Вставить("ОтражатьВОперативномУчете", Объект.ОтражатьВОперативномУчете);
		
		Если СписокТипыОперацийНеОтражаемыеВРеглУчете.НайтиПоЗначению(ЗначенияЗаполнения.ХозяйственнаяОперация) = Неопределено Тогда
			ЗначенияЗаполнения.Вставить("ОтражатьВБУиНУ",            Объект.ОтражатьВБУиНУ);
			ЗначенияЗаполнения.Вставить("ОтражатьВУУ",               Объект.ОтражатьВУУ);
		Иначе
			ЗначенияЗаполнения.Вставить("ОтражатьВБУиНУ",            Ложь);
			ЗначенияЗаполнения.Вставить("ОтражатьВУУ",               Ложь);
		КонецЕсли;
		
		Модифицированность = Ложь;
		ОткрытьФорму("Документ.ВводОстатков.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ВладелецФормы, );//КлючИзПараметров
		Закрыть();
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьТипОперации(Команда)

	ОбработкаВыбораТипаОперации();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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


#КонецОбласти
