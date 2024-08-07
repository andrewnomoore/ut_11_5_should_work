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
	
	ОшибкаНаКлиенте = Параметры.ОшибкаНаКлиенте;
	
	Если ЗначениеЗаполнено(Параметры.АдресСертификата) Тогда

		ДанныеСертификата = ПолучитьИзВременногоХранилища(Параметры.АдресСертификата);
		Если ТипЗнч(ДанныеСертификата) = Тип("Строка") Тогда
			ДанныеСертификата = Base64Значение(ДанныеСертификата);
		КонецЕсли;
		Сертификат = Новый СертификатКриптографии(ДанныеСертификата);
		АдресСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.Ссылка) Тогда
		АдресСертификата = АдресСертификата(Параметры.Ссылка, УникальныйИдентификатор);
		
		Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
			ОшибкаНаСервере = Новый Структура;
			ОшибкаНаСервере.Вставить("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сертификат ""%1"",
				           |не найден в справочнике сертификатов.'"), Параметры.Ссылка));
			Возврат;
		КонецЕсли;
	Иначе // Отпечаток
		АдресСертификата = АдресСертификата(Параметры.Отпечаток, УникальныйИдентификатор);
		
		Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
			ОшибкаНаСервере = Новый Структура;
			ОшибкаНаСервере.Вставить("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сертификат не найден по отпечатку ""%1"".'"), Параметры.Отпечаток));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеСертификата = Неопределено Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДанныеСертификата);
	КонецЕсли;
	
	СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(Сертификат);
	ДополнительныеСвойстваСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.ДополнительныеСвойстваСертификата(
		ДанныеСертификата);
	
	НазначениеПодписание = Сертификат.ИспользоватьДляПодписи;
	НазначениеШифрование = Сертификат.ИспользоватьДляШифрования;
	
	Отпечаток      = СвойстваСертификата.Отпечаток;
	КомуВыдан      = СвойстваСертификата.КомуВыдан;
	КемВыдан       = СвойстваСертификата.КемВыдан;
	ДатаОкончания  = СвойстваСертификата.ДатаОкончания;
	ДатаОкончанияЗакрытогоКлюча = СвойстваСертификата.ДатаОкончанияЗакрытогоКлюча;
	Элементы.ДатаОкончанияЗакрытогоКлюча.Видимость = ЗначениеЗаполнено(ДатаОкончанияЗакрытогоКлюча);
	
	АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмПодписиСертификата(
		ДанныеСертификата, Истина);
	
	Элементы.АлгоритмПодписи.Подсказка =
		Метаданные.Справочники.ПрограммыЭлектроннойПодписиИШифрования.Реквизиты.АлгоритмПодписи.Подсказка;
	
	Элементы.ГруппаЛицензияКриптоПро.Видимость = ДополнительныеСвойстваСертификата.СодержитВстроеннуюЛицензиюКриптоПро;
	
	ЗаполнитьКодыНазначенияСертификата(СвойстваСертификата.Назначение, НазначениеКоды);
	
	ЗаполнитьСвойстваСубъекта(Сертификат);
	ЗаполнитьСвойстваИздателя(Сертификат);
	
	ГруппаВнутреннихПолей = "Общие";
	ЗаполнитьВнутренниеПоляСертификата();
	
	ОбъектКомпоненты = Неопределено;
	
	Если ЭлектроннаяПодпись.ОбщиеНастройки().ПроверятьЭлектронныеПодписиНаСервере
		Или ЭлектроннаяПодпись.ОбщиеНастройки().СоздаватьЭлектронныеПодписиНаСервере Тогда
		
		РезультатЦепочкаСертификатов = ЭлектроннаяПодписьСлужебный.ЦепочкаСертификатов(
			ДанныеСертификата, УникальныйИдентификатор, ОбъектКомпоненты);
			
		Если Не ЗначениеЗаполнено(РезультатЦепочкаСертификатов.Ошибка) Тогда
			Для Каждого ТекущийСертификат Из РезультатЦепочкаСертификатов.Сертификаты Цикл
				СертификатКриптографии = Новый СертификатКриптографии(
					Base64Значение(ПолучитьИзВременногоХранилища(ТекущийСертификат.ДанныеСертификата)));
				НоваяСтрока = ПутьСертификации.Вставить(0);
				СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии);
				НоваяСтрока.Представление = СвойстваСертификата.Представление;
				НоваяСтрока.ДанныеСертификата = ТекущийСертификат.ДанныеСертификата;
			КонецЦикла;
			Элементы.ГруппаОшибкаПолученияЦепочкиСертификатов.Видимость = Ложь;
		Иначе
			ОшибкаПриПолученииПутиСертификацииНаСервере = РезультатЦепочкаСертификатов.Ошибка;
			Элементы.ГруппаОшибкаПолученияЦепочкиСертификатов.Видимость = Истина;
		КонецЕсли;
		
		СвойстваСертификатаРасширенные = ЭлектроннаяПодписьСлужебный.СвойстваСертификатаРасширенные(
			ДанныеСертификата, УникальныйИдентификатор, ОбъектКомпоненты);
		ОшибкаПриПолученииАдресовСписковОтзываНаСервере = СвойстваСертификатаРасширенные.Ошибка;
		ЕстьОшибка = ЗначениеЗаполнено(СвойстваСертификатаРасширенные.Ошибка);
		Элементы.ГруппаОшибкаПолученияСписковОтзыва.Видимость = ЕстьОшибка;
		Элементы.СпискиОтзыва.Видимость = Не ЕстьОшибка;
		Если Не ЕстьОшибка Тогда
			Для Каждого ТекущийАдрес Из СвойстваСертификатаРасширенные.СвойстваСертификата.АдресаСписковОтзыва Цикл
				НоваяСтрока = СпискиОтзыва.Добавить();
				НоваяСтрока.Адрес = ТекущийАдрес;
			КонецЦикла;
		КонецЕсли;
	
	КонецЕсли;
	
	Если Параметры.Свойство("ОткрытиеИзФормыЭлементаСертификата") Тогда
		Элементы.ФормаСохранитьВФайл.Видимость = Ложь;
		Элементы.ФормаПроверить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ОшибкаНаСервере) Тогда
		Отказ = Истина;
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			НСтр("ru = 'Не удалось открыть сертификат'"), "", 
			ОшибкаНаКлиенте, ОшибкаНаСервере);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаВнутреннихПолейПриИзменении(Элемент)
	
	ЗаполнитьВнутренниеПоляСертификата();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаВнутреннихПолейОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаКорневыеСертификаты 
		И (ЗначениеЗаполнено(ОшибкаПриПолученииПутиСертификацииНаСервере) Или ПутьСертификации.Количество() = 0) Тогда
			
		ЗаполнитьКорневыеСертификаты();
		
	КонецЕсли;
	
	Если ТекущаяСтраница = Элементы.СтраницаСпискиОтзыва 
		И СпискиОтзыва.Количество() = 0 Тогда

		ЗаполнитьСпискиОтзыва();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОшибкаПолученияЦепочкиСертификатовНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Не удалось получить путь сертификации'"), "", 
		Новый Структура("ОписаниеОшибки", ОшибкаПриПолученииПутиСертификации),
		Новый Структура("ОписаниеОшибки", ОшибкаПриПолученииПутиСертификацииНаСервере));
		
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОшибкаПолученияСписковОтзываНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Не удалось получить адреса списков отзыва сертификата'"), "", 
		Новый Структура("ОписаниеОшибки", ОшибкаПриПолученииАдресовСписковОтзыва),
		Новый Структура("ОписаниеОшибки", ОшибкаПриПолученииАдресовСписковОтзываНаСервере));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпискиОтзыва

&НаКлиенте
Процедура СпискиОтзываВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКорневыеСертификаты

&НаКлиенте
Процедура КорневыеСертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ПутьСертификации.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресСертификата", ТекущиеДанные.ДанныеСертификата);

	ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыФормы);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьВФайл(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(Неопределено, АдресСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ДополнительныеПараметрыПроверок = ЭлектроннаяПодписьСлужебныйКлиент.ДополнительныеПараметрыПроверкиСертификата();
	ДополнительныеПараметрыПроверок.ОбъединитьОшибкиДанныхСертификата = Ложь;
	ЭлектроннаяПодписьСлужебныйКлиент.ПроверитьСертификат(Новый ОписаниеОповещения(
		"ПроверитьЗавершение", ЭтотОбъект), АдресСертификата,,, ДополнительныеПараметрыПроверок);
	Элементы.ФормаПроверить.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСписокОтзыва(Команда)
	
	ПараметрыУстановкиСпискаОтзыва = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыУстановкиСпискаОтзыва(АдресСертификата);
	ЭлектроннаяПодписьСлужебныйКлиент.УстановитьСписокОтзываСертификата(ПараметрыУстановкиСпискаОтзыва);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСертификат(Команда)
	
	ТекущиеДанные = Элементы.ПутьСертификации.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДвоичныеДанные = Base64Значение(ПолучитьИзВременногоХранилища(ТекущиеДанные.ДанныеСертификата));
	ПараметрыУстановкиСертификата = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыУстановкиСертификата(
		ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор));
		
	Если ПутьСертификации.Количество() > 1 Тогда
		
		Если ТекущиеДанные.ПолучитьИдентификатор() = ПутьСертификации[0].ПолучитьИдентификатор() Тогда
			ВариантыУстановки = Новый СписокЗначений;
			ВариантыУстановки.Добавить("ROOT", НСтр("ru = 'Доверенные корневые сертификаты'"));
			ВариантыУстановки.Добавить("CA", НСтр("ru = 'Промежуточные сертификаты'"));
			ВариантыУстановки.Добавить("MY", НСтр("ru = 'Личное хранилище сертификатов'"));
			ВариантыУстановки.Добавить("Контейнер", НСтр("ru = 'Контейнер и личное хранилище'"));
			ПараметрыУстановкиСертификата.ВариантыУстановки = ВариантыУстановки;
		ИначеЕсли ТекущиеДанные.ПолучитьИдентификатор() <> ПутьСертификации[ПутьСертификации.Количество() - 1].ПолучитьИдентификатор() Тогда
			ВариантыУстановки = Новый СписокЗначений;
			ВариантыУстановки.Добавить("CA", НСтр("ru = 'Промежуточные сертификаты'"));
			ВариантыУстановки.Добавить("ROOT", НСтр("ru = 'Доверенные корневые сертификаты'"));
			ВариантыУстановки.Добавить("MY", НСтр("ru = 'Личное хранилище сертификатов'"));
			ВариантыУстановки.Добавить("Контейнер", НСтр("ru = 'Контейнер и личное хранилище'"));
			ПараметрыУстановкиСертификата.ВариантыУстановки = ВариантыУстановки;
		КонецЕсли;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.УстановитьСертификат(ПараметрыУстановкиСертификата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры Проверить.
&НаКлиенте
Процедура ПроверитьЗавершение(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сертификат действителен.'"));
	ИначеЕсли Результат <> Неопределено Тогда
		
		ДополнительныеДанные = ЭлектроннаяПодписьСлужебныйКлиент.ДополнительныеДанныеДляКлассификатораОшибок();
		ДополнительныеДанные.ДанныеСертификата = АдресСертификата;
		
		ПараметрыПредупреждения = Новый Структура;
		ПараметрыПредупреждения.Вставить("ДополнительныеДанные", ДополнительныеДанные);
		
		ПараметрыПредупреждения.Вставить("ЗаголовокПредупреждения",
			НСтр("ru = 'Сертификат недействителен по причине:'"));
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			ПараметрыПредупреждения.Вставить("ТекстОшибкиКлиент",
				Результат.ОписаниеОшибкиНаКлиенте);
			ПараметрыПредупреждения.Вставить("ТекстОшибкиСервер",
				Результат.ОписаниеОшибкиНаСервере);
		Иначе
			ПараметрыПредупреждения.Вставить("ТекстОшибкиКлиент",
				Результат);
		КонецЕсли;
		ОткрытьФорму("ОбщаяФорма.РасширенноеПредставлениеОшибки",
			ПараметрыПредупреждения, ЭтотОбъект);
			
	КонецЕсли;
	
	Элементы.ФормаПроверить.Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваСубъекта(Сертификат)
	
	Коллекция = ЭлектроннаяПодпись.СвойстваСубъектаСертификата(Сертификат);
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["ОбщееИмя"] = НСтр("ru = 'Общее имя'");
	ПредставленияСвойств["Страна"] = НСтр("ru = 'Страна'");
	ПредставленияСвойств["Регион"] = НСтр("ru = 'Регион'");
	ПредставленияСвойств["НаселенныйПункт"] = НСтр("ru = 'Населенный пункт'");
	ПредставленияСвойств["Улица"] = НСтр("ru = 'Улица'");
	ПредставленияСвойств["Организация"] = НСтр("ru = 'Организация'");
	ПредставленияСвойств["Подразделение"] = НСтр("ru = 'Подразделение'");
	ПредставленияСвойств["ЭлектроннаяПочта"] = НСтр("ru = 'Электронная почта'");
	
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ПредставленияСвойств,
			Обработки["ПрограммыЭлектроннойПодписиИШифрования"].ПредставленияСвойствСубъектаСертификата(), Истина);
	КонецЕсли;
	
	Для каждого ЭлементСписка Из ПредставленияСвойств Цикл
		ЗначениеСвойства = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Коллекция, ЭлементСписка.Ключ);
		Если Не ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			Продолжить;
		КонецЕсли;
		Строка = Субъект.Добавить();
		Строка.Свойство = ЭлементСписка.Значение;
		Строка.Значение = ЗначениеСвойства;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваИздателя(Сертификат)
	
	Коллекция = ЭлектроннаяПодпись.СвойстваИздателяСертификата(Сертификат);
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["ОбщееИмя"] = НСтр("ru = 'Общее имя'");
	ПредставленияСвойств["Страна"] = НСтр("ru = 'Страна'");
	ПредставленияСвойств["Регион"] = НСтр("ru = 'Регион'");
	ПредставленияСвойств["НаселенныйПункт"] = НСтр("ru = 'Населенный пункт'");
	ПредставленияСвойств["Улица"] = НСтр("ru = 'Улица'");
	ПредставленияСвойств["Организация"] = НСтр("ru = 'Организация'");
	ПредставленияСвойств["Подразделение"] = НСтр("ru = 'Подразделение'");
	ПредставленияСвойств["ЭлектроннаяПочта"] = НСтр("ru = 'Электронная почта'");
	
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ПредставленияСвойств,
			Обработки["ПрограммыЭлектроннойПодписиИШифрования"].ПредставленияСвойствИздателяСертификата(), Истина);
	КонецЕсли;
	
	Для каждого ЭлементСписка Из ПредставленияСвойств Цикл
		ЗначениеСвойства = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Коллекция, ЭлементСписка.Ключ);
		Если Не ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			Продолжить;
		КонецЕсли;
		Строка = Издатель.Добавить();
		Строка.Свойство = ЭлементСписка.Значение;
		Строка.Значение = ЗначениеСвойства;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВнутренниеПоляСертификата()
	
	ВнутреннееСодержание.Очистить();
	ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
	Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
	
	Если ГруппаВнутреннихПолей = "Общие" Тогда
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Ложь;
		
		ДобавитьСвойство(Сертификат, "Версия",                    НСтр("ru = 'Версия'"));
		ДобавитьСвойство(Сертификат, "ДатаНачала",                НСтр("ru = 'Дата начала'"));
		ДобавитьСвойство(Сертификат, "ДатаОкончания",             НСтр("ru = 'Дата окончания'"));
		
		Если ЗначениеЗаполнено(ДополнительныеСвойстваСертификата.ДатаНачалаЗакрытогоКлюча) Тогда
			ДобавитьСвойство(ДополнительныеСвойстваСертификата, "ДатаНачалаЗакрытогоКлюча",    НСтр("ru = 'Дата начала закрытого ключа'"));
		КонецЕсли;
		Если ЗначениеЗаполнено(ДополнительныеСвойстваСертификата.ДатаОкончанияЗакрытогоКлюча) Тогда
			ДобавитьСвойство(ДополнительныеСвойстваСертификата, "ДатаОкончанияЗакрытогоКлюча", НСтр("ru = 'Дата окончания закрытого ключа'"));
		КонецЕсли;
		
		ДобавитьСвойство(Сертификат, "ИспользоватьДляПодписи",    НСтр("ru = 'Использовать для подписи'"));
		ДобавитьСвойство(Сертификат, "ИспользоватьДляШифрования", НСтр("ru = 'Использовать для шифрования'"));
		ДобавитьСвойство(Сертификат, "ОткрытыйКлюч",              НСтр("ru = 'Открытый ключ'"), Истина);
		ДобавитьСвойство(Сертификат, "Отпечаток",                 НСтр("ru = 'Отпечаток'"), Истина);
		ДобавитьСвойство(Сертификат, "СерийныйНомер",             НСтр("ru = 'Серийный номер'"), Истина);
		
	ИначеЕсли ГруппаВнутреннихПолей = "РасширенныеСвойства" Тогда
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Ложь;
		
		Коллекция = Сертификат.РасширенныеСвойства;
		Для Каждого КлючИЗначение Из Коллекция Цикл
			ДобавитьСвойство(Коллекция, КлючИЗначение.Ключ, КлючИЗначение.Ключ);
		КонецЦикла;
	Иначе
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Истина;
		
		ИменаИдентификаторов = Новый СписокЗначений;
		ИменаИдентификаторов.Добавить("OID2_5_4_3",              "CN");
		ИменаИдентификаторов.Добавить("OID2_5_4_6",              "C");
		ИменаИдентификаторов.Добавить("OID2_5_4_8",              "ST");
		ИменаИдентификаторов.Добавить("OID2_5_4_7",              "L");
		ИменаИдентификаторов.Добавить("OID2_5_4_9",              "Street");
		ИменаИдентификаторов.Добавить("OID2_5_4_10",             "O");
		ИменаИдентификаторов.Добавить("OID2_5_4_11",             "OU");
		ИменаИдентификаторов.Добавить("OID2_5_4_12",             "T");
		ИменаИдентификаторов.Добавить("OID1_2_840_113549_1_9_1", "E");
		
		ИменаИдентификаторов.Добавить("OID1_2_643_100_1",     "OGRN");
		ИменаИдентификаторов.Добавить("OID1_2_643_100_5",     "OGRNIP");
		ИменаИдентификаторов.Добавить("OID1_2_643_100_3",     "SNILS");
		ИменаИдентификаторов.Добавить("OID1_2_643_3_131_1_1", "INN");
		ИменаИдентификаторов.Добавить("OID1_2_643_100_4",     "INNLE");
		ИменаИдентификаторов.Добавить("OID2_5_4_4",           "SN");
		ИменаИдентификаторов.Добавить("OID2_5_4_42",          "GN");
		
		ИменаИИдентификаторы = Новый Соответствие;
		Коллекция = Сертификат[ГруппаВнутреннихПолей];
		
		Для Каждого ЭлементСписка Из ИменаИдентификаторов Цикл
			Если Коллекция.Свойство(ЭлементСписка.Значение) Тогда
				ДобавитьСвойство(Коллекция, ЭлементСписка.Значение, ЭлементСписка.Представление);
			КонецЕсли;
			ИменаИИдентификаторы.Вставить(ЭлементСписка.Значение, Истина);
			ИменаИИдентификаторы.Вставить(ЭлементСписка.Представление, Истина);
		КонецЦикла;
		
		Для Каждого КлючИЗначение Из Коллекция Цикл
			Если ИменаИИдентификаторы.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
				ДобавитьСвойство(Коллекция, КлючИЗначение.Ключ, КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСвойство(ЗначенияСвойств, Свойство, Представление, НижнийРегистр = Неопределено)
	
	Значение = ЗначенияСвойств[Свойство];
	Если ТипЗнч(Значение) = Тип("Дата") Тогда
		Значение = МестноеВремя(Значение, ЧасовойПоясСеанса());
	ИначеЕсли ТипЗнч(Значение) = Тип("ФиксированныйМассив") Тогда
		ФиксированныйМассив = Значение;
		Значение = "";
		Для каждого ЭлементМассива Из ФиксированныйМассив Цикл
			Значение = Значение + ?(Значение = "", "", Символы.ПС) + СокрЛП(ЭлементМассива);
		КонецЦикла;
	КонецЕсли;
	
	Строка = ВнутреннееСодержание.Добавить();
	Если СтрНачинаетсяС(Свойство, "OID") Тогда
		Строка.Идентификатор = СтрЗаменить(Сред(Свойство, 4), "_", ".");
		Если Свойство <> Представление Тогда
			Строка.Свойство = Представление;
		КонецЕсли;
	Иначе
		Строка.Свойство = Представление;
	КонецЕсли;
	
	Если НижнийРегистр = Истина Тогда
		Строка.Значение = НРег(Значение);
	Иначе
		Строка.Значение = Значение;
	КонецЕсли;
	
КонецПроцедуры

// Преобразует назначения сертификатов в коды назначения.
//
// Параметры:
//  Назначение    - Строка - многострочное назначение сертификата, например:
//                           "Microsoft Encrypted File System (1.3.6.1.4.1.311.10.3.4)
//                           |E-mail Protection (1.3.6.1.5.5.7.3.4)
//                           |TLS Web Client Authentication (1.3.6.1.5.5.7.3.2)".
//  
//  КодыНазначения - Строка - коды назначения "1.3.6.1.4.1.311.10.3.4, 1.3.6.1.5.5.7.3.4, 1.3.6.1.5.5.7.3.2".
//
&НаСервере
Процедура ЗаполнитьКодыНазначенияСертификата(Назначение, КодыНазначения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Коды = "";
	
	Для Индекс = 1 По СтрЧислоСтрок(Назначение) Цикл
		
		Строка = СтрПолучитьСтроку(Назначение, Индекс);
		ТекущийКод = "";
		
		Позиция = СтрНайти(Строка, "(", НаправлениеПоиска.СКонца);
		Если Позиция <> 0 Тогда
			ТекущийКод = Сред(Строка, Позиция + 1, СтрДлина(Строка) - Позиция - 1);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущийКод) Тогда
			Коды = Коды + ?(Коды = "", "", ", ") + СокрЛП(ТекущийКод);
		КонецЕсли;
		
	КонецЦикла;
	
	КодыНазначения = Коды;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКорневыеСертификаты()
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьЦепочкуСертификатов(Новый ОписаниеОповещения("ПослеПолученияЦепочкиСертификатов", ЭтотОбъект),
		АдресСертификата, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПослеПолученияЦепочкиСертификатов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат.Ошибка) Тогда
		Для Каждого ТекущийСертификат Из Результат.Сертификаты Цикл
			СертификатКриптографии = Новый СертификатКриптографии();
			Ждать СертификатКриптографии.ИнициализироватьАсинх(
				Base64Значение(ПолучитьИзВременногоХранилища(ТекущийСертификат.ДанныеСертификата)));
			НоваяСтрока = ПутьСертификации.Вставить(0);
			
			СвойстваСертификата = Ждать ЭлектроннаяПодписьСлужебныйКлиент.СвойстваСертификата(СертификатКриптографии);
			
			НоваяСтрока.Представление = СвойстваСертификата.Представление;
			НоваяСтрока.ДанныеСертификата = ТекущийСертификат.ДанныеСертификата;
		КонецЦикла;
		Элементы.ГруппаОшибкаПолученияЦепочкиСертификатов.Видимость = Ложь;
	Иначе
		ОшибкаПриПолученииПутиСертификации = Результат.Ошибка;
		Элементы.ГруппаОшибкаПолученияЦепочкиСертификатов.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗаполнитьСпискиОтзыва()
	
	ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр(
		"ru = 'Для получения данных об адресах списков отзыва сертификата требуется установка внешней компоненты %1.'"),
		"ExtraCryptoAPI");

	Попытка
		ОбъектКомпоненты = Ждать ЭлектроннаяПодписьСлужебныйКлиент.ОбъектВнешнейКомпонентыExtraCryptoAPI(Истина, ТекстПояснения);
	Исключение
		ОшибкаПриПолученииАдресовСписковОтзыва = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Элементы.ГруппаОшибкаПолученияСписковОтзыва.Видимость = Истина;
		Элементы.СпискиОтзыва.Видимость = Ложь;
		Возврат;
	КонецПопытки;
	
	СвойстваСертификатаРасширенные = Ждать ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСвойстваСертификатаАсинх(
		АдресСертификата, ОбъектКомпоненты);
		
	Если ЗначениеЗаполнено(СвойстваСертификатаРасширенные.Ошибка) Тогда
		ОшибкаПриПолученииАдресовСписковОтзыва = СвойстваСертификатаРасширенные.Ошибка;
		Элементы.ГруппаОшибкаПолученияСписковОтзыва.Видимость = Истина;
		Элементы.СпискиОтзыва.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаОшибкаПолученияСписковОтзыва.Видимость = Ложь;
	Элементы.СпискиОтзыва.Видимость = Истина;
		
	АдресаСписковОтзыва = СвойстваСертификатаРасширенные.СвойстваСертификата.АдресаСписковОтзыва;
	Для Каждого ТекущийАдрес Из СвойстваСертификатаРасширенные.СвойстваСертификата.АдресаСписковОтзыва Цикл
		НоваяСтрока = СпискиОтзыва.Добавить();
		НоваяСтрока.Адрес = ТекущийАдрес;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция АдресСертификата(СсылкаОтпечаток, ИдентификаторФормы = Неопределено)
	
	ДанныеСертификата = Неопределено;
	
	Если ТипЗнч(СсылкаОтпечаток) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		Хранилище = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаОтпечаток, "ДанныеСертификата");
		Если ТипЗнч(Хранилище) = Тип("ХранилищеЗначения") Тогда
			ДанныеСертификата = Хранилище.Получить();
		КонецЕсли;
	Иначе
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Отпечаток", СсылкаОтпечаток);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Сертификаты.ДанныеСертификата
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
		|ГДЕ
		|	Сертификаты.Отпечаток = &Отпечаток";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДанныеСертификата = Выборка.ДанныеСертификата.Получить();
		Иначе
			Сертификат = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(СсылкаОтпечаток, Ложь, Ложь);
			Если Сертификат <> Неопределено Тогда
				ДанныеСертификата = Сертификат.Выгрузить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		Возврат ПоместитьВоВременноеХранилище(ДанныеСертификата, ИдентификаторФормы);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти
