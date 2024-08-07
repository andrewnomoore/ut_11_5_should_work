#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует описание реквизитов объекта, заполняемых по статистике их использования.
//
// Параметры:
//  ОписаниеРеквизитов - Структура - описание реквизитов, для которых необходимо получить значения по статистике
//
//
Процедура ЗадатьОписаниеЗаполняемыхРеквизитовПоСтатистике(ОписаниеРеквизитов) Экспорт
	
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "Ответственный");
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьТолькоЗаполненные = "Ответственный";
	Параметры.ЗаполнятьПриУсловии.ПоляОбъектаЗаполнены = "Ответственный";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов,
		"Организация", Параметры);
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьТолькоЗаполненные = "Организация";
	Параметры.ЗаполнятьПриУсловии.ПоляОбъектаЗаполнены = "Организация";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов,
		"КассоваяКнига", Параметры);
	
КонецПроцедуры

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("ОборотныеРегистрыУправленческогоУчета");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("СебестоимостьИПартионныйУчет");
	МеханизмыДокумента.Добавить("СуммыДокументовВВалютахУчета");
	МеханизмыДокумента.Добавить("УчетДенежныхСредств");
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	МеханизмыДокумента.Добавить("ИсправлениеДокументов");
	
	ИнвентаризацияНаличныхДенежныхСредствЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов - таблиц значений - данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ИнвентаризацияНаличныхДенежныхСредств") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса

		
		ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаДенежныеСредстваНаличные(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		
		ИнвентаризацияНаличныхДенежныхСредствЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос,
																							ТекстыЗапроса,
																							Регистры);
	КонецЕсли;
	
	ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	ИсправлениеДокументов.ДобавитьКомандуИсправление(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	ИсправлениеДокументов.ДобавитьКомандуСторно(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	
	ИнвентаризацияНаличныхДенежныхСредствЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Инвентаризация наличных денежных средств".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	ТаблицаЗначений, Неопределено - сформированные команды для вывода в подменю.
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
	ИнвентаризацияНаличныхДенежныхСредствЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры


// Возвращает параметры выбора статей в документе.
// 
// Возвращаемое значение:
// 	Массив - Массив параметров настройки счетов учета (См. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики)
//
Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	МассивПараметровВыбора = Новый Массив;
	
	#Область СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект.Кассы";
	ПараметрыВыбора.Статья = "СтатьяДоходовРасходов";
	ПараметрыВыбора.ТипСтатьи = "ТипСтатьи";
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("КассыСтатьяДоходовРасходов");
	
	#Область АналитикаРасходов
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("КассыАналитикаРасходов");
	#КонецОбласти
	
	#Область АналитикаДоходов
	ПараметрыВыбора.ВыборСтатьиДоходов = Истина;
	ПараметрыВыбора.АналитикаДоходов = "АналитикаДоходов";
	ПараметрыВыбора.ЭлементыФормы.АналитикаДоходов.Добавить("КассыАналитикаДоходов");
	#КонецОбласти
	
	МассивПараметровВыбора.Добавить(ПараметрыВыбора);
	#КонецОбласти
		
	Возврат МассивПараметровВыбора;
	
КонецФункции

// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Выбранная хозяйственная операция
//	МассивВсехРеквизитов - Массив - Массив всех имен реквизитов, зависимых от хозяйственной операции
//	МассивРеквизитовОперации - Массив - Массив имен реквизитов, используемых в выбранной хозяйственной операции.
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СтатьяДоходов");
	МассивВсехРеквизитов.Добавить("АналитикаДоходов");
	МассивВсехРеквизитов.Добавить("СтатьяРасходов");
	МассивВсехРеквизитов.Добавить("АналитикаРасходов");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяДоходов");
		МассивРеквизитовОперации.Добавить("АналитикаДоходов");
	
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяРасходов");
		МассивРеквизитовОперации.Добавить("АналитикаРасходов");
		
	КонецЕсли;
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ИнвентаризацияНаличныхДенежныхСредств";
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса, ПолноеИмяДокумента, "", Ложь);
	Иначе
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса, ПолноеИмяДокумента, "");
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметровПроведения();
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата                          КАК Период,
	|	ДанныеДокумента.Организация                   КАК Организация,
	|	ДанныеДокумента.КассоваяКнига                 КАК КассоваяКнига,
	|	
	|	ДанныеДокумента.СуммаПоФактуВсего             КАК СуммаДокумента,
	|	ДанныеДокумента.СуммаПоФактуВсего             КАК СуммаПоФактуВсего,
	|	ДанныеДокумента.Ответственный                 КАК Ответственный,
	|	ДанныеДокумента.Автор                         КАК Автор,
	|	ДанныеДокумента.Номер                         КАК Номер,
	|	ДанныеДокумента.Комментарий                   КАК Комментарий,
	|	ДанныеДокумента.ПометкаУдаления               КАК ПометкаУдаления,
	|	ДанныеДокумента.Исправление                   КАК Исправление,
	|	ДанныеДокумента.СторнируемыйДокумент          КАК СторнируемыйДокумент,
	|	ДанныеДокумента.ИсправляемыйДокумент          КАК ИсправляемыйДокумент,
	|	ДанныеДокумента.Проведен                      КАК Проведен
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения(Реквизиты) Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперацииИзлишек", 		Справочники.НастройкиХозяйственныхОпераций.ОтражениеИзлишкаПриИнвентаризацииДенежныхСредств);
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперацииНедостача", 	Справочники.НастройкиХозяйственныхОпераций.ОтражениеНедостачиПриИнвентаризацииДенежныхСредств);
	
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)
	
	Значения = Новый Структура;
	Значения.Вставить("ИдентификаторМетаданных",           ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ИнвентаризацияНаличныхДенежныхСредств"));
	Значения.Вставить("ВалютаУправленческогоУчета",        Константы.ВалютаУправленческогоУчета.Получить());
	Значения.Вставить("ХозяйственнаяОперацияИзлишек",      Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнвентаризацииДенежныхСредств);
	Значения.Вставить("ХозяйственнаяОперацияНедостача",    Перечисления.ХозяйственныеОперации.ОтражениеНедостачиПриИнвентаризацииДенежныхСредств);
	
	Если Реквизиты <> Неопределено Тогда
		Значения.Вставить("НомерНаПечать",                         ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
		Значения.Вставить("ВалютаРегламентированногоУчета", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Реквизиты.Организация));
	КонецЕсли;
	
	Возврат Значения;
	
КонецФункции

Функция ТекстЗапросаВТКурсыВалютУпр(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТКурсыВалютУпр"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.КурсЧислитель * КурсВалютыУпр.КурсЗнаменатель / (КурсВалюты.КурсЗнаменатель * КурсВалютыУпр.КурсЧислитель) КАК КоэффициентПересчета
	|ПОМЕСТИТЬ ВТКурсыВалютУпр
	|ИЗ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Период, БазоваяВалюта = &ВалютаРегламентированногоУчета) КАК КурсВалюты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУправленческогоУчета И БазоваяВалюта = &ВалютаРегламентированногоУчета) КАК КурсВалютыУпр
	|	ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.КурсЗнаменатель <> 0
	|	И КурсВалютыУпр.КурсЧислитель <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВТКурсыВалютРегл(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТКурсыВалютРегл"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.КурсЧислитель * КурсВалютыРегл.КурсЗнаменатель / (КурсВалюты.КурсЗнаменатель * КурсВалютыРегл.КурсЧислитель) КАК КоэффициентПересчета
	|ПОМЕСТИТЬ ВТКурсыВалютРегл
	|ИЗ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Период, БазоваяВалюта = &ВалютаРегламентированногоУчета) КАК КурсВалюты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаРегламентированногоУчета И БазоваяВалюта = &ВалютаРегламентированногоУчета) КАК КурсВалютыРегл
	|	ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.КурсЗнаменатель <> 0
	|	И КурсВалютыРегл.КурсЧислитель <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТКассы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТКурсыВалютУпр", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКурсыВалютУпр(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТКурсыВалютРегл", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКурсыВалютРегл(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаКассы.Ссылка КАК Ссылка,
	|	ТаблицаКассы.НомерСтроки КАК НомерСтроки,
	|	ТаблицаКассы.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаКассы.Касса КАК Касса,
	|	ТаблицаКассы.Касса.ВалютаДенежныхСредств КАК Валюта,
	|	ТаблицаКассы.СуммаРасхождения КАК СуммаРасхождения,
	|	ТаблицаКассы.СуммаРасхождения * ЕСТЬNULL(ТаблицаКурсыВалютУпр.КоэффициентПересчета, 0) КАК СуммаРасхожденияУпр,
	|	ТаблицаКассы.СуммаРасхождения * ЕСТЬNULL(ТаблицаКурсыВалютРегл.КоэффициентПересчета, 0) КАК СуммаРасхожденияРегл,
	|	ТаблицаКассы.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ТаблицаКассы.Касса.Подразделение КАК Подразделение,
	|	ТаблицаКассы.Подразделение КАК ПодразделениеДоходовРасходов,
	|	ТаблицаКассы.Касса.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаКассы.СтатьяДоходовРасходов КАК СтатьяДоходовРасходов,
	|	ТаблицаКассы.АналитикаДоходов КАК АналитикаДоходов,
	|	ТаблицаКассы.АналитикаРасходов КАК АналитикаРасходов
	|ПОМЕСТИТЬ ВТКассы
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК ТаблицаКассы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКурсыВалютУпр КАК ТаблицаКурсыВалютУпр
	|		ПО (ТаблицаКурсыВалютУпр.Валюта = ТаблицаКассы.Касса.ВалютаДенежныхСредств)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКурсыВалютРегл КАК ТаблицаКурсыВалютРегл
	|		ПО (ТаблицаКурсыВалютРегл.Валюта = ТаблицаКассы.Касса.ВалютаДенежныхСредств)
	|ГДЕ
	|	ТаблицаКассы.Ссылка = &Ссылка
	|	И ТаблицаКассы.СуммаРасхождения <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеДоходы";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	
	|	&Организация                                 КАК Организация,
	|	
	|	ВТКассы.ПодразделениеДоходовРасходов         КАК Подразделение,
	|	ВТКассы.НаправлениеДеятельности              КАК НаправлениеДеятельности,
	|	ВТКассы.СтатьяДоходовРасходов                КАК СтатьяДоходов,
	|	ВТКассы.АналитикаДоходов                     КАК АналитикаДоходов,
	|	
	|	ВТКассы.СуммаРасхожденияУпр                  КАК Сумма,
	|	ВЫБОР
	|		КОГДА &УправленческийУчетОрганизаций
	|			ТОГДА ВТКассы.СуммаРасхожденияУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ                                        КАК СуммаУпр,
	|	ВЫБОР
	|		КОГДА &ИспользоватьУчетПрочихДоходовРасходовРегл
	|			ТОГДА ВТКассы.СуммаРасхожденияРегл
	|		ИНАЧЕ 0
	|	КОНЕЦ                                        КАК СуммаРегл,
	|	
	|	&ХозяйственнаяОперацияИзлишек                КАК ХозяйственнаяОперация,
	|	
	|	ВТКассы.ИдентификаторСтроки                  КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперацииИзлишек       КАК НастройкаХозяйственнойОперации
	|	
	|ИЗ
	|	ВТКассы КАК ВТКассы
	|	
	|ГДЕ
	|	ВТКассы.СуммаРасхождения > 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	&Организация                                 КАК Организация,
	|	ВТКассы.ПодразделениеДоходовРасходов         КАК Подразделение,
	|	ВТКассы.НаправлениеДеятельности              КАК НаправлениеДеятельности,
	|	ВТКассы.СтатьяДоходовРасходов                КАК СтатьяРасходов,
	|	ВТКассы.АналитикаРасходов                    КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                 КАК ВидДеятельностиНДС,
	|	
	|	-ВТКассы.СуммаРасхожденияУпр                 КАК СуммаСНДС,
	|	-ВТКассы.СуммаРасхожденияУпр                 КАК СуммаБезНДС,
	|	-ВТКассы.СуммаРасхожденияУпр                 КАК СуммаБезНДСУпр,
	|
	|	-ВТКассы.СуммаРасхожденияРегл                КАК СуммаСНДСРегл,
	|	-ВТКассы.СуммаРасхожденияРегл                КАК СуммаБезНДСРегл,
	|	0                                            КАК ПостояннаяРазница,
	|	0                                            КАК ВременнаяРазница,
	|	&ХозяйственнаяОперацияНедостача              КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                                 КАК АналитикаУчетаНоменклатуры,
	|	
	|	ВТКассы.ИдентификаторСтроки                  КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперацииНедостача     КАК НастройкаХозяйственнойОперации
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	ВТКассы КАК ВТКассы
	|ГДЕ
	|	ВТКассы.СуммаРасхождения < 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса) Экспорт
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПартииПрочихРасходов";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                            КАК ВидДвижения,
	|	&Период                                                           КАК Период,
	|	&Организация                                                      КАК Организация,
	|	ВТКассы.ПодразделениеДоходовРасходов                              КАК Подразделение,
	|	&Ссылка                                                           КАК ДокументПоступленияРасходов,
	|	ВТКассы.СтатьяДоходовРасходов                                     КАК СтатьяРасходов,
	|	ВТКассы.АналитикаРасходов                                         КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                                      КАК АналитикаАктивовПассивов,
	|	ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)       КАК АналитикаУчетаПартий,
	|	ВТКассы.НаправлениеДеятельности                                   КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                                                      КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО                                                      КАК ВидДеятельностиНДС,
	|	
	|	-ВТКассы.СуммаРасхожденияРегл                                     КАК Стоимость,
	|	-ВТКассы.СуммаРасхожденияРегл                                     КАК СтоимостьБезНДС,
	|	0                                                                 КАК НДСУпр,
	|	-ВТКассы.СуммаРасхожденияРегл                                     КАК СтоимостьРегл,
	|	0                                                                 КАК ПостояннаяРазница,
	|	0                                                                 КАК ВременнаяРазница,
	|	0                                                                 КАК НДСРегл,
	|	&ХозяйственнаяОперацияНедостача                                   КАК ХозяйственнаяОперация,
	|	
	|	ВТКассы.ИдентификаторСтроки                                       КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперацииНедостача                          КАК НастройкаХозяйственнойОперации
	|
	|ПОМЕСТИТЬ ВтИсходныеПартииПрочихРасходов
	|ИЗ
	|	ВТКассы КАК ВТКассы
	|ГДЕ
	|	ВТКассы.СуммаРасхождения < 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса) Экспорт
	
	ИмяРегистра = "ВтПартииПрочихРасходов";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтИсходныеПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаВтПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПартииПрочихРасходов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДенежныеСредстваНаличные(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваНаличные";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	&Период                                           КАК Период,
	|	
	|	&Организация                                      КАК Организация,
	|	ВТКассы.Касса                                     КАК Касса,
	|	
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхождения
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхождения
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияУпр
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияУпр
	|	КОНЕЦ КАК СуммаУпр,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияРегл
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияРегл
	|	КОНЕЦ КАК СуммаРегл,
	|	
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		&ХозяйственнаяОперацияИзлишек
	|	ИНАЧЕ
	|		&ХозяйственнаяОперацияНедостача
	|	КОНЕЦ КАК ХозяйственнаяОперация,
	|	ВТКассы.СтатьяДвиженияДенежныхСредств             КАК СтатьяДвиженияДенежныхСредств,
	|	
	|	ВТКассы.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		&НастройкаХозяйственнойОперацииИзлишек
	|	ИНАЧЕ
	|		&НастройкаХозяйственнойОперацииНедостача
	|	КОНЕЦ КАК НастройкаХозяйственнойОперации
	|	
	|ИЗ
	|	ВТКассы КАК ВТКассы";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период                                             КАК Период,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		&ХозяйственнаяОперацияИзлишек
	|	ИНАЧЕ
	|		&ХозяйственнаяОперацияНедостача
	|	КОНЕЦ КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	ВТКассы.Подразделение                               КАК Подразделение,
	|	ВТКассы.НаправлениеДеятельности                     КАК НаправлениеДеятельностиДС,
	|	ВТКассы.ПодразделениеДоходовРасходов                КАК ПодразделениеДоходовРасходов,
	|
	|	ВТКассы.Касса                                       КАК ДенежныеСредства,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные) КАК ТипДенежныхСредств,
	|	ВТКассы.СтатьяДвиженияДенежныхСредств               КАК СтатьяДвиженияДенежныхСредств,
	|	ВТКассы.Валюта                                      КАК Валюта,
	|
	|	ВТКассы.НаправлениеДеятельности                     КАК НаправлениеДеятельностиСтатьи,
	|	ВТКассы.СтатьяДоходовРасходов                       КАК СтатьяДоходовРасходов,
	|	ВТКассы.АналитикаДоходов                            КАК АналитикаДоходов,
	|	ВТКассы.АналитикаРасходов                           КАК АналитикаРасходов,
	|
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияУпр
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияУпр
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияРегл
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияРегл
	|	КОНЕЦ КАК СуммаРегл,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхождения
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхождения
	|	КОНЕЦ КАК СуммаВВалюте,
	|
	|	ВТКассы.Касса                                       КАК ИсточникГФУДенежныхСредств,
	|	ВТКассы.СтатьяДоходовРасходов                       КАК ИсточникГФУДоходовРасходов
	|	
	|ИЗ
	|	ВТКассы КАК ВТКассы";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеАктивыПассивы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеАктивыПассивы.ТекстЗапросаТаблицаПрочиеАктивыПассивы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции


Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&ХозяйственнаяОперацияНедостача         КАК ХозяйственнаяОперация,
	|	&Организация                            КАК Организация,
	|	НЕОПРЕДЕЛЕНО                            КАК Партнер,
	|	НЕОПРЕДЕЛЕНО                          КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО                            КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО                            КАК Подразделение,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Ссылка                                 КАК Ссылка,
	
	|	&Номер                                  КАК НомерДокументаИБ,
	|	НЕОПРЕДЕЛЕНО                            КАК Статус,
	|	&Ответственный                          КАК Ответственный,
	|	&Автор                                  КАК Автор,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО                            КАК Дополнительно,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	&СуммаПоФактуВсего                      КАК Сумма,
	|	НЕОПРЕДЕЛЕНО                            КАК Валюта,
	|	НЕОПРЕДЕЛЕНО                            КАК Договор,
	|	НЕОПРЕДЕЛЕНО                            КАК НаправлениеДеятельности,
	|	&Исправление                            КАК СторноИсправление,
	|	&СторнируемыйДокумент                   КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент                   КАК ИсправляемыйДокумент,
	|	&Период                                 КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	ИнвентаризацияНаличныхДенежныхСредствЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ИнвентаризацияНаличныхДенежныхСредствЛокализация.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
КонецПроцедуры

#КонецОбласти

// Определяет состав документов и хозяйственных операций, доступных для отображения в рабочем месте.
//
// Параметры:
//  ХозяйственныеОперацииИДокументы	 - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка
// 
// Возвращаемое значение:
//   - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка.
//
//
Функция ИнициализироватьХозяйственныеОперацииИДокументы(ХозяйственныеОперацииИДокументы) Экспорт
	
	ПолноеИмяДокумента = Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств.ПолноеИмя();
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПустаяСсылка();
	Строка.ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяДокумента);
	Строка.ПолноеИмяДокумента = ПолноеИмяДокумента;
	Строка.КлючНазначенияИспользования = "Инвентаризация наличных денежных средств";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Инвентаризация наличных денежных средств'");
	Строка.Порядок = 1;
	Строка.ДобавитьКнопкуСоздать = Истина;
	Строка.ПравоДоступаДобавление = ПравоДоступа("Добавление", Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств);;
	Строка.ПравоДоступаИзменение = ПравоДоступа("Изменение", Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств);;
	Строка.Отбор = Истина;
	
	Возврат ХозяйственныеОперацииИДокументы;
	
КонецФункции

#КонецОбласти

#КонецЕсли
