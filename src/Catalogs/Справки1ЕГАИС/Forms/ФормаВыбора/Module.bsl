
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Номенклатура")
		И Параметры.Свойство("Характеристика") Тогда
		УстановитьОтборПоНоменклатуре();
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "Запись_Справка1" И ТипЗнч(Параметр) = Тип("СправочникСсылка.Справки1ЕГАИС") Тогда
		Элементы.Список.ТекущаяСтрока = Параметр;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоНоменклатуре()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|ГДЕ
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура = &Номенклатура
	|	И СоответствиеНоменклатурыЕГАИС.Характеристика = &Характеристика");
	
	Запрос.УстановитьПараметр("Номенклатура",   Параметры.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Параметры.Характеристика);
	
	СписокАлкогольнаяПродукция = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("АлкогольнаяПродукция");
	
	Если СписокАлкогольнаяПродукция.Количество() > 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"АлкогольнаяПродукция",
			СписокАлкогольнаяПродукция,
			ВидСравненияКомпоновкиДанных.ВСписке,,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
		Элементы.НадписьОтбораПоНоменклатуре.Видимость = Истина;
		СтрокаОтбораПоНоменклатуре = НСтр("ru = 'Соответствующие номенклатуре: %1'");
		ПредставлениеНоменклатуры = ИнтеграцияИС.ПредставлениеНоменклатуры(Параметры.Номенклатура, Параметры.Характеристика);
		
		НадписьОтбораПоНоменклатуре = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СтрокаОтбораПоНоменклатуре,
			ПредставлениеНоменклатуры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

