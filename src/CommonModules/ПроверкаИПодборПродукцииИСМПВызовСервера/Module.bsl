#Область СлужебныйПрограммныйИнтерфейс

Функция ВозобновитьПроверкуПоДокументу(ДокументСсылка, ВидМаркируемойПродукции, Сценарий) Экспорт
	
	Возврат РегистрыСведений.СтатусыПроверкиИПодбораДокументовИС.ОтразитьВозобновлениеПроверкиДокумента(
		ДокументСсылка, ВидМаркируемойПродукции, Сценарий);
	
КонецФункции

#Область РасчетХешСумм
	
// Получает данные по хеш суммам для переданных упаковок. Возвращает таблицу с идентификаторами строк, требующих перемаркировки
//
// Параметры:
//	СтрокиДерева - Массив - содержит структуры с данными упаковок, для которых требуется получить хеш сумму:
//		* ИдентификаторСтроки - Число - идентификатор строки дерева маркируемой продукции
//		* ТипУпаковки - ПеречислениеСсылка.ТипыУпаковок - тип упаковки строки дерева маркируемой продукции
//		* СтатусПроверки - ПеречислениеСсылка.СтатусыПроверкиИПодбораИС - статус проверки строки дерева маркируемой продукции
//		* Штрихкод - Строка - значение штрихкода строки дерева маркируемой продукции
//		* ХешСумма - Строка - рассчитываемая хешсумма строки дерева маркируемой продукции
//		* ПодчиненныеСтроки - Массив - дочерние строки строки дерева маркируемой продукции
//	ПараметрыСканирования - См. ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования
//	
// Возвращаемое значение:
//	Массив Из Структура - содержит структуры с данными строк, для которых требуется перемаркировка
//		* ИдентификаторВДереве - Число - идентификатор строки дерева маркируемой продукции
//		* ТребуетсяПеремаркировка - Булево - признак необходимости перемаркировки
//
Функция ПересчитатьХешСуммыВсехУпаковок(СтрокиДерева, ПараметрыСканирования = Неопределено) Экспорт
	
	ТаблицаХешСумм = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки)
			Или СтрокаДерева.ТипУпаковки = ПроверкаИПодборПродукцииИСМПКлиентСервер.ТипУпаковкиГрупповыеУпаковкиБезКоробки() Тогда
			
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(
				СтрокаДерева, ТаблицаХешСумм, Истина,,, "КоличествоПодчиненныхПотребительскихУпаковок");
			
		ИначеЕсли СтрокаДерева.ТипУпаковки = Перечисления.ПрочиеЗоныПересчетаПродукцииИСМП.ОбъемноСортовойУчет Тогда
			
			Если ТипЗнч(СтрокаДерева) = Тип("ДанныеФормыЭлементДерева") Тогда
				ПодчиненныеСтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
			Иначе
				ПодчиненныеСтрокиДерева = СтрокаДерева.Строки;
			КонецЕсли;
			
			Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтрокиДерева Цикл
				
				Если ПодчиненнаяСтрока.ТипУпаковки = Перечисления.ПрочиеЗоныПересчетаПродукцииИСМП.ГруппировкаОбъемноСортовогоУчетаПоGTIN Тогда
					ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(
						ПодчиненнаяСтрока, ТаблицаХешСумм, Истина,,, "КоличествоПодчиненныхПотребительскихУпаковок");
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ШтрихкодИДанныеУпаковки = Неопределено;
	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИС.ТаблицаПеремаркировки(ТаблицаХешСумм, ШтрихкодИДанныеУпаковки);
	
	СоответствиеСтрок = Неопределено;
	
	// Обход ошибки расчета хеш суммы без учета поля ХешСуммыНормализации
	Для Каждого СтрокаПеремаркировки Из ТаблицаПеремаркировки Цикл
		
		Если СтрокаПеремаркировки.ТребуетсяПеремаркировка Тогда
			
			Если СоответствиеСтрок = Неопределено Тогда
				СоответствиеСтрок = Новый Соответствие;
				СоответствиеСтрокДерева(СтрокиДерева, СоответствиеСтрок);
			КонецЕсли;
			
			ТаблицаХешСуммБезУчетаХешСуммыНормализации = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
			СтрокаДерева = СоответствиеСтрок[СтрокаПеремаркировки.ИдентификаторВДереве];
			Если СтрокаДерева = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСуммБезУчетаХешСуммыНормализации, Истина,, Ложь);
			
			Для Каждого СтрокаХешСуммы Из ТаблицаХешСуммБезУчетаХешСуммыНормализации Цикл
				
				ДанныеУпаковки = ШтрихкодИДанныеУпаковки[СтрокаХешСуммы.Штрихкод];
				Если ДанныеУпаковки = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				Если СтрокаХешСуммы.ХешСумма = ДанныеУпаковки.ХешСумма
					И ПустаяСтрока(СтрокаХешСуммы.ХешСумма) Тогда
					СтрокаПеремаркировки.ТребуетсяПеремаркировка = (СтрокаХешСуммы.СодержимоеОтсутствует
						И (ДанныеУпаковки.Количество <> 0 Или ДанныеУпаковки.КоличествоПотребительскихУпаковок <> 0));
				Иначе
					СтрокаПеремаркировки.ТребуетсяПеремаркировка = (СтрокаХешСуммы.ХешСумма <> ДанныеУпаковки.ХешСумма);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Форма = Новый Структура;
	Форма.Вставить("ПараметрыСканирования",        ПараметрыСканирования);
	Форма.Вставить("ДеревоМаркированнойПродукции", СтрокиДерева);
	
	ПроверкаИПодборПродукцииИС.ОбработататьТаблицуПеремаркировкиСУчетомДетализации(Форма, ТаблицаПеремаркировки, ШтрихкодИДанныеУпаковки);
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаПеремаркировки);
	
КонецФункции

#КонецОбласти

Процедура СохранитьПолныйКодМаркировкиВПулПриСканированииСуществующего(ДанныеШтрихкода, ПараметрыСканирования) Экспорт
	
	ДанныеШтрихкодаПолные = ШтрихкодированиеОбщегоНазначенияИС.ИнициализироватьДанныеШтрихкода(ПараметрыСканирования);
	ДанныеШтрихкодаПолные.Штрихкод       = ДанныеШтрихкода.Штрихкод;
	ДанныеШтрихкодаПолные.ШтрихкодBase64 = ДанныеШтрихкода.ПолныйКодМаркировки;
	
	Если ДанныеШтрихкода.Свойство("ДанныеРазбора") Тогда
		ЗаполнитьЗначенияСвойств(ДанныеШтрихкодаПолные, ДанныеШтрихкода.ДанныеРазбора);
		ЗаполнитьЗначенияСвойств(ДанныеШтрихкодаПолные, ДанныеШтрихкода.ДанныеРазбора.СоставКодаМаркировки);
	КонецЕсли;
	
	РегистрыСведений.ПулКодовМаркировкиСУЗ.ЗаписатьДанныеКодаМаркировки(
		ДанныеШтрихкодаПолные,
		ПараметрыСканирования);
	
КонецПроцедуры

Функция КомплектующиеНаборов(НоменклатураНабора, ХарактеристикаНабора, GTIN) Экспорт
	
	ВозвращаемоеЗначение = Новый Массив;
	
	ЭлементДанных = Новый Структура;
	ЭлементДанных.Вставить("НомерСтроки",        1);
	ЭлементДанных.Вставить("Номенклатура",       НоменклатураНабора);
	ЭлементДанных.Вставить("Характеристика",     ХарактеристикаНабора);
	ЭлементДанных.Вставить("GTIN",               GTIN);
	ЭлементДанных.Вставить("Упаковка",           Неопределено);
	ЭлементДанных.Вставить("КоличествоУпаковок", 1);
	ЭлементДанных.Вставить("Количество",         1);
	
	Наборы = Новый Массив;
	Наборы.Добавить(ЭлементДанных);
	
	КомплектующиеНаборов = ИнтеграцияИСМП.КомплектующиеНаборов(Наборы);
	
	Для Каждого ЭлементНабора Из КомплектующиеНаборов Цикл
		
		ЭлементДанных = Новый Структура;
		ЭлементДанных.Вставить("Номенклатура",   ЭлементНабора.Номенклатура);
		ЭлементДанных.Вставить("Характеристика", ЭлементНабора.Характеристика);
		ЭлементДанных.Вставить("Количество",     ЭлементНабора.Количество);
		
		ВозвращаемоеЗначение.Добавить(ЭлементДанных);
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ВесПоGTIN(СписокGTIN, ПараметрыСканирования) Экспорт
	
	Если СписокGTIN.Количество() = 0 Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	
	ШтрихкодEAN = Новый Массив;
	
	GTINEAN = Новый Соответствие;
	EANGTIN = Новый Соответствие;
	Для Каждого GTIN Из СписокGTIN Цикл
		Если GTINEAN[GTIN] = Неопределено Тогда
			EAN = РазборКодаМаркировкиИССлужебныйКлиентСервер.ШтрихкодEANИзGTIN(GTIN);
			ШтрихкодEAN.Добавить(EAN);
			GTINEAN[GTIN] = EAN;
			EANGTIN[EAN]  = GTIN;
		КонецЕсли;
	КонецЦикла;
	
	ДанныеПоШтрихкодамEAN = ШтрихкодированиеОбщегоНазначенияИС.ДанныеПоШтрихкодамEAN(ШтрихкодEAN, ПараметрыСканирования, GTINEAN);
	
	Результат = Новый Соответствие;
	
	Для Каждого СтрокаТЧ Из ДанныеПоШтрихкодамEAN Цикл
		Если СтрокаТЧ.Количество > 0 Тогда
			Результат.Вставить(EANGTIN[СтрокаТЧ.ШтрихкодEAN], СтрокаТЧ.Коэффициент);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеНоменклатуры(Номенклатура) Экспорт
	Возврат ИнтеграцияИСМП.ДанныеНоменклатуры(Номенклатура);
КонецФункции

Функция КоличествоПотребительскихУпаковокПоGTIN(ДанныеДляРасчетаПоGTIN, ВидМаркируемойПродукции, ПараметрыСканирования) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ТребуетсяОбновлениеКлючаСессии",          Ложь);
	ВозвращаемоеЗначение.Вставить("КоличествоПотребительскихУпаковокПоGTIN", Неопределено);
	
	СписокДляПолученияВеса = Новый Массив;
	СписокДляПолученияИзСервиса = Новый Массив;
	Номенклатура = Новый Массив;
	
	Для Каждого GTIN Из ДанныеДляРасчетаПоGTIN Цикл
		Если GTIN.Значение.ТребуетВзвешивания Тогда
			СтруктураДляЗапроса = Новый Структура("GTIN, Номенклатура, Количество");
			ЗаполнитьЗначенияСвойств(СтруктураДляЗапроса, GTIN.Значение);
			СтруктураДляЗапроса.GTIN = GTIN.Ключ;
			СписокДляПолученияИзСервиса.Добавить(СтруктураДляЗапроса);
			Номенклатура.Добавить(GTIN.Значение.Номенклатура);
		Иначе
			СписокДляПолученияВеса.Добавить(GTIN.Ключ);
		КонецЕсли;
		
	КонецЦикла;
	
	ЕдиницаИзмеренияКилограмм = ИнтеграцияИСКлиентСерверПовтИсп.ЕдиницаИзмеренияКилограмм();
	
	КоэффициентыУпаковокНоменклатуры = Новый Соответствие();
	
	ИнтеграцияИСПереопределяемый.ПриОпределенииКоэффициентовУпаковки(ЕдиницаИзмеренияКилограмм,  Номенклатура, КоэффициентыУпаковокНоменклатуры);
	
	АнализируемыеGTIN = Новый Массив;
	
	Для Каждого Строка Из СписокДляПолученияИзСервиса Цикл
		
		ДанныеКоэффициента = КоэффициентыУпаковокНоменклатуры.Получить(Строка.Номенклатура);
		КоэффициентКилограммВГраммы = 1000;
		Если ДанныеКоэффициента <> Неопределено Тогда
			
			ДанныеДляРасчета = Новый Структура("GTIN, Вес");
			ДанныеДляРасчета.GTIN = Строка.GTIN;
			ДанныеДляРасчета.Вес = Формат(
				КоэффициентКилограммВГраммы * ДанныеКоэффициента.Коэффициент * Строка.Количество,
				"ЧН=0; ЧГ=0");
			АнализируемыеGTIN.Добавить(ДанныеДляРасчета);
			
		КонецЕсли;
		
	КонецЦикла;
	
	КоличествоПотребительскихУпаковокПоGTIN = Новый Соответствие();
	
	Если АнализируемыеGTIN.Количество() > 0 Тогда
		РезультатСервиса = ИнтерфейсИСМП.КоличествоПотребительскихУпаковокНаОснованииВеса(
			ПараметрыСканирования.Организация, ВидМаркируемойПродукции, АнализируемыеGTIN);
		
		Если ЗначениеЗаполнено(РезультатСервиса.ТекстОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(РезультатСервиса.ТекстОшибки);
			Возврат ВозвращаемоеЗначение;
		КонецЕсли;
		
		Если РезультатСервиса.ТребуетсяОбновлениеКлючаСессии Тогда
			ВозвращаемоеЗначение.ТребуетсяОбновлениеКлючаСессии = Истина;
			Возврат ВозвращаемоеЗначение;
		КонецЕсли;
		
		Для Каждого GTIN Из ДанныеДляРасчетаПоGTIN Цикл
			ДанныеИзСервиса = РезультатСервиса.КоличествоПотребительскихУпаковок.Получить(GTIN.Ключ);
			Если ДанныеИзСервиса = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеДляЗаполнения = Новый Структура("КоличествоВложенныхЕдиниц, КоличествоПодобрано");
			ДанныеДляЗаполнения.КоличествоВложенныхЕдиниц = ДанныеИзСервиса;
			ДанныеДляЗаполнения.КоличествоПодобрано       = GTIN.Значение.Количество;
			КоличествоПотребительскихУпаковокПоGTIN.Вставить(GTIN.Ключ, ДанныеДляЗаполнения);
		КонецЦикла;
		
	КонецЕсли;
	
	ВесаПоGTIN = ВесПоGTIN(СписокДляПолученияВеса, ПараметрыСканирования);
	
	Для Каждого GTIN Из ДанныеДляРасчетаПоGTIN Цикл
		
		Если GTIN.Значение.ТребуетВзвешивания Тогда
			Продолжить;
		КонецЕсли;
		
		Вес = ВесаПоGTIN[GTIN.Ключ];
		
		Если Вес = Неопределено Или Вес = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеДляЗаполнения = Новый Структура("КоличествоВложенныхЕдиниц, КоличествоПодобрано");
		ДанныеДляЗаполнения.КоличествоВложенныхЕдиниц = Окр(GTIN.Значение.Количество / Вес, 0);
		ДанныеДляЗаполнения.КоличествоПодобрано       = Окр(ДанныеДляЗаполнения.КоличествоВложенныхЕдиниц * Вес, 3);
		
		Если ДанныеДляЗаполнения.КоличествоПодобрано = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоПотребительскихУпаковокПоGTIN.Вставить(GTIN.Ключ, ДанныеДляЗаполнения);
		
	КонецЦикла;
	
	ВозвращаемоеЗначение.КоличествоПотребительскихУпаковокПоGTIN = КоличествоПотребительскихУпаковокПоGTIN;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция СписокGTINПоДаннымВиртуальногоБаланса(Организация, ВидПродукции, МассивGTIN) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ТребуетсяОбновлениеКлючаСессии", Ложь);
	ВозвращаемоеЗначение.Вставить("СписокGTIN",                     Неопределено);
	ВозвращаемоеЗначение.Вставить("ВНаличииНаБалансе",              Неопределено);
	
	РезультатСервиса = ИнтерфейсИСМП.ОстатокGTINПоДаннымВиртуальногоБаланса(Организация, ВидПродукции, МассивGTIN);
	
	Если ЗначениеЗаполнено(РезультатСервиса.ТекстОшибки) Тогда
		ВызватьИсключение РезультатСервиса.ТекстОшибки;
	КонецЕсли;
	
	Если РезультатСервиса.ТребуетсяОбновлениеКлючаСессии Тогда
		ВозвращаемоеЗначение.ТребуетсяОбновлениеКлючаСессии = Истина;
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	ВНаличииНаБалансе = Новый Массив;
	СписокGTIN = Новый СписокЗначений;
	
	Если РезультатСервиса.ОстатокGTIN <> Неопределено Тогда
		
		Для Каждого СтрокаОтвет Из РезультатСервиса.ОстатокGTIN Цикл
			
			Если СтрокаОтвет.Значение > 0 Тогда
				ВНаличииНаБалансе.Добавить(СтрокаОтвет.Ключ);
			КонецЕсли;
			
			ПредставлениеОстаток = Новый ФорматированнаяСтрока(
				СтрШаблон(
					НСтр("ru = 'Остаток в ГИС МТ: %1'"),
					СтрокаОтвет.Значение),,
				ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
			ПредставлениеЗначения = Новый ФорматированнаяСтрока(СтрокаОтвет.Ключ, " ", ПредставлениеОстаток);
			СписокGTIN.Добавить(СтрокаОтвет.Ключ, ПредставлениеЗначения);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.СписокGTIN        = СписокGTIN;
	ВозвращаемоеЗначение.ВНаличииНаБалансе = ВНаличииНаБалансе;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоответствиеСтрокДерева(СтрокиДерева, СоответствиеСтрокДерева)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		СоответствиеСтрокДерева.Вставить(СтрокаДерева.ИдентификаторСтроки, СтрокаДерева);
		
		СоответствиеСтрокДерева(СтрокаДерева.Строки, СоответствиеСтрокДерева);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти