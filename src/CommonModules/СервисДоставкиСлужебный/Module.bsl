////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис доставки".
// ОбщийМодуль.СервисДоставкиСлужебный.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выводит сообщение пользователю о нехватки прав доступа.
Процедура СообщитьПользователюОНарушенииПравДоступа() Экспорт
	
	ТекстСообщения = НСтр("ru = 'Нарушение прав доступа.'");
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

Процедура ПроверитьОрганизациюБизнесСети(Организация, Отказ) Экспорт
	
	ПроверитьРегистрациюОрганизации(Организация, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьРеквизитыАдреса(Объект, ИмяРеквизита, ЕстьОшибки, ВыводитьПредупреждения) Экспорт
	
	ЗначениеРеквизита = Объект[ИмяРеквизита + "Значение"];
	ЗначениеПредставление = Объект[ИмяРеквизита + "Представление"];
	
	ИмяПоля = ИмяРеквизита;
	ЗаголовокПоля = ИмяРеквизита;
	ПутьКДанным = "";
	
	Если Найти(ИмяРеквизита, "ЮридическийАдрес") Тогда
		ИмяПоля = СтрЗаменить(ИмяРеквизита, "ЮридическийАдрес", "");
		ВладелецАдреса = Объект[ИмяПоля + "Наименование"];
		
		ТекстОшибкиПустогоАдреса = НСтр("ru='Не заполнен юридический адрес у участника грузоперевозки ""%1"".
										|Добавьте юридический адрес участнику ""%1"".'");
		
		ТекстОшибкиНекорректногоАдреса = НСтр("ru='Некорректный формат юридического адреса у участника грузоперевозки ""%1"". 
											|Проверьте корректность адреса вручную.'");
		
		Если Найти(ИмяРеквизита, "Отправитель") Тогда
			ЗаголовокПоля = "Отправитель";
		ИначеЕсли Найти(ИмяРеквизита, "Получатель") Тогда
			ЗаголовокПоля = "Получатель";
		ИначеЕсли Найти(ИмяРеквизита, "Плательщик") Тогда
			ЗаголовокПоля = "Плательщик";
		КонецЕсли;
		
		ЭлементФормы = Объект.Элементы.Найти(ИмяПоля);
		Если ЭлементФормы <> Неопределено Тогда
			ПутьКДанным = ЭлементФормы.ПутьКДанным;
		КонецЕсли;
		
	Иначе
		ВладелецАдреса = Объект[ИмяРеквизита + "Владелец"];
		
		ТекстОшибкиПустогоАдреса = НСтр("ru='У выбранного в поле ""%1"" владельца адреса не заполнен адрес доставки/склада.
										|Добавьте адрес доставки/склада для этого владельца или введите произвольный адрес.'");
		
		ТекстОшибкиНекорректногоАдреса = НСтр("ru='Некорректный формат адреса в поле ""%1"". 
											|Проверьте корректность адреса вручную.'");
		
		ЭлементФормы = Объект.Элементы.Найти(ИмяПоля);
		
		Если ЭлементФормы <> Неопределено Тогда
			ЗаголовокПоля = ЭлементФормы.Заголовок;
			ПутьКДанным = ЭлементФормы.ПутьКДанным;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВладелецАдреса)
		И Не ЗначениеЗаполнено(ЗначениеПредставление) Тогда
		ЕстьОшибки = Истина;
		Если ВыводитьПредупреждения Тогда
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстОшибкиПустогоАдреса,
				ЗаголовокПоля)
				,,ПутьКДанным);
		КонецЕсли;
		Возврат;
	КонецЕсли;
				
	Если Не ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		
		ЕстьОшибки = Истина;
		Если ЗначениеЗаполнено(ЗначениеПредставление) Тогда
			
			Если ВыводитьПредупреждения Тогда
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиНекорректногоАдреса,
					ЗаголовокПоля)
					,,ПутьКДанным);
			КонецЕсли;
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураАдреса = СервисДоставки.ЗначениеИзСтрокиJSON(ЗначениеРеквизита);
	
	Если Не ЗначениеЗаполнено(СтруктураАдреса) Тогда
		ЕстьОшибки = Истина;
		Если ВыводитьПредупреждения Тогда
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстОшибкиНекорректногоАдреса,
				ЗаголовокПоля)
				,,ПутьКДанным);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СписокОшибок = РаботаСАдресами.ПроверитьАдрес(ЗначениеРеквизита).СписокОшибок;
	
	Если СписокОшибок.Количество() <> 0 Тогда
		ЕстьОшибки = Истина;
		
		Если НЕ СписокОшибок[0].Пометка Тогда
			Если ВыводитьПредупреждения Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибкиНекорректногоАдреса,
					ЗаголовокПоля)
					,,ПутьКДанным);
			КонецЕсли;
				
		Иначе
			
			Если ВыводитьПредупреждения Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиНекорректногоАдреса,
					ЗаголовокПоля);
					
				Для Каждого ТекущаяОшибка Из СписокОшибок Цикл
					ТекстОшибки = ТекстОшибки + Символы.ПС + ТекущаяОшибка.Представление;
				КонецЦикла;
				
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,ПутьКДанным);
			КонецЕсли;
			
		КонецЕсли;
	ИначеЕсли СтруктураАдреса.Свойство("Id") И Не ЗначениеЗаполнено(СтруктураАдреса.Id) Тогда
		
		ЕстьОшибки = Истина;
		
		Если ВыводитьПредупреждения Тогда
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстОшибкиНекорректногоАдреса,
				ЗаголовокПоля)
				,,ПутьКДанным);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьУникальныйИдентификаторАдреса(Объект, ИмяРеквизита, ЕстьОшибки, ВыводитьПредупреждения) Экспорт
	
	ВладелецАдреса = Объект[ИмяРеквизита + "Владелец"];
	ЗначениеРеквизита = Объект[ИмяРеквизита + "Значение"];
	ЗначениеПредставление = Объект[ИмяРеквизита + "Представление"];
	ЭтоАдресОтправки = (СтрНайти(ИмяРеквизита, "Отправитель") > 0);
	
	ШаблонОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Некорректный формат адреса в поле ""%1"". Проверьте корректность адреса.'"), 
		?(ЭтоАдресОтправки, НСтр("ru='Откуда'"), НСтр("ru='Куда'")));
	
	
	Если ЗначениеЗаполнено(ВладелецАдреса)
		И Не ЗначениеЗаполнено(ЗначениеПредставление) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='У выбранного в поле ""%1"" владельца адреса не заполнен адрес доставки/склада. 
				|Добавьте адрес доставки/склада для этого владельца или введите произвольный адрес.'"), 
			?(ЭтоАдресОтправки, НСтр("ru='Откуда'"), НСтр("ru='Куда'")));
			
		ЕстьОшибки = Истина;
		Если ВыводитьПредупреждения Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,ИмяРеквизита + "Представление");
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		
		Если ЗначениеЗаполнено(ЗначениеПредставление) Тогда
			
			ЕстьОшибки = Истина;
			Если ВыводитьПредупреждения Тогда
				ОбщегоНазначения.СообщитьПользователю(ШаблонОшибки,,ИмяРеквизита + "Представление");
			КонецЕсли;
			
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	СтруктураАдреса = СервисДоставки.ЗначениеИзСтрокиJSON(ЗначениеРеквизита);
	
	Если Не ЗначениеЗаполнено(СтруктураАдреса) Тогда
		ЕстьОшибки = Истина;
		Если ВыводитьПредупреждения Тогда
			ОбщегоНазначения.СообщитьПользователю(ШаблонОшибки,,ИмяРеквизита + "Представление");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтруктураАдреса.Id) Тогда 
		ЕстьОшибки = Истина;
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось проверить формат адреса в поле ""%1"". Проверьте корректность адреса вручную.'"), 
			?(ЭтоАдресОтправки, НСтр("ru='Откуда'"), НСтр("ru='Куда'")));
			
		Если ВыводитьПредупреждения Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,ИмяРеквизита + "Представление");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗначенияАдреса(Объект, ИмяРеквизита, ЕстьИзменения = Ложь) Экспорт
	
	ИмяРеквизитаПредставление = ИмяРеквизита + "Представление";
	ИмяРеквизитаАдресЗначение = ИмяРеквизита + "Значение";
	
	Если ЗначениеЗаполнено(Объект[ИмяРеквизитаПредставление])
		И НЕ ЗначениеЗаполнено(Объект[ИмяРеквизитаАдресЗначение]) Тогда
			ЗначениеВJSON = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Объект[ИмяРеквизитаПредставление]
																,Перечисления.ТипыКонтактнойИнформации.Адрес);
																
			Объект[ИмяРеквизитаАдресЗначение] = ЗначениеВJSON;
			
			ЕстьИзменения = Истина;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект[ИмяРеквизитаАдресЗначение]) Тогда
		
		СтруктураАдреса = СервисДоставки.ЗначениеИзСтрокиJSON(Объект[ИмяРеквизитаАдресЗначение]);
		
		Если Не ЗначениеЗаполнено(СтруктураАдреса) Тогда
			Возврат;
		КонецЕсли;
			
		СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(Объект[ИмяРеквизитаАдресЗначение], Новый Структура("КодыАдреса, ПроверитьАдрес", Истина, Истина));
		
		Если СведенияОбАдресе.ТипАдреса <> "ВСвободнойФорме" Тогда 
			Объект[ИмяРеквизитаАдресЗначение] = РаботаСАдресами.ПоляАдресаВJSON(СведенияОбАдресе);
			ЕстьИзменения = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьАдресПоПараметрам(Параметры) Экспорт
	
	РезультатПроверкиАдреса = "";
	
	Если Не ЗначениеЗаполнено(Параметры.Значение)
		И ЗначениеЗаполнено(Параметры.ЗначенияПолей) Тогда
		СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(Параметры.ЗначенияПолей, 
			Новый Структура("КодыАдреса, ПроверитьАдрес", Истина, Истина));
		Если СведенияОбАдресе.РезультатПроверкиАдреса = "Успех" Тогда
			Параметры.Значение = РаботаСАдресами.ПоляАдресаВJSON(СведенияОбАдресе);
			Параметры.Представление = СведенияОбАдресе.Представление;
			РезультатПроверкиАдреса = СведенияОбАдресе.РезультатПроверкиАдреса;
		КонецЕсли;
	КонецЕсли;
	
	Если РезультатПроверкиАдреса <> "Успех" Тогда
		Если Не ЗначениеЗаполнено(Параметры.Значение) Тогда
			
			Если ЗначениеЗаполнено(Параметры.Представление) Тогда
				Параметры.Представление = ПреобразоватьПредставлениеАдреса(Параметры.Представление);
				Параметры.Значение = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Параметры.Представление,
																				Перечисления.ТипыКонтактнойИнформации.Адрес);
			КонецЕсли;
		
			Если Не ЗначениеЗаполнено(Параметры.Значение)
				И ЗначениеЗаполнено(Параметры.Владелец) Тогда
				ЗаполнитьПараметрыАдресаПоВладельцу(Параметры);
				Если Не ЗначениеЗаполнено(Параметры.Значение)
					И ЗначениеЗаполнено(Параметры.Представление) Тогда
					Параметры.Представление = ПреобразоватьПредставлениеАдреса(Параметры.Представление);
					Параметры.Значение = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Параметры.Представление,
																					Перечисления.ТипыКонтактнойИнформации.Адрес);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		// Не меняем значение юридического адреса, так как он получается из ЕГРН и у него нет жесткой привязки к ФИАС.
		Если НРег(Параметры.ТипАдреса) <> "юридический" Тогда
			Если ЗначениеЗаполнено(Параметры.Значение) Тогда
				
				СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(Параметры.Значение, 
					Новый Структура("КодыАдреса, ПроверитьАдрес", Истина, Истина));
																
				Если СведенияОбАдресе.РезультатПроверкиАдреса <> "Успех"
					И ЗначениеЗаполнено(Параметры.Представление) Тогда
					Параметры.Представление = ПреобразоватьПредставлениеАдреса(Параметры.Представление);
					Параметры.Значение = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Параметры.Представление,
																					Перечисления.ТипыКонтактнойИнформации.Адрес);
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьЗначенияАдреса(Параметры, "");
	
КонецПроцедуры

Функция ПараметрыВидаКонтактнойИнформации(ВидКонтактнойИнформацииСтрока = "") Экспорт
	
	СтруктураКонтактнойИнформации = Новый Структура;
	СтруктураКонтактнойИнформации.Вставить("Вид", Неопределено);
	СтруктураКонтактнойИнформации.Вставить("Тип", Неопределено);
	СтруктураКонтактнойИнформации.Вставить("ТипНаименование", "");
	
	Если ВидКонтактнойИнформацииСтрока = "" Тогда
		ВидКонтактнойИнформации = ВидКонтактнойИнформации("АдресСкладаОрганизации");
	Иначе
		ВидКонтактнойИнформации = ВидКонтактнойИнформации(ВидКонтактнойИнформацииСтрока);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидКонтактнойИнформации) Тогда
		Если ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		
			СтруктураВидаКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(ВидКонтактнойИнформации);
			
			СтруктураВидаКонтактнойИнформации.МожноИзменятьСпособРедактирования = Ложь;
			СтруктураВидаКонтактнойИнформации.РедактированиеТолькоВДиалоге = Истина;
			СтруктураВидаКонтактнойИнформации.ОбязательноеЗаполнение = Истина;
			
			НастройкиПроверки = СтруктураВидаКонтактнойИнформации.НастройкиПроверки;
			НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
			НастройкиПроверки.ПроверятьКорректность = Истина;
			
			СтруктураКонтактнойИнформации.Вид = СтруктураВидаКонтактнойИнформации;
			СтруктураКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
			СтруктураКонтактнойИнформации.ТипНаименование = "Адрес";
			
		ИначеЕсли ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			
			СтруктураКонтактнойИнформации.Вид = ВидКонтактнойИнформации;
			СтруктураКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
			СтруктураКонтактнойИнформации.ТипНаименование = "Телефон";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураКонтактнойИнформации;
	
КонецФункции

Функция КонтактнаяИнформацияПоПредставлению(Представление, ТипКонтактнойИнформацииИмя) Экспорт
	
	Если ТипКонтактнойИнформацииИмя = "Телефон" Тогда
		ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон
	ИначеЕсли ТипКонтактнойИнформацииИмя = "Адрес" Тогда
		ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Адрес
	КонецЕсли;
	
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Представление, 
			ТипКонтактнойИнформации);
	
КонецФункции

// Организации бизнес сети.
// 
// Возвращаемое значение:
//  ТаблицаЗначений -  Организации бизнес сети
Функция ОрганизацииБизнесСети() Экспорт
	
	ИмяСправочникаОрганизации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Справочник.%1", 
		ОбщегоНазначенияБЭД.ИмяПрикладногоСправочника("Организации"));
	ЕстьПраво = ПравоДоступа("Чтение", Метаданные.НайтиПоПолномуИмени(ИмяСправочникаОрганизации));
	
	Если Не ЕстьПраво Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОрганизацииБизнесСеть.Организация КАК Организация,
		|	ОрганизацииБизнесСеть.Идентификатор КАК Идентификатор,
		|	Организации.Наименование КАК Наименование
		|ИЗ
		|	РегистрСведений.ОрганизацииБизнесСеть КАК ОрганизацииБизнесСеть
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник_Организации КАК Организации
		|		ПО ОрганизацииБизнесСеть.Организация = Организации.Ссылка
		|ГДЕ
		|	НЕ Организации.Ссылка ЕСТЬ NULL
		|	И НЕ ОрганизацииБизнесСеть.Организация.ПометкаУдаления
		|	И ОрганизацииБизнесСеть.Идентификатор <> """"";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник_Организации", ИмяСправочникаОрганизации);
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);

	Возврат Результат;
	
КонецФункции

Функция ОрганизацияПодключена(Организация = Неопределено) Экспорт
	
	ЕстьОшибки = Ложь;
	ПроверитьОрганизацию(Организация, ЕстьОшибки);
	Если ЕстьОшибки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат БизнесСеть.ОрганизацияПодключена(Организация);
	
КонецФункции

Функция Типы() Экспорт
	
	Возврат СервисДоставкиПовтИсп.ТипыДанных();
	
КонецФункции

Процедура УстановитьДоступностьНастройкиСервисаДоставки(Форма) Экспорт
	
	СервисДоставкиПереопределяемый.УстановитьДоступностьНастройкиСервисаДоставки(Форма);
	
КонецПроцедуры

Процедура ПроверитьДоступностьСервисаДоставки(Результат) Экспорт
	
	СервисДоставкиПереопределяемый.ПроверитьДоступностьСервисаДоставки(Результат);
	
КонецПроцедуры

Функция ПолучитьОписаниеТипаПоСтруктуре(СтруктураТипа) Экспорт
	
	ТипДанныхНаименование = СтруктураТипа.name;
	НовыйТип = Неопределено;
	Если ТипДанныхНаименование = "Число" Тогда
		ЗначениеДопустимогоЗнака = ?(СтруктураТипа.allowedSign = 0, ДопустимыйЗнак.Любой, ДопустимыйЗнак.Неотрицательный);
		НовыйТип = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(СтруктураТипа.digits,
			СтруктураТипа.fractionDigits, ЗначениеДопустимогоЗнака));
		
	ИначеЕсли ТипДанныхНаименование = "Строка" Тогда
		НовыйТип = Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(СтруктураТипа.length,
			?(СтруктураТипа.allowedLength = 0, ДопустимаяДлина.Переменная, ДопустимаяДлина.Фиксированная)));
	ИначеЕсли ТипДанныхНаименование = "Дата" Тогда
		ЗначениеЧастиДаты = ЧастиДаты.ДатаВремя; // 0 - ДатаВремя, 1 - Дата, 2 - Время
		Если СтруктураТипа.dateFractions = 1 Тогда
			ЗначениеЧастиДаты = ЧастиДаты.Дата;
		ИначеЕсли СтруктураТипа.DateFractions = 2 Тогда
			ЗначениеЧастиДаты = ЧастиДаты.Время;
		КонецЕсли;
		НовыйТип = Новый ОписаниеТипов("Строка", Новый КвалификаторыДаты(ЗначениеЧастиДаты));
	ИначеЕсли ТипДанныхНаименование = "Булево" Тогда
		НовыйТип = Новый ОписаниеТипов("Булево");
	КонецЕсли;
	
	Возврат НовыйТип;
	
КонецФункции

// Возвращает контактную информацию объектов.
//
// Параметры:
//  МассивВладельцев - Массив Из СправочникСсылка - владельцы контактных лиц.
//  ТипыКонтактнойИнформации - Массив Из ПеречислениеСсылка.ТипыКонтактнойИнформации - массив типов контактной информации.
//  
// Возвращаемое значение:
//  Соответствие Из СправочникСсылка - соответствие со списками значений контактной информации.
//  ТипыКонтактнойИнформации - Массив Из ПеречислениеСсылка.ТипыКонтактнойИнформации - массив типов контактной информации.
Функция КонтактнаяИнформацияОбъектов(Знач МассивВладельцев, Знач ТипыКонтактнойИнформации = Неопределено) Экспорт
	
	Результат = Новый Соответствие;

	КоличествоЭлементов = МассивВладельцев.ВГраница();
	Для Индекс = 0 По КоличествоЭлементов Цикл
		
		ИндексЭлемента = КоличествоЭлементов - Индекс;
		Если Не ЗначениеЗаполнено(МассивВладельцев.Получить(ИндексЭлемента)) Тогда
			МассивВладельцев.Удалить(ИндексЭлемента);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ТипыКонтактнойИнформации) Тогда
		
		ТипыКонтактнойИнформации = Новый Массив;
		ТипыКонтактнойИнформации.Добавить(Перечисления.ТипыКонтактнойИнформации.Адрес);
		ТипыКонтактнойИнформации.Добавить(Перечисления.ТипыКонтактнойИнформации.Телефон);
		
	КонецЕсли;
	
	Для Каждого ВладелецКИ Из МассивВладельцев Цикл
		Результат.Вставить(ВладелецКИ, Новый СписокЗначений);
	КонецЦикла;
	
	МассивДобавленнойКонтактнойИнформации = Новый Массив;
	
	ТаблицаКонтактнойИнформации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивВладельцев, ТипыКонтактнойИнформации,, Дата(1, 1, 1));
	Для Каждого СтрокаКИ Из ТаблицаКонтактнойИнформации Цикл
		
		СписокЗначенийКонтактнойИнформации = Результат.Получить(СтрокаКИ.Объект);
		
		Если МассивДобавленнойКонтактнойИнформации.Найти(СтрокаКИ.Представление) = Неопределено Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаКИ.Значение)
				И Не ЗначениеЗаполнено(СтрокаКИ.ЗначенияПолей) Тогда
				Продолжить;
			КонецЕсли;
			
			СписокЗначенийКонтактнойИнформации.Добавить(Новый Структура("Тип, Значение, Представление",
				СтрокаКИ.Тип,
				?(ЗначениеЗаполнено(СтрокаКИ.Значение),
					СтрокаКИ.Значение,
					УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(СтрокаКИ.ЗначенияПолей)),
				СтрокаКИ.Представление));
			
			МассивДобавленнойКонтактнойИнформации.Добавить(СтрокаКИ.Представление);
			
		КонецЕсли;
			
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьПредставлениеАдреса(Знач Представление)
	
	НовоеПредставление = Представление;
	
	ЧастиАдреса = СтрРазделить(НовоеПредставление, "," + Символы.ПС, Ложь);
	
	НомерЧасти = 0;
	Для Каждого ТекЧасть Из ЧастиАдреса Цикл
		
		ЧастиЕдиницыАдреса = СтрРазделить(ТекЧасть, " ", Ложь);
		
		// Обработаем варианты сокращенного названия региона в адресе типа "МО".
		Если ЧастиЕдиницыАдреса.Количество() = 1 Тогда
			
			ПерваяЧастьЕдинцыАдреса = НРег(ЧастиЕдиницыАдреса[0]);
			
			Если (ПерваяЧастьЕдинцыАдреса = "мо") Тогда
				ЧастиАдреса[НомерЧасти] = СтрЗаменить(ТекЧасть, " " + ПерваяЧастьЕдинцыАдреса, "Московская обл");
			КонецЕсли;
		КонецЕсли;
		
		// Обработаем вариант номера дама в адресе типа "д 10 к 2".
		Если ЧастиЕдиницыАдреса.Количество() = 4 Тогда
			
			ПерваяЧастьЕдинцыАдреса = НРег(ЧастиЕдиницыАдреса[0]);
			ТретьяЧастьЕдинцыАдреса = НРег(ЧастиЕдиницыАдреса[2]);
			
			Если (ПерваяЧастьЕдинцыАдреса = "д"
				ИЛИ ПерваяЧастьЕдинцыАдреса = "д."
				ИЛИ ПерваяЧастьЕдинцыАдреса = "дом")
				И (ТретьяЧастьЕдинцыАдреса = "к"
				ИЛИ ТретьяЧастьЕдинцыАдреса = "к."
				ИЛИ ТретьяЧастьЕдинцыАдреса = "корп"
				ИЛИ ТретьяЧастьЕдинцыАдреса = "корп."
				ИЛИ ТретьяЧастьЕдинцыАдреса = "корпус")
				Тогда
				ЧастиАдреса[НомерЧасти] = СтрЗаменить(ТекЧасть, " " + ТретьяЧастьЕдинцыАдреса, ", " + ТретьяЧастьЕдинцыАдреса);
			КонецЕсли;
		КонецЕсли;
		
		НомерЧасти = НомерЧасти + 1;
	КонецЦикла;
	
	НовоеПредставление = СтрСоединить(ЧастиАдреса, ",");
	
	Возврат НовоеПредставление;
	
КонецФункции

Процедура ПроверитьОрганизацию(Организация, Отказ)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Не указана организация сервиса 1С:Бизнес-сеть. Работа с сервисом 1С:Доставка невозможна.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьРегистрациюОрганизации(Организация, Отказ)
	
	Если Не ОрганизацияПодключена(Организация) Тогда
		ТекстСообщения = НСтр("ru='Организация ""%1"" не подключена в сервисе 1С:Бизнес-сеть. Необходимо подключить организацию.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Организация);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыАдресаПоВладельцу(Параметры)
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Владелец, "Наименование");
	
	Параметры.ВладелецНаименование = ЗначенияРеквизитов.Наименование;
	
	ВидКонтактнойИнформации = Неопределено;
	СервисДоставкиПереопределяемый.ПолучитьЗначениеВидаКонтактнойИнформацииДляАдресаПоВладельцу(Параметры.Владелец,
																								ВидКонтактнойИнформации, 
																								Параметры.ТипАдреса);
	
	Если ВидКонтактнойИнформации <> Неопределено Тогда
		КонтактнаяИнформацияТаблица = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Параметры.Владелец,
																								ВидКонтактнойИнформации,
																								ТекущаяДатаСеанса(),
																								Ложь);
		Если КонтактнаяИнформацияТаблица.Количество() Тогда
			КонтактнаяИнформация = КонтактнаяИнформацияТаблица[0];
			Параметры.Представление = КонтактнаяИнформация.Представление;
			Параметры.ЗначенияПолей = КонтактнаяИнформация.ЗначенияПолей;
			Параметры.Значение = КонтактнаяИнформация.Значение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ВидКонтактнойИнформации(ВидКонтактнойИнформацииСтрока)
	
	ВидКонтактнойИнформации = Неопределено;
	
	Если ВидКонтактнойИнформацииСтрока = "АдресСкладаОрганизации" Тогда
		СервисДоставкиПереопределяемый.ПолучитьЗначениеВидаКонтактнойИнформацииДляАдресаДоставкиСкладаОрганизации(ВидКонтактнойИнформации);
	ИначеЕсли ВидКонтактнойИнформацииСтрока = "АдресСкладаКонтрагента" Тогда
		СервисДоставкиПереопределяемый.ПолучитьЗначениеВидаКонтактнойИнформацииДляАдресаДоставкиСкладаКонтрагента(ВидКонтактнойИнформации);
	ИначеЕсли ВидКонтактнойИнформацииСтрока = "ТелефонКонтактногоЛицаОрганизации" Тогда
		СервисДоставкиПереопределяемый.ПолучитьЗначениеВидаКонтактнойИнформацииДляТелефонаКонтактногоЛицаОрганизации(ВидКонтактнойИнформации);
	ИначеЕсли ВидКонтактнойИнформацииСтрока = "ТелефонКонтактногоЛицаКонтрагента" Тогда
		СервисДоставкиПереопределяемый.ПолучитьЗначениеВидаКонтактнойИнформацииДляТелефонаКонтактногоЛицаКонтрагента(ВидКонтактнойИнформации);
	КонецЕсли;
	
	Возврат ВидКонтактнойИнформации;
	
КонецФункции

#КонецОбласти
