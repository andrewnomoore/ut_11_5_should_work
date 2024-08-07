////////////////////////////////////////////////////////////////////////////////
// Подсистема "Коммерческие предложения", внедрение в УТ.
// ОбщийМодуль.КоммерческиеПредложенияДокументыУТВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция УсловияОплатыТекстом(ИсточникУсловийОплаты) Экспорт
	
	ДанныеУсловий = Новый Структура;
	ДанныеУсловий.Вставить("ФормаОплаты", Перечисления.ФормыОплаты.ПустаяСсылка());
	ДанныеУсловий.Вставить("ЭтапыОплаты", Новый ТаблицаЗначений);
	
	Если ТипЗнч(ИсточникУсловийОплаты) = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
		
		ПолучитьДанныеУсловийОплатыПоСоглашению(ИсточникУсловийОплаты, ДанныеУсловий);
		
	ИначеЕсли ТипЗнч(ИсточникУсловийОплаты) = Тип("СправочникСсылка.ГрафикиОплаты") Тогда
		
		ПолучитьДанныеУсловийОплатыПоГрафикуОплаты(ИсточникУсловийОплаты, ДанныеУсловий);
		
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	Если ЗначениеЗаполнено(ДанныеУсловий.ФормаОплаты) Тогда
		МассивСтрок.Добавить(СтрШаблон(НСтр("ru = 'Форма оплаты: %1.'"), Строка(ДанныеУсловий.ФормаОплаты)));
		МассивСтрок.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если ДанныеУсловий.ЭтапыОплаты.Количество() > 0 Тогда
		МассивСтрок.Добавить(НСтр("ru = 'Этапы оплаты:'"));
	КонецЕсли;
	
	Для Каждого ЭтапОплаты Из ДанныеУсловий.ЭтапыОплаты Цикл
		МассивСтрок.Добавить(Символы.ПС);
		МассивСтрок.Добавить(СтрШаблон(НСтр("ru = '%1, отсрочка (дн.) - %2, процент платежа - %3 %%'"),
		                               ЭтапОплаты.ВариантОплаты,
		                               ЭтапОплаты.Сдвиг,
		                               ЭтапОплаты.ПроцентПлатежа));
		МассивСтрок.Добавить(".");
	КонецЦикла;
		
	Возврат СтрСоединить(МассивСтрок);
	
КонецФункции

Функция ПредставлениеНоменклатурыДляПечати(Номенклатура, Характеристика) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредставлениеНоменклатурыДляПечати = "";
	ПредставлениеХарактеристикиДляПечати = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Номенклатура.Артикул КАК Артикул,
	|	Номенклатура.Код КАК Код,
	|	Номенклатура.НаименованиеПолное КАК НаименованиеПолное
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////1
	|ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.НаименованиеПолное КАК НаименованиеПолное
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Ссылка = &Характеристика";
	
	Запрос.УстановитьПараметр("Номенклатура",   Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);

	
	Результат = Запрос.ВыполнитьПакет(); // Массив из ВыборкаИзРезультатаЗапроса
	
	КолонкаКодов = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	ВыводитьКоды = Не ПустаяСтрока(КолонкаКодов);
	
	ВыборкаНоменклатура = Результат[0].Выбрать();
	Если ВыборкаНоменклатура.Следующий() Тогда
		
		Если ВыводитьКоды И Не ПустаяСтрока(ВыборкаНоменклатура[КолонкаКодов]) Тогда
			ПредставлениеНоменклатурыДляПечати = ВыборкаНоменклатура[КолонкаКодов] + ", " + ВыборкаНоменклатура.НаименованиеПолное;
		Иначе
			ПредставлениеНоменклатурыДляПечати = ВыборкаНоменклатура.НаименованиеПолное;			
		КонецЕсли;
	
	КонецЕсли;
	
	ВыборкаХарактеристика = Результат[1].Выбрать();
	Если ВыборкаХарактеристика.Следующий() Тогда
	
		ПредставлениеХарактеристикиДляПечати = ВыборкаХарактеристика.НаименованиеПолное;
	
	КонецЕсли;
	
	ДопПараметрыПредставлениеНоменклатуры = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	ДопПараметрыПредставлениеНоменклатуры.КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	
	Возврат НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(ПредставлениеНоменклатурыДляПечати, 
				ПредставлениеХарактеристикиДляПечати,
				,
				,
				ДопПараметрыПредставлениеНоменклатуры);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПолучитьДанныеУсловийОплатыПоСоглашению(Соглашение, ДанныеУсловий)
	
	ИспользоватьГрафикиОплаты = ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиОплаты");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	
	Если ИспользоватьГрафикиОплаты Тогда
		
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоглашенияСКлиентами.ГрафикОплаты КАК Ссылка
		|ПОМЕСТИТЬ ТребуемыйГрафикОплаты
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|ГДЕ
		|	СоглашенияСКлиентами.Ссылка = &Соглашение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////1
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрафикиОплаты.ФормаОплаты КАК ФормаОплаты
		|ИЗ
		|	Справочник.ГрафикиОплаты КАК ГрафикиОплаты
		|ГДЕ
		|	ГрафикиОплаты.Ссылка В
		|			(ВЫБРАТЬ
		|				ТребуемыйГрафикОплаты.Ссылка
		|			ИЗ
		|				ТребуемыйГрафикОплаты КАК ТребуемыйГрафикОплаты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////2
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрафикиОплатыЭтапы.ВариантОплаты  КАК ВариантОплаты,
		|	ГрафикиОплатыЭтапы.Сдвиг          КАК Сдвиг,
		|	ГрафикиОплатыЭтапы.ПроцентПлатежа КАК ПроцентПлатежа
		|ИЗ
		|	Справочник.ГрафикиОплаты.Этапы КАК ГрафикиОплатыЭтапы
		|ГДЕ
		|	ГрафикиОплатыЭтапы.Ссылка В
		|			(ВЫБРАТЬ
		|				ТребуемыйГрафикОплаты.Ссылка
		|			ИЗ
		|				ТребуемыйГрафикОплаты КАК ТребуемыйГрафикОплаты)";
		
		Результат = Запрос.ВыполнитьПакет();
		
		ВыборкаШапка       = Результат[1].Выбрать();
		ТаблицаЭтапыОплаты = Результат[2].Выгрузить();
		
	Иначе
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоглашенияСКлиентами.ФормаОплаты КАК ФормаОплаты
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|ГДЕ
		|	СоглашенияСКлиентами.Ссылка = &Соглашение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////1
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.ВариантОплаты КАК ВариантОплаты,
		|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.Сдвиг КАК Сдвиг,
		|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.ПроцентПлатежа КАК ПроцентПлатежа
		|ИЗ
		|	Справочник.СоглашенияСКлиентами.ЭтапыГрафикаОплаты КАК СоглашенияСКлиентамиЭтапыГрафикаОплаты
		|ГДЕ
		|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.Ссылка = &Соглашение";
		
		Результат = Запрос.ВыполнитьПакет();
		
		ВыборкаШапка       = Результат[0].Выбрать();
		ТаблицаЭтапыОплаты = Результат[1].Выгрузить();
		
	КонецЕсли;
	
	Если ВыборкаШапка.Следующий() Тогда
		
		ДанныеУсловий.ФормаОплаты = ВыборкаШапка.ФормаОплаты;
		
	КонецЕсли;
	
	ДанныеУсловий.ЭтапыОплаты = ТаблицаЭтапыОплаты;
	
КонецПроцедуры

Процедура ПолучитьДанныеУсловийОплатыПоГрафикуОплаты(График, ДанныеУсловий)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ГрафикиОплаты.ФормаОплаты КАК ФормаОплаты
	|ИЗ
	|	Справочник.ГрафикиОплаты КАК ГрафикиОплаты
	|ГДЕ
	|	ГрафикиОплаты.Ссылка = &График
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГрафикиОплатыЭтапы.ВариантОплаты  КАК ВариантОплаты,
	|	ГрафикиОплатыЭтапы.Сдвиг          КАК Сдвиг,
	|	ГрафикиОплатыЭтапы.ПроцентПлатежа КАК ПроцентПлатежа
	|ИЗ
	|	Справочник.ГрафикиОплаты.Этапы КАК ГрафикиОплатыЭтапы
	|ГДЕ
	|	ГрафикиОплатыЭтапы.Ссылка = &График
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГрафикиОплатыЭтапы.НомерСтроки";
	
	Запрос.УстановитьПараметр("График", График);
	
	Результат = Запрос.ВыполнитьПакет();
		
	ВыборкаШапка       = Результат[0].Выбрать();
	ТаблицаЭтапыОплаты = Результат[1].Выгрузить();
	
	Если ВыборкаШапка.Следующий() Тогда
		
		ДанныеУсловий.ФормаОплаты = ВыборкаШапка.ФормаОплаты;
		
	КонецЕсли;
	
	ДанныеУсловий.ЭтапыОплаты = ТаблицаЭтапыОплаты;
	
КонецПроцедуры

#КонецОбласти