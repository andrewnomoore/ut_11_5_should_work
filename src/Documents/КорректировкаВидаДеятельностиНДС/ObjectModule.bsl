#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет аналитики учета номенклатуры. Используется в отчете ОстаткиТоваровОрганизаций.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатуры() Экспорт
	
	ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(Товары);
	
КонецПроцедуры

// Создает менеджер временных таблиц с таблицами, которые используются для заполнения видов запасов.
// Экспорт требуется для отчета ОстаткиТоваровОрганизаций.
// 
// Возвращаемое значение:
//  МенеджерВременныхТаблиц - менеджер временных таблиц.
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	&Назначение КАК Назначение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПустаяСсылка) КАК Предназначение,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеТоваров) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ &ТекстПоляТаблицаТоваровКоличествоПоРНПТ_
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	&ТекстПоляТаблицаТоваровНомерГТД_ КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	&Назначение КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
						ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
						Товары);
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	ОбщегоНазначенияУТ.ЗаменитьОтсутствующиеПоляТаблицыЗначенийВТекстеЗапроса(
		ТаблицаТоваров,
		Запрос.Текст,
		"&ТекстПоляТаблицаТоваровКоличествоПоРНПТ_",
		"ТаблицаТоваров",
		"КоличествоПоРНПТ",
		"ТаблицаТоваров.КоличествоПоРНПТ",
		"0");
	
	ОбщегоНазначенияУТ.ЗаменитьОтсутствующиеПоляТаблицыЗначенийВТекстеЗапроса(
		ТаблицаТоваров,
		Запрос.Текст,
		"&ТекстПоляТаблицаТоваровНомерГТД_",
		"ТаблицаТоваров",
		"НомерГТД",
		"ТаблицаТоваров.НомерГТД",
		"ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)");
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

// Заполняет реквизиты, хранящие информацию о видах запасов и аналитиках учета номенклатуры в табличной части 'Товары'
// документа, а также заполняет табличную часть 'ВидыЗапасов'.
//
// Параметры:
//	Отказ - Булево - признак того, что не удалось заполнить данные.
//	ТаблицыДокумента - см. Документы.КорректировкаВидаДеятельностиНДС.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьВидыЗапасовПриОбмене(Отказ, ТаблицыДокумента) Экспорт
	
	ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
	
	Если ТаблицыДокумента <> Неопределено Тогда
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента);
		ДополнительныеСвойства.Вставить("ТаблицыЗаполненияВидовЗапасовПриОбмене", ТаблицыДокумента);
	Иначе
		ИмяПараметра = "ТаблицыДокумента";
		
		ТекстИсключения = НСтр("ru = 'Для заполнения видов запасов не передан параметр ""%1"".'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ИмяПараметра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаполнитьВидыЗапасов(Отказ);
	ДополнительныеСвойства.Удалить("ТаблицыЗаполненияВидовЗапасовПриОбмене");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ВидыЗапасовУказаныВручную = Ложь;
	
	Если ВидыЗапасов.Количество() > 0 Тогда
		ВидыЗапасов.Очистить();
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаОбособленногоУчетаЗапасов),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	Если НалогообложениеНДС = НовоеНалогообложениеНДС Тогда
		
		ТекстОшибки = НСтр("ru='Новая деятельность соответствует исходной'");
		Поле = "НалогообложениеНДС";
	
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, Поле, , Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаОбособленногоУчетаЗапасов));
	
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение
		И Не ВидыЗапасовУказаныВручную Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", "ПолучитьПередФормированием");
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", "ПолучитьПередФормированием");
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(ПриобретениеТоваровУслуг)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ПриобретениеТоваровУслуг);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриобретениеТоваровУслуг.Ссылка КАК Ссылка,
	|	ПриобретениеТоваровУслуг.Организация КАК Организация,
	|	ПриобретениеТоваровУслуг.Склад КАК Склад,
	|	ПриобретениеТоваровУслуг.Ссылка КАК ДокументПоступления,
	|	ПриобретениеТоваровУслуг.ЗакупкаПодДеятельность КАК НалогообложениеНДС,
	|	
	|	НЕ ПриобретениеТоваровУслуг.Проведен КАК ЕстьОшибкиПроведен
	|
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
	|ГДЕ
	|	ПриобретениеТоваровУслуг.Ссылка = &ДокументОснование
	|
	|////////////////////////////////////////////////
	|;
	|ВЫБРАТЬ
	|	Товары.Номенклатура        КАК Номенклатура,
	|	Товары.Характеристика      КАК Характеристика,
	|	Товары.Серия               КАК Серия,
	|	Товары.Склад               КАК Склад,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Количество          КАК Количество
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И Товары.Номенклатура.ТипНоменклатуры В(
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|";
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	Шапка = ПакетРезультатов[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		,
		Шапка.ЕстьОшибкиПроведен,);
	
	// Заполнение шапки.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	
	ТоварыОснования = ПакетРезультатов[1].Выгрузить();
	
	// Заполнение табличной части товары.
	Если Не ТоварыОснования.Количество() Тогда
		ТекстОшибки = НСтр("ru='Документ %Документ% не содержит товаров. Ввод на основании документа запрещен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ПриобретениеТоваровУслуг);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Товары.Загрузить(ТоварыОснования);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") Тогда
		МассивСкладов = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(ТоварыОснования.ВыгрузитьКолонку("Склад"));
		
		Если МассивСкладов.Количество() = 1 Тогда
			Склад = МассивСкладов[0];
		Иначе
			Склад = Справочники.Склады.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		ИЛИ ПерезаполнитьВидыЗапасов
		ИЛИ ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		ИЛИ ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличеству(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(МенеджерВременныхТаблиц);
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество, КоличествоПоРНПТ");
		
		ЗаполнитьВидЗапасовОприходование();
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует временную таблицу товаров с аналитикой обособленного учета. 
// Требуется для отчета ОстаткиТоваровОрганизаций.
//
// Параметры:
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц	 - менеджер временных таблиц, в котором есть таблица ТаблицаТоваров.
//
Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТоваров.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаДанныхДокумента.Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		ИСТИНА
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц)
	
	Если МенеджерВременныхТаблиц.Таблицы.Найти("ДоступныеВидыЗапасов") <> Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"
	// Собственные виды запасов
	|ВЫБРАТЬ
	|	ВидыЗапасов.Организация КАК ДляОрганизации,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|	
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	НЕ ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И (ВидыЗапасов.НалогообложениеНДС = &НалогообложениеНДС
	|		ИЛИ (ВидыЗапасов.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|				И &НалогообложениеНДС = &НалогообложениеОрганизации))
	|	И НЕ ВидыЗапасов.ПометкаУдаления
	|	И НЕ &ПартионныйУчетВерсии22
	|	И НЕ ВидыЗапасов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВидыЗапасов.Организация КАК ДляОрганизации,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	НЕ ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И НЕ ВидыЗапасов.ПометкаУдаления
	|	И &ПартионныйУчетВерсии22
	|	И НЕ ВидыЗапасов.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидЗапасов";
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("ПартионныйУчетВерсии22",
		РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(Дата)));
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПараметрыЗаполненияВидовЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	РежимЗаписи = ПроведениеДокументов.СвойстваДокумента(ЭтотОбъект).РежимЗаписи;
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ДокументДелаетИПриходИРасход = (РежимЗаписи = РежимЗаписиДокумента.Проведение);
	ПараметрыЗаполнения.ДоступныеВидыЗапасовУжеСформированы = Истина;
	ПараметрыЗаполнения.ПодбиратьВТЧТоварыПринятыеНаОтветственноеХранение.Вставить(Перечисления.ТипыЗапасов.ТоварНаХраненииСПравомПродажи, "Никогда");
	
	СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Заполняет аналитики учета номенклатуры в табличных частях документа, хранящих информацию о товарах.
// Если параметр не передан, тогда будет выполнено заполнение данных в табличных частях документа.
//
// Параметры:
//	ТаблицыДокумента - см. Документы.КорректировкаВидаДеятельностиНДС.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента = Неопределено)
	
	Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.КорректировкаВидаДеятельностиНДС.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
					Перечисления.ХозяйственныеОперации.ПеремещениеТоваров,
					Склад,
					Неопределено,
					Неопределено);
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Склад, НалогообложениеНДС";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Процедура ЗаполнитьВидЗапасовОприходование()
	
	Если СохранятьВидЗапасов Тогда
		Для Каждого СтрТабл Из ВидыЗапасов Цикл
			СтрТабл.ВидЗапасовОприходование = СтрТабл.ВидЗапасов;
		КонецЦикла;
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаВидыЗапасов.НомерСтроки,
		|	ВЫРАЗИТЬ(ТаблицаВидыЗапасов.ВидЗапасов КАК Справочник.ВидыЗапасов) КАК ВидЗапасов,
		|	ТаблицаВидыЗапасов.НомерГТД,
		|	ТаблицаВидыЗапасов.Количество,
		|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры
		|ПОМЕСТИТЬ ТаблицаВидыЗапасов
		|ИЗ
		|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	&Организация КАК Организация,
		|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
		|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
		|	ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов КАК ТипЗапасов,
		|	ТаблицаВидыЗапасов.ВидЗапасов.ВладелецТовара КАК ВладелецТовара,
		|	ТаблицаВидыЗапасов.ВидЗапасов.Соглашение КАК Соглашение,
		|	ТаблицаВидыЗапасов.ВидЗапасов.Валюта КАК Валюта,
		|	&НалогообложениеОрганизации КАК НалогообложениеОрганизации,
		|	ТаблицаВидыЗапасов.ВидЗапасов.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
		|	&НовоеНалогообложениеНДС КАК НалогообложениеНДС,
		|	ВЫБОР
		|		КОГДА ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаКомиссию)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
		|	КОНЕЦ КАК ХозяйственнаяОперация
		|ИЗ
		|	ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";

		ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
		Запрос.УстановитьПараметр("НалогообложениеОрганизации", ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("НовоеНалогообложениеНДС", НовоеНалогообложениеНДС);
		Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
		
		СоответствиеВидовЗапасов = Новый Соответствие;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаТЧ = ВидыЗапасов[Выборка.НомерСтроки - 1];
			
			ВидЗапасовОприходование = СоответствиеВидовЗапасов.Получить(СтрокаТЧ.ВидЗапасов);
			
			Если ВидЗапасовОприходование = Неопределено Тогда
				ВидЗапасовОприходование = Справочники.ВидыЗапасов.ВидЗапасовДокумента(Выборка.Организация, Выборка.ХозяйственнаяОперация, Выборка);
				СоответствиеВидовЗапасов.Вставить(СтрокаТЧ.ВидЗапасов, ВидЗапасовОприходование);
			КонецЕсли;
			СтрокаТЧ.ВидЗапасовОприходование = ВидЗапасовОприходование;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли