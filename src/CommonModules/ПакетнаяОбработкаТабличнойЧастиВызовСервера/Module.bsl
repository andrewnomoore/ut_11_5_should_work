////////////////////////////////////////////////////////////////////////////////
// Модуль предоставляет клиенту интерфейс к серверной части функциональности
// механизма обработки табличной части.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Вызов этой функции должен осуществляться только из клиентского модуля ПакетнаяОбработкаТабличнойЧастиКлиент.
// 
// Параметры:
//  ТекущаяСтрока - см. ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧВЦикле.ТекущаяСтрока
//  СтруктураДействий - см. ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧВЦикле.Действия
//  КэшированныеЗначения - см. ПакетнаяОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения
//
Процедура ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Если КэшированныеЗначения = Неопределено Тогда
		КэшированныеЗначения = ПакетнаяОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	КонецЕсли;
	
	ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения)
	
КонецПроцедуры

// Возвращает данные об упаковке.
// 
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - Номенклатура, по которой требуется получить коэффициент упаковки.
//  Упаковка - СправочникСсылка.УпаковкиЕдиницыИзмерения - Упаковка, по которой требуется получить коэффициент упаковки.
//  КэшированныеЗначения - см. ПакетнаяОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения
// 
// Возвращаемое значение:
//  см. Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки
//
Функция ДанныеОбУпаковке(Номенклатура, Упаковка, КэшированныеЗначения) Экспорт 
	
	Возврат ПакетнаяОбработкаТабличнойЧастиСервер.ДанныеОбУпаковке(Номенклатура, Упаковка, КэшированныеЗначения);
	
КонецФункции

#КонецОбласти
