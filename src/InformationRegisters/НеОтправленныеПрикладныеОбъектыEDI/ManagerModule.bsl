#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(ПрикладнойОбъект)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает признак того, что документ больше не стоит предлагать к отправке для массива документов.
// 
// Параметры:
// 	МассивПрикладныхОбъектов - Массив - массив документов
//
Процедура УстановитьПризнакНеПредлагатьКОтправкеДляМассива(МассивПрикладныхОбъектов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если МассивПрикладныхОбъектов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ПрикладнойОбъект Из МассивПрикладныхОбъектов Цикл
		
		НачатьТранзакцию();
	
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НеОтправленныеПрикладныеОбъектыEDI");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("ПрикладнойОбъект", ПрикладнойОбъект);
	
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.НеОтправленныеПрикладныеОбъектыEDI.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ПрикладнойОбъект.Установить(ПрикладнойОбъект);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() = 0 Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			НаборЗаписей[0].НеПредлагатьКОтправке = Истина;
			НаборЗаписей.Записать();
				
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			
			ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ВызватьИсключение НСтр("ru = 'Не удалось изменить признак ""не предлагать к отправке"".'");
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет, требуется ли для документа запись в регистре и создает или удаляет ее.
// 
// Параметры:
// 	ДанныеДокумента - Структура - содержит:
//   * ПрикладнойОбъект      - ДокументСсылка - 
//   * Контрагент            - ОпределяемыйТип.КонтрагентEDI -
//   * Организация           - ОпределяемыйТип.ОрганизацияEDI -
//   * НеПредлагатьКОтправке - Булево - текущее значение признака в регистре.
//   * Согласован            - Булево - документ прошел внутреннее согласование.
//   * Проведен              - Булево - признак проведения документа.
//
Процедура ОтразитьНеобходимостьОтправкиПоДаннымДокумента(ДанныеДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДокумента.Вставить("НеПредлагатьКОтправке", Ложь);
	
	ТребуетсяЗапись                       = Ложь;
	ЕстьЗапись                            = Ложь;
	УжеОтправлен                          = Ложь;
	ПоставщикПринимаетЗаказыОтКонтрагента = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НеОтправленныеПрикладныеОбъектыEDI.ПрикладнойОбъект      КАК ПрикладнойОбъект,
	|	НеОтправленныеПрикладныеОбъектыEDI.НеПредлагатьКОтправке КАК НеПредлагатьКОтправке
	|ИЗ
	|	РегистрСведений.НеОтправленныеПрикладныеОбъектыEDI КАК НеОтправленныеПрикладныеОбъектыEDI
	|ГДЕ
	|	НеОтправленныеПрикладныеОбъектыEDI.ПрикладнойОбъект = &ПрикладнойОбъект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////1
	|ВЫБРАТЬ
	|	НастройкиПоставщикаEDI.РежимРаботыСЗаказамиКлиентов КАК РежимРаботыСЗаказамиКлиентов,
	|	""ПоПокупателю""                                    КАК ВариантРежима
	|ИЗ
	|	РегистрСведений.НастройкиПоставщикаEDI КАК НастройкиПоставщикаEDI
	|ГДЕ
	|	НастройкиПоставщикаEDI.Поставщик    = &Контрагент
	|	И НастройкиПоставщикаEDI.Покупатель = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НастройкиПоставщикаEDI.РежимРаботыСЗаказамиКлиентов,
	|	""ПоПоставщику""
	|ИЗ
	|	РегистрСведений.НастройкиПоставщикаEDI КАК НастройкиПоставщикаEDI
	|ГДЕ
	|	НастройкиПоставщикаEDI.Поставщик    = &Контрагент
	|	И НастройкиПоставщикаEDI.Покупатель В (&ПустыеЗначенияПокупатели)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////2
	|ВЫБРАТЬ
	|	СостоянияДокументовEDI.ИдентификаторВСервисе КАК ИдентификаторВСервисе
	|ИЗ
	|	РегистрСведений.СостоянияДокументовEDI КАК СостоянияДокументовEDI
	|ГДЕ
	|	СостоянияДокументовEDI.ПрикладнойОбъект = &ПрикладнойОбъект";
	
	Запрос.УстановитьПараметр("ПрикладнойОбъект",         ДанныеДокумента.ПрикладнойОбъект);
	Запрос.УстановитьПараметр("Контрагент",               ДанныеДокумента.Контрагент);
	Запрос.УстановитьПараметр("Организация",              ДанныеДокумента.Организация);
	Запрос.УстановитьПараметр("ПустыеЗначенияПокупатели", ДокументыEDI.МассивПустыхЗначенийПоОписаниюТипа(РегистрыСведений.НастройкиПоставщикаEDI.ТипыИзмерения("Покупатель")));
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаЕстьЗапись = РезультатЗапроса[0].Выбрать();
	
	Если ВыборкаЕстьЗапись.Следующий() Тогда
	
		ЕстьЗапись = Истина;
		ДанныеДокумента.НеПредлагатьКОтправке = ВыборкаЕстьЗапись.НеПредлагатьКОтправке;
	
	КонецЕсли;
	
	ПараметрыПриемаЗаказовПоставщикомОтПокупателя = РегистрыСведений.НастройкиПоставщикаEDI.ПараметрыПриемаЗаказовПоставщикомОтПокупателя();
	ВыборкаРежимПриемаЗаказов = РезультатЗапроса[1].Выбрать();
	
	Пока ВыборкаРежимПриемаЗаказов.Следующий() Цикл
		
		Если ВыборкаРежимПриемаЗаказов.ВариантРежима = "ПоПокупателю" Тогда
			
			ПараметрыПриемаЗаказовПоставщикомОтПокупателя.РежимПриемаЗаказовПоПокупателю = ВыборкаРежимПриемаЗаказов.РежимРаботыСЗаказамиКлиентов;
			
		ИначеЕсли ВыборкаРежимПриемаЗаказов.ВариантРежима = "ПоПоставщику" Тогда
			
			ПараметрыПриемаЗаказовПоставщикомОтПокупателя.РежимПриемаЗаказовОбщий        = ВыборкаРежимПриемаЗаказов.РежимРаботыСЗаказамиКлиентов;
			
		КонецЕсли;
		
	КонецЦикла;
	
	РежимПриемаЗаказов = РегистрыСведений.НастройкиПоставщикаEDI.РежимПриемаЗаказовПоставщикомОтПокупателя(ПараметрыПриемаЗаказовПоставщикомОтПокупателя);
	ПоставщикПринимаетЗаказыОтКонтрагента = (РежимПриемаЗаказов = Перечисления.РежимыРаботыСЗаказамиКлиентаEDI.ПриниматьВТерминахПоставщика
	                                         Или РежимПриемаЗаказов = Перечисления.РежимыРаботыСЗаказамиКлиентаEDI.ПриниматьВТерминахПоставщикаИПокупателя);
	
	ВыборкаУжеОтправлен = РезультатЗапроса[2].Выбрать();
	
	Если ВыборкаУжеОтправлен.Следующий() Тогда
	
		УжеОтправлен = Истина;
	
	КонецЕсли;
	
	ТребуетсяЗапись = ДанныеДокумента.Согласован
	                  И ДанныеДокумента.Проведен
	                  И ПоставщикПринимаетЗаказыОтКонтрагента
	                  И Не УжеОтправлен;
	
	Если ЕстьЗапись 
		И Не ТребуетсяЗапись Тогда
		
		УдалитьЗапись(ДанныеДокумента.ПрикладнойОбъект);
		
	ИначеЕсли ТребуетсяЗапись Тогда
		
		ПараметрыЗаписи = ПараметрыЗаписиВРегистр();
		ЗаполнитьЗначенияСвойств(ПараметрыЗаписи, ДанныеДокумента);
		ВыполнитьЗаписьВРегистр(ПараметрыЗаписи)
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет запись по прикладному объекту из регистра
// 
// Параметры:
// 	ПрикладнойОбъект - ОпределяемыйТип.ПрикладнойДокументОбъектEDI - документ, по которому требуется удалить запись
//
Процедура УдалитьЗапись(ПрикладнойОбъект) Экспорт
	
	НаборЗаписей = РегистрыСведений.НеОтправленныеПрикладныеОбъектыEDI.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПрикладнойОбъект.Установить(ПрикладнойОбъект);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр
// 
// Параметры:
// 	ПараметрыЗаписи - Структура - содержит:
// * НеПредлагатьКОтправке - Булево - 
// * Менеджер - СправочникСсылка.Пользователи -
// * Номер - Строка -
// * Дата - Дата -
// * Сумма - Число -
// * Валюта - СправочникСсылка.Валюты -
// * Контрагент - ОпределяемыйТип.КонтрагентEDI -
// * Организация - ОпределяемыйТип.ОрганизацияEDI -
// * ПрикладнойОбъект - ОпределяемыйТип.ПрикладнойДокументОбъектEDI 
//
Процедура ВыполнитьЗаписьВРегистр(ПараметрыЗаписи) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.НеОтправленныеПрикладныеОбъектыEDI.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПрикладнойОбъект.Установить(ПараметрыЗаписи.ПрикладнойОбъект);
	Запись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(Запись, ПараметрыЗаписи);
	НаборЗаписей.Записать()
	
КонецПроцедуры

// Конструктор параметров записи в регистр
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * НеПредлагатьКОтправке - Булево - 
// * Менеджер - СправочникСсылка.Пользователи -
// * Номер - Строка -
// * Дата - Дата -
// * Сумма - Число -
// * Валюта - СправочникСсылка.Валюты -
// * Контрагент - ОпределяемыйТип.КонтрагентEDI -
// * Организация - ОпределяемыйТип.ОрганизацияEDI -
// * ПрикладнойОбъект - ОпределяемыйТип.ПрикладнойДокументОбъектEDI -
//
Функция ПараметрыЗаписиВРегистр() Экспорт
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ПрикладнойОбъект"     , Неопределено);
	ПараметрыЗаписи.Вставить("Организация"          , Неопределено);
	ПараметрыЗаписи.Вставить("Контрагент"           , Неопределено);
	ПараметрыЗаписи.Вставить("Валюта"               , Неопределено);
	ПараметрыЗаписи.Вставить("Сумма"                , Неопределено);
	ПараметрыЗаписи.Вставить("Дата"                 , Неопределено);
	ПараметрыЗаписи.Вставить("Номер"                , Неопределено);
	ПараметрыЗаписи.Вставить("Менеджер"             , Неопределено);
	ПараметрыЗаписи.Вставить("НеПредлагатьКОтправке", Ложь);
	
	Возврат ПараметрыЗаписи;
	
КонецФункции

#КонецОбласти

#КонецЕсли