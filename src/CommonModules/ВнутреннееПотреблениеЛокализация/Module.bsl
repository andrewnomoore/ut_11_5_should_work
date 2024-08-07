
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


	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

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
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияПродукцииВЕТИС") Тогда	
		ИнтеграцияВЕТИСУТ.ЗаполнитьВнутреннееПотреблениеНаОснованииИнвентаризацииПродукцииВЕТИС(
			Объект,
			ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВыводИзОборотаИСМП") Тогда	
		ИнтеграцияИСМПУТ.ЗаполнитьВнутреннееПотреблениеНаОснованииВыводаИзОборотаИСМП(
			Объект,
			ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СписаниеПартийЗЕРНО") Тогда
		ИнтеграцияЗЕРНОУТ.ЗаполнитьВнутреннееПотреблениеНаОснованииСписанияПартийЗЕРНО(
			Объект,	
			ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктПримененияСАТУРН") Тогда
		ИнтеграцияСАТУРНУТ.ЗаполнитьВнутреннееПотреблениеНаОснованииАктПримененияСАТУРН(
			Объект,
			ДанныеЗаполнения);
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
	
	//++ Локализация
		
	// ИнтеграцияГИСМ
	ЗаполнитьЗначенияСвойств(Объект, ИнтеграцияГИСМ_УТ.ЗаполнитьПризнакиЕстьМаркируемаяПродукцияИЕстьКиЗ(Объект, "Серии"));
	// Конец ИнтеграцияГИСМ
	
	//-- Локализация
	
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
//  ОбъектКопирования - ДокументОбъект.ВнутреннееПотребление - Исходный документ, который является источником копирования.
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
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-3 
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ3";
		КомандаПечати.Представление = НСтр("ru = 'Акт о возврате ТМЦ, сданных на хранение (МХ-3)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	
	
	// Требование-накладная (М-11)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьМ11";
	КомандаПечати.Идентификатор = "М11";
	КомандаПечати.Представление = НСтр("ru = 'Требование-накладная (М-11)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
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


КонецПроцедуры

//++ Локализация

// Возвращает данные для формирования печатной формы МХ - 3.
//
// Параметры:
//	ПараметрыПечати	- Структура -дополнительные настройки печати.
//	МассивОбъектов	- Массив из ДокументСсылка.ВнутреннееПотребление - коллекция значений ссылок на документы,
//																		по которым необходимо получить данные.
//
// Возвращаемое значение:
//	Структура - коллекция данных, используемых для печати, содержащая следующие следующие свойства:
//		* РезультатПоШапке			- РезультатЗапроса - данные шапки документа.
//		* РезультатПоСкладам		- РезультатЗапроса - данные о складе ответственного хранения.
//		* РезультатПоТабличнойЧасти	- РезультатЗапроса - данные табличной части документа.
//		* РезультатПоОшибкам		- РезультатЗапроса - данные об ошибках, возникающих при печати документа.
//
Функция ПолучитьДанныеДляПечатнойФормыМХ3(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка									КАК Ссылка,
	|	ЕСТЬNULL(ДанныеДокумента.ИсправляемыйДокумент.Номер, ДанныеДокумента.Номер)	КАК Номер,
	|	ЕСТЬNULL(ДанныеДокумента.ИсправляемыйДокумент.Дата, ДанныеДокумента.Дата)	КАК Дата,
	|	ЕСТЬNULL(ДанныеДокумента.ИсправляемыйДокумент.Дата, ДанныеДокумента.Дата)	КАК ДатаДокумента,
	|	ДанныеДокумента.Организация								КАК Организация,
	|	ДанныеДокумента.Склад									КАК Склад,
	|	ЕСТЬNULL(Склады.СкладОтветственногоХранения, ЛОЖЬ)		КАК СкладОтветственногоХранения,
	|	ДанныеДокумента.Организация = Склады.Поклажедержатель	КАК ОрганизацияПоклажедержатель,
	|	Склады.ИсточникИнформацииОЦенахДляПечати				КАК ИсточникИнформацииОЦенахДляПечати,
	|	Склады.УчетныйВидЦены									КАК ВидЦены,
	|	Склады.УчетныйВидЦены.ВалютаЦены						КАК ВалютаЦены,
	|	РасчетСебестоимостиТоваровОрганизации.Ссылка.ПредварительныйРасчет	КАК ПредварительныйРасчет,
	|	ДанныеДокумента.Дата									КАК ДатаПолученияСебестоимости
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	Документ.ВнутреннееПотребление КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	|		ПО РасчетСебестоимостиТоваровОрганизации.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ)
	|			И РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен
	|			И ДанныеДокумента.Организация = РасчетСебестоимостиТоваровОрганизации.Организация
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО ДанныеДокумента.Склад = Склады.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ДанныеДокумента.Ссылка В(&МассивДокументов)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка								КАК Ссылка,
	|	ДанныеДокумента.Номер								КАК Номер,
	|	ДанныеДокумента.Дата								КАК Дата,
	|	ДанныеДокумента.ДатаДокумента						КАК ДатаДокумента,
	|	ДанныеДокумента.Организация							КАК Организация,
	|	ДанныеДокумента.Склад								КАК Склад,
	|	ДанныеДокумента.ИсточникИнформацииОЦенахДляПечати	КАК ИсточникИнформацииОЦенахДляПечати,
	|	ДанныеДокумента.ВидЦены								КАК ВидЦены,
	|	ДанныеДокумента.ВалютаЦены							КАК ВалютаЦены,
	|	ДанныеДокумента.ПредварительныйРасчет				КАК ПредварительныйРасчет,
	|	ДанныеДокумента.ДатаПолученияСебестоимости			КАК ДатаПолученияСебестоимости
	|ПОМЕСТИТЬ ВтШапка
	|ИЗ
	|	ДанныеДокумента КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.СкладОтветственногоХранения
	|	И НЕ ДанныеДокумента.ОрганизацияПоклажедержатель
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 2
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Шапка.Склад КАК Склад,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Серия КАК Серия,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения КАК ЕдиницаИзмеренияКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ВидУпаковки,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	Шапка.ВидЦены КАК ВидЦены,
	|	Шапка.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	Документ.ВнутреннееПотребление.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО Товары.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	Товары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен)
	|		ИЛИ (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|			И Шапка.ПредварительныйРасчет ЕСТЬ NULL))
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 3
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК Ссылка,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	Шапка.Организация КАК Организация,
	|	АналитикаУчетаНоменклатуры.СкладскаяТерритория КАК Склад,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление ВидУпаковки,
	|	ВидыЗапасов.Количество КАК КоличествоУпаковок,
	|	ВидыЗапасов.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(ВидыЗапасов.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены КАК ВидЦены,
	|	АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	|	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	Документ.ВнутреннееПотребление.ВидыЗапасов КАК ВидыЗапасов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО ВидыЗапасов.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И АналитикаУчетаНоменклатуры.СкладскаяТерритория.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|;
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "Товары.Упаковка", "Товары.Номенклатура"));
	
	СкладыСервер.ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос);
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатПоШапке			= МассивРезультатов[МассивРезультатов.ВГраница() - 3];
	РезультатПоСкладам			= МассивРезультатов[МассивРезультатов.ВГраница() - 2];
	РезультатПоТабличнойЧасти	= МассивРезультатов[МассивРезультатов.ВГраница() - 1];
	РезультатПоОшибкам			= МассивРезультатов[МассивРезультатов.ВГраница()];
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке",			РезультатПоШапке);
	СтруктураДанныхДляПечати.Вставить("РезультатПоСкладам",			РезультатПоСкладам);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти",	РезультатПоТабличнойЧасти);
	СтруктураДанныхДляПечати.Вставить("РезультатПоОшибкам",			РезультатПоОшибкам);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

// Функция получает данные для формирования печатной формы М-11
//
// Параметры:
//	ПараметрыПечати	- Структура -дополнительные настройки печати.
//	МассивОбъектов	- Массив из ДокументСсылка.ВнутреннееПотребление - коллекция значений ссылок на документы,
//																		по которым необходимо получить данные.
//
// Возвращаемое значение:
//	Структура - коллекция данных, используемых для печати, содержащая следующие следующие свойства:
//		* РезультатПоШапке			- РезультатЗапроса - данные шапки документа.
//		* РезультатПоТабличнойЧасти	- РезультатЗапроса - данные табличной части документа.
Функция ПолучитьДанныеДляПечатнойФормыМ11(ПараметрыПечати, МассивДокументов) Экспорт
	
	Запрос = ПолучитьЗапросПолученияДанныхДляПечатнойФормыМ11();
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"Товары.Упаковка",
			"Товары.Номенклатура"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"Цены.Упаковка",
			"Товары.Номенклатура"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование",
			"Товары.Упаковка",
			"Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код",
			"Товары.Упаковка",
			"Товары.Номенклатура"));
		
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	РезультатПакетаЗапросов = Запрос.ВыполнитьПакет();
	
	Возврат Новый Структура(
		"РезультатПоШапке, РезультатПоТабличнойЧасти",
		РезультатПакетаЗапросов[РезультатПакетаЗапросов.ВГраница() - 1],
		РезультатПакетаЗапросов[РезультатПакетаЗапросов.ВГраница()]);
	
КонецФункции

Функция ПолучитьЗапросПолученияДанныхДляПечатнойФормыМ11()

	ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	Если ИспользуетсяЦенообразование25 Тогда
		ДатаПереходаНаЦенообразование25 = ЦенообразованиеВызовСервера.ДатаПереходаНаЦенообразованиеВерсии25();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаПереходаНаЦенообразование25", ДатаПереходаНаЦенообразование25);
	Запрос.УстановитьПараметр("ИспользуетсяЦенообразование25", ИспользуетсяЦенообразование25);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Упаковка КАК Упаковка,
	|	ЕСТЬNULL(ВЫБОР
	|		КОГДА
	|			ВидыНоменклатуры.НастройкиКлючаЦенПоХарактеристике = ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатурыДляЦенообразования.ПустаяСсылка)
	|		ИНАЧЕ Товары.Характеристика.ХарактеристикаНоменклатурыДляЦенообразования
	|	КОНЕЦ, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатурыДляЦенообразования.ПустаяСсылка)) КАК ХарактеристикаЦО,
	|	ЕСТЬNULL(ВЫБОР
	|		КОГДА ВидыНоменклатуры.НастройкиКлючаЦенПоСерии = ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СерииНоменклатурыДляЦенообразования.ПустаяСсылка)
	|		ИНАЧЕ Товары.Серия.СерияНоменклатурыДляЦенообразования
	|	КОНЕЦ, ЗНАЧЕНИЕ(Справочник.СерииНоменклатурыДляЦенообразования.ПустаяСсылка)) КАК СерияЦО,
	|	ВЫБОР
	|		КОГДА ВидыНоменклатуры.НастройкиКлючаЦенПоУпаковке = ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|		ИНАЧЕ Товары.Упаковка
	|	КОНЕЦ КАК УпаковкаЦО,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	Товары.Ссылка.ВидЦены КАК ВидЦены,
	|	Товары.Ссылка.ВидЦены.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.ВнутреннееПотребление.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ПО (ВидыНоменклатуры.Ссылка = Товары.Номенклатура.ВидНоменклатуры)
	|		И &ИспользуетсяЦенообразование25
	|ГДЕ
	|	Товары.Ссылка В (&МассивДокументов)
	|	И НЕ Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	ЦеныНоменклатуры.ВидЦены КАК ВидЦены,
	|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатуры.Характеристика КАК Характеристика,
	|	NULL ХарактеристикаЦО,
	|	NULL СерияЦО,
	|	NULL УпаковкаЦО,
	|	МАКСИМУМ(ЦеныНоменклатуры.Период) КАК Период
	|ПОМЕСТИТЬ ПериодыЦенНоменклатуры
	|ИЗ
	|	Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ПО Товары.ВидЦены = ЦеныНоменклатуры.ВидЦены
	|		И Товары.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|		И Товары.Характеристика = ЦеныНоменклатуры.Характеристика
	|		И Товары.ДатаПолученияЦены >= ЦеныНоменклатуры.Период
	|		И Товары.ВалютаЦены = ЦеныНоменклатуры.Валюта
	|СГРУППИРОВАТЬ ПО
	|	Товары.Ссылка,
	|	Товары.НомерСтроки,
	|	ЦеныНоменклатуры.ВидЦены,
	|	ЦеныНоменклатуры.Номенклатура,
	|	ЦеныНоменклатуры.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	ЦеныНоменклатуры.ВидЦены КАК ВидЦены,
	|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	NULL,
	|	ЦеныНоменклатуры.ХарактеристикаЦО КАК ХарактеристикаЦО,
	|	ЦеныНоменклатуры.СерияЦО КАК СерияЦО,
	|	ЦеныНоменклатуры.УпаковкаЦО КАК УпаковкаЦО,
	|	МАКСИМУМ(ЦеныНоменклатуры.Период) КАК Период
	|ПОМЕСТИТЬ ПериодыЦенНоменклатуры25
	|ИЗ
	|	Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры25 КАК ЦеныНоменклатуры
	|		ПО Товары.ВидЦены = ЦеныНоменклатуры.ВидЦены
	|		И Товары.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|		И Товары.ХарактеристикаЦО = ЦеныНоменклатуры.ХарактеристикаЦО
	|		И Товары.СерияЦО = ЦеныНоменклатуры.СерияЦО
	|		И Товары.УпаковкаЦО = ЦеныНоменклатуры.УпаковкаЦО
	|		И Товары.ДатаПолученияЦены >= ЦеныНоменклатуры.Период
	|		И Товары.ВалютаЦены = ЦеныНоменклатуры.Валюта
	|ГДЕ
	|	Товары.ДатаПолученияЦены >= &ДатаПереходаНаЦенообразование25
	|СГРУППИРОВАТЬ ПО
	|	Товары.Ссылка,
	|	Товары.НомерСтроки,
	|	ЦеныНоменклатуры.ВидЦены,
	|	ЦеныНоменклатуры.Номенклатура,
	|	ЦеныНоменклатуры.ХарактеристикаЦО,
	|	ЦеныНоменклатуры.СерияЦО,
	|	ЦеныНоменклатуры.УпаковкаЦО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документы.Ссылка КАК Ссылка,
	|	Документы.Организация.ВалютаРегламентированногоУчета КАК БазоваяВалюта,
	|	МАКСИМУМ(КурсыВалют.Период) КАК Период,
	|	КурсыВалют.Валюта КАК Валюта
	|ПОМЕСТИТЬ ПериодыКурсовВалютПоДокументам
	|ИЗ
	|	Документ.ВнутреннееПотребление КАК Документы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалют
	|		ПО Документы.ВидЦены.ВалютаЦены = КурсыВалют.Валюта
	|		И Документы.Организация.ВалютаРегламентированногоУчета = КурсыВалют.БазоваяВалюта
	|		И Документы.Дата >= КурсыВалют.Период
	|ГДЕ
	|	Документы.Ссылка В (&МассивДокументов)
	|СГРУППИРОВАТЬ ПО
	|	Документы.Ссылка,
	|	Документы.Организация.ВалютаРегламентированногоУчета,
	|	КурсыВалют.Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыЦенНоменклатуры.Ссылка,
	|	ПериодыЦенНоменклатуры.НомерСтроки,
	|	ЦеныНоменклатуры.Цена,
	|	ЦеныНоменклатуры.Упаковка
	|ПОМЕСТИТЬ Цены
	|ИЗ
	|	ПериодыЦенНоменклатуры КАК ПериодыЦенНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ПО ПериодыЦенНоменклатуры.Период = ЦеныНоменклатуры.Период
	|		И ПериодыЦенНоменклатуры.ВидЦены = ЦеныНоменклатуры.ВидЦены
	|		И ПериодыЦенНоменклатуры.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|		И ПериодыЦенНоменклатуры.Характеристика = ЦеныНоменклатуры.Характеристика
	|		И НЕ &ИспользуетсяЦенообразование25
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПериодыЦенНоменклатуры.Ссылка,
	|	ПериодыЦенНоменклатуры.НомерСтроки,
	|	ЦеныНоменклатуры.Цена,
	|	ЦеныНоменклатуры.Упаковка
	|ИЗ
	|	ПериодыЦенНоменклатуры25 КАК ПериодыЦенНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры25 КАК ЦеныНоменклатуры
	|		ПО ПериодыЦенНоменклатуры.Период = ЦеныНоменклатуры.Период
	|		И ПериодыЦенНоменклатуры.ВидЦены = ЦеныНоменклатуры.ВидЦены
	|		И ПериодыЦенНоменклатуры.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|		И ПериодыЦенНоменклатуры.ХарактеристикаЦО = ЦеныНоменклатуры.ХарактеристикаЦО
	|		И ПериодыЦенНоменклатуры.СерияЦО = ЦеныНоменклатуры.СерияЦО
	|		И ПериодыЦенНоменклатуры.УпаковкаЦО = ЦеныНоменклатуры.УпаковкаЦО
	|		И &ИспользуетсяЦенообразование25
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыКурсовВалютПоДокументам.Ссылка,
	|	КурсыВалют.Валюта,
	|	КурсыВалют.КурсЧислитель,
	|	КурсыВалют.КурсЗнаменатель
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	ПериодыКурсовВалютПоДокументам КАК ПериодыКурсовВалютПоДокументам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалют
	|		ПО ПериодыКурсовВалютПоДокументам.Период = КурсыВалют.Период
	|		И ПериодыКурсовВалютПоДокументам.Валюта = КурсыВалют.Валюта
	|		И ПериодыКурсовВалютПоДокументам.БазоваяВалюта = КурсыВалют.БазоваяВалюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документы.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(Документы.ИсправляемыйДокумент.Номер, Документы.Номер) КАК Номер,
	|	ЕСТЬNULL(Документы.ИсправляемыйДокумент.Дата, Документы.Дата) КАК ДатаСоставления,
	|	ЕСТЬNULL(Документы.ИсправляемыйДокумент.Дата, Документы.Дата) КАК ДатаДокумента,
	|	Документы.Организация КАК Организация,
	|	Документы.Организация.Префикс КАК Префикс,
	|	Документы.Подразделение КАК Подразделение,
	|	Документы.ВидЦены КАК УчетныйВидЦены,
	|	Документы.ВидЦены.ВалютаЦены КАК УчетныйВидЦеныВалютаЦены
	|ИЗ
	|	Документ.ВнутреннееПотребление КАК Документы
	|ГДЕ
	|	Документы.Ссылка В (&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДокумента,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Ссылка.Склад КАК Склад,
	|	ВЫРАЗИТЬ(Товары.Ссылка.Склад КАК Справочник.Склады).ТекущийОтветственный КАК КладовщикОтправитель,
	|	ВЫРАЗИТЬ(Товары.Ссылка.Склад КАК Справочник.Склады).ТекущаяДолжностьОтветственного КАК
	|		ДолжностьКладовщикаОтправителя,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.НаименованиеПолное КАК НоменклатураНаименование,
	|	Товары.Номенклатура.Код КАК НоменклатурныйНомерКод,
	|	Товары.Номенклатура.Артикул КАК НоменклатурныйНомерАртикул,
	|	Товары.Характеристика.НаименованиеПолное КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) = 1
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ Товары.Упаковка.Наименование
	|	КОНЕЦ КАК Упаковка,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения КАК ЕдиницаИзмеренияКод,
	|	Товары.КоличествоУпаковок КАК Количество,
	|	(ВЫРАЗИТЬ(ЕСТЬNULL(Цены.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) *
	|		ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(КурсыВалют.КурсЧислитель, 1) /
	|		ЕСТЬNULL(КурсыВалют.КурсЗнаменатель, 1) КАК ЧИСЛО(31, 2))) * Товары.КоличествоУпаковок КАК Сумма,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Цены.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) *
	|		ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(КурсыВалют.КурсЧислитель, 1) /
	|		ЕСТЬNULL(КурсыВалют.КурсЗнаменатель, 1) КАК ЧИСЛО(31, 2)) КАК Цена,
	|	Товары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|		ПО Товары.Ссылка = КурсыВалют.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Цены КАК Цены
	|		ПО Товары.Ссылка = Цены.Ссылка
	|		И Товары.НомерСтроки = Цены.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ
	|	МАКСИМУМ(ДолжностьКладовщикаОтправителя),
	|	МАКСИМУМ(КладовщикОтправитель)
	|ПО
	|	Ссылка,
	|	Склад";
	
	Возврат Запрос;
	
КонецФункции

//-- Локализация
#КонецОбласти

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

	
	//-- Локализация
	
КонецПроцедуры

//++ Локализация


//-- Локализация

Процедура ДополнитьЗначенияПараметровПроведения(ЗначенияПараметровПроведения, Реквизиты) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

#КонецОбласти


#Область ФормаДокумента

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форме документа:
//		* Элементы - ВсеЭлементыФормы - 
//		* Объект - ДокументОбъект.ВнутреннееПотребление - 
//	Отказ - Булево - 
//	СтандартнаяОбработка - Булево - 
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	
КонецПроцедуры

#КонецОбласти

#Область Прочее

 
#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

#Область Печать


#КонецОбласти

#Область Проведение


#КонецОбласти


//-- Локализация

#КонецОбласти
