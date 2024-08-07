///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСсылку(Наименование) Экспорт
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
	ХешированиеДанных.Добавить(Наименование);
	ХешНаименования = СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", "");
	
	Ссылка = НайтиПоХешу(ХешНаименования);
	Если Ссылка = Неопределено Тогда
		Ссылка = СоздатьНовый(Наименование, ХешНаименования);
	КонецЕсли;
	
	Возврат Ссылка;
КонецФункции

Функция НайтиПоХешу(Хеш)
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОперацииСтатистики.ИдентификаторОперации
	|ИЗ
	|	РегистрСведений.ОперацииСтатистики КАК ОперацииСтатистики
	|ГДЕ
	|	ОперацииСтатистики.ХешНаименования = &ХешНаименования
	|";
	Запрос.УстановитьПараметр("ХешНаименования", Хеш);
    
    УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
    УстановитьПривилегированныйРежим(Ложь);
    
	Если Результат.Пустой() Тогда
		Ссылка = Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Ссылка = Выборка.ИдентификаторОперации;
	КонецЕсли;
	
	Возврат Ссылка;
КонецФункции

Функция СоздатьНовый(Наименование, ХешНаименования)
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОперацииСтатистики");
		ЭлементБлокировки.УстановитьЗначение("ХешНаименования", ХешНаименования);
		Блокировка.Заблокировать();
		
		Ссылка = НайтиПоХешу(ХешНаименования);
		
		Если Ссылка = Неопределено Тогда
			Ссылка = Новый УникальныйИдентификатор();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НовЗапись = НаборЗаписей.Добавить();
			НовЗапись.ХешНаименования = ХешНаименования;
			НовЗапись.ИдентификаторОперации = Ссылка;
			НовЗапись.Наименование = Наименование;
            
            УстановитьПривилегированныйРежим(Истина);
			НаборЗаписей.Записать(Ложь);
            УстановитьПривилегированныйРежим(Ложь);
            
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Ссылка;
КонецФункции

Функция МожноНовыйКомментарий(СсылкаОперация) Экспорт
	КоличествоУникальныхМаксимум = 100;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОперацииСтатистики.КоличествоУникальныхКомментариев КАК КоличествоУникальных
		|ИЗ
		|	РегистрСведений.ОперацииСтатистики КАК ОперацииСтатистики
		|ГДЕ
		|	ОперацииСтатистики.ИдентификаторОперации = &ИдентификаторОперации";
		
	Запрос.УстановитьПараметр("ИдентификаторОперации", СсылкаОперация);	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	КоличествоУникальных = ВыборкаДетальныеЗаписи.КоличествоУникальных;
	
	Если КоличествоУникальных = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если КоличествоУникальных < КоличествоУникальныхМаксимум Тогда
		МожноНовыйКомментарий = Истина;
	Иначе
		МожноНовыйКомментарий = Ложь;
	КонецЕсли;
	
	Возврат МожноНовыйКомментарий;
КонецФункции

Процедура УвеличитьКоличествоУникальныхКомментариев(СсылкаОперация, СсылкаКомментарий) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторОперации.Установить(СсылкаОперация);
	НаборЗаписей.Прочитать();
	Для Каждого ТекЗапись Из НаборЗаписей Цикл
		ТекЗапись.КоличествоУникальныхКомментариев = ТекЗапись.КоличествоУникальныхКомментариев + 1;
	КонецЦикла;
	НаборЗаписей.Записать(Истина);
	
	РегистрыСведений.КомментарииОперацииСтатистики.СоздатьНовуюЗапись(СсылкаОперация, СсылкаКомментарий); 
КонецПроцедуры

#КонецОбласти

#КонецЕсли