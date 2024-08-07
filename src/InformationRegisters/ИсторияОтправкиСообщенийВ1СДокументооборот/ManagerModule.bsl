#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Перемещает сообщение из очереди на отправку в регистр истории отправки сообщений.
//
// Параметры:
//   МоментВремени - Число - момент времени.
//   Идентификатор - УникальныйИдентификатор - идентификатор сообщения.
//
Процедура ПеренестиСообщениеВИсторию(МоментВремени, Идентификатор) Экспорт
	
	МенеджерЗаписиОчередь = РегистрыСведений.ОчередьСообщенийВ1СДокументооборот.СоздатьМенеджерЗаписи();
	МенеджерЗаписиОчередь.МоментВремени = МоментВремени;
	МенеджерЗаписиОчередь.Идентификатор = Идентификатор;
	МенеджерЗаписиОчередь.Прочитать();
	
	Если Не МенеджерЗаписиОчередь.Выбран() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		МенеджерЗаписиИстория = РегистрыСведений.ИсторияОтправкиСообщенийВ1СДокументооборот.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписиИстория, МенеджерЗаписиОчередь);
		МенеджерЗаписиИстория.ДатаОтправки = ТекущаяДатаСеанса();
		МенеджерЗаписиИстория.Записать(Истина);
		
		КонтрольОтправкиФайлов = МенеджерЗаписиОчередь.КонтрольОтправкиФайлов.Получить(); // См. ИнтеграцияС1СДокументооборотБазоваяФункциональность.КонтрольОтправкиФайлов
		Для Каждого Строка Из КонтрольОтправкиФайлов Цикл
			РегистрыСведений.КонтрольОтправкиФайловВ1СДокументооборот.СохранитьХешСуммуВерсииФайла(
				Строка.Источник,
				Строка.ИмяФайла,
				Строка.ТабличныйДокумент)
		КонецЦикла;
		
		МенеджерЗаписиОчередь.Удалить();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли