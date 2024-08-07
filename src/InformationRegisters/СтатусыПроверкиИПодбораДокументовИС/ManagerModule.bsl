
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет запись в регистр промежуточных результатов проверки и подбора документа.
// 
// Параметры:
// 	ПроверяемыйДокумент    - ДокументСсылка - документ, в котором выполняется проверка и/или подбор.
// 	Сценарий               - Число - ключ сценария проверки.
//
Процедура ОчиститьРезультатыПроверкиДокумента(ПроверяемыйДокумент, Сценарий = 0) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(ПроверяемыйДокумент);
	НаборЗаписей.Отбор.Сценарий.Установить(Сценарий);
	
	НаборЗаписей.Записать(Истина);

КонецПроцедуры

// Выполняет запись в регистр промежуточных результатов проверки и подбора документа.
// 
// Параметры:
// 	ПроверяемыйДокумент     - ДокументСсылка - документ, в котором выполняется проверка и/или подбор.
// 	ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции.
// 	ДанныеПроверкиИПодбора  - ХранилищеЗначения - промежуточные результаты проверки.
// 	Сценарий                - Число - ключ сценария проверки.
//
Процедура СохранитьПромежуточныеРезультатыПроверкиДокумента(
	ПроверяемыйДокумент,
	ВидМаркируемойПродукции,
	ДанныеПроверкиИПодбора,
	Сценарий = 0) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(ПроверяемыйДокумент);
	НаборЗаписей.Отбор.ВидМаркируемойПродукции.Установить(ВидМаркируемойПродукции);
	НаборЗаписей.Отбор.Сценарий.Установить(Сценарий);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Документ                = ПроверяемыйДокумент;
	НоваяЗапись.ВидМаркируемойПродукции = ВидМаркируемойПродукции;
	НоваяЗапись.Сценарий                = Сценарий;
	НоваяЗапись.ДанныеПроверкиИПодбора  = ДанныеПроверкиИПодбора;
	НоваяЗапись.СтатусПроверкиИПодбора  = Перечисления.СтатусыПроверкиИПодбораИС.Выполняется;
	
	НаборЗаписей.Записать(Истина);

КонецПроцедуры

// Выполняет запись в регистр, отражующую завершение проверки и подбора документа.
// 
// Параметры:
// 	ПроверяемыйДокумент     - ДокументСсылка - документ, в котором выполнялась проверка и/или подбор.
// 	ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции.
// 	ДанныеПроверкиИПодбора  - ХранилищеЗначения, Неопределено - для входящих документов результаты проверки сохраняются,
// 	   для исходящих документов нет.
// 	ТребуемоеДействиеЭДО    - ПеречислениеСсылка.ТребуемоеДействиеДокументЭДО - действие, которое нужно выполнить с документом ЭДО.
// 	Сценарий                - Число - ключ сценария проверки.
//
Процедура ОтразитьЗавершениеПроверкиДокумента(
	ПроверяемыйДокумент,
	ВидМаркируемойПродукции,
	ДанныеПроверкиИПодбора,
	ТребуемоеДействиеЭДО = Неопределено,
	Сценарий = 0) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(ПроверяемыйДокумент);
	НаборЗаписей.Отбор.ВидМаркируемойПродукции.Установить(ВидМаркируемойПродукции);
	НаборЗаписей.Отбор.Сценарий.Установить(Сценарий);

	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Документ                = ПроверяемыйДокумент;
	НоваяЗапись.ВидМаркируемойПродукции = ВидМаркируемойПродукции;
	НоваяЗапись.Сценарий                = Сценарий;
	НоваяЗапись.ДанныеПроверкиИПодбора  = ДанныеПроверкиИПодбора;
	НоваяЗапись.СтатусПроверкиИПодбора  = Перечисления.СтатусыПроверкиИПодбораИС.Завершено;
	НоваяЗапись.ТребуемоеДействиеЭДО    = ТребуемоеДействиеЭДО;
	
	НаборЗаписей.Записать(Истина);

КонецПроцедуры

// Выполняет запись в регистр, отражующую возобновление проверки и подбора документа.
// 
// Параметры:
//   ПроверяемыйДокумент - ДокументСсылка - документ, в котором выполнялась проверка и/или подбор.
//   ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции.
//   Сценарий                - Число - ключ сценария обработки
// 
// Возвращаемое значение:
//   Булево - запись в регистре проверки и подбора выполнена
//
Функция ОтразитьВозобновлениеПроверкиДокумента(ПроверяемыйДокумент, ВидМаркируемойПродукции, Сценарий) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(ПроверяемыйДокумент);
	НаборЗаписей.Отбор.ВидМаркируемойПродукции.Установить(ВидМаркируемойПродукции);
	НаборЗаписей.Отбор.Сценарий.Установить(Сценарий);
	
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() Тогда
		Запись = НаборЗаписей[0];
		Запись.СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.Выполняется;
		Запись.ТребуемоеДействиеЭДО   = Перечисления.ТребуемоеДействиеДокументЭДО.ПустаяСсылка();
	КонецЕсли;
	
	Попытка
		НаборЗаписей.Записать(Истина);
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;

КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СтатусыПроверкиИПодбораДокументов.Документ КАК Документ
	|ИЗ
	|	РегистрСведений.СтатусыПроверкиИПодбораДокументовИС КАК СтатусыПроверкиИПодбораДокументов
	|ГДЕ
	|	СтатусыПроверкиИПодбораДокументов.ВидМаркируемойПродукции = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|";
	
	ТаблицаИзмерений = Запрос.Выполнить().Выгрузить();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.СтатусыПроверкиИПодбораДокументовИС";
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ТаблицаИзмерений, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра  = "РегистрСведений.СтатусыПроверкиИПодбораДокументовИС";
	МетаданныеРегистра = Метаданные.РегистрыСведений.СтатусыПроверкиИПодбораДокументовИС;

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.УстановитьЗначение("Документ", Выборка.Документ);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор["Документ"].Установить(Выборка.Документ);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() = 0 Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей, ДополнительныеПараметры);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Для Каждого Запись Из НаборЗаписей Цикл
				Если Не ЗначениеЗаполнено(Запись.ВидМаркируемойПродукции) Тогда
					Запись.ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Табак;
				КонецЕсли;
			КонецЦикла;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей, ДополнительныеПараметры);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать статус проверки и подбора по документу: %1 по причине: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Документ, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, МетаданныеРегистра,, ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
