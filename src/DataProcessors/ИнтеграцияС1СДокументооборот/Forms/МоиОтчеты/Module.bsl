#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДниНедели.Добавить(НСтр("ru='Понедельник'"));
	ДниНедели.Добавить(НСтр("ru='Вторник'"));
	ДниНедели.Добавить(НСтр("ru='Среда'"));
	ДниНедели.Добавить(НСтр("ru='Четверг'"));
	ДниНедели.Добавить(НСтр("ru='Пятница'"));
	ДниНедели.Добавить(НСтр("ru='Суббота'"));
	ДниНедели.Добавить(НСтр("ru='Воскресенье'"));
	
	НастройкаПериода = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот",
		"ЕжедневныеОтчеты_НастройкаПериода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьПодключение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы Тогда
		СтруктураПериода = Новый Структура("Вариант, ДатаНачала, ДатаОкончания",
			НастройкаПериода.Вариант,
			НастройкаПериода.ДатаНачала,
			НастройкаПериода.ДатаОкончания);
		ПередЗакрытиемНаСервере(СтруктураПериода);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтеграцияС1СДокументооборотом_УспешноеПодключение" И Источник <> ЭтотОбъект Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ДокументооборотОбъект" И Источник = ЭтотОбъект Тогда
		ОбновитьСписокДокументовЧастично(Параметр.ID);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот";
	
	ОткрытьФорму(ИмяФормыПараметров,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Документ = Элементы.Список.ТекущиеДанные;
	Если Документ <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(Документ.СсылкаТип, Документ.СсылкаID, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ЕжедневныйОтчет",,ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	УстановитьПометкуУдаленияНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ЕжедневныйОтчет",,ЭтотОбъект);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	Документ = Элементы.Список.ТекущиеДанные;
	
	Если Документ <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(Документ.СсылкаТип, Документ.СсылкаID, ЭтотОбъект);
	КонецЕсли;
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаления(Команда)
	
	УстановитьПометкуУдаленияНаКлиенте();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокДокументов();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериода(Команда)
	
	Оповещение = Новый ОписаниеОповещения("НастройкаПериодаЗавершение", ЭтотОбъект);
	
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода;
	ДиалогПериода.Период = НастройкаПериода;
	ДиалогПериода.Показать(Оповещение);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериодаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		НастройкаПериода = Результат;
		ОбновитьСписокДокументов();
	КонецЕсли;
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет подключение к ДО, выводя окно авторизации, если необходимо, и изменяя форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключение()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,
		ЭтотОбъект);
	
КонецПроцедуры

// Вызывается после проверки подключения к ДО и изменяет форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	ОбработатьФормуСогласноВерсииСервиса();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДокументы(Прокси, НастройкаПериода)
	
	СписокУсловий = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	УсловияОтбора = СписокУсловий.conditions; // СписокXDTO
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "byUser";
	Условие.value = Истина;
	УсловияОтбора.Добавить(Условие);
	
	Если ЗначениеЗаполнено(НастройкаПериода.ДатаНачала) Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "beginDate";
		Условие.value = НастройкаПериода.ДатаНачала;
		УсловияОтбора.Добавить(Условие);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкаПериода.ДатаОкончания) Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "endDate";
		Условие.value = НастройкаПериода.ДатаОкончания;
		УсловияОтбора.Добавить(Условие);
	КонецЕсли;
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMDailyReport",
		СписокУсловий);
	
	Возврат Ответ.items;
	
КонецФункции

&НаСервере
Процедура УстановитьОформлениеСписка(УсловноеОформление)

	// установка оформления для просроченных задач
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СписокНекорректнаяДлительность");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  WebЦвета.Красный; 
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("Список");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДокументов()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ДокументыXDTO = ПолучитьДокументы(Прокси, НастройкаПериода);
	ЗаполнитьСписокДокументов(ДокументыXDTO);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДокументовЧастично(ТекущийДокумент = Неопределено)
	
	Если Список.Количество() = 0 Тогда
		ОбновитьСписокДокументов();
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ДокументыXDTO = ПолучитьДокументы(Прокси, НастройкаПериода);
	СсылкиСтрокКУдалению = Список.Выгрузить().ВыгрузитьКолонку("СсылкаID");
	
	Для Каждого СтрокаXDTO Из ДокументыXDTO Цикл
		Строки = Список.НайтиСтроки(Новый Структура("СсылкаID",СтрокаXDTO.object.objectID.ID));
		Если Строки.Количество() > 0 Тогда
			Строка = Строки[0];
			СсылкиСтрокКУдалению.Удалить(СсылкиСтрокКУдалению.Найти(СтрокаXDTO.object.objectID.ID));
		Иначе
			Строка = Список.Добавить();
		КонецЕсли;
		ЗаполнитьСтрокуСписка(Строка, СтрокаXDTO.object);
	КонецЦикла;
	
	Для Каждого Ссылка Из СсылкиСтрокКУдалению Цикл
		Строки = Список.НайтиСтроки(Новый Структура("СсылкаID",Ссылка));
		Если Строки.Количество() > 0 Тогда
			Список.Удалить(Строки[0]);
		КонецЕсли;
	КонецЦикла;
	
	Список.Сортировать("Дата");
	
	УстановитьТекущуюСтроку(ТекущийДокумент);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументов(ДокументыXDTO)
	
	ТекущийДокумент = Элементы.Список.ТекущаяСтрока;
	Если ТекущийДокумент <> неопределено Тогда
		ТекущийДокумент = Список.НайтиПоИдентификатору(ТекущийДокумент).СсылкаID;
	КонецЕсли;
	
	Список.Очистить();
	
	Для Каждого ДокументXDTO Из ДокументыXDTO Цикл
		СтрокаСписка = Список.Добавить();
		ЗаполнитьСтрокуСписка(СтрокаСписка, ДокументXDTO.object)
	КонецЦикла;
	
	Список.Сортировать("Дата");
	
	УстановитьТекущуюСтроку(ТекущийДокумент);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуСписка(СтрокаСписка, ДокументXDTO)
	
	СтрокаСписка.Дата = ДокументXDTO.date;
	СтрокаСписка.ДеньНедели = ДниНедели.Получить(ДеньНедели(ДокументXDTO.date) - 1).Значение;
	СтрокаСписка.НачалоДня = ДокументXDTO.dayBegin;
	СтрокаСписка.ОкончаниеДня = ДокументXDTO.dayEnd;
	СтрокаСписка.ДлительностьРабот = ДокументXDTO.duration;
	СтрокаСписка.НекорректнаяДлительность =  ДокументXDTO.durationIncorrect;
	СтрокаСписка.Картинка = 1;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(СтрокаСписка, ДокументXDTO.author, "Автор", Ложь);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(СтрокаСписка, ДокументXDTO.user, "Пользователь", Ложь);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(СтрокаСписка, ДокументXDTO, "Ссылка", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтроку(СсылкаID)
	
	Если ЗначениеЗаполнено(СсылкаID) Тогда
		Для Каждого Строка Из Список Цикл
			Если Строка.СсылкаID = СсылкаID Тогда
				Элементы.Список.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияНаКлиенте()
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = "";
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"), Элементы.Список.ТекущиеДанные.Ссылка);
	Иначе
		ТекстВопроса = НСтр("ru='Пометить выделенные элементы на удаление?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("УстановитьПометкуУдаленияНаКлиентеЗавершение", ЭтотОбъект);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПоказатьВопросДаНет(Оповещение, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияНаКлиентеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкуУдаленияНаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаленияНаНаСервере()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	СписокОбъектов = Новый Массив;
	
	Для Каждого НомерСтроки Из Элементы.Список.ВыделенныеСтроки Цикл
		Данные = Список.НайтиПоИдентификатору(НомерСтроки);
		СписокОбъектов.Добавить(Новый Структура("ID, Тип", Данные.СсылкаID, Данные.СсылкаТип));
	КонецЦикла;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПометитьНаУдалениеСнятьПометкуОбъектов(
		Прокси,
		СписокОбъектов);
	
	ОбновитьСписокДокументовЧастично();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПередЗакрытиемНаСервере(СтруктураПериода)
	
	НастройкаПериода = Новый СтандартныйПериод(СтруктураПериода.Вариант);
	НастройкаПериода.ДатаНачала = СтруктураПериода.ДатаНачала;
	НастройкаПериода.ДатаОкончания = СтруктураПериода.ДатаОкончания;
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтеграцияС1СДокументооборот", "ЕжедневныеОтчеты_НастройкаПериода", НастройкаПериода);
	
КонецПроцедуры

&НаСервере
Функция ОбработатьФормуСогласноВерсииСервиса()
	
	Заголовок = НСтр("ru = 'Мои отчеты'");
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
		Элементы.ГруппаФункционалНеПоддерживается.Видимость = Истина;
		Элементы.ГруппаПроверкаАвторизации.Видимость = Истина;
		Элементы.ДекорацияФункционалНеПоддерживается.Заголовок = НСтр("ru = 'Нет доступа к 1С:Документообороту.'");
		Элементы.Список.Видимость = Ложь;
		Возврат Ложь;
	КонецЕсли;
	
	ФормаОбработанаУспешно = Истина;
	
	Попытка
		
		Элементы.ГруппаПроверкаАвторизации.Видимость = Ложь;
		
		Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3")
				Или ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("3.0.1.1") Тогда
			Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтотОбъект);
			Элементы.Список.Видимость = Ложь;
		Иначе
			Элементы.ГруппаФункционалНеПоддерживается.Видимость = Ложь;
			Элементы.Список.Видимость = Истина;
			
			УстановитьОформлениеСписка(УсловноеОформление);
			ОбновитьСписокДокументов();
		КонецЕсли;
		
	Исключение
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.НужноОбработатьФорму(ИнформацияОбОшибке()) Тогда
			ОбработатьФормуСогласноВерсииСервиса();
		КонецЕсли;
		
	КонецПопытки;
	
	Возврат ФормаОбработанаУспешно;
	
КонецФункции

#КонецОбласти