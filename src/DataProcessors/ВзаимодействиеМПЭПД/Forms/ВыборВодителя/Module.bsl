
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	ИдентификаторЭДО = Параметры.ИдентификаторЭДО;
	
	Если ТипЗнч(Параметры.СтруктураОтбора) = Тип("Структура") Тогда
		СтруктураОтбора = Параметры.СтруктураОтбора;
	Иначе
		СтруктураОтбора = Новый Структура; 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураОтбора.Вставить("Организация", Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЭДО) Тогда
		СтруктураОтбора.Вставить("ИдентификаторЭДО", ИдентификаторЭДО);
	КонецЕсли;
	
	ЗаполнитьТаблицуМобильныхУстройств(СтруктураОтбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаМобильныхУстройств

&НаКлиенте
Процедура ТаблицаМобильныхУстройствВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.ТаблицаМобильныхУстройств.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		Результат = Новый Структура;
		Результат.Вставить("Наименование", ТекущаяСтрока.Наименование);
		Результат.Вставить("Организация", ТекущаяСтрока.Организация);
		Результат.Вставить("ИдентификаторЭДО", ТекущаяСтрока.ИдентификаторЭДО);
		Результат.Вставить("ИдентификаторМП", ТекущаяСтрока.ИдентификаторМП);
		Результат.Вставить("Идентификатор", ТекущаяСтрока.Идентификатор);

		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуМобильныхУстройств(СтруктураОтбора)
	
	ВключаяНеактивные = Истина;
	ТаблицаПодключенныхМП = СервисВзаимодействияМПЭПД.СписокПодключенныхМП(СтруктураОтбора, ВключаяНеактивные);
	ТаблицаМобильныхУстройств.Загрузить(ТаблицаПодключенныхМП);
	
КонецПроцедуры

#КонецОбласти
