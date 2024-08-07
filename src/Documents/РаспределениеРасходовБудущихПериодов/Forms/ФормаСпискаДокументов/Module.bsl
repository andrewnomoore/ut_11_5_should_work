
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = Документы.РаспределениеРасходовБудущихПериодов.ТекстЗапросаРасходыКРаспределению();
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.РасходыКРаспределению,
		СвойстваСписка);	
	
	Если Параметры.Свойство("Организация") Тогда
		 Организация = Параметры.Организация;
		 ЭтаФорма.Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРаспоряженияНаОформление;
	КонецЕсли;
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		 Период = НачалоМесяца(Параметры.ПериодРегистрации);
	Иначе
		 Период = НачалоМесяца(ТекущаяДата());
	КонецЕсли;
	УстановитьОтборДинамическихСписков();
	УстановитьПараметрыДинамическихСписков();
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	Элементы.РасходыКРаспределениюГруппаКРаспределениюУпр.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'К распределению в упр. учете (%1)'"),
		ВалютаУправленческогоУчета);
		
	УстановитьОформлениеДинамическихСписков();
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);
	
	УстановитьВидимостьДоступностьЭлементов();
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РаспределениеРасходовБудущихПериодов" Тогда
		Элементы.РасходыКРаспределению.Обновить();
	ИначеЕсли ИмяСобытия = "Запись_НаборКонстант" Тогда
		УстановитьВидимостьДоступностьЭлементов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.Свойство("Организация") Тогда
		 Организация = Параметры.Организация;
	Иначе 
		 Организация = Настройки.Получить("Организация");
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") Тогда
		 Подразделение = Параметры.Подразделение;
	Иначе 
		 Подразделение = Настройки.Получить("Подразделение");
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		Период = Параметры.ПериодРегистрации;
	ИначеЕсли Настройки.Получить("Период") <> Неопределено Тогда
		Период = Настройки.Получить("Период");
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();
	УстановитьОформлениеДинамическихСписков();
	УстановитьОтборДинамическихСписков();
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОформлениеДинамическихСписков();
	УстановитьОтборДинамическихСписков();
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры


&НаКлиенте
Процедура МесяцСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработчикЗакрытия = Новый ОписаниеОповещения("МесяцСтрокаНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы 	   = Новый Структура("Значение, РежимВыбораПериода", Период, "МЕСЯЦ");
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор,
		,
		, 
		ОбработчикЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод <> Неопределено Тогда
		Период = ВыбранныйПериод;
		МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);

		УстановитьПараметрыДинамическихСписков();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(
		Направление,
		СтандартнаяОбработка,
		Период,
		МесяцСтрока);
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаРаспоряженияНаОформление Тогда
		Элементы.РасходыКРаспределению.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьРаспределениеРасходов(Команда)
	
	Строка = Элементы.РасходыКРаспределению.ТекущиеДанные;
	Если Строка <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура("Дата, Организация, Подразделение",
			Период,
			Строка.Организация,
			Строка.Подразделение);
			
		СтруктураОснование.Вставить("Период", КонецМесяца(Период));
		СтруктураОснование.Вставить("СтатьяРасходов",     Строка.СтатьяРасходов);
		СтруктураОснование.Вставить("АналитикаРасходов",  Строка.АналитикаРасходов);
		СтруктураОснование.Вставить("НаправлениеДеятельности", Строка.НаправлениеДеятельности);
		СтруктураОснование.Вставить("СуммаДокумента",     Строка.Сумма);
		СтруктураОснование.Вставить("СуммаДокументаУпр",  Строка.СуммаУпр);
		СтруктураОснование.Вставить("СуммаДокументаРегл", Строка.СуммаРегл);
		СтруктураОснование.Вставить("СуммаДокументаПР",   Строка.ПостояннаяРазница);
		СтруктураОснование.Вставить("СуммаДокументаВР",   Строка.ВременнаяРазница);
		СтруктураОснование.Вставить("СуммаДокументаНДД",  Строка.СуммаНДД);
		СтруктураОснование.Вставить("РаспределениеИзОВЗ", НЕ ЗначениеЗаполнено(Строка.СтатьяРасходов));
		
		ПараметрыСтатьи = Новый Структура;
		ПараметрыСтатьи.Вставить("Период", Период);
		ПараметрыСтатьи.Вставить("Организация",
			?(ЗначениеЗаполнено(Строка.Организация),
				Строка.Организация,
				ОрганизацияПоУмолчанию));
		ПараметрыСтатьи.Вставить("Подразделение", Строка.Подразделение);
		ПараметрыСтатьи.Вставить("СтатьяРасходов", Строка.СтатьяРасходов);
		ПараметрыСтатьи.Вставить("АналитикаРасходов", Строка.АналитикаРасходов);
		ПараметрыСтатьи.Вставить("НаправлениеДеятельности", Строка.НаправлениеДеятельности);
		СостояниеРаспределения = ПолучитьСостояниеРаспределенияРБП(ПараметрыСтатьи);
		Если СостояниеРаспределения = Неопределено Тогда
			ТекстОшибки = НСтр("ru='По выбранной строке внесены ошибочные данные. 
			|Возможно в текущем периоде введено более одного документа распределения.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "РасходыКРаспределению");
		КонецЕсли;
		
		НаборПравил = Новый Соответствие();
		НаборРазрезовУчета = Новый Структура();
		 
		Если СостояниеРаспределения.УправленческийУчет 
			И НЕ ЗначениеЗаполнено(СостояниеРаспределения.ДокументУпр) 
		Тогда
			НаборРазрезовУчета.Вставить("УправленческийУчет", Истина);
			Если ЗначениеЗаполнено(СостояниеРаспределения.ПравилоРаспределенияРасходовУпр) Тогда
				НаборПравил.Вставить(СостояниеРаспределения.ПравилоРаспределенияРасходовУпр);
			КонецЕсли;
		Иначе
			НаборРазрезовУчета.Вставить("УправленческийУчет", Ложь);
		КонецЕсли;
		
		Если СостояниеРаспределения.РегламентированныйУчет 
			И НЕ ЗначениеЗаполнено(СостояниеРаспределения.ДокументРегл) 
		Тогда
			НаборРазрезовУчета.Вставить("РегламентированныйУчет", Истина);
			Если ЗначениеЗаполнено(СостояниеРаспределения.ПравилоРаспределенияРасходовРегл) Тогда
				НаборПравил.Вставить(СостояниеРаспределения.ПравилоРаспределенияРасходовРегл);
			КонецЕсли;
		Иначе
			НаборРазрезовУчета.Вставить("РегламентированныйУчет", Ложь);
		КонецЕсли;
		
		
		Если НаборПравил.Количество() <= 1 Тогда
			Для Каждого Правило Из НаборПравил Цикл
				СтруктураОснование.Вставить("ПравилоРБП", Правило.Ключ);
			КонецЦикла;
			Для Каждого РазрезУчета Из НаборРазрезовУчета Цикл
				СтруктураОснование.Вставить(РазрезУчета.Ключ, РазрезУчета.Значение);
			КонецЦикла;
			СтруктураПараметры = Новый Структура;
			СтруктураПараметры.Вставить("Основание", СтруктураОснование);
			ОткрытьФорму("Документ.РаспределениеРасходовБудущихПериодов.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
		Иначе
			ОткрытьФорму("Документ.РаспределениеРасходовБудущихПериодов.Форма.ФормаВыбораНастроек", СостояниеРаспределения, Элементы.Список, , , , 
				Новый ОписаниеОповещения("СоздатьРаспределениеРасходовЗавершение", ЭтотОбъект, СтруктураОснование), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокДокументовРаспределениеРБП(Команда)
	ОткрытьФорму("Документ.РаспределениеРасходовБудущихПериодов.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуРасхода(Команда)

	Если Элементы.РасходыКРаспределению.ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПоляВидовУчета = Новый Соответствие;
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСумма", 0);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаУпр", 2);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаРегл", 3);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаНУ", 4);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюПостояннаяРазница", 4);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюВременнаяРазница", 4);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаНДД", 4);
	
	ДанныеОтчета = ПоляВидовУчета.Получить(Элементы.РасходыКРаспределению.ТекущийЭлемент.Имя);
	
	ПараметрыФормыРасшифровки = Новый Структура;
	ПараметрыФормыРасшифровки.Вставить("Организация", Элементы.РасходыКРаспределению.ТекущиеДанные.Организация);
	ПараметрыФормыРасшифровки.Вставить("Подразделение", Элементы.РасходыКРаспределению.ТекущиеДанные.Подразделение);
	ПараметрыФормыРасшифровки.Вставить("НаправлениеДеятельности", Элементы.РасходыКРаспределению.ТекущиеДанные.НаправлениеДеятельности);
	ПараметрыФормыРасшифровки.Вставить("СтатьяРасходов", Элементы.РасходыКРаспределению.ТекущиеДанные.СтатьяРасходов);
	ПараметрыФормыРасшифровки.Вставить("АналитикаРасходов", Элементы.РасходыКРаспределению.ТекущиеДанные.АналитикаРасходов);
	ПараметрыФормыРасшифровки.Вставить("ВариантРаспределения", ПредопределенноеЗначение("Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов"));
	ПараметрыФормыРасшифровки.Вставить("Периодичность", 1);
	ПараметрыФормыРасшифровки.Вставить("ПериодАкцентирования", Новый СтандартныйПериод(НачалоМесяца(Период), КонецМесяца(Период)));
	
	Если ДанныеОтчета <> Неопределено Тогда
		ПараметрыФормыРасшифровки.Вставить("ДанныеОтчета", ДанныеОтчета);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("Отбор", ПараметрыФормыРасшифровки);
	
	ОткрытьФорму("Отчет.КарточкаРасхода.ФормаОбъекта", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАнализРБП(Команда)

	Если Элементы.РасходыКРаспределению.ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПоляВидовУчета = Новый Соответствие;
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСумма", 0);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаУпр", 2);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаРегл", 3);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаНУ", 4);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюПостояннаяРазница", 4);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюВременнаяРазница", 4);
	ПоляВидовУчета.Вставить("РасходыКРаспределениюСуммаНДД", 4);
	
	ДанныеОтчета = ПоляВидовУчета.Получить(Элементы.РасходыКРаспределению.ТекущийЭлемент.Имя);
	
	ПараметрыФормыРасшифровки = Новый Структура;
	ПараметрыФормыРасшифровки.Вставить("Организация", Элементы.РасходыКРаспределению.ТекущиеДанные.Организация);
	ПараметрыФормыРасшифровки.Вставить("Подразделение", Элементы.РасходыКРаспределению.ТекущиеДанные.Подразделение);
	ПараметрыФормыРасшифровки.Вставить("НаправлениеДеятельности", Элементы.РасходыКРаспределению.ТекущиеДанные.НаправлениеДеятельности);
	ПараметрыФормыРасшифровки.Вставить("СтатьяРасходов", Элементы.РасходыКРаспределению.ТекущиеДанные.СтатьяРасходов);
	ПараметрыФормыРасшифровки.Вставить("АналитикаРасходов", Элементы.РасходыКРаспределению.ТекущиеДанные.АналитикаРасходов);
	ПараметрыФормыРасшифровки.Вставить("ПериодАкцентирования", Новый СтандартныйПериод(НачалоМесяца(Период), КонецМесяца(Период)));
	
	Если ДанныеОтчета <> Неопределено Тогда
		ПараметрыФормыРасшифровки.Вставить("ДанныеОтчета", ДанныеОтчета);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("Отбор", ПараметрыФормыРасшифровки);
	
	ОткрытьФорму("Отчет.АнализРБП.ФормаОбъекта", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ПереключитьОтображатьРазницы(Команда)
	ОтображатьРазницы = Не ОтображатьРазницы;
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	лДатаНачала = ?(ЗначениеЗаполнено(Период), НачалоМесяца(Период), НачалоМесяца(ТекущаяДатаСеанса()));
	лДатаОкончания = ?(ЗначениеЗаполнено(Период), КонецМесяца(Период), КонецМесяца(ТекущаяДатаСеанса()));
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачала", лДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", лДатаОкончания);
	
	РасходыКРаспределению.Параметры.УстановитьЗначениеПараметра("НачалоПериода", лДатаНачала);
	РасходыКРаспределению.Параметры.УстановитьЗначениеПараметра("КонецПериода", лДатаОкончания);
	РасходыКРаспределению.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
	РасходыКРаспределению.Параметры.УстановитьЗначениеПараметра("ПоВсемОрганизациям", Не ЗначениеЗаполнено(Организация));
	РасходыКРаспределению.Параметры.УстановитьЗначениеПараметра("Подразделение", Подразделение);
	РасходыКРаспределению.Параметры.УстановитьЗначениеПараметра("ПоВсемПодразделениям", Не ЗначениеЗаполнено(Подразделение));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Подразделение", Подразделение, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Подразделение));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСостояниеРаспределенияРБП(Параметры)
	
	Результат = Новый Структура("
	|УправленческийУчет,ПравилоРаспределенияРасходовУпр,ДокументУпр,
	|РегламентированныйУчет,ПравилоРаспределенияРасходовРегл,ДокументРегл
	|");
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	
	|	СтатьиРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов) КАК УправленческийУчет,
	|	СтатьиРасходов.ПравилоРаспределенияРасходовУпр КАК ПравилоРаспределенияРасходовУпр,
	|	ЕСТЬNULL(ДокументыУУ.Ссылка, ЗНАЧЕНИЕ(Документ.РаспределениеРасходовБудущихПериодов.ПустаяСсылка)) КАК ДокументУпр,
	|
	|	СтатьиРасходов.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов) КАК РегламентированныйУчет,
	|	СтатьиРасходов.ПравилоРаспределенияРасходовРегл КАК ПравилоРаспределенияРасходовРегл,
	|	ЕСТЬNULL(ДокументыРУ.Ссылка, ЗНАЧЕНИЕ(Документ.РаспределениеРасходовБудущихПериодов.ПустаяСсылка)) КАК ДокументРегл
	|
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РаспределениеРасходовБудущихПериодов КАК ДокументыУУ
	|	ПО
	|		ДокументыУУ.СтатьяРасходов = СтатьиРасходов.Ссылка
	|		И ДокументыУУ.Организация = &Организация
	|		И ДокументыУУ.Подразделение = &Подразделение
	|		И ДокументыУУ.АналитикаРасходов = &АналитикаРасходов
	|		И ДокументыУУ.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|		И ДокументыУУ.УправленческийУчет
	|		И ДокументыУУ.Проведен
	|		И ДокументыУУ.ВариантУказанияСуммыУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыУказанияСуммыРБП.ОпределяетсяАвтоматически)
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РаспределениеРасходовБудущихПериодов КАК ДокументыРУ
	|	ПО
	|		ДокументыРУ.СтатьяРасходов = СтатьиРасходов.Ссылка
	|		И ДокументыРУ.Организация = &Организация
	|		И ДокументыРУ.Подразделение = &Подразделение
	|		И ДокументыРУ.АналитикаРасходов = &АналитикаРасходов
	|		И ДокументыРУ.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|		И ДокументыРУ.РегламентированныйУчет
	|		И ДокументыРУ.Проведен
	|		И ДокументыРУ.ВариантУказанияСуммыРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыУказанияСуммыРБП.ОпределяетсяАвтоматически)
	|	
	|ГДЕ
	|	СтатьиРасходов.Ссылка = &СтатьяРасходов";
		

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Параметры.Период));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Параметры.Период));
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	Запрос.УстановитьПараметр("Подразделение", Параметры.Подразделение);
	Запрос.УстановитьПараметр("СтатьяРасходов", Параметры.СтатьяРасходов);
	Запрос.УстановитьПараметр("АналитикаРасходов", Параметры.АналитикаРасходов);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", Параметры.НаправлениеДеятельности);
	Выборка = Запрос.Выполнить().Выбрать();
	Если НЕ Выборка.Следующий() ИЛИ Выборка.Количество() > 1 Тогда
		Возврат Неопределено;
	Иначе
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СоздатьРаспределениеРасходовЗавершение(ПараметрыСоздания, ДополнительныеПараметры) Экспорт
	
	Если ПараметрыСоздания <> Неопределено Тогда
		СтруктураПараметры = Новый Структура;
		СтруктураПараметры.Вставить("Основание", ДополнительныеПараметры);
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ДополнительныеПараметры, ПараметрыСоздания);
		ОткрытьФорму("Документ.РаспределениеРасходовБудущихПериодов.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	
	// Упр
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Сумма");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Не требуется >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Сумма");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Требуется авто >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ТекстИнформационнойНадписи);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Сумма");
	ГруппаОтбораЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораЭлемента.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВсеРаспределеноСумма");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаУпр");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаУпрСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Не требуется >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаУпр");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаУпрСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Требуется авто >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ТекстИнформационнойНадписи);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаУпр");
	ГруппаОтбораЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораЭлемента.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВсеРаспределеноСуммаУпр");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаУпрСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
// Регл
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаРегл");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаРеглСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Не требуется >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаРегл");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаРеглСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Требуется авто >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ТекстИнформационнойНадписи);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаРегл");
	ГруппаОтбораЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораЭлемента.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВсеРаспределеноСуммаРегл");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаРеглСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
// НУ
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаНУ");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаНУСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Не требуется >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаНУ");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаНУСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Требуется авто >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ТекстИнформационнойНадписи);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаНУ");
	ГруппаОтбораЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораЭлемента.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВсеРаспределеноСуммаНУ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаНУСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
// НДД
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаНДД");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаНДДСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Не требуется >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаНДД");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаНДДСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Требуется авто >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ТекстИнформационнойНадписи);
	
	Элемент = РасходыКРаспределению.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СуммаНДД");
	ГруппаОтбораЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораЭлемента.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВсеРаспределеноСуммаНДД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаНДДСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветНедоступногоТекста);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеДинамическихСписков()
	
	ИспользоватьРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
	ЗаголовокГруппыРегл = 
		?(ИспользоватьРеглУчет, 
			НСтр("ru = 'К распределению в регл. учете'"),
			НСтр("ru = 'К распределению в бух. учете'")
		);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
		Элементы.РасходыКРаспределениюГруппаКРаспределениюРегл.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокГруппыРегл + " (%1)",
			ВалютаРегламентированногоУчета);
	Иначе
		Элементы.РасходыКРаспределениюГруппаКРаспределениюРегл.Заголовок = ЗаголовокГруппыРегл;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	ИспользоватьУчетПрочихДоходовРасходовРегл = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходовРегл");
	Элементы.РасходыКРаспределениюГруппаКРаспределениюРегл.Видимость = ИспользоватьУчетПрочихДоходовРасходовРегл;
	Элементы.РасходыКРаспределениюСуммаРегл.Видимость = ИспользоватьУчетПрочихДоходовРасходовРегл;
	
	ИспользоватьРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	Элементы.РасходыКРаспределениюСуммаРегл.ПоложениеЗаголовка = ?(ИспользоватьРеглУчет, ПоложениеЗаголовкаЭлементаФормы.Авто, ПоложениеЗаголовкаЭлементаФормы.Нет);
	Элементы.РасходыКРаспределениюСуммаНУ.Видимость = ИспользоватьРеглУчет;
	
	ВедетсяУчетПостоянныхИВременныхРазниц = Ложь;
	//++ Локализация


	//-- Локализация
	Элементы.РасходыКРаспределениюПостояннаяРазница.Видимость = ВедетсяУчетПостоянныхИВременныхРазниц И ОтображатьРазницы;
	Элементы.РасходыКРаспределениюВременнаяРазница.Видимость = ВедетсяУчетПостоянныхИВременныхРазниц И ОтображатьРазницы;
	
	ВедетсяУчетНДД = РасчетСебестоимостиЛокализация.ПолучитьФункциональнуюОпциюУчетПоНДД();
	Элементы.РасходыКРаспределениюСуммаНДД.Видимость = ВедетсяУчетНДД;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
