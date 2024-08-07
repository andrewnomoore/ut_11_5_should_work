#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ОшибкаРасчетаКурсаПоФормуле;
Перем КодыВалют;

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.Валюта = Запись.БазоваяВалюта
			И (Запись.КурсЧислитель <> 1 Или Запись.КурсЗнаменатель <> 1) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В поле валюта и базовая валюта выбрано одинаковое значение %1.
					|В поля Курс (Числитель) и Курс (Знаменатель) необходимо указать значение ""1""'"),
					Запись.Валюта);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// При записи контролируются курсы подчиненных валют.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОтключитьКонтрольПодчиненныхВалют") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЗависимыеВалюты", Новый Соответствие);
	
	Если Количество() > 0 Тогда
		ОбновитьКурсыПодчиненныхВалют();
	Иначе
		УдалитьКурсыПодчиненныхВалют();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Находит все зависимые валюты и изменяет их курс.
//
Процедура ОбновитьКурсыПодчиненныхВалют()
	
	ВыбраннаяВалюта = Неопределено;
	ДополнительныеСвойства.Свойство("ОбновитьКурсЗависимойВалюты", ВыбраннаяВалюта);
	
	Для Каждого ЗаписьОсновнойВалюты Из ЭтотОбъект Цикл
	
		Если ВыбраннаяВалюта <> Неопределено Тогда // Нужно обновить курс только указанной валюты.
			ЗаблокироватьКурсЗависимойВалюты(ВыбраннаяВалюта, ЗаписьОсновнойВалюты.БазоваяВалюта, ЗаписьОсновнойВалюты.Период);
		Иначе
			ЗависимыеВалюты = РаботаСКурсамиВалютУТ.СписокЗависимыхВалют(ЗаписьОсновнойВалюты.Валюта, ДополнительныеСвойства);
			Для Каждого ЗависимаяВалюта Из ЗависимыеВалюты Цикл
				ЗаблокироватьКурсЗависимойВалюты(ЗависимаяВалюта, ЗаписьОсновнойВалюты.БазоваяВалюта, ЗаписьОсновнойВалюты.Период);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ЗаписьОсновнойВалюты Из ЭтотОбъект Цикл

		Если ВыбраннаяВалюта <> Неопределено Тогда // Нужно обновить курс только указанной валюты.
			ОбновленныеПериоды = Неопределено;
			Если Не ДополнительныеСвойства.Свойство("ОбновленныеПериоды", ОбновленныеПериоды) Тогда
				ОбновленныеПериоды = Новый Соответствие;
				ДополнительныеСвойства.Вставить("ОбновленныеПериоды", ОбновленныеПериоды);
			КонецЕсли;
			// Повторно не обновляем курс за один и тот же период.
			Если ОбновленныеПериоды[ЗаписьОсновнойВалюты.Период] = Неопределено Тогда
				ОбновитьКурсЗависимойВалюты(ВыбраннаяВалюта, ЗаписьОсновнойВалюты);
				ОбновленныеПериоды.Вставить(ЗаписьОсновнойВалюты.Период, Истина);
			КонецЕсли;
		Иначе	// Обновить курс всех зависимых валют.
			ЗависимыеВалюты = РаботаСКурсамиВалютУТ.СписокЗависимыхВалют(ЗаписьОсновнойВалюты.Валюта, ДополнительныеСвойства);
			Для Каждого ЗависимаяВалюта Из ЗависимыеВалюты Цикл
				ОбновитьКурсЗависимойВалюты(ЗависимаяВалюта, ЗаписьОсновнойВалюты); 
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаблокироватьКурсЗависимойВалюты(ЗависимаяВалюта, БазоваяВалюта, ПериодОсновнойВалюты)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтносительныеКурсыВалют");
	ЭлементБлокировки.УстановитьЗначение("Валюта", ЗависимаяВалюта.Ссылка);
	ЭлементБлокировки.УстановитьЗначение("БазоваяВалюта", БазоваяВалюта);
	Если ЗначениеЗаполнено(ПериодОсновнойВалюты) Тогда
		ЭлементБлокировки.УстановитьЗначение("Период", ПериодОсновнойВалюты);
	КонецЕсли;
	Блокировка.Заблокировать();
	
КонецПроцедуры
	
Процедура ОбновитьКурсЗависимойВалюты(ЗависимаяВалюта, ЗаписьОсновнойВалюты)
	
	НаборЗаписей = РегистрыСведений.ОтносительныеКурсыВалют.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Валюта.Установить(ЗависимаяВалюта.Ссылка);
	НаборЗаписей.Отбор.БазоваяВалюта.Установить(ЗаписьОсновнойВалюты.БазоваяВалюта);
	НаборЗаписей.Отбор.Период.Установить(ЗаписьОсновнойВалюты.Период);
	
	ЗаписьКурсовВалют = НаборЗаписей.Добавить();
	ЗаписьКурсовВалют.Валюта = ЗависимаяВалюта.Ссылка;
	ЗаписьКурсовВалют.БазоваяВалюта = ЗаписьОсновнойВалюты.БазоваяВалюта;
	ЗаписьКурсовВалют.Период = ЗаписьОсновнойВалюты.Период;
	Если ЗависимаяВалюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.НаценкаНаКурсДругойВалюты Тогда
		Если ЗаписьОсновнойВалюты.КурсЗнаменатель > ЗаписьОсновнойВалюты.КурсЧислитель Тогда
			ЗаписьКурсовВалют.КурсЧислитель = ЗаписьОсновнойВалюты.КурсЧислитель;
			ЗаписьКурсовВалют.КурсЗнаменатель = ЗаписьОсновнойВалюты.КурсЗнаменатель + ЗаписьОсновнойВалюты.КурсЗнаменатель * ЗависимаяВалюта.Наценка / 100;
		Иначе
			ЗаписьКурсовВалют.КурсЧислитель = ЗаписьОсновнойВалюты.КурсЧислитель + ЗаписьОсновнойВалюты.КурсЧислитель * ЗависимаяВалюта.Наценка / 100;
			ЗаписьКурсовВалют.КурсЗнаменатель = ЗаписьОсновнойВалюты.КурсЗнаменатель;
		КонецЕсли;
	Иначе // по формуле
		КурсЗависимойВалюты = КурсВалютыПоФормуле(ЗависимаяВалюта.Ссылка, ЗависимаяВалюта.ФормулаРасчетаКурса, ЗаписьОсновнойВалюты.БазоваяВалюта, ЗаписьОсновнойВалюты.Период);
		Если КурсЗависимойВалюты <> Неопределено Тогда
			Если ЗаписьОсновнойВалюты.КурсЗнаменатель > ЗаписьОсновнойВалюты.КурсЧислитель Тогда
				ЗаписьКурсовВалют.КурсЧислитель = 1;
				ЗаписьКурсовВалют.КурсЗнаменатель = КурсЗависимойВалюты;
			Иначе
				ЗаписьКурсовВалют.КурсЧислитель = КурсЗависимойВалюты;
				ЗаписьКурсовВалют.КурсЗнаменатель = 1;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаписьКурсовВалют.КурсЧислитель = 0 Или ЗаписьКурсовВалют.КурсЗнаменатель = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьКонтрольПодчиненныхВалют");
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтносительныеКурсыВалют");
	ЭлементБлокировки.УстановитьЗначение("Валюта", ЗаписьКурсовВалют.Валюта);
	ЭлементБлокировки.УстановитьЗначение("БазоваяВалюта", ЗаписьКурсовВалют.БазоваяВалюта);
	ЭлементБлокировки.УстановитьЗначение("Период", ЗаписьКурсовВалют.Период);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		НаборЗаписей.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Очищает курсы зависимых валют.
//
Процедура УдалитьКурсыПодчиненныхВалют()
	
	ВалютаВладелец = Отбор.Валюта.Значение;
	БазоваяВалютаВладелец = Отбор.БазоваяВалюта.Значение;
	Период = Отбор.Период.Значение;
	
	ЗависимаяВалюта = Неопределено;
	Если ДополнительныеСвойства.Свойство("ОбновитьКурсЗависимойВалюты", ЗависимаяВалюта) Тогда
		ЗаблокироватьКурсЗависимойВалюты(ЗависимаяВалюта, БазоваяВалютаВладелец, Период);
		УдалитьКурсыВалюты(ЗависимаяВалюта, БазоваяВалютаВладелец, Период);
	Иначе
		ЗависимыеВалюты = РаботаСКурсамиВалютУТ.СписокЗависимыхВалют(ВалютаВладелец, ДополнительныеСвойства);
		Для Каждого ЗависимаяВалюта Из ЗависимыеВалюты Цикл
			ЗаблокироватьКурсЗависимойВалюты(ЗависимаяВалюта.Ссылка, БазоваяВалютаВладелец, Период); 
		КонецЦикла;
		Для Каждого ЗависимаяВалюта Из ЗависимыеВалюты Цикл
			УдалитьКурсыВалюты(ЗависимаяВалюта.Ссылка, БазоваяВалютаВладелец, Период);
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

Процедура УдалитьКурсыВалюты(ВалютаСсылка, БазоваяВалюта, Период)
	НаборЗаписей = РегистрыСведений.ОтносительныеКурсыВалют.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Валюта.Установить(ВалютаСсылка);
	НаборЗаписей.Отбор.БазоваяВалюта.Установить(БазоваяВалюта);
	НаборЗаписей.Отбор.Период.Установить(Период);
	НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьКонтрольПодчиненныхВалют");
	НаборЗаписей.Записать();
КонецПроцедуры
	
Функция КурсВалютыПоФормуле(Валюта, Формула, БазоваяВалюта, Период)
	
	Если КодыВалют = Неопределено Тогда
		КодыВалют = КодыВалют();
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка,
	|	Валюты.СимвольныйКод КАК СимвольныйКод
	|ПОМЕСТИТЬ Валюты
	|ИЗ
	|	&КодыВалют КАК Валюты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Валюты.СимвольныйКод КАК СимвольныйКод,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(КурсыВалютСрезПоследних.КурсЗнаменатель, 1) > ЕСТЬNULL(КурсыВалютСрезПоследних.КурсЧислитель, 1)
	|			ТОГДА ЕСТЬNULL(КурсыВалютСрезПоследних.КурсЗнаменатель, 1) / ЕСТЬNULL(КурсыВалютСрезПоследних.КурсЧислитель, 1)
	|		ИНАЧЕ ЕСТЬNULL(КурсыВалютСрезПоследних.КурсЧислитель, 1) / ЕСТЬNULL(КурсыВалютСрезПоследних.КурсЗнаменатель, 1)
	|	КОНЕЦ КАК Курс
	|ИЗ
	|	Валюты КАК Валюты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Период, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютСрезПоследних
	|		ПО (КурсыВалютСрезПоследних.Валюта = Валюты.Ссылка)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("КодыВалют", КодыВалют);
	Запрос.УстановитьПараметр("БазоваяВалюта", БазоваяВалюта);
	Запрос.УстановитьПараметр("Период", Период);
	
	Выражение = Формула;
	Если СтрНайти(Выражение, ".") = 0 Тогда
		Выражение = СтрЗаменить(Выражение, ",", ".");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Выражение = СтрЗаменить(Выражение, Выборка.СимвольныйКод, Формат(Выборка.Курс, "ЧРД=.; ЧГ=0"));
	КонецЦикла;
	
	Попытка
		Результат = ОбщегоНазначения.ВычислитьВБезопасномРежиме(Выражение);
	Исключение
		Если ОшибкаРасчетаКурсаПоФормуле = Неопределено Тогда
			ОшибкаРасчетаКурсаПоФормуле = Новый Соответствие;
		КонецЕсли;
		Если ОшибкаРасчетаКурсаПоФормуле[Валюта] = Неопределено Тогда
			ОшибкаРасчетаКурсаПоФормуле.Вставить(Валюта, Истина);
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Расчет курса валюты ""%1"" по формуле ""%2"" за период ""%3""не выполнен:'",
				ОбщегоНазначения.КодОсновногоЯзыка()), Валюта, Формула, Период);
				
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке), 
				Валюта, "Объект.ФормулаРасчетаКурса");
				
			Если ДополнительныеСвойства.Свойство("ОбновитьКурсЗависимойВалюты") Тогда
				ВызватьИсключение ТекстОшибки + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
			КонецЕсли;
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Загрузка курсов валют ЕЦБ'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, Валюта.Метаданные(), Валюта, 
				ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецЕсли;
		Результат = Неопределено;
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

Функция КодыВалют()
	
	КодыВалют = Неопределено;
	ДополнительныеСвойства.Свойство("КодыВалют", КодыВалют);
	Если КодыВалют = Неопределено Тогда
		КодыВалют = Справочники.Валюты.КодыВалют();
	КонецЕсли;
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	Результат.Колонки.Добавить("СимвольныйКод", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(Метаданные.Справочники.Валюты.ДлинаНаименования, ДопустимаяДлина.Переменная)));
	
	Для Каждого ОписаниеВалюты Из КодыВалют Цикл
		// Валюта участвует в формуле, если символьный код содержит буквы.
		Если ЗначениеЗаполнено(СтрСоединить(СтрРазделить(ОписаниеВалюты.СимвольныйКод, "0123456789", Ложь), "")) Тогда
			ЗаполнитьЗначенияСвойств(Результат.Добавить(), ОписаниеВалюты);
		КонецЕсли;
	КонецЦикла;
	
	Результат.Индексы.Добавить("Ссылка");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ОшибкаРасчетаКурсаПоФормуле = Неопределено;
КодыВалют = Неопределено;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли