#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	УправлениеВидимостью();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВидыКонтактнойИнформацииПустаяСсылка = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	
	Если (НЕ Объект.ОтправлятьПартнеру) Или (НЕ ПредназначенаДляSMS) Тогда
		ТекущийОбъект.ВидКИПартнераДляSMS   = ВидыКонтактнойИнформацииПустаяСсылка;
	КонецЕсли;
	
	Если (НЕ Объект.ОтправлятьПартнеру) Или (НЕ ПредназначенаДляЭлектронныхПисем) Тогда
		ТекущийОбъект.ВидКИПартнераДляПисем = ВидыКонтактнойИнформацииПустаяСсылка;
	КонецЕсли;
	
	Если (НЕ Объект.ОтправлятьКонтактномуЛицуОбъектаОповещения) Или (НЕ ПредназначенаДляSMS) Тогда
		ТекущийОбъект.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS   = ВидыКонтактнойИнформацииПустаяСсылка;
	КонецЕсли;
	
	Если (НЕ Объект.ОтправлятьКонтактномуЛицуОбъектаОповещения) Или (НЕ ПредназначенаДляЭлектронныхПисем) Тогда
		ТекущийОбъект.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем = ВидыКонтактнойИнформацииПустаяСсылка;
	КонецЕсли;
	
	Если (НЕ ПредназначенаДляЭлектронныхПисем) ИЛИ (НЕ ПредназначенаДляSMS) Тогда
		Для Каждого КонтактноеЛицо Из ТекущийОбъект.КонтактныеЛица Цикл
			Если НЕ ПредназначенаДляЭлектронныхПисем Тогда
				КонтактноеЛицо.ВидКИДляПисем = ВидыКонтактнойИнформацииПустаяСсылка;
			КонецЕсли;
			Если НЕ ПредназначенаДляSMS Тогда
				КонтактноеЛицо.ВидКИДляSMS   = ВидыКонтактнойИнформацииПустаяСсылка;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ОтправлятьСообщенияКонтактнымЛицам Тогда
		ТекущийОбъект.КонтактныеЛица.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОтправлятьСообщенияКонтактнымЛицам = Объект.КонтактныеЛица.Количество() > 0;
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Подписчик", Объект.Владелец);
	ПараметрыЗаписи.Вставить("ГруппаРассылокИОповещений", Объект.ГруппаРассылокИОповещений);
	Оповестить("Запись_ПодпискиНаРассылкиИОповещенияКлиентам", ПараметрыЗаписи, ЭтотОбъект); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодпискаДействуетПриИзменении(Элемент)
	
	Объект.ПодпискаДействует = ?(ПодпискаДействует = 1, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьПартнеруПриИзменении(Элемент)
	
	ЗаполнитьВидыКИПоУмолчанию(ЭтотОбъект);
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьКонтактномуЛицуОбъектаОповещенияПриИзменении(Элемент)
	
	ЗаполнитьВидыКИПоУмолчанию(ЭтотОбъект);
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьВидыКИПоУмолчанию(Форма)

	Если Форма.Объект.ОтправлятьПартнеру Тогда
		Если Форма.ПредназначенаДляSMS И Форма.Объект.ВидКИПартнераДляSMS.Пустая() Тогда
			Форма.Объект.ВидКИПартнераДляSMS = Форма.ВидКонтактнойИнформацииПартнераДляSMS;
		КонецЕсли;
		Если Форма.ПредназначенаДляЭлектронныхПисем И Форма.Объект.ВидКИПартнераДляПисем.Пустая() Тогда
			Форма.Объект.ВидКИПартнераДляПисем = Форма.ВидКонтактнойИнформацииПартнераДляПисем;
		КонецЕсли;
	КонецЕсли;
	
	Если Форма.Объект.ОтправлятьКонтактномуЛицуОбъектаОповещения Тогда
		Если Форма.ПредназначенаДляSMS И Форма.Объект.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS.Пустая() Тогда
			Форма.Объект.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS = Форма.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS;
		КонецЕсли;
		Если Форма.ПредназначенаДляЭлектронныхПисем И Форма.Объект.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем.Пустая() Тогда
			Форма.Объект.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем = Форма.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого КонтактноеЛицо Из Форма.Объект.КонтактныеЛица Цикл
		
		Если Форма.ПредназначенаДляSMS И КонтактноеЛицо.ВидКИДляSMS.Пустая() Тогда
			КонтактноеЛицо.ВидКИДляSMS = Форма.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS;
		КонецЕсли;
		
		Если Форма.ПредназначенаДляЭлектронныхПисем И КонтактноеЛицо.ВидКИДляПисем.Пустая() Тогда
			КонтактноеЛицо.ВидКИДляПисем = Форма.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьСообщенияКонтактнымЛицамПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиКонтактныеЛица

&НаКлиенте
Процедура КонтактныеЛицаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.НеНоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ВидКИДляSMS) И ПредназначенаДляSMS  Тогда
		ТекущиеДанные.ВидКИДляSMS = ВидКонтактнойИнформацииКонтактногоЛицаДляSMS;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ВидКИДляПисем) И ПредназначенаДляЭлектронныхПисем Тогда
		ТекущиеДанные.ВидКИДляПисем = ВидКонтактнойИнформацииКонтактногоЛицаДляПисем;
	КонецЕсли;
	
	ТекущиеДанные.НеНоваяСтрока = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактныеЛицаПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	Элементы.ДекорацияКонтактноеЛицоОбъектаОповещенияПояснение.Заголовок = 
	                 РассылкиИОповещенияКлиентам.ТекстПоясненияКонтактноеЛицоОбъектаОповещения();
	ОтправлятьСообщенияКонтактнымЛицам = Объект.КонтактныеЛица.Количество() > 0;
	ЗаполнитьСпискиВыбораВидаКИ();
	ПодпискаДействует = ?(Объект.ПодпискаДействует, 1, 0);
	
	РассылкиИОповещенияКлиентам.ЗаполнитьРеквизитыФормыПоГруппеРассылокИОповещений(ЭтотОбъект, Объект.ГруппаРассылокИОповещений);
	ЗаполнитьВидыКИПоУмолчанию(ЭтотОбъект);
	Элементы.ДоступныеСпособыОтправкиПояснение.Заголовок = ТекстПоясненияДоступныеСпособыОтправки();
	
	УправлениеДоступностью(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Не предназначена для SMS и вид контактной информации для sms контактного лица не заполнен.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонтактныеЛицаВидКИКонтактногоЛицаДляSMS.Имя);
	
	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПредназначенаДляSMS");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("КонтактныеЛица.ВидКИДляSMS");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	// Не предназначена для писем и вид контактной информации для писем контактного лица не заполнен.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонтактныеЛицаВидКИКонтактногоЛицаДляПисем.Имя);
	
	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПредназначенаДляЭлектронныхПисем");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("КонтактныеЛица.ВидКИДляПисем");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	Если Не ЗначениеЗаполнено(Форма.Объект.Владелец) 
		Или Не ЗначениеЗаполнено(Форма.Объект.ГруппаРассылокИОповещений) Тогда
		Форма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Форма.КоличествоДополнительныхАдресатов = Форма.Объект.КонтактныеЛица.Количество();
	
	ВлияющиеРеквизитыФормыВыбраны = НЕ Форма.Объект.Владелец.Пустая() 
	                                И НЕ Форма.Объект.ГруппаРассылокИОповещений.Пустая();
	
	Форма.Элементы.ГруппаПартнер.Доступность                         = ВлияющиеРеквизитыФормыВыбраны;
	Форма.Элементы.ГруппаКонтактноеЛицоОбъектаОповещения.Доступность = ВлияющиеРеквизитыФормыВыбраны;
	Форма.Элементы.ГруппаКонтактныеЛица.Доступность                  = ВлияющиеРеквизитыФормыВыбраны;

	Форма.Элементы.ГруппаКонтактнаяИнформацияПартнера.Доступность        = Форма.Объект.ОтправлятьПартнеру;
	Форма.Элементы.ГруппаКонтактнаяИнформацияКонтактногоЛица.Доступность = Форма.Объект.ОтправлятьКонтактномуЛицуОбъектаОповещения;
	
	Форма.Элементы.ВидКИПартнераДляПисем.Доступность  = Форма.ПредназначенаДляЭлектронныхПисем;
	Форма.Элементы.ВидКИПартнераДляSMS.Доступность    = Форма.ПредназначенаДляSMS;
	
	Форма.Элементы.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем.Доступность  = Форма.ПредназначенаДляЭлектронныхПисем;
	Форма.Элементы.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS.Доступность    = Форма.ПредназначенаДляSMS;
	
	Форма.Элементы.КонтактныеЛица.Доступность = Форма.ОтправлятьСообщенияКонтактнымЛицам;

КонецПроцедуры

&НаСервере
Функция ТекстПоясненияДоступныеСпособыОтправки()
	
	Если ПредназначенаДляЭлектронныхПисем И ПредназначенаДляSMS Тогда
		ТекстПояснения = НСтр("ru = 'Будут отправляться Email и SMS'");
	ИначеЕсли ПредназначенаДляЭлектронныхПисем Тогда
		ТекстПояснения = НСтр("ru = 'Будут отправляться Email'");
	Иначе
		ТекстПояснения = НСтр("ru = 'Будут отправляться SMS'");
	КонецЕсли;
	
	Возврат ТекстПояснения;
	
КонецФункции

&НаСервере
Функция ЗаполнитьСпискиВыбораВидаКИ()
	
	СтруктураСписковВыбора = РассылкиИОповещенияКлиентам.СтруктураСписковВыбораКИ();
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	                    Элементы.ВидКИПартнераДляПисем.СписокВыбора,
	                    СтруктураСписковВыбора.ПартнерыАдресЭлектроннойПочты);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	                    Элементы.ВидКИПартнераДляSMS.СписокВыбора,
	                    СтруктураСписковВыбора.ПартнерыТелефон);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	                    Элементы.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем.СписокВыбора,
	                    СтруктураСписковВыбора.КонтактныеЛицаАдресЭлектроннойПочты);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	                    Элементы.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS.СписокВыбора,
	                    СтруктураСписковВыбора.КонтактныеЛицаТелефон);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	                    Элементы.КонтактныеЛицаВидКИКонтактногоЛицаДляПисем.СписокВыбора,
	                    СтруктураСписковВыбора.КонтактныеЛицаАдресЭлектроннойПочты);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	                    Элементы.КонтактныеЛицаВидКИКонтактногоЛицаДляSMS.СписокВыбора,
	                    СтруктураСписковВыбора.КонтактныеЛицаТелефон);

КонецФункции

&НаСервере
Процедура УправлениеВидимостью()

	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Элементы.Владелец.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти




