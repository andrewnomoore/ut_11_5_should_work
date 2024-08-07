#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыНабора = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
	ПараметрыНабора.Используется = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов");
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_КорректировкаНазначенияТоваров", ПараметрыНабора);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
