
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	ОбработатьПереданныеПараметры(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьЭлементыФормыПриСоздании();
	УстановитьЗаголовокФормы();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_МестаХраненияСАТУРН"
		И ТипЗнч(Источник) = Тип("СправочникСсылка.МестаХраненияСАТУРН") Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Источник;
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагруженные;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыФормыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если РежимВыбора Тогда
		
		Если ТекущаяСтраница = Элементы.СтраницаЗагруженные Тогда
			Элементы.СписокВыбрать.КнопкаПоУмолчанию = Истина;
		Иначе
			Элементы.ВыбратьИзКлассификатора.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	
	КонецЕсли;
	
	Если Не ПереключениеМеждуСтраницамиВыполнялось
		И РежимВыбора
		И ПараметрыПоиска.Количество() Тогда
		
		ОбработатьНайденныеМестаХранения(1);
		
	КонецЕсли;
	
	ПереключениеМеждуСтраницамиВыполнялось = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПараметровПоискаВКлассификатореОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьФормуПараметрыПоиска" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ПараметрыПоиска", ПараметрыПоиска);
		
		ОткрытьФорму(
			"Справочник.МестаХраненияСАТУРН.Форма.ПараметрыПоиска",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			Новый ОписаниеОповещения("ОбработатьПараметрыПоискаВКлассификаторе", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоПредприятияОрганизацииПриИзменении(Элемент)
	ОтборПоОрганизацииПриИзмененииСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОтборПоОрганизацииПриИзмененииСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	ТолькоМестаХраненияОрганизации = Ложь;
	ОтборПоОрганизацииПриИзмененииСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриВыбореИзЗагруженных();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМестаХраненияСАТУРН 

&НаКлиенте
Процедура МестаХраненияСАТУРНВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПриВыбореИзДанныхКлассификатора();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДанныеКлассификатора(Команда)
	
	ТекущиеДанные = Элементы.МестаХраненияСАТУРН.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, ОбщегоНазначенияИСКлиентСервер.ТекстКомандаНеМожетБытьВыполнена());
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	ПриВыбореИзДанныхКлассификатора();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзЗагруженных(Команда)
	ПриВыбореИзЗагруженных();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияФормыИУправлениеЭлементами

&НаСервере
Процедура ОтборПоОрганизацииПриИзмененииСервере()

	Если Не ТолькоМестаХраненияОрганизации Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Неопределено,,, Ложь);
		ПараметрыПоиска = Новый Структура;
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка",
			ИнтеграцияСАТУРНВызовСервера.МестаХраненияОрганизацииСАТУРН(Организация, Истина),
			ВидСравненияКомпоновкиДанных.ВСписке,
			НСтр("ru = 'Места хранения владельца'"),
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
		Если ЗначениеЗаполнено(Организация) Тогда
			ПараметрыПоиска.Вставить("Организация", Организация);
		Иначе
			ПараметрыПоиска = Новый Структура;
		КонецЕсли;
		СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПереданныеПараметры(Отказ)
	
	РежимВыбора          = Параметры.РежимВыбора;
	
	Если ТипЗнч(Параметры.ПараметрыПоиска) = Тип("Структура") Тогда

		ПараметрыПоиска = Параметры.ПараметрыПоиска;
		ОбработатьНайденныеМестаХранения(1);
	
	Иначе
		ПараметрыПоиска = Новый Структура;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ОрганизацияСАТУРН") Тогда
		Организация      = Параметры.Отбор.ОрганизацияСАТУРН;
	Иначе
		Организация      = Параметры.ОрганизацияСАТУРН;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Элементы.ГруппаОтборОрганизация.Видимость = Истина;
		ТолькоМестаХраненияОрганизации            = Истина;
		
		ОтборПоОрганизацииПриИзмененииСервере();
		
		ПараметрыПоиска.Вставить("Организация", Организация);
		
	Иначе
		
		Элементы.ГруппаОтборОрганизация.Видимость = Ложь;
		
		Если ТипЗнч(Параметры.ПараметрыПоиска) = Тип("Структура") Тогда
			ПараметрыПоиска = Параметры.ПараметрыПоиска;
			ОбработатьНайденныеМестаХранения(1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыПриСоздании()

	СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска, Истина);

	Если РежимВыбора Тогда
		
		Элементы.СписокВыбрать.Видимость                = Истина;
		Элементы.СписокКонтекстноеМенюВыбрать.Видимость = Истина;
		
	Иначе
		
		Элементы.СписокВыбрать.Видимость                = Ложь;
		Элементы.СписокКонтекстноеМенюВыбрать.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()

	ТекстЗаголовка = "";
	
	Если РежимВыбора Тогда
		ТекстЗаголовка = НСтр("ru = 'Выбор места хранения САТУРН'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Классификатор мест хранения САТУРН'");
	КонецЕсли;
	
	Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Загруженные. Отображение неактивными элементы со статусами кроме Актуально
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыОбъектовСАТУРН.Актуально;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	// Классификатор. Отображение неактивными элементы со статусами кроме Актуально
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МестаХраненияСАТУРН.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыОбъектовСАТУРН.Актуально;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
		
	// Загруженные. Вывод подтипа места хранения: Склад временного хранения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Склад временного хранения'"));
	
	// Загруженные. Вывод подтипа места хранения: Это производственная площадка
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Площадка производства'"));
	
	// Загруженные. Вывод подтипа места хранения: Это производственная площадка + Склад временного хранения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Склад временного хранения; Площадка производства'"));
	
	// Загруженные. Вывод подтипа места хранения: незаполнено
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "-");
	
	// Классификатор. Вывод подтипа места хранения: Склад временного хранения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МестаХраненияСАТУРНПодтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Склад временного хранения'"));
	
	// Классификатор. Вывод подтипа места хранения: Это производственная площадка
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МестаХраненияСАТУРНПодтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Площадка производства'"));
	
	// Классификатор. Вывод подтипа места хранения: Это производственная площадка + Склад временного хранения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МестаХраненияСАТУРНПодтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Склад временного хранения; Площадка производства'"));
	
	// Классификатор. Вывод подтипа места хранения: незаполнено
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МестаХраненияСАТУРНПодтип.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоСкладВременногоХранения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестаХраненияСАТУРН.ЭтоПроизводственнаяПлощадка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "-");

