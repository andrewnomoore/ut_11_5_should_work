
#Область ПрограммныйИнтерфейс

#Область ОбщиеПроцедурыИФункцииФормСпискаИВыбораСправочникаПартнеры

// При перетаскивании в форме списка обновляет значение реквизита, на которое было выполнено перетаскивание для массива
// перетаскиваемых партнеров.
//
// Параметры:
//  Значение              - Произвольный - значение, на которое было выполнено перетаскивание.
//  МассивПартнеров       - Массив Из СправочникСсылка.Партнеры - массив перетаскиваемых партнеров.
//  КоличествоЗаписанных  - Число - количество записанных партнеров.
//
Процедура ОбновитьЗначениеРеквизитаУПеретаскиваемыхПартнеров(Значение, МассивПартнеров, КоличествоЗаписанных) Экспорт

	КоличествоЗаписанных = 0;
	МассивГруппДоступныхДляИзменения =
		УправлениеДоступом.ГруппыЗначенийДоступаРазрешающиеИзменениеЗначенийДоступа(Тип("СправочникСсылка.Партнеры"), Истина);
	
	ИмяРеквизита = "";
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.БизнесРегионы") Тогда
		ИмяРеквизита = "БизнесРегион";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ГруппыДоступаПартнеров") Тогда
		ИмяРеквизита = "ГруппаДоступа";
		Если МассивГруппДоступныхДляИзменения.Найти(Значение) = Неопределено Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Пользователи") Тогда
		ИмяРеквизита = "ОсновнойМенеджер";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Партнеры.Ссылка
	|ИЗ
	|	Справочник.Партнеры КАК Партнеры
	|ГДЕ
	|	Партнеры.Ссылка В(&МассивПартнеров)
	|	И Партнеры.ГруппаДоступа В (&МассивГруппДоступныхДляИзменения)
	|	И &ИмяРеквизитаПартнеры <> &Значение";
	
	Запрос.УстановитьПараметр("МассивПартнеров",МассивПартнеров);
	Запрос.УстановитьПараметр("Значение",Значение);
	Запрос.УстановитьПараметр("МассивГруппДоступныхДляИзменения", МассивГруппДоступныхДляИзменения);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИмяРеквизитаПартнеры", "Партнеры." + ИмяРеквизита);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		ПартнерОбъект =  Выборка.Ссылка.ПолучитьОбъект();
		ПартнерОбъект[ИмяРеквизита] = Значение;
		ПартнерОбъект.Записать();
		КоличествоЗаписанных = КоличествоЗаписанных + 1;
	
	КонецЦикла;

КонецПроцедуры

// Получает основного менеджера бизнес-региона.
//
// Параметры:
//  БизнесРегион  - СправочникСсылка.БизнесРегионы - бизнес-регион, для которого получается основной менеджер.
//
// Возвращаемое значение:
//   СправочникСсылка.Пользователи   - основной менеджер бизнес-региона.
//
Функция ОсновнойМенеджерБизнесРегиона(БизнесРегион) Экспорт

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БизнесРегион,"ОсновнойМенеджер");

КонецФункции

// Получает партнера - объекта авторизации внешнего пользователя
//
// Возвращаемое значение:
//  СправочникСсылка.Партнеры - партнер,если объект авторизации партнер, неопределено в обратном случае.
//
Функция ПолучитьАвторизовавшегосяПартнера() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешнийПользователь = ВнешниеПользователи.ТекущийВнешнийПользователь();
	Если НЕ ЗначениеЗаполнено(ВнешнийПользователь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбъектАвторизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВнешнийПользователь, "ОбъектАвторизации");
	
	Если ТипЗнч(ОбъектАвторизации) = Тип("СправочникСсылка.Партнеры") Тогда
		Возврат ОбъектАвторизации;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Формирует представление справочника Партнеры в зависимости от настроек раздельного или совместного использования
// партнеров и контрагентов.
//
// Возвращаемое значение:
//   Строка   - сформированное представление справочника Партнеры.
//
Функция ПредставлениеСправочникаПартнеры() Экспорт
	
	Возврат ?(ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов"), НСтр("ru = 'Контрагенты'"), НСтр("ru = 'Партнеры'"));
	
КонецФункции

// Получает структуру данных о авторизовавшемся внешнем пользователе
//
// Возвращаемое значение:
//  Структура - содержит:
//  * АвторизованПартнер - Булево - Истина, если авторизован Партнер, Ложь, если контактное лицо.
//  * Партнер            - СправочникСсылка.Партнеры - информация об авторизовавшемся партнере.
//  * КонтактноеЛицо     - СправочникСсылка.КонтактныеЛицаПартнеров - информация об авторизовавшемся контактном лице.
//
Функция ДанныеАвторизовавшегосяВнешнегоПользователя() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешнийПользователь = ВнешниеПользователи.ТекущийВнешнийПользователь();
	Если НЕ ЗначениеЗаполнено(ВнешнийПользователь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	АвторизованПартнер = Истина;
	Партнер            = Справочники.Партнеры.ПустаяСсылка();
	КонтактноеЛицо     = Справочники.КонтактныеЛицаПартнеров.ПустаяСсылка();
	
	ОбъектАвторизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВнешнийПользователь, "ОбъектАвторизации");
	
	Если ТипЗнч(ОбъектАвторизации) = Тип("СправочникСсылка.Партнеры") Тогда
		Партнер        = ОбъектАвторизации;
	ИначеЕсли ТипЗнч(ОбъектАвторизации) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		АвторизованПартнер = Ложь;
		КонтактноеЛицо = ОбъектАвторизации;
		Партнер        = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектАвторизации, "Владелец");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураКВозврату = Новый Структура;
	СтруктураКВозврату.Вставить("АвторизованПартнер", АвторизованПартнер);
	СтруктураКВозврату.Вставить("Партнер", Партнер);
	СтруктураКВозврату.Вставить("КонтактноеЛицо", КонтактноеЛицо);
	
	Возврат СтруктураКВозврату;
	
КонецФункции

// Получает данные для открытия формы
// 
// Параметры:
// 	Параметры - Структура - структура параметров открытия формы
//	
Процедура ДанныеКонтрагентаДляОткрытияФормыПартнера(Параметры) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтрагентСсылка.Партнер КАК Партнер,
	|	КонтрагентСсылка.ИНН КАК ИНН,
	|	КонтрагентСсылка.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Контрагенты КАК КонтрагентСсылка
	|ГДЕ
	|	КонтрагентСсылка.Ссылка = &КонтрагентСсылка
	|";
	Запрос.УстановитьПараметр("КонтрагентСсылка", Параметры.Ключ);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Параметры.Вставить("Ключ",         Выборка.Партнер);
		Параметры.Вставить("ИНН",          Выборка.ИНН);
		Параметры.Вставить("Наименование", Выборка.Наименование);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


// Получает значения полей контактной информации в формате XML по представлению
// 
// Параметры:
//  Представление           - Строка
//  ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации - 
//  Комментарий              - Строка - Комментарий
// 
// Возвращаемое значение:
//  Строка - Значения полей контактной информации
Функция ЗначенияПолейКонтактнойИнформации(Знач Представление, Знач ВидКонтактнойИнформации, Знач Комментарий = Неопределено) Экспорт
	
	// Создаем новый экземпляр по представлению
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Представление, ВидКонтактнойИнформации);
	
	// Добавляем в него комментарий, если есть
	Если Комментарий <> Неопределено Тогда
		Комментарий = УправлениеКонтактнойИнформацией.КомментарийКонтактнойИнформации(Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 


// Определяет имя формы создания контрагента
// 
// Возвращаемое значение:
//  Строка - Имя формы создания контрагента
Функция ИмяФормыСозданияКонтрагента() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		Возврат "Справочник.Партнеры.Форма.ПомощникНового";
	Иначе
		Возврат "Справочник.Контрагенты.Форма.ФормаЭлемента";
	КонецЕсли;
	
КонецФункции


// Массив установленных параметров отбора по типу партнера.
// 
// Параметры:
//  Параметры - Отбор - 
// 
// Возвращаемое значение:
//  Массив Из Строка - Массив установленных параметров отбора по типу партнера
Функция МассивУстановленныхПараметровОтбораПоТипуПартнера(Параметры) Экспорт
	
	МассивУстановленныхОтборов = Новый Массив;
	Если Параметры.Отбор.Свойство("Клиент") Тогда
		МассивУстановленныхОтборов.Добавить("Клиент");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("Поставщик") Тогда
		МассивУстановленныхОтборов.Добавить("Поставщик");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("Конкурент") Тогда
		МассивУстановленныхОтборов.Добавить("Конкурент");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("ПрочиеОтношения") Тогда
		МассивУстановленныхОтборов.Добавить("ПрочиеОтношения");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("ОбслуживаетсяТорговымиПредставителями") Тогда
		МассивУстановленныхОтборов.Добавить("ОбслуживаетсяТорговымиПредставителями");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("НашеПредприятие") Тогда
		МассивУстановленныхОтборов.Добавить("НашеПредприятие");
	КонецЕсли;
	
	Возврат МассивУстановленныхОтборов;
	
КонецФункции


// Формирует строку текста запроса по массиву установленных отборов по типу партнера
// 
// Параметры:
//  Параметры - Структура - содержит:
//    * УстанавливатьОтборПоТипуПартнераКакИЛИ - Булево - 
//  МассивУстановленныхОтборов - Массив Из Строка - имена реквизитов отбора по типам отношений с партнером.
// 
// Возвращаемое значение:
//  Строка - 
//
Функция СтрокаОтбораЗапросаПоТипуПартнера(Параметры, МассивУстановленныхОтборов) Экспорт
	
	УстанавливатьОтборПоТипуПартнераКакИЛИ = Параметры.Свойство("УстанавливатьОтборПоТипуПартнераКакИЛИ") 
	                                         И Параметры.УстанавливатьОтборПоТипуПартнераКакИЛИ;
	
	СтрокаОтбора = "";
	УстановленоОтборов = 0;
	
	Для каждого ЭлементМассива Из МассивУстановленныхОтборов Цикл
		Если ЭлементМассива = "НашеПредприятие" Тогда
			Условие = "Партнеры.Ссылка = ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)"; 
		Иначе
			Условие = "Партнеры." + ЭлементМассива; 
		КонецЕсли;
		 
		Если УстановленоОтборов > 0 Тогда
			Если УстанавливатьОтборПоТипуПартнераКакИЛИ Тогда
				СтрокаОтбора = СтрокаОтбора + " ИЛИ "; // @query-part
			Иначе
				СтрокаОтбора = СтрокаОтбора + " И "; // @query-part
			КонецЕсли;
		КонецЕсли;
		
		СтрокаОтбора = СтрокаОтбора + Условие;
		УстановленоОтборов = УстановленоОтборов + 1;
		
	КонецЦикла;
	
	Возврат ?(ПустаяСтрока(СтрокаОтбора),""," И (" + СтрокаОтбора + ")");
	
КонецФункции

Процедура ЗаполнитьКонтрагентаПартнераПоУмолчанию(Знач Партнер, Контрагент, ПерезаполнятьКонтрагента) Экспорт
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент, ПерезаполнятьКонтрагента);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеКонтрагентаПартнера(Приемник, Партнер, СИсторическимиДанными = Истина) Экспорт
	
	ПартнерыИКонтрагенты.ЗаполнитьДанныеКонтрагентаПартнера(Приемник, Партнер, СИсторическимиДанными);
	
КонецПроцедуры

// Вызывается для включения ведения истории для вида контактной информации.
// Параметры:
//  ИмяВидаКонтактнойИнформации - Строка - имя вида контактной информации.
//
Процедура ВключитьХранениеИсторииИзменений(ИмяВидаКонтактнойИнформации) Экспорт
	
	ПартнерыИКонтрагенты.ВключитьХранениеИсторииИзменений(ИмяВидаКонтактнойИнформации);
	
КонецПроцедуры

// Получает единственного контрагента партнера.
// 
// Параметры:
//  Партнер - СправочникСсылка.Партнеры -
// 
// Возвращаемое значение:
//  СправочникСсылка.Контрагенты - Контрагент партнера
Функция КонтрагентПартнера(Партнер) Экспорт
	
	Возврат ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер);
	
КонецФункции

#Область ДанныеВыбора

// Возвращает доступные виды сделок для данных выбора при поиске по строке.
// 
// Параметры:
//  СтрокаПоиска -  Строка - Строка поиска.
// 
// Возвращаемое значение:
//  Неопределено, СписокЗначений - 
//
Функция ВидыСделокДанныхВыбора(СтрокаПоиска) Экспорт

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи") Тогда

		ДанныеВыбора  = Новый СписокЗначений;
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ВидыСделокСКлиентами.Ссылка
		|ИЗ
		|	Справочник.ВидыСделокСКлиентами КАК ВидыСделокСКлиентами
		|ГДЕ
		|	ВидыСделокСКлиентами.ИспользованиеРазрешено
		|	И ВидыСделокСКлиентами.ТипСделки В(&ДоступныеТипыСделок)
		|	И ВидыСделокСКлиентами.Наименование ПОДОБНО &СтрокаПоиска СПЕЦСИМВОЛ ""~""";
		
		ДоступныеТипыСделок = Новый Массив;
		ДоступныеТипыСделок.Добавить(Перечисления.ТипыСделокСКлиентами.ПрочиеНепроцессныеСделки);
		ДоступныеТипыСделок.Добавить(Перечисления.ТипыСделокСКлиентами.СделкиСРучнымПереходомПоЭтапам);
		
		Запрос.УстановитьПараметр("СтрокаПоиска", ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(СтрокаПоиска)+"%");
		Запрос.УстановитьПараметр("ДоступныеТипыСделок", ДоступныеТипыСделок);
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		
		Возврат ДанныеВыбора;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;

КонецФункции

// Получает данные выбора справочника Контрагенты.
// 
// Параметры:
//  Параметры - Структура - содержит:
//   * Отбор                         - Отбор - 
//   * ВыборКонтрагентовИОрганизаций - Булево - 
//   * СтрокаПоиска                  - Строка - 
// 
// Возвращаемое значение:
//  СписокЗначений - 
Функция КонтрагентыДанныеВыбора(Параметры) Экспорт
	
 	ДанныеВыбора = Новый СписокЗначений;
	Партнер = Неопределено;
	
	Если Параметры.Отбор.Свойство("Партнер") Тогда
		Партнер = ?(ЗначениеЗаполнено(Параметры.Отбор.Партнер),Параметры.Отбор.Партнер,Неопределено);
		Параметры.Отбор.Удалить("Партнер");
	КонецЕсли;
	
	ЮрФизЛицо = Неопределено;
	
	Если Параметры.Отбор.Свойство("ЮрФизЛицо") Тогда
		ЮрФизЛицо = ?(ЗначениеЗаполнено(Параметры.Отбор.ЮрФизЛицо),Параметры.Отбор.ЮрФизЛицо,Неопределено);
		Параметры.Отбор.Удалить("ЮрФизЛицо");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	МассивУстановленныхОтборов = ПартнерыИКонтрагентыВызовСервера.МассивУстановленныхПараметровОтбораПоТипуПартнера(Параметры);
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	Если МассивУстановленныхОтборов.Количество() > 0 И ИспользоватьПартнеровКакКонтрагентов Тогда
		
		СтрокаОтбора = ПартнерыИКонтрагентыВызовСервера.СтрокаОтбораЗапросаПоТипуПартнера(Параметры, МассивУстановленныхОтборов);
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
		|	Контрагенты.Ссылка                КАК Ссылка,
		|	Контрагенты.ЮрФизЛицо             КАК ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка) КАК Представление,
		|	Партнеры.Наименование             КАК ПартнерНаименование,
		|	Контрагенты.Наименование          КАК Наименование,
		|	Контрагенты.ИНН                   КАК ИНН,
		|	&НайденоПоНаименованию            КАК НайденоПо,
		|	Контрагенты.ПометкаУдаления       КАК ПометкаУдаления
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
		|		ПО Контрагенты.Партнер = Партнеры.Ссылка
		|ГДЕ
		|	Контрагенты.Наименование ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|	И Партнеры.Ссылка = &УсловиеОтбора
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 51
		|	Контрагенты.Ссылка,
		|	Контрагенты.ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка),
		|	Партнер.Наименование,
		|	Контрагенты.Наименование,
		|	Контрагенты.ИНН,
		|	&НайденоПоИНН,
		|	Контрагенты.ПометкаУдаления
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
		|		ПО Контрагенты.Партнер = Партнеры.Ссылка
		|ГДЕ
		|	Контрагенты.ИНН ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|	И Партнеры.Ссылка = &УсловиеОтбора
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Контрагенты.ПометкаУдаления";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И Партнеры.Ссылка = &УсловиеОтбора" , СтрокаОтбора);
		
	ИначеЕсли Параметры.Свойство("ВыборКонтрагентовИОрганизаций") И ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 41
		|	Контрагенты.Ссылка                КАК Ссылка,
		|	Контрагенты.ЮрФизЛицо             КАК ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка) КАК Представление,
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Родитель.Наименование
		|		ИНАЧЕ Контрагенты.Партнер.Наименование
		|	КОНЕЦ                            КАК ПартнерНаименование,
		|	Контрагенты.Наименование,
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Уровень
		|		ИНАЧЕ -1
		|	КОНЕЦ                           КАК ПорядокВывода,
		|	Контрагенты.ИНН                 КАК ИНН,
		|	&НайденоПоНаименованию          КАК НайденоПо,
		|	Контрагенты.ПометкаУдаления     КАК ПометкаУдаления
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК ИерархияПартнеров
		|		ПО Контрагенты.Партнер = ИерархияПартнеров.Родитель
		|ГДЕ
		|	Контрагенты.Наименование ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 41
		|	Контрагенты.Ссылка,
		|	Контрагенты.ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка),
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Родитель.Наименование
		|		ИНАЧЕ Контрагенты.Партнер.Наименование
		|	КОНЕЦ,
		|	Контрагенты.Наименование,
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Уровень
		|		ИНАЧЕ -1
		|	КОНЕЦ,
		|	Контрагенты.ИНН,
		|	&НайденоПоИНН,
		|	Контрагенты.ПометкаУдаления
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК ИерархияПартнеров
		|		ПО Контрагенты.Партнер = ИерархияПартнеров.Родитель
		|ГДЕ
		|	Контрагенты.ИНН ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 10
		|	Контрагенты.Ссылка,
		|	Контрагенты.ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка),
		|	&НашеПредприятие,
		|	Контрагенты.Наименование,
		|	 -1,
		|	Контрагенты.ИНН,
		|	&НайденоПоНаименованию,
		|	Контрагенты.ПометкаУдаления
		|ИЗ
		|	Справочник.Организации КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Наименование ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 10
		|	Контрагенты.Ссылка,
		|	Контрагенты.ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка),
		|	&НашеПредприятие,
		|	Контрагенты.Наименование,
		|	 -1,
		|	Контрагенты.ИНН,
		|	&НайденоПоИНН,
		|	Контрагенты.ПометкаУдаления
		|ИЗ
		|	Справочник.Организации КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ИНН ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Контрагенты.ПометкаУдаления,
		|	ПорядокВывода УБЫВ";
		
	Иначе
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
		|	Контрагенты.Ссылка                КАК Ссылка,
		|	Контрагенты.ЮрФизЛицо             КАК ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка) КАК Представление,
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Родитель.Наименование
		|		ИНАЧЕ Контрагенты.Партнер.Наименование
		|	КОНЕЦ                            КАК ПартнерНаименование,
		|	Контрагенты.Наименование         КАК Наименование,
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Уровень
		|		ИНАЧЕ -1
		|	КОНЕЦ                           КАК ПорядокВывода,
		|	Контрагенты.ИНН                    КАК ИНН,
		|	&НайденоПоНаименованию          КАК НайденоПо,
		|	Контрагенты.ПометкаУдаления     КАК ПометкаУдаления
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК ИерархияПартнеров
		|		ПО Контрагенты.Партнер = ИерархияПартнеров.Родитель
		|ГДЕ
		|	Контрагенты.Наименование ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 51
		|	Контрагенты.Ссылка,
		|	Контрагенты.ЮрФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка),
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Родитель.Наименование
		|		ИНАЧЕ Контрагенты.Партнер.Наименование
		|	КОНЕЦ,
		|	Контрагенты.Наименование,
		|	ВЫБОР
		|		КОГДА ИерархияПартнеров.Партнер = &Партнер
		|			ТОГДА ИерархияПартнеров.Уровень
		|		ИНАЧЕ -1
		|	КОНЕЦ,
		|	Контрагенты.ИНН,
		|	&НайденоПоИНН,
		|	Контрагенты.ПометкаУдаления
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК ИерархияПартнеров
		|		ПО Контрагенты.Партнер = ИерархияПартнеров.Родитель
		|ГДЕ
		|	Контрагенты.ИНН ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""
		|   И &УсловиеОтбораЮрФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Контрагенты.ПометкаУдаления,
		|	ПорядокВывода УБЫВ";
		
	КонецЕсли;
	
	УсловиеОтбораЮрФизЛицо = "ИСТИНА";
	Если ЗначениеЗаполнено(ЮрФизЛицо) Тогда
		УсловиеОтбораЮрФизЛицо = "Контрагенты.ЮрФизЛицо В (&ЮрФизЛицо)";
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеОтбораЮрФизЛицо" , УсловиеОтбораЮрФизЛицо);
	
	СтрокаПоиска = ?(Параметры.СтрокаПоиска = Неопределено, "", Параметры.СтрокаПоиска);
	
	Запрос.УстановитьПараметр("СтрокаВвода", ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(СтрокаПоиска) + "%");
	Запрос.УстановитьПараметр("Партнер",               Партнер);
	Запрос.УстановитьПараметр("ЮрФизЛицо",             ЮрФизЛицо);
	Запрос.УстановитьПараметр("НайденоПоНаименованию", "ПоНаименованию");
	Запрос.УстановитьПараметр("НайденоПоИНН",          "ПоИНН");
	Запрос.УстановитьПараметр("НашеПредприятие",       НСтр("ru = 'Наше предприятие'"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ИННПоКоторымНужноВыводитьПрефикс = ИННПоКоторымТребуетсяВыводПрефиксаЮрФизЛицо(Выборка);
	
	Пока Выборка.Следующий() Цикл
		
		Если ДанныеВыбора.НайтиПоЗначению(Выборка.Ссылка) = Неопределено Тогда
			
			Если Выборка.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель
				И ИННПоКоторымНужноВыводитьПрефикс.Найти(Выборка.ИНН) <> Неопределено Тогда
				
				ПрефиксЮрФизЛицо = НСтр("ru = '(ИП)'") ;
				
			ИначеЕсли Выборка.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо 
				И ИННПоКоторымНужноВыводитьПрефикс.Найти(Выборка.ИНН) <> Неопределено Тогда
				
				ПрефиксЮрФизЛицо = НСтр("ru = '(ФЛ)'");
				
			Иначе
				
				ПрефиксЮрФизЛицо = "";
				
			КонецЕсли;
			
			Если Выборка.НайденоПо = "ПоНаименованию"  Тогда
				Представление = ПрефиксЮрФизЛицо  + " " + Выборка.Наименование;
			Иначе
				Представление =  Выборка.ИНН  + " " + ПрефиксЮрФизЛицо + " (" +Выборка.Наименование + ")";
			КонецЕсли;
			
			Если Не ИспользоватьПартнеровКакКонтрагентов Тогда
				Представление = Представление + " (" + Выборка.ПартнерНаименование + ")";
			КонецЕсли;
			
			Если Выборка.ПометкаУдаления Тогда
				СтруктураЗначение = Новый Структура("Значение,ПометкаУдаления", Выборка.Ссылка, Выборка.ПометкаУдаления);
				ДанныеВыбора.Добавить(СтруктураЗначение,Представление,,БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
			Иначе
				ДанныеВыбора.Добавить(Выборка.Ссылка,Представление);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции 

Функция ИННПоКоторымТребуетсяВыводПрефиксаЮрФизЛицо(Выборка)
	
	ДанныеКонтрагентов = Новый Массив;
	
	ПроверяемыеИНН = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ПустаяСтрока(Выборка.ИНН)
			И (Выборка.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель
				Или Выборка.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо) Тогда
			
			ПроверяемыеИНН.Добавить(Выборка.ИНН); 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Выборка.Сбросить();
	
	Если ПроверяемыеИНН.Количество() > 0 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Контрагенты.Ссылка) КАК Ссылка,
		|	Контрагенты.ИНН                          КАК ИНН
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ИНН В(&ПроверяемыеИНН)
		|	И Контрагенты.ЮрФизЛицо В (ЗНАЧЕНИЕ(Перечисление.ЮрФизлицо.ФизЛицо), ЗНАЧЕНИЕ(Перечисление.ЮрФизлицо.ИндивидуальныйПредприниматель))
		|
		|СГРУППИРОВАТЬ ПО
		|	Контрагенты.ИНН
		| ИМЕЮЩИЕ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Контрагенты.Ссылка) > 1"; 
		
		Запрос.УстановитьПараметр("ПроверяемыеИНН", ПроверяемыеИНН);
		
		ДанныеКонтрагентов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИНН");
		
	КонецЕсли;
		
	Возврат ДанныеКонтрагентов;
	
КонецФункции

// Получает данные выбора справочника Партнеры.
// 
// Параметры:
//  Параметры - Структура - содержит:
//   * Отбор                         - Отбор - 
//   * СтрокаПоиска                  - Строка - 
// 
// Возвращаемое значение:
//  СписокЗначений - 
Функция ПартнерыДанныеВыбора(Параметры) Экспорт

	МассивУстановленныхОтборов = ПартнерыИКонтрагентыВызовСервера.МассивУстановленныхПараметровОтбораПоТипуПартнера(Параметры);
	
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	Если МассивУстановленныхОтборов.Количество() > 0 ИЛИ ИспользоватьПартнеровКакКонтрагентов Тогда
		
		Запрос = Новый Запрос;
		
		СтрокаОтбора = ПартнерыИКонтрагентыВызовСервера.СтрокаОтбораЗапросаПоТипуПартнера(Параметры, МассивУстановленныхОтборов);
		
		Если Параметры.Отбор.Свойство("БизнесРегион") Тогда
			СтрокаОтбора = " И Партнеры.БизнесРегион = &БизнесРегион";
			Запрос.УстановитьПараметр("БизнесРегион", Параметры.Отбор.БизнесРегион);
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("ЮрФизЛицо") Тогда
			СтрокаОтбора = СтрокаОтбора + " И (Партнеры.ЮрФизЛицо В (&ЮрФизЛицо)) ";
			Запрос.УстановитьПараметр("ЮрФизЛицо", Параметры.Отбор.ЮрФизЛицо);
		КонецЕсли;
		
		Если ИспользоватьПартнеровКакКонтрагентов Тогда
			СтрокаОтбора = СтрокаОтбора + " И (НЕ Партнеры.Ссылка = Значение(Справочник.Партнеры.НеизвестныйПартнер)) ";
		КонецЕсли;
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
			СтрокаОтбора = СтрокаОтбора + " И (НЕ Партнеры.Ссылка = Значение(Справочник.Партнеры.НашеПредприятие)) ";
		КонецЕсли;
		
		Запрос.УстановитьПараметр(
			"СтрокаВвода", ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(Параметры.СтрокаПоиска) + "%");
		
		Если ИспользоватьПартнеровКакКонтрагентов Тогда
			
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 51
				|	Партнеры.Ссылка КАК Партнер,
				|	Контрагенты.ЮрФизЛицо КАК ЮрФизЛицо, 
				|	ПРЕДСТАВЛЕНИЕ(Партнеры.Ссылка) КАК Представление,
				|	Партнеры.ПометкаУдаления КАК ПометкаУдаления,
				|	Контрагенты.ИНН КАК ИНН,
				|	""НайденоПоНаименованию"" КАК НайденоПо
				|ИЗ
				|	Справочник.Контрагенты КАК Контрагенты
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
				|		ПО Контрагенты.Партнер = Партнеры.Ссылка
				|ГДЕ
				|	Контрагенты.Наименование ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""" + СтрокаОтбора;
				
		Иначе
			
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 51
				|	Партнеры.Ссылка КАК Партнер,
				|	ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ПустаяСсылка) КАК ЮрФизЛицо, 
				|	ПРЕДСТАВЛЕНИЕ(Партнеры.Ссылка) КАК Представление,
				|	Партнеры.ПометкаУдаления КАК ПометкаУдаления,
				|	"""" КАК ИНН,
				|	""НайденоПоНаименованию"" КАК НайденоПо
				|ИЗ
				|	Справочник.Партнеры КАК Партнеры
				|ГДЕ
				|	Партнеры.Наименование ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""" + СтрокаОтбора;
	
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + "	
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 51
		|	Партнеры.Ссылка,
		|	Контрагенты.ЮрФизЛицо ,
		|	ПРЕДСТАВЛЕНИЕ(Партнеры.Ссылка),
		|	Партнеры.ПометкаУдаления,
		|	Контрагенты.ИНН КАК ИНН,
		|	""НайденоПоИНН""
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
		|		ПО Контрагенты.Партнер = Партнеры.Ссылка
		|ГДЕ
		|	Контрагенты.ИНН ПОДОБНО &СтрокаВвода СПЕЦСИМВОЛ ""~""" + СтрокаОтбора;
		
		Выборка = Запрос.Выполнить().Выбрать();
		ДанныеВыбора = Новый СписокЗначений; 
		
		ИННПоКоторымНужноВыводитьПрефикс = ИННПоКоторымТребуетсяВыводПрефиксаЮрФизЛицо(Выборка);
		
		Пока Выборка.Следующий() Цикл
			
			ПрефиксЮрФизЛицо = "";
			
			Если ИспользоватьПартнеровКакКонтрагентов Тогда
			
				Если Выборка.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель
					И ИННПоКоторымНужноВыводитьПрефикс.Найти(Выборка.ИНН) <> Неопределено Тогда
					
					ПрефиксЮрФизЛицо = НСтр("ru = '(ИП)'") ;
					
				ИначеЕсли Выборка.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо 
					И ИННПоКоторымНужноВыводитьПрефикс.Найти(Выборка.ИНН) <> Неопределено Тогда
					
					ПрефиксЮрФизЛицо = НСтр("ru = '(ФЛ)'");
					
				КонецЕсли;
				
			Иначе
				
				Если ДанныеВыбора.НайтиПоЗначению(Выборка.Партнер) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
			
			КонецЕсли;
			
			Если Выборка.НайденоПо = "НайденоПоНаименованию"  Тогда
				ТекстПредставление = ПрефиксЮрФизЛицо  + " " + Выборка.Представление;
			Иначе
				ТекстПредставление =  Выборка.ИНН  + " " + ПрефиксЮрФизЛицо + " (" +Выборка.Представление + ")";
			КонецЕсли;
			
			Если Выборка.ПометкаУдаления Тогда
				СтруктураЗначение = Новый Структура("Значение,ПометкаУдаления", Выборка.Партнер, Выборка.ПометкаУдаления);
				ДанныеВыбора.Добавить(СтруктураЗначение,ТекстПредставление,, БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
			Иначе
				ДанныеВыбора.Добавить(Выборка.Партнер, ТекстПредставление);
			КонецЕсли;
		КонецЦикла;
		
		Возврат ДанныеВыбора;
	
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

// Получает данные выбора справочника "Роли контактных лиц в сделках и проектах".
// 
// Параметры:
//  Параметры - Структура - содержит:
//   * Отбор                         - Отбор - 
//   * СтрокаПоиска                  - Строка - 
// 
// Возвращаемое значение:
//  СписокЗначений - 
Функция РолиПартнеровВСделкахИПроектахДанныеВыбора(Параметры) Экспорт
	
	Если Параметры.Свойство("Клиент") Тогда

		ДанныеВыбора = Новый СписокЗначений;
		
		Если Параметры.Клиент = Параметры.Участник Тогда
			
			ДанныеВыбора = Новый СписокЗначений;
			Роль = Справочники.РолиПартнеровВСделкахИПроектах.Клиент;
			ДанныеВыбора.Добавить(Роль, НСтр("ru = 'Наименование'"));
			
		Иначе
			
			Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	РолиПартнеровВСделкахИПроектах.Ссылка,
				|	РолиПартнеровВСделкахИПроектах.Наименование
				|ИЗ
				|	Справочник.РолиПартнеровВСделкахИПроектах КАК РолиПартнеровВСделкахИПроектах
				|ГДЕ
				|	РолиПартнеровВСделкахИПроектах.Ссылка <> ЗНАЧЕНИЕ(Справочник.РолиПартнеровВСделкахИПроектах.Клиент)");
			РезультатЗапроса = Запрос.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				
				Выборка = РезультатЗапроса.Выбрать();
				Пока Выборка.Следующий() Цикл
					ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Наименование);
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Возврат ДанныеВыбора;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
