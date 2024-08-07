
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Идентификаторы обучения вида плана.
// 
// Параметры:
//  ВидПлана - СправочникСсылка.ВидыПланов - Вид плана.
//  ТребуетсяПоследнийОбучающийся - Булево - Требуется последний обучающийся вид плана.
// 
// Возвращаемое значение:
//  Неопределено, Структура - из:
//   * ВидПлана - СправочникСсылка.ВидыПланов - 
//   * ИдОбучения - Строка - 
//   * ВремяИзмененияСостояния - Дата -  
//   * СтатусОбучения - Строка - 
//   * ТекстОшибки - Строка - 
//   * Готовность - Число - 
Функция ИдентификаторыОбученияВидаПлана(ВидПлана, ТребуетсяПоследнийОбучающийся = Истина) Экспорт
	
	ИнформацияОбОбучении = ИнформацияОбОбученииМодели(ВидПлана);
	Если ТребуетсяПоследнийОбучающийся Тогда
		Возврат ИнформацияОбОбучении["ОбучающаясяМодель"];
	Иначе
		Возврат ИнформацияОбОбучении["ЗагруженнаяМодель"];
	КонецЕсли;
	
КонецФункции

// Создать новый или перезаписать существующий идентификатор обучения по виду плана.
// 
// Параметры:
//  ВидПлана - СправочникСсылка.ВидыПланов - Вид плана.
//  ИдОбучения - Строка - Ид обучения.
//  СтатусОбучения - Строка - Статус обучения.
//  ТекстОшибки - Строка - Текст ошибки.
//  Готовность - Число - Готовность.
Процедура ЗаполнитьИдентификаторОбученияПоВидуПлана(ВидПлана,
	ИдОбучения,
	СтатусОбучения = "",
	ТекстОшибки = "",
	Готовность = 0) Экспорт
	
	Набор = РегистрыСведений.СервисПрогнозированияИдентификаторыОбучения.СоздатьНаборЗаписей();
	Набор.Отбор.ВидПлана.Установить(ВидПлана);
	
	Запись = Набор.Добавить();
	Запись.ВидПлана                = ВидПлана;
	Запись.ИдОбучения              = ИдОбучения;
	Запись.СтатусОбучения          = СтатусОбучения;
	Запись.ТекстОшибки             = ТекстОшибки;
	Запись.Готовность              = Готовность;
	Запись.ВремяИзмененияСостояния = ТекущаяДатаСеанса();
	
	Набор.Записать();
	
КонецПроцедуры

// Добавить текст ошибки к обучению по виду плана.
// 
// Параметры:
//  ВидПлана - СправочникСсылка.ВидыПланов - Вид плана.
//  ТекстОшибки - Строка - Текст ошибки.
Процедура ДобавитьТекстОшибкиКОбучениюПоВидуПлана(ВидПлана, ТекстОшибки) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.СервисПрогнозированияИдентификаторыОбучения");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировкиДанных.УстановитьЗначение("ВидПлана", ВидПлана);
		БлокировкаДанных.Заблокировать();
	
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТаблицаРегистра.ВидПлана КАК ВидПлана,
		|	ТаблицаРегистра.ИдОбучения КАК ИдОбучения,
		|	ТаблицаРегистра.СтатусОбучения КАК СтатусОбучения,
		|	ТаблицаРегистра.Готовность КАК Готовность
		|ИЗ
		|	РегистрСведений.СервисПрогнозированияИдентификаторыОбучения КАК ТаблицаРегистра
		|ГДЕ
		|	ТаблицаРегистра.ВидПлана = &ВидПлана
		|	И ТаблицаРегистра.СтатусОбучения В (&Статус)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВремяИзмененияСостояния УБЫВ";
		
		СтатусОбученияОбучаетсяГотов = Новый Массив();
		СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусНеизвестен());
		СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусОжидаетОбучения());
		СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусОбучается());
		СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусГотовКПолучению());
		СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусОшибкаОбучения());
		
		Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
		Запрос.УстановитьПараметр("Статус", СтатусОбученияОбучаетсяГотов);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
		
			Набор = РегистрыСведений.СервисПрогнозированияИдентификаторыОбучения.СоздатьНаборЗаписей();
			Набор.Отбор.ВидПлана.Установить(ВидПлана);
			Набор.Отбор.ИдОбучения.Установить(Выборка.ИдОбучения);
			
			Запись = Набор.Добавить();
			Запись.ВидПлана = ВидПлана;
			Запись.ИдОбучения = Выборка.ИдОбучения;
			Запись.СтатусОбучения = "Ошибка обучения";
			Запись.ТекстОшибки = ТекстОшибки;
			Запись.Готовность = Выборка.Готовность;
			Запись.ВремяИзмененияСостояния = ТекущаяДатаСеанса();
			
			Набор.Записать();
		
		КонецЕсли;
	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		СобытиеЖурналаРегистрации = СервисПрогнозированияПереопределяемый.ТекстСобытиеЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации,
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.ЖурналСервисаПрогнозирования,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Информация об обучении модели.
// 
// Параметры:
//  ВидПлана - СправочникСсылка.ВидыПланов - Вид плана.
// 
// Возвращаемое значение:
//  Структура - Информация об обучении модели из:
//  * ОбучающаясяМодель - Структура - из:
//   ** ВидПлана - СправочникСсылка.ВидыПланов - 
//   ** ИдОбучения - Строка - 
//   ** ВремяИзмененияСостояния - Дата -  
//   ** СтатусОбучения - Строка - 
//   ** ТекстОшибки - Строка - 
//   ** Готовность - Число - 
//  * ЗагруженнаяМодель - Структура - из:
//   ** ВидПлана - СправочникСсылка.ВидыПланов - 
//   ** ИдОбучения - Строка - 
//   ** ВремяИзмененияСостояния - Дата -  
//   ** СтатусОбучения - Строка - 
//   ** ТекстОшибки - Строка - 
//   ** Готовность - Число - 
Функция ИнформацияОбОбученииМодели(ВидПлана) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	&ВидПлана КАК ВидПлана,
	|	СервисПрогнозированияИдентификаторыОбучения.ИдОбучения КАК ИдОбучения,
	|	СервисПрогнозированияИдентификаторыОбучения.ВремяИзмененияСостояния КАК ВремяИзмененияСостояния,
	|	СервисПрогнозированияИдентификаторыОбучения.СтатусОбучения КАК СтатусОбучения,
	|	СервисПрогнозированияИдентификаторыОбучения.ТекстОшибки КАК ТекстОшибки,
	|	СервисПрогнозированияИдентификаторыОбучения.Готовность КАК Готовность
	|ИЗ
	|	РегистрСведений.СервисПрогнозированияИдентификаторыОбучения КАК СервисПрогнозированияИдентификаторыОбучения
	|ГДЕ
	|	СервисПрогнозированияИдентификаторыОбучения.ВидПлана = &ВидПлана
	|	И СервисПрогнозированияИдентификаторыОбучения.СтатусОбучения В(&СтатусОбученияОбучаетсяГотов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяИзмененияСостояния УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	&ВидПлана КАК ВидПлана,
	|	СервисПрогнозированияИдентификаторыОбучения.ИдОбучения КАК ИдОбучения,
	|	СервисПрогнозированияИдентификаторыОбучения.ВремяИзмененияСостояния КАК ВремяИзмененияСостояния,
	|	СервисПрогнозированияИдентификаторыОбучения.СтатусОбучения КАК СтатусОбучения,
	|	СервисПрогнозированияИдентификаторыОбучения.ТекстОшибки КАК ТекстОшибки,
	|	СервисПрогнозированияИдентификаторыОбучения.Готовность КАК Готовность
	|ИЗ
	|	РегистрСведений.СервисПрогнозированияИдентификаторыОбучения КАК СервисПрогнозированияИдентификаторыОбучения
	|ГДЕ
	|	СервисПрогнозированияИдентификаторыОбучения.ВидПлана = &ВидПлана
	|	И СервисПрогнозированияИдентификаторыОбучения.СтатусОбучения В(&СтатусОбученияЗагружен)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяИзмененияСостояния УБЫВ";
	
	СтатусОбученияЗагружен = Новый Массив();
	СтатусОбученияЗагружен.Добавить(СервисПрогнозирования.СтатусЗагружен());
	
	СтатусОбученияОбучаетсяГотов = Новый Массив();
	СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусНеизвестен());
	СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусОжидаетОбучения());
	СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусОбучается());
	СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусГотовКПолучению());
	СтатусОбученияОбучаетсяГотов.Добавить(СервисПрогнозирования.СтатусОшибкаОбучения());
	
	Запрос.УстановитьПараметр("СтатусОбученияЗагружен", СтатусОбученияЗагружен);
	Запрос.УстановитьПараметр("СтатусОбученияОбучаетсяГотов", СтатусОбученияОбучаетсяГотов);
	Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаОбучается = Результат[0].Выбрать();
	ВыборкаЗагружен = Результат[1].Выбрать();
	
	Ответ = Новый Структура("ОбучающаясяМодель, ЗагруженнаяМодель", Неопределено, Неопределено);
	
	Если ВыборкаЗагружен.Следующий() Тогда
		ШаблонСтруктурыОтвета = ШаблонОтветаИнформацииОбОбучении();
		ЗаполнитьЗначенияСвойств(ШаблонСтруктурыОтвета, ВыборкаЗагружен);
		Ответ["ЗагруженнаяМодель"] = ШаблонСтруктурыОтвета;
	КонецЕсли;
	
	// Предотвращение возврата обучающейся модели, которая была перед последней загруженной.
	// Такое возможно, когда обучение было прервано с ошибкой, а затем запущено новое.
	Если ВыборкаОбучается.Следующий()
		И (Ответ["ЗагруженнаяМодель"] = Неопределено
			Или ВыборкаОбучается.ВремяИзмененияСостояния > Ответ["ЗагруженнаяМодель"].ВремяИзмененияСостояния) Тогда
		ШаблонСтруктурыОтвета = ШаблонОтветаИнформацииОбОбучении();
		ЗаполнитьЗначенияСвойств(ШаблонСтруктурыОтвета, ВыборкаОбучается);
		Ответ["ОбучающаясяМодель"] = ШаблонСтруктурыОтвета;
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

// Получить текст ошибки вида плана.
// 
// Параметры:
//  ВидПлана - СправочникСсылка.ВидыПланов - Вид плана.
// 
// Возвращаемое значение:
//  Строка - Получить текст ошибки вида плана.
Функция ПолучитьТекстОшибкиВидаПлана(ВидПлана) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СервисПрогнозированияИдентификаторыОбучения.ВремяИзмененияСостояния КАК ВремяИзмененияСостояния,
	|	СервисПрогнозированияИдентификаторыОбучения.СтатусОбучения КАК СтатусОбучения,
	|	СервисПрогнозированияИдентификаторыОбучения.ТекстОшибки КАК ТекстОшибки,
	|	СервисПрогнозированияИдентификаторыОбучения.Готовность КАК Готовность
	|ИЗ
	|	РегистрСведений.СервисПрогнозированияИдентификаторыОбучения КАК СервисПрогнозированияИдентификаторыОбучения
	|ГДЕ
	|	СервисПрогнозированияИдентификаторыОбучения.ВидПлана = &ВидПлана
	|	И СервисПрогнозированияИдентификаторыОбучения.СтатусОбучения = &СтатусОбучения
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяИзмененияСостояния УБЫВ";
	
	Запрос.УстановитьПараметр("СтатусОбучения", "Ошибка обучения");
	Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекстОшибки = "";
	
	Если Выборка.Следующий() Тогда
		ТекстОшибки = Выборка.ТекстОшибки;
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

// Полная информация о последних моделях.
// 
// Параметры:
//  ЛимитВыборки - Число - Лимит выборки
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Полная информация о последних моделях, колонки:
//   * ВидПлана - СправочникСсылка.ВидыПланов - 
//   * ТипПлана - ПеречислениеСсылка.ТипыПланов - 
//   * ИдентификаторМоделиПрогнозирования - Число -
//   * ЗаполнятьПоХарактеристикамНоменклатуры - Булево - 
//   * ЗаполнятьСклад - Булево - 
//   * ЗаполнятьПартнера - Булево - 
//   * Периодичность - Дата - 
//   * АвтоматическиОбновлятьПрогноз - Булево - 
//   * ПериодичностьОбновленияПрогноза - Число - 
//   * КоличествоОбновленийЗаПериод - Число - 
//   * МетрикаОценкиКачестваПрогноза - Строка - 
//   * ВзвешиваниеОбъектовПриПодсчетеМетрики - Число - 
//   * УчетПотерянныхПродаж - Число - 
//   * КоэффициентВосстановленияУчетаПотерянныхПродаж - Число - 
//   * СглаживаниеВыбросовИсторическихДанных - Число - 
//   * НижняяГраницаВыброса - Число - 
//   * ВерхняяГраницаВыброса - Число - 
//   * РассчитыватьОтклонениеПоСезоннымЗначениям - Число - 
//   * НачалоПрогнозирования - Дата - 
//   * ДополнительноеСвойствоВзвешивания - Строка - 
//   * ЗаполнятьПоДаннымСервиса - Булево - 
//   * УскоритьОбучениеСПотерейКачества - Булево - 
//   * КоличествоПериодовДляОценкиТочности - Число - 
//   * УскоритьОбучениеСПотерейКачества - Число - 
//   * ДеньНеделиНачалаПрогноза - ПеречислениеСсылка.ДниНедели - 
Функция ПолнаяИнформацияОПоследнихМоделях(ЛимитВыборки = 10) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 10
	|	СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК ВидПлана,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ТипПлана КАК ТипПлана,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ИдентификаторМоделиПрогнозирования КАК ИдентификаторМоделиПрогнозирования,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ЗаполнятьПоХарактеристикамНоменклатуры КАК ЗаполнятьПоХарактеристикамНоменклатуры,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ЗаполнятьСклад КАК ЗаполнятьСклад,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ЗаполнятьПартнера КАК ЗаполнятьПартнера,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).Периодичность КАК Периодичность,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).АвтоматическиОбновлятьПрогноз КАК АвтоматическиОбновлятьПрогноз,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ПериодичностьОбновленияПрогноза КАК ПериодичностьОбновленияПрогноза,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).КоличествоОбновленийЗаПериод КАК КоличествоОбновленийЗаПериод,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).МетрикаОценкиКачестваПрогноза КАК МетрикаОценкиКачестваПрогноза,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ВзвешиваниеОбъектовПриПодсчетеМетрики КАК ВзвешиваниеОбъектовПриПодсчетеМетрики,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).УчетПотерянныхПродаж КАК УчетПотерянныхПродаж,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).КоэффициентВосстановленияУчетаПотерянныхПродаж КАК КоэффициентВосстановленияУчетаПотерянныхПродаж,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).СглаживаниеВыбросовИсторическихДанных КАК СглаживаниеВыбросовИсторическихДанных,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).НижняяГраницаВыброса КАК НижняяГраницаВыброса,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ВерхняяГраницаВыброса КАК ВерхняяГраницаВыброса,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).РассчитыватьОтклонениеПоСезоннымЗначениям КАК РассчитыватьОтклонениеПоСезоннымЗначениям,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).НачалоПрогнозирования КАК НачалоПрогнозирования,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ДополнительноеСвойствоВзвешивания КАК ДополнительноеСвойствоВзвешивания,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ЗаполнятьПоДаннымСервиса КАК ЗаполнятьПоДаннымСервиса,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).УскоритьОбучениеСПотерейКачества КАК УскоритьОбучениеСПотерейКачества,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).КоличествоПериодовДляОценкиТочности КАК КоличествоПериодовДляОценкиТочности,
	|	ВЫРАЗИТЬ(СервисПрогнозированияИдентификаторыОбучения.ВидПлана КАК Справочник.ВидыПланов).ДеньНеделиНачалаПрогноза КАК ДеньНеделиНачалаПрогноза,
	|	СервисПрогнозированияИдентификаторыОбучения.ИдОбучения КАК ИдОбучения,
	|	СервисПрогнозированияИдентификаторыОбучения.ВремяИзмененияСостояния КАК ВремяИзмененияСостояния,
	|	СервисПрогнозированияИдентификаторыОбучения.СтатусОбучения КАК СтатусОбучения,
	|	СервисПрогнозированияИдентификаторыОбучения.ТекстОшибки КАК ТекстОшибки,
	|	СервисПрогнозированияИдентификаторыОбучения.Готовность КАК Готовность
	|ИЗ
	|	РегистрСведений.СервисПрогнозированияИдентификаторыОбучения КАК СервисПрогнозированияИдентификаторыОбучения
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяИзмененияСостояния УБЫВ";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "10", ЛимитВыборки);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Шаблон ответа информации об обучении.
// 
// Возвращаемое значение:
//  Структура - Шаблон ответа информации об обучении:
// * ВидПлана - СправочникСсылка.ВидыПланов - 
// * ИдОбучения - Строка - 
// * ВремяИзмененияСостояния - Дата -  
// * СтатусОбучения - Строка - 
// * ТекстОшибки - Строка - 
// * Готовность - Число - 
Функция ШаблонОтветаИнформацииОбОбучении()
	
	Шаблон = Новый Структура();
	Шаблон.Вставить("ВидПлана");
	Шаблон.Вставить("ИдОбучения");
	Шаблон.Вставить("ВремяИзмененияСостояния");
	Шаблон.Вставить("СтатусОбучения");
	Шаблон.Вставить("ТекстОшибки");
	Шаблон.Вставить("Готовность");
	
	Возврат Шаблон;
	
КонецФункции

#КонецОбласти

#КонецЕсли