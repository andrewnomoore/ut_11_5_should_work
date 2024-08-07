#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - см. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	НастройкиОтчета = ЭтаФорма.НастройкиОтчета;
	
	Схема = ПолучитьИзВременногоХранилища(ЭтаФорма.НастройкиОтчета.АдресСхемы);
	
	ДоступныеЗначения = ДоступныеВидыОперацийИЗапросы();
	Если ДоступныеЗначения.Количество() = 2 Тогда
		Параметры.КлючВарианта =  "КонтрольОформленияТоваровВПутиИНеотфактурованныхПоставок";
	ИначеЕсли ДоступныеЗначения.Количество() = 1 Тогда
		Если ДоступныеЗначения[0].ВидОперации = "ТоварыВПути" Тогда
			Параметры.КлючВарианта =  "КонтрольОформленияТоваровВПути";
		ИначеЕсли ДоступныеЗначения[0].ВидОперации = "НеотфактурованнаяПоставка" Тогда
			Параметры.КлючВарианта =  "КонтрольОформленияНеотфактурованныхПоставок";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//   Например, если схема отчета зависит от ключа варианта или параметров отчета.
//   Чтобы изменения схемы вступили в силу следует вызывать метод ОтчетыСервер.ПодключитьСхему().
//
// Параметры:
//   Контекст - Произвольный - 
//       Параметры контекста, в котором используется отчет.
//       Используется для передачи в параметрах метода ОтчетыСервер.ПодключитьСхему().
//   КлючСхемы - Строка -
//       Идентификатор текущей схемы компоновщика настроек.
//       По умолчанию не заполнен (это означает что компоновщик инициализирован на основании основной схемы).
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже).
//       Может не использоваться если переинициализация выполняется безусловно.
//   КлючВарианта - Строка, Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных, Неопределено -
//       Настройки варианта отчета, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных, Неопределено -
//       Пользовательские настройки, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда пользовательские настройки не надо загружать (уже загружены ранее).
//
// Примеры:
// 1. Компоновщик отчета инициализируется на основании схемы из общих макетов:
//	Если КлючСхемы <> "1" Тогда
//		КлючСхемы = "1";
//		СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//	КонецЕсли;
//
// 2. Схема зависит от значения параметра, выведенного в пользовательские настройки отчета:
//	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//		ПолноеИмяОбъектаМетаданных = "";
//		Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//			Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//				ИмяПараметра = Строка(ЭлементКД.Параметр);
//				Если ИмяПараметра = "ОбъектМетаданных" Тогда
//					ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//			КлючСхемы = ПолноеИмяОбъектаМетаданных;
//			СхемаКД = Новый СхемаКомпоновкиДанных;
//			// Наполнение схемы...
//			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	// Локализация списка значений
	ДоступныеЗначения = ДоступныеЗначенияПоляВидОперации();
	
	ВидОперации = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Поля.Найти("ВидОперации");
	ВидОперации.УстановитьДоступныеЗначения(ДоступныеЗначения);
		
	ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса();
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	ПараметрПериода = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Период");
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодГраница", Новый Граница(КонецДня(ПараметрПериода.Значение), ВидГраницы.Включая));
	
	ВидыОперацийИСинонимы = ВидыОперацийИСинонимы();
	
	// Строковые литералы
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаРекомендацияОформитеПоступлениеТоваров", НСтр("ru='Оформите поступление товаров'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг", НСтр("ru='Оформите приобретение товаров и услуг'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаРекомендацияОформитеТаможеннуюДекларациюНаИмпорт", НСтр("ru='Оформите таможенную декларацию на импорт'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаРекомендацияОформитеУведомлениеОВвозеПрослеживаемыхТоваров", НСтр("ru='Оформите уведомление о ввозе ПТ'"));
		
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТоварыВПути", ВидыОперацийИСинонимы["ТоварыВПути"]);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НеотфактурованнаяПоставка", ВидыОперацийИСинонимы["НеотфактурованнаяПоставка"]);
	
КонецПроцедуры

Функция ДоступныеВидыОперацийИЗапросы()
	
	Доступные = Новый ТаблицаЗначений;
	Доступные.Колонки.Добавить("ВидОперации", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	Доступные.Колонки.Добавить("ВидОперацииСиноним", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	Доступные.Колонки.Добавить("ИмяТекстаЗапроса", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	
	ВидыОперацийИСинонимы = ВидыОперацийИСинонимы();
	
	// Отключаются комбинацией функциональных опций
	Если ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков") Тогда
		ДобавитьВидОперацииИЗапрос(Доступные, ВидыОперацийИСинонимы, "ТоварыВПути", "ТекстЗапросаТоварыВПути");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки") Тогда
		ДобавитьВидОперацииИЗапрос(Доступные, ВидыОперацийИСинонимы, "НеотфактурованнаяПоставка", "ТекстЗапросаНеотфактурованнаяПоставка");
	КонецЕсли;
	
	Возврат Доступные;
	
КонецФункции

Процедура ПодключитьЗапрос(ДинамическийТекстЗапроса, ПодключаемыйЗапрос, КоличествоПодключенныхЗапросов,
	ТекстЗапросаВременнойТаблицы = Неопределено)
	
	ТекстЗапросаВременнойТаблицы = ?(ЗначениеЗаполнено(ТекстЗапросаВременнойТаблицы),
		ТекстЗапросаВременнойТаблицы + ОбщегоНазначения.РазделительПакетаЗапросов(), "");
	
	Если КоличествоПодключенныхЗапросов = 0 Тогда
		ДинамическийТекстЗапроса = ДинамическийТекстЗапроса + ТекстЗапросаВременнойТаблицы + ПодключаемыйЗапрос;
	Иначе
		ДинамическийТекстЗапроса = ДинамическийТекстЗапроса + Символы.ПС + Символы.ПС 
			+ "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС + Символы.ПС;
			
		СтрокаПолейКомпоновки = "{ВЫБРАТЬ
			|	Номенклатура.*,
			|	Характеристика.*,
			|	Серия.*,
			|	Назначение.*}";

		ПодключаемыйЗапросПодготовка = СтрЗаменить(ПодключаемыйЗапрос, "РАЗРЕШЕННЫЕ", "");
		ПодключаемыйЗапросПодготовка = СтрЗаменить(ПодключаемыйЗапросПодготовка, СтрокаПолейКомпоновки, "");
		
		ДинамическийТекстЗапроса = ТекстЗапросаВременнойТаблицы + ДинамическийТекстЗапроса + ПодключаемыйЗапросПодготовка;
	КонецЕсли;
		
	КоличествоПодключенныхЗапросов = КоличествоПодключенныхЗапросов + 1;
КонецПроцедуры

Функция ТекстЗапросаВременнойТаблицы(ВыводитьТоварыВПути, ВыводитьНеотфактурованныеПоставки)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчетаНоменклатуры.Ссылка,
	|	АналитикаУчетаНоменклатуры.Номенклатура,
	|	АналитикаУчетаНоменклатуры.Характеристика,
	|	АналитикаУчетаНоменклатуры.Серия,
	|	АналитикаУчетаНоменклатуры.Назначение,
	|	АналитикаУчетаНоменклатуры.Договор КАК Договор,
	|	АналитикаУчетаНоменклатуры.Партнер КАК Партнер,
	|	АналитикаУчетаНоменклатуры.Контрагент КАК Контрагент
	|ПОМЕСТИТЬ КлючиАналитики
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ГДЕ
	|	АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
	|	И (&ВариантыОформленияЗакупок)
	|	И НЕ АналитикаУчетаНоменклатуры.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры.Ссылка";
	
	Условия = Новый Массив();
	Если ВыводитьТоварыВПути Тогда
		Условия.Добавить("АналитикаУчетаНоменклатуры.Договор.ВариантОформленияЗакупок = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияЗакупок.ТоварыВПути)");
	КонецЕсли;
	Если ВыводитьНеотфактурованныеПоставки Тогда
		Условия.Добавить("АналитикаУчетаНоменклатуры.Договор.ВариантОформленияЗакупок В (
		|	ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияЗакупок.НеотфактурованныеПоставкиТоваров),
		|	ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияЗакупок.НеотфактурованныеПоставкиТоваровИУслуг))");
	КонецЕсли;
	ТекстУсловий = СтрСоединить(Условия, " ИЛИ ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВариантыОформленияЗакупок", ТекстУсловий);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТоварыВПути()
	// Строковые литералы локализуются в настройках СКД отчета
	// Наборы данных - Поля - Доступные значения.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&ТоварыВПути КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА ТоварыУПартнеровОстатки.КоличествоОстаток > 0
	|			ТОГДА &СтрокаРекомендацияОформитеПоступлениеТоваров
	|		КОГДА ТоварыУПартнеровОстатки.КоличествоОстаток < 0
	|			ТОГДА &СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг
	|	КОНЕЦ КАК Рекомендация,
	|	КлючиАналитики.Номенклатура КАК Номенклатура,
	|	КлючиАналитики.Характеристика КАК Характеристика,
	|	КлючиАналитики.Серия КАК Серия,
	|	КлючиАналитики.Назначение КАК Назначение,
	|	ТоварыУПартнеровОстатки.ВидЗапасов КАК ВидЗапасов,
	|	КлючиАналитики.Партнер КАК Партнер,
	|	КлючиАналитики.Контрагент КАК Контрагент,
	|	ТоварыУПартнеровОстатки.НомерГТД КАК НомерГТД,
	|	КлючиАналитики.Договор КАК Договор,
	|	ТоварыУПартнеровОстатки.КоличествоОстаток КАК Количество
	|{ВЫБРАТЬ
	|	Номенклатура.*,
	|	Характеристика.*,
	|	Серия.*,
	|	Назначение.*}
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(
	|		&ПериодГраница, АналитикаУчетаНоменклатуры В (
	|		ВЫБРАТЬ
	|			Ключи.Ссылка
	|		ИЗ
	|			КлючиАналитики КАК Ключи
	|		)) КАК ТоварыУПартнеровОстатки
	|	ЛЕВОЕ СОЕДИНЕНИЕ КлючиАналитики КАК КлючиАналитики
	|	ПО КлючиАналитики.Ссылка = ТоварыУПартнеровОстатки.АналитикаУчетаНоменклатуры
	|ГДЕ
	|	ТоварыУПартнеровОстатки.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.СобственныйТоварВПути)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ТоварыВПути КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА ТоварыКОформлениюДокументовИмпортаОстатки.КоличествоОстаток > 0
	|			ТОГДА ВЫБОР 
	|					КОГДА ТипДокументаИмпорта = &ТипДокументаИмпорта 
	|						ТОГДА &СтрокаРекомендацияОформитеТаможеннуюДекларациюНаИмпорт
	|						ИНАЧЕ &СтрокаРекомендацияОформитеУведомлениеОВвозеПрослеживаемыхТоваров 
	|					КОНЕЦ	
	|		КОГДА ТоварыКОформлениюДокументовИмпортаОстатки.КоличествоОстаток < 0
	|			ТОГДА &СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг
	|	КОНЕЦ,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Характеристика,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Серия,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Назначение,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.ВидЗапасов,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.Поставщик,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюДокументовИмпорта.Остатки(
	|		&ПериодГраница, ) КАК ТоварыКОформлениюДокументовИмпортаОстатки
	|ГДЕ
	|	ТоварыКОформлениюДокументовИмпортаОстатки.ДокументПоступления.ХозяйственнаяОперация В
	|		(
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути)
	|		)";
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстЗапросаНеотфактурованнаяПоставка()
	// Строковые литералы локализуются в настройках СКД отчета
	// Наборы данных - Поля - Доступные значения.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&НеотфактурованнаяПоставка КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА ТоварыУПартнеровОстатки.КоличествоОстаток < 0
	|			ТОГДА &СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг
	|		КОГДА ТоварыУПартнеровОстатки.КоличествоОстаток > 0
	|			ТОГДА &СтрокаРекомендацияОформитеПоступлениеТоваров
	|	КОНЕЦ КАК Рекомендация,
	|	КлючиАналитики.Номенклатура КАК Номенклатура,
	|	КлючиАналитики.Характеристика КАК Характеристика,
	|	КлючиАналитики.Серия КАК Серия,
	|	КлючиАналитики.Назначение КАК Назначение,
	|	ТоварыУПартнеровОстатки.ВидЗапасов КАК ВидЗапасов,
	|	КлючиАналитики.Партнер КАК Партнер,
	|	КлючиАналитики.Контрагент КАК Контрагент,
	|	ТоварыУПартнеровОстатки.НомерГТД КАК НомерГТД,
	|	КлючиАналитики.Договор КАК Договор,
	|	ТоварыУПартнеровОстатки.КоличествоОстаток КАК Количество
	|{ВЫБРАТЬ
	|	Номенклатура.*,
	|	Характеристика.*,
	|	Серия.*,
	|	Назначение.*}
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(
	|		&ПериодГраница, АналитикаУчетаНоменклатуры В (
	|		ВЫБРАТЬ
	|			Ключи.Ссылка
	|		ИЗ
	|			КлючиАналитики КАК Ключи
	|		)) КАК ТоварыУПартнеровОстатки
	|	ЛЕВОЕ СОЕДИНЕНИЕ КлючиАналитики КАК КлючиАналитики
	|	ПО КлючиАналитики.Ссылка = ТоварыУПартнеровОстатки.АналитикаУчетаНоменклатуры
	|ГДЕ
	|	ТоварыУПартнеровОстатки.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.СобственныйТоварПоНеотфактурованнойПоставке)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&НеотфактурованнаяПоставка КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА ТоварыКОформлениюДокументовИмпортаОстатки.КоличествоОстаток > 0
	|			ТОГДА  
	|					&СтрокаРекомендацияОформитеУведомлениеОВвозеПрослеживаемыхТоваров
	|	КОНЕЦ,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Характеристика,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Серия,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.АналитикаУчетаНоменклатуры.Назначение,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.ВидЗапасов,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.Поставщик,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ТоварыКОформлениюДокументовИмпортаОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюДокументовИмпорта.Остатки(
	|		&ПериодГраница, ) КАК ТоварыКОформлениюДокументовИмпортаОстатки
	|ГДЕ
	|	ТоварыКОформлениюДокументовИмпортаОстатки.ДокументПоступления.ХозяйственнаяОперация В
	|		(
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки)
	|)
	|	И ТоварыКОформлениюДокументовИмпортаОстатки.КоличествоОстаток > 0";
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ДоступныеЗначенияПоляВидОперации()
	
	ДоступныеВидыОперацийИЗапросы = ДоступныеВидыОперацийИЗапросы();
	ДоступныеЗначения = Новый СписокЗначений;
	
	ДоступныеЗначения.ЗагрузитьЗначения(ДоступныеВидыОперацийИЗапросы.ВыгрузитьКолонку("ВидОперацииСиноним"));
	Для Каждого ДоступноеЗначение Из ДоступныеЗначения Цикл 
		ДоступноеЗначение.Представление = ДоступноеЗначение.Значение;
	КонецЦикла;
	
	Возврат ДоступныеЗначения;
КонецФункции

Процедура ДобавитьВидОперацииИЗапрос(Таблица, ВидыОперацийИСинонимы, ВидОперации, ИмяТекстаЗапроса)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.ВидОперации = ВидОперации;
	НоваяСтрока.ВидОперацииСиноним = ВидыОперацийИСинонимы[ВидОперации];
	НоваяСтрока.ИмяТекстаЗапроса = ИмяТекстаЗапроса;
	
КонецПроцедуры

Функция ВидыОперацийИСинонимы()
	
	ВидыОперацийИСинонимы = Новый Соответствие;
	
	ВидыОперацийИСинонимы.Вставить("ТоварыВПути", НСтр("ru='Товары в пути'"));
	ВидыОперацийИСинонимы.Вставить("НеотфактурованнаяПоставка", НСтр("ru='Неотфактурованная поставка'"));
	
	Возврат ВидыОперацийИСинонимы;
	
КонецФункции

Функция ТекстЗапроса()
	КоличествоПодключенныхЗапросов = 0;
	ТекстЗапроса = "";
	
	Доступные = ДоступныеВидыОперацийИЗапросы();
	ТекстыЗапроса = Новый Структура; 
	Для Каждого Доступный Из Доступные Цикл 
		ТекстыЗапроса.Вставить(Доступный.ИмяТекстаЗапроса, Истина);
	КонецЦикла;
	
	ВыводитьТоварыВПути = ТекстыЗапроса.Свойство("ТекстЗапросаТоварыВПути");
	ВыводитьНеотфактурованныеПоставки = ТекстыЗапроса.Свойство("ТекстЗапросаНеотфактурованнаяПоставка");
	
	Если ВыводитьТоварыВПути
		Или ВыводитьНеотфактурованныеПоставки Тогда
		ТекстЗапросаВременнойТаблицы = ТекстЗапросаВременнойТаблицы(ВыводитьТоварыВПути, ВыводитьНеотфактурованныеПоставки);
		ПодключитьЗапрос(ТекстЗапроса, "", 0, ТекстЗапросаВременнойТаблицы);
	КонецЕсли;
	
	Если ВыводитьТоварыВПути Тогда
		ПодключитьЗапрос(ТекстЗапроса, ТекстЗапросаТоварыВПути(), КоличествоПодключенныхЗапросов);
	КонецЕсли;
	
	Если ВыводитьНеотфактурованныеПоставки Тогда
		ПодключитьЗапрос(ТекстЗапроса, ТекстЗапросаНеотфактурованнаяПоставка(), КоличествоПодключенныхЗапросов);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
КонецФункции

#КонецОбласти

#КонецЕсли