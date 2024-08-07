///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела.
// См. Пользователи.АвторизованныйПользователь.
// См. ПользователиКлиент.АвторизованныйПользователь.
//
Функция АвторизованныйПользователь() Экспорт
	
// АПК:547-выкл код сохранен для обратной совместимости, используется в устаревшем программном интерфейсе.
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат Пользователи.АвторизованныйПользователь();
#Иначе
	Возврат ПользователиКлиент.АвторизованныйПользователь();
#КонецЕсли
// АПК:547-вкл
	
КонецФункции

// Устарела.
// См. Пользователи.ТекущийПользователь.
// См. ПользователиКлиент.ТекущийПользователь.
//
Функция ТекущийПользователь() Экспорт
	
// АПК:547-выкл код сохранен для обратной совместимости, используется в устаревшем программном интерфейсе.
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат Пользователи.ТекущийПользователь();
#Иначе
	Возврат ПользователиКлиент.ТекущийПользователь();
#КонецЕсли
// АПК:547-вкл
	
КонецФункции

// Устарела.
// См. ВнешниеПользователи.ТекущийВнешнийПользователь.
// См. ВнешниеПользователиКлиент.ТекущийВнешнийПользователь.
//
Функция ТекущийВнешнийПользователь() Экспорт
	
// АПК:547-выкл код сохранен для обратной совместимости, используется в устаревшем программном интерфейсе.
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ВнешниеПользователи.ТекущийВнешнийПользователь();
#Иначе
	Возврат ВнешниеПользователиКлиент.ТекущийВнешнийПользователь();
#КонецЕсли
// АПК:547-вкл
	
КонецФункции

// Устарела.
// См. Пользователи.ЭтоСеансВнешнегоПользователя.
// См. ПользователиКлиент.ЭтоСеансВнешнегоПользователя.
//
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
// АПК:547-выкл код сохранен для обратной совместимости, используется в устаревшем программном интерфейсе.
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат Пользователи.ЭтоСеансВнешнегоПользователя();
#Иначе
	Возврат ПользователиКлиент.ЭтоСеансВнешнегоПользователя();
#КонецЕсли
// АПК:547-вкл
	
КонецФункции

#КонецОбласти

#КонецОбласти
