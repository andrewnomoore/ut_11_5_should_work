#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияПоОбъектамУчетаЭДО;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	СсылкаНаОбъект = Неопределено;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("СсылкаНаОбъект");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("СсылкаНаОбъект");

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияЭД.СсылкаНаОбъект КАК СсылкаНаОбъект
	|ПОМЕСТИТЬ ВТ_ВходящиеИсходящие
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияЭД
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронныйДокументВходящийЭДО КАК ВходящиеЭД
	|		ПО СостоянияЭД.УдалитьЭлектронныйДокумент = ВходящиеЭД.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыУчетаДокументовЭДО КАК ОбъектыУчетаДокументовЭДО
	|		ПО ОбъектыУчетаДокументовЭДО.ЭлектронныйДокумент = СостоянияЭД.УдалитьЭлектронныйДокумент
	|		И ОбъектыУчетаДокументовЭДО.Актуальный
	|ГДЕ
	|	(&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияЭД.СсылкаНаОбъект > &СсылкаНаОбъект)
	// Нет записи в регистре актуальности.
	|	И ОбъектыУчетаДокументовЭДО.ОбъектУчета ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияЭД.СсылкаНаОбъект КАК СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияЭД
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронныйДокументВходящийЭДО КАК ВходящиеЭД
	|		ПО СостоянияЭД.УдалитьЭлектронныйДокумент = ВходящиеЭД.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовЭДО КАК СостоянияЭДО
	|		ПО СостоянияЭД.УдалитьЭлектронныйДокумент = СостоянияЭДО.ЭлектронныйДокумент
	|		И СостоянияЭД.СостояниеЭДО = СостоянияЭДО.Состояние
	|ГДЕ
	|	(&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияЭД.СсылкаНаОбъект > &СсылкаНаОбъект)
	// Неверное состояние ЭДО.
	|	И СостоянияЭДО.ЭлектронныйДокумент ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияЭД.СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияЭД
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронныйДокументИсходящийЭДО КАК ИсходящиеЭД
	|		ПО СостоянияЭД.УдалитьЭлектронныйДокумент = ИсходящиеЭД.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыУчетаДокументовЭДО КАК ОбъектыУчетаДокументовЭДО
	|		ПО ОбъектыУчетаДокументовЭДО.ЭлектронныйДокумент = СостоянияЭД.УдалитьЭлектронныйДокумент
	|		И ОбъектыУчетаДокументовЭДО.Актуальный
	|ГДЕ
	|	(&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияЭД.СсылкаНаОбъект > &СсылкаНаОбъект)
	// Нет записи в регистре актуальности.
	|	И ОбъектыУчетаДокументовЭДО.ОбъектУчета ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияЭД.СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияЭД
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронныйДокументИсходящийЭДО КАК ИсходящиеЭД
	|		ПО СостоянияЭД.УдалитьЭлектронныйДокумент = ИсходящиеЭД.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовЭДО КАК СостоянияЭДО
	|		ПО СостоянияЭД.УдалитьЭлектронныйДокумент = СостоянияЭДО.ЭлектронныйДокумент
	|		И СостоянияЭД.СостояниеЭДО = СостоянияЭДО.Состояние
	|ГДЕ
	|	(&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияЭД.СсылкаНаОбъект > &СсылкаНаОбъект)
	// Неверное состояние ЭДО.
	|	И СостоянияЭДО.ЭлектронныйДокумент ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияПоОбъектамУчетаЭДО.СсылкаНаОбъект КАК СсылкаНаОбъект,
	|	СообщениеЭДОПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайла,
	|	СостоянияПоОбъектамУчетаЭДО.СостояниеЭДО КАК СостояниеЭДО
	|ПОМЕСТИТЬ ВТ_ПрисоединенныеФайлы
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияПоОбъектамУчетаЭДО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СообщениеЭДОПрисоединенныеФайлы КАК СообщениеЭДОПрисоединенныеФайлы
	|		ПО СостоянияПоОбъектамУчетаЭДО.УдалитьЭлектронныйДокумент = СообщениеЭДОПрисоединенныеФайлы.Ссылка
	|ГДЕ
	|	&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияПоОбъектамУчетаЭДО.СсылкаНаОбъект > &СсылкаНаОбъект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПрисоединенныеФайлы.СсылкаНаОбъект,
	|	ВТ_ПрисоединенныеФайлы.СостояниеЭДО,
	|	СообщениеЭДО.ЭлектронныйДокумент
	|ПОМЕСТИТЬ ВТ_ПрисоединенныеФайлыЭД
	|ИЗ
	|	ВТ_ПрисоединенныеФайлы КАК ВТ_ПрисоединенныеФайлы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СообщениеЭДО КАК СообщениеЭДО
	|		ПО ВТ_ПрисоединенныеФайлы.ВладелецФайла = СообщениеЭДО.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ВходящиеИсходящие.СсылкаНаОбъект КАК СсылкаНаОбъект
	|ПОМЕСТИТЬ ВТ_Сводная
	|ИЗ
	|	ВТ_ВходящиеИсходящие КАК ВТ_ВходящиеИсходящие
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ПрисоединенныеФайлыЭД.СсылкаНаОбъект
	|ИЗ
	|	ВТ_ПрисоединенныеФайлыЭД КАК ВТ_ПрисоединенныеФайлыЭД
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовЭДО КАК СостоянияЭДО
	|		ПО ВТ_ПрисоединенныеФайлыЭД.ЭлектронныйДокумент = СостоянияЭДО.ЭлектронныйДокумент
	|		И ВТ_ПрисоединенныеФайлыЭД.СостояниеЭДО = СостоянияЭДО.Состояние
	|ГДЕ
	// Неверное состояние ЭДО.
	|	СостоянияЭДО.ЭлектронныйДокумент ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияПоОбъектамУчетаЭДО.СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияПоОбъектамУчетаЭДО
	|ГДЕ
	|	(&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияПоОбъектамУчетаЭДО.СсылкаНаОбъект > &СсылкаНаОбъект)
	// Не заполнено представление состояния.
	|	И (СостоянияПоОбъектамУчетаЭДО.ПредставлениеСостояния = """"
	|	И СостоянияПоОбъектамУчетаЭДО.СостояниеЭДО <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовЭДО.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияПоОбъектамУчетаЭДО.СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияПоОбъектамУчетаЭДО
	|ГДЕ
	|	(&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияПоОбъектамУчетаЭДО.СсылкаНаОбъект > &СсылкаНаОбъект)
	// Неверное состояние ЭДО при отклонении по регламенту 14н.
	|	И СостоянияПоОбъектамУчетаЭДО.СостояниеЭДО = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	ВТ_Сводная.СсылкаНаОбъект
	|ИЗ
	|	ВТ_Сводная КАК ВТ_Сводная
	|
	|УПОРЯДОЧИТЬ ПО
	|	СсылкаНаОбъект";
	
	ОтработаныВсеДанные = Ложь;

	Пока Не ОтработаныВсеДанные Цикл

		Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
		Выгрузка = Запрос.Выполнить().Выгрузить();

		КоличествоСтрок = Выгрузка.Количество();

		Если КоличествоСтрок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСтрок > 0 Тогда
			СсылкаНаОбъект = Выгрузка[КоличествоСтрок - 1].СсылкаНаОбъект;
		КонецЕсли;

		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);

	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияПоОбъектамУчетаЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	МассивПроверяемыхОбъектов = Новый Массив;
	МассивПроверяемыхОбъектов.Добавить("Документ.ЭлектронныйДокументВходящийЭДО");
	МассивПроверяемыхОбъектов.Добавить("Документ.ЭлектронныйДокументИсходящийЭДО");

	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь,
		МассивПроверяемыхОбъектов)
		ИЛИ ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь,
		"РегистрСведений.СостоянияДокументовЭДО") Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;	
	
	ДанныеДляОбновления = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
		
	Если ДанныеДляОбновления.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаДанных Из ДанныеДляОбновления Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("СсылкаНаОбъект", СтрокаДанных.СсылкаНаОбъект);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Записать = Ложь;
			
			Набор = РегистрыСведений.СостоянияПоОбъектамУчетаЭДО.СоздатьНаборЗаписей();
			Набор.Отбор.СсылкаНаОбъект.Установить(СтрокаДанных.СсылкаНаОбъект);
			Набор.Прочитать();
			
			ОбработатьДанные_ЗаполнитьАктуальныйДокументооборот(Набор);
			ОбработатьДанные_ЗаполнитьСостояниеЭДО(Набор, Записать);
			ОбработатьДанные_ЗаполнитьПредставлениеСостояния(Набор, Записать);
			ОбработатьДанные_ЗаполнитьОписаниеОснования(Набор, Записать);
			ОбработатьДанные_ЗаменитьСостояниеОжидаетсяИзвещениеПоОтклонению(Набор, Записать);
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
			КонецЕсли;

			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов  + ДанныеДляОбновления.Количество();
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьДанные_ЗаполнитьАктуальныйДокументооборот(Набор) 
	
	Для Каждого Запись Из Набор Цикл

		Если ТипЗнч(Запись.СсылкаНаОбъект) = Тип("СправочникСсылка.НастройкиЭДО")
			ИЛИ Не ЗначениеЗаполнено(Запись.СсылкаНаОбъект) Тогда
			Продолжить;
		КонецЕсли;
	
		НаборАктуальныхДокументов = РегистрыСведений.УдалитьАктуальныеДокументыЭДО.СоздатьНаборЗаписей();
		НаборАктуальныхДокументов.Отбор.ОбъектУчета.Установить(Запись.СсылкаНаОбъект);
		НаборАктуальныхДокументов.Прочитать();

		Если НаборАктуальныхДокументов.Количество() = 0 Тогда
			
			ЭлектронныйДокумент = Неопределено;
			
			Если ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО")
				Или ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящийЭДО") Тогда
				ЭлектронныйДокумент = Запись.УдалитьЭлектронныйДокумент;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ЭлектронныйДокумент) Тогда
				Продолжить;
			КонецЕсли;
		
			ИнтеграцияЭДО.УстановитьАктуальныйЭлектронныйДокумент(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
					Запись.СсылкаНаОбъект), ЭлектронныйДокумент);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
			
Процедура ОбработатьДанные_ЗаполнитьСостояниеЭДО(Набор, Записать) 
	
	Для Каждого Запись Из Набор Цикл
		
			Если Не ЗначениеЗаполнено(Запись.УдалитьЭлектронныйДокумент)
				Или Не ЗначениеЗаполнено(Запись.СсылкаНаОбъект) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлектронныйДокумент = Неопределено;
			
			Если ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО")
				Или ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящийЭДО") Тогда
				ЭлектронныйДокумент = Запись.УдалитьЭлектронныйДокумент;
			КонецЕсли;
			
			Если ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("СправочникСсылка.СообщениеЭДОПрисоединенныеФайлы")  Тогда
				ЭлектронныйДокумент = Запись.УдалитьЭлектронныйДокумент.ВладелецФайла.ЭлектронныйДокумент;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ЭлектронныйДокумент) Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьСостояниеОбъектаУчета(Запись, Записать);
			
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанные_ЗаполнитьПредставлениеСостояния(Набор, Записать) 
	
	Для Каждого Запись Из Набор Цикл
		
		Если Запись.ПредставлениеСостояния = "" И ЗначениеЗаполнено(Запись.СсылкаНаОбъект) Тогда
			
			Запись.ПредставлениеСостояния =
				ИнтеграцияЭДО.РассчитатьСостояниеОбъектаУчета(Запись.СсылкаНаОбъект).ПредставлениеСостояния;
			Записать = Истина;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанные_ЗаполнитьОписаниеОснования(Набор, Записать) 
	
	Описание = Неопределено;
	
	ЗаписиДляУдаления = Новый Массив;
	
	Для Каждого Запись Из Набор Цикл
		
		Если Запись.СсылкаНаОбъект = Неопределено Тогда
			ЗаписиДляУдаления.Добавить(Запись);
			Продолжить;
		КонецЕсли;
		
		Если Запись.СостояниеЭДО <> Перечисления.СостоянияДокументовЭДО.НеСформирован Тогда
			Продолжить;
		КонецЕсли;
		
		Если Описание = Неопределено Тогда
			Описание = ИнтеграцияЭДО.ОписаниеОснованияЭлектронногоДокумента(Запись.СсылкаНаОбъект);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Запись, Описание);
		
		Записать = Истина;
		
	КонецЦикла;
	
	Для Каждого Запись Из ЗаписиДляУдаления Цикл
		Набор.Удалить(Запись);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанные_ЗаменитьСостояниеОжидаетсяИзвещениеПоОтклонению(Набор, Записать)
	
	Для Каждого Запись Из Набор Цикл
		
		Если ЗначениеЗаполнено(Запись.УдалитьЭлектронныйДокумент) // Состояние обновлено ранее
			ИЛИ Запись.СостояниеЭДО <> Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьСостояниеОбъектаУчета(Запись, Записать)
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСостояниеОбъектаУчета(Запись, Записать)
	
	СостояниеОбъектаУчета = ИнтеграцияЭДО.РассчитатьСостояниеОбъектаУчета(Запись.СсылкаНаОбъект);
	СостояниеЭДО = СостояниеОбъектаУчета.Состояние;
	ПредставлениеСостояния = СостояниеОбъектаУчета.ПредставлениеСостояния;
	
	Если Запись.СостояниеЭДО <> СостояниеЭДО Тогда
		Запись.СостояниеЭДО = СостояниеЭДО;
		Записать = Истина;
	КонецЕсли;
	
	Если Запись.ПредставлениеСостояния <> ПредставлениеСостояния Тогда
		Запись.ПредставлениеСостояния = ПредставлениеСостояния;
		Записать = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли