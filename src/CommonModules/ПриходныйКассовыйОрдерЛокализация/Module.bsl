#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация
	
	МеханизмыДокумента.Добавить("ПодарочныеСертификаты");
	

	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив из Строка - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	
	ПодарочныеСертификатыСервер.ОбработкаПроверкиЗаполнения(Объект, Отказ);
	
	
	//-- Локализация

КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект.ПриходныйКассовыйОрдер - Приходный кассовый ордер
//  ДокОснование - Произвольный - Значение, которое используется как основание для заполнения.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения, данный параметр будет дозаполнен данными.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДокОснование, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	
	Если ЗначениеЗаполнено(ДокОснование) Тогда
		
		ТипОснования = ТипЗнч(ДокОснование);
		
		Если ТипОснования = Тип("ДокументСсылка.ВыемкаДенежныхСредствИзКассыККМ") Тогда
			ЗаполнитьПоВыемкеДенежныхСредствИзКассыККМ(Объект, ДокОснование, ДанныеЗаполнения);
		
		КонецЕсли;
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//++ Локализация
	// Приходный кассовый ордер
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КО1";
	КомандаПечати.Представление = НСтр("ru = 'Приходный кассовый ордер'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Переопределим печатную форму ПКО в целях локализации
	Команда = КомандыПечати.Найти("ПКО", "Идентификатор");
	Если Команда <> Неопределено Тогда
		КомандыПечати.Удалить(Команда);
	КонецЕсли;
	

	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	//++ Локализация
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КО1") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"КО1",
			НСтр("ru='Приходный кассовый ордер'"),
			СформироватьПечатнуюФормуКО1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

Процедура СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, КомплектПечатныхФорм) Экспорт
	//++ Локализация
	КомплектыПечатиПоОбъектам = РегистрыСведений.НастройкиПечатиОбъектов.КомплектыПечатиПоОбъектам(КоллекцияПечатныхФорм,
		КомплектПечатныхФорм,
		МассивОбъектов,
		"КО1");
	Для Каждого КомплектПечати Из КомплектыПечатиПоОбъектам Цикл
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			КомплектПечати.Имя,
			КомплектПечати.Представление,
			СформироватьПечатнуюФормуКО1(КомплектПечати.Объекты, ОбъектыПечати, ПараметрыПечати));
	КонецЦикла;
	//-- Локализация
КонецПроцедуры

Процедура КомплектПечатныхФорм(КомплектПечатныхФорм) Экспорт
	//++ Локализация
	// Переопределим печатную форму ПКО в целях локализации
	Команда = КомплектПечатныхФорм.Найти("ПКО", "Имя");
	Если Команда <> Неопределено Тогда
		КомплектПечатныхФорм.Удалить(Команда);
	КонецЕсли;
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "КО1", НСтр("ru = 'Приходный кассовый ордер'"), 1);
	//-- Локализация
КонецПроцедуры

//++ Локализация
Функция СформироватьПечатнуюФормуКО1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КО1";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриходныйКассовыйОрдер.ПФ_MXL_КО1_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	ИспользуетсяРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") И НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(ДанныеДокумента.ИсправляемыйДокумент.Дата, ДанныеДокумента.Дата) КАК ДатаДокумента,
	|	ЕСТЬNULL(ДанныеДокумента.ИсправляемыйДокумент.Номер, ДанныеДокумента.Номер) КАК Номер,
	|	ДанныеДокумента.Организация.Наименование КАК НаименованиеОрганизации,
	|	ДанныеДокумента.Организация.НаименованиеСокращенное КАК НаименованиеОрганизацииСокращенное,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	ДанныеДокумента.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
	|	ВЫБОР 
	|		КОГДА ДанныеДокумента.Валюта = ДанныеДокумента.Организация.ВалютаРегламентированногоУчета
	|			ТОГДА ""50.01""
	|		ИНАЧЕ ""50.21""
	|	КОНЕЦ КАК КодДебета,
	|	ДанныеДокумента.Касса.КассоваяКнига.СтруктурноеПодразделение КАК ПредставлениеПодразделения,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Контрагент.Представление КАК КонтрагентПредставление,
	|	ДанныеДокумента.ПринятоОт КАК ПринятоОт,
	|	ДанныеДокумента.Основание КАК Основание,
	|	ДанныеДокумента.Приложение КАК Приложение,
	|	ДанныеДокумента.ВТомЧислеНДС КАК ВТомЧисле,
	|	ДанныеДокумента.СуммаДокумента КАК Сумма,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Валюта.Представление КАК ВалютаПредставление,
	|	ДанныеДокумента.Организация.КодПоОКПО КАК ОрганизацияПоОКПО,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Кассир = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Автор.ФизическоеЛицо
	|		ИНАЧЕ ДанныеДокумента.Кассир
	|	КОНЕЦ КАК Кассир,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер
	|;";
	
	Если Не ИспользуетсяРеглУчет Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВложенныйЗапрос.Ссылка,
		|	ВложенныйЗапрос.СтатьяДвиженияДенежныхСредств,
		|	СтатьиДвиженияДенежныхСредств.КорреспондирующийСчет КАК КорСчетКод
		|ИЗ
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		ДанныеДокумента.Ссылка КАК Ссылка,
		|		ДанныеДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
		|	ИЗ
		|		Документ.ПриходныйКассовыйОрдер КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В(&МассивДокументов)
		|	
		|	ОБЪЕДИНИТЬ
		|	
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		РасшифровкаПлатежа.Ссылка,
		|		РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
		|	ИЗ
		|		Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|	ГДЕ
		|		РасшифровкаПлатежа.Ссылка В(&МассивДокументов)) КАК ВложенныйЗапрос
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДвиженияДенежныхСредств
		|		ПО ВложенныйЗапрос.СтатьяДвиженияДенежныхСредств = СтатьиДвиженияДенежныхСредств.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	КорреспондирующийСчет";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	Выборка           = МассивРезультатов[0].Выбрать();
	КорСчета          = МассивРезультатов[1].Выгрузить();
	
	ПервыйДокумент = Истина;
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, Выборка.Ссылка);
		ОбластьМакета.Параметры.Заполнить(Выборка);
		
		Если Не ПустаяСтрока(Выборка.НаименованиеОрганизацииСокращенное) Тогда
			ОбластьМакета.Параметры.ПредставлениеОрганизации = Выборка.НаименованиеОрганизацииСокращенное;
		Иначе
			ОбластьМакета.Параметры.ПредставлениеОрганизации = Выборка.НаименованиеОрганизации;
		КонецЕсли;
		
		Сумма = Формат(Выборка.Сумма, "ЧДЦ=2");
		Если Выборка.ВалютаРегламентированногоУчета <> Выборка.Валюта Тогда
			Сумма = Сумма + " " + СокрЛП(Выборка.ВалютаПредставление);
		КонецЕсли;
		ОбластьМакета.Параметры.Сумма = Сумма;
		ОбластьМакета.Параметры.СуммаРубКоп = ФормированиеПечатныхФорм.СуммаРубКоп(
			Выборка.Сумма, 
			Выборка.Валюта,	
			Выборка.ВалютаРегламентированногоУчета);
		Если Выборка.Валюта <> Выборка.ВалютаРегламентированногоУчета Тогда
			ОбластьМакета.Параметры.СуммаРубКоп = ОбластьМакета.Параметры.СуммаРубКоп + " " + СокрЛП(Выборка.ВалютаПредставление); 
		КонецЕсли;
		ОбластьМакета.Параметры.СуммаПрописью = РаботаСКурсамиВалютУТ.СформироватьСуммуПрописью(
			Выборка.Сумма, 
			Выборка.Валюта, 
			Ложь); // ВыводитьСуммуБезКопеек
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
			Выборка.Номер, 
			Ложь,
			Истина);
		ОбластьМакета.Параметры.СубСчет = КорреспондирующийСчет(Выборка, КорСчета, ИспользуетсяРеглУчет);
		
		Если ПустаяСтрока(Выборка.ВТомЧисле) Тогда
			ОбластьМакета.Параметры.ВТомЧисле = НСтр("ru='без налога (НДС)'", Метаданные.Языки.Русский.КодЯзыка);
		КонецЕсли;
		
		ОбластьМакета.Параметры.ФИОГлавногоБухгалтера = Выборка.ГлавныйБухгалтер;
		ОбластьМакета.Параметры.ФИОКассира = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Выборка.Кассир, Выборка.ДатаДокумента);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			Выборка.Ссылка);
	КонецЦикла;
	
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция КорреспондирующийСчет(ДанныеДокумента, КорСчета, ИспользуетсяРеглУчет)
	
	Отбор = Новый Структура("Ссылка", ДанныеДокумента.Ссылка);
	КорСчетаДокумента = КорСчета.НайтиСтроки(Отбор);
	Результат = "";
	Для Каждого Счет Из КорСчетаДокумента Цикл
		Результат = Результат + " " + СокрЛП(Счет.КорСчетКод);
	КонецЦикла;
	
	Если Результат = "" И Не ИспользуетсяРеглУчет Тогда
		СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПредопределеннаяСтатьяДДС(ДанныеДокумента.ХозяйственнаяОперация,
																											ДанныеДокумента.Валюта);
		Результат = СтатьяДвиженияДенежныхСредств.КорреспондирующийСчет;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции
//-- Локализация

#КонецОбласти


#Область Фискализация

//++ Локализация

// Возвращает параметры операции фискализации чека для печати чека по документу
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// Возвращаемое значение:
// 	Структура - Структура параметров операции фискализации чека
Функция ОсновныеПараметрыОперации(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ОсновныеПараметрыОперации = ФормированиеФискальныхЧековСерверПереопределяемый.СтруктураОсновныхПараметровОперации();
	
	ОсновныеПараметрыОперации.ДокументСсылка       = Объект.Ссылка;
	ОсновныеПараметрыОперации.Организация          = Объект.Организация;
	ОсновныеПараметрыОперации.Контрагент           = Объект.Контрагент;
	ОсновныеПараметрыОперации.Партнер              = Объект.Партнер;
	ОсновныеПараметрыОперации.Валюта               = Объект.Валюта;
	ОсновныеПараметрыОперации.СуммаДокумента       = Объект.СуммаДокумента;
	
	ОсновныеПараметрыОперации.ИмяРеквизитаГиперссылкиНаФорме = "ФискальнаяОперацияСтатус";
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ Тогда
		ОсновныеПараметрыОперации.ИмяКомандыПробитияЧека = "ПробитьЧекИнкассацияВыемка";
		ОсновныеПараметрыОперации.ТорговыйОбъект         = Объект.КассаККМ;
	Иначе
		ОсновныеПараметрыОперации.ИмяКомандыПробитияЧека = "ПробитьЧек";
		ОсновныеПараметрыОперации.ТорговыйОбъект         = Объект.Касса;
	КонецЕсли;
	
	Возврат ОсновныеПараметрыОперации;
	
КонецФункции

// Определяет, разрешено ли пробитие фискального чека по документу
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// Возвращаемое значение:
// 	Булево - Истина, если разрешено пробитие чека
Функция РазрешеноПробитиеФискальныхЧековПоДокументу(Форма) Экспорт
	
	РазрешеноПробитиеФискальныхЧековПоДокументу = Ложь;
	
	Если Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ Тогда
		
		РазрешеноПробитиеФискальныхЧековПоДокументу = Истина;
		
	ИначеЕсли Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации
		Или Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
		Или (Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Объект.Контрагент, "ЮрФизЛицо") = Перечисления.ЮрФизЛицо.ФизЛицо) Тогда
		
		РазрешеноПробитиеФискальныхЧековПоДокументу = Истина;
	КонецЕсли;
	
	Возврат РазрешеноПробитиеФискальныхЧековПоДокументу;
	
КонецФункции

// Формирует массив форматированных строк для формирования гиперссылки пробития фискального чека
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ-ссылка, по которому пробивается фискальный чек
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// 	МассивПредставлений - Массив из ФорматированнаяСтрока - Массив форматированных строк для формирования гиперссылки
//    пробития фискального чека.
Процедура ОбновитьГиперссылкуПробитияФискальногоЧека(ДокументСсылка, Форма, МассивПредставлений) Экспорт
	
	ФискальнаяОперацияДанныеЖурнала = ФормированиеФискальныхЧековСервер.ДанныеПробитогоФискальногоЧекаПоДокументу(ДокументСсылка);
	
	Если ФискальнаяОперацияДанныеЖурнала <> Неопределено Тогда
		
		НомерЧекаККМ = ФискальнаяОперацияДанныеЖурнала.НомерЧекаККМ;
		СуммаЧекаККМ = ФискальнаяОперацияДанныеЖурнала.Сумма;
		ТекстСсылки = "ОткрытьЗаписьФискальнойОперации";
		
		Если Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ Тогда
			ТекстПредставления = СтрШаблон(НСтр("ru = 'Пробит чек на сумму %1'"), СуммаЧекаККМ);
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуЧекПробит(МассивПредставлений, НомерЧекаККМ, ТекстСсылки, ТекстПредставления);
		Иначе
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуЧекПробит(МассивПредставлений, НомерЧекаККМ, ТекстСсылки);
		КонецЕсли;
		
	ИначеЕсли ФормированиеФискальныхЧековСервер.ЕстьПравоНаПробитиеФискальногоЧекаПоДокументу(ДокументСсылка) Тогда
		
		Если ФормированиеФискальныхЧековСервер.ЕстьПодключенноеОборудованиеККассамОрганизации(Форма.Объект.Организация) Тогда 
			ТекстСсылки = "ПробитьЧек";
			Если Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ Тогда
				ТекстСсылки = "ПробитьЧекИнкассацияВыемка";
			КонецЕсли;
			
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуПробитьЧек(МассивПредставлений, ТекстСсылки);
		Иначе
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиСтатусЧекНеПробит(МассивПредставлений, "НастроитьОборудование");
		КонецЕсли;
		
	Иначе
		
		ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиСтатусЧекНеПробит(МассивПредставлений);
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет виды фискальных чеков, доступных по документу
// 
// Параметры:
// 	ВидыЧеков - ТаблицаЗначений - Таблица значений, содержащая виды фискальных чеков, доступных по документу
// 	Операция - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция по документу
// 	ИмяКомандыПробитияЧека - Строка - Имя команды пробития чека
Процедура ЗаполнитьВидыФискальныхЧековПоДокументу(ВидыЧеков, Операция, ИмяКомандыПробитияЧека) Экспорт
	
	ТипРасчетовДенежнымиСредствами = Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств; // Операция = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
	Если Операция = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика Тогда
		ТипРасчетовДенежнымиСредствами = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратРасходаДенежныхСредств;
	КонецЕсли;
	
	ВидЧека = ВидыЧеков.Добавить();
	ВидЧека.ТипФискальногоДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧек;
	ВидЧека.ТипРасчетаДенежнымиСредствами = ТипРасчетовДенежнымиСредствами;
	ВидЧека.ВидЧекаКоррекции = Неопределено;
	
	Если ФормированиеФискальныхЧековСерверПереопределяемый.РазрешенКассовыйЧекКоррекцииДляТипаРасчетов(ТипРасчетовДенежнымиСредствами) Тогда
		ВидЧека = ВидыЧеков.Добавить();
		ВидЧека.ТипФискальногоДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧекКоррекции;
		ВидЧека.ТипРасчетаДенежнымиСредствами =ТипРасчетовДенежнымиСредствами;
		ВидЧека.ВидЧекаКоррекции = Перечисления.ВидыЧековКоррекции.НеприменениеККТ;
	КонецЕсли;
	
КонецПроцедуры

// Определяет систему налогообложения по документу
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ для определения системы налогообложения
// Возвращаемое значение:
// 	ПеречислениеСсылка.ТипыСистемНалогообложенияККТ - Система налогообложения по документу
Функция СистемаНалогообложенияПоДокументу(ДокументСсылка) Экспорт
	
	РасшифровкаПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "РасшифровкаПлатежа").Выгрузить();
	
	МассивОбъектовРасчетов = РасшифровкаПлатежа.ВыгрузитьКолонку("ОбъектРасчетов");
	МассивОбъектовРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОбъектовРасчетов, "НалогообложениеНДС");
	
	НалогообложениеНДСПоОбъектамРасчетов = Новый Массив();
	Для Каждого ОбъектРасчетов Из МассивОбъектовРасчетов Цикл
		
		Если ЗначениеЗаполнено(ОбъектРасчетов.Значение.НалогообложениеНДС) Тогда
			Если НалогообложениеНДСПоОбъектамРасчетов.Найти(ОбъектРасчетов.Значение.НалогообложениеНДС) = Неопределено Тогда
				НалогообложениеНДСПоОбъектамРасчетов.Добавить(ОбъектРасчетов.Значение.НалогообложениеНДС);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	СистемаНалогообложения = Неопределено;
	Если НалогообложениеНДСПоОбъектамРасчетов.Количество() = 1 Тогда
		Если НалогообложениеНДСПоОбъектамРасчетов[0] = Перечисления.ТипыНалогообложенияНДС.ПродажаПоПатенту Тогда
			СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.Патент;
		ИначеЕсли НалогообложениеНДСПоОбъектамРасчетов[0] = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД Тогда
			СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ЕНВД;
		КонецЕсли;
	КонецЕсли;
	
	Если СистемаНалогообложения = Неопределено Тогда
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Организация");
		СистемаНалогообложения = РозничныеПродажиЛокализация.СистемаНалогообложенияФискальнойОперации(РеквизитыДокумента.Организация);
	КонецЕсли;
	
	Возврат СистемаНалогообложения;
	
КонецФункции

// Возвращает наименование клиента, кто внес или получил денежные средства в качестве аванса
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ для определения системы налогообложения
// Возвращаемое значение:
// 	Строка - Наименование клиента платежа-аванса
Функция КлиентАвансовогоПлатежаНаименование(ДокументСсылка) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "ПринятоОт");
	
КонецФункции

//-- Локализация

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	
	ТекстЗапросаТаблицаАктивацияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры);
	

	//-- Локализация
	
КонецПроцедуры

//++ Локализация

Функция ТекстЗапросаТаблицаАктивацияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АктивацияПодарочныхСертификатов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОбъектыРасчетов.Объект КАК ПодарочныйСертификат,
		|	&Период КАК ДатаНачалаДействия,
		|	ВЫБОР
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕНЬ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, НЕДЕЛЯ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, КВАРТАЛ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ГОД, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕКАДА, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ПОЛУГОДИЕ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		ИНАЧЕ &Период
		|	КОНЕЦ КАК ДатаОкончанияДействия,
		|	&Организация КАК Организация
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ТабличнаяЧасть
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|		ПО (ОбъектыРасчетов.Ссылка = ТабличнаяЧасть.ОбъектРасчетов)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
		|		ПО (ВидыПодарочныхСертификатов.Ссылка = ОбъектыРасчетов.Объект.Владелец)
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &Ссылка
		|	И ОбъектыРасчетов.Объект ССЫЛКА Справочник.ПодарочныеСертификаты";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции


//-- Локализация

#КонецОбласти

#Область Прочее

//++ Локализация
Процедура ЗаполнитьПоВыемкеДенежныхСредствИзКассыККМ(Объект, Знач ВыемкаДенежныхСредствИзКассыККМ, ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Неопределено                КАК Касса,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.КассаККМ    КАК КассаОтправитель,
	|	ДанныеДокумента.Валюта      КАК Валюта,
	|	ДанныеДокумента.Ссылка      КАК ДокументОснование,
	|	
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы) КАК ХозяйственнаяОперация
	|	
	|ИЗ
	|	Документ.ВыемкаДенежныхСредствИзКассыККМ КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", ВыемкаДенежныхСредствИзКассыККМ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		ДанныеЗаполнения.Вставить(Колонка.Имя);
	КонецЦикла;
	
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить приходный кассовый ордер на основании документа %1'"),
			Объект.ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
		ДенежныеСредстваСервер.ЗаполнитьРеквизитыДокументаПоФормеОплаты(
			Перечисления.ФормыОплаты.Наличная,
			ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

// Определяет свойства полей формы в зависимости от данных
//
// Возвращаемое значение:
//    ТаблицаЗначений - таблица с колонками Поля, Условие, Свойства.
//
Процедура ЗаполнитьНастройкиПолейФормы(Настройки) Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;
	
	Операции = Перечисления.ХозяйственныеОперации;
	
	#Область РасшифровкаПлатежа
	// ДоговорЗаймаСотруднику, ТипСуммыКредитаДепозита
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РасшифровкаПлатежа.ДоговорЗаймаСотруднику");
	Элемент.Поля.Добавить("РасшифровкаБезРазбиенияДоговорЗаймаСотруднику");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьНачислениеЗарплатыУТ", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "ХозяйственнаяОперация", Операции.ПогашениеЗаймаСотрудником);
	Элемент.Свойства.Вставить("Видимость");
	
	// ТипСуммыКредитаДепозита
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РасшифровкаПлатежа.ТипСуммыКредитаДепозита");
	Элемент.Поля.Добавить("РасшифровкаБезРазбиенияТипСуммыКредитаДепозита");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствПоДепозитам);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствПоЗаймамВыданным);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПогашениеЗаймаСотрудником);
	Элемент.Свойства.Вставить("Видимость");
	#КонецОбласти
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

//++ Локализация


//-- Локализация

#КонецОбласти
