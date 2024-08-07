#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокТипов = Документы.ВводОстатковВзаиморасчетов.СписокДоступныхТиповОбъектовРасчетов(
		Параметры.ХозяйственнаяОперация,
		Параметры.ЭтоРасчетыМеждуОрганизациями,
		Параметры.ЭтоРозничныйПокупатель);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокТипов

&НаКлиенте
Процедура СписокТиповВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.СписокТипов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ТекущиеДанные = Элементы.СписокТипов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Значение);
	Иначе
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти
