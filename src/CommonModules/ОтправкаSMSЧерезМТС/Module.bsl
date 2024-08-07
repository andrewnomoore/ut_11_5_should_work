///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Отправляет SMS через МТС.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ (строкой);
//  Текст             - Строка - текст сообщения, длиной не более 1000 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин             - Строка - логин пользователя услуги отправки sms;
//  Пароль            - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.ОтправитьSMS.
//
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Знач Пароль) Экспорт
	
	Получатели = Новый Массив;
	Для Каждого Элемент Из НомераПолучателей Цикл
		НомерПолучателя = ФорматироватьНомер(Элемент);
		Если Получатели.Найти(НомерПолучателя) = Неопределено Тогда
			Получатели.Добавить(НомерПолучателя);
		КонецЕсли;
	КонецЦикла;
	
	СпособАвторизации = СпособАвторизации();
	
	Если СпособАвторизации = СпособАвторизацииПоЛогинуИПаролюМаркетолог() Тогда
		Возврат ОтправитьSMSМаркетолог(Получатели, Текст, ИмяОтправителя, Логин, Пароль);
	КонецЕсли;
	
	Возврат ОтправитьSMSКоммуникатор(Получатели, Текст, ИмяОтправителя, Логин, Пароль);
	
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке.
//  НастройкиОтправкиSMS   - см. ОтправкаSMS.НастройкиОтправкиSMS.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.СтатусДоставки.
//
Функция СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS) Экспорт
	
	Если НастройкиОтправкиSMS.СпособАвторизации = СпособАвторизацииПоЛогинуИПаролюМаркетолог() Тогда
		Возврат СтатусДоставкиМаркетолог(ИдентификаторСообщения, НастройкиОтправкиSMS);
	КонецЕсли;
	
	Результат = "Ошибка";
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("messageID", ИдентификаторСообщения);
	ПараметрыЗапроса.Вставить("login", НастройкиОтправкиSMS.Логин);
	
	Если ЗначениеЗаполнено(НастройкиОтправкиSMS.Логин) Тогда
		ПараметрыЗапроса.Вставить("password", ОбщегоНазначения.КонтрольнаяСуммаСтрокой(НастройкиОтправкиSMS.Пароль));
	Иначе
		ПараметрыЗапроса.Вставить("password", "");
	КонецЕсли;
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос(АдресРесурсаКоммуникатор() + "GetMessageStatus", ПараметрыЗапроса, Истина);
	
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераКоммуникатор(), HTTPЗапрос);
	Если Не РезультатЗапроса.ЗапросВыполнен Тогда
		Возврат Результат;
	КонецЕсли;
	
	ДокументDOM = ДокументDOM(РезультатЗапроса.ОтветСервера);
	Разыменователь = ДокументDOM.СоздатьРазыменовательПИ();
	
	НайденныйЭлемент = ДокументDOM.ВычислитьВыражениеXPath("/xmlns:ArrayOfDeliveryInfo/xmlns:DeliveryInfo/xmlns:DeliveryStatus",
		ДокументDOM, Разыменователь).ПолучитьСледующий();
		
	Если НайденныйЭлемент = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = СтатусДоставкиSMS(НайденныйЭлемент.ТекстовоеСодержимое);
	Возврат Результат;
	
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция СтатусДоставкиSMS(СтатусСтрокой)
	СоответствиеСтатусов = Новый Соответствие;
	
	// Коммуникатор
	СоответствиеСтатусов.Вставить("Pending", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("Sending", "Отправляется");
	СоответствиеСтатусов.Вставить("Sent", "Отправлено");
	СоответствиеСтатусов.Вставить("NotSent", "НеОтправлено");
	СоответствиеСтатусов.Вставить("Delivered", "Доставлено");
	СоответствиеСтатусов.Вставить("NotDelivered", "НеДоставлено");
	СоответствиеСтатусов.Вставить("TimedOut", "НеДоставлено");
	
	// Маркетолог
	СоответствиеСтатусов.Вставить(200, "Отправлено");
	СоответствиеСтатусов.Вставить(201, "НеОтправлено");
	СоответствиеСтатусов.Вставить(202, "Отправлено"); // Частично отправлено
	СоответствиеСтатусов.Вставить(300, "Доставлено");
	СоответствиеСтатусов.Вставить(302, "Доставлено"); // Частично доставлено
	СоответствиеСтатусов.Вставить(301, "НеДоставлено");
		
	Результат = СоответствиеСтатусов[СтатусСтрокой];
	Возврат ?(Результат = Неопределено, "Ошибка", Результат);
КонецФункции

Функция ОписанияОшибок()
	ОписанияОшибок = Новый Соответствие;

	// Коммуникатор
	ОписанияОшибок.Вставить("SYSTEM_FAILURE", НСтр("ru = 'Временная проблема на стороне МТС.'"));
	ОписанияОшибок.Вставить("TOO_MANY_PARAMETERS", НСтр("ru = 'Превышено максимальное число параметров.'"));
	ОписанияОшибок.Вставить("INCORRECT_PASSWORD", НСтр("ru = 'Предоставленные логин/пароль не верны.'"));
	ОписанияОшибок.Вставить("MSID_FORMAT_ERROR", НСтр("ru = 'Формат номера неверный.'"));
	ОписанияОшибок.Вставить("MESSAGE_FORMAT_ERROR", НСтр("ru = 'Ошибка в формате сообщения.'"));
	ОписанияОшибок.Вставить("WRONG_ID", НСтр("ru = 'Передан неверный идентификатор.'"));
	ОписанияОшибок.Вставить("MESSAGE_HANDLING_ERROR", НСтр("ru = 'Ошибка в обработке сообщения'"));
	ОписанияОшибок.Вставить("NO_SUCH_SUBSCRIBER", НСтр("ru = 'Данный абонент не зарегистрирован в Услуге в учетной записи клиента (или еще не дал подтверждение).'"));
	ОписанияОшибок.Вставить("TEST_LIMIT_EXCEEDED", НСтр("ru = 'Превышен лимит по количеству сообщений в тестовой эксплуатации.'"));
	ОписанияОшибок.Вставить("TRUSTED_LIMIT_EXCEEDED", НСтр("ru = 'Превышен лимит по количеству сообщений для абонентов, которые были добавлены без подтверждения.'"));
	ОписанияОшибок.Вставить("IP_NOT_ALLOWED", НСтр("ru = 'Доступ к сервису с данного IP невозможен (список допустимых IP-адресов можно указывается при подключении услуги).'"));
	ОписанияОшибок.Вставить("MAX_LENGTH_EXCEEDED", НСтр("ru = 'Превышена максимальная длина сообщения (1000 символов).'"));
	ОписанияОшибок.Вставить("OPERATION_NOT_ALLOWED", НСтр("ru = 'Пользователь услуги не имеет прав на выполнение данной операции.'"));
	ОписанияОшибок.Вставить("EMPTY_MESSAGE_NOT_ALLOWED", НСтр("ru = 'Отправка пустых сообщений не допускается.'"));
	ОписанияОшибок.Вставить("ACCOUNT_IS_BLOCKED", НСтр("ru = 'Учетная запись заблокирована, отправка сообщений не возможна.'"));
	ОписанияОшибок.Вставить("OBJECT_ALREADY_EXISTS", НСтр("ru = 'Список рассылки с указанным названием уже существует в рамках компании.'"));
	ОписанияОшибок.Вставить("MSID_IS_IN_BLACKLIST", НСтр("ru = 'Номер абонента находится в черном списке, отправка сообщений запрещена.'"));
	ОписанияОшибок.Вставить("MSIDS_ARE_IN_BLACKLIST", НСтр("ru = 'Все указанные номера абонентов находятся в черном списке, отправка сообщений запрещена.'"));
	ОписанияОшибок.Вставить("TIME_IS_IN_THE_PAST", НСтр("ru = 'Переданное время в прошлом.'"));
	
	// Маркетолог
	ОписанияОшибок.Вставить(806, НСтр("ru = 'Не указан получатель сообщения.'"));
	ОписанияОшибок.Вставить(807, НСтр("ru = 'Некорректный номер получателя.'"));
	ОписанияОшибок.Вставить(802, НСтр("ru = 'Неверный логин или пароль.'"));
	ОписанияОшибок.Вставить(803, НСтр("ru = 'Превышен лимит на отправку сообщений. Допускается до 10 SMS в секунду.'"));
	ОписанияОшибок.Вставить(804, НСтр("ru = 'Не указан текст сообщения.'"));
	ОписанияОшибок.Вставить(805, НСтр("ru = 'Использование шаблонов недоступно.'"));
	ОписанияОшибок.Вставить(808, НСтр("ru = 'Указанный шаблон не найден.'"));
	ОписанияОшибок.Вставить(401, НСтр("ru = 'Ключ доступа не указан или неверный.'"));
	ОписанияОшибок.Вставить(602, НСтр("ru = 'Отсутствует обязательный параметр в тексте запроса.'"));
	
	Возврат ОписанияОшибок;
КонецФункции

Функция ОписаниеОшибкиПоКоду(Знач КодОшибки)
	КодОшибки = СокрЛП(КодОшибки);
	ОписанияОшибок = ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Отказ выполнения операции.'") + Символы.ПС
			+ КодОшибки;
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

// Возвращает список разрешений для отправки SMS с использованием всех доступных провайдеров.
//
// Возвращаемое значение:
//  Массив
//
Функция Разрешения() Экспорт
	Протокол = "HTTPS";
	Адрес = "mcommunicator.ru";
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через МТС.'");
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Разрешения = Новый Массив;
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	
	Возврат Разрешения;
КонецФункции

Функция ВыполнитьЗапрос(Знач АдресСервера, Знач HTTPЗапрос, Знач Пользователь = Неопределено, Знач Пароль = Неопределено)
	
	Результат = Новый Структура;
	Результат.Вставить("ЗапросВыполнен", Ложь);
	Результат.Вставить("ОтветСервера", "");
	
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение(АдресСервера, , Пользователь, Пароль, ПолучениеФайловИзИнтернета.ПолучитьПрокси("https"),
			60, ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
			
		HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если HTTPОтвет <> Неопределено Тогда
		Если HTTPОтвет.КодСостояния <> 200 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запрос ""%1"" не выполнен. Код состояния: %2.'"), HTTPЗапрос.АдресРесурса, HTTPОтвет.КодСостояния) + Символы.ПС
				+ HTTPОтвет.ПолучитьТелоКакСтроку();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
		КонецЕсли;
		
		Результат.ЗапросВыполнен = HTTPОтвет.КодСостояния = 200;
		Результат.ОтветСервера = HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.АдресОписанияУслугиВИнтернете = "https://marketolog.mts.ru/";
	Настройки.ПриОпределенииСпособовАвторизации = Истина;
	Настройки.ПриОпределенииПолейАвторизации = Истина;
	
КонецПроцедуры

Процедура ПриОпределенииСпособовАвторизации(СпособыАвторизации) Экспорт
	
	СпособыАвторизации.Очистить();
	СпособыАвторизации.Добавить("ПоЛогинуИПаролюМаркетолог", НСтр("ru = 'По логину и паролю (МТС Маркетолог)'"));
	СпособыАвторизации.Добавить("ПоКлючу", НСтр("ru = 'По ключу (МТС Коммуникатор)'"));
	СпособыАвторизации.Добавить("ПоЛогинуИПаролю", НСтр("ru = 'По логину и паролю (МТС Коммуникатор)'"));
	
КонецПроцедуры

Процедура ПриОпределенииПолейАвторизации(СпособыАвторизации) Экспорт
	
	ПоляАвторизации = Новый СписокЗначений;
	ПоляАвторизации.Добавить("Пароль", НСтр("ru = 'Ключ API'"));
	
	СпособыАвторизации.Вставить("ПоКлючу", ПоляАвторизации);
	
	ПоляАвторизации = Новый СписокЗначений;
	ПоляАвторизации.Добавить("Логин", НСтр("ru = 'Логин'"));
	ПоляАвторизации.Добавить("Пароль", НСтр("ru = 'Пароль'"));

	СпособыАвторизации.Вставить("ПоЛогинуИПаролюМаркетолог", ПоляАвторизации);
	
КонецПроцедуры

Функция ДокументDOM(Строка)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Строка);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	Возврат ДокументDOM;
	
КонецФункции

Функция ОтправитьSMSКоммуникатор(Получатели, Текст, ИмяОтправителя, Логин, Знач Пароль)
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("msids", Получатели);
	ПараметрыЗапроса.Вставить("message", Текст);
	ПараметрыЗапроса.Вставить("naming", ИмяОтправителя);
	ПараметрыЗапроса.Вставить("login", Логин);
	
	Если ЗначениеЗаполнено(Логин) Тогда
		ПараметрыЗапроса.Вставить("password", ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Пароль));
	Иначе
		ПараметрыЗапроса.Вставить("password", "");
	КонецЕсли;		
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос(АдресРесурсаКоммуникатор() + "SendMessages", ПараметрыЗапроса, Истина);
	
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераКоммуникатор(), HTTPЗапрос);
	Если Не РезультатЗапроса.ЗапросВыполнен Тогда
		Результат.ОписаниеОшибки = ОписаниеОшибкиПоКоду(РезультатЗапроса.ОтветСервера);
		Возврат Результат;
	КонецЕсли;
	
	ДокументDOM = ДокументDOM(РезультатЗапроса.ОтветСервера);
	Разыменователь = ДокументDOM.СоздатьРазыменовательПИ();
	
	ОтправленныеСообщения = ДокументDOM.ВычислитьВыражениеXPath("/xmlns:ArrayOfSendMessageIDs/xmlns:SendMessageIDs",
		ДокументDOM, Разыменователь);
	
	Сообщение = ОтправленныеСообщения.ПолучитьСледующий();
	Пока Сообщение <> Неопределено Цикл
		НомерПолучателя = ДокументDOM.ВычислитьВыражениеXPath("xmlns:Msid", Сообщение, Разыменователь).ПолучитьСледующий().ТекстовоеСодержимое;
		ИдентификаторСообщения = ДокументDOM.ВычислитьВыражениеXPath("xmlns:MessageID", Сообщение, Разыменователь).ПолучитьСледующий().ТекстовоеСодержимое;
		
		Результат.ОтправленныеСообщения.Добавить(Новый Структура("НомерПолучателя,ИдентификаторСообщения",
			"+" +  НомерПолучателя, Формат(ИдентификаторСообщения, "ЧГ=")));
		
		Сообщение = ОтправленныеСообщения.ПолучитьСледующий();
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОтправитьSMSМаркетолог(Знач Получатели, Знач Текст, Знач ИмяОтправителя, Знач Логин, Знач Пароль)
	
	ТекстЗапроса = ТекстЗапросаМаркетолог(Получатели, Текст, ИмяОтправителя);
	HTTPЗапрос = HTTPЗапросМаркетолог(АдресРесурсаМаркетолог(Получатели.Количество() >= 10) + "messages", ТекстЗапроса);
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераМаркетолог(), HTTPЗапрос, Логин, Пароль);
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	ТекстОтвета = СокрЛП(РезультатЗапроса.ОтветСервера);
	Ответ = Новый Соответствие;
	Если СтрНачинаетсяС(ТекстОтвета, "{") И СтрЗаканчиваетсяНа(ТекстОтвета, "}") Тогда
		Ответ = ОбщегоНазначения.JSONВЗначение(ТекстОтвета);
	КонецЕсли;

	КодОшибки = Ответ["code"];
	Если КодОшибки = Неопределено И Не РезультатЗапроса.ЗапросВыполнен Тогда
		КодОшибки = 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодОшибки) Тогда
		Результат.ОписаниеОшибки = ОписаниеОшибкиПоКоду(КодОшибки);
		Возврат Результат;
	КонецЕсли;
	
	Сообщения = Ответ["messages"];
	Если Сообщения = Неопределено Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Не удалось разобрать ответ сервера.'");
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Результат.ОписаниеОшибки + Символы.ПС + Символы.ПС + ТекстОтвета);
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Сообщение Из Сообщения Цикл
		НомерПолучателя = Сообщение["msisdn"];
		ИдентификаторСообщения = Сообщение["message_id"];
		
		ОписаниеСообщения = Новый Структура;
		ОписаниеСообщения.Вставить("НомерПолучателя", "+" + НомерПолучателя);
		ОписаниеСообщения.Вставить("ИдентификаторСообщения", ИдентификаторСообщения);
		
		Результат.ОтправленныеСообщения.Добавить(ОписаниеСообщения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СтатусДоставкиМаркетолог(ИдентификаторСообщения, НастройкиОтправкиSMS)
	
	Результат = "Ошибка";
	
	ПараметрыЗапроса = Новый Структура;
	МассивИдентификаторов = Новый Массив;
	МассивИдентификаторов.Добавить(ИдентификаторСообщения);
	ПараметрыЗапроса.Вставить("msg_ids", МассивИдентификаторов);

	ТекстЗапроса = ОбщегоНазначения.ЗначениеВJSON(Новый Структура("msg_ids", ПараметрыЗапроса.msg_ids));
	HTTPЗапрос = HTTPЗапросМаркетолог(АдресРесурсаМаркетолог() + "messages/info", ТекстЗапроса);
	
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераМаркетолог(), HTTPЗапрос, НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);	
	Если Не РезультатЗапроса.ЗапросВыполнен Тогда
		Возврат Результат;
	КонецЕсли;
	
	Ответ = ОбщегоНазначения.JSONВЗначение(РезультатЗапроса.ОтветСервера, "event_at");
	СтатусыСообщений = Ответ["events_info"];
	
	Если СтатусыСообщений = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	КодСостояния = Неопределено;
	Для Каждого СтатусыСообщения Из СтатусыСообщений Цикл
		Если СтатусыСообщения["key"] = ИдентификаторСообщения Тогда
			ВремяСобытия = '000101010000';
			Для Каждого ОписаниеСтатуса Из СтатусыСообщения["events_info"] Цикл
				Если ВремяСобытия < ОписаниеСтатуса["event_at"] Тогда
					КодСостояния = ОписаниеСтатуса["status"];
					ВремяСобытия = ОписаниеСтатуса["event_at"];
				КонецЕсли;
			КонецЦикла;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Если КодСостояния = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = СтатусДоставкиSMS(КодСостояния);
	Возврат Результат;
	
КонецФункции

Функция HTTPЗапросМаркетолог(ИмяМетода, ТекстЗапроса)
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-type", "application/json");
	
	HTTPЗапрос = Новый HTTPЗапрос(ИмяМетода, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТекстЗапроса);
	
	Возврат HTTPЗапрос;
	
КонецФункции

Функция ТекстЗапросаМаркетолог(Получатели, Текст, ИмяОтправителя)
	
	ОписанияПолучателей = Новый Массив;
	Для Каждого Получатель Из Получатели Цикл
		ОписаниеПолучателя = Новый Структура;
		ОписаниеПолучателя.Вставить("msisdn", Получатель);
		ОписаниеПолучателя.Вставить("message_id", УникальныйИдентификатор());
		ОписанияПолучателей.Добавить(ОписаниеПолучателя); 
	КонецЦикла;
	
	Сообщение = Новый Структура;
	Сообщение.Вставить("content", Новый Структура("short_text", Текст));
	Сообщение.Вставить("to", ОписанияПолучателей);
	
	Сообщения = Новый Массив;
	Сообщения.Добавить(Сообщение);

	ПараметрыОтправки = Новый Структура;
	
	Если ЗначениеЗаполнено(ИмяОтправителя) Тогда
		ПараметрыОтправки.Вставить("from", Новый Структура("sms_address", ИмяОтправителя));
	КонецЕсли;
	
	ОписаниеЗапроса = Новый Структура;
	ОписаниеЗапроса.Вставить("messages", Сообщения);
	
	Если ЗначениеЗаполнено(ПараметрыОтправки) Тогда
		ОписаниеЗапроса.Вставить("options", ПараметрыОтправки);
	КонецЕсли;
	
	ТекстЗапроса = ОбщегоНазначения.ЗначениеВJSON(ОписаниеЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция УникальныйИдентификатор()
	
	УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
	Возврат Лев(СтрЗаменить(УникальныйИдентификатор, "-", ""), 20);
	
КонецФункции

Функция АдресСервераКоммуникатор()
	
	Возврат "api.mcommunicator.ru";
	
КонецФункции

Функция АдресРесурсаКоммуникатор()
	
	Возврат "/m2m/m2m_api.asmx/";
	
КонецФункции

Функция АдресСервераМаркетолог()
	
	Возврат "omnichannel.mts.ru";
	
КонецФункции

Функция АдресРесурсаМаркетолог(ДляОтправкиБольшогоКоличестваSMS = Ложь)
	
	Если ДляОтправкиБольшогоКоличестваSMS Тогда
		Возврат "/http-api/v1/b/";
	КонецЕсли;
	
	Возврат "/http-api/v1/";
	
КонецФункции

Функция СпособАвторизации()
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = ОтправкаSMS.НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(НастройкиОтправкиSMS.СпособАвторизации) Тогда
		Возврат НастройкиОтправкиSMS.СпособАвторизации;
	КонецЕсли;
	
	Возврат "ПоЛогинуИПаролю";
	
КонецФункции

Функция СпособАвторизацииПоЛогинуИПаролюМаркетолог()
	
	Возврат "ПоЛогинуИПаролюМаркетолог";
	
КонецФункции

#КонецОбласти
