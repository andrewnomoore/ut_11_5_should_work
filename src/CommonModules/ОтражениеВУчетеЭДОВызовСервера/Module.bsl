// @strict-types

#Область СлужебныеПроцедурыИФункции

#Область Настройки

// Параметры:
//  УникальныйИдентификатор - УникальныйИдентификатор
//  Получатель - см. РегистрСведений.НастройкиПолученияЭлектронныхДокументов.Получатель
//  Отправитель - см. РегистрСведений.НастройкиПолученияЭлектронныхДокументов.Отправитель
//  ИдентификаторПолучателя - см. РегистрСведений.НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя
//  ИдентификаторОтправителя - см. РегистрСведений.НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция НачатьУдалениеНастроекОтраженияВУчете(Знач УникальныйИдентификатор, Знач Получатель, Знач Отправитель, Знач ИдентификаторПолучателя,
	Знач ИдентификаторОтправителя) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Удаление настройки отправки электронных документов'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.Удалить", Получатель, Отправитель,
		ИдентификаторПолучателя, ИдентификаторОтправителя);
	
КонецФункции

#КонецОбласти

#Область Отражение

// Параметры:
//  ДанныеЭлектронногоДокумента - см. ОтражениеВУчетеЭДО.НовыеДанныеЭлектронногоДокументаДляОтраженияВУчете
//  СпособОбработки - см. ОтражениеВУчетеЭДО.СпособОбработкиДокумента
//  ОбъектыУчета - Массив из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
Процедура ЗаполнитьДокументУчета(Знач ДанныеЭлектронногоДокумента, Знач СпособОбработки, ОбъектыУчета) Экспорт
	
	ОтражениеВУчетеЭДО.ОтразитьДанныеЭлектронногоДокумента(ДанныеЭлектронногоДокумента, СпособОбработки, ОбъектыУчета);
	
КонецПроцедуры

// Параметры:
//  ПараметрыЗаполнения - см. ОтражениеВУчетеЭДО.ПерезаполнитьДокумент.ПараметрыЗаполнения
//  КонтекстДиагностики - см. ОтражениеВУчетеЭДО.ПерезаполнитьДокумент.КонтекстДиагностики
// 
// Возвращаемое значение:
//  См. ОтражениеВУчетеЭДО.ПерезаполнитьДокумент
Функция ПерезаполнитьДокумент(Знач ПараметрыЗаполнения, КонтекстДиагностики) Экспорт
	
 	Возврат ОтражениеВУчетеЭДО.ПерезаполнитьДокумент(ПараметрыЗаполнения, КонтекстДиагностики);
	
КонецФункции

// Параметры:
//  ДанныеЭлектронногоДокумента - см. ОтражениеВУчетеЭДОКлиент.НовыеДанныеЭлектронногоДокументаДляОтраженияВУчете
// 
// Возвращаемое значение:
//  см. ОтражениеВУчетеЭДО.НоменклатураЭлектронногоДокументаБезСопоставления
Функция НоменклатураЭлектронногоДокументаБезСопоставления(ДанныеЭлектронногоДокумента) Экспорт
	
	Если ДанныеЭлектронногоДокумента.ТипДокумента = Перечисления.ТипыДокументовЭДО.РеквизитыОрганизации Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОтражениеВУчетеЭДО.НоменклатураЭлектронногоДокументаБезСопоставления(ДанныеЭлектронногоДокумента); 
	
КонецФункции


#КонецОбласти

#КонецОбласти
