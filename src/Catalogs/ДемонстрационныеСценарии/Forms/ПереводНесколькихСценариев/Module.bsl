
#Область ОбработчикиСобытийФормы

 &НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработатьПереданныеПараметры(Параметры, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	ЯзыкиКонфигурации = ДемонстрационныеСценарии.ЯзыкиКонфигурации();
	
	Элементы.ИсходныйЯзык.СписокВыбора.ЗагрузитьЗначения(ЯзыкиКонфигурации);
	Элементы.ЦелевойЯзык.СписокВыбора.ЗагрузитьЗначения(ЯзыкиКонфигурации);
	
	ДемонстрационныеСценарии.УстановитьНастройкуПоЯзыкамВФорме(ЭтотОбъект, "ИсходныйЯзык", "ЦелевойЯзык"); 
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

 &НаКлиенте
 Процедура УстанавливатьСтатусПриИзменении(Элемент)
	 
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПеревод(Команда)
	
	ОчиститьСообщения();
	
	Если Не РезультатПроверкиЗаполнения() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Закрыть(СтруктураВозврата());
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьПереданныеПараметры(Параметры, Отказ)
	
	ТекстСообщенияНетДляПеревода = НСтр("ru = 'Не передано ни одного объекта для перевода'");
	
	Если  Параметры.ПереводимыеОбъекты.Количество() = 0 Тогда
		
		
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из Параметры.ПереводимыеОбъекты Цикл
		
		Если ТипЗнч(ЭлементСписка.Значение) = Тип("СправочникСсылка.ДемонстрационныеСценарии") Тогда
			
			ПереводимыеСценарии.Добавить(ЭлементСписка.Значение);
			
		ИначеЕсли ТипЗнч(ЭлементСписка.Значение) = Тип("СправочникСсылка.Глоссарий") Тогда
			
			ПереводимыеГлоссарии.Добавить(ЭлементСписка.Значение); 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПереводимыеСценарии.Количество() = 0 
		И ПереводимыеГлоссарии.Количество() = 0 Тогда
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщенияНетДляПеревода);
		Отказ = Истина;
		
		Возврат;
		
	КонецЕсли;

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.УстанавливаемыйСтатус.Доступность = Форма.УстанавливатьСтатус;
	
КонецПроцедуры

&НаКлиенте
Функция РезультатПроверкиЗаполнения()
	
	ЗаполненоКорректно = Истина;
	
	Если Не ЗначениеЗаполнено(ИсходныйЯзык) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указан язык, с которого будет выполняться перевод'"),,"ИсходныйЯзык");
		ЗаполненоКорректно = Ложь;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(ЦелевойЯзык) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указан язык, на который будет выполняться перевод'"),,"ЦелевойЯзык");
		ЗаполненоКорректно = Ложь;
	КонецЕсли;
	
	Если ЗаполненоКорректно 
		И ИсходныйЯзык = ЦелевойЯзык Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Исходный и целевой языки одинаковые'"),,"ЦелевойЯзык");
		ЗаполненоКорректно = Ложь
		
	КонецЕсли; 
	
	Если УстанавливатьСтатус 
		И Не ЗначениеЗаполнено(УстанавливаемыйСтатус) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указан устанавливаемый статус'"),,"УстанавливаемыйСтатус");
		ЗаполненоКорректно = Ложь;
		
	КонецЕсли;
	
	Возврат ЗаполненоКорректно;

КонецФункции

&НаКлиенте
Функция СтруктураВозврата()

	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("ИсходныйЯзык",                      ИсходныйЯзык);
	СтруктураВозврата.Вставить("ЦелевойЯзык",                       ЦелевойЯзык);
	СтруктураВозврата.Вставить("УстанавливатьСтатус",               УстанавливатьСтатус);
	СтруктураВозврата.Вставить("УстанавливаемыйСтатус",             УстанавливаемыйСтатус);
	СтруктураВозврата.Вставить("ПерезаписыватьСуществующийПеревод", ПерезаписыватьСуществующийПеревод);
	СтруктураВозврата.Вставить("ПереводимыеГлоссарии",              ПереводимыеГлоссарии);
	СтруктураВозврата.Вставить("ПереводимыеСценарии",               ПереводимыеСценарии);
	
	Возврат СтруктураВозврата;

КонецФункции

#КонецОбласти



