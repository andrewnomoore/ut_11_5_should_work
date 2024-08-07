
#Область ПрограммныйИнтерфейс

// Сравнивает переданную версию ФФД на актуальность (На текущий момент актуальная версия 1.0.5 или 1.1).
//
// Параметры:
//  ВерсияФФД - Строка - Версия ФФД.
// 
// Возвращаемое значение:
//  Булево - Версия актуальна.
//
Функция ПоддерживаетсяФорматФФД1_0_5ИЛИФФД1_1(ВерсияФФД) Экспорт
	
	Возврат ВерсияФФД = "1.0.5" ИЛИ ВерсияФФД = "1.1";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Локализация

//++ Локализация

// Процедура удаляет не фискализированные записи из очереди чеков ККТ
Процедура УдалитьНеФискализированныеЧекиИзОчереди(ДокументСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ОчередьЧековККТ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументОснование.Установить(ДокументСсылка);
	НаборЗаписей.Прочитать();
	
	ЗаписиКУдалению = Новый Массив;
	Для Каждого Запись Из НаборЗаписей Цикл
		Если Запись.СтатусЧека = Перечисления.СтатусЧекаККТВОчереди.Фискализирован Тогда
			Продолжить;
		КонецЕсли;
		ЗаписиКУдалению.Добавить(Запись);
	КонецЦикла;
	
	Для Каждого Запись Из ЗаписиКУдалению Цикл
		НаборЗаписей.Удалить(Запись);
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	// Обработчик выполняется только для международной версии.
	Если Не ПолучитьФункциональнуюОпцию("ЛокализацияРФ") Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Процедура = "ПодключаемоеОборудованиеУТСервер.ОбработатьДанныеДляДляПереходаНаНовуюВерсию";
		Обработчик.Версия = "11.5.18.23";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("6c5dfa20-cd35-3491-41e8-7754c37bd829");
		Обработчик.Многопоточный = Истина;
		Обработчик.ПроцедураЗаполненияДанныхОбновления = "ПодключаемоеОборудованиеУТСервер.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
		Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
		ШаблонКомментарияОбработчика = НСтр("ru = 'Установка пометки удаления на локализованные предопределенные элементы справочника %1.'");
		
		Обработчик.Комментарий = СтрШаблон(ШаблонКомментарияОбработчика,
								Метаданные.Справочники.ДрайверыОборудования.Синоним);
		
		Читаемые = Новый Массив;
		Читаемые.Добавить(Метаданные.Справочники.ДрайверыОборудования.ПолноеИмя());
		Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
		
		Изменяемые = Новый Массив;
		Изменяемые.Добавить(Метаданные.Справочники.ДрайверыОборудования.ПолноеИмя());
		Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
		
		Обработчик.БлокируемыеОбъекты = "";
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.ДрайверыОборудования";
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДрайверыОборудования.Ссылка
	|ИЗ
	|	Справочник.ДрайверыОборудования КАК ДрайверыОборудования
	|ГДЕ
	|	ДрайверыОборудования.Предопределенный
	|	И НЕ ДрайверыОборудования.ПометкаУдаления";
	
	МассивСсылокДляОбработки = Новый Массив;

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Справочники.ДрайверыОборудования.ПолучитьИмяПредопределенного(Выборка.Ссылка)) Тогда
			МассивСсылокДляОбработки.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылокДляОбработки);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.ДрайверыОборудования";
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Для Каждого ЭлементСправочника Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСправочника.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			СправочникОбъект = ЭлементСправочника.Ссылка.ПолучитьОбъект();
			
			Если СправочникОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
			Иначе
				
				СправочникОбъект.ПометкаУдаления = Истина;
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ЭлементСправочника.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);

КонецПроцедуры

#КонецОбласти

#КонецОбласти