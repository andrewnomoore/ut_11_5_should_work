
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ПараметрыПоиска) Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыПоиска);
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КодОбъектаПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ОчиститьСообщения();
	
	Если Не РеквизитыПоискаКорректны() Тогда	
		Возврат;
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура;
	
	Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(GUID) Тогда
		ПараметрыПоиска.Вставить("GUID", GUID);
		Закрыть(ПараметрыПоиска);
		Возврат;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ПараметрыПоиска.Вставить("Идентификатор", Идентификатор);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыПоиска.Вставить("Организация", Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		ПараметрыПоиска.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Статус) Тогда
		ПараметрыПоиска.Вставить("Статус", Статус);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КадастровыйНомер) Тогда
		ПараметрыПоиска.Вставить("КадастровыйНомер", КадастровыйНомер);
	КонецЕсли;
	
	Закрыть(ПараметрыПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностьюЭлементовФормы()
	
	УказанИдентификатор = Не ПустаяСтрока(GUID);
	
	УказанРеквизитНеТочногоСоответствия = Не ПустаяСтрока(Наименование);
	
	УказанРеквизитТочногоСоответствия = УказанИдентификатор 
		Или ЗначениеЗаполнено(Организация)
		Или ЗначениеЗаполнено(Идентификатор)
		Или ЗначениеЗаполнено(Статус)
		Или ЗначениеЗаполнено(КадастровыйНомер);
	
	Элементы.Идентификатор.Доступность    = Не УказанРеквизитНеТочногоСоответствия;
	Элементы.Организация.Доступность      = Не УказанРеквизитНеТочногоСоответствия;
	Элементы.GUIDОбъекта.Доступность      = Не УказанРеквизитНеТочногоСоответствия;
	Элементы.Статус.Доступность           = Не УказанРеквизитНеТочногоСоответствия;
	Элементы.КадастровыйНомер.Доступность = Не УказанРеквизитНеТочногоСоответствия;
	
	Элементы.ПолноеНаименование.Доступность  = Не УказанРеквизитТочногоСоответствия;

	Элементы.GUIDОбъекта.ОтметкаНезаполненного = УказанИдентификатор И НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(GUID);
	
КонецПроцедуры

&НаКлиенте
Функция РеквизитыПоискаКорректны()

	Отказ = Ложь;
	
	Если Не ПустаяСтрока(GUID)
		И НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(GUID) Тогда
		
		ТекстОшибки = НСтр("ru = 'Неправильно указан идентификатор'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, ,"GUID",, Отказ);
		
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

#КонецОбласти
