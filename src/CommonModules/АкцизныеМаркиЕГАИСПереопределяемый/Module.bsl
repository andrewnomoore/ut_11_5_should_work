#Область ПрограммныйИнтерфейс

// Возвращает Истина, если акцизная марка никогда раньше не продавалась. Ложь - в противном случае.
//
// Параметры:
//  Операция - Строка - текущая операция, для которой требуется осуществить контроль. Возможные значения:
//   "Продажа" - проверка пройдена, если продажи за минусом возвратов <= 0,
//   "Возврат" - проверка пройдена, если продажи за минусом возвратов >= 0,
//   "АктПостановкиНаБаланс" - проверка пройдена, если не было продаж, возвратов, актов постановок на баланс,
//   "АктСписания" - проверка пройдена, если продажи за минусом возвратов <= 0 и поставлено на баланс - списано >= 0.
//  КодАкцизнойМарки - Строка - код акцизной марки,
//  ТекстОшибки - Строка, ФорматированнаяСтрока - текст сообщения пользователю, если акцизная марка не уникальна. Выходной параметр.
Процедура ПроверитьУникальностьАкцизнойМарки(Операция, КодАкцизнойМарки, ТекстОшибки) Экспорт
	
	//++ НЕ ГОСИС
	Если Не ЗначениеЗаполнено(Операция) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Операция = "Продажа" ИЛИ Операция = "Возврат" Тогда
		Запрос = АкцизныеМаркиЕГАИСУТ.ЗапросПроверкиУникальностиПродажаВозврат(КодАкцизнойМарки, Операция);
	ИначеЕсли Операция = "АктПостановкиНаБаланс" Тогда
		Запрос = АкцизныеМаркиЕГАИСУТ.ЗапросПроверкиУникальностиАктПостановкиНаБаланс(КодАкцизнойМарки);
	ИначеЕсли Операция = "АктСписания" Тогда
		Запрос = АкцизныеМаркиЕГАИСУТ.ЗапросПроверкиУникальностиАктСписания(КодАкцизнойМарки);
	КонецЕсли;
	
	ВыборкаОбщийИтог = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаОбщийИтог.Следующий();
	
	ТекстОшибки = "";
	Если ТипЗнч(ВыборкаОбщийИтог.Количество) = Тип("Число") И ВыборкаОбщийИтог.Количество > 0 Тогда
		
		Выборка = ВыборкаОбщийИтог.Выбрать();
		Выборка.Следующий();
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru='Считанная акцизная марка была реализована ранее в документе:'"));
		МассивСтрок.Добавить(Символы.ПС);
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			ОбщегоНазначенияУТ.ПолучитьПредставлениеДокумента(Выборка.Ссылка, Выборка.Номер, Выборка.Дата),,,,
			ПолучитьНавигационнуюСсылку(Выборка.Ссылка)));
		
		ТекстОшибки = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура СлужебныеДанныеАлкогольнойПродукции(Товары, Результат) Экспорт
	
	//++ НЕ ГОСИС
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Т.НомерСтроки,
	|	Т.ИдентификаторСтроки,
	|	Т.АлкогольнаяПродукция,
	|	Т.Справка2,
	|	Т.Номенклатура,
	|	Т.Характеристика,
	|	Т.Серия,
	|	Т.Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Т
	|;
	|" + ИнтеграцияЕГАИС.ТекстЗапросаВТКоэффициентыПересчетаВЕдиницыЕГАИС("Товары", "ВТКоэффициентыПересчетаВЕдиницыЕГАИС") + "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ НоменклатураЧастичногоВыбытия
	|ИЗ
	|	Товары КАК Товары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиЧастичногоВыбытияПродукцииИС КАК НастройкиЧастичногоВыбытияПродукцииИС
	|	ПО Товары.Номенклатура = НастройкиЧастичногоВыбытияПродукцииИС.НоменклатураЧастичногоВыбытия
	|		И Товары.Характеристика = НастройкиЧастичногоВыбытияПродукцииИС.ХарактеристикаЧастичногоВыбытия
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки          КАК НомерСтроки,
	|	Товары.ИдентификаторСтроки  КАК ИдентификаторСтроки,
	|	Товары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	Товары.Справка2             КАК Справка2,
	|	Товары.Номенклатура         КАК Номенклатура,
	|	Товары.Характеристика       КАК Характеристика,
	|	Товары.Серия                КАК Серия,
	|	Товары.Количество           КАК Количество,
	|	0                           КАК КоличествоАкцизныхМарок,
	|	0                           КАК КоличествоПродукцииПоАкцизнымМаркам,
	|	ЕСТЬNULL(Товары.Справка2.Поштучная, ЛОЖЬ) КАК ПомарочныйУчет,
	|	ВЫБОР
	|		КОГДА Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			И Товары.АлкогольнаяПродукция = ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
	|			ТОГДА ВЫБОР
	|				КОГДА Товары.Номенклатура.АлкогольнаяПродукцияВоВскрытойТаре
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ
	|					ЕСТЬNULL(Товары.Номенклатура.ВидАлкогольнойПродукции.Маркируемый, ЛОЖЬ)
	|			КОНЕЦ
	|		ИНАЧЕ
	|			ЕСТЬNULL(Товары.АлкогольнаяПродукция.ВидПродукции.Маркируемый, ЛОЖЬ)
	|	КОНЕЦ КАК МаркируемаяПродукция,
	|	ЕСТЬNULL(Товары.АлкогольнаяПродукция.ТипПродукции, ЗНАЧЕНИЕ(Перечисление.ТипыПродукцииЕГАИС.Неупакованная)) КАК ТипПродукции,
	|	ЕСТЬNULL(ОписаниеНоменклатурыИС.КоличествоВПотребительскойУпаковке, 1) КАК КоличествоВПотребительскойУпаковке,
	|	ЕСТЬNULL(ОписаниеНоменклатурыИС.ВариантЧастичногоВыбытия, НЕОПРЕДЕЛЕНО) КАК ВариантЧастичногоВыбытия,
	|	ЕСТЬNULL(ОписаниеНоменклатурыИС.УпаковкаЧастичногоВыбытия, НЕОПРЕДЕЛЕНО) КАК УпаковкаЧастичногоВыбытия,
	|	ЕСТЬNULL(ОписаниеНоменклатурыИС.ПотребительскаяУпаковка, НЕОПРЕДЕЛЕНО) КАК ПотребительскаяУпаковка,
	|	НЕ НоменклатураЧастичногоВыбытия.Номенклатура ЕСТЬ NULL КАК ЭтоНоменклатураЧастичногоВыбытия,
	|	ЕСТЬNULL(ЕдиницыЕГАИС.ОбъемДАЛ, 0) КАК ОбъемДАЛ
	|ИЗ
	|	Товары КАК Товары
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОписаниеНоменклатурыИС КАК ОписаниеНоменклатурыИС
	|	ПО Товары.Номенклатура = ОписаниеНоменклатурыИС.Номенклатура
	|	ЛЕВОЕ СОЕДИНЕНИЕ НоменклатураЧастичногоВыбытия КАК НоменклатураЧастичногоВыбытия
	|	ПО Товары.Номенклатура = НоменклатураЧастичногоВыбытия.Номенклатура
	|		И Товары.Характеристика = НоменклатураЧастичногоВыбытия.Характеристика
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТКоэффициентыПересчетаВЕдиницыЕГАИС КАК ЕдиницыЕГАИС
	|	ПО ЕдиницыЕГАИС.АлкогольнаяПродукция = Товары.АлкогольнаяПродукция
	|		И Товары.Номенклатура = ЕдиницыЕГАИС.Номенклатура
	|		И Товары.Характеристика = ЕдиницыЕГАИС.Характеристика
	|		И Товары.Серия = ЕдиницыЕГАИС.Серия";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.Параметры.Вставить("Товары", Товары);
	
	Результат = Запрос.Выполнить().Выгрузить();
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Определяет, является ли номенклатура алкогольной маркируемой продукцией.
//
// Параметры:
//  Маркируемая  - Булево - признак маркируемой продукции (Истина если является)
//  Номенклатура - ОпределяемыйТип.Номенклатура - номенклатура.
Процедура ЗаполнитьПризнакМаркируемойПродукции(Маркируемая, Номенклатура) Экспорт
	
	//++ НЕ ГОСИС
	Маркируемая = Ложь;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ВидыАлкогольнойПродукции.Маркируемый, ЛОЖЬ) КАК Маркируемый
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО Номенклатура.ВидАлкогольнойПродукции = ВидыАлкогольнойПродукции.Ссылка
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|");
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Маркируемая = Выборка.Маркируемый;
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти