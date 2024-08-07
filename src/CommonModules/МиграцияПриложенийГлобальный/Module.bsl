#Область СлужебныйПрограммныйИнтерфейс

// Нужно из-за того что в веб-клиенте в неоткрытой форме не выполняется обработчик ожидания
Процедура ОбновитьСтатусПереходаВСервис() Экспорт
	
	Форма = МиграцияПриложенийКлиент.ФормаПереходВСервис();
	Если Форма = Неопределено Тогда
		ОтключитьОбработчикОжидания("ОбновитьСтатусПереходаВСервис");
	Иначе
		Форма.ОбновлениеСтатусаПерехода();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьОбработчикОбновленияСтатусаПереходаВСервис() Экспорт
	
	ПодключитьОбработчикОжидания("ОбновитьСтатусПереходаВСервис", 5, Ложь);
	
КонецПроцедуры

Процедура ОтключитьОбработчикОбновленияСтатусаПереходаВСервис() Экспорт
	
	ОтключитьОбработчикОжидания("ОбновитьСтатусПереходаВСервис");
	
КонецПроцедуры

#КонецОбласти
