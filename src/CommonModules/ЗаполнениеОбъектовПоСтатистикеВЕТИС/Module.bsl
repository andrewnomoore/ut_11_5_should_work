#Область ПрограммныйИнтерфейс

// Получает историю поля "Благополучие местности" по предыдущим трем документам "Исходящая транспортная операция ВетИС"
//   * Массив с элементом "Местность благополучна по заразным болезням животных", если не было документов
//   * Массив значений заполнения в иных случаях
// 
// Параметры:
//   Предприятие - СправочникСсылка.ПредприятияВЕТИС - грузоотправитель
// Возвращаемое значение:
//   Массив Из Строка - значения заполнения поля "Благополучие местности" в исходящей транспортной операции ВетИС
//     по предыдущим документам площадки
//
Функция БлагополучиеМестностиПоПредприятию(Предприятие) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 3
	|	ИсходящаяТранспортнаяОперацияВЕТИС.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Документы
	|ИЗ
	|	Документ.ИсходящаяТранспортнаяОперацияВЕТИС КАК ИсходящаяТранспортнаяОперацияВЕТИС
	|ГДЕ
	|	ИсходящаяТранспортнаяОперацияВЕТИС.Проведен
	|	И ИсходящаяТранспортнаяОперацияВЕТИС.ГрузоотправительПредприятие = &Предприятие
	|УПОРЯДОЧИТЬ ПО
	|	ИсходящаяТранспортнаяОперацияВЕТИС.Дата Убыв
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходящаяТранспортнаяОперацияВЕТИСТовары.БлагополучиеМестности             КАК БлагополучиеМестности,
	|	КОЛИЧЕСТВО(ИсходящаяТранспортнаяОперацияВЕТИСТовары.БлагополучиеМестности) КАК КоличествоВхождений
	|ИЗ
	|	Документы КАК Документы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Товары КАК
	|			ИсходящаяТранспортнаяОперацияВЕТИСТовары
	|		ПО Документы.Ссылка = ИсходящаяТранспортнаяОперацияВЕТИСТовары.Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ИсходящаяТранспортнаяОперацияВЕТИСТовары.БлагополучиеМестности
	|УПОРЯДОЧИТЬ ПО
	|	КоличествоВхождений Убыв";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.БлагополучиеМестности);
	КонецЦикла;
	
	Если Результат.Количество() = 0 Тогда
		Результат.Добавить(НСтр("ru='Местность благополучна по заразным болезням животных'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает историю поля "Цель" по предыдущим документам "Исходящая транспортная операция ВетИС" на текущего получателя 
//   по группе продукции. Ограничивает доступной продукцией.
// 
// Параметры:
//   Продукция                  - СправочникСсылка.ПродукцияВЕТИС             - продукция
//   НизкокачественнаяПродукция - Булево, Неопределено                        - признак низкокачественной продукции
//   ХозяйствующийСубъект       - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС - грузополучатель
//   КешированныеЗначения       - ДеревоЗначений, Неопределено                - кешированные значения допустимых целей
//
// Возвращаемое значение:
//   Массив Из СправочникСсылка.ЦелиВЕТИС - значения заполнения поля "Цель" в исходящей транспортной операции ВетИС
//     по предыдущим документам грузополучателя (либо все доступные цели)
//
Функция ЦелиПоПродукцииИПолучателю(Продукция, НизкокачественнаяПродукция, ХозяйствующийСубъект, КешированныеЗначения) Экспорт
	
	ДоступныеЦели = ДопустимыеЦелиВЕТИС.ДопустимыеЦелиПоПродукции(Продукция, КешированныеЗначения, НизкокачественнаяПродукция);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Продукция",            Продукция);
	Запрос.УстановитьПараметр("ХозяйствующийСубъект", ХозяйствующийСубъект);
	Запрос.УстановитьПараметр("ДоступныеЦели",        ДоступныеЦели);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПродукцияВЕТИС.Родитель КАК Родитель
	|ПОМЕСТИТЬ Группа
	|ИЗ
	|	Справочник.ПродукцияВЕТИС КАК ПродукцияВЕТИС
	|ГДЕ
	|	ПродукцияВЕТИС.Ссылка = &Продукция
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 3
	|	ТоварыДокумента.Ссылка      КАК Ссылка,
	|	ТоварыДокумента.Ссылка.Дата КАК Дата
	|ПОМЕСТИТЬ Документы
	|ИЗ
	|	Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Товары КАК ТоварыДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Группа КАК Группа
	|		ПО ТоварыДокумента.Продукция.Родитель = Группа.Родитель
	|ГДЕ
	|	ТоварыДокумента.Ссылка.ГрузополучательХозяйствующийСубъект = &ХозяйствующийСубъект
	|	И ТоварыДокумента.Ссылка.Проведен
	|	И ТоварыДокумента.Цель В (&ДоступныеЦели)
	|УПОРЯДОЧИТЬ ПО
	|	Дата Убыв
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходящаяТранспортнаяОперацияВЕТИСТовары.Цель КАК Цель,
	|	КОЛИЧЕСТВО(ИсходящаяТранспортнаяОперацияВЕТИСТовары.Цель) КАК КоличествоВхождений
	|ИЗ
	|	Документы КАК Документы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Товары КАК
	|			ИсходящаяТранспортнаяОперацияВЕТИСТовары
	|		ПО Документы.Ссылка = ИсходящаяТранспортнаяОперацияВЕТИСТовары.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Группа КАК Группа
	|		ПО ИсходящаяТранспортнаяОперацияВЕТИСТовары.Продукция.Родитель = Группа.Родитель
	|СГРУППИРОВАТЬ ПО
	|	ИсходящаяТранспортнаяОперацияВЕТИСТовары.Цель
	|УПОРЯДОЧИТЬ ПО
	|	КоличествоВхождений Убыв";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.Цель);
	КонецЦикла;
	
	Если Результат.Количество() = 0 Тогда
		Результат = ДоступныеЦели;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает историю поля "Скоропортящаяся продукция" по предыдущим документам "Производственная операция ВетИС"
//   по текущей продукции
//
// Параметры:
//   Продукция - Массив Из СправочникСсылка.ПродукцияВЕТИС - продукция
//
// Возвращаемое значение:
//   Массив Из СправочникСсылка.ПродукцияВЕТИС - скоропортящаяся продукции
//
Функция СкоропортящаясяПродукцияПоПродукции(Продукция) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Продукция", Продукция);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварыДокумента.Продукция             КАК Продукция,
	|	МАКСИМУМ(ТоварыДокумента.Ссылка.Дата) КАК Дата
	|ПОМЕСТИТЬ Документы
	|ИЗ
	|	Документ.ПроизводственнаяОперацияВЕТИС.Товары КАК ТоварыДокумента
	|ГДЕ
	|	ТоварыДокумента.Продукция В (&Продукция)
	|	И ТоварыДокумента.Ссылка.Проведен
	|СГРУППИРОВАТЬ ПО
	|	ТоварыДокумента.Продукция
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документы.Продукция КАК Продукция
	|ИЗ
	|	Документы КАК Документы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперацияВЕТИС.Товары КАК ТоварыДокумента
	|		ПО Документы.Дата = ТоварыДокумента.Ссылка.Дата
	|		И ТоварыДокумента.Ссылка.Проведен
	|		И Документы.Продукция = ТоварыДокумента.Продукция
	|		И ТоварыДокумента.СкоропортящаясяПродукция
	|СГРУППИРОВАТЬ ПО
	|	Документы.Продукция";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Продукция");
	
КонецФункции

// Получает историю полей "Экспертиза выполнена", "Ветеринарно-санитарная экспертиза" по предыдущим документам 
//   "Производственная операция ВетИС" по текущему пользователю
//
// Возвращаемое значение:
//   Структура, Неопределено - значения полей "ЭкспертизаВыполнена" и "ЭкспертизаРезультат" если они совпали 
//     в предыдущих документах
//
Функция ЭкспертизаПоПользователю() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ответственный", Пользователи.ТекущийПользователь());
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 3
	|	Документы.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Документы
	|ИЗ
	|	Документ.ПроизводственнаяОперацияВЕТИС КАК Документы
	|ГДЕ
	|	Документы.Проведен
	|	И Документы.Ответственный = &Ответственный
	|УПОРЯДОЧИТЬ ПО
	|	Документы.Дата Убыв
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыДокумента.ЭкспертизаРезультат КАК ЭкспертизаРезультат,
	|	ТоварыДокумента.ЭкспертизаВыполнена КАК ЭкспертизаВыполнена
	|ИЗ
	|	Документы КАК Документы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперацияВЕТИС.Товары КАК ТоварыДокумента
	|		ПО Документы.Ссылка = ТоварыДокумента.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Структура(
		"ЭкспертизаВыполнена, ЭкспертизаРезультат", Ложь, Перечисления.РезультатыЛабораторныхИсследованийВЕТИС.НеПодвергнутаВСЭ);
	
	Если Выборка.Количество() = 1 Тогда
		Если Выборка.Следующий() Тогда
			Если ЗначениеЗаполнено(Выборка.ЭкспертизаРезультат) Тогда
				Результат.ЭкспертизаРезультат = Выборка.ЭкспертизаРезультат;
			КонецЕсли;
			Результат.ЭкспертизаВыполнена = Выборка.ЭкспертизаВыполнена;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает упаковку ВетИС по продукции и уровню упаковки по предыдущим документам "Производственная операция ВетИС"
//
// Параметры:
//   ТаблицаУпаковок - ТаблицаЗначений:
//    * Продукция       - СправочникСсылка.ПродукцияВЕТИС - продукция (ключ поиска);
//    * УровеньУпаковки - ПеречислениеСсылка.УровниУпаковокВЕТИС - уровень упаковки (ключ поиска);
//    * ИдентификаторСтроки - Строка - идентификатор заполняемой строки;
//    * УпаковкаВЕТИС - СправочникСсылка.УпаковкиВЕТИС - заполняемая колонка.
Процедура УпаковкиВЕТИСПоПродукции(ТаблицаУпаковок) Экспорт
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаУпаковок", ТаблицаУпаковок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаУпаковок.Продукция КАК Продукция,
	|	ТаблицаУпаковок.УровеньУпаковки КАК УровеньУпаковки,
	|	ТаблицаУпаковок.ИдентификаторСтроки КАК ИдентификаторСтроки
	|	
	|ПОМЕСТИТЬ ВходящиеДанные
	|ИЗ
	|	&ТаблицаУпаковок КАК ТаблицаУпаковок
	|ИНДЕКСИРОВАТЬ ПО
	|	Продукция,
	|	УровеньУпаковки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВходящиеДанные.Продукция       КАК Продукция,
	|	ВходящиеДанные.УровеньУпаковки КАК УровеньУпаковки,
	|	Шапка.Дата                     КАК Дата,
	|	Упаковки.УпаковкаВЕТИС         КАК УпаковкаВЕТИС
	|ПОМЕСТИТЬ Статистика
	|ИЗ
	|	ВходящиеДанные КАК ВходящиеДанные
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперацияВЕТИС.Товары КАК ПроизводственнаяОперацияВЕТИСТовары
	|		ПО ПроизводственнаяОперацияВЕТИСТовары.Продукция = ВходящиеДанные.Продукция
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперацияВЕТИС КАК Шапка
	|		ПО ПроизводственнаяОперацияВЕТИСТовары.Ссылка = Шапка.Ссылка
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперацияВЕТИС.УпаковкиВЕТИС КАК Упаковки
	|		ПО Упаковки.УровеньУпаковки = ВходящиеДанные.УровеньУпаковки
	|		И Упаковки.Ссылка = ПроизводственнаяОперацияВЕТИСТовары.Ссылка
	|		И Упаковки.ИдентификаторСтрокиТовары = ПроизводственнаяОперацияВЕТИСТовары.ИдентификаторСтроки
	|ИНДЕКСИРОВАТЬ ПО
	|	Продукция,
	|	УровеньУпаковки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статистика.Продукция       КАК Продукция,
	|	Статистика.УровеньУпаковки КАК УровеньУпаковки,
	|	МАКСИМУМ(Статистика.Дата)  КАК Дата
	|ПОМЕСТИТЬ ДатыПредыдущихДокументов
	|ИЗ
	|	Статистика КАК Статистика
	|СГРУППИРОВАТЬ ПО
	|	Статистика.Продукция,
	|	Статистика.УровеньУпаковки
	|ИНДЕКСИРОВАТЬ ПО
	|	Продукция,
	|	УровеньУпаковки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВходящиеДанные.Продукция           КАК Продукция,
	|	ВходящиеДанные.УровеньУпаковки     КАК УровеньУпаковки,
	|	ВходящиеДанные.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	МАКСИМУМ(Статистика.УпаковкаВЕТИС) КАК УпаковкаВЕТИС
	|ИЗ
	|	ВходящиеДанные КАК ВходящиеДанные
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыПредыдущихДокументов КАК ДатыПредыдущихДокументов
	|		ПО ДатыПредыдущихДокументов.Продукция = ВходящиеДанные.Продукция
	|		И ДатыПредыдущихДокументов.УровеньУпаковки = ВходящиеДанные.УровеньУпаковки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Статистика КАК Статистика
	|		ПО ДатыПредыдущихДокументов.Продукция = Статистика.Продукция
	|		И ДатыПредыдущихДокументов.УровеньУпаковки = Статистика.УровеньУпаковки
	|		И ДатыПредыдущихДокументов.Дата = Статистика.Дата
	|СГРУППИРОВАТЬ ПО
	|	ВходящиеДанные.Продукция,
	|	ВходящиеДанные.УровеньУпаковки,
	|	ВходящиеДанные.ИдентификаторСтроки";
	
	ТаблицаУпаковок = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

// Получает срок годности продукции по предыдущим документам "Производственная операция ВетИС"
//
// Параметры:
//   Продукция - Массив Из СправочникСсылка.ПродукцияВЕТИС - продукция
//
// Возвращаемое значение:
//   Соответствие - сроки годности продукции по предыдущим документам:
//    * Ключ     - СправочникСсылка.ПродукцияВЕТИС - продукция
//    * Значение - Структура - точности заполнения даты производства и срока годности, срок годности в часах
//
Функция СрокГодностиПоПродукции(Продукция) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Продукция", Продукция);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварыДокумента.Продукция КАК Продукция,
	|	МАКСИМУМ(ТоварыДокумента.Ссылка.Дата) КАК Дата
	|ПОМЕСТИТЬ Документы
	|ИЗ
	|	Документ.ПроизводственнаяОперацияВЕТИС.Товары КАК ТоварыДокумента
	|ГДЕ
	|	ТоварыДокумента.Продукция В (&Продукция)
	|	И ТоварыДокумента.Ссылка.Проведен
	|СГРУППИРОВАТЬ ПО
	|	ТоварыДокумента.Продукция
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыДокумента.Продукция КАК Продукция,
	|	МАКСИМУМ(ТоварыДокумента.СрокГодностиТочностьЗаполнения) КАК СрокГодностиТочностьЗаполнения,
	|	МАКСИМУМ(ТоварыДокумента.ДатаПроизводстваТочностьЗаполнения) КАК ДатаПроизводстваТочностьЗаполнения,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ТоварыДокумента.СрокГодностиНачалоПериода = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА 0
	|		КОГДА ТоварыДокумента.ДатаПроизводстваНачалоПериода = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(ТоварыДокумента.ДатаПроизводстваНачалоПериода, ТоварыДокумента.СрокГодностиНачалоПериода, ЧАС)
	|	КОНЕЦ) КАК СрокГодности
	|ИЗ
	|	Документы КАК Документы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперацияВЕТИС.Товары КАК ТоварыДокумента
	|		ПО Документы.Дата = ТоварыДокумента.Ссылка.Дата
	|		И ТоварыДокумента.Ссылка.Проведен
	|		И Документы.Продукция = ТоварыДокумента.Продукция
	|СГРУППИРОВАТЬ ПО
	|	ТоварыДокумента.Продукция";
	
	Результат = Новый Соответствие;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.СрокГодности > 0 Тогда
			Результат.Вставить(Выборка.Продукция,
				Новый Структура("СрокГодностиТочностьЗаполнения, ДатаПроизводстваТочностьЗаполнения, СрокГодности",
					Выборка.СрокГодностиТочностьЗаполнения,
					Выборка.ДатаПроизводстваТочностьЗаполнения,
					Выборка.СрокГодности));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Получает срок годности продукции по журналу продукции ВетИС
//
// Параметры:
//   Продукция - Массив Из СправочникСсылка.ПродукцияВЕТИС - продукция
//
// Возвращаемое значение:
//   Соответствие - сроки годности продукции по предыдущим документам:
//    * Ключ     - СправочникСсылка.ПродукцияВЕТИС - продукция
//    * Значение - Структура - точности заполнения даты производства и срока годности, срок годности в часах
//
Функция СрокГодностиПоЗаписиЖурнала(Продукция) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Продукция", Продукция);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиПродукцииВЕТИС.Продукция КАК Продукция,
	|	ОстаткиПродукцииВЕТИС.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
	|ПОМЕСТИТЬ АктуальныеЗаписи
	|ИЗ
	|	РегистрСведений.ОстаткиПродукцииВЕТИС КАК ОстаткиПродукцииВЕТИС
	|ГДЕ
	|	ОстаткиПродукцииВЕТИС.Продукция В (&Продукция)
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиПродукцииВЕТИС.Продукция,
	|	ОстаткиПродукцииВЕТИС.ЗаписьСкладскогоЖурнала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктуальныеЗаписи.Продукция КАК Продукция,
	|	МАКСИМУМ(ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиТочностьЗаполнения) КАК СрокГодностиТочностьЗаполнения,
	|	МАКСИМУМ(ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваТочностьЗаполнения) КАК ДатаПроизводстваТочностьЗаполнения,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиНачалоПериода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА 0
	|		КОГДА ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваНачалоПериода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваНачалоПериода,
	|			ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиНачалоПериода, ЧАС)
	|	КОНЕЦ) КАК СрокГодности
	|ИЗ
	|	АктуальныеЗаписи КАК АктуальныеЗаписи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗаписиСкладскогоЖурналаВЕТИС КАК ЗаписиСкладскогоЖурналаВЕТИС
	|		ПО ЗаписиСкладскогоЖурналаВЕТИС.Ссылка = АктуальныеЗаписи.ЗаписьСкладскогоЖурнала
	|СГРУППИРОВАТЬ ПО
	|	АктуальныеЗаписи.Продукция
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиТочностьЗаполнения) = 1
	|	И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|		КОГДА ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиНачалоПериода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА 0
	|		КОГДА ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваНачалоПериода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваНачалоПериода,
	|			ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиНачалоПериода, ЧАС)
	|	КОНЕЦ) = 1";
	
	Результат = Новый Соответствие;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.СрокГодности > 0 Тогда
			Результат.Вставить(Выборка.Продукция, 
				Новый Структура("СрокГодности, ДатаПроизводстваТочностьЗаполнения, СрокГодностиТочностьЗаполнения",
					Выборка.СрокГодности,
					Выборка.ДатаПроизводстваТочностьЗаполнения,
					Выборка.СрокГодностиТочностьЗаполнения));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Получает перевозчика и способ хранения при перевозке по реквизитам транспортного средства
//   (при полном совпадении реквизитов с одной из предыдущих перевозок, последней по дате если их несколько)
//
// Параметры:
//   РеквизитыТранспортногоСредства - Структура - реквизиты транспортного средства маршрута:
//     * ТипТранспорта - ПеречислениеСсылка.ТипыТранспортаВЕТИС,
//     * ТранспортноеСредство - ОпределяемыйТип.ТранспортныеСредстваВЕТИС,
//     * НомерТранспортногоСредства - ОпределяемыйТип.СтрокаВЕТИС,
//     * НомерАвтомобильногоПрицепа - ОпределяемыйТип.СтрокаВЕТИС,
//     * НомерАвтомобильногоКонтейнера - ОпределяемыйТип.СтрокаВЕТИС.
//
// Возвращаемое значение:
//   Структура - перевозчик и способ хранения:
//    * СпособХранения     - ПеречислениеСсылка.СпособыХраненияПриТранспортировкеВЕТИС,
//    * ПеревозчикХозяйствующийСубъект - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС.
//
Функция РеквизитыПеревозкиПоТранспортномуСредству(РеквизитыТранспортногоСредства) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СпособХранения");
	Результат.Вставить("ПеревозчикХозяйствующийСубъект");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипТранспорта",                 РеквизитыТранспортногоСредства.ТипТранспорта);
	Запрос.УстановитьПараметр("ТранспортноеСредство",          РеквизитыТранспортногоСредства.ТранспортноеСредство);
	Запрос.УстановитьПараметр("НомерТранспортногоСредства",    РеквизитыТранспортногоСредства.НомерТранспортногоСредства);
	Запрос.УстановитьПараметр("НомерАвтомобильногоПрицепа",    РеквизитыТранспортногоСредства.НомерАвтомобильногоПрицепа);
	Запрос.УстановитьПараметр("НомерАвтомобильногоКонтейнера", РеквизитыТранспортногоСредства.НомерАвтомобильногоКонтейнера);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ИсходящаяТранспортнаяОперацияВЕТИСМаршрут.Ссылка.Дата) КАК Дата,
	|	1 КАК ВариантПоиска
	|ПОМЕСТИТЬ ДатыПеревозки
	|ИЗ
	|	Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Маршрут КАК ИсходящаяТранспортнаяОперацияВЕТИСМаршрут
	|ГДЕ
	|	ИсходящаяТранспортнаяОперацияВЕТИСМаршрут.ТипТранспорта = &ТипТранспорта
	|	И ИсходящаяТранспортнаяОперацияВЕТИСМаршрут.ТранспортноеСредство = &ТранспортноеСредство
	|	И ИсходящаяТранспортнаяОперацияВЕТИСМаршрут.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|	И ИсходящаяТранспортнаяОперацияВЕТИСМаршрут.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|	И ИсходящаяТранспортнаяОперацияВЕТИСМаршрут.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|	И ИсходящаяТранспортнаяОперацияВЕТИСМаршрут.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВходящаяТранспортнаяОперацияВЕТИСМаршрутВозврата.Ссылка.Дата),
	|	2
	|ИЗ
	|	Документ.ВходящаяТранспортнаяОперацияВЕТИС.МаршрутВозврата КАК ВходящаяТранспортнаяОперацияВЕТИСМаршрутВозврата
	|ГДЕ
	|	ВходящаяТранспортнаяОперацияВЕТИСМаршрутВозврата.ТипТранспорта = &ТипТранспорта
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрутВозврата.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрутВозврата.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрутВозврата.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрутВозврата.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВходящаяТранспортнаяОперацияВЕТИСМаршрут.Ссылка.Дата),
	|	3
	|ИЗ
	|	Документ.ВходящаяТранспортнаяОперацияВЕТИС.Маршрут КАК ВходящаяТранспортнаяОперацияВЕТИСМаршрут
	|ГДЕ
	|	ВходящаяТранспортнаяОперацияВЕТИСМаршрут.ТипТранспорта = &ТипТранспорта
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрут.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрут.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрут.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|	И ВходящаяТранспортнаяОперацияВЕТИСМаршрут.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВходящаяТранспортнаяОперацияВЕТИС.Дата),
	|	4
	|ИЗ
	|	Документ.ВходящаяТранспортнаяОперацияВЕТИС КАК ВходящаяТранспортнаяОперацияВЕТИС
	|ГДЕ
	|	ВходящаяТранспортнаяОперацияВЕТИС.ТипТранспорта = &ТипТранспорта
	|	И ВходящаяТранспортнаяОперацияВЕТИС.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|	И ВходящаяТранспортнаяОперацияВЕТИС.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|	И ВходящаяТранспортнаяОперацияВЕТИС.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|	И ВходящаяТранспортнаяОперацияВЕТИС.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ДатыПеревозки.Дата) КАК Дата
	|ПОМЕСТИТЬ МаксимальнаяДатаПеревозки
	|ИЗ
	|	ДатыПеревозки КАК ДатыПеревозки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыПеревозки.Дата,
	|	МИНИМУМ(ДатыПеревозки.ВариантПоиска) КАК ВариантПоиска
	|ПОМЕСТИТЬ ПредыдущаяПеревозка
	|ИЗ
	|	МаксимальнаяДатаПеревозки КАК МаксимальнаяДатаПеревозки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДатыПеревозки КАК ДатыПеревозки
	|		ПО ДатыПеревозки.Дата = МаксимальнаяДатаПеревозки.Дата
	|СГРУППИРОВАТЬ ПО
	|	ДатыПеревозки.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Маршрут.Ссылка.СпособХранения КАК СпособХранения,
	|	Маршрут.Ссылка.ПеревозчикХозяйствующийСубъект КАК ПеревозчикХозяйствующийСубъект
	|ИЗ
	|	ПредыдущаяПеревозка КАК ПредыдущаяПеревозка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Маршрут КАК Маршрут
	|		ПО ПредыдущаяПеревозка.ВариантПоиска = 1
	|		И ПредыдущаяПеревозка.Дата = Маршрут.Ссылка.Дата
	|		И Маршрут.ТипТранспорта = &ТипТранспорта
	|		И Маршрут.ТранспортноеСредство = &ТранспортноеСредство
	|		И Маршрут.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|		И Маршрут.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|		И Маршрут.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|		И Маршрут.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Маршрут.Ссылка.СпособХранения,
	|	Маршрут.Ссылка.ПеревозчикХозяйствующийСубъект
	|ИЗ
	|	ПредыдущаяПеревозка КАК ПредыдущаяПеревозка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВходящаяТранспортнаяОперацияВЕТИС.МаршрутВозврата КАК Маршрут
	|		ПО ПредыдущаяПеревозка.ВариантПоиска = 2
	|		И ПредыдущаяПеревозка.Дата = Маршрут.Ссылка.Дата
	|		И Маршрут.ТипТранспорта = &ТипТранспорта
	|		И Маршрут.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|		И Маршрут.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|		И Маршрут.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|		И Маршрут.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Маршрут.Ссылка.СпособХранения,
	|	Маршрут.Ссылка.ПеревозчикХозяйствующийСубъект
	|ИЗ
	|	ПредыдущаяПеревозка КАК ПредыдущаяПеревозка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВходящаяТранспортнаяОперацияВЕТИС.Маршрут КАК Маршрут
	|		ПО ПредыдущаяПеревозка.ВариантПоиска = 3
	|		И ПредыдущаяПеревозка.Дата = Маршрут.Ссылка.Дата
	|		И Маршрут.ТипТранспорта = &ТипТранспорта
	|		И Маршрут.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|		И Маршрут.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|		И Маршрут.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|		И Маршрут.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МаршрутШапка.СпособХранения,
	|	МаршрутШапка.ПеревозчикХозяйствующийСубъект
	|ИЗ
	|	ПредыдущаяПеревозка КАК ПредыдущаяПеревозка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВходящаяТранспортнаяОперацияВЕТИС КАК МаршрутШапка
	|		ПО ПредыдущаяПеревозка.ВариантПоиска = 4
	|		И ПредыдущаяПеревозка.Дата = МаршрутШапка.Дата
	|		И МаршрутШапка.ТипТранспорта = &ТипТранспорта
	|		И МаршрутШапка.НомерТранспортногоСредства = &НомерТранспортногоСредства
	|		И МаршрутШапка.НомерАвтомобильногоПрицепа = &НомерАвтомобильногоПрицепа
	|		И МаршрутШапка.НомерАвтомобильногоКонтейнера = &НомерАвтомобильногоКонтейнера
	|		И МаршрутШапка.Проведен";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти