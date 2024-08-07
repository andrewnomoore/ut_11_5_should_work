///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем НаименованиеВыбраннойПрограммы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		ТолькоПросмотр = Истина;
	Иначе
		Элементы.НадписьНастройкаВЦентральномУзле.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Наименование.СписокВыбора.Добавить("", НСтр("ru = '<Другое приложение>'"));
	ПоставляемыеНастройки = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПоставляемыеНастройкиПрограмм();
	Для каждого ПоставляемаяНастройка Из ПоставляемыеНастройки Цикл
		Если ЕстьВОСКлиентаИлиВОССервера(ПоставляемаяНастройка) Тогда
			Элементы.Наименование.СписокВыбора.Добавить(ПоставляемаяНастройка.Представление);
		КонецЕсли;
	КонецЦикла;
	
	// Заполнение нового объекта по поставляемой настройке.
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если ЗначениеЗаполнено(Параметры.ИдентификаторПоставляемойНастройки) Тогда
		
			Отбор = Новый Структура("Идентификатор", Параметры.ИдентификаторПоставляемойНастройки);
			Строки = ПоставляемыеНастройки.НайтиСтроки(Отбор);
			Если Строки.Количество() > 0 Тогда
				ЗаполнитьЗначенияСвойств(Объект, Строки[0]);
				Объект.Наименование = Строки[0].Представление;
				Элементы.Наименование.ТолькоПросмотр = Истина;
				Элементы.ИмяПрограммы.ТолькоПросмотр = Истина;
				Элементы.ТипПрограммы.ТолькоПросмотр = Истина;
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(Параметры.Программа) Тогда
			
			ПрограммаАвто = Параметры.Программа; // см. ЭлектроннаяПодписьСлужебныйКлиентСервер.РасширенноеОписаниеПрограммы
			
			ЗаполнитьЗначенияСвойств(Объект, ПрограммаАвто,,"Ссылка");
			Объект.Наименование = ПрограммаАвто.Представление;
			Элементы.Наименование.ТолькоПросмотр = Истина;
			Элементы.ИмяПрограммы.ТолькоПросмотр = Истина;
			Элементы.ТипПрограммы.ТолькоПросмотр = Истина;
			Объект.РежимИспользования = Параметры.РежимИспользования;
			
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение списков алгоритмов.
	Отбор = Новый Структура("ИмяПрограммы, ТипПрограммы", Объект.ИмяПрограммы, Объект.ТипПрограммы);
	Строки = ПоставляемыеНастройки.НайтиСтроки(Отбор);
	ПоставляемаяНастройка = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	ЗаполнитьСпискиВыбораАлгоритмов(ПоставляемаяНастройка);
	УстановитьЗаголовокАвтоматическиеНастройки(ПоставляемаяНастройка);
	УстановитьВидимостьИДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьАлгоритмыВыбраннойПрограммы(Истина);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИмяПрограммы) Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияНачатьВыборПрограммыПослеОткрытия", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Требуется для обновления списка программ и
	// их параметров на сервере и на клиенте.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПрограммыЭлектроннойПодписиИШифрования", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИмяПрограммы", Объект.ИмяПрограммы);
	Запрос.УстановитьПараметр("ТипПрограммы", Объект.ТипПрограммы);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
	|ГДЕ
	|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка <> &Ссылка
	|	И ПрограммыЭлектроннойПодписиИШифрования.ИмяПрограммы = &ИмяПрограммы
	|	И ПрограммыЭлектроннойПодписиИШифрования.ТипПрограммы = &ТипПрограммы";
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Программа с указанным именем и типом уже добавлена в список.'"),
			,
			"Объект.ИмяПрограммы");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ЗаполнитьНастройкиВыбраннойПрограммы(Объект.Наименование);
	ЗаполнитьАлгоритмыВыбраннойПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = "" Тогда
		Объект.Наименование = "";
		Объект.ИмяПрограммы = "";
		Объект.ТипПрограммы = 0;
		Объект.АлгоритмПодписи = "";
		Объект.АлгоритмХеширования = "";
		Объект.АлгоритмШифрования = "";
	КонецЕсли;
	
	НаименованиеВыбраннойПрограммы = ВыбранноеЗначение;
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияНаименованиеОбработкаВыбора", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПрограммыПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияИмяИТипПриИзменении", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПрограммыПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияИмяИТипПриИзменении", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимИспользованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение(
		"Перечисление.РежимыИспользованияПрограммыЭлектроннойПодписи.Автоматически") Тогда
		
		ПрограммыПоИменамСТипом = ЭлектроннаяПодписьКлиент.ОбщиеНастройки().ПрограммыПоИменамСТипом;
		Ключ = ЭлектроннаяПодписьСлужебныйКлиентСервер.КлючПоискаПрограммыПоИмениСТипом(Объект.ИмяПрограммы, Объект.ТипПрограммы);
		ПоставляемаяПрограмма = ПрограммыПоИменамСТипом.Получить(Ключ);
		Если ПоставляемаяПрограмма = Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьПредупреждение(, НСтр("ru = 'Приложение с указанными именем и типом не может быть определено автоматически.'"));
			Возврат;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Объект, ПоставляемаяПрограмма);
		Объект.РежимИспользования = ВыбранноеЗначение;
		РежимИспользованияПриИзменении(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимИспользованияПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступность(ЭтотОбъект);
	ЗаполнитьАлгоритмыВыбраннойПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПометкуУдаления(Команда)
	
	Если Не Модифицированность Тогда
		УстановитьПометкуУдаленияЗавершение();
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("УстановитьПометкуУдаленияПослеОтветаНаВопрос", ЭтотОбъект),
		НСтр("ru = 'Для установки отметки удаления запишите сделанные изменения.
		           |Записать данные?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНастройкиВыбраннойПрограммы(Представление)
	
	ПоставляемыеНастройки = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПоставляемыеНастройкиПрограмм();
	Если ТипЗнч(Представление) = Тип("Структура") Тогда
		Строки = ПоставляемыеНастройки.НайтиСтроки(Представление);
		ПоставляемаяНастройка = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	Иначе
		ПоставляемаяНастройка = ПоставляемыеНастройки.Найти(Представление, "Представление");
	КонецЕсли;
	
	Если ПоставляемаяНастройка <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Объект, ПоставляемаяНастройка);
		Объект.Наименование = ПоставляемаяНастройка.Представление;
	КонецЕсли;
	
	УстановитьЗаголовокАвтоматическиеНастройки(ПоставляемаяНастройка);
	ЗаполнитьСпискиВыбораАлгоритмов(ПоставляемаяНастройка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокАвтоматическиеНастройки(ПоставляемаяНастройка)
	
	Если ПоставляемаяНастройка = Неопределено Тогда
		Элементы.ДекорацияНадписьАвтоматическиеНастройки.Заголовок = НСтр("ru = 'Это приложение не может быть определено автоматически'");
		Возврат;
	КонецЕсли;
	
	Элементы.ДекорацияНадписьАвтоматическиеНастройки.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При работе с этим приложением используются алгоритмы:
			|Для подписи: %1
			|Для хеширования: %2
			|Для шифрования: %3'"), ПоставляемаяНастройка.АлгоритмПодписи, ПоставляемаяНастройка.АлгоритмХеширования,
			ПоставляемаяНастройка.АлгоритмШифрования);
			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораАлгоритмов(ПоставляемаяНастройка)
	
	АлгоритмыПодписиПоставляемые.Очистить();
	АлгоритмыХешированияПоставляемые.Очистить();
	АлгоритмыШифрованияПоставляемые.Очистить();
	
	Если ПоставляемаяНастройка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АлгоритмыПодписиПоставляемые.ЗагрузитьЗначения(ПоставляемаяНастройка.АлгоритмыПодписи);
	АлгоритмыХешированияПоставляемые.ЗагрузитьЗначения(ПоставляемаяНастройка.АлгоритмыХеширования);
	АлгоритмыШифрованияПоставляемые.ЗагрузитьЗначения(ПоставляемаяНастройка.АлгоритмыШифрования);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАлгоритмыВыбраннойПрограммы(ПриОткрытии = Ложь)
	
	Если Объект.РежимИспользования = ПредопределенноеЗначение(
		"Перечисление.РежимыИспользованияПрограммыЭлектроннойПодписи.Автоматически") Тогда
		Возврат;
	КонецЕсли;
	
	НачатьПодключениеРасширенияРаботыСКриптографией(Новый ОписаниеОповещения(
		"ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПодключенияРасширенияРаботыСКриптографией", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьАлгоритмыВыбраннойПрограммы.
&НаКлиенте
Процедура ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПодключенияРасширенияРаботыСКриптографией(Подключено, Контекст) Экспорт
	
	Если Не Подключено Тогда
		ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПолученияИнформации(Неопределено, Контекст);
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьПутьКПрограмме(
		Новый ОписаниеОповещения("ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПолученияПутиКПрограмме",
			ЭтотОбъект, Контекст), Объект.Ссылка);
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьАлгоритмыВыбраннойПрограммы.
&НаКлиенте
Процедура ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПолученияПутиКПрограмме(ОписаниеПути, Контекст) Экспорт
	
	СредстваКриптографии.НачатьПолучениеИнформацииМодуляКриптографии(Новый ОписаниеОповещения(
			"ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПолученияИнформации", ЭтотОбъект, ,
			"ЗаполнитьАлгоритмыВыбраннойПрограммыПослеОшибкиПолученияИнформации", ЭтотОбъект),
		Объект.ИмяПрограммы, ОписаниеПути.ПутьКПрограмме, Объект.ТипПрограммы);
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьАлгоритмыВыбраннойПрограммы.
&НаКлиенте
Процедура ЗаполнитьАлгоритмыВыбраннойПрограммыПослеОшибкиПолученияИнформации(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПолученияИнформации(Неопределено, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьАлгоритмыВыбраннойПрограммы.
&НаКлиенте
Процедура ЗаполнитьАлгоритмыВыбраннойПрограммыПослеПолученияИнформации(ИнформацияМодуля, Контекст) Экспорт
	
	// Если менеджер криптографии недоступен и не из числа поставляемых,
	// тогда имена алгоритмов заполняются вручную.
	
	Если ИнформацияМодуля <> Неопределено
	   И Объект.ИмяПрограммы <> ИнформацияМодуля.Имя
	   И Не ЭлектроннаяПодписьСлужебныйКлиент.ТребуетсяПутьКПрограмме() Тогда
		
		ИнформацияМодуля = Неопределено;
	КонецЕсли;
	
	Если ИнформацияМодуля = Неопределено Тогда
		Элементы.АлгоритмПодписи.СписокВыбора.ЗагрузитьЗначения(
			АлгоритмыПодписиПоставляемые.ВыгрузитьЗначения());
		
		Элементы.АлгоритмХеширования.СписокВыбора.ЗагрузитьЗначения(
			АлгоритмыХешированияПоставляемые.ВыгрузитьЗначения());
		
		Элементы.АлгоритмШифрования.СписокВыбора.ЗагрузитьЗначения(
			АлгоритмыШифрованияПоставляемые.ВыгрузитьЗначения());
	Иначе
		Элементы.АлгоритмПодписи.СписокВыбора.ЗагрузитьЗначения(
			Новый Массив(ИнформацияМодуля.АлгоритмыПодписи));
		
		Элементы.АлгоритмХеширования.СписокВыбора.ЗагрузитьЗначения(
			Новый Массив(ИнформацияМодуля.АлгоритмыХеширования));
		
		Элементы.АлгоритмШифрования.СписокВыбора.ЗагрузитьЗначения(
			Новый Массив(ИнформацияМодуля.АлгоритмыШифрования));
	КонецЕсли;
	
	Элементы.АлгоритмПодписи.КнопкаВыпадающегоСписка =
		Элементы.АлгоритмПодписи.СписокВыбора.Количество() <> 0;
	
	Элементы.АлгоритмХеширования.КнопкаВыпадающегоСписка =
		Элементы.АлгоритмХеширования.СписокВыбора.Количество() <> 0;
	
	Элементы.АлгоритмШифрования.КнопкаВыпадающегоСписка =
		Элементы.АлгоритмШифрования.СписокВыбора.Количество() <> 0;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияПослеОтветаНаВопрос(Ответ, Контекст) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкуУдаленияЗавершение();
	
КонецПроцедуры
	
&НаКлиенте
Процедура УстановитьПометкуУдаленияЗавершение()
	
	Объект.ПометкаУдаления = Не Объект.ПометкаУдаления;
	Записать();
	
	Оповестить("Запись_ПрограммыЭлектроннойПодписиИШифрования", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияНачатьВыборПрограммыПослеОткрытия()
	
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ПослеВыбораПрограммы", ЭтотОбъект),
		Элементы.Наименование.СписокВыбора, Элементы.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПрограммы(ВыбранныйЭлемент, Контекст) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	НаименованиеОбработкаВыбора(Элементы.Наименование, ВыбранныйЭлемент.Значение, Ложь);
	
КонецПроцедуры

// Продолжение процедуры НаименованиеОбработкаВыбора.
&НаКлиенте
Процедура ОбработчикОжиданияНаименованиеОбработкаВыбора()
	
	ЗаполнитьНастройкиВыбраннойПрограммы(НаименованиеВыбраннойПрограммы);
	ЗаполнитьАлгоритмыВыбраннойПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияИмяИТипПриИзменении()
	
	Если ЗначениеЗаполнено(Объект.ИмяПрограммы) И ЗначениеЗаполнено(Объект.ТипПрограммы) Тогда
		ЗаполнитьНастройкиВыбраннойПрограммы(Новый Структура("ИмяПрограммы, ТипПрограммы",
			Объект.ИмяПрограммы, Объект.ТипПрограммы));
	КонецЕсли;
	
	ЗаполнитьАлгоритмыВыбраннойПрограммы();
	
КонецПроцедуры

&НаСервере
Функция ЕстьВОСКлиентаИлиВОССервера(Настройка)
	
	Возврат Не Настройка.НетВWindows
	      И (ОбщегоНазначения.ЭтоWindowsКлиент() Или ОбщегоНазначения.ЭтоWindowsСервер())
	    Или Не Настройка.НетВLinux
	      И (ОбщегоНазначения.ЭтоLinuxКлиент() Или ОбщегоНазначения.ЭтоLinuxСервер())
	    Или Не Настройка.НетВMacOS
	      И ОбщегоНазначения.ЭтоMacOSКлиент();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьИДоступность(Форма)
	
	ДоступностьНастроек = Не ЭлектроннаяПодписьСлужебныйКлиентСервер.ИспользуютсяАвтоматическиеНастройки(
		Форма.Объект.РежимИспользования);
	
	Форма.Элементы.АлгоритмПодписи.Видимость = ДоступностьНастроек;
	Форма.Элементы.АлгоритмХеширования.Видимость = ДоступностьНастроек;
	Форма.Элементы.АлгоритмШифрования.Видимость = ДоступностьНастроек;
	Форма.Элементы.АлгоритмПодписи.Видимость = ДоступностьНастроек;
	Форма.Элементы.ДекорацияНадписьАвтоматическиеНастройки.Видимость = Не ДоступностьНастроек;
	
	Если Не ДоступностьНастроек Тогда
		Форма.Элементы.Наименование.ТолькоПросмотр = Истина;
		Форма.Элементы.ИмяПрограммы.ТолькоПросмотр = Истина;
		Форма.Элементы.ТипПрограммы.ТолькоПросмотр = Истина;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
