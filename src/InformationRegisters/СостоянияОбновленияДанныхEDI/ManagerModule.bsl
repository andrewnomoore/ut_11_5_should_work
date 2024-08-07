
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция РезультатПодготовкиОбновленияДанных(Организация, ВидОбновляемыхДанных) Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ОбновлениеВозможно", Ложь);
	Результат.Вставить("ДатаОбновления",     Дата(1, 1, 1));
	
	РезультатПроверкиОбновления = ОбновлениеДанныхНеВыполняется(Организация, ВидОбновляемыхДанных);
	Результат.ДатаОбновления    = РезультатПроверкиОбновления.ДатаОбновления -300;
	
	Результат.ОбновлениеВозможно = РезультатПроверкиОбновления.ОбновлениеНеВыполняется
	                               И РезультатБлокировкиОбновляемыхДанных(Организация, ВидОбновляемыхДанных);
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыЗаписиВРегистр() Экспорт
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Организация"                   , Неопределено);
	ПараметрыЗаписи.Вставить("ВидОбновляемыхДанных",         Перечисления.ВидыОбновляемыхДанныхEDI.ПустаяСсылка());
	ПараметрыЗаписи.Вставить("ДатаОбновления" ,              Дата(1, 1, 1));
	ПараметрыЗаписи.Вставить("ДатаБлокировкиДляОбновления" , Дата(1, 1, 1));
	
	Возврат ПараметрыЗаписи;
	
КонецФункции

Процедура ВыполнитьЗаписьВРегистр(ПараметрыЗаписи) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияОбновленияДанныхEDI");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Организация", ПараметрыЗаписи.Организация);
		ЭлементБлокировки.УстановитьЗначение("ВидОбновляемыхДанных", ПараметрыЗаписи.ВидОбновляемыхДанных);

		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.СостоянияОбновленияДанныхEDI.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(ПараметрыЗаписи.Организация);
		НаборЗаписей.Отбор.ВидОбновляемыхДанных.Установить(ПараметрыЗаписи.ВидОбновляемыхДанных);
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, ПараметрыЗаписи);
		НаборЗаписей.Записать();
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВызватьИсключение НСтр("ru = 'Не удалось записать информацию о состоянии обновления данных EDI.'");
		
	КонецПопытки;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Блокировки

Функция ОбновлениеДанныхНеВыполняется(Организация, ВидОбновляемыхДанных) 
	
	Результат = Новый Структура;
	Результат.Вставить("ОбновлениеНеВыполняется", Истина);
	Результат.Вставить("ДатаОбновления",          Дата(1, 1, 1));
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СостоянияОбновленияДанныхEDI.ДатаБлокировкиДляОбновления КАК ДатаБлокировкиДляОбновления,
	|	СостоянияОбновленияДанныхEDI.ДатаОбновления              КАК ДатаОбновления
	|ИЗ
	|	РегистрСведений.СостоянияОбновленияДанныхEDI КАК СостоянияОбновленияДанныхEDI
	|ГДЕ
	|	СостоянияОбновленияДанныхEDI.Организация = &Организация
	|	И СостоянияОбновленияДанныхEDI.ВидОбновляемыхДанных = &ВидОбновляемыхДанных";
	
	Запрос.УстановитьПараметр("Организация",          Организация);
	Запрос.УстановитьПараметр("ВидОбновляемыхДанных", ВидОбновляемыхДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Результат.ДатаОбновления = Выборка.ДатаОбновления;
	Если Выборка.ДатаБлокировкиДляОбновления < ТекущаяДатаСеанса() - 60*60 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.ОбновлениеНеВыполняется = Ложь;
	Возврат Результат;
	
КонецФункции

Функция РезультатСнятияБлокировкиОбновляемыхДанных(Организация, ВидОбновляемыхДанных) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидОбновляемыхДанных) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияОбновленияДанныхEDI");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		ЭлементБлокировки.УстановитьЗначение("ВидОбновляемыхДанных", ВидОбновляемыхДанных);

		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.СостоянияОбновленияДанныхEDI.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Отбор.ВидОбновляемыхДанных.Установить(ВидОбновляемыхДанных);
	
		НаборЗаписей.Прочитать();
	
		Если НаборЗаписей.Количество() = 1 Тогда
			СтрокаНабора = НаборЗаписей[0];
		Иначе
			ОтменитьТранзакцию();
			Возврат Истина;
		КонецЕсли;
	
		Если СтрокаНабора.ДатаОбновления = Дата(1,1,1) Тогда
			НаборЗаписей.Очистить();
		Иначе
			СтрокаНабора.ДатаБлокировкиДляОбновления = Дата(1,1,1);
		КонецЕсли;
	
		НаборЗаписей.Записать(Истина);
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВызватьИсключение НСтр("ru = 'Не удалось записать информацию о состоянии обновления данных EDI.'");
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция РезультатБлокировкиОбновляемыхДанных(Организация, ВидОбновляемыхДанных)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидОбновляемыхДанных) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
		НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияОбновленияДанныхEDI");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		ЭлементБлокировки.УстановитьЗначение("ВидОбновляемыхДанных", ВидОбновляемыхДанных);

		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.СостоянияОбновленияДанныхEDI.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Отбор.ВидОбновляемыхДанных.Установить(ВидОбновляемыхДанных);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			
			СтрокаНабора = НаборЗаписей[0];
			
		Иначе
			
			СтрокаНабора = НаборЗаписей.Добавить();
			
		КонецЕсли;
		
		СтрокаНабора.Организация                 = Организация;
		СтрокаНабора.ВидОбновляемыхДанных        = ВидОбновляемыхДанных;
		СтрокаНабора.ДатаБлокировкиДляОбновления = ТекущаяДатаСеанса();
		
		НаборЗаписей.Записать(Истина);
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВызватьИсключение НСтр("ru = 'Не удалось записать информацию о состоянии обновления данных EDI.'");
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
