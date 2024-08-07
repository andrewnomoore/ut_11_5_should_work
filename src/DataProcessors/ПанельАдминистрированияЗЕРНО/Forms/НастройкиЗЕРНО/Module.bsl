#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанныеАдресаСервера();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВестиУчетЗернаИПродуктовПереработкиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимРаботыСТестовымКонтуромЗЕРНОПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияКилограммИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресСервераПриИзменении(Элемент)
	АдресСервераПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СертификатыДляПодписанияСообщений(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Подсистема", "ЗЕРНО");
	
	ОткрытьФорму("ОбщаяФорма.НастройкаСертификатовДляАвтоматическогоОбменаИС", ПараметрыОткрытияФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиРегламентныхЗаданийДляОбмена(Команда)
	
	ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийЗЕРНО.Форма.ФормаНастроек");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтветственныхЗаПодписаниеСообщений(Команда)
	
	ОткрытьФорму("Справочник.ОтветственныеЗаПодписаниеСообщенийЗЕРНО.Форма.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыОптимизации(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияЗЕРНО.Форма.ПараметрыОптимизации");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ИмяЭлемента = Метаданные.Константы.РежимРаботыСТестовымКонтуромЗЕРНО.Имя Тогда
		ЗаполнитьДанныеАдресаСервера();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если КонстантаИмя = Метаданные.Константы.ВестиУчетЗернаИПродуктовПереработкиЗЕРНО.Имя
			И КонстантаЗначение Тогда
			ПараметрыОптимизации = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
			Если Не ЗначениеЗаполнено(ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий) Тогда
				ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий = НачалоДня(ТекущаяДатаСеанса());
				ИнтеграцияЗЕРНОСлужебный.ЗаписатьПараметрыОптимизации(ПараметрыОптимизации);
			КонецЕсли;
		КонецЕсли;
		
		СобытияФормИСПереопределяемый.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(ЭтотОбъект, КонстантаИмя, КонстантаЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУчетЗернаИПродуктовПереработкиЗЕРНО" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ВестиУчетЗернаИПродуктовПереработкиЗЕРНО;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетЗернаИПродуктовПереработкиЗЕРНО, ЗначениеКонстанты);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.РежимРаботыСТестовымКонтуромЗЕРНО" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.РежимРаботыСТестовымКонтуромЗЕРНО;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.РежимРаботыСТестовымКонтуромЗЕРНО, ЗначениеКонстанты);
		
	КонецЕсли;
	
	ВестиУчетЗернаИПродуктовПереработкиЗЕРНО = ПолучитьФункциональнуюОпцию("ВестиУчетЗернаИПродуктовПереработкиЗЕРНО");
	
	Элементы.СертификатыДляПодписанияСообщений.Доступность     = ВестиУчетЗернаИПродуктовПереработкиЗЕРНО;
	Элементы.НастройкиРегламентныхЗаданийДляОбмена.Доступность = ВестиУчетЗернаИПродуктовПереработкиЗЕРНО;
	Элементы.РежимРаботыСТестовымКонтуромЗЕРНО.Доступность     = ВестиУчетЗернаИПродуктовПереработкиЗЕРНО;
	Элементы.ЕдиницаИзмеренияКилограммИС.Доступность           = ВестиУчетЗернаИПродуктовПереработкиЗЕРНО;
	Элементы.АдресСервера.Доступность                          = ВестиУчетЗернаИПродуктовПереработкиЗЕРНО;
	Элементы.ПараметрыОптимизации.Доступность                  = ВестиУчетЗернаИПродуктовПереработкиЗЕРНО;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.СертификатыДляПодписанияСообщений.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеАдресаСервера()
	
	ПараметрыОптимизации            = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
	ПараметрыОптимизацииПоУмолчанию = ИнтеграцияЗЕРНО.ПараметрыОптимизацииПоУмолчанию();
	
	Элементы.АдресСервера.СписокВыбора.Очистить();
	Если НаборКонстант.РежимРаботыСТестовымКонтуромЗЕРНО Тогда
		АдресСервера = ПараметрыОптимизации.АдресСервераТестовыйКонтур;
		Элементы.АдресСервера.СписокВыбора.Добавить(ПараметрыОптимизацииПоУмолчанию.АдресСервераТестовыйКонтур);
		Если Элементы.АдресСервера.СписокВыбора.НайтиПоЗначению(ПараметрыОптимизации.АдресСервераТестовыйКонтур) = Неопределено Тогда
			Элементы.АдресСервера.СписокВыбора.Добавить(ПараметрыОптимизации.АдресСервераТестовыйКонтур);
		КонецЕсли;
	Иначе
		АдресСервера = ПараметрыОптимизации.АдресСервера;
		Элементы.АдресСервера.СписокВыбора.Добавить(ПараметрыОптимизацииПоУмолчанию.АдресСервера);
		Если Элементы.АдресСервера.СписокВыбора.НайтиПоЗначению(ПараметрыОптимизации.АдресСервера) = Неопределено Тогда
			Элементы.АдресСервера.СписокВыбора.Добавить(ПараметрыОптимизации.АдресСервера);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АдресСервераПриИзмененииНаСервере()
	
	ПараметрыОптимизации = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
	Если НаборКонстант.РежимРаботыСТестовымКонтуромЗЕРНО Тогда
		ПараметрыОптимизации.АдресСервераТестовыйКонтур = АдресСервера;
	Иначе
		ПараметрыОптимизации.АдресСервера = АдресСервера;
	КонецЕсли;

	ИнтеграцияЗЕРНОСлужебный.ЗаписатьПараметрыОптимизации(ПараметрыОптимизации);
	
КонецПроцедуры

#КонецОбласти