
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СообщениеОбмена = Параметры.СообщениеОбмена;
	ПричинаОтклонения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеОбмена, "ПричинаОтклонения");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьЭлектронныйДокумент(Команда)
	ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(СообщениеОбмена);
	Закрыть();
КонецПроцедуры

#КонецОбласти