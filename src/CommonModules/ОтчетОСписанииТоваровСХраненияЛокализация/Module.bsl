#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	
	// Акт о списании товаров (ТОРГ-16)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьТОРГ16";
	КомандаПечати.Идентификатор = "ТОРГ16";
	КомандаПечати.Представление = НСтр("ru = 'Акт о списании товаров (ТОРГ-16)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

//++ Локализация

// Функция получает данные для формирования печатной формы ТОРГ-16.
//
// Параметры:
//	ПараметрыПечати   - Структура                                        - Дополнительные параметры печати.
//	ДокументОснование - ДокументСсылка.ОтчетОСписанииТоваровСХранения - Документ, который нужно распечатать.
//
// Возвращаемое значение:
//	Структура - структура с данными для печати формы ТОРГ-16.
//
Функция ПолучитьДанныеДляПечатнойФормыТОРГ16(ПараметрыПечати, ДокументОснование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеТоваров.Дата				КАК ДатаДокумента,
	|	СписаниеТоваров.Партнер				КАК Партнер,
	|	СписаниеТоваров.Организация			КАК Организация,
	|	СписаниеТоваров.Руководитель		КАК Руководитель,
	|	ЕСТЬNULL(СписаниеТоваров.Руководитель.Должность, """") КАК ДолжностьРуководителя,
	|	СписаниеТоваров.ГлавныйБухгалтер	КАК ГлавныйБухгалтер,
	|	ВЫБОР
	|		КОГДА СписаниеТоваров.ХозяйственнаяОперация В(
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеПринятыхТоваровНаРасходы))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ								КАК СписаниеЗаНашСчет
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения КАК СписаниеТоваров
	|
	|ГДЕ
	|	СписаниеТоваров.Ссылка = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеДокумента = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ДанныеДокумента.Следующий();
	
	ДатаДокумента     = ДанныеДокумента.ДатаДокумента;
	Организация       = ДанныеДокумента.Организация;
	Партнер           = ДанныеДокумента.Партнер;
	СписаниеЗаНашСчет = ДанныеДокумента.СписаниеЗаНашСчет;
	
	ДопКолонка             = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	ИспользуетсяДопКолонка = ЗначениеЗаполнено(ДопКолонка);
	
	СтруктураОтветственных = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Организация,
																							КонецДня(ДатаДокумента));
	
	Руководитель          = ?(ЗначениеЗаполнено(ДанныеДокумента.Руководитель),
								ДанныеДокумента.Руководитель,
								СтруктураОтветственных.Руководитель);
	ДолжностьРуководителя = ?(ЗначениеЗаполнено(ДанныеДокумента.Руководитель),
								ДанныеДокумента.ДолжностьРуководителя,
								СтруктураОтветственных.РуководительДолжность);
	ГлавныйБухгалтер      = ?(ЗначениеЗаполнено(ДанныеДокумента.ГлавныйБухгалтер),
								ДанныеДокумента.ГлавныйБухгалтер,
								СтруктураОтветственных.ГлавныйБухгалтер);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаЦен",               ДатаДокумента);
	Запрос.УстановитьПараметр("ТекущийДокумент",       ДокументОснование);
	Запрос.УстановитьПараметр("Руководитель",          Руководитель);
	Запрос.УстановитьПараметр("ДолжностьРуководителя", ДолжностьРуководителя);
	Запрос.УстановитьПараметр("ГлавныйБухгалтер",      ГлавныйБухгалтер);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СписаниеТоваров.Ссылка      КАК Ссылка,
	|	НЕОПРЕДЕЛЕНО                КАК ДокументОснование,
	|	ЕСТЬNULL(СписаниеТоваров.ИсправляемыйДокумент.Номер, СписаниеТоваров.Номер) КАК Номер,
	|	ЕСТЬNULL(СписаниеТоваров.ИсправляемыйДокумент.Дата, СписаниеТоваров.Дата) КАК ДатаДокумента,
	|	СписаниеТоваров.Контрагент  КАК Поставщик,
	|	СписаниеТоваров.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Организация.НаименованиеСокращенное) КАК ОрганизацияПредставление,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Организация.КодПоОКПО)               КАК ОрганизацияПоОКПО,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Организация.Префикс)                 КАК Префикс,
	|	СписаниеТоваров.Подразделение                КАК Подразделение,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Подразделение) КАК ПодразделениеПредставление,
	|	НЕОПРЕДЕЛЕНО                КАК Кладовщик,
	|	НЕОПРЕДЕЛЕНО                КАК ДолжностьКладовщика,
	|	СписаниеТоваров.Менеджер.ФизическоеЛицо КАК Ответственный,
	|	&Руководитель               КАК Руководитель,
	|	&ДолжностьРуководителя      КАК ДолжностьРуководителя,
	|	&ГлавныйБухгалтер           КАК ГлавныйБухгалтер,
	|	""""                        КАК ОснованиеДата,
	|	""""                        КАК НомерОснования
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения КАК СписаниеТоваров
	|
	|ГДЕ
	|	СписаниеТоваров.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1";
	
	Если СписаниеЗаНашСчет Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ТоварыСписания.НомерСтроки                                  КАК НомерСтроки,
		|	&ТекстЗапросаТоварКод                                       КАК ТоварКод,
		|	ТоварыСписания.Номенклатура                                 КАК Номенклатура,
		|	ТоварыСписания.Номенклатура.НаименованиеПолное              КАК НоменклатураПредставление,
		|	ТоварыСписания.Характеристика.НаименованиеПолное            КАК ХарактеристикаПредставление,
		|	ТоварыСписания.Номенклатура.ЕдиницаИзмерения.Код            КАК ЕдиницаИзмеренияКодПоОКЕИ,
		|	ПРЕДСТАВЛЕНИЕ(ТоварыСписания.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	&ТекстЗапросаВес                                            КАК МассаОдногоМеста,
		|	ТоварыСписания.Количество                                   КАК КоличествоМест,
		|	ВЫБОР
		|		КОГДА &ТекстЗапросаКоэффициентУпаковки <> 0
		|			ТОГДА ТоварыСписания.Цена / &ТекстЗапросаКоэффициентУпаковки
		|		ИНАЧЕ ТоварыСписания.Цена
		|	КОНЕЦ                                                       КАК Цена
		|ИЗ
		|	Документ.ОтчетОСписанииТоваровСХранения.Товары КАК ТоварыСписания
		|ГДЕ
		|	ТоварыСписания.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТоварыСписания.НомерСтроки";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
									"&ТекстЗапросаКоэффициентУпаковки",
									Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ТоварыСписания.Упаковка",
																											"ТоварыСписания.Номенклатура"));
		
	Иначе
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	Запасы.ВидЦены                КАК ВидЦены,
		|	КлючиАналитики.Номенклатура   КАК Номенклатура,
		|	КлючиАналитики.Характеристика КАК Характеристика
		|
		|ПОМЕСТИТЬ ЗапасыСписания
		|ИЗ
		|	Документ.ОтчетОСписанииТоваровСХранения.ВидыЗапасов КАК ТоварыСписания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК Запасы
		|		ПО ТоварыСписания.ВидЗапасов = Запасы.Ссылка
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитики
		|		ПО ТоварыСписания.АналитикаУчетаНоменклатуры = КлючиАналитики.Ссылка
		|
		|ГДЕ
		|	ТоварыСписания.Ссылка = &ТекущийДокумент
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////// 2
		|ВЫБРАТЬ
		|	ЦеныНоменклатуры.Номенклатура   КАК Номенклатура,
		|	ЦеныНоменклатуры.Характеристика КАК Характеристика,
		|	ЦеныНоменклатуры.Упаковка       КАК Упаковка,
		|	ЦеныНоменклатуры.Цена           КАК Цена
		|
		|ПОМЕСТИТЬ ЦеныНоменклатуры
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(КОНЕЦПЕРИОДА(&ДатаЦен, ДЕНЬ),
		|		(Партнер, ВидЦеныПоставщика, Номенклатура, Характеристика) В
		|			(ВЫБРАТЬ
		|				&Партнер,
		|				ЗапасыСписания.ВидЦены        КАК ВидЦены,
		|				ЗапасыСписания.Номенклатура   КАК Номенклатура,
		|				ЗапасыСписания.Характеристика КАК Характеристика
		|			ИЗ
		|				ЗапасыСписания КАК ЗапасыСписания)) КАК ЦеныНоменклатуры
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////// 3
		|ВЫБРАТЬ
		|	ТоварыСписания.НомерСтроки                                  КАК НомерСтроки,
		|	&ТекстЗапросаТоварКод                                       КАК ТоварКод,
		|	ТоварыСписания.Номенклатура                                 КАК Номенклатура,
		|	ТоварыСписания.Номенклатура.НаименованиеПолное              КАК НоменклатураПредставление,
		|	ТоварыСписания.Характеристика.НаименованиеПолное            КАК ХарактеристикаПредставление,
		|	ТоварыСписания.Номенклатура.ЕдиницаИзмерения.Код            КАК ЕдиницаИзмеренияКодПоОКЕИ,
		|	ПРЕДСТАВЛЕНИЕ(ТоварыСписания.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	&ТекстЗапросаВес                                            КАК МассаОдногоМеста,
		|	ТоварыСписания.Количество                                   КАК КоличествоМест,
		|	ВЫБОР
		|		КОГДА НЕ &ТекстЗапросаКоэффициентУпаковки ЕСТЬ NULL
		|				И &ТекстЗапросаКоэффициентУпаковки <> 0
		|			ТОГДА ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0) / &ТекстЗапросаКоэффициентУпаковки
		|		ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0)
		|	КОНЕЦ                                                       КАК Цена
		|ИЗ
		|	Документ.ОтчетОСписанииТоваровСХранения.Товары КАК ТоварыСписания
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|		ПО ТоварыСписания.Номенклатура      = ЦеныНоменклатуры.Номенклатура
		|			И ТоварыСписания.Характеристика = ЦеныНоменклатуры.Характеристика
		|ГДЕ
		|	ТоварыСписания.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТоварыСписания.НомерСтроки";
		
		Запрос.УстановитьПараметр("Партнер", Партнер);
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
									"&ТекстЗапросаКоэффициентУпаковки",
									Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ЦеныНоменклатуры.Упаковка",
																											"ЦеныНоменклатуры.Номенклатура"));
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВес",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
									"ТоварыСписания.Номенклатура.ЕдиницаИзмерения",
									"ТоварыСписания.Номенклатура"));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
									"&ТекстЗапросаТоварКод",
									"ТоварыСписания.Номенклатура." + ?(ИспользуетсяДопКолонка, ДопКолонка, "Код"));
	
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	РезультатПоШапке    = РезультатЗапроса[0];
	РезультатПоДатам    = РезультатЗапроса[РезультатЗапроса.Количество() - 1];
	РезультатПоТоварам  = РезультатЗапроса[РезультатЗапроса.Количество() - 1];
	РезультатКурсыВалют = ТаблицаКурсовВалют(ДокументОснование);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("РезультатПоШапке",    РезультатПоШапке);
	СтруктураВозврата.Вставить("РезультатПоДатам",    РезультатПоДатам);
	СтруктураВозврата.Вставить("РезультатПоТоварам",  РезультатПоТоварам);
	СтруктураВозврата.Вставить("РезультатКурсыВалют", РезультатКурсыВалют);
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Функция формирует таблицу курсов валют по дням.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ОтчетОСписанииТоваровСХранения - документ, на дату которого нужно получить
//																			курсы валют.
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица значений, содержащая информацию о курсах валют по дням.
//
Функция ТаблицаКурсовВалют(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыСписания.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ТоварыСписания.Ссылка.ХозяйственнаяОперация В(
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеПринятыхТоваровНаРасходы))
	|			ТОГДА ТоварыСписания.Ссылка.Валюта
	|		ИНАЧЕ ЕСТЬNULL(МАКСИМУМ(ВидыЦен.Валюта), ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))
	|	КОНЕЦ                 КАК Валюта
	|ПОМЕСТИТЬ ВалютыСписанияТоваров
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения.ВидыЗапасов КАК ТоварыСписания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК Запасы
	|		ПО ТоварыСписания.ВидЗапасов = Запасы.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЦенПоставщиков КАК ВидыЦен
	|		ПО Запасы.ВидЦены = ВидыЦен.Ссылка
	|
	|ГДЕ
	|	ТоварыСписания.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыСписания.Ссылка
	|
	|;
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписаниеТоваров.Ссылка                    КАК Ссылка,
	|	НАЧАЛОПЕРИОДА(СписаниеТоваров.Дата, ДЕНЬ) КАК Дата,
	|	ЕСТЬNULL(ВалютыСписания.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)) КАК Валюта,
	|	СписаниеТоваров.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения КАК СписаниеТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВалютыСписанияТоваров КАК ВалютыСписания
	|		ПО СписаниеТоваров.Ссылка = ВалютыСписания.Ссылка
	|ГДЕ
	|	СписаниеТоваров.Ссылка = &ДокументОснование
	|	И ЕСТЬNULL(ВалютыСписания.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)) <> СписаниеТоваров.Организация.ВалютаРегламентированногоУчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюта,
	|	Дата";
	
	Запрос.УстановитьПараметр("ДокументОснование",              ДокументОснование);
	
	ТаблицаКурсовВалют = Новый ТаблицаЗначений;
	ТаблицаКурсовВалют.Колонки.Добавить("Ссылка",    Новый ОписаниеТипов(
															"ДокументСсылка.ОтчетОСписанииТоваровСХранения"));
	ТаблицаКурсовВалют.Колонки.Добавить("Валюта",    Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	ТаблицаКурсовВалют.Колонки.Добавить("Дата",      Новый ОписаниеТипов("Дата"));
	ТаблицаКурсовВалют.Колонки.Добавить("КурсЧислитель", Новый ОписаниеТипов("Число"));
	ТаблицаКурсовВалют.Колонки.Добавить("КурсЗнаменатель", Новый ОписаниеТипов("Число"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	НоваяСтрока = ТаблицаКурсовВалют.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	
	КурсыВалюты = РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(Выборка.Валюта, Выборка.Дата, Выборка.ВалютаРегламентированногоУчета);
	
	НоваяСтрока.КурсЧислитель = КурсыВалюты.КурсЧислитель;
	НоваяСтрока.КурсЗнаменатель = КурсыВалюты.КурсЗнаменатель;
	
	Возврат ТаблицаКурсовВалют;
	
КонецФункции

//-- Локализация
#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

//++ Локализация


//-- Локализация

#КонецОбласти

//++ Локализация


//-- Локализация

#КонецОбласти
