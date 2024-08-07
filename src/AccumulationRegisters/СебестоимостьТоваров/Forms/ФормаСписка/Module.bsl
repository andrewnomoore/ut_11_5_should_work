
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗакрытиеМесяцаСервер.УстановитьОтборыВФормеСпискаРегистра(ЭтотОбъект, Список);
	Элементы.СтоимостьНУ.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Значение = Элемент.ТекущиеДанные[Поле.Имя];
	ПоказатьЗначение(Неопределено, Значение);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Если ЗакрытиеМесяцаСервер.ЭтаФормаОткрытаИзФормыЗакрытияМесяца(ЭтотОбъект) Тогда
		ОтборКомпоновки = Настройки.Элементы.Найти(Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
		ОтборКомпоновки.Элементы.Очистить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
