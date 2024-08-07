
#Область ПрограммныйИнтерфейс

// Зарегистрировать изменения справочника
//
// Параметры:
//  Источник - СправочникОбъект.ПодключаемоеОборудование,
//             СправочникОбъект.УпаковкиЕдиницыИзмерения,
//             СправочникОбъект.ХарактеристикиНоменклатуры,
//             СправочникОбъект.Номенклатура, СправочникОбъект.ВидыНоменклатуры - Источник.
//  Отказ - Булево - Признак отказа.
//
Процедура ЗарегистрироватьИзмененияСправочника(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("СправочникОбъект.Номенклатура") Тогда
		
		Запрос = Новый Запрос;
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.НаименованиеПолное <> &ЗначениеНаименованиеПолное)
		|";
	
	//++ Локализация
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОфлайнОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.НаименованиеПолное <> &ЗначениеНаименованиеПолное)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.НаименованиеПолное <> &ЗначениеНаименованиеПолное)
		|";
	//-- Локализация
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("ЗначениеНаименованиеПолное", Источник.НаименованиеПолное);
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ХарактеристикиНоменклатуры") Тогда
		
		Запрос = Новый Запрос;
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Характеристика.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Характеристика.НаименованиеПолное <> &ЗначениеНаименованиеПолное)";
		
	//++ Локализация
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОфлайнОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Характеристика.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Характеристика.НаименованиеПолное <> &ЗначениеНаименованиеПолное)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Характеристика.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Характеристика.НаименованиеПолное <> &ЗначениеНаименованиеПолное)";
	//-- Локализация
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("ЗначениеНаименованиеПолное", Источник.НаименованиеПолное);
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.УпаковкиЕдиницыИзмерения") Тогда
		
		Запрос = Новый Запрос;
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = &Значение
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка.Наименование <> &ЗначениеНаименование";

	//++ Локализация
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОфлайнОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = &Значение
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка.Наименование <> &ЗначениеНаименование
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = &Значение
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка.Наименование <> &ЗначениеНаименование";
	//-- Локализация
		
		Запрос.Текст = ТекстЗапроса;
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ВидыНоменклатуры") Тогда
		
		Запрос = Новый Запрос;
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.ВидНоменклатуры = &Значение";
		
	//++ Локализация
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОфлайнОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.ВидНоменклатуры = &Значение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.ВидНоменклатуры = &Значение";
	//-- Локализация
		
		Запрос.Текст = ТекстЗапроса;
	
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ПодключаемоеОборудование") 
			И ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
			И ЗначениеЗаполнено(Источник.ПравилоОбмена)
			И Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
				
		ИсточникСсылкаПравилоОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка,
													Метаданные.Справочники.ПодключаемоеОборудование.Реквизиты.ПравилоОбмена.Имя);
		
		Если Источник.ПравилоОбмена <> ИсточникСсылкаПравилоОбмена Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(Источник.УзелИнформационнойБазы);
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
			|	КодыТоваровПодключаемогоОборудованияOffline.Код           КАК Код,
			|	&УзелИнформационнойБазы                                   КАК УзелИнформационнойБазы
			|ИЗ
			|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
			|ГДЕ
			|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = &ПравилоОбмена");
			
			Запрос.УстановитьПараметр("ПравилоОбмена", Источник.ПравилоОбмена);
			Запрос.УстановитьПараметр("УзелИнформационнойБазы", Источник.УзелИнформационнойБазы);
		Иначе
			Возврат;
		КонецЕсли;

//++ Локализация
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ОфлайнОборудование") 
			И ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
			И ЗначениеЗаполнено(Источник.ПравилоОбмена)
			И Источник.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ККМ Тогда
			
		ИсточникСсылкаПравилоОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка,
													Метаданные.Справочники.ОфлайнОборудование.Реквизиты.ПравилоОбмена.Имя);
		
		Если Источник.ПравилоОбмена <> ИсточникСсылкаПравилоОбмена Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(Источник.УзелИнформационнойБазы);
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
			|	КодыТоваровПодключаемогоОборудованияOffline.Код           КАК Код,
			|	&УзелИнформационнойБазы                                   КАК УзелИнформационнойБазы
			|ИЗ
			|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
			|ГДЕ
			|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = &ПравилоОбмена");
			
			Запрос.УстановитьПараметр("ПравилоОбмена", Источник.ПравилоОбмена);
			Запрос.УстановитьПараметр("УзелИнформационнойБазы", Источник.УзелИнформационнойБазы);
		Иначе
			Возврат;
		КонецЕсли;
		
//-- Локализация
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Значение",             Источник.Ссылка);
	Запрос.УстановитьПараметр("ЗначениеНаименование", Источник.Наименование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.Код.Значение = Выборка.Код;
		Набор.Отбор.Код.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

// Зарегистрировать изменения документа
//
// Параметры:
//  Источник - ДокументОбъект.УстановкаЦенНоменклатуры - Источник.
//  Отказ - Булево - Признак отказа.
//  РежимЗаписи - РежимЗаписиДокумента.
//  РежимПроведения - РежимПроведенияДокумента.
//
Процедура ЗарегистрироватьИзмененияДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("ДокументОбъект.УстановкаЦенНоменклатуры") Тогда
		
		Запрос = Новый Запрос;
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = УстановкаЦенНоменклатурыТовары.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = УстановкаЦенНоменклатурыТовары.Характеристика
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И УстановкаЦенНоменклатурыТовары.Ссылка = &Значение";
	
	//++ Локализация
		ТекстЗапроса = "ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОфлайнОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = УстановкаЦенНоменклатурыТовары.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = УстановкаЦенНоменклатурыТовары.Характеристика
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И УстановкаЦенНоменклатурыТовары.Ссылка = &Значение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = УстановкаЦенНоменклатурыТовары.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = УстановкаЦенНоменклатурыТовары.Характеристика
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И НЕ ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И УстановкаЦенНоменклатурыТовары.Ссылка = &Значение";
	//-- Локализация
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Значение", Источник.Ссылка);
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.Код.Значение = Выборка.Код;
		Набор.Отбор.Код.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

// Зарегистрировать изменения регистра сведений
//
// Параметры:
//  Источник - РегистрСведенийНаборЗаписей.ЦеныНоменклатуры, РегистрСведенийНаборЗаписей.ШтрихкодыНоменклатуры - Источник.
//  Отказ - Булево - Признак отказа.
//  Замещение - Булево.
//
Процедура ЗарегистрироватьИзмененияРегистраСведений(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ШтрихкодыНоменклатуры") Тогда
		
		Запрос = Новый Запрос;
		
		ТекстЗапроса  ="ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = ШтрихкодыНоменклатуры.Характеристика
		|			И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = ШтрихкодыНоменклатуры.Упаковка
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И ШтрихкодыНоменклатуры.Штрихкод = &Значение";
		
	//++ Локализация
		ТекстЗапроса  ="ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОфлайнОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = ШтрихкодыНоменклатуры.Характеристика
		|			И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = ШтрихкодыНоменклатуры.Упаковка
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И ШтрихкодыНоменклатуры.Штрихкод = &Значение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = ШтрихкодыНоменклатуры.Характеристика
		|			И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = ШтрихкодыНоменклатуры.Упаковка
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И ШтрихкодыНоменклатуры.Штрихкод = &Значение";
	//-- Локализация
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Значение", Источник.Отбор.Штрихкод.Значение);
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.Код.Значение = Выборка.Код;
		Набор.Отбор.Код.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

// Создать узел обмена с подключаемым оборудованием offline
//
// Параметры:
//  Источник - СправочникОбъект.ПодключаемоеОборудование - Источник.
//  Отказ - Булево - Признак отказа.
//
Процедура СоздатьУзелОбменаСПодключаемымОборудованиемOffline(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Источник.УзелИнформационнойБазы) Тогда
		Если ТипЗнч(Источник) = Тип("СправочникОбъект.ПодключаемоеОборудование")
				И Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
			Источник.УзелИнформационнойБазы = ПолучитьУзелРИБ(Источник);
			
	//++ Локализация
		ИначеЕсли (ТипЗнч(Источник) = Тип("СправочникОбъект.ОфлайнОборудование")
				И Источник.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ККМ) Тогда
			Источник.УзелИнформационнойБазы = ПолучитьУзелРИБ(Источник);
	//-- Локализация
		Конецесли;
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить(
		"ИзмененоПравилоОбмена", 
		Источник.ПравилоОбмена <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПравилоОбмена"));
	
КонецПроцедуры

// Очистить узел обмена с подключаемым оборудованием offline.
//
// Параметры:
//  Источник - СправочникОбъект.ПодключаемоеОборудование - Источник.
//  ОбъектКопирования - СправочникОбъект.ПодключаемоеОборудование - Объект копирования.
//
Процедура ОчиститьУзелОбменаСПодключаемымОборудованиемOffline(Источник, ОбъектКопирования) Экспорт
	
	Источник.УзелИнформационнойБазы = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка();
	
КонецПроцедуры

// Зарегистрировать изменения при смене правила обмена подключаемого оборудования.
//
// Параметры:
//  Источник - СправочникОбъект.ПодключаемоеОборудование - Источник.
//  Отказ - Булево - Отказ.
//
Процедура ЗарегистрироватьИзмененияПриСменеПравилаОбменаПодключаемогоОборудования(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("СправочникОбъект.ПодключаемоеОборудование")
		И Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток
		И Источник.ДополнительныеСвойства.ИзмененоПравилоОбмена Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ПланыОбмена.ЗарегистрироватьИзменения(Источник.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline);
		
//++ Локализация
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.ОфлайнОборудование")
			И Источник.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ККМ
			И Источник.ДополнительныеСвойства.ИзмененоПравилоОбмена Тогда
	
		УстановитьПривилегированныйРежим(Истина);
		ПланыОбмена.ЗарегистрироватьИзменения(Источник.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline);
		
//-- Локализация
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция создает узел для данного экземпляра подключаемого оборудования и возвращает ссылку на него
// Применяется перед записью элемента справочника Подключаемое оборудование.
//
// Параметры:
//  ПодключаемоеОборудованиеОбъект - СправочникОбъект.ПодключаемоеОборудование - Ссылка на экземпляр подключаемого оборудования.
// 
// Возвращаемое значение:
//   ПланОбменаСсылка.ОбменСПодключаемымОборудованиемOffline - Возвращает узел для данного экземпляра подключаемого оборудования.
//
Функция ПолучитьУзелРИБ(ПодключаемоеОборудованиеОбъект)
	
	УзелОбъект = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.СоздатьУзел();
	УзелОбъект.УстановитьНовыйКод();
	УзелОбъект.Наименование = ПодключаемоеОборудованиеОбъект.Наименование;
	УзелОбъект.Записать();
	
	Возврат УзелОбъект.Ссылка;
	
КонецФункции

#КонецОбласти