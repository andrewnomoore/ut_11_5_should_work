///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Маг1С"
// ОбщийМодуль.Маг1ССервер
//
// Все серверные процедуры и функции для работы с mag1c
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выполняется только при старте сеанса
//
Процедура ВыполнитьДействияПриУстановкеПараметровСеанса(ИменаПараметровСеанса) Экспорт
	
	Если ИменаПараметровСеанса <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьУстановкуРасширенияИВзвестиКонстанту(Истина);
	
КонецПроцедуры

// Проверяет, что расширение для работы с mag1c уже установлено и включает (выключает), если
// это нужно константу ПоказыватьКомандуУстановитьРасширениеМаг1с. В разделенном режиме всегда 
// возвращает Истину.
//
// Возвращаемое значение:
// 	Булево - расширение уже установлено
//
Функция ПроверитьУстановкуРасширенияИВзвестиКонстанту(ЭтоЗапуск) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТекущийРежимЗапуска() = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УжеУстановлено = Метаданные.ОбщиеМодули.Найти("Маг1СИнтеграцияСлужебныйКлиент") <> Неопределено;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	Если Не УжеУстановлено
		И Не РазделениеВключено Тогда
		
		Попытка
			Расширения = РасширенияКонфигурации.Получить(Новый Структура("Имя", Маг1СКлиентСерверПереопределяемый.ИдентификаторРасширения()));
			БылоРаширение = Ложь;
			Для Каждого Расширение Из Расширения Цикл
				Расширение.Удалить();
				БылоРаширение = Истина;
			КонецЦикла;
			
			Если БылоРаширение Тогда
				ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
				Если ДанныеАутентификации <> Неопределено Тогда
					УстановитьРасширение();
					УжеУстановлено = Истина;
				КонецЕсли;
			КонецЕсли;
			
		Исключение
			ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрацииОбновлениеРасширения(), 
				УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));				
		КонецПопытки;
	
	КонецЕсли;

	Если (РазделениеВключено 
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных())
		Или Не РазделениеВключено Тогда  

		Если УжеУстановлено = Константы.ПоказыватьКомандуУстановитьРасширениеМаг1с.Получить() Тогда
			Константы.ПоказыватьКомандуУстановитьРасширениеМаг1с.Установить(Не УжеУстановлено)	
		КонецЕсли;
		
	КонецЕсли;	

	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат УжеУстановлено;
	
КонецФункции

// Скачивает и устанавливает расширение для работы с сервисом mag1c
// 
// Возвращаемое значение:
// 	Булево - расширение установлено 
//
Функция УстановитьРасширение() Экспорт
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Истина;
	КонецЕсли;
		
	ТокенАвторизацииМенеджераВитрин = ПолучитьТокенАвторизацииМенеджераВитрин();
	
	ДанныеРасширения = ПолучитьОбновлениеРасширения(ТокенАвторизацииМенеджераВитрин);
	
	Если ДанныеРасширения = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	// АПК:554-выкл расширение получено безопасным способом.
	ТекущееРасширение = РасширенияКонфигурации.Создать();
	// АПК:554-вкл
	ТекущееРасширение.БезопасныйРежим         = Ложь;
	ТекущееРасширение.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
	Попытка
		ТекущееРасширение.Записать(ДанныеРасширения);
		Константы.ПоказыватьКомандуУстановитьРасширениеМаг1с.Установить(Ложь);
		Возврат Истина;
	Исключение
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрацииОбновлениеРасширения(), 
			УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// Выполняется только при старте сеанса
//
Процедура ПередЗапускомПрограммы() Экспорт
	
	Если ТекущийРежимЗапуска() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьУстановкуРасширенияИВзвестиКонстанту(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяСобытияЖурналаРегистрацииОбновлениеРасширения()
	
	Возврат НСтр("ru = 'Маг1С: Установка расширения'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ПолучитьОбновлениеРасширения(ТокенАвторизации)
	Результат = Неопределено;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервисаМенеджераВитрин());
	
	Соединение = НовоеHTTPСоединение(СтруктураURI);
	
	АдресРесурса = "/api/v2/update";
	
	Запрос = НовыйHTTPЗапрос(СтруктураURI, АдресРесурса, ОписаниеКонфигурации(), ТокенАвторизации);

	Ответ = Соединение.Получить(Запрос);
	Результат = Неопределено;
	
	Если Ответ.КодСостояния = 200 Тогда       
		Результат = Ответ.ПолучитьТелоКакДвоичныеДанные();
	ИначеЕсли Ответ.КодСостояния >= 400 Тогда
		ВызватьИсключение ОписаниеОшибкиСервиса(
			СтруктураURI.ИмяСервера,
			"GET",
			АдресРесурса,
			Ответ.КодСостояния,
			Ответ.ПолучитьТелоКакСтроку());
	ИначеЕсли Ответ.КодСостояния <> 204 Тогда
		ВызватьИсключение ОписаниеОшибкиСервиса(
			СтруктураURI.ИмяСервера,
			"GET",
			АдресРесурса,
			Ответ.КодСостояния);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьТокенАвторизацииМенеджераВитрин()
	
	Результат = Неопределено;
	
	АдресРесурса = АдресСервисаМенеджераВитрин();
	
	СведенияАутентификации = СведенияАутентификацииКлиентаВСервисеМенеджераВитрин();
			
	Если СведенияАутентификации <> Неопределено Тогда
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресРесурса);
		
		Результат = ПолучитьТокенАвторизацииВСервисе(
			СтрШаблон("%1://%2", СтруктураАдреса.Схема, СтруктураАдреса.ИмяСервера),
			СведенияАутентификации);
			
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьТокенАвторизацииВСервисе(URIСервиса, СведенияАутентификации)
	
	Результат = Неопределено;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URIСервиса);
	
	Соединение = НовоеHTTPСоединение(
		СтруктураURI,
		,
		СведенияАутентификации.Идентификатор,
		СведенияАутентификации.СекретныйКлюч);
	
	АдресРесурса = "/auth/oidc/token";
	
	Запрос = НовыйHTTPЗапрос(СтруктураURI, АдресРесурса, Неопределено, Неопределено);
	
	Запрос.Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	
	Запрос.УстановитьТелоИзСтроки("grant_type=client_credentials");
	
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		СтруктураОтвета = СтрокаJSONВСоответствие(Ответ.ПолучитьТелоКакСтроку());
		
		Результат = Новый Структура;
		Результат.Вставить("ТипТокена",           СтруктураОтвета["token_type"]);
		Результат.Вставить("ИдентификаторТокена", СтруктураОтвета["id_token"]);
	ИначеЕсли Ответ.КодСостояния >= 400 Тогда
		ВызватьИсключение ОписаниеОшибкиСервиса(
			СтруктураURI.ИмяСервера,
			"POST",
			АдресРесурса,
			Ответ.КодСостояния,
			Ответ.ПолучитьТелоКакСтроку());
	Иначе
		ВызватьИсключение ОписаниеОшибкиСервиса(
			СтруктураURI.ИмяСервера,
			"POST",
			АдресРесурса,
			Ответ.КодСостояния);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция АдресСервисаМенеджераВитрин()
	
	УстановитьПривилегированныйРежим(Истина);
	СистемныеНастройки = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища("Маг1С_.СистемныеНастройки");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если СистемныеНастройки = Неопределено
		Или Не ТипЗнч(СистемныеНастройки) = Тип("Структура")
		Или Не СистемныеНастройки.Свойство("АдресСервисаМенеджераВитрин")
		Или Не ЗначениеЗаполнено(СистемныеНастройки.АдресСервисаМенеджераВитрин) Тогда
		Возврат "https://service.mag1c.ru/applications/manager";
	Иначе
		Возврат СистемныеНастройки.АдресСервисаМенеджераВитрин;
	КонецЕсли;
	
КонецФункции

Функция СведенияАутентификацииКлиентаВСервисеМенеджераВитрин()
	
	Результат = Неопределено;
	
	ТелоЗапроса = Новый Структура("token,login,password", "", "", "");
	
	ТикетАутентификации = ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки(
			ИдентификаторСервисаМенеджераВитрин());
			
	Если ПустаяСтрока(ТикетАутентификации.КодОшибки) Тогда
		ТелоЗапроса.token = ТикетАутентификации.Тикет;
	ИначеЕсли ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение ТикетАутентификации.ИнформацияОбОшибке;
	Иначе
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		
		ТелоЗапроса.login    = ДанныеАутентификации.Логин;
		ТелоЗапроса.password = ДанныеАутентификации.Пароль;
	КонецЕсли;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервисаМенеджераВитрин());
	
	Соединение = НовоеHTTPСоединение(СтруктураURI);
	
	АдресРесурса = "/api/v1/auth";
	
	Запрос = НовыйHTTPЗапрос(СтруктураURI, АдресРесурса, ОписаниеКонфигурации(), Неопределено);
	
	Запрос.Заголовки.Вставить("Content-Type", "application/json");
	
	Запрос.УстановитьТелоИзСтроки(СтруктураВСтрокуJSON(ТелоЗапроса));
	
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		СтруктураОтвета = СтрокаJSONВСоответствие(Ответ.ПолучитьТелоКакСтроку());
		
		Результат = Новый Структура;
		Результат.Вставить("Идентификатор", СтруктураОтвета.Получить("client_id"));
		Результат.Вставить("СекретныйКлюч", СтруктураОтвета.Получить("client_secret"));
		Результат.Вставить("СрокДействия",  ТекущаяУниверсальнаяДата() + 24 * 60 * 60);
	ИначеЕсли Ответ.КодСостояния >= 400 Тогда
		ВызватьИсключение ОписаниеОшибкиСервиса(
			СтруктураURI.ИмяСервера,
			"POST",
			АдресРесурса,
			Ответ.КодСостояния,
			Ответ.ПолучитьТелоКакСтроку());
	Иначе
		ВызватьИсключение ОписаниеОшибкиСервиса(
			СтруктураURI.ИмяСервера,
			"POST",
			АдресРесурса,
			Ответ.КодСостояния);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НовоеHTTPСоединение(СтруктураURI, Таймаут = 20, ИмяПользователя = "", Пароль = "")
	
	Сервер   = СтруктураURI.Хост;
	Порт     = СтруктураURI.Порт;
	Протокол = СтруктураURI.Схема;
	
	ЗащищенноеСоединение = Неопределено;
	Если ВРег(Протокол) = "HTTPS" Тогда
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(,Новый СертификатыУдостоверяющихЦентровОС);
	КонецЕсли;
	
	Возврат Новый HTTPСоединение(
		Сервер,
		Порт,
		ИмяПользователя,
		Пароль,
		НовыйИнтернетПрокси(Протокол),
		Таймаут,
		ЗащищенноеСоединение);
	
КонецФункции

Функция НовыйHTTPЗапрос(СтруктураURI, АдресРесурса, ОписаниеКонфигурации, ТокенАвторизации)
	
	Если Не ПустаяСтрока(СтруктураURI.ПутьНаСервере) Тогда
		АдресРесурса = "/" + СтруктураURI.ПутьНаСервере + АдресРесурса;
	КонецЕсли;
	
	Запрос = Новый HTTPЗапрос(АдресРесурса);
	
	Если ТокенАвторизации <> Неопределено Тогда
		Запрос.Заголовки.Вставить("Authorization", ТокенАвторизации.ТипТокена + " " + ТокенАвторизации.ИдентификаторТокена);
	КонецЕсли;
	
	Если ОписаниеКонфигурации <> Неопределено Тогда
		ИмяКонфигурации = СтрЗаменить(СтрЗаменить(Base64Строка(ПолучитьДвоичныеДанныеИзСтроки(ОписаниеКонфигурации.ИмяКонфигурации)), Символы.ПС,""), Символы.ВК, "");
		
		Запрос.Заголовки.Вставить("X-User-Agent-Configuration-Name",    ИмяКонфигурации);
		Запрос.Заголовки.Вставить("X-User-Agent-Configuration-Version", ОписаниеКонфигурации.ВерсияКонфигурации);
		Запрос.Заголовки.Вставить("X-User-Agent-Wizard-Version",        ОписаниеКонфигурации.ВерсияРасширения);
		Запрос.Заголовки.Вставить("X-User-Agent-Infobase-Id",           ОписаниеКонфигурации.ИдентификаторИБ);
		Запрос.Заголовки.Вставить("X-User-Agent-Timezone",              ОписаниеКонфигурации.ЧасовойПоясСеанса);
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

Функция ОписаниеОшибкиСервиса(ИмяСервера, Метод, Ресурс, КодОтвета, Знач СообщениеОбОшибке = "")
	
	Если ПустаяСтрока(СообщениеОбОшибке) Тогда
		СообщениеОбОшибке = НСтр("ru = 'Неизвестная ошибка сервиса.'");
	КонецЕсли;
	
	Возврат СтрШаблон(
		"Сервер: %1
		|%2 %3 HTTP/1.1
		|HTTP/1.1 %4
		|
		|%5",
		ИмяСервера, Метод, Ресурс, XMLСтрока(КодОтвета), СообщениеОбОшибке);
	
КонецФункции

Функция НовыйИнтернетПрокси(Протокол)
	
	Возврат ПолучениеФайловИзИнтернета.ПолучитьПрокси(Протокол);
	
КонецФункции

Функция СтруктураВСтрокуJSON(Источник, ИмяФайла = "")
	
	Запись = Новый ЗаписьJSON;
	Если ПустаяСтрока(ИмяФайла) Тогда
		Запись.УстановитьСтроку();
	Иначе
		Запись.ОткрытьФайл(ИмяФайла, "UTF-8");
	КонецЕсли;
	
	ЗаписатьJSON(Запись, Источник);
	
	Возврат Запись.Закрыть();
	
КонецФункции

Функция СтрокаJSONВСоответствие(Источник)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Источник);
	
	Результат = ПрочитатьJSON(ЧтениеJSON, Истина);
	
	ЧтениеJSON.Закрыть();
	
	Возврат Результат;
	
КонецФункции

Функция ИдентификаторСервисаМенеджераВитрин()
	
	Возврат "1C-YOS";
	
КонецФункции

Функция ОписаниеКонфигурации()
	
	Результат = СтруктураОписанияКонфигурации();
	Результат.ИмяКонфигурации    = Метаданные.Имя;
	Результат.ВерсияКонфигурации = Метаданные.Версия;
	Результат.ВерсияРасширения   = "";
	Результат.ИдентификаторИБ    = СтандартныеПодсистемыСервер.ИдентификаторИнформационнойБазы();
	Результат.ЧасовойПоясСеанса  = ЧасовойПоясСеанса();
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураОписанияКонфигурации()
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяКонфигурации",    "");
	Результат.Вставить("ВерсияКонфигурации", "");
	Результат.Вставить("ВерсияРасширения",   "");
	Результат.Вставить("ИдентификаторИБ",    "");
	Результат.Вставить("ЧасовойПоясСеанса",  "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
