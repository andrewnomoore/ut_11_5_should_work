#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	УчетнаяЗаписьМаркетплейса =
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "УчетнаяЗаписьМаркетплейса", Справочники.УчетныеЗаписиМаркетплейсов.ПустаяСсылка());
	ВидМаркетплейса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗаписьМаркетплейса, "ВидМаркетплейса");
	ВидМаркетплейсаПустаяСсылка = ПредопределенноеЗначение("Перечисление.ВидыМаркетплейсов.ПустаяСсылка");
	
	Если ВидМаркетплейса <> ВидМаркетплейсаПустаяСсылка Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;

		Если ВидМаркетплейса = ПредопределенноеЗначение("Перечисление.ВидыМаркетплейсов.МаркетплейсOzon") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СхемыРаботыТорговыхПлощадок.FBO"), НСтр("ru = 'FBO'"));
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СхемыРаботыТорговыхПлощадок.FBS"), НСтр("ru = 'FBS'"));
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СхемыРаботыТорговыхПлощадок.DBS"), НСтр("ru = 'RealFBS'"));
		ИначеЕсли ВидМаркетплейса = ПредопределенноеЗначение("Перечисление.ВидыМаркетплейсов.МаркетплейсЯндексМаркет") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СхемыРаботыТорговыхПлощадок.FBO"), 	НСтр("ru = 'FBY'"));
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СхемыРаботыТорговыхПлощадок.FBS"), 	НСтр("ru = 'FBS'"));
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СхемыРаботыТорговыхПлощадок.Express"), НСтр("ru = 'Express'"));
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СхемыРаботыТорговыхПлощадок.DBS"), 	НСтр("ru = 'DBS'"));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает представление схемы работы для учетной записи маркетплейса.
//
// Параметры:
//   СхемаРаботы - ПеречислениеСсылка.СхемыРаботыТорговыхПлощадок - схема работы, по которой необходимо получить представление.
//   УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись для получения представления схемы работы.
//
// Возвращаемое значение:
//   Строка - представление схемы работы.
//
Функция ПредставлениеСхемыРаботы(СхемаРаботы, УчетнаяЗаписьМаркетплейса) Экспорт

	ПараметрыВыбора = Новый Структура("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	ДанныеВыбора = ПолучитьДанныеВыбора(ПараметрыВыбора);

	ЗначениеПеречисления = ДанныеВыбора.НайтиПоЗначению(СхемаРаботы);
	Если ЗначениеПеречисления = Неопределено Тогда
		Возврат "";
	КонецЕсли;

	Представление = ?(ПустаяСтрока(ЗначениеПеречисления.Представление),
		Строка(ЗначениеПеречисления.Значение), ЗначениеПеречисления.Представление);

	Возврат ЗначениеПеречисления.Представление;

КонецФункции

#КонецОбласти

#КонецЕсли