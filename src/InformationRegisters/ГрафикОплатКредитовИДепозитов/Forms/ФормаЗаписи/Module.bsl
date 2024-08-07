
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Запись.Сумма + Запись.Проценты + Запись.Комиссия = 0 Тогда
		
		Текст  = НСтр("ru='В строке должна быть указана хотя бы одна из сумм графика!'");		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		Отказ = Истина;
		
	КонецЕсли;
	
	Если ДоговорЗакрыт(Запись.ВариантГрафика) Тогда
		Отказ = Истина;
		Текст = НСтр("ru = 'Изменения графика по закрытому договору запрещены!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоговорЗакрыт(ВариантГрафика)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВариантГрафика, "Владелец")
		= Перечисления.СтатусыДоговоровКонтрагентов.Закрыт;
	
КонецФункции

#КонецОбласти
