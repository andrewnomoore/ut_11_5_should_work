#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	// Описание не требуется. Список учетных механизмов получается из менеджера сторнируемого документа.
	Возврат;
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.Сторно") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	КонецЕсли;
	
	ДобавитьТекстыЗапросовТаблицСторноДвижений(Запрос, ТекстыЗапроса, Регистры);
	ДобавитьТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	ДобавитьТекстЗапросаТаблицаИсправленияДокументов(Запрос, ТекстыЗапроса, Регистры);
	
	СторноЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

#Область Команды

// Определяет список команд создания на основании.
//
// Параметры:
//	КомандыСозданияНаОсновании - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//	Параметры - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	СторноЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);
	
КонецПроцедуры

// Добавляет команду создания документа "Сторно".
//
// Параметры:
//   КомандыСозданияНаОсновании - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
// Возвращаемое значение:
//	см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.Сторно) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.Сторно.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.Сторно);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьИсправлениеДокументов";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//	КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//	Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	СторноЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	СторноЛокализация.ДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтение
		|ГДЕ
		| ЧтениеОбъектаРазрешено(СторнируемыйДокумент)
		|;
		|РазрешитьИзменениеЕслиРазрешеноЧтение
		|ГДЕ
		| ИзменениеОбъектаРазрешено(СторнируемыйДокумент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив Из ДокументСсылка.Сторно - Ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - Дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - Объекты печати
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СторноЛокализация.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

// Функция-конструктор параметров процедуры ИсправляемыйДокумент
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * СторнируемыйДокумент - ОпределяемыйТип.ИсправляемыеДокументы
// * Дата - Дата
//
Функция ПараметрыПолученияИсправляемогоДокумента() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("СторнируемыйДокумент", Документы.РеализацияТоваровУслуг.ПустаяСсылка());
	Параметры.Вставить("Дата", Дата(1, 1, 1));
	
	Возврат Параметры;	
	
КонецФункции

// Возвращает исправляемый документ сторно.
//
// Параметры:
//	РеквизитыДокумента - См. ПараметрыПолученияИсправляемогоДокумента
//
// Возвращаемое значение:
//  ДокументСсылка - Исправляемый документ.
//
Функция ИсправляемыйДокумент(Знач РеквизитыДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	ИсправляемыйДокумент = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СторнируемыйДокумент", РеквизитыДокумента.СторнируемыйДокумент);
	Запрос.УстановитьПараметр("Период", РеквизитыДокумента.Дата);
	
	Запрос.Текст = ТекстЗапросаТаблицаИсправленияДокументов();
		
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ИсправляемыйДокумент = Выборка.ИсправляемыйДокумент;	
	КонецЕсли;
	
	Возврат ИсправляемыйДокумент;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                     КАК Ссылка,
	|	ДанныеДокумента.Дата                       КАК Период,
	|	ДанныеДокумента.Номер                      КАК Номер,
	|	ДанныеДокумента.Проведен                   КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления            КАК ПометкаУдаления,
	|	ДанныеДокумента.СторнируемыйДокумент       КАК СторнируемыйДокумент,
	|	ДанныеДокумента.Автор                      КАК Автор,
	|	ДанныеДокумента.Комментарий                КАК Комментарий
	|ИЗ
	|	Документ.Сторно КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьТекстыЗапросовТаблицСторноДвижений(Запрос, ТекстыЗапроса, Регистры) 
	
	Если Запрос.Параметры.Свойство("СторнируемыйДокумент") Тогда
		// Сформируем запросы только по механизмам сторнируемого документа.
		ОбъектМетаданныхДокумент = Запрос.Параметры.СторнируемыйДокумент.Метаданные();
		УчетныеМеханизмы = ПроведениеДокументов.УчетныеМеханизмыДокумента(Документы[ОбъектМетаданныхДокумент.Имя]);
	Иначе
		// Сформируем запросы по всем учетным регистрам, т.к. контекст выполнения не известен.
		ОбъектМетаданныхДокумент = Неопределено;
		УчетныеМеханизмы = ПроведениеДокументов.ИменаУчетныхМеханизмовКонфигурации();
	КонецЕсли;
	
	МеханизмыКонфигурации = ПроведениеДокументов.УчетныеМеханизмыКонфигурации();
	Для каждого Механизм Из УчетныеМеханизмы Цикл
		
		МодульМеханизма = ОбщегоНазначения.ОбщийМодуль(МеханизмыКонфигурации[Механизм]);
		ТекстыЗапросовСторнирования = МодульМеханизма.ТекстыЗапросовСторнирования(Метаданные.Документы.Сторно);
		Для каждого КлючИЗначение Из ТекстыЗапросовСторнирования Цикл
			ОбъектМетаданныхРегистр = Метаданные.НайтиПоПолномуИмени(КлючИЗначение.Ключ);
			Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ОбъектМетаданныхРегистр.Имя, Регистры) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ОбъектМетаданныхДокумент <> Неопределено
				И Не ОбъектМетаданныхДокумент.Движения.Содержит(ОбъектМетаданныхРегистр) Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстыЗапроса.Добавить(КлючИЗначение.Значение, ОбъектМетаданныхРегистр.Имя);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ИсправляемыеДокументыПустыеСсылки = Новый Массив;
	Для каждого Тип Из Метаданные.ОпределяемыеТипы.ИсправляемыеДокументы.Тип.Типы() Цикл
		ИсправляемыеДокументыПустыеСсылки.Добавить(Новый (Тип));
	КонецЦикла;
	Запрос.УстановитьПараметр("ИсправляемыеДокументыПустыеСсылки", ИсправляемыеДокументыПустыеСсылки);
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	РеестрДокументов.ТипСсылки КАК ТипСсылки,
	|	РеестрДокументов.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	РеестрДокументов.Организация КАК Организация,
	|	РеестрДокументов.Партнер КАК Партнер,
	|	РеестрДокументов.МестоХранения КАК МестоХранения,
	|	РеестрДокументов.Контрагент КАК Контрагент,
	|	РеестрДокументов.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Дата КАК ДатаДокументаИБ,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	РеестрДокументов.РазделительЗаписи КАК РазделительЗаписи,
	|	ДанныеДокумента.Номер КАК НомерДокументаИБ,
	|	РеестрДокументов.Статус КАК Статус,
	|	ДанныеДокумента.Автор КАК Ответственный,
	|	РеестрДокументов.ДополнительнаяЗапись КАК ДополнительнаяЗапись,
	|	РеестрДокументов.Дополнительно КАК Дополнительно,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	РеестрДокументов.ДатаПервичногоДокумента КАК ДатаПервичногоДокумента,
	|	РеестрДокументов.НомерПервичногоДокумента КАК НомерПервичногоДокумента,
	|	РеестрДокументов.Сумма КАК Сумма,
	|	РеестрДокументов.Валюта КАК Валюта,
	|	РеестрДокументов.Договор КАК Договор,
	|	РеестрДокументов.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.Дата КАК ДатаОтраженияВУчете,
	|	ИСТИНА КАК СторноИсправление,
	|	ДанныеДокумента.СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	ВЫБОР
	|		КОГДА РеестрДокументов.ИсправляемыйДокумент = НЕОПРЕДЕЛЕНО
	|				ИЛИ РеестрДокументов.ИсправляемыйДокумент В (&ИсправляемыеДокументыПустыеСсылки)
	|			ТОГДА ДанныеДокумента.СторнируемыйДокумент
	|		ИНАЧЕ РеестрДокументов.ИсправляемыйДокумент
	|	КОНЕЦ КАК ИсправляемыйДокумент,
	|	ДанныеДокумента.Автор КАК Автор
	|ИЗ
	|	Документ.Сторно КАК ДанныеДокумента
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|	ПО
	|		ДанныеДокумента.СторнируемыйДокумент = РеестрДокументов.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&Ссылка)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаИсправленияДокументов()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&СторнируемыйДокумент КАК СторнируемыйДокумент
	|
	|ПОМЕСТИТЬ ВТ_СторнируемыйДокумент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЕСТЬNULL(ИсправленияДокументов.ИсправляемыйДокумент, ВТ_СторнируемыйДокумент.СторнируемыйДокумент) КАК ИсправляемыйДокумент,
	|	ВЫБОР
	|		КОГДА ИсправленияДокументов.Регистратор ЕСТЬ NULL
	|			ТОГДА Неопределено
	|		КОГДА ИсправленияДокументов.СпособИсправленияСторно
	|			ТОГДА ВТ_СторнируемыйДокумент.СторнируемыйДокумент
	|		ИНАЧЕ ИсправленияДокументов.ПредыдущееИсправление
	|	КОНЕЦ КАК ПредыдущееИсправление,
	|	ВЫБОР
	|		КОГДА ИсправленияДокументов.Регистратор ЕСТЬ NULL
	|			ТОГДА Неопределено
	|		КОГДА ИсправленияДокументов.СпособИсправленияСторно
	|			ТОГДА Неопределено
	|		ИНАЧЕ ИсправленияДокументов.ПредыдущееИсправление
	|	КОНЕЦ КАК ПоследнийДокументЦепочки,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ИсправленияДокументов.СпособИсправленияСторно, ИСТИНА)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СторнированИсправляемыйДокумент,
	|	ИСТИНА КАК СпособИсправленияСторно
	|ИЗ
	|	ВТ_СторнируемыйДокумент КАК ВТ_СторнируемыйДокумент
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсправленияДокументов КАК ИсправленияДокументов
	|		ПО (ИсправленияДокументов.Регистратор = ВТ_СторнируемыйДокумент.СторнируемыйДокумент)";

	Возврат ТекстЗапроса;
		
КонецФункции

Процедура ДобавитьТекстЗапросаТаблицаИсправленияДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ИсправленияДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;

	ТекстЗапроса = ТекстЗапросаТаблицаИсправленияДокументов();		
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос();
	ТекстыЗапроса = Новый СписокЗначений();
	
	ПолноеИмяДокумента = ПустаяСсылка().Метаданные().ПолноеИмя();
	СинонимТаблицыДокумента = "ДанныеДокумента";
	ВЗапросеЕстьИсточник    = Истина;
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяДокумента));
	
	ПереопределениеРасчетаПараметров = Новый Структура;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ДобавитьТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		ТекстЗапроса = ТекстыЗапроса[0].Значение;
		ЗначенияПараметров.Вставить("ИсправляемыеДокументыПустыеСсылки",
			Запрос.Параметры.ИсправляемыеДокументыПустыеСсылки);
		ВЗапросеЕстьИсточник = Истина;
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса,
			ПолноеИмяДокумента,
			СинонимТаблицыДокумента,
			ВЗапросеЕстьИсточник,
			ПереопределениеРасчетаПараметров
		);
			
		Для Каждого Измерение Из Метаданные.РегистрыСведений.РеестрДокументов.Измерения Цикл
		
			Если Измерение.Тип.СодержитТип(Тип("СправочникСсылка.КлючиРеестраДокументов")) Тогда
				
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 КАК %1", Измерение.Имя),
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1.Ключ КАК %1", Измерение.Имя)
				);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти

#КонецЕсли
