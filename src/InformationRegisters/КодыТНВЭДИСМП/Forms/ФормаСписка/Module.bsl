#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДоступныеВидыПродукции();
	
	РежимВыбора = Параметры.РежимВыбора;
	Элементы.ВыбратьИзСправочника.Видимость    = РежимВыбора;
	Элементы.Список.РежимВыбора                = РежимВыбора;
	Если РежимВыбора Тогда
		Элементы.ВыбратьИзКлассификатора.Заголовок = НСтр("ru = 'Выбрать'");
	Иначе
		Элементы.ВыбратьИзКлассификатора.Заголовок = НСтр("ru = 'Загрузить'");
	КонецЕсли;
	
	Список.ТекстЗапроса = ИнтеграцияИС.ОпределитьТекстЗапросаСопоставлениеКодовТНВЭД();
	
	Если ЗначениеЗаполнено(Параметры.ВидПродукции) Тогда
		
		ВидПродукции = Параметры.ВидПродукции;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ВидПродукции",
			ВидыПродукцииОтбора(ВидПродукции),
			ВидСравненияКомпоновкиДанных.ВСписке,,
			ЗначениеЗаполнено(Параметры.ВидПродукции));
		
		Элементы.ВидПродукцииИС.Видимость = Ложь;
		Элементы.ВидПродукции.Видимость   = Ложь;
		
	КонецЕсли;
	
	Организация = Параметры.Организация;
	Если Параметры.Свойство("ВозвращатьСсылкуНаЭлементКлассификатора") Тогда
		ВозвращатьСсылкуНаЭлементКлассификатора = Параметры.ВозвращатьСсылкуНаЭлементКлассификатора;
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидПродукцииПриИзменении(Элемент)
	
	ВидыПродукцииОтбора = Новый Массив;
	Если ОбщегоНазначенияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукции) Тогда
		ВидыПродукцииОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС"));
		ВидыПродукцииОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
	ИначеЕсли ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		ВидыПродукцииОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак"));
		ВидыПродукцииОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак"));
		ВидыПродукцииОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция"));
	Иначе
		ВидыПродукцииОтбора.Добавить(ВидПродукции);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ВидПродукции",
		ВидыПродукцииОтбора,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ЗначениеЗаполнено(ВидПродукции));
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(Значение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КодыТНВЭДОнлайнВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияОнлайнКлассификатораИзСписка(ВыбраннаяСтрока, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КодыТНВЭДОнлайнВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияОнлайнКлассификатораИзСписка(Значение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.КодыТНВЭДОнлайн, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.КодыТНВЭДОнлайн.ТекущиеДанные;
	
	ОбработкаВыбораЗначенияОнлайнКлассификатораИзСписка(ТекущиеДанные.ПолучитьИдентификатор(), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзСправочника(Команда)
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.Список, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ОбработкаВыбораЗначенияСписка(ТекущиеДанные, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиКодыТНВЭД(Команда)
	
	ОчиститьСообщения();
	НайтиКодыТНВЭДНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиКодыТНВЭДНаКлиенте(ВызовПослеАвторизации = Ложь)
	
	ТребуетсяОбновитьКлючСессии = ЗагрузитьКодыТНВЭД();
	
	Если ТребуетсяОбновитьКлючСессии = Истина Тогда
		Если ВызовПослеАвторизации Тогда
			ТекстОшибки = НСтр("ru = 'Не удалось выполнить авторизацию.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		Иначе
			ЗапроситьКлючСессииНачало();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ЗапроситьКлючСессииНачало()
	
	ОповещениеПриЗапросеКлючаСессии = Новый ОписаниеОповещения("ЗапроситьКлючСессииЗавершение", ЭтотОбъект);
	
	Если ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		ПараметрыЗапроса = ОбщегоНазначенияИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии(Организация);
	Иначе
		ПараметрыЗапроса = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ПараметрыЗапросаКлючаСессии(Организация);
	КонецЕсли;
	
	ИнтерфейсАвторизацииИСМПКлиент.ЗапроситьКлючСессии(
		ПараметрыЗапроса, 
		ОповещениеПриЗапросеКлючаСессии);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьКлючСессииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОтказОтАвторизации = Ложь;
	ОшибкаАвторизации  = Ложь;
	
	Если ТипЗнч(Результат) <> Тип("Соответствие") Тогда
		ОтказОтАвторизации = Истина;
	Иначе
		РезультатАвторизации = Результат[Организация];
		
		Если РезультатАвторизации = Неопределено Тогда
			ОшибкаАвторизации = Истина;
			ТекстОшибки = НСтр("ru = 'Произошла ошибка при авторизации.'");
		ИначеЕсли РезультатАвторизации <> Истина Тогда
			ОшибкаАвторизации = Истина;
			ТекстОшибки = РезультатАвторизации;
		КонецЕсли;
	КонецЕсли;
	
	Если ОтказОтАвторизации Тогда
		Возврат;
	ИначеЕсли ОшибкаАвторизации Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	Иначе
		НайтиКодыТНВЭДНаКлиенте(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьКодыТНВЭД()
	
	Если ЗначениеЗаполнено(Организация) Тогда
		РезультатПроверки = ИнтерфейсИСМП.КодыТНВЭДПоВидуПродукции(ВидПродукции, Организация); 
	Иначе
		РезультатПроверки = ИнтерфейсИСМП.КодыТНВЭДПоВидуПродукции(ВидПродукции);
	КонецЕсли;
	
	Если РезультатПроверки.ТребуетсяОбновлениеКлючаСессии Тогда
		Возврат Истина;
	ИначеЕсли РезультатПроверки.КодыТНВЭД = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	КодыТНВЭДОнлайн.Очистить();
	Для Каждого СтрокаКодаТНВЭД Из РезультатПроверки.КодыТНВЭД Цикл
		
		НоваяСтрока = КодыТНВЭДОнлайн.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКодаТНВЭД);
		
	КонецЦикла;
	
	ОпределитьНаличиеКодаТНВЭД();
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДоступныеВидыПродукции()
	
	ДоступныеВидыПродукции = ОбщегоНазначенияИСКлиентСервер.ВидыПродукцииИСМП(Истина);
	Элементы.ВидПродукции.СписокВыбора.Очистить();
	Для Каждого ДоступныйВидПродукции Из ДоступныеВидыПродукции Цикл
		
		Если ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияИСМП(ДоступныйВидПродукции, Истина)
			И ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(ДоступныйВидПродукции) Тогда
			Элементы.ВидПродукции.СписокВыбора.Добавить(ДоступныйВидПродукции, Строка(ДоступныйВидПродукции));
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ВидПродукции.СписокВыбора.СортироватьПоПредставлению();
	
	Если Элементы.ВидПродукции.СписокВыбора.Количество() > 0
		И Элементы.ВидПродукции.СписокВыбора.НайтиПоЗначению(ВидПродукции) = Неопределено Тогда
		ВидПродукции = Элементы.ВидПродукции.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

#Область ПроверкаНаличияЭлементовКлассификатораВБазе

&НаСервере
Процедура ОпределитьНаличиеКодаТНВЭД()
	
	ТаблицаФормы = КодыТНВЭДОнлайн;
	Если ТаблицаФормы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивИдентификаторов = ТаблицаФормы.Выгрузить(, "КодТНВЭД").ВыгрузитьКолонку("КодТНВЭД");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивИдентификаторов", МассивИдентификаторов);
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КодыТНВЭД.КодТНВЭД     КАК КодТНВЭД,
		|	КодыТНВЭД.ВидПродукции КАК ВидПродукции
		|ИЗ
		|	РегистрСведений.КодыТНВЭДИСМП КАК КодыТНВЭД
		|ГДЕ
		|	КодыТНВЭД.КодТНВЭД В(&МассивИдентификаторов)
		|	И КодыТНВЭД.ВидПродукции В(&МассивВидовПродукции)";
		
		Запрос.УстановитьПараметр("МассивВидовПродукции", ВидыПродукцииОтбора(ВидПродукции));
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КодыТНВЭД.КодТНВЭД     КАК КодТНВЭД,
		|	КодыТНВЭД.ВидПродукции КАК ВидПродукции
		|ИЗ
		|	РегистрСведений.КодыТНВЭДИСМП КАК КодыТНВЭД
		|ГДЕ
		|	КодыТНВЭД.КодТНВЭД В(&МассивИдентификаторов)";
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПараметрыПоиска = Новый Структура("КодТНВЭД");
	
	Пока Выборка.Следующий() Цикл
		
		ПараметрыПоиска.КодТНВЭД = Выборка.КодТНВЭД;
		
		НайденныеСтроки = ТаблицаФормы.НайтиСтроки(ПараметрыПоиска);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ЕстьВБазе = 1;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("ДанныеФормыСтруктура") Тогда
		ДанныеСтроки = ВыбраннаяСтрока;
	Иначе
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ВозвращатьСсылкуНаЭлементКлассификатора Тогда
			Результат = ОбработкаВыбораЗначенияИзСпискаНаСервере(
				ДанныеСтроки.КодТНВЭД, ДанныеСтроки.НаименованиеПолное, ВидПродукции, Ложь);
			ВыбранноеЗначение = Результат.ЭлементСправочника;
		Иначе
			ВыбранноеЗначение = ДанныеСтроки.КодТНВЭД;
		КонецЕсли;
		ОповеститьОВыборе(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораЗначенияОнлайнКлассификатораИзСписка(ВыбраннаяСтрока, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.КодыТНВЭДОнлайн.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.КодыТНВЭДОнлайн.ДанныеСтроки(ВыбраннаяСтрока);
	КодТНВЭД = ДанныеСтроки.КодТНВЭД;
	Результат = ОбработкаВыбораЗначенияИзСпискаНаСервере(
		КодТНВЭД, ДанныеСтроки.НаименованиеПолное, ВидПродукции, Не ДанныеСтроки.ЕстьВБазе);
	ДанныеСтроки.ЕстьВБазе = 1;
	Если ВозвращатьСсылкуНаЭлементКлассификатора Тогда
		КодТНВЭД = Результат.ЭлементСправочника;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		СтандартнаяОбработка = Ложь;
		ОповеститьОВыборе(КодТНВЭД);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработкаВыбораЗначенияИзСпискаНаСервере(КодТНВЭД, Наименование, ВидПродукции, Записывать = Истина)
	
	Результат = ИнтеграцияИСМП.ПолучитьДанныеСопоставленногоКлассификатораТНВЭД(КодТНВЭД, Наименование);
	
	Если Записывать Тогда
		
		Если Результат.НаименованиеПолное <> Неопределено Тогда
			Наименование = Результат.НаименованиеПолное;
		КонецЕсли;
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("КодТНВЭД", КодТНВЭД);
		СтруктураЗаписи.Вставить("ВидПродукции", ВидПродукции);
		СтруктураЗаписи.Вставить("НаименованиеПолное", Наименование);
		
		РегистрыСведений.КодыТНВЭДИСМП.ЗаписатьДанныеКодаТНВЭД(СтруктураЗаписи);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВидыПродукцииОтбора(ВидПродукцииОтбора)
	
	ВидыПродукцииОтбора = Новый Массив;
	Если ОбщегоНазначенияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукцииОтбора) Тогда
		ВидыПродукцииОтбора.Добавить(Перечисления.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС);
		ВидыПродукцииОтбора.Добавить(Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС);
	ИначеЕсли ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукцииОтбора) Тогда
		ВидыПродукцииОтбора.Добавить(Перечисления.ВидыПродукцииИС.Табак);
		ВидыПродукцииОтбора.Добавить(Перечисления.ВидыПродукцииИС.АльтернативныйТабак);
		ВидыПродукцииОтбора.Добавить(Перечисления.ВидыПродукцииИС.НикотиносодержащаяПродукция);
	Иначе
		ВидыПродукцииОтбора.Добавить(ВидПродукцииОтбора);
	КонецЕсли;
	
	Возврат ВидыПродукцииОтбора;
	
КонецФункции

#КонецОбласти