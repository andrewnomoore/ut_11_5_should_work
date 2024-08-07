///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработатьОткрытиеОповещения(Контекст) Экспорт
	
	Если ЗначениеЗаполнено(Контекст.Источник) 
		Или НапоминанияПользователяКлиентСервер.ЭтоНавигационнаяСсылкаСообщения(Контекст.НавигационнаяСсылка) Тогда
		ПараметрыНапоминания = НапоминанияПользователяКлиентСервер.ОписаниеНапоминания(Контекст);
		
		КлючНапоминания = НапоминанияПользователяВызовСервера.ПолучитьКлючЗаписиИОтключитьНапоминание(ПараметрыНапоминания);
		
		НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ПараметрыНапоминания);
		Оповестить("Запись_НапоминанияПользователя", Новый Структура, КлючНапоминания);
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Контекст.НавигационнаяСсылка);
	Иначе
		ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", Новый Структура("ДанныеКлюча", Контекст));	
	КонецЕсли;
	
КонецПроцедуры

Процедура Напомнить(Ссылка, Параметры) Экспорт
	ПараметрыФормы = Новый Структура("Источник", Ссылка);
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", 
		ПараметрыФормы, Параметры.Форма);
КонецПроцедуры

#Область Обсуждения

Процедура ДобавитьКомандыОбсуждения(ПараметрыКоманд, Команды, КомандаПоУмолчанию) Экспорт
	
	Если ТипЗнч(ПараметрыКоманд.Сообщение) <> Тип("СообщениеСистемыВзаимодействия") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	Если Не ПараметрыРаботыКлиента.ИспользуютсяНапоминанияПользователя Тогда
		Возврат;
	КонецЕсли;
		
	КомандыНапоминаний = Новый ОписаниеКомандыСистемыВзаимодействия(Новый Массив, НСтр("ru='Напомнить...'"));
	КомандыНапоминаний.Картинка = ?(ПараметрыРаботыКлиента.ОтображатьНапоминанияВЦентреОповещений, 
		БиблиотекаКартинок.ЦентрОповещений, БиблиотекаКартинок.Напоминание);
	
	ДобавитьКоманду(КомандыНапоминаний.Команда, ПараметрыКоманд, "НапомнитьЧерезЧас", НСтр("ru='Через час'"));
	ДобавитьКоманду(КомандыНапоминаний.Команда, ПараметрыКоманд, "НапомнитьЧерез2Часа", НСтр("ru='Через 2 часа'"));
	ДобавитьКоманду(КомандыНапоминаний.Команда, ПараметрыКоманд, "НапомнитьЧерез3Часа", НСтр("ru='Через 4 часа'"));
	ДобавитьКоманду(КомандыНапоминаний.Команда, ПараметрыКоманд, "НапомнитьЗавтраУтром", НСтр("ru='Завтра утром'"));
	ДобавитьКоманду(КомандыНапоминаний.Команда, ПараметрыКоманд, "НапомнитьНачалоСледующейНедели", НСтр("ru='Начало следующей недели'"));
	ДобавитьРазделитель(КомандыНапоминаний.Команда);
	ДобавитьКоманду(КомандыНапоминаний.Команда, ПараметрыКоманд, "НастройкиНапоминаний", НСтр("ru='Настройки...'"));
	
	Команды.Добавить(КомандыНапоминаний);

КонецПроцедуры

Процедура СоздатьНапоминание(ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ИдентификаторКоманды = "НастройкиНапоминаний" Тогда
		НапоминанияПользователяКлиент.ОткрытьНастройки();
		Возврат;
	КонецЕсли;
	
	ВремяНапоминания = ОбщегоНазначенияКлиент.ДатаСеанса();
	Если ДополнительныеПараметры.ИдентификаторКоманды = "НапомнитьЧерезЧас" Тогда
		ВремяНапоминания = ВремяНапоминания + 60*60;
	ИначеЕсли ДополнительныеПараметры.ИдентификаторКоманды = "НапомнитьЧерез2Часа" Тогда
		ВремяНапоминания = ВремяНапоминания + 2*60*60;
	ИначеЕсли ДополнительныеПараметры.ИдентификаторКоманды = "НапомнитьЧерез3Часа" Тогда
		ВремяНапоминания = ВремяНапоминания + 3*60*60;
	ИначеЕсли ДополнительныеПараметры.ИдентификаторКоманды = "НапомнитьЗавтраУтром" Тогда
		ВремяНапоминания = КонецДня(ВремяНапоминания) + 9*60*60;
	ИначеЕсли ДополнительныеПараметры.ИдентификаторКоманды = "НапомнитьНачалоСледующейНедели" Тогда
		ВремяНапоминания = КонецНедели(ВремяНапоминания) + 9*60*60;
	КонецЕсли;           
	
	НапоминанияПользователяКлиент.НапомнитьВУказанноеВремя(НСтр("ru='Напоминание об отложенном сообщении'"), 
		ВремяНапоминания, , "e1ccs/data/msg?id=" + ДополнительныеПараметры.ИдентификаторСообщения);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьКоманду(КомандыПодменю, ПараметрыСообщения, ИдентификаторКоманды, Представление)
	
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ТекстСообщения", ПараметрыСообщения.Сообщение.Текст);
	ПараметрыКоманды.Вставить("ИдентификаторСообщения", ПараметрыСообщения.Сообщение.Идентификатор);
	ПараметрыКоманды.Вставить("ИдентификаторКоманды", ИдентификаторКоманды);
	КомандаНапоминания = Новый ОписаниеКомандыСистемыВзаимодействия(
		Новый ОписаниеОповещения("СоздатьНапоминание", ЭтотОбъект, ПараметрыКоманды), Представление);
	КомандыПодменю.Добавить(КомандаНапоминания);
	
КонецПроцедуры

Процедура ДобавитьРазделитель(КомандыПодменю)
	Разделитель = Новый ОписаниеКомандыСистемыВзаимодействия(Неопределено);
	КомандыПодменю.Добавить(Разделитель);
КонецПроцедуры

#КонецОбласти