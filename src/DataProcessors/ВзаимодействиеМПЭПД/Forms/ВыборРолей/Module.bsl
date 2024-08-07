#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БезИзменения = Неопределено;
	Параметры.Свойство("ТолькоПросмотр", БезИзменения);
	
	Если БезИзменения = Истина Тогда
		Элементы.ФормаВыбрать.Видимость = Ложь;
		Элементы.СписокРолейПометка.Доступность = Ложь;
	КонецЕсли;
	
	Роль = 0;
	Параметры.Свойство("Роль", Роль);
	
	АтомарныеРолиМП = СервисВзаимодействияМПЭПДКлиентСервер.АтомарныеРолиМП();
	ПредставленияПоддерживаемыхРолейМП = СервисВзаимодействияМПЭПДКлиентСервер.ПредставленияРолейМП(Ложь);
	
	ОбязательныеРолиМП = СервисВзаимодействияМПЭПДКлиентСервер.ОбязательныеРолиМП();
	Для Каждого ОбязательнаяРоль Из ОбязательныеРолиМП Цикл
		Если ОбменСГИСЭПДКлиентСервер.ВхождениеРоли(Роль, ОбязательнаяРоль, АтомарныеРолиМП.Количество()) = Ложь Тогда
			Роль = Роль + ОбязательнаяРоль;
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого КиЗ Из ПредставленияПоддерживаемыхРолейМП Цикл
		Пометка = Ложь;
		Если ОбменСГИСЭПДКлиентСервер.ВхождениеРоли(Роль, КиЗ.Ключ, АтомарныеРолиМП.Количество()) Тогда
			Пометка = Истина;
		КонецЕсли;
		СписокРолей.Добавить(КиЗ.Ключ, КиЗ.Значение, Пометка);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СписокРолейПередНачаломИзменения(Элемент, Отказ)
	
	ОбязательныеРолиМП = СервисВзаимодействияМПЭПДКлиентСервер.ОбязательныеРолиМП();
	
	Если ОбязательныеРолиМП.Найти(Элементы.СписокРолей.ТекущиеДанные.Значение) <> Неопределено Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Это обязательная роль, ее нельзя отключить'"));		
	КонецЕсли;	

КонецПроцедуры



#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Роль = 0;
	Для Каждого ЭлементСписка Из СписокРолей Цикл
		Если ЭлементСписка.Пометка Тогда
			Роль = Роль + ЭлементСписка.Значение;
		КонецЕсли;
	КонецЦикла;

	Закрыть(Роль);

КонецПроцедуры

#КонецОбласти
