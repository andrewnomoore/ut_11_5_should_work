///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СообщениеОбмена Экспорт; // При получении - имя полученного файла во ВременныйКаталог. При отправке - имя файла, который необходимо отправить
Перем ВременныйКаталог Экспорт; // Временный каталог для сообщений обмена.
Перем ИдентификаторКаталога Экспорт;
Перем Корреспондент Экспорт;
Перем ИмяПланаОбмена Экспорт;
Перем ИмяПланаОбменаКорреспондента Экспорт;
Перем СообщениеОбОшибке Экспорт;
Перем СообщениеОбОшибкеЖР Экспорт;

Перем ШаблоныИменДляПолученияСообщения Экспорт;
Перем ИмяСообщенияДляОтправки Экспорт;

Перем Таймаут;
Перем ТаймаутОтправкаПолучение;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ОтправитьДанные
Функция ОтправитьДанные(СообщениеДляСопоставленияДанных = Ложь) Экспорт

	Попытка
		Результат = ОтправитьСообщение();
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ВыгрузкаДанных");
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПолучитьДанные
Функция ПолучитьДанные() Экспорт

	Попытка
		
		Для Каждого Шаблон Из ШаблоныИменДляПолученияСообщения Цикл
			
			Результат = ПолучитьСообщение(Шаблон);
			
			Если Результат Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
		
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПередВыгрузкойДанных
Функция ПередВыгрузкойДанных(СообщениеДляСопоставленияДанных = Ложь) Экспорт
	
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПараметрыКорреспондента
Функция ПараметрыКорреспондента(НастройкиПодключения) Экспорт
	
	Результат = ТранспортСообщенийОбмена.СтруктураРезультатаПолученияПараметровКорреспондента();
	Результат.ПодключениеУстановлено = Истина;
	Результат.ПодключениеРазрешено = Истина;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.СохранитьНастройкиВКорреспонденте
Функция СохранитьНастройкиВКорреспонденте(НастройкиПодключения) Экспорт
		
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ТребуетсяАутентификация
Функция ТребуетсяАутентификация() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСообщение(ШаблонИмениСообщения)

	ОбновитьТокен();
	
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Authorization","Bearer " + AccessToken);
	
	ИдентификаторКаталогаВОблаке = ИдентификаторКаталогаВОблаке();
	
	АдресРесурса = "/drive/v3/files?q='%1' in parents and trashed = false and name contains '%2'&orderBy=modifiedTime desc";
	АдресРесурса = СтрШаблон(АдресРесурса, ИдентификаторКаталогаВОблаке, ШаблонИмениСообщения);
		
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	HTTPСоединение = Новый HTTPСоединение("www.googleapis.com",,,,, Таймаут, ЗащищенноеСоединение);
	
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Ответ = HTTPСоединение.Получить(Запрос);
	Тело = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	РезультатЗапроса = ТранспортСообщенийОбмена.JSONВЗначение(Тело); 
	
	Если Ответ.КодСостояния <> 200 Тогда
		
		СообщениеОбОшибке = РезультатЗапроса["error"]["message"];
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		
		Возврат Ложь;
	
	КонецЕсли;
		
	ФайлыВОблаке = РезультатЗапроса["files"];
	
	ТаблицаФайлов = Новый ТаблицаЗначений;
	ТаблицаФайлов.Колонки.Добавить("ИмяФайла", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(200)));
	ТаблицаФайлов.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(200)));
	
	Для Каждого Файл Из ФайлыВОблаке Цикл
		
		НовСтрока = ТаблицаФайлов.Добавить();
		НовСтрока.ИмяФайла = Файл["name"];
		НовСтрока.Идентификатор = Файл["id"];
		
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Т.ИмяФайла КАК ИмяФайла,
		|	Т.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ ВТ
		|ИЗ
		|	&ТаблицаФайлов КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ.ИмяФайла КАК ИмяФайла,
		|	ВТ.Идентификатор КАК Идентификатор
		|ИЗ
		|	ВТ КАК ВТ
		|ГДЕ
		|	ВТ.ИмяФайла ПОДОБНО &Шаблон";
		
	ШаблонИмениСообщенияДляПоиска = СтрЗаменить(ШаблонИмениСообщения, "*", "%");
	
	Запрос.УстановитьПараметр("Шаблон", ШаблонИмениСообщенияДляПоиска);
	Запрос.УстановитьПараметр("ТаблицаФайлов", ТаблицаФайлов);
	
	РезультатПоискаФайлов = Запрос.Выполнить().Выгрузить();
	
	Если РезультатПоискаФайлов.Количество() = 0 Тогда
		
		СообщениеОбОшибке = НСтр("ru = 'В каталоге обмена информацией не был обнаружен файл сообщения с данными.
                                  |Идентификатор каталога на сервере на сервере: ""%1""
                                  |Имя файла сообщения обмена: ""%2""'");

		СообщениеОбОшибке = СтрШаблон(СообщениеОбОшибке, ИдентификаторКаталогаВОблаке, ШаблонИмениСообщения);
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		
		Возврат Ложь;

	КонецЕсли;
	
	// загрузка файла с диска
	Файл = РезультатПоискаФайлов[0];
	
	HTTPСоединение = Новый HTTPСоединение("www.googleapis.com",,,,, ТаймаутОтправкаПолучение, ЗащищенноеСоединение);
	
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Authorization","Bearer " + AccessToken);
	
	АдресРесурса = "/drive/v3/files/%1?alt=media";
	АдресРесурса = СтрШаблон(АдресРесурса, Файл["Идентификатор"]);
	
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	Ответ = HTTPСоединение.Получить(Запрос);
	
	Если Ответ.КодСостояния <> 200 Тогда
		
		СообщениеОбОшибке = ТранспортСообщенийОбмена.JSONВЗначение(Тело)["message"];
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		
		Возврат Ложь;
	
	КонецЕсли;
	
	ФайлЗапакован = ВРег(Прав(Файл["ИмяФайла"], 3)) = "ZIP";
	
	Если ФайлЗапакован Тогда
			
		// Получаем имя для временного файла архива.
		ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
			ВременныйКаталог, Строка(Новый УникальныйИдентификатор) + ".zip");
		
		ДвоичныеДанные = Ответ.ПолучитьТелоКакДвоичныеДанные();
		ДвоичныеДанные.Записать(ИмяВременногоФайлаАрхива);
		
		Если Не ТранспортСообщенийОбмена.РаспаковатьСообщениеОбменаИзZipФайла(
			ЭтотОбъект, ИмяВременногоФайлаАрхива, ПарольАрхиваСообщенияОбмена) Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
	Иначе
		
		ДвоичныеДанные = Ответ.ПолучитьТелоКакДвоичныеДанные();
		ДвоичныеДанные.Записать(СообщениеОбмена);
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ОтправитьСообщение()

	ОбновитьТокен();
	
	Если СжиматьФайлИсходящегоСообщения Тогда
			
		Тип = "application/zip";
		
		Если Не ТранспортСообщенийОбмена.ЗапаковатьСообщениеОбменаВZipФайл(ЭтотОбъект, ПарольАрхиваСообщенияОбмена) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Файл = Новый Файл(ИмяСообщенияДляОтправки);
		ИмяСообщения = Файл.ИмяБезРасширения + ".zip";
		
	Иначе
		
		ИмяСообщения = ИмяСообщенияДляОтправки;
		Тип = "application/xml";
		
	КонецЕсли;
	
	ИдентификаторФайла = "";
	
	Если Не ПоискФайла(ИмяСообщения, ИдентификаторФайла, "ВыгрузкаДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Разделитель = "v8exchange_cloud";
	
	// Метаданные файла
	Свойства = Новый Соответствие();
	Свойства.Вставить("name", ИмяСообщения);
	Свойства.Вставить("mimeType", Тип);
	
	ИдентификаторКаталогаВОблаке = ИдентификаторКаталогаВОблаке();
	
	Если Не ЗначениеЗаполнено(ИдентификаторФайла) Тогда 
		МассивКаталогов = Новый Массив;
		МассивКаталогов.Добавить(ИдентификаторКаталогаВОблаке);
		Свойства.Вставить("parents", МассивКаталогов);
	КонецЕсли;
	
	МетаданныеФайла = ТранспортСообщенийОбмена.ЗначениеВJSON(Свойства); 
	
	Поток = Новый ПотокВПамяти();
	ЗаписьДанных = Новый ЗаписьДанных(Поток);
	
	ЗаписьДанных.ЗаписатьСтроку("Content-Type: application/json; charset=UTF-8");
	ЗаписьДанных.ЗаписатьСтроку("");
	ЗаписьДанных.ЗаписатьСтроку(МетаданныеФайла);
	ЗаписьДанных.Закрыть();
	
	ДвоичныеДанныеМетаданные = Поток.ЗакрытьИПолучитьДвоичныеДанные();
		
	// Данные файла
	ДвоичныеДанные = Новый ДвоичныеДанные(СообщениеОбмена);
		
	Поток = Новый ПотокВПамяти();
	ЗаписьДанных = Новый ЗаписьДанных(Поток);
	ЗаписьДанных.ЗаписатьСтроку("Content-Type:" + Тип);
	ЗаписьДанных.ЗаписатьСтроку("");
	ЗаписьДанных.Записать(ДвоичныеДанные);
	ЗаписьДанных.Закрыть();
	
	ДвоичныеДанныеФайл = Поток.ЗакрытьИПолучитьДвоичныеДанные();
		
	// Тело запроса
	ПотокТело = Новый ПотокВПамяти();
	ЗаписьДанных = Новый ЗаписьДанных(ПотокТело);
	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель);
	ЗаписьДанных.Записать(ДвоичныеДанныеМетаданные);
	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель);
	ЗаписьДанных.Записать(ДвоичныеДанныеФайл);
	ЗаписьДанных.ЗаписатьСтроку("");
	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель + "--");
	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель + "--");
	
	ЗаписьДанных.Закрыть();
	
	ДвоичныеДанныеТело = ПотокТело.ЗакрытьИПолучитьДвоичныеДанные();
		
	Заголовки  = Новый Соответствие;
	Заголовки.Вставить("Authorization", "Bearer " + AccessToken);
	Заголовки.Вставить("Content-Type", "Multipart/Related; boundary=" + Разделитель);
	Заголовки.Вставить("Content-Length", Формат(ДвоичныеДанныеТело.Размер(), "ЧГ="));
	
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	Соединение = Новый HTTPСоединение("www.googleapis.com",,,,,
		ТаймаутОтправкаПолучение, ЗащищенноеСоединение);
	
	Если ЗначениеЗаполнено(ИдентификаторФайла) Тогда
			
		Запрос = Новый HTTPЗапрос("/upload/drive/v3/files/" + ИдентификаторФайла + "?uploadType=multipart", Заголовки);
		Запрос.УстановитьТелоИзДвоичныхДанных(ДвоичныеДанныеТело);
		
		Ответ = Соединение.Изменить(Запрос);
		
	Иначе
		
		Запрос = Новый HTTPЗапрос("/upload/drive/v3/files?uploadType=multipart", Заголовки);
		Запрос.УстановитьТелоИзДвоичныхДанных(ДвоичныеДанныеТело);
		
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
		
	КонецЕсли;
	
	Тело = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	РезультатЗапроса = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
	
	Если Ответ.КодСостояния <> 200 Тогда
		
		СообщениеОбОшибке = РезультатЗапроса["error"]["message"];
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ВыгрузкаДанных");
		
		Возврат Ложь;
		
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

Функция ПодключениеУстановлено() Экспорт
	
	ОбновитьТокен();

	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Authorization","Bearer " + AccessToken);
	
	АдресРесурса = "/drive/v3/files?pageSize=1"; 
	
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	HTTPСоединение = Новый HTTPСоединение("www.googleapis.com",,,,, Таймаут, ЗащищенноеСоединение);
	
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Ответ = HTTPСоединение.Получить(Запрос);
	Тело = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	РезультатЗапроса = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
			
	Если Ответ.КодСостояния <> 200 Тогда
		
		СообщениеОбОшибке = РезультатЗапроса["error"]["message"];
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ОбновитьТокен()
	
	Если ЗначениеЗаполнено(ExpiresIn) И ТекущаяДатаСеанса() < ExpiresIn Тогда
		Возврат Истина;
	КонецЕсли;
	
	АдресРесурса = "client_id=%1&client_secret=%2&grant_type=refresh_token&refresh_token=%3";
	АдресРесурса = СтрШаблон(АдресРесурса, ClientID, ClientSecret, RefreshToken);
	
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	Соединение = Новый HTTPСоединение("accounts.google.com", 443,,,, Таймаут, ЗащищенноеСоединение);

	Заголовки  = Новый Соответствие;
	Заголовки.Вставить("Content-Type","application/x-www-form-urlencoded");
	
	Запрос = Новый HTTPЗапрос("/o/oauth2/token", Заголовки);
	Запрос.УстановитьТелоИзСтроки(АдресРесурса);

	Ответ = Соединение.ВызватьHTTPМетод("POST", Запрос);
	Тело = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	РезультатЗапроса = ТранспортСообщенийОбмена.JSONВЗначение(Тело);
	
	Если Ответ.КодСостояния <> 200 Тогда
		
		СообщениеОбОшибке = РезультатЗапроса["error_description"];
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		Возврат Ложь;
		
	КонецЕсли;
	
	access_token = РезультатЗапроса["access_token"];
	expires_in = ТекущаяДатаСеанса() + РезультатЗапроса["expires_in"] - 25;
	
	Если ЗначениеЗаполнено(Корреспондент) Тогда
	
		НастройкиТранспорта = ТранспортСообщенийОбмена.НастройкиТранспорта(Корреспондент, "GoogleDrive"); 
		
		Если НастройкиТранспорта <> Неопределено Тогда
			
			НастройкиТранспорта.Вставить("Google_access_token", access_token);
			НастройкиТранспорта.Вставить("Google_expires_in", expires_in);
			
			ТранспортСообщенийОбмена.СохранитьНастройкиТранспорта(Корреспондент, "GoogleDrive", НастройкиТранспорта);
			
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ИдентификаторКаталогаВОблаке()

	Если ЗначениеЗаполнено(КаталогВОблаке) Тогда
		
		Заголовки = Новый Соответствие();
		Заголовки.Вставить("Authorization","Bearer " + AccessToken);
		
		АдресРесурса = "/drive/v3/files?q=trashed = false and name='%1'";
		АдресРесурса = СтрШаблон(АдресРесурса, КаталогВОблаке); 
		
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
		HTTPСоединение = Новый HTTPСоединение("www.googleapis.com",,,,, Таймаут, ЗащищенноеСоединение);
		
		Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
		
		Ответ = HTTPСоединение.Получить(Запрос);
		Тело = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
		РезультатЗапроса = ТранспортСообщенийОбмена.JSONВЗначение(Тело); 
	
		Если Ответ.КодСостояния <> 200 Тогда
			
			СообщениеОбОшибке = РезультатЗапроса["error"]["message"];
			ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект,"ЗагрузкаДанных");
			Возврат "";
		
		КонецЕсли;
		
		ФайлыВОблаке = РезультатЗапроса["files"];
	
		Если ФайлыВОблаке.Количество() = 0 Тогда
			Возврат "";
		Иначе
			Возврат ФайлыВОблаке[0]["id"];
		КонецЕсли;
	
	Иначе 
		
		Возврат "root";
		
	КонецЕсли;
	
КонецФункции

Функция ПоискФайла(ИмяФайла, ИдентификаторФайла, ДействиеПриОбмене)
	
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Authorization","Bearer " + AccessToken);
	
	ИдентификаторКаталогаВОблаке = ИдентификаторКаталогаВОблаке();
	
	АдресРесурса = "/drive/v3/files?q='%1' in parents and trashed = false and name='%2'";
	АдресРесурса = СтрШаблон(АдресРесурса, ИдентификаторКаталогаВОблаке, ИмяФайла); 
	
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	HTTPСоединение = Новый HTTPСоединение("www.googleapis.com",,,,, Таймаут, ЗащищенноеСоединение);
	
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Ответ = HTTPСоединение.Получить(Запрос);
	Тело = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	РезультатЗапроса = ТранспортСообщенийОбмена.JSONВЗначение(Тело);

	Если Ответ.КодСостояния <> 200 Тогда
		
		СообщениеОбОшибке = РезультатЗапроса["error"]["message"];
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, ДействиеПриОбмене);
		
		Возврат Ложь;
		
	КонецЕсли;
		
	ФайлыВОблаке = РезультатЗапроса["files"];
	
	Если ФайлыВОблаке.Количество() = 0 Тогда
		ИдентификаторФайла = "";
	Иначе
		ИдентификаторФайла = ФайлыВОблаке[0]["id"];
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ВременныйКаталог = Неопределено;
СообщениеОбмена = Неопределено;

Таймаут = 20;
ТаймаутОтправкаПолучение = 43200;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли