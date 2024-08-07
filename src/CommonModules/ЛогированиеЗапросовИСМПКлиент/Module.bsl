#Область ПрограммныйИнтерфейс

//Включает логирование запросов в текущем сейнсе на время ЗаписыватьСекунд.
// 
// Параметры:
// 	Форма            - ФормаКлиентскогоПриложения - Форма-владелец.
// 	ЗаписыватьСекунд - Неопределено, Число - Количество секунд, после которых прекратится запись логов запросов.
// 	НовыйЛог         - Булево              - Добавляет новый слой логирования, который обязательно должен завершаться
// 	                                         методом см. ЗавершитьЛогированиеЗапросовПоИдентификатору. 
// 	                                         Возвращаются параметры логирования с текущим значением идентификатора логов.
Процедура ВключитьЛогированиеЗапросов(Форма, ЗаписыватьСекунд = 300, НовыйЛог = Ложь) Экспорт
	
	ЛогированиеЗапросовИСМПВызовСервера.ВключитьЛогированиеЗапросов(ЗаписыватьСекунд, НовыйЛог);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Логирование запросов включено'"));
	
	Форма.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Параметры открытия формы проверки кодов маркировки.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции
// * Организация  - ОпределяемыйТип.Организация        - Организация.
// * Штрихкоды    - Строка, Массив из Строка           - Начальное значение.
Функция ПараметрыОткрытияПроверкиКодовМаркирови() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Штрихкоды");
	ВозвращаемоеЗначение.Вставить("Организация");
	ВозвращаемоеЗначение.Вставить("ВидПродукции");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Открывает рабочее место проверки кодов маркировки.
// 
// Параметры:
// 	ПараметыОткрытия - См. ПараметрыОткрытияПроверкиКодовМаркирови.
// 	Форма            - ФормаКлиентскогоПриложения - Форма-источник возниконовления события.
Процедура ОткрытьРабочееМестоПроверкиКодовМаркировки(ПараметыОткрытия, Форма, РежимОткрытияОкна = Неопределено) Экспорт
	
	Если РежимОткрытияОкна = Неопределено Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПроверкаКодовМаркировкиИСМП.Форма",
		ПараметыОткрытия,
		Форма,,,,,
		РежимОткрытияОкна);
	
КонецПроцедуры

// Открывает панель администрирования ИС МП.
// 
// Параметры:
// 	Форма            - ФормаКлиентскогоПриложения - Форма-источник возниконовления события.
// 	ПараметыОткрытия - См. ПараметрыОткрытияПроверкиКодовМаркирови.
Процедура ОткрытьПанельАдминистрирования(Форма, ПараметыОткрытия = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияИСМП.Форма.НастройкиИСМП", ПараметыОткрытия, Форма);
	
КонецПроцедуры

Функция ВыполняетсяЛогированиеЗапросов() Экспорт
	Возврат ЛогированиеЗапросовИСМПВызовСервера.ВыполняетсяЛогированиеЗапросов();
КонецФункции

// Выводит содержимое в лог запросов.
// 
// Параметры:
//  ТекстДляВывода - Строка - Текст для вывода в лог.
Процедура Вывести(ТекстДляВывода) Экспорт
	
	ЛогированиеЗапросовИСМПВызовСервера.Вывести(ТекстДляВывода);
	
КонецПроцедуры

#КонецОбласти