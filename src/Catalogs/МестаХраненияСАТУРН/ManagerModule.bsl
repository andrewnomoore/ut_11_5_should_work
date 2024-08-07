#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
	
		Если Параметры = Неопределено Тогда
			Параметры = Новый Структура();
		КонецЕсли;
		
		Параметры.Вставить("РежимВыбора", Истина);
		
		ВыбраннаяФорма       = "Справочник.МестаХраненияСАТУРН.Форма.ФормаСписка";
		СтандартнаяОбработка = Ложь;
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НоваяТаблицаСопоставленияМестХранения() Экспорт
	
	ВозвращаемоеЗначение = Новый ТаблицаЗначений();
	ВозвращаемоеЗначение.Колонки.Добавить("ОрганизацияСАТУРН", Новый ОписаниеТипов("СправочникСсылка.КлассификаторОрганизацийСАТУРН"));
	ВозвращаемоеЗначение.Колонки.Добавить("МестоХранения",     Новый ОписаниеТипов("СправочникСсылка.МестаХраненияСАТУРН"));
	ВозвращаемоеЗначение.Колонки.Добавить("ТорговыйОбъект");
	ВозвращаемоеЗначение.Колонки.Добавить("ПроизводственныйОбъект");
	
	ВозвращаемоеЗначение.Индексы.Добавить("ОрганизацияСАТУРН, МестоХранения");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ЗаполнитьТаблицуСопоставлений(ТаблицаСопоставлений) Экспорт
	
	ВозвращаемоеЗначение  = Новый Соответствие();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИсходнаяТаблица.ОрганизацияСАТУРН,
		|	ИсходнаяТаблица.МестоХранения
		|ПОМЕСТИТЬ ИсходнаяТаблица
		|ИЗ
		|	&ИсходнаяТаблица КАК ИсходнаяТаблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсходнаяТаблица.ОрганизацияСАТУРН                                  КАК ОрганизацияСАТУРН,
		|	ИсходнаяТаблица.МестоХранения                                      КАК МестоХранения,
		|	КлассификаторОрганизацийСАТУРНМестаХранения.ТорговыйОбъект         КАК ТорговыйОбъект,
		|	КлассификаторОрганизацийСАТУРНМестаХранения.ПроизводственныйОбъект КАК ПроизводственныйОбъект
		|ИЗ
		|	ИсходнаяТаблица КАК ИсходнаяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийСАТУРН.МестаХранения КАК
		|			КлассификаторОрганизацийСАТУРНМестаХранения
		|		ПО ИсходнаяТаблица.ОрганизацияСАТУРН = КлассификаторОрганизацийСАТУРНМестаХранения.Ссылка
		|		И ИсходнаяТаблица.МестоХранения = КлассификаторОрганизацийСАТУРНМестаХранения.МестоХранения";
	
	Запрос.УстановитьПараметр("ИсходнаяТаблица", ТаблицаСопоставлений);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса       = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура("ОрганизацияСАТУРН, МестоХранения");
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, ВыборкаДетальныеЗаписи);
		
		ПоискСтрок = ТаблицаСопоставлений.НайтиСтроки(СтруктураПоиска);
		Если ПоискСтрок.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы = ПоискСтрок[0];
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ТорговыйОбъект) Тогда
			
			Если СтрокаТаблицы.ТорговыйОбъект = Неопределено Тогда
				СтрокаТаблицы.ТорговыйОбъект = ВыборкаДетальныеЗаписи.ТорговыйОбъект
			ИначеЕсли ТипЗнч(СтрокаТаблицы.ТорговыйОбъект) = Тип("Массив") Тогда
				СтрокаТаблицы.ТорговыйОбъект.Добавить(ВыборкаДетальныеЗаписи.ТорговыйОбъект);
			Иначе
				Значения = Новый Массив();
				Значения.Добавить(СтрокаТаблицы.ТорговыйОбъект);
				Значения.Добавить(ВыборкаДетальныеЗаписи.ТорговыйОбъект);
				СтрокаТаблицы.ТорговыйОбъект = Значения;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ПроизводственныйОбъект) Тогда
			
			Если СтрокаТаблицы.ПроизводственныйОбъект = Неопределено Тогда
				СтрокаТаблицы.ПроизводственныйОбъект = ВыборкаДетальныеЗаписи.ПроизводственныйОбъект
			ИначеЕсли ТипЗнч(СтрокаТаблицы.ПроизводственныйОбъект) = Тип("Массив") Тогда
				СтрокаТаблицы.ПроизводственныйОбъект.Добавить(ВыборкаДетальныеЗаписи.ПроизводственныйОбъект);
			Иначе
				Значения = Новый Массив();
				Значения.Добавить(СтрокаТаблицы.ПроизводственныйОбъект);
				Значения.Добавить(ВыборкаДетальныеЗаписи.ПроизводственныйОбъект);
				СтрокаТаблицы.ПроизводственныйОбъект = Значения;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ДанныеОбъекта(ЭлементДанных) Экспорт
	
	ДанныеМестаХранения = Новый Структура;
	
	ДанныеМестаХранения.Вставить("GUID",                        ЭлементДанных.sys_guid);
	ДанныеМестаХранения.Вставить("Идентификатор",               ЭлементДанных.id);
	ДанныеМестаХранения.Вставить("Статус",                      ИнтерфейсСАТУРН.Статус(ЭлементДанных.lcState));
	ДанныеМестаХранения.Вставить("ДатаСоздания",                ОбщегоНазначенияИСКлиентСервер.ДатаИзСтрокиUNIX(ЭлементДанных.sys_timeFrom));
	ДанныеМестаХранения.Вставить("ДатаИзменения",               ОбщегоНазначенияИСКлиентСервер.ДатаИзСтрокиUNIX(ЭлементДанных.sys_changedAt));
	ДанныеМестаХранения.Вставить("Наименование",                ЭлементДанных.name);
	ДанныеМестаХранения.Вставить("Адрес",                       ЭлементДанных.addr);
	ДанныеМестаХранения.Вставить("НаименованиеСубъектаРФ",      ЭлементДанных.subName);
	ДанныеМестаХранения.Вставить("ЭтоПроизводственнаяПлощадка", ЭлементДанных.isProducingStoreArea = Истина Или ЭлементДанных.isProducingStoreArea = "true");
	ДанныеМестаХранения.Вставить("ЭтоСкладВременногоХранения",  ЭлементДанных.isTempStoringArea = Истина Или ЭлементДанных.isTempStoringArea = "true");
	ДанныеМестаХранения.Вставить("ГеографическиеКоординаты",    ЭлементДанных.location);
	ДанныеМестаХранения.Вставить("ГеографическаяФорма",         ЭлементДанных.geoForm);
	ДанныеМестаХранения.Вставить("Комментарий",                 ЭлементДанных.description);
	
	// инициализация значений, которые могут отсутствовать в структуре данных
	ДанныеМестаХранения.Вставить("ДанныеОрганизации",        Неопределено);
	ДанныеМестаХранения.Вставить("ИдентификаторОрганизации", "");
	
	Если ТипЗнч(ЭлементДанных.ownerId) = Тип("Структура") Тогда
		
		Если ЭлементДанных.ownerId.Свойство("id") Тогда
			
			ДанныеМестаХранения.Вставить("ИдентификаторОрганизации", ЭлементДанных.ownerId.id);
			ДанныеМестаХранения.Вставить("ДанныеОрганизации",        ЭлементДанных.ownerId);
			
		ИначеЕсли ЭлементДанных.ownerId.Свойство("_id") Тогда
			
			ДанныеМестаХранения.Вставить("ИдентификаторОрганизации", ЭлементДанных.ownerId._id);
			ДанныеМестаХранения.Вставить("ДанныеОрганизации",        ЭлементДанных.ownerId);
			
		КонецЕсли;
		
	Иначе
		
		ДанныеМестаХранения.Вставить("ИдентификаторОрганизации", ЭлементДанных.ownerId);
		
	КонецЕсли;
	
	Возврат ДанныеМестаХранения;
	
КонецФункции

Функция ОрганизацииВладельцыМестаХранения(МестоХранения) Экспорт
	
	МассивВладельцев = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
		|	КлассификаторОрганизацийСАТУРНМестаХранения.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КлассификаторОрганизацийСАТУРН.МестаХранения КАК КлассификаторОрганизацийСАТУРНМестаХранения
		|ГДЕ
		|	НЕ КлассификаторОрганизацийСАТУРНМестаХранения.Ссылка.ПометкаУдаления
		|	И КлассификаторОрганизацийСАТУРНМестаХранения.МестоХранения = &МестоХранения";
	
	Запрос.УстановитьПараметр("МестоХранения", МестоХранения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивВладельцев.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
	Возврат МассивВладельцев;
	
КонецФункции

Процедура ОбработкаЗагрузкиПолученныхДанных(ЭлементОчереди, ПараметрыОбмена, ПолученныеДанные, ИзмененныеОбъекты) Экспорт
	
	Если ЭлементОчереди.Операция = ОперацияЗагрузкиКлассификатора() Тогда
		
		ВходящиеДанные = ИнтеграцияСАТУРНСлужебный.ОбработатьРезультатЗапросаСпискаОбъектов(ПолученныеДанные, ПараметрыОбмена);
		ИнтеграцияСАТУРНСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена, ИзмененныеОбъекты);
		
		Попытка
			
			Для Каждого ЭлементДанных Из ВходящиеДанные Цикл
				
				ДанныеОбъекта   = ДанныеОбъекта(ЭлементДанных);
				СсылкаНаЭлемент = ЗагрузитьОбъект(ДанныеОбъекта, ПараметрыОбмена,,, ЭлементОчереди.ОрганизацияСАТУРН);
				
				Если Не ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
					Продолжить;
				КонецЕсли;
				ИзмененныеОбъекты.Добавить(СсылкаНаЭлемент);
				
			КонецЦикла;
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
	
	КонецЕсли;
	
КонецПроцедуры

Функция ОперацияЗагрузкиКлассификатора() Экспорт
	Возврат Перечисления.ВидыОперацийСАТУРН.МестоХраненияЗапросКлассификатора;
КонецФункции

#Область ПоискСсылок

Функция МестоХранения(Идентификатор, ПараметрыОбмена, ОрганизацияСАТУРН = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Идентификатор)
		Или Идентификатор = -1 Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ИмяТаблицы       = Метаданные.Справочники.МестаХраненияСАТУРН.ПолноеИмя();
	СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
	
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
	Иначе
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Идентификатор);
		
		ТранзакцияЗафиксирована = Истина;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
			
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				
				ДанныеОбъекта = ИнтеграцияСАТУРНСлужебный.ДанныеОбъекта(
					Идентификатор,
					Метаданные.Справочники.МестаХраненияСАТУРН, ПараметрыОбмена);
				Если ДанныеОбъекта = Неопределено Тогда
					СправочникСсылка = СоздатьМестоХранения(Идентификатор, ПараметрыОбмена);
					ИнтеграцияСАТУРНСлужебный.ДобавитьКЗагрузке(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка, ОрганизацияСАТУРН);
				Иначе
					СправочникСсылка = ЗагрузитьОбъект(ДанныеОбъекта, ПараметрыОбмена,, Ложь, ОрганизацияСАТУРН);
				КонецЕсли;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТранзакцияЗафиксирована = Ложь;
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при создании Места хранения с идентификатором %1:
				           |%2'"),
				Идентификатор,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибкиПодробно = СтрШаблон(
				НСтр("ru = 'Ошибка при создании Места хранения с идентификатором %1:
				           |%2'"),
				Идентификатор,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ТекстОшибкиПодробно,
				НСтр("ru = 'Работа с Местами хранения'", ОбщегоНазначения.КодОсновногоЯзыка()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		Если ТранзакцияЗафиксирована Тогда
			ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СправочникСсылка;
	
КонецФункции

Функция ЗагрузитьОбъект(ДанныеМестаХранения, ПараметрыОбмена, СправочникОбъект = Неопределено, ТребуетсяПоиск = Истина, ОрганизацияСАТУРН = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ДанныеМестаХранения = Неопределено Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ЗаписьНового = Ложь;
	ИмяТаблицы   = Метаданные.Справочники.МестаХраненияСАТУРН.ПолноеИмя();
	
	Если СправочникОбъект = Неопределено Тогда
		
		СправочникСсылка = Неопределено;
		Если ТребуетсяПоиск Тогда
			СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, ДанныеМестаХранения.Идентификатор);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
			СправочникОбъект = СоздатьЭлемент();
			СправочникОбъект.Заполнить(Неопределено);
			
			ИдентификаторОбъекта = Новый УникальныйИдентификатор();
			СправочникСсылка = ПолучитьСсылку(ИдентификаторОбъекта);
			СправочникОбъект.УстановитьСсылкуНового(СправочникСсылка);
			ЗаписьНового = Истина;
			
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;
		
	Иначе
		СправочникСсылка = СправочникОбъект.Ссылка;
	КонецЕсли;
	
	Если Не ЗаписьНового Тогда
		СправочникОбъект.Заблокировать();
	КонецЕсли;
	
	СправочникОбъект.Наименование                = ДанныеМестаХранения.Наименование;
	СправочникОбъект.Идентификатор               = ДанныеМестаХранения.Идентификатор;
	СправочникОбъект.Статус                      = ДанныеМестаХранения.Статус;
	СправочникОбъект.Адрес                       = ДанныеМестаХранения.Адрес;
	СправочникОбъект.ЭтоПроизводственнаяПлощадка = ДанныеМестаХранения.ЭтоПроизводственнаяПлощадка;
	СправочникОбъект.ЭтоСкладВременногоХранения  = ДанныеМестаХранения.ЭтоСкладВременногоХранения;
	СправочникОбъект.Комментарий                 = ДанныеМестаХранения.Комментарий;
	
	Если ЗначениеЗаполнено(ДанныеМестаХранения.ИдентификаторОрганизации) Тогда
		
		Организация = Справочники.КлассификаторОрганизацийСАТУРН.Организация(
			ДанныеМестаХранения.ИдентификаторОрганизации,
			ПараметрыОбмена,
			ОрганизацияСАТУРН);
		ОрганизацияОбъект = Организация.ПолучитьОбъект();
		
		СтруктураОтбора = Новый Структура("МестоХранения", СправочникСсылка);
		СтрокаСвязкиОрганизацииСМестомХранения = ОрганизацияОбъект.МестаХранения.НайтиСтроки(СтруктураОтбора);
		
		Если СтрокаСвязкиОрганизацииСМестомХранения.Количество() = 0 Тогда
			
			НоваяСтрокаПривязки = ОрганизацияОбъект.МестаХранения.Добавить();
			НоваяСтрокаПривязки.МестоХранения = СправочникСсылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СправочникОбъект.ТребуетсяЗагрузка = Ложь;
	СправочникОбъект.Записать();
	
	ОрганизацияОбъект.Записать();
	
	ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(
		ПараметрыОбмена,
		ИмяТаблицы,
		ДанныеМестаХранения.Идентификатор,
		СправочникОбъект.Ссылка);
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

Функция СоздатьМестоХранения(Идентификатор, ПараметрыОбмена)
	
	СправочникОбъект = СоздатьЭлемент();
	СправочникОбъект.Идентификатор     = Идентификатор;
	СправочникОбъект.ТребуетсяЗагрузка = Истина;
	СправочникОбъект.Наименование      = НСтр("ru = '<Требуется загрузка>'");
	
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
