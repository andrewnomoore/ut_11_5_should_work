#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Поле", "Заполнение", "Организация"),
			ЭтотОбъект,
			"Организация",
			,
			Отказ);
	КонецЕсли;

	Если СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском
		Или СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО Тогда
		
		Если СертификатыПодписейОрганизации.Количество() = 0 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Список", "Заполнение", , , НСтр("ru = 'Сертификаты организации'")),
				ЭтотОбъект,
				"СертификатыПодписейОрганизации",
				,
				Отказ);
		КонецЕсли;
	Иначе
		Отбор = Новый Структура;
		Отбор.Вставить("Формировать", Истина);
		Отбор.Вставить("ИспользоватьЭП", Истина);
		
		Если ИсходящиеДокументы.НайтиСтроки(Отбор).Количество() > 0 И СертификатыПодписейОрганизации.Количество() = 0 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Список", "Заполнение", , , НСтр("ru = 'Сертификаты организации'")),
				ЭтотОбъект,
				"СертификатыПодписейОрганизации",
				,
				Отказ);
		КонецЕсли;
		
		Если СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
			Если НЕ ЗначениеЗаполнено(АдресСервера) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Поле", "Заполнение", НСтр("ru = 'Адрес сервера'")),
					ЭтотОбъект,
					"АдресСервера",
					,
					Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Проверим заполненность маршрута подписания в исходящих документах
	Отбор = Новый Структура;
	Отбор.Вставить("МаршрутПодписания", Справочники.МаршрутыПодписания.ПустаяСсылка());
	Отбор.Вставить("Формировать", Истина);
	Отбор.Вставить("ИспользоватьЭП", Истина);
	СтрокиСПустымиМаршрутами = ИсходящиеДокументы.НайтиСтроки(Отбор);
	Для Каждого СтрокаОшибки Из СтрокиСПустымиМаршрутами Цикл
		ТекстОшибки = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Колонка", "Заполнение", "МаршрутПодписания", 
			СтрокаОшибки.НомерСтроки, НСтр("ru = 'Виды электронных документов'"));
		ИмяПоля = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"ИсходящиеДокументы[%1].ДополнительныеНастройки", СтрокаОшибки.НомерСтроки - 1);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ИмяПоля,, Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОчиститьРегистр = Ложь;
	Если ПометкаУдаления Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка
		|ИЗ
		|	Справочник.УдалитьСоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
		|ГДЕ
		|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ПрофильНастроекЭДО = &ПрофильНастроекЭДО
		|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.СтатусПодключения = ЗНАЧЕНИЕ(Перечисление.СтатусыПриглашений.Принято)";
		Запрос.УстановитьПараметр("ПрофильНастроекЭДО", Ссылка);
		
		УстановитьПривилегированныйРежим(Истина);
		Если Не Запрос.Выполнить().Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Операция отменена. Текущий профиль настроек ЭДО используется в действующих настройках ЭДО.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
		
		Если Не Отказ Тогда
			ОчиститьРегистрНовыеДокументыВСервисеЭДО();
			ОчиститьРегистр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ОчиститьРегистр И Не ЭтоНовый() Тогда
		ИдентификаторСсылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИдентификаторОрганизации");
		Если Не ИдентификаторОрганизации = ИдентификаторСсылки Тогда
			ОчиститьРегистрНовыеДокументыВСервисеЭДО();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура ОчиститьРегистрНовыеДокументыВСервисеЭДО()
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.УдалитьНовыеДокументыВСервисеЭДО.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПрофильЭДО.Установить(Ссылка);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Только для внутреннего использования
Процедура ИзменитьДанныеВСвязанныхНастройкахЭДО(ПрофильНастроекЭДО, Отказ) Экспорт
	
	// Замена табличной части в связанных настройках ЭДО.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УдалитьСоглашенияОбИспользованииЭД.ИдентификаторКонтрагента,
	|	УдалитьСоглашенияОбИспользованииЭД.Ссылка КАК НастройкаЭДО
	|ИЗ
	|	Справочник.УдалитьСоглашенияОбИспользованииЭД КАК УдалитьСоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ УдалитьСоглашенияОбИспользованииЭД.РасширенныйРежимНастройкиСоглашения
	|	И УдалитьСоглашенияОбИспользованииЭД.ПрофильНастроекЭДО = &ПрофильНастроекЭДО";
	
	Запрос.УстановитьПараметр("ПрофильНастроекЭДО", ПрофильНастроекЭДО.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	НачатьТранзакцию();
	Попытка
		Пока Выборка.Следующий() Цикл
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.УдалитьСоглашенияОбИспользованииЭД");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.НастройкаЭДО);
			Блокировка.Заблокировать();
			
			// Готовится ТЧ для разовой замены в Настройках ЭДО.
			ИсходнаяТаблицаЭД = ПрофильНастроекЭДО.ИсходящиеДокументы.Выгрузить();
			ИсходнаяТаблицаЭД.Колонки.Добавить("ПрофильНастроекЭДО");
			ИсходнаяТаблицаЭД.Колонки.Добавить("СпособОбменаЭД");
			ИсходнаяТаблицаЭД.Колонки.Добавить("ИдентификаторОрганизации");
			ИсходнаяТаблицаЭД.Колонки.Добавить("ИдентификаторКонтрагента");
			
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(ПрофильНастроекЭДО.Ссылка,                   "ПрофильНастроекЭДО");
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(ПрофильНастроекЭДО.СпособОбменаЭД,           "СпособОбменаЭД");
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(ПрофильНастроекЭДО.ИдентификаторОрганизации, "ИдентификаторОрганизации");
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(Выборка.ИдентификаторКонтрагента,            "ИдентификаторКонтрагента");
			
			ВыбраннаяНастройкаЭДО = Выборка.НастройкаЭДО.ПолучитьОбъект();
			ВыбраннаяНастройкаЭДО.ОбменДанными.Загрузка = Истина;
			ВыбраннаяНастройкаЭДО.ИдентификаторОрганизации = ПрофильНастроекЭДО.ИдентификаторОрганизации;
			ВыбраннаяНастройкаЭДО.ИспользоватьУПД = ПрофильНастроекЭДО.ИспользоватьУПД;
			ВыбраннаяНастройкаЭДО.ИспользоватьУКД = ПрофильНастроекЭДО.ИспользоватьУКД;
			ВыбраннаяНастройкаЭДО.ИсходящиеДокументы.Загрузить(ИсходнаяТаблицаЭД);
			ВыбраннаяНастройкаЭДО.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли