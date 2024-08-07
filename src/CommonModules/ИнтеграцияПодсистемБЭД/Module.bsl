// @strict-types

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Обработка программных событий, возникающих в подсистемах БСП.
// Только для вызовов из библиотеки БСП в БЭД.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - см. ИнтеграцияПодсистемБСП.СобытияБСП.
//
Процедура ПриОпределенииПодписокНаСобытияБСП(Подписки) Экспорт

	// ВнешниеКомпоненты
	//@skip-check property-return-type
	Подписки.ПриОпределенииИспользуемыхВнешнихКомпонент = Истина;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ИнтеграцияПодсистемБСП.ПриОпределенииИспользуемыхВнешнихКомпонент.
Процедура ПриОпределенииИспользуемыхВнешнихКомпонент(Компоненты) Экспорт 

	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками") Тогда
		МодульОбменСБанкамиСлужебный = ОбщегоНазначения.ОбщийМодуль("ОбменСБанкамиСлужебный");
		МодульОбменСБанкамиСлужебный.ПриОпределенииИспользуемыхВнешнихКомпонент(Компоненты);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти