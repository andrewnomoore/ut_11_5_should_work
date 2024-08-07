
#Область ПрограммныйИнтерфейс

// Получает данные по алкогольной продукции из прикладного документа при открытии формы проверки
// 
// Параметры:
//  Параметры - См. Обработки.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.ЗагрузитьДанныеДокументаДлительнаяОперация.Параметры
//  ДанныеДокумента - См. Обработки.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.ЗагрузитьДанныеДокументаДлительнаяОперация
//
Процедура ПриЗагрузкеДанныхДокумента(Параметры, ДанныеДокумента) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Возвращает данные по алкогольной продукции в прикладной документ при завершении проверки
// 
// Параметры:
//  РезультатПроверки - См. Обработки.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.ЗафиксироватьРезультатПроверкиИПодбора.Параметры
//
Процедура ОтразитьРезультатыСканированияВДокументе(РезультатПроверки) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПриОпределенииПараметровИнтеграцииФормыПроверкиИПодбора(Форма, ПараметрыИнтеграции) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Заполняет специфику применения интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма для которой применяются параметры интеграции.
//
Процедура ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возвращает через третий параметр признак наличия маркируемой продукции.
//
// Параметры:
//  Коллекция                - ДанныеФормыКоллекция - ТЧ с товарами.
//  ЕстьМаркируемаяПродукция - Булево - Исходящий, признак наличия маркируемой продукции.
//
Процедура ЕстьМаркируемаяПродукцияВКоллекции(Коллекция, ЕстьМаркируемаяПродукция) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти
