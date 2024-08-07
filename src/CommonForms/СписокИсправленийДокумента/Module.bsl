
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИсправляемыйДокумент = ?(ЗначениеЗаполнено(Параметры.ИсправляемыйДокумент), Параметры.ИсправляемыйДокумент, Параметры.ТекущийДокумент);
	ТекущийДокумент = Параметры.ТекущийДокумент;
	
	УстановитьУсловноеОформление();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокИсправлений, "ИсправляемыйДокумент", ИсправляемыйДокумент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсправляемыйДокументНажатие(Элемент, СтандартнаяОбработка)
	
	ПоказатьЗначение(, ИсправляемыйДокумент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокИсправлений

&НаКлиенте
Процедура СписокИсправленийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элементы.СписокИсправлений.ТекущиеДанные.Ссылка);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокИсправленийДата.Имя);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокИсправленийНомер.Имя);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокИсправленийСсылка.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение =  Новый ПолеКомпоновкиДанных("СписокИсправлений.Ссылка");
	ОтборЭлемента.ВидСравнения =  ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ТекущийДокумент;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
КонецПроцедуры

#КонецОбласти

