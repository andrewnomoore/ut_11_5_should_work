#Область ПрограммныйИнтерфейс

#Область Локализация

Процедура МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты) Экспорт
	
	ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции);
	ДобавитьРеквизитТекстСостояниеВЕТИС(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	
КонецПроцедуры

Процедура МодификацияЭлементовФормы(Форма) Экспорт
	
	СобытияФормИС.ВстроитьСтрокуИнтеграцииВДокументОснованиеПоПараметрам(Форма, "ВЕТИС.ДокументОснование");
	
КонецПроцедуры

Процедура ЗаполнениеРеквизитовФормы(Форма) Экспорт
	
	ИмяРеквизитаФормыОбъект = Форма.ПараметрыИнтеграцииГосИС.Получить("ВЕТИС").ИмяРеквизитаФормыОбъект;
	
	Общие = Форма.ПараметрыИнтеграцииГосИС.Получить("ИС.ДокументОснование");
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ВЕТИС.ДокументОснование");
	Если ПараметрыИнтеграции <> Неопределено И ЗначениеЗаполнено(ПараметрыИнтеграции.ИмяРеквизитаФормы) Тогда
		Если ЗначениеЗаполнено(Форма[Общие.ИмяРеквизитаФормы]) Тогда
			Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы].Видимость = Ложь;
		Иначе
			ТекстНадписи = ИнтеграцияВЕТИСВызовСервера.ТекстНадписиПоляИнтеграцииВФормеДокументаОснования(Форма[ИмяРеквизитаФормыОбъект].Ссылка);
			Форма[ПараметрыИнтеграции.ИмяРеквизитаФормы] = ТекстНадписи;
			Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы].Видимость = ЗначениеЗаполнено(ТекстНадписи);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСтатусыОформления(Ссылка, ПараметрыИнтеграцииГосИС, РеквизитыФормыСтатусовОформления) Экспорт
	
	ПараметрыИнтеграции = ПараметрыИнтеграцииГосИС.Получить("ВЕТИС.ДокументОснование");
	Если ПараметрыИнтеграции <> Неопределено И ЗначениеЗаполнено(ПараметрыИнтеграции.ИмяРеквизитаФормы) Тогда
		ТекстНадписи = ИнтеграцияВЕТИСВызовСервера.ТекстНадписиПоляИнтеграцииВФормеДокументаОснования(Ссылка);
		РеквизитыФормыСтатусовОформления.Вставить(ПараметрыИнтеграции.ИмяРеквизитаФормы, ТекстНадписи);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	СобытияФормВЕТИСПереопределяемый.ПослеЗаписиНаСервере(Форма);
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СобытияФормВЕТИСПереопределяемый.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СобытияФормВЕТИСПереопределяемый.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормВЕТИСПереопределяемый.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции)
	
	ОбщиеНастройки = СобытияФормИС.ОбщиеПараметрыИнтеграции("СобытияФормВЕТИС");
	ПараметрыИнтеграции.Вставить("ВЕТИС", ОбщиеНастройки);
	
КонецПроцедуры

// Встраивает реквизит - форматированную строку перехода к ВЕТИС в прикладные формы
// 
// Параметры:
//   Форма                - ФормаКлиентскогоПриложения - форма в которую происходит встраивание
//   ПараметрыИнтеграции  - Структура        - (См. ПараметрыИнтеграцииВЕТИС)
//   ДобавляемыеРеквизиты - Массив           - массив реквизитов формы к добавлению

Процедура ДобавитьРеквизитТекстСостояниеВЕТИС(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты)
	
	ПараметрыИнтеграцииВЕТИС = ПараметрыИнтеграцииВЕТИС(Форма);
	
	Если ЗначениеЗаполнено(ПараметрыИнтеграцииВЕТИС.ИмяРеквизитаФормы) Тогда
		ПараметрыИнтеграции.Вставить("ВЕТИС.ДокументОснование", ПараметрыИнтеграцииВЕТИС);
		Реквизит = Новый РеквизитФормы(
			ПараметрыИнтеграцииВЕТИС.ИмяРеквизитаФормы,
			Новый ОписаниеТипов("ФорматированнаяСтрока"),,
			ПараметрыИнтеграцииВЕТИС.Заголовок);
		ДобавляемыеРеквизиты.Добавить(Реквизит);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, заполненную значениями по умолчанию, используемую для интеграции реквизитов ВЕТИС
//   в прикладные формы конфигурации - потребителя библиотеки ГосИС. Если передана форма - сразу заполняет ее
//   специфику в переопределяемом модуле.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - форма для которой возвращаются параметры интеграции
//
// ВозвращаемоеЗначение:
//   Структура - (См. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования).
//
Функция ПараметрыИнтеграцииВЕТИС(Форма = Неопределено)
	
	ПараметрыНадписи = СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования();
	ПараметрыНадписи.Вставить("Ключ",              "ЗаполнениеТекстаДокументаВЕТИС");
	ПараметрыНадписи.Вставить("МодульЗаполнения",  "СобытияФормВЕТИС");
	ПараметрыНадписи.Вставить("ИмяЭлементаФормы",  "ТекстДокументаВЕТИС");
	ПараметрыНадписи.Вставить("ИмяРеквизитаФормы", "ТекстДокументаВЕТИС");
	
	Если НЕ(Форма = Неопределено) Тогда
		СобытияФормВЕТИСПереопределяемый.ПриОпределенииПараметровИнтеграцииВЕТИС(Форма, ПараметрыНадписи);
	КонецЕсли;
	
	Возврат ПараметрыНадписи;
	
КонецФункции

#КонецОбласти

