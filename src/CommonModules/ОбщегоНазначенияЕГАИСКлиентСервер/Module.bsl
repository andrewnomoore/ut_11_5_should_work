
#Область СлужебныеПроцедурыИФункции

Функция ЭтоРасширеннаяВерсияГосИС() Экспорт
	
	Возврат ОбщегоНазначенияЕГАИСКлиентСерверПовтИсп.ЭтоРасширеннаяВерсияГосИС();
	
КонецФункции

// Имя события для записи в журнал регистрации.
//
// Возвращаемое значение:
//  Строка - заголовок события для записи в журнал регистрации
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Интеграция с ЕГАИС'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Возвращает признак возможности для вида продукции (и вида операции) участвовать в частичном выбытии.
// 
// Параметры:
//  ВидПродукции    - ПеречислениеСсылка.ВидыПродукцииИС                   - вид продукции.
//  ОперацияИС      - ПеречислениеСсылка.ВидыДокументовЕГАИС, Неопределено - вид операции ЕГАИС.
// Возвращаемое значение:
//  Булево - Вид продукци (в текущей операции) может выбывать частично.
Функция ПоддерживаетсяЧастичноеВыбытие(ВидПродукции, ОперацияИС = Неопределено) Экспорт
	
	Возврат ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная")
		И (ОперацияИС = Неопределено
		Или ОперацияИС = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктСписанияИзРегистра1")
		Или ОперацияИС = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктСписанияИзРегистра3")
		Или ОперацияИС = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ"));
	
КонецФункции

#Область ОбменНаКлиентеПоРасписанию

Функция ПараметрПриложенияОбменНаКлиентеПоРасписанию() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ВедетсяУчетАлкогольнойПродукции", Ложь);
	ВозвращаемоеЗначение.Вставить("НастроенАвтоматическийОбмен",     Ложь);
	ВозвращаемоеЗначение.Вставить("ОбновитьПараметрыНастроек",       Истина);
	ВозвращаемоеЗначение.Вставить("ДатаПоследнейОбработкиОтветов",   Новый Соответствие());
	ВозвращаемоеЗначение.Вставить("ЭтоВебКлиент",                    Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция НовоеЗначениеПараметраПериодическойОтправкиДанныхНаСерверЗапрос() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ДатыПоследнегоЗапускаОбменаНаКлиентеПоРасписанию", Неопределено);
	ВозвращаемоеЗначение.Вставить("НастроенАвтоматическийОбмен",                      Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция НовоеЗначениеПараметраПериодическойОтправкиДанныхНаСерверОтвет() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ПараметрПриложения",                 Неопределено);
	ВозвращаемоеЗначение.Вставить("ВыполнитьОбменНаКлиенте",            Ложь);
	ВозвращаемоеЗначение.Вставить("ДанныеДляВыполненияОбменаНаКлиенте", Неопределено);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ИменаПараметровПериодическогоПолученияДанных() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ИмяПараметраПриложения",    "ИнтеграцияЕГАИС.ПараметрПриложенияОбменНаКлиентеПоРасписанию");
	ВозвращаемоеЗначение.Вставить("ОбновитьПараметрыНастроек", "ИнтеграцияЕГАИС.ОбновитьПараметрыНастроек");
	ВозвращаемоеЗначение.Вставить("ВыполнитьОбменДанными",     "ИнтеграцияЕГАИС.ВыполнитьОбменДанными");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецОбласти