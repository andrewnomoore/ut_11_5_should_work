
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриИзмененииТипаВЕТИС(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриИзмененииТипаВЕТИС(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДатаСинхронизацииПриИзменении(Элемент)
	
	Запись.Смещение = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипВЕТИСПриИзменении(Элемент)
	
	ПриИзмененииТипаВЕТИС(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииТипаВЕТИС(Форма)

	Форма.Элементы.Предприятие.Доступность = Форма.Запись.ТипВЕТИС = ПредопределенноеЗначение("Перечисление.ТипыВЕТИС.ЗаписиСкладскогоЖурнала")
		Или Форма.Запись.ТипВЕТИС = ПредопределенноеЗначение("Перечисление.ТипыВЕТИС.ВетеринарноСопроводительныеДокументы");
		
	Если Не Форма.Элементы.Предприятие.Доступность Тогда
		Форма.Элементы.Предприятие.ПодсказкаВвода = НСтр("ru = '<для всех предприятий>'");
		Если ЗначениеЗаполнено(Форма.Запись.Предприятие) Тогда
			Форма.Запись.Предприятие = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Форма.Элементы.ХозяйствующийСубъект.Доступность = Форма.Запись.ТипВЕТИС = ПредопределенноеЗначение("Перечисление.ТипыВЕТИС.ЗаписиСкладскогоЖурнала")
		Или Форма.Запись.ТипВЕТИС = ПредопределенноеЗначение("Перечисление.ТипыВЕТИС.ВетеринарноСопроводительныеДокументы");
		
	Если Не Форма.Элементы.ХозяйствующийСубъект.Доступность Тогда
		Форма.Элементы.ХозяйствующийСубъект.ПодсказкаВвода = НСтр("ru = '<для всех организаций>'");
		Если ЗначениеЗаполнено(Форма.Запись.Предприятие) Тогда
			Форма.Запись.ХозяйствующийСубъект = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти