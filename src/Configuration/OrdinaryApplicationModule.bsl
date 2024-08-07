///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт; // для предотвращения повторной обработки события
Перем глПодключаемоеОборудованиеСобытиеОбработаноДанные Экспорт; // для предотвращения повторной обработки события
Перем глДоступныеТипыОборудования Экспорт;
//Конец РаботаСВнешнимОборудованием

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие из КлючИЗначение:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Пример инициализации:
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Пример использования:
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	//++ НЕ ГОСИС
	Если Лев(Источник, 17) = "MobileApplication" Тогда
		МобильныеПриложенияКлиент.ОбработатьВнешнееСобытиеОтМобильногоПриложения(Источник, Событие, Данные);
		Возврат;
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Если глПодключаемоеОборудованиеСобытиеОбработаноДанные <> Неопределено
		И глПодключаемоеОборудованиеСобытиеОбработаноДанные[Данные] <> Неопределено Тогда
		глПодключаемоеОборудованиеСобытиеОбработаноДанные.Удалить(Данные);
		Возврат;
	КонецЕсли;
	
	глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
	
	//РаботаСВнешнимОборудованием
	// Подготовить данные
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	// Передать на обработку данные
	Результат = Истина;
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'")
			+ Символы.ПС + ОписаниеОшибки);
	КонецЕсли;
	//Конец РаботаСВнешнимОборудованием
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора,
			Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора,
		Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

#КонецОбласти

Процедура ПриИзмененииДоступностиОсновногоСервера(НачалоСеансаОсновногоСервера)

КонецПроцедуры

#Область Инициализация

//++ НЕ ГОСИС
глНомерКонтейнераСбербанк     = 0;
глУстановленКаналСоСбербанком = Ложь;
//-- НЕ ГОСИС
глПодключаемоеОборудованиеСобытиеОбработано = Ложь;

#КонецОбласти