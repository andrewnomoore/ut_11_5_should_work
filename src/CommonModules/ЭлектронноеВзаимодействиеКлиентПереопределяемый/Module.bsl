////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиентПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет интерактивное проведение документов перед формированием ЭД.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ДокументыМассив - Массив - Ссылки на документы, которые требуется провести перед формированием электронных документов.
//                             После выполнения функции из массива исключаются непроведенные документы.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                         которая должна быть вызвана после завершения проверки документов.
//  ФормаИсточник - ФормаКлиентскогоПриложения - форма, из которой была вызвана команда.
//  СтандартнаяОбработка - Булево - если значение установлено в Ложь, то стандартная обработка не выполняется.
//
Процедура ВыполнитьПроверкуПроведенияДокументов(ДокументыМассив, ОбработкаПродолжения, ФормаИсточник = Неопределено, СтандартнаяОбработка = Истина) Экспорт

	//++ Локализация
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	ОчиститьСообщения();
	
	РезультатПроверки = ИнтеграцияИСВызовСервераУТ.РезультатПроверкиПроведенностиДокументовИЗаполненияКодовМаркировки(ДокументыМассив);
	ДокументыТребующиеПроведение = РезультатПроверки.ДокументыТребующиеПроведение;
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронную версию документа, его необходимо предварительно провести.
										|Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронные версии документов, их необходимо предварительно провести.
										|Выполнить проведение документов и продолжить?'");
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
		ДополнительныеПараметры.Вставить("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение);
		ДополнительныеПараметры.Вставить("ФормаИсточник", ФормаИсточник);
		ДополнительныеПараметры.Вставить("ДокументыМассив", ДокументыМассив);
		Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовПродолжить", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.РазностьМассивов(
			ДокументыМассив,
			РезультатПроверки.ДокументыСОшибкамиПроверкиЗаполненияКодовМаркировки);
		
		Если ДокументыМассив.Количество() Тогда
			ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС

	//-- Локализация

КонецПроцедуры

// Открывает форму обращения в службу технической поддержки
//
// Параметры:
//  ДанныеДляТехПоддержки                     - Структура - данные, которые можно передать в переопределенную форму:
//     * АдресФайлаДляТехПоддержки            - Строка - адрес во временном хранилище файла с технической информацией.
//     * ТелефонСлужбыПоддержки               - Строка - телефон службы технической поддержки.
//     * АдресЭлектроннойПочтыСлужбыПоддержки - Строка - email службы технической поддержки.
//     * ТекстОбращения                       - Строка - текст обращения в службу технической поддержки.
//  СтандартнаяОбработка                      - Булево - если метод реализован, то необходимо установить значение Ложь.
//
Процедура ОткрытьФормуОбращенияВТехПоддержку(ДанныеДляТехПоддержки, СтандартнаяОбработка) Экспорт

	//++ Локализация
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	
	ИнтернетПоддержкаПользователейУПКлиент.ОтправитьСообщениеСПомощьюВебСтраницыИТС(ДанныеДляТехПоддержки.ТекстОбращения);
	//-- НЕ ГОСИС

	//-- Локализация

КонецПроцедуры

#Область ПереопределениеФормПодсистемы

// Общие замечания для методов области "ПереопределениеФормПодсистемы".
// Поддерживается переопределение форм со следующим назначением и стандартными элементами:
// * "СопоставлениеНоменклатуры" - форма сопоставления номенклатуры.
//  ** "Характеристика" - колонка характеристики ИБ таблицы сопоставления.
//  ** "Упаковка" - колонка упаковки ИБ таблицы сопоставления.
// Описание параметра "Контекст" для всех методов области:
//  * Назначение - Строка - назначение формы (см. выше).
//  * Форма - ФормаКлиентскогоПриложения - форма, для которой вызвано событие.
//  * Префикс - Строка - префикс имен для новых реквизитов, команд и элементов формы.
//  * СтандартныйЭлемент - Строка - идентификатор стандартного элемента (см. выше), для которого вызвано событие.
//                       - Неопределено - событие вызвано для элемента, добавленного в переопределяемой части.

// Выполняется при открытии формы подсистемы.
// Позволяет выполнить дополнительные действия с формой на клиенте.
//
// Параметры:
//  Контекст - ФиксированнаяСтруктура - контекст создания формы. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Отказ - Булево - аналогичен параметру обработчика события "ПриОткрытии" управляемой формы.
//
// Пример:
//  Если ВРег(Контекст.Назначение) = ВРег("СопоставлениеНоменклатуры") Тогда
//  	// действия с формой на клиенте...
//  КонецЕсли;
//
Процедура ПриОткрытииФормыПодсистемы(Контекст, Отказ) Экспорт
	
КонецПроцедуры

// Обработчик события ПриИзменении элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыПриИзменении(Контекст, Элемент) Экспорт
	
КонецПроцедуры

// Обработчик события НачалоВыбора элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  ДанныеВыбора - СписокЗначений - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыНачалоВыбора(Контекст, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события НачалоВыбораИзСписка элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыНачалоВыбораИзСписка(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события Очистка элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОчистка(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события Создание элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыСоздание(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события ОбработкаВыбора элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  ВыбранноеЗначение - Произвольный - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОбработкаВыбора(Контекст, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт

	//++ Локализация
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.ЭлементФормыПодсистемыОбработкаВыбора(Контекст, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	//-- НЕ ГОСИС

	//-- Локализация

КонецПроцедуры

// Обработчик события ИзменениеТекстаРедактирования элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  Текст - Строка - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыИзменениеТекстаРедактирования(Контекст, Элемент, Текст, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события АвтоПодбор элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  Текст - Строка - см. описание параметра события элемента формы.
//  ДанныеВыбора - СписокЗначений  - см. описание параметра события элемента формы.
//  ПараметрыПолученияДанных - Структура, Неопределено - см. описание параметра события элемента формы.
//  Ожидание - Число - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыАвтоПодбор(Контекст, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события ОкончаниеВводаТекста элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  Текст - Строка - см. описание параметра события элемента формы.
//  ДанныеВыбора - СписокЗначений  - см. описание параметра события элемента формы.
//  ПараметрыПолученияДанных - Структура, Неопределено - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОкончаниеВводаТекста(Контекст, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события Нажатие элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыНажатие(Контекст, Элемент) Экспорт
	
КонецПроцедуры

// Обработчик события ОбработкаНавигационнойСсылки элемента формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Элемент - ПолеФормы - см. описание параметра события элемента формы.
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыПодсистемыОбработкаНавигационнойСсылки(Контекст, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Выполняет действие команды формы подсистемы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. См. общие замечания области "ПереопределениеФормПодсистемы".
//  Команда - КомандаФормы - см. описание параметра действия команды формы.
//
Процедура КомандаФормыПодсистемыДействие(Контекст, Команда) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПроверкуПроведенияДокументовПродолжить(Знач Результат, Знач ДополнительныеПараметры) Экспорт

	//++ Локализация
	
	//++ НЕ ГОСИС
	ДокументыМассив = Неопределено;
	ОбработкаПродолжения = Неопределено;
	ДокументыТребующиеПроведение = Неопределено;
	Если Результат = КодВозвратаДиалога.Да
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения)
		И ДополнительныеПараметры.Свойство("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение) Тогда
		
		ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДокументыТребующиеПроведение);
		
		// Сообщения о документах, которые не провелись.
		ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2 Формирование ЭД невозможно.'");
		НепроведенныеДокументы = Новый Массив;
		Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																	ШаблонСообщения,
																	Строка(ИнформацияОДокументе.Ссылка),
																	ИнформацияОДокументе.ОписаниеОшибки);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ИнформацияОДокументе.Ссылка);
			НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
		КонецЦикла;
		
		КоличествоНепроведенныхДокументов = НепроведенныеДокументы.Количество();
		
		// Оповещаем открытые формы о том, что были проведены документы.
		ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыТребующиеПроведение,
																			 НепроведенныеДокументы);
		ТипыПроведенныхДокументов = Новый Соответствие;
		Для Каждого ПроведенныйДокумент Из ПроведенныеДокументы Цикл
			ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
		КонецЦикла;
		Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
			ОповеститьОбИзменении(Тип.Ключ);
		КонецЦикла;
		
		Оповестить("ОбновитьДокументИБПослеЗаполнения", ПроведенныеДокументы);
		
		// Обновляем исходный массив документов.
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыМассив, НепроведенныеДокументы);
		ЕстьДокументыГотовыеДляФормированияЭД = ДокументыМассив.Количество() > 0;
		Если КоличествоНепроведенныхДокументов > 0 Тогда
			
			// Спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов.
			ТекстВопроса = НСтр("ru = 'Не удалось провести один или несколько документов.'");
			КнопкиДиалога = Новый СписокЗначений;
			
			Если ЕстьДокументыГотовыеДляФормированияЭД Тогда
				ТекстВопроса = ТекстВопроса + " " + НСтр("ru = 'Продолжить?'");
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
			Иначе
				КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
			КонецЕсли;
			ДопПараметры = Новый Структура("ОбработкаПродолжения, ДокументыМассив", ОбработкаПродолжения, ДокументыМассив);
			Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовЗавершить", ЭтотОбъект, ДопПараметры);
			ПоказатьВопрос(Обработчик, ТекстВопроса, КнопкиДиалога);
		Иначе
			
			ДокументыСОшибками = ИнтеграцияИСВызовСервераУТ.ДокументыСОшибкамиПроверкиЗаполненияКодовМаркировки(ДокументыМассив);
			ДокументыМассив = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыМассив, ДокументыСОшибками);
			Если ДокументыМассив.Количество() Тогда
				ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
			КонецЕсли;
			
		КонецЕсли;
		Оповестить("ОбновитьСостояниеЭД");
	КонецЕсли;
	//-- НЕ ГОСИС

	//-- Локализация

КонецПроцедуры

Процедура ВыполнитьПроверкуПроведенияДокументовЗавершить(Знач Результат, Знач ДополнительныеПараметры) Экспорт

	//++ Локализация
	
	//++ НЕ ГОСИС
	ДокументыМассив = Неопределено;
	
	ОбработкаПродолжения = Неопределено;
	Если Результат = КодВозвратаДиалога.Пропустить
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения) Тогда
		
		ДокументыСОшибками = ИнтеграцияИСВызовСервераУТ.ДокументыСОшибкамиПроверкиЗаполненияКодовМаркировки(ДокументыМассив);
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыМассив, ДокументыСОшибками);
		Если ДокументыМассив.Количество() Тогда
			ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС

	//-- Локализация

КонецПроцедуры

#КонецОбласти
