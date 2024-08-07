
#Область ПрограммныйИнтерфейс

// Возвращает структуру с настройками учетной записи.
//
// Параметры:
//   УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись подключения к сервису.
// 
// Возвращаемое значение:
//   Структура - настройки учетной записи:
//     * ВидМаркетплейса                           - ПеречислениеСсылка.ВидыМаркетплейсов - вид маркетплейса;
//     * Организация                               - СправочникСсылка.Организации - организация;
//     * ИдентификаторКлиента                      - Строка - идентификатор клиента;
//     * ИсточникКатегории                         - ПеречислениеСсылка.ИсточникиКатегорийДляМаркетплейса - источник категории;
//     * ВалютаУчета                               - СправочникСсылка.Валюты - валюта учета;
//     * ВидыЦен                                   - Структура - используемые виды цен, где ключ - имя настройки, значение - вид цены;
//     * СхемаРаботы                               - ПеречислениеСсылка.СхемыРаботыТорговыхПлощадок - схема работы;
//     * Партнер                                   - СправочникСсылка.Партнеры - партнер;
//     * Контрагент                                - СправочникСсылка.Контрагенты - контрагент;
//     * Соглашение                                - СправочникСсылка.СоглашенияСКлиентами - соглашение;
//     * ДоговорПродажиЧерезСкладыТорговойПлощадки - СправочникСсылка.ДоговорыКонтрагентов - договор продажи через склады торговой площадки;
//     * ДоговорПродажиЧерезСкладыСобственные      - СправочникСсылка.ДоговорыКонтрагентов - договор продажи через склады собственные;
//     * ПродажиРазделяютсяПоДоговорам             - Булево - признак разделения продаж со складов торговой площадки и собственных складов;
//     * ДополнительныеНастройки                   - Соответствие Из КлючИЗначение - дополнительные настройки.
//
Функция НастройкиУчетнойЗаписи(УчетнаяЗаписьМаркетплейса) Экспорт

	Возврат Справочники.УчетныеЗаписиМаркетплейсов.НастройкиУчетнойЗаписи(УчетнаяЗаписьМаркетплейса);

КонецФункции

// Возвращает список действующих учетных записей маркетплейсов.
//
// Возвращаемое значение:
//   СписокЗначений Из СправочникСсылка.УчетныеЗаписиМаркетплейсов - не помеченные на удаление учетные записи Ozon.
//
Функция СписокНастроекПодключенияКСервису() Экспорт
	
	Возврат ИнтеграцияСМаркетплейсомOzonСервер.СписокНастроекПодключенияКСервису();
	
КонецФункции

// Изменяет признак контроля обновления данных торговой площадки.
//
// Параметры:
//   УчетнаяЗаписьМаркетплейса         - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись подключения к сервису.
//	 НеОбновлятьДанныеТорговойПлощадки - Булево - Истина, если необходимо запретить обновление данных торговой площадки.
// 
// Возвращаемое значение:
//   Булево - результат выполнения действия.
//
Функция ИзменитьКонтрольОбновленияДанныхТорговойПлощадки(УчетнаяЗаписьМаркетплейса, НеОбновлятьДанныеТорговойПлощадки) Экспорт
	
	Возврат Справочники.УчетныеЗаписиМаркетплейсов.ИзменитьКонтрольОбновленияДанныхТорговойПлощадки(УчетнаяЗаписьМаркетплейса, НеОбновлятьДанныеТорговойПлощадки);
	
КонецФункции

// Определяет признак контроля обновления данных торговой площадки.
//
// Параметры:
//   УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись подключения к сервису.
// 
// Возвращаемое значение:
//   Булево - Истина, если обновление данных торговой площадки разрешено;
//            Ложь - обновление данных запрещено.
//
Функция ОбновленияДанныхТорговойПлощадкиРазрешено(УчетнаяЗаписьМаркетплейса) Экспорт
	
	Возврат Справочники.УчетныеЗаписиМаркетплейсов.ОбновленияДанныхТорговойПлощадкиРазрешено(УчетнаяЗаписьМаркетплейса);
	
КонецФункции

// Определяет текущую сопоставленную категорию для указанной номенклатуры.
//
// Параметры:                                                                   
//   УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись подключения к сервису.
//   Номенклатура              - СправочникСсылка.Номенклатура - номенклатура, для которой требуется найти категорию.
//   ИдентификаторКатегории    - Строка - искомый идентификатор категории маркетплейса;
//   ИсточникКатегории         - ПеречислениеСсылка.ИсточникиКатегорийДляМаркетплейса - источник категории из настроек сопоставления.
//
// Возвращаемое значение:
//   Структура - результат поиска категории:
//     * ИсточникКатегории      - СправочникСсылка.ВидыНоменклатуры, СправочникСсылка.Номенклатура, СправочникСсылка.ТоварныеКатегории -
//                                  источник категории 1С;
//                              - Неопределено - источник категории не найден;
//     * Категория              - СправочникСсылка.ВидыНоменклатуры, СправочникСсылка.Номенклатура, СправочникСсылка.ТоварныеКатегории -
//                                  подобранная категория 1С;
//                              - Неопределено - категория не найдена;
//     * ИдентификаторКатегории - Строка - идентификатор сопоставленной категории маркетплейса;
//     * НаименованиеКатегории  - Строка - наименование сопоставленной категории маркетплейса.
//
Функция ОпределитьТекущуюСопоставленнуюКатегориюМаркетплейсаПоНоменклатуре(УчетнаяЗаписьМаркетплейса, Номенклатура, ИдентификаторКатегории, ИсточникКатегории) Экспорт
	
	Возврат ИнтеграцияСМаркетплейсомOzonСервер.ОпределитьТекущуюСопоставленнуюКатегориюМаркетплейсаПоНоменклатуре(УчетнаяЗаписьМаркетплейса, Номенклатура, ИдентификаторКатегории, ИсточникКатегории);

КонецФункции

// Определяет текущую сопоставленную категорию для указанного идентификатора категории маркетплейса.
//
// Параметры:                                                                   
//   УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись подключения к сервису.
//   ИсточникКатегории         - СправочникСсылка.ВидыНоменклатуры, СправочникСсылка.Номенклатура, СправочникСсылка.ТоварныеКатегории -
//                                  искомый источник категории 1С.
//   ИдентификаторКатегории    - Строка - идентификатор категория маркетплейса, для которого требуется найти сопоставление.
//
// Возвращаемое значение:
//   - Неопределено             - сопоставление категорий не найдено.
//   - Структура                - результат поиска категории:
//       * Категория              - Неопределено
//                                - СправочникСсылка.ВидыНоменклатуры
//                                - СправочникСсылка.Номенклатура
//                                - СправочникСсылка.ТоварныеКатегории - подобранная категория 1С;
//       * ИдентификаторКатегории - Строка - идентификатор сопоставленной категории маркетплейса;
//       * НаименованиеКатегории  - Строка - наименование сопоставленной категории маркетплейса.
//
Функция ОпределитьТекущуюСопоставленнуюКатегориюМаркетплейсаПоИдентификатору(УчетнаяЗаписьМаркетплейса, ИсточникКатегории, ИдентификаторКатегории) Экспорт
	
	Возврат ИнтеграцияСМаркетплейсомOzonСервер.ОпределитьТекущуюСопоставленнуюКатегориюМаркетплейсаПоИдентификатору(УчетнаяЗаписьМаркетплейса, ИсточникКатегории, ИдентификаторКатегории);

КонецФункции

// Определяет категорию-источник, для которой выполнены настройки сопоставления.
//
// Параметры:
//   УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись подключения к сервису.
//   Категория1С               - СправочникСсылка.ВидыНоменклатуры
//                             - СправочникСсылка.Номенклатура
//                             - СправочникСсылка.ТоварныеКатегории - категория, для которой нужно получить категорию-источник.
//   БлижайшийРодитель         - Булево - признак определения только по ближайшему родителю (Истина) или с учетом 
//                                 текущей категории (Ложь).
//
// Возвращаемое значение:
//   Структура - данные об источнике категории:
//     * ИсточникКатегорииМаркетплейса               - СправочникСсылка.ВидыНоменклатуры
//                                                   - СправочникСсылка.Номенклатура
//                                                   - СправочникСсылка.ТоварныеКатегории - источник категории;
//                                                   - Неопределено - источник категории не найден;
//     * ИдентификаторИсточникаКатегорииМаркетплейса - Строка - идентификатор источника категории;
//     * НаименованиеИсточникаКатегорииМаркетплейса  - Строка - наименование источника категории.
//
Функция ПолучитьТекущийИсточникКатегорииМаркетплейса(УчетнаяЗаписьМаркетплейса, Категория1С, БлижайшийРодитель = Истина) Экспорт
	
	Возврат ИнтеграцияСМаркетплейсомOzonСервер.ПолучитьТекущийИсточникКатегорииМаркетплейса(УчетнаяЗаписьМаркетплейса, Категория1С, БлижайшийРодитель);

КонецФункции

// Определяет результат выполнения фонового задания.
// Если результат является структурой, дополнительно добавляет свойство КодОшибки (если оно отсутствует).
//
// Параметры:
//   АдресРезультата - Строка - адрес временного хранилища, в которое помещен результат работы фоновой процедуры.
// 
// Возвращаемое значение:
//   Произвольный - результат выполнения фонового задания.
//
Функция ПолучитьРезультатВыполненияФоновогоЗадания(АдресРезультата) Экспорт
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если ТипЗнч(Результат) = Тип("Структура")
			И Не Результат.Свойство("КодОшибки") Тогда
		Результат.Вставить("КодОшибки", "");
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Подготавливает данные о доступных хозяйственных операциях.
//
// Параметры:
//   ПостфиксЗаголовкаФормы - Строка - значение, однозначно идентифицирующее владельца формы использующей данные о 
//                              доступных хозяйственных операциях.
// 
// Возвращаемое значение:
//   Структура - используемые хозяйственные операции:
//     * Поставки - Соответствие Из КлючИЗначение - описание хозяйственных операций раздела "Поставки":
//       ** Ключ  - ПеречислениеСсылка.ХозяйственныеОперации - используемая хозяйственная операция;
//       ** Значение - Соответствие Из КлючИЗначение - описание документов:
//          *** Ключ     - Строка - полное имя документа, для которого используется текущая хозяйственная операция;
//          *** Значение - Строка - заголовок формы при выборе текущей хозяйственной операции и вида документа.
//     * Продажи  - Соответствие Из КлючИЗначение - описание хозяйственных операций раздела "Продажи":
//       ** Ключ  - ПеречислениеСсылка.ХозяйственныеОперации - используемая хозяйственная операция;
//       ** Значение - Соответствие Из КлючИЗначение - описание документов:
//          *** Ключ     - Строка - полное имя документа, для которого используется текущая хозяйственная операция;
//          *** Значение - Строка - заголовок формы при выборе текущей хозяйственной операции и вида документа.
//
Функция ИспользуемыеХозяйственныеОперации(ПостфиксЗаголовкаФормы = "все") Экспорт

	ИспользуемыеХозОперации = Новый Структура;

	// Поставки
	ХозОперации = Новый Соответствие;
	ШаблонЗаголовка = НСтр("ru = 'Документы поставок <%1>'");

	// Хозяйственная операция ПередачаНаКомиссию
	ДокументыХозОперации = Новый Соответствие;
	ДокументыХозОперации.Вставить(Метаданные.Документы.АктОРасхожденияхПослеОтгрузки.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка + " " + НСтр("ru = '(расхождения)'"), ПостфиксЗаголовкаФормы));
	ДокументыХозОперации.Вставить(Метаданные.Документы.ПередачаТоваровХранителю.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		 ШаблонЗаголовка + " " + НСтр("ru = '(передачи на комиссию)'"), ПостфиксЗаголовкаФормы));
	ХозОперации.Вставить(Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию, ДокументыХозОперации);

	// Хозяйственная операция ВозвратОтКомиссионера
	ДокументыХозОперации = Новый Соответствие;
	ДокументыХозОперации.Вставить(Метаданные.Документы.ПоступлениеТоваровОтХранителя.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка + " " + НСтр("ru = '(возвраты от комиссионера)'"), ПостфиксЗаголовкаФормы));
	ХозОперации.Вставить(Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера, ДокументыХозОперации);

	// Хозяйственная операция СписаниеНедостачЗаСчетКомитента
	ДокументыХозОперации = Новый Соответствие;
	ДокументыХозОперации.Вставить(Метаданные.Документы.ОтчетОСписанииТоваровУХранителя.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		 ШаблонЗаголовка + " " + НСтр("ru = '(списания у комиссионера)'"), ПостфиксЗаголовкаФормы));
	ХозОперации.Вставить(Перечисления.ХозяйственныеОперации.СписаниеНедостачЗаСчетКомитента, ДокументыХозОперации);

	ИспользуемыеХозОперации.Вставить("Поставки", ХозОперации);

	// Продажи
	ХозОперации = Новый Соответствие;
	ШаблонЗаголовка = НСтр("ru = 'Документы продаж <%1>'");

	// Хозяйственная операция ВозвратТоваровЧерезКомиссионера
	ДокументыХозОперации = Новый Соответствие;
	ДокументыХозОперации.Вставить(Метаданные.Документы.ВозвратТоваровОтКлиента.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонЗаголовка + " " + НСтр("ru = '(накладные)'"), ПостфиксЗаголовкаФормы));
	ХозОперации.Вставить(Перечисления.ХозяйственныеОперации.ВозвратТоваровЧерезКомиссионера, ДокументыХозОперации);

	// Хозяйственная операция ВозвратОтКомиссионера
	ДокументыХозОперации = Новый Соответствие;
	ДокументыХозОперации.Вставить(Метаданные.Документы.ПоступлениеТоваровОтХранителя.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка + " " + НСтр("ru = '(возвраты от комиссионера)'"), ПостфиксЗаголовкаФормы));
	ХозОперации.Вставить(Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера, ДокументыХозОперации);

	// Хозяйственная операция РеализацияЧерезКомиссионера
	ДокументыХозОперации = Новый Соответствие;
	ДокументыХозОперации.Вставить(Метаданные.Документы.КорректировкаРеализации.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка + " " + НСтр("ru = '(корректировки)'"), ПостфиксЗаголовкаФормы));
	ДокументыХозОперации.Вставить(Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка + " " + НСтр("ru = '(накладные)'"), ПостфиксЗаголовкаФормы));
	ДокументыХозОперации.Вставить(Метаданные.Документы.ОтчетКомиссионера.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонЗаголовка + " " + НСтр("ru = '(отчеты комиссионера)'"), ПостфиксЗаголовкаФормы));
	ХозОперации.Вставить(Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера, ДокументыХозОперации);

	// Хозяйственная операция РеализацияЧерезКомиссионераБезПереходаПраваСобственности
	ДокументыХозОперации = Новый Соответствие;
	ДокументыХозОперации.Вставить(Метаданные.Документы.КорректировкаРеализации.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка + " " + НСтр("ru = '(корректировки)'"), ПостфиксЗаголовкаФормы));
	ДокументыХозОперации.Вставить(Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя(),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка + " " + НСтр("ru = '(накладные)'"), ПостфиксЗаголовкаФормы));
	ХозОперации.Вставить(Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности,
		ДокументыХозОперации);

	ИспользуемыеХозОперации.Вставить("Продажи", ХозОперации);

	Возврат ИспользуемыеХозОперации;

КонецФункции

// Возвращает соответствие атрибутов реквизитам 1С, заданным по умолчанию.
//
// Возвращаемое значение:
//   См. ИнтеграцияСМаркетплейсомOzonСервер.ПутьКРеквизитам1СПоУмолчанию.
//
Функция ПутьКРеквизитам1СПоУмолчанию() Экспорт
	
	Возврат ИнтеграцияСМаркетплейсомOzonСервер.ПутьКРеквизитам1СПоУмолчанию();
	
КонецФункции

#КонецОбласти
