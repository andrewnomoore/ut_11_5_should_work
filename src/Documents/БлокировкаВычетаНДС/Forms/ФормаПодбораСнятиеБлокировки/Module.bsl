#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("КонецПериода", КонецПериода);
	Параметры.Свойство("Организация",  Организация);
	Параметры.Свойство("ВыбранныеСчетаФактуры", СписокВыбранныхСчетовФактур);
	Параметры.Свойство("ПериодичностьФормированияВычетовИВосстановленийНДС", ПериодичностьФормированияВычетовИВосстановленийНДС);
	
	ЗаполнитьСчетаФактуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИтоговыеСуммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РазблокироватьНДС(Команда)
	
	СоздатьБлокировкуВычетаНДС();
	Оповестить("Запись_БлокировкаВычетаНДС");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьЗначениеФлага(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьЗначениеФлага(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаФактурыФлагПриИзменении(Элемент)
	
	ОбновитьИтоговыеСуммы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСчетаФактуры() 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура КАК СчетФактура,
	|	МАКСИМУМ(БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата) КАК ДатаПоследнегоДокумента
	|ПОМЕСТИТЬ ДатыПоследнихОперацийПоБлокировке
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК БлокировкаВычетаНДССчетаФактуры
	|ГДЕ
	|	НЕ БлокировкаВычетаНДССчетаФактуры.Ссылка.ПометкаУдаления
	|	И БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата <= &КонецПериода
	|	И БлокировкаВычетаНДССчетаФактуры.Ссылка.Организация = &Организация
	|СГРУППИРОВАТЬ ПО
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	ДатаПоследнегоДокумента
	|;
	|
	|ВЫБРАТЬ
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура КАК СчетФактура,
	|	МАКСИМУМ(БлокировкаВычетаНДССчетаФактуры.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ВТ_СрезПоследнихДокументовБлокировки
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК БлокировкаВычетаНДССчетаФактуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыПоследнихОперацийПоБлокировке
	|		ПО ДатыПоследнихОперацийПоБлокировке.СчетФактура = БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|			И ДатыПоследнихОперацийПоБлокировке.ДатаПоследнегоДокумента = БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата
	|ГДЕ
	|	НЕ БлокировкаВычетаНДССчетаФактуры.Ссылка.ПометкаУдаления
	|СГРУППИРОВАТЬ ПО
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаблокированныеСФ.Ссылка.Организация КАК Организация,
	|	ЗаблокированныеСФ.СчетФактура КАК СчетФактура,
	|	ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ДанныеПервичныхДокументов.ДатаРегистратора, КВАРТАЛ), КВАРТАЛ, 11) КАК ПравоНаВычетДо,
	|	ВЫБОР
	|		КОГДА ЗаблокированныеСФ.СчетФактура В (&СписокВыбранныхСчетовФактур)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Флаг,
	|	ЗаблокированныеСФ.СрокБлокировки КАК СрокБлокировки,
	|	ЗаблокированныеСФ.НДС КАК НДС
	|ПОМЕСТИТЬ ВТ_Заблокировано
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК ЗаблокированныеСФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО ЗаблокированныеСФ.СчетФактура = ДанныеПервичныхДокументов.Документ
	|			И ЗаблокированныеСФ.Ссылка.Организация = ДанныеПервичныхДокументов.Организация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СрезПоследнихДокументовБлокировки КАК ВТ_СрезПоследнихДокументовБлокировки
	|		ПО ЗаблокированныеСФ.СчетФактура = ВТ_СрезПоследнихДокументовБлокировки.СчетФактура
	|			И ЗаблокированныеСФ.Ссылка = ВТ_СрезПоследнихДокументовБлокировки.Ссылка
	|ГДЕ
	|	(ЗаблокированныеСФ.СрокБлокировки > &НачалоПериода
	|		ИЛИ ЗаблокированныеСФ.СрокБлокировки = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|	И ЗаблокированныеСФ.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБлокировкиВычетаНДС.Установлена)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Заблокировано.СчетФактура КАК СчетФактура,
	|	ЕСТЬNULL(СФПолученный.Ссылка.Дата, ЕСТЬNULL(СФПолученныйНА.Ссылка.Дата, ЕСТЬNULL(ИнойДокументПодтвержденияНДС.Дата, СФВыданный.Ссылка.Дата))) КАК ДатаПолученияСчетаФактуры,
	|	Заблокировано.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА РеестрДокументов.Контрагент.Ключ ССЫЛКА Справочник.Организации
	|			ТОГДА ВЫРАЗИТЬ(РеестрДокументов.Контрагент.Ключ КАК Справочник.Организации)
	|		ИНАЧЕ ВЫРАЗИТЬ(РеестрДокументов.Контрагент.Ключ КАК Справочник.Контрагенты)
	|	КОНЕЦ КАК Поставщик
	|ПОМЕСТИТЬ ВТ_СчетаФактуры
	|ИЗ
	|	ВТ_Заблокировано КАК Заблокировано
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный.ДокументыОснования КАК СФПолученный
	|		ПО Заблокировано.СчетФактура = СФПолученный.ДокументОснование
	|			И (СФПолученный.Ссылка.Проведен)
	|			И (НЕ СФПолученный.Ссылка.Исправление)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученныйНалоговыйАгент.ДокументыОснования КАК СФПолученныйНА
	|		ПО (Заблокировано.СчетФактура = СФПолученный.ДокументОснование)
	|			И (СФПолученный.Ссылка.Проведен)
	|			И (НЕ СФПолученный.Ссылка.Исправление)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК СФВыданный
	|		ПО Заблокировано.СчетФактура = СФВыданный.ДокументОснование
	|			И (СФВыданный.Ссылка.Проведен)
	|			И (НЕ СФВыданный.Ссылка.Исправление)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИнойДокументПодтвержденияНДС КАК ИнойДокументПодтвержденияНДС
	|		ПО Заблокировано.СчетФактура = ИнойДокументПодтвержденияНДС.ДокументОснование
	|			И (ИнойДокументПодтвержденияНДС.Проведен)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|		ПО Заблокировано.СчетФактура = РеестрДокументов.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Заблокировано.Флаг КАК Флаг,
	|	Заблокировано.Организация КАК Организация,
	|	Заблокировано.СчетФактура КАК СчетФактура,
	|	СчетаФактуры.Поставщик КАК Поставщик,
	|	СчетаФактуры.ДатаПолученияСчетаФактуры КАК ДатаПолученияСчетаФактуры,
	|	Заблокировано.ПравоНаВычетДо КАК ПравоНаВычетДо,
	|	МАКСИМУМ(Заблокировано.СрокБлокировки) КАК СрокБлокировки,
	|	СУММА(Заблокировано.НДС) КАК НДС
	|ИЗ
	|	ВТ_Заблокировано КАК Заблокировано
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СчетаФактуры КАК СчетаФактуры
	|		ПО Заблокировано.СчетФактура = СчетаФактуры.СчетФактура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|		ПО Заблокировано.СчетФактура = РеестрДокументов.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Заблокировано.Организация,
	|	Заблокировано.СчетФактура,
	|	СчетаФактуры.ДатаПолученияСчетаФактуры,
	|	СчетаФактуры.Поставщик,
	|	Заблокировано.ПравоНаВычетДо,
	|	Заблокировано.Флаг
	|
	|УПОРЯДОЧИТЬ ПО
	|	Флаг УБЫВ";
	
	Если ПериодичностьФормированияВычетовИВосстановленийНДС =
		ОбщегоНазначения.ПредопределенныйЭлемент("Перечисление.Периодичность.Квартал") Тогда
			Запрос.УстановитьПараметр("НачалоПериода", НачалоКвартала(КонецПериода));
	Иначе
		Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(КонецПериода));
	КонецЕсли;
	Запрос.УстановитьПараметр("КонецПериода",  КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("СписокВыбранныхСчетовФактур", СписокВыбранныхСчетовФактур);
	
	СчетаФактуры.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СоздатьБлокировкуВычетаНДС() 
	
	ДокументОбъект = Документы.БлокировкаВычетаНДС.СоздатьДокумент();
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Флаг", Истина);
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Дата",         КонецДня(КонецПериода));
	ЗначенияЗаполнения.Вставить("Состояние",    Перечисления.СостоянияБлокировкиВычетаНДС.Снята);
	ЗначенияЗаполнения.Вставить("Организация",  Организация);
	ЗначенияЗаполнения.Вставить("СчетаФактуры", СчетаФактуры.Выгрузить(СтруктураОтбора));
	ДокументОбъект.Заполнить(ЗначенияЗаполнения);
	ДокументОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеФлага(ЗначениеФлага)
	
	Для каждого Строка Из СчетаФактуры Цикл
		
		Строка.Флаг = ЗначениеФлага;
		
	КонецЦикла;
	
	ОбновитьИтоговыеСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИтоговыеСуммы()
	
	ВыбраноНаСумму = 0;
	Для Каждого СтрокаСФ Из СчетаФактуры Цикл
		Если СтрокаСФ.Флаг Тогда
			ВыбраноНаСумму = ВыбраноНаСумму + СтрокаСФ.НДС;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти