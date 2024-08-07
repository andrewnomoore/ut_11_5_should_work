
#Область ПрограммныйИнтерфейс

#Область ЭтапыГрафикаОплаты

//Выполняет перезаполнение этапов графика оплаты, обновляет гиперссылку графика оплаты.
//Вызывается из метода ПередЗаписью формы.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа/справочника.
// 
Процедура ФормаПередЗаписьюНаКлиентеСервер(Форма) Экспорт
	ДополненныеПараметры = ОбщегоНазначенияУТКлиентСервер.ПолучитьДанныеМеханизмаИзКэшаФормы(Форма, "Взаиморасчеты");
	
	Для Каждого СтруктураПараметров Из ДополненныеПараметры.МассивПараметров Цикл
		
		Если СтруктураПараметров.Свойство("ИсточникСуммТабличнаяЧасть") И СтруктураПараметров.ИсточникСуммТабличнаяЧасть Тогда
			СтруктураПараметров.Удалить("СуммыДокумента");
			СтруктураПараметров.Вставить("СуммыДокумента", ВзаиморасчетыСервер.СуммыДокумента(Форма,СтруктураПараметров));
		КонецЕсли;
		
		ВзаиморасчетыСервер.ПроверитьЗаполнитьСуммуВзаиморасчетов(Форма, СтруктураПараметров, ДополненныеПараметры.СистемныеНастройки);
		ВзаиморасчетыСервер.ПроверитьЗаполнитьСуммыВзаиморасчетовВТабличнойЧасти(Форма, СтруктураПараметров);
		
	КонецЦикла;
	
	ВзаиморасчетыСервер.ПроверитьЗаполнитьЭтапыГрафикаОплаты(Форма, ДополненныеПараметры);
	ВзаиморасчетыСервер.ОбновитьТекстГиперссылкиЭтапыОплаты(Форма);
КонецПроцедуры

#КонецОбласти

#Область ОграниченияЗадолженности

// Управляет отображение ограничения задолженности в форме документа
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, на которой требуется обновить гиперссылку:
//	 * Элементы - ЭлементыФормы - элементы вызывающей формы
//
Процедура ОбновитьТекстГиперссылкиОграничениеЗадолженности(Форма) Экспорт
	
	ДополненныеПараметрыМеханизма = ОбщегоНазначенияУТКлиентСервер.ПолучитьДанныеМеханизмаИзКэшаФормы(Форма, "Взаиморасчеты");
	СистемныеНастройки = ДополненныеПараметрыМеханизма.СистемныеНастройки;
	Для Каждого СтруктураПараметров Из ДополненныеПараметрыМеханизма.МассивПараметров Цикл
		
		Если НЕ ЗначениеЗаполнено(СтруктураПараметров.ЭлементыФормы.ОграничениеЗадолженностиТекст)
			ИЛИ НЕ ЗначениеЗаполнено(СтруктураПараметров.ЭлементыФормы.ОграничениеЗадолженностиКартинка) Тогда
				Возврат;
		КонецЕсли;
		
		ВзаиморасчетыКлиентСервер.ПроверитьОбязательныеПараметры(СтруктураПараметров, "Договор,Дата");
		
		Договор                = ОбщегоНазначенияУТКлиентСервер.ДанныеПоПути(Форма, СтруктураПараметров.Договор);
		Дата                   = ОбщегоНазначенияУТКлиентСервер.ДанныеПоПути(Форма, СтруктураПараметров.Дата);
		ЭлементТекст           = Форма.Элементы[СтруктураПараметров.ЭлементыФормы.ОграничениеЗадолженностиТекст];
		ЭлементКартинка        = Форма.Элементы[СтруктураПараметров.ЭлементыФормы.ОграничениеЗадолженностиКартинка];
		ЕстьРасчетыПоДоговорам = СтруктураПараметров.ДокументРасчетовСКлиентами И СистемныеНастройки.ИспользоватьДоговорыСКлиентами
										ИЛИ СтруктураПараметров.ДокументРасчетовСПоставщиками И СистемныеНастройки.ИспользоватьДоговорыСПоставщиками;
		
		Если ПравоДоступа("Чтение", Метаданные.Справочники.ДоговорыКонтрагентов)
			И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.РасчетыСКлиентами)
			И ЕстьРасчетыПоДоговорам Тогда
			
			ДанныеДоговора = Новый Структура; 
			ДанныеДоговора.Вставить("ОграничиватьСуммуЗадолженности", Ложь); 
			ДанныеДоговора.Вставить("ДопустимаяСуммаЗадолженности",         0); 
			ДанныеДоговора.Вставить("ВалютаВзаиморасчетов",                 Неопределено); 
			ДанныеДоговора.Вставить("ЗапрещаетсяПросроченнаяЗадолженность", Ложь); 
			
			Если ЗначениеЗаполнено(Договор) Тогда
				
				Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ДоговорыКонтрагентов.ОграничиватьСуммуЗадолженности КАК ОграничиватьСуммуЗадолженности,
				|	ДоговорыКонтрагентов.ДопустимаяСуммаЗадолженности КАК ДопустимаяСуммаЗадолженности,
				|	ДоговорыКонтрагентов.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
				|	ДоговорыКонтрагентов.ЗапрещаетсяПросроченнаяЗадолженность КАК ЗапрещаетсяПросроченнаяЗадолженность
				|ИЗ
				|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
				|ГДЕ
				|	ДоговорыКонтрагентов.Ссылка = &Договор");
				
				Запрос.УстановитьПараметр("Договор", Договор);
				
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					ДанныеДоговора = Выборка;
				КонецЕсли;
				
			КонецЕсли;
			
			ПревышенаСумма = Ложь;
			Если ДанныеДоговора.ОграничиватьСуммуЗадолженности Тогда
				ОстатокДопустимогоКредита = ОстатокДопустимогоКредита(Договор, ДанныеДоговора.ДопустимаяСуммаЗадолженности);
				ПревышенаСумма = ОстатокДопустимогоКредита < 0;
			КонецЕсли;
			
			ПревышенСрок = Ложь;
			Если ДанныеДоговора.ЗапрещаетсяПросроченнаяЗадолженность Тогда
				СуммаПросроченнойЗадолженности = СуммаПросроченнойЗадолженности(Договор, Дата);
				ПревышенСрок = СуммаПросроченнойЗадолженности > 0;
			КонецЕсли;
			
			Если ПревышенаСумма ИЛИ ПревышенСрок Тогда
				ЭлементТекст.Заголовок = НСтр("ru='Отгрузка запрещена'");
				ЭлементТекст.ЦветТекста = WebЦвета.Кирпичный;
				ЭлементТекст.Видимость = Истина;
				ЭлементКартинка.Видимость = Истина;
			ИначеЕсли ДанныеДоговора.ОграничиватьСуммуЗадолженности Тогда
				ЭлементТекст.Заголовок = НСтр("ru='Остаток допустимого кредита:'") + " " + Формат(ОстатокДопустимогоКредита, "ЧДЦ=2; ЧН=0,00") + " " + Строка(ДанныеДоговора.ВалютаВзаиморасчетов);
				ЭлементТекст.ЦветТекста = ЦветаСтиля.ГиперссылкаЦвет;
				ЭлементТекст.Видимость = Истина;
				ЭлементКартинка.Видимость = Ложь;
			Иначе
				ЭлементТекст.Видимость = Ложь;
				ЭлементКартинка.Видимость = Ложь;
			КонецЕсли;
			
		Иначе
			
			ЭлементТекст.Видимость = Ложь;
			ЭлементКартинка.Видимость = Ложь;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает сумму просроченной задолженности по данным расчетов с клиентом
//
// Параметры:
//	Договор       - СправочникСсылка.ДоговорыКонтрагентов - Договор, по которому определяется задолженность клиента
//	ДатаДокумента - Дата - Дата документа, для которого выполняется контроль суммы просроченной задолженности.
//
// Возвращаемое значение:
//	Число
//
Функция СуммаПросроченнойЗадолженности(Договор, ДатаДокумента) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	РасчетыСКлиентамиОстатки.ДолгОстаток КАК ПросроченнаяЗадолженность
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам.Остатки(
		|		,
		|		АналитикаУчетаПоПартнерам В (
		|			ВЫБРАТЬ
		|				АналитикаПоПартнерам.КлючАналитики КАК КлючАналитики
		|			ИЗ
		|				РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
		|			ГДЕ
		|				АналитикаПоПартнерам.Договор = &Договор
		|			) И ДатаПлановогоПогашения < &ПериодКонтроляСрокаДолга
		|	) КАК РасчетыСКлиентамиОстатки
		|
		|ГДЕ
		|	РасчетыСКлиентамиОстатки.ДолгОстаток > 0
		|");
		Запрос.УстановитьПараметр("ПериодКонтроляСрокаДолга", НачалоДня(Макс(ТекущаяДатаСеанса(), ДатаДокумента)));
	Иначе
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ВЫБОР КОГДА РасчетыСКлиентамиОстатки.СуммаОстаток >
		|			РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток ТОГДА
		|		РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток
		|	ИНАЧЕ
		|		РасчетыСКлиентамиОстатки.СуммаОстаток
		|	КОНЕЦ), 0) КАК ПросроченнаяЗадолженность
		|
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами.Остатки(
		|		&ПериодКонтроляСрокаДолга,
		|		АналитикаУчетаПоПартнерам В (
		|			ВЫБРАТЬ
		|				АналитикаПоПартнерам.КлючАналитики КАК КлючАналитики
		|			ИЗ
		|				РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
		|			ГДЕ
		|				АналитикаПоПартнерам.Договор = &Договор
		|			)
		|	) КАК РасчетыСКлиентамиОстатки
		|
		|ГДЕ
		|	РасчетыСКлиентамиОстатки.СуммаОстаток > 0
		|	И (РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток) > 0
		|");
		Запрос.УстановитьПараметр("ПериодКонтроляСрокаДолга", Макс(КонецДня(ТекущаяДатаСеанса()), КонецДня(ДатаДокумента)));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Договор", Договор);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Если Выборка.Следующий() Тогда
		СуммаПросроченнойЗадолженности = Выборка.ПросроченнаяЗадолженность;
	Иначе
		СуммаПросроченнойЗадолженности = 0;
	КонецЕсли;
	
	Возврат СуммаПросроченнойЗадолженности;
	
КонецФункции

// Возвращает остаток допустимого кредита по данным расчетов с клиентом и допустимой суммы задолженности.
//
// Параметры:
//	Договор          - СправочникСсылка.ДоговорыКонтрагентов - Договор, по которому определяется задолженность клиента
//	ДопустимыйКредит - Число - Значение допустимой суммы задолженности.
//
// Возвращаемое значение:
//	Число
//
Функция ОстатокДопустимогоКредита(Договор, ДопустимыйКредит) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	РасчетыСКлиентамиОстатки.СуммаОстаток + РасчетыСКлиентамиОстатки.ОтгружаетсяОстаток КАК ОстатокДолга
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(
	|		,
	|		АналитикаУчетаПоПартнерам В (
	|			ВЫБРАТЬ
	|				АналитикаПоПартнерам.КлючАналитики КАК КлючАналитики
	|			ИЗ
	|				РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|			ГДЕ
	|				АналитикаПоПартнерам.Договор = &Договор
	|			)
	|	) КАК РасчетыСКлиентамиОстатки
	|");
	Запрос.УстановитьПараметр("Договор", Договор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ОстатокДопустимогоКредита = ДопустимыйКредит - Выборка.ОстатокДолга;
	Иначе
		ОстатокДопустимогоКредита = ДопустимыйКредит;
	КонецЕсли;
	
	Возврат ОстатокДопустимогоКредита;
	
КонецФункции

#КонецОбласти

#Область ОбъектыРасчетов

// Функция возвращает имя формы для открытия.
//
// Параметры:
//	Ключ - СправочникСсылка.ОбъектыРасчетов - Ссылка на элемент справочника Объекты расчетов.
//
// Возвращаемое значение:
//	Структура:
//	 * Форма - Строка - Полное имя формы.
//	 * Ключ - ОпределяемыйТип.ОбъектРасчетов - Ссылка на открываемый объект расчетов.
//
Функция ФормаОбъектаРасчетов(Ключ) Экспорт
	
	СсылкаНаОбъект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ключ, "Объект");
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
		
		Результат = Новый Структура();
		Результат.Вставить("Форма",ОбщегоНазначения.ИмяТаблицыПоСсылке(СсылкаНаОбъект) + ".Форма." + МетаданныеОбъекта.ОсновнаяФормаОбъекта.Имя);
		Результат.Вставить("Ключ",ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ключ, "Объект"));
	Иначе
		Результат = Новый Структура();
		Результат.Вставить("Форма","");
		Результат.Вставить("Ключ",Неопределено);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбъектРасчетовОснованиеПлатежаОбработкаПолученияДанныхВыбора(ДанныеВыбора, НастройкиПодбора, ЭтоУИП, ЭтоОбъектРасчетов) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Не ЭтоОбъектРасчетов Тогда
		ТипыОснований = Новый Массив;
		МетаданныеДокумента = НастройкиПодбора.РедактируемыйДокумент.Метаданные();
		Если МетаданныеДокумента <> Неопределено Тогда
			Если МетаданныеДокумента.ТабличныеЧасти.Найти("РасшифровкаПлатежа") = Неопределено Тогда
				ОписаниеТипов = МетаданныеДокумента.Реквизиты.ОснованиеПлатежа.Тип;
			Иначе
				ОписаниеТипов = МетаданныеДокумента.ТабличныеЧасти.РасшифровкаПлатежа.Реквизиты.ОснованиеПлатежа.Тип;
			КонецЕсли;
			ТипыОснований = ОписаниеТипов.Типы();
		КонецЕсли;
		НастройкиПодбора.Вставить("ТипыОснований", ТипыОснований);
	КонецЕсли;
	
	Если ЭтоОбъектРасчетов Тогда
		ВзаиморасчетыСервер.ЗаполнитьДанныеВыбораОбъектаРасчетов(
			ДанныеВыбора,
			НастройкиПодбора);
	ИначеЕсли ЭтоУИП Тогда
		ВзаиморасчетыСервер.ЗаполнитьДанныеВыбораУИП(
			ДанныеВыбора,
			НастройкиПодбора);
	Иначе
		ВзаиморасчетыСервер.ЗаполнитьДанныеВыбораОснованияПлатежа(
			ДанныеВыбора,
			НастройкиПодбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Отключает вопрос о переходе на новую архитектуру взаиморасчетов
//
Процедура ОтключитьВопросПереходаНаОнлайнВзаиморасчеты() Экспорт
	
	Константы.НеСпрашиватьПроПереходНаОнлайнВзаиморасчеты.Установить(Истина);
	
КонецПроцедуры

// Запускает распределение всех расчетов по текущим заданиям к распределению в регистре ЗаданияКРаспределениюРасчетов
// в фоновом задании.
Процедура ВключитьРаспределениеВзаиморасчетов() Экспорт
	
	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ОперативныеВзаиморасчетыСервер.ЗапуститьОтложенноеРаспределениеВзаиморасчетов(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Отключает распределение фактических расчетов при проведении документа 
// и включает запись заданий к распределению в регистр ЗаданияКРаспределениюРасчетов.
Процедура ОтключитьРаспределениеВзаиморасчетов() Экспорт

	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Константы.РаспределятьФактическиеРасчетыФоновымЗаданием.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
