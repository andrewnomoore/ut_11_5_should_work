////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Механизм расчета статусов оформления документов ЗЕРНО.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Для добавления нового документа-основания к документу ЗЕРНО надо
//   - добавить ссылочный тип документа в определяемый тип с именем Основание<ИмяДокументаЗЕРНО>
//   - добавить ссылочный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовЗЕРНО
//   - добавить объектный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовЗЕРНООбъект
//
//   - дополнить процедуры общего модуля РасчетСтатусовОформленияЗЕРНОПереопределяемый
//     - ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаЗЕРНО()
//     - ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаЗЕРНО()
//
// Для подключения документа ЗЕРНО к этому механизму нужно:
//   - добавить его ссылочный тип в определяемый тип ДокументыЗЕРНОПоддерживающиеСтатусыОформления
//   - добавить его объектный тип в определяемый тип ДокументыЗЕРНОПоддерживающиеСтатусыОформленияОбъект
//   - добавить его объектный тип в определяемый тип ОснованиеСтатусыОформленияДокументовЗЕРНООбъект
//
//   - добавить в документ реквизит с именем ДокументОснование
//   - создать определяемый тип с именем Основание<ИмяДокументаЗЕРНО>
//     - заполнить этот тип ссылочными типами документов-оснований
//
//   - добавить типы из определяемого типа Основание<ИмяДокументаЗЕРНО> в ОснованиеСтатусыОформленияДокументовЗЕРНО
//   - добавить соответствующие ссылочным объектные типы из определяемого типа Основание<ИмяДокументаЗЕРНО>
//      в ОснованиеСтатусыОформленияДокументовЗЕРНООбъект
//
//   - дополнить процедуры общего модуля РасчетСтатусовОформленияЗЕРНОПереопределяемый
//     - ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаЗЕРНО()
//     - ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаЗЕРНО()
//
#Область ПрограммныйИнтерфейс

#Область ОбработчикиПодписокНаСобытияЗЕРНО

