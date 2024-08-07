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
	
	Элементы.ПараметрыПодключенияВЕТИС.Видимость      = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.НастройкиПодключенияВЕТИС);
	Элементы.ПользователиВЕТИС.Видимость              = ПравоДоступа("Чтение", Метаданные.Справочники.ПользователиВЕТИС);
	Элементы.ПраваДоступаПользователейВЕТИС.Видимость = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПраваДоступаПользователейВЕТИС);
	
	Элементы.ОтключитьОчередьПередачиЗаписейСкладскогоЖурналаВЕТИС.Видимость
		= ПравоДоступа("Чтение", Метаданные.Константы.ОтключитьОчередьПередачиЗаписейСкладскогоЖурналаВЕТИС);
		
	Элементы.ДатаЗапретаИспользованияПродукцииТретьегоУровняВЕТИС.Видимость
		= ПравоДоступа("Чтение", Метаданные.Константы.ДатаЗапретаИспользованияПродукцииТретьегоУровняВЕТИС);
	
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
Процедура ИспользоватьСверткуРегистраСоответствиеНоменклатурыПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетПодконтрольныхТоваровВЕТИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимРаботыСТестовымКонтуромВЕТИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОчередьПередачиЗаписейСкладскогоЖурналаВЕТИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗапретаИспользованияПродукцииТретьегоУровняВЕТИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиРегламентныхЗаданийДляОбменаСВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийВЕТИС.Форма.ФормаНастроек");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСверткуРегистраСоответствияНоменклатурыВЕТИС(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеСверткиРегистраСоответствияВЕТИС", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеСверткиРегистраСоответствиеНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПодключенияКВЕТИС(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиПодключенияВЕТИС.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступаПользователейВЕТИС(Команда)
	
	ОткрытьФорму("РегистрСведений.ПраваДоступаПользователейВЕТИС.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.ПользователиВЕТИС.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыОптимизации(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияВЕТИС.Форма.ПараметрыОптимизации");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьРасписаниеСверткиРегистраСоответствияВЕТИС(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеСверткиРегистраСоответствиеНоменклатуры = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания(
		"СверткаРегистраСоответствиеНоменклатурыВЕТИС",
		РасписаниеСверткиРегистраСоответствиеНоменклатуры);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Истина И Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// СверткаРегистраСоответствиеНоменклатурыВЕТИС
	Если ИнтеграцияИС.СерииИспользуются() Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Метаданные", "СверткаРегистраСоответствиеНоменклатурыВЕТИС");
		ЗаданиеСверткиРегистраСоответствиеНоменклатурыВЕТИС = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
		
		РасписаниеСверткиРегистраСоответствиеНоменклатуры = ЗаданиеСверткиРегистраСоответствиеНоменклатурыВЕТИС.Расписание;
		
		Элементы.СверткаРегистраСоответствиеНоменклатурыВЕТИС.Доступность = ЗаданиеСверткиРегистраСоответствиеНоменклатурыВЕТИС.Использование;
		УстановитьТекстНадписиРегламентнойНастройки(
			ЗаданиеСверткиРегистраСоответствиеНоменклатурыВЕТИС,
			Элементы.СверткаРегистраСоответствиеНоменклатурыВЕТИС);
		
		Элементы.РегламентноеЗаданиеСверткаРегистраСоответствия.Видимость = Истина;
		
	Иначе
		
		Элементы.РегламентноеЗаданиеСверткаРегистраСоответствия.Видимость = Ложь;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстРасписания, РасписаниеАктивно;
	
	ОбщегоНазначенияИС.ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно);
	Элемент.Заголовок = ТекстРасписания;
	
КонецПроцедуры

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
		
		СобытияФормИСПереопределяемый.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(ЭтотОбъект, КонстантаИмя, КонстантаЗначение);
		
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьАвтоматическуюСверткуРегистраСоответствиеНоменклатурыВЕТИС" Тогда
		ИзменитьИспользованиеЗадания(
			"СверткаРегистраСоответствиеНоменклатурыВЕТИС",
			НаборКонстант.ИспользоватьАвтоматическуюСверткуРегистраСоответствиеНоменклатурыВЕТИС);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУчетПодконтрольныхТоваровВЕТИС" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ВестиУчетПодконтрольныхТоваровВЕТИС;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетПодконтрольныхТоваровВЕТИС, ЗначениеКонстанты);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.РежимРаботыСТестовымКонтуромВЕТИС" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.РежимРаботыСТестовымКонтуромВЕТИС;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.РежимРаботыСТестовымКонтуромВЕТИС, ЗначениеКонстанты);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ОтключитьОчередьПередачиЗаписейСкладскогоЖурналаВЕТИС" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ОтключитьОчередьПередачиЗаписейСкладскогоЖурналаВЕТИС;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ОтключитьОчередьПередачиЗаписейСкладскогоЖурналаВЕТИС, ЗначениеКонстанты);
		
	КонецЕсли;
	
	ВестиУчетПодконтрольныхТоваровВЕТИС = ПолучитьФункциональнуюОпцию("ВестиУчетПодконтрольныхТоваровВЕТИС");
	
	Элементы.НастройкиРегламентныхЗаданийДляОбменаСВЕТИС.Доступность            = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.ИспользоватьСверткуРегистраСоответствиеНоменклатуры.Доступность    = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.ОтключитьОчередьПередачиЗаписейСкладскогоЖурналаВЕТИС.Доступность  = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.ПараметрыПодключенияВЕТИС.Доступность                              = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.ПраваДоступаПользователейВЕТИС.Доступность                         = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.ПользователиВЕТИС.Доступность                                      = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.РежимРаботыСТестовымКонтуромВЕТИС.Доступность                      = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.ПараметрыОптимизации.Доступность                                   = ВестиУчетПодконтрольныхТоваровВЕТИС;
	Элементы.ДатаЗапретаИспользованияПродукцииТретьегоУровняВЕТИС.Доступность   = ВестиУчетПодконтрольныхТоваровВЕТИС;
	
	// В модели сервиса расписание настраивается в неразделенном режиме из панели управления очередью регламентных заданий.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.НастройкиРегламентныхЗаданий.Видимость = Ложь;
	Иначе
		УстановитьНастройкиЗаданий();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

