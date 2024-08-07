#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	УстановитьБыстрыйОтборСервер();
	СобытияФормСАТУРН.ПриСозданииНаСервереФормыСпискаДокументов(ЭтотОбъект);

	ИнтеграцияСАТУРН.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействие.СписокВыбора, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
	НастроитьВидимостьДоступностьЭлементовСервер();
	
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
		ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизации

&НаКлиенте
Процедура ОформленоОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",,,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",,,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Истина, "Оформлено",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Истина, "Оформлено",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлению",,,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлению",,,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Истина, "КОформлению",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Истина, "КОформлению",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению",,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Статус", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаКОформлениюОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Не Копирование Тогда
		
		ЗначенияЗаполнения = Новый Структура;
		Если ЗначениеЗаполнено(ОрганизацияСАТУРН) Тогда
			ЗначенияЗаполнения.Вставить("ОрганизацияСАТУРН", ОрганизацияСАТУРН);
		КонецЕсли;
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.НакладнаяСАТУРН.Форма.ФормаДокумента", ПараметрыФормы);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКОформлению

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьРаспоряжение(Элементы.СписокКОформлению, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияСАТУРНКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияСАТУРНКлиент.ОрганизацииДляОбмена(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Оформить(Команда)
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокКОформлению) Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуСозданияДокумента(
		ИнтеграцияИСКлиентСервер.ИмяОбъектаИзИмениФормы(ЭтотОбъект),
		Элементы.СписокКОформлению.ТекущиеДанные.ДокументОснование,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Архивировать(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(ЭтотОбъект, Элементы.СписокКОформлению, ИнтеграцияСАТУРНКлиент,
		ПредопределенноеЗначение("Документ.НакладнаяСАТУРН.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияСАТУРНКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияСАТУРНКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные"),
		"Грузоотправитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьНакладные(Команда)
	
	ЗапросНакладныхЗавершение = Новый ОписаниеОповещения("Подключаемый_ЗапросНакладныхЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = ИнтеграцияСАТУРНСлужебныйКлиент.ПараметрыОткрытияФормыЗапросаДокументов();
	Если ЗначениеЗаполнено(ОрганизацияСАТУРН) Тогда
		ПараметрыФормы.ОрганизацияСАТУРН = ОрганизацияСАТУРН;
	КонецЕсли;
	
	ИнтеграцияСАТУРНСлужебныйКлиент.ОткрытьФормуЗапросаДокументов(ПараметрыФормы, ЭтотОбъект, ЗапросНакладныхЗавершение);
	
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
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.Статус.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.НакладнаяСАТУРН.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействие.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.НакладнаяСАТУРН.ВсеТребующиеОжидания()); 
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗапросНакладныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.СписокКОформлению.Обновить();
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.НакладнаяСАТУРН.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.НакладнаяСАТУРН.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияСАТУРН.УстановитьОтборПоДальнейшемуДействию(
		Список, ДальнейшееДействие, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("ОрганизацииСАТУРН",              ОрганизацииСАТУРН);
		СтруктураБыстрогоОтбора.Свойство("ОрганизацияСАТУРН",              ОрганизацияСАТУРН);
		СтруктураБыстрогоОтбора.Свойство("ОрганизацииСАТУРНПредставление", ОрганизацииСАТУРНПредставление);
		СтруктураБыстрогоОтбора.Свойство("СопоставленныеОрганизации",      СопоставленныеОрганизации);
		
		ПрефиксыСписка = "Грузоотправитель,Грузополучатель";
		ИнтеграцияСАТУРНКлиентСервер.УстановитьОтборыДинамическогоСпискаПоОрганизацииСАТУРН(ЭтотОбъект, ПрефиксыСписка);
		
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,            "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		
	КонецЕсли;
	
	СобытияФормСАТУРН.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект);
	
	Если ИнтеграцияСАТУРН.НеобходимОтборПоДальнейшемуДействиюПриСозданииНаСервере(ДальнейшееДействие, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьДоступностьЭлементовСервер()
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Документы.НакладнаяСАТУРН) Тогда
		Элементы.СтраницаКОформлению.Видимость = Ложь;
	ИначеЕсли Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()

	ИнтеграцияСАТУРНСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти