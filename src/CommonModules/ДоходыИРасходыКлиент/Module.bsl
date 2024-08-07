#Область ПрограммныйИнтерфейс

#Область ВыборСтатейИАналитик

// Обеспечивает выбор статьи в соответствии с параметрами выбора.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
// 	Элемент - ПолеФормы - Элемент выбора статьи.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
//
Процедура НачалоВыбораСтатьи(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	ПараметрыВыбораСтатьи = ДоходыИРасходыКлиентСервер.ПараметрыВыбораПоЭлементу(Форма, Элемент);
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторСтроки = Неопределено;
	ТаблицаФормы = ОбщегоНазначенияУТКлиентСервер.ТаблицаФормыЭлемента(Элемент);
	Если ТаблицаФормы <> Неопределено Тогда
		ИдентификаторСтроки = ТаблицаФормы.ТекущаяСтрока;
	КонецЕсли;
	Данные = ДоходыИРасходыКлиентСервер.ДанныеПоПути(Форма, ПараметрыВыбораСтатьи.ПутьКДанным, ИдентификаторСтроки);
	Если ТипЗнч(Данные) = Тип("ДанныеФормыКоллекция") Тогда
		// Редактируем таблицу в режиме "Без разбиения"
		Данные = Данные[0];
	КонецЕсли;
	
	ПараметрыВыбора = Новый Массив();
	Для Каждого ПараметрВыбора Из Элемент.ПараметрыВыбора Цикл
		ПараметрыВыбора.Добавить(ПараметрВыбора);
	КонецЦикла;
	
	СвязиПараметровВыбора = Элемент.СвязиПараметровВыбора; // ФиксированныйМассив из СвязьПараметраВыбора
	Для каждого СвязьПараметраВыбора Из СвязиПараметровВыбора Цикл
		ЗначениеПараметра = ОбщегоНазначенияУТКлиентСервер.ЗначениеПараметраСвязи(СвязьПараметраВыбора, Форма);
		НовыйПараметрВыбора = Новый ПараметрВыбора(СвязьПараметраВыбора.Имя, ЗначениеПараметра);
		ПараметрыВыбора.Добавить(НовыйПараметрВыбора);
	КонецЦикла;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Данные[ПараметрыВыбораСтатьи.Статья]);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Новый ФиксированныйМассив(ПараметрыВыбора));
	ПараметрыФормы.Вставить("ОграничениеТипа", Элемент.ОграничениеТипа);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Обеспечивает выбор аналитики расходов в соответствии с параметрами выбора.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
