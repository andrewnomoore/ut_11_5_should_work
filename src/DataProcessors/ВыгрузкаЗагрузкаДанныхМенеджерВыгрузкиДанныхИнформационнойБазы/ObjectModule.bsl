#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущийОбъектМетаданных; // ОбъектМетаданных - текущий объект метаданных.
Перем ТекущиеОбработчики;
Перем ТекущийПотокЗаписиПересоздаваемыхСсылок;
Перем ТекущийПотокЗаписиСопоставляемыхСсылок;
Перем ТекущийСериализатор;
Перем ТекущийУзел;
Перем ФиксироватьОбработкуОбъектов;
Перем НаличиеОбработчиков; // Структура

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


// Инициализирует обработку выгрузки-загрузки данных.
// 
// Параметры:
// 	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - 
// 	ОбъектМетаданных - ОбъектМетаданных -
// 	Узел - ПланОбменаСсылка.МиграцияПриложений - 
// 	Обработчики - ТаблицаЗначений - 
// 	Сериализатор - СериализаторXDTO - 
// 	ПотокЗаписиПересоздаваемыхСсылок - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиПересоздаваемыхСсылок - 
// 	ПотокЗаписиСопоставляемыхСсылок - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиСопоставляемыхСсылок - 
//
Процедура Инициализировать(Контейнер, ОбъектМетаданных, Узел, Обработчики, Сериализатор, ПотокЗаписиПересоздаваемыхСсылок, ПотокЗаписиСопоставляемыхСсылок) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ФиксироватьОбработкуОбъектов = Контейнер.ФиксироватьСостояние(); 
	
	ТекущийОбъектМетаданных = ОбъектМетаданных; // ОбъектМетаданных
	ТекущийУзел = Узел;
	ТекущиеОбработчики = Обработчики;
	ТекущийСериализатор = Сериализатор;
	ТекущийПотокЗаписиПересоздаваемыхСсылок = ПотокЗаписиПересоздаваемыхСсылок;
	ТекущийПотокЗаписиСопоставляемыхСсылок = ПотокЗаписиСопоставляемыхСсылок;
    	 
КонецПроцедуры

Процедура ВыгрузитьДанные() Экспорт
	
	Если ФиксироватьОбработкуОбъектов Тогда
		ТекущийКонтейнер.ЗафиксироватьНачалоОбработкиОбъектаМетаданных(ТекущийОбъектМетаданных.ПолноеИмя());
	КонецЕсли;
		
	Отказ = Ложь;
	НаличиеОбработчиков = ТекущиеОбработчики.НаличиеОбработчиковПоОбъектуМетаданных(ТекущийОбъектМетаданных);
	
	Если НаличиеОбработчиков.ПередВыгрузкойТипа Тогда
		ТекущиеОбработчики.ПередВыгрузкойТипа(ТекущийКонтейнер, ТекущийСериализатор, ТекущийОбъектМетаданных, Отказ);
	КонецЕсли;
	
	Если Отказ И ФиксироватьОбработкуОбъектов Тогда
		ТекущийКонтейнер.ОбъектыОбработаны(
			ТекущийКонтейнер.ОбъектовКОбработкеПоОбъектуМетаданных(ТекущийОбъектМетаданных));
	ИначеЕсли Не Отказ Тогда
		ВыгрузитьДанныеОбъектаМетаданных();
	КонецЕсли;
	
	Если НаличиеОбработчиков.ПослеВыгрузкиТипа Тогда
		ТекущиеОбработчики.ПослеВыгрузкиТипа(ТекущийКонтейнер, ТекущийСериализатор, ТекущийОбъектМетаданных);
	КонецЕсли;
	
	Если ФиксироватьОбработкуОбъектов Тогда
		ТекущийКонтейнер.ЗафиксироватьОкончаниеОбработкиОбъектаМетаданных(ТекущийОбъектМетаданных.ПолноеИмя());
	КонецЕсли;
		
КонецПроцедуры

// Выполняет действия для пересоздания ссылки при загрузке.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - ссылка на объект.
//
Процедура ТребуетсяПересоздатьСсылкуПриЗагрузке(Знач Ссылка) Экспорт
	
	ТекущийПотокЗаписиПересоздаваемыхСсылок.ПересоздатьСсылкуПриЗагрузке(Ссылка);
	
КонецПроцедуры

// Выполняет действия для сопоставления ссылки при загрузке.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - ссылка на объект.
//	ЕстественныйКлюч - Структура - где ключ, это имя естественного ключа, а значение произвольное значение естественного ключа.
//
Процедура ТребуетсяСопоставитьСсылкуПриЗагрузке(Знач Ссылка, Знач ЕстественныйКлюч) Экспорт
	
	ТекущийПотокЗаписиСопоставляемыхСсылок.СопоставитьСсылкуПриЗагрузке(Ссылка, ЕстественныйКлюч);
	
КонецПроцедуры

Процедура Закрыть() Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьДанныеОбъектаМетаданных()
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Выгрузка загрузка данных. Выгрузка объекта метаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		ТекущийОбъектМетаданных,
		,
		СтрШаблон(НСтр("ru = 'Начало выгрузки данных объекта метаданных: %1'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ТекущийОбъектМетаданных.ПолноеИмя()));
	
	Если ОбщегоНазначенияБТС.ЭтоКонстанта(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьКонстанту();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьСсылочныйОбъект();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНезависимыйНаборЗаписей(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьНезависимыйНаборЗаписей();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ТекущийОбъектМетаданных) Тогда 
		
		ВыгрузитьНаборЗаписейПодчиненныйРегистратору();
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неожиданный объект метаданных: %1'"),
			ТекущийОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
 	
КонецПроцедуры

Процедура ВыгрузитьКонстанту()
	
	Если ТекущийУзел = Неопределено Тогда
	
		МенеджерЗначения = Константы[ТекущийОбъектМетаданных.Имя].СоздатьМенеджерЗначения();	
		МенеджерЗначения.Прочитать();
		
		ПотокЗаписи = НачатьЗаписьФайла();
		ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, МенеджерЗначения);
		ЗавершитьЗаписьФайла(ПотокЗаписи);
		
	Иначе
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, ТекущийОбъектМетаданных);
		Пока Выборка.Следующий() Цикл
			
			МенеджерЗначения = Выборка.Получить();
			
			ПотокЗаписи = НачатьЗаписьФайла();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, МенеджерЗначения);
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ВыгрузкаЗагрузкаУзловПлановОбменов.ВыгрузитьИзменения(ТекущийКонтейнер, ТекущийОбъектМетаданных, ТекущийСериализатор);
	
КонецПроцедуры

Процедура ВыгрузитьСсылочныйОбъект()
	
	ПоддерживаетПредопределенные = 
		ОбщегоНазначенияБТС.ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(ТекущийОбъектМетаданных);
	
	ПроверитьДублиПредопределенных(ПоддерживаетПредопределенные);
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	ИмяОбъекта = ТекущийОбъектМетаданных.ПолноеИмя();
	Если ТекущийУзел = Неопределено 
		Или Метаданные.ПланыОбмена.Содержит(ТекущийОбъектМетаданных) Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	
		Выборка = МенеджерОбъекта.Выбрать();
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.ПолучитьОбъект();
			ИсправитьИмяПредопределенныхДанных(ПоддерживаетПредопределенные, МенеджерОбъекта, Объект);
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Объект);
		КонецЦикла;
		
	Иначе
		Если ПоддерживаетПредопределенные Тогда
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
		КонецЕсли;
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, ТекущийОбъектМетаданных);
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.Получить();
			Если Объект <> Неопределено И ТипЗнч(Объект) <> Тип("УдалениеОбъекта") Тогда
				ИсправитьИмяПредопределенныхДанных(ПоддерживаетПредопределенные, МенеджерОбъекта, Объект);
			КонецЕсли;
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Объект);
		КонецЦикла;
	
	КонецЕсли;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
	ВыгрузкаЗагрузкаУзловПлановОбменов.ВыгрузитьИзменения(ТекущийКонтейнер, ТекущийОбъектМетаданных, ТекущийСериализатор);
	
КонецПроцедуры

Процедура ВыгрузитьНезависимыйНаборЗаписей()
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	Если ТекущийУзел = Неопределено Тогда
		
		Измерения = Новый Массив();
		Если ТекущийОбъектМетаданных.ПериодичностьРегистраСведений 
			<> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			РеквизитПериод = ТекущийОбъектМетаданных.СтандартныеРеквизиты.Период; // ОписаниеСтандартногоРеквизита
			Измерения.Добавить(РеквизитПериод.Имя);
		КонецЕсли;
		Для Каждого Измерение Из ТекущийОбъектМетаданных.Измерения Цикл // ОбъектМетаданныхИзмерение
			Измерения.Добавить(Измерение.Имя);
		КонецЦикла;
		
		МенеджерОбъекта = РегистрыСведений[ТекущийОбъектМетаданных.Имя];
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей(); // Создание набора занимает существенное время
		Для Каждого Измерение Из Измерения Цикл
			НаборЗаписей.Отбор[Измерение].Использование = Истина;
		КонецЦикла;
		
		Выборка = МенеджерОбъекта.Выбрать();
		Пока Выборка.Следующий() Цикл
			НаборЗаписей.Очистить();
			Для Каждого Измерение Из Измерения Цикл
				НаборЗаписей.Отбор[Измерение].Значение = Выборка[Измерение];
			КонецЦикла;
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
		КонецЦикла;
			
	Иначе
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, ТекущийОбъектМетаданных);
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = Выборка.Получить();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
	ВыгрузкаЗагрузкаУзловПлановОбменов.ВыгрузитьИзменения(ТекущийКонтейнер, ТекущийОбъектМетаданных, ТекущийСериализатор);
	
КонецПроцедуры

Процедура ВыгрузитьНаборЗаписейПодчиненныйРегистратору()
	
	Если ОбщегоНазначенияБТС.ЭтоНаборЗаписейПерерасчета(ТекущийОбъектМетаданных) Тогда
		
		ИмяПоляРегистратора = "ОбъектПерерасчета";
		
		Подстроки = СтрРазделить(ТекущийОбъектМетаданных.ПолноеИмя(), ".");
		ИмяТаблицы = Подстроки[0] + "." + Подстроки[1] + "." + Подстроки[3];
		
	Иначе
		
		ИмяПоляРегистратора = "Регистратор";
		ИмяТаблицы = ТекущийОбъектМетаданных.ПолноеИмя();
		
	КонецЕсли;
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	Если ТекущийУзел <> Неопределено Тогда
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, ТекущийОбъектМетаданных);
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = Выборка.Получить();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			
		КонецЦикла;
	
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоРегистрНакопления(ТекущийОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоРегистрСведений(ТекущийОбъектМетаданных) Тогда
			
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.ИмяПоляРегистратора КАК Регистратор,
		|	КОЛИЧЕСТВО(*) КАК КоличествоЗаписей
		|ИЗ
		|	ИмяТаблицы КАК Таблица
		|СГРУППИРОВАТЬ ПО
		|	Таблица.ИмяПоляРегистратора";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяПоляРегистратора", ИмяПоляРегистратора);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			Возврат;
		КонецЕсли;
		
		НаборыРегистраторов = Новый Массив;
		НаборыРегистраторов.Добавить(Новый Массив);
		Выборка = Результат.Выбрать();
		ТекущееКоличествоЗаписей = 0;
		Пока Выборка.Следующий() Цикл
			Если ТекущееКоличествоЗаписей + Выборка.КоличествоЗаписей > 1000 И ТекущееКоличествоЗаписей <> 0 Тогда
				НаборыРегистраторов.Добавить(Новый Массив);
				ТекущееКоличествоЗаписей = 0;
			КонецЕсли;
			ТекущееКоличествоЗаписей = ТекущееКоличествоЗаписей + Выборка.КоличествоЗаписей;
			ПоследнийЭлемент = НаборыРегистраторов[НаборыРегистраторов.ВГраница()]; // Массив
			ПоследнийЭлемент.Добавить(Выборка.Регистратор);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	ИмяТаблицы КАК Таблица
		|ГДЕ
		|	Регистратор В (&Регистраторы)
		|УПОРЯДОЧИТЬ ПО
		|	Регистратор, НомерСтроки
		|ИТОГИ ПО
		|	Регистратор";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяПоляРегистратора", ИмяПоляРегистратора);
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийОбъектМетаданных.ПолноеИмя());
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей(); // Создание набора занимает существенное время
		Для Каждого Регистраторы Из НаборыРегистраторов Цикл
			Запрос.УстановитьПараметр("Регистраторы", Регистраторы);
			ВыборкаПоРегистраторам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоРегистраторам.Следующий() Цикл
				НаборЗаписей.Очистить();
				ЭлементОтбора = НаборЗаписей.Отбор[ИмяПоляРегистратора]; // ЭлементОтбора
				ЭлементОтбора.Установить(ВыборкаПоРегистраторам.Регистратор);
				ВыборкаПоЗаписям = ВыборкаПоРегистраторам.Выбрать();
				Пока ВыборкаПоЗаписям.Следующий() Цикл
					ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ВыборкаПоЗаписям);
				КонецЦикла;
				ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.ИмяПоляРегистратора КАК Регистратор
		|ИЗ
		|	ИмяТаблицы КАК Таблица";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяПоляРегистратора", ИмяПоляРегистратора);
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			Возврат;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийОбъектМетаданных.ПолноеИмя());
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей(); // Создание набора занимает существенное время
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ЭлементОтбора = НаборЗаписей.Отбор[ИмяПоляРегистратора]; // ЭлементОтбора
			ЭлементОтбора.Установить(Выборка.Регистратор);
			
			НаборЗаписей.Прочитать();
			
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			
		КонецЦикла;
	
	КонецЕсли;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
	ВыгрузкаЗагрузкаУзловПлановОбменов.ВыгрузитьИзменения(ТекущийКонтейнер, ТекущийОбъектМетаданных, ТекущийСериализатор);
	
КонецПроцедуры

// Записывает объект в XML.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи. 
//	Данные - Произвольный - записываемый объект.
//
Процедура ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Данные)
	
	Отказ = Ложь;
	Артефакты = Новый Массив();
	
	Если НаличиеОбработчиков.ПередВыгрузкойОбъекта Тогда
		ТекущиеОбработчики.ПередВыгрузкойОбъекта(
			ТекущийКонтейнер, ЭтотОбъект, ТекущийСериализатор, Данные, Артефакты, Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПотокЗаписи.ЗаписатьОбъектДанныхИнформационнойБазы(Данные, Артефакты);
	КонецЕсли;
	
	Если НаличиеОбработчиков.ПослеВыгрузкиОбъекта Тогда
		ТекущиеОбработчики.ПослеВыгрузкиОбъекта(ТекущийКонтейнер, ЭтотОбъект, ТекущийСериализатор, Данные, Артефакты);
	КонецЕсли;
	
	Если ФиксироватьОбработкуОбъектов Тогда
		ТекущийКонтейнер.ОбъектОбработан();	
	КонецЕсли;
		
	Если ПотокЗаписи.РазмерБольшеРекомендуемого() Тогда
		ЗавершитьЗаписьФайла(ПотокЗаписи);
		ПотокЗаписи = НачатьЗаписьФайла();
	КонецЕсли;
	
КонецПроцедуры

Функция НачатьЗаписьФайла()
	
	ИмяФайла = ТекущийКонтейнер.СоздатьФайл(
		ВыгрузкаЗагрузкаДанныхСлужебный.InfobaseData(), ТекущийОбъектМетаданных.ПолноеИмя());
	
	ПотокЗаписи = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы.Создать();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла, ТекущийСериализатор);
		
	Возврат ПотокЗаписи;
	
КонецФункции

Процедура ЗавершитьЗаписьФайла(ПотокЗаписи)
	
	ПотокЗаписи.Закрыть();
	
	КоличествоОбъектов = ПотокЗаписи.КоличествоОбъектов();
	Если КоличествоОбъектов = 0 Тогда
		ТекущийКонтейнер.ИсключитьФайл(ПотокЗаписи.ИмяФайла());
	Иначе
		ТекущийКонтейнер.УстановитьКоличествоОбъектов(ПотокЗаписи.ИмяФайла(), КоличествоОбъектов);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Выгрузка загрузка данных. Выгрузка объекта метаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		ТекущийОбъектМетаданных,
		,
		СтрШаблон(НСтр("ru = 'Окончание выгрузки данных объекта метаданных: %1
		|Выгружено объектов: %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ТекущийОбъектМетаданных.ПолноеИмя(), КоличествоОбъектов));
	
КонецПроцедуры

Процедура ПроверитьДублиПредопределенных(ПоддерживаетПредопределенныеЭлементы)
	
	Если Не ПоддерживаетПредопределенныеЭлементы Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонТекстаЗапросаПроверкаДублированияПредопределенных = 
	"ВЫБРАТЬ
	|	Таблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	&Таблица КАК Таблица
	|ГДЕ
	|	Таблица.Предопределенный
	|СГРУППИРОВАТЬ ПО
	|	Таблица.ИмяПредопределенныхДанных
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|УПОРЯДОЧИТЬ ПО
	|	ИмяПредопределенныхДанных";
	
	ПолноеИмя = ТекущийОбъектМетаданных.ПолноеИмя();
	
	
	Запрос = Новый Запрос;		
	Запрос.Текст = СтрЗаменить(ШаблонТекстаЗапросаПроверкаДублированияПредопределенных, "&Таблица", ПолноеИмя);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ИменаПредопределенныхДанных = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ИмяПредопределенныхДанных");
	
	Если ИменаПредопределенныхДанных.Количество() = 1 Тогда
		ШаблонТекстаОшибки = НСтр("ru = 'Обнаружено дублирование предопределенных данных с именем %1 в таблице %2
		|%3'")	
	Иначе
		ШаблонТекстаОшибки = НСтр("ru = 'Обнаружено дублирование предопределенных данных с именами %1 в таблице %2
		|%3'")	
	КонецЕсли;
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		ТекстРекомендации = НСтр(
		"ru = 'Рекомендуется обратиться в службу технической поддержки'"); 
	Иначе
		ТекстРекомендации = НСтр(
		"ru = 'Рекомендуется выполнить тестирование и исправление в режиме ''Проверка логической целостности информационной базы'''");
	КонецЕсли;
	
	ТекстОшибки = СтрШаблон(
		ШаблонТекстаОшибки,
		СтрСоединить(ИменаПредопределенныхДанных, ", "),
		ПолноеИмя,
		ТекстРекомендации);
	
	ТекущийКонтейнер.ДобавитьПредупреждение(ТекстОшибки);
	
	
	ШаблонТекстаЗапросаДублиПредопределенных = 
	"ВЫБРАТЬ
	|	Таблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	&Таблица КАК Таблица
	|ГДЕ
	|	Таблица.ИмяПредопределенныхДанных В(&ИменаПредопределенныхДанных)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИмяПредопределенныхДанных,
	|	Ссылка
	|ИТОГИ ПО
	|	ИмяПредопределенныхДанных";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИменаПредопределенныхДанных", ИменаПредопределенныхДанных);
	Запрос.Текст = СтрЗаменить(ШаблонТекстаЗапросаДублиПредопределенных, "&Таблица", ПолноеИмя);
	
	Дубли = Новый Структура;
	ВыборкаПоПредопределенному = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоПредопределенному.Следующий() Цикл
		Идентификаторы = Новый Массив;
		ВыборкаПоСсылкам = ВыборкаПоПредопределенному.Выбрать();
		Пока ВыборкаПоСсылкам.Следующий() Цикл
			Идентификаторы.Добавить(Строка(ВыборкаПоСсылкам.Ссылка.УникальныйИдентификатор()));
		КонецЦикла;
		Дубли.Вставить(ВыборкаПоПредопределенному.ИмяПредопределенныхДанных, Идентификаторы);
	КонецЦикла;
	
	ТекущийКонтейнер.ДобавитьДублиПредопределенных(ТекущийОбъектМетаданных, Дубли);
	
КонецПроцедуры

Процедура ИсправитьИмяПредопределенныхДанных(ПоддерживаетПредопределенные, МенеджерОбъекта, Объект)
	
	Если Не ПоддерживаетПредопределенные Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИмяПредопределенныхДанных)
		И Не СтрНачинаетсяС(Объект.ИмяПредопределенныхДанных, "#") 
		И МенеджерОбъекта[Объект.ИмяПредопределенныхДанных] <> Объект.Ссылка Тогда
		Объект.ИмяПредопределенныхДанных = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
