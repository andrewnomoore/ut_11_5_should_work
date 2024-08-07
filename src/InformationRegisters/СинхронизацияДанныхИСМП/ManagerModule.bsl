#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает дату выполнения синхронизациии в регистр в привелегированном режиме
//
// Параметры:
//  Организация       - ОпределяемыйТип.Организация.
//  ВидПродукции      - ПеречислениеСсылка.ВидыПродукцииИС.
//  Операция          - ПеречислениеСсылка.ВидыОперацийИСМП.
//  ДатаСинхронизации - Дата.
//  ПроверятьРегистр  - Булево.
//
Процедура УстановитьДатуВыполненияСинхронизации(Организация, ВидПродукции, Операция,
	ДатаСинхронизации = Неопределено, ПроверятьРегистр = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.ВидПродукции.Установить(ВидПродукции);
	НаборЗаписей.Отбор.Операция.Установить(Операция);
	
	Если ДатаСинхронизации <> Неопределено Тогда
		
		Если ПроверятьРегистр Тогда
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Выбран()
				И НаборЗаписей.Количество() > 0 Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.Организация        = Организация;
		ЗаписьНабора.ВидПродукции       = ВидПродукции;
		ЗаписьНабора.Операция           = Операция;
		ЗаписьНабора.ДатаСинхронизации  = ДатаСинхронизации;
		ЗаписьНабора.ДатаОбмена         = ТекущаяУниверсальнаяДата();
		
		НаборЗаписей.Записать();
		
	Иначе
		
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Выбран()
			И НаборЗаписей.Количество() > 0 Тогда
			
			Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
				ЗаписьНабора.ДатаОбмена = ТекущаяУниверсальнаяДата();
			КонецЦикла;
			
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные о датах выгрузки, на которые были получены сведения об отклонениях.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация.
//  Операция    - ПеречислениеСсылка.ВидыОперацийИСМП
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
// * Ключ - ПеречислениеСсылка.ВидыПродукцииИС.
// * Значение - Дата.
Функция ДатыСинхронизации(Организация, Операция) Экспорт
	
	ДатыСинхронизации = Новый Соответствие;
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	|	СинхронизацияДанныхИСМП.ДатаСинхронизации КАК ДатаСинхронизации,
	|	СинхронизацияДанныхИСМП.ВидПродукции      КАК ВидПродукции
	|ИЗ
	|	РегистрСведений.СинхронизацияДанныхИСМП КАК СинхронизацияДанныхИСМП
	|ГДЕ
	|	СинхронизацияДанныхИСМП.Организация = &Организация
	|	И СинхронизацияДанныхИСМП.Операция = &Операция";
	
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("Операция",     Операция);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДатыСинхронизации.Вставить(Выборка.ВидПродукции, Выборка.ДатаСинхронизации);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДатыСинхронизации;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Списки) Экспорт

	УправлениеДоступомИСПереопределяемый.ПриЗаполненииОграниченияДоступа(
		Метаданные.РегистрыСведений.СинхронизацияДанныхИСМП, Списки);

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли