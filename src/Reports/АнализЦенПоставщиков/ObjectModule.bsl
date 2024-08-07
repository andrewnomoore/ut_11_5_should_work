#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	
	Если ПараметрВалюта <> Неопределено И Не ПараметрВалюта.Использование Тогда
		ПараметрВалюта.Использование = Истина;
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	ПараметрДокумент = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ФиксированныеНастройки, "Документ");
	ЗначениеПараметраДокумент = ПараметрДокумент.Значение;
	
	ТипДокумента = ТипЗнч(ЗначениеПараметраДокумент);
	
	Если ТипДокумента = Тип("СписокЗначений") Тогда
		Если ЗначениеПараметраДокумент.Количество() = 0 Тогда
			
			ПараметрДокумент          = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.Настройки, "Документ");
			ЗначениеПараметраДокумент = ПараметрДокумент.Значение;
			ТипДокумента              = ТипЗнч(ЗначениеПараметраДокумент);
			
			Если ТипДокумента = Тип("СписокЗначений") Тогда
				Если ЗначениеПараметраДокумент.Количество() = 0 Тогда
					ВывестиРезультатКонтроляКонтекстногоОткрытия(ДокументРезультат);
					
					Возврат;
				Иначе
					ТипДокумента = ТипЗнч(ЗначениеПараметраДокумент[0].Значение);
					ПриКомпоновкеРезультатаФрагмент(ТипДокумента, СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки, ДокументРезультат);
	
				КонецЕсли;
			КонецЕсли;
		Иначе
			ТипДокумента = ТипЗнч(ЗначениеПараметраДокумент[0].Значение);
			ПриКомпоновкеРезультатаФрагмент(ТипДокумента, СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки, ДокументРезультат);
	
		КонецЕсли;
	КонецЕсли;
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Документ", Параметры.ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриКомпоновкеРезультатаФрагмент(ТипДокумента, СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки, ДокументРезультат)
	
	ТекстЗапросаЗамена = "";
	
	Если ТипДокумента = Тип("СправочникСсылка.СделкиСКлиентами") Тогда
		
		ТекстЗапросаЗамена = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КоммерческоеПредложениеТовары.Ссылка.Сделка              КАК Ссылка,
		|	КоммерческоеПредложениеТовары.Ссылка                     КАК Документ,
		|	КоммерческоеПредложениеТовары.Ссылка.Дата                КАК Дата,
		|	КоммерческоеПредложениеТовары.Ссылка.Валюта              КАК Валюта,
		|	КоммерческоеПредложениеТовары.НомерСтроки                КАК НомерСтроки,
		|	КоммерческоеПредложениеТовары.Номенклатура               КАК Номенклатура,
		|	КоммерческоеПредложениеТовары.Характеристика             КАК Характеристика,
		|	КоммерческоеПредложениеТовары.ЕдиницаИзмерения           КАК Упаковка,
		|	КоммерческоеПредложениеТовары.Цена                       КАК Цена,
		|	КоммерческоеПредложениеТовары.Цена - КоммерческоеПредложениеТовары.Цена *
		|	(КоммерческоеПредложениеТовары.ПроцентАвтоматическойСкидки +
		|	КоммерческоеПредложениеТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
		|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
		|ИЗ
		|	Документ.КоммерческоеПредложениеКлиенту.Товары КАК КоммерческоеПредложениеТовары
		|ГДЕ
		|	КоммерческоеПредложениеТовары.Ссылка.Сделка В(&Документ)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиентаТовары.Ссылка.Сделка  КАК Ссылка,
		|	ЗаказКлиентаТовары.Ссылка         КАК Документ,
		|	ЗаказКлиентаТовары.Ссылка.Дата    КАК Дата,
		|	ЗаказКлиентаТовары.Ссылка.Валюта  КАК Валюта,
		|	ЗаказКлиентаТовары.НомерСтроки    КАК НомерСтроки,
		|	ЗаказКлиентаТовары.Номенклатура   КАК Номенклатура,
		|	ЗаказКлиентаТовары.Характеристика КАК Характеристика,
		|	ЗаказКлиентаТовары.Упаковка       КАК Упаковка,
		|	ЗаказКлиентаТовары.Цена           КАК Цена,
		|	ЗаказКлиентаТовары.Цена - ЗаказКлиентаТовары.Цена *
		|	(ЗаказКлиентаТовары.ПроцентАвтоматическойСкидки +
		|	ЗаказКлиентаТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|ГДЕ
		|	ЗаказКлиентаТовары.Ссылка.Сделка В(&Документ)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	РеализацияТоваровУслугТовары.Ссылка.Сделка  КАК Ссылка,
		|	РеализацияТоваровУслугТовары.Ссылка         КАК Документ,
		|	РеализацияТоваровУслугТовары.Ссылка.Дата    КАК Дата,
		|	РеализацияТоваровУслугТовары.Ссылка.Валюта  КАК Валюта,
		|	РеализацияТоваровУслугТовары.НомерСтроки    КАК НомерСтроки,
		|	РеализацияТоваровУслугТовары.Номенклатура   КАК Номенклатура,
		|	РеализацияТоваровУслугТовары.Характеристика КАК Характеристика,
		|	РеализацияТоваровУслугТовары.Упаковка       КАК Упаковка,
		|	РеализацияТоваровУслугТовары.Цена           КАК Цена,
		|	РеализацияТоваровУслугТовары.Цена - РеализацияТоваровУслугТовары.Цена *
		|	(РеализацияТоваровУслугТовары.ПроцентАвтоматическойСкидки +
		|	РеализацияТоваровУслугТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|ГДЕ
		|	РеализацияТоваровУслугТовары.Ссылка.Сделка В(&Документ)
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ТекстЗапросаЗамена = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказКлиентаТовары.Ссылка         КАК Ссылка,
		|	ЗаказКлиентаТовары.Ссылка         КАК Документ,
		|	ЗаказКлиентаТовары.Ссылка.Дата    КАК Дата,
		|	ЗаказКлиентаТовары.Ссылка.Валюта  КАК Валюта,
		|	ЗаказКлиентаТовары.НомерСтроки    КАК НомерСтроки,
		|	ЗаказКлиентаТовары.Номенклатура   КАК Номенклатура,
		|	ЗаказКлиентаТовары.Характеристика КАК Характеристика,
		|	ЗаказКлиентаТовары.Упаковка       КАК Упаковка,
		|	ЗаказКлиентаТовары.Цена           КАК Цена,
		|	ЗаказКлиентаТовары.Цена - ЗаказКлиентаТовары.Цена *
		|	(ЗаказКлиентаТовары.ПроцентАвтоматическойСкидки +
		|	ЗаказКлиентаТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
		|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|ГДЕ
		|	ЗаказКлиентаТовары.Ссылка В(&Документ)
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		ТекстЗапросаЗамена = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РеализацияТоваровУслугТовары.Ссылка         КАК Ссылка,
		|	РеализацияТоваровУслугТовары.Ссылка         КАК Документ,
		|	РеализацияТоваровУслугТовары.Ссылка.Дата    КАК Дата,
		|	РеализацияТоваровУслугТовары.Ссылка.Валюта  КАК Валюта,
		|	РеализацияТоваровУслугТовары.НомерСтроки    КАК НомерСтроки,
		|	РеализацияТоваровУслугТовары.Номенклатура   КАК Номенклатура,
		|	РеализацияТоваровУслугТовары.Характеристика КАК Характеристика,
		|	РеализацияТоваровУслугТовары.Упаковка       КАК Упаковка,
		|	РеализацияТоваровУслугТовары.Цена           КАК Цена,
		|	РеализацияТоваровУслугТовары.Цена - РеализацияТоваровУслугТовары.Цена *
		|	(РеализацияТоваровУслугТовары.ПроцентАвтоматическойСкидки +
		|	РеализацияТоваровУслугТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
		|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|ГДЕ
		|	РеализацияТоваровУслугТовары.Ссылка В(&Документ)
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.АктВыполненныхРабот") Тогда
		
		ТекстЗапросаЗамена = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АктВыполненныхРаботУслуги.Ссылка         КАК Ссылка,
		|	АктВыполненныхРаботУслуги.Ссылка         КАК Документ,
		|	АктВыполненныхРаботУслуги.Ссылка.Дата    КАК Дата,
		|	АктВыполненныхРаботУслуги.Ссылка.Валюта  КАК Валюта,
		|	АктВыполненныхРаботУслуги.НомерСтроки    КАК НомерСтроки,
		|	АктВыполненныхРаботУслуги.Номенклатура   КАК Номенклатура,
		|	АктВыполненныхРаботУслуги.Характеристика КАК Характеристика,
		|	ЗНАЧЕНИЕ (Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)  КАК Упаковка,
		|	АктВыполненныхРаботУслуги.Цена           КАК Цена,
		|	АктВыполненныхРаботУслуги.Цена - АктВыполненныхРаботУслуги.Цена *
		|	(АктВыполненныхРаботУслуги.ПроцентАвтоматическойСкидки +
		|	АктВыполненныхРаботУслуги.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
		|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
		|ИЗ
		|	Документ.АктВыполненныхРабот.Услуги КАК АктВыполненныхРаботУслуги
		|ГДЕ
		|	АктВыполненныхРаботУслуги.Ссылка В(&Документ)
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ТекстЗапросаЗамена = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказПоставщикуТовары.Ссылка         КАК Ссылка,
		|	ЗаказПоставщикуТовары.Ссылка         КАК Документ,
		|	ЗаказПоставщикуТовары.Ссылка.Дата    КАК Дата,
		|	ЗаказПоставщикуТовары.Ссылка.Валюта  КАК Валюта,
		|	ЗаказПоставщикуТовары.НомерСтроки    КАК НомерСтроки,
		|	ЗаказПоставщикуТовары.Номенклатура   КАК Номенклатура,
		|	ЗаказПоставщикуТовары.Характеристика КАК Характеристика,
		|	ЗаказПоставщикуТовары.Упаковка       КАК Упаковка,
		|	ЗаказПоставщикуТовары.Цена           КАК Цена,
		|	ЗаказПоставщикуТовары.Цена - ЗаказПоставщикуТовары.Цена *
		|	ЗаказПоставщикуТовары.ПроцентРучнойСкидки / 100 КАК ЦенаСоСкидкой
		|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
		|ИЗ
		|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
		|ГДЕ
		|	ЗаказПоставщикуТовары.Ссылка В(&Документ)
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		ТекстЗапросаЗамена = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриобретениеТоваровУслугТовары.Ссылка         КАК Ссылка,
		|	ПриобретениеТоваровУслугТовары.Ссылка         КАК Документ,
		|	ПриобретениеТоваровУслугТовары.Ссылка.Дата    КАК Дата,
		|	ПриобретениеТоваровУслугТовары.Ссылка.Валюта  КАК Валюта,
		|	ПриобретениеТоваровУслугТовары.НомерСтроки    КАК НомерСтроки,
		|	ПриобретениеТоваровУслугТовары.Номенклатура   КАК Номенклатура,
		|	ПриобретениеТоваровУслугТовары.Характеристика КАК Характеристика,
		|	ПриобретениеТоваровУслугТовары.Упаковка       КАК Упаковка,
		|	ПриобретениеТоваровУслугТовары.Цена           КАК Цена,
		|	ПриобретениеТоваровУслугТовары.Цена - ПриобретениеТоваровУслугТовары.Цена *
		|	ПриобретениеТоваровУслугТовары.ПроцентРучнойСкидки / 100 КАК ЦенаСоСкидкой
		|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
		|ИЗ
		|	Документ.ПриобретениеТоваровУслуг.Товары КАК ПриобретениеТоваровУслугТовары
		|ГДЕ
		|	ПриобретениеТоваровУслугТовары.Ссылка В(&Документ)
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.КоммерческоеПредложениеКлиенту") Тогда
		
		ТекстЗапросаЗамена = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КоммерческоеПредложениеТовары.Ссылка                     КАК Ссылка,
		|	КоммерческоеПредложениеТовары.Ссылка                     КАК Документ,
		|	КоммерческоеПредложениеТовары.Ссылка.Дата                КАК Дата,
		|	КоммерческоеПредложениеТовары.Ссылка.Валюта              КАК Валюта,
		|	КоммерческоеПредложениеТовары.НомерСтроки                КАК НомерСтроки,
		|	КоммерческоеПредложениеТовары.Номенклатура               КАК Номенклатура,
		|	КоммерческоеПредложениеТовары.Характеристика             КАК Характеристика,
		|	КоммерческоеПредложениеТовары.ЕдиницаИзмерения           КАК Упаковка,
		|	КоммерческоеПредложениеТовары.Цена                       КАК Цена,
		|	КоммерческоеПредложениеТовары.Цена - КоммерческоеПредложениеТовары.Цена *
		|	(КоммерческоеПредложениеТовары.ПроцентАвтоматическойСкидки +
		|	КоммерческоеПредложениеТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
		|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
		|ИЗ
		|	Документ.КоммерческоеПредложениеКлиенту.Товары КАК КоммерческоеПредложениеТовары
		|ГДЕ
		|	КоммерческоеПредложениеТовары.Ссылка В(&Документ)
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|";
		
	КонецЕсли;
	
	ТекстЗапроса  = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
	ПозицияЗамены = СтрНайти(ТекстЗапроса, "%1");
	ДлинаСтроки   = СтрДлина(ТекстЗапроса);
	ТекстЗапроса  = Прав(ТекстЗапроса, ДлинаСтроки - ПозицияЗамены - 1);
	ТекстЗапроса  = ТекстЗапросаЗамена + ТекстЗапроса;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"&ТекстЗапросаКоэффициентУпаковки1",
	Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
	"ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
	"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"&ТекстЗапросаКоэффициентУпаковки2",
	Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
	"ДанныеДокументов.Упаковка",
	"ДанныеДокументов.Номенклатура"));
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапроса;

	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

Процедура ВывестиРезультатКонтроляКонтекстногоОткрытия(ДокументРезультат)

	ТаблицаПредупреждение = Новый ТабличныйДокумент;
	ОбластьПредупреждение = ТаблицаПредупреждение.Область(1,1,1,1);
	ТекстПредупреждения = НСтр("ru ='Отчет может быть сформирован только в контексте документов:
		| - %1,
		| - %2,
		| - %3,
		| - %4,
		| - %5,
		| - %6,
		| - %7.'");
		
	МассивСинонимов = Новый Массив;
	МетаданныеДокументы = Метаданные.Документы;
	МассивСинонимов.Добавить(МетаданныеДокументы.АктВыполненныхРабот.Синоним);
	МассивСинонимов.Добавить(МетаданныеДокументы.ЗаказКлиента.Синоним);
	МассивСинонимов.Добавить(МетаданныеДокументы.ЗаказПоставщику.Синоним);
	МассивСинонимов.Добавить(МетаданныеДокументы.КоммерческоеПредложениеКлиенту.Синоним);
	МассивСинонимов.Добавить(МетаданныеДокументы.ПриобретениеТоваровУслуг.Синоним);
	МассивСинонимов.Добавить(МетаданныеДокументы.РеализацияТоваровУслуг.Синоним);
	МассивСинонимов.Добавить(Метаданные.Справочники.СделкиСКлиентами.Синоним);
	
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ТекстПредупреждения, МассивСинонимов);
	ОбластьПредупреждение.Текст = ТекстПредупреждения;
	ОбластьПредупреждение.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
	ДокументРезультат.ВставитьОбласть(ОбластьПредупреждение, ДокументРезультат.Область(1,1,1,1), ТипСмещенияТабличногоДокумента.ПоВертикали);

КонецПроцедуры

#КонецОбласти 

#КонецЕсли