// Обработчик подписки на событие "Перед записью" документов ЗЕРНО, поддерживающих статусы оформления.
// 
// Параметры:
//   Источник        - ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформленияОбъект - записываемый объект
//   Отказ           - Булево - параметр, определяющий будет ли записываться объект
//   РежимЗаписи     - РежимЗаписиДокумента     - не используется
//   РежимПроведения - РежимПроведенияДокумента - не используется
//
Процедура РассчитатьСтатусОформленияЗЕРНОПередЗаписьюДокументаОбработчик(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	РасчетСтатусовОформленияИС.ПередЗаписьюДокумента("ВестиУчетЗернаИПродуктовПереработкиЗЕРНО", Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие "При записи" документов ЗЕРНО, поддерживающих статусы оформления, и их документов-оснований.
//
// Параметры:
//   Источник - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЗЕРНООбъект - записываемый объект.
//   Отказ    - Булево - параметр, определяющий будет ли записываться объект.
//
Процедура РассчитатьСтатусОформленияЗЕРНОПриЗаписиДокументаОбработчик(Источник, Отказ) Экспорт
	
	РасчетСтатусовОформленияИС.ПриЗаписиДокумента("ВестиУчетЗернаИПродуктовПереработкиЗЕРНО", Источник, Отказ, РасчетСтатусовОформленияЗЕРНО);
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПересчетСтатусов

// Рассчитывает статусы оформления документов и записывает их в регистр сведений СтатусыОформленияДокументовЗЕРНО.
//   ВАЖНО: все элементы массива Источники должны иметь одинаковый тип.
//
// Параметры:
//   Источники - Массив из ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформления,
//                         ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЗЕРНО - источники события.
//
Процедура РассчитатьСтатусыОформленияДокументов(Источники) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокументов("ВестиУчетЗернаИПродуктовПереработкиЗЕРНО", Источники, РасчетСтатусовОформленияЗЕРНО) Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСтатусыОформленияСДИЗ(Источники);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ФункцииОбщегоМеханизма

//Возвращает признак, что документ ИС МП поддерживает статусы оформления (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ ИС МП поддерживающий статус оформления
//
Функция ЭтоДокументПоддерживающийСтатусОформления(Источник) Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыЗЕРНОПоддерживающиеСтатусыОформленияОбъект.Тип.СодержитТип(ТипЗнч(Источник))
		ИЛИ Метаданные.ОпределяемыеТипы.ДокументыЗЕРНОПоддерживающиеСтатусыОформления.Тип.СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//Возвращает признак, что проверяемый объект может являться основанием для документа ИС МП (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ-основание для документа ИС МП.
//
Функция ЭтоДокументОснование(Источник) Экспорт
	
	Возврат ТипОснование().СодержитТип(ТипЗнч(Источник));
	
КонецФункции

// См. РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования.
// 
// Параметры:
//  ДокументОснование - См. РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования.ДокументОснование
// 
// Возвращаемое значение:
//  Массив из Строка -- .
Функция ИменаДокументовДляДокументаОснования(ДокументОснование) Экспорт
	
	Если ТипЗнч(ДокументОснование) = Тип("СправочникСсылка.СДИЗЗЕРНО") Тогда
		Имена = Новый Массив;
		Имена.Добавить(Метаданные.Документы.ПогашениеСДИЗЗЕРНО.Имя);
	Иначе
		Имена = РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования(ДокументОснование, ТипДокумент());
	КонецЕсли;
	Возврат Имена;
	
КонецФункции

//Реквизиты регистра "Статусы оформления документов ИС МП"
//
//Возвращаемое значение:
//   Массив Из ОбъектМетаданных - реквизиты.
//
Функция МетаРеквизиты() Экспорт
	
	Возврат Метаданные.РегистрыСведений.СтатусыОформленияДокументовЗЕРНО.Реквизиты;
	
КонецФункции

//Описание типов (документов) являющихся основаниями для оформления документов ИС МП.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип основание.
//
Функция ТипОснование() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ОснованиеСтатусыОформленияДокументовЗЕРНО.Тип;
	
КонецФункции

//Описание типов (документов) ИС МП поддерживающих статус оформления.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип документы ИС МП.
//
Функция ТипДокумент() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыЗЕРНОПоддерживающиеСтатусыОформления.Тип;
	
КонецФункции

#КонецОбласти

#Область Статусы

// Рассчитывает статус оформления документа и записывает его в регистр сведений СтатусыОформленияДокументовЗЕРНО.
//
// Параметры:
//   Источник - ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформления, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЗЕРНО, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЗЕРНООбъект - источник события расчета статуса.
//
Процедура РассчитатьСтатусОформленияДокумента(Знач Источник) Экспорт
	
	Если РассчитатьСтатусыОформленияПоРезультатамИсследованияЗЕРНО(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокумента("ВестиУчетЗернаИПродуктовПереработкиЗЕРНО", Источник, РасчетСтатусовОформленияЗЕРНО) Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСтатусыОформленияСДИЗ(Источник);
	
КонецПроцедуры

// Возвращает структуру с именами ключевых реквизитов документа-основания для документа ЗЕРНО.
//   Значения этих реквизитов будут записаны в регистр сведений СтатусыОформленияДокументовЗЕРНО.
//   Способ определения значения реквизита:
//      Строка - имя реквизита документа-основания из которого следует взять значение (при обращении через
//     точку будет выполнено обращение к реквизиту первой строки одноименной ТЧ или к реквизиту реквизита основания);
//      Произвольный - в т.ч. пустая строка - значение заполнения не зависящее от основания.
//
// Параметры:
//   МетаданныеОснования     - ОбъектМетаданных - метаданные документа-основания из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЗЕРНО
//   МетаданныеДокументаЗЕРНО - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформления
//
// Возвращаемое значение:
//   Структура - имена реквизитов (в качестве типа приведен тип соответствующего реквизита):
//     * Проведен      - Строка, Произвольный - документ-основание проведен.
//     * Дата          - Строка, Произвольный - дата основания.
//     * Номер         - Строка, Произвольный - номер основания.
//     * Ответственный - Строка, Произвольный - пользователь, оформивший документ-основание; значение по умолчанию "Ответственный".
//     * Контрагент    - Строка, Произвольный - организация в документе-основании; значение по умолчанию "Организация".
//     * ПометкаУдаления    - Строка, Булево - реквизит "пометка удаления" СДИЗ
//     * Статус             - Строка, ПеречислениеСсылка.СтатусыСДИЗЗЕРНО - реквизит "статус" СДИЗ
//     * Отгрузка           - Строка, Булево - реквизит "Отгрузка" СДИЗ
//     * Реализация         - Строка, Булево - реквизит "Реализация" СДИЗ
//     * Перевозка          - Строка, Булево - реквизит "Перевозка" СДИЗ
//     * Приемка            - Строка, Булево - реквизит "Приемка" СДИЗ
//     * ВидОперации        - Строка, ПеречислениеСсылка.ВидыОперацийЗЕРНО - реквизит "ВидОперации" СДИЗ
//     * УполномоченноеЛицо - Строка, СправочникСсылка.КлючиРеквизитовОрганизацийЗЕРНО - реквизит "Уполномоченное лицо" СДИЗ
//     * Грузополучатель    - Строка, СправочникСсылка.КлючиРеквизитовОрганизацийЗЕРНО - реквизит "Грузополучатель" СДИЗ
//     * Покупатель         - Строка, СправочникСсылка.КлючиРеквизитовОрганизацийЗЕРНО - реквизит "Покупатель" СДИЗ
Функция РеквизитыДляРасчета(МетаданныеОснования, МетаданныеДокументаЗЕРНО) Экспорт

	Реквизиты = Новый Структура;

	// Стандартные реквизиты
	Реквизиты.Вставить("Проведен", "Проведен");
	Реквизиты.Вставить("Дата", "Дата");
	Реквизиты.Вставить("Номер", "Номер");
	// Переопределяемые реквизиты
	Реквизиты.Вставить("Ответственный", "Ответственный");
	Реквизиты.Вставить("Контрагент", "Организация");
	// Дополнительно для СДИЗ
	Реквизиты.Вставить("ПометкаУдаления", "");
	Реквизиты.Вставить("Статус",          "");
	Реквизиты.Вставить("Отгрузка", "");
	Реквизиты.Вставить("Реализация", "");
	Реквизиты.Вставить("Перевозка", "");
	Реквизиты.Вставить("Приемка", "");
	Реквизиты.Вставить("ВидОперации", "");
	Реквизиты.Вставить("УполномоченноеЛицо", "");
	Реквизиты.Вставить("Грузополучатель", "");
	Реквизиты.Вставить("Покупатель", "");
	
	Если МетаданныеОснования = Метаданные.Справочники.СДИЗЗЕРНО Тогда
		Реквизиты.Номер         = "НомерПартии";
		Реквизиты.Проведен      = "";
		Реквизиты.Дата          = "ДатаОформления";
		Реквизиты.Контрагент    = "";
		Реквизиты.Ответственный = "";
		// Дополнительно
		Реквизиты.Отгрузка           = "Отгрузка";
		Реквизиты.Реализация         = "Реализация";
		Реквизиты.Перевозка          = "Перевозка";
		Реквизиты.Приемка            = "Приемка";
		Реквизиты.ВидОперации        = "ВидОперации";
		Реквизиты.УполномоченноеЛицо = "УполномоченноеЛицо";
		Реквизиты.Грузополучатель    = "Грузополучатель";
		Реквизиты.Покупатель         = "Покупатель";
		Реквизиты.ПометкаУдаления    = "ПометкаУдаления";
		Реквизиты.Статус             = "Статус";
	ИначеЕсли МетаданныеОснования = Метаданные.Справочники.РезультатыИсследованийЗЕРНО Тогда
		Реквизиты.Номер         = "";
		Реквизиты.Проведен      = Ложь;
		Реквизиты.Дата          = "";
		Реквизиты.Контрагент    = "";
		Реквизиты.Ответственный = "";
	КонецЕсли;
	
	РасчетСтатусовОформленияЗЕРНОПереопределяемый.ПриОпределенииИменРеквизитовДляРасчетаСтатусаОформления(МетаданныеОснования, МетаданныеДокументаЗЕРНО, Реквизиты);
	
	Возврат Реквизиты;
	
КонецФункции

//Позволяет определить текст и параметры запроса выборки данных из документов-основания для расчета статуса оформления. 
//
//Параметры:
//   МетаданныеОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ЗЕРНО>.
//   МетаданныеДокументаЗЕРНО - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформления.
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо определить.
//   ПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру.
//
Процедура ПриОпределенииЗапросаТоварыДокументаОснования(МетаданныеОснования, МетаданныеДокументаЗЕРНО,
	ТекстЗапроса, ПараметрыЗапроса) Экспорт
	
	Если МетаданныеОснования = Метаданные.Справочники.СДИЗЗЕРНО Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	СДИЗ.Ссылка     КАК Ссылка,
		|	ИСТИНА          КАК ЭтоДвижениеПриход,
		|	НЕОПРЕДЕЛЕНО    КАК Номенклатура,
		|	НЕОПРЕДЕЛЕНО    КАК Характеристика,
		|	НЕОПРЕДЕЛЕНО    КАК Серия,
		|	СДИЗ.Количество КАК Количество
		|	
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Справочник.СДИЗЗЕРНО КАК СДИЗ
		|ГДЕ
		|	СДИЗ.Ссылка В (&МассивДокументов)
		|	И НЕ СДИЗ.ПометкаУдаления";
		
	ИначеЕсли МетаданныеОснования = Метаданные.Документы.ВнесениеСведенийОСобранномУрожаеЗЕРНО Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Товары.Ссылка         КАК Ссылка,
		|	ИСТИНА                КАК ЭтоДвижениеПриход,
		|	Товары.Номенклатура   КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Серия          КАК Серия,
		|	Товары.Количество     КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Документ.ВнесениеСведенийОСобранномУрожаеЗЕРНО.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка В (&МассивДокументов)";
		
	ИначеЕсли МетаданныеОснования = Метаданные.Документы.ФормированиеПартийЗЕРНО Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Товары.Ссылка         КАК Ссылка,
		|	ИСТИНА                КАК ЭтоДвижениеПриход,
		|	Товары.Номенклатура   КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Серия          КАК Серия,
		|	Товары.Количество     КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Документ.ФормированиеПартийЗЕРНО.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка В (&МассивДокументов)
		|	И Товары.Партия <> ЗНАЧЕНИЕ(Справочник.РеестрПартийЗЕРНО.ПустаяСсылка)
		|	И Товары.Ссылка.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗЕРНО.ФормированиеПартииИмпорт)";
		
	КонецЕсли;
	
	РасчетСтатусовОформленияЗЕРНОПереопределяемый.ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформления(
		МетаданныеОснования, МетаданныеДокументаЗЕРНО, ТекстЗапроса, ПараметрыЗапроса);
	
КонецПроцедуры

// Определяет текущий статус оформления документов ЗЕРНО.
//
//Параметры:
//   МассивДокументов        - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЗЕРНО - документы-основание для документа ЗЕРНО
//   МетаданныеДокументаЗЕРНО - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформления
//   МенеджерВТ              - МенеджерВременныхТаблиц - (см. СформироватьТаблицуТоварыДокументовОснования)
//
// Возвращаемое значение:
//   Соответствие Из КлючИЗначение:
//     Ключ     - элемент параметра МассивДокументов
//     Значение - Структура с полями:
//       СтатусОформления         - статус оформления объекта,
//       ДополнительнаяИнформация - информация для отладки.
//
Функция ОпределитьСтатусыОформленияДокументов(МассивДокументов, МетаданныеДокументаЗЕРНО, МенеджерВТ) Экспорт
	
	ДокументОснование = МассивДокументов[0];
	ТипОснования = ТипЗнч(ДокументОснование);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("ОтборСтрокОформленныеТовары", Истина);
	Запрос.УстановитьПараметр("ПустаяСерия", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("СерияНоменклатуры"));
	
	Если ТипОснования = Тип("СправочникСсылка.СДИЗЗЕРНО") Тогда
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаТовары.СДИЗ КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1.Товары КАК ТаблицаТовары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.%1 КАК ТаблицаДокументы
		|		ПО ТаблицаДокументы.Ссылка = ТаблицаТовары.Ссылка
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОбъектовСинхронизацииЗЕРНО КАК Статусы
		|		ПО Статусы.ОбъектСинхронизации = ТаблицаДокументы.Ссылка
		|ГДЕ
		|	ТаблицаТовары.СДИЗ В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	ИначеЕсли МетаданныеДокументаЗЕРНО = Метаданные.Документы.ФормированиеПартийПриПроизводствеЗЕРНО
			Или МетаданныеДокументаЗЕРНО = Метаданные.Документы.ФормированиеПартийИзДругихПартийЗЕРНО
			Или МетаданныеДокументаЗЕРНО = Метаданные.Документы.ЗапросОстатковПартийЗЕРНО Тогда
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1 КАК ТаблицаДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОбъектовСинхронизацииЗЕРНО КАК Статусы
		|		ПО Статусы.ОбъектСинхронизации = ТаблицаДокументы.Ссылка
		|		И Статусы.ИдентификаторСтроки = """"
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	Иначе
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1 КАК ТаблицаДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОбъектовСинхронизацииЗЕРНО КАК Статусы
		|		ПО Статусы.ОбъектСинхронизации = ТаблицаДокументы.Ссылка
		|		И Статусы.ИдентификаторСтроки = """"
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование,
		|	Статусы.ИдентификаторСтроки КАК ИдентификаторСтроки
		|ПОМЕСТИТЬ ОформленныеДокументыКроме%1
		|ИЗ
		|	Документ.%1 КАК ТаблицаДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОбъектовСинхронизацииЗЕРНО КАК Статусы
		|		ПО Статусы.ОбъектСинхронизации = ТаблицаДокументы.Ссылка
		|		И Статусы.ИдентификаторСтроки <> """"
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	КонецЕсли;
	
	Если МетаданныеДокументаЗЕРНО = Метаданные.Документы.ФормированиеПартийИзДругихПартийЗЕРНО
			Или МетаданныеДокументаЗЕРНО = Метаданные.Документы.ЗапросОстатковПартийЗЕРНО Тогда
		ШаблонЗапросаОформленныеТовары = "
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
		|		%3 КАК ЭтоДвижениеПриход,
		|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
		|		ОформленныеТовары.Характеристика КАК Характеристика,
		|		0                                КАК План,
		|		ОформленныеТовары.Количество     КАК Факт
		|	ИЗ
		|		Документ.%1.%2 КАК ОформленныеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
		|";
		
	ИначеЕсли МетаданныеДокументаЗЕРНО = Метаданные.Документы.ФормированиеПартийПриПроизводствеЗЕРНО Тогда
	
		ШаблонЗапросаОформленныеТовары = "
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
		|		%2 КАК ЭтоДвижениеПриход,
		|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
		|		ОформленныеТовары.Характеристика КАК Характеристика,
		|		0                                КАК План,
		|		ОформленныеТовары.Количество     КАК Факт
		|	ИЗ
		|		Документ.%1 КАК ОформленныеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
		|";
		
	Иначе
		ШаблонЗапросаОформленныеТовары = "
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
		|		%3 КАК ЭтоДвижениеПриход,
		|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
		|		ОформленныеТовары.Характеристика КАК Характеристика,
		|		0                                КАК План,
		|		ОформленныеТовары.Количество     КАК Факт
		|	ИЗ
		|		Документ.%1.%2 КАК ОформленныеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОформленныеДокументыКроме%1 КАК ОформленныеДокументыКроме
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументыКроме.Ссылка
		|			И ОформленныеТовары.Идентификатор = ОформленныеДокументыКроме.ИдентификаторСтроки
		|	ГДЕ
		|		ОформленныеДокументыКроме.ИдентификаторСтроки ЕСТЬ NULL
		|";
	КонецЕсли;
	
	ШаблонРазделительЗапросов = "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапросаВТОформленныеДокументы = "";
	ТекстЗапросаОформленныеТовары = "";
	
	ИмяДокументаЗЕРНО = МетаданныеДокументаЗЕРНО.Имя;
	
	ЭтоДвижениеПриход = "ЛОЖЬ";
	Если МетаданныеДокументаЗЕРНО = Метаданные.Документы.ВнесениеСведенийОСобранномУрожаеЗЕРНО
			ИЛИ МетаданныеДокументаЗЕРНО = Метаданные.Документы.ФормированиеПартийЗЕРНО
			ИЛИ МетаданныеДокументаЗЕРНО = Метаданные.Документы.ФормированиеПартийПриПроизводствеЗЕРНО Тогда
		ЭтоДвижениеПриход = "ИСТИНА";
	КонецЕсли;
	
	ТекстЗапросаВТОформленныеДокументы = СтрШаблон(ШаблонЗапросаВТОформленныеДокументы, ИмяДокументаЗЕРНО) + ШаблонРазделительЗапросов;
	
	// СДИЗ можно гасить неоднократно, до смены статуса
	Если ТипОснования = Тип("СправочникСсылка.СДИЗЗЕРНО") Тогда
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары;
		
	ИначеЕсли ИмяДокументаЗЕРНО = "ФормированиеПартийПриПроизводствеЗЕРНО" Тогда
		
		ТекстЗапросаОформленныеТовары = СтрШаблон(ШаблонЗапросаОформленныеТовары, ИмяДокументаЗЕРНО, ЭтоДвижениеПриход);
		
	Иначе
		
		ТекстЗапросаОформленныеТовары = СтрШаблон(ШаблонЗапросаОформленныеТовары, ИмяДокументаЗЕРНО, "Товары", ЭтоДвижениеПриход);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КонечныеСтатусы" + ИмяДокументаЗЕРНО, Документы[ИмяДокументаЗЕРНО].КонечныеСтатусы());
	
	ЧастиЗапроса = Новый Массив;
	ЧастиЗапроса.Добавить(ТекстЗапросаВТОформленныеДокументы);
	
	ЧастиЗапроса.Добавить(СтрШаблон("
		|ВЫБРАТЬ
		|	ТоварыКОформлению.ДокументОснование КАК ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура      КАК Номенклатура,
		|	ТоварыКОформлению.Характеристика    КАК Характеристика,
		|	СУММА(ТоварыКОформлению.План)       КАК План,
		|	СУММА(ТоварыКОформлению.Факт)       КАК Факт
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	(ВЫБРАТЬ
		|		Товары.Ссылка 			 КАК ДокументОснование,
		|		Товары.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|		Товары.Номенклатура      КАК Номенклатура,
		|		Товары.Характеристика    КАК Характеристика,
		|		Товары.Количество        КАК План,
		|		0                        КАК Факт
		|	ИЗ
		|		%1 КАК Товары
		|", РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента()));
	ЧастиЗапроса.Добавить(ТекстЗапросаОформленныеТовары);
	ЧастиЗапроса.Добавить("
		|	) КАК ТоварыКОформлению
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКОформлению.ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика
		|");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт > 0 И Т.План > 0 	   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт >= 0 И Т.План > Т.Факт ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьНеОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План <= Т.Факт 			   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьПолностьюОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План < Т.Факт 			   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОшибкиОформления
		|ПОМЕСТИТЬ РезультатПоДокументам
		|ИЗ
		|	Результат КАК Т
		|СГРУППИРОВАТЬ ПО
		|	Т.ДокументОснование");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА Т.ЕстьОшибкиОформления
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ЕстьОшибкиОформления)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И НЕ Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.Оформлено)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ОформленоЧастично)
		|		КОГДА Т.ЕстьОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ОформленоЧастично)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.НеОформлено)
		|	КОНЕЦ КАК СтатусОформления
		|ИЗ
		|	РезультатПоДокументам КАК Т");
	
	Запрос.Текст = СтрСоединить(ЧастиЗапроса);
	
	// Получим данные и определим статус оформления документа ЗЕРНО.
	
	СтатусОформления = Новый Структура(
		"СтатусОформления, ДополнительнаяИнформация",
		Перечисления.СтатусыОформленияДокументовГосИС.НеОформлено,
		Неопределено);
	
	Результат = ИнтеграцияИСКлиентСервер.МассивВСоответствие(МассивДокументов, СтатусОформления);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка   = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос.Текст = "ВЫБРАТЬ * ИЗ Результат КАК Т ГДЕ Т.ДокументОснование = &ДокументОснование";
	
	Пока Выборка.Следующий() Цикл
		
		Запрос.УстановитьПараметр("ДокументОснование", Выборка.ДокументОснование);
		
		// Сохраним данные, использовавшиеся для расчета статуса.
		УстановитьПривилегированныйРежим(Истина);
		ТаблицаДляРасчетаСтатуса = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);
	
		ТаблицаДляРасчетаСтатуса.Колонки.ЭтоДвижениеПриход.Заголовок = НСтр("ru='Приходное движение'");
		ТаблицаДляРасчетаСтатуса.Колонки.План.Заголовок              = НСтр("ru='По документу-основанию'");
		ТаблицаДляРасчетаСтатуса.Колонки.Факт.Заголовок              = НСтр("ru='По документу ЗЕРНО'");
		
		ДополнительнаяИнформация = Новый ХранилищеЗначения(ТаблицаДляРасчетаСтатуса, Новый СжатиеДанных(9));
		
		СтатусОформления = Новый Структура(
			"СтатусОформления, ДополнительнаяИнформация",
			Выборка.СтатусОформления,
			ДополнительнаяИнформация);
		
		Результат.Вставить(Выборка.ДокументОснование, СтатусОформления);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

//Служебная. Рассчитывает и записывает статусы оформления. Специфика ИС МП.
//
//Параметры:
//   ТаблицаРеквизитов - ТаблицаЗначений - собранные общим механизмом реквизиты для записи статуса
//
Процедура ЗаписатьДляОснований(ТаблицаРеквизитов) Экспорт

	// Запишем статус оформления документа ЗЕРНО.
	ДополнительныеПараметры = Новый Соответствие;
	
	РасчетСтатусовОформленияИС.ЗаписатьСтатусОформленияДокументов(
		ТаблицаРеквизитов,
		РегистрыСведений.СтатусыОформленияДокументовЗЕРНО,
		РасчетСтатусовОформленияЗЕРНО,
		ДополнительныеПараметры);

КонецПроцедуры

//Возвращает признак необходимости записи в регистр "Статусы оформления документов ИС МП"
//
//Параметры:
//   ДокументОснование  - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЗЕРНО - записываемый в регистр документ-основание.
//   Реквизиты - См. РеквизитыДляРасчета.
//   КоличествоСтрокДокументовОснования - Соответствие - количество строк основания требующих оформления.
//   ДополнительныеПараметры - Неопределено - не используется в подсистеме
//
//Возвращаемое значение:
//   Булево - признак необходимости записи
//
Функция ТребуетсяОформление(ДокументОснование, Реквизиты, КоличествоСтрокДокументовОснования, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(ДокументОснование) = Тип("СправочникСсылка.СДИЗЗЕРНО") Тогда
		
		Если Реквизиты.ПометкаУдаления
			ИЛИ (Реквизиты.Статус <> Перечисления.СтатусыСДИЗЗЕРНО.Оформлен
				И Реквизиты.Статус <> Перечисления.СтатусыСДИЗЗЕРНО.ОформленИПодтвержден)
			ИЛИ Не СоответствуетОрганизации(Реквизиты, ДополнительныеПараметры) Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
	Иначе
		
		Если НЕ Реквизиты.Проведен Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КоличествоСтрокДокументовОснования[ДокументОснование]);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Рассчитывает статусы СДИЗ, указанных в документе погашения СДИЗ.
//   Специфика ЗЕРНО.
//
//Параметры:
//   Источник - ДокументОбъект.ПогашениеСДИЗЗЕРНО, ДокументСсылка.ПогашениеСДИЗЗЕРНО, Массив из ДокументСсылка.ПогашениеСДИЗЗЕРНО - объект, содержащий данные о СДИЗ.
//
Процедура РассчитатьСтатусыОформленияСДИЗ(Источник)
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПогашениеСДИЗЗЕРНО") Тогда
		
		ТаблицаСДИЗ = Источник.Товары.Выгрузить(, "СДИЗ");
		ТаблицаСДИЗ.Свернуть("СДИЗ", "");
		
		ПустыеСДИЗ = ТаблицаСДИЗ.НайтиСтроки(
			Новый Структура("СДИЗ", Справочники.СДИЗЗЕРНО.ПустаяСсылка()));
		
		Для Каждого СтрокаТаблицы Из ПустыеСДИЗ Цикл
			ТаблицаСДИЗ.Удалить(СтрокаТаблицы);
		КонецЦикла;
		
	Иначе
		
		Если ТипЗнч(Источник) = Тип("Массив") И ЗначениеЗаполнено(Источник) Тогда
			ИсточникСсылка = Источник[0];
		Иначе
			ИсточникСсылка = Источник;
		КонецЕсли;
		
		Если ТипЗнч(ИсточникСсылка) <> Тип("ДокументСсылка.ПогашениеСДИЗЗЕРНО") Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(Источник) = Тип("Массив") Тогда
			МассивДокументов = Источник;
		Иначе
			МассивДокументов = Новый Массив;
			МассивДокументов.Добавить(Источник);
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.СДИЗ КАК СДИЗ
		|ИЗ
		|	Документ.ПогашениеСДИЗЗЕРНО.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка В (&МассивДокументов)
		|	И Товары.СДИЗ <> ЗНАЧЕНИЕ(Справочник.СДИЗЗЕРНО.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		
		УстановитьПривилегированныйРежим(Истина);
		ТаблицаСДИЗ = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	РасчетСтатусовОформленияИС.РассчитатьОбщая(
		ТаблицаСДИЗ.ВыгрузитьКолонку("СДИЗ"), Неопределено, РасчетСтатусовОформленияЗЕРНО);
	
КонецПроцедуры

// Подменяет объекты расчета статусов оформления партий ЗЕРНО по поступившим результатам исследований (внесение сведений о собранном
// урожае, связь через место формирования партии).
// Специфика ЗЕРНО.
// 
// Параметры:
//  Источник - СправочникОбъект.РезультатыИсследованийЗЕРНО, СправочникСсылка.РезультатыИсследованийЗЕРНО, Массив из СправочникСсылка.РезультатыИсследованийЗЕРНО -
// 
// Возвращаемое значение:
//  Булево - не требуется продолжать расчет
Функция РассчитатьСтатусыОформленияПоРезультатамИсследованияЗЕРНО(Источник)
	
	ИзмененныеРезультатыИсследований = Новый Массив;
	Если ТипЗнч(Источник) = Тип("СправочникОбъект.РезультатыИсследованийЗЕРНО") Тогда
		ИзмененныеРезультатыИсследований.Добавить(Источник.Ссылка);
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.РезультатыИсследованийЗЕРНО") Тогда
		ИзмененныеРезультатыИсследований.Добавить(Источник);
	ИначеЕсли ТипЗнч(Источник) = Тип("Массив")
			И Источник.Количество()
			И ТипЗнч(Источник[0]) = Тип("СправочникСсылка.РезультатыИсследованийЗЕРНО") Тогда
		ИзмененныеРезультатыИсследований = Источник;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РезультатыИсследованийЗЕРНО", ИзмененныеРезультатыИсследований);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РезультатыИсследованийЗЕРНО.МестоФормированияПартии КАК МестоФормированияПартии
	|ПОМЕСТИТЬ МестаФормированияПартий
	|ИЗ
	|	Справочник.РезультатыИсследованийЗЕРНО КАК РезультатыИсследованийЗЕРНО
	|ГДЕ
	|	РезультатыИсследованийЗЕРНО.Ссылка В (&РезультатыИсследованийЗЕРНО)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	МестоФормированияПартии
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ВнесениеСведенийОСобранномУрожаеЗЕРНО.Товары КАК ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МестаФормированияПартий КАК МестаФормированияПартий
	|		ПО МестаФормированияПартий.МестоФормированияПартии = ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.МестоФормированияПартии";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РасчетСтатусовОформленияИС.РассчитатьДляДокумента("ВестиУчетЗернаИПродуктовПереработкиЗЕРНО", Выборка.Ссылка, РасчетСтатусовОформленияЗЕРНО);
	КонецЦикла;
	
	Возврат Выборка.Количество() = 0;
	
КонецФункции

Функция СоответствуетОрганизации(Реквизиты, Кэш)
	
	Ключ = Реквизиты.УполномоченноеЛицо;
	Если (Реквизиты.Реализация Или Реквизиты.Перевозка)
		И Не Реквизиты.ВидОперации = Перечисления.ВидыОперацийЗЕРНО.ОформлениеСДИЗЭкспорт Тогда
		Если ЗначениеЗаполнено(Реквизиты.Грузополучатель) Тогда
			Ключ = Реквизиты.Грузополучатель;
		ИначеЕсли ЗначениеЗаполнено(Реквизиты.Покупатель) Тогда
			Ключ = Реквизиты.Покупатель;
		КонецЕсли;
	КонецЕсли;
	
	Значение = Кэш.Получить(Ключ);
	
	Если Значение = Неопределено Тогда
		
		Организация = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.ОрганизацииКонтрагентыПоКлючам(Ключ).Получить(Ключ);
		Если Организация <> Неопределено Тогда
			Организация = Организация.Организация;
		КонецЕсли;
		Значение = Новый Структура("Организация, СоответствуетОрганизации", Организация, ЗначениеЗаполнено(Организация));
		Кэш.Вставить(Ключ, Значение);
		
	КонецЕсли;
	
	Реквизиты.Контрагент = Значение.Организация;
	Возврат Значение.СоответствуетОрганизации;
	
КонецФункции

#КонецОбласти
