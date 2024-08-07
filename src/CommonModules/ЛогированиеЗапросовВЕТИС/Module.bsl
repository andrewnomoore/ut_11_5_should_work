#Область СлужебныеПроцедурыИФункции

// Отключает режим записи логов.
// 
Процедура ОтключитьЛогированиеЗапросов() Экспорт
	
	ПараметрыЛогирования                 = ПараметрыЛогированияЗапросов();
	ПараметрыЛогирования.Включено        = Ложь;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Возвращает текствое описание текущего окружения и параметров.
// 
// Возвращаемое значение:
// 	Строка - Текстовое описание текущего окружения.
Функция ИнформацияОбОкружении() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеОкружения = Новый Массив();
	
	ЛогированиеЗапросовИС.ДополнитьИнформациюОбОкруженииШапка(ДанныеОкружения);
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			"%1: %2",
			Метаданные.Константы.РежимРаботыСТестовымКонтуромВЕТИС.Синоним,
			ИнтеграцияВЕТИСКлиентСервер.РежимРаботыСТестовымКонтуромВЕТИС()));
	
	ПараметрыОптимизации = ИнтеграцияВЕТИС.ПараметрыОптимизации();
	
	СинонимыПараметровОптимизации = ИнтеграцияВЕТИСПовтИсп.ПредставленияНастроекОптимизации();
	
	Для Каждого КлючИЗначение Из ПараметрыОптимизации Цикл
		
		ПредставлениеПараметра = СинонимыПараметровОптимизации.Получить(КлючИЗначение.Ключ);
		Если ПредставлениеПараметра = Неопределено Тогда
			ПредставлениеПараметра = ОбщегоНазначенияИСКлиентСервер.ПредставлениеВстроенногоИмени(КлючИЗначение.Ключ);
		КонецЕсли;
		
		ДанныеОкружения.Добавить(
			СтрШаблон(
				"%1: %2%3",
				ПредставлениеПараметра,
				Формат(КлючИЗначение.Значение, "ДФ=dd.MM.yyyy; БЛ=Нет; БИ=Да;")));
		
	КонецЦикла;
	
	ДополнитьПодвалЛогаЗапросовДаннымиПоКлассификаторам(ДанныеОкружения);
	ЛогированиеЗапросовИС.ДополнитьИнформациюОбОкруженииПодвал(ДанныеОкружения);
	
	Возврат СтрСоединить(ДанныеОкружения, Символы.ПС);
	
КонецФункции

// Получает текущие параметры логирования.
// 
// Возвращаемое значение:
// 	см. ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов
Функция ПараметрыЛогированияЗапросов() Экспорт
	
	Возврат ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов("ПараметрыЛогированияЗапросовВЕТИС");
	
КонецФункции

// Сохраняет параметры логирования в параметр сеанса.
// 
// Параметры:
// 	ПараметрыЛогирования - см. ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов.
Процедура УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования) Экспорт
	
	ПараметрыСеанса.ПараметрыЛогированияЗапросовВЕТИС = ОбщегоНазначения.ФиксированныеДанные(ПараметрыЛогирования);
	
КонецПроцедуры

// Дописывает полученные данные лога запросов в текущий уровень логирования.
// 
// Параметры:
// 	ДанныеДокумента - Структура:
// 	* ДанныеЛогаЗапросов - Строка - Данные для записи в лог запросов
Процедура ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДокумента) Экспорт
	
	ЛогированиеЗапросовИС.ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДокумента, ПараметрыЛогированияЗапросов());
	
КонецПроцедуры

Процедура ДополнитьПодвалЛогаЗапросовДаннымиПоКлассификаторам(ДанныеОкружения)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВерсийКлассификаторов   = Новый Массив();
	ИдентификаторыКлассификаторов = ИнтеграцияВЕТИС.ИдентификаторыКлассификаторов();
	ПроверитьНаличиеОбновлений    = Новый Массив();
	
	Для Каждого КлючИЗначение Из ИдентификаторыКлассификаторов Цикл
		
		ВидКлассификатора           = КлючИЗначение.Значение.ВидКлассификатора;
		ИдентификаторКлассификатора = КлючИЗначение.Ключ;
		Версия                      = РаботаСКлассификаторами.ВерсияКлассификатора(ИдентификаторКлассификатора);
		
		Если Не ЗначениеЗаполнено(Версия) Тогда
			Версия = 0;
		КонецЕсли;
		
		ДанныеВерсийКлассификаторов.Добавить(
			СтрШаблон("%1 (%2) версия %3",
			ВидКлассификатора,
			ИдентификаторКлассификатора,
			Формат(Версия, "ЧН=0;")));
		
		ПроверитьНаличиеОбновлений.Добавить(ИдентификаторКлассификатора);
		
	КонецЦикла;
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			НСтр("ru = 'Версии классификаторов: %1'"),
			СтрСоединить(ДанныеВерсийКлассификаторов, ", ")));
	
	ДоступныеОбновления = РаботаСКлассификаторами.ДоступныеОбновленияКлассификаторов(ПроверитьНаличиеОбновлений);
	
	Если ЗначениеЗаполнено(ДоступныеОбновления.КодОшибки)
		И ДоступныеОбновления.КодОшибки <> "ОбновлениеНеТребуется" Тогда
		
		ДанныеОкружения.Добавить(
			СтрШаблон(
				НСтр("ru = 'Обновление классификаторов: %1'"),
				ДоступныеОбновления.СообщениеОбОшибке));
		
	Иначе
		
		ДанныеДоступныхОбновлений = Новый Массив();
		
		Для Каждого СтрокаТаблицы Из ДоступныеОбновления.ДоступныеВерсии Цикл
			
			СтрокаКлассификатора = ИдентификаторыКлассификаторов[СтрокаТаблицы.Идентификатор];
			Если СтрокаКлассификатора = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ВидКлассификатора           = СтрокаКлассификатора.ВидКлассификатора;
			ИдентификаторКлассификатора = СтрокаТаблицы.Идентификатор;
			Версия                      = СтрокаТаблицы.Версия;
			
			ДанныеДоступныхОбновлений.Добавить(
				СтрШаблон("%1 (%2) версия %3",
					ВидКлассификатора,
					ИдентификаторКлассификатора,
					Версия));
			
		КонецЦикла;
		
		Если ДанныеДоступныхОбновлений.Количество() Тогда
			ДанныеОкружения.Добавить(
				СтрШаблон(
					НСтр("ru = 'Доступно обновление классификаторов: %1'"),
					СтрСоединить(ДанныеДоступныхОбновлений, ", ")));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
