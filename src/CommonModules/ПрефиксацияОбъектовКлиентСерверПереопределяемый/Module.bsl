///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события "При получении номера на печать".
// Событие возникает перед стандартной обработкой получения номера.
// В обработчике можно переопределить стандартное поведение системы при формировании номера на печать.
//
// Параметры:
//  НомерОбъекта                     - Строка - номер или код объекта, который обрабатывается.
//  СтандартнаяОбработка             - Булево - флаг стандартной обработки; если установить значение флага в Ложь,
//                                              то стандартная обработка формирования номера на печать выполняться
//                                              не будет.
//  УдалитьПрефиксИнформационнойБазы - Булево - признак удаления префикса информационной базы;
//                                              по умолчанию равен Ложь.
//  УдалитьПользовательскийПрефикс   - Булево - признак удаления пользовательского префикса;
//                                              по умолчанию равен Ложь.
//
// Пример:
//
//   НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПользовательскиеПрефиксыИзНомераОбъекта(НомерОбъекта);
//   СтандартнаяОбработка = Ложь;
//
Процедура ПриПолученииНомераНаПечать(НомерОбъекта, СтандартнаяОбработка,
	УдалитьПрефиксИнформационнойБазы, УдалитьПользовательскийПрефикс) Экспорт
	
	//++ НЕ ГОСИС
	// Если номер документа не содержит "-", то удаляем из номера все префиксы.
	ПозицияМинус = Найти(НомерОбъекта, "-");
	Если ПозицияМинус = 0 Тогда
		
		СтандартнаяОбработка = Ложь;
	
		// Удаление всех символьных префиксов.
		Пока Найти("0123456789", Лев(НомерОбъекта, 1)) = 0 Цикл
			НомерОбъекта = Сред(НомерОбъекта, 2);
		КонецЦикла;
		
		// Удаляем лидирующие нули слева в номере.
		НомерОбъекта = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(НомерОбъекта, "0");
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти
