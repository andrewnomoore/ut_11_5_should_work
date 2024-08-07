
#Область ПрограммныйИнтерфейс

// Получить оборудование подключенное к терминалу.
//
// Параметры:
//  ЭквайринговыйТерминал - СправочникСсылка.ЭквайринговыеТерминалы - Эквайринговый терминал.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - Неопределено, СправочникСсылка.ПодключаемоеОборудование - Терминал.
//   * ККТ - Неопределено, СправочникСсылка.ПодключаемоеОборудование - ККТ.
//
Функция ОборудованиеПодключенноеКТерминалу(ЭквайринговыйТерминал) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРМК КАК Т
	|ГДЕ
	|	Т.РабочееМесто = &РабочееМесто
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЭквайринговыеТерминалы.ПодключаемоеОборудование               КАК Терминал,
	|	ЭквайринговыеТерминалы.ИспользоватьБезПодключенияОборудования КАК ИспользоватьБезПодключенияОборудования,
	|	ЭквайринговыеТерминалы.ПодключаемоеОборудованиеККТ            КАК ККТ
	|ИЗ
	|	Справочник.НастройкиРМК.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НастройкаРМК КАК НастройкаРМК
	|		ПО НастройкаРМК.Ссылка = ЭквайринговыеТерминалы.Ссылка
	|ГДЕ
	|	ЭквайринговыеТерминалы.ЭквайринговыйТерминал = &ЭквайринговыйТерминал");
	
	Запрос.УстановитьПараметр("РабочееМесто",          МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Запрос.УстановитьПараметр("ЭквайринговыйТерминал", ЭквайринговыйТерминал);
	
	ВозвращаемоеЗначение = СтруктураПодключенноеОборудование();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, Выборка);
		Если Выборка.ИспользоватьБезПодключенияОборудования Тогда
			ВозвращаемоеЗначение.Терминал = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получить оборудование подключенное к кассе.
//
// Параметры:
//  Касса - СправочникСсылка.Кассы - Касса.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - Неопределено, СправочникСсылка.ПодключаемоеОборудование - Данные подключенному термиралу
//   * ККТ - Неопределено, СправочникСсылка.ПодключаемоеОборудование - ККТ.
//
Функция ОборудованиеПодключенноеККассе(Касса) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРМК КАК Т
	|ГДЕ
	|	Т.РабочееМесто = &РабочееМесто
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Кассы.ПодключаемоеОборудование КАК ККТ
	|ИЗ
	|	Справочник.НастройкиРМК.Кассы КАК Кассы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НастройкаРМК КАК НастройкаРМК
	|		ПО НастройкаРМК.Ссылка = Кассы.Ссылка
	|ГДЕ
	|	Кассы.Касса = &Касса");
	
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Запрос.УстановитьПараметр("Касса",        Касса);
	
	ВозвращаемоеЗначение = СтруктураПодключенноеОборудование();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, Выборка);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получить кассу, связанную с оборудованием.
//
// Параметры:
//  ОборудованиеККТ - СправочникСсылка.ПодключаемоеОборудование -
// 
// Возвращаемое значение:
//  СправочникСсылка.Кассы, Неопределено - 
//
Функция КассаСвязаннаяСОборудованием(ОборудованиеККТ) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРМК КАК Т
	|ГДЕ
	|	Т.РабочееМесто = &РабочееМесто
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|   Кассы.Касса КАК Касса
	|ИЗ
	|	Справочник.НастройкиРМК.Кассы КАК Кассы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НастройкаРМК КАК НастройкаРМК
	|		ПО НастройкаРМК.Ссылка = Кассы.Ссылка
	|ГДЕ
	|	Кассы.ПодключаемоеОборудование = &ОборудованиеККТ");
	
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Запрос.УстановитьПараметр("ОборудованиеККТ", ОборудованиеККТ);
	
	ВозвращаемоеЗначение = Неопределено;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВозвращаемоеЗначение = Выборка.Касса;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получить оборудование подключенное к кассе ККМ.
//
// Параметры:
//  КассаККМ - СправочникСсылка.КассыККМ - Касса ККМ.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - Неопределено, СправочникСсылка.ПодключаемоеОборудование - Данные подключенному термиралу
//   * ККТ - Массив Из СправочникСсылка.ПодключаемоеОборудование - ККТ
//
Функция ОборудованиеПодключенноеККассеККМ(КассаККМ) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРМК КАК Т
	|ГДЕ
	|	Т.РабочееМесто = &РабочееМесто
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КассыККМ.ПодключаемоеОборудование КАК ККТ
	|ИЗ
	|	Справочник.НастройкиРМК.КассыККМ КАК КассыККМ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НастройкаРМК КАК НастройкаРМК
	|		ПО НастройкаРМК.Ссылка = КассыККМ.Ссылка
	|ГДЕ
	|	НЕ КассыККМ.ИспользоватьБезПодключенияОборудования
	|	И КассыККМ.КассаККМ = &КассаККМ");
	
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Запрос.УстановитьПараметр("КассаККМ",     КассаККМ);
	
	ВозвращаемоеЗначение = СтруктураПодключенноеОборудование();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, Выборка);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получить оборудование подключенное по организации.
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияБПО - Организация.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - Неопределено, СправочникСсылка.ПодключаемоеОборудование - Данные подключенному термиралу
//   * ККТ - Массив Из СправочникСсылка.ПодключаемоеОборудование, СправочникСсылка.ОфлайнОборудование - ККТ
//
Функция ОборудованиеПодключенноеПоОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК ККТ
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Организация = &Организация
	|	И НЕ ПодключаемоеОборудование.ПометкаУдаления
	|	И ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто";
	
	//++ Локализация
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК ККТ
	|ИЗ
	|	Справочник.ОфлайнОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Организация = &Организация
	|	И НЕ ПодключаемоеОборудование.ПометкаУдаления
	|	И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК ККТ
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Организация = &Организация
	|	И НЕ ПодключаемоеОборудование.ПометкаУдаления
	|	И ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто";
	//-- Локализация
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Запрос.УстановитьПараметр("Организация",  Организация);
	
	СписокККТ = Новый Массив();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокККТ.Добавить(Выборка.ККТ);
	КонецЦикла;
	
	ВозвращаемоеЗначение = СтруктураПодключенноеОборудование();
	ВозвращаемоеЗначение.ККТ = СписокККТ;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получить оборудование подключенное к кассам организации для текущего рабочего места.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Организация.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - Неопределено.
//   * ККТ - Неопределено, СправочникСсылка.ПодключаемоеОборудование - ККТ.
//
Функция ОборудованиеПодключенноеККассеПоОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРМК КАК Т
	|ГДЕ
	|	Т.РабочееМесто = &РабочееМесто
	|
	|;
	|ВЫБРАТЬ
	|	Кассы.ПодключаемоеОборудование КАК ККТ,
	|   Кассы.Касса КАК Касса
	|ИЗ
	|	Справочник.НастройкиРМК.Кассы КАК Кассы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НастройкаРМК КАК НастройкаРМК
	|		ПО НастройкаРМК.Ссылка = Кассы.Ссылка
	|ГДЕ
	|	Кассы.ПодключаемоеОборудование.Организация = &Организация
	|	И НЕ Кассы.ПодключаемоеОборудование.ПометкаУдаления
	|	И Кассы.ПодключаемоеОборудование.УстройствоИспользуется
	|");
	
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Запрос.УстановитьПараметр("Организация",  Организация);
	
	ВозвращаемоеЗначение = СтруктураПодключенноеОборудование();
	ВозвращаемоеЗначение.ККТ = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ВозвращаемоеЗначение.ККТ.Добавить(Выборка.ККТ);
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получить оборудование подключенное по организации и взаимодействующее в онлайн с 1С.
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияБПО - Организация.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - Неопределено, СправочникСсылка.ПодключаемоеОборудование - Данные подключенному термиралу
//   * ККТ - Массив Из СправочникСсылка.ПодключаемоеОборудование - ККТ
//
Функция ОборудованиеПодключенноеПоОрганизацииВзаимодействующееОнлайнС1С(Организация) Экспорт
	
	ОборудованиеПодключенноеПоОрганизации = ОборудованиеПодключенноеПоОрганизации(Организация);
	
	ОборудованиеВзаимодействующееОнлайнС1С = Новый Массив();
	ЗаполнитьМассивПодключенногоОборудованияПоОрганизации(ОборудованиеВзаимодействующееОнлайнС1С, ОборудованиеПодключенноеПоОрганизации);
	
	ОборудованиеПодключенноеПоОрганизации.ККТ = ОборудованиеВзаимодействующееОнлайнС1С;
	
	Возврат ОборудованиеПодключенноеПоОрганизации;
	
КонецФункции

// Получить оборудование подключенное по торговому объету и взаимодействующее в онлайн с 1С.
//
// Параметры:
//  ТорговыйОбъект - СправочникСсылка.КассыККМ, СправочникСсылка.Кассы - Торговый объект для определения
//  	конкретного подключенного оборудования.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - Неопределено, СправочникСсылка.ПодключаемоеОборудование - Данные подключенному термиралу
//   * ККТ - Массив Из СправочникСсылка.ПодключаемоеОборудование - ККТ
//
Функция ОборудованиеПодключенноеПоТорговомуОбъектуВзаимодействующееОнлайнС1С(ТорговыйОбъект) Экспорт
	
	ОборудованиеПоТорговомуОбъекту = Неопределено;
	Если ТипЗнч(ТорговыйОбъект) = Тип("СправочникСсылка.КассыККМ") Тогда
		ОборудованиеПоТорговомуОбъекту = ОборудованиеПодключенноеККассеККМ(ТорговыйОбъект);
	Иначе // ТипЗнч(ТорговыйОбъект) = Тип("СправочникСсылка.Кассы") Тогда
		ОборудованиеПоТорговомуОбъекту = ОборудованиеПодключенноеККассе(ТорговыйОбъект);
	КонецЕсли;
	
	ОборудованиеВзаимодействующееОнлайнС1С = Новый Массив();
	
	ЗаполнитьМассивПодключенногоОборудованияПоТорговомуОбъекту(ОборудованиеВзаимодействующееОнлайнС1С, ОборудованиеПоТорговомуОбъекту);
	
	ОборудованиеПодключенноеПоОрганизации = СтруктураПодключенноеОборудование();
	ОборудованиеПодключенноеПоОрганизации.ККТ = ОборудованиеВзаимодействующееОнлайнС1С;
	
	Возврат ОборудованиеПодключенноеПоОрганизации;
	
КонецФункции

Функция ДанныеФискальнойОперацииСУчетомКорректировкиРеализации(ДокументОснование) Экспорт
	
	ДанныеФискальнойОперации = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КорректировкаРеализации.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФискальныеОперации КАК ФискальныеОперации
	|		ПО КорректировкаРеализации.Ссылка = ФискальныеОперации.ДокументОснование
	|ГДЕ
	|	КорректировкаРеализации.ДокументОснование = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	КорректировкаРеализации.Дата УБЫВ";
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДанныеФискальнойОперации = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ДанныеФискальнойОперации(Выборка.Ссылка);
	КонецЕсли;
	
	Возврат ДанныеФискальнойОперации;
	
КонецФункции

// Записать операцию в регистр сведений Фискальные операции. Оставлен для совместимости с ОперацияПоЯндексКассе.ОтразитьДокументВЖурналеФискальныхОпераций()
// вызывается ТОЛЬКО оттуда
// раньше запись делалась в регистр сведений ЖурналФискальныхОпераций
// теперь в рамках этого метода НЕ создаются : 
//		РозничныеПродажи.СоздатьДокументВнесениеДенежныхСредствВКассуККМ(ВнесениеДенежныхСредствВКассуККМ);
//      РозничныеПродажи.СоздатьДокументВыемкаДенежныхСредствИзКассыККМ(ВыемкаДенежныхСредствИзКассыККМ).
//
// Параметры:
//  ТребуетсяПовторнаяПопыткаЗаписи - Булево - Требуется повторная попытка записи.
//  РеквизитыФискальнойОперацииКассовогоУзла - Структура - Реквизиты фискальной операции кассового узла:
//    	* Дата - Дата - Дата формирования чека
//    	* ДокументОснование - ДокументСсылка - 
//    	* Организация - СправочникСсылка - Организация который принадлежит касса
//    	* ТорговыйОбъект - СправочникСсылка - 
//    	* Устройство - СправочникСсылка - Касса ККМ или фискальное устройство
//    	* ТипОперации - ПеречислениеСсылка - Тип операции кассового узла
//    	* ТипРасчета - ПеречислениеСсылка - Тип расчета денежными средствами
//    	* НомерЧекаККМ - Строка - Фискальный номер документа
//    	* НомерСмены - Строка - Номер кассовой смены
//    	* ВариантОтправкиЭлектронногоЧека - ПеречислениеСсылка - Варианты отправки электронного чека покупателю
//    	* КонтактныеДанныеЭлектронногоЧека - Строка - Контактные данные электронного чека
//    	* Сумма - Число - Сумма чека
//    	* СуммаОплатыНаличные - Число - Сумма чека
//    	* СуммаОплатыПлатежнаяКарта - Число - Сумма чека
//    	* СуммаКредит - Число - Сумма чека
//    	* СуммаПредоплаты - Число - Сумма чека
//    	* СуммаВзаимозачет - Число - Сумма чека
//    	* Данные - Структура -
//    			- Массив - Данные фискальной операции
//    	* ДополнительныеПараметры - Структура - Описывает дополнительные параметры.
//  
// Возвращаемое значение:
//  Булево - Результат записи фискальной опрерации.
Функция ЗаписатьВЖурналФискальныхОпераций(ТребуетсяПовторнаяПопыткаЗаписи, Знач РеквизитыФискальнойОперацииКассовогоУзла) Экспорт
	
	ПараметрыФискализации = ОборудованиеЧекопечатающиеУстройства.ПараметрыФискализацииЧека();
	
	ПараметрыФискализации.ДокументОснование = РеквизитыФискальнойОперацииКассовогоУзла.ДокументОснование;
	ПараметрыФискализации.Организация = РеквизитыФискальнойОперацииКассовогоУзла.Организация;
	ПараметрыФискализации.ТорговыйОбъект = РеквизитыФискальнойОперацииКассовогоУзла.ТорговыйОбъект;
	ПараметрыФискализации.ТипРасчета = РеквизитыФискальнойОперацииКассовогоУзла.ТипРасчета;
	ПараметрыФискализации.НомерЧекаККТ = РеквизитыФискальнойОперацииКассовогоУзла.НомерЧекаККМ; //в БПО НомерЧекаККТ, в ЯК НомерЧекаККМ
	ПараметрыФискализации.ДатаВремяЧека = РеквизитыФискальнойОперацииКассовогоУзла.Дата;
	
	Если РеквизитыФискальнойОперацииКассовогоУзла.ТипОперации = Перечисления.ТипыОперацииКассовогоУзла.ФискальнаяОперация Тогда
		ПараметрыФискализации.ТипДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧек;
	ИначеЕсли РеквизитыФискальнойОперацииКассовогоУзла.ТипОперации = Перечисления.ТипыОперацииКассовогоУзла.ВнесениеДенежныхСредств Тогда	
		ПараметрыФискализации.ТипДокумента = Перечисления.ТипыФискальныхДокументовККТ.Внесение;
	ИначеЕсли РеквизитыФискальнойОперацииКассовогоУзла.ТипОперации = Перечисления.ТипыОперацииКассовогоУзла.ВыемкаДенежныхСредств Тогда	
		ПараметрыФискализации.ТипДокумента = Перечисления.ТипыФискальныхДокументовККТ.Выемка;
	КонецЕсли;	
	
	ПараметрыФискализации.СуммаЧека = РеквизитыФискальнойОперацииКассовогоУзла.Сумма;
	ПараметрыФискализации.ОплатаЭлектронно = РеквизитыФискальнойОперацииКассовогоУзла.СуммаОплатыПлатежнаяКарта;
	
	Результат = ЗаписатьФискальнуюОперациюВТранзакции(ТребуетсяПовторнаяПопыткаЗаписи, ПараметрыФискализации);
	
	Возврат Результат;
	
КонецФункции

// Записать операцию в регистр сведений Фискальные операции в транзакции. 
// Метод добавлен для вызова из клиентского контекста (в частности ПодключаемоеОборудованиеУТКлиент) с возможностью попытки повторной записи
// В дальнейшем предполагается перенести этот метод в ОМ МенеджерОбрудованияВызовСервера БПО.
//
// Параметры:
//  ТребуетсяПовторнаяПопыткаЗаписи - Булево - Требуется повторная попытка записи.
//  ПараметрыФискализации - Структура - Описание параметров фискализация чека, см. функцию МенеджерОборудованияКлиентСервер.ПараметрыФискализацииЧека().
// 
// Возвращаемое значение:
// 	Булево - Результат записи фискальной операции.
Функция ЗаписатьФискальнуюОперациюВТранзакции(ТребуетсяПовторнаяПопыткаЗаписи, Знач ПараметрыФискализации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Если ПараметрыФискализации <> Неопределено Тогда
			
			НужноЗаписатьФискальнуюОперацию = НЕ ПараметрыФискализации.ОперацияЗаписана;
			НужноЗаписатьФискальнуюОперациюСторно = НЕ ( ПустаяСтрока(ПараметрыФискализации.ЧекКоррекцииСторно)
					 									 ИЛИ ПараметрыФискализации.ЧекКоррекцииСторно.ОперацияЗаписана );
														 
			Если НужноЗаписатьФискальнуюОперацию ИЛИ НужноЗаписатьФискальнуюОперациюСторно Тогда
															 
				Блокировка = Новый БлокировкаДанных;
				
				Если НужноЗаписатьФискальнуюОперацию И ЗначениеЗаполнено(ПараметрыФискализации.ДокументОснование) Тогда
					ЭлементБлокировки = Блокировка.Добавить();
					ЭлементБлокировки.Область = "РегистрСведений.ФискальныеОперации";
					ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
					ЭлементБлокировки.УстановитьЗначение("ДокументОснование", ПараметрыФискализации.ДокументОснование);
				КонецЕсли;	
				
				Если НужноЗаписатьФискальнуюОперациюСторно И ЗначениеЗаполнено(ПараметрыФискализации.ЧекКоррекцииСторно.ДокументОснование) Тогда
					ЭлементБлокировки = Блокировка.Добавить();
					ЭлементБлокировки.Область = "РегистрСведений.ФискальныеОперации";
					ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
					ЭлементБлокировки.УстановитьЗначение("ДокументОснование", ПараметрыФискализации.ЧекКоррекцииСторно.ДокументОснование);
				КонецЕсли;
				
				Если Блокировка.Количество() Тогда
					Блокировка.Заблокировать();
				КонецЕсли;	

				Если НужноЗаписатьФискальнуюОперацию Тогда
					ОборудованиеЧекопечатающиеУстройстваВызовСервера.ЗаписатьФискальнуюОперацию(ПараметрыФискализации);
				КонецЕсли;
				Если НужноЗаписатьФискальнуюОперациюСторно Тогда
					ОборудованиеЧекопечатающиеУстройстваВызовСервера.ЗаписатьФискальнуюОперацию(ПараметрыФискализации.ЧекКоррекцииСторно);
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
		Результат = Истина;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТребуетсяПовторнаяПопыткаЗаписи = Истина;
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Формирует список операций к фискализации по документу и помещает их в очередь
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - ссылка на документ для которого необходимо сформировать очередь чеков
//
Процедура СформироватьОчередьЧеков(ДокументСсылка) Экспорт
	
	//++ Локализация
	ПодключаемоеОборудованиеУТСервер.УдалитьНеФискализированныеЧекиИзОчереди(ДокументСсылка);
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДокументСсылка);
	
	МассивЧеков = МенеджерОбъекта.СобратьДанныеЧеков(ДокументСсылка);
	Для Каждого Чек Из МассивЧеков Цикл
		ОборудованиеЧекопечатающиеУстройстваВызовСервера.ДобавитьЧекВОчередьЧековККТ(Чек);
	КонецЦикла;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Служебная структура "подключенное оборудование"
// 
// Возвращаемое значение:
//  Структура - с полями:
//   * ККТ - Массив Из СправочникСсылка.ПодключаемоеОборудование - ККТ
//   * Терминал - Неопределено, СправочникСсылка.ПодключаемоеОборудование - Данные подключенному термиралу
//   * ИспользоватьБезПодключенияОборудования - Булево, Неопределено - 
//
Функция СтруктураПодключенноеОборудование()
	
	Результат = Новый Структура;
	Результат.Вставить("Терминал");
	Результат.Вставить("ККТ");
	Результат.Вставить("ИспользоватьБезПодключенияОборудования");
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьМассивПодключенногоОборудованияПоОрганизации(ОборудованиеВзаимодействующееОнлайнС1С, ОборудованиеПодключенноеПоОрганизации)
	
	Для Каждого ФискальноеОборудование Из ОборудованиеПодключенноеПоОрганизации.ККТ Цикл
		ДобавитьВМассивФискальноеОборудованиеВзаимодействующееОнлайнС1С(ОборудованиеВзаимодействующееОнлайнС1С, ФискальноеОборудование);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМассивПодключенногоОборудованияПоТорговомуОбъекту(ОборудованиеВзаимодействующееОнлайнС1С, ОборудованиеПоТорговомуОбъекту)
	
	Если ТипЗнч(ОборудованиеПоТорговомуОбъекту) = Тип("Структура")
		И ОборудованиеПоТорговомуОбъекту.Свойство("ККТ")
		И ОборудованиеПоТорговомуОбъекту.ККТ <> Неопределено Тогда
		
		ДобавитьВМассивФискальноеОборудованиеВзаимодействующееОнлайнС1С(ОборудованиеВзаимодействующееОнлайнС1С, ОборудованиеПоТорговомуОбъекту.ККТ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВМассивФискальноеОборудованиеВзаимодействующееОнлайнС1С(ОборудованиеВзаимодействующееОнлайнС1С, ФискальноеОборудование)
	
	НаименованиеРеквизитаТипОборудования = "ТипОборудования";
	
	//++ Локализация
	Если ТипЗнч(ФискальноеОборудование) = Тип("СправочникСсылка.ОфлайнОборудование") Тогда
		НаименованиеРеквизитаТипОборудования = "ТипОфлайнОборудования";
	КонецЕсли;
	//-- Локализация
	
	ТипОборудования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФискальноеОборудование, НаименованиеРеквизитаТипОборудования);
		
	Если ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков
		ИЛИ ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор
		ИЛИ ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
		
		ОборудованиеВзаимодействующееОнлайнС1С.Добавить(ФискальноеОборудование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
