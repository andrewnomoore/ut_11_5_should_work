#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список текущих дел пользователя.
//
// Параметры:
//  ТекущиеДела - ТаблицаЗначений - таблица с колонками:
//   * Идентификатор           - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//   * ЕстьДела                - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//   * Важное                  - Булево - если Истина, дело будет выделено красным цветом.
//   * Представление           - Строка - представление дела, выводимое пользователю.
//   * Количество              - Число  - количественный показатель дела, выводится в строке заголовка дела.
//   * Форма                   - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                                        дела на панели "Текущие дела".
//   * ПараметрыФормы          - Структура - параметры, с которыми нужно открывать форму показателя.
//   * Владелец                - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                               или объект метаданных подсистема.
//   * Подсказка               - Строка - текст подсказки.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Справочник.ГосударственныеКонтракты.ФормаСписка";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	Доступность = ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь 
		ИЛИ ПравоДоступа("Редактирование", Метаданные.Справочники.ГосударственныеКонтракты);
		
	Если Не Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(*) КАК ГосударственныеКонтрактыЗакрыть
	|ИЗ
	|	Справочник.ГосударственныеКонтракты КАК ГосударственныеКонтракты
	|ГДЕ
	|	ГосударственныеКонтракты.ГодОкончанияСрокаДействия < ГОД(&ТекущаяДата)
	|	И ГосударственныеКонтракты.Состояние В (
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияГосударственныхКонтрактов.Выполняется),
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияГосударственныхКонтрактов.Готовится)
	|	)
	|	И НЕ ГосударственныеКонтракты.ПометкаУдаления";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	СписокОтбора = Новый СписокЗначений;
	СписокОтбора.Добавить(Перечисления.СостоянияГосударственныхКонтрактов.Выполняется);
	СписокОтбора.Добавить(Перечисления.СостоянияГосударственныхКонтрактов.Готовится);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Состояние", СписокОтбора);
	ПараметрыОтбора.Вставить("ПометкаУдаления", Ложь);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ГосударственныеКонтрактыЗакрыть";
	Дело.ЕстьДела       = Результат.ГосударственныеКонтрактыЗакрыть > 0;
	Дело.Представление  = НСтр("ru = 'Закрыть государственные контракты'");
	Дело.Количество     = Результат.ГосударственныеКонтрактыЗакрыть;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = Метаданные.Подсистемы.Закупки;
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ГосударственныеКонтрактыЗакрыть";
	Дело.ЕстьДела       = Результат.ГосударственныеКонтрактыЗакрыть > 0;
	Дело.Представление  = НСтр("ru = 'Закрыть государственные контракты'");
	Дело.Количество     = Результат.ГосударственныеКонтрактыЗакрыть;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = Метаданные.Подсистемы.Продажи;
	
КонецПроцедуры

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Наименование");
	Результат.Добавить("Код;Код,ЗаполнитьИдентификатор");
	Результат.Добавить("ГоловнойИсполнитель");
	Результат.Добавить("УполномоченныйБанк");
	Результат.Добавить("ГодЗаключения");
	Результат.Добавить("ГодОкончанияСрокаДействия");
	Результат.Добавить("КодГосударственногоЗаказчика");
	Результат.Добавить("КодСпособаОпределенияПоставщика");
	Результат.Добавить("ВидЦены");
	Результат.Добавить("ДополнительныеРазряды");
	Результат.Добавить("ПорядковыйНомер");
	Результат.Добавить("ДатаЗаключения");
	Результат.Добавить("НомерИГК");
	
	Возврат Результат;
	
КонецФункции

// Возвращает строковое представление кода способа определения поставщика
//
// Параметры:
//  КодСпособаОпределенияПоставщика - Число.
//
// Возвращаемое значение:
//  Строка - представление кода способа определения поставщика.
//
Функция ПредставлениеИдентификатораИнформацииОЗакупке(КодСпособаОпределенияПоставщика) Экспорт
	Представление = "";
	
	МакетПоставляемыеДанные = ПолучитьМакет("ИдентификаторыИнформацииОЗакупке").ПолучитьТекст();
	ИдентификаторыИнформацииОЗакупке = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетПоставляемыеДанные).Данные;
	
	Отбор = Новый Структура("Код", Строка(КодСпособаОпределенияПоставщика));
	НайденныеСтроки = ИдентификаторыИнформацииОЗакупке.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Представление = НайденныеСтроки[0].Наименование;
	КонецЕсли;
	
	Возврат Представление;
КонецФункции

// Возвращает таблицу администраторов доходов бюджета.
//
// Параметры:
//  Код (необязательный) - Строка - код администратора доходов бюджета.
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица с колонками Код и ПолноеНаименование.
//
Функция АдминистраторыДоходовБюджета(Код = "") Экспорт
	Макет = Справочники.ГосударственныеКонтракты.ПолучитьМакет("АдминистраторыДоходовБюджетов").ПолучитьТекст();
	Таблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет).Данные;
	
	Если ЗначениеЗаполнено(Код) Тогда
		Отбор = Новый Структура("Код", Код);
		НайденныеСтроки = Таблица.НайтиСтроки(Отбор);
		
		Возврат Таблица.Скопировать(НайденныеСтроки);
	Иначе
		Возврат Таблица;
	КонецЕсли;
КонецФункции

// Относящиеся к государственному контракту договоры.
//
// Параметры:
//    Госконтракт - СправочникСсылка.ГосударственныеКонтракты - Ссылка на госконтракт.
//
// Возвращаемое значение:
//    Массив - Договоры с контрагентами.
//
Функция ДоговорыПоГосударственномуКонтракту(Госконтракт) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт = &Ссылка
	|";
	
	Запрос.УстановитьПараметр("Ссылка", Госконтракт);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
КонецФункции

// Относящиеся к государственному контракту банковские счета.
//
// Параметры:
//    Госконтракт - СправочникСсылка.ГосударственныеКонтракты - Ссылка на госконтракт.
//
// Возвращаемое значение:
//    Массив из СправочникСсылка.БанковскиеСчетаОрганизаций.
//
Функция БанковскиеСчетаПоГосударственномуКонтракту(Госконтракт) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	БанковскиеСчетаОрганизаций.Ссылка
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.ГосударственныйКонтракт = &Ссылка
	|";
	
	Запрос.УстановитьПараметр("Ссылка", Госконтракт);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
