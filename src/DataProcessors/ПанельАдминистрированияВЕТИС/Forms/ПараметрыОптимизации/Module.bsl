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
	
	ПараметрыОптимизации = ИнтеграцияВЕТИС.ПараметрыОптимизации();
	
	ВремяОжиданияОбработкиЗаявки                     = ПараметрыОптимизации.ВремяОжиданияОбработкиЗаявки;
	КоличествоПовторныхЗапросов                      = ПараметрыОптимизации.КоличествоПовторныхЗапросов;
	КоличествоПопытокВосстановленияДокументов        = ПараметрыОптимизации.КоличествоПопытокВосстановленияДокументов;
	КоличествоЭлементов                              = ПараметрыОптимизации.КоличествоЭлементов;
	ИнтервалМеждуЗапросамиСписков                    = ПараметрыОптимизации.ИнтервалМеждуЗапросамиСписков;
	ОтправлятьЗависшиеЗапросыПовторно                = ПараметрыОптимизации.ОтправлятьЗависшиеЗапросыПовторно;
	ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала     = ПараметрыОптимизации.ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала;
	ВыполнятьСинхронизацииТолькоВРегламентномЗадании = ПараметрыОптимизации.ВыполнятьСинхронизацииТолькоВРегламентномЗадании;
	ИнтервалЗапросаИзмененныхДанных                  = ПараметрыОптимизации.ИнтервалЗапросаИзмененныхДанных;
	ЗагружатьДокументыСозданныеЧерезWeb              = ПараметрыОптимизации.ЗагружатьДокументыСозданныеЧерезWeb;
	
	ДополнитьСписокВыбора("ИнтервалЗапросаИзмененныхДанных", Истина);
	ДополнитьСписокВыбора("ИнтервалМеждуЗапросамиСписков", Истина);
	ДополнитьСписокВыбора("ВремяОжиданияОбработкиЗаявки", Истина);
	ДополнитьСписокВыбора("КоличествоЭлементов");
	ДополнитьСписокВыбора("КоличествоПовторныхЗапросов");
	
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
Процедура ИнтервалЗапросаИзмененныхДанныхПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВремяОжиданияОбработкиЗаявкиПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьЗависшиеЗапросыПовторноПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуЗапросамиСписковПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПовторныхЗапросовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПопытокВосстановленияДокументовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗапрашиватьИзмененияЗаписейСкладскогоЖурналаПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьСинхронизацииТолькоВРегламентномЗаданииПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьДокументыСозданныеЧерезWebПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПовторныхЗапросовОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВремяОжиданияОбработкиЗаявкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуЗапросамиСписковОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалЗапросаИзмененныхДанныхОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииНастройкиКлиент(Элемент)
	
	Результат = ПриИзмененииНастройкиСервер(Элемент.Имя);
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииНастройкиСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	НачатьТранзакцию();
	Попытка
		
		Если ИмяЭлемента = "КоличествоЭлементов" Тогда
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СинхронизацияКлассификаторовВЕТИС");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
		
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	СинхронизацияКлассификаторовВЕТИС.ТипВЕТИС             КАК ТипВЕТИС,
			|	СинхронизацияКлассификаторовВЕТИС.ХозяйствующийСубъект КАК ХозяйствующийСубъект,
			|	СинхронизацияКлассификаторовВЕТИС.Предприятие          КАК Предприятие,
			|	СинхронизацияКлассификаторовВЕТИС.ДатаСинхронизации    КАК ДатаСинхронизации,
			|	СинхронизацияКлассификаторовВЕТИС.Смещение             КАК Смещение
			|ИЗ
			|	РегистрСведений.СинхронизацияКлассификаторовВЕТИС КАК СинхронизацияКлассификаторовВЕТИС
			|ГДЕ
			|	СинхронизацияКлассификаторовВЕТИС.ТипВЕТИС В (
			|		ЗНАЧЕНИЕ(Перечисление.ТипыВЕТИС.ВетеринарноСопроводительныеДокументы),
			|		ЗНАЧЕНИЕ(Перечисление.ТипыВЕТИС.ЗаписиСкладскогоЖурнала))
			|	И СинхронизацияКлассификаторовВЕТИС.Смещение > 0");
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				
				НаборЗаписей = РегистрыСведений.СинхронизацияКлассификаторовВЕТИС.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ТипВЕТИС.Установить(Выборка.ТипВЕТИС);
				НаборЗаписей.Отбор.ХозяйствующийСубъект.Установить(Выборка.ХозяйствующийСубъект);
				НаборЗаписей.Отбор.Предприятие.Установить(Выборка.Предприятие);
				
				ЗаписьНабора = НаборЗаписей.Добавить();
				ЗаписьНабора.ТипВЕТИС             = Выборка.ТипВЕТИС;
				ЗаписьНабора.ДатаСинхронизации    = Выборка.ДатаСинхронизации;
				ЗаписьНабора.Смещение             = 0;
				ЗаписьНабора.ХозяйствующийСубъект = Выборка.ХозяйствующийСубъект;
				ЗаписьНабора.Предприятие          = Выборка.Предприятие;
				
				НаборЗаписей.Записать();
				
			КонецЦикла;
		
		ИначеЕсли ИмяЭлемента = "ИнтервалЗапросаИзмененныхДанных" Тогда
			
			Если Константы.ИнтервалЗапросаИзмененныхДанныхВЕТИС.Получить() <> ИнтервалЗапросаИзмененныхДанных Тогда
				Константы.ИнтервалЗапросаИзмененныхДанныхВЕТИС.Установить(ИнтервалЗапросаИзмененныхДанных);
			КонецЕсли;
			
		КонецЕсли;
		
		ПараметрыОптимизации = ИнтеграцияВЕТИС.ПараметрыОптимизации();
		ПараметрыОптимизации.ВремяОжиданияОбработкиЗаявки                     = ВремяОжиданияОбработкиЗаявки;
		ПараметрыОптимизации.ИнтервалМеждуЗапросамиСписков                    = ИнтервалМеждуЗапросамиСписков;
		ПараметрыОптимизации.КоличествоПовторныхЗапросов                      = КоличествоПовторныхЗапросов;
		ПараметрыОптимизации.КоличествоПопытокВосстановленияДокументов        = КоличествоПопытокВосстановленияДокументов;
		ПараметрыОптимизации.КоличествоЭлементов                              = КоличествоЭлементов;
		ПараметрыОптимизации.ОтправлятьЗависшиеЗапросыПовторно                = ОтправлятьЗависшиеЗапросыПовторно;
		ПараметрыОптимизации.ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала     = ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала;
		ПараметрыОптимизации.ВыполнятьСинхронизацииТолькоВРегламентномЗадании = ВыполнятьСинхронизацииТолькоВРегламентномЗадании;
		ПараметрыОптимизации.ИнтервалЗапросаИзмененныхДанных                  = ИнтервалЗапросаИзмененныхДанных;
		ПараметрыОптимизации.ЗагружатьДокументыСозданныеЧерезWeb              = ЗагружатьДокументыСозданныеЧерезWeb;
		
		Константы.НастройкиОбменаВЕТИС.Установить(Новый ХранилищеЗначения(ПараметрыОптимизации));
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнфрмацияОшибки = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнфрмацияОшибки));
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ПраваНаРедактирование = ПраваНаРедактированиеЭлементовФормы();
	
	Для Каждого ЭлементФормы Из Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
			
			МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементФормы.ПутьКДанным, ".");
			ИмяРеквизитаФормы = МассивПодстрок[МассивПодстрок.ВГраница()];
			ПравоТолькоПросмотр = Не ПраваНаРедактирование.Получить(ИмяРеквизитаФормы);
			ЭлементФормы.ТолькоПросмотр = ПравоТолькоПросмотр; 
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПраваНаРедактированиеЭлементовФормы()
	
	Соответствие = Новый Соответствие;
	
	НастройкиОбменаВЕТИС = ИнтеграцияВЕТИС.ПараметрыОптимизации();
	ПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.Константы.НастройкиОбменаВЕТИС);
	Для Каждого КлючЗначение Из НастройкиОбменаВЕТИС Цикл
		Соответствие.Вставить(КлючЗначение.Ключ, ПравоРедактирования);
	КонецЦикла;
	
	ПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.Константы.ИнтервалЗапросаИзмененныхДанныхВЕТИС);
	Соответствие.Вставить("ИнтервалЗапросаИзмененныхДанных", ПравоРедактирования);
	
	Возврат Соответствие;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьСписокВыбора(ИмяРеквизита, СформироватьПредставлениеДаты = Ложь)

	СписокВыбора = Элементы[ИмяРеквизита].СписокВыбора;
	Значение     = ЭтотОбъект[ИмяРеквизита];
	
	Если СписокВыбора.НайтиПоЗначению(Значение) <> Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПредставлениеЗначения = Строка(Значение);
	Если СформироватьПредставлениеДаты И Значение > 0 Тогда
		ПредставлениеЗначения = ПредставлениеВремени(Значение);
	КонецЕсли;
	
	СписокВыбора.Добавить(Значение, ПредставлениеЗначения);

КонецПроцедуры

&НаСервере
Функция ПредставлениеВремени(ОбщееКоличествоСекунд)
	
	ОбщаяДата = Дата(1, 1, 1) + ОбщееКоличествоСекунд;
	
	Дней   = ДеньГода(ОбщаяДата) - 1;
	Часов  = Час(ОбщаяДата);
	Минут  = Минута(ОбщаяДата);
	Секунд = Секунда(ОбщаяДата);
	
	Строки = Новый Массив;
	
	Если Дней > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 дн.'"), Дней));
	КонецЕсли;
	Если Часов > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 ч.'"), Часов));
	КонецЕсли;
	Если Минут > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 мин.'"), Минут));
	КонецЕсли;
	Если Секунд > 0 Или Строки.Количество() = 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 сек.'"), Секунд));
	КонецЕсли;
	
	Возврат СтрСоединить(Строки, " ");
	
КонецФункции

#КонецОбласти