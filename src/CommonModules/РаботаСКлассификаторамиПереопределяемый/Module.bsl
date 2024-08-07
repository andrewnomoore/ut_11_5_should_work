///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.РаботаСКлассификаторами".
// ОбщийМодуль.РаботаСКлассификаторамиПереопределяемый.
//
// Серверные переопределяемые процедуры загрузки классификаторов:
//  - определение списка автоматический обновляемых классификаторов;
//  - определение алгоритмов обработки файлов классификаторов;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяется список и настройки классификаторов обновления которых необходимо
// загружать из сервиса классификаторов. Для получения идентификатора необходимо
// перевести наименование объекта метаданных, данные которого планируется обновлять,
// на английский язык. При переводе рекомендуется использовать профессиональные
// программы перевода текста, либо воспользоваться услугами переводчика, т.к. при
// обнаружении смысловых ошибок в идентификаторе потребуется заводить новый классификатор
// и изменять код конфигурации.
//
// Параметры:
//  Классификаторы  - Массив из Структура - содержит настройки загрузки классификаторов.
//                    Состав настроек см. функцию РаботаСКлассификаторами.ОписаниеКлассификатора.
//
// Пример:
//	Описатель = РаботаСКлассификаторами.ОписаниеКлассификатора();
//	Описатель.Наименование               = НСтр("ru = 'Ставки рефинансирования'");
//	Описатель.Идентификатор              = "CentralBankRefinancingRate";
//	Описатель.ОбновлятьАвтоматически     = Истина;
//	Описатель.ОбщиеДанные                = Истина;
//	Описатель.СохранятьФайлВКэш          = Ложь;
//	Описатель.ОбработкаРазделенныхДанных = Ложь;
//	Классификаторы.Добавить(Описатель);
//
//@skip-warning
Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт
	
	//++ НЕ ГОСИС
	
	
	ИнтеграцияИС.ПриДобавленииКлассификаторов(Классификаторы);
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределяются номер версии классификатора, который уже загружен в информационную базу.
// При начале использовании подсистемы "РаботаСКлассификаторами" или при подключении нового
// классификатора к сервису, неизвестно какой номер версии классификатора загружен в ИБ,
// поэтому при очередной итерации обновления данных из сервиса данные будут загружены повторно.
// Чтобы избежать повторной загрузки, необходимо указать задать начальный номер версии.
// Метод будет вызван при попытке загрузить версию классификатора, у которого установлена
// версия равная 0.
//
// Параметры:
//  Идентификатор        - Строка - идентификатор классификатора в сервисе классификаторов.
//                         Определяется в процедуре ПриДобавленииКлассификаторов.
//  НачальныйНомерВерсии - Число - номер версии загруженного классификатора.
//
// Пример:
//	Если Идентификатор = "CentralBankRefinancingRate" Тогда
//		НачальныйНомерВерсии = РегистрыСведений.СтавкиРефинансирования.НомерЗагруженнойВерсии();
//	КонецЕсли;
//
//@skip-warning
Процедура ПриОпределенииНачальногоНомераВерсииКлассификатора(Идентификатор, НачальныйНомерВерсии) Экспорт
	
	//++ НЕ ГОСИС
	
	ИнтеграцияИС.ПриОпределенииНачальногоНомераВерсииКлассификатора(Идентификатор, НачальныйНомерВерсии);
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределяются алгоритмы обработки файла загруженного
// из сервиса классификаторов. После обработки файла нельзя удалять
// временного хранилища, т.к. при необходимости он будет сохранен в
// кэше для последующего использования.
//
// Параметры:
//  Идентификатор           - Строка - идентификатор классификатора в сервисе классификаторов.
//                            Определяется в процедуре ПриДобавленииКлассификаторов.
//  Версия                  - Число - номер загруженной версии;
//  Адрес                   - Строка - адрес двоичных данных файла обновления во
//                            временном хранилище;
//  Обработан               - Булево - если Ложь, при обработке файла обновления были ошибки
//                            и его необходимо загрузить повторно;
//  ДополнительныеПараметры - Структура - содержит дополнительные параметры обработки.
//                            Необходимо использовать для передачи значений в переопределяемый
//                            метод РаботаСКлассификаторамиВМоделиСервисаПереопределяемый.ПриОбработкеОбластиДанных
//                            и метод ИнтеграцияПодсистемБИП.ПриОбработкеОбластиДанных..
// Пример:
//	Если Идентификатор = "CentralBankRefinancingRate" Тогда
//		Обработан = РегистрыСведений.СтавкиРефинансирования.ОбновитьДанныеРегистраИзФайла(Адрес, ДополнительныеПараметры);
//	КонецЕсли;
//
//@skip-warning
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	
	КалендарныеГрафики.ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры);
	
	
	ИнтеграцияИС.ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры);

	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределяются пользовательские настройки обновления классификаторов.
//
// Параметры:
//  Настройки - Структура:
//    * ОтключитьНапоминания - Булево - Истина, если необходимо отключить напоминание о включении
//        автоматической загрузки классификаторов в подсистеме БСП.ТекущиеДела и не показывать оповещение
//        пользователю при старте системы, если подсистема БСП.ТекущиеДела отсутствует в конфигурации.
//
//@skip-warning
Процедура ПриОпределенииНастроекПользователя(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти
