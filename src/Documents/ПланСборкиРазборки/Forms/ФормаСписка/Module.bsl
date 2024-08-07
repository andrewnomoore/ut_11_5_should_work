
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	ТолькоАктуальные = Истина;
	
	УстановитьДоступностьКомандУстановкиСтатуса();
	
	ТекущиеДелаПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Список);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Сценарий  = Настройки.Получить("Сценарий");
	Статус = Настройки.Получить("Статус");
	Ответственный = Настройки.Получить("Ответственный");
	ТолькоАктуальные = Настройки.Получить("ТолькоАктуальные");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сценарий",  Сценарий, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Сценарий));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус",  Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
	ТекущиеДелаПереопределяемый.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КонтрольЗамещенияПланов();
	ПодключитьОбработчикОжидания("КонтрольЗамещенияПланов", 3600);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСценарийПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сценарий",  Сценарий, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Сценарий));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус",  Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТолькоАктуальныеПриИзменении(Элемент)
	
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусВПодготовке(Команда)
	
	УстановитьСтатус("ВПодготовке", НСтр("ru = 'В подготовке'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНаУтверждении(Команда)
	
	УстановитьСтатус("НаУтверждении", НСтр("ru = 'В работе'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусУтвержден(Команда)
	
	УстановитьСтатус("Утвержден", НСтр("ru = 'Утвержден'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтменен(Команда)
	
	УстановитьСтатус("Отменен", НСтр("ru = 'Отменен'"));
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроведение(Команда)
	МассивСсылок = Элементы.Список.ВыделенныеСтроки;
	ОтменитьПроведениеПлановНаСервере(МассивСсылок);
	Элементы.Список.Обновить()
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьКомандУстановкиСтатуса()
	
	ПравоДоступаИзменениеПланСборкиРазборки = ПравоДоступа("Изменение", Метаданные.Документы.ПланСборкиРазборки);
	ПравоДоступаУтверждениеПлановСборкиРазборки = Пользователи.РолиДоступны("УтверждениеПлановСборкиРазборки");
	
	Элементы.ГруппаУстановитьСтатус.Видимость = ПравоДоступаИзменениеПланСборкиРазборки;
	Элементы.СписокУстановитьСтатусУтвержден.Видимость = ПравоДоступаУтверждениеПлановСборкиРазборки;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатус(Статус, ТексСтатуса)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке планов будет установлен статус ""%Статус%"". По принятым в работу планам могут быть оформлены документы. Продолжить?'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Статус%", ТексСтатуса);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Статус", Статус);
	ДополнительныеПараметры.Вставить("ТексСтатуса", ТексСтатуса);
	ДополнительныеПараметры.Вставить("ВыделенныеСтроки", ВыделенныеСтроки);
	
	Оповещение = Новый ОписаниеОповещения("УстановитьСтатусЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(
		ДополнительныеПараметры.ВыделенныеСтроки, 
		ДополнительныеПараметры.Статус);
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, 
		КоличествоОбработанных, 
		ДополнительныеПараметры.ВыделенныеСтроки.Количество(), 
		ДополнительныеПараметры.ТексСтатуса);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольЗамещенияПланов()
	
	КонтрольЗамещенияПлановНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КонтрольЗамещенияПлановНаСервере()
	
	Планирование.КонтрольЗамещенияПланов();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьПроведениеПлановНаСервере(МассивСсылок)
	
	Планирование.ОтменитьПроведениеПланов(МассивСсылок, "ПланСборкиРазборки");
	
КонецПроцедуры

#КонецОбласти
