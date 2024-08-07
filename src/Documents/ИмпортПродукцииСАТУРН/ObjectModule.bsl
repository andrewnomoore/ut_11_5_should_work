
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура")Тогда
	
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ИмпортируемаяПартияСАТУРН")
		ИЛИ (ТипДанныхЗаполнения = Тип("Массив")
		И ДанныеЗаполнения.Количество()
		И ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.ИмпортируемаяПартияСАТУРН"))Тогда 
		
		ЗаполнитьИмпортПродукцииПоДаннымПартииСАТУРН(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнтеграцияСАТУРНПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Серия");
	
	ИнтеграцияСАТУРНПереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.ИмпортируемаяПартия) Тогда
			
			СтрокаТабличнойЧасти.Идентификатор = "";
			
		Иначе
			
			СтрокаТабличнойЧасти.Идентификатор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.ИмпортируемаяПартия, "Идентификатор");
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИнтеграцияСАТУРН.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияСАТУРН.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
		
		СтрокаТабличнойЧасти.Идентификатор       = "";
		СтрокаТабличнойЧасти.ИмпортируемаяПартия = Справочники.ИмпортируемаяПартияСАТУРН.ПустаяСсылка();
		СтрокаТабличнойЧасти.Партия        = Справочники.ПартииСАТУРН.ПустаяСсылка();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ИмпортПродукцииСАТУРН.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиПартийСАТУРН.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	РегистрыСведений.МестаХраненияПартийСАТУРН.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеСАТУРН.ДанныеЗаполненияИмпортПродукцииСАТУРН(ОрганизацияСАТУРН);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеСАТУРН.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьИмпортПродукцииПоДаннымПартииСАТУРН(ДанныеЗаполнения, ДополнитьДокумент = Ложь)

	РезультатДанныеИмпортныхПартий = ДанныеИмпортныхПартий(ДанныеЗаполнения);
	
	ДанныеШапки = РезультатДанныеИмпортныхПартий.ДанныеШапки;
	ДанныеТЧ    = РезультатДанныеИмпортныхПартий.ДанныеПартий;
	
	Если ДанныеШапки.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеШапки);
		
	КонецЕсли;
	
	Товары.Очистить();
	
	Пока ДанныеТЧ.Следующий() Цикл
		
		НоваяСтрокаТоваров = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТоваров, ДанныеТЧ);
		
	КонецЦикла;
	
	ДанныеУпаковок = ИнтеграцияИСВызовСервера.КоэффициентВесОбъемУпаковок(Товары);
	
	Для Каждого Строка Из Товары Цикл
		
		Если Не ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеУпаковки = ИнтеграцияИСКлиентСервер.ПолучитьДанныеУпаковки(
			ДанныеУпаковок, Строка.Номенклатура, Строка.Упаковка);
		
		Если Строка.ТипИзмеряемойВеличиныСАТУРН = Перечисления.ТипыИзмеряемыхВеличинСАТУРН.Вес Тогда
			Коэффициент = ДанныеУпаковки.Вес;
		ИначеЕсли Строка.ТипИзмеряемойВеличиныСАТУРН = Перечисления.ТипыИзмеряемыхВеличинСАТУРН.Объем Тогда
			Коэффициент = ДанныеУпаковки.Объем;
		Иначе
			Коэффициент = 0;
		КонецЕсли;
			
		Строка.КоличествоУпаковок = Строка.КоличествоСАТУРН * Коэффициент;
		Строка.Количество = Строка.КоличествоУпаковок;
		
	КонецЦикла;

КонецПроцедуры

Функция ДанныеИмпортныхПартий(МассивИмпортныхПартий)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивИмпортныхПартий);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоответствиеНоменклатуры.ПАТ КАК ПАТ,
	|	МАКСИМУМ(СоответствиеНоменклатуры.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(СоответствиеНоменклатуры.Характеристика) КАК Характеристика
	|ПОМЕСТИТЬ СоответствиеНоменклатуры
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатуры
	|ГДЕ СоответствиеНоменклатуры.ПАТ В (
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ ПАТ
	|	ИЗ Справочник.ИмпортируемаяПартияСАТУРН
	|	ГДЕ Ссылка В (&МассивСсылок))
	|СГРУППИРОВАТЬ ПО
	|	СоответствиеНоменклатуры.ПАТ
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Номенклатура) = 1
	|	И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Характеристика) = 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИмпортируемаяПартияСАТУРН.ОрганизацияСАТУРН КАК ОрганизацияСАТУРН,
	|	ИмпортируемаяПартияСАТУРН.МестоХранения     КАК МестоХранения,
	|	ИмпортируемаяПартияСАТУРН.ДатаПолучения     КАК ДатаПолучения,
	|	ИмпортируемаяПартияСАТУРН.НомерТТНАРГУС     КАК НомерТТНАРГУС
	|ИЗ
	|	Справочник.ИмпортируемаяПартияСАТУРН КАК ИмпортируемаяПартияСАТУРН
	|ГДЕ
	|	ИмпортируемаяПартияСАТУРН.Ссылка В (&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИмпортируемаяПартияСАТУРН.Ссылка                          КАК ИмпортируемаяПартия,
	|	ИмпортируемаяПартияСАТУРН.ПАТ                             КАК ПАТ,
	|	ИмпортируемаяПартияСАТУРН.КоличествоУпаковок
	|		* ИмпортируемаяПартияСАТУРН.КоличествоВУпаковкеСАТУРН КАК КоличествоСАТУРН,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличинСАТУРН.Вес)    КАК ТипИзмеряемойВеличиныСАТУРН,
	|	ИмпортируемаяПартияСАТУРН.Идентификатор                   КАК Идентификатор,
	|	СоответствиеНоменклатуры.Номенклатура                     КАК Номенклатура,
	|	СоответствиеНоменклатуры.Характеристика                   КАК Характеристика
	|ИЗ
	|	Справочник.ИмпортируемаяПартияСАТУРН КАК ИмпортируемаяПартияСАТУРН
	|		ЛЕВОЕ СОЕДИНЕНИЕ СоответствиеНоменклатуры КАК СоответствиеНоменклатуры
	|		ПО ИмпортируемаяПартияСАТУРН.ПАТ = СоответствиеНоменклатуры.ПАТ
	|ГДЕ
	|	ИмпортируемаяПартияСАТУРН.Ссылка В (&МассивСсылок)";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВГраница = РезультатЗапроса.ВГраница();
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДанныеШапки",  РезультатЗапроса[ВГраница-1].Выбрать());
	СтруктураВозврата.Вставить("ДанныеПартий", РезультатЗапроса[ВГраница].Выбрать());
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
