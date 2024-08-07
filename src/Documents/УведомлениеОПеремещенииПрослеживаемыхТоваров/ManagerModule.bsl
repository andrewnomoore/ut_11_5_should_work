#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// Возвращает представление уведомления о перемещении прослеживаемых товаров с учетом состояния проведения.
//
// Параметры:
// 	Номер - Строка - Номер уведомления о ввозе.
// 	Дата - Дата - Дата уведомления о ввозе.
// 	Проведен - Булево - Признак проведения документа.
//	ДанныеИзменены - Булево - Признак того, что данные изменены
//
// Возвращаемое значение:
//	Строка - 
//
Функция ПредставлениеУведомленияОПеремещенииПрослеживаемыхТоваров(Номер, Дата, Проведен, ДанныеИзменены = Ложь) Экспорт
	
	ДанныеШапки = Новый Структура();
	ДанныеШапки.Вставить("Номер", Номер);
	ДанныеШапки.Вставить("Дата", Дата);
	
	МассивПодстрок = Новый Массив;
	МассивПодстрок.Добавить(ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(ДанныеШапки, НСтр("ru = 'Уведомление о перемещении ПТ'")));
	
	МассивПодстрокВСкобках = Новый Массив;
	Если Не Проведен Тогда 		
		МассивПодстрокВСкобках.Добавить(НСтр("ru = 'не проведено'"));
	КонецЕсли;
	Если ДанныеИзменены Тогда
		Если МассивПодстрокВСкобках.Количество() Тогда
			МассивПодстрокВСкобках.Добавить(НСтр("ru = ', '"));
		КонецЕсли;
		МассивПодстрокВСкобках.Добавить(НСтр("ru = 'данные изменены'"));
	КонецЕсли;
	Если МассивПодстрокВСкобках.Количество() Тогда		
		МассивПодстрок.Добавить(НСтр("ru = '('"));
		Для Каждого ПодстрокаВСкобках Из МассивПодстрокВСкобках Цикл
			МассивПодстрок.Добавить(ПодстрокаВСкобках);		
		КонецЦикла;
		МассивПодстрок.Добавить(НСтр("ru = ')'"));		
	КонецЕсли;

	Возврат СтрСоединить(МассивПодстрок, " ");
	
КонецФункции

// Функция находит распоряжения на оформление уведомлений о перемещении прослеживаемых товаров для заданного документа реализации.
//
// Параметры:
//	ДокументРеализации - ДокументСсылка - Документ, для которого необходимо найти распоряжения на оформление уведомлений о перемещении прослеживаемых товаров.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Таблица с найденными распоряжениями на оформление.
//
Функция РаспоряженияКОформлениюУведомленийОПеремещенииПоОснованию(ДокументРеализации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
                          |		ТоварыКОформлениюДокументовИмпортаОстатки.Организация КАК Организация,
                          |		ТоварыКОформлениюДокументовИмпортаОстатки.Номенклатура.КодТНВЭД КАК КодТНВЭД,
                          |		ТоварыКОформлениюДокументовИмпортаОстатки.СопроводительныйДокумент КАК СопроводительныйДокумент
                          |	ИЗ
                          |		РегистрНакопления.ПрослеживаемыеТоварыОтгруженныеВЕАЭС.Остатки(
                          |				,
                          |				СопроводительныйДокумент = &ДокументРеализации) КАК ТоварыКОформлениюДокументовИмпортаОстатки
                          |	ГДЕ
                          |		ТоварыКОформлениюДокументовИмпортаОстатки.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("ДокументРеализации", ДокументРеализации);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаРаспоряжений = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаРаспоряжений;
	
КонецФункции

// Функция находит уведомления о перемещении прослеживаемых товаров заданного первичного документа.
//
// Параметры:
//	ПервичныйДокумент - ДокументСсылка - Документ, для которого необходимо найти уведомления о перемещении прослеживаемых товаров.
//	Проведен - Булево - Признак того, что необходимо получить проведенные документы.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Таблица найденных уведомления о перемещении прослеживаемых товаров.
//
Функция УведомленияОПеремещенииПрослеживаемыхТоваровПоОснованию(ПервичныйДокумент, Проведен = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка КАК Ссылка,
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка.Проведен КАК Проведен,
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка.Номер КАК Номер,
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка.Дата КАК Дата,
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка.Организация КАК Организация,
	|	ЕСТЬNULL(УведомлениеОПеремещенииПрослеживаемыхТоваровКонтрагенты.Контрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Контрагент,
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.КодТНВЭД КАК КодТНВЭД,
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.СопроводительныйДокумент КАК СопроводительныйДокумент
	|ИЗ
	|	Документ.УведомлениеОПеремещенииПрослеживаемыхТоваров.Товары КАК УведомлениеОПеремещенииПрослеживаемыхТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УведомлениеОПеремещенииПрослеживаемыхТоваров.Контрагенты КАК УведомлениеОПеремещенииПрослеживаемыхТоваровКонтрагенты
	|		ПО (УведомлениеОПеремещенииПрослеживаемыхТоваровКонтрагенты.КлючСтроки = УведомлениеОПеремещенииПрослеживаемыхТоваров.КлючСтроки)
	|ГДЕ
	|	УведомлениеОПеремещенииПрослеживаемыхТоваров.СопроводительныйДокумент = &СопроводительныйДокумент
	|	И УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка.ПометкаУдаления = ЛОЖЬ";
	
	Если Проведен Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПометкаУдаления = ЛОЖЬ", "Проведен");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СопроводительныйДокумент", ПервичныйДокумент);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаУведомлений = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаУведомлений;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует заполненные таблицы документа
//
// Параметры:
//  Параметры - Структура: 
//						- Организация - СправочникСсылка - организация
//						- Период - Дата - дата помощника получения РНПТ
//  АдресРезультата - строка - адрес, куда будет помещен результат 
// 
Процедура ЗаполнитьДокумент(Параметры, АдресРезультата) Экспорт
	
	ДанныеТаблиц = ЗаполнитьДокументДанными(
		Параметры.Дата,
		Параметры.Организация);
	
	ПоместитьВоВременноеХранилище(ДанныеТаблиц, АдресРезультата);
	
КонецПроцедуры

#Область ПодготовкаПараметровПроведенияДокумента

// Функция подготавливает параметры проведения документа
// 
// Параметры:
//  ДокументСсылка - ДокументСсылка - ссылка на документ УведомлениеОПеремещенииПрослеживаемыхТоваров
//  Отказ - Булево
// 
// Возвращаемое значение:
//  Структура - Подготовить параметры проведения:
// * Реквизиты - ТаблицаЗначений, ДеревоЗначений -
Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	Если НЕ ПрослеживаемостьПереопределяемый.УчетнаяПолитикаСуществует(
			Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = 
		ПрослеживаемостьПереопределяемый.ТекстЗапросаТаблицаТоваровУведомлениеОПеремещении(НомераТаблиц, ДокументСсылка);
	
	ПрослеживаемостьПереопределяемый.ДополнительныеПараметрыЗапроса(НомераТаблиц, Запрос);
	
	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		Результат = Запрос.ВыполнитьПакет();
		Для Каждого НомерТаблицы Из НомераТаблиц Цикл
			ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаполнитьДокументДанными(Период, Организация, ДокументОснование = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Запрос.Текст = ПрослеживаемостьПереопределяемый.ЗапросЗаполнитьДокументДаннымиУведомлениеОперемещении() + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ВыборкаДанных.Контрагент КАК Контрагент
	|ИЗ
	|	ВТ_ВыборкаДанных КАК ВТ_ВыборкаДанных
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ВыборкаДанных.Контрагент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ВыборкаДанных.Номенклатура КАК Номенклатура,
	|	ВТ_ВыборкаДанных.РНПТ КАК РНПТ,
	|	ВТ_ВыборкаДанных.Контрагент КАК Контрагент,
	|	ВТ_ВыборкаДанных.ПорядковыйНомер КАК ПорядковыйНомер,
	|	ВТ_ВыборкаДанных.КоличествоОстаток КАК Количество,
	|	ВТ_ВыборкаДанных.КоличествоПрослеживаемостиОстаток КАК КоличествоПрослеживаемости,
	|	ВТ_ВыборкаДанных.СуммаОстаток КАК Сумма,
	|	ВТ_ВыборкаДанных.СопроводительныйДокумент КАК СопроводительныйДокумент,
	|	ВТ_ВыборкаДанных.КодТНВЭД КАК КодТНВЭД,
	|	ВТ_ВыборкаДанных.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫРАЗИТЬ(ВТ_ВыборкаДанных.КодТНВЭД КАК Справочник.КлассификаторТНВЭД).ЕдиницаИзмерения КАК ЕдиницаПрослеживаемости
	|ИЗ
	|	ВТ_ВыборкаДанных КАК ВТ_ВыборкаДанных";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	// В таблице товары СопроводительныйДокумент показывает сигнал к новому ключу
	ТаблицаКонтрагенты = РезультатЗапроса[1].Выгрузить();
	ТаблицаКонтрагенты.Колонки.Добавить("КлючСтроки", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ТаблицаКонтрагенты.Колонки.Добавить("ЕдиницыПрослеживаемостиСовпадают", Новый ОписаниеТипов("Булево"));
	
	ТаблицаТовары = РезультатЗапроса[2].Выгрузить();
	ТаблицаТовары.Колонки.Добавить("КлючСтроки", Новый ОписаниеТипов("УникальныйИдентификатор"));
	
	ФильтрОтбора = Новый Структура("Контрагент");
	
	Для каждого ТекущаСтрокаКонтрагенты Из ТаблицаКонтрагенты Цикл
		
		ЗаполнитьЗначенияСвойств(ФильтрОтбора, ТекущаСтрокаКонтрагенты);
		ТекущаСтрокаКонтрагенты.КлючСтроки = Новый УникальныйИдентификатор();
		
		ТекущаСтрокаКонтрагенты.ЕдиницыПрослеживаемостиСовпадают = Истина;
		
		НаденныйСтрокиТовары = ТаблицаТовары.НайтиСтроки(ФильтрОтбора);
		
		Для каждого ТекущаяСтрокаТовары Из НаденныйСтрокиТовары Цикл
			
			ТекущаяСтрокаТовары.КлючСтроки = ТекущаСтрокаКонтрагенты.КлючСтроки;
			
			Если ТекущаяСтрокаТовары.ЕдиницаИзмерения <> ТекущаяСтрокаТовары.ЕдиницаПрослеживаемости Тогда
				
				ТекущаСтрокаКонтрагенты.ЕдиницыПрослеживаемостиСовпадают = Ложь;
				
			КонецЕсли;
		
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый Структура("Контрагенты,Товары", ТаблицаКонтрагенты, ТаблицаТовары)
	
КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.УведомлениеОПеремещенииПрослеживаемыхТоваров КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Организация КАК Организация
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
