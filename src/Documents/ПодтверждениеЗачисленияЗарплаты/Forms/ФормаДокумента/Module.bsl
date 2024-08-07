
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//++ Локализация
	Если Не Истина Тогда // ERP-БЗКР Проект 3063
	Если Параметры.Ключ.Пустая() Тогда
		ПодключитьОбработчикОжидания("ЗагрузитьПодтвержденияБанка", 0.1, Истина);
	КонецЕсли;
	КонецЕсли;
	//-- Локализация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	//++ Локализация


	//-- Локализация
	
	Оповестить("Запись_ПодтверждениеЗачисленияЗарплаты", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
		
		НепроверяемыеРеквизиты = Новый Массив;
		НепроверяемыеРеквизиты.Добавить("ЗарплатныйПроект");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ПринудительноЗакрытьФорму = Истина;
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = 
			ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(
			ЭтотОбъект,
			Объект,
			Отказ,
			ЗавершениеРаботы,
			ТекстПредупреждения,
			СтандартнаяОбработка);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПервичныйДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПервичныйДокументНачалоВыбораСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПервичныйДокументНачалоВыбораСервер()

	ТипыОперации = Новый Массив;
	ТипыОперации.Добавить(Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств"));
	
	Элементы.ПервичныйДокумент.ОграничениеТипа = Новый ОписаниеТипов(ТипыОперации);

КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)

	ХозяйственнаяОперацияПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПервичныйДокументПриИзменении(Элемент)
	
	ПервичныйДокументПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПервичныйДокументПриИзмененииНаСервере()
	
	Объект.Сотрудники.Очистить();
	//++ Локализация


	//-- Локализация
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДанныеЗаполнения = Новый Структура("ХозяйственнаяОперация, Организация");
	
	//++ Локализация


	//-- Локализация
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику
		И ЗначениеЗаполнено(Объект.ПервичныйДокумент) Тогда
		ДокументОбъект.ПолучитьДанныеЗаполненияПоВыплатеПодотчетникам(Объект.ПервичныйДокумент, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ЗаполнитьЗначенияСвойств(Объект, ДанныеЗаполнения, , "ХозяйственнаяОперация, Организация");
	
	//++ Локализация


	//-- Локализация
	
	Объект.СуммаДокумента = Объект.Сотрудники.Итог("Сумма");
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьПараметрыВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатныйПроектПриИзменении(Элемент)

	//++ Локализация


	//-- Локализация
	Возврат;

КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)

	//++ Локализация


	//-- Локализация
	Возврат;

КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиСуммаПриИзменении(Элемент)
	
	Объект.СуммаДокумента = Объект.Сотрудники.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		Элемент.ТекущиеДанные.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьСтатьюДвиженияДенежныхСредств(Команда)

	ДенежныеСредстваКлиент.ЗаполнитьСтатьюДвиженияДенежныхСредств(
		ЭтотОбъект, Элементы.Сотрудники, "Сотрудники");

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = 
			ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата =
			ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = 
			ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)

	ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)

	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)

	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтотОбъект, Истина);

КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
    РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

//++ Локализация


//-- Локализация

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ИспользоватьНачислениеЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ");
	
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(Объект.ХозяйственнаяОперация);
	
	ЗаполнитьСписокХозяйственныхОпераций();
	
	//++ Локализация


	//-- Локализация
	
	ДенежныеСредстваСервер.УправлениеЭлементамиФормыПриЧтенииСозданииНаСервере(ЭтотОбъект);
	УстановитьПараметрыВыбора();
	
	НастроитьЗависимыеЭлементыФормыНаСервере();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокХозяйственныхОпераций()

	ДоступныеОперации = Элементы.ХозяйственнаяОперация.СписокВыбора;
	ДоступныеОперации.Очистить();
	
	Операции = Перечисления.ХозяйственныеОперации;
	ДоступныеОперации.Добавить(Операции.ВыдачаДенежныхСредствПодотчетнику);
	
	//++ Локализация


	//-- Локализация

КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтотОбъект, ИзмененныйРеквизит, РеквизитыФормы(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыФормы(Форма)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("ИспользоватьНачислениеЗарплаты");
	РеквизитыФормы.Вставить("ЗарплатныйПроектПоддерживаетСпособыЗачисленияВыплат");
	РеквизитыФормы.Вставить("ПоддерживаетсяЗачислениеПоНомеруСчета");
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Возврат РеквизитыФормы;
	
КонецФункции

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииНаСервере()
	
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(Объект.ХозяйственнаяОперация);
	
	Если ЗначениеЗаполнено(Объект.ПервичныйДокумент)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПервичныйДокумент, "ХозяйственнаяОперация") <> Объект.ХозяйственнаяОперация Тогда
		
		Объект.ПервичныйДокумент = Неопределено;
		ПервичныйДокументПриИзмененииНаСервере();
		
	КонецЕсли;
	
	УстановитьПараметрыВыбораПервичногоДокумента();
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбора()

	//++ Локализация


	//-- Локализация
	
	УстановитьПараметрыВыбораПервичногоДокумента();

КонецПроцедуры

//++ Локализация


//-- Локализация

&НаСервере
Процедура УстановитьПараметрыВыбораПервичногоДокумента()

	ПараметрыВыбораПервичногоДокумента = Новый Массив;
	
	ПараметрВыбораОрганизация = Новый ПараметрВыбора("Отбор.Организация", Объект.Организация);
	ПараметрыВыбораПервичногоДокумента.Добавить(ПараметрВыбораОрганизация);
	
	ПараметрВыбораПоХозяйственнойОперации = Новый ПараметрВыбора("Отбор.ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	ПараметрыВыбораПервичногоДокумента.Добавить(ПараметрВыбораПоХозяйственнойОперации);
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
	
		ПараметрВыбораПоСписку = Новый ПараметрВыбора("Отбор.СписокФизЛиц", Истина);
		ПараметрыВыбораПервичногоДокумента.Добавить(ПараметрВыбораПоСписку);
	
	КонецЕсли;
	
	Элементы.ПервичныйДокумент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПервичногоДокумента);

КонецПроцедуры

#КонецОбласти
