
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает соответствие между идентификатором объекта внешней системы
// и объектом информационной базы.
// 
// Параметры:
//	ПараметрыЗаписи - Структура - параметры соответствия.
//
Процедура ДобавитьЗапись(Знач ПараметрыЗаписи) Экспорт
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СоответствиеОбъектовСервисовДоставки");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ТипГрузоперевозки", ПараметрыЗаписи.ТипГрузоперевозки);
		ЭлементБлокировки.УстановитьЗначение("ТипОбъекта", ПараметрыЗаписи.ТипОбъекта);
		
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПараметрыЗаписи);
		
		Если ЗначениеЗаполнено(МенеджерЗаписи.Значение) Тогда
			
			МенеджерЗаписи.Записать();
			
			Если МенеджерЗаписи.ЗначениеПоУмолчанию Тогда
				
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("ТипГрузоперевозки", МенеджерЗаписи.ТипГрузоперевозки);
				Запрос.УстановитьПараметр("ТипОбъекта", МенеджерЗаписи.ТипОбъекта);
				Запрос.УстановитьПараметр("ИдентификаторОбъекта", МенеджерЗаписи.ИдентификаторОбъекта);
				Запрос.Текст =
				"ВЫБРАТЬ
				|	ТаблицаСоответствий.ТипГрузоперевозки КАК ТипГрузоперевозки,
				|	ТаблицаСоответствий.ТипОбъекта КАК ТипОбъекта,
				|	ТаблицаСоответствий.ИдентификаторОбъекта КАК ИдентификаторОбъекта
				|ИЗ
				|	РегистрСведений.СоответствиеОбъектовСервисовДоставки КАК ТаблицаСоответствий
				|ГДЕ
				|	ТаблицаСоответствий.ТипГрузоперевозки = &ТипГрузоперевозки
				|	И ТаблицаСоответствий.ТипОбъекта = &ТипОбъекта
				|	И ТаблицаСоответствий.ИдентификаторОбъекта <> &ИдентификаторОбъекта
				|	И ТаблицаСоответствий.ЗначениеПоУмолчанию";
				
				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					
					МенеджерЗаписи = СоздатьМенеджерЗаписи();
					ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
					
					МенеджерЗаписи.Прочитать();
					Если МенеджерЗаписи.Выбран() Тогда
						МенеджерЗаписи.ЗначениеПоУмолчанию = Ложь;
						МенеджерЗаписи.Записать();
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		Иначе
			
			МенеджерЗаписи.Прочитать();
			Если МенеджерЗаписи.Выбран() Тогда
				МенеджерЗаписи.Удалить();
			КонецЕсли;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
