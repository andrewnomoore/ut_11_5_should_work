#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИС.НастроитьВидимостьДокументаОснования(ЭтотОбъект);
	Элементы.ДокументОснование.ДоступныеТипы = Метаданные.ОпределяемыеТипы.ОснованиеИмпортПродукцииСАТУРН.Тип;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыИС.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СобытияФормСАТУРН.УстановитьСвязиПараметровВыбораСОрганизациейМестомХранения(ЭтотОбъект, "МестаПримененияМестоПрименения",, "");
	
	Если Объект.Ссылка.Пустая() Тогда

		ПриСозданииЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
		
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыХарактеристика");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыУпаковка");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыСерия");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(ЭтотОбъект, "ТоварыСерия");
	
	СобытияФормСАТУРН.УстановитьПараметрыВыбораОрганизации(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	СобытияФормИС.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка, Неопределено);
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере(Ложь);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыИС.ПриЧтенииНаСервере(ЭтотОбъект);
	
	СобытияФормИС.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если НовыйОбъект = Элементы.ДокументОснование.ДоступныеТипы.ПривестиЗначение(НовыйОбъект) Тогда
		Объект.ДокументОснование = НовыйОбъект;
		Модифицированность = Истина;
		Записать();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореНоменклатуры", ЭтотОбъект);
	СобытияФормСАТУРНКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(ОписаниеОповещения, НовыйОбъект, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИмяПодсистемы = ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы();
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИмяПодсистемы)
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен")
			И Параметр.ОбъектИзменен Тогда
			ОбновитьПредставленияНаФорме(Истина);
		Иначе
			ОбновитьПредставленияНаФорме(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен(ИмяПодсистемы)
	 И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ОбновитьПредставленияНаФорме(Истина);
		
	КонецЕсли;
	
	Если ИмяСобытия = "Закрытие_ПерейтиКСтрокеОшибки" И Источник = "Справочник.САТУРНПрисоединенныеФайлы.Форма.ФормаОшибки" Тогда
		ТекущийЭлемент = Элементы.Товары;
		Элементы.Товары.ТекущаяСтрока = Параметр;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_КлассификаторОрганизацийСАТУРН"
		И Параметр = Объект.ОрганизацияСАТУРН Тогда

		ЗаполнитьГиперссылкиРеквизитов();
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормСАТУРНКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий);
	
	СобытияФормСАТУРНКлиентПереопределяемый.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СобытияФормСАТУРНКлиент.ОбработкаНавигационнойСсылкиСАТУРН(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ИнтеграцияИСКлиент.ПослеЗаписиВФормеОбъектаДокументаИС(
		ЭтотОбъект,
		Объект,
		ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы(),
		ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Подключаемый_ОбновитьКоманды();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	ИнтеграцияСАТУРН.ЗаполнитьСопоставленнуюПродукциюВДокументе(Объект.Товары, Не ЗначениеЗаполнено(Объект.Ссылка));
	
	ОбновитьПредставленияНаФорме();
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	ИнтеграцияИС.ПослеЗаписиНаСервереВФормеОбъектаДокументаИС(
		ЭтотОбъект,
		ТекущийОбъект,
		ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы(),
		ПараметрыЗаписи);
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ОчиститьСообщения();

	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда

		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = '""План применения"" не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

	ИначеЕсли Модифицированность Тогда

		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = '""План применения"" был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

	Иначе

		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ДокументОснование");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияСАТУРНПриИзменении(Элемент)
	
	ЗаполнитьГиперссылкиРеквизитов();

КонецПроцедуры

&НаКлиенте
Процедура СрокОграниченийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если РедактированиеФормыНедоступно Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия          = Новый Структура("ДатаПрименения", Объект.ПлановаяДатаПрименения);
	ОписаниеПослеУстановкиДаты = Новый ОписаниеОповещения("ПослеУстановкиДатыОграничения", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ПланПримененияСАТУРН.Форма.УстановкаСрокаОграничений",
		ПараметрыОткрытия,
		Элемент,
		УникальныйИдентификатор,,,
		ОписаниеПослеУстановкиДаты,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияСАТУРННачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	
	Если ЗначениеЗаполнено(ОрганизацияИзОснованияДляОтбораОрганизацииСАТУРН)
		И Не ЗначениеЗаполнено(Объект.ОрганизацияСАТУРН) Тогда
		
		ПараметрыОткрытия.Вставить("Контрагент", ОрганизацияИзОснованияДляОтбораОрганизацииСАТУРН);
		
	Иначе
		
		ПараметрыОткрытия.Вставить("Соответствует", "Организации");
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.КлассификаторОрганизацийСАТУРН.ФормаСписка",
		ПараметрыОткрытия,
		Элемент,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеОчистка(Элемент, СтандартнаяОбработка)
	ЗаполнитьОтборыПоОснованию(Неопределено, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМестаПрименения

&НаКлиенте
Процедура МестаПримененияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Не Копирование Тогда
		Возврат;	
	КонецЕсли;
	
	ТекущиеДанные = Элементы.МестаПрименения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	НоваяСтрока = Объект.МестаПрименения.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные,, "Идентификатор");
	
	Элементы.МестаПрименения.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	Элементы.МестаПрименения.ИзменитьСтроку();

КонецПроцедуры

&НаКлиенте
Процедура МестаПримененияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.МестаПрименения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не РедактированиеФормыНедоступно Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.МестоПрименения) Тогда
	
		ПоказатьЗначение(, ТекущиеДанные.МестоПрименения);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура МестаПримененияТипМестаПримененияПриИзменении(Элемент)
	
	ОбновитьПодсказкуВводаОписанияМестаПрименения();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если РедактированиеФормыНедоступно
		Или Не ПравоИзменения Тогда
		СобытияФормСАТУРНКлиент.ВыборЭлементаТабличнойЧастиОткрытьФормуЭлемента(ЭтотОбъект, Элемент, Поле);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Не Копирование Тогда
		Возврат;	
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	НоваяСтрока = Объект.Товары.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные,, "Идентификатор");
	
	Элементы.Товары.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	Элементы.Товары.ИзменитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	Если РедактированиеФормыНедоступно Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(
		Элемент,
		ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПодконтрольнаяПродукцияСАТУРН"),
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
	НоменклатураПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыНоменклатуры = ИнтеграцияСАТУРНВызовСервера.ПараметрыСозданияНоменклатуры(
		ТекущиеДанные.ПАТ);
	
	СобытияФормСАТУРНКлиентПереопределяемый.ОткрытьФормуСозданияНоменклатуры(ЭтотОбъект, ПараметрыНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(
		Элемент, ТекущиеДанные, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект,, Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииСерии(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТипИзмеряемойВеличиныСАТУРННачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ДанныеВыбора = Новый СписокЗначений;
	Данные = Новый Структура;
	Данные.Вставить("Партия",       Неопределено);
	Данные.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	Данные.Вставить("Упаковка",     ТекущиеДанные.Упаковка);
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(
		ИнтеграцияСАТУРНКлиент.ДоступныеТипыИзмеряемыхВеличин(Данные, КэшированныеЗначения));
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТипИзмеряемойВеличиныСАТУРНПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииТипаИзмеряемойВеличины(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ТоварыПАТ Тогда
		
		Элементы.ТоварыПАТ.СписокВыбора.ЗагрузитьЗначения(ТекущиеДанные.НоменклатураДляВыбора.ВыгрузитьЗначения());
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ПланПримененияСАТУРН.Форма.ФормаДокумента.Провести",,Истина);
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ПланПримененияСАТУРН.Форма.ФормаДокумента.Записать",,Истина);
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ПланПримененияСАТУРН.Форма.ФормаДокумента.ПровестиИЗакрыть",,Истина);
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоОснованию(Команда)
	ОбработчикПерезаполненияПоОснованию();
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокумент(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Объект.Ссылка, ИнтеграцияСАТУРНКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ПланПримененияСАТУРН.ФормаДокумента.Команда.ОткрытьПодбор");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект);
	СобытияФормСАТУРНКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатуры(ЭтотОбъект, ОписаниеОповещения);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюКомандПодключенныхКОбъекту(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияСАТУРНСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт

	Прочитать();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПослеВыбораОснования(ДанныеВыбора, ДополнительныеПараметры) Экспорт
	
	Если ДанныеВыбора = Элементы.ДокументОснование.ДоступныеТипы.ПривестиЗначение(ДанныеВыбора) Тогда
		Объект.ДокументОснование = ДанныеВыбора;
		Модифицированность       = Истина;
	КонецЕсли;
	
	ЗаполнитьТовары = (ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ОбработатьПерезаполнение"));
	Если ЗаполнитьТовары Тогда
		ОбработчикПерезаполненияПоОснованию(Ложь);
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ДокументОснование");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Оформление поля Описание места применения
	ЦветТекстаНеТребуетВниманияГосИС = ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС;
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект);
	
	ИнтеграцияСАТУРН.УстановитьУсловноеОформлениеПоляПАТ(ЭтотОбъект);
	
	// Представление полей для зарегистрированных мест применения
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МестаПримененияОписаниеМестаПрименения.Имя);
	
	ГруппаОтбораИ = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ГруппаОтбораИЛИ = ГруппаОтбораИ.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбораИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.МестаПрименения.ТипМестаПрименения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыМестПримененияСАТУРН.ЗарегистрованноеМестоПрименения;
	
	ОтборЭлемента = ГруппаОтбораИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.МестаПрименения.ТипМестаПрименения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыМестПримененияСАТУРН.ПустаяСсылка();
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.МестаПрименения.ОписаниеМестаПрименения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Заполните описание, если в списке нет подходящего участка или требуется дополнительное пояснение.'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекстаНеТребуетВниманияГосИС);
	
	// Представление полей для прочих мест применения
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МестаПримененияМестоПрименения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.МестаПрименения.ТипМестаПрименения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыМестПримененияСАТУРН.ЗарегистрованноеМестоПрименения;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не указывается>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере(ОбновитьКомандыОснования = Истина)
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Документы.ПланПримененияСАТУРН);
	ЗаполнитьОтборыПоОснованию(Объект.ДокументОснование, ЭтотОбъект, ОбновитьКомандыОснования);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	ИнтеграцияСАТУРН.ЗаполнитьСопоставленнуюПродукциюВДокументе(Объект.Товары, Не ЗначениеЗаполнено(Объект.Ссылка));
	
	ЗаполнитьГиперссылкиРеквизитов();
	ОбновитьПредставленияНаФорме();
	
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(Объект, Документы.ПланПримененияСАТУРН);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияНаФорме(Прочитать = Ложь)

	Если Прочитать Тогда
		Прочитать();
	КонецЕсли;
	
	ОбновитьСтатусСАТУРН();
	
	ИнтеграцияИСКлиентСервер.УстановитьДоступностьЭлементовГруппыФормыРекурсивно(
		Элементы.СтраницаОсновное, Не РедактированиеФормыНедоступно);
	
	ИнтеграцияИСКлиентСервер.УстановитьДоступностьЭлементовГруппыФормыРекурсивно(
		Элементы.СтраницаМестаПрименения, Не РедактированиеФормыНедоступно);
		
	ИнтеграцияИСКлиентСервер.УстановитьДоступностьЭлементовГруппыФормыРекурсивно(
		Элементы.СтраницаПрепараты, Не РедактированиеФормыНедоступно);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);

	Если Инициализация Или СтруктураРеквизитов.Свойство("ДокументОснование") Тогда
		ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюКомандПодключенныхКОбъекту(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГиперссылкиРеквизитов()
	
	СобытияФормСАТУРН.ЗаполнитьГиперссылкиРеквизитовУпрощенно(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиДатыОграничения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонСтрокиОграничений = НСтр("ru = 'до %1'");
	СтрокаОграничений       = СтрШаблон(ШаблонСтрокиОграничений, Результат);
	
	Объект.СрокОграничений = СтрокаОграничений;
	
КонецПроцедуры

#Область ПерезаполнениеПоОснованию

&НаКлиенте
Процедура ОбработчикПерезаполненияПоОснованию(ЗадаватьВопрос = Истина)
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() > 0 И ЗадаватьВопрос Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные документа будут перезаполнены. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОснованиюПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОснованиюПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьПоОснованиюСервер()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Объект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	ПриСозданииЧтенииНаСервере();

	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПодсказкуВводаОписанияМестаПрименения()
	
	ТекущиеДанные = Элементы.МестаПрименения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипМестаПрименения = ПредопределенноеЗначение("Перечисление.ТипыМестПримененияСАТУРН.ЗарегистрованноеМестоПрименения") Тогда
		
		Элементы.МестаПримененияОписаниеМестаПрименения.ПодсказкаВвода = НСтр("ru = 'Заполните описание, если в списке нет подходящего участка или требуется дополнительное пояснение.'");
		
	Иначе
		
		Элементы.МестаПримененияОписаниеМестаПрименения.ПодсказкаВвода = "";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Статус

&НаСервере
Процедура ОбновитьСтатусСАТУРН()
	
	МенеджерОбъекта = ОбщегоНазначенияИС.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ОрганизацияСАТУРН",        Объект.ОрганизацияСАТУРН);
	
	СтатусСАТУРН = МенеджерОбъекта.СтатусПоУмолчанию();
	
	ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию(Реквизиты);
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	Статусы.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовСАТУРН КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ
		|	И Статусы.ИдентификаторСтроки = &ПустойИдентификатор");
		
		Запрос.УстановитьПараметр("Документ",                 Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияСАТУРН.НеотображаемыеВДокументахДальнейшиеДействия());
		Запрос.УстановитьПараметр("ПустойИдентификатор",      ОбщегоНазначенияИС.ПустоеЗначениеОпределяемогоТипа("УникальныйИдентификаторИС"));
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СтатусСАТУРН = Выборка.Статус;
				
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЦикла;
		
	КонецЕсли;

	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ОтменитеПередачуДанных);
	
	СтатусПредставление = ИнтеграцияСАТУРН.ПредставлениеСтатуса(СтатусСАТУРН, ДальнейшееДействие, ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусСАТУРН <> Перечисления.СтатусыОбработкиПланаПримененияСАТУРН.Черновик
	                              И СтатусСАТУРН <> Перечисления.СтатусыОбработкиПланаПримененияСАТУРН.Ошибка
	                              И СтатусСАТУРН <> Перечисления.СтатусыОбработкиПланаПримененияСАТУРН.ПроведеноЧастично;

КонецПроцедуры

&НаКлиенте
Процедура СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		РазблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;

	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		Отказ = ПроверкаЗаполненияДляПотвержденияПланаПрименения();
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыОбработкиДокументов = ИнтеграцияСАТУРНСлужебныйКлиентСервер.ПараметрыОбработкиДокументов();
		ПараметрыОбработкиДокументов.Ссылка             = Объект.Ссылка;
		ПараметрыОбработкиДокументов.ОрганизацияСАТУРН  = Объект.ОрганизацияСАТУРН;
		ПараметрыОбработкиДокументов.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные");
		
		ОписаниеПриЗавершении = Новый ОписаниеОповещения(
			"Подключаемый_ПриЗавершенииОперации", ЭтотОбъект, ПараметрыОбработкиДокументов);
		
		ИнтеграцияСАТУРНКлиент.ПодготовитьКПередаче(
			ЭтотОбъект,
			ПараметрыОбработкиДокументов,
			ОписаниеПриЗавершении);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияСАТУРНКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачуДанных" Тогда
		
		ИнтеграцияСАТУРНКлиент.ОтменитьПередачу(Объект.Ссылка);
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьПричинуОшибки" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Документ", Объект.Ссылка);
		
		ОткрытьФорму(
			"Документ.ПланПримененияСАТУРН.Форма.ПросмотрРезультатаОбмена",
			ПараметрыОткрытияФормы,
			ЭтотОбъект,
			,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаЗаполненияДляПотвержденияПланаПрименения()
	
	Отказ = Ложь;
	
	ОшибкаЗаполнения = ПроверкаПлановойДатыДляПотвержденияПланаПримения(Объект.ПлановаяДатаПрименения);
	
	Если ОшибкаЗаполнения Тогда
		Отказ = ОшибкаЗаполнения;
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверкаПлановойДатыДляПотвержденияПланаПримения(ПлановаяДатаПрименения)
	
	Отказ = Ложь;
	
	Если ПлановаяДатаПрименения <= НачалоДня(ТекущаяДатаСеанса()) Тогда
		
		ТекстСообщения = НСтр("ru = 'План применения нельзя создавать на дату в прошлом.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,
			"Объект.ПлановаяДатаПрименения",, Отказ);
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ПриВыбореНоменклатуры(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Номенклатура = Номенклатура;
	
	НоменклатураПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	КонецЕсли;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОтборыПоОснованию(ДокументОснование, Форма, НастроитьЗависимыеЭлементыФормы = Истина)
	
	ОтборыПоОснованию = Неопределено;
	Если ДокументОснование <> Неопределено Тогда 
		ОтборыПоОснованию = ИнтеграцияСАТУРНВызовСервера.ОтборыДляРеквизитовДокументаПоОснованию(Тип("ДокументСсылка.ПланПримененияСАТУРН"), ДокументОснование);
	КонецЕсли;
	
	Если ОтборыПоОснованию <> Неопределено Тогда
		Форма.ОрганизацияИзОснованияДляОтбораОрганизацииСАТУРН = ОтборыПоОснованию.ОрганизацияСАТУРН;
	Иначе 
		Форма.ОрганизацияИзОснованияДляОтбораОрганизацииСАТУРН = Неопределено;
	КонецЕсли;
	
	Если НастроитьЗависимыеЭлементыФормы Тогда
		НастроитьЗависимыеЭлементыФормы(Форма, "ДокументОснование");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаПодбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ОбработкаРезультатаПодбораНоменклатуры(Результат, КэшированныеЗначения);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаРезультатаПодбораНоменклатуры(ВыбранноеЗначение, КэшированныеЗначения)
	
	ПараметрыЗаполнения = ИнтеграцияСАТУРН.ПараметрыЗаполненияТабличнойЧастиТовары();
	ПараметрыЗаполнения.Вставить("ПараметрыУказанияСерий", ПараметрыУказанияСерий);
	
	ДобавленныеСтроки = Новый Массив;
	
	СобытияФормСАТУРНПереопределяемый.ОбработкаРезультатаПодбораНоменклатуры(
		ЭтотОбъект, ВыбранноеЗначение, ПараметрыЗаполнения, КэшированныеЗначения, ДобавленныеСтроки);
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ТоварыНоменклатура");
	
КонецПроцедуры

#КонецОбласти
