#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Извещение") Тогда
		СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Извещение",
			"Извещение",
			СформироватьПечатнуюФормуИзвещение(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуИзвещение(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИЗВЕЩЕНИЕ";
	
	НомерТипаДокумента = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначенияУТ.ПолучитьМодульЛокализации(СтруктураОбъектов.Ключ);
		Если МенеджерОбъекта = Неопределено Тогда
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		КонецЕсли;

		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыИзвещения(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументИзвещение(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Извещение

// Параметры:
// 	ТабличныйДокумент - ТабличныйДокумент
// 	ДанныеДляПечати - Структура:
// 		* РезультатПоШапке - РезультатЗапроса
// 		* РезультатПоЭтапамОплаты - РезультатЗапроса
// 		* РезультатПоТабличнойЧасти - РезультатЗапроса
//	ОбъектыПечати - СписокЗначений - список объектов печати
//
Процедура ЗаполнитьТабличныйДокументИзвещение(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Перем КомплектПечатиПоСсылке;
	
	ШаблоныОшибок = Новый Структура;
	ШаблоныОшибок.Вставить("Товары", НСтр("ru = 'В документе %1 отсутствуют товары. Печать извещения не требуется'"));
	ШаблоныОшибок.Вставить("ЗаменяющиеТовары", НСтр("ru = 'В документе %1 отсутствуют заменяющие товары. Печать извещения не требуется'"));
	ШаблоныОшибок.Вставить("Этапы", НСтр("ru = 'В документе %1 отсутствуют этапы оплаты. Печать извещения не требуется'"));
	ШаблоныОшибок.Вставить("ЮрФизЛицо", НСтр("ru = 'Контрагент документа %1 не является физическим лицом. Печать извещения не требуется'"));
	ШаблоныОшибок.Вставить("СуммаКОплате", НСтр("ru = 'Сумма к оплате по документу %1 равна 0. Печать извещения не требуется'"));
	ШаблоныОшибок.Вставить("БанковскийСчет", НСтр("ru = 'В документе %1 не заполнен банковский счет организации. Печать извещения не требуется'"));
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	Если ДанныеДляПечати.Свойство("РезультатПоЭтапамОплаты") Тогда
		ЭтапыОплаты = ДанныеДляПечати.РезультатПоЭтапамОплаты.Выгрузить();
	Иначе
		ЭтапыОплаты = Неопределено;
		ТаблицаЭтапыОплаты = Неопределено;
	КонецЕсли;
	Если ДанныеДляПечати.Свойство("РезультатПоТабличнойЧасти") Тогда
		Товары = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	Иначе
		Товары = Неопределено;
		ТаблицаТовары = Неопределено;
	КонецЕсли;
	
	ПервыйДокумент = Истина;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьИзвещений.ПФ_MXL_Извещение_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Отказ = Ложь;
		
		Если ДанныеПечати.КонтрагентЮрФизЛицо <> Перечисления.ЮрФизЛицо.ФизЛицо Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблоныОшибок.ЮрФизЛицо,
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеПечати.БанковскийСчет) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблоныОшибок.БанковскийСчет,
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		Если Товары <> Неопределено Тогда
			ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоиска);
		КонецЕсли;
		Если ЭтапыОплаты <> Неопределено Тогда
			ТаблицаЭтапыОплаты = ЭтапыОплаты.НайтиСтроки(СтруктураПоиска);
		КонецЕсли;
		
		ПроверкаЗаполненияДокумента(ДанныеПечати, ТаблицаТовары, ТаблицаЭтапыОплаты, ШаблоныОшибок, Отказ);
		Если Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		СуммаКОплатеПоСчету = СуммаКОплатеПоСчету(ДанныеПечати, ТаблицаТовары);
		Если СуммаКОплатеПоСчету <= 0 Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблоныОшибок.СуммаКОплате,
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Ссылка", ДанныеПечати.Ссылка);
		
		Если ТипЗнч(ДанныеПечати.Контрагент) = Тип("СправочникСсылка.ФизическиеЛица")
		 И ЗначениеЗаполнено(ДанныеПечати.Контрагент) Тогда
			СтруктураФИО = ФизическиеЛицаУТ.ФамилияИмяОтчество(ДанныеПечати.Контрагент, ДанныеПечати.Дата);
			СтруктураПараметров.Вставить("ФамилияПлательщика",  СтруктураФИО.Фамилия);
			СтруктураПараметров.Вставить("ИмяПлательщика", 		СтруктураФИО.Имя);
			СтруктураПараметров.Вставить("ОтчествоПлательщика", СтруктураФИО.Отчество);
			СтруктураПараметров.Вставить("ФИОПлательщика", 		ДанныеПечати.Контрагент);
		КонецЕсли;
		
		СведенияОПоставщике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата);
		
		СтруктураПараметров.Вставить("ИННПолучателя", СведенияОПоставщике.ИНН);
		СтруктураПараметров.Вставить("КПППолучателя", СведенияОПоставщике.КПП);
		
		Если ЗначениеЗаполнено(ДанныеПечати.БИКБанкаДляРасчетов) Тогда
			Банк       = ДанныеПечати.НаименованиеБанкаДляРасчетов;
			БИК        = ДанныеПечати.БИКБанкаДляРасчетов;
			КоррСчет   = ДанныеПечати.КоррСчетБанкаДляРасчетов;
			ГородБанка = ДанныеПечати.ГородБанкаДляРасчетов;
			НомерСчета = ДанныеПечати.КоррСчетБанка;
		Иначе
			Банк       = ДанныеПечати.НаименованиеБанка;
			БИК        = ДанныеПечати.БИКБанк;
			КоррСчет   = ДанныеПечати.КоррСчетБанка;
			ГородБанка = ДанныеПечати.ГородБанкаДляРасчетов;
			НомерСчета = ДанныеПечати.НомерБанковскогоСчета;
		КонецЕсли;
		
		СтруктураПараметров.Вставить("БИКБанкаПолучателя", БИК);
		СтруктураПараметров.Вставить("НаименованиеБанкаПолучателя", СокрЛП(Банк) + " " + ГородБанка);
		СтруктураПараметров.Вставить("СчетБанкаПолучателя", КоррСчет);
		СтруктураПараметров.Вставить("НомерСчетаПолучателя", НомерСчета);
		
		Если ЗначениеЗаполнено(ДанныеПечати.БанковскийСчетТекстКорреспондента) Тогда
			СтруктураПараметров.Вставить("ТекстПолучателя", ДанныеПечати.БанковскийСчетТекстКорреспондента);
		Иначе
			СтруктураПараметров.Вставить("ТекстПолучателя",
				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,"));
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеПечати.НазначениеПлатежа)
				И ТипЗнч(ДанныеПечати.Ссылка) <> Тип("ДокументСсылка.СчетНаОплатуКлиенту") Тогда
			СтруктураПараметров.Вставить("НазначениеПлатежа", Документы.СчетНаОплатуКлиенту.СформироватьНазначениеПлатежа(
				ДанныеПечати.Номер, ДанныеПечати.Ссылка));
		Иначе
			СтруктураПараметров.Вставить("НазначениеПлатежа", ДанныеПечати.НазначениеПлатежа);
		КонецЕсли;
		
		СуммаБезКопеек = Цел(СуммаКОплатеПоСчету);
		СуммаКопейки = (СуммаКОплатеПоСчету - СуммаБезКопеек) * 100;
		СтруктураПараметров.Вставить("СуммаЧислом", СуммаКОплатеПоСчету);
		СтруктураПараметров.Вставить("Сумма", Формат(СуммаБезКопеек, "ЧДЦ=; ЧН=0; ЧГ=0"));
		СтруктураПараметров.Вставить("СуммаКопейки", Формат(СуммаКопейки, "ЧДЦ=; ЧН=00; ЧГ=0"));
		
		ОбластьМакета = Макет.ПолучитьОбласть("Печатается");
		ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
		
		ВывестиQRКод(СтруктураПараметров, ДанныеПечати, ОбластьМакета);
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверкаЗаполненияДокумента(ДанныеПечати, ТаблицаТовары, ТаблицаЭтапыОплаты, ШаблоныОшибок, Отказ);
	
	Если НЕ (ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.СчетНаОплатуКлиенту")
	 И ТипЗнч(ДанныеПечати.ДокументОснование) = Тип("СправочникСсылка.ДоговорыКонтрагентов")) 
	 И ТаблицаТовары <> Неопределено И ТаблицаТовары.Количество() = 0 Тогда
		Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблоныОшибок.ЗаменяющиеТовары, ДанныеПечати.Ссылка), ДанныеПечати.Ссылка);
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблоныОшибок.Товары, ДанныеПечати.Ссылка), ДанныеПечати.Ссылка);
		КонецЕсли;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если ТаблицаЭтапыОплаты <> Неопределено И ТаблицаЭтапыОплаты.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблоныОшибок.Этапы, ДанныеПечати.Ссылка), ДанныеПечати.Ссылка);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СуммаКОплатеПоСчету(ДанныеПечати, ТаблицаТовары)
	
	Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.АвансовыйОтчет")
		ИЛИ ТипЗнч(ДанныеПечати.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомитенту")
		ИЛИ ДанныеПечати.ЧастичнаяОплата Тогда
		
		СуммаКОплатеПоСчету = ДанныеПечати.СуммаДокумента;
		
	Иначе
		
		СуммаКОплатеПоСчету = 0;
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			СуммаКОплатеПоСчету = СуммаКОплатеПоСчету
				+ СтрокаТовары.Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СтрокаТовары.СуммаНДС);
		КонецЦикла;
		
		Если ДанныеПечати.СчетКВозврату Тогда
			СуммаКОплатеПоСчету = СуммаКОплатеПоСчету - ДанныеПечати.СуммаКВозврату;
			Если СуммаКОплатеПоСчету < 0 Тогда
				СуммаКОплатеПоСчету = 0;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СуммаКОплатеПоСчету;
	
КонецФункции

Процедура ВывестиQRКод(РеквизитыПлатежа, ДанныеПечати, ОбластьМакета)
	
	QRСтрока = УправлениеПечатьюРФ.ФорматнаяСтрокаУФЭБС(РеквизитыПлатежа);
	
	Если Не ПустаяСтрока(QRСтрока) Тогда
		
		ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190);
		
		Если ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
			КартинкаQRКода = Новый Картинка(ДанныеQRКода);
			ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаQRКода;
		Иначе
			Шаблон = Нстр("ru = 'Не удалось сформировать QR-код для документа %1.
				|Технические подробности см. в журнале регистрации.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли