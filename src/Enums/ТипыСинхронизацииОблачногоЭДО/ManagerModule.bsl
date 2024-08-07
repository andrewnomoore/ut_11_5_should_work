// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.ТипыСинхронизацииОблачногоЭДО
Функция Значения() Экспорт
	Значения = Новый Массив; // см. Значения
	ДанныеВыбора = ДанныеВыбора();
	Для Каждого ЭлементСписка Из ДанныеВыбора Цикл
		Значения.Добавить(ЭлементСписка.Значение.Значение);
	КонецЦикла;
	Возврат Значения;
КонецФункции

// Возвращаемое значение:
//  СписокЗначений из Структура:
//  * Значение - ПеречислениеСсылка.ТипыСинхронизацииОблачногоЭДО
Функция ДанныеВыбора()
	Возврат ПолучитьДанныеВыбора(Новый Структура);
КонецФункции

#КонецОбласти

#КонецЕсли
