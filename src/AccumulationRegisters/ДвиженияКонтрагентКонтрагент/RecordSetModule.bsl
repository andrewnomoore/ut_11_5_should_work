#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ДополнительныеСвойства.Свойство("СвойстваДокумента") Тогда
		ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
