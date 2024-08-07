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
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	Если Не ЗначениеЗаполнено(Запись.ИсходныйКлючЗаписи.УзелИнформационнойБазы) Тогда
		Запись.КоличествоФайлов = 1;
		Запись.ХранитьНаДиске = Истина;
	КонецЕсли;
	
	МестоХранения = Запись.ХранитьНаДиске;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		АрхивСообщенийОбменов, "УзелИнформационнойБазы", Запись.УзелИнформационнойБазы);

	ДоступностьЭлементов();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МестоХраненияПриИзменении(Элемент)
	
	Запись.ХранитьНаДиске = МестоХранения;
	
	ДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолныйПутьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Заголовок = НСтр("ru = 'Выбор папки для хранения файлов обмена'");
	ОбработчикЗавершения = Новый ОписаниеОповещения("ПолныйПутьЗавершениеВыбора", ЭтотОбъект);
	
	ФайловаяСистемаКлиент.ВыбратьКаталог(ОбработчикЗавершения, Заголовок, Запись.ПолныйПуть);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолныйПутьПриИзменении(Элемент)
	
	ДополнитьПолныйПуть();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоФайловПриИзменении(Элемент)
	
	Если РазделениеВключено Тогда
		Запись.КоличествоФайлов = Мин(Запись.КоличествоФайлов, 1);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	ВыделенныеСтроки = Элементы.АрхивСообщенийОбменов.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Периоды = Новый Массив;
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		СтрокаСписка = Элементы.АрхивСообщенийОбменов.ДанныеСтроки(Строка);
		Периоды.Добавить(СтрокаСписка.Период);
	КонецЦикла;
		
	ФайлыДляСкачивания = ПодготовитьФайлыНаСервере(Запись.УзелИнформационнойБазы, Периоды);
	Если ФайлыДляСкачивания.Количество() <> 0 Тогда
		Заголовок = НСтр("ru = 'Выберите каталог для сохранения файлов'");
		ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов(Заголовок, Истина);
		НачатьПолучениеФайловССервера(ФайлыДляСкачивания, ПараметрыДиалога);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступностьПапки(Команда)
	ПроверитьДоступностьПапкиНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Особый цвет шрифта с файлом больше 100 Мб
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("АрхивСообщенийОбменов");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("АрхивСообщенийОбменов.ФайлБольше100Мб");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);

КонецПроцедуры

&НаСервере
Процедура ДоступностьЭлементов()
	
	Элементы.ГруппаПапка.Доступность = Запись.ХранитьНаДиске;
	
	Если РазделениеВключено И Не Запись.ХранитьНаДиске Тогда
		Элементы.МестоХранения.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСправа;
	Иначе
		Элементы.МестоХранения.ОтображениеПодсказки = ОтображениеПодсказки.Нет
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПолныйПутьЗавершениеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись.ПолныйПуть = Результат;
	
	ДополнитьПолныйПуть();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДоступностьПапкиНаСервере()
	
	КаталогСправки = Новый Файл(Запись.ПолныйПуть);
	Если КаталогСправки.Существует() Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Каталог доступен'"));
	Иначе
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Каталог не доступен'"));	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьПолныйПуть()
	
	Если Не ПустаяСтрока(Запись.ПолныйПуть) Тогда
		
		ПолныйПуть = СокрЛП(Запись.ПолныйПуть);	
		Запись.ПолныйПуть = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолныйПуть);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьФайлыНаСервере(УзелИнформационнойБазы, Периоды)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Архив.ПолноеИмяФайла КАК ПолноеИмяФайла,
		|	Архив.Период КАК Период,
		|	Архив.НомерПринятогоСообщения КАК НомерПринятогоСообщения,
		|	Архив.Хранилище КАК Хранилище,
		|	Архив.ИмяФайла КАК ИмяФайла,
		|	Архив.РасширениеФайла КАК РасширениеФайла
		|ИЗ
		|	РегистрСведений.АрхивСообщенийОбменов КАК Архив
		|ГДЕ
		|	Архив.Период В(&Периоды)
		|	И Архив.УзелИнформационнойБазы = &УзелИнформационнойБазы
		|	И НЕ Архив.ФайлБольше100Мб";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПолноеИмяФайла <> "" Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(Выборка.ПолноеИмяФайла);	
		Иначе
			ДвоичныеДанные = Выборка.Хранилище.Получить();
		КонецЕсли; 
		
		Если ДвоичныеДанные = Неопределено Тогда
			
			Шаблон = НСтр("ru = 'Не обнаружено сообщение №%1 от %2'");
			ТекстСообщения = СтрШаблон(Шаблон,
				Выборка.НомерПринятогоСообщения,
				Выборка.Период);
				
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			Продолжить;
			
		КонецЕсли;
		
		Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		ИмяФайла = Выборка.ИмяФайла + "." + Выборка.РасширениеФайла;
		Результат.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайла, Адрес))
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

#КонецОбласти