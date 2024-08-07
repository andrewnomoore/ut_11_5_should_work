#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	АдресСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.АдресВебСервиса1СДокументооборот();
	ЭтоПользовательЗаданияОбмена = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ЭтоПользовательЗаданияОбмена();
	Параметры.Свойство("ВызовДляПользователяЗаданияОбмена", ВызовДляПользователяЗаданияОбмена);
	Параметры.Свойство("ВызовДляНастройкиДоступа", ВызовДляНастройкиДоступа);
	
	Если ВызовДляПользователяЗаданияОбмена Или ЭтоПользовательЗаданияОбмена Тогда
		ИмяПользователя = Константы.ИнтеграцияС1СДокументооборотИмяПользователяДляОбмена.Получить();
		Пароль = Константы.ИнтеграцияС1СДокументооборотПарольДляОбмена.Получить();
		
	ИначеЕсли ПараметрыСеанса.ИнтеграцияС1СДокументооборотПарольИзвестен
			И Не ПараметрыСеанса.ИнтеграцияС1СДокументооборотИспользуетсяАутентификацияОС
			И Не ПараметрыСеанса.ИнтеграцияС1СДокументооборотИспользуетсяАутентификацияJWT Тогда
		ИмяПользователя = ПараметрыСеанса.ИнтеграцияС1СДокументооборотИмяПользователя;
		Пароль = ПараметрыСеанса.ИнтеграцияС1СДокументооборотПароль;
		
	КонецЕсли;
	
#Если Не ВебКлиент Тогда
	// Добавим в список выбора имя пользователя ИС.
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	Элементы.ИмяПользователя.СписокВыбора.Добавить(ПользовательИБ.Имя);
	Элементы.ИмяПользователя.КнопкаВыпадающегоСписка = Истина;
#КонецЕсли
	
	// Если вызов - автоматический, при проверке подключения, и аутентификация ОС оказалась успешной,
	// то форму открывать не нужно.
	Если Параметры.АвтоматическийВызовПриПроверкеПодключения
			И (ИспользуетсяАутентификацияОС Или ИспользуетсяАутентификацияJWT) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьИспользованиеАутентификацииБезЛогина();
	
	ПарольСохранен = Ложь;
	
	Если Не ВызовДляПользователяЗаданияОбмена Или ЭтоПользовательЗаданияОбмена Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПрочитатьНастройкиАвторизации(
			ИмяПользователя,
			ПарольСохранен,
			Пароль);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ЗначениеЗаполнено(ИмяПользователя)
			И Не ИспользуетсяАутентификацияОС
			И Не ИспользуетсяАутентификацияJWT Тогда
		ТекущийЭлемент = Элементы.ИмяПользователя;
		ПоказатьПредупреждение(, НСтр("ru = 'Не заполнено имя пользователя 1С:Документооборота.'"));
		Возврат;
	КонецЕсли;
	
	ЗакончитьАвторизацию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОКЗавершение(Результат, ТекстСообщенияОбОшибке) Экспорт
	
	Если Результат = "Подробнее" Тогда
		ПоказатьПредупреждение(, ТекстСообщенияОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаJWT(Команда)
	
	Оповещение = Новый ОписаниеОповещения("НастройкаJWTЗавершение", ЭтотОбъект);
	ИмяФормыJWT = "Обработка.ПанельАдминистрированияБИД.Форма.НастройкаАутентификацииЧерезJWTТокены";
	
	ОткрытьФорму(ИмяФормыJWT,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаJWTЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ЗакончитьАвторизацию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьИспользованиеАутентификацииБезЛогина()
	
	ИспользуетсяАутентификацияОС = Ложь;
	ИспользуетсяАутентификацияJWT = Ложь;
	УстановитьВидимостьЭлементов();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ПроверитьИспользованиеАутентификацииБезЛогинаЗавершение",
		ЭтотОбъект);
	ДлительнаяОперация = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПодключитьсяИПолучитьВерсиюСервисаАсинхронно(
		"",
		"",
		УникальныйИдентификатор,
		Ложь);
	Если ДлительнаяОперация <> Неопределено Тогда
		ЭтотОбъект.Доступность = Ложь;
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьЗапросАсинхронно(
			ЭтотОбъект,
			ДлительнаяОперация,
			ОповещениеОЗавершении,
			Истина,
			НСтр("ru = 'Установка соединения с 1С:Документооборот.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеАутентификацииБезЛогинаЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	ЭтотОбъект.Доступность = Истина;
	
	Если Результат = Неопределено Тогда
		Если Открыта() Тогда
			Закрыть(Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		ПараметрыОперации = Результат.РезультатДлительнойОперации;
		ВерсияСервиса = ПараметрыОперации.ИнтеграцияС1СДокументооборотВерсияСервиса;
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
			ИспользуетсяАутентификацияОС = ПараметрыОперации.ИнтеграцияС1СДокументооборотИспользуетсяАутентификацияОС;
			ИспользуетсяАутентификацияJWT = ПараметрыОперации.ИнтеграцияС1СДокументооборотИспользуетсяАутентификацияJWT;
		КонецЕсли;
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПриАвторизации(ИспользуетсяАутентификацияJWT);
		
		УстановитьВидимостьЭлементов(Истина);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ВызватьИсключение Результат.ПодробноеПредставлениеОшибки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементов(УстановитьОтметкаНезаполненного = Ложь)
	
	Элементы.НастройкаJWT.Видимость = ВызовДляНастройкиДоступа;
	Элементы.ДекорацияИспользуетсяАутентификацияОС.Видимость = ИспользуетсяАутентификацияОС;
	Элементы.ДекорацияИспользуетсяАутентификацияJWT.Видимость = ИспользуетсяАутентификацияJWT;
	
	КлючСохраненияПоложенияОкна = СтрШаблон("НастройкаJWT%1АутентификацияОС%2АутентификацияJWT%3",
		Элементы.НастройкаJWT.Видимость,
		Элементы.ДекорацияИспользуетсяАутентификацияОС.Видимость,
		Элементы.ДекорацияИспользуетсяАутентификацияJWT.Видимость);
		
	Если УстановитьОтметкаНезаполненного Тогда
		Элементы.ИмяПользователя.АвтоОтметкаНезаполненного = Не ИспользуетсяАутентификацияОС
			И Не ИспользуетсяАутентификацияJWT;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьАвторизацию()
	
	ТекстСообщенияОбОшибке = "";
	ИспользуетсяАутентификацияОССтароеЗначение = ИспользуетсяАутентификацияОС;
	ИспользуетсяАутентификацияJWTСтароеЗначение = ИспользуетсяАутентификацияJWT;
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПроверитьПодключение(
			ИмяПользователя,
			Пароль,
			АдресСервиса,
			ИспользуетсяАутентификацияОС,
			ИспользуетсяАутентификацияJWT,
			ТекстСообщенияОбОшибке,
			ВызовДляПользователяЗаданияОбмена) Тогда
		
		Если ВызовДляПользователяЗаданияОбмена Или ЭтоПользовательЗаданияОбмена Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.СохранитьНастройкиАвторизацииДляОбмена(
				ИмяПользователя,
				Пароль);
		КонецЕсли;
		
		Если Не ВызовДляПользователяЗаданияОбмена Или ЭтоПользовательЗаданияОбмена Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.СохранитьНастройкиАвторизации(
				ИмяПользователя,
				Пароль,
				ИспользуетсяАутентификацияОС,
				ИспользуетсяАутентификацияJWT);
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.УстановитьВерсиюСервисаВПараметрыСеанса();
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПриАвторизации(ИспользуетсяАутентификацияJWT);
			Оповестить("ИнтеграцияС1СДокументооборотом_УспешноеПодключение",, ВладелецФормы);
		КонецЕсли;
		
		Закрыть(Истина);
		Возврат;
		
	Иначе
		
		ИспользуетсяАутентификацияОС = ИспользуетсяАутентификацияОССтароеЗначение;
		ИспользуетсяАутентификацияJWT = ИспользуетсяАутентификацияJWTСтароеЗначение;
		ОписаниеОповещения = Новый ОписаниеОповещения("ОКЗавершение", ЭтотОбъект, ТекстСообщенияОбОшибке);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ОК", "ОК");
		Кнопки.Добавить("Подробнее", "Подробнее...");
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Не удалось подключиться к 1С:Документообороту с указанным
			|именем пользователя и паролем. Обратитесь к администратору.'"), Кнопки);
		
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти