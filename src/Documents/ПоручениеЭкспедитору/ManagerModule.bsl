#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает текст запроса для определения реквизитов доставки.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстЗапросаРеквизитыДоставки() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Шапка.Номер             КАК Номер,
	|	Шапка.Проведен          КАК Проведен,
	|	Шапка.Ссылка            КАК Ссылка,
	|	Шапка.ДатаВыполнения    КАК Дата,
	|
	|	Шапка.Пункт
	|                           КАК ПолучательОтправитель,
	|
	|	НЕОПРЕДЕЛЕНО            КАК Перевозчик,
	|	Шапка.СпособДоставки    КАК СпособДоставки,
	|	Шапка.ЗонаДоставки      КАК Зона,
	|	Шапка.АдресДоставки     КАК Адрес,
	|
	|	Шапка.АдресДоставкиЗначенияПолей
	|		                    КАК АдресЗначенияПолей,
	|
	|	Шапка.ВремяДоставкиС    КАК ВремяС,
	|	Шапка.ВремяДоставкиПо   КАК ВремяПо,
	|	ДополнительнаяИнформацияПоДоставке КАК ДополнительнаяИнформация,
	|	Шапка.Склад             КАК Склад,
	|	ИСТИНА                  КАК ДоставитьПолностью,
	|	ИСТИНА                  КАК ОсобыеУсловияПеревозки,
	|	Шапка.ОсобыеУсловияПеревозкиОписание КАК ОсобыеУсловияПеревозкиОписание,
	|	ЛОЖЬ КАК РазбиватьРасходныеОрдераПоРаспоряжениям
	|
	|ИЗ
	|	Документ.ПоручениеЭкспедитору КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка В (&Ссылки)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Функция извлекает из оснований данные для заполнения поручения.
//
// Параметры:
//  Основания	 - Массив	 - основания для ввода поручений экспедитору.
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//  *Склады - Массив - СправочникСсылка.Склады
//  *Пункты - Массив - СправочникСсылка.Партнеры или СправочникСсылка.Склады или СправочникСсылка.СтруктураПредприятия
//  *Контакты - Массив - СправочникСсылка.КонтактныеЛицаПартнеров.
//
Функция ДанныеОснований(Основания) Экспорт
	
	ШаблонЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|ЗНАЧЕНИЕ(Справочник.КонтактныеЛицаПартнеров.ПустаяСсылка) КАК КонтактноеЛицо
	|ПОМЕСТИТЬ ДанныеОснований
	|ИЗ #ТаблицаДокумента КАК Т
	|
	|ГДЕ Т.Ссылка В (&Основания)";
	
	ОснованияПоТипам = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(Основания);
	ПервыйЗапрос = Истина;
	ТекстЗапроса = "";
	
	СпособыДоставки = Новый Массив;
	
	Для Каждого КлючИЗначение Из ОснованияПоТипам Цикл
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(КлючИЗначение.Ключ);
		ИмяТаблицыОбъекта = МетаданныеОбъекта.ПолноеИмя();
		ТекстЗапросаПоТипу = ШаблонЗапроса;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", МетаданныеОбъекта) Тогда
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад", "Склад КАК Склад");
		КонецЕсли;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Партнер", МетаданныеОбъекта) Тогда
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер", "Партнер КАК Партнер");
		КонецЕсли;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Подразделение", МетаданныеОбъекта) Тогда
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение", "Подразделение КАК Подразделение");
		КонецЕсли;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("КонтактноеЛицо", МетаданныеОбъекта) Тогда
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.КонтактныеЛицаПартнеров.ПустаяСсылка) КАК КонтактноеЛицо", "КонтактноеЛицо КАК КонтактноеЛицо");
		КонецЕсли;
		ДополнитьЗапросПоОснованиям(ТекстЗапроса, ТекстЗапросаПоТипу, ПервыйЗапрос, ИмяТаблицыОбъекта);
		
		ТекстЗапросаПоТипу = ШаблонЗапроса;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СкладОтправитель", МетаданныеОбъекта) Тогда
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад", "СкладОтправитель КАК Склад");
		КонецЕсли;		
		ДополнитьЗапросПоОснованиям(ТекстЗапроса, ТекстЗапросаПоТипу, ПервыйЗапрос, ИмяТаблицыОбъекта);
		
		ТекстЗапросаПоТипу = ШаблонЗапроса;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СкладПолучатель", МетаданныеОбъекта) Тогда
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад", "СкладПолучатель КАК Склад");
		КонецЕсли;		
		ДополнитьЗапросПоОснованиям(ТекстЗапроса, ТекстЗапросаПоТипу, ПервыйЗапрос, ИмяТаблицыОбъекта);
		
		МетаданныеОбъектаТабличныеЧасти = МетаданныеОбъекта.ТабличныеЧасти; // КоллекцияОбъектовМетаданных
		
		Для Каждого ТЧ Из МетаданныеОбъектаТабличныеЧасти Цикл
			Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", ТЧ) Тогда
				Продолжить;
			КонецЕсли;
			ИмяТаблицыТЧ = ИмяТаблицыОбъекта + "." + ТЧ.Имя;
			ТекстЗапросаПоТипу = ШаблонЗапроса;
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад", "Склад КАК Склад");
			ДополнитьЗапросПоОснованиям(ТекстЗапроса, ТекстЗапросаПоТипу, ПервыйЗапрос, ИмяТаблицыТЧ);
		КонецЦикла;
		Для Каждого ТЧ Из МетаданныеОбъектаТабличныеЧасти Цикл
			Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("СкладОтправитель", ТЧ) Тогда
				Продолжить;
			КонецЕсли;
			ИмяТаблицыТЧ = ИмяТаблицыОбъекта + "." + ТЧ.Имя;
			ТекстЗапросаПоТипу = ШаблонЗапроса;
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад", "СкладОтправитель КАК Склад");			
			ДополнитьЗапросПоОснованиям(ТекстЗапроса, ТекстЗапросаПоТипу, ПервыйЗапрос, ИмяТаблицыТЧ);
		КонецЦикла;
		Для Каждого ТЧ Из МетаданныеОбъектаТабличныеЧасти Цикл
			Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("СкладПолучатель", ТЧ) Тогда
				Продолжить;
			КонецЕсли;
			ИмяТаблицыТЧ = ИмяТаблицыОбъекта + "." + ТЧ.Имя;
			ТекстЗапросаПоТипу = ШаблонЗапроса;
			ТекстЗапросаПоТипу = СтрЗаменить(ТекстЗапросаПоТипу, "ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад", "СкладПолучатель КАК Склад");
			ДополнитьЗапросПоОснованиям(ТекстЗапроса, ТекстЗапросаПоТипу, ПервыйЗапрос, ИмяТаблицыТЧ);
		КонецЦикла;
		
		Если Метаданные.ОпределяемыеТипы.РаспоряжениеНаОтгрузку.Тип.СодержитТип(КлючИЗначение.Ключ) Тогда
			Если СпособыДоставки.Найти(Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада) = Неопределено Тогда
				СпособыДоставки.Добавить(Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада);
			КонецЕсли;
		ИначеЕсли Метаданные.ОпределяемыеТипы.РаспоряжениеНаПоступление.Тип.СодержитТип(КлючИЗначение.Ключ) Тогда
			Если СпособыДоставки.Найти(Перечисления.СпособыДоставки.ПоручениеЭкспедиторуНаСклад) = Неопределено Тогда
				СпособыДоставки.Добавить(Перечисления.СпособыДоставки.ПоручениеЭкспедиторуНаСклад);
			КонецЕсли;
		Иначе
			Если СпособыДоставки.Найти(Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте) = Неопределено Тогда
				СпособыДоставки.Добавить(Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|//////////////////////////////////////////
	|;
	|" +
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Т.Склад
	|ИЗ
	|	ДанныеОснований КАК Т
	|ГДЕ
	|	Т.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	И НЕ Т.Склад.ЭтоГруппа
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Склад
	|
	|УПОРЯДОЧИТЬ ПО
	|	КОЛИЧЕСТВО(*) УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Т.Пункт
	|ИЗ
	|	(ВЫБРАТЬ
	|		Т.Партнер КАК Пункт,
	|		1 КАК Порядок
	|	ИЗ
	|		ДанныеОснований КАК Т
	|	ГДЕ
	|		Т.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Т.Подразделение,
	|		2
	|	ИЗ
	|		ДанныеОснований КАК Т
	|	ГДЕ
	|		Т.Подразделение <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Т.Склад,
	|		3
	|	ИЗ
	|		ДанныеОснований КАК Т
	|	ГДЕ
	|		Т.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|		И НЕ Т.Склад.ЭтоГруппа) КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Пункт,
	|	Т.Порядок
	|
	|УПОРЯДОЧИТЬ ПО
	|	Т.Порядок,
	|	КОЛИЧЕСТВО(*) УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.КонтактноеЛицо
	|ИЗ
	|	ДанныеОснований КАК Т
	|ГДЕ
	|	Т.КонтактноеЛицо <> ЗНАЧЕНИЕ(Справочник.КонтактныеЛицаПартнеров.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.КонтактноеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	КОЛИЧЕСТВО(*) УБЫВ";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Основания", Основания);
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	СтруктураВозврата = Новый Структура("Склады, Пункты, Контакты, СпособыДоставки");
	СтруктураВозврата.Склады   = РезультатЗапроса[РезультатЗапроса.Количество()-3].Выгрузить().ВыгрузитьКолонку("Склад");
	СтруктураВозврата.Пункты   = РезультатЗапроса[РезультатЗапроса.Количество()-2].Выгрузить().ВыгрузитьКолонку("Пункт");
	СтруктураВозврата.Контакты = РезультатЗапроса[РезультатЗапроса.Количество()-1].Выгрузить().ВыгрузитьКолонку("КонтактноеЛицо");
	СтруктураВозврата.СпособыДоставки = СпособыДоставки;
	
	Возврат СтруктураВозврата;

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	(ЗначениеРазрешено(Склад)
	|	ИЛИ СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.ПоручениеЭкспедиторуВПункте))
	|		И ЗначениеРазрешено(Пункт, Неопределено КАК Истина)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Поручение экспедитору
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПоручениеЭкспедитору";
	КомандаПечати.Представление = НСтр("ru = 'Поручение экспедитору'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПоручениеЭкспедитору") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПоручениеЭкспедитору",
			НСтр("ru = 'Поручение экспедитору'"),
			СформироватьПечатнуюФормуПорученияЭкспедитору(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуПорученияЭкспедитору(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПОРУЧЕНИЕЭКСПЕДИТОРУ";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляПечати = ПолучитьДанныеДляПечатнойФормыПоручениеЭкспедитору(МассивОбъектов, ПараметрыПечати);
	ЗаполнитьТабличныйДокументПоручениеЭкспедитору(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеДляПечатнойФормыПоручениеЭкспедитору(МассивОбъектов, ПараметрыПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПоручениеЭкспедитору.Ссылка КАК Ссылка,
	|	ПоручениеЭкспедитору.Номер КАК НомерПоручения,
	|	ПоручениеЭкспедитору.Дата КАК Дата,
	|	ПоручениеЭкспедитору.СпособДоставки КАК СпособДоставки,
	|	ПоручениеЭкспедитору.Склад.Представление КАК Склад,
	|	ПРЕДСТАВЛЕНИЕ(ПоручениеЭкспедитору.Пункт) КАК Пункт,
	|	ПоручениеЭкспедитору.КонтактноеЛицо.Представление КАК Контакт,
	|	ПоручениеЭкспедитору.АдресДоставки КАК АдресДоставки,
	|	ПоручениеЭкспедитору.ЗонаДоставки.Представление КАК ЗонаДоставки,
	|	ПоручениеЭкспедитору.ВремяДоставкиС КАК ВремяС,
	|	ПоручениеЭкспедитору.ВремяДоставкиПо КАК ВремяПо,
	|	ПоручениеЭкспедитору.ДополнительнаяИнформацияПоДоставке КАК ИнформацияПоПункту,
	|	ПоручениеЭкспедитору.ОсобыеУсловияПеревозкиОписание КАК ОписаниеПоручения,
	|	ПоручениеЭкспедитору.Ответственный.Представление КАК Ответственный
	|ИЗ
	|	Документ.ПоручениеЭкспедитору КАК ПоручениеЭкспедитору
	|ГДЕ
	|	ПоручениеЭкспедитору.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеДляПечати = РезультатЗапроса.Выгрузить();
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументПоручениеЭкспедитору(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	ДанныеДляПечатиСтрока = ДанныеДляПечати[0];
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПоручениеЭкспедитору.ПФ_MXL_ПоручениеЭкспедитору");
	
	// Области документа
	ОбластьШтрихкода = Макет.ПолучитьОбласть("ОбластьШтрихкода");
	ОбластьЗаголовка = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПункта = Макет.ПолучитьОбласть("ОбластьПункт");
	ОбластьАдреса = Макет.ПолучитьОбласть("ОбластьАдресДоставки");
	ОбластьОписания = Макет.ПолучитьОбласть("ОбластьОписание");
	ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
	
	// Реквизиты заголовка документа
	РеквизитыДокумента = Новый Структура;
	РеквизитыДокумента.Вставить("Номер", ДанныеДляПечатиСтрока.НомерПоручения);
	РеквизитыДокумента.Вставить("Дата", ДанныеДляПечатиСтрока.Дата);
	
	ЗаголовокДокумента = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента,
		НСтр("ru='Поручение экспедитору'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	// Заполнение параметров областей ПФ_MXL_ПоручениеЭкспедитору
	СтруктураДанныхЗаголовка = Новый Структура;
	СтруктураДанныхЗаголовка.Вставить("ТекстЗаголовка", ЗаголовокДокумента);
	ОбластьЗаголовка.Параметры.Заполнить(СтруктураДанныхЗаголовка);
	
	ОбластьПункта.Параметры.Заполнить(ДанныеДляПечатиСтрока);
	ОбластьАдреса.Параметры.Заполнить(ДанныеДляПечатиСтрока);
	ОбластьОписания.Параметры.Заполнить(ДанныеДляПечатиСтрока);
	ОбластьПодписи.Параметры.Заполнить(ДанныеДляПечатиСтрока);
	
	// Вывод областей ПФ_MXL_ПоручениеЭкспедитору
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(
		ТабличныйДокумент,
		Макет,
		ОбластьЗаголовка,
		ДанныеДляПечатиСтрока.Ссылка);
	
	ТабличныйДокумент.Вывести(ОбластьЗаголовка);
	
	Если ДанныеДляПечатиСтрока.СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада
		Или ДанныеДляПечатиСтрока.СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуНаСклад Тогда
		
		ОбластьНаправлениеОткуда = Макет.ПолучитьОбласть("ЗаголовокНаправление");
		ОбластьСклада = Макет.ПолучитьОбласть("ОбластьСклад");
		ОбластьНаправлениеКуда = Макет.ПолучитьОбласть("ЗаголовокНаправление");
		
		СтруктураДанныхОткуда = Новый Структура;
		СтруктураДанныхОткуда.Вставить("Направление", НСтр("ru='Откуда'", ОбщегоНазначения.КодОсновногоЯзыка()));
		ОбластьНаправлениеОткуда.Параметры.Заполнить(СтруктураДанныхОткуда);
		
		ОбластьСклада.Параметры.Склад = ДанныеДляПечатиСтрока.Склад;

		СтруктураДанныхКуда = Новый Структура;
		СтруктураДанныхКуда.Вставить("Направление", НСтр("ru='Куда'", ОбщегоНазначения.КодОсновногоЯзыка()));
		ОбластьНаправлениеКуда.Параметры.Заполнить(СтруктураДанныхКуда);
		
		Если ДанныеДляПечатиСтрока.СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада Тогда
			
			ТабличныйДокумент.Вывести(ОбластьНаправлениеОткуда);
			ТабличныйДокумент.Вывести(ОбластьСклада);
			ТабличныйДокумент.Вывести(ОбластьНаправлениеКуда);
			
		Иначе
			
			ТабличныйДокумент.Вывести(ОбластьНаправлениеКуда);
			ТабличныйДокумент.Вывести(ОбластьСклада);
			ТабличныйДокумент.Вывести(ОбластьНаправлениеОткуда);
			
		КонецЕсли;
		
	Иначе
		ОбластьНаправление = Макет.ПолучитьОбласть("ЗаголовокНаправление");
		СтруктураДанныхНаправление = Новый Структура;
		СтруктураДанныхНаправление.Вставить("Направление", НСтр("ru='Где'", ОбщегоНазначения.КодОсновногоЯзыка()));
		ОбластьНаправление.Параметры.Заполнить(СтруктураДанныхНаправление);
		
		ТабличныйДокумент.Вывести(ОбластьНаправление);
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьПункта);
	
	Если ЗначениеЗаполнено(ДанныеДляПечатиСтрока.Контакт) Тогда
		ОбластьКонтакта = Макет.ПолучитьОбласть("ОбластьКонтакт");
		
		ОбластьКонтакта.Параметры.Заполнить(ДанныеДляПечатиСтрока);
		ТабличныйДокумент.Вывести(ОбластьКонтакта);
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьАдреса);
	
	Если ЗначениеЗаполнено(ДанныеДляПечатиСтрока.ЗонаДоставки) Тогда
		ОбластьЗоны = Макет.ПолучитьОбласть("ОбластьЗона");
		
		ОбластьЗоны.Параметры.Заполнить(ДанныеДляПечатиСтрока);
		ТабличныйДокумент.Вывести(ОбластьЗоны);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеДляПечатиСтрока.ВремяС)
		Или ЗначениеЗаполнено(ДанныеДляПечатиСтрока.ВремяПо) Тогда
		
		ОбластьВремени = Макет.ПолучитьОбласть("ОбластьВремяДоставки");
		
		ВремяС = Формат(ДанныеДляПечатиСтрока.ВремяС, "ДФ=ЧЧ:ММ");
		ВремяПо = Формат(ДанныеДляПечатиСтрока.ВремяПо, "ДФ=ЧЧ:ММ");
		
		ОбластьВремени.Параметры.ВремяС = ВремяС;
		ОбластьВремени.Параметры.ВремяПо = ВремяПо;
		
		ТабличныйДокумент.Вывести(ОбластьВремени);
		
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьОписания);
	ТабличныйДокумент.Вывести(ОбластьПодписи);
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеНаОсновании

// Добавляет команду создания документа "Поручение экспедитору".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - Добавить команду создать на основании
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПоручениеЭкспедитору) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПоручениеЭкспедитору.ПолноеИмя();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.ПоручениеЭкспедитору";
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПоручениеЭкспедитору);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьУправлениеДоставкой";
		КомандаСоздатьНаОсновании.МножественныйВыбор = Истина;
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

#КонецОбласти 

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти 

#Область ОбновлениеИнформационнойБазы

Процедура ДополнитьЗапросПоОснованиям(ТекстЗапроса, ТекстЗапросаДляДополнения, ПервыйЗапрос, ИмяТаблицы)
	
	Если Не ЗначениеЗаполнено(ТекстЗапросаДляДополнения) Тогда
		Возврат;
	КонецЕсли;
	ТекстЗапросаДляДополнения = СтрЗаменить(ТекстЗапросаДляДополнения, "#ТаблицаДокумента", ИмяТаблицы);
	Если ПервыйЗапрос Тогда
		ПервыйЗапрос = Ложь;
		ТекстЗапроса = ТекстЗапросаДляДополнения;
	Иначе
		ТекстЗапросаДляДополнения = СтрЗаменить(ТекстЗапросаДляДополнения, "ПОМЕСТИТЬ ДанныеОснований", "");
		ТекстЗапросаДляДополнения = СтрЗаменить(ТекстЗапросаДляДополнения, "РАЗРЕШЕННЫЕ", "");
		ТекстЗапроса = ТекстЗапроса +
		"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|"
		+ ТекстЗапросаДляДополнения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

