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

#Область Фискализация

//++ Локализация

// Определяет систему налогообложения по документу
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ для определения системы налогообложения
// Возвращаемое значение:
// 	ПеречислениеСсылка.ТипыСистемНалогообложенияККТ - Система налогообложения по документу
Функция СистемаНалогообложенияПоДокументу(ДокументСсылка) Экспорт
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Организация, КассаККМ");
	РеквизитыКассыККМ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДокумента.КассаККМ, "Склад, Подразделение");
	
	НалогообложениеНДС = УчетНДСУП.ПараметрыУчетаПоОрганизации(РеквизитыДокумента.Организация, ТекущаяДатаСеанса(), РеквизитыКассыККМ.Склад, РеквизитыКассыККМ.Подразделение).НалогообложениеНДСРозничнойПродажи;
	
	Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД Тогда
		СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ЕНВД;
	ИначеЕсли НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаПоПатенту Тогда
		СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.Патент;
	Иначе
		СистемаНалогообложения = РозничныеПродажиЛокализация.СистемаНалогообложенияФискальнойОперации(РеквизитыДокумента.Организация);
	КонецЕсли;
	
	Возврат СистемаНалогообложения;
	
КонецФункции

// Получить основные данные по таблице товаров для чека о розничной продаже
//
// Параметры:
//  ДокументСсылка - ДокументОбъект.РеализацияПодарочныхСертификатов - Документ.
// 
// Возвращаемое значение:
//  Массив - Данные о продажах.
//
Функция ПредметыРасчетовПоДокументу(ДокументСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "НалогообложениеНДС");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.НомерСтроки,
	|	ПодарочныеСертификаты.ПодарочныйСертификат.Наименование КАК Номенклатура,
	|	""""                                             		КАК Характеристика,
	|	""""                                             		КАК Упаковка,
	|
	|	1 														КАК Количество,
	|	1 														КАК КоличествоУпаковок,
	|
	|	ПодарочныеСертификаты.Сумма 							КАК Цена,
	|	ПодарочныеСертификаты.Сумма								КАК СуммаСНДС,
	|
	|	ВЫБОР
	|		КОГДА &НалогообложениеНДС В (ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаПоПатенту))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
	|		ИНАЧЕ &СтавкаНДС20_120
	|	КОНЕЦ 													КАК СтавкаНДС,
	|
	|	ВЫБОР
	|		КОГДА &НалогообложениеНДС В (ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаПоПатенту))
	|			ТОГДА 0
	|		ИНАЧЕ ВЫРАЗИТЬ(ПодарочныеСертификаты.Сумма / 120 * 20 КАК ЧИСЛО(31,2))
	|	КОНЕЦ 													КАК СуммаНДС,
	|	
	|	0														КАК СуммаСкидки
	|	
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.Номенклатура,
	|
	|	НЕОПРЕДЕЛЕНО					КАК ТипНоменклатуры,
	|	ЛОЖЬ							КАК ПодакцизныйТовар,
	|	
	|	Товары.Номенклатура   			КАК НоменклатураНаименование,
	|	Товары.Характеристика 			КАК ХарактеристикаНаименование,
	|	Товары.Упаковка					КАК УпаковкаНаименование,
	|	
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок,
	|	Товары.Цена,
	|	Товары.СуммаСНДС,
	|	Товары.СтавкаНДС,
	|	Товары.СуммаНДС,
	|	Товары.СуммаСкидки
	|ИЗ
	|	ТаблицаТовары КАК Товары
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|";
		
	Запрос.УстановитьПараметр("Ссылка"			  , ДокументСсылка);
	Запрос.УстановитьПараметр("НалогообложениеНДС", РеквизитыДокумента.НалогообложениеНДС);
	Запрос.УстановитьПараметр("СтавкаНДС20_120"	  , УчетНДСРФКлиентСерверПовтИсп.СтавкаНДСПоЗначениюПеречисления(Перечисления.СтавкиНДС.НДС20_120));
	
	ПредметыРасчетов = Запрос.Выполнить().Выгрузить();
	
	Возврат ПредметыРасчетов;
	
КонецФункции

//-- Локализация

// Определяет и возвращает статус, является ли организации плательщиком НДС
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, по которой определяется, облагается ли она НДС
// 	ОрганизацияПлательщикНДС - Булево - Параметр для сохранения и передачи во вне значения
Процедура ОбновитьОрганизацияПлательщикНДС(Организация, ОрганизацияПлательщикНДС) Экспорт
	
	//++ Локализация
	ОрганизацияПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, ТекущаяДатаСеанса())
		И НЕ УчетнаяПолитика.ПрименяетсяОсвобождениеОтУплатыНДС(Организация, ТекущаяДатаСеанса());
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти