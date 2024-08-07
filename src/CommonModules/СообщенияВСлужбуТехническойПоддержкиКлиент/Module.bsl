///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сообщения в службу технической поддержки".
// ОбщийМодуль.СообщенияВСлужбуТехническойПоддержкиКлиент.
//
// Клиентские процедуры и функции отправки сообщений в 
// службу технической поддержки:
//  - подготовка вложений сообщений;
//  - отправка сообщений на Портал 1С:ИТС;
//  - переход на страницу отправки сообщений.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает страницу Портала 1С:ИТС для отправки сообщения в службу
// технической поддержки. В параметрах передаются данные заполнения,
// вложения и параметры выгрузки журнала регистрации.
//
// Параметры:
//  ДанныеСообщения - Структура - данные для формирования сообщения,
//                    См. СообщенияВСлужбуТехническойПоддержкиКлиентСервер.ДанныеСообщения;
//  Вложения - Массив Из Структура, Неопределено - файлы вложений.  Важно: допускаются только
//             текстовые вложения (*.txt, *.json, *.xml). Поля структуры элемента вложения:
//    *Представление - Строка - представление вложения. Например, "Вложение 1.txt";
//    *ВидДанных - Строка - определяет преобразование переданных данных.
//                Возможна передача одного из значений:
//                  - ИмяФайла - Строка - полное имя файла вложения;
//                  - Адрес - Строка - адрес во временном хранилище значения типа ДвоичныеДанные;
//                  - Текст - Строка - текст вложения;
//    *Данные - Строка - данные для формирования вложения;
//  ОтборЖурналаРегистрации - Структура, Неопределено - настройки выгрузки журнала регистрации:
//    *ДатаНачала    - Дата - начало периода журнала;
//    *ДатаОкончания - Дата - конец периода журнала;
//    *События       - Массив - список событий;
//    *Метаданные    - Массив, Неопределено - массив метаданных для отбора;
//    *Уровень       - Строка - уровень важности событий журнала регистрации. Возможные значения:
//       - "Ошибка" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Ошибка;
//       - "Предупреждение" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Предупреждение;
//       - "Информация" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Информация;
//       - "Примечание" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Примечание.
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - метод, в который должен быть
//                          передан результат отправки сообщения. В метод передается значение типа
//                          Структура - результат отправки сообщения:
//                            *КодОшибки - Строка - идентификатор ошибки при отправки:
//                                                   - <Пустая строка> - отправка выполнена успешно;
//                                                   - "НеверныйФорматЗапроса" - переданы некорректные параметры
//                                                      сообщения в техническую поддержку;
//                                                   - "НеизвестнаяОшибка" - при отправке сообщения возникли ошибки;
//                                                   - "НеизвестнаяОшибкаСервиса" - при отправке сообщения возникли
//                                                      проблемы с сервисом;
//                                                   - "ОтсутствуетОбязательныйПараметрЗапроса" - отсутствует
//                                                      обязательный параметр сообщения в техническую поддержку;
//                                                   - "ОшибкаФайловойСистемы" - ошибка файловой системы;
//                                                   - "ПревышенМаксимальныйРазмерВложения" - превышен максимальный
//                                                      размер вложения;
//                                                   - "ПревышенМаксимальныйРазмерЖурналаРегистрации" - превышен
//                                                      максимальный размер журнала регистрации;
//                                                   - "ПустойПараметрЗапроса" - не заполнен обязательный параметр
//                                                      сообщения в техническую поддержку;
//                            *СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке
//                                                 для пользователя;
//
Процедура ОтправитьСообщение(
		ДанныеСообщения,
		Вложения = Неопределено,
		ОтборЖурналаРегистрации = Неопределено,
		ОповещениеОЗавершении = Неопределено) Экспорт
	
	Результат = СообщенияВСлужбуТехническойПоддержкиКлиентСервер.РезультатПроверкиПараметровОтправки(
		ДанныеСообщения,
		Вложения,
		ОтборЖурналаРегистрации);
	
	Если ЗначениеЗаполнено(Результат.КодОшибки)
		И ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(
			ОповещениеОЗавершении,
			Результат);
		Возврат;
	КонецЕсли;
	
	Состояние(
		,
		,
		НСтр("ru = 'Подготовка сообщения в службу технической поддержки'"));
	
	ПодготовитьТехническуюИнформацию(ДанныеСообщения);
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("ДанныеСообщения",         ДанныеСообщения);
	ПараметрыСообщения.Вставить("Вложения",                Вложения);
	ПараметрыСообщения.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаРегистрации);
	ПараметрыСообщения.Вставить("ОповещениеОЗавершении",   ОповещениеОЗавершении);
	
	ПодготовитьВложенияКОтправке(ПараметрыСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет техническую информацию клиентской части.
//
// Параметры:
//  ДанныеСообщения - Структура - данные для формирования сообщения,
//                    См. СообщенияВСлужбуТехническойПоддержкиКлиентСервер.ДанныеСообщения.
//
Процедура ПодготовитьТехническуюИнформацию(ДанныеСообщения)
	
	ДанныеТехническойИнформации = ДанныеСообщения.ДанныеТехническойИнформации;
	СообщенияВСлужбуТехническойПоддержкиКлиентСервер.ЗаполнитьСистемнуюИнформацию(
		ДанныеТехническойИнформации.СистемнаяИнформацияКлиента);
	
КонецПроцедуры

// Отправляет вложения на сервер и вызывает метод подготовки сообщения.
//
// Параметры:
//  ПараметрыСообщения - Структура - данные для отправки сообщения.
//
Процедура ПодготовитьВложенияКОтправке(ПараметрыСообщения)
	
	ПомещаемыеФайлы = Новый Массив;
	Если ПараметрыСообщения.Вложения <> Неопределено Тогда
		Для Каждого Вложение Из ПараметрыСообщения.Вложения Цикл
			Если Вложение.ВидДанных = "ИмяФайла" Тогда
				ПередаваемыйФайл = Новый ОписаниеПередаваемогоФайла(Вложение.Данные);
				ПомещаемыеФайлы.Добавить(ПередаваемыйФайл);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ПомещаемыеФайлы.Количество() = 0 Тогда
		ПодготовитьВложенияКОтправкеЗавершение(
			Неопределено,
			ПараметрыСообщения);
	Иначе
		
		ПараметрыСообщения.Вставить("ПомещаемыеФайлы", ПомещаемыеФайлы);
		
		ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
		ПараметрыЗагрузки.Интерактивно = Ложь;
		
		ФайловаяСистемаКлиент.ЗагрузитьФайлы(
			Новый ОписаниеОповещения(
				"ПодготовитьВложенияКОтправкеЗавершение",
				ЭтотОбъект,
				ПараметрыСообщения),
			ПараметрыЗагрузки,
			ПомещаемыеФайлы);
		
	КонецЕсли;
	
КонецПроцедуры

// Помещает вложения во временное хранилище и вызывает метод подготовки сообщения.
//
// Параметры:
//  ФайлыВложений - Массив - файлы переданные на сервер;
//  ПараметрыСообщения - Структура - данные для отправки сообщения.
//
Процедура ПодготовитьВложенияКОтправкеЗавершение(
		ФайлыВложений,
		ПараметрыСообщения) Экспорт
	
	Если ФайлыВложений <> Неопределено Тогда
		Для каждого Вложение Из ПараметрыСообщения.Вложения Цикл
			Если Вложение.ВидДанных = "ИмяФайла" Тогда
				Для каждого Файл Из ФайлыВложений Цикл
					Если Файл.ПолноеИмя = Вложение.Данные Тогда
						// Замена вида данных на адрес во временном хранилище.
						Вложение.ВидДанных = "Адрес";
						Вложение.Данные = Файл.Хранение;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	РезультатОтправки = СообщенияВСлужбуТехническойПоддержкиВызовСервера.ПодготовитьСообщение(
		ПараметрыСообщения.ДанныеСообщения,
		ПараметрыСообщения.Вложения,
		ПараметрыСообщения.ОтборЖурналаРегистрации);
	
	// Очистка сеансовых данных после отправки сообщения.
	Если ФайлыВложений <> Неопределено Тогда
		Попытка
			Для Каждого Файл Из ФайлыВложений Цикл
				УдалитьИзВременногоХранилища(Файл.Хранение);
			КонецЦикла;
		Исключение
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				ИмяСобытияЖурналаРегистрации(),
				"Предупреждение",
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатОтправки.КодОшибки) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗаголовокОкна", НСтр("ru = 'Отправка сообщения в службу технической поддержки'"));
		
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницуСДополнительнымиПараметрами(
			РезультатОтправки.URLСтраницы,
			ПараметрыОткрытия);
		
		ПриЗавершенииОбработкиСообщения(
			ПараметрыСообщения,
			РезультатОтправки);
		
	Иначе
		
		Если ПараметрыСообщения.ОповещениеОЗавершении =  Неопределено Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ПараметрыСообщения", ПараметрыСообщения);
			ДополнительныеПараметры.Вставить("РезультатОтправки",  РезультатОтправки);
			
			ПоказатьПредупреждение(
				,
				РезультатОтправки.СообщениеОбОшибке);
			
		Иначе
			
			ПриЗавершенииОбработкиСообщения(
				ПараметрыСообщения,
				РезультатОтправки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииОбработкиСообщения(ПараметрыСообщения, РезультатОтправки)
	
	Если ПараметрыСообщения.ОповещениеОЗавершении <> Неопределено Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("КодОшибки",         "");
		Результат.Вставить("СообщениеОбОшибке", "");
		
		ЗаполнитьЗначенияСвойств(
			Результат,
			РезультатОтправки,
			"КодОшибки, СообщениеОбОшибке");
		
		ВыполнитьОбработкуОповещения(
			ПараметрыСообщения.ОповещениеОЗавершении,
			Результат);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя события для журнала регистрации
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Сообщения в службу технической поддержки'",
		ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти
