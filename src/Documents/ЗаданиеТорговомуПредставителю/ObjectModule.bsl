#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет в табличную часть Задачи строки с описанием задач, которые могут быть сформированы автоматически.
//
Процедура ДобавитьАвтоматическиеЗадачи() Экспорт
	
	ИспользованиеЗаданий = Константы.ИспользованиеЗаданийТорговымПредставителям.Получить();
	Если ИспользованиеЗаданий = Перечисления.ИспользованиеЗаданийТорговымПредставителям.ИспользуютсяТорговымиПредставителямиДляПланирования Тогда
		
		// Добавление задачи по контролю просроченной оплаты
		Если ДолгиПоЗаказам.Итог("КОплатеПросрочено")>0 Тогда
			Если Задачи.Найти("Обратить внимание на просроченную оплату", "ОписаниеЗадачи")= Неопределено Тогда
				НоваяСтрока = Задачи.Добавить();
				НоваяСтрока.ОписаниеЗадачи = НСтр("ru='Обратить внимание на просроченную оплату'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет товарный состав по данным истории продаж.
//
// Параметры:
//  ОписаниеПериода - Структура - структура, содержащая следующие элементы:
//		* Период - Строка - детализация группировки информации по периоду (День, Неделя, Месяц)
//		* НачалоПериода - Дата - дата начала периода, за который анализируется история продаж
//		* КонецПериода - Дата - дата конца периода, за который анализируется история продаж
//  ДетализацияПоХарактеристикам - Булево - признак необходимости детализации задания по характеристикам.
//
Процедура ЗаполнитьПоИсторииПродаж(ОписаниеПериода, ДетализацияПоХарактеристикам=Ложь) Экспорт

	Период = ОписаниеПериода.Период;
	НачалоПериода = ОписаниеПериода.НачалоПериода;
	КонецПериода = ОписаниеПериода.КонецПериода;
	
	Если ДетализацияПоНоменклатуре Тогда
		СхемаКомпоновки = Документы.ЗаданиеТорговомуПредставителю.ПолучитьМакет("СхемаКомпоновкиДляАвтоматическогоЗаполненияПоИсторииПродаж");
	Иначе
		СхемаКомпоновки = Документы.ЗаданиеТорговомуПредставителю.ПолучитьМакет("СхемаКомпоновкиДляАвтоматическогоЗаполненияПоИсторииПродажПоСумме");
		ДетализацияПоХарактеристикам=Ложь;
	КонецЕсли;

	НастройкиКомпоновки = СхемаКомпоновки.НастройкиПоУмолчанию;	
	
	МобильныеПриложения.УстановитьИспользованиеПоляКомпоновки(НастройкиКомпоновки, "Характеристика", ДетализацияПоХарактеристикам);
	МобильныеПриложения.УстановитьЗначениеЭлементаОтбора(НастройкиКомпоновки.Отбор, "Партнер",, Истина, Партнер);
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		МобильныеПриложения.УстановитьЗначениеЭлементаОтбора(НастройкиКомпоновки.Отбор, "Контрагент",, Истина, Контрагент);
	КонецЕсли;
	
	МобильныеПриложения.УстановитьЗначениеПараметраНастроек(НастройкиКомпоновки, "ДетализацияПоХарактеристикам", ДетализацияПоХарактеристикам);

	РезультатЗапроса = ТорговыеПредставителиСервер.ВыполнитьЗапросПоИсторииПродаж(
		НастройкиКомпоновки, 
		НачалоПериода,
		КонецПериода,
		Период,
		ДетализацияПоНоменклатуре);

	ТаблицаЗапроса = РезультатЗапроса.Выгрузить();
	
	Если ДетализацияПоНоменклатуре Тогда
		
		Товары.Очистить();
		Для Каждого ТекСтрока Из ТаблицаЗапроса Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекСтрока);
			НоваяСтрока.КоличествоУпаковокПлан = НоваяСтрока.КоличествоПлан;
		КонецЦикла;
		
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		
		// Параметры заполнения
		СтруктураЗаполнения = Новый Структура;
		СтруктураЗаполнения.Вставить("Дата", Дата);
		СтруктураЗаполнения.Вставить("Организация", Организация);
		СтруктураЗаполнения.Вставить("Валюта", Валюта);
		СтруктураЗаполнения.Вставить("Соглашение", Соглашение);
		СтруктураЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
		СтруктураЗаполнения.Вставить("ВозвращатьМногооборотнуюТару", ВернутьМногооборотнуюТару);
		СтруктураЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС, ВидЦены");
					
		СтруктураПересчета = Новый Структура("Очищать", Ложь);
		
		// Структура действий с измененными строками
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуРучнойСкидки", "КоличествоУпаковок");
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", СтруктураПересчета);
					
		ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(Товары, , СтруктураЗаполнения, СтруктураДействий);
		
	Иначе
		
		СуммаИсторииПродаж = ТаблицаЗапроса.Итог("Сумма");
		ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
		
		Если Валюта <> ВалютаУпрУчета Тогда
			СтруктураКурсовСтаройВалюты = РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(ВалютаУпрУчета, Дата);
			СтруктураКурсовНовойВалюты = РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(Валюта, Дата);
			
			СуммаИсторииПродаж = РаботаСКурсамиВалютУТ.ПересчитатьПоКурсу(СуммаИсторииПродаж,
                     СтруктураКурсовСтаройВалюты, СтруктураКурсовНовойВалюты);
		КонецЕсли;
		
		СуммаПлан = СуммаИсторииПродаж;
		
	КонецЕсли;

КонецПроцедуры

// Заполняет задание информацией о состоянии расчетов с клиентом.
//
Процедура ЗаполнитьДанныеОДебиторскойЗадолженности() Экспорт
	
	Если ДолгиПоЗаказам.Количество()>0 Тогда
		ДолгиПоЗаказам.Очистить();
	КонецЕсли;
	
	Если РасшифровкаДебиторскойЗадолженности.Количество()>0 Тогда
		РасшифровкаДебиторскойЗадолженности.Очистить();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		СтруктураДанныхОДолгах = ТорговыеПредставителиСервер.ПолучитьДанныеОДебиторскойЗадолженностиПартнера(Партнер, ДатаВизитаПлан);
		ДолгиПоЗаказам.Загрузить(СтруктураДанныхОДолгах.ТаблицаДолгов);
		РасшифровкаДебиторскойЗадолженности.Загрузить(СтруктураДанныхОДолгах.ТаблицаДвижений);
	КонецЕсли;
	
КонецПроцедуры

#Область УсловияПродаж

// Заполняет условия продаж в задании торговому представителю.
//
// Параметры:
//  УсловияПродаж - Структура - структура, содержащая данные условий продаж. Свойства структуры:
//  	* Валюта - СправочникСсылка.Валюты - используемая валюта.
//  	* ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - хозяйственная операция.
//  	* ГрафикОплаты - СправочникСсылка.ГрафикиОплаты - график оплаты.
//  	* ФормаОплаты - ПеречислениеСсылка.ФормыОплаты - форма оплаты.
//  	* ЦенаВключаетНДС - Булево - признак влючения НДС.
//  	* НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - тип налогообложения НДС.
//  	* ВозвращатьМногооборотнуюТару - Булево - признак необходимости возврата многооборотной тары.
//  	* СрокВозвратаМногооборотнойТары - Число - срок, в который требуется вернуть тару.
//  	* ТребуетсяЗалогЗаТару - Булево - признак необходимости залога за тару.
//  	* Организация - СправочникСсылка.Организации - организация.
//  	* Склад - СправочникСсылка.Склады - склад.
//  	* Контрагент - СправочникСсылка.Контрагенты - контрагент.
//  	* Типовое - Булево - признак того, что используемое соглашение - типовое.
//
Процедура ЗаполнитьУсловияПродаж(УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументПродажи = ЭтотОбъект;
	
	ДокументПродажи.Валюта = УсловияПродаж.Валюта;
	ДокументПродажи.ХозяйственнаяОперация = УсловияПродаж.ХозяйственнаяОперация;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГрафикОплаты) Тогда
		ДокументПродажи.ГрафикОплаты = УсловияПродаж.ГрафикОплаты;
	КонецЕсли;
	
	ДокументПродажи.ФормаОплаты = УсловияПродаж.ФормаОплаты;
	ДокументПродажи.ЦенаВключаетНДС    = УсловияПродаж.ЦенаВключаетНДС;
	ДокументПродажи.ВернутьМногооборотнуюТару = УсловияПродаж.ВозвращатьМногооборотнуюТару;
	ДокументПродажи.СрокВозвратаМногооборотнойТары = УсловияПродаж.СрокВозвратаМногооборотнойТары;
	ДокументПродажи.ТребуетсяЗалогЗаТару = УсловияПродаж.ТребуетсяЗалогЗаТару;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) Тогда
		ДокументПродажи.Организация = УсловияПродаж.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Склад) Тогда
		ДокументПродажи.Склад = УсловияПродаж.Склад;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Контрагент) И НЕ ЗначениеЗаполнено(ДокументПродажи.Контрагент) Тогда
		Если НЕ УсловияПродаж.Типовое Тогда
			ДокументПродажи.Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
	КонецЕсли;
	
	Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект, ХозяйственнаяОперация, Валюта);
	ДатаНачала = ?(ЗначениеЗаполнено(ДокументПродажи.Дата), ДокументПродажи.Дата,
		ОбщегоНазначения.ТекущаяДатаПользователя());
	
	Если ЗначениеЗаполнено(УсловияПродаж.СрокПоставки) Тогда
		ДокументПродажи.ЖелаемаяДатаОтгрузки = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаНачала,
			Перечисления.Периодичность.День, УсловияПродаж.СрокПоставки) + 1;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
КонецПроцедуры

// Заполняет условия продаж в задании торговому представителю по умолчанию
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
	Если ЗначениеЗаполнено(Партнер) ИЛИ НЕ ИспользоватьСоглашенияСКлиентами Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ТолькоИспользуемыеВРаботеТП", Истина);
		ПараметрыОтбора.Вставить("ВыбранноеСоглашение", Соглашение);
		ПараметрыОтбора.Вставить("ПустаяСсылкаДокумента", Документы.ЗаданиеТорговомуПредставителю.ПустаяСсылка());
					
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(Партнер, ПараметрыОтбора);
			
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если НЕ ИспользоватьСоглашенияСКлиентами ИЛИ 
				(Соглашение <> УсловияПродажПоУмолчанию.Соглашение И ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение)) Тогда
				
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				
				ПараметрыЗаполнения = Документы.ЗаданиеТорговомуПредставителю.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
				УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
				
				Если ИспользоватьСоглашенияСКлиентами Тогда
					СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
					
					// Параметры заполнения
					СтруктураЗаполнения = Новый Структура;
					СтруктураЗаполнения.Вставить("Дата", Дата);
					СтруктураЗаполнения.Вставить("Организация", Организация);
					СтруктураЗаполнения.Вставить("Валюта", Валюта);
					СтруктураЗаполнения.Вставить("Соглашение", Соглашение);
					СтруктураЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
					СтруктураЗаполнения.Вставить("ВозвращатьМногооборотнуюТару", ВернутьМногооборотнуюТару);
					СтруктураЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС, ВидЦены");
							
					СтруктураПересчета = Новый Структура("Очищать", Ложь);
					
					// Структура действий с измененными строками
					СтруктураДействий = Новый Структура;
					СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
					СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
					СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
					СтруктураДействий.Вставить("ПересчитатьСуммуРучнойСкидки", "КоличествоУпаковок");
					СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", СтруктураПересчета);
						
					ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(Товары, , СтруктураЗаполнения, СтруктураДействий);
					
				КонецЕсли;
			Иначе
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

// Заполняет условия продаж в задании торговому представителю по соглашению
//
Процедура ЗаполнитьУсловияПродажПоСоглашению() Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение);
	ЗаполнитьУсловияПродаж(УсловияПродаж);

	ПараметрыЗаполнения = Документы.ЗаданиеТорговомуПредставителю.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
	
	// Параметры заполнения
	СтруктураЗаполнения = Новый Структура;
	СтруктураЗаполнения.Вставить("Дата", Дата);
	СтруктураЗаполнения.Вставить("Организация", Организация);
	СтруктураЗаполнения.Вставить("Валюта", Валюта);
	СтруктураЗаполнения.Вставить("Соглашение", Соглашение);
	СтруктураЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
	СтруктураЗаполнения.Вставить("ВозвращатьМногооборотнуюТару", ВернутьМногооборотнуюТару);
	СтруктураЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС, ВидЦены");
			
	СтруктураПересчета = Новый Структура("Очищать", Ложь);
	
	// Структура действий с измененными строками		
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы );
	СтруктураДействий.Вставить("ПересчитатьСуммуРучнойСкидки", "КоличествоУпаковок");
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", СтруктураПересчета);
		
	ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(Товары,	, СтруктураЗаполнения, СтруктураДействий);
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);

КонецПроцедуры

// Заполняет условия продаж в задании торговому представителю по данным соглашения
//
Процедура ЗаполнитьДокументПоДаннымСоглашения() Экспорт
	
	СтруктураУсловийСоглашения = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение);
	
	Если ЗначениеЗаполнено(СтруктураУсловийСоглашения.Организация) Тогда
		Организация = СтруктураУсловийСоглашения.Организация;
	КонецЕсли;
	
	Валюта = СтруктураУсловийСоглашения.Валюта;
	ЦенаВключаетНДС = СтруктураУсловийСоглашения.ЦенаВключаетНДС;
	ГрафикОплаты = СтруктураУсловийСоглашения.ГрафикОплаты;
	
	Если ЗначениеЗаполнено(СтруктураУсловийСоглашения.Склад) Тогда
		Склад = СтруктураУсловийСоглашения.Склад;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		КонтрагентПоУмолчанию = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер);
		Если КонтрагентПоУмолчанию <> Неопределено Тогда
			Контрагент = КонтрагентПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗаполнения = Документы.ЗаданиеТорговомуПредставителю.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);

КонецПроцедуры

#КонецОбласти

#Область УсловияОбслуживания

// Заполняет условия продаж в задании торговому представителю по условиям обслуживания.
//
Процедура ЗаполнитьУсловияПродажПоУсловиямОбслуживания() Экспорт
	
	Если Не ЗначениеЗаполнено(УсловияОбслуживания) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураУсловий = ТорговыеПредставителиСервер.ПолучитьУсловияОбслуживания(УсловияОбслуживания);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами")
		И Соглашение <> СтруктураУсловий.Соглашение И ЗначениеЗаполнено(СтруктураУсловий.Соглашение) Тогда
		Соглашение = СтруктураУсловий.Соглашение;
		ЗаполнитьУсловияПродажПоСоглашению();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураУсловий.Куратор) Тогда
		Куратор = СтруктураУсловий.Куратор;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураУсловий.ТорговыйПредставитель) Тогда
		ТорговыйПредставитель = СтруктураУсловий.ТорговыйПредставитель;
	КонецЕсли;
	
	ДатаВизитаПлан = СтруктураУсловий.ДатаВизитаПлан;
	ВремяНачала    = СтруктураУсловий.ВремяНачала;
	ВремяОкончания = СтруктураУсловий.ВремяОкончания;

КонецПроцедуры