КонецПроцедуры

#КонецОбласти

#Область Поиск

&НаКлиенте
Процедура ОбработатьПараметрыПоискаВКлассификаторе(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПоиска = Результат;
	ОбработатьНайденныеМестаХранения(1);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьНайденныеМестаХранения(НомерСтраницы)
	
	МестаХраненияСАТУРН.Очистить();
	
	Если ПараметрыПоиска.Свойство("Идентификатор") Тогда
		Результат = ИнтерфейсСАТУРНВызовСервера.МестоХраненияПоИдентификатору(ПараметрыПоиска.Идентификатор);
		ДобавитьВСписокНайденноеМестоХранения(Результат);
	Иначе
		
		КоличествоЭлементовНаСтранице = 100;
		Результат = ИнтерфейсСАТУРНВызовСервера.СписокМестХранения(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
		ЗаполнитьСписокМестХранения(Результат, НомерСтраницы);
		
	КонецЕсли;
	
	СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуСоСкладомСАТУРН(ДанныеМестаХранения)
	
	ДанныеМестаХранения = ИнтерфейсСАТУРН.ДанныеМестаХранения(ДанныеМестаХранения);
	
	НоваяСтрока = МестаХраненияСАТУРН.Добавить();
	НоваяСтрока.Идентификатор       = ДанныеМестаХранения.Идентификатор;
	НоваяСтрока.GUID                = ДанныеМестаХранения.GUID;
	НоваяСтрока.Статус              = ДанныеМестаХранения.Статус;
	НоваяСтрока.ДатаСоздания        = ДанныеМестаХранения.ДатаСоздания;
	НоваяСтрока.ДатаИзменения       = ДанныеМестаХранения.ДатаИзменения;
	
	НоваяСтрока.Наименование            = ДанныеМестаХранения.Наименование;
	НоваяСтрока.НаименованиеСубъектаРФ  = ДанныеМестаХранения.НаименованиеСубъектаРФ;
	
	НоваяСтрока.Адрес                       = ДанныеМестаХранения.Адрес;
	НоваяСтрока.ОрганизацияСАТУРН           = ДанныеМестаХранения.ИдентификаторОрганизации;
	НоваяСтрока.ЭтоПроизводственнаяПлощадка = ДанныеМестаХранения.ЭтоПроизводственнаяПлощадка;
	НоваяСтрока.ЭтоСкладВременногоХранения  = ДанныеМестаХранения.ЭтоСкладВременногоХранения;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокМестХранения(Результат, НомерСтраницы)
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Результат.Список Цикл
		ДобавитьСтрокуСоСкладомСАТУРН(СтрокаТЧ);
	КонецЦикла;
	
	ОпределитьНаличиеСкладаВИБ();
	
	ОбщееКоличество = Результат.Список.Количество();
	
	Если ОбщееКоличество >= 500 Тогда
		КоличествоСтраниц = 2;
	Иначе
		КоличествоСтраниц = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВСписокНайденноеМестоХранения(Результат)
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если Результат.Элемент <> Неопределено Тогда
		ДобавитьСтрокуСоСкладомСАТУРН(Результат.Элемент);
	КонецЕсли;
	
	ОпределитьНаличиеСкладаВИБ();
	
	КоличествоСтраниц = 1;

	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПоискВКлассификаторе;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеСкладаВИБ()
	
	Если МестаХраненияСАТУРН.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ПараметрыОбмена = ИнтеграцияСАТУРН.ПараметрыОбмена();
	ИмяТаблицы      = Метаданные.Справочники.МестаХраненияСАТУРН.ПолноеИмя();
	
	Для Каждого СтрокаТаблицы Из МестаХраненияСАТУРН Цикл
		ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, СтрокаТаблицы.Идентификатор, Неопределено);
	КонецЦикла;
	
	ИнтеграцияСАТУРНСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена);
	
	Для Каждого СтрокаТаблицы Из МестаХраненияСАТУРН Цикл
		
		НайденнаяСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, СтрокаТаблицы.Идентификатор);
		Если ЗначениеЗаполнено(НайденнаяСсылка) Тогда
			
			СтрокаТаблицы.ИндексКартинкиЕстьВБазе = 1;
			СтрокаТаблицы.СкладСАТУРН             = НайденнаяСсылка;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПредставлениеОтбора

&НаСервере
Процедура СформироватьПредставлениеПараметровПоиска(ПараметрыОтбора, ПриСоздании = Ложь)
	
	СтрокаОтбор = "";
	
	КоличествоПараметровОтбора = 0;
	
	Если ПараметрыОтбора <> Неопределено Тогда
		
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'GUID'"),
			"GUID", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Идентификатор'"),
			"Идентификатор", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Организация'"),
			"Организация", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Наименование'"),
			"Наименование", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Статус'"), 
			"Статус", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Склад временного хранения'"),
			"ЭтоСкладВременногоХранения", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Производственная площадка'"),
			"ЭтоПроизводственнаяПлощадка", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Адрес'"),
			"АдресПредставление", КоличествоПараметровОтбора);
			
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Площадка без подтипов'"), 
			"БезПодтипов", КоличествоПараметровОтбора);
		
	КонецЕсли;
	
	Если КоличествоПараметровОтбора = 0 Тогда
		ПредставлениеОтбора = ПредставлениеПустогоОтбора(ЭтотОбъект, ПриСоздании);
	Иначе	
		ПредставлениеОтбора = ПредставлениеНеПустогоОтбора(СтрокаОтбор, ЭтотОбъект, ПриСоздании);
	КонецЕсли;
	
	КоличествоСтраницНесколько = КоличествоСтраниц > 1;
	НулевойРезультат           = МестаХраненияСАТУРН.Количество() = 0;
	
	Элементы.ГруппаИнформацияОНеКорректномЗапросе.Видимость = КоличествоСтраницНесколько И Не НулевойРезультат;
	
	Если ПриСоздании Или КоличествоСтраницНесколько И НулевойРезультат Тогда
		
		Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость = Истина;
		Элементы.ВыбратьИзКлассификатора.Видимость           = Ложь;
		
		Элементы.СтраницыМестаХраненияСАТУРН.ТекущаяСтраница = Элементы.СтраницаМестаХраненияСАТУРНПоискНеВыполнен;
		
		Если КоличествоСтраницНесколько Тогда
			Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость = Ложь;
			Элементы.ПоискНеНастроен.ОтображениеСостояния.Текст  =
				НСтр("ru = 'Заданные условия поиска дали слишком много результатов. Уточните реквизиты отбора и выполните поиск.'");
		КонецЕсли;
		
	Иначе
		
		Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость                           = Ложь;
		Элементы.ВыбратьИзКлассификатора.Видимость                                     = РежимВыбора;
		Элементы.МестаХраненияСАТУРНКонтекстноеМенюВыбратьИзКлассификатора.Видимость   = РежимВыбора;
		
		Элементы.СтраницыМестаХраненияСАТУРН.ТекущаяСтраница = Элементы.СтраницаМестаХраненияСАТУРНЭлементы;
		
	КонецЕсли;
	
	ПредставлениеПараметровПоиска = ПредставлениеОтбора;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВПредставление(Представление, ПараметрыОтбора, ПредставлениеПоля, ИмяПоля, КоличествоПараметров)
	
	Если ПараметрыОтбора.Свойство(ИмяПоля) Тогда
		
		Если ТипЗнч(ПараметрыОтбора[ИмяПоля]) = Тип("Структура")
			И ПараметрыОтбора[ИмяПоля].Свойство("ПредставлениеАдреса") Тогда
			Значение = ПараметрыОтбора[ИмяПоля].ПредставлениеАдреса;
		Иначе
			Значение = ПараметрыОтбора[ИмяПоля];
		КонецЕсли;
		
		КоличествоПараметров = КоличествоПараметров + 1;
		
	Иначе
		Значение = Неопределено;	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяПоля = "Наименование" Тогда
		Разделитель = " " + НСтр("ru = 'содержит'") + " ";
	Иначе
		Разделитель = " = ";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Представление) Тогда
		Представление = Представление + " " + НСтр("ru = 'и'") + " " + ПредставлениеПоля + Разделитель + """" + Значение + """";
	Иначе
		Представление = ПредставлениеПоля + Разделитель + """" + Значение + """";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеПустогоОтбора(Форма, ПриСоздании = Ложь)
	
	Если ПриСоздании Тогда
		
		Строки = Новый Массив;
		Строки.Добавить(НСтр("ru = 'Для вывода мест хранения САТУРН'"));
		Строки.Добавить(" ");
		Строки.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'настройте отбор'"),,
				Форма.ЦветГиперссылки,,
				"ОткрытьФормуПараметрыПоиска"));
		Строки.Добавить(" ");
		Строки.Добавить(НСтр("ru = 'и выполните поиск'"));
		
	Иначе

		СтрокаПредставлениеОтбора = НСтр("ru = 'Отбор не настроен'");

		МассивСтрокИзменить = Новый Массив;
	
		МассивСтрокИзменить.Добавить(" (");
		МассивСтрокИзменить.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'настроить отбор'"),,
				Форма.ЦветГиперссылки,,
				"ОткрытьФормуПараметрыПоиска"));
		МассивСтрокИзменить.Добавить(")");
	
		Строки = Новый Массив;
		Строки.Добавить(СтрокаПредставлениеОтбора);
		Строки.Добавить(Новый ФорматированнаяСтрока(МассивСтрокИзменить));
	
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(Строки);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеНеПустогоОтбора(СтрокаОтбор, Форма, ПриСоздании = Ложь)
	
	СтрокаПредставлениеОтбора = СтрШаблон(НСтр("ru = 'Установлен отбор по %1'"), СтрокаОтбор);
	
	МассивСтрокИзменить = Новый Массив;
	
	МассивСтрокИзменить.Добавить(" (");
	МассивСтрокИзменить.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'изменить'"),,
			Форма.ЦветГиперссылки,,
			"ОткрытьФормуПараметрыПоиска"));
	МассивСтрокИзменить.Добавить(")");
	
	Строки = Новый Массив;
	Строки.Добавить(СтрокаПредставлениеОтбора);
	Строки.Добавить(Новый ФорматированнаяСтрока(МассивСтрокИзменить));
	
	Возврат Новый ФорматированнаяСтрока(Строки);
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура МестоХраненияПослеСоздания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора
		И ЗначениеЗаполнено(Результат)
		И ТипЗнч(Результат) = Тип("СправочникСсылка.МестаХраненияСАТУРН") Тогда
		
		ОповеститьОВыборе(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДанныхКлассификатора(Идентификатор)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор", Идентификатор);
	
	ОповещениеОЗакрытииФормыДанныхКлассификатора = Новый ОписаниеОповещения("ДанныеКлассификатораПослеЗакрытия", ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.МестаХраненияСАТУРН.Форма.ДанныеКлассификатора",
		ПараметрыФормы, ЭтотОбъект,,,,
		ОповещениеОЗакрытииФормыДанныхКлассификатора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеКлассификатораПослеЗакрытия(Результат, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат)
		И ТипЗнч(Результат) = Тип("СправочникСсылка.МестаХраненияСАТУРН") Тогда
		
		Если РежимВыбора Тогда
			ОповеститьОВыборе(Результат);
		Иначе
			
			ОпределитьНаличиеСкладаВИБ();
			Элементы.Список.ТекущаяСтрока = Результат;
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагруженные;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореИзДанныхКлассификатора()

	ТекущиеДанные = Элементы.МестаХраненияСАТУРН.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.СкладСАТУРН) Тогда
			ОповеститьОВыборе(ТекущиеДанные.СкладСАТУРН);
		Иначе
			ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.Идентификатор);
		КонецЕсли;
		
	Иначе
		ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.Идентификатор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореИзЗагруженных()
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.Список, Истина, Ложь) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если РежимВыбора Тогда
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти