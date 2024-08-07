#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());

	// Обновим элементы справочника НаборыДополнительныхРеквизитовИСведений и ПВХ ДополнительныеРеквизитыИСведения. 
	ОбновитьПоляДополнительныхСвойств(ЭтотОбъект, "Справочник_Инциденты");

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
		НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Адаптированный вариант УправлениеСвойствами.ПередЗаписьюВидаОбъекта()
//
// Параметры:
//  ВидИнцидента - СправочникОбъект.ВидыИнцидентов
//  ИмяОбъектаСоСвойствами - Строка - Имя объекта со свойствами
//  ИмяРеквизитаНабораСвойств - Строка - Имя реквизита набора свойств
//  ОкончаниеНаименования - Строка - Окончание наименования
//  НуженНаборСвойств - Булево - Нужен набор свойств
Процедура ОбновитьПоляДополнительныхСвойств(ВидИнцидента,
                                  ИмяОбъектаСоСвойствами,
                                  НуженНаборСвойств = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборСвойств   = ВидИнцидента["НаборСвойств"];
	РодительНабора = УправлениеСвойствами.НаборСвойствПоИмени(ИмяОбъектаСоСвойствами);
	
	// Обновлений наименований набора свойств
	Если ЗначениеЗаполнено(НаборСвойств) Тогда
		
		СтарыеСвойстваНабора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			НаборСвойств, "Наименование, Родитель, ПометкаУдаления");
		
		Если СтарыеСвойстваНабора.Наименование    = ВидИнцидента.Наименование
		   И СтарыеСвойстваНабора.ПометкаУдаления = ВидИнцидента.ПометкаУдаления
		   И СтарыеСвойстваНабора.Родитель        = РодительНабора Тогда
			
			Возврат;
		КонецЕсли;
		
		Если СтарыеСвойстваНабора.Родитель = РодительНабора Тогда
			ЗаблокироватьДанныеДляРедактирования(НаборСвойств);
			НаборСвойствОбъект = НаборСвойств.ПолучитьОбъект();
		Иначе
			НаборСвойствОбъект = НаборСвойств.Скопировать();
		КонецЕсли;
		
	ИначеЕсли НуженНаборСвойств Тогда
		НаборСвойствОбъект = Справочники.НаборыДополнительныхРеквизитовИСведений.СоздатьЭлемент();
		НаборСвойствОбъект.Используется = Истина;
	Иначе
		НаборСвойствОбъект = Неопределено;
	КонецЕсли;
	
	Если НаборСвойствОбъект <> Неопределено Тогда 
		НаборСвойствОбъект.Наименование    = ВидИнцидента.Наименование;
		НаборСвойствОбъект.ПометкаУдаления = ?(НуженНаборСвойств, ВидИнцидента.ПометкаУдаления, Истина);;
		НаборСвойствОбъект.Родитель        = РодительНабора;
		НаборСвойствОбъект.Записать();
	КонецЕсли;
	
	ВидИнцидента["НаборСвойств"] = ?(НуженНаборСвойств, НаборСвойствОбъект.Ссылка, Неопределено);
	
	// Обновление наименований необщих дополнительных реквизитов и сведений.
	Если Не ЗначениеЗаполнено(НаборСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	ИзмененныеНаименования = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаборСвойств", НаборСвойств);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Свойства.Ссылка КАК Ссылка,
	|	Свойства.НаборСвойств.Наименование КАК НаименованиеНабора,
	|	Свойства.НаборСвойств.ПометкаУдаления КАК ПометкаУдаленияНабора,
	|	Свойства.ЭтоДополнительноеСведение
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК Свойства
	|ГДЕ
	|	Свойства.НаборСвойств = &НаборСвойств
	|	И ВЫБОР
	|			КОГДА Свойства.Наименование <> Свойства.Заголовок + "" ("" + Свойства.НаборСвойств.Наименование + "")""
	|				ТОГДА ИСТИНА
	|			КОГДА Свойства.ПометкаУдаления <> Свойства.НаборСвойств.ПометкаУдаления
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ";
	
	ВыборкаСвойств = Запрос.Выполнить().Выбрать();
	Пока ВыборкаСвойств.Следующий() Цикл
		
		ЗаблокироватьДанныеДляРедактирования(ВыборкаСвойств.Ссылка);
		
		Объект = ВыборкаСвойств.Ссылка.ПолучитьОбъект(); // ПланВидовХарактеристикОбъект.ДополнительныеРеквизитыИСведения
		
		СтароеНаименование = Объект.Наименование;
		Объект.Наименование = Объект.Заголовок + " (" + Строка(ВыборкаСвойств.НаименованиеНабора) + ")";
		Объект.ПометкаУдаления = ВыборкаСвойств.ПометкаУдаленияНабора;
		
		Объект.ДополнительныеСвойства.Вставить("НеОбновлятьШаблоныНаименований");
		Объект.Записать();
		
		Если НЕ ВыборкаСвойств.ЭтоДополнительноеСведение Тогда
			ИзмененныеНаименования.Вставить(
				"[" + СтароеНаименование + "]", "[" + Объект.Наименование + "]");
		КонецЕсли;
		
	КонецЦикла;
	
	// Переименование в шаблонах наименований
	Если ИзмененныеНаименования.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
