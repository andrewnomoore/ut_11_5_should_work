
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СвойстваУстановлены = Параметры.Свойство("ПараметрыПриложенияЯндекс", ПараметрыПриложенияЯндекс)
		И Параметры.Свойство("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	Если Не СвойстваУстановлены Тогда
		// Проверка обязательных параметров
		ВызватьИсключение НСтр("ru = 'Для открытия формы необходимо передать параметры.'");
	КонецЕсли;

	Элементы.ГруппаУспешнаяАвторизация.Видимость = Ложь;
	Элементы.ГруппаОшибкаАвторизации.Видимость = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если (Не ЗавершениеРаботы) И АвторизацияУспешна Тогда
		Оповестить("ОбновитьАвторизациюПриложения", АвторизацияУспешна);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолучитьКодПодтвержденияНажатие(Элемент)

	АдресАвторизации = ПолучитьАдресАвторизации(ПараметрыПриложенияЯндекс.client_id);
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресАвторизации);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Авторизовать(Команда)

	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	ОчиститьСообщения();

	АвторизоватьНаСервере();

	Если АвторизацияУспешна Тогда
		Элементы.Авторизовать.Доступность = Ложь;
		Элементы.ГруппаУспешнаяАвторизация.Видимость = Истина;
		Элементы.ГруппаОшибкаАвторизации.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУспешнаяАвторизация.Видимость = Ложь;
		Элементы.ГруппаОшибкаАвторизации.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресАвторизации(ИдентификаторПриложения)

	Возврат ИнтеграцияСМаркетплейсамиСервер.АдресЗапросаКодаПодтверждения(ИдентификаторПриложения);

КонецФункции

&НаСервере
Процедура АвторизоватьНаСервере()

	ПараметрыАвторизации = ИнтеграцияСМаркетплейсамиСервер.ЗапроситьТокеныАвторизацииПоКоду(ПараметрыПриложенияЯндекс, КодПодтверждения);

	АвторизацияУспешна = Не ПараметрыАвторизации.Отказ;

	Если АвторизацияУспешна Тогда
		ДанныеПриложения = Новый Структура();
		ДанныеПриложения.Вставить("access_token", ПараметрыАвторизации.access_token);
		ДанныеПриложения.Вставить("expires_in", ТекущаяДатаСеанса() + ПараметрыАвторизации.expires_in);
		ДанныеПриложения.Вставить("refresh_token", ПараметрыАвторизации.refresh_token);
		ИнтеграцияСМаркетплейсамиСервер.ЗаписатьДанныеПриложенияВХранилище(УчетнаяЗаписьМаркетплейса, ПараметрыПриложенияЯндекс, ДанныеПриложения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти