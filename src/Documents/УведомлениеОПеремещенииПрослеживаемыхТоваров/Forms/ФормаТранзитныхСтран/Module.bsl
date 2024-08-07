#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТранзитныеСтраныЕАЭС        = Параметры.ТранзитныеСтраныЕАЭС;
	КлючСтроки                  = Параметры.КлючСтроки;
	Контрагент                  = Параметры.Контрагент;
	
	ФильтрПоТаблице = Новый Структура("КлючСтроки", КлючСтроки);
	
	ТранзитныеСтраны.Загрузить(
		ТранзитныеСтраныЕАЭС.Выгрузить(ФильтрПоТаблице, "Страна"));
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	СписокСтран = Новый СписокЗначений;
	
	Для Каждого ТекущаяСтрока Из ТранзитныеСтраны Цикл
		
		Если СписокСтран.НайтиПоЗначению(ТекущаяСтрока.Страна) <> Неопределено Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 повторно указана страна %2.'"),
				ТранзитныеСтраны.Индекс(ТекущаяСтрока) + 1,
				ТекущаяСтрока.Страна);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , , , Отказ);
		КонецЕсли;
		
		СписокСтран.Добавить(ТекущаяСтрока.Страна);
		
		Если НЕ УправлениеКонтактнойИнформацией.ЭтоСтранаУчастникЕАЭС(ТекущаяСтрока.Страна) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 указана страна %2, которая не является членом ЕАЭС.'"),
				ТранзитныеСтраны.Индекс(ТекущаяСтрока) + 1,
				ТекущаяСтрока.Страна);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , , , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТранзитныеСтраны.Количество() > 3 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Можно указать только три страны.'"), , , , Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Модифицированность И ПроверитьЗаполнение() Тогда
		
		ОповеститьОВыборе(
			Новый Структура("ТранзитныеСтраныЕАЭС, КлючСтроки", ТранзитныеСтраны, КлючСтроки));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
