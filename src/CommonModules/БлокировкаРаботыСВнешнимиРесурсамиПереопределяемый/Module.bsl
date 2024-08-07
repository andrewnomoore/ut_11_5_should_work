///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при снятии блокировки работы с внешними ресурсами.
// Для включения работы механизмов, отключенных в процедуре ПриЗапретеРаботыСВнешнимиРесурсами.
//
Процедура ПриРазрешенииРаботыСВнешнимиРесурсами() Экспорт
	
КонецПроцедуры

// Вызывается при установке блокировки работы с внешними ресурсами,
// при старте регламентного задания в копии информационной базы или интерактивно.
//
// Позволяет отключить произвольные механизмы, работа
// которых в копии информационной базы недопустима.
//
Процедура ПриЗапретеРаботыСВнешнимиРесурсами() Экспорт
	
	//++ НЕ ГОСИС
	БлокировкаРаботыСВнешнимиРесурсамиЛокализация.ПриЗапретеРаботыСВнешнимиРесурсами();
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти