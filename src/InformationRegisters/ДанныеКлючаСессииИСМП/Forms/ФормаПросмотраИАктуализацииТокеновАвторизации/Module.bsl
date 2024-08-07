#Область ОписаниеПеременных

&НаКлиенте
Перем ТребуетсяАктуализация;

&НаКлиенте
Перем НапоминанияОтложены;

&НаКлиенте
Перем ПредупреждатьОЗакрытии;

&НаКлиенте
Перем ИдетЗакрытиеФормы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Актуализация") Тогда
		Актуализация = Параметры.Актуализация;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	НастроитьЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСрокиПовторногоНапоминания();
	СрокПовторногоОповещения = "10м";
	СрокПовторногоОповещения = ОформитьВремя(СрокПовторногоОповещения);
	
	ТребуетсяАктуализация  = Ложь;
	НапоминанияОтложены    = Ложь;
	ПредупреждатьОЗакрытии = Неопределено;
	ИдетЗакрытиеФормы      = Ложь;
	
	ИмяПараметраНастроек    = ИнтерфейсАвторизацииИСМПКлиент.ИмяПараметраНастроекОтветственногоЗаАктуализациюТокеновАвторизации();
	НастройкиОтветственного = ПараметрыПриложения[ИмяПараметраНастроек];
	Если Актуализация Тогда
		Если НастройкиОтветственного <> Неопределено Тогда
			Если Не НастройкиОтветственного.ОткрытаФормаАктуализации Тогда
				ПараметрыПриложения[ИмяПараметраНастроек].ОткрытаФормаАктуализации = Истина;
			КонецЕсли;
			ПараметрыПриложения[ИмяПараметраНастроек].ВремяСледующейПроверки = Дата(1,1,1)
		КонецЕсли;
		ТекущийЭлемент = Элементы.СрокПовторногоОповещения;
		ОчиститьНапоминанияТекущегоПользователя();
	Иначе
		Если НастройкиОтветственного <> Неопределено Тогда
			Если Не НастройкиОтветственного.ОткрытаФормаПросмотра Тогда
				ПараметрыПриложения[ИмяПараметраНастроек].ОткрытаФормаПросмотра = Истина;
			КонецЕсли;
			
			ИнтерфейсАвторизацииИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
			
			Если Не НастройкиОтветственного.ТребуетсяПроверкаНапоминаний Тогда
				ПодключитьОбработчикОжидания("ОбработчикОжиданияПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации", 60);
			КонецЕсли;
		КонецЕсли;
		ПодключитьОбработчикОжидания("ВыполнитьОбновлениеТаблицыТокенов", 60);
	КонецЕсли;
	
	ВыполнитьОбновлениеТаблицыТокенов();
	
	Если Актуализация
		И Не ТребуетсяАктуализация Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	Если Актуализация Тогда
		Если ИдетЗакрытиеФормы Тогда
			Возврат;
		КонецЕсли;
		ВыполнитьОбновлениеТаблицыТокенов();
		Активизировать();
		Если Не ТребуетсяАктуализация Тогда
			Если ПредупреждатьОЗакрытии = Неопределено Тогда
				ПредупреждатьОЗакрытии = Истина;
			КонецЕсли;
			ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.1, Истина);
		Иначе
			ПредупреждатьОЗакрытии = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Актуализация Тогда
		Если ТребуетсяАктуализация
			И Не НапоминанияОтложены Тогда
			ОтложитьНапоминания();
			НапоминанияОтложены = Истина;
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Напоминание отложено:'"),,
				СтрШаблон(
				НСтр("ru = 'Напоминание отложено на %1'"),
				СрокПовторногоОповещения),
				БиблиотекаКартинок.Информация32ГосИС);
		КонецЕсли;
		Если ПредупреждатьОЗакрытии = Истина Тогда
			Отказ                  = Истина;
			СтандартнаяОбработка   = Ложь;
			ПредупреждатьОЗакрытии = Ложь;
			ИдетЗакрытиеФормы      = Истина;
			ПоказатьПредупреждение(
				Новый ОписаниеОповещения("ПослеПредупрежденияОЗакрытии", ЭтотОбъект),
				НСтр("ru = 'На текущий момент, все необходимые токены авторизации актуализированы.'"),
				10,
				НСтр("ru = 'Актуализация токенов авторизации.'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПараметраНастроек    = ИнтерфейсАвторизацииИСМПКлиент.ИмяПараметраНастроекОтветственногоЗаАктуализациюТокеновАвторизации();
	
	НастройкиОтветственного = ПараметрыПриложения[ИмяПараметраНастроек];
	Если НастройкиОтветственного <> Неопределено Тогда
		Если Актуализация
			И НастройкиОтветственного.ОткрытаФормаАктуализации Тогда
			ПараметрыПриложения[ИмяПараметраНастроек].ОткрытаФормаАктуализации = Ложь;
		ИначеЕсли Не Актуализация
			И НастройкиОтветственного.ОткрытаФормаПросмотра Тогда
			ПараметрыПриложения[ИмяПараметраНастроек].ОткрытаФормаПросмотра = Ложь;
		КонецЕсли;
	КонецЕсли;
		
	Если Не Актуализация Тогда
		ОтключитьОбработчикОжидания("ВыполнитьОбновлениеТаблицыТокенов");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СрокПовторногоОповещенияПриИзменении(Элемент)
	
	СрокПовторногоОповещения = ОформитьВремя(СрокПовторногоОповещения);
	
	Если Лев(СрокПовторногоОповещения, 1) = "0" Тогда
		СрокПовторногоОповещения = "10м";
		СрокПовторногоОповещения = ОформитьВремя(СрокПовторногоОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТокены

&НаКлиенте
Процедура ТокеныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Актуализация Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Токены.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТипТокенаАвторизации",   ТекущиеДанные.ТипТокенаАвторизации);
	ПараметрыОткрытия.Вставить("Организация",            ТекущиеДанные.Организация);
	ПараметрыОткрытия.Вставить("ПроизводственныйОбъект", ТекущиеДанные.ПроизводственныйОбъект);
	ПараметрыОткрытия.Вставить("СозданиеТокена",         Ложь);
	
	ОткрытьФормуТокенаАвторизации(ПараметрыОткрытия)
	
КонецПроцедуры

&НаКлиенте
Процедура ТокеныПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Отказ = Истина;
	
	Если Актуализация Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СозданиеТокена", Истина);
	
	Если Копирование Тогда
		ТекущиеДанные = Элементы.Токены.ТекущиеДанные;
		ПараметрыОткрытия.Вставить("ТипТокенаАвторизации",   ТекущиеДанные.ТипТокенаАвторизации);
		ПараметрыОткрытия.Вставить("Организация",            ТекущиеДанные.Организация);
		ПараметрыОткрытия.Вставить("ПроизводственныйОбъект", ТекущиеДанные.ПроизводственныйОбъект);
	Иначе
		ПараметрыОткрытия.Вставить("ТипТокенаАвторизации",   Неопределено);
		ПараметрыОткрытия.Вставить("Организация",            Неопределено);
		ПараметрыОткрытия.Вставить("ПроизводственныйОбъект", Неопределено);
	КонецЕсли;
	
	ОткрытьФормуТокенаАвторизации(ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТокеныПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Токены.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ИмяПараметраСеанса",
		ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ИмяДанныхКлючаСессии(ТекущиеДанные.ТипТокенаАвторизации));
	ПараметрыЗапроса.Вставить("Организация",            ТекущиеДанные.Организация);
	ПараметрыЗапроса.Вставить("ПроизводственныйОбъект", ТекущиеДанные.ПроизводственныйОбъект);
	
	УдалитьТокен(ПараметрыЗапроса);
	
	ИнтерфейсАвторизацииИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
	
	Если Не Актуализация Тогда
		ВыполнитьОбновлениеТаблицыТокенов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьТаблицуТокенов(Команда)
		
	ИнтерфейсАвторизацииИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
	
	Если Не Актуализация Тогда
		ВыполнитьОбновлениеТаблицыТокенов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отложить(Команда)
	
	ОтложитьНапоминания();
	НапоминанияОтложены = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	ТокеныДляОбновления = Новый Массив;
	
	Если Актуализация Тогда
		Строки = Токены;
		ПолучатьДанныеСтроки = Ложь;
	Иначе
		Строки = Элементы.Токены.ВыделенныеСтроки;
		ПолучатьДанныеСтроки = Истина;
	КонецЕсли;
	
	ЕстьТокеныСУЗ = Ложь;
	
	Для Каждого Строка Из Строки Цикл
		Если ПолучатьДанныеСтроки Тогда
			Строка = Токены.НайтиПоИдентификатору(Строка);
		КонецЕсли;
		Если Строка.ТипТокенаАвторизации = ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.СУЗ") Тогда
			ЕстьТокеныСУЗ = Истина;
		КонецЕсли;
		ДанныеТокена = Новый Структура;
		ДанныеТокена.Вставить("ТипТокенаАвторизации",   Строка.ТипТокенаАвторизации);
		ДанныеТокена.Вставить("Организация",            Строка.Организация);
		ДанныеТокена.Вставить("ПроизводственныйОбъект", Строка.ПроизводственныйОбъект);
		ТокеныДляОбновления.Добавить(ДанныеТокена);
	КонецЦикла;
	
	Если ТокеныДляОбновления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЕстьТокеныСУЗ Тогда
		ДополнитьТокеныДляОбновленияДаннымиСУЗ(ТокеныДляОбновления);
	КонецЕсли;
	
	АктуализироватьТокены(ТокеныДляОбновления);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Токены.Имя);
	
	Если Актуализация Тогда
		ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТокеныТребуетсяАктуализация.ПутьКДанным);
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
	Иначе
		ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТокеныПросрочен.ПутьКДанным);
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
	КонецЕсли;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТокеныПроизводственныйОбъект.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТокеныПроизводственныйОбъект.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не используется>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыНаСервере()
	
	АвтоЗаголовок = Ложь;
	Если Актуализация Тогда
		Заголовок = НСтр("ru = 'Актуализация токенов авторизации'");
		Элементы.Актуализировать.Заголовок = НСтр("ru = 'Актуализировать все'");
	Иначе
		Заголовок = НСтр("ru = 'Токены авторизации'");
		Элементы.Актуализировать.Заголовок = НСтр("ru = 'Актуализировать'");
	КонецЕсли;
	
	Элементы.ГруппаЕще.Видимость         = Не Актуализация;
	Элементы.ГруппаНапоминание.Видимость = Актуализация;
	Элементы.Токены.ТолькоПросмотр       = Актуализация
		Или Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДанныеКлючаСессииИСМП);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСрокиПовторногоНапоминания()
	
	Для Каждого Элемент Из Элементы.СрокПовторногоОповещения.СписокВыбора Цикл
		Элемент.Представление = ОформитьВремя(Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбновлениеТаблицыТокенов()
	
	Если Элементы.Токены.ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Неопределено;
	Иначе
		ТекущиеДанные = Новый Структура("Организация,ПроизводственныйОбъект,ТипТокенаАвторизации");
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Элементы.Токены.ТекущиеДанные);
	КонецЕсли;
	
	Токены.Очистить();
	
	ТребуетсяАктуализация = Ложь;
		
		ИмяПараметраНастроек = ИнтерфейсАвторизацииИСМПКлиент.ИмяПараметраНастроекОтветственногоЗаАктуализациюТокеновАвторизации();
		
		НастройкиОтветственного = ПараметрыПриложения[ИмяПараметраНастроек];
		Если НастройкиОтветственного = Неопределено Тогда
			Если Актуализация Тогда
				Возврат;
			Иначе
				ИнтерфейсАвторизацииИСМПКлиент.ВыполнитьОбновлениеНастроекОтветственногоЗаАктуализациюТокеновАвторизации(Истина);
				
				НастройкиОтветственного = ПараметрыПриложения[ИмяПараметраНастроек];
				
				Если НастройкиОтветственного = Неопределено Тогда
					Возврат;
				КонецЕсли;
				
				Если Не НастройкиОтветственного.ОткрытаФормаПросмотра Тогда
					ПараметрыПриложения[ИмяПараметраНастроек].ОткрытаФормаПросмотра = Истина;
				КонецЕсли;
				
				ИнтерфейсАвторизацииИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
				
				Если Не НастройкиОтветственного.ТребуетсяПроверкаНапоминаний Тогда
					ПодключитьОбработчикОжидания("ОбработчикОжиданияПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации", 60);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		ИмяПараметраНапоминаний  = ИнтерфейсАвторизацииИСМПКлиент.ИмяПараметраНапоминанийОтветственногоЗаАктуализациюТокеновАвторизации();
		
		Напоминания = ПараметрыПриложения[ИмяПараметраНапоминаний];
		Если Напоминания = Неопределено Тогда
			Если Актуализация Тогда
				Возврат;
			Иначе
				ИнтерфейсАвторизацииИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
				Напоминания = ПараметрыПриложения[ИмяПараметраНапоминаний];
				Если Напоминания = Неопределено Тогда
					Возврат;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Для Каждого Напоминание Из Напоминания Цикл
			
			Если Актуализация Тогда
				Если Не Напоминание.ОповещениеИспользуется Тогда
					Продолжить;
				КонецЕсли;
				Если Не Напоминание.ТребуетсяАктуализация Тогда
					Если Напоминание.ОповещатьЗа < 3600 Тогда
						ДобавочноеВремя = 600;
					Иначе
						ДобавочноеВремя = 1800;
					КонецЕсли;
					Если Напоминание.ВремяДействия > Напоминание.ОповещатьЗа + ДобавочноеВремя Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли Напоминание.Отсутствует Тогда
				Продолжить;
			КонецЕсли;
			
			Строка = Токены.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, Напоминание);
			
			Если Строка.Отсутствует Тогда
				Строка.ВремяДействияСтрокой = НСтр("ru = '<не найден>'");
			ИначеЕсли Строка.Просрочен Тогда
				Строка.ВремяДействияСтрокой = НСтр("ru = '<просрочен>'");
			Иначе
				Строка.ВремяДействияСтрокой = ПредставлениеВремени(Строка.ВремяДействия);
			КонецЕсли;
			
			Если Строка.ТребуетсяАктуализация Тогда
				ТребуетсяАктуализация = Истина;
			КонецЕсли;
			
		КонецЦикла;
	
	Если ТекущиеДанные <> Неопределено Тогда
		НайденныеСтроки = Токены.НайтиСтроки(ТекущиеДанные);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Элементы.Токены.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	НастроитьОтображениеСпискаТокенов();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеСпискаТокенов()
	
	ЕстьТокеныСУЗ  = Ложь;
	ЕстьТокеныИСМП = Ложь;
	
	Для Каждого Строка Из Токены Цикл
		Если Строка.ТипТокенаАвторизации = ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.СУЗ") Тогда
			ЕстьТокеныСУЗ = Истина;
		Иначе
			ЕстьТокеныИСМП = Истина;
		КонецЕсли;
		Если ЕстьТокеныСУЗ И ЕстьТокеныИСМП Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ТокеныТипТокенаАвторизации.Видимость = ЕстьТокеныСУЗ И ЕстьТокеныИСМП;
	Элементы.ТокеныПроизводственныйОбъект.Видимость = ЕстьТокеныСУЗ;
	
КонецПроцедуры

&НаКлиенте
Функция ПредставлениеВремени(ВремяВСекундах)
	
	Результат = "";
	
	ПредставлениеДней  = НСтр("ru = ';%1 день;;%1 дня;%1 дней;%1 дня'");
	ПредставлениеЧасов = НСтр("ru = ';%1 час;;%1 часа;%1 часов;%1 часа'");
	ПредставлениеМинут = НСтр("ru = ';%1 минута;;%1 минуты;%1 минут;%1 минуты'");
	
	КоличествоДней  = Цел(ВремяВСекундах / 3600 / 24);
	КоличествоЧасов = Цел((ВремяВСекундах - КоличествоДней * 24 * 3600) / 3600);
	КоличествоМинут = Цел((ВремяВСекундах - КоличествоДней * 24 * 3600 - КоличествоЧасов * 3600) / 60);
	
	Если КоличествоДней > 0 Тогда
		Результат = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеДней, КоличествоДней);
	КонецЕсли;
	
	Если КоличествоЧасов > 0 Тогда
		Если Результат <> "" Тогда
			Результат = Результат + " ";
		КонецЕсли;
		Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеЧасов, КоличествоЧасов);
	КонецЕсли;
	
	Если КоличествоМинут > 0 Тогда
		Если Результат <> "" Тогда
			Результат = Результат + " ";
		КонецЕсли;
		Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеМинут, КоличествоМинут);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуТокенаАвторизации(ПараметрыОткрытия)
	
	ОткрытьФорму(
		"РегистрСведений.ДанныеКлючаСессииИСМП.Форма.ФормаТокенаАвторизации",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПослеИзмененияТокена", ЭтотОбъект));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьТокен(ПараметрыЗапроса)
	
	ПараметрыКлючаСессии = ИнтерфейсАвторизацииИСМПВызовСервера.ПараметрыКлючаСессии();
	ПараметрыКлючаСессии.КлючСессии  = "";
	ПараметрыКлючаСессии.ДействуетДо = Дата(1,1,1);
	
	ИнтерфейсАвторизацииИСМПВызовСервера.УстановитьКлючСессии(ПараметрыЗапроса, ПараметрыКлючаСессии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьНапоминания()
	
	ВремяВСекундах = ПолучитьИнтервалВремениИзСтроки(СрокПовторногоОповещения);
	Если ВремяВСекундах = 0 Тогда
		ВремяВСекундах = 10*60;
	КонецЕсли;
	
	ОтложитьНапоминанияТекущегоПользователя(ВремяВСекундах);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОчиститьНапоминанияТекущегоПользователя()
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("РегистрСведений.НапоминанияПользователяИСМП");
	МенеджерОбъекта.ОчиститьНапоминанияТекущегоПользователя();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтложитьНапоминанияТекущегоПользователя(ВремяВСекундах)
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("РегистрСведений.НапоминанияПользователяИСМП");
	МенеджерОбъекта.ОтложитьНапоминанияТекущегоПользователя(ВремяВСекундах);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДополнитьТокеныДляОбновленияДаннымиСУЗ(ТокеныДляОбновления)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Индекс",                 ОбщегоНазначения.ОписаниеТипаЧисло(5));
	Таблица.Колонки.Добавить("Организация",            Метаданные.ОпределяемыеТипы.Организация.Тип);
	Таблица.Колонки.Добавить("ПроизводственныйОбъект", Метаданные.ОпределяемыеТипы.ПроизводственныйОбъектИС.Тип);
	
	Для Индекс = 0 По ТокеныДляОбновления.ВГраница() Цикл
		ДанныеТокена = ТокеныДляОбновления[Индекс];
		Если ДанныеТокена.ТипТокенаАвторизации = Перечисления.ТипыТокеновАвторизации.СУЗ Тогда
			Строка = Таблица.Добавить();
			Строка.Индекс                 = Индекс;
			Строка.Организация            = ДанныеТокена.Организация;
			Строка.ПроизводственныйОбъект = ДанныеТокена.ПроизводственныйОбъект;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Индекс,
	|	Таблица.Организация,
	|	Таблица.ПроизводственныйОбъект
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Индекс,
	|	МАКСИМУМ(НастройкиОбменаСУЗ.ИдентификаторСоединения) КАК ИдентификаторСоединения
	|ИЗ
	|	Таблица КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаСУЗ КАК НастройкиОбменаСУЗ
	|		ПО Таблица.Организация = НастройкиОбменаСУЗ.Организация
	|		И Таблица.ПроизводственныйОбъект = НастройкиОбменаСУЗ.ПроизводственныйОбъект
	|		И НастройкиОбменаСУЗ.ИдентификаторСоединения <> """"
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Индекс";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТокеныДляОбновления[Выборка.Индекс].Вставить("ИдентификаторСоединения", Выборка.ИдентификаторСоединения);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьТокены(ТокеныДляОбновления)
	
	Если ТокеныДляОбновления.Количество() = 0 Тогда
		
		Если Актуализация Тогда
			ПредупреждатьОЗакрытии = Ложь;
		КонецЕсли;
		
		ИнтерфейсАвторизацииИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
		
		Если Не Актуализация Тогда
			ВыполнитьОбновлениеТаблицыТокенов();
		КонецЕсли;
		
	Иначе
		
		ДанныеТокена = ТокеныДляОбновления[0];
		ТокеныДляОбновления.Удалить(0);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТокеныДляОбновления", ТокеныДляОбновления);
		
		Если ДанныеТокена.ТипТокенаАвторизации = ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.СУЗ") Тогда
			ПараметрыЗапросаКлючаСессии = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ПараметрыЗапросаКлючаСессииСУЗ(ДанныеТокена);
		ИначеЕсли ДанныеТокена.ТипТокенаАвторизации = ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.ИСМПРозница") Тогда
			ПараметрыЗапросаКлючаСессии = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ПараметрыЗапросаКлючаСессииИСМПРозница(ДанныеТокена.Организация);
		Иначе
			ПараметрыЗапросаКлючаСессии = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ПараметрыЗапросаКлючаСессии(ДанныеТокена.Организация);
		КонецЕсли;
		
		ИнтерфейсАвторизацииИСМПКлиент.ЗапроситьКлючСессии(
			ПараметрыЗапросаКлючаСессии,
			Новый ОписаниеОповещения("ПослеПолученияКлючаСессии", ЭтотОбъект, ДополнительныеПараметры));
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияКлючаСессии(РезультатПолученияКлючейСессийПоОрганизациям, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатПолученияКлючейСессийПоОрганизациям = Неопределено Тогда
	
		Для Каждого РезультатПолученияКлючей Из РезультатПолученияКлючейСессийПоОрганизациям Цикл
			
			Если ТипЗнч(РезультатПолученияКлючей.Значение) = Тип("Строка") И ЗначениеЗаполнено(РезультатПолученияКлючей.Значение) Тогда
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатПолученияКлючей.Значение);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	АктуализироватьТокены(ДополнительныеПараметры.ТокеныДляОбновления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияТокена(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Актуализация Тогда
		ПредупреждатьОЗакрытии = Ложь;
	КонецЕсли;
		
	ИнтерфейсАвторизацииИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
	
	Если Не Актуализация Тогда
		ВыполнитьОбновлениеТаблицыТокенов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПредупрежденияОЗакрытии(ДополнительныеПараметры) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

#Область ОбщийМодуль_НапоминанияПользователяКлиент

&НаКлиенте
Функция ОформитьВремя(ВремяСтрокой)
	Возврат ПредставлениеВремени(ПолучитьИнтервалВремениИзСтроки(ВремяСтрокой));
КонецФункции

&НаКлиенте
Функция ПолучитьИнтервалВремениИзСтроки(Знач СтрокаСоВременем)
	
	Если ПустаяСтрока(СтрокаСоВременем) Тогда
		Возврат 0;
	КонецЕсли;
	
	СтрокаСоВременем = НРег(СтрокаСоВременем);
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, Символы.НПП," ");
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, ".",",");
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, "+","");
	
	ПодстрокаСЦифрами = "";
	ПодстрокаСБуквами = "";
	
	ПредыдущийСимволЭтоЦифра = Ложь;
	ЕстьДробнаяЧасть = Ложь;
	
	Результат = 0;
	Для Позиция = 1 По СтрДлина(СтрокаСоВременем) Цикл
		ТекущийКодСимвола = КодСимвола(СтрокаСоВременем,Позиция);
		Символ = Сред(СтрокаСоВременем,Позиция,1);
		Если (ТекущийКодСимвола >= КодСимвола("0") И ТекущийКодСимвола <= КодСимвола("9"))
			ИЛИ (Символ="," И ПредыдущийСимволЭтоЦифра И Не ЕстьДробнаяЧасть) Тогда
			Если Не ПустаяСтрока(ПодстрокаСБуквами) Тогда
				ПодстрокаСЦифрами = СтрЗаменить(ПодстрокаСЦифрами,",",".");
				Результат = Результат + ?(ПустаяСтрока(ПодстрокаСЦифрами), 1, Число(ПодстрокаСЦифрами))
					* ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами);
					
				ПодстрокаСЦифрами = "";
				ПодстрокаСБуквами = "";
				
				ПредыдущийСимволЭтоЦифра = Ложь;
				ЕстьДробнаяЧасть = Ложь;
			КонецЕсли;
			
			ПодстрокаСЦифрами = ПодстрокаСЦифрами + Сред(СтрокаСоВременем,Позиция,1);
			
			ПредыдущийСимволЭтоЦифра = Истина;
			Если Символ = "," Тогда
				ЕстьДробнаяЧасть = Истина;
			КонецЕсли;
		Иначе
			Если Символ = " " И ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами) = "0" Тогда
				ПодстрокаСБуквами = "";
			КонецЕсли;
			
			ПодстрокаСБуквами = ПодстрокаСБуквами + Сред(СтрокаСоВременем,Позиция,1);
			ПредыдущийСимволЭтоЦифра = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПустаяСтрока(ПодстрокаСБуквами) Тогда
		ПодстрокаСЦифрами = СтрЗаменить(ПодстрокаСЦифрами,",",".");
		Результат = Результат + ?(ПустаяСтрока(ПодстрокаСЦифрами), 1, Число(ПодстрокаСЦифрами))
			* ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ЗаменитьЕдиницуИзмеренияНаМножитель(Знач Единица)
	
	Результат = 0;
	Единица = НРег(Единица);
	
	ДопустимыеСимволы = НСтр("ru = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'"); // АПК:163; АПК:1036 (см. 456:1.1) символы, которые может вводить пользователь.
	ПосторонниеСимволы = СтрСоединить(СтрРазделить(Единица, ДопустимыеСимволы, Ложь), "");
	Если ПосторонниеСимволы <> "" Тогда
		Единица = СтрСоединить(СтрРазделить(Единица, ПосторонниеСимволы, Ложь), "");
	КонецЕсли;
	
	СловоформыНедели = СтрРазделить(НСтр("ru = 'нед,н'"), ",", Ложь);
	СловоформыДня = СтрРазделить(НСтр("ru = 'ден,дне,дня,дн,д'"), ",", Ложь);
	СловоформыЧаса = СтрРазделить(НСтр("ru = 'час,ч'"), ",", Ложь);
	СловоформыМинуты = СтрРазделить(НСтр("ru = 'мин,м'"), ",", Ложь);
	СловоформыСекунды = СтрРазделить(НСтр("ru = 'сек,с'"), ",", Ложь);
	
	ПервыеТриСимвола = Лев(Единица,3);
	Если СловоформыНедели.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60*60*24*7;
	ИначеЕсли СловоформыДня.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60*60*24;
	ИначеЕсли СловоформыЧаса.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60*60;
	ИначеЕсли СловоформыМинуты.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60;
	ИначеЕсли СловоформыСекунды.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 1;
	КонецЕсли;
	
	Возврат Формат(Результат,"ЧН=0; ЧГ=0");
	
КонецФункции

#КонецОбласти

#КонецОбласти