
#Область ПрограммныйИнтерфейс

// Вызывает функцию модуля менеджера базы распределения, которая возвращает имя схемы компоновки данных
// по переданной базе распределения.
// Параметры:
//	БазаРаспределения - ПеречислениеСсылка.ТипыБазыРаспределенияРасходов, 
//						ПеречислениеСсылка.НаправлениеРаспределенияПоПодразделениям - база распределения.
// Возвращаемое значение:
// 	Строка - имя соотв. схемы ПравилаРаспределенияВызовСервера.ИмяСхемыБазыРаспределения()
Функция ИмяСхемыБазыРаспределения(БазаРаспределения) Экспорт
	
	Возврат ПравилаРаспределенияВызовСервера.ИмяСхемыБазыРаспределения(БазаРаспределения);
	
КонецФункции

// Возвращает схему компоновки базы распределения.
// Параметры:
//	ИмяСхемы - Строка - имя схемы компоновки данных базы распределения.
//	БазаРаспределения - ПеречислениеСсылка.ТипыБазыРаспределенияРасходов, 
//						ПеречислениеСсылка.НаправлениеРаспределенияПоПодразделениям - база распределения.
// Возвращаемое значение:
//	СхемаКомпоновкиДанных - схема компоновки базы распределения.
Функция СхемаБазыРаспределения(ИмяСхемы, БазаРаспределения) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(БазаРаспределения);
	Возврат МенеджерОбъекта.ПолучитьМакет(ИмяСхемы);
	
КонецФункции

// Возвращает макет компоновки данных по переданным настройкам компоновки данных.
// Параметры:
//	ИмяСхемы - Строка - имя схемы компоновки данных базы распределения.
//	БазаРаспределения - ПеречислениеСсылка.ТипыБазыРаспределенияРасходов, 
//						ПеречислениеСсылка.НаправлениеРаспределенияПоПодразделениям - база распределения.
//	НастройкиКомпоновкиДанныхXML - Строка - настройки компоновки данных в формате XML.
//
// Возвращаемое значение:
//	МакетКомпоновкиДанных - макет компоновки данных по настройкам компоновки.
Функция МакетКомпоновкиДанных(ИмяСхемы, БазаРаспределения, НастройкиКомпоновкиДанныхXML) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(НастройкиКомпоновкиДанныхXML);
	НастройкиКомпоновкиДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
	
	СхемаКомпоновкиДанных = ПравилаРаспределенияПовтИсп.СхемаБазыРаспределения(ИмяСхемы, БазаРаспределения);
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Возврат КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
		
КонецФункции

#КонецОбласти
