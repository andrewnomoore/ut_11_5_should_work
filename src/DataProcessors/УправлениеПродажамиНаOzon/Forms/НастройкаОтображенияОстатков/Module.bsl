
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СвойстваУстановлены = Параметры.Свойство("ПараметрыОтображенияОстатковЦен", ПараметрыОтображенияОстатковЦен)
		И Параметры.Свойство("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	Если Не СвойстваУстановлены Тогда
		// Проверка обязательных параметров
		ВызватьИсключение НСтр("ru = 'Для открытия формы необходимо передать параметры.'");
	КонецЕсли;

	ИнициализироватьДеревоНастроек();
	УстановитьУсловноеОформление();

КонецПроцедуры        

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ПорядокНастроек = ОбщегоНазначенияВызовСервера.ХранилищеНастроекДанныхФормЗагрузить(ИмяФормы, "ПорядокНастроек", Неопределено);
	Если ПорядокНастроек <> Неопределено Тогда
		Для Каждого ГруппаНастроек Из ДеревоНастроек.ПолучитьЭлементы() Цикл
			Для Каждого СтрокаНастройки Из ГруппаНастроек.ПолучитьЭлементы() Цикл
				ПорядокНастроек.Свойство(СтрокаНастройки.Идентификатор, СтрокаНастройки.Порядок);
			КонецЦикла;
		КонецЦикла;
		УстановитьПорядокНастроек();
		Для Каждого ГруппаНастроек Из ДеревоНастроек.ПолучитьЭлементы() Цикл
			Элементы.ДеревоНастроек.Развернуть(ГруппаНастроек.ПолучитьИдентификатор(), Ложь);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьПараметрыОтображенияОстатковЦен();
	СохранитьПорядокНастроек();
	ДанныеОповещения = Новый Структура("Источник, ПараметрыОтображенияОстатковЦен", "НастройкаОтображенияОстатков", ПараметрыОтображенияОстатковЦен);
	ОповеститьОВыборе(ДанныеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтметки(Команда)

	УстановитьПометку(Истина);

КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)

	УстановитьПометку(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоУмолчанию(Команда)

	УстановитьНастройкиПоУмолчаниюНаСервере();
	Для Каждого ГруппаНастроек Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		Элементы.ДеревоНастроек.Развернуть(ГруппаНастроек.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьДеревоНастроек()

	НастройкиУчетнойЗаписи = ИнтеграцияСМаркетплейсомOzonСервер.НастройкиУчетнойЗаписиСЗагружаемымиВидамиЦен(УчетнаяЗаписьМаркетплейса);
	ВидыЦен = НастройкиУчетнойЗаписи.ВидыЦен;
	ИспользуемыеСклады = ИнтеграцияСМаркетплейсамиСервер.ПолучитьСопоставленныеСклады(УчетнаяЗаписьМаркетплейса, Истина, Ложь);
	ПредставлениеСкладов = СтрСоединить(ИспользуемыеСклады, ", ");

	ЭлементыВерхнегоУровня = ДеревоНастроек.ПолучитьЭлементы();
	ЭлементыВерхнегоУровня.Очистить();
	СтрокаРодитель = ЭлементыВерхнегоУровня.Добавить();
	СтрокаРодитель.Наименование = НСтр("ru = 'Остатки'");
	СтрокаРодитель.Идентификатор = "Остатки";
	СтрокаРодитель.ЕстьОшибки = Истина;

	ТекстОшибки = НСтр("ru = 'Нет сопоставленных складов'");
	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "ОстатокПоУчету", НСтр("ru = 'Остаток по учету'"),
		ПредставлениеСкладов, ТекстОшибки);

	ДобавитьСтрокуВДерево(СтрокаРодитель, "ОстатокНаOzon", НСтр("ru = 'Остаток на Ozon'"),
		НСтр("ru = 'Общий остаток на маркетплейсе'"), "");

	ДобавитьСтрокуВДерево(СтрокаРодитель, "ОстатокFBO", НСтр("ru = 'Остаток FBO'"),
		НСтр("ru = 'Остаток на складах Ozon'"), "");

	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "ОстатокFBS", НСтр("ru = 'Остаток FBS'"),
		ПредставлениеСкладов, ТекстОшибки);

	СтрокаРодитель = ЭлементыВерхнегоУровня.Добавить();
	СтрокаРодитель.Наименование = НСтр("ru = 'Виды цен'");
	СтрокаРодитель.Идентификатор = "ВидыЦен";
	СтрокаРодитель.ЕстьОшибки = Истина;

	ТекстОшибки = НСтр("ru = 'Не указан вид цен'");
	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "ЦенаСоСкидкой", НСтр("ru = 'Цена со скидками'"),
		ВидыЦен.ВидЦеныСУчетомСкидок, ТекстОшибки);

	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "ЦенаДоСкидки", НСтр("ru = 'Цена до скидок'"),
		ВидыЦен.ВидЦеныДоСкидок, ТекстОшибки);

	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "МинимальнаяЦена", НСтр("ru = 'Минимальная цена'"),
		ВидыЦен.ВидЦеныМинимальныхЦен, ТекстОшибки);

	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "ЦенаСУчетомАкцийПродавца", НСтр("ru = 'Цена с акциями продавца'"),
		ВидыЦен.ВидЦеныСАкциямиПродавца, ТекстОшибки);

	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "ЦенаСУчетомВсехАкций", НСтр("ru = 'Цена со всеми акциями'"),
		ВидыЦен.ВидЦеныСоВсемиАкциями, ТекстОшибки);

	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "РекомендованнаяЦена", НСтр("ru = 'Рекомендованная цена'"),
		ВидыЦен.ВидЦеныРекомендованный, ТекстОшибки);

	СтрокаНастройки = ДобавитьСтрокуВДерево(СтрокаРодитель, "ЦенаПоставщика", НСтр("ru = 'Цена поставщика'"),
		ВидыЦен.ВидЦеныПоставщика, ТекстОшибки);

КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуВДерево(Родитель, Идентификатор, Наименование, Пояснение, ТекстОшибки)

	СписокНастроек = Родитель.ПолучитьЭлементы();
	СтрокаНастройки = СписокНастроек.Добавить();
	СтрокаНастройки.Идентификатор = Идентификатор;
	СтрокаНастройки.Наименование = Наименование;
	Если ПустаяСтрока(Пояснение) Тогда
		СтрокаНастройки.Пояснение = ТекстОшибки;
		СтрокаНастройки.ЕстьОшибки = Истина;
		СтрокаНастройки.ОтображатьВТаблице = Ложь;
		СтрокаНастройки.ОтображатьВИнформационномПоле = Ложь;
	Иначе
		СтрокаНастройки.Пояснение = Пояснение;
		СтрокаНастройки.ОтображатьВТаблице = ПараметрыОтображенияОстатковЦен[Идентификатор].ОтображатьВТаблице;
		СтрокаНастройки.ОтображатьВИнформационномПоле = ПараметрыОтображенияОстатковЦен[Идентификатор].ОтображатьВИнформационномПоле;
	КонецЕсли;
	СтрокаНастройки.Порядок = СписокНастроек.Количество();

	Возврат СтрокаНастройки;

КонецФункции

&НаСервере
Процедура ЗаполнитьПараметрыОтображенияОстатковЦен()

	ЦеныИнфоПоля = Новый Массив;
	ЦеныПодсказки = Новый Массив;
	ОстаткиИнфоПоля = Новый Массив;
	ОстаткиПодсказки = Новый Массив;

	Для Каждого СтрокаВерхнегоУровня Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		НомерВПоле = 0;
		Для Каждого СтрокаНастройки Из СтрокаВерхнегоУровня.ПолучитьЭлементы() Цикл
			ЗначениеНастройки = ПараметрыОтображенияОстатковЦен[СтрокаНастройки.Идентификатор];
			ЗначениеНастройки.Вставить("Наименование", СтрокаНастройки.Наименование);
			ЗначениеНастройки.ОтображатьВТаблице = СтрокаНастройки.ОтображатьВТаблице;
			ЗначениеНастройки.ОтображатьВИнформационномПоле = СтрокаНастройки.ОтображатьВИнформационномПоле;
			Если СтрокаВерхнегоУровня.Идентификатор = "Остатки" Тогда
				Если СтрокаНастройки.ОтображатьВИнформационномПоле Тогда
					Если НомерВПоле < 2 Тогда
						НомерВПоле = НомерВПоле + 1;
						ОстаткиИнфоПоля.Добавить(СтрокаНастройки.Идентификатор);
					Иначе
						ОстаткиПодсказки.Добавить(СтрокаНастройки.Идентификатор);
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если СтрокаНастройки.ОтображатьВИнформационномПоле Тогда
					Если НомерВПоле < 2 Тогда
						НомерВПоле = НомерВПоле + 1;
						ЦеныИнфоПоля.Добавить(СтрокаНастройки.Идентификатор);
					Иначе
						ЦеныПодсказки.Добавить(СтрокаНастройки.Идентификатор);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			ПараметрыОтображенияОстатковЦен.Вставить("ЦеныИнфоПоля", ЦеныИнфоПоля);
			ПараметрыОтображенияОстатковЦен.Вставить("ЦеныПодсказки", ЦеныПодсказки);
			ПараметрыОтображенияОстатковЦен.Вставить("ОстаткиИнфоПоля", ОстаткиИнфоПоля);
			ПараметрыОтображенияОстатковЦен.Вставить("ОстаткиПодсказки", ОстаткиПодсказки);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьПорядокНастроек()

	ДеревоЗначений = РеквизитФормыВЗначение("ДеревоНастроек");
	ДеревоЗначений.Строки.Сортировать("Порядок", Истина);
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоНастроек");

КонецПроцедуры

&НаКлиенте
Процедура СохранитьПорядокНастроек()

	НомерПоПорядку = 1;
	ПорядокНастроек = Новый Структура();
	Для Каждого ГруппаНастроек Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаНастройки Из ГруппаНастроек.ПолучитьЭлементы() Цикл
			ПорядокНастроек.Вставить(СтрокаНастройки.Идентификатор, НомерПоПорядку);
			НомерПоПорядку = НомерПоПорядку + 1;
		КонецЦикла;
	КонецЦикла;
	ОбщегоНазначенияВызовСервера.ХранилищеНастроекДанныхФормСохранить(ИмяФормы, "ПорядокНастроек", ПорядокНастроек);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

 	УсловноеОформление.Элементы.Очистить();

    //
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНастроекОтображатьВТаблице.Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНастроекОтображатьВИнформационномПоле.Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоНастроек.Идентификатор");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

    //
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНастроекОтображатьВТаблице.Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНастроекОтображатьВИнформационномПоле.Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНастроекПояснение.Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоНастроек.ЕстьОшибки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометку(Пометка)

	Для Каждого ГруппаДереваНастроек Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		Для Каждого ЭлементДереваНастроек Из ГруппаДереваНастроек.ПолучитьЭлементы() Цикл
			Если ЭлементДереваНастроек.ЕстьОшибки Тогда
				Продолжить;
			КонецЕсли;
			ЭлементДереваНастроек.ОтображатьВТаблице = Пометка;
			ЭлементДереваНастроек.ОтображатьВИнформационномПоле = Пометка;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиПоУмолчаниюНаСервере()

	ПараметрыОтображенияОстатковЦен = ИнтеграцияСМаркетплейсомOzonСервер.НовыеПараметрыОтображенияОстатковЦен(УчетнаяЗаписьМаркетплейса);
	ИнициализироватьДеревоНастроек();

КонецПроцедуры

#КонецОбласти
