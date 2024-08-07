
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,
		"Характеристика", "Объект.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,
		"Серия", "Объект.Номенклатура");
	
	ВидыПродукции = Новый Массив;
	ВидыПродукции.Добавить(Перечисления.ВидыПродукцииИС.ПодконтрольнаяПродукцияСАТУРН);
	
	СобытияФормИСКлиентСерверПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект, ВидыПродукции, "Номенклатура");
	СобытияФормСАТУРН.УстановитьСвязиПараметровВыбораСПАТ(ЭтотОбъект, "Партия", "Объект.ПАТ");
	
	Если Не ЗначениеЗаполнено(Объект.ИсходныйКлючЗаписи) Тогда
		ПриСозданииЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Партия) Тогда
		
		СтруктураОповещения = Новый Структура("Партия, ПАТ", Объект.Партия, Объект.ПАТ);
		Оповестить("Запись_СоответствиеНомеклатурыСАТУРН", СтруктураОповещения, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	
	ХарактеристикаПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура СерияПриИзменении(Элемент)
	
	СерияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(
		Элемент,
		ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПодконтрольнаяПродукцияСАТУРН"),
		СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СобытияФормСАТУРНКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(
		Элемент, Объект, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект,, Элемент.ТекстРедактирования, СтандартнаяОбработка, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект, "Характеристика", "ХарактеристикиИспользуются"); 
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтотОбъект, "Серия", "СтатусУказанияСерий", "ТипНоменклатуры");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(ЭтотОбъект, 
		РегистрыСведений.СоответствиеНоменклатурыСАТУРН);
		
	ЗаполнитьСлужебныеРеквизитыНоменклатуры();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ХарактеристикиИспользуются Тогда
		Элементы.Характеристика.Доступность    = Истина;
		Элементы.Характеристика.ПодсказкаВвода = "";
	Иначе
		Элементы.Характеристика.Доступность    = Ложь;
		Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
	КонецЕсли;
	
	Если Форма.СерииИспользуются Тогда
		Элементы.Серия.Доступность    = Истина;
		Элементы.Серия.ПодсказкаВвода = "";
	Иначе
		Элементы.Серия.Доступность    = Ложь;
		Элементы.Серия.ПодсказкаВвода = НСтр("ru = '<серии не используются>'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере()
	
	Объект.Характеристика = Неопределено;
	Объект.Серия          = Неопределено;
	
	ЗаполнитьСлужебныеРеквизитыНоменклатуры();

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ХарактеристикаПриИзмененииНаСервере()
	
	Объект.Серия = Неопределено;
	ЗаполнитьСлужебныеРеквизитыНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура СерияПриИзмененииНаСервере()
	
	ЗаполнитьСлужебныеРеквизитыНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореНоменклатуры(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Номенклатура = Номенклатура;
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыНоменклатуры()
	
	ВременнаяТаблица = Новый ТаблицаЗначений();
	ВременнаяТаблица.Колонки.Добавить("НомерСтроки",                ОбщегоНазначения.ОписаниеТипаЧисло(5, 0, ДопустимыйЗнак.Неотрицательный));
	ВременнаяТаблица.Колонки.Добавить("Номенклатура",               Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ВременнаяТаблица.Колонки.Добавить("Характеристика",             Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ВременнаяТаблица.Колонки.Добавить("Серия",                      Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ВременнаяТаблица.Колонки.Добавить("СтатусУказанияСерий",        Новый ОписаниеТипов("Булево"));
	ВременнаяТаблица.Колонки.Добавить("ТипНоменклатуры",            Метаданные.ОпределяемыеТипы.ТипНоменклатуры.Тип);
	ВременнаяТаблица.Колонки.Добавить("ХарактеристикиИспользуются", Новый ОписаниеТипов("Булево"));
	
	НоваяСтрока = ВременнаяТаблица.Добавить();
	НоваяСтрока.НомерСтроки         = 1;
	НоваяСтрока.Номенклатура        = Объект.Номенклатура;
	НоваяСтрока.Характеристика      = Объект.Характеристика;
	НоваяСтрока.Серия               = Объект.Серия;
	НоваяСтрока.СтатусУказанияСерий = Объект.СтатусУказанияСерий;
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, ВременнаяТаблица);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(НоваяСтрока, ПараметрыУказанияСерий);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВременнаяТаблица[0]);
	
КонецПроцедуры

#КонецОбласти

