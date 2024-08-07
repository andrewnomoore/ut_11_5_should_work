
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.ЗакрыватьПриВыборе            = Истина;
	Параметры.ЗакрыватьПриЗакрытииВладельца = Истина;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры);
	
	Если ПрименениеПриказа107н Тогда
		Элементы.КодОКАТО.Заголовок = НСтр("ru='ОКТМО'");
	Иначе
		Элементы.КодОКАТО.Заголовок = НСтр("ru='ОКАТО'");
	КонецЕсли;
	
	СписокВыбораПоказателяДаты = Элементы.ПоказательДаты.СписокВыбора;
	СписокВыбораПоказателяДаты.Добавить("0",     НСтр("ru='0 - не указывается'"));
	Если ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж Тогда
		СписокВыбораПоказателяДаты.Добавить("00",     НСтр("ru='00 - иные случаи'"));
	КонецЕсли;
	СписокВыбораПоказателяДаты.Добавить("Дата",  НСтр("ru='Дата...'"));
	
	Если ЗначениеЗаполнено(ПоказательДаты) И ПоказательДаты <> "0" И ПоказательДаты <> "00" Тогда
		ОписаниеТипаДата = Новый ОписаниеТипов("Дата");
		ПоказательДаты = ОписаниеТипаДата.ПривестиЗначение(Сред(ПоказательДаты, 7) + Сред(ПоказательДаты, 4, 2) + Сред(ПоказательДаты, 1, 2));
		
		Элементы.ПоказательДаты.ОграничениеТипа = ОписаниеТипаДата;
		
		Элементы.ПоказательДаты.КнопкаВыбора = Истина;
		Элементы.ПоказательДаты.РедактированиеТекста = Истина;
	КонецЕсли;
	
	УправлениеПоказателямиПлатежаВБюджет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Модифицированность И Не Готово Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
			НСтр("ru = 'Все измененные данные будут потеряны. Закрыть форму?'"), 
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = "Закрыть" Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидПеречисленияВБюджетПриИзменении(Элемент)
	
	ВидПеречисленияВБюджетПриИзмененииСервер();
	ЗаполнитьПоказателиНомераИДаты();
	
КонецПроцедуры

&НаСервере
Процедура ВидПеречисленияВБюджетПриИзмененииСервер()
	
	СписокВыбораПоказателяДаты = Элементы.ПоказательДаты.СписокВыбора;
	СписокВыбораПоказателяДаты.Очистить();
	СписокВыбораПоказателяДаты.Добавить("0",     НСтр("ru='0 - не указывается'"));
	
	Если ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.НалоговыйПлатеж Тогда
		СтатусСоставителя = "01";
		ПоказательОснования = "";
		ПоказательПериода = "";
		ПоказательТипа = "";
		
	ИначеЕсли ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж Тогда
		СтатусСоставителя = "06";
		ПоказательОснования = "";
		ПоказательПериода = "";
		ПоказательТипа = "";
		
		СписокВыбораПоказателяДаты.Добавить("00",     НСтр("ru='00 - иные случаи'"));
	
	ИначеЕсли ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ИнойПлатеж Тогда
		СтатусСоставителя = "08";
		ПоказательОснования = "0";
		ПоказательПериода = "0";
		ПоказательНомера = "0";
		ПоказательДаты = "0";
		ПоказательТипа = ?(ПрименениеПриказа126н, "", "0");
		
	КонецЕсли;
	
	СписокВыбораПоказателяДаты.Добавить("Дата",  НСтр("ru='Дата...'"));
	
	УправлениеПоказателямиПлатежаВБюджет();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусСоставителяПриИзменении(Элемент)
	
	Если ПустаяСтрока(СтатусСоставителя) Тогда
		СтатусСоставителя = "01";
	КонецЕсли;
	Модифицированность = Истина;
	УправлениеПоказателямиПлатежаВБюджет();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусСоставителяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Список = ПлатежиВБюджетКлиентСервер.СтатусыПлательщика(ПрименениеПриказа107н, ТекущаяДата);
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("СтатусСоставителяНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент)), Список, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусСоставителяНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	ЭлементСписка = ВыбранныйЭлемент;
	Если ЭлементСписка <> Неопределено Тогда
		СтатусСоставителя = ЭлементСписка.Значение;
		СтатусСоставителяПриИзменении(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодБКПриИзменении(Элемент)
	
	КодБКПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКАТОПриИзменении(Элемент)
	
	ОчиститьСообщения();
	Если Не ПлатежиВБюджетКлиентСервер.КорректныйОКТМО(КодОКАТО) Тогда
		ТекстСообщения = НСтр("ru = 'При заполнении одиннадцатизначного кода ОКТМО, значение ""000"" в 9-11 знаках кода недопустимо.
			|
			|Введите 8-значный код муниципального образования или укажите идентификатор населенного пункта в 9-11 знаках.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодОКАТО", "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательОснованияПриИзменении(Элемент)
	
	ЗаполнитьПоказателиНомераИДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательОснованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Список = ПлатежиВБюджетКлиентСервер.ОснованияПлатежа(ВидПеречисленияВБюджет, ПрименениеПриказа107н, ТекущаяДата);
	
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ПоказательОснованияНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент)), Список, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательОснованияНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	ЭлементСписка = ВыбранныйЭлемент;
	Если ЭлементСписка <> Неопределено Тогда
		ПоказательОснования = ЭлементСписка.Значение;
		ЗаполнитьПоказателиНомераИДаты();
		СтатусСоставителяПриИзменении(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтруктураПараметры = Новый Структура("ПоказательПериода, ПоказательОснования",
		ПоказательПериода,
		ПоказательОснования);
	
	ОткрытьФорму(
		"Документ.СписаниеБезналичныхДенежныхСредств.Форма.ФормаВводаПериода",
		СтруктураПараметры,
		Элемент,,,,
		Новый ОписаниеОповещения("ПоказательПериодаНачалоВыбораЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательПериодаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Значение = Результат;
	Если Значение <> Неопределено Тогда
		ПоказательПериода = Значение;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательДатыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "Дата" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Оповещение = Новый ОписаниеОповещения("ВыполнитьПослеВыбораДаты", ЭтотОбъект);
		
		Если ТипЗнч(ПоказательДаты) = Тип("Дата") Тогда
			НачальноеЗначение = ПоказательДаты;
		Иначе
			НачальноеЗначение = Неопределено;
		КонецЕсли;
		
		ПоясняющийТекст = НСтр("ru='Выберите дату подписания документа'") + " ";
		ОткрытьФорму(
			"ОбщаяФорма.ВыборДаты",
			Новый Структура("ПоясняющийТекст, НачальноеЗначение", ПоясняющийТекст, НачальноеЗначение),
			,,,,
			Оповещение,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) <> Тип("Дата") Тогда
		
		ОписаниеТиповДата = Новый ОписаниеТипов("Строка");
		Элемент.ОграничениеТипа = ОписаниеТиповДата;
		
		Элемент.КнопкаВыбора = Ложь;
		Элемент.РедактированиеТекста = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораДаты(ВыбраннаяДата, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбраннаяДата) Тогда
		
		ПоказательДаты = ВыбраннаяДата;
		
		ОписаниеТиповДата = Новый ОписаниеТипов("Дата");
		Элементы.ПоказательДаты.ОграничениеТипа = ОписаниеТиповДата;
		
		Элементы.ПоказательДаты.КнопкаВыбора = Истина;
		Элементы.ПоказательДаты.РедактированиеТекста = Истина;
		
		Модифицированность = Истина;
	Иначе
		
		Если ТипЗнч(ПоказательДаты) = Тип("Дата") Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательТипаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Список = ПлатежиВБюджетКлиентСервер.ТипыПлатежа(ВидПеречисленияВБюджет, ПрименениеПриказа107н);
	
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ПоказательТипаНачалоВыбораЗавершение", ЭтотОбъект), Список, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательТипаНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	ЭлементСписка = ВыбранныйЭлемент;
	Если ЭлементСписка <> Неопределено Тогда
		ПоказательТипа = ЭлементСписка.Значение;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если Не Модифицированность Или ТолькоПросмотр Тогда
		
		Закрыть();
		
	Иначе
		Если ТипЗнч(ПоказательДаты) = Тип("Дата") Тогда
			ПоказательДаты = Формат(ПоказательДаты, "ДЛФ=D");
		КонецЕсли;
		
		СтруктураОбъекта = Новый Структура;
		СтруктураОбъекта.Вставить("ВидПеречисленияВБюджет", ВидПеречисленияВБюджет);
		СтруктураОбъекта.Вставить("КодБК",                  КодБК);
		СтруктураОбъекта.Вставить("КодОКАТО",               КодОКАТО);
		СтруктураОбъекта.Вставить("ПоказательДаты",         ПоказательДаты);
		СтруктураОбъекта.Вставить("ПоказательНомера",       ПоказательНомера);
		СтруктураОбъекта.Вставить("ПоказательОснования",    ПоказательОснования);
		СтруктураОбъекта.Вставить("ПоказательПериода",      ПоказательПериода);
		СтруктураОбъекта.Вставить("ПоказательТипа",         ПоказательТипа);
		СтруктураОбъекта.Вставить("СтатусСоставителя",      СтатусСоставителя);
		
		Готово = Истина;
		
		Закрыть(СтруктураОбъекта);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеПоказателямиПлатежаВБюджет()
	
	Элементы.ВидПеречисленияВБюджет.Видимость = (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств);
	
	Если ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.НалоговыйПлатеж Тогда
		
		Элементы.ПоказательПериода.Видимость      = Истина;
		Элементы.КодТаможенногоОргана.Видимость   = Ложь;
		Элементы.ПоказательНомера.Видимость       = Истина;
		Элементы.ПоказательДаты.Видимость         = Истина;
		
	ИначеЕсли ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж Тогда
		
		Элементы.ПоказательПериода.Видимость      = Ложь;
		Элементы.КодТаможенногоОргана.Видимость   = Истина;
		Элементы.ПоказательНомера.Видимость       = Истина;
		Элементы.ПоказательДаты.Видимость         = Истина;
		
	ИначеЕсли ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ИнойПлатеж Тогда
		
		Элементы.ПоказательПериода.Видимость      = Ложь;
		Элементы.КодТаможенногоОргана.Видимость   = Ложь;
		Если СтатусСоставителя = "03"
			Или СтатусСоставителя = "19"
			Или СтатусСоставителя = "20"
			Или СтатусСоставителя = "24"
		Тогда
			Элементы.ПоказательНомера.Видимость   = Истина;
		Иначе
			Элементы.ПоказательНомера.Видимость   = Ложь;
		КонецЕсли;
		Элементы.ПоказательДаты.Видимость         = Ложь;
		
	КонецЕсли;
	
	Элементы.ПоказательТипа.Видимость = Не ПрименениеПриказа126н;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоказателиНомераИДаты()

	Если ВидПеречисленияВБюджет = ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.ТаможенныйПлатеж")
		И ПоказательОснования = "00" Тогда
		ПоказательНомера = "00";
		ПоказательДаты = "00";
	Иначе
		Если ПоказательНомера = "00" Тогда
			ПоказательНомера = "0";
		КонецЕсли;
		Если ПоказательДаты = "00" Тогда
			ПоказательДаты = "0";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура КодБКПриИзмененииНаСервере()

	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("Дата",                   ТекущаяДата);
	ДанныеОбъекта.Вставить("ВидПеречисленияВБюджет", ВидПеречисленияВБюджет);
	ДанныеОбъекта.Вставить("КодБК",                  КодБК);
	ДанныеОбъекта.Вставить("КодОКАТО",               КодОКАТО);
	ДанныеОбъекта.Вставить("ПоказательДаты",         ПоказательДаты);
	ДанныеОбъекта.Вставить("ПоказательНомера",       ПоказательНомера);
	ДанныеОбъекта.Вставить("ПоказательОснования",    ПоказательОснования);
	ДанныеОбъекта.Вставить("ПоказательПериода",      ПоказательПериода);
	ДанныеОбъекта.Вставить("СтатусСоставителя",      СтатусСоставителя);
	ДанныеОбъекта.Вставить("ТипНалога",              ТипНалога);
	
	ПлатежиВБюджет.РеквизитыПлатежаВБюджетПоУмолчанию(ДанныеОбъекта);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);

КонецПроцедуры

#КонецОбласти