// 	Элемент - ПолеФормы - Элемент выбора статьи.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
//
Процедура НачалоВыбораАналитикиРасходов(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	ПараметрыВыбораСтатьи = ДоходыИРасходыКлиентСервер.ПараметрыВыбораПоЭлементу(Форма, Элемент);
	
	ИдентификаторСтроки = Неопределено;
	ТаблицаФормы = ОбщегоНазначенияУТКлиентСервер.ТаблицаФормыЭлемента(Элемент);
	Если ТаблицаФормы <> Неопределено Тогда
		ИдентификаторСтроки = ТаблицаФормы.ТекущаяСтрока;
	КонецЕсли;
	Данные = ДоходыИРасходыКлиентСервер.ДанныеПоПути(Форма, ПараметрыВыбораСтатьи.ПутьКДанным, ИдентификаторСтроки);
	
	ДанныеВТаблице = Ложь;
	Если ТипЗнч(Данные) = Тип("ДанныеФормыКоллекция") Тогда
		// Редактируем таблицу в режиме "Без разбиения"
		Данные = Данные[0];
		ДанныеВТаблице = Истина;
	ИначеЕсли ТипЗнч(Данные) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		ДанныеВТаблице = Истина;
	КонецЕсли;
	
	Если ДанныеВТаблице Тогда
		АналитикаРасходовЗаказРеализация = Данные[ПараметрыВыбораСтатьи.КэшРеквизитовСтатьиРасходов.АналитикаРасходовЗаказРеализация];
	Иначе
		АналитикаРасходовЗаказРеализация = Форма[ПараметрыВыбораСтатьи.КэшРеквизитовСтатьиРасходов.АналитикаРасходовЗаказРеализация];
	КонецЕсли;
	
	АналитикаРасходов = Данные[ПараметрыВыбораСтатьи.АналитикаРасходов];
	
	Если АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", АналитикаРасходов);
		ОткрытьФорму("ОбщаяФорма.ВыборАналитикиРасходов", ПараметрыФормы, Элемент);
	КонецЕсли;
	
	Если ТипЗнч(АналитикаРасходов)=Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ТипыДоговоров = Новый Массив();
		ТипыДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПереработчиком2_5"));
		ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", АналитикаРасходов);
		ПараметрыФормы.Вставить("РазрешитьВыборПартнера", Истина);
		ПараметрыФормы.Вставить("ТипыДоговоров", ТипыДоговоров);

		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	КонецЕсли;
	
	
КонецПроцедуры

// Заполняет список выбора при авто подборе аналитики расходов.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
// 	Элемент - ПолеФормы - Элемент выбора статьи.
// 	Текст - Строка - Введенный текст.
// 	ДанныеВыбора - СписокЗначений - Данные выбора аналитики.
// 	Параметры - Структура, Неопределено - Параметры получения данных выбора.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
//
Процедура АвтоПодборАналитикиРасходов(Форма, Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыбораСтатьи = ДоходыИРасходыКлиентСервер.ПараметрыВыбораПоЭлементу(Форма, Элемент);
	
	ИдентификаторСтроки = Неопределено;
	ТаблицаФормы = ОбщегоНазначенияУТКлиентСервер.ТаблицаФормыЭлемента(Элемент);
	Если ТаблицаФормы <> Неопределено Тогда
		ИдентификаторСтроки = ТаблицаФормы.ТекущаяСтрока;
	КонецЕсли;
	
	Данные = ДоходыИРасходыКлиентСервер.ДанныеПоПути(Форма, ПараметрыВыбораСтатьи.ПутьКДанным, ИдентификаторСтроки);
	ДанныеВТаблице = Ложь;
	Если ТипЗнч(Данные) = Тип("ДанныеФормыКоллекция") Тогда
		// Редактируем таблицу в режиме "Без разбиения"
		Данные = Данные[0];
		ДанныеВТаблице = Истина;
	ИначеЕсли ТипЗнч(Данные) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		ДанныеВТаблице = Истина;
	КонецЕсли;
	
	Если ДанныеВТаблице Тогда
		АналитикаРасходовЗаказРеализация = Данные[ПараметрыВыбораСтатьи.КэшРеквизитовСтатьиРасходов.АналитикаРасходовЗаказРеализация];
	Иначе
		АналитикаРасходовЗаказРеализация = Форма[ПараметрыВыбораСтатьи.КэшРеквизитовСтатьиРасходов.АналитикаРасходовЗаказРеализация];
	КонецЕсли;
	
	Если АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ПродажиВызовСервера.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список выбора при окончании ввода текста в поле аналитики расходов.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
// 	Элемент - ПолеФормы - Элемент выбора статьи.
// 	Текст - Строка - Введенный текст.
// 	ДанныеВыбора - СписокЗначений - Данные выбора аналитики.
// 	Параметры - Структура, Неопределено - Параметры получения данных выбора.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
//
Процедура ОкончаниеВводаТекстаАналитикиРасходов(Форма, Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыбораСтатьи = ДоходыИРасходыКлиентСервер.ПараметрыВыбораПоЭлементу(Форма, Элемент);
	
	ИдентификаторСтроки = Неопределено;
	ТаблицаФормы = ОбщегоНазначенияУТКлиентСервер.ТаблицаФормыЭлемента(Элемент);
	Если ТаблицаФормы <> Неопределено Тогда
		ИдентификаторСтроки = ТаблицаФормы.ТекущаяСтрока;
	КонецЕсли;
	Данные = ДоходыИРасходыКлиентСервер.ДанныеПоПути(Форма, ПараметрыВыбораСтатьи.ПутьКДанным, ИдентификаторСтроки);
	ДанныеВТаблице = Ложь;
	Если ТипЗнч(Данные) = Тип("ДанныеФормыКоллекция") Тогда
		// Редактируем таблицу в режиме "Без разбиения"
		Данные = Данные[0];
		ДанныеВТаблице = Истина;
	ИначеЕсли ТипЗнч(Данные) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		ДанныеВТаблице = Истина;
	КонецЕсли;
	
	Если ДанныеВТаблице Тогда
		АналитикаРасходовЗаказРеализация = Данные[ПараметрыВыбораСтатьи.КэшРеквизитовСтатьиРасходов.АналитикаРасходовЗаказРеализация];
	Иначе
		АналитикаРасходовЗаказРеализация = Форма[ПараметрыВыбораСтатьи.КэшРеквизитовСтатьиРасходов.АналитикаРасходовЗаказРеализация];
	КонецЕсли;
	
	Если АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ПродажиВызовСервера.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды заполнение статьи и аналитики в выделенных строках таблицы.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
// 	Элемент - ПолеФормы - Элемент выбора статьи, для данных которого необходимо выполнить заполнение.
// 	ВыделенныеСтроки - Массив - Выделенные строки таблицы формы
// 	ОписаниеОповещенияПослеЗаполнения - ОписаниеОповещения - Описания оповещения, которое необходимо вызвать после заполнения статьи и аналитики.
//
Процедура ЗаполнитьСтатьюИАналитикуВВыделенныхСтроках(Форма, Элемент, ВыделенныеСтроки, ОписаниеОповещенияПослеЗаполнения = Неопределено) Экспорт
	
	ПараметрыВыбораСтатьи = ДоходыИРасходыКлиентСервер.ПараметрыВыбораПоЭлементу(Форма, Элемент);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья",                         Неопределено);
	ПараметрыФормы.Вставить("ПараметрыВыбораЭлементаСтатьи",  Элемент.ПараметрыВыбора);
	ПараметрыФормы.Вставить("ЗначениеПоУмолчанию",            ПараметрыВыбораСтатьи.ЗначениеПоУмолчанию);
	ПараметрыФормы.Вставить("ВыборСтатьиРасходов",            ПараметрыВыбораСтатьи.ВыборСтатьиРасходов);
	ПараметрыФормы.Вставить("ВыборСтатьиДоходов",             ПараметрыВыбораСтатьи.ВыборСтатьиДоходов);
	ПараметрыФормы.Вставить("ВыборСтатьиАктивовПассивов",     ПараметрыВыбораСтатьи.ВыборСтатьиАктивовПассивов);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Форма",                         Форма);
	ДополнительныеПараметры.Вставить("ИдентификаторСтроки",           ВыделенныеСтроки);
	ДополнительныеПараметры.Вставить("ПараметрыВыбораСтатьи",         ПараметрыВыбораСтатьи);
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияПослеЗаполнения", ОписаниеОповещенияПослеЗаполнения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииВыбораСтатьиИАналитики", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьиИАналитики", 
		ПараметрыФормы, Форма, , , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыборСтатейИАналитик

Процедура ПриЗавершенииВыбораСтатьиИАналитики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма                 = ДополнительныеПараметры.Форма;
	ПараметрыВыбораСтатьи = ДополнительныеПараметры.ПараметрыВыбораСтатьи;
	Если ТипЗнч(ДополнительныеПараметры.ИдентификаторСтроки) = Тип("Массив") Тогда
		МассивИдентификаторов = ДополнительныеПараметры.ИдентификаторСтроки;
	Иначе
		МассивИдентификаторов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДополнительныеПараметры.ИдентификаторСтроки)
	КонецЕсли;
	
	Для каждого ИдентификаторСтроки Из МассивИдентификаторов Цикл
		Данные = ДоходыИРасходыКлиентСервер.ДанныеПоПути(Форма, ПараметрыВыбораСтатьи.ПутьКДанным, ИдентификаторСтроки);
		Данные[ПараметрыВыбораСтатьи.Статья] = Результат.Статья;
		Если ПараметрыВыбораСтатьи.ВыборСтатьиРасходов Тогда
			Данные[ПараметрыВыбораСтатьи.АналитикаРасходов] = Результат.АналитикаРасходов;
		КонецЕсли;
		Если ПараметрыВыбораСтатьи.ВыборСтатьиДоходов Тогда
			Данные[ПараметрыВыбораСтатьи.АналитикаДоходов] = Результат.АналитикаДоходов;
		КонецЕсли;
		Если ПараметрыВыбораСтатьи.ВыборСтатьиАктивовПассивов Тогда
			Данные[ПараметрыВыбораСтатьи.АналитикаАктивовПассивов] = Результат.АналитикаАктивовПассивов;
		КонецЕсли;
		ДоходыИРасходыКлиентСервер.ЗаполнитьРеквизитыСтатьи(Форма, Данные, ПараметрыВыбораСтатьи);
		ДоходыИРасходыКлиентСервер.УстановитьСвойстваЭлементовАналитики(Форма, ПараметрыВыбораСтатьи);
	КонецЦикла;
	
	
	Форма.Модифицированность = Истина;
	
	Если ДополнительныеПараметры.ОписаниеОповещенияПослеЗаполнения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияПослеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти