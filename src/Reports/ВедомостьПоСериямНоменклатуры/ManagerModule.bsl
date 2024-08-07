#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//  Неопределено
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВедомостьПоСериямНоменклатуры) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ВедомостьПоСериямНоменклатуры.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru= 'Движения по сериям товара'");
		
		КомандаОтчет.Обработчик = "МенюОтчетыУТКлиент.ВедомостьПоСериямТовара";
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Истина;
		
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ВедомостьПоСериямТовара");
		
		КомандаОтчет.КлючВарианта = "ВедомостьПоСериямНоменклатурыКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли