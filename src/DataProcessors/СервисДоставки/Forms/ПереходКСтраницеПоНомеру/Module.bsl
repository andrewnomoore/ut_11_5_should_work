#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.НомерСтраницы <> 0 Тогда
		НомерСтраницы = Параметры.НомерСтраницы;
	Иначе
		НомерСтраницы = 1;
	КонецЕсли;
	
	Если Параметры.МаксимальныйНомерСтраницы <> 0 Тогда
		ВсегоСтраниц = Параметры.МаксимальныйНомерСтраницы;
	Иначе
		ВсегоСтраниц = 1;
	КонецЕсли;
	
	Если НомерСтраницы > ВсегоСтраниц Тогда
		ВсегоСтраниц = ВсегоСтраниц;
	КонецЕсли;
	
	Элементы.НомерСтраницы.МаксимальноеЗначение = ВсегоСтраниц;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Закрыть(НомерСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти



