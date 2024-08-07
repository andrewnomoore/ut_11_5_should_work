#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ЭтоНовый() И НЕ ПометкаУдаления Тогда
		Наименование = РегистрыСведений.АналитикаУчетаНоменклатуры.НаименованиеКлючаАналитики(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	УдалитьАналитикуКлюча();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура УдалитьАналитикуКлюча()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.АналитикаУчетаНоменклатуры КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики = &Ключ
	|");
	Запрос.УстановитьПараметр("Ключ", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.АналитикаУчетаНоменклатуры.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
