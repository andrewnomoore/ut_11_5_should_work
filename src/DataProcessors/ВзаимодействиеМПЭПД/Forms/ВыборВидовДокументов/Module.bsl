#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БезИзменения = Неопределено;
	Параметры.Свойство("ТолькоПросмотр", БезИзменения);
	
	Если БезИзменения = Истина Тогда
		Элементы.ФормаВыбрать.Видимость = Ложь;
		Элементы.СписокВидовДокументовПометка.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ВидыДокументов = 0;
	Параметры.Свойство("ВидыДокументов", ВидыДокументов);
	
	АтомарныеВидыДокументовМП = СервисВзаимодействияМПЭПДКлиентСервер.АтомарныеВидыДокументовМП();
	ПредставленияПоддерживаемыхРолейМП = СервисВзаимодействияМПЭПДКлиентСервер.ПредставленияВидовДокументовМП(Ложь);
	
	Для Каждого КиЗ Из ПредставленияПоддерживаемыхРолейМП Цикл
		Пометка = Ложь;
		Если ОбменСГИСЭПДКлиентСервер.ВхождениеРоли(ВидыДокументов, КиЗ.Ключ, АтомарныеВидыДокументовМП.Количество()) Тогда
			Пометка = Истина;
		КонецЕсли;
		СписокВидовДокументов.Добавить(КиЗ.Ключ, КиЗ.Значение, Пометка);
	КонецЦикла;

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВидыДокументов = 0;
	Для Каждого ЭлементСписка Из СписокВидовДокументов Цикл
		Если ЭлементСписка.Пометка Тогда
			ВидыДокументов = ВидыДокументов + ЭлементСписка.Значение;
		КонецЕсли;
	КонецЦикла;

	Закрыть(ВидыДокументов);

КонецПроцедуры

#КонецОбласти
