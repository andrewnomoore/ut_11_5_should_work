
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет регистр вспомогательной информации по изменениям оперативных регистров расчетов.
// 
// Параметры:
// 	МенеджерВТ - МенеджерВременныхТаблиц - Менеджер, содержащий таблицу с изменениями.
// 	ЭтоРасчетыСКлиентами - Булево - это расчеты с клиентами.
Процедура ЗаполнитьВспомогательнуюИнформацию(МенеджерВТ, ЭтоРасчетыСКлиентами = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР КОГДА Изменения.РасчетныйДокумент ССЫЛКА Документ.ПервичныйДокумент
	|						И Изменения.РасчетныйДокумент <> ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|		ТОГДА Изменения.РасчетныйДокумент
	|		ИНАЧЕ Изменения.Документ
	|	КОНЕЦ                                           КАК РасчетныйДокумент,
	|	НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Изменения.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1) ИЛИ Изменения.Сторно
	|							ТОГДА Изменения.ДатаРегистратора
	|						ИНАЧЕ Изменения.ДатаПлатежа
	|					КОНЕЦ , ДЕНЬ)      КАК ДатаПлановогоПогашения
	|ПОМЕСТИТЬ ИзмененияВспомогательнойИнформации
	|ИЗ
	|	&РасчетыИзменения КАК Изменения
	|ГДЕ
	|	Изменения.Сумма <> 0 ИЛИ Изменения.КОтгрузке <> 0 ИЛИ Изменения.КОплате <> 0
	|;
	|ВЫБРАТЬ
	|	Изменения.РасчетныйДокумент                                            КАК РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения                                       КАК ДатаПлановогоПогашения,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.Регистратор, Неопределено))                    КАК ДокументРегистратор,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СвязанныйДокумент, Неопределено))             КАК СвязанныйДокумент,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокОперации, Неопределено))                КАК ПорядокОперации,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокЗачетаПоДатеПлатежа, Неопределено))     КАК ПорядокЗачета,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ВалютаДокумента, Неопределено))                КАК ВалютаДокумента,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СтатьяДвиженияДенежныхСредств, Неопределено)) КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	ИзмененияВспомогательнойИнформации КАК Изменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ &Расчеты КАК Расчеты
	|			ПО Изменения.РасчетныйДокумент = Расчеты.Регистратор
	|				И Изменения.ДатаПлановогоПогашения = НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1) ИЛИ Расчеты.Сторно
	|																		ТОГДА Расчеты.ДатаРегистратора
	|																	ИНАЧЕ Расчеты.ДатаПлатежа
	|																КОНЕЦ , ДЕНЬ)
	|				И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КОтгрузке <> 0 ИЛИ Расчеты.КОплате <> 0)
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Изменения.РасчетныйДокумент) <> ТИП(Документ.ПервичныйДокумент)
	|СГРУППИРОВАТЬ ПО
	|	Изменения.РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Изменения.РасчетныйДокумент                                            КАК РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения                                       КАК ДатаПлановогоПогашения,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.Регистратор, Неопределено))                    КАК ДокументРегистратор,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СвязанныйДокумент, Неопределено))             КАК СвязанныйДокумент,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокОперации, Неопределено))                КАК ПорядокОперации,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ПорядокЗачетаПоДатеПлатежа, Неопределено))     КАК ПорядокЗачета,
	|	МИНИМУМ(ЕСТЬNULL(Расчеты.ВалютаДокумента, Неопределено))                КАК ВалютаДокумента,
	|	МАКСИМУМ(ЕСТЬNULL(Расчеты.СтатьяДвиженияДенежныхСредств, Неопределено)) КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	ИзмененияВспомогательнойИнформации КАК Изменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ &Расчеты КАК Расчеты
	|			ПО Изменения.РасчетныйДокумент = Расчеты.РасчетныйДокумент
	|				И Изменения.ДатаПлановогоПогашения = НАЧАЛОПЕРИОДА(ВЫБОР КОГДА Расчеты.ДатаПлатежа = ДАТАВРЕМЯ(1,1,1) ИЛИ Расчеты.Сторно
	|																		ТОГДА Расчеты.ДатаРегистратора
	|																	ИНАЧЕ Расчеты.ДатаПлатежа
	|																КОНЕЦ , ДЕНЬ)
	|				И (Расчеты.Сумма <> 0 ИЛИ Расчеты.КОтгрузке <> 0 ИЛИ Расчеты.КОплате <> 0)
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Изменения.РасчетныйДокумент) = ТИП(Документ.ПервичныйДокумент)
	|СГРУППИРОВАТЬ ПО
	|	Изменения.РасчетныйДокумент,
	|	Изменения.ДатаПлановогоПогашения
	|;
	|УНИЧТОЖИТЬ ИзмененияВспомогательнойИнформации";
	Если ЭтоРасчетыСКлиентами Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&РасчетыИзменения","РасчетыСКлиентамиИзменения");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&Расчеты","РегистрНакопления.РасчетыСКлиентами");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&РасчетыИзменения","РасчетыСПоставщикамиИзменения");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&Расчеты","РегистрНакопления.РасчетыСПоставщиками");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"КОтгрузке","КПоступлению");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.РасчетныйДокумент.Установить(Выборка.РасчетныйДокумент);
		НаборЗаписей.Отбор.ДатаПлановогоПогашения.Установить(Выборка.ДатаПлановогоПогашения);
		Если Выборка.ДокументРегистратор <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		КонецЕсли;
		НаборЗаписей.Записать();
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
