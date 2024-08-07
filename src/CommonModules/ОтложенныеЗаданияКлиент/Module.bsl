/////////////////////////////////////////////////////////////////////
// Модуль "ОтложенныеЗаданияКлиент" содержит процедуры и функции для
// работы с механизмом отложенных заданий.
//
/////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область РасшифровкаОтчетаОшибкиВыполненияОтложенныхЗаданий

Процедура ОбработатьРасшифровкуОшибкиВыполненияОтложенныхЗаданий(Форма, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Если Расшифровка = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СписокПараметров = Новый Массив;
	
	ПоляРасшифровки = Новый Массив;
	ПоляРасшифровки.Добавить("Очередь");
	ПоляРасшифровки.Добавить("ИдентификаторОшибки");
	
	ДанныеРасшифровкиОтчета = КомпоновкаДанныхВызовСервера.ПараметрыФормыРасшифровки(
								Расшифровка,
								Форма.ОтчетДанныеРасшифровки,
								СписокПараметров,
								ПоляРасшифровки);
	
	Если ДанныеРасшифровкиОтчета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Очередь = Неопределено;
	Если Не ДанныеРасшифровкиОтчета.Свойство("Очередь", Очередь) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторОшибки = Неопределено;
	ДанныеРасшифровкиОтчета.Свойство("ИдентификаторОшибки", ИдентификаторОшибки);
	
	Представление = ?(ЗначениеЗаполнено(ИдентификаторОшибки), НСтр("ru = 'задание'"), НСтр("ru = 'задания'"));
	
	МенюОтчетов  = Новый Массив;
	МенюДействий = Новый Массив;
	
	ДанныеПараметров = Новый Структура;
	ДанныеПараметров.Вставить("Очередь",             Очередь);
	ДанныеПараметров.Вставить("ИдентификаторОшибки", ИдентификаторОшибки);
	ДанныеПараметров.Вставить("Форма",               Форма);
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("Имя",              "Выполнить");
	ПараметрыДействия.Вставить("Заголовок",        СтрШаблон(НСтр("ru = 'Выполнить %1'"), Представление));
	ПараметрыДействия.Вставить("ИмяОбщегоМодуля",  "ОтложенныеЗаданияКлиент");
	ПараметрыДействия.Вставить("ДанныеПараметров", ДанныеПараметров);
	
	МенюДействий.Добавить(ПараметрыДействия);
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("Имя",              "Удалить");
	ПараметрыДействия.Вставить("Заголовок",        СтрШаблон( НСтр("ru = 'Удалить %1'"), Представление));
	ПараметрыДействия.Вставить("ИмяОбщегоМодуля",  "ОтложенныеЗаданияКлиент");
	ПараметрыДействия.Вставить("ДанныеПараметров", ДанныеПараметров);
	
	МенюДействий.Добавить(ПараметрыДействия);
	
	ПараметрыРасшифровки = Новый Структура;
	ПараметрыРасшифровки.Вставить("МенюОтчетов",  МенюОтчетов);
	ПараметрыРасшифровки.Вставить("МенюДействий", МенюДействий);
	ПараметрыРасшифровки.Вставить("Расшифровка",  Расшифровка);
	
	КомпоновкаДанныхКлиент.ОбработкаРасшифровкиСДополнительнымМеню(Форма, ПараметрыРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик специальных действий при расшифровке отчетов.
//
// Параметры:
//  ПараметрыДействия - Структура - с ключами:
//   * Имя       - Строка - Имя выполняемого действия
//   * Заголовок - Строка - Пользовательское представление выполняемого действия
//  ПараметрыРасшифровки - Структура - Параметры, передаваемые в форму.
//
Процедура ВыполнитьДействиеРасшифровки(ПараметрыДействия, ПараметрыРасшифровки) Экспорт
	
	ДействиеРасшифровки = ПараметрыДействия.Имя;
	
	Если ДействиеРасшифровки = "Выполнить" Тогда
		
		ДанныеПараметров = ПараметрыДействия.ДанныеПараметров;
		
		ДействиеВыполнено = ОтложенныеЗаданияВызовСервера.ВыполнитьЗаданияИзРегистраОшибкиВыполненияОтложенныхЗаданий(
								ДанныеПараметров.Очередь,
								ДанныеПараметров.ИдентификаторОшибки);
		
		Если ДействиеВыполнено Тогда
			ДанныеПараметров.Форма.СкомпоноватьРезультат();
		КонецЕсли;
		
	ИначеЕсли ДействиеРасшифровки = "Удалить" Тогда
		
		ДанныеПараметров = ПараметрыДействия.ДанныеПараметров;
		
		ДействиеВыполнено = ОтложенныеЗаданияВызовСервера.УдалитьЗаданияИзРегистраОшибкиВыполненияОтложенныхЗаданий(
								ДанныеПараметров.Очередь,
								ДанныеПараметров.ИдентификаторОшибки);
		
		Если ДействиеВыполнено Тогда
			ДанныеПараметров.Форма.СкомпоноватьРезультат();
		КонецЕсли;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не определен обработчик действия %1.'"), ПараметрыДействия.Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти