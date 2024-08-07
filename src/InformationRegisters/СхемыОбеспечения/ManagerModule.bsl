#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Предназначена для получения текста запроса временной таблицы "ВтСпособыОбеспечения",
// содержащей основной способ обеспечения для списка товаров и складов.
//
// Параметры:
//  ФорматыСкладов - Строка - если значение параметра "ВЫЧИСЛЯТЬ", то будет создана временная таблица "ВтФорматыСкладов",
//                            иначе считается что на момент исполнения запроса эта таблица уже существует.
//
// Возвращаемое значение:
//  Строка - текст запроса запроса временной таблицы ВтСпособыОбеспечения".
//
Функция ВременнаяТаблицаСпособыОбеспечения(ФорматыСкладов) Экспорт
	
	ТекстЗапроса = "";
	Если ФорматыСкладов = "ВЫЧИСЛЯТЬ" Тогда
		
		ТекстЗапроса = Справочники.ФорматыМагазинов.ТекстЗапросаВтФорматыСкладов();
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТоварнаяМатрица.Номенклатура   КАК Номенклатура,
	|	ТоварнаяМатрица.Характеристика КАК Характеристика,
	|	ТоварнаяМатрица.Склад          КАК Склад,
	|	
	|	ЕСТЬNULL(СпрСпособ.Ссылка, ЗНАЧЕНИЕ(Справочник.СпособыОбеспеченияПотребностей.ПустаяСсылка)) КАК СпособОбеспеченияПотребностей,
	|	ВЫБОР ЕСТЬNULL(СпрСпособ.ТипОбеспечения, ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.ПустаяСсылка))
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.Производство)
	|			ТОГДА 1
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.СборкаРазборка)
	|			ТОГДА 2
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.ПроизводствоНаСтороне)
	|			ТОГДА 3
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.Покупка)
	|			ТОГДА 4
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.Перемещение)
	|			ТОГДА 5
	|		ИНАЧЕ 9999
	|	КОНЕЦ КАК ПриоритетТипаОбеспечения,
	|	
	|	ВЫБОР КОГДА СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
	|		
	|			СпрНоменклатура.СпособОбеспеченияПотребностей
	|			
	|		ИНАЧЕ
	|			
	|			ЕСТЬNULL(ТаблицаСхемыОбеспеченияСкладов.СпособОбеспеченияПотребностей,
	|					ЕСТЬNULL(ТаблицаСхемыОбеспеченияФорматов.СпособОбеспеченияПотребностей,
	|						ЗНАЧЕНИЕ(Справочник.СпособыОбеспеченияПотребностей.ПустаяСсылка)))
	|			
	|		КОНЕЦ                      КАК СпособОбеспеченияПотребностейУнаследованный,
	|		
	|	ВЫБОР КОГДА НЕ ТаблицаВариантыОбеспеченияТоварами.Номенклатура ЕСТЬ NULL ИЛИ НЕ ТаблицаВариантыОбеспеченияРаботами.Номенклатура ЕСТЬ NULL ТОГДА
	|				
	|				""НоменклатураХарактеристикаСклад""
	|				
	|			КОГДА СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
	|				
	|				""Номенклатура""
	|				
	|			ИНАЧЕ
	|				
	|				""СхемаОбеспечения""
	|				
	|		КОНЕЦ КАК ИсточникНастройки
	|	
	|ПОМЕСТИТЬ ВтСпособыОбеспечения
	|ИЗ
	|	ВтТовары КАК ТоварнаяМатрица
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО СпрНоменклатура.Ссылка = ТоварнаяМатрица.Номенклатура
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияРаботами КАК ТаблицаВариантыОбеспеченияРаботами
	|		ПО СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|		 И ТаблицаВариантыОбеспеченияРаботами.Номенклатура   = ТоварнаяМатрица.Номенклатура
	|		 И ТаблицаВариантыОбеспеченияРаботами.Характеристика = ТоварнаяМатрица.Характеристика
	|		 И ТаблицаВариантыОбеспеченияРаботами.РеквизитДопУпорядочивания = 1
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияТоварами КАК ТаблицаВариантыОбеспеченияТоварами
	|		ПО СпрНоменклатура.ТипНоменклатуры В(
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара),
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Набор))
	|		 И ТаблицаВариантыОбеспеченияТоварами.Номенклатура   = ТоварнаяМатрица.Номенклатура
	|		 И ТаблицаВариантыОбеспеченияТоварами.Характеристика = ТоварнаяМатрица.Характеристика
	|		 И ТаблицаВариантыОбеспеченияТоварами.Склад          = ТоварнаяМатрица.Склад
	|		 И ТаблицаВариантыОбеспеченияТоварами.РеквизитДопУпорядочивания = 1
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтФорматыСкладов КАК ТаблицаФорматыСкладов
	|		ПО ТаблицаФорматыСкладов.Склад = ТоварнаяМатрица.Склад
	|		 И ТаблицаВариантыОбеспеченияТоварами.Номенклатура ЕСТЬ NULL
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК ТаблицаСхемыОбеспеченияСкладов
	|		ПО ТаблицаСхемыОбеспеченияСкладов.СхемаОбеспечения = СпрНоменклатура.СхемаОбеспечения
	|		 И ТаблицаСхемыОбеспеченияСкладов.Склад = ТоварнаяМатрица.Склад
	|		 И ТаблицаВариантыОбеспеченияТоварами.Номенклатура ЕСТЬ NULL
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК ТаблицаСхемыОбеспеченияФорматов
	|		ПО ТаблицаСхемыОбеспеченияФорматов.СхемаОбеспечения = СпрНоменклатура.СхемаОбеспечения
	|		 И ТаблицаСхемыОбеспеченияФорматов.Склад = ТаблицаФорматыСкладов.ФорматМагазина
	|		 И ТаблицаСхемыОбеспеченияСкладов.СхемаОбеспечения ЕСТЬ NULL
	|		 И ТаблицаВариантыОбеспеченияТоварами.Номенклатура ЕСТЬ NULL
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СпрСпособ
	|		ПО ВЫБОР КОГДА СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
	|						
	|						ЕСТЬNULL(ТаблицаВариантыОбеспеченияРаботами.СпособОбеспеченияПотребностей,
	|							СпрНоменклатура.СпособОбеспеченияПотребностей)
	|						
	|					ИНАЧЕ
	|						
	|						ЕСТЬNULL(ТаблицаВариантыОбеспеченияТоварами.СпособОбеспеченияПотребностей,
	|							ЕСТЬNULL(ТаблицаСхемыОбеспеченияСкладов.СпособОбеспеченияПотребностей,
	|								ЕСТЬNULL(ТаблицаСхемыОбеспеченияФорматов.СпособОбеспеченияПотребностей,
	|									ЗНАЧЕНИЕ(Справочник.СпособыОбеспеченияПотребностей.ПустаяСсылка))))
	|						
	|				КОНЕЦ = СпрСпособ.Ссылка
	|		
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура, Характеристика, Склад
	|;
	|
	|////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Предназначена для получения текста запроса временной таблицы "ВтСпособыОбеспечения",
// содержащей основной способ обеспечения на всех складах для списка товаров.
//
// Параметры:
//  ТипОбеспечения - ПеречислениеСсылка.ТипыОбеспечения - если установлено значение типа обеспечения "Перемещение",
//                                                        то результат будет содержать только товары и склады с основным
//                                                        способом обеспечения путем перемещения.
//  ЕстьТаблицаФорматыСкладов - Булево - истина, если таблица ВтФормыСкладов уже сформирована ранее.
//
// Возвращаемое значение:
//  Строка - текст запроса запроса временной таблицы ВтСпособыОбеспечения".
//
Функция ВременнаяТаблицаСпособыОбеспеченияВсехСкладов(ТипОбеспечения = Неопределено, ЕстьТаблицаФорматыСкладов = Ложь) Экспорт
	
	ТекстЗапроса = "";
	Если Не ЕстьТаблицаФорматыСкладов Тогда
		ТекстЗапроса = Справочники.ФорматыМагазинов.ТекстЗапросаВтФорматыСкладов(Ложь);
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Набор.Номенклатура   КАК Номенклатура,
		|	Набор.Характеристика КАК Характеристика,
		|	Набор.Склад          КАК Склад,
		|	Набор.СпособОбеспеченияПотребностей КАК СпособОбеспеченияПотребностей
		|ПОМЕСТИТЬ ВтСпособыОбеспечения
		|ИЗ(
		|	ВЫБРАТЬ
		|		ТоварнаяМатрица.Номенклатура   КАК Номенклатура,
		|		ТоварнаяМатрица.Характеристика КАК Характеристика,
		|		
		|		Настройка.Склад                         КАК Склад,
		|		Настройка.СпособОбеспеченияПотребностей КАК СпособОбеспеченияПотребностей
		|	ИЗ
		|		ВтТовары КАК ТоварнаяМатрица
		|			
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияТоварами КАК Настройка
		|			ПО Настройка.Номенклатура   = ТоварнаяМатрица.Номенклатура
		|			 И Настройка.Характеристика = ТоварнаяМатрица.Характеристика
		|			 И Настройка.РеквизитДопУпорядочивания = 1
		|	ГДЕ
		|		НЕ Настройка.Склад ЕСТЬ NULL
		|		И &Отборы
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварнаяМатрица.Номенклатура   КАК Номенклатура,
		|		ТоварнаяМатрица.Характеристика КАК Характеристика,
		|		
		|		Настройка.Склад                         КАК Склад,
		|		Настройка.СпособОбеспеченияПотребностей КАК СпособОбеспеченияПотребностей
		|	ИЗ
		|		ВтТовары КАК ТоварнаяМатрица
		|			
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК Настройка
		|			ПО Настройка.СхемаОбеспечения = ТоварнаяМатрица.Номенклатура.СхемаОбеспечения
		|			 И Настройка.Склад ССЫЛКА Справочник.Склады
		|			
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияТоварами КАК ВытесняющаяНастройка
		|			ПО ВытесняющаяНастройка.Номенклатура   = ТоварнаяМатрица.Номенклатура
		|			 И ВытесняющаяНастройка.Характеристика = ТоварнаяМатрица.Характеристика
		|			 И ВытесняющаяНастройка.Склад          = Настройка.Склад
		|			 И ВытесняющаяНастройка.РеквизитДопУпорядочивания = 1
		|	ГДЕ
		|		НЕ Настройка.Склад ЕСТЬ NULL
		|		И ВытесняющаяНастройка.Склад ЕСТЬ NULL
		|		И &Отборы
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварнаяМатрица.Номенклатура   КАК Номенклатура,
		|		ТоварнаяМатрица.Характеристика КАК Характеристика,
		|		
		|		СкладыФормата.Склад                     КАК Склад,
		|		Настройка.СпособОбеспеченияПотребностей КАК СпособОбеспеченияПотребностей
		|	ИЗ
		|		ВтТовары КАК ТоварнаяМатрица
		|			
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК Настройка
		|			ПО Настройка.СхемаОбеспечения = ТоварнаяМатрица.Номенклатура.СхемаОбеспечения
		|			 И Настройка.Склад ССЫЛКА Справочник.ФорматыМагазинов
		|			
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВтФорматыСкладов КАК СкладыФормата
		|			ПО СкладыФормата.ФорматМагазина = Настройка.Склад
		|			
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК ВытесняющаяНастройкаСхемы
		|			ПО ВытесняющаяНастройкаСхемы.СхемаОбеспечения = ТоварнаяМатрица.Номенклатура.СхемаОбеспечения
		|			 И ВытесняющаяНастройкаСхемы.Склад ССЫЛКА Справочник.Склады
		|			 И ВытесняющаяНастройкаСхемы.Склад = СкладыФормата.Склад
		|			
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияТоварами КАК ВытесняющаяНастройка
		|			ПО ВытесняющаяНастройка.Номенклатура   = ТоварнаяМатрица.Номенклатура
		|			 И ВытесняющаяНастройка.Характеристика = ТоварнаяМатрица.Характеристика
		|			 И ВытесняющаяНастройка.Склад          = СкладыФормата.Склад
		|			 И ВытесняющаяНастройка.РеквизитДопУпорядочивания = 1
		|	ГДЕ
		|		НЕ Настройка.Склад ЕСТЬ NULL
		|		И НЕ СкладыФормата.Склад ЕСТЬ NULL
		|		И ВытесняющаяНастройкаСхемы.Склад ЕСТЬ NULL
		|		И ВытесняющаяНастройка.Склад ЕСТЬ NULL
		|		И &Отборы) КАК Набор
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика, Склад
		|;
		|
		|////////////////////////////////////
		|";
	
	ПодстрокаЗамены = "";
	Если ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
		
		ПодстрокаЗамены = "Настройка.СпособОбеспеченияПотребностей.ТипОбеспечения = ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.Перемещение)
			|		И Настройка.СпособОбеспеченияПотребностей.ИсточникОбеспеченияПотребностей ССЫЛКА Справочник.Склады
			|		И Настройка.СпособОбеспеченияПотребностей.ИсточникОбеспеченияПотребностей <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)";
		
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Отборы", ПодстрокаЗамены);
	Возврат ТекстЗапроса;
	
КонецФункции

// Подставляет в текст запроса соединения, необходимые для получения основного способа обеспечения товаром на складе или
// работой.
//
// Параметры:
//  ТекстЗапроса	 - Строка - текст запроса, в который нужно подставить соединение
//  ИмяПараметра	 - Строка - имя параметра на место которого будет подставлено соединение
//  ПоляСоединения	 - Строка - поля соединения в формате [ВедущаяТаблица].Номенклатура,[ВедущаяТаблица].Характеристика,[ВедущаяТаблица].Склад.
//  Постфикс         - Строка - уникальный текст для внутренних синонимов таблиц.
// 
// Возвращаемое значение:
//  Строка - новый тест запроса
//
Функция ПодставитьСоединениеДляПолученияСпособаОбеспечения(ТекстЗапроса, ИмяПараметра, ПоляСоединения = Неопределено, Постфикс = "") Экспорт
	
	РезультатПодстановки = ТекстЗапроса;
	Пока Истина Цикл
		
		НачалоПараметра = СтрНайти(РезультатПодстановки, ИмяПараметра, НаправлениеПоиска.СНачала);
		
		Если НачалоПараметра = 0 Тогда
			Прервать;
		КонецЕсли;
		
		ПоследнийСимвол = НачалоПараметра + СтрДлина(ИмяПараметра);
		НачалоСинонима = СтрНайти(РезультатПодстановки, "КАК", НаправлениеПоиска.СКонца, НачалоПараметра) + СтрДлина("КАК");
		Синоним = СокрЛП(СтрЗаменить(Сред(РезультатПодстановки, НачалоСинонима, НачалоПараметра - НачалоСинонима - 1), "ПО", ""));
		ПревыйСимвол = СтрНайти(РезультатПодстановки, "СОЕДИНЕНИЕ", НаправлениеПоиска.СКонца, НачалоСинонима) + СтрДлина("СОЕДИНЕНИЕ");
		
		ПодстрокаПоиска = Сред(РезультатПодстановки, ПревыйСимвол, ПоследнийСимвол - ПревыйСимвол);
		ПодстрокаЗамены =
			"		РегистрСведений.ВариантыОбеспеченияРаботами КАК ТаблицаВариантыОбеспеченияРаботамиПереопределяемый
			|		ПО Т.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
			|		 И ТаблицаВариантыОбеспеченияРаботамиПереопределяемый.Номенклатура   = Т.Номенклатура
			|		 И ТаблицаВариантыОбеспеченияРаботамиПереопределяемый.Характеристика = Т.Характеристика
			|		 И ТаблицаВариантыОбеспеченияРаботамиПереопределяемый.РеквизитДопУпорядочивания = 1
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияТоварами КАК ТаблицаВариантыОбеспеченияТоварамиПереопределяемый
			|		ПО Т.Номенклатура.ТипНоменклатуры В(
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара),
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Набор))
			|		 И ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.Номенклатура   = Т.Номенклатура
			|		 И ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.Характеристика = Т.Характеристика
			|		 И ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.Склад          = Т.Склад
			|		 И ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.РеквизитДопУпорядочивания = 1
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВтФорматыСкладов КАК ТаблицаФорматыСкладовПереопределяемый
			|		ПО ТаблицаФорматыСкладовПереопределяемый.Склад = Т.Склад
			|		 И ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.Номенклатура ЕСТЬ NULL
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК ТаблицаСхемыОбеспеченияСкладовПереопределяемый
			|		ПО ТаблицаСхемыОбеспеченияСкладовПереопределяемый.СхемаОбеспечения = Т.Номенклатура.СхемаОбеспечения
			|		 И ТаблицаСхемыОбеспеченияСкладовПереопределяемый.Склад = Т.Склад
			|		 И ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.Номенклатура ЕСТЬ NULL
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК ТаблицаСхемыОбеспеченияФорматовПереопределяемый
			|		ПО ТаблицаСхемыОбеспеченияФорматовПереопределяемый.СхемаОбеспечения = Т.Номенклатура.СхемаОбеспечения
			|		 И ТаблицаСхемыОбеспеченияФорматовПереопределяемый.Склад = ТаблицаФорматыСкладовПереопределяемый.ФорматМагазина
			|		 И ТаблицаСхемыОбеспеченияСкладовПереопределяемый.СхемаОбеспечения ЕСТЬ NULL
			|		 И ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.Номенклатура ЕСТЬ NULL
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СпрСпособ
			|		ПО ВЫБОР КОГДА Т.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
			|						
			|						ЕСТЬNULL(ТаблицаВариантыОбеспеченияРаботамиПереопределяемый.СпособОбеспеченияПотребностей,
			|							Т.Номенклатура.СпособОбеспеченияПотребностей)
			|						
			|					ИНАЧЕ
			|						
			|						ЕСТЬNULL(ТаблицаВариантыОбеспеченияТоварамиПереопределяемый.СпособОбеспеченияПотребностей,
			|							ЕСТЬNULL(ТаблицаСхемыОбеспеченияСкладовПереопределяемый.СпособОбеспеченияПотребностей,
			|								ЕСТЬNULL(ТаблицаСхемыОбеспеченияФорматовПереопределяемый.СпособОбеспеченияПотребностей,
			|									ЗНАЧЕНИЕ(Справочник.СпособыОбеспеченияПотребностей.ПустаяСсылка))))
			|						
			|				КОНЕЦ = СпрСпособ.Ссылка";
			
		ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "СпрСпособ", Синоним);
		Если ПоляСоединения <> Неопределено Тогда
			МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляСоединения);
			ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "Т.Номенклатура",   МассивПодстрок[0]);
			ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "Т.Характеристика", МассивПодстрок[1]);
			ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "Т.Склад",          МассивПодстрок[2]);
		КонецЕсли;
		
		ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "ТаблицаВариантыОбеспеченияРаботамиПереопределяемый", "ТаблицаВариантыОбеспеченияРаботами" + Постфикс);
		ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "ТаблицаВариантыОбеспеченияТоварамиПереопределяемый", "ТаблицаВариантыОбеспеченияТоварами" + Постфикс);
		ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "ТаблицаФорматыСкладовПереопределяемый", "ТаблицаФорматыСкладов" + Постфикс);
		ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "ТаблицаСхемыОбеспеченияСкладовПереопределяемый", "ТаблицаСхемыОбеспеченияСкладов" + Постфикс);
		ПодстрокаЗамены = СтрЗаменить(ПодстрокаЗамены, "ТаблицаСхемыОбеспеченияФорматовПереопределяемый", "ТаблицаСхемыОбеспеченияФорматов" + Постфикс);
		
		РезультатПодстановки = СтрЗаменить(РезультатПодстановки, ПодстрокаПоиска, ПодстрокаЗамены);
		
	КонецЦикла;
	
	Возврат РезультатПодстановки;
	
КонецФункции

// Для переданных ключей определяет топологию складов. Перечень центров с которых перемещяют товары на удаленные склады.
//  Результат сохраняется во временную таблицу ТопологияСкладов с полями:
//   Номенклатура   - СправочникСсылка.Номенклатура - номенклатура товара,
//   Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - характеристика товара,
//   Центр          - СправочникСсылка.Склады - склад, с которого товары перемещаются на другие склады,
//   Склад          - СправочникСсылка.Склады - склад на который перемещаются товары из центра, а также сам центр распределительной сети.
// Параметры:
//  Запрос - Запрос - запрос во временные таблицы которого необходимо поместить результат
//  ИмяТаблицыТовары - Строка - имя временной таблицы содержащей набор уникальных ключей:
//                     * Номенклатура   - СправочникСсылка.Номенклатура - номенклатура товара,
//                     * Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - характеристика товара,
//
Процедура ВременнаяТаблицаТопологияСкладов(Запрос, ИмяТаблицыТовары) Экспорт
	
	Текст = ВременнаяТаблицаСпособыОбеспеченияВсехСкладов(Перечисления.ТипыОбеспечения.Перемещение, Истина);
	Текст = СтрЗаменить(Текст, "ВтТовары", ИмяТаблицыТовары);
	
	ТекстыЗапроса = Новый Массив();
	ТекстыЗапроса.Добавить(Текст);
	
	Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.Склад КАК СкладПолучатель,
		|	ВЫРАЗИТЬ(Таблица.СпособОбеспеченияПотребностей КАК Справочник.СпособыОбеспеченияПотребностей).ИсточникОбеспеченияПотребностей КАК СкладОтправитель
		|ПОМЕСТИТЬ ТопологияВременный
		|ИЗ
		|	ВтСпособыОбеспечения КАК Таблица
		|ГДЕ
		|	Таблица.Склад <> ВЫРАЗИТЬ(Таблица.СпособОбеспеченияПотребностей КАК Справочник.СпособыОбеспеченияПотребностей).ИсточникОбеспеченияПотребностей
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика
		|;
		|ВЫБРАТЬ
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.СкладПолучатель КАК СкладПолучатель,
		|	Таблица.СкладОтправитель КАК СкладОтправитель,
		|	ЛОЖЬ КАК Обработан
		|ИЗ
		|	ТопологияВременный КАК Таблица
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура, Характеристика
		|;
		|ВЫБРАТЬ
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	КОЛИЧЕСТВО(*) КАК ВсегоЗаписей
		|ИЗ
		|	ТопологияВременный КАК Таблица
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура, Характеристика
		|;
		|УНИЧТОЖИТЬ ВтСпособыОбеспечения";
		
	ТекстыЗапроса.Добавить(Текст);
	Запрос.Текст = СтрСоединить(ТекстыЗапроса);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	Таблица = РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 2].Выгрузить();
	Таблица.Индексы.Добавить("Номенклатура,Характеристика,СкладПолучатель");
	ТаблицаТоваров = РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 1].Выгрузить();
	ПодчиненныеСклады = Таблица.СкопироватьКолонки();
	
	Отбор = Новый Структура("Номенклатура,Характеристика,СкладПолучатель");
	ИндексПоследний = -1;
	Для ИндексТовара = 0 По ТаблицаТоваров.Количество() - 1 Цикл
		
		Товар = ТаблицаТоваров[ИндексТовара];
		ЗаполнитьЗначенияСвойств(Отбор, Товар);
		ИндексПервый = ИндексПоследний + 1;
		ИндексПоследний = ИндексПервый + Товар.ВсегоЗаписей - 1;
		
		ОбработкаЗавершена = Ложь;
		Пока Не ОбработкаЗавершена Цикл
			
			ОбработкаЗавершена = Истина;
			
			Для ИндексТекущий = ИндексПервый По ИндексПоследний Цикл
				
				СтрокаТаблицы = Таблица[ИндексТекущий];
				Если СтрокаТаблицы.Обработан Тогда
					Продолжить;
				КонецЕсли;
				СтрокаТаблицы.Обработан = Истина;
				НоваяСтрока = ПодчиненныеСклады.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
				Отбор.СкладПолучатель = СтрокаТаблицы.СкладОтправитель;
				НайденныеСтроки = Таблица.НайтиСтроки(Отбор);
				Если НайденныеСтроки.Количество() > 0 Тогда
					
						ЦентрВышеУровнем = НайденныеСтроки[0].СкладОтправитель;
						Если СтрокаТаблицы.СкладПолучатель = ЦентрВышеУровнем Тогда // защита от зацикливания
							Продолжить;
						КонецЕсли;
						
						ОбработкаЗавершена = Ложь;
						СтрокаТаблицы.Обработан = Ложь;
						СтрокаТаблицы.СкладОтправитель = ЦентрВышеУровнем;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	Запрос.УстановитьПараметр("ПодчиненныеСклады", ПодчиненныеСклады);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.СкладОтправитель КАК СкладОтправитель,
		|	Таблица.СкладПолучатель КАК СкладПолучатель
		|ПОМЕСТИТЬ ПодчиненныеСклады
		|ИЗ
		|	&ПодчиненныеСклады КАК Таблица
		|;
		|ВЫБРАТЬ
		|	ПодчиненныеСклады.Номенклатура КАК Номенклатура,
		|	ПодчиненныеСклады.Характеристика КАК Характеристика,
		|	ПодчиненныеСклады.СкладПолучатель КАК Склад,
		|	ПодчиненныеСклады.СкладОтправитель КАК Центр
		|ПОМЕСТИТЬ ТопологияСкладов
		|ИЗ
		|	ПодчиненныеСклады КАК ПодчиненныеСклады
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.СкладОтправитель КАК Склад,
		|	Таблица.СкладОтправитель КАК Центр
		|ИЗ
		|	ТопологияВременный КАК Таблица
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика, Склад, Центр
		|;
		|УНИЧТОЖИТЬ ПодчиненныеСклады
		|;
		|УНИЧТОЖИТЬ ТопологияВременный";
	Запрос.Выполнить();
	Запрос.УстановитьПараметр("ПодчиненныеСклады", Неопределено); // очистка таблицы
	
КонецПроцедуры

// Дополняет переданную таблицу ключей. Для склада, центра распределительной сети,
// добавляет все склады сети согласно тополонии складов.
//
// Параметры:
//  ИмяТаблицыТовары - Строка - имя временной таблицы содержащей ключи Номенклатура,Характеристика,Склад (уникальность не требуется)
//  ДетализироватьДоНазначений - Булево - признак, что в таблице есть назначение.
//
// Возвращаемое значение:
//  Строка - Текст запроса запроса временной таблицы "РазличныеТоварыИСклады" с уникальными ключами:
//           * Номенклатура   - СправочникСсылка.Номенклатура - номенклатура товара,
//           * Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - характеристика товара,
//           * Назначение     - СправочникСсылка.Назначения - назначение товара, либо Неопределено,
//           * Склад          - СправочникСсылка.Склады - склад.
//
Функция ВременнаяТаблицаРазличныеТоварыИСклады(ИмяТаблицыТовары, ДетализироватьДоНазначений) Экспорт
	
	Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.Номенклатура    КАК Номенклатура,
		|	Товары.Характеристика  КАК Характеристика,
		|	Товары.Склад           КАК Склад,
		|	&ПодстановкаНазначение КАК Назначение
		|ПОМЕСТИТЬ РазличныеТоварыИСклады
		|ИЗ
		|	ИмяТаблицыПереопределяемый КАК Товары
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.Номенклатура    КАК Номенклатура,
		|	Товары.Характеристика  КАК Характеристика,
		|	Топология.Склад        КАК Склад,
		|	&ПодстановкаНазначение КАК Назначение
		|ИЗ
		|	ИмяТаблицыПереопределяемый КАК Товары
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТопологияСкладов КАК Топология
		|		ПО Топология.Номенклатура   =  Товары.Номенклатура
		|		 И Топология.Характеристика =  Товары.Характеристика
		|		 И Топология.Центр          =  Товары.Склад
		|ГДЕ
		|	НЕ Топология.Номенклатура ЕСТЬ NULL
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика, Склад";
		
	Текст = СтрЗаменить(Текст, "ИмяТаблицыПереопределяемый", ИмяТаблицыТовары);
	ПодстановкаИтоговая = ?(ДетализироватьДоНазначений, "Товары.Назначение", "НЕОПРЕДЕЛЕНО");
	Текст = СтрЗаменить(Текст, "&ПодстановкаНазначение", ПодстановкаИтоговая);
	
	Возврат Текст;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

Процедура Добавить(Склад, СхемаОбеспечения, СпособОбеспечения) Экспорт
	
	Набор = РегистрыСведений.СхемыОбеспечения.СоздатьНаборЗаписей();
	
	Набор.Отбор.СхемаОбеспечения.Установить(СхемаОбеспечения);
	Набор.Отбор.Склад.Установить(Склад);
	
	Запись = Набор.Добавить();
	Запись.СхемаОбеспечения = СхемаОбеспечения;
	Запись.Склад = Склад;
	
	Запись.СпособОбеспеченияПотребностей = СпособОбеспечения;
	Набор.Записать();
	
КонецПроцедуры

Процедура Удалить(Склад, СхемаОбеспечения) Экспорт
	
	Набор = РегистрыСведений.СхемыОбеспечения.СоздатьНаборЗаписей();
	
	Набор.Отбор.СхемаОбеспечения.Установить(СхемаОбеспечения);
	Набор.Отбор.Склад.Установить(Склад);
	
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
