#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имя СКД базы распределения. СКД располагается в макетах этого объекта.
// Параметры:
//	БазаРаспределения - ПеречислениеСсылка.ТипыБазыРаспределенияРасходов - база распределения.
// Возвращаемое значение:
//	Строка - имя СКД.
Функция ИмяСхемыБазыРаспределения(БазаРаспределения) Экспорт
	
	Если ТипЗнч(БазаРаспределения) = Тип("Строка") Тогда
		Возврат БазаРаспределения;
	ИначеЕсли Не ТипыБазРаспределенияПоГруппе("Материалы").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "МатериальныеЗатраты";
	ИначеЕсли Не ТипыБазРаспределенияПоГруппе("Трудозатраты").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "Трудозатраты";
	ИначеЕсли Не ТипыБазРаспределенияПоГруппе("Продукция").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "Продукция";
	ИначеЕсли Не ТипыБазРаспределенияПоГруппе("МатериальныеИТрудозатраты").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "МатериальныеИТрудозатраты";
	ИначеЕсли Не ТипыБазРаспределенияПоГруппе("Товары").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "Товары";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает значение типа базы распределения по умолчанию в зависимости от назначения правила распределения
// Параметры:
//	НазначениеПравилРаспределенияРасходов - ПеречислениеСсылка.НазначениеПравилРаспределенияРасходов - назначения.
// Возвращаемое значение:
//	ПеречислениеСсылка.ТипыБазыРаспределенияРасходов - значение типа базы распределения по умолчанию.
Функция ЗначениеПоУмолчанию(НазначениеПравилРаспределенияРасходов) Экспорт
	
	Если НазначениеПравилРаспределенияРасходов = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаСебестоимостьТоваров Тогда
		Возврат Перечисления.ТипыБазыРаспределенияРасходов.КоличествоТоваров;
	ИначеЕсли НазначениеПравилРаспределенияРасходов = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства 
		Или НазначениеПравилРаспределенияРасходов = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаСебестоимостьПроизводства Тогда
		Возврат Перечисления.ТипыБазыРаспределенияРасходов.КоличествоПродукции;
	КонецЕсли;
	
	Возврат Перечисления.ТипыБазыРаспределенияРасходов.ПустаяСсылка();
	
КонецФункции

// Возвращает типы баз распределения в зависимости от указанной группы
// Параметры:
//	Группа - Строка - Условное обозначение гуппы.
// Возвращаемое значение:
//	Массив из ПеречислениеСсылка.ТипыБазыРаспределенияРасходов - массив типов баз распределения.
Функция ТипыБазРаспределенияПоГруппе(Группа) Экспорт
	
	ТипыБаз = Новый Массив;
	
	Если Группа = "Материалы" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхЗатрат"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоУказанныхМатериалов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесУказанныхМатериалов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемУказанныхМатериалов"));
		
	КонецЕсли;
		
	Если Группа = "Трудозатраты" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаРасходовНаОплатуТруда"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоРаботУказанныхВидов"));
		
	КонецЕсли;

	Если Группа = "Продукция" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоПродукцииСУчетомБудущихВыпусков"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесПродукцииСУчетомБудущихВыпусков"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемПродукцииСУчетомБудущихВыпусков"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ПлановаяСтоимостьПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ПлановаяСтоимостьПродукцииСУчетомБудущихВыпусков"));
		
	КонецЕсли;

	Если Группа = "МатериальныеИТрудозатраты" Тогда
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат"));
		
	КонецЕсли;
	
	Если Группа = "Товары" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоТоваров"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемТоваров"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесТоваров"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СебестоимостьТоваров"));
		
	КонецЕсли;
	
	Если Группа = "Стоимость" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхЗатрат"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаРасходовНаОплатуТруда"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ПлановаяСтоимостьПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ПлановаяСтоимостьПродукцииСУчетомБудущихВыпусков"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат"));
		
	КонецЕсли;
	
	Если Группа = "Количество" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоУказанныхМатериалов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоРаботУказанныхВидов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоПродукцииСУчетомБудущихВыпусков"));
		
	КонецЕсли;
	
	Если Группа = "Объем" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемУказанныхМатериалов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемПродукцииСУчетомБудущихВыпусков"));
		
	КонецЕсли;
	
	Если Группа = "Вес" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесУказанныхМатериалов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесПродукции"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесПродукцииСУчетомБудущихВыпусков"));
		
	КонецЕсли;
	
	Если Группа = "Продажа" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВыручкаОтПродаж"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВаловаяПрибыль"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СебестоимостьПродаж"));
		
	КонецЕсли;
	
	Возврат ТипыБаз;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипыБазРаспределенияПрямыхРасходов() Экспорт
	
	ТипыБаз = Новый Массив;
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоПродукции"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоПродукцииСУчетомБудущихВыпусков"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесПродукции"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесПродукцииСУчетомБудущихВыпусков"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемПродукции"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемПродукцииСУчетомБудущихВыпусков"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхЗатрат"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаРасходовНаОплатуТруда"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ПлановаяСтоимостьПродукции"));
	ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ПлановаяСтоимостьПродукцииСУчетомБудущихВыпусков"));
	
	Возврат ТипыБаз;
	
КонецФункции

#КонецОбласти

#КонецЕсли
