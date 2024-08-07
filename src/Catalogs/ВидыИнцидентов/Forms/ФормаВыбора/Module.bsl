
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	Элементы.ДекорацияРасшифровкаОтбора.Видимость = Ложь;

	Если ЗначениеЗаполнено(Параметры.ТекущийВид) Тогда

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", Параметры.ТекущийВид,
			ВидСравненияКомпоновкиДанных.НеРавно, , Истина);
	ИначеЕсли Параметры.Свойство("Инцидент") Тогда

		НастроитьСписок(Параметры.ТекущаяСтрока);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьСписок(ВидИнцидента = Неопределено, ОтключениеОтбора = Ложь)

	Элементы.Список.Обновить();

	Если Не ЗначениеЗаполнено(ВидИнцидента) Или ОтключениеОтбора Тогда

		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Ссылка");
		Элементы.ДекорацияРасшифровкаОтбора.Видимость = Ложь;

		Возврат;

	КонецЕсли;

	НаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидИнцидента, "НаборСвойств");

	ОграничениеВыбораВидаИнцидентов = Справочники.Инциденты.ОграничениеВыбораНовогоВидаИнцидентов(НаборСвойств);

	Если ОграничениеВыбораВидаИнцидентов Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", ВидИнцидента,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);

		ТекстСообщения = (НСтр(
			"ru = 'Если инцидент уже в работе, то произвольное изменение вида инцидента может привести к проблемам. Показаны виды инцидентов, которые можно выбрать без привнесения проблем.'"));

		Если Пользователи.РолиДоступны("РедактированиеРеквизитовОбъектов") Тогда
			ИмяНавигационнойСсылки = "ОтключитьОтбор";
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Если инцидент уже в работе, то произвольное изменение вида инцидента может привести к проблемам. Показаны виды инцидентов, которые можно выбрать без привнесения проблем. <a href=""%1"">Показать все виды инцидентов.</a>'"), ИмяНавигационнойСсылки);
		КонецЕсли;

		Элементы.ДекорацияРасшифровкаОтбора.Видимость = Истина;

		Элементы.ДекорацияРасшифровкаОтбора.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ТекстСообщения);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРасшифровкаОтбораОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылка = "ОтключитьОтбор" Тогда 
		НастроитьСписок(,Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
