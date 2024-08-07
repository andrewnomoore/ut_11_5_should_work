
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	
	ЗаполнитьСписокРаспоряжений();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.СписокРаспоряжений.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.СписокРаспоряжений) Тогда
		Закрыть(Элементы.СписокРаспоряжений.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()
	
	Обработчик = Документы.ПередачаТоваровХранителю.ОбработчикДействий(Параметры.ХозяйственнаяОперация);
	
	ТекстыЗапроса = Новый Массив;
	
	ПараметрыТекстаЗапроса = ОбщегоНазначенияУТ.ПараметрыТекстаЗапросаРаспоряженийНакладных();
	ПараметрыТекстаЗапроса.СформироватьВТ = Истина;
	ПараметрыТекстаЗапроса.ИмяВТ = "РаспоряженияНакладной";
	
	ТекстыЗапроса.Добавить(Обработчик.ТекстЗапросаРаспоряженияНакладной(ПараметрыТекстаЗапроса));
	ТекстыЗапроса.Добавить(Документы.ПередачаТоваровХранителю.ТекстЗапросаОстаткиТоваровКОформлению("ТоварыКОформлению"));
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТоварыКОформлению.Распоряжение КАК Распоряжение,
	|	ТоварыКОформлению.Склад        КАК Склад
	|ПОМЕСТИТЬ РаспоряженияКОформлению
	|ИЗ
	|	ТоварыКОформлению КАК ТоварыКОформлению
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОформлению.Распоряжение,
	|	ТоварыКОформлению.Склад
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Распоряжение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаспоряженияКОформлению.Распоряжение              КАК Ссылка,
	|	ТИПЗНАЧЕНИЯ(РаспоряженияКОформлению.Распоряжение) КАК ТипРаспоряжения,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(РаспоряженияКОформлению.Распоряжение) = ТИП(Документ.ЗаказКлиента)
	|			ТОГДА ВЫРАЗИТЬ(РаспоряженияКОформлению.Распоряжение КАК Документ.ЗаказКлиента).Приоритет
	|	КОНЕЦ                                             КАК Приоритет,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(РаспоряженияКОформлению.Распоряжение) = ТИП(Документ.ЗаказКлиента)
	|			И ВЫРАЗИТЬ(РаспоряженияКОформлению.Распоряжение КАК Документ.ЗаказКлиента).Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА ТИПЗНАЧЕНИЯ(РаспоряженияКОформлению.Распоряжение) = ТИП(Документ.ЗаказКлиента)
	|			И ВЫРАЗИТЬ(РаспоряженияКОформлению.Распоряжение КАК Документ.ЗаказКлиента).Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ                                             КАК КартинкаПриоритета,
	|	РеестрДокументов.ДатаДокументаИБ                  КАК Дата,
	|	РеестрДокументов.НомерДокументаИБ                 КАК Номер,
	|	РеестрДокументов.Статус                           КАК Статус,
	|	РеестрДокументов.Партнер                          КАК Партнер,
	|	РеестрДокументов.Контрагент.Ключ                  КАК Контрагент,
	|	ВЫРАЗИТЬ(РаспоряженияКОформлению.Распоряжение КАК Документ.ЗаказКлиента).Соглашение КАК Соглашение,
	|	РеестрДокументов.Организация                      КАК Организация,
	|	РеестрДокументов.Договор                          КАК Договор,
	|	РаспоряженияКОформлению.Склад                     КАК Склад,
	|	РеестрДокументов.Валюта                           КАК Валюта,
	|	РеестрДокументов.Ответственный                    КАК Менеджер,
	|	РеестрДокументов.Комментарий                      КАК Комментарий,
	|	РеестрДокументов.Сумма                            КАК СуммаДокумента
	|ИЗ
	|	РаспоряженияКОформлению КАК РаспоряженияКОформлению
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|	ПО РеестрДокументов.Ссылка = РаспоряженияКОформлению.Распоряжение
	|	И НЕ РеестрДокументов.ДополнительнаяЗапись
	|";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Запрос.УстановитьПараметр("Регистратор",				Параметры.Регистратор);
	Запрос.УстановитьПараметр("Партнер",					Параметры.Отбор.Партнер);
	Запрос.УстановитьПараметр("Контрагент",					Параметры.Отбор.Контрагент);
	Запрос.УстановитьПараметр("Соглашение",					Параметры.Отбор.Соглашение);
	Запрос.УстановитьПараметр("Организация",				Параметры.Отбор.Организация);
	Запрос.УстановитьПараметр("Договор",					Параметры.Отбор.Договор);
	Запрос.УстановитьПараметр("Склад",						Параметры.Склад);
	Запрос.УстановитьПараметр("Валюта",						Параметры.Отбор.Валюта);
	Запрос.УстановитьПараметр("Сделка",						Параметры.Отбор.Сделка);
	Запрос.УстановитьПараметр("НаправлениеДеятельности",	Параметры.Отбор.НаправлениеДеятельности);
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару",	Параметры.Отбор.ВернутьМногооборотнуюТару);
	
	Результат = Запрос.Выполнить();
	
	СписокРаспоряжений.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

