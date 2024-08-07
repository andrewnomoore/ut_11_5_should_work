
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипНазначения = Перечисления.ТипыНазначений.Собственное Тогда
		Элементы.Партнер.Заголовок = НСтр("ru='Переработчик'");
		
	ИначеЕсли Объект.ТипНазначения = Перечисления.ТипыНазначений.ПоставкаПодПринципала Тогда
		Элементы.Партнер.Заголовок = НСтр("ru='Принципал'");
		
	Иначе
		Элементы.Партнер.Заголовок = НСтр("ru='Давалец'");
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Элементы.ТипНазначения.Видимость = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	Элементы.Партнер.Видимость = ЗначениеЗаполнено(Объект.Партнер);
	Элементы.Договор.Видимость = ЗначениеЗаполнено(Объект.Партнер);
	Элементы.КонтролироватьТолькоНаличие.Видимость = ЗначениеЗаполнено(Объект.НаправлениеДеятельности)
		И Не ЗначениеЗаполнено(Объект.Партнер)
		И Не ЗначениеЗаполнено(Объект.Заказ);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

