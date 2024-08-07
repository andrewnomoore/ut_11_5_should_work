#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	УправлениеДоступомИСПереопределяемый.ПриЗаполненииОграниченияДоступа(
		Метаданные.РегистрыСведений.ОчередьСообщенийЗЕРНО, Ограничение);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	Возврат;
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// Параметры:
//   МассивОбъектов        - Массив из Произвольный         - ссылки на объекты, которые нужно распечатать
//   ПараметрыПечати       - Структура                      - дополнительные настройки печати
//   КоллекцияПечатныхФорм - ТаблицаЗначений                - сформированные табличные документы (выходной параметр)
//   ОбъектыПечати         - СписокЗначений из Произвольный - имя области, в которой был выведен объект (выходной параметр)
//   ПараметрыВывода       - Структура                      - дополнительные параметры сформированных табличных документов (выходной параметр)
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Очередь сообщений по документу.
// Параметры:
//  Документ - ОпределяемыйТип.ДокументыЗЕРНО - ссылка на документ.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Описание:
//   * Сообщение - ОпределяемыйТип.УникальныйИдентификаторИС - идентификатор сообщения.
//   * Операция - ПеречислениеСсылка.ВидыОперацийЗЕРНО - операция.
//   * Организация - ОпределяемыйТип.Организация - организация.
//
Функция ОчередьСообщенийПоДокументу(Документ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОчередьСообщенийИСМП.Сообщение          КАК Сообщение,
	|	ОчередьСообщенийИСМП.Операция           КАК Операция,
	|	ОчередьСообщенийИСМП.Организация        КАК Организация,
	|	ОчередьСообщенийИСМП.Подразделение      КАК Подразделение,
	|	ОчередьСообщенийИСМП.СообщениеОснование КАК СообщениеОснование
	|ИЗ
	|	РегистрСведений.ОчередьСообщенийЗЕРНО КАК ОчередьСообщенийИСМП
	|ГДЕ
	|	ОчередьСообщенийИСМП.СсылкаНаОбъект = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
