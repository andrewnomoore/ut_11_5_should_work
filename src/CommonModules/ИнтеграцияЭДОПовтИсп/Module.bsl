#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//  * Ключ - см. ОбщегоНазначения.ИдентификаторОбъектаМетаданных
//  * Значение - см. ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору
Функция ОписаниеОбъектовУчетаВнутреннихЭлектронныхДокументов() Экспорт
	
	ОбъектыУчета = Новый Соответствие;
	
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ОснованияЭлектронныхДокументовЭДО.Тип.Типы() Цикл
		СтроковоеПредставлениеТипа = ОбщегоНазначения.СтроковоеПредставлениеТипа(Тип);
		ОписаниеТипов = Новый ОписаниеТипов(СтроковоеПредставлениеТипа);
		ПустаяСсылка = ОписаниеТипов.ПривестиЗначение();
		Попытка
			ОписаниеОбъектаУчета = ИнтеграцияЭДО.ОписаниеОбъектаУчета(ПустаяСсылка);
			Для каждого ПараметрыЭД Из ОписаниеОбъектаУчета Цикл
				Если ПараметрыЭД.Направление = Перечисления.НаправленияЭДО.Внутренний Тогда
					ИдентификаторОбъектаУчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип);
					МетаданныеОбъектаУчета = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИдентификаторОбъектаУчета);
					ОбъектыУчета.Вставить(ИдентификаторОбъектаУчета, МетаданныеОбъектаУчета);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Исключение
			ИмяСобытия = НСтр(
				"ru = 'Получение метаданных объектов учета внутреннего электронного документа'",
				ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстОшибки = СтроковоеПредставлениеТипа + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
		КонецПопытки;
	КонецЦикла;
	
	Возврат ОбъектыУчета;
	
КонецФункции

// Функция возвращает признак использования справочника Партнеров в качестве
// дополнительной аналитики к справочнику Контрагенты.
//
// Возвращаемое значение:
//  ИспользуетсяСправочникПартнеры - Булево - флаг использования в библиотеке справочника Партнеры.
//
Функция ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры() Экспорт

	ИспользуетсяСправочникПартнеры = Ложь;
	ОбменСКонтрагентамиПереопределяемый.ДополнительнаяАналитикаКонтрагентовСправочникПартнеры(ИспользуетсяСправочникПартнеры);
	
	Возврат ИспользуетсяСправочникПартнеры;
	
КонецФункции

Функция ИспользуютсяДоговорыКонтрагентов() Экспорт

	ЕстьСсылочныйТип = Ложь;
	ТипыСущностиДоговор = Метаданные.ОпределяемыеТипы.ДоговорСКонтрагентомЭДО.Тип.Типы();
	
	Для Каждого ТипСущности Из ТипыСущностиДоговор Цикл
		Если ОбщегоНазначения.ЭтоСсылка(ТипСущности) Тогда
			ЕстьСсылочныйТип = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьСсылочныйТип;

КонецФункции

// Возвращает имя прикладного справочника по имени библиотечного справочника.
//
// Параметры:
//  ИмяСправочника - строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  Строка - имя прикладного справочника.
//
Функция ИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	ИмяОпределяемогоТипа = "";
	
	Если ВРег(ИмяСправочника) = ВРег("Контрагенты") Тогда
		ИмяОпределяемогоТипа = "КонтрагентБЭД";
	ИначеЕсли ВРег(ИмяСправочника) = ВРег("Номенклатура") Тогда
		ИмяОпределяемогоТипа = "НоменклатураБЭД";
	ИначеЕсли ВРег(ИмяСправочника) = ВРег("Организации") Тогда
		ИмяОпределяемогоТипа = "Организация";
	ИначеЕсли ВРег(ИмяСправочника) = ВРег("Партнеры") Тогда
		ИмяОпределяемогоТипа = "Партнер";
	ИначеЕсли ВРег(ИмяСправочника) = ВРег("ХарактеристикиНоменклатуры") Тогда
		ИмяОпределяемогоТипа = "ХарактеристикаНоменклатурыБЭД";
	ИначеЕсли ВРег(ИмяСправочника) = ВРег("УпаковкиНоменклатуры") Тогда
		ИмяОпределяемогоТипа = "УпаковкаНоменклатурыБЭД";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяОпределяемогоТипа) Тогда
		Возврат Метаданные.ОпределяемыеТипы[ИмяОпределяемогоТипа].Тип.ПривестиЗначение().Метаданные().Имя;
	Иначе
		ВызватьИсключение НСтр(
			СтрШаблон(
			"ru = 'Неизвестный справочник %1. Проверьте имя и определение в ИнтеграцияЭДО.ИмяПрикладногоСправочника.'",
			ИмяСправочника));
	КонецЕсли;

КонецФункции

// Функция возвращает соответствующее переданному параметру значение ставки НДС.
// Если в функцию передан параметр ПредставлениеБЭД, то функция вернет ПрикладноеЗначение ставки НДС и наоборот.
//
// Параметры:
//   ПредставлениеБЭД - Строка - строковое представление ставки НДС.
//   ПрикладноеЗначение - ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - прикладное представление
//     соответствующего значения ставки НДС.
//
// Возвращаемое значение:
//   Строка, ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - соответствующее представление ставки НДС.
//
Функция СтавкаНДСИзСоответствия(ПредставлениеБЭД = "", ПрикладноеЗначение = Неопределено) Экспорт
	
	Соответствие = Новый Соответствие;
	ОбменСКонтрагентамиПереопределяемый.ЗаполнитьСоответствиеСтавокНДС(Соответствие);
	Значение = Неопределено;
	Если ЗначениеЗаполнено(ПредставлениеБЭД) Тогда
		Значение = Соответствие.Получить(ПредставлениеБЭД);
	Иначе
		Для Каждого КлючИЗначение Из Соответствие Цикл
			Если КлючИЗначение.Значение = ПрикладноеЗначение Тогда
				Значение = КлючИЗначение.Ключ;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Функция возвращает соответствующее переданному параметру значение ставки НДС.
//
// Параметры:
//   СтавкаНДС - ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - прикладное представление
//               соответствующего значения ставки НДС.
//
// Возвращаемое значение:
//   Строка, ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - соответствующее представление ставки НДС.
//
Функция СтавкаНДСПеречисление(СтавкаНДС) Экспорт
	
	Соответствие = Новый Соответствие;
	ОбменСКонтрагентамиПереопределяемый.ЗаполнитьСоответствиеСтавокНДС(Соответствие);
	
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Если КлючИЗначение.Значение = СтавкаНДС Тогда
			Значение = КлючИЗначение.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Значение = "0" Или Значение = "10" Или Значение = "18" ИЛИ Значение = "20" Тогда
		Значение = Значение + "%";
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Функция возвращает соответствующее переданному параметру значение вида договора контрагента.
//
// Параметры:
//   ВидДоговора - ПеречислениеСсылка.ВидыДоговоровКонтрагентов - прикладное представление соответствующего значения
//               вида договора контрагента.
//
// Возвращаемое значение:
//   Строка, ПеречислениеСсылка.ВидыДоговоровКонтрагентов - соответствующее вида договора контрагента.
//
Функция ВидДоговоровКонтрагентовПеречисление(ВидДоговора) Экспорт
	
	Соответствие = Новый Соответствие;
	ОбменСКонтрагентамиПереопределяемый.ЗаполнитьСоответствиеВидовДоговоровКонтрагентов(Соответствие);
	
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Если КлючИЗначение.Значение = ВидДоговора Тогда
			Значение = КлючИЗначение.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат Значение;
	
КонецФункции

#КонецОбласти