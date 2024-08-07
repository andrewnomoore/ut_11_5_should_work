#Область ПрограммныйИнтерфейс

#Область Авторизация

// Возвращает текущий ключ сессии для обмена с ИСМП.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
// 	СрокДействия - Дата, Неопределено - Срок действия ключа сессии.
// Возвращаемое значение:
// 	Строка, Неопределено - Действующий ключ сессии для организации.
	
Функция ТекущийКлючСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено) Экспорт
	
	Попытка
		ДанныеКлючаСессии = ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса].Получить();
	Исключение
		ДанныеКлючаСессии = Неопределено;
	КонецПопытки;
	
	Если ДанныеКлючаСессии = Неопределено
		Или ДанныеКлючаСессии.Количество() = 0 Тогда
		ДанныеКлючаСессии = ИнтерфейсАвторизацииИСМПСлужебный.ПолучитьСохраненныеДанныеКлючаСессии(ПараметрыЗапроса.ИмяПараметраСеанса);
	КонецЕсли;
	
	// Ключ сессии еще не установлен
	Если ДанныеКлючаСессии = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеКлючаСессииДляОрганизации = ИнтерфейсАвторизацииИСМПСлужебный.АктуальныеПараметрыКлючаСессии(ПараметрыЗапроса, ДанныеКлючаСессии, СрокДействия);
	
	Если ДанныеКлючаСессииДляОрганизации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КлючСессии = ДанныеКлючаСессииДляОрганизации.КлючСессии;
	
	Возврат КлючСессии;
	
КонецФункции

// Проверить актуальность ключа сессии.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
// 	СрокДействия - Дата, Неопределено - Требуемый срок действия ключа сессии.
// Возвращаемое значение:
// 	Булево - Необходимость обновления ключа сессии.
Функция ТребуетсяОбновлениеКлючаСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено) Экспорт
	
	КлючСессии = ТекущийКлючСессии(ПараметрыЗапроса, СрокДействия);
	
	ТребуетсяОбновление = (КлючСессии = Неопределено);
	
	Если Не ТребуетсяОбновление Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючСессииОбновлен = ИнтерфейсАвторизацииИСМПСлужебный.ОбновитьКлючСессииНаСервере(ПараметрыЗапроса);
	
	Возврат Не КлючСессииОбновлен;
	
КонецФункции

// Проверить актуальность розничного ключа сессии.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессииИСМПРозница).
// 	СрокДействия - Дата, Неопределено - Требуемый срок действия ключа сессии.
// Возвращаемое значение:
// 	Булево - Необходимость обновления ключа сессии.
Функция ТребуетсяОбновлениеКлючаСессииРозница(ПараметрыЗапроса, Знач СрокДействия = Неопределено) Экспорт
	
	КлючСессии = ТекущийКлючСессии(ПараметрыЗапроса, СрокДействия);
	
	ТребуетсяОбновление = (КлючСессии = Неопределено);
	
	Если Не ТребуетсяОбновление Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючСессииОбновлен = ИнтерфейсАвторизацииИСМПСлужебный.ОбновитьКлючСессииНаСервере(ПараметрыЗапроса);
	
	Возврат Не КлючСессииОбновлен;
	
КонецФункции

// Запросить из сервиса ИС МП параметры авторизации.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ПараметрыЗапросаКлючаСессии) - Параметры запроса ключа сессии.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ПараметрыАвторизации - (См. ИнтерфейсАвторизацииИСМПСлужебный.ПараметрыАвторизации). - Параметры авторизации
//                        - Неопределено - Если при получении параметров авторизации возникла ошибка.
// * ТекстОшибки          - Строка - Текст сообщения об ошибке.
Функция ЗапроситьПараметрыАвторизации(ПараметрыЗапроса) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПараметрыАвторизации", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	РезультатЗапроса = ОбщегоНазначенияИС.ПолучитьДанныеИзСервиса(
		ПараметрыЗапроса.АдресЗапросаПараметровАвторизации, Неопределено,
		ПараметрыЗапроса);
	
	РезультатОтправкиЗапроса = ОбщегоНазначенияИСМП.ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(РезультатЗапроса);
	
	Если РезультатОтправкиЗапроса.ОтветПолучен Тогда
		
		Если РезультатОтправкиЗапроса.КодСостояния = 200 Тогда
			
			ДанныеОтвета = ОбщегоНазначенияИСМП.ТекстJSONВОбъект(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON);
			
			Если ДанныеОтвета = Неопределено Тогда
				
				ВозвращаемоеЗначение.ТекстОшибки = ОбщегоНазначенияИС.ТекстОшибкиПоРезультатуОтправкиЗапроса(
					ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
					РезультатОтправкиЗапроса);
				
			Иначе
				
				ПараметрыАвторизации = ИнтерфейсАвторизацииИСМПСлужебный.ПараметрыАвторизации();
				ПараметрыАвторизации.Идентификатор = ДанныеОтвета.uuid;
				ПараметрыАвторизации.Данные        = ДанныеОтвета.data;
				
				ВозвращаемоеЗначение.ПараметрыАвторизации = ПараметрыАвторизации;
				
			КонецЕсли;
			
		Иначе
			
			ВозвращаемоеЗначение.ТекстОшибки = ОбщегоНазначенияИС.ТекстОшибкиПоРезультатуОтправкиЗапроса(
				ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
				РезультатОтправкиЗапроса);
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.ТекстОшибки = ОбщегоНазначенияИС.ТекстОшибкиПоРезультатуОтправкиЗапроса(
			ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
			РезультатОтправкиЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Выполнить запрос ключа сессии в МОТП.
// 
// Параметры:
// 	ПараметрыЗапросаПоОрганизации - Структура - Структура со свойствами:
//	* ПараметрыЗапроса
//	* ПараметрыАвторизации
//	* СвойстваПодписи
//
// Возвращаемое значение:
// 	Структура - Описание:
// * Результат   - (См. ИнтерфейсМОТПСлужебный.ПараметрыКлючаСессии).
//               - Неопределено - При получении параметров ключа сессии произошла ошибка.
// * ТекстОшибки - Строка - Текст ошибки.
Функция ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПараметрыКлючаСессии", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	ТокенРозничнойПродажи = (ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.ИмяПараметраСеанса = Метаданные.ПараметрыСеанса.ДанныеКлючаСессииИСМПРозница.Имя);
	
	ТелоЗапроса = Новый Структура;
	Если Не ТокенРозничнойПродажи Тогда
	
		ТелоЗапроса.Вставить("uuid", ПараметрыЗапросаПоОрганизации.ПараметрыАвторизации.Идентификатор);
		
		Если ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Свойство("Организация")
			И ЗначениеЗаполнено(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация) Тогда
			ТелоЗапроса.Вставить("inn", РаботаСКонтрагентамиИСВызовСервера.ИННКПППоОрганизацииКонтрагенту(
				ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация).ИНН);
		КонецЕсли;
	
	КонецЕсли;
	
	ТелоЗапроса.Вставить("data", ОбщегоНазначенияИСКлиентСервер.ДвоичныеДанныеBase64(
		ОбщегоНазначенияИСМПСлужебный.ПодписьИзСвойствПодписи(ПараметрыЗапросаПоОрганизации.СвойстваПодписи)));
	
	Если ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Свойство("Организация")
		И ЗначениеЗаполнено(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация) Тогда
		ТелоЗапроса.Вставить("inn", РаботаСКонтрагентамиИСВызовСервера.ИННКПППоОрганизацииКонтрагенту(
			ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация).ИНН);
	КонецЕсли;
	
	РезультатЗапроса = ОбщегоНазначенияИСМП.ОтправитьДанныеВСервис(
		ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии, ТелоЗапроса, Неопределено, "POST",
		ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса);
	
	РезультатОтправкиЗапроса = ОбщегоНазначенияИСМП.ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(РезультатЗапроса);
	
	Если РезультатОтправкиЗапроса.ОтветПолучен Тогда
		
		Если РезультатОтправкиЗапроса.КодСостояния = 200 Тогда
			
			ДанныеОтвета = ОбщегоНазначенияИСМП.ТекстJSONВОбъект(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON);
			
			Если ДанныеОтвета = Неопределено
				Или Не ДанныеОтвета.Свойство("token") И Не ДанныеОтвета.Свойство("access_token") Тогда
				
				ВозвращаемоеЗначение.ТекстОшибки = ОбщегоНазначенияИС.ТекстОшибкиПоРезультатуОтправкиЗапроса(
					ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
					РезультатОтправкиЗапроса);
				
			Иначе
				
				ДействуетДо = ТекущаяУниверсальнаяДата() + ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.ВремяЖизни;
				
				Если ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.ИмяПараметраСеанса = Метаданные.ПараметрыСеанса.ДанныеКлючаСессииИСМП.Имя Тогда
					
					РезультатРазбора = ОбщегоНазначенияИСМПСлужебный.РасшифроватьТокенJWT(ДанныеОтвета.token);
					Если РезультатРазбора.Данные <> Неопределено Тогда
						ДействуетДо = ОбщегоНазначенияИСКлиентСервер.ДатаИзСтрокиUNIX(РезультатРазбора.Данные.exp, 1, Ложь);
					КонецЕсли;
					
				ИначеЕсли ТокенРозничнойПродажи Тогда
					
					ДействуетДо = ТекущаяУниверсальнаяДата() + ДанныеОтвета.expires_in;
					
					ПараметрыКлючаСессии = ПараметрыКлючаСессии();
					ПараметрыКлючаСессии.КлючСессии  = ДанныеОтвета.access_token;
					ПараметрыКлючаСессии.ДействуетДо = ДействуетДо;
					
					ВозвращаемоеЗначение.ПараметрыКлючаСессии = ПараметрыКлючаСессии;
					
					Возврат ВозвращаемоеЗначение;
					
				КонецЕсли;
				
				ПараметрыКлючаСессии = ПараметрыКлючаСессии();
				ПараметрыКлючаСессии.КлючСессии  = ДанныеОтвета.token;
				ПараметрыКлючаСессии.ДействуетДо = ДействуетДо;
				
				ВозвращаемоеЗначение.ПараметрыКлючаСессии = ПараметрыКлючаСессии;
				
			КонецЕсли;
			
		Иначе
			
			ВозвращаемоеЗначение.ТекстОшибки = ОбщегоНазначенияИС.ТекстОшибкиПоРезультатуОтправкиЗапроса(
				ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
				РезультатОтправкиЗапроса);
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.ТекстОшибки = ОбщегоНазначенияИС.ТекстОшибкиПоРезультатуОтправкиЗапроса(
			ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
			РезультатОтправкиЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ТребуетсяОбновлениеКлючаСессииСУчетомВидаТокена(ПараметрыСканирования, РозничныйТокен = Ложь) Экспорт
	
	Если РозничныйТокен Тогда
		ПараметрыЗапроса = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ПараметрыЗапросаКлючаСессииИСМПРозница(ПараметрыСканирования.Организация);
	Иначе
		ПараметрыЗапроса = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ПараметрыЗапросаКлючаСессии(ПараметрыСканирования.Организация);
	КонецЕсли;
	
	Возврат ТребуетсяОбновлениеКлючаСессии(ПараметрыЗапроса);
	
КонецФункции

// Возвращает структуру данных ключа сессии обмена с МОТП.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Параметры ключа сессии:
// * КлючСессии  - Строка - Ключ сессии.
// * ДействуетДо - Дата   - Дата и время окончания действия ключа сессии.
Функция ПараметрыКлючаСессии() Экспорт
	
	ПараметрыКлючаСессии = Новый Структура;
	ПараметрыКлючаСессии.Вставить("КлючСессии",  "");
	ПараметрыКлючаСессии.Вставить("ДействуетДо", '00010101');
	
	Возврат ПараметрыКлючаСессии;
	
КонецФункции

// Параметры запроса ключа сессии.
// 
// Параметры:
//  ТипТокенаАвторизации - ПеречислениеСсылка.ТипыТокеновАвторизации - Тип токена
// 
// Возвращаемое значение:
//  Структура - Параметры запроса ключа сессии:
// * ИмяПараметраСеанса - Строка - 
// * Организация - ОпределяемыйТип.Организация - 
// * ПроизводственныйОбъект - ОпределяемыйТип.ПроизводственныйОбъектИС, Неопределено - 
Функция ПараметрыЗапросаКлючаСессии(ТипТокенаАвторизации) Экспорт
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить(
		"ИмяПараметраСеанса",
		ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ИмяДанныхКлючаСессии(ТипТокенаАвторизации));
	ПараметрыЗапроса.Вставить("Организация",            Неопределено);
	ПараметрыЗапроса.Вставить("ПроизводственныйОбъект", Неопределено);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

// Записать ключ сессии в базу данных.
// 
// Параметры:
//  ПараметрыЗапроса - см. ПараметрыЗапросаКлючаСессии
//  ПараметрыКлючаСессии - см. ПараметрыКлючаСессии
//  ЗаписатьВРегистр - Булево - Записать в регистр
Процедура УстановитьКлючСессии(ПараметрыЗапроса, ПараметрыКлючаСессии, ЗаписатьВРегистр = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗаписатьВРегистр Тогда
		
		НачатьТранзакцию();
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДанныеКлючаСессииИСМП");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ИмяПараметраСеанса", ПараметрыЗапроса.ИмяПараметраСеанса);
		Блокировка.Заблокировать();
		
		ДанныеКлючаСессии = ИнтерфейсАвторизацииИСМПСлужебный.ПолучитьСохраненныеДанныеКлючаСессии(ПараметрыЗапроса.ИмяПараметраСеанса);
		
	Иначе
		Попытка
			ДанныеКлючаСессии = ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса].Получить();
		Исключение
			ДанныеКлючаСессии = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Если ДанныеКлючаСессии = Неопределено Тогда
		ДанныеКлючаСессии = Новый Соответствие();
	КонецЕсли;
	
	Если ИнтерфейсАвторизацииИСМПСлужебный.ЭтоПараметрыЗапросаСУЗ(ПараметрыЗапроса) Тогда
		
		ДанныеПоОрганизации = ДанныеКлючаСессии.Получить(ПараметрыЗапроса.Организация);
		
		Если ДанныеПоОрганизации = Неопределено
			Или ТипЗнч(ДанныеПоОрганизации) = Тип("Структура") Тогда
			ДанныеПоОрганизации = Новый Соответствие;
			ДанныеКлючаСессии.Вставить(ПараметрыЗапроса.Организация, ДанныеПоОрганизации);
		КонецЕсли;
		
		Если ПараметрыКлючаСессии.КлючСессии  = ""
			Или ПараметрыКлючаСессии.ДействуетДо = Дата(1,1,1) Тогда
			ДанныеПоОрганизации.Удалить(ПараметрыЗапроса.ПроизводственныйОбъект);
		Иначе
			ДанныеПоОрганизации.Вставить(ПараметрыЗапроса.ПроизводственныйОбъект, ПараметрыКлючаСессии);
		КонецЕсли;
		
	Иначе
		
		Если ПараметрыКлючаСессии.КлючСессии  = ""
			Или ПараметрыКлючаСессии.ДействуетДо = Дата(1,1,1) Тогда
			ДанныеКлючаСессии.Удалить(ПараметрыЗапроса.Организация);
		Иначе
			ДанныеКлючаСессии.Вставить(ПараметрыЗапроса.Организация, ПараметрыКлючаСессии);
		КонецЕсли;
		
	КонецЕсли;
	
	СохраняемыеДанные = Новый ХранилищеЗначения(ДанныеКлючаСессии);
	
	Если ЗаписатьВРегистр Тогда
		
		НаборЗаписей = РегистрыСведений.ДанныеКлючаСессииИСМП.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИмяПараметраСеанса.Установить(ПараметрыЗапроса.ИмяПараметраСеанса, Истина);
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.ИмяПараметраСеанса = ПараметрыЗапроса.ИмяПараметраСеанса;
		ЗаписьНабора.Данные             = СохраняемыеДанные;
		
		Попытка
			НаборЗаписей.Записать(Истина);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
	ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса] = СохраняемыеДанные;
	
КонецПроцедуры

#КонецОбласти

#Область ОтветственныеЗаАктуализациюТокеновАвторизации

// Получает настройки текущего пользователя для актуализации токенов авторизации.
// 
// Параметры:
//  ДляПросмотра - Булево - определяет для чего нужно получить настройки:
//                          для просмотра списка токенов или для актуализации токенов.
// 
// Возвращаемое значение:
// см. Справочники.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.НастройкиОтветственногоЗаАктуализациюТокеновАвторизации.
//
Функция НастройкиОтветственногоЗаАктуализациюТокеновАвторизации(ДляПросмотра) Экспорт
	
	Возврат Справочники.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.НастройкиОтветственногоЗаАктуализациюТокеновАвторизации(ДляПросмотра);
	
КонецФункции

// Получает напоминания пользователю, ответственному за актуализацию токенов авторизации.
//
// Параметры:
//  Настройки - см. Справочники.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.НастройкиОтветственногоЗаАктуализациюТокеновАвторизации.
// 
// Возвращаемое значение:
//  Массив из Структура:
//   * ТипТокенаАвторизации - ПеречислениеСсылка.ТипыТокеновАвторизации - тип токена авторизации.
//   * Организация - ОпределяемыйТип.Организация - организация.
//   * ПроизводственныйОбъект - ОпределяемыйТип.ПроизводственныйОбъектИС - производственный объект.
//   * ДатаДействия - Дата - дата и время, до которой действителен токен.
//   * ВремяДействия - Число - сколько времени (в секундах, кратно минутам) осталось до окончания действия токена.
//   * Отсутствует - Булево - Истина, если токен отсутствует.
//   * Просрочен - Булево - Истина, если токен имеется, но дата действия токена больше текущей.
//   * ТребуетсяАктуализация - Булево - Истина, если требуется актуализация токена.
//   * ОповещениеИспользуется - Булево - Истина, если требуется оповещение пользователя о скором окончании действия токена.
//   * ОповещатьЗа - Число - время в секундах до истечения действия токена, за которое необходимо оповестить пользователя.
//   * ОповеститьЧерез - Число - время в секундах до момента ближайшего оповещения пользователя.
//
Функция ПолучитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации(Настройки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяПараметраСУЗ         = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ИмяДанныхКлючаСессии(Перечисления.ТипыТокеновАвторизации.СУЗ);
	ИмяПараметраИСМП        = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ИмяДанныхКлючаСессии(Перечисления.ТипыТокеновАвторизации.ИСМП);
	ИмяПараметраИСМПРозница = ИнтерфейсИСМПОбщегоНазначенияКлиентСервер.ИмяДанныхКлючаСессии(Перечисления.ТипыТокеновАвторизации.ИСМПРозница);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПараметраИСМП",        ИмяПараметраИСМП);
	Запрос.УстановитьПараметр("ИмяПараметраСУЗ",         ИмяПараметраСУЗ);
	Запрос.УстановитьПараметр("ИмяПараметраИСМПРозница", ИмяПараметраИСМПРозница);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИмяПараметраСеанса,
	|	Данные
	|ИЗ
	|	РегистрСведений.ДанныеКлючаСессииИСМП
	|ГДЕ
	|	ИмяПараметраСеанса = &ИмяПараметраИСМП
	|	ИЛИ ИмяПараметраСеанса = &ИмяПараметраСУЗ
	|	ИЛИ ИмяПараметраСеанса = &ИмяПараметраИСМПРозница";
	РезультатЗапроса = Запрос.Выполнить();
	
	ТекущаяДата = ТекущаяУниверсальнаяДата();
	ПустаяДата  = Дата(1,1,1);
	
	ДанныеКлючаСессииСУЗ         = Неопределено;
	ДанныеКлючаСессииИСМП        = Неопределено;
	ДанныеКлючаСессииИСМПРозница = Неопределено;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ИмяПараметраСеанса = ИмяПараметраИСМП Тогда
			ДанныеКлючаСессииИСМП = Выборка.Данные.Получить();
		ИначеЕсли Выборка.ИмяПараметраСеанса = ИмяПараметраИСМПРозница Тогда
			ДанныеКлючаСессииИСМПРозница = Выборка.Данные.Получить();
		ИначеЕсли Выборка.ИмяПараметраСеанса = ИмяПараметраСУЗ Тогда
			ДанныеКлючаСессииСУЗ = Выборка.Данные.Получить();
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Массив;
	
	Для Каждого Настройка Из Настройки Цикл
		
		ТипТокенаАвторизации   = Настройка.ТипТокенаАвторизации;
		Организация            = Настройка.Организация;
		ПроизводственныйОбъект = Настройка.ПроизводственныйОбъект;
		ОповещатьЗа            = 0;
		
		Если ТипТокенаАвторизации = Перечисления.ТипыТокеновАвторизации.СУЗ Тогда
			Если ДанныеКлючаСессииСУЗ = Неопределено
				Или ДанныеКлючаСессииСУЗ[Организация] = Неопределено
				Или ДанныеКлючаСессииСУЗ[Организация][ПроизводственныйОбъект] = Неопределено Тогда
				ДатаДействияТокена = ПустаяДата;
			Иначе
				ДатаДействияТокена = ДанныеКлючаСессииСУЗ[Организация][ПроизводственныйОбъект].ДействуетДо;
			КонецЕсли;
		ИначеЕсли ТипТокенаАвторизации = Перечисления.ТипыТокеновАвторизации.ИСМПРозница Тогда
			Если ДанныеКлючаСессииИСМПРозница = Неопределено
				Или ДанныеКлючаСессииИСМПРозница[Организация] = Неопределено Тогда
				ДатаДействияТокена = ПустаяДата;
			Иначе
				ДатаДействияТокена = ДанныеКлючаСессииИСМПРозница[Организация].ДействуетДо;
			КонецЕсли;
		Иначе
			Если ДанныеКлючаСессииИСМП = Неопределено
				Или ДанныеКлючаСессииИСМП[Организация] = Неопределено Тогда
				ДатаДействияТокена = ПустаяДата;
			Иначе
				ДатаДействияТокена = ДанныеКлючаСессииИСМП[Организация].ДействуетДо;
			КонецЕсли;
		КонецЕсли;
		
		ТокенОтсутствует = ДатаДействияТокена = ПустаяДата;
		
		Если ТокенОтсутствует Тогда
			ВремяДействияТокена = 0;
		Иначе
			ВремяДействияТокена = ДатаДействияТокена - ТекущаяДата;
			Если ВремяДействияТокена < 0 Тогда
				ВремяДействияТокена = 0;
			Иначе
				ВремяДействияТокена = Цел(ВремяДействияТокена / 60) * 60;
			КонецЕсли;
		КонецЕсли;
		
		ТокенПросрочен              = Не ТокенОтсутствует И ВремяДействияТокена = 0;
		ТребуетсяАктуализацияТокена = ТокенОтсутствует Или ТокенПросрочен;
		ОповещениеИспользуется      = Ложь;
		ОповеститьЧерез             = 0;
		
		Если ОбщегоНазначенияИСКлиентСервер.ЭтоРасширеннаяВерсияГосИС() Тогда
			
			ОповещатьЗа            = Настройка.ВремяОповещения;
			ОповещениеИспользуется = ОповещатьЗа > 0;
			
			Если ОповещениеИспользуется Тогда
				
				НапоминанияПользователяИСМП = ОбщегоНазначенияИС.МенеджерОбъектаПоПолномуИмени("РегистрСведений.НапоминанияПользователяИСМП");
				СрокНапоминания = НапоминанияПользователяИСМП.СрокНапоминанияТекущегоПользователя();
				
				Если ВремяДействияТокена > ОповещатьЗа Тогда
					ОповеститьЧерез = ВремяДействияТокена - ОповещатьЗа;
				ИначеЕсли СрокНапоминания > ТекущаяДата Тогда
					ОповеститьЧерез = СрокНапоминания - ТекущаяДата;
				КонецЕсли;
				
				ТребуетсяАктуализацияТокена = ТребуетсяАктуализацияТокена
					Или ВремяДействияТокена <= ОповещатьЗа И СрокНапоминания <= ТекущаяДата;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Данные = Новый Структура;
		Данные.Вставить("ТипТокенаАвторизации",   ТипТокенаАвторизации);
		Данные.Вставить("Организация",            Организация);
		Данные.Вставить("ПроизводственныйОбъект", ПроизводственныйОбъект);
		Данные.Вставить("ДатаДействия",           ДатаДействияТокена);
		Данные.Вставить("ВремяДействия",          ВремяДействияТокена);
		Данные.Вставить("Отсутствует",            ТокенОтсутствует);
		Данные.Вставить("Просрочен",              ТокенПросрочен);
		Данные.Вставить("ТребуетсяАктуализация",  ТребуетсяАктуализацияТокена);
		Данные.Вставить("ОповещениеИспользуется", ОповещениеИспользуется);
		Данные.Вставить("ОповещатьЗа",            ОповещатьЗа);
		Данные.Вставить("ОповеститьЧерез",        ОповеститьЧерез);
		
		Результат.Добавить(Данные);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет запрос ключа сессии для организации с учетом результата подписания.
// 
// Параметры:
// 	ПараметрыЗапросовПоОрганизациям - (См. ИнтерфейсАвторизацииИСМПСлужебныйКлиент.РезультатПодписания).
// Возвращаемое значение:
// 	Соответствие - Результат запроса ключей сессий по организациям.
Функция ЗапроситьКлючиСессий(ПараметрыЗапросовПоОрганизациям) Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие;
	
	Для Каждого ПараметрыЗапросаПоОрганизации Из ПараметрыЗапросовПоОрганизациям Цикл
		
		РезультатЗапросаКлючаСессии = ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации);
		
		Если РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии <> Неопределено Тогда
			
			УстановитьКлючСессии(
				ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса,
				РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии);
			
			// Ключ сессии обновлен
			ВозвращаемоеЗначение.Вставить(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация, Истина);
			
		Иначе
			
			// Ключ сессии не обновлен
			ВозвращаемоеЗначение.Вставить(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация, РезультатЗапросаКлючаСессии.ТекстОшибки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти