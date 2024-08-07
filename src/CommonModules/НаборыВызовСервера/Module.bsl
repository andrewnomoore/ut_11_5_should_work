////////////////////////////////////////////////////////////////////////////////
// Модуль "НаборыВызовСервера", содержит процедуры и функции для
// работы с наборами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает вариант комплектации номенклатуры по-умолчанию
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - Позиция номенклатуры.
//  Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - Характеристика номенклатуры.
//
// Возвращаемое значение:
//  СправочникСсылка.ВариантыКомплектацииНоменклатуры - Вариант комплектации по-умолчанию.
//
Функция ВариантКомплектацииНоменклатурыПоУмолчанию(Знач Номенклатура, Знач Характеристика) Экспорт
	
	ВариантКомплектацииНоменклатуры = Неопределено;
	
	Если Характеристика = Неопределено Тогда
		Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВариантыКомплектацииНоменклатуры.Ссылка КАК ВариантКомплектацииНоменклатуры
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|ГДЕ
	|	ВариантыКомплектацииНоменклатуры.Владелец = &Владелец
	|	И ВариантыКомплектацииНоменклатуры.Характеристика = &Характеристика
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВариантыКомплектацииНоменклатуры.Основной УБЫВ,
	|	ВариантыКомплектацииНоменклатуры.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("Владелец", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВариантКомплектацииНоменклатуры = Выборка.ВариантКомплектацииНоменклатуры;
	КонецЕсли;
	
	Возврат ВариантКомплектацииНоменклатуры;
	
КонецФункции

// Функция возвращает параметры варианта комплектации номенклатуры
// 
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - Позиция номенклатуры.
//  Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - Характеристика номенклатуры.
//
// Возвращаемое значение:
//  Неопределено, Структура - Структура со свойствами:
//   * ВариантКомплектацииНоменклатуры - СправочникСсылка.ВариантыКомплектацииНоменклатуры - Вариант комплектации.
//   * ВариантРасчетаЦеныНабора - ПеречислениеСсылка.ВариантыРасчетаЦенНаборов - Вариант расчета цены набора.
//   * ВариантПредставленияНабораВПечатныхФормах - ПеречислениеСсылка.ВариантыПредставленияНаборовВПечатныхФормах -
//                                                 Вариант предоставления в печатных формах.
//   * Комплектующие - ТаблицаЗначений - Комплектующие.
//   * НоменклатураОсновногоКомпонента - СправочникСсылка.Номенклатура - Номенклатура основного компонента.
//   * ХарактеристикаОсновногоКомпонента - СправочникСсылка.ХарактеристикиНоменклатуры - Характеристика основного компонента.
//
Функция ПараметрыВариантаКомплектацииНоменклатуры(Знач Номенклатура, Знач Характеристика) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Характеристика = Неопределено Тогда
		Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВариантыКомплектацииНоменклатуры.Ссылка                                    КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	ВариантыКомплектацииНоменклатуры.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатуры.НоменклатураОсновногоКомпонента           КАК НоменклатураОсновногоКомпонента,
	|	ВариантыКомплектацииНоменклатуры.ХарактеристикаОсновногоКомпонента         КАК ХарактеристикаОсновногоКомпонента,
	|	ВариантыКомплектацииНоменклатуры.Товары.(
	|		Ссылка,
	|		НомерСтроки,
	|		Номенклатура,
	|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		Номенклатура.ТипНоменклатуры  КАК ТипНоменклатуры,
 	|		ВЫБОР 
	|			КОГДА Номенклатура.ИспользованиеХарактеристик В (
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры),
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры),
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры))
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ                         КАК ХарактеристикиИспользуются,
	|		Характеристика,
	|		Упаковка,
	|		КоличествоУпаковок,
	|		ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) КАК КоэффициентУпаковки,
	|		ДоляСтоимости,
	|		Количество
	|	) КАК Комплектующие
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|ГДЕ
	|	ВариантыКомплектацииНоменклатуры.Владелец = &Владелец
	|	И ВариантыКомплектацииНоменклатуры.Характеристика = &Характеристика
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВариантыКомплектацииНоменклатуры.Основной УБЫВ");
	
	Запрос.УстановитьПараметр("Владелец", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	
	ТекстЗапросаКоэффициентУпаковки = Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ВариантыКомплектацииНоменклатуры.Товары.Упаковка",
		"ВариантыКомплектацииНоменклатуры.Товары.Номенклатура");
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		ТекстЗапросаКоэффициентУпаковки);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() > 0 Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("ВариантКомплектацииНоменклатуры",           Результат[0].ВариантКомплектацииНоменклатуры);
		ВозвращаемоеЗначение.Вставить("ВариантРасчетаЦеныНабора",                  Результат[0].ВариантРасчетаЦеныНабора);
		ВозвращаемоеЗначение.Вставить("ВариантПредставленияНабораВПечатныхФормах", Результат[0].ВариантПредставленияНабораВПечатныхФормах);
		ВозвращаемоеЗначение.Вставить("Комплектующие",                             Результат[0].Комплектующие);
		ВозвращаемоеЗначение.Вставить("НоменклатураОсновногоКомпонента",           Результат[0].НоменклатураОсновногоКомпонента);
		ВозвращаемоеЗначение.Вставить("ХарактеристикаОсновногоКомпонента",         Результат[0].ХарактеристикаОсновногоКомпонента);
		
		Возврат ВозвращаемоеЗначение;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Функция возвращает комплектующие набора, их цены и остатки на складах
// 
// Параметры:
//  Параметры - Структура - Описание параметров набора.
//  ДополнительныеПараметры - Структура - Прочие параметры (Расчет цен и остатков).
//
// Возвращаемое значение:
//  Массив - Массив с комплектующими набора.
//
Функция Комплектующие(Параметры, ДополнительныеПараметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Параметры.ВариантКомплектацииНоменклатуры) Тогда
		ВариантКомплектацииНоменклатуры = ВариантКомплектацииНоменклатурыПоУмолчанию(
			Параметры.НоменклатураНабора,
			Параметры.ХарактеристикаНабора);
	Иначе
		ВариантКомплектацииНоменклатуры = Параметры.ВариантКомплектацииНоменклатуры;
	КонецЕсли;
	
	Если Не Параметры.Свойство("КоличествоУпаковок") Тогда
		Параметры.Вставить("КоличествоУпаковок", 1);
	КонецЕсли;
	
	ПодобранныеТовары = Новый Массив;
	
	Если Не ЗначениеЗаполнено(ВариантКомплектацииНоменклатуры) Тогда
		ТекстОшибки = НСтр("ru = 'Для номенклатуры %1 не определен состав набора'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстОшибки,
			Параметры.НоменклатураНабора,
			Параметры.ХарактеристикаНабора);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат ПодобранныеТовары;
	КонецЕсли;
	
	Комплектующие = НаборыСервер.СоздатьТаблицуСоставаНабора(КолонкиНабора());
	Комплектующие.Колонки.Добавить("ТипНоменклатуры", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыНоменклатуры"));
	Комплектующие.Колонки.Добавить("ВидНоменклатуры", Новый ОписаниеТипов("СправочникСсылка.ВидыНоменклатуры"));
	Комплектующие.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	Комплектующие.Колонки.Добавить("КоэффициентУпаковки", Новый ОписаниеТипов("Число"));
	
	ВариантРасчетаЦеныНабора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВариантКомплектацииНоменклатуры, "ВариантРасчетаЦеныНабора");
	
	Запрос = Новый Запрос();
	Тексты = Новый Массив();
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДоступностьТоваров.Номенклатура КАК Номенклатура,
		|	ДоступностьТоваров.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ДоступностьТоваров.ВНаличииОстаток - ДоступностьТоваров.РезервироватьНаСкладеОстаток < 0
		|			ТОГДА ДоступностьТоваров.ВНаличииОстаток - ДоступностьТоваров.РезервироватьНаСкладеОстаток
		|		ИНАЧЕ
		|			ВЫБОР
		|				КОГДА ДоступностьТоваров.ВНаличииОстаток
		|							- ДоступностьТоваров.РезервироватьНаСкладеОстаток
		|							- ДоступностьТоваров.РезервироватьПоМереПоступленияОстаток > 0
		|					ТОГДА ДоступностьТоваров.ВНаличииОстаток
		|							- ДоступностьТоваров.РезервироватьНаСкладеОстаток
		|							- ДоступностьТоваров.РезервироватьПоМереПоступленияОстаток
		|				ИНАЧЕ 0
		|			КОНЕЦ
		|	КОНЕЦ КАК Свободно
		|ПОМЕСТИТЬ ДоступныеОстатки
		|ИЗ
		|	РегистрНакопления.ЗапасыИПотребности.Остатки(,
		|		(Номенклатура, Характеристика) В(
		|			ВЫБРАТЬ
		|				ВариантыКомплектацииНоменклатурыТовары.Номенклатура КАК Номенклатура,
		|				ВариантыКомплектацииНоменклатурыТовары.Характеристика КАК Характеристика
		|			ИЗ
		|				Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
		|			ГДЕ
		|				ВариантыКомплектацииНоменклатурыТовары.Ссылка = &Ссылка)
		|		И &ФильтрСклады
		|		И Назначение = &Назначение) КАК ДоступностьТоваров
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика
		|;
		|
		|//////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДоступностьТоваров.Номенклатура КАК Номенклатура,
		|	ДоступностьТоваров.Характеристика КАК Характеристика,
		|	ДоступностьТоваров.ВНаличииОстаток КАК ВНаличии
		|ПОМЕСТИТЬ ОстаткиВНаличии
		|ИЗ
		|	РегистрНакопления.ЗапасыИПотребности.Остатки(,
		|		(Номенклатура, Характеристика) В(
		|			ВЫБРАТЬ
		|				ВариантыКомплектацииНоменклатурыТовары.Номенклатура КАК Номенклатура,
		|				ВариантыКомплектацииНоменклатурыТовары.Характеристика КАК Характеристика
		|			ИЗ
		|				Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
		|			ГДЕ
		|				ВариантыКомплектацииНоменклатурыТовары.Ссылка = &Ссылка)
		|		И &ФильтрНазначение
		|		И &ФильтрСклады) КАК ДоступностьТоваров
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика";
	Тексты.Добавить(ТекстЗапроса);
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВариантыКомплектацииНоменклатурыТовары.НомерСтроки КАК НомерСтроки,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура КАК Номенклатура,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
		|	ВариантыКомплектацииНоменклатурыТовары.Характеристика КАК Характеристика,
		|	ВариантыКомплектацииНоменклатурыТовары.Упаковка КАК Упаковка,
		|	ВариантыКомплектацииНоменклатурыТовары.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ВариантыКомплектацииНоменклатурыТовары.Количество КАК Количество,
		|	ВариантыКомплектацииНоменклатурыТовары.ДоляСтоимости КАК ДоляСтоимости,
		|	СУММА(ЕСТЬNULL(ОстаткиВНаличии.ВНаличии, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1)) КАК ВНаличии,
		|	СУММА(ЕСТЬNULL(ДоступностьТоваров.Свободно, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1)) КАК Доступно,
		|	ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) КАК КоэффициентУпаковки		
		|ИЗ
		|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ДоступныеОстатки КАК ДоступностьТоваров
		|		ПО ДоступностьТоваров.Номенклатура = ВариантыКомплектацииНоменклатурыТовары.Номенклатура
		|			И ДоступностьТоваров.Характеристика = ВариантыКомплектацииНоменклатурыТовары.Характеристика
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиВНаличии КАК ОстаткиВНаличии
		|		ПО ОстаткиВНаличии.Номенклатура = ВариантыКомплектацииНоменклатурыТовары.Номенклатура
		|			И ОстаткиВНаличии.Характеристика = ВариантыКомплектацииНоменклатурыТовары.Характеристика
		|ГДЕ
		|	ВариантыКомплектацииНоменклатурыТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВариантыКомплектацииНоменклатурыТовары.Характеристика,
		|	ВариантыКомплектацииНоменклатурыТовары.Упаковка,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура,
		|	ВариантыКомплектацииНоменклатурыТовары.НомерСтроки,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура.ТипНоменклатуры,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура.ЕдиницаИзмерения,
		|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура.ВидНоменклатуры,
		|	ВариантыКомплектацииНоменклатурыТовары.КоличествоУпаковок,
		|	ВариантыКомплектацииНоменклатурыТовары.Количество,
		|	ВариантыКомплектацииНоменклатурыТовары.ДоляСтоимости,
		|	ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Тексты.Добавить(ТекстЗапроса);
	Запрос.Текст = СтрСоединить(Тексты, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ВЫРАЗИТЬ(ВариантыКомплектацииНоменклатурыТовары.Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения)",
		"ВЫРАЗИТЬ(ВариантыКомплектацииНоменклатурыТовары.Номенклатура КАК Справочник.Номенклатура)"));
		
	Запрос.УстановитьПараметр("Ссылка",  ВариантКомплектацииНоменклатуры);
	Если ДополнительныеПараметры.Свойство("Назначение") И ЗначениеЗаполнено(ДополнительныеПараметры.Назначение) Тогда
		// По переданному назначению получаем остатки в наличии только по этому назначению и доступные остатки тоже.
		Запрос.УстановитьПараметр("Назначение", ДополнительныеПараметры.Назначение);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрНазначение", "Назначение = &Назначение");
	Иначе
		// Если конкретное назначение не передано, получаем в наличии по всем назначениям а доступные остатки по пустому назначению.
		Запрос.УстановитьПараметр("Назначение", Справочники.Назначения.ПустаяСсылка());
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрНазначение", "ИСТИНА");
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("Склады") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрСклады", "Склад В (&Склады)");
		Запрос.УстановитьПараметр("Склады",  ДополнительныеПараметры.Склады);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрСклады", "ИСТИНА");
	КонецЕсли;

	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Комплектующие.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.КоличествоУпаковок   = НоваяСтрока.КоличествоУпаковок;
		НоваяСтрока.Количество           = НоваяСтрока.Количество;
		НоваяСтрока.НоменклатураНабора   = Параметры.НоменклатураНабора;
		НоваяСтрока.ХарактеристикаНабора = Параметры.ХарактеристикаНабора;
		
	КонецЦикла;
	
	Если ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих Тогда
		
		Если ДополнительныеПараметры.Свойство("ВидЦены") Тогда
			
			ПараметрыЗаполнения = Новый Структура;
			ПараметрыЗаполнения.Вставить("Дата", ДополнительныеПараметры.Дата);
			ПараметрыЗаполнения.Вставить("Валюта", ДополнительныеПараметры.Валюта);
			ПараметрыЗаполнения.Вставить("ВидЦены", ДополнительныеПараметры.ВидЦены);
			ПараметрыЗаполнения.Вставить("РассчитыватьНаборы", Истина);
			ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, ВидЦены");
			
			Если ДополнительныеПараметры.Свойство("Организация") И ЗначениеЗаполнено(ДополнительныеПараметры.Организация) Тогда
				ПараметрыЗаполнения.Вставить("Организация", ДополнительныеПараметры.Организация);
			КонецЕсли;
			
			ЦеныРассчитаны = ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(
				Комплектующие,
				Неопределено, // Массив строк или структура отбора.
				ПараметрыЗаполнения);
		ИначеЕсли ДополнительныеПараметры.Свойство("Соглашение") Тогда
			
			ПараметрыЗаполнения = Новый Структура;
			ПараметрыЗаполнения.Вставить("Дата", ДополнительныеПараметры.Дата);
			ПараметрыЗаполнения.Вставить("Валюта", ДополнительныеПараметры.Валюта);
			ПараметрыЗаполнения.Вставить("Соглашение", ДополнительныеПараметры.Соглашение);
			ПараметрыЗаполнения.Вставить("РассчитыватьНаборы", Истина);
			ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, ВидЦены");
			
			Если ДополнительныеПараметры.Свойство("Организация") И ЗначениеЗаполнено(ДополнительныеПараметры.Организация) Тогда
				ПараметрыЗаполнения.Вставить("Организация", ДополнительныеПараметры.Организация);
			КонецЕсли;
			
			
			ЦеныРассчитаны = ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(
				Комплектующие,
				Неопределено, // Массив строк или структура отбора.
				ПараметрыЗаполнения);
		КонецЕсли;
		
		Для Каждого СтрокаТЧ Из Комплектующие Цикл
			
			ПараметрыТовара = ПодборТоваровКлиентСервер.ПараметрыТовара();
			ЗаполнитьЗначенияСвойств(ПараметрыТовара, Параметры);
			
			ПараметрыТовара.Номенклатура       = СтрокаТЧ.Номенклатура;
			ПараметрыТовара.Характеристика     = СтрокаТЧ.Характеристика;
			ПараметрыТовара.Упаковка           = СтрокаТЧ.Упаковка;
			ПараметрыТовара.ТипНоменклатуры    = СтрокаТЧ.ТипНоменклатуры;
			ПараметрыТовара.ВидНоменклатуры    = СтрокаТЧ.ВидНоменклатуры;
			ПараметрыТовара.ЕдиницаИзмерения   = СтрокаТЧ.ЕдиницаИзмерения;
			ПараметрыТовара.ВидЦены            = СтрокаТЧ.ВидЦены;
			ПараметрыТовара.Цена               = СтрокаТЧ.Цена;
			ПараметрыТовара.КоличествоУпаковок = СтрокаТЧ.КоличествоУпаковок * Параметры.КоличествоУпаковок;
			ПараметрыТовара.Количество         = СтрокаТЧ.Количество * Параметры.КоличествоУпаковок;
			ПараметрыТовара.Доступно           = СтрокаТЧ.Доступно;
			ПараметрыТовара.ВНаличии           = СтрокаТЧ.ВНаличии;
			ПараметрыТовара.КоэффициентУпаковки = СтрокаТЧ.КоэффициентУпаковки;
			
			Если ПараметрыТовара.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга
				ИЛИ ПараметрыТовара.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
				ПараметрыТовара.Склад = Справочники.Склады.ПустаяСсылка();
			КонецЕсли;
			
			ПараметрыТовара.ХарактеристикиИспользуются = ?(ЗначениеЗаполнено(ПараметрыТовара.Характеристика), Истина, Ложь);
			
			ПодобранныеТовары.Добавить(ПараметрыТовара);
			
		КонецЦикла;
		
	Иначе
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами")
			И ДополнительныеПараметры.Свойство("Соглашение")
			И ЗначениеЗаполнено(ДополнительныеПараметры.Соглашение) Тогда
			
			ПараметрыРасчета = Новый Структура;
			ПараметрыРасчета.Вставить("Дата", ДополнительныеПараметры.Дата);
			ПараметрыРасчета.Вставить("Валюта", ДополнительныеПараметры.Валюта);
			ПараметрыРасчета.Вставить("Соглашение", ДополнительныеПараметры.Соглашение);
			ПараметрыРасчета.Вставить("ПоляЗаполнения", "Цена");
			
		Иначе
			
			ПараметрыРасчета = Новый Структура;
			ПараметрыРасчета.Вставить("Дата", ДополнительныеПараметры.Дата);
			ПараметрыРасчета.Вставить("Валюта", ДополнительныеПараметры.Валюта);
			ПараметрыРасчета.Вставить("ВидЦены", ДополнительныеПараметры.ВидЦены);
			ПараметрыРасчета.Вставить("ПоляЗаполнения", "Цена");
			
		КонецЕсли;
		
		КоэффициентыПропорциональностиРасчетаЦенНаборов = НаборыСервер.КоэффициентыРаспределения(
			Комплектующие.Скопировать(), ПараметрыРасчета);
		
		ОбщаяСтоимость = 0;
		Для Каждого ТекущаяСтрока Из КоэффициентыПропорциональностиРасчетаЦенНаборов Цикл
			ОбщаяСтоимость = ОбщаяСтоимость + ТекущаяСтрока.Цена;
		КонецЦикла;

		СуммаКРаспределению = ДополнительныеПараметры.Цена * Параметры.КоличествоУпаковок;
		
		СлужебнаяТЧ = Новый ТаблицаЗначений;
		СлужебнаяТЧ.Колонки.Добавить("СтрокаТЧ");
		СлужебнаяТЧ.Колонки.Добавить("НомерСтроки");
		
		Комплектующие.Сортировать("КоличествоУпаковок Убыв");
		Для Каждого ТекущаяСтрока Из Комплектующие Цикл
			
			Стоимость = КоэффициентыПропорциональностиРасчетаЦенНаборов.Найти(ТекущаяСтрока.НомерСтроки, "НомерСтроки").Цена;
			
			ПараметрыТовара = ПодборТоваровКлиентСервер.ПараметрыТовара();
			ЗаполнитьЗначенияСвойств(ПараметрыТовара, Параметры);
			
			ПараметрыТовара.Номенклатура       = ТекущаяСтрока.Номенклатура;
			ПараметрыТовара.Характеристика     = ТекущаяСтрока.Характеристика;
			ПараметрыТовара.Упаковка           = ТекущаяСтрока.Упаковка;
			ПараметрыТовара.ТипНоменклатуры    = ТекущаяСтрока.ТипНоменклатуры;
			ПараметрыТовара.ВидНоменклатуры    = ТекущаяСтрока.ВидНоменклатуры;
			ПараметрыТовара.ЕдиницаИзмерения   = ТекущаяСтрока.ЕдиницаИзмерения;
			ПараметрыТовара.КоличествоУпаковок = ТекущаяСтрока.КоличествоУпаковок * Параметры.КоличествоУпаковок;
			ПараметрыТовара.Количество         = ТекущаяСтрока.Количество * Параметры.КоличествоУпаковок;
			ПараметрыТовара.КоэффициентУпаковки = ТекущаяСтрока.КоэффициентУпаковки;
			
			Если ПараметрыТовара.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга
				ИЛИ ПараметрыТовара.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
				ПараметрыТовара.Склад = Справочники.Склады.ПустаяСсылка();
			КонецЕсли;
			
			Если ДополнительныеПараметры.Свойство("ВидЦены") Тогда
				ПараметрыТовара.ВидЦены = ДополнительныеПараметры.ВидЦены;
			Иначе
				ПараметрыТовара.ВидЦены = Справочники.ВидыЦен.ПустаяСсылка();
			КонецЕсли;
			
			Если ПараметрыТовара.КоличествоУпаковок <> 0 И ОбщаяСтоимость <> 0 Тогда
				ПараметрыТовара.Цена = Окр(((Стоимость / ОбщаяСтоимость) * СуммаКРаспределению) / ПараметрыТовара.КоличествоУпаковок, 2);
			Иначе
				ПараметрыТовара.Цена = 0;
			КонецЕсли;
			
			ОбщаяСтоимость = ОбщаяСтоимость - Стоимость;
			СуммаКРаспределению = СуммаКРаспределению - ПараметрыТовара.Цена * ПараметрыТовара.КоличествоУпаковок;
			
			ПараметрыТовара.Доступно = ТекущаяСтрока.Доступно;
			ПараметрыТовара.ВНаличии = ТекущаяСтрока.ВНаличии;
			
			ПараметрыТовара.ХарактеристикиИспользуются = ?(ЗначениеЗаполнено(ПараметрыТовара.Характеристика), Истина, Ложь);
			
			СлужебнаяСтрока = СлужебнаяТЧ.Добавить();
			СлужебнаяСтрока.СтрокаТЧ = ПараметрыТовара;
			СлужебнаяСтрока.НомерСтроки = ТекущаяСтрока.НомерСтроки;
			
		КонецЦикла;
		
		Если СуммаКРаспределению <> 0 И СлужебнаяТЧ.Количество() > 0 Тогда
			
			ПоследняяСтрока = СлужебнаяТЧ[СлужебнаяТЧ.Количество() - 1];
			ИсходнаяСтрока = ПоследняяСтрока.СтрокаТЧ;
			
			Если ИсходнаяСтрока.КоличествоУпаковок > 1 Тогда
				НоваяСтрока = ПодборТоваровКлиентСервер.ПараметрыТовара();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ИсходнаяСтрока);
				
				ИсходнаяСтрока.КоличествоУпаковок = ИсходнаяСтрока.КоличествоУпаковок - 1;
				НоваяСтрока.КоличествоУпаковок = 1;
				НоваяСтрока.Цена = НоваяСтрока.Цена + СуммаКРаспределению;
				
				СлужебнаяСтрока = СлужебнаяТЧ.Добавить();
				СлужебнаяСтрока.СтрокаТЧ = НоваяСтрока;
				СлужебнаяСтрока.НомерСтроки = ПоследняяСтрока.НомерСтроки;
				
			Иначе
				
				ИсходнаяСтрока.Погрешность = СуммаКРаспределению;
				
			КонецЕсли;
			
		КонецЕсли;
		
		СлужебнаяТЧ.Сортировать("НомерСтроки Возр");
		Для Каждого СтрокаТЧ Из СлужебнаяТЧ Цикл
			ПодобранныеТовары.Добавить(СтрокаТЧ.СтрокаТЧ);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ПодобранныеТовары;

КонецФункции

// Процедура дополняет массив строк табличной части оставшимися строками наборов,
// если указанные наборы в массиве строк представлены не полностью.
// 
// Параметры:
//  ТабличнаяЧасть - ТабличнаяЧасть - Табличная часть.
//  МассивСтрок - Массив - Строки табличной части для дополнения.
//  УчитыватьКодСтроки - Булево - Признак учета кода строки.
//
Процедура ДополнитьДоПолногоНабора(ТабличнаяЧасть, МассивСтрок, УчитыватьКодСтроки = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(ТабличнаяЧасть) Или Не ЗначениеЗаполнено(МассивСтрок)
		Или Не ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ТабличнаяЧасть[0], "НоменклатураНабора") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНоменклатура = Новый ТаблицаЗначений;
	ТаблицаНоменклатура.Колонки.Добавить("НоменклатураНабора", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаНоменклатура.Колонки.Добавить("ХарактеристикаНабора", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	Для Каждого СтрокаТЧ Из МассивСтрок Цикл
		Если ЗначениеЗаполнено(СтрокаТЧ.НоменклатураНабора) Тогда
			НоваяСтрока = ТаблицаНоменклатура.Добавить();
			НоваяСтрока.НоменклатураНабора = СтрокаТЧ.НоменклатураНабора;
			НоваяСтрока.ХарактеристикаНабора = СтрокаТЧ.ХарактеристикаНабора;
		КонецЕсли;
	КонецЦикла;
	ТаблицаНоменклатура.Свернуть("НоменклатураНабора,ХарактеристикаНабора");
	
	Если Не ЗначениеЗаполнено(ТаблицаНоменклатура) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.НоменклатураНабора,
	|	Т.ХарактеристикаНабора
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Т
	|;
	|ВЫБРАТЬ
	|	Т.НоменклатураНабора,
	|	Т.ХарактеристикаНабора,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора
	|ИЗ
	|	Таблица КАК Т
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО ВариантыКомплектацииНоменклатуры.Владелец = Т.НоменклатураНабора
	|		И ВариантыКомплектацииНоменклатуры.Характеристика = Т.ХарактеристикаНабора
	|		И ВариантыКомплектацииНоменклатуры.Основной
	|");
	
	Запрос.УстановитьПараметр("Таблица", ТаблицаНоменклатура);
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	ДобавляемыеСтроки = Новый Массив;
	Для Каждого СтрокаТЧ Из МассивСтрок Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЧ.НоменклатураНабора) Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("НоменклатураНабора", СтрокаТЧ.НоменклатураНабора);
			Отбор.Вставить("ХарактеристикаНабора", СтрокаТЧ.ХарактеристикаНабора);
			
			НайденныеСтроки = Данные.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				Если НайденныеСтроки[0].ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
					ИЛИ НайденныеСтроки[0].ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам Тогда
					НайденныеСтрокиТабличнойЧасти = ТабличнаяЧасть.НайтиСтроки(Отбор);
					Для Каждого НайденнаяСтрока Из НайденныеСтрокиТабличнойЧасти Цикл
						
						Если УчитыватьКодСтроки И НайденнаяСтрока.КодСтроки <> 0 Тогда
							Продолжить;
						КонецЕсли;
						
						Если МассивСтрок.Найти(НайденнаяСтрока) = Неопределено Тогда
							 ДобавляемыеСтроки.Добавить(НайденнаяСтрока);
						КонецЕсли;
						
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из ДобавляемыеСтроки Цикл
		МассивСтрок.Добавить(СтрокаТЧ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КолонкиНабора()
	
	Колонки = Новый Массив;
	Колонки.Добавить("НомерСтроки");
	Колонки.Добавить("НоменклатураКомплекта");
	Колонки.Добавить("ХарактеристикаКомплекта");
	Колонки.Добавить("Номенклатура");
	Колонки.Добавить("Характеристика");
	Колонки.Добавить("Цена");
	Колонки.Добавить("ВидЦены");
	Колонки.Добавить("Упаковка");
	Колонки.Добавить("Количество");
	Колонки.Добавить("КоличествоУпаковок");
	Колонки.Добавить("ПроцентРучнойСкидки");
	Колонки.Добавить("СуммаРучнойСкидки");
	Колонки.Добавить("Доступно");
	Колонки.Добавить("ВНаличии");
	
	Возврат Колонки;
	
КонецФункции

#КонецОбласти
