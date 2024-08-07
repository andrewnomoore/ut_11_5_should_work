#Область ПрограммныйИнтерфейс

// Работа с сохраненным выбором при пакетной загрузке кодов маркировки:
//  * Переносит данные сохраненного выбора в коды маркировки, требующие уточнения данных.
//  * Учитывает требующее маркировки количество для сброса сохраненного выбора.
//  * Учитывает состав кода маркировки для сброса сохраненного выбора.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой происходит пакетная загрузка данных
//  ДанныеШтрихкода - См. ШтрихкодированиеОбщегоНазначенияИС.ИнициализироватьДанныеШтрихкода
//  ПараметрыСканирования - См. ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования
//
Процедура ПрименитьСохраненныйВыбор(Форма, ДанныеШтрихкода, ПараметрыСканирования) Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ЗагрузкаДанныхТСД") Тогда
		Возврат;
	ИначеЕсли Форма.ЗагрузкаДанныхТСД = Неопределено Тогда
		Возврат;
	ИначеЕсли Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"ДанныеВыбораПоМаркируемойПродукции") Тогда
		Возврат;
	ИначеЕсли Форма.ДанныеВыбораПоМаркируемойПродукции = Неопределено Тогда
		Возврат;
	ИначеЕсли Не Форма.ЗагрузкаДанныхТСД.Свойство("Всего") Тогда //ЕГАИС
		Возврат;
	КонецЕсли;
	
	// Сохранение выбора в параметры сканирования
	ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Форма.ДанныеВыбораПоМаркируемойПродукции;
	
	// Определение состава полей для отбора
	СохраненныйВыбор = Форма.ДанныеВыбораПоМаркируемойПродукции;
	ПоляПоиска = Новый Структура;
	ПоляПоиска.Вставить("Номенклатура",   СохраненныйВыбор.Номенклатура);
	ПоляПоиска.Вставить("Характеристика", СохраненныйВыбор.Характеристика);
	ПоляПоиска.Вставить("Серия",          СохраненныйВыбор.Серия);
	Если Не ЗначениеЗаполнено(СохраненныйВыбор.Номенклатура) Тогда
		ПоляПоиска.Вставить("GTIN", СохраненныйВыбор.GTIN);
	КонецЕсли;
	Если ПараметрыСканирования.Свойство("ЗаполнятьДанныеВЕТИС") И ПараметрыСканирования.ЗаполнятьДанныеВЕТИС = Истина Тогда
		ПоляПоиска.Вставить("ИдентификаторПроисхожденияВЕТИС", СохраненныйВыбор.ИдентификаторПроисхожденияВЕТИС);
	КонецЕсли;
	Если ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности") И ПараметрыСканирования.ЗаполнятьСрокГодности Тогда
		ПоляПоиска.Вставить("ГоденДо", СохраненныйВыбор.ГоденДо);
	КонецЕсли;
	
	// Выбор будет сброшен по достижению неотмаркированного количества в документе
	ДоступноеКоличествоПоСохраненномуВыбору = -1;
	
	// Не сбрасывать выбор, если количество не указывается
	Если ДанныеШтрихкода.ТребуетВзвешивания И Не ПараметрыСканирования.ЗапрашиватьКоличествоМерногоТовара Тогда
	// Формы проверки и подбора
	ИначеЕсли Форма.ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор"
		Или Форма.ИмяФормы = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор" Тогда
		
		СтрокиМаркируемойПродукции = Форма.ПодобраннаяМаркируемаяПродукция.НайтиСтроки(ПоляПоиска);
		Если СтрокиМаркируемойПродукции.Количество() Тогда
			ДоступноеКоличествоПоСохраненномуВыбору = 0;
			Для Каждого СтрокаМаркируемойПродукции Из СтрокиМаркируемойПродукции Цикл
				ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору + СтрокаМаркируемойПродукции.Количество - СтрокаМаркируемойПродукции.КоличествоПодобрано;
			КонецЦикла;
		КонецЕсли;
	// Формы документов
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"ДанныеШтрихкодовУпаковокГосИС")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"Объект")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект,"Товары") Тогда
		
		Если ПоляПоиска.Свойство("ГоденДо") Тогда
			ПоляПоиска.Вставить("СрокГодности", ПоляПоиска.ГоденДо);
			ПоляПоиска.Удалить("ГоденДо");
		КонецЕсли;
		
		СтрокаМаркируемойПродукции = Форма.ДанныеШтрихкодовУпаковокГосИС.НайтиСтроки(ПоляПоиска);
		Если СтрокаМаркируемойПродукции.Количество() Тогда
			ДоступноеКоличествоПоСохраненномуВыбору = - СтрокаМаркируемойПродукции[0].Количество;
		КонецЕсли;
		Для Каждого СтрокаТовары Из Форма.Объект.Товары.НайтиСтроки(ПоляПоиска) Цикл
			ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору + СтрокаТовары.Количество;
		КонецЦикла;
		
	КонецЕсли;
	
	Пакет = Форма.ЗагрузкаДанныхТСД;
	
	ВсегоКодовМаркировки = Пакет.Всего;
	
	// При обработке кода маркировки в форме документа изменения применяются мгновенно,
	// поэтому поле Обработано содержит точное количество обработанных кодов.
	// В форме проверки и подбора обработка кода происходит отложенно, вместе с обработкой остальных кодов.
	Обработано = Пакет.Обработано;
	Если Форма.ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор"
		Или Форма.ИмяФормы = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор" Тогда
		Обработано = Пакет.Обработано - 1;
	КонецЕсли;
	
	// Первый проход - зафиксируем коды маркировки с известным составом, которые будут загружены из пакета
	ЗаполняемыйКодМаркировки = Обработано;
	Пока ЗаполняемыйКодМаркировки <> ВсегоКодовМаркировки Цикл
		
		СтрокаШтрихкод = Пакет.ШтрихкодыТСД[ЗаполняемыйКодМаркировки].РезультатОбработки.ДанныеШтрихкода;
		Если СтрокаШтрихкод <> Неопределено Тогда
			КодСоответствуетВыбору = Истина;
			Для Каждого КлючИЗначение Из ПоляПоиска Цикл
				Если КлючИЗначение.Ключ = "СрокГодности" Тогда
					КодСоответствуетВыбору = КодСоответствуетВыбору И КлючИЗначение.Значение = СтрокаШтрихкод.ГоденДо;
				Иначе
					КодСоответствуетВыбору = КодСоответствуетВыбору И КлючИЗначение.Значение = СтрокаШтрихкод[КлючИЗначение.Ключ];
				КонецЕсли;
			КонецЦикла;
			Если КодСоответствуетВыбору Тогда
				Количество = ?(ЗначениеЗаполнено(СтрокаШтрихкод.Количество), СтрокаШтрихкод.Количество, 1);
				ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору - Количество;
			КонецЕсли;
		КонецЕсли;
		ЗаполняемыйКодМаркировки = ЗаполняемыйКодМаркировки + 1;
		
	КонецЦикла;
	
	// Второй проход - заполним сохраненным выбором строки кодов маркировки
	Если ДоступноеКоличествоПоСохраненномуВыбору = 0 Тогда
		ДоступноеКоличествоПоСохраненномуВыбору = -1;
	КонецЕсли;
	ОбновляемыеШтрихкодыУпаковок = Новый Массив;
	ЗаполняемыйКодМаркировки     = Обработано;
	
	ПоляИсключения = Новый Массив;
	Если СохраненныйВыбор.Свойство("Количество") Тогда
		ПоляИсключения.Добавить("Количество");
	КонецЕсли;
	Если СохраненныйВыбор.Свойство("ВидУпаковки") И Не ЗначениеЗаполнено(СохраненныйВыбор.ВидУпаковки) Тогда
		ПоляИсключения.Добавить("ВидУпаковки");
	КонецЕсли;
	Если СохраненныйВыбор.Свойство("КоличествоПотребительскихУпаковок")	И СохраненныйВыбор.КоличествоПотребительскихУпаковок = 0 Тогда
		ПоляИсключения.Добавить("КоличествоПотребительскихУпаковок");
	КонецЕсли;
	
	ПоляИсключения.Добавить("ВидПродукции");
	ПоляИсключения.Добавить("ПолныйКодМаркировки");
	
	ПоляИсключения = СтрСоединить(ПоляИсключения, ",");
	
	Пока ДоступноеКоличествоПоСохраненномуВыбору <> 0 И ЗаполняемыйКодМаркировки <> ВсегоКодовМаркировки Цикл
		
		СтрокаШтрихкод = Пакет.ШтрихкодыТСД[ЗаполняемыйКодМаркировки];
		// Пропустим строки не требующие уточнения (игнорируем возможные изменения состава кода в них)
		Если СтрокаШтрихкод.РезультатОбработки.ТребуетсяУточнениеДанных
			Или СтрокаШтрихкод.РезультатОбработки.ТребуетсяВыборСерии Тогда
			ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору - 1;
			// Выбор будет сброшен по смене состава кода (не отображать сразу для проверки/подбора)
			Если ШтрихкодированиеИСКлиентСервер.ТребуетсяСброситьСохраненныйВыбор(СохраненныйВыбор, СтрокаШтрихкод.РезультатОбработки.ДанныеШтрихкода) Тогда
				Если Форма.ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор"
						Или Форма.ИмяФормы = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор" Тогда
					ШтрихкодированиеИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоМаркируемойПродукции(Форма, Неопределено, Ложь);
				КонецЕсли;
				Прервать;
			Иначе
				ЗаполнитьЗначенияСвойств(СтрокаШтрихкод.РезультатОбработки.ДанныеШтрихкода, СохраненныйВыбор,, ПоляИсключения);
				СтрокаШтрихкод.РезультатОбработки.ТребуетсяУточнениеДанных = Ложь;
				СтрокаШтрихкод.РезультатОбработки.ТребуетсяВыборСерии = Ложь;
				ОбновляемыеШтрихкодыУпаковок.Добавить(СтрокаШтрихкод);
			КонецЕсли;
		КонецЕсли;
		ЗаполняемыйКодМаркировки = ЗаполняемыйКодМаркировки + 1;
	КонецЦикла;
	
	// Выбор будет сброшен по завершению проверки строки
	Если ДоступноеКоличествоПоСохраненномуВыбору = 0 Тогда
		ШтрихкодированиеИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоМаркируемойПродукции(Форма, ДанныеШтрихкода, Ложь);
	КонецЕсли;
	
	// Требуется обновить существующие элементы справочника ШтрихкодыУпаковокТоваров как при уточнении данных
	Если ОбновляемыеШтрихкодыУпаковок.Количество() Тогда
		ШтрихкодированиеИСВызовСервера.ОбработатьГрупповоеУточнениеДанных(
			СохраненныйВыбор, ОбновляемыеШтрихкодыУпаковок, ПараметрыСканирования);
	КонецЕсли;
	
КонецПроцедуры

// Открыть форму уточнения данных ТСД.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма-источник вызова:
//   * ЗагрузкаДанныхТСД - См. ГрупповаяОбработкаШтрихкодовИС.РезультатЗагрузкиШтрихкодовИзТСД
//  Оповещение - ОписаниеОповещения - действие после уточнения данных
Процедура ОткрытьФормуУточненияДанныхТСД(Форма, Оповещение) Экспорт
	
	ПакетТСД = Форма.ЗагрузкаДанныхТСД;
	ДанныеДляУточнения = ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ПараметрыОткрытияФормыУточненияДанных();
	ДанныеДляУточнения.ПараметрыСканирования = ПакетТСД.ПараметрыСканирования;
	ДанныеДляУточнения.АдресДереваУпаковок = ПакетТСД.АдресДереваУпаковок;
	ДанныеДляУточнения.КодМаркировки = ПакетТСД.АгрегатТСД;
	
	ШтрихкодированиеИСКлиент.ДополнитьПараметрыУточненияИзФормыИсточника(Форма, ДанныеДляУточнения, Истина);
	
	ОткрытьФорму("ОбщаяФорма.УточнениеСоставаУпаковкиИС",
		ДанныеДляУточнения, Форма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Выводит оповещение о начале загрузки данных из ТСД
// 
// Параметры:
//  ПараметрыУведомления - Неопределено - уведомление "по-умолчанию"
//                       - Структура - кастомизированное уведомление:
//                          * Заголовок - Строка - текст заголовка,
//                          * Текст     - Строка - текст уведомления.
Процедура ОповеститьОНачалеОбработкиДанныхТСД(ПараметрыУведомления = Неопределено) Экспорт
	
	Если ПараметрыУведомления = Неопределено Тогда
		ТекстЗаголовка   = ЗаголовокОповещенияТСД();
		ТекстУведомления = НСтр("ru = 'Начата обработка полученных из ТСД данных.'");
	Иначе
		ТекстЗаголовка   = ПараметрыУведомления.Заголовок;
		ТекстУведомления = ПараметрыУведомления.Текст;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		ТекстЗаголовка,,
		ТекстУведомления,
		БиблиотекаКартинок.Информация32ГосИС);
	
КонецПроцедуры

// Выводит оповещение об окончании обработки данных ТСД.
//
// Параметры:
//  ПараметрыУведомления - Неопределено - уведомление "по-умолчанию"
//                       - Структура - кастомизированное уведомление:
//                          * Заголовок - Строка - текст заголовка,
//                          * Текст     - Строка - текст уведомления.
Процедура ОповеститьОбОкончанииОбработкиДанныхТСД(ПараметрыУведомления = Неопределено) Экспорт
	
	Если ПараметрыУведомления = Неопределено Тогда
		ТекстЗаголовка   = ЗаголовокОповещенияТСД();
		ТекстУведомления = НСтр("ru = 'Закончена обработка полученных из ТСД данных.'");
	Иначе
		ТекстЗаголовка   = ПараметрыУведомления.Заголовок;
		ТекстУведомления = ПараметрыУведомления.Текст;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		ТекстЗаголовка,,
		ТекстУведомления,
		БиблиотекаКартинок.Информация32ГосИС);
	
КонецПроцедуры

// Завершить загрузку ТСД.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма:
//  * ЗагрузкаДанныхТСД - Произвольный - реквизит формы с данными пакета загрузки
Процедура ЗавершитьЗагрузкуТСД(Форма) Экспорт
	
	Если Форма.ЗагрузкаДанныхТСД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОбОкончанииОбработкиДанныхТСД();
	Форма.ЗагрузкаДанныхТСД = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает текст заголовка оповещения для ТСД.
//
// Параметры:
// Возвращаемое значение:
//  Строка - Текст заголовка.
Функция ЗаголовокОповещенияТСД()
	
	Возврат НСтр("ru = 'Загрузка из ТСД'");
	
КонецФункции

#КонецОбласти
