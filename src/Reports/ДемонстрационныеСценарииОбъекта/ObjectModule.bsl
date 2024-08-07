#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Сформировать отчет.
// 
// Параметры:
//  ТаблицаОтчета      - ТабличныйДокумент - в него выводится отчет
//  ОбъектДляСценариев - СправочникСсылка, ДокументСсылка - объект для которого формируется отчет
//
Процедура СформироватьОтчет(ТаблицаОтчета, ОбъектДляСценариев)  Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ОбъектДляСценариев) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
	
		ДанныеДляЗаполнения = ДанныеДляЗаполненияДемонстрационныеСценарииОбъекта(ОбъектДляСценариев); 
	Иначе
		
		ДанныеДляЗаполнения = ДанныеДляЗаполненияДемонстрационныеСценарииПрофиля(ОбъектДляСценариев);
		
	КонецЕсли;
	
	ТаблицаОтчета = ТабличныйДокументДемонстрационныеСценарииОбъекта(ДанныеДляЗаполнения);
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТабличныйДокументДемонстрационныеСценарииОбъекта(ДанныеДляЗаполнения) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("ДемонстрационныеСценарии");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	ОбластьЗаголовок.Параметры.ТекстЗаголовка = 
		СтрШаблон(НСтр("ru = 'Описания процессов ""%1""'"), ДанныеДляЗаполнения.ПредставлениеОбъектаМетаданных); 
	
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	
	Уровень = 0; 
	
	Для Каждого СтрокаДерева Из ДанныеДляЗаполнения.ДеревоСценариев.Строки Цикл
		 ВывестиСтрокуСценарияТабличныйДокумент(СтрокаДерева, ТабличныйДокумент, Макет, Уровень);
	КонецЦикла;
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиСтрокуСценарияТабличныйДокумент(СтрокаДерева, ТабличныйДокумент, Макет, Знач Уровень)
	
	СтрокаРодитель = СтрокаДерева.Родитель;
	
	Если СтрокаРодитель <> Неопределено 
		И СтрокаРодитель.Ссылка = СтрокаДерева.Ссылка Тогда
		Возврат;
	КонецЕсли;
	
	ОбластьОтступОбщий = Макет.ПолучитьОбласть("ОбластьОтступОбщий");
	ТабличныйДокумент.Вывести(ОбластьОтступОбщий);
	
	ОбластьОтступГруппировка = Макет.ПолучитьОбласть("ОбластьОтступГруппировка");
	
	Инд = 1;
	Пока Инд <= Уровень Цикл
		
		ТабличныйДокумент.Присоединить(ОбластьОтступГруппировка);
		Инд = Инд + 1;
		
	КонецЦикла;
	
	ОбластьСценарий = Макет.ПолучитьОбласть("ОбластьСценарий");
	ОбластьСценарий.Параметры.НаименованиеСценария = СтрокаДерева.Наименование;
	ОбластьСценарий.Параметры.СсылкаНаСценарий     = СтрокаДерева.Ссылка;
	Если СтрокаДерева.ЭтоГруппа Тогда
		ОбластьСценарий.Области.ОбластьСценарий.ЦветТекста = ЦветаСтиля.ЦветТекстаГруппаВетвление;
	КонецЕсли;

	Если СтрокаДерева.ТипГруппы = 1 Или СтрокаДерева.ТипГруппы = Перечисления.ТипыГруппДемонстрационныхСценариев.Ветвление Тогда
		ОбластьСценарий.Параметры.КартинкаСценария = БиблиотекаКартинок.Справка;
	КонецЕсли;
	
	ТабличныйДокумент.Присоединить(ОбластьСценарий);
	
	Уровень = Уровень + 1;
	Для Каждого ПодчиненнаяСтрока Из СтрокаДерева.Строки Цикл
		 ВывестиСтрокуСценарияТабличныйДокумент(ПодчиненнаяСтрока, ТабличныйДокумент, Макет, Уровень);
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеДляЗаполненияДемонстрационныеСценарииОбъекта(ОбъектДляСценариев)
	
	ДанныеДляЗаполнения = Новый Структура;
	ДанныеДляЗаполнения.Вставить("ПредставлениеОбъектаМетаданных", "");
	ДанныеДляЗаполнения.Вставить("ДеревоСценариев",                Новый ДеревоЗначений);
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДемонстрационныеСценарии.Ссылка       КАК Ссылка, 
	|	ДемонстрационныеСценарии.Наименование КАК Наименование,
	|	ДемонстрационныеСценарии.ТипГруппы    КАК ТипГруппы,
	|	ДемонстрационныеСценарии.ЭтоГруппа    КАК ЭтоГруппа
	|ИЗ
	|	Справочник.ДемонстрационныеСценарии.ОбъектыКонфигурации КАК ДемонстрационныеСценарииОбъектыКонфигурации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДемонстрационныеСценарии КАК ДемонстрационныеСценарии
	|		ПО ДемонстрационныеСценарииОбъектыКонфигурации.Ссылка = ДемонстрационныеСценарии.Ссылка
	|ГДЕ
	|	ДемонстрационныеСценарииОбъектыКонфигурации.ОбъектКонфигурации = &ИдентификаторОбъектаМетаданных
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДемонстрационныеСценарии.Наименование
	|ИТОГИ ПО
	|	Ссылка ИЕРАРХИЯ";
	
	Если Не ЗначениеЗаполнено(ОбъектДляСценариев) Тогда
		Возврат ДанныеДляЗаполнения;
	КонецЕсли;
	
	ДанныеДляЗаполнения.ПредставлениеОбъектаМетаданных = Строка(ОбъектДляСценариев);
	
	Запрос.УстановитьПараметр("ИдентификаторОбъектаМетаданных", ОбъектДляСценариев); 
	
	МультиязычностьСервер.ИзменитьПолеЗапросаПодТекущийЯзык(Запрос.Текст, "Наименование");
	
	ДанныеДляЗаполнения.ДеревоСценариев = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией); 
	
	ИмяПоляКИзменению = ДемонстрационныеСценарии.ИмяМультиязычногоРеквизита("Наименование");
	ДанныеДляЗаполнения.ДеревоСценариев.Колонки[ИмяПоляКИзменению].Имя = "Наименование";
	
	Возврат ДанныеДляЗаполнения;
	
КонецФункции 

Функция ДанныеДляЗаполненияДемонстрационныеСценарииПрофиля(ОбъектДляСценариев)
	
	ДанныеДляЗаполнения = Новый Структура;
	ДанныеДляЗаполнения.Вставить("ПредставлениеОбъектаМетаданных", "");
	ДанныеДляЗаполнения.Вставить("ДеревоСценариев",                Неопределено);
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДемонстрационныеСценарии.Ссылка       КАК Ссылка, 
	|	ДемонстрационныеСценарии.Наименование КАК Наименование,
	|	ДемонстрационныеСценарии.ТипГруппы    КАК ТипГруппы,
	|	ДемонстрационныеСценарии.ЭтоГруппа    КАК ЭтоГруппа
	|ИЗ
	|	Справочник.ДемонстрационныеСценарии.ПрофилиГруппДоступа КАК ДемонстрационныеСценарииПрофилиГруппДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДемонстрационныеСценарии КАК ДемонстрационныеСценарии
	|		ПО ДемонстрационныеСценарииПрофилиГруппДоступа.Ссылка = ДемонстрационныеСценарии.Ссылка
	|ГДЕ
	|	ДемонстрационныеСценарииПрофилиГруппДоступа.Профиль = &ПрофильГруппДоступа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДемонстрационныеСценарии.Наименование
	|ИТОГИ ПО
	|	Ссылка ИЕРАРХИЯ";
	
	Если Не ЗначениеЗаполнено(ОбъектДляСценариев) Тогда
		Возврат ДанныеДляЗаполнения;
	КонецЕсли;
	
	ДанныеДляЗаполнения.ПредставлениеОбъектаМетаданных = СтрШаблон("%1 (%2)", Строка(ОбъектДляСценариев), НСтр("ru = 'Профиль групп доступа'"));
	
	Запрос.УстановитьПараметр("ПрофильГруппДоступа", ОбъектДляСценариев); 
	
	ДанныеДляЗаполнения.ДеревоСценариев = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Возврат ДанныеДляЗаполнения;
	
	
КонецФункции


#КонецОбласти

#КонецЕсли