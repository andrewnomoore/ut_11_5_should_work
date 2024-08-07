
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьОрганизациюВладельцаМестаПрименения();
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Объект.Ссылка, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияСтрокойОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьОрганизациюВладельца" Тогда
		
		ПоказатьЗначение(, Организация);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьИзСервиса(Команда)
	
	ПараметрОповещения = ЗагрузитьМестоПримененияНаСервере();
	
	Если ЗначениеЗаполнено(ПараметрОповещения) Тогда
		
		ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Объект.Ссылка, ПараметрОповещения);
		УстановитьОрганизациюВладельцаМестаПрименения();
		
		Закрыть();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДанныеСАТУРН(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор",                 Объект.Идентификатор);
	ПараметрыФормы.Вставить("НеПоказыватьСостояниеЗагрузки", Истина);
	
	ОткрытьФорму(
		"Справочник.МестаПримененияСАТУРН.Форма.ДанныеКлассификатора",
		ПараметрыФормы, ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗагрузитьМестоПримененияНаСервере()
	
	Результат = ИнтерфейсСАТУРНВызовСервера.МестоПримененияПоИдентификатору(Объект.Идентификатор);
		
	Если Не ПустаяСтрока(Результат.ТекстОшибки) Тогда
		
		ВызватьИсключение Результат.ТекстОшибки;
		
	Иначе
		
		ДанныеМестаПрименения = ИнтерфейсСАТУРН.ДанныеМестаПрименения(Результат.Элемент);
		МестоПрименения = ИнтеграцияСАТУРН.ЗагрузитьМестоПрименения(ДанныеМестаПрименения); 

	КонецЕсли;
	
	Возврат МестоПрименения;
	
КонецФункции

&НаСервере
Процедура УстановитьОрганизациюВладельцаМестаПрименения()
	
	МассивОрганизаций     = Справочники.МестаПримененияСАТУРН.ОрганизацииВладельцыМестаПрименения(Объект.Ссылка);
	МассивСтрок           = Новый Массив;
	КоличествоОрганизаций = МассивОрганизаций.Количество();
	
	Если КоличествоОрганизаций = 0 Тогда
		
		Строка = Новый ФорматированнаяСтрока(НСтр("ru = '<не указана>'"),, ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
		МассивСтрок.Добавить(Строка);
		
	ИначеЕсли КоличествоОрганизаций = 1 Тогда
		
		Организация = МассивОрганизаций[0];
		
		Строка = Новый ФорматированнаяСтрока(Строка(Организация),, ЦветаСтиля.ЦветГиперссылкиГосИС,, "ОткрытьОрганизациюВладельца");
		МассивСтрок.Добавить(Строка);
		
	Иначе
		
		Организация  = МассивОрганизаций[0];
		ШаблонСтроки = НСтр("ru = '%1 ( + еще %2 )'");
		
		Строка = Новый ФорматированнаяСтрока(СтрШаблон(ШаблонСтроки, Организация, КоличествоОрганизаций - 1),, ЦветаСтиля.ЦветГиперссылкиГосИС,, "ОткрытьОрганизациюВладельца");
		МассивСтрок.Добавить(Строка);
		
	КонецЕсли;
	
	ОрганизацияСтрокой = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ТребуетсяЗагрузка.Видимость = Объект.ТребуетсяЗагрузка;
	
КонецПроцедуры

#КонецОбласти
