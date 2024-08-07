
#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  СтруктураПоддерживаемыхВерсий - см. ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов.ПоддерживаемыеВерсии
// 
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// 
// Параметры:
//  Типы - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
// 
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	Типы.Добавить(Метаданные.РегистрыСведений.ВидыПриложенийОбластейДанных);
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	Параметры.Вставить("ПредставлениеВидаПриложения", ВидыПриложенийСервер.ПредставлениеТекущегоВидаПриложения());
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента.
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	Параметры.Вставить("ПредставлениеВидаПриложения", ВидыПриложенийСервер.ПредставлениеТекущегоВидаПриложения());
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов принимаемых сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив из ОбщийМодуль - коллекция модулей, содержащих обработчики.
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов отправляемых сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив из ОбщийМодуль - коллекция модулей, содержащих обработчики..
//
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Вызывается при установке базового вида приложения.
//
// Параметры:
//  РезультатОбработки - Структура - результаты обработки метода (возвращаемые данные):
//   * Ошибка - Булево - признак ошибки обработки.
//   * Сообщение - Строка - сообщение об ошибке обработки.
//
Процедура УстановкаБазовогоВидаПриложения(РезультатОбработки) Экспорт
	
	ВидыПриложенийПереопределяемый.ПриУстановкеБазовогоВидаПриложения(РезультатОбработки);
	
КонецПроцедуры

// Вызывается при прикреплении области данных или завершении миграции приложения.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ВидПриложения - Неопределено, ОбъектXDTO - тело сообщения.
//
Процедура УстановитьВидПриложенияПоСообщению(ВидПриложения) Экспорт
	
КонецПроцедуры

#КонецОбласти