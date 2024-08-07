
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("КассаККМ") И ЗначениеЗаполнено(ДанныеЗаполнения.КассаККМ) Тогда
			ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияПодарочныхСертификатов") Тогда
		
		Если ЗначениеЗаполнено(ДанныеЗаполнения.КассаККМ) Тогда
			ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Не ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыЧековККМ.Отложен;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = Справочники.Контрагенты.РозничныйПокупатель;
	КонецЕсли;
	
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
	Если Статус = Перечисления.СтатусыЧековККМ.Пробит Тогда
		
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			
			ЗаполнитьПодарочныеСертификаты(Отказ);
			
			ЗаполнитьОбъектРасчетов();
			
		ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
			
			Отказ = Истина;
			
			ТекстОшибки = НСтр("ru='Чек ККМ пробит. Отмена проведения невозможна'");
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект);
				
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		Для Каждого СтрокаТЧ Из ПодарочныеСертификаты Цикл
			СтрокаТЧ.ОбъектРасчетов = Неопределено;
		КонецЦикла;
		
	КонецЕсли;
	
	СуммаДокумента = ПодарочныеСертификаты.Итог("Сумма");
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ПодарочныеСертификаты,ОплатаПлатежнымиКартами");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус           = Неопределено;
	
	ПолученоНаличными = 0;
	ОплатаПлатежнымиКартами.Очистить();
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены);
	
	ИнициализироватьДокумент();
	
	ВзаиморасчетыСервер.ПриКопировании(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ПодарочныеСертификаты,ОплатаПлатежнымиКартами");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РеквизитыДляПровекиЗаполнения = Новый Массив(Новый ФиксированныйМассив(ПроверяемыеРеквизиты));
	Отказ = ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, РеквизитыДляПровекиЗаполнения);
	
	Если ЗначенияРеквизитовОбъектаИзменились(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		ПодарочныеСертификатыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	КонецЕсли;
	РозничныеПродажи.ПроверитьЗаполнениеОплатыПлатежнымиКартами(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыборкаПодарочныхСертификатовДляЗаполненияПоДокументу()
	
	МассивПодарочныхСертификатов = ПодарочныеСертификаты.ВыгрузитьКолонку("ПодарочныйСертификат");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.Ссылка КАК ПодарочныйСертификат,
	|	&Организация КАК Организация,
	|	ВидыПодарочныхСертификатов.УчетПодарочныхСертификатов2_5
	|ИЗ
	|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
	|		ПО ПодарочныеСертификаты.Владелец = ВидыПодарочныхСертификатов.Ссылка
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка В(&МассивПодарочныхСертификатов)
	|	И (НЕ ВидыПодарочныхСертификатов.УчетПодарочныхСертификатов2_5
	|		И ( ЛОЖЬ
	|			ИЛИ &Организация <> ПодарочныеСертификаты.Организация
	|		  )
	|		)";
	Запрос.УстановитьПараметр("МассивПодарочныхСертификатов", МассивПодарочныхСертификатов);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ЗаполнитьПодарочныеСертификаты(Отказ)
	
	Выборка = ВыборкаПодарочныхСертификатовДляЗаполненияПоДокументу();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.УчетПодарочныхСертификатов2_5 Тогда
			Продолжить;
		КонецЕсли;

		ДанныеДляЗаполнения = Новый Соответствие;
		ДанныеДляЗаполнения.Вставить("Организация", Выборка.Организация);
		
		Попытка
			// Перед записью подарочного сертификата 2.5 будет обновлен связанный объект расчетов.
			Справочники.ПодарочныеСертификаты.ЗаполнитьРеквизитыПодарочногоСертификата(Выборка.ПодарочныйСертификат, ДанныеДляЗаполнения);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ОписаниеОшибки = НСтр("ru = 'При записи элемента справочника ""Подарочные сертификаты"" %ПодарочныйСертификат% произошла ошибка.
								|Дополнительное описание:
								|%ДополнительноеОписание%'");
			
			ОписаниеОшибки = СтрЗаменить(
				ОписаниеОшибки, 
				"%ПодарочныйСертификат%", 
				Выборка.ПодарочныйСертификат);

			ОписаниеОшибки = СтрЗаменить(
				ОписаниеОшибки, 
				"%ДополнительноеОписание%", 
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				
			ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки,,,,Отказ);
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьОбъектРасчетов()
	
	Если ПодарочныеСертификаты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ПодарочныеСертификаты.ПодарочныйСертификат КАК Справочник.ПодарочныеСертификаты) КАК ПодарочныйСертификат
	|ПОМЕСТИТЬ ПодарочныеСертификаты
	|ИЗ
	|	&ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодарочныйСертификат
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
	|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ОбъектыРасчетов.Ссылка КАК ОбъектРасчетов
	|ИЗ
	|	ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
	|		ПО ОбъектыРасчетов.Объект = ПодарочныеСертификаты.ПодарочныйСертификат
	|			И НЕ ОбъектыРасчетов.ПометкаУдаления
	|ГДЕ
	|	ПодарочныеСертификаты.ПодарочныйСертификат.Владелец.УчетПодарочныхСертификатов2_5";
	
	Запрос.УстановитьПараметр("ПодарочныеСертификаты", ПодарочныеСертификаты.Выгрузить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Индекс = Выборка.НомерСтроки - 1;
		ПодарочныеСертификаты[Индекс].ОбъектРасчетов = Выборка.ОбъектРасчетов;
	КонецЦикла;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Кассир = Пользователи.ТекущийПользователь();
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = Справочники.Контрагенты.РозничныйПокупатель;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены,,"Кассир");
	
КонецПроцедуры

#КонецОбласти

// Осуществляет проверку того, что значения переданных реквизитов объекта изменились относительно значений, сохраненых в информационной базе.
//
// Параметры:
// 		Объект - ДокументОбъект, СправочникОбъект - Проверяемый объект.
// 		МассивПроверяемыхРеквизитов - Массив Из Строка - Массив проверяемых реквизитов. 
//
// Возвращаемое значение:
// 		Булево - Истина, если значение хотя бы одного реквизита изменилось, иначе Ложь.
//
Функция ЗначенияРеквизитовОбъектаИзменились(Объект, МассивПроверяемыхРеквизитов)
	Перем ПроверяемыеРеквизитыТЧ;
	
	Если Объект.ЭтоНовый() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЗначенияРеквизитовИзменились = Ложь;
	
	// Получение метаданных объекта
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	// Создание структуры для хранения имен табличных частей и проверяемых реквизитов в них.
	// 		Ключ -  Имя табличной части
	// 		Значение - Массив - Массив строк, реквизитов этой табличной части для проверки.
	ТабличныеЧасти = Новый Структура;
	ПроверяемыеРеквизитыШапки = Новый Массив;
	
	// Проверка реквизитов объекта и заполнение структуры по реквизитам табличных частей.
	Для Каждого Реквизит Из МассивПроверяемыхРеквизитов Цикл
		СоставныеЧастиРеквизита = СтрРазделить(Реквизит, ".");
		Если СоставныеЧастиРеквизита.Количество() = 1 Тогда
		 	// В случае если указан реквизит объекта, нужно проверить не является ли он табличной частью
			Если ПроверяемыеРеквизитыШапки.Найти(Реквизит) = Неопределено И Не ТабличныеЧасти.Свойство(Реквизит) Тогда
				Если МетаданныеОбъекта.ТабличныеЧасти.Найти(Реквизит) = Неопределено Тогда
					ПроверяемыеРеквизитыШапки.Добавить(Реквизит);
				Иначе	
					ТабличныеЧасти.Вставить(Реквизит, Новый Массив);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ИмяТабличнойЧасти = СоставныеЧастиРеквизита[0];
			ИмяРеквизита = СоставныеЧастиРеквизита[1];
			// Сохранение проверяемого реквизита табличной части в структуру
			Если Не ТабличныеЧасти.Свойство(ИмяТабличнойЧасти, ПроверяемыеРеквизитыТЧ) Тогда
				ПроверяемыеРеквизитыТЧ = Новый Массив;
				ТабличныеЧасти.Вставить(ИмяТабличнойЧасти, ПроверяемыеРеквизитыТЧ);
			КонецЕсли;
			ПроверяемыеРеквизитыТЧ.Добавить(ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	
	ШаблонТекстаЗапроса = "ВЫБРАТЬ
							|&ТекстПолейВыборки
							|ИЗ
							|	&ПолноеИмяОбъекта КАК ДанныеОбъекта
							|ГДЕ
							|	ДанныеОбъекта.Ссылка = &Ссылка";
	
	ШаблонТекстаЗапросаПоляВыборки = "ДанныеОбъекта.%1 КАК %1";
	ШаблонТекстаЗапросаТЧВыборки = "ДанныеОбъекта.%1.(
								|%2) КАК %1";
	ШаблонТекстаЗапросаПоляТЧВыборки = "%1 КАК %1";
	
	МассивТекстовЗапросовДляРеквизитов = Новый Массив;
	Если ПроверяемыеРеквизитыШапки.Количество() Тогда
		Для Каждого Реквизит Из ПроверяемыеРеквизитыШапки Цикл
			МассивТекстовЗапросовДляРеквизитов.Добавить(СтрШаблон(ШаблонТекстаЗапросаПоляВыборки, Реквизит));
		КонецЦикла;
	КонецЕсли;
	Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
		Если ТабличнаяЧасть.Значение.Количество() Тогда
			// Для корректного сравнения строк табличной части нужно добавить стандартный реквизит "Номер строки"
			СтандартныйРеквизитНомерСтроки = МетаданныеОбъекта.ТабличныеЧасти[ТабличнаяЧасть.Ключ].СтандартныеРеквизиты.НомерСтроки; // ОписаниеСтандартногоРеквизита 
			ИмяРеквизитаНомерСтроки = СтандартныйРеквизитНомерСтроки.Имя;
			Если ТабличнаяЧасть.Значение.Найти(ИмяРеквизитаНомерСтроки) = Неопределено Тогда
				ТабличнаяЧасть.Значение.Добавить(ИмяРеквизитаНомерСтроки);
			КонецЕсли;
			МассивТекстовЗапросовДляРеквизитовТЧ = Новый Массив;
			Для Каждого	Реквизит Из ТабличнаяЧасть.Значение Цикл
				МассивТекстовЗапросовДляРеквизитовТЧ.Добавить(СтрШаблон(ШаблонТекстаЗапросаПоляТЧВыборки, Реквизит));	
			КонецЦикла;
			ТекстЗапросаРеквизитовТЧ = СтрСоединить(МассивТекстовЗапросовДляРеквизитовТЧ, ","+Символы.ПС);
			ТекстЗапросаПоТабличнойЧасти = СтрШаблон(ШаблонТекстаЗапросаТЧВыборки, ТабличнаяЧасть.Ключ, ТекстЗапросаРеквизитовТЧ);
		Иначе
			// Если для проверки задана табличная часть без указания конкретных реквизитов, то это значит, что сравнение будет проведено в разрезе всех реквизитов.
			ТекстЗапросаПоТабличнойЧасти = СтрШаблон(ШаблонТекстаЗапросаПоляВыборки, ТабличнаяЧасть.Ключ);
		КонецЕсли;	
		МассивТекстовЗапросовДляРеквизитов.Добавить(ТекстЗапросаПоТабличнойЧасти);
	КонецЦикла;
	
	Если МассивТекстовЗапросовДляРеквизитов.Количество() Тогда
		ТекстЗапросаПолейВыборки = СтрСоединить(МассивТекстовЗапросовДляРеквизитов, ","+Символы.ПС);
		ТекстЗапроса = СтрЗаменить(ШаблонТекстаЗапроса, "&ТекстПолейВыборки", ТекстЗапросаПолейВыборки);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолноеИмяОбъекта", МетаданныеОбъекта.ПолноеИмя());

		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		Запрос.УстановитьПараметр("ПолноеИмяОбъекта", МетаданныеОбъекта.ПолноеИмя());
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Для Каждого	Реквизит Из ПроверяемыеРеквизитыШапки Цикл
				Если Выборка[Реквизит] <> Объект[Реквизит] Тогда
					ЗначенияРеквизитовИзменились = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Не ЗначенияРеквизитовИзменились Тогда
				Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
					ДанныеТЧПоСсылке = Выборка[ТабличнаяЧасть.Ключ].Выгрузить();
					ДанныеТЧИзОбъекта = Объект[ТабличнаяЧасть.Ключ].Выгрузить();
					РезультатСравнения = ОбщегоНазначенияУТ.СравнитьТаблицыЗначений(ДанныеТЧПоСсылке, ДанныеТЧИзОбъекта, Ложь);
					Если РезультатСравнения.Количество() Тогда
						ЗначенияРеквизитовИзменились = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначенияРеквизитовИзменились;
КонецФункции

#КонецОбласти

#КонецЕсли
