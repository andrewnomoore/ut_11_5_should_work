#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Запрет редактирования реквизитов объектов"
//
// Возвращаемое значение:
//   Массив - имена блокируемых реквизитов объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ТипСделки");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Результат = ПартнерыИКонтрагентыВызовСервера.ВидыСделокДанныхВыбора(Параметры.СтрокаПоиска);
	
	Если Результат <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Результат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

