
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значение:
//	Массив из Строка - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ИмущественныйУчет");
	Результат.Добавить("ИнвентарныйУчет");
	Результат.Добавить("УчетПоФизЛицам");
	Результат.Добавить("СрокЭксплуатации");
	Результат.Добавить("УчитыватьВВидеГрупповогоОС");
	Результат.Добавить("СпособПогашенияСтоимостиБУ");
	Результат.Добавить("СпособПогашенияСтоимостиНУ");

	Возврат Результат;
	
КонецФункции

#КонецОбласти


#КонецОбласти

#КонецЕсли
