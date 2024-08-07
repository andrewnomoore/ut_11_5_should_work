#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияСАТУРНПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Серия");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерПартии");
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Продукция""'");
	
	Для Каждого СтрокаТовары Из Товары Цикл
		Если Не ЗначениеЗаполнено(СтрокаТовары.НомерПартии) Тогда
			ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru = 'Данные партии'"), СтрокаТовары.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Товары", СтрокаТовары.НомерСтроки, "ДанныеНовойПартии"),,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	ИнтеграцияСАТУРНПереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияСАТУРН.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект);
	ИнтеграцияСАТУРН.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект, "Сырье");
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	ИнтеграцияСАТУРН.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Идентификатор = Неопределено;
	
	Для Каждого СтрокаТовары Из Товары Цикл
		СтрокаТовары.Партия = Неопределено;
		СтрокаТовары.НомерПартии  = Неопределено;
	КонецЦикла;
	
	Для Каждого СтрокаТовары Из Сырье Цикл
		СтрокаТовары.Партия = Неопределено;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПроизводственнаяОперацияСАТУРН.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиПартийСАТУРН.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	РегистрыСведений.МестаХраненияПартийСАТУРН.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеСАТУРН.ДанныеЗаполненияПроизводственнаяОперацияСАТУРН(ОрганизацияСАТУРН);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеСАТУРН.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
