#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РежимНапоминания = Параметры.РежимНапоминания;
	УстановитьУсловноеОформление();
	УстановитьБыстрыйОтборСервер();
	
	СобытияФормЗЕРНО.ПриСозданииНаСервереФормыСпискаСправочников(ЭтотОбъект);
	
	ЗаполнитьТаблицуСообщенийКПодписанию();
	НастроитьЭлементыФормыНаСервере();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСрокиПовторногоНапоминания();
	СрокПовторногоОповещения = 10;
	
	ИменаПараметров    = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.ИменаПараметровПериодическогоПолученияДанных();
	ПараметрПриложения = ПараметрыПриложения[ИменаПараметров.ИмяПараметраПриложения]; // - см. ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыПриложенияОтветственныеЗаПодписаниеСообщений
	
	Если ПараметрПриложения <> Неопределено Тогда
		ПараметрПриложения.ОткрытаФормаСообщений = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ИменаПараметров    = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.ИменаПараметровПериодическогоПолученияДанных();
	ПараметрПриложения = ПараметрыПриложения[ИменаПараметров.ИмяПараметраПриложения]; // - см. ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыПриложенияОтветственныеЗаПодписаниеСообщений
	
	Если ПараметрПриложения <> Неопределено Тогда
		ПараметрПриложения.ОткрытаФормаСообщений = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИменаПараметров = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.ИменаПараметровПериодическогоПолученияДанных();
	
	Если ИмяСобытия = ИменаПараметров.ПоступилиНовыеСообщенияДляПодписания Тогда
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			ВходящиеДанныеОрганизации = Параметр;
		Иначе
			ВходящиеДанныеОрганизации = Новый Массив();
			ВходящиеДанныеОрганизации.Добавить(Параметр);
		КонецЕсли;
		
		Для Каждого ЗначениеОрганизации Из ВходящиеДанныеОрганизации Цикл
			Если Организации.НайтиПоЗначению(ЗначениеОрганизации) = Неопределено Тогда
				Организации.Добавить(ЗначениеОрганизации);
			КонецЕсли;
		КонецЦикла;
		
		ОрганизацииПредставление = Строка(Организации);
		ИнтеграцияИСКлиентСервер.НастроитьОтборПоОрганизации(ЭтотОбъект, Организации, "Отбор");
		
		ЗаполнитьТаблицуСообщенийКПодписанию();
		
		Активизировать();
		
	ИначеЕсли ИмяСобытия = ИменаПараметров.ВыполненоАвтоподписание Тогда
		
		ЗаполнитьТаблицуСообщенийКПодписанию();
		Если РежимНапоминания
			И СообщенияКПодписанию.Количество() = 0 Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОформленоОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборОгранизацииЗавершение = Новый ОписаниеОповещения("ВыборОгранизацииЗавершение", ЭтотОбъект);
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",, ВыборОгранизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "Оформлено");
	ЗаполнитьТаблицуСообщенийКПодписанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	ЗаполнитьТаблицуСообщенийКПодписанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборОгранизацииЗавершение = Новый ОписаниеОповещения("ВыборОгранизацииЗавершение", ЭтотОбъект);
	
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",, ВыборОгранизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "Оформлено");
	ЗаполнитьТаблицуСообщенийКПодписанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	ЗаполнитьТаблицуСообщенийКПодписанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСообщенияКПодписанию

&НаКлиенте
Процедура СообщенияКПодписаниюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = СообщенияКПодписанию.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СообщенияКПодписаниюСсылкаНаОбъект Тогда
		ПоказатьЗначение(, ДанныеСтроки.СсылкаНаОбъект);
	Иначе
		ПодписатьСообщения(ДанныеСтроки.Сообщение, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуСообщенийКПодписанию();
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	ЗакрытьФорму      = РежимНапоминания;
	ОтборПоСообщениям = Новый Массив();
	Если Элементы.СообщенияКПодписанию.ВыделенныеСтроки.Количество() > 1 Тогда
		Для Каждого ВыделеннаяСтрока Из Элементы.СообщенияКПодписанию.ВыделенныеСтроки Цикл
			ТекущиеДанные = СообщенияКПодписанию.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если ТекущиеДанные = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ОтборПоСообщениям.Добавить(ТекущиеДанные.Сообщение);
		КонецЦикла;
		ЗакрытьФорму = Ложь;
	Иначе
		Для Каждого СтрокаТаблицы Из СообщенияКПодписанию Цикл
			ОтборПоСообщениям.Добавить(СтрокаТаблицы.Сообщение);
		КонецЦикла;
	КонецЕсли;
	
	ПодписатьСообщения(ОтборПоСообщениям,, ЗакрытьФорму);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьВсе(Команда)
	
	ОтложитьНапоминания();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриЗавершенииОперацииПодписи(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Успех = ИнтеграцияЗЕРНОВызовСервера.ЗаписатьРезультаПодписиВОчередьСообщений(Результат, Контекст.ИсходныеДатыМодификацииПоСообщениям);
	
	Если Контекст.ЗакрытьФорму
		И Успех Тогда
		СообщенияКПодписанию.Очистить();
		Закрыть(Истина);
	Иначе
		ЗаполнитьТаблицуСообщенийКПодписанию();
	КонецЕсли;
	
	Оповестить("ЗЕРНО.ОбновитьКоличествоСообщенийКПодписанию");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьНапоминания()
	
	ИменаПараметров    = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.ИменаПараметровПериодическогоПолученияДанных();
	ПараметрПриложения = ПараметрыПриложения[ИменаПараметров.ИмяПараметраПриложения]; // - см. ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыПриложенияОтветственныеЗаПодписаниеСообщений
	
	СмещениеВСекундах = СрокПовторногоОповещения * 60;
	
	ПараметрПриложения.ВремяСледующейПроверки = ТекущаяДата() + СмещениеВСекундах;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьСообщения(Сообщения = Неопределено, ЭтоПросмотрСообщения = Ложь, ЗакрытьФорму = Ложь) Экспорт
	
	ОчиститьСообщения();
	
	ДанныеСообщений = ИнтеграцияЗЕРНОВызовСервера.СообщенияВОчередиТребующиеПодписания(Организации.ВыгрузитьЗначения(), Сообщения);
	
	НаборДанныхДляПодписанияПоОрганизациям = Новый Соответствие();
	ИсходныеДатыМодификацииПоСообщениям    = Новый Соответствие();
	
	Для Каждого КлючИЗначение Из ДанныеСообщений.СообщенияКПодписанию Цикл
		
		СообщенияДляПодписания = Новый Массив();
		
		Для Каждого КлючИЗначениеСообщение Из КлючИЗначение.Значение Цикл
			Если Не ЭтоПросмотрСообщения
				И Не КлючИЗначениеСообщение.ДоступныСертификаты Тогда
				Продолжить;
			КонецЕсли;
			СообщенияДляПодписания.Добавить(КлючИЗначениеСообщение.РеквизитыИсходящегоСообщения);
			ИсходныеДатыМодификацииПоСообщениям.Вставить(КлючИЗначениеСообщение.Сообщение, КлючИЗначениеСообщение.ДатаМодификацииУниверсальная);
		КонецЦикла;
		
		Если СообщенияДляПодписания.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ИнтеграцияЗЕРНОСлужебныйКлиент.ДополнитьНаборДляПодписанияПоСообщениям(
			НаборДанныхДляПодписанияПоОрганизациям,
			КлючИЗначение.Ключ,
			СообщенияДляПодписания);
		
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из НаборДанныхДляПодписанияПоОрганизациям Цикл
		
		НаборДанныхДляПодписания = КлючИЗначение.Значение;
		
		Контекст = Новый Структура;
		Контекст.Вставить("ИсходныеДатыМодификацииПоСообщениям", ИсходныеДатыМодификацииПоСообщениям);
		Контекст.Вставить("ЗакрытьФорму",                        ЗакрытьФорму);
		
		ДоступныеСертификаты = ДанныеСообщений.ДоступныеСертификаты.Получить(КлючИЗначение.Ключ);
		
		ИнтеграцияЗЕРНОСлужебныйКлиент.Подписать(
			НаборДанныхДляПодписания,
			Организация,
			ДоступныеСертификаты,
			Новый ОписаниеОповещения(
				"ПриЗавершенииОперацииПодписи",
				ЭтотОбъект,
				Контекст),
			Новый Соответствие(),
			(Не ЭтоПросмотрСообщения));
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборОгранизацииЗавершение(Значение, ДополнительныеПараметры) Экспорт
	
	Если Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуСообщенийКПодписанию();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСообщенийКПодписанию()
	
	ДанныеСообщений = ИнтеграцияЗЕРНОВызовСервера.СообщенияВОчередиТребующиеПодписания(
		Организации.ВыгрузитьЗначения());
	
	СообщенияКПодписанию.Очистить();
	Для Каждого КлючИЗначение Из ДанныеСообщений.СообщенияКПодписанию Цикл
		
		Для Каждого ЭлементНабора Из КлючИЗначение.Значение Цикл
			НоваяСтрока = СообщенияКПодписанию.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементНабора);
		КонецЦикла;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Организации", Организации);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			ОрганизацииПредставление = Строка(Организации);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПредставлениеВремени(ВремяВСекундах)
	
	Результат = "";
	
	ПредставлениеЧасов = НСтр("ru = ';%1 час;;%1 часа;%1 часов;%1 часа'");
	ПредставлениеМинут = НСтр("ru = ';%1 минута;;%1 минуты;%1 минут;%1 минуты'");
	
	КоличествоЧасов = Цел(ВремяВСекундах / 3600);
	КоличествоМинут = Цел(ВремяВСекундах / 60);
	КоличествоМинут = КоличествоМинут - КоличествоЧасов * 60;
	
	Если КоличествоЧасов > 0 Тогда
		Результат = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеЧасов, КоличествоЧасов);
	КонецЕсли;
	
	Если КоличествоМинут > 0 Тогда
		Если Результат <> "" Тогда
			Результат = Результат + " ";
		КонецЕсли;
		Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеМинут, КоличествоМинут);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СообщенияКПодписанию");
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СообщенияКПодписанию.ДоступныСертификаты");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыНаСервере()
	
	Элементы.СообщенияКПодписаниюПодразделение.Видимость = ОбщегоНазначенияИС.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс();
	Элементы.СрокПовторногоОповещения.Видимость          = РежимНапоминания;
	Элементы.ОтложитьВсе.Видимость                       = РежимНапоминания;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСрокиПовторногоНапоминания()
	
	Для Каждого Элемент Из Элементы.СрокПовторногоОповещения.СписокВыбора Цикл
		Элемент.Представление = ПредставлениеВремени(Элемент.Значение * 60);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти