#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//  Формат - Строка - см. ЭлектронныеДокументыЭДО.ПоддерживаемыеФорматы
//  ТипДокумента - ПеречислениеСсылка.ТипыДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ПоддерживаетФормат(Формат, ТипДокумента) Экспорт
	ПоддерживаемыеФорматы = ЭлектронныеДокументыЭДО.ПоддерживаемыеФорматы();
	Возврат Формат = ПоддерживаемыеФорматы.ФНС.АктПриемкиСтроительныхРаботУслуг.ИнформацияПодрядчика;
КонецФункции

// Служебное имя формата.
// 
// Возвращаемое значение:
//  Строка
Функция ИмяФормата() Экспорт
	Возврат ПространствоИмен();
КонецФункции

// Параметры:
//  ИмяФайла - Строка
// 
// Возвращаемое значение:
//  Булево
//
Функция ЭтоФайлФормата(ИмяФайла) Экспорт
	Префикс = ПрефиксФормата();
	Возврат СтрНачинаетсяС(ИмяФайла, Префикс);
КонецФункции

// Возвращаемое значение:
//  Строка
//
Функция КНД() Экспорт
	Возврат "1110336";
КонецФункции

// Возвращаемое значение:
//  Строка
//
Функция ПрефиксФормата() Экспорт
	Возврат "ON_AKTREZRABZ";
КонецФункции

// Параметры:
//  ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//  Параметры - см. ИнтеграцияЭДО.НовыеПараметрыФормированияДанныхОбъектаУчета
// 
// Возвращаемое значение:
//  см. ИнтеграцияЭДО.НовыйРезультатФормированияДанныхОбъектаУчета
//
Функция ОписаниеДанныхОбъектаУчета(ОбъектУчета, Параметры) Экспорт
	КонструкторЭД = Создать();
	Отказ = Ложь;
	КонструкторЭД.ИнформацияЗаказчика().Составитель = ОбщегоНазначенияБЭД.ДанныеЮрФизЛица(
		Параметры.Отправитель).ОфициальноеНаименование;
	ОбменСКонтрагентамиПереопределяемый.ЗаполнитьДанныеАктОПриемкеВыполненныхРаботВСтроительстве_ИнформацияЗаказчика(
		ОбъектУчета, КонструкторЭД, Отказ);
	Если Отказ Тогда
		Возврат ИнтеграцияЭДО.НовыйРезультатФормированияДанныхОбъектаУчета();
	КонецЕсли;
	Результат = ИнтеграцияЭДО.НовыйРезультатФормированияДанныхОбъектаУчета();
	Результат.Данные = КонструкторЭД;
	Результат.Основания.Добавить(ОбъектУчета);
	Возврат Результат;
КонецФункции

// Сформировать документ.
// 
// Параметры:
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
// 
// Возвращаемое значение:
//  см. ФорматыЭДО_ФНС.НовыйРезультатЗаполненияДокумента
//
Функция СформироватьДокумент(КонструкторЭД) Экспорт
	Документ = ФорматыЭДО_ФНС.НовыйРезультатЗаполненияДокумента();
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	Файл = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.Файл);
	ЗаполнитьФайлИнформацииЗаказчика(Файл, КонструкторЭД, Документ.Ошибки);
	Если Не ЗначениеЗаполнено(Документ.Ошибки) Тогда
		ДвоичныеДанные = РаботаСФайламиБЭД.XDTOВДвоичныеДанные(Файл, Ложь, , "Файл");
		ПространствоИмен = КонструкторЭД.ПространствоИмен();
		Документ.ДанныеОсновногоФайла.ДвоичныеДанные = ОбщегоНазначенияБЭД.УдалитьПространствоИмен(ДвоичныеДанные,
			ПространствоИмен);
		Расширение = "xml";
		ИмяФайла = КонструкторЭД.ИдентификаторФайла();
		Документ.ДанныеОсновногоФайла.ИмяФайла = СтрШаблон("%1.%2", ИмяФайла, Расширение);
	КонецЕсли;
	Возврат Документ;
КонецФункции

// Параметры:
//  ДанныеФайлаЭД - ОбъектXDTO:
//  * Документ - ОбъектXDTO:
//  ** ПодписантЗак - СписокXDTO
//  ДанныеПодписанта - см. ФорматыЭДО.НовыеДанныеПодписанта
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьДанныеПодписанта(ДанныеФайлаЭД, ДанныеПодписанта, Ошибки) Экспорт
	Если Не ЗначениеЗаполнено(ДанныеПодписанта.Организация) Или Не ЗначениеЗаполнено(
		ДанныеПодписанта.СертификатПодписи) Тогда
		ТекстОшибки = НСтр("ru = 'Не удалось заполнить подписанта. Не заполнены организация или сертификат подписи'");
		ОбщегоНазначенияБЭД.ДобавитьОшибку(Ошибки, ТекстОшибки);
		Возврат;
	КонецЕсли;
	КонструкторЭД = Создать();
	Подписант = КонструкторЭД.НовыйПодписант();
	Статусы = КонструкторЭД.СтатусыПодписанта();
	Если ЭлектронныеДокументыЭДО.ТребуетсяМашиночитаемаяДоверенность(ДанныеПодписанта.Организация,
		ДанныеПодписанта.СертификатПодписи) Тогда
		Подписант.Статус = Статусы.ПолномочияНаОснованииЭлектроннойДоверенности;
	Иначе
		Подписант.Статус = Статусы.ПолномочияБезДоверенности;
	КонецЕсли;
	Подписант.ТипПодписи = КонструкторЭД.ТипыПодписи().УсиленнаяКвалифицированная;
	РеквизитыСертификата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеПодписанта.СертификатПодписи,
		"Должность, Фамилия, Имя, Отчество");
	Подписант.Должность = РеквизитыСертификата.Должность;
	Подписант.ФИО = КонструкторЭД.НовыеФИО();
	ЗаполнитьЗначенияСвойств(Подписант.ФИО, РеквизитыСертификата);
	Если ЗначениеЗаполнено(ДанныеПодписанта.Доверенность) Тогда
		РеквизитыДоверенности = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеПодписанта.Доверенность,
			"НомерДоверенности, СведенияОбИнформационнойСистеме, ДатаВыдачи, ДатаСоздания, Код");
		Подписант.ЭлектроннаяДоверенность = КонструкторЭД.НоваяЭлектроннаяДоверенность();
		Подписант.ЭлектроннаяДоверенность.Номер = РеквизитыДоверенности.НомерДоверенности;
		Подписант.ЭлектроннаяДоверенность.СистемаОтменыДоверенности =
			РеквизитыДоверенности.СведенияОбИнформационнойСистеме;
		Подписант.ЭлектроннаяДоверенность.ДатаВыдачи = РеквизитыДоверенности.ДатаВыдачи;
		Подписант.ЭлектроннаяДоверенность.ДатаВнутреннейРегистрации = РеквизитыДоверенности.ДатаСоздания;
		Подписант.ЭлектроннаяДоверенность.ВнутреннийНомер = РеквизитыДоверенности.Код;
	КонецЕсли;
	ПодписантЗаказчика = КонструкторЭД.ПолучитьXDTOОбъект(КонструкторЭД.ТипыОбъектов().ПодписантЗак);
	ЗаполнитьСведенияОПодписанте(ПодписантЗаказчика, Подписант, КонструкторЭД, Ошибки);
	ДанныеФайлаЭД.Документ.ПодписантЗак.Очистить();
	ДанныеФайлаЭД.Документ.ПодписантЗак.Добавить(ПодписантЗаказчика);
КонецПроцедуры

// Возвращаемое значение:
//  Строка
//
Функция ПространствоИмен() Экспорт
	Возврат "ON_AKTREZRABZ_1_971_02_01_00_01";
КонецФункции

// При определении соответствия титулов.
// 
// Параметры:
//  СоответствиеОсновногоТитулаОтветному - Соответствие Из КлючИЗначение:
//  * Ключ - Строка - пространство имен основного титула
//  * Значение - Строка - пространство имен ответного титула
//
Процедура ЗаполнитьСоответствиеТитулов(СоответствиеОсновногоТитулаОтветному) Экспорт
	ОсновнойТитул = Обработки.ФорматАктПриемкиСтроительныхРаботИнформацияПодрядчикаЭДО.ПространствоИмен();
	ОтветныйТитул = ПространствоИмен();
	СоответствиеОсновногоТитулаОтветному.Вставить(ОсновнойТитул, ОтветныйТитул);
КонецПроцедуры

// Возвращаемое значение:
//  Булево
//
Функция ЗаполнениеДанныхПодписантаДоступно() Экспорт
	Возврат Истина;
КонецФункции

// Поддерживаемые типы документов.
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.ТипыДокументовЭДО
//
Функция ПоддерживаемыеТипыДокументов() Экспорт
	ПоддерживаемыеТипы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		Перечисления.ТипыДокументовЭДО.АктПриемкиСтроительныхРаботУслуг);
	Возврат ПоддерживаемыеТипы;
КонецФункции

// Возвращаемое значение:
//  ФиксированнаяСтруктура:
// * ИностраннаяОрганизация - Тип
// * ИностранныйГражданин - Тип
// * ОрганИсполнительнойВласти - Тип
// * ЮридическоеЛицо - Тип
// * ФизическоеЛицо - Тип
//
Функция ТипыСубъектовДокумента() Экспорт
	Типы = Новый Структура;
	Шаблон = "ОбработкаТабличнаяЧастьСтрока.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.%1";
	ИностраннаяОрганизация = СтрШаблон(Шаблон, "ИдентифицирующиеПризнакиИностранныхОрганизаций");
	Типы.Вставить("ИностраннаяОрганизация", Тип(ИностраннаяОрганизация));
	ИностранныйГражданин = СтрШаблон(Шаблон, "ИдентифицирующиеПризнакиИностранныхГраждан");
	Типы.Вставить("ИностранныйГражданин", Тип(ИностранныйГражданин));
	ОрганИсполнительнойВласти = СтрШаблон(Шаблон, "ИдентифицирующиеПризнакиОргановИсполнительнойВласти");
	Типы.Вставить("ОрганИсполнительнойВласти", Тип(ОрганИсполнительнойВласти));
	ЮридическоеЛицо = СтрШаблон(Шаблон, "ИдентифицирующиеПризнакиЮрЛиц");
	Типы.Вставить("ЮридическоеЛицо", Тип(ЮридическоеЛицо));
	ФизическоеЛицо = СтрШаблон(Шаблон, "ИдентифицирующиеПризнакиФизЛиц");
	Типы.Вставить("ФизическоеЛицо", Тип(ФизическоеЛицо));
	Возврат Новый ФиксированнаяСтруктура(Типы);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеЭлектронногоДокумента

// BSLLS:Typo-off

// Заполнение объекта из таблицы 7.1 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьФайлИнформацииЗаказчика(Объект, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	ИдентификаторФайла = КонструкторЭД.ИдентификаторФайла();
	ДополнительныеДанные = КонструкторЭД.ПолучитьДополнительныеДанныеДляФормирования();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдФайл", ИдентификаторФайла, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВерсПрог", ДополнительныеДанные.ВерсияПрограммы, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВерсФорм", "1.00", Истина, Ошибки);
	Документ = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.Документ);
	ЗаполнитьДокументИнформацииЗаказчика(Документ, КонструкторЭД, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Документ", Документ, Истина, Ошибки);
КонецПроцедуры

// Заполнение объекта из таблицы 7.2 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO:
//  * ПодписантЗак - СписокXDTO
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьДокументИнформацииЗаказчика(Объект, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	ИнформацияЗаказчика = КонструкторЭД.ИнформацияЗаказчика();
	КНД = КНД();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "КНД", КНД, Истина, Ошибки);
	ПараметрыОсновногоТитула = КонструкторЭД.ПолучитьПараметрыОсновногоТитула();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатИнфЗак", ПараметрыОсновногоТитула.ДатаФормированияФайла,
		Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВрИнфЗак", ПараметрыОсновногоТитула.ВремяФормированияФайла,
		Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "НаимЭконСубСост", ИнформацияЗаказчика.Составитель, Истина, Ошибки);
	Если ЗначениеЗаполнено(ИнформацияЗаказчика.ДоверенностьНаСоставление) Тогда
		Доверенность = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИдРеквДокТип);
		ЗаполнитьИдентифицирующиеПризнакиДокумента(Доверенность, ИнформацияЗаказчика.ДоверенностьНаСоставление,
			КонструкторЭД, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ОснДоверОргСост", Доверенность, Ложь, Ошибки);
	КонецЕсли;
	СведенияОтправителя = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИдИнфПодр);
	ЗаполнитьИнформациюОФайлеОбменаПодрядчика(СведенияОтправителя, КонструкторЭД, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдИнфПодр", СведенияОтправителя, Истина, Ошибки);
	СведенияОПриемкеРезультатов = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.СодФХЖ4);
	ЗаполнитьСведенияОПриемкеРезультатов(СведенияОПриемкеРезультатов, ИнформацияЗаказчика, КонструкторЭД, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СодФХЖ4", СведенияОПриемкеРезультатов, Истина, Ошибки);
	Подписант = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ПодписантЗак);
	ДанныеПодписанта = КонструкторЭД.НовыйПодписант();
	ДанныеПодписанта.ФИО = КонструкторЭД.НовыеФИО("-", "-", "-");
	ЗаполнитьСведенияОПодписанте(Подписант, ДанныеПодписанта, КонструкторЭД, Ошибки);
	Объект.ПодписантЗак.Добавить(Подписант);
КонецПроцедуры

// Заполнение объекта из таблицы 7.3 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO:
//  * ЭП - СписокXDTO
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьИнформациюОФайлеОбменаПодрядчика(Объект, КонструкторЭД, Ошибки)
	ДопДанные = КонструкторЭД.ПолучитьДополнительныеДанныеДляФормирования();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдФайлИнфПодр", ДопДанные.УникальныйИдентификатор, Истина, Ошибки);
	ПараметрыОсновногоТитула = КонструкторЭД.ПолучитьПараметрыОсновногоТитула();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаФайлИнфПодр", ПараметрыОсновногоТитула.ДатаФормированияФайла,
		Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВремяФайлИнфПодр",
		ПараметрыОсновногоТитула.ВремяФормированияФайла, Истина, Ошибки);
	Если ЗначениеЗаполнено(ДопДанные.ПодписиОснования) Тогда
		Для Каждого Подпись Из ДопДанные.ПодписиОснования Цикл
			Объект.ЭП.Добавить(Подпись);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.4 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  ИнформацияЗаказчика - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИнформацияЗаказчика
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьСведенияОПриемкеРезультатов(Объект, ИнформацияЗаказчика, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	ПараметрыОсновногоТитула = КонструкторЭД.ПолучитьПараметрыОсновногоТитула();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "НомПостДок", ПараметрыОсновногоТитула.НомерАкта, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаПостДок", ПараметрыОсновногоТитула.ДатаАкта, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВидОпер", ИнформацияЗаказчика.ВидОперации, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ПрГосМун", ?(ИнформацияЗаказчика.ДляГосИМуниципальныхНужд, "1",
		"0"), Истина, Ошибки);
	ИнформацияОПриемке = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.СвПрием);
	ЗаполнитьИнформациюОПриемкеРабот(ИнформацияОПриемке, ИнформацияЗаказчика, КонструкторЭД, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СвПрием", ИнформацияОПриемке, Истина, Ошибки);
	Если ЗначениеЗаполнено(ИнформацияЗаказчика.РешениеПоПредоставленнымРасчетам) Тогда
		РешениеПоРасчетам = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИзвОРасч);
		ЗаполнитьИзвещениеЗаказчикаОСогласииНесогласииСРасчетами(РешениеПоРасчетам,
			ИнформацияЗаказчика.РешениеПоПредоставленнымРасчетам, КонструкторЭД, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИзвОРасч", РешениеПоРасчетам, Ложь, Ошибки);
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.5 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  ИнформацияЗаказчика - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.ИнформацияЗаказчика
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьИнформациюОПриемкеРабот(Объект, ИнформацияЗаказчика, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СодОпер", ИнформацияЗаказчика.Содержание, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "КодСодОпер", ИнформацияЗаказчика.КодОперации, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИнфОтказПрием", ИнформацияЗаказчика.ПричиныОтказа, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИнфОНедостатк", ИнформацияЗаказчика.УстранимыеНедостатки, Ложь,
		Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СумНДФЛ", ИнформацияЗаказчика.СуммаНДФЛ, Ложь, Ошибки);
	КодыОпераций = КонструкторЭД.КодыОперации();
	ДатаРешения = ПредставлениеДаты(ИнформацияЗаказчика.ДатаРешения);
	Если ЗначениеЗаполнено(ИнформацияЗаказчика.Содержание) Или ИнформацияЗаказчика.КодОперации <> КодыОпераций.Отказ Тогда
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаПрин", ДатаРешения, Истина, Ошибки);
	Иначе
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаОтказПрин", ДатаРешения, Истина, Ошибки);
	КонецЕсли;
	Если ИнформацияЗаказчика.КодОперации = КодыОпераций.Отказ И ЗначениеЗаполнено(ИнформацияЗаказчика.ДокументОтказа) Тогда
		ДокументОтказа = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИдРеквДокТип);
		ЗаполнитьИдентифицирующиеПризнакиДокумента(ДокументОтказа, ИнформацияЗаказчика.ДокументОтказа, КонструкторЭД,
			Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдДокОтказ", ДокументОтказа, Истина, Ошибки);
	КонецЕсли;
	КодыСНедостатками = Новый Соответствие;
	КодыСНедостатками.Вставить(КодыОпераций.ПринятоСБезвозмезднымУстранениемНедостатков);
	КодыСНедостатками.Вставить(КодыОпераций.ПринятоСУменьшениемСтоимостиДоговора);
	КодыСНедостатками.Вставить(КодыОпераций.ПринятоСВозмещениемРасходов);
	Если КодыСНедостатками[ИнформацияЗаказчика.КодОперации] <> Неопределено И ЗначениеЗаполнено(
		ИнформацияЗаказчика.ДокументПодтвержденияНедостатков) Тогда
		ДокументНедостатков = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИдРеквДокТип);
		ЗаполнитьИдентифицирующиеПризнакиДокумента(ДокументОтказа, ИнформацияЗаказчика.ДокументОтказа, КонструкторЭД,
			Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдДокОНедостатк", ДокументНедостатков, Истина, Ошибки);
	КонецЕсли;
	Если ИнформацияЗаказчика.КодОперации = КодыОпераций.ПринятоСУменьшениемСтоимостиДоговора Тогда
		ИтогСУменьшениемСтоимости = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИтогУмСтоимДог);
		ЗаполнитьИтогиПринятияРаботСУстранимымиНедостатками(ИтогСУменьшениемСтоимости,
			ИнформацияЗаказчика.ИтогиПринятияНаУсловияхУменьшенияСтоимости, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИтогУмСтоимДог", ИтогСУменьшениемСтоимости, Истина, Ошибки);
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.6 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  ИтогиПринятияНаУсловияхУменьшенияСтоимости - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеИтогиПринятияНаУсловияхУменьшенияСтоимости
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьИтогиПринятияРаботСУстранимымиНедостатками(Объект, ИтогиПринятияНаУсловияхУменьшенияСтоимости,
	Ошибки)
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СтТовБезНДСИтог",
		ИтогиПринятияНаУсловияхУменьшенияСтоимости.Сумма, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СтТовУчНалИтог",
		ИтогиПринятияНаУсловияхУменьшенияСтоимости.СуммаСНДС, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИтогКПеречислОтч",
		ИтогиПринятияНаУсловияхУменьшенияСтоимости.ИтогоСУчетомУменьшенияСтоимостиДоговора, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИтогКПеречислСНач",
		ИтогиПринятияНаУсловияхУменьшенияСтоимости.ИтогоСНачалаСтроительстваСУчетомУменьшенияСтоимостиДоговора, Ложь,
		Ошибки);
	Если ЗначениеЗаполнено(ИтогиПринятияНаУсловияхУменьшенияСтоимости.СуммаНДС) Тогда
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СумНалИтог",
			ИтогиПринятияНаУсловияхУменьшенияСтоимости.СуммаНДС, Истина, Ошибки);
	Иначе
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ОтсСумНДС", "-", Истина, Ошибки);
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.7 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO:
//  * ИдНеучтенДок - СписокXDTO
//  * ИдЛишнДок - СписокXDTO
//  РешениеПоПредоставленнымРасчетам - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовоеРешениеПоПредоставленнымРасчетам
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьИзвещениеЗаказчикаОСогласииНесогласииСРасчетами(Объект, РешениеПоПредоставленнымРасчетам,
	КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ПричНесогРасч",
		РешениеПоПредоставленнымРасчетам.ПричинаНесогласия, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИзвПоРасч", РешениеПоПредоставленнымРасчетам.КодРешения, Истина,
		Ошибки);
	Если ЗначениеЗаполнено(РешениеПоПредоставленнымРасчетам.НеучтенныеДокументы) Тогда
		Для Каждого Документ Из РешениеПоПредоставленнымРасчетам.НеучтенныеДокументы Цикл
			ПризнакиДокумента = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИдРеквДокТип);
			ЗаполнитьИдентифицирующиеПризнакиДокумента(ПризнакиДокумента, Документ, КонструкторЭД, Ошибки);
			Объект.ИдНеучтенДок.Добавить(ПризнакиДокумента);
		КонецЦикла;
	КонецЕсли;
	Если ЗначениеЗаполнено(РешениеПоПредоставленнымРасчетам.ЛишниеДокументы) Тогда
		Для Каждого Документ Из РешениеПоПредоставленнымРасчетам.ЛишниеДокументы Цикл
			ПризнакиДокумента = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИдРеквДокТип);
			ЗаполнитьИдентифицирующиеПризнакиДокумента(ПризнакиДокумента, Документ, КонструкторЭД, Ошибки);
			Объект.ИдЛишнДок.Добавить(ПризнакиДокумента);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.8 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  Данные - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыйПодписант
//  КонструкторЭД - см. КонтекстЗаполненияОсновногоТитула
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьСведенияОПодписанте(Объект, Данные, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	Подписант = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ПодписантТип);
	ЗаполнитьСведенияОЛицеПодписывающемФайл(Подписант, Данные, КонструкторЭД, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Подписант", Подписант, Истина, Ошибки);
КонецПроцедуры

// Заполнение объекта из таблицы 7.9 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  Документ - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовоеОписаниеДокумента
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьИдентифицирующиеПризнакиДокумента(Объект, Документ, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	Реквизиты = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.РеквДокТип);
	ЗаполнитьРеквизитыДокумента(Реквизиты, Документ, КонструкторЭД, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ТипИдДок", Реквизиты, Истина, Ошибки);
КонецПроцедуры

// Заполнение объекта из таблицы 7.10 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO:
//  * ИдРекСост - СписокXDTO
//  Документ - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовоеОписаниеДокумента
//  КонструкторЭД - см. КонтекстЗаполненияОсновногоТитула
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьРеквизитыДокумента(Объект, Документ, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "НаимДок", Документ.Наименование, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "НомерДок", Документ.Номер, Ложь, Ошибки);
	ДатаДокумента = ПредставлениеДаты(Документ.Дата);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаДок", ДатаДокумента, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдДок", Документ.ГосНомер, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДопСведДок", Документ.ДополнительныеСведения, Ложь, Ошибки);
	Если ЗначениеЗаполнено(Документ.Стороны) Тогда
		Для Каждого Сторона Из Документ.Стороны Цикл
			НоваяЗапись = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ИдРекСостТип);
			ЗаполнитьИдентифицирующиеРеквизитыСубъектаДокумента(НоваяЗапись, Сторона, КонструкторЭД, Ошибки);
			Объект.ИдРекСост.Добавить(НоваяЗапись);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.11 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  Сторона - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиИностраннойОрганизации
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиИностранногоГражданина
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиОрганаИсполнительнойВласти
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиЮрЛица
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиФизЛица
//  КонструкторЭД - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьИдентифицирующиеРеквизитыСубъектаДокумента(Объект, Сторона, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	ТипыСторон = ТипыСубъектовДокумента();
	Если ТипЗнч(Сторона) = ТипыСторон.ИностранныйГражданин Или ТипЗнч(Сторона) = ТипыСторон.ИностраннаяОрганизация Тогда
		ДанныеИностранца = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ДаннИноТип);
		ЗаполнитьДанныеИностраннойОрганизацииГражданина(ДанныеИностранца, Сторона, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДаннИно", ДанныеИностранца, Истина, Ошибки);
	ИначеЕсли ТипЗнч(Сторона) = ТипыСторон.ОрганИсполнительнойВласти Тогда
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "НаимОИВ", Сторона.Наименование, Истина, Ошибки);
	ИначеЕсли ТипЗнч(Сторона) = ТипыСторон.ЮридическоеЛицо Тогда
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИННЮЛ", Сторона.ИНН, Истина, Ошибки);
	Иначе
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИННФЛ", Сторона.ИНН, Истина, Ошибки);
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.12 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  Сторона - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиИностраннойОрганизации
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиИностранногоГражданина
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиОрганаИсполнительнойВласти
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиЮрЛица
//          - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеПризнакиФизЛица
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьДанныеИностраннойОрганизацииГражданина(Объект, Сторона, Ошибки)
	ТипыСторон = ТипыСубъектовДокумента();
	ЭтоОрганизация = ТипЗнч(Сторона) = ТипыСторон.ИностраннаяОрганизация; 
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдСтат", ?(ЭтоОрганизация, "ИО", "ИГ"), Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Стран", Сторона.Страна, ЭтоОрганизация, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Наим", ?(ЭтоОрганизация, Сторона.Наименование, Сторона.ФИО),
		Не ЭтоОрганизация, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Идентиф", Сторона.Идентификатор, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИныеСвед", Сторона.ИныеСведения, Истина, Ошибки);
КонецПроцедуры

// Заполнение объекта из таблицы 7.13 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  Подписант - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыйПодписант
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьСведенияОЛицеПодписывающемФайл(Объект, Подписант, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СтатПодп", Подписант.Статус, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ТипПодпис", Подписант.ТипПодписи, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдСистХран", Подписант.URLДоверенности, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Должн", Подписант.Должность, Ложь, Ошибки);
	ФИО = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ФИОТип);
	ЗаполнитьФИО(ФИО, Подписант.ФИО, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ФИО", ФИО, Истина, Ошибки);
	Если ЗначениеЗаполнено(Подписант.ЭлектроннаяДоверенность) Тогда
		Доверенность = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.СвДовер);
		ЗаполнитьСведенияОбЭлектроннойДоверенности(Доверенность, Подписант.ЭлектроннаяДоверенность, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СвДовер", Доверенность, Ложь, Ошибки);
	КонецЕсли;
	Если ЗначениеЗаполнено(Подписант.БумажнаяДоверенность) Тогда
		Доверенность = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.СвДоверБум);
		ЗаполнитьСведенияОБумажнойДоверенности(Доверенность, Подписант.БумажнаяДоверенность, КонструкторЭД, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СвДоверБум", Доверенность, Ложь, Ошибки);
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.14 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  Доверенность - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НоваяЭлектроннаяДоверенность
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьСведенияОбЭлектроннойДоверенности(Объект, Доверенность, Ошибки)
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "НомДовер", Доверенность.Номер, Ложь, Ошибки);
	ДатаВыдачи = ПредставлениеДаты(Доверенность.ДатаВыдачи);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаНач", ДатаВыдачи, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВнНомДовер", Доверенность.ВнутреннийНомер, Ложь, Ошибки);
	ДатаРегистрации = ПредставлениеДаты(Доверенность.ДатаВнутреннейРегистрации);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаВнРегДовер", ДатаРегистрации, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СведСистОтм", Доверенность.СистемаОтменыДоверенности, Ложь, Ошибки);
КонецПроцедуры

// Заполнение объекта из таблицы 7.15 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  Доверенность - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НоваяБумажнаяДоверенность
//  КонструкторЭД - ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьСведенияОБумажнойДоверенности(Объект, Доверенность, КонструкторЭД, Ошибки)
	ТипыОбъектов = КонструкторЭД.ТипыОбъектов();
	ДатаВыдачи = ПредставлениеДаты(Доверенность.ДатаВыдачи);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ДатаНач", ДатаВыдачи, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВнНомДовер", Доверенность.ВнутреннийНомер, Ложь, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "СвИдДовер", Доверенность.СведенияОДоверителе, Ложь, Ошибки);
	Если ЗначениеЗаполнено(Доверенность.ПодписалФИО) Тогда
		ФИО = КонструкторЭД.ПолучитьXDTOОбъект(ТипыОбъектов.ФИОТип);
		ЗаполнитьФИО(ФИО, Доверенность.ПодписалФИО, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ФИО", ФИО, Ложь, Ошибки);
	КонецЕсли;
КонецПроцедуры

// Заполнение объекта из таблицы 7.19 формата.
// 
// Параметры:
//  Объект - ОбъектXDTO
//  ФИО - см. ОбработкаОбъект.ФорматАктПриемкиСтроительныхРаботИнформацияЗаказчикаЭДО.НовыеФИО
//  Ошибки - Неопределено
//         - Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Процедура ЗаполнитьФИО(Объект, ФИО, Ошибки)
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Фамилия", ФИО.Фамилия, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Имя", ФИО.Имя, Истина, Ошибки);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "Отчество", ФИО.Отчество, Ложь, Ошибки);
КонецПроцедуры

// BSLLS:Typo-on

#КонецОбласти

#Область Общее

// Параметры:
//  Дата - Дата
// 
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеДаты(Дата)
	Возврат Формат(Дата, "ДФ=dd.MM.yyyy;");
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
