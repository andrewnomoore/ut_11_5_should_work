
#Область ПрограммныйИнтерфейс

Процедура ПриПодбореУчетногоДокументаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = "1" Тогда
		ОткрытьФорму("Документ.СчетФактураПолученный.ФормаВыбора", 
			ДополнительныеПараметры.ПараметрыФормы,,,,, ДополнительныеПараметры.ОповещениеОВыборе, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли РезультатВопроса = "2" Тогда 
		ОткрытьФорму("Документ.СчетФактураПолученныйАванс.ФормаВыбора", 
			ДополнительныеПараметры.ПараметрыФормы,,,,, ДополнительныеПараметры.ОповещениеОВыборе, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли РезультатВопроса = "4" Тогда
		ПараметрыФормы = ДополнительныеПараметры.ПараметрыФормы;
		Если ПараметрыФормы.Свойство("Отбор") Тогда 
			СтарыйОтбор = ПараметрыФормы.Отбор;
			НовыйОтбор = Новый Структура;
			Для каждого ЭлементОтбора Из СтарыйОтбор Цикл
				Если ЭлементОтбора.Ключ = "Контрагент" Тогда
					НовыйОтбор.Вставить("Организация", ЭлементОтбора.Значение);
				ИначеЕсли ЭлементОтбора.Ключ = "Организация" Тогда
					НовыйОтбор.Вставить("ОрганизацияПолучатель", ЭлементОтбора.Значение);
				КонецЕсли;
			КонецЦикла;
			ПараметрыФормы.Вставить("Отбор", НовыйОтбор);
		КонецЕсли;
			
			ОткрытьФорму("Документ.СчетФактураВыданный.ФормаВыбора", 
				ДополнительныеПараметры.ПараметрыФормы,,,,, ДополнительныеПараметры.ОповещениеОВыборе, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаВыбора", 
			ДополнительныеПараметры.ПараметрыФормы,,,,, ДополнительныеПараметры.ОповещениеОВыборе, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСозданииНоменклатурыПоДаннымКонтрагента(Знач НаборНоменклатурыКонтрагентов, Знач ОповещениеОЗавершении, СтандартнаяОбработка = Истина) Экспорт
	
	Если Не НаборНоменклатурыКонтрагентов.Количество() Тогда
		Возврат
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	НоменклатураКонтрагента = НаборНоменклатурыКонтрагентов[0];
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	ПараметрыЗавершения.Вставить("НоменклатураКонтрагента", НоменклатураКонтрагента);
	
	ОписаниеОповещенияОЗакрытииФормы = Новый ОписаниеОповещения("ПриСозданииНоменклатурыПоДаннымКонтрагентаЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ФормаНоменклатуры = ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытииФормы, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Если ФормаНоменклатуры <> Неопределено Тогда
		ДанныеЗаполнения = ЭлектронноеВзаимодействиеУТВызовСервера.ДанныеДляЗаполнения(НоменклатураКонтрагента);
		
		ФормаНоменклатуры.Объект.Артикул = ДанныеЗаполнения.Артикул;
		ФормаНоменклатуры.Объект.Наименование = ДанныеЗаполнения.Наименование;
		ФормаНоменклатуры.Объект.НаименованиеПолное = ДанныеЗаполнения.Наименование;
		ФормаНоменклатуры.Объект.ЕдиницаИзмерения = ДанныеЗаполнения.ЕдиницаИзмерения;
		ФормаНоменклатуры.Объект.СтавкаНДС = ДанныеЗаполнения.СтавкаНДС;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСозданииНоменклатурыПоДаннымКонтрагентаЗавершение(Знач НоменклатураСсылка, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(НоменклатураСсылка) Тогда 
		ДополнительныеПараметры.Свойство("НоменклатураСсылка", НоменклатураСсылка);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НоменклатураСсылка) Тогда 
		Возврат;
	КонецЕсли;
	
	Результат = Новый Массив;
	
	НоменклатураИБ = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураИнформационнойБазы(НоменклатураСсылка);
		
	СозданныйЭлемент = Новый Структура;
	СозданныйЭлемент.Вставить("НоменклатураКонтрагента", ДополнительныеПараметры.НоменклатураКонтрагента);
	СозданныйЭлемент.Вставить("НоменклатураИБ", НоменклатураИБ);
	Результат.Добавить(СозданныйЭлемент);
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, Результат);
	
КонецПроцедуры
	
// Формирует представление этапа госконтракта для отображения в формах документов.
// 
// Параметры:
//  Данные - см. ЭлектронноеВзаимодействиеУТВызовСервера.СформироватьПредставлениеЭтапаГосконтракта.Данные
// 
// Возвращаемое значение:
//  Строка - см. ЭлектронноеВзаимодействиеУТВызовСервера.СформироватьПредставлениеЭтапаГосконтракта
//
Функция СформироватьПредставлениеЭтапаГосконтракта(Данные) Экспорт
	
	Возврат ЭлектронноеВзаимодействиеУТВызовСервера.СформироватьПредставлениеЭтапаГосконтракта(Данные);
	
КонецФункции

#КонецОбласти
