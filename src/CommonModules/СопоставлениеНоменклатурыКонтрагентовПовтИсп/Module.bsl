
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает таблицу слов исключений меньше 3 букв
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Слово - Строка - слово исключение.
//
Функция СловаИсключенияМеньшеТрехБукв() Экспорт
	
	ТаблицаСлов = Новый ТаблицаЗначений();
	ТаблицаСлов.Колонки.Добавить("Слово", ОбщегоНазначения.ОписаниеТипаСтрока(2));
	
	ЗаполнитьТаблицуСловПоМакету(ТаблицаСлов, "СписокИсключенийСловМеньше3Букв");
	
	Возврат ТаблицаСлов;
	
КонецФункции

// Возвращает таблицу незначимых слов исключений
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Слово - Строка - слово исключение.
//
Функция СловаИсключенияНезначимые() Экспорт
	
	ТаблицаСлов = Новый ТаблицаЗначений();
	ТаблицаСлов.Колонки.Добавить("Слово", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	
	ЗаполнитьТаблицуСловПоМакету(ТаблицаСлов, "СписокИсключенийНезначимыхСлов");
	
	Возврат ТаблицаСлов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицуСловПоМакету(ТаблицаСлов, ИмяМакета)
	
	Макет = Обработки.СопоставлениеНоменклатурыБЭД.ПолучитьМакет(ИмяМакета);
	
	НомерСтроки = 1;
	Пока Истина Цикл
		Адрес = "R" + Формат(НомерСтроки, "ЧГ=") + "C1";
		Значение = Макет.Область(Адрес).Текст;
		Если ПустаяСтрока(Значение) Тогда
			Прервать;
		КонецЕсли;
		
		ТаблицаСлов.Добавить().Слово = СокрЛП(Значение);
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
