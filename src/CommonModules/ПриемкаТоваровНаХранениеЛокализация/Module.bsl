
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
	
	//++ Локализация
	УчетПрослеживаемыхТоваровЛокализация.ПроверитьЗаполнениеКоличестваПоРНПТ(Объект, Отказ, Неопределено);
	УчетПрослеживаемыхТоваровЛокализация.ПроверитьДанныеПрослеживаемостиНомеровГТД(Объект, Объект.Товары, Объект.Дата);
	//-- Локализация
	
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
	
	// МХ-1 
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
	КомандаПечати.Идентификатор = "МХ1";
	КомандаПечати.Представление = НСтр("ru='Акт о приеме-передаче ТМЦ на хранение (МХ-1)'");
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
	//++ Локализация
	//-- Локализация
КонецПроцедуры

//++ Локализация

// Возвращает данные для формирования печатной формы МХ - 1.
//
// Параметры:
//	ПараметрыПечати	- Структура -дополнительные настройки печати.
//	МассивОбъектов	- Массив из ДокументСсылка.ПриемкаТоваровНаХранение - коллекция значений ссылок на документы,
//																			по которым необходимо получить данные.
//
// Возвращаемое значение:
//	Структура - коллекция данных, используемых для печати, содержащая следующие следующие свойства:
//		* РезультатПоШапке			- РезультатЗапроса - данные шапки документа.
//		* РезультатПоСкладам		- РезультатЗапроса - данные о складе ответственного хранения.
//		* РезультатПоТабличнойЧасти	- РезультатЗапроса - данные табличной части документа.
//		* РезультатПоОшибкам		- Неорпеделено - данные об ошибках, возникающих при печати документа.
//
Функция ПолучитьДанныеДляПечатнойФормыМХ1(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокументПриемка.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(ДокументПриемка.ИсправляемыйДокумент.Номер, ДокументПриемка.Номер) КАК Номер,
	|	ЕСТЬNULL(ДокументПриемка.ИсправляемыйДокумент.Дата, ДокументПриемка.Дата) КАК Дата,
	|	ЕСТЬNULL(ДокументПриемка.ИсправляемыйДокумент.Дата, ДокументПриемка.Дата) КАК ДатаДокумента,
	|	ДокументПриемка.Дата КАК ДатаПолученияСебестоимости,
	|	ДокументПриемка.Организация КАК Организация,
	|	ДокументПриемка.Контрагент КАК Контрагент,
	|	ДокументПриемка.Сдал КАК Сдал,
	|	ДокументПриемка.СдалДолжность КАК СдалДолжность,
	|	ДокументПриемка.Принял КАК Принял,
	|	ДокументПриемка.ПринялДолжность КАК ПринялДолжность,
	|	ДокументПриемка.Договор.Дата КАК ДоговорДата,
	|	ДокументПриемка.Договор.Номер КАК ДоговорНомер,
	|	ВЫБОР
	|		КОГДА Организации.ВалютаРегламентированногоУчета = ДокументПриемка.Валюта
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ ДокументВВалютеРеглУчета
	|ПОМЕСТИТЬ ВтШапка
	|ИЗ
	|	Документ.ПриемкаТоваровНаХранение КАК ДокументПриемка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Организации.Ссылка = ДокументПриемка.Организация
	|ГДЕ
	|	ДокументПриемка.Ссылка В(&МассивДокументов)
	|	И ДокументПриемка.Проведен
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	ВтШапка.Ссылка КАК Ссылка,
	|	ВтШапка.Номер КАК Номер,
	|	ВтШапка.Дата КАК Дата,
	|	ВтШапка.Дата КАК ДатаДокумента,
	|	ВтШапка.Организация КАК Организация,
	|	ВтШапка.Контрагент КАК Поклажедатель,
	|	ВтШапка.Сдал КАК Сдал,
	|	ВтШапка.СдалДолжность КАК СдалДолжность,
	|	ВтШапка.Принял КАК МОЛ,
	|	ВтШапка.ПринялДолжность КАК ДолжностьМОЛ,
	|	ВтШапка.ДоговорДата,
	|	ВтШапка.ДоговорНомер
	|ИЗ
	|	ВтШапка КАК ВтШапка
	|;
	|//////////////////////////////////////////////////////////////////////////////// 2
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПриемкаТовары.Ссылка КАК Ссылка,
	|	ПриемкаТовары.Склад КАК Склад,
	|	ЛОЖЬ КАК ПредварительныйРасчет,
	|	НЕОПРЕДЕЛЕНО КАК ИсточникИнформацииОЦенахДляПечати,
	|	ПРЕДСТАВЛЕНИЕ(ПриемкаТовары.Склад) КАК ПредставлениеСклада,
	|	ПРЕДСТАВЛЕНИЕ(Склады.Подразделение) КАК ПредставлениеПодразделения,
	|	ВтШапка.Организация КАК Поклажедержатель,
	|	"""" КАК ОсобыеОтметки,
	|	"""" КАК УсловияХранения,
	|	ВтШапка.Сдал КАК Сдал,
	|	ВтШапка.СдалДолжность КАК СдалДолжность,
	|	ВтШапка.Принял КАК МОЛ,
	|	ВтШапка.ПринялДолжность КАК ДолжностьМОЛ
	|ИЗ
	|	Документ.ПриемкаТоваровНаХранение.Товары КАК ПриемкаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК ВтШапка
	|		ПО ВтШапка.Ссылка = ПриемкаТовары.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО ПриемкаТовары.Склад = Склады.Ссылка
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 3
	|ВЫБРАТЬ
	|	ПриемкаТовары.Ссылка КАК Ссылка,
	|	ПриемкаТовары.Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА &КолонкаКодов = ""Артикул""
	|			ТОГДА ПриемкаТовары.Номенклатура.Артикул
	|		ИНАЧЕ ПриемкаТовары.Номенклатура.Код
	|	КОНЕЦ КАК НоменклатураКод,
	|	ПриемкаТовары.Номенклатура КАК Номенклатура,
	|	ПриемкаТовары.Номенклатура.НаименованиеПолное КАК ПредставлениеНоменклатуры,
	|	ПриемкаТовары.Характеристика.НаименованиеПолное КАК ПредставлениеХарактеристики,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения КАК ЕдиницаИзмеренияКод,
	|	ПриемкаТовары.КоличествоУпаковок КАК Количество,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ВидУпаковки,
	|
	|	ВЫБОР
	|		КОГДА ВтШапка.ДокументВВалютеРеглУчета
	|			ТОГДА ПриемкаТовары.Сумма
	|		ИНАЧЕ ЕСТЬNULL(СуммыДокументовВВалютахУчета.СуммаБезНДСРегл, 0)
	|	КОНЕЦ Сумма,
	|	
	|	ВЫБОР
	|		КОГДА ВтШапка.ДокументВВалютеРеглУчета
	|			ТОГДА ПриемкаТовары.Цена
	|		КОГДА ЕСТЬNULL(СуммыДокументовВВалютахУчета.СуммаБезНДСРегл, 0) > 0
	|			ТОГДА СуммыДокументовВВалютахУчета.СуммаБезНДСРегл/ПриемкаТовары.КоличествоУпаковок
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Цена
	|ИЗ
	|	Документ.ПриемкаТоваровНаХранение.Товары КАК ПриемкаТовары
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК ВтШапка
	|		ПО ПриемкаТовары.Ссылка = ВтШапка.Ссылка
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
	|		ПО ПриемкаТовары.Ссылка              = СуммыДокументовВВалютахУчета.Регистратор
	|		 И ПриемкаТовары.ИдентификаторСтроки = СуммыДокументовВВалютахУчета.ИдентификаторСтроки
	|		 И СуммыДокументовВВалютахУчета.Активность
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|ИТОГИ ПО
	|	Ссылка,
	|	Склад
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "ПриемкаТовары.Упаковка", "ПриемкаТовары.Номенклатура"));
			
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "ПриемкаТовары.Упаковка", "ПриемкаТовары.Номенклатура"));
			

	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке",          МассивРезультатов[1]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоСкладам",        МассивРезультатов[2]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", МассивРезультатов[3]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоОшибкам",        Неопределено);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции


//-- Локализация
#КонецОбласти


// Заполняет массив допустимых наименований входящих документов.
//
// Параметры:
//  МассивНаименований	 - Массив - массив наименования входящих документов.
//
Процедура ДополнитьНаименованияВходящихДокументов(МассивНаименований) Экспорт
	
КонецПроцедуры

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


	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

//++ Локализация


//-- Локализация

#КонецОбласти
