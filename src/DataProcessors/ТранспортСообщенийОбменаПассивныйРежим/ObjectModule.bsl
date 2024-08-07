///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СообщениеОбмена Экспорт; // При получении - имя полученного файла во ВременныйКаталог. При отправке - имя файла, который необходимо отправить
Перем ВременныйКаталог Экспорт; // Временный каталог для сообщений обмена.
Перем ИдентификаторКаталога Экспорт;
Перем Корреспондент Экспорт;
Перем ИмяПланаОбмена Экспорт;
Перем ИмяПланаОбменаКорреспондента Экспорт;
Перем СообщениеОбОшибке Экспорт;
Перем СообщениеОбОшибкеЖР Экспорт;

Перем ШаблоныИменДляПолученияСообщения Экспорт;
Перем ИмяСообщенияДляОтправки Экспорт;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ОтправитьДанные
Функция ОтправитьДанные(СообщениеДляСопоставленияДанных = Ложь) Экспорт
	
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПолучитьДанные
Функция ПолучитьДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПередВыгрузкойДанных
Функция ПередВыгрузкойДанных(СообщениеДляСопоставленияДанных = Ложь) Экспорт
	
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПараметрыКорреспондента
Функция ПараметрыКорреспондента(НастройкиПодключения) Экспорт
	
	Результат = ТранспортСообщенийОбмена.СтруктураРезультатаПолученияПараметровКорреспондента();
	Результат.ПодключениеУстановлено = Истина;
	Результат.ПодключениеРазрешено = Истина;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.СохранитьНастройкиВКорреспонденте
Функция СохранитьНастройкиВКорреспонденте(НастройкиПодключения) Экспорт
	
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ТребуетсяАутентификация
Функция ТребуетсяАутентификация() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодключениеУстановлено() Экспорт
 	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ВременныйКаталог = Неопределено;
СообщенияОбмена = Неопределено;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли