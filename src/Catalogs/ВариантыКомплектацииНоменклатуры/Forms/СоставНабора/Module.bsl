#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьДанныеФормы();
		НастроитьЭлементыФормы();
	КонецЕсли;

	// Подсистема запрета редактирования ключевых реквизитов объектов.
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьДанныеФормы();
	НастроитьЭлементыФормы();

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрыЗаписи.Вставить("ВладелецКомплекта", Объект.Владелец);
	ПараметрыЗаписи.Вставить("Комплект", Объект.Ссылка);
	ПараметрыЗаписи.Вставить("Основной", Объект.Основной);
	ПараметрыЗаписи.Вставить("Характеристика", Объект.Характеристика);

	Оповестить("Запись_ВариантыКомплектацииНоменклатуры", ПараметрыЗаписи, Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьДанныеФормы();
	НастроитьЭлементыФормы();

	// Подсистема запрета редактирования ключевых реквизитов объектов.
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеКомпонентаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(Неопределено, Объект.НоменклатураОсновногоКомпонента);
КонецПроцедуры

&НаКлиенте
Процедура ВариантПредставленияНабораВПечатныхФормахПриИзменении(Элемент)
	
	НаборыКлиент.ИзменитьВидимостьПредупрежденияОбОграниченииНастроек(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	Действия = Новый Структура("
		|ПроверитьХарактеристикуПоВладельцу,
		|ПроверитьЗаполнитьУпаковкуПоВладельцу, ПересчитатьКоличествоЕдиниц");
	Действия.ПроверитьХарактеристикуПоВладельцу = ТекущаяСтрока.Характеристика;
	Действия.ПроверитьЗаполнитьУпаковкуПоВладельцу = ТекущаяСтрока.Упаковка;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, Действия, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные; 
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,СтруктураДействий,КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные; 
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,СтруктураДействий,КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	Компонент = Элемент.ТекущиеДанные;
	Если Компонент <> Неопределено Тогда
		ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОсновнымКомпонентом(Команда)
	Компонент = Элементы.Товары.ТекущиеДанные;
	Если Компонент <> Неопределено Тогда
		ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Основная комплектующая не установлена. Для установки основной комплектующей необходимо выбрать строку в списке комплектующих.'"));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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
// СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ЗаполнитьДанныеФормы()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Владелец           = Параметры.Отбор.Владелец;
		Объект.Характеристика     = Параметры.Отбор.Характеристика;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Номенклатура.ВидНоменклатуры.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
		|	Номенклатура.ВидНоменклатуры.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка = &Номенклатура");
		
		Запрос.УстановитьПараметр("Номенклатура", Объект.Владелец);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(Объект, Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
	Заголовок = Строка(Объект.Владелец)
	          + ": "
	          + НСтр("ru = 'Состав набора'")
	          + ?(Не ЗначениеЗаполнено(Объект.Ссылка), " (" + НСтр("ru = 'Создание'") + ")", "");
	
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.Владелец);
	
	Действия = Новый Структура("ЗаполнитьПризнакХарактеристикиИспользуются");
	Действия.ЗаполнитьПризнакХарактеристикиИспользуются = Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, Действия);
	
	ПредставлениеОсновногоКомпонента = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
		Объект.НоменклатураОсновногоКомпонента, Объект.ХарактеристикаОсновногоКомпонента);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам";
	
	Если Объект.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих
		ИЛИ НЕ ЗначениеЗаполнено(Объект.ВариантРасчетаЦеныНабора) Тогда
		
		ВариантЗаданияЦены = 0;
		
	Иначе
		
		ВариантЗаданияЦены = 1;
		
		Если Объект.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям Тогда
			
			ВариантРаспределенияЦены = "РаспределяетсяПропорциональноДолям";
			
		Иначе
			
			ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ГруппаЦенаНабораПраво.ТолькоПросмотр = (ВариантЗаданияЦены = 0);
	
	Если Объект.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
		И ВариантЗаданияЦены = 1 Тогда
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Истина;
		Элементы.ТоварыДоляСтоимости.Видимость = Истина;
	Иначе
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ТоварыДоляСтоимости.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ВедетсяУчетПоГТД = ОбщегоНазначенияУТ.ЗначенияРеквизитовОбъектаПоУмолчанию(Объект.Владелец, "ВестиУчетПоГТД").ВестиУчетПоГТД;
	Иначе
		ВедетсяУчетПоГТД = Ложь;
	КонецЕсли;
	
	ПодсказкаОсновнаяКомплектующая = НСтр("ru = 'Текущая позиция является основным компонентом сборки, по которому определяется страна происхождения и номера ГТД'");
	Если Не ВедетсяУчетПоГТД Тогда
		ПодсказкаОсновнаяКомплектующая = НСтр("ru = 'Текущая позиция является основным компонентом сборки'");
	КонецЕсли;
	КомандаУстановитьОсновнымКомпонентом = Команды.Найти("УстановитьОсновнымКомпонентом");
	КомандаУстановитьОсновнымКомпонентом.Подсказка = ПодсказкаОсновнаяКомплектующая;
	
	Элементы.ГруппаПредупреждениеНаборы.Видимость = 
		(Объект.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор
		ИЛИ ВариантЗаданияЦены = 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОсновнойКомпонент(НоменклатураКомпонента, ХарактеристикаКомпонента)
	
	Объект.НоменклатураОсновногоКомпонента = НоменклатураКомпонента;
	Объект.ХарактеристикаОсновногоКомпонента = ХарактеристикаКомпонента;
	
	ПредставлениеОсновногоКомпонента = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
	Объект.НоменклатураОсновногоКомпонента, Объект.ХарактеристикаОсновногоКомпонента);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаданияЦеныПриИзменении(Элемент)
	
	Элементы.ГруппаЦенаНабораПраво.ТолькоПросмотр = (ВариантЗаданияЦены = 0);
	
	Если ВариантЗаданияЦены = 0 Тогда
		Объект.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих");
		Элементы.ТоварыДоляСтоимости.Видимость = Ложь;
		ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам";
	Иначе
		Если ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам" Тогда
			Объект.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам");
		ИначеЕсли ВариантРаспределенияЦены = "РаспределяетсяПропорциональноДолям" Тогда
			Объект.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям");
		КонецЕсли;
	КонецЕсли;
	
	НаборыКлиент.ИзменитьВидимостьПредупрежденияОбОграниченииНастроек(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияЦеныПриИзменении(Элемент)
	
	Если ВариантЗаданияЦены = 0 Тогда
		Объект.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих");
	Иначе
		Если ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам" Тогда
			Объект.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам");
		ИначеЕсли ВариантРаспределенияЦены = "РаспределяетсяПропорциональноДолям" Тогда
			Объект.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям");
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям")
		И ВариантЗаданияЦены = 1 Тогда
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Истина;
		Элементы.ТоварыДоляСтоимости.Видимость = Истина;
	Иначе
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ТоварыДоляСтоимости.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	Если Объект.Товары.Количество() = 1 Тогда
		Компонент = Объект.Товары[0];
		Если Компонент <> Неопределено Тогда
			ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
		КонецЕсли;
	Иначе
		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура", Объект.НоменклатураОсновногоКомпонента);
		Отбор.Вставить("Характеристика", Объект.ХарактеристикаОсновногоКомпонента);
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 И Объект.Товары.Количество() > 0 Тогда
			
			Компонент = Объект.Товары[0];
			Если Компонент <> Неопределено Тогда
				ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	Если Объект.Товары.Количество() = 1 Тогда
		Компонент = Объект.Товары[0];
		Если Компонент <> Неопределено Тогда
			ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.Товары.Количество() = 0 Тогда
		ЗаполнитьОсновнойКомпонент(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