// Заполняет условия продаж в задании торговому представителю по условиям обслуживания по умолчанию.
//
Процедура ЗаполнитьУсловияОбслуживанияПоУмолчанию() Экспорт
	
	Если НЕ ЗначениеЗаполнено(Партнер) Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьСоглашения = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	СтароеСоглашение       = Соглашение;
	
	СтруктураУсловий = ТорговыеПредставителиСервер.ПолучитьУсловияОбслуживанияПоУмолчанию(Партнер);
	
	Если СтруктураУсловий <> Неопределено Тогда
		
		УсловияОбслуживания = СтруктураУсловий.УсловияОбслуживания;
		
		Если ИспользоватьСоглашения И Соглашение <> СтруктураУсловий.Соглашение Тогда
			Соглашение = СтруктураУсловий.Соглашение;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтруктураУсловий.Куратор) Тогда
			Куратор = СтруктураУсловий.Куратор;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтруктураУсловий.ТорговыйПредставитель) Тогда
			ТорговыйПредставитель = СтруктураУсловий.ТорговыйПредставитель;
		КонецЕсли;
	
		ДатаВизитаПлан = СтруктураУсловий.ДатаВизитаПлан;
		ВремяНачала = СтруктураУсловий.ВремяНачала;
		ВремяОкончания = СтруктураУсловий.ВремяОкончания;
		
	КонецЕсли;
	
	Если ИспользоватьСоглашения Тогда
		Если Не ЗначениеЗаполнено(Соглашение) Или СтруктураУсловий = Неопределено Тогда
			ЗаполнитьУсловияПродажПоУмолчанию();
		ИначеЕсли СтароеСоглашение <> Соглашение Тогда
			ЗаполнитьУсловияПродажПоСоглашению();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДетализацияПоНоменклатуре = Константы.ДетализироватьЗаданияТорговымПредставителямПоНоменклатуре.Получить();
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
			Если ДанныеЗаполнения.Свойство("Партнер") Тогда
				Партнер = ДанныеЗаполнения.Партнер;
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("УсловияОбслуживания") Тогда
				УсловияОбслуживания = ДанныеЗаполнения.УсловияОбслуживания;
				ЗаполнитьУсловияПродажПоУсловиямОбслуживания();
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("Соглашение") Тогда
				Соглашение = ДанныеЗаполнения.Соглашение;
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("Контрагент") Тогда
				Контрагент = ДанныеЗаполнения.Контрагент;
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("ТорговыйПредставитель") Тогда
				ТорговыйПредставитель = ДанныеЗаполнения.ТорговыйПредставитель;
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("ДатаВизитаПлан") Тогда
				ДатаВизитаПлан = ДанныеЗаполнения.ДатаВизитаПлан;
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
				ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаданиеТорговомуПредставителю") 
			ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			
			ЗаполнитьНаОсновании(ДанныеЗаполнения);
		
		КонецЕсли;
		
	КонецЕсли;
	
	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
	ИнициализироватьУсловияПродаж();
	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыЗаданийТорговымПредставителям.НеПодготовлено;
	СуммаДокумента = 0;
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	ДатаВизитаПлан = '00010101';
	ДатаВизитаФакт = '00010101';
	
	Задачи.Очистить();
	
	Для Каждого Строка Из Товары Цикл
		Строка.Количество = 0;
		Строка.КоличествоУпаковок = 0;
		Строка.Сумма = 0;
		Строка.СуммаНДС = 0;
		Строка.Комментарий = "";
		Строка.ПроцентРучнойСкидки = 0;
		Строка.СуммаРучнойСкидки = 0;
		Строка.ПричинаОтмены = Справочники.ПричиныОтменыЗаказовКлиентов.ПустаяСсылка();
	КонецЦикла;

	Для Каждого Строка Из ЭтапыГрафикаОплаты Цикл
		Строка.ДатаПлатежа = '00010101000000';
		Строка.СуммаПлатежа = 0;
		Строка.СуммаЗалогаЗаТару = 0;
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИменаПолейССуффиксом.Вставить("Количество", "КоличествоПлан");
	ПараметрыПроверки.ИменаПолейССуффиксом.Вставить("КоличествоУпаковок", "КоличествоУпаковокПлан");
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	Если Статус <> Перечисления.СтатусыЗаданийТорговымПредставителям.Отработано Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВизитаФакт");
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыЗаданийТорговымПредставителям.Отменено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВизитаПлан");
	КонецЕсли;
		
	Если Статус = Перечисления.СтатусыЗаданийТорговымПредставителям.НеПодготовлено 
		ИЛИ Статус = Перечисления.СтатусыЗаданийТорговымПредставителям.Отменено Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
		МассивНепроверяемыхРеквизитов.Добавить("ТорговыйПредставитель");
		МассивНепроверяемыхРеквизитов.Добавить("Куратор");
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ХозяйственнаяОперация");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Соглашение)
		ИЛИ НЕ ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
		
	КонецЕсли;
	
	Если Статус <> Перечисления.СтатусыЗаданийТорговымПредставителям.Отработано 
		ИЛИ Статус <> Перечисления.СтатусыЗаданийТорговымПредставителям.КОтработке Тогда
		ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект,Отказ);
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСодержания(ЭтотОбъект, Отказ, "Товары");
	ПроверитьВозможностьИспользованияДанныхТорговымиПредставителями(Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПараметрыОкругления = НоменклатураСервер.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.ИмяПоляКоличествоСуффикс = "КоличествоПлан";
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
	СуммаДокумента = ПолучитьСуммуЗаказанныхСтрок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если НЕ ЗначениеЗаполнено(Куратор) Тогда
		Куратор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		Если НЕ ЗначениеЗаполнено(УсловияОбслуживания) Тогда
			ЗаполнитьУсловияОбслуживанияПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;

	ПараметрыЗаполнения = Документы.ЗаданиеТорговомуПредставителю.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(ЭтотОбъект);
	
	СтруктураДействий = Новый Структура;
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Товары, СтруктураДействий, КэшированныеЗначения);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначения.ОбработанныеСтроки, СтруктураДействий, Неопределено);
	
КонецПроцедуры

Процедура ЗаполнитьНаОсновании(ДокументОснование)
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаданиеТорговомуПредставителю")
		ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ДанныеОснования = ПолучитьДанныеОснования(ДокументОснование);
		ТаблицаСостава = ДанныеОснования.Товары; // ТаблицаЗначений
		
	Иначе
		Возврат;
	КонецЕсли;
	
	ЗаполнитьШапку(ДокументОснование, ДанныеОснования);
	Товары.Очистить();
	ЭтапыГрафикаОплаты.Очистить();
	
	Если ДетализацияПоНоменклатуре Тогда
		ТаблицаСостава.Свернуть("Номенклатура,Характеристика,Упаковка,ВидЦены,Цена,СтавкаНДС","КоличествоПлан, КоличествоУпаковокПлан");
		Товары.Загрузить(ТаблицаСостава);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьШапку(ДокументОснование, ДанныеОснования)
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Партнер = ДанныеОснования.Партнер;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДанныеОснования.Валюта;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Соглашение) Тогда
		Соглашение = ДанныеОснования.Соглашение;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = ДанныеОснования.Организация;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = ДанныеОснования.Контрагент;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ГрафикОплаты) Тогда
		ГрафикОплаты = ДанныеОснования.ГрафикОплаты;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Склад) Тогда
		Склад = ДанныеОснования.Склад;
	КонецЕсли;
	
	Если Не ДетализацияПоНоменклатуре Тогда
		СуммаПлан = ДанныеОснования.Сумма;
	КонецЕсли;

КонецПроцедуры

Процедура ИнициализироватьУсловияПродаж()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ЗаполнитьУсловияПродажПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Рассчитывает сумму неотмененных строк заказа
//
// Параметры:
//  ТолькоЗалогЗаТару - Булево- признак расчета только за тару.
//
// Возвращаемое значение:
//  Число - сумма заказанных строк.
//
Функция ПолучитьСуммуЗаказанныхСтрок(ТолькоЗалогЗаТару = Ложь) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.СуммаСНДС КАК СуммаСНДС,
	|	Товары.ПричинаОтмены КАК ПричинаОтмены
	|ПОМЕСТИТЬ
	|	Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(Товары.СуммаСНДС),0) КАК СуммаСНДС
	|ИЗ
	|	Товары КАК Товары
	|ГДЕ
	|	Товары.ПричинаОтмены = ЗНАЧЕНИЕ(Справочник.ПричиныОтменыЗаказовКлиентов.ПустаяСсылка)
	|	И ((Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара) И НЕ &ТолькоЗалогЗаТару)
	|		ИЛИ (Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара) И НЕ &ВернутьМногооборотнуюТару)
	|		ИЛИ (Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара) И &ТолькоЗалогЗаТару))
	|");
	
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"Номенклатура,СуммаСНДС,ПричинаОтмены"));
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару", ВернутьМногооборотнуюТару);
	Запрос.УстановитьПараметр("ТолькоЗалогЗаТару", ТолькоЗалогЗаТару);
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	СуммаЗаказанныхСтрок = Выгрузка[0].СуммаСНДС;
	Возврат СуммаЗаказанныхСтрок;
	
КонецФункции

Функция ПолучитьДанныеОснования(ДокументОснование)
	
	Если ТипЗнч(ДокументОснование) = "ДокументСсылка.ЗаданиеТорговомуПредставителю" Тогда
		ПолеСумма = "СуммаПлан";
		ПолеКоличество = "КоличествоПлан";
		ПолеКоличествоУпаковок = "КоличествоУпаковокПлан";
	Иначе
		ПолеСумма = "СуммаДокумента";
		ПолеКоличество = "Количество";
		ПолеКоличествоУпаковок = "КоличествоУпаковок";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Основание.Партнер КАК Партнер,
	|	Основание.Валюта КАК Валюта,
	|	Основание.Соглашение КАК Соглашение,
	|	Основание.Договор КАК Договор,
	|	Основание.Организация КАК Организация,
	|	Основание.Контрагент КАК Контрагент,
	|	Основание.ГрафикОплаты КАК ГрафикОплаты,
	|	Основание.Склад КАК Склад,
	|	Основание." + ПолеСумма + " КАК Сумма,
	|	Основание.Товары.(
	|   Номенклатура КАК Номенклатура,
	|   Характеристика КАК Характеристика,
	|   Упаковка КАК Упаковка,
	|"+ ПолеКоличество + " КАК КоличествоПлан,
	|"+ ПолеКоличествоУпаковок + " КАК КоличествоУпаковокПлан,
	|   ВидЦены КАК ВидЦены,
	|   Цена КАК Цена,
	|   СтавкаНДС КАК СтавкаНДС,
	|) КАК Товары
	|ИЗ Документ." + ДокументОснование.Метаданные().Имя + " КАК Основание
	|ГДЕ
	|	Основание.Ссылка = &ДокументОснование"
	;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	СтруктураДанных = Новый Структура();
	СтруктураДанных.Вставить("Партнер");
	СтруктураДанных.Вставить("Валюта");
	СтруктураДанных.Вставить("Соглашение");
	СтруктураДанных.Вставить("Договор");
	СтруктураДанных.Вставить("Организация");
	СтруктураДанных.Вставить("Контрагент");
	СтруктураДанных.Вставить("ГрафикОплаты");
	СтруктураДанных.Вставить("Склад");
	СтруктураДанных.Вставить("Сумма");
	
	ЗаполнитьЗначенияСвойств(СтруктураДанных, Выборка);
	
	СтруктураДанных.Вставить("Товары", Выборка.Товары.Выгрузить());
	
	Возврат СтруктураДанных;
	
КонецФункции

Процедура ПроверитьВозможностьИспользованияДанныхТорговымиПредставителями(Отказ)
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		Если Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Партнер, "ОбслуживаетсяТорговымиПредставителями") Тогда
			ТекстСообщения = НСтр("ru='Для указанного партнера не указан признак обслуживания торговыми представителями'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Партнер");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
			
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") И ЗначениеЗаполнено(Соглашение) Тогда
		
		Если Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуетсяВРаботеТорговыхПредставителей") Тогда
			ТекстСообщения = НСтр("ru='Указанное соглашение не используется в работе торговых представителей'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Соглашение");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
