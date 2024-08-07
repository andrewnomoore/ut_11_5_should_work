
//++ Локализация

#Область СлужебныеПроцедурыИФункции

#Область СертификатыНоменклатуры

// Выполняет запуск фонового задания по обновлению статусов Росаккредитации сертификатов номенклатуры.
//
// Параметры:
//	УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор запускаемого фонового задания.
//
// Возвращаемое значение:
//	см. ДлительныеОперации.ВыполнитьФункцию.
//
Функция ОбновитьСтатусыРосаккредитации(УникальныйИдентификатор) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление статусов Росаккредитации сертификатов номенклатуры'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьФункцию(
							ПараметрыВыполнения,
							"НоменклатураЛокализация.ОбновитьСтатусыРосаккредитации");
	
	Возврат РезультатВыполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

//-- Локализация