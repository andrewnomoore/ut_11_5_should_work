///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Не ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаЗаголовок.Видимость = Не ПустаяСтрока(Параметры.БизнесПроцесс);
	СтрокаБизнесПроцесса = Параметры.БизнесПроцесс;
	СтрокаЗадачи = Параметры.Задача;
	
	Если Параметры.ПоказыватьЗадачи >=0 И Параметры.ПоказыватьЗадачи < 3 Тогда
		ПоказыватьЗадачи = Параметры.ПоказыватьЗадачи;
	Иначе
		ПоказыватьЗадачи = 2;
	КонецЕсли;
	
	Если Параметры.ВидимостьОтборов <> Неопределено Тогда
		Элементы.ГруппаОтбор.Видимость = Параметры.ВидимостьОтборов;
	Иначе
		ПоАвтору = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	УстановитьОтбор();
	
	Если Параметры.БлокировкаОкнаВладельца <> Неопределено Тогда
		РежимОткрытияОкна = Параметры.БлокировкаОкнаВладельца;
	КонецЕсли;
		
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	Если Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		Элементы.ПоАвтору.Видимость = Ложь;
		Элементы.ПоИсполнителю.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)

	ИмяНастройки = ?(Не ПустаяСтрока(Параметры.БизнесПроцесс), "ФормаСпискаБП", "ФормаСписка");
	НастройкиОтбора = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("Задачи.ЗадачаИсполнителя.Формы.ФормаСписка", ИмяНастройки);
	Если НастройкиОтбора = Неопределено Тогда 
		Настройки.Очистить();
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из НастройкиОтбора Цикл
		Настройки.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	УстановитьОтборСписка(Список, НастройкиОтбора);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	ИмяНастроек = ?(Элементы.ГруппаЗаголовок.Видимость, "ФормаСпискаБП", "ФормаСписка");
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить("Задачи.ЗадачаИсполнителя.Формы.ФормаСписка", ИмяНастроек, Настройки);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПерехода(ОбъектПерехода, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ОбъектПерехода) Или ОбъектПерехода = Элементы.Список.ТекущаяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ПоАвтору = Неопределено;
	ПоИсполнителю = Неопределено;
	ПоказыватьЗадачи = 0;
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоАвторуПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗадачиПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, 
		Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ПринятаКИсполнению = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элемент.ТекущиеДанные.Свойство("ПринятаКИсполнению", ПринятаКИсполнению) 
	КонецЕсли;
	УстановитьДоступностьПринятьКИсполнению(ПринятаКИсполнению);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачиКИсполнению(Элементы.Список.ВыделенныеСтроки);
	УстановитьДоступностьПринятьКИсполнению(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(Элементы.Список.ВыделенныеСтроки);
	УстановитьДоступностьПринятьКИсполнению(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадач(Команда)
	
	ОбновитьСписокЗадачНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	Если Элементы.Список.ТекущиеДанные.БизнесПроцесс = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'У выбранной задачи не указан бизнес-процесс.'"));
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.БизнесПроцесс);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредметЗадачи(Команда)
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	Если Элементы.Список.ТекущиеДанные.Предмет = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'У выбранной задачи не указан предмет.'"));
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Предмет);
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоАвтору", ПоАвтору);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	ПараметрыОтбора.Вставить("ПоказыватьЗадачи", ПоказыватьЗадачи);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Автор", ПараметрыОтбора["ПоАвтору"],,, ПараметрыОтбора["ПоАвтору"] <> Неопределено И Не ПараметрыОтбора["ПоАвтору"].Пустая());
	
	Если ПараметрыОтбора["ПоИсполнителю"] = Неопределено Или ПараметрыОтбора["ПоИсполнителю"].Пустая() Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ВыбранныйИсполнитель", NULL);
	Иначе	
		Список.Параметры.УстановитьЗначениеПараметра("ВыбранныйИсполнитель", ПараметрыОтбора["ПоИсполнителю"]);
	КонецЕсли;
		
	Если ПараметрыОтбора["ПоказыватьЗадачи"] = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Выполнена", Истина,,,Ложь);
	ИначеЕсли ПараметрыОтбора["ПоказыватьЗадачи"] = 1 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Выполнена", Истина,,,Истина);
	ИначеЕсли ПараметрыОтбора["ПоказыватьЗадачи"] = 2 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Выполнена", Ложь,,,Истина);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	// Цвет просроченных задач зависит от значения текущей даты,
	// поэтому нужно переинициализировать условное оформление.
	УстановитьУсловноеОформление();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьПринятьКИсполнению(ЗначениеФлага)
	
	Если ТипЗнч(ЗначениеФлага) = Тип("Булево") Тогда
		Элементы.ПринятьКИсполнению.Доступность                               = ЗначениеФлага;
		Элементы.СписокКонтекстноеМенюПринятьКИсполнению.Доступность          = ЗначениеФлага;
		Элементы.СписокКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = Не ЗначениеФлага;
	Иначе
		Элементы.ПринятьКИсполнению.Доступность                               = Ложь;
		Элементы.СписокКонтекстноеМенюПринятьКИсполнению.Доступность          = Ложь;
		Элементы.СписокКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
