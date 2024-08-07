
#Область ПрограммныйИнтерфейс

// Возвращает значение константы по имени
//
// Параметры:
// 	Имя - Строка - Имя константы
// 
// Возвращаемое значение:
//	Произвольный - Значение константы
// 
Функция ЗначениеКонстанты(Имя) Экспорт
	Возврат ОбщегоНазначенияУТВызовСервера.ЗначениеКонстанты(Имя);
КонецФункции

// Возвращает значение константы по имени
//
// Параметры:
// 	ИмяИлиИдентификаторДокумента - Строка - 
// 					- СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
// 					- СправочникСсылка.ИдентификаторыОбъектовРасширений -  Имя или идентификатор метаданных документа.
// 
// Возвращаемое значение:
//	Строка - Синоним документа
// 
Функция СинонимДокумента(ИмяИлиИдентификаторДокумента) Экспорт
	Возврат ОбщегоНазначенияУТВызовСервера.СинонимДокумента(ИмяИлиИдентификаторДокумента);
КонецФункции

// Возвращает признак того, что для пользователя установлен язык интерфейса
// соответствующий основному языку информационной базы.
//
// Возвращаемое значение:
//  Булево
//
Функция ЭтоОсновнойЯзык() Экспорт
	
	Возврат ОбщегоНазначенияУТВызовСервера.ЭтоОсновнойЯзык();
	
КонецФункции


#КонецОбласти
