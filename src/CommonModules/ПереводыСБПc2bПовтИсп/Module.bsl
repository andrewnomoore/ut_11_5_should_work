///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.ПереводыСБПc2b".
// ОбщийМодуль.ПереводыСБПc2bПовтИсп.
//
// Повторно используемые серверные процедуры переводов СБП.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Определяет доступность использования функциональности выполнения операций
// на основании прав доступа пользователя.
//
// Возвращаемое значение:
//  Булево - если Истина, оплата в Системе быстрых платежей доступна.
//
Функция ПереводыСБПДоступны() Экспорт
	
	Возврат ПереводыСБПc2bСлужебный.СлужебнаяПереводыСБПДоступны();
	
КонецФункции

// Определяет доступность использования функциональности чтения операций
// в на основании прав доступа пользователя.
//
// Возвращаемое значение:
//  Булево - если Истина, чтение операций доступно.
//
Функция ЧтениеПереводовСБПДоступно() Экспорт
	
	Возврат ПереводыСБПc2bСлужебный.СлужебнаяЧтениеПереводовСБПДоступно();
	
КонецФункции

#КонецОбласти
