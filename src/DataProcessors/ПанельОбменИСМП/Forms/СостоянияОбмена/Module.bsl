
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организации.Очистить();
	Если Параметры.Свойство("Организации") И ЗначениеЗаполнено(Параметры.Организации) Тогда
		Если ТипЗнч(Параметры.Организации) = Тип("Массив") Тогда
			Организации.ЗагрузитьЗначения(Параметры.Организации);
		ИначеЕсли ТипЗнч(Параметры.Организации) = Тип("СписокЗначений") Тогда
			Организации.ЗагрузитьЗначения(Параметры.Организации.ВыгрузитьЗначения());
		КонецЕсли;
		Параметры.Свойство("ОрганизацииПредставление", ОрганизацииПредставление);
		Параметры.Свойство("Организация", Организация);
		Параметры.Свойство("Ответственный", Ответственный);
		
	КонецЕсли;
	
	ОбновитьСписокПроблем();
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ХранитьФайлыВТомахНаДиске" Тогда
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.НастройкиРаботыСФайлами");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЕстьСообщенияОжидающиеОтправки" Тогда
		
		ПараметрыОткрытияФормы = Неопределено;
		Если Организации.Количество() > 0 Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("Организация", Организации.ВыгрузитьЗначения());
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
			
		КонецЕсли;
		
		ОткрытьФорму("РегистрСведений.ОчередьСообщенийИСМП.ФормаСписка", ПараметрыОткрытияФормы, ВладелецФормы);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НастроитьАвтоматическийОбмен"
		Или НавигационнаяСсылкаФорматированнойСтроки = "НастроитьАвтоматическуюПроверкуСтатусовДокументовВГИСМТ"
		Или НавигационнаяСсылкаФорматированнойСтроки = "НастроитьУдалениеНеиспользованныхКодовМаркировки"
		Или НавигационнаяСсылкаФорматированнойСтроки = "НастроитьЗагрузкуСведенийОбОтклонениях" Тогда
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияИСМП.Форма.НастройкиИСМП");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВыполнитьОбмен" Тогда
		
		ИнтеграцияИСМПКлиент.ВыполнитьОбмен(
			ВладелецФормы,
			ИнтеграцияИСМПКлиент.ОрганизацииДляОбмена(ВладелецФормы));
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НастройкаСертификатаНаСервере" Тогда
		
		ОткрытьФорму("ОбщаяФорма.НастройкаСертификатовДляАвтоматическогоОбменаИС");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НастройкаОтветственныхЗаПодписаниеСообщений" Тогда
		
		ОткрытьФорму("Справочник.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.ФормаСписка");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтправленныеДокументыСОшибками"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ПробитыеЧекиККТСОшибками"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ОтправленныеДокументыОтсутствующиеВЛКГИСМТ"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ПробитыеЧекиККТОтсутствующиеВЛКГИСМТ"
		Или НавигационнаяСсылкаФорматированнойСтроки = "НеОтправленныеДокументыСОшибкми" Тогда
		
		Если НавигационнаяСсылкаФорматированнойСтроки = "ОтправленныеДокументыСОшибками" Тогда
			
			ТипДокумента      = СоответствиеТребованиямГИСМТКлиентСервер.ТипыЭлектронныхДокументовГИСМТ();
			СтатусОтправки = ПредопределенноеЗначение("Перечисление.СтатусОтправкиГИСМТ.ДоставленВГИСМТ");
			
		ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПробитыеЧекиККТСОшибками" Тогда
			
			ТипДокумента      = ПредопределенноеЗначение("Перечисление.ТипыДокументовГИСМТ.ЧекККТ");
			СтатусОтправки = ПредопределенноеЗначение("Перечисление.СтатусОтправкиГИСМТ.ДоставленВГИСМТ");
			
		ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтправленныеДокументыОтсутствующиеВЛКГИСМТ" Тогда
			
			ТипДокумента      = СоответствиеТребованиямГИСМТКлиентСервер.ТипыЭлектронныхДокументовГИСМТ();
			СтатусОтправки = ПредопределенноеЗначение("Перечисление.СтатусОтправкиГИСМТ.ОжидаетсяПроверкаУПДвГИСМТ");
			
		ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПробитыеЧекиККТОтсутствующиеВЛКГИСМТ" Тогда
			
			ТипДокумента      = ПредопределенноеЗначение("Перечисление.ТипыДокументовГИСМТ.ЧекККТ");
			СтатусОтправки = ПредопределенноеЗначение("Перечисление.СтатусОтправкиГИСМТ.ОтправленВОФД");
			
		ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НеОтправленныеДокументыСОшибкми" Тогда
			
			ТипДокумента      = СоответствиеТребованиямГИСМТКлиентСервер.ТипыЭлектронныхДокументовГИСМТ();
			СтатусОтправки = ПредопределенноеЗначение("Перечисление.СтатусОтправкиГИСМТ.НеОтправлен");
		
		КонецЕсли;
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Организации",    Организации.ВыгрузитьЗначения());
		ПараметрыОткрытияФормы.Вставить("ТипДокумента",   ТипДокумента);
		ПараметрыОткрытияФормы.Вставить("СтатусОтправки", СтатусОтправки);
		ПараметрыОткрытияФормы.Вставить("ФлагОшибки",     Истина);
		
		ОткрытьФорму("РегистрСведений.РезультатыОбработкиДокументовИСМП.Форма.ФормаРезультатыПроверки",
			ПараметрыОткрытияФормы, ВладелецФормы, НавигационнаяСсылкаФорматированнойСтроки);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СведенияОбОтклоненияхОжидающиеДействия" Тогда
		
		СтруктураБыстрогоОтбора = Новый Структура();
		ПараметрыФормы = Новый Структура;
		
		СтруктураБыстрогоОтбора.Вставить("ДальнейшееДействиеИСМП", ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюИСМП.ПодтвердитеОбработкуОтклонений"));
		
		ИмяПоляОтветственный = "Ответственный";
		ИмяПоляОрганизации = "Организации";
		ИмяПоляОрганизация = "Организация";
		ИмяПоляПредставления = "ОрганизацииПредставление";
		
		СтруктураБыстрогоОтбора.Вставить(ИмяПоляОтветственный, Ответственный);
		СтруктураБыстрогоОтбора.Вставить(ИмяПоляОрганизации,   Организации);
		СтруктураБыстрогоОтбора.Вставить(ИмяПоляОрганизация,   Организации);
		СтруктураБыстрогоОтбора.Вставить(ИмяПоляПредставления, ОрганизацииПредставление);
		
		ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
		ОткрытьФорму("Документ.ОтчетИСМП.Форма.ФормаСпискаДокументов", ПараметрыФормы);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неизвестная ссылка: %1'"),
			НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокПроблем();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПроблем()
	
	РезультатыЗапроса = ИнтеграцияИСМП.СостояниеОбмена(Организации);
	
	ПроверитьХранениеФайловВТомахНаДиске();
	ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса);
	ПроверитьСтатусОтправкиДокументовВГИСМТ(РезультатыЗапроса);
	ПроверитьНастройкуСертификатаНаСервере(РезультатыЗапроса);
	ПроверитьНастройкуОтветственныхЗаПодписаниеСообщений(РезультатыЗапроса);
	ПроверитьНастройкиАвтоматическогоОбмена(РезультатыЗапроса);
	ПроверитьНастройкуПроверкаСтатусовДокументовГИСМТ(РезультатыЗапроса);
	ПроверитьНастройкиУдаленияНеиспользованныхКодовМаркировки();
	ПроверитьНастройкиАвтоматическойЗагрузкиСведенийОбОтклонениях(РезультатыЗапроса);
	ПроверитьОтчетыИСМПОжидающиеДействияПользователя(РезультатыЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьХранениеФайловВТомахНаДиске()
	
	ИдентификаторПроблемы = "ХранитьФайлыВТомахНаДиске";
	ИмяЭлемента           = "ХранитьФайлыВТомахНаДиске";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
		И Не ОбщегоНазначения.РазделениеВключено()
		И Не ИнтеграцияИС.ХранитьФайлыВТомахНаДиске();
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			Строка(Элементы[ИмяЭлемента].Заголовок),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru='Файлы обмена могут занимать значительный объем данных в базе.
			|Для уменьшения объема базы данных, файлы необходимо хранить в томах на диске.'");
		
		Если Не ИнтеграцияИС.ПравоДоступаПанельАдминистрированиеБСП() Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru='У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиАвтоматическойЗагрузкиСведенийОбОтклонениях(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "НастроитьЗагрузкуСведенийОбОтклонениях";
	ИмяЭлемента           = "НастроитьЗагрузкуСведенийОбОтклонениях";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	ЗаданиеВключено = Выборка.Количество() > 0;
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не ЗаданиеВключено;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			Строка(Элементы[ИмяЭлемента].Заголовок),,,,
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьОтчетыИСМПОжидающиеДействияПользователя(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "СведенияОбОтклоненияхОжидающиеДействия";
	ИмяЭлемента           = "СведенияОбОтклоненияхОжидающиеДействия";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Выборка.Следующий();
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть отчеты ИС МП (%1), ожидающие обработки сведений об отклонениях'"),
				Выборка.КоличествоДокументов),,,,
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьСообщенияОжидающиеОтправки";
	ИмяЭлемента           = "ЕстьСообщенияОжидающиеОтправки";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Выборка.Следующий();
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть сообщения ожидающие отправки (%1)'"),
				Выборка.КоличествоСообщений),,,,
			ИдентификаторПроблемы);
		
		СтрокаЗаголовка = Новый Массив;
		СтрокаЗаголовка.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Не все подготовленные для отправки сообщения доставлены в ИС МП.
					|Рекомендуется'")));
		СтрокаЗаголовка.Добавить(" ");
		СтрокаЗаголовка.Добавить(
			Новый ФорматированнаяСтрока(
				Нстр("ru='выполнить обмен'"),,,, "ВыполнитьОбмен"));
		СтрокаЗаголовка.Добавить(".");
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = Новый ФорматированнаяСтрока(СтрокаЗаголовка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатусОтправкиДокументовВГИСМТ(РезультатыЗапроса)
	
	ВозможныеПроблемыПроверкаГИСМТ     = СоответствиеТребованиямГИСМТ.ВозможныеПроблемыОбмена();
	
	Приоритеты            = ВозможныеПроблемыПроверкаГИСМТ.Приоритет;
	ИдентификаторыПроблем = ВозможныеПроблемыПроверкаГИСМТ.Идентификаторы;
	Представления         = ВозможныеПроблемыПроверкаГИСМТ.Представления;
	
	Для Каждого Приоритет Из Приоритеты Цикл
	
		ИдентификаторПроблемы = ИдентификаторыПроблем[Приоритет];
		ИмяЭлемента           = ИдентификаторПроблемы;
		ОписаниеПроблемы = Представления.Получить(ИдентификаторПроблемы);
		
		Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
		
		Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
		
		Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
			
			Выборка.Следующий();
			
			Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
				СтрШаблон(
					ОписаниеПроблемы,
					Выборка.Количество),,,,
				ИдентификаторПроблемы);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиАвтоматическогоОбмена(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "НастроитьАвтоматическийОбмен";
	ИмяЭлемента           = "НастроитьАвтоматическийОбмен";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	ЗаданиеВключено = Выборка.Количество() > 0;
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не ЗаданиеВключено;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			Строка(Элементы[ИмяЭлемента].Заголовок),,,,
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкуПроверкаСтатусовДокументовГИСМТ(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "НастроитьАвтоматическуюПроверкуСтатусовДокументовВГИСМТ";
	ИмяЭлемента           = "НастроитьАвтоматическуюПроверкуСтатусовДокументовВГИСМТ";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	ЗаданиеВключено = Выборка.Количество() > 0;
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не ЗаданиеВключено;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			Строка(Элементы[ИмяЭлемента].Заголовок),,,,
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкуСертификатаНаСервере(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "НастройкаСертификатаНаСервере";
	ИмяЭлемента           = "НастройкаСертификатаНаСервере";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	ЕстьПроблемы = Выборка.Количество() > 0;
	
	// Если задание включено, необходимо настроить сертификаты
	Элементы["Группа" + ИмяЭлемента].Видимость = ЕстьПроблемы;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить сертификаты на сервере для автоматического подписания сообщений'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Для выполнения регламентных заданий по обмену с ИС МП и проверке статусов в ГИС МТ
		                            |требуется подписание отправляемых сообщений.
		                            |Сообщения могут быть подписаны:
		                            |- Автоматически, если настроены сертификаты ЭЦП на сервере
		                            |- Ответственным за подписание сообщений.'");
		
		Если Не ПравоДоступа("Изменение", Метаданные.Константы.НастройкиОбменаГосИС) Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкуОтветственныхЗаПодписаниеСообщений(РезультатЗапроса)
	
	ИдентификаторПроблемы = "НастройкаОтветственныхЗаПодписаниеСообщений";
	ИмяЭлемента           = "НастройкаОтветственныхЗаПодписаниеСообщений";
	
	Выборка = РезультатЗапроса[ИдентификаторПроблемы].Выбрать();
	
	ЕстьПроблемы = Выборка.Количество() > 0;
	
	// Если сертификат не настроен и задание включено, необходимо настроить ответственных
	Элементы["Группа" + ИмяЭлемента].Видимость = ЕстьПроблемы;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить ответственных за подписание сообщений'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Для выполнения регламентных заданий по обмену с ИС МП и проверке статусов в ГИС МТ
		                            |требуется подписание отправляемых сообщений.
		                            |Сообщения могут быть подписаны:
		                            |- Автоматически, если настроены сертификаты ЭЦП на сервере
		                            |- Ответственным за подписание сообщений.'");
		
		Если Не ПравоДоступа("Изменение", Метаданные.Справочники.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП) Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиУдаленияНеиспользованныхКодовМаркировки()
	
	ИдентификаторПроблемы = "НастроитьУдалениеНеиспользованныхКодовМаркировки";
	ИмяЭлемента           = "НастроитьУдалениеНеиспользованныхКодовМаркировки";
	
	ЗаданиеВключено = Истина;
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Метаданные",    "УдалениеНеиспользованныхКодовМаркировкиИСМП");
		Отбор.Вставить("Использование", Истина);
		
		УстановитьПривилегированныйРежим(Истина);
		ЗаданиеВключено = РегламентныеЗаданияСервер.НайтиЗадания(Отбор).Количество() > 0;
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не ЗаданиеВключено;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			Строка(Элементы[ИмяЭлемента].Заголовок),,,,
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти