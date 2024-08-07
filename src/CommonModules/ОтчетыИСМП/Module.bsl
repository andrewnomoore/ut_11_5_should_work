
#Область ПрограммныйИнтерфейс

// Задает настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//  Настройки - См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КодыМаркировкиДляДекларацииИСМП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасхожденийПриВыводеИзОборотаИСМП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасхожденийПриМаркировкеТоваровИСМП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СписокКИНаБалансеИСМП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СведенияОбОтклоненияхИСМП);
	
КонецПроцедуры

// Вызывается при выполнении отчета с помощью метода СкомпоноватьРезультат.
//
// Параметры:
//  НастройкиОтчета - НастройкиКомпоновкиДанных - настройки отчета
//  ВнешниеНаборыДанных - Неопределено - входящий параметр для заполнения
Процедура ПриКомпоновкеРезультата(НастройкиОтчета, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Перем ИмяОтчета, ДанныеИнформационнойБазы;
	
	Если НЕ НастройкиОтчета.ДополнительныеСвойства.Свойство("ИмяОтчета", ИмяОтчета) Тогда
		Возврат;
	КонецЕсли;
	
	СписокОтчетов    = ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, "ДокументИСМП");
	
	Если ИмяОтчета = Метаданные.Отчеты.КодыМаркировкиДляДекларацииИСМП.Имя Тогда
		ДанныеИнформационнойБазы = Отчеты.КодыМаркировкиДляДекларацииИСМП.ДанныеИнформационнойБазы(СписокОтчетов);
	ИначеЕсли ИмяОтчета = Метаданные.Отчеты.СписокКИНаБалансеИСМП.Имя Тогда
		КлючПредопределенногоВарианта = Неопределено;
		НастройкиОтчета.ДополнительныеСвойства.Свойство("КлючПредопределенногоВарианта", КлючПредопределенногоВарианта);
		ДанныеИнформационнойБазы = Отчеты.СписокКИНаБалансеИСМП.ДанныеИнформационнойБазы(
			СписокОтчетов, КлючПредопределенногоВарианта = "РасшифровкаПоКодамМаркировки");
	ИначеЕсли ИмяОтчета = Метаданные.Отчеты.СведенияОбОтклоненияхИСМП.Имя Тогда
		
		КлючПредопределенногоВарианта = Неопределено;
		НастройкиОтчета.ДополнительныеСвойства.Свойство("КлючПредопределенногоВарианта", КлючПредопределенногоВарианта);
		ДанныеИнформационнойБазы = Отчеты.СведенияОбОтклоненияхИСМП.ДанныеИнформационнойБазы(
			СписокОтчетов, КлючПредопределенногоВарианта = "РасшифровкаПоКодамМаркировки");
		
		Если КлючПредопределенногоВарианта = "РасшифровкаПоКодамМаркировки" Тогда
			
			ВидПродукции = Неопределено;
			Если НастройкиОтчета.ДополнительныеСвойства.Свойство("ФормаПараметрыОтбор") 
				И ЗначениеЗаполнено(НастройкиОтчета.ДополнительныеСвойства.ФормаПараметрыОтбор) Тогда
				НастройкиОтчета.ДополнительныеСвойства.ФормаПараметрыОтбор.Свойство("ВидПродукции", ВидПродукции);
			КонецЕсли;
			
			Если ВидПродукции = Неопределено
				И СписокОтчетов.Количество() Тогда
				ВидПродукции = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СписокОтчетов.Получить(0).Значение, "ВидПродукции");
			КонецЕсли;
			
			Если Не ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияПодконтрольнаяВЕТИС(ВидПродукции) Тогда
				ОтключитьИспользованиеУВыбранногоПоля(НастройкиОтчета.Выбор.Элементы, "ИдентификаторВСД");
				ОтключитьИспользованиеУГруппировки(НастройкиОтчета.Структура, "ИдентификаторВСД");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДанныеИнформационнойБазы <> Неопределено Тогда
		ВнешниеНаборыДанных = Новый Структура;
		ВнешниеНаборыДанных.Вставить("ДанныеИнформационнойБазы" + ИмяОтчета, ДанныеИнформационнойБазы);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает значение параметра компоновки данных.
//
// Параметры:
//  НастройкиОтчета - НастройкиКомпоновкиДанных - формируемые настройки отчета,
//  ИмяПараметра - Строка - имя параметра, значение которого требуется получить.
//
// Возвращаемое значение:
//  Произвольный
Функция ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, ИмяПараметра) Экспорт
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	
	Если Параметр <> Неопределено Тогда
		Возврат Параметр.Значение;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтключитьИспользованиеУВыбранногоПоля(ЭлементыВыбора, ИмяПоля)
	
	Для Каждого ЭлементВыбора Из ЭлементыВыбора Цикл
		
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
		Если ТипЗнч(ЭлементВыбора) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			Если ЭлементВыбора.Поле = ПолеКомпоновки Тогда
				ЭлементВыбора.Использование = Ложь;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ЭлементВыбора) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			ОтключитьИспользованиеУВыбранногоПоля(ЭлементВыбора.Элементы, ИмяПоля);
		Иначе
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтключитьИспользованиеУГруппировки(Структура, ИмяГруппировки)
	
	Для Каждого ЭлементСтруктуры Из Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") Тогда
			ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяГруппировки);
			Для Каждого ПолеГруппировки Из ЭлементСтруктуры.ПоляГруппировки.Элементы Цикл
				Если ТипЗнч(ПолеГруппировки) = Тип("ПолеГруппировкиКомпоновкиДанных")
					И ПолеГруппировки.Поле = ПолеКомпоновки Тогда
					ПолеГруппировки.Использование = Ложь;
				КонецЕсли;
			КонецЦикла;
			ОтключитьИспользованиеУВыбранногоПоля(ЭлементСтруктуры.Выбор.Элементы, ИмяГруппировки);
			ОтключитьИспользованиеУГруппировки(ЭлементСтруктуры.Структура, ИмяГруппировки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
