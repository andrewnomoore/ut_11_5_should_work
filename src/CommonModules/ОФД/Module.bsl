///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОФД".
// ОбщийМодуль.ОФД.
//
// Серверные процедуры получения данных от ОФД и создания настроек интеграции:
//  - определение доступности настроек подключения, а также получения настроек;
//  - определение доступности получения данных от сервиса ОФД;
//  - получение оборотов и чеков кассовой смены;
//  - получение данных продаж за период;
//  - получение описания и запись таблицы с результатами загрузки данных продаж.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет доступность использования функциональности подключения
// к ОФД на основании прав доступа пользователя.
//
// Возвращаемое значение:
//  Булево - если Истина, настройка подключения к ОФД доступна.
//
Функция НастройкаПодключенияДоступна() Экспорт
	
	Возврат ОФДПовтИсп.НастройкаПодключенияДоступна();
	
КонецФункции

// Определяет доступность использования функциональности выполнения операций
// на основании прав доступа пользователя.
//
// Возвращаемое значение:
//  Булево - если Истина, получение данных из ОФД доступно.
//
Функция ПолучениеДанныхИзОФДДоступно() Экспорт
	
	Возврат ОФДПовтИсп.ПолучениеДанныхИзОФДДоступно();
	
КонецФункции

// Проверяет наличие настройки подключения кассы.
//
// Параметры:
//  Касса - ОпределяемыйТИП.КассаОФДБИП - касса по которой выполняется запрос.
//
// Возвращаемое значение:
//  Булево - если Истина, настройка подключения выполнена.
//
Функция ПодключениеНастроено(Касса) Экспорт
	
	Возврат ОФДСлужебный.ПодключениеНастроено(Касса);
	
КонецФункции

// Возвращает значения показателей смены по переданным параметрам.
//
// Параметры:
//  Касса - ОпределяемыйТип.КассаОФДБИП - Касса, по которой необходимо получить данные.
//  НомерСмены- Число - Номер смены по которой необходимо получить данные.
// Возвращаемое значение:
//  Структура - результат выполнения:
//    * ДанныеСмены - Структура, Неопределено - данные смены по сведениям ОФД:
//      ** ДатаОткрытия - Дата - Дата открытия смены;
//      ** ДатаЗакрытия - Дата - Дата закрытия смены;
//      ** КоличествоЧеков - Число - Общее количество чеков за смену;
//      ** СуммаПрихода - Число - Сумма прихода за смену;
//      ** СуммаВозвратаПрихода - Число - Сумма возврата прихода за смену;
//      ** СуммаРасхода - Число - Сумма расхода за смену;
//      ** СуммаВозвратаРасхода - Число - Сумма возврата расхода за смену;
//      ** СуммаНаличными - Число - Сумма наличными за смену;
//      ** СуммаЭлектронными - Число - Сумма электронными за смену;
//      ** СуммаПредоплатами - Число - Сумма предоплатами за смену;
//      ** СуммаПостоплатами- Число - Сумма постоплатами за смену.
//    * КодОшибки - Строка - строковый код возникшей ошибки, который
//        может быть обработан вызывающим методом:
//        - <Пустая строка> - создание нового заказа выполнено успешно;
//        - "НеверныйФорматЗапроса" - передан некорректный запрос или настройка подключения;
//        - "НеверныйЛогинИлиПароль" - неверный логин или пароль или параметры
//          подключения к ОФД;
//        - "ОтсутствуетДоступКСервису" - у пользователя нет доступа к сервису;
//        - "ТребуетсяОплата" - у пользователя отсутствует оплата сервиса;
//        - "ПревышеноКоличествоПопыток" - превышено количество попыток
//          обращения к сервису с некорректным логином и паролем;
//        - "ОшибкаПодключения" - ошибка при подключении к сервису;
//        - "ОшибкаСервиса" - внутренняя ошибка сервиса;
//        - "НеизвестнаяОшибка" - при получении информации возникла
//          неизвестная (не обрабатываемая) ошибка;
//        - "СервисВременноНеДоступен" - на сервере ведутся регламентные работы;
//    * СообщениеОбОшибке  - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
//    * ИнформацияОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для администратора.
//
Функция ОборотыКассовойСмены(Касса, НомерСмены) Экспорт
	
	Если Не ОФДПовтИсп.ПолучениеДанныхИзОФДДоступно() Тогда
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа. Пользователю запрещено получение данных от ОФД.
			|Обратитесь к администратору.'");
	КонецЕсли;
	
	РезультатОперации = ОФДСлужебный.НовыйРезультатОперации();
	РезультатОперации.Вставить("ДанныеСмены", Неопределено);
	ОФДСлужебный.ПроверитьНастройкиПодключения(Касса, РезультатОперации);
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		Возврат РезультатОперации;
	КонецЕсли;
	
	Возврат СервисИнтеграцииСОФД.ОборотыКассовойСмены(Касса, НомерСмены);
	
КонецФункции

// Возвращает список чеков по смене.
//
// Параметры:
//  Касса - ОпределяемыйТип.КассаОФДБИП - касса, по которой выполняется запрос.
//  НомерСмены- Число - номер смены по которой необходимо получить данные.
// Возвращаемое значение:
//  Структура - результат выполнения:
//    * ДанныеЧеков - Массив из Структура, Неопределено - данные чеков по смене по сведениям ОФД:
//      ** ДатаЧека - Дата - Дата фискализации чека;
//      ** ФискальныйНомерЧека - Число - Фискальный номер документа;
//      ** НомерЧекаЗаСмену - Число - Номер чека в смене;
//      ** ПризнакРасчета - Строка - Идентификатор признака расчета. Может принимать одно следующих значений - 
//        ПРИХОД, ВОЗВРАТПРИХОДА, РАСХОД, ВОЗВРАТРАСХОДА;
//      ** СуммаНаличными - Число - Сумма наличными за смену;
//      ** СуммаЭлектронными - Число - Сумма электронными за смену;
//      ** СуммаПредоплатами - Число - Сумма предоплатами за смену;
//      ** СуммаПостоплатами- Число - Сумма постоплатами за смену.
//    * КодОшибки - Строка - строковый код возникшей ошибки, который
//        может быть обработан вызывающим методом:
//        - <Пустая строка> - создание нового заказа выполнено успешно;
//        - "НеверныйФорматЗапроса" - передан некорректный запрос или настройка подключения;
//        - "НеверныйЛогинИлиПароль" - неверный логин или пароль или параметры
//          подключения к ОФД;
//        - "ОтсутствуетДоступКСервису" - у пользователя нет доступа к сервису;
//        - "ТребуетсяОплата" - у пользователя отсутствует оплата сервиса;
//        - "ПревышеноКоличествоПопыток" - превышено количество попыток
//          обращения к сервису с некорректным логином и паролем;
//        - "ОшибкаПодключения" - ошибка при подключении к сервису; 
//        - "ОшибкаСервиса" - внутренняя ошибка сервиса;
//        - "НеизвестнаяОшибка" - при получении информации возникла
//          неизвестная (не обрабатываемая) ошибка;
//        - "СервисВременноНеДоступен" - на сервере ведутся регламентные работы;
//    * СообщениеОбОшибке  - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
//    * ИнформацияОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для администратора.
//
Функция ЧекиКассовойСмены(Касса, НомерСмены) Экспорт
	
	Если Не ОФДПовтИсп.ПолучениеДанныхИзОФДДоступно() Тогда
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа. Пользователю запрещено получение данных от ОФД.
			|Обратитесь к администратору.'");
	КонецЕсли;
	
	РезультатОперации = ОФДСлужебный.НовыйРезультатОперации();
	РезультатОперации.Вставить("ДанныеЧеков", Неопределено);
	ОФДСлужебный.ПроверитьНастройкиПодключения(Касса, РезультатОперации);
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		Возврат РезультатОперации;
	КонецЕсли;
	
	Возврат СервисИнтеграцииСОФД.ЧекиКассовойСмены(Касса, НомерСмены);
	
КонецФункции

// Возвращает данные продаж за период из сервиса.
//
// Параметры:
//  Касса - ОпределяемыйТип.КассаОФДБИП - касса по которой выполняется запрос.
//  НачалоПериода - Дата - дата начало получения данных продаж;
//  КонецПериода - Дата - дата окончания получения данных продаж.
//
// Возвращаемое значение:
//  Структура - результат выполнения.
//    * ДанныеСмен - Массив из Структура, Неопределено - данные смен по сведениям ОФД:
//      ** ДатаОткрытия - Дата - Дата открытия смены;
//      ** ДатаЗакрытия - Дата - Дата закрытия смены;
//      ** НомерСмены - Число - Номер смены;
//      ** ДанныеЧеков - Массив из Структура - данные чеков по смене;
//        *** ДатаЧека - Дата - Дата фискализации чека;
//        *** НомерЗаСмену - Число - Номер чека в смене;
//        *** ФискальныйНомерЧека - Число - Фискальный номер документа;
//        *** ЧекКоррекции - Булево - Фискальный номер документа;
//        *** ДанныеКоррекции - Структура, Неопределено - данные коррекции,
//          заполняется когда чек является чеком коррекции:
//          **** ТипКоррекции - Строка - Идентификатор типа коррекции. Может принимать одно следующих значений:
//            САМОСТОЯТЕЛЬНО, ПОПРЕДПИСАНИЮ;
//          **** ДатаКорректируемогоРасчета - Дата - Дата корректируемого расчета;
//          **** ФискальныйНомер - Число, Неопредеделено - Фискальный номер корректируемого документа
//            Неопределено - данные отсутствуют;
//          **** НомерПредписания - Строка - Номер предписания налогового органа.
//        *** СистемаНалогообложения - Строка - Идентификатор системы налогообложения. Может принимать одно следующих значений:
//          ОСН, УПРОЩЕННАЯДОХОД, УПРОЩЕННАЯДОХОДРАСХОД, ЕНВД, ЕСН, ПАТЕНТ;
//        *** ПризнакРасчета - Строка - Идентификатор признака расчета. Может принимать одно следующих значений:
//          ПРИХОД, ВОЗВРАТПРИХОДА, РАСХОД, ВОЗВРАТРАСХОДА;
//        *** ДанныеПоРасчетам - Структура - Содержит данные по видам расчетов:
//          **** СуммаНаличными - Число - Сумма наличными за смену;
//          **** СуммаЭлектронными - Число - Сумма электронными за смену;
//          **** СуммаПредоплатами - Число - Сумма предоплатами за смену;
//          **** СуммаПостоплатами- Число - Сумма постоплатами за смену;
//        *** Товары - Массив из Структура - содержит описание товарных позиций чека:
//          **** Наименование - Строка, Неопределено - Наименование предмета расчета. Неопределено - данные отсутствуют;
//          **** Цена - Число, Неопределено - Стоимость единицы предмета расчета. Неопределено - данные отсутствуют;
//          **** Количество - Число, Неопределено - Количество единиц предмета расчета. Неопределено - данные отсутствуют;
//          **** Сумма - Число, Неопределено - Сумма (с учетом скидок) по предмету расчета. Неопределено - данные отсутствуют;
//          **** СтавкаНДС - Число, Неопределено - Процент ставки НДС Может принимать одно следующих значений:
//            1 - ставка НДС 20%;
//            2 - ставка НДС 10%;
//            3 - ставка НДС 20/120%;
//            4 - ставка НДС 10/110%;
//            5 - ставка НДС 0%;
//            6 - НДС не облагается;
//            Неопределено - данные отсутствуют;
//          **** ПризнакПредметаРасчета - Число, Неопределено - Идентификатор признака расчета. Может принимать одно следующих значений:
//            1 - Товар;
//            2 - Подакцизный товар;
//            3 - Работа;
//            4 - Услуга;
//            5 - Ставка азартной игры;
//            6 - Выигрыш азартной игры;
//            7 - Лотерейный билет;
//            8 - Выигрыш лотереи;
//            9 - Предоставление РИД;
//            10 - Платеж;
//            11 - Агентское вознаграждение;
//            12 - Выплата;
//            13 - Иной предмет расчета;
//            14 - Имущественное право;
//            15 - Внереализационный доход;
//            16 - Страховые взносы;
//            17 - Торговый сбор;
//            18 - Курортный сбор;
//            19 - Залог;
//            20 - Расход;
//            21 - Обязательное пенсионное страхование ИП;
//            22 - Обязательное пенсионное страхование;
//            23 - Обязательное медицинское страхование ИП;
//            24 - Обязательное медицинское страхование;
//            25 - Обязательное социальное страхование;
//            26 - Платеж казино;
//            27 - Выдача денежных средств;
//            30 - Подакцизный товар маркируемый СИ Не имеющий КМ;
//            31 - Подакцизный товар маркируемый СИ имеющий КМ;
//            32 - Товар маркируемый СИ не имеющийКМ;
//            33 - ТоварМаркируемыйСИИмеющийКМ;
//            Неопределено - данные отсутствуют;
//          **** КодПредметаРасчета - Структура, Неопределено - Содержит описание кода предмета расчета:
//            ***** ТипКода - Строка, Неопределено - Идентификатор типа кода предмета расчета.
//              Может принимать одно следующих значений: EAN13, EAN8, EGAIS2, EGAIS3, F1, F2, F3,
//                F4,F5,F6, GS1, GS1M, ITF14, KMK, MI, UNDEFINED. Неопределено - когда значение не передано.
//            ***** ЗначениеКода - Строка - Значение кода предмета расчета.
//          **** ПризнакСпособаРасчета - Строка - Идентификатор способа расчета. Может принимать одно следующих значений:
//            ПРЕДОПЛАТА100%, ПРЕДОПЛАТА, АВАНС, ПОЛНЫЙРАСЧЕТ, ЧАСТИЧНЫЙРАСЧЕТКРЕДИТ, КРЕДИТ, ОПЛАТАКРЕДИТА. Пустая строка
//            в тех случаях, когда значение не передано;
//          **** МераКоличестваПредметаРасчета - Структура - Содержит описание меры количества предмета расчета:
//            ***** Идентификатор - Число, Неопределено - Идентификатор меры единицы предмета расчета.
//              Может принимать одно следующих значений:
//                0 - Штука;
//                10 -Грамм;
//                11 - Килограмм;
//                12 - Тонна;
//                20 - Сантиметр;
//                21 - Дециметр;
//                22 - Метр;
//                30 - Квадратный сантиметр;
//                31 - Квадратный дециметр;
//                32 - Квадратный метр;
//                40 - Миллилитр;
//                41 - Литр;
//                42 - Кубический метр;
//                50 - Киловатт/час;
//                51 - Гигакалория;
//                70 - Сутки/день;
//                71 - Час;
//                72 - Минута;
//                73 - Секунда;
//                80 - Килобайт;
//                81 - Мегабайт;
//                82 - Гигабайт;
//                83 - Терабайт;
//                255 - Иные единицы измерения;
//                Неопределено - нет данных.
//            ***** Значение - Строка, Неопределено - Значение меры единицы предмета расчета,
//            заполняется в случаях когда Идентификатор = Неопределено. Неопределено - нет данных.
//          **** ДанныеАгента - Структура, Неопределено - Содержит данные об агенте:
//            ***** Наименование - Строка, Неопределено - Наименование оператора перевода;
//            ***** ИНН - Строка, Неопределено - ИНН оператора перевода
//          **** ДанныеПоставщика - Структура, Неопределено - Содержит данные о поставщике:
//            ***** Наименование - Строка, Неопределено - Наименование поставщика;
//            ***** ИНН - Строка, Неопределено - ИНН поставщика
//    * КодОшибки - Строка - строковый код возникшей ошибки, который
//        может быть обработан вызывающим методом:
//        - <Пустая строка> - создание нового заказа выполнено успешно;
//        - "НеверныйФорматЗапроса" - передан некорректный запрос или настройка подключения;
//        - "НеверныйЛогинИлиПароль" - неверный логин или пароль или параметры
//          подключения к ОФД;
//        - "ОтсутствуетДоступКСервису" - у пользователя нет доступа к сервису;
//        - "ТребуетсяОплата" - у пользователя отсутствует оплата сервиса;
//        - "ПревышеноКоличествоПопыток" - превышено количество попыток
//          обращения к сервису с некорректным логином и паролем;
//        - "ОшибкаПодключения" - ошибка при подключении к сервису;
//        - "ОшибкаСервиса" - внутренняя ошибка сервиса;
//        - "НеизвестнаяОшибка" - при получении информации возникла
//          неизвестная (не обрабатываемая) ошибка;
//        - "СервисВременноНеДоступен" - на сервере ведутся регламентные работы;
//    * СообщениеОбОшибке  - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
//    * ИнформацияОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для администратора.
//
Функция ПродажиЗаПериод(Касса, НачалоПериода, КонецПериода) Экспорт
	
	Если Не ОФДПовтИсп.ПолучениеДанныхИзОФДДоступно() Тогда
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа. Пользователю запрещено получение данных от ОФД.
			|Обратитесь к администратору.'");
	КонецЕсли;
	
	РезультатОперации = ОФДСлужебный.НовыйРезультатОперации();
	РезультатОперации.Вставить("ДанныеСмен", Новый Массив);
	ОФДСлужебный.ПроверитьНастройкиПодключения(Касса, РезультатОперации);
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		Возврат РезультатОперации;
	КонецЕсли;
	
	Возврат СервисИнтеграцииСОФД.ПродажиЗаПериод(Касса, НачалоПериода, КонецПериода);
	
КонецФункции

// Записывает соответствие документов фискальным данным из сервиса ОФД.
//
// Параметры:
//  Касса - ОпределяемыйТип.КассаОФДБИП - касса по которой выполняется запрос.
//  РезультатЗагрузки - Массив из Соответствие - Описывает соответствие документов фискальным данным:
//    * Ключ - ОпределяемыйТип.ДокументОФДБИП - документ созданный по данным сервиса ОФД;
//    * Значение - ТаблицаЗначений - содержит перечень фискальных данных по которым был создан документ.
//      см. ОФД.НовыйОписаниеТаблицыФискальныхДанных
//
Процедура ЗаписатьРезультатЗагрузкиДанныхПродаж(Касса, РезультатЗагрузки) Экспорт
	
	РегистрыСведений.ДокументыОФД.СохранитьДанныеЗагрузки(
		Касса,
		РезультатЗагрузки);
	
КонецПроцедуры

// Возвращает результат записи соответствия документов фискальным данным из сервиса ОФД.
//
// Возвращаемое значение:
//  ТаблицаЗначений - содержит описание результатов загрузки. Колонки::
//    * НомерСмены- Число - Номер смены;
//    * НомерЧекаЗаСмену- Число - Номер чека в смене;
//    * ФискальныйНомер - Число - Фискальный номер чека;
//
Функция НовыйОписаниеТаблицыФискальныхДанных() Экспорт
	
	ФискальныеДанные = Новый ТаблицаЗначений;
	
	ФискальныеДанные.Колонки.Добавить("НомерСмены",       Новый ОписаниеТипов("Число"));
	ФискальныеДанные.Колонки.Добавить("НомерЧекаЗаСмену", Новый ОписаниеТипов("Число"));
	ФискальныеДанные.Колонки.Добавить("ФискальныйНомер",  Новый ОписаниеТипов("Число"));
	
	Возврат ФискальныеДанные;
	
КонецФункции

#КонецОбласти