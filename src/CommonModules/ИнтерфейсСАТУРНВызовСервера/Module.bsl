
#Область ПрограммныйИнтерфейс

#Область ГрупповаяЗагрузкаИзСАТУРН

Функция СписокОрганизаций(ПараметрыПоиска, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = 100) Экспорт
	Возврат ИнтерфейсСАТУРН.СписокКонтрагентов(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
КонецФункции

Функция СписокМестХранения(ПараметрыПоиска, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = 100) Экспорт
	Возврат ИнтерфейсСАТУРН.СписокМестХранения(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
КонецФункции

Функция СписокМестПрименения(ПараметрыПоиска, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = 100) Экспорт
	Возврат ИнтерфейсСАТУРН.СписокМестПрименения(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
КонецФункции

Функция СписокПАТ(ПараметрыПоиска, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = 100) Экспорт
	Возврат ИнтерфейсСАТУРН.СписокПАТ(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
КонецФункции

Функция СписокПартий(ПараметрыПоиска, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = 100) Экспорт
	Возврат ИнтерфейсСАТУРН.СписокПартий(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
КонецФункции

#КонецОбласти

#Область ЗагрузкаИзСАТУРНПоИдентификатору

Функция ОрганизацияПоИдентификатору(Идентификатор) Экспорт

	ПараметрыПоиска = Новый Структура("Идентификатор", Идентификатор);

	РезультатПоиска = ИнтерфейсСАТУРН.СписокКонтрагентов(ПараметрыПоиска, 1, 100);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Элемент",         Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);
	ВозвращаемоеЗначение.Вставить("ПараметрыОбмена", Неопределено);

	Если РезультатПоиска.Список <> Неопределено И РезультатПоиска.Список.Количество() = 1 Тогда
		ВозвращаемоеЗначение.Элемент = РезультатПоиска.Список[0];
	ИначеЕсли Не ЗначениеЗаполнено(РезультатПоиска.ТекстОшибки) Тогда
		
		ШаблонСообщения = НСтр("ru = 'В системе ФГИС ""Сатурн"" не найден элемент по идентификатору %1.
			|Обратитесь к Администратору системы.'");
			
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(ШаблонСообщения, Идентификатор);
		
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;

КонецФункции

Функция МестоХраненияПоИдентификатору(Идентификатор) Экспорт

	ПараметрыПоиска = Новый Структура("Идентификатор, РасширенныйСоставДанных", Идентификатор, Истина);

	РезультатПоиска = ИнтерфейсСАТУРН.СписокМестХранения(ПараметрыПоиска, 1, 100);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Элемент",         Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);
	ВозвращаемоеЗначение.Вставить("ПараметрыОбмена", Неопределено);

	Если РезультатПоиска.Список <> Неопределено И РезультатПоиска.Список.Количество() = 1 Тогда
		ВозвращаемоеЗначение.Элемент = РезультатПоиска.Список[0];
	ИначеЕсли Не ЗначениеЗаполнено(РезультатПоиска.ТекстОшибки) Тогда
		
		ШаблонСообщения = НСтр("ru = 'В системе ФГИС ""Сатурн"" не найден элемент по идентификатору %1.
			|Обратитесь к Администратору системы.'");
			
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(ШаблонСообщения, Идентификатор);
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.ПараметрыОбмена = РезультатПоиска.ПараметрыОбмена;

	Возврат ВозвращаемоеЗначение;

КонецФункции

Функция МестоПримененияПоИдентификатору(Идентификатор) Экспорт
	
	ПараметрыПоиска = Новый Структура("Идентификатор, РасширенныйСоставДанных", Идентификатор, Истина);

	РезультатПоиска = ИнтерфейсСАТУРН.СписокМестПрименения(ПараметрыПоиска, 1, 100);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Элемент",         Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);
	ВозвращаемоеЗначение.Вставить("ПараметрыОбмена", Неопределено);

	Если РезультатПоиска.Список <> Неопределено И РезультатПоиска.Список.Количество() = 1 Тогда
		ВозвращаемоеЗначение.Элемент = РезультатПоиска.Список[0];
	ИначеЕсли Не ЗначениеЗаполнено(РезультатПоиска.ТекстОшибки) Тогда
		
		ШаблонСообщения = НСтр("ru = 'В системе ФГИС ""Сатурн"" не найден элемент по идентификатору %1.
			|Обратитесь к Администратору системы.'");
			
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(ШаблонСообщения, Идентификатор);
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.ПараметрыОбмена = РезультатПоиска.ПараметрыОбмена;

	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПАТПоИдентификатору(Идентификатор) Экспорт
	
	ПараметрыПоиска = Новый Структура("Идентификатор, РасширенныйСоставДанных", Идентификатор, Истина);

	РезультатПоиска = ИнтерфейсСАТУРН.СписокПАТ(ПараметрыПоиска, 1, 100);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Элемент",         Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);
	ВозвращаемоеЗначение.Вставить("ПараметрыОбмена", Неопределено);

	Если РезультатПоиска.Список <> Неопределено И РезультатПоиска.Список.Количество() = 1 Тогда
		ВозвращаемоеЗначение.Элемент = РезультатПоиска.Список[0];
	ИначеЕсли Не ЗначениеЗаполнено(РезультатПоиска.ТекстОшибки) Тогда
		
		ШаблонСообщения = НСтр("ru = 'В системе ФГИС ""Сатурн"" не найден элемент по идентификатору %1.
			|Обратитесь к Администратору системы.'");
			
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(ШаблонСообщения, Идентификатор);
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.ПараметрыОбмена = РезультатПоиска.ПараметрыОбмена;

	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПартияПоИдентификатору(Идентификатор) Экспорт
	
	ПараметрыПоиска = Новый Структура("Идентификатор, РасширенныйСоставДанных", Идентификатор, Истина);

	РезультатПоиска = ИнтерфейсСАТУРН.СписокПартий(ПараметрыПоиска, 1, 100);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Элемент",         Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);
	ВозвращаемоеЗначение.Вставить("ПараметрыОбмена", Неопределено);

	Если РезультатПоиска.Список <> Неопределено И РезультатПоиска.Список.Количество() = 1 Тогда
		ВозвращаемоеЗначение.Элемент = РезультатПоиска.Список[0];
	ИначеЕсли Не ЗначениеЗаполнено(РезультатПоиска.ТекстОшибки) Тогда
		
		ШаблонСообщения = НСтр("ru = 'В системе ФГИС ""Сатурн"" не найден элемент по идентификатору %1.
			|Обратитесь к Администратору системы.'");
			
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(ШаблонСообщения, Идентификатор);
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.ПараметрыОбмена = РезультатПоиска.ПараметрыОбмена;

	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ИмпортируемаяПартияПоИдентификатору(Идентификатор) Экспорт
	
	ПараметрыПоиска = Новый Структура("Идентификатор, РасширенныйСоставДанных", Идентификатор, Истина);

	РезультатПоиска = ИнтерфейсСАТУРН.СписокИмпортируемыхПартий(ПараметрыПоиска, 1, 100);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Элемент",         Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);
	ВозвращаемоеЗначение.Вставить("ПараметрыОбмена", Неопределено);

	Если РезультатПоиска.Список <> Неопределено И РезультатПоиска.Список.Количество() = 1 Тогда
		ВозвращаемоеЗначение.Элемент = РезультатПоиска.Список[0];
	КонецЕсли;
	
	ВозвращаемоеЗначение.ПараметрыОбмена = РезультатПоиска.ПараметрыОбмена;

	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область ЗагрузкаИзСАТУРНПоОрганизации

Функция МестаХраненияПоОрганизации(ИдентификаторОрганизации, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = 0) Экспорт
	
	ПараметрыПоиска = Новый Структура("ИдентификаторОрганизации", ИдентификаторОрганизации);
	
	РезультатПоиска = ИнтерфейсСАТУРН.СписокМестХранения(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Список",          Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);

	Если РезультатПоиска.Список <> Неопределено Тогда
		ВозвращаемоеЗначение.Список = РезультатПоиска.Список;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция МестаПримененияПоОрганизации(ИдентификаторОрганизации, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = 0) Экспорт
	
	ПараметрыПоиска = Новый Структура("ИдентификаторОрганизации", ИдентификаторОрганизации);
	
	РезультатПоиска = ИнтерфейсСАТУРН.СписокМестПрименения(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Список",         Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     РезультатПоиска.ТекстОшибки);

	Если РезультатПоиска.Список <> Неопределено Тогда
		ВозвращаемоеЗначение.Список = РезультатПоиска.Список;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецОбласти