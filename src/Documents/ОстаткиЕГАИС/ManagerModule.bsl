#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбменеЕГАИС

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовЕГАИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
//
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1
		Или Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2 Тогда
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыКПередаче(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиОстатковЕГАИС.КПередаче);
		
	Иначе
		ВызватьИсключение ОбщегоНазначенияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовЕГАИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
//
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Если СтатусОбработки = Неопределено Тогда
		СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ПереданоВУТМ;
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1
		Или Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2 Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиОстатковЕГАИС.ПереданВУТМ;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеОстатков);
		
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиОстатковЕГАИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОстатки);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусы(ДокументСсылка, СтатусОбработки, СтатусыБазовыйПроцесс);
		
	Иначе
		ВызватьИсключение ОбщегоНазначенияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено -
//                          - Структура:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовЕГАИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
//
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОстатковВРегистре1
		Или Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОстатковВРегистре2 Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиОстатковЕГАИС.ПолученыОстатки;
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусы(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиСообщенийЕГАИС.ПринятИзЕГАИС,
			СтатусыБазовыйПроцесс);
		
	ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		СтатусыБазовыйПроцесс.Обрабатывается = Перечисления.СтатусыОбработкиОстатковЕГАИС.ОбрабатываетсяЕГАИС;
		СтатусыБазовыйПроцесс.Ошибка         = Перечисления.СтатусыОбработкиОстатковЕГАИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОстатки);
		СтатусыБазовыйПроцесс.КвитанцияПроведенЕГАИС          = Ложь;
		СтатусыБазовыйПроцесс.УведомлениеОРегистрацииДвижения = Ложь;
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыПриПолученииКвитанции(
			ДокументСсылка,
			"КвитанцияПолученЕГАИС", ДополнительныеПараметры.СтатусОбработки,
			СтатусыБазовыйПроцесс, Истина);
		
	Иначе
		ВызватьИсключение ОбщегоНазначенияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции


// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  ДополнительныеПараметры - Произвольный - Дополнительные параметры
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиОстатковЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
//  ДополнительныеПараметры - Произвольный - дополнительные параметры
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиОстатковЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено - 
//                          - Структура:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиОстатковЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Изменяет и возвращает статус документа ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Документ, для которого требуется обновить статус.
//  ПараметрыОбновления - Структура - со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//  ДополнительныеПараметры - Неопределено - 
//                          - Структура:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияЕГАИС - новый статус документа ЕГАИС.
Функция ОбновитьСтатус(ДокументСсылка, ПараметрыОбновления, ДополнительныеПараметры) Экспорт
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОстаткиЕГАИС - Документ, для которого требуется обновить статус.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ОбменДаннымиЕГАИС.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Операция = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "ВидДокумента");
	
	Таблица = ОбменДаннымиЕГАИС.ПустаяТаблицаПоследовательностьОпераций();
	
	Исходящий = Перечисления.ТипыЗапросовИС.Исходящий;
	Входящий  = Перечисления.ТипыЗапросовИС.Входящий;
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1 Тогда
		
		ОбменДаннымиЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящий, Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1, ДокументСсылка, Ложь, Ложь);
		ОбменДаннымиЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Входящий,  Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОстатковВРегистре1);
		
	Иначе
		
		ОбменДаннымиЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящий, Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2, ДокументСсылка, Ложь, Ложь);
		ОбменДаннымиЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Входящий,  Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОстатковВРегистре2);
		
	КонецЕсли;
	
	Возврат Таблица;
	
КонецФункции

// Обработчик изменения статуса документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.АктПостановкиНаБалансЕГАИС - Документ.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС - Предыдущий статус.
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ОбменДаннымиЕГАИС.ПараметрыОбновленияСтатуса().
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса) Экспорт
	
	ОбновитьДвижения = ИнтеграцияЕГАИС.СтатусТребуетОбновленияДвижений(СтатусыДвижений(), ПредыдущийСтатус, НовыйСтатус);
	
	Если ПараметрыОбновленияСтатуса.ОбновлятьДвижения И ОбновитьДвижения Тогда
		
		ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС";
		
		НаборЗаписей = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ДокументСсылка);
		
		ДополнительныеСвойстваДляПроведения = Новый Структура;
		ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(ДокументСсылка, ДополнительныеСвойстваДляПроведения);
		
		ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойстваДляПроведения, ИмяРегистра);
		НаборЗаписей.Загрузить(ДополнительныеСвойстваДляПроведения.ТаблицыДляДвижений["Таблица" + ИмяРегистра]);
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
КонецПроцедуры

#КонецОбласти

#Область Статусы

// Возвращает статус по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиОстатковЕГАИС - Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыОбработкиОстатковЕГАИС.Черновик;
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СтатусыОбработкиОстатковЕГАИС -Статусы ошибок.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыОбработкиОстатковЕГАИС.ОшибкаПередачи);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает конечные статусы.
// 
// Параметры:
//  ТребуетсяПовторноеОформление - Булево - Требуется повторное оформление
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СтатусыОбработкиОстатковЕГАИС - Конечные статусы.
Функция КонечныеСтатусы(ТребуетсяПовторноеОформление = Истина) Экспорт
	
	Статусы = Новый Массив;
	Возврат Статусы;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОстатки;
	
КонецФункции

#КонецОбласти

#Область ПанельОбменСЕГАИС

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - дальшейшие действия
//
Функция ВсеТребующиеДействия() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОстатки);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ВыполнитеОбмен);
	
	Возврат МассивДействий;
	
КонецФункции

// Возвращает массив дальнейших действий с документом, не требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - дальшейшие действия
//
Функция ВсеТребующиеОжидания() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеОстатков);
	
	Возврат МассивДействий;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ОстаткиЕГАИС КАК ОстаткиЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ОстаткиЕГАИС.Ссылка
	|ГДЕ
	|	ОстаткиЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ОстаткиЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеДействия)
	|	И (ОстаткиЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ОстаткиЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ОстаткиЕГАИС КАК ОстаткиЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ОстаткиЕГАИС.Ссылка
	|ГДЕ
	|	ОстаткиЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ОстаткиЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеОжидания)
	|	И (ОстаткиЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ОстаткиЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщенияЕГАИС

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие ЕГАИС
//  ДополнительныеПараметры - Неопределено - не используется в этом документе
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОстатки Тогда
		
		Возврат ЗапросОстатковЕГАИСXML(ДокументСсылка);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ВЫБОР КОГДА ОрганизацияЕГАИС.Сопоставлено И ОрганизацияЕГАИС.СоответствуетОрганизации Тогда ЗначениеРазрешено(ОрганизацияЕГАИС.Контрагент)
	|	КОГДА ОрганизацияЕГАИС.Сопоставлено И НЕ ОрганизацияЕГАИС.СоответствуетОрганизации Тогда ЗначениеРазрешено(ОрганизацияЕГАИС.ТорговыйОбъект)
	|	ИНАЧЕ ИСТИНА КОНЕЦ ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

//@skip-warning
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"ОстаткиЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область СообщенияЕГАИС

Функция ЗапросОстатковЕГАИСXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕГАИСПрисоединенныеФайлы.Документ      КАК Ссылка,
	|	КОЛИЧЕСТВО(ЕГАИСПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомер
	|ПОМЕСТИТЬ Версии
	|ИЗ
	|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОстаткиЕГАИС КАК Шапка
	|		ПО Шапка.Ссылка       = &Ссылка
	|		 И Шапка.ВидДокумента = ЕГАИСПрисоединенныеФайлы.Операция
	|		 И Шапка.Ссылка       = ЕГАИСПрисоединенныеФайлы.Документ
	|ГДЕ
	|	ЕГАИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
	|СГРУППИРОВАТЬ ПО
	|	ЕГАИСПрисоединенныеФайлы.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Шапка.Номер                           КАК Номер,
	|	Шапка.Дата                            КАК Дата,
	|	ЕСТЬNULL(Версии.ПоследнийНомер, 0)    КАК ПоследнийНомерВерсии,
	|	
	|	Шапка.ВидДокумента                    КАК Операция,
	|	Шапка.ОрганизацияЕГАИС              КАК ОрганизацияЕГАИС,
	|	Шапка.ОрганизацияЕГАИС.Код          КАК ИдентификаторФСРАР,
	|	Шапка.ОрганизацияЕГАИС.ФорматОбмена КАК ФорматОбмена,
	|	Шапка.Ответственный                 КАК Ответственный
	|ИЗ
	|	Документ.ОстаткиЕГАИС КАК Шапка,
	|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
	|		ПО Шапка.Ссылка = Версии.Ссылка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	Если Не Шапка.Следующий() Тогда
		
		СообщениеXML = ОбменДаннымиЕГАИС.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ОбменДаннымиЕГАИС.ОписаниеОперацииПередачиДанных(
			Шапка.Операция, ДокументСсылка);
		
		ОбменДаннымиЕГАИСКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, НСтр("ru = 'Нет данных для выгрузки.'"));
		
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	ФорматОбмена = ОбменДаннымиЕГАИСКлиентСервер.ФорматОбмена(Шапка.ФорматОбмена);
	
	СообщениеXML = ОбменДаннымиЕГАИС.СтруктураСообщенияXML();
	СообщениеXML.Описание = ОбменДаннымиЕГАИС.ОписаниеОперацииПередачиДанных(
		Шапка.Операция, ДокументСсылка, НомерВерсии);
	
	ПространствоИмен = Перечисления.ВидыДокументовЕГАИС.ПространствоИмен(Шапка.Операция, ФорматОбмена);
	ИмяТипа          = Перечисления.ВидыДокументовЕГАИС.ТипЕГАИС(Шапка.Операция, ФорматОбмена);
	
	Если ПространствоИмен = Неопределено
		Или ИмяТипа = Неопределено Тогда
		ОбменДаннымиЕГАИСКлиентСервер.ДобавитьТекстОшибки(
			СообщениеXML,
			СтрШаблон(НСтр("ru = 'Операция не поддерживается в версии формата обмена: %1.'"), ФорматОбмена));
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
	КонецЕсли;
	
	ЗапросXDTO = РаботаСXMLЕГАИС.ОбъектXDTO(ПространствоИмен, "QueryParameters");
	
	ТекстСообщенияXML = РаботаСXMLЕГАИС.ОбъектXDTOВXML(ЗапросXDTO, Шапка.ИдентификаторФСРАР, ПространствоИмен, ИмяТипа);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.ТипСообщения      = Перечисления.ТипыЗапросовИС.Исходящий;
	СообщениеXML.ОрганизацияЕГАИС  = Шапка.ОрганизацияЕГАИС;
	СообщениеXML.Операция          = Шапка.Операция;
	СообщениеXML.ФорматОбмена      = ФорматОбмена;
	СообщениеXML.Документ          = ДокументСсылка;
	СообщениеXML.ДокументОснование = Неопределено;
	СообщениеXML.Версия            = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ИнтеграцияЕГАИСКлиент.ПечатьОстаткиЕГАИС";
	КомандаПечати.МенеджерПечати = "";
	КомандаПечати.Идентификатор = "ОстаткиЕГАИС";
	КомандаПечати.Представление = НСтр("ru = 'Остатки ЕГАИС'");
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// Параметры:
//   МассивОбъектов        - Массив из Произвольный         - ссылки на объекты, которые нужно распечатать
//   ПараметрыПечати       - Структура                      - дополнительные настройки печати
//   КоллекцияПечатныхФорм - ТаблицаЗначений                - сформированные табличные документы (выходной параметр)
//   ОбъектыПечати         - СписокЗначений из Произвольный - имя области, в которой был выведен объект (выходной параметр)
//   ПараметрыВывода       - Структура                      - дополнительные параметры сформированных табличных документов (выходной параметр)
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных;

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры);
	
	ИнтеграцияИС.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата              КАК Период,
	|	ДанныеШапки.Ссылка            КАК Ссылка,
	|	ДанныеШапки.ОрганизацияЕГАИС  КАК ОрганизацияЕГАИС,
	|	СтатусыДокументовЕГАИС.Статус КАК СтатусОбработки,
	|	ДанныеШапки.ВидДокумента      КАК ВидДокумента
	|ИЗ
	|	Документ.ОстаткиЕГАИС КАК ДанныеШапки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО СтатусыДокументовЕГАИС.Документ = ДанныеШапки.Ссылка
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                 Реквизиты.Период);
	Запрос.УстановитьПараметр("Ссылка",                 Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("УдалитьСтатусОбработки", Реквизиты.СтатусОбработки);
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС",       Реквизиты.ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("ВидДокумента",           Реквизиты.ВидДокумента);
	
	Запрос.УстановитьПараметр("СтатусыДвижений", СтатусыДвижений());
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС";
	
	Если НЕ ИнтеграцияИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ИнтеграцияЕГАИС.ЕстьТаблицаЗапроса("ВТТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Количество > 0
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	&Период КАК Период,
	|	&ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ТаблицаТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.Справка2 КАК Справка2,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Количество > 0
	|			ТОГДА ТаблицаТовары.Количество
	|		ИНАЧЕ -ТаблицаТовары.Количество
	|	КОНЕЦ КАК СвободныйОстаток,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Количество > 0
	|			ТОГДА ТаблицаТовары.Количество
	|		ИНАЧЕ -ТаблицаТовары.Количество
	|	КОНЕЦ КАК Количество,
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ВТТовары КАК ТаблицаТовары
	|ГДЕ
	|	&УдалитьСтатусОбработки В (&СтатусыДвижений)
	|	И &ВидДокумента = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТТовары";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка               КАК Ссылка,
	|	ТаблицаТовары.НомерСтроки          КАК НомерСтроки,
	|	ТаблицаТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.Количество           КАК Количество,
	|	ТаблицаТовары.Справка2             КАК Справка2
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ
	|	Документ.ОстаткиЕГАИС.КорректировкаОстатков КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СтатусыДвижений()
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.СтатусыОбработкиОстатковЕГАИС.ПолученыОстатки);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Серии

//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ИнтеграцияИС.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(Метаданные.Документы.ОстаткиЕГАИС);
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  См. ИнтеграцияИС.ПараметрыУказанияСерий
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ИнтеграцияИС.ПараметрыУказанияСерий(Метаданные.Документы.ОстаткиЕГАИС, Объект);
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ИнтеграцияИС.ТекстЗапросаЗаполненияСтатусовУказанияСерий(Метаданные.Документы.ОстаткиЕГАИС, ПараметрыУказанияСерий);

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений();
	ТекстыЗапросаВременныхТаблиц = Новый Массив;
	ПолноеИмяДокумента = "Документ.ОстаткиЕГАИС";
	
	Если ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, ИмяРегистра);
		ТекстыЗапросаВременныхТаблиц.Добавить(Новый Структура("Ключ, Значение", "ВТТовары", ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса)));
		СинонимТаблицыДокумента = "ТаблицаТовары";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ПереопределениеРасчетаПараметров = Новый Структура;
	
	Результат = ОбновлениеИнформационнойБазыЕГАИС.РезультатАдаптацииЗапроса();
	
	Результат.ЗначенияПараметров.Вставить("СтатусыДвижений", СтатусыДвижений());
	
	Результат.ТекстЗапроса = ОбновлениеИнформационнойБазыЕГАИС.АдаптироватьЗапросМеханизмаПроведения(
		ТекстЗапроса,
		ПолноеИмяДокумента,
		СинонимТаблицыДокумента,
		ПереопределениеРасчетаПараметров,
		ТекстыЗапросаВременныхТаблиц);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Возврат;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли

