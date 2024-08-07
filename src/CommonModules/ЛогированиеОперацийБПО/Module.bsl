#Область ПрограммныйИнтерфейс

// Возвращает параметры записи истории платежной операции
//
// Возвращаемое значение:
//  Структура:
//   * ИдентификаторЗапроса - Неопределено, Строка - Необязательный. Уникальный идентификатор запроса
//   * ДокументОснование - Неопределено, ОпределяемыйТип.ОснованиеФискальнойОперацииБПО - 
//   * ИдентификаторФискальнойОперации - Неопределено, Строка - 
//   * СуммаОперации - Число
//   * ОперацияВыполнена - Булево
//   * ДанныеЗапроса - Структура
//   * ДанныеОтвета - Структура
//  
Функция ПараметрыИсторияОплатыПлатежнойСистемой() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ИдентификаторЗапроса", Неопределено);
	Результат.Вставить("ДокументОснование", Неопределено);
	Результат.Вставить("ИдентификаторФискальнойОперации",Неопределено);
	Результат.Вставить("СуммаОперации", 0);
	Результат.Вставить("ОперацияВыполнена", Ложь);
	Результат.Вставить("ДанныеЗапроса", Новый Структура());
	Результат.Вставить("ДанныеОтвета", Новый Структура());
	Возврат Результат;
	
КонецФункции

// Выполняет запись в регистр платежных операций
// 
// Параметры:
//  Параметры - см. ПараметрыИсторияОплатыПлатежнойСистемой
Процедура ЗаписатьИсториюОплатаПлатежнойСистемой(Параметры) Экспорт
	
	Если Не ДоступноЛогированиеПлатежныхОпераций() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ПлатежныеОперации.СоздатьНаборЗаписей();
	Запись = НаборЗаписей.Добавить();
	
	Запись.ИдентификаторЗапроса = Строка(Параметры.ИдентификаторЗапроса);
	Если ПустаяСтрока(Запись.ИдентификаторЗапроса) Тогда
		Запись.ИдентификаторЗапроса = Строка(Новый УникальныйИдентификатор());
	КонецЕсли;
	
	ДатаЗаписи = ОбщегоНазначенияБПО.ДатаСеанса();
	Запись.ДокументОснование               = Параметры.ДокументОснование;
	Запись.ДатаЗапроса                     = ДатаЗаписи;
	Запись.ГодМесяц                        = Год(ДатаЗаписи)*100+Месяц(ДатаЗаписи);
	Запись.ТипОперации                     = Перечисления.ТипыПлатежныхОпераций.ОплатаПлатежнойСистемой;
	Запись.ИдентификаторФискальнойОперации = Параметры.ИдентификаторФискальнойОперации;
	Запись.СуммаОперации                   = Параметры.СуммаОперации;
	Запись.ОперацияВыполнена               = Параметры.ОперацияВыполнена;
	
	Сжатие = Новый СжатиеДанных(6);
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Параметры.ДанныеЗапроса, ,"ЗаписатьИсториюПлатежнойОперации_ПреобразованиеВJSON", МенеджерОборудованияВызовСервера);
	Запись.ДанныеЗапроса = Новый ХранилищеЗначения(ЗаписьJSON.Закрыть(), Сжатие);
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Параметры.ДанныеОтвета, ,"ЗаписатьИсториюПлатежнойОперации_ПреобразованиеВJSON", МенеджерОборудованияВызовСервера);
	Запись.ДанныеОтвета = Новый ХранилищеЗначения(ЗаписьJSON.Закрыть(), Сжатие);
	
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполнят очистку истории платежных операций
//
Процедура ОчисткаИсторииПлатежныхОпераций() Экспорт
	
	ОбщегоНазначенияБПО.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОчисткаИсторииПлатежныхОпераций);
	
	Если Не ОбщегоНазначенияБПО.ИспользуетсяПлатежныеСистемы() Тогда
		Возврат;
	КонецЕсли;

	Если Не ДоступноЛогированиеПлатежныхОпераций() Тогда
		Возврат;
	КонецЕсли;
	
	ПериодХранения = ПериодХраненияИсторииПлатежныхОпераций();
	ДатаОчистки    = ОпределитьДатуОчисткиОпераций(ПериодХранения);
	Если ДатаОчистки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ПлатежныеОперации.ОчиститьРегистрЗаПрошлыеМесяцы(ДатаОчистки);
	РегистрыСведений.ПлатежныеОперации.ОчиститьРегистрЗаТекущийМесяц (ДатаОчистки);
	
КонецПроцедуры

// Выполнят очистку истории фискальных операций
//
Процедура ОчисткаИсторииФискальныхОпераций() Экспорт
	
	ОбщегоНазначенияБПО.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОчисткаИсторииФискальныхОпераций);
	
	Если Не ОбщегоНазначенияБПО.ИспользуетсяЧекопечатающиеУстройства() Тогда
		Возврат;
	КонецЕсли;
	
	ПериодХранения = ПериодХраненияИсторииФискальныхОпераций();
	ДатаОчистки    = ОпределитьДатуОчисткиОпераций(ПериодХранения);
	Если ДатаОчистки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ФискальныеОперации.ОчиститьРегистрДоДаты(ДатаОчистки);
	
КонецПроцедуры

// ++ Локализация

// Выполнят очистку истории операций очереди чеков
//
Процедура ОчисткаИсторииОперацийОчередиЧеков() Экспорт
	
	ОбщегоНазначенияБПО.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОчисткаИсторииОперацийОчередиЧеков);
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		
		ПериодХранения = ПериодХраненияИсторииОперацийОчередиЧеков();
		ДатаОчистки    = ОпределитьДатуОчисткиОпераций(ПериодХранения);
		МодульРаспределеннаяФискализация.ОчисткаИсторииОперацийОчередиЧеков(ДатаОчистки);
	КонецЕсли;
	
КонецПроцедуры

// Выполнят очистку истории операций проверки КМ
//
Процедура ОчисткаИсторииОперацийПроверкиКМ() Экспорт
	
	ОбщегоНазначенияБПО.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОчисткаИсторииОперацийПроверкиКМ);
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		
		ПериодХранения = ПериодХраненияИсторииОперацийПроверкиКМ();
		ДатаОчистки    = ОпределитьДатуОчисткиОпераций(ПериодХранения);
		Если ДатаОчистки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		МодульМенеджерОборудованияМаркировка.ОчисткаИсторииОперацийПроверкиКМ(ДатаОчистки);
		
	КонецЕсли;
	
КонецПроцедуры

// -- Локализация

Процедура ЗаписатьИсториюПлатежнойОперации(Команда, ДанныеОперации, РезультатВыполнения) Экспорт
	
	Если Не ДоступноЛогированиеПлатежныхОпераций() Тогда
		Возврат;
	КонецЕсли;
	
	ТипОперации = ТипПлатежнойОперацииПоКоманде(Команда);
	Если ТипОперации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторЗапроса = ?(ДанныеОперации.Свойство("ИдентификаторЗапроса"), ДанныеОперации.ИдентификаторЗапроса, Неопределено);
	ДокументОснование    = ?(ДанныеОперации.Свойство("ДокументОснование"), ДанныеОперации.ДокументОснование, Неопределено);
	СуммаОперации        = ?(ДанныеОперации.Свойство("СуммаОперации"), ДанныеОперации.СуммаОперации, Неопределено);
	ИдентификаторФискальнойОперации = 
		?(ДанныеОперации.Свойство("ИдентификаторФискальнойОперации"), ДанныеОперации.ИдентификаторФискальнойОперации, Неопределено);
	
	Если ПустаяСтрока(ИдентификаторЗапроса) Тогда
		ИдентификаторЗапроса = Новый УникальныйИдентификатор();
		Если ДанныеОперации.Свойство("ИдентификаторЗапроса") Тогда
			ДанныеОперации.ИдентификаторЗапроса = ИдентификаторЗапроса;
		КонецЕсли;
	КонецЕсли;
	ДатаЗаписи = ОбщегоНазначенияБПО.ДатаСеанса();
	
	НаборЗаписей = РегистрыСведений.ПлатежныеОперации.СоздатьНаборЗаписей();
	Запись = НаборЗаписей.Добавить();
	Запись.ИдентификаторЗапроса            = Строка(ИдентификаторЗапроса);
	Запись.ДокументОснование               = ДокументОснование;
	Запись.ДатаЗапроса                     = ДатаЗаписи;
	Запись.ГодМесяц                        = Год(ДатаЗаписи)*100+Месяц(ДатаЗаписи);
	Запись.ТипОперации                     = ТипОперации;
	Запись.ИдентификаторФискальнойОперации = ИдентификаторФискальнойОперации;
	Запись.СуммаОперации                   = СуммаОперации;
	Запись.ОперацияВыполнена               = РезультатВыполнения.Результат;
	
	Сжатие = Новый СжатиеДанных(6);
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ДанныеОперации, , "ЗаписатьИсториюПлатежнойОперации_ПреобразованиеВJSON", ЛогированиеОперацийБПО);
	Запись.ДанныеЗапроса = Новый ХранилищеЗначения(ЗаписьJSON.Закрыть(), Сжатие);
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, РезультатВыполнения, , "ЗаписатьИсториюПлатежнойОперации_ПреобразованиеВJSON", ЛогированиеОперацийБПО);
	Запись.ДанныеОтвета = Новый ХранилищеЗначения(ЗаписьJSON.Закрыть(), Сжатие);
	
	НаборЗаписей.Записать(Ложь);

КонецПроцедуры

// Возвращает доступность логирования платежных операций
//
// Возвращаемое значение:
//  Булево.
//
Функция ДоступноЛогированиеПлатежныхОпераций() Экспорт
	
	Результат = Истина;
	ЛогированиеДоступно = Результат; 
	СтандартнаяОбработка = Истина;
	ЛогированиеОперацийБПОПереопределяемый.ДоступноЛогированиеПлатежныхОпераций(ЛогированиеДоступно, СтандартнаяОбработка);
	Результат = ?(СтандартнаяОбработка, Результат, ЛогированиеДоступно);
	Возврат Результат; 
	
КонецФункции

Функция ОпределитьДатуОчисткиОпераций(ПериодХранения) Экспорт
	
	ТекущаяДата = ОбщегоНазначенияБПО.ДатаСеанса();
	Если ПериодХранения = Перечисления.ПериодХраненияИсторииПлатежныхОпераций.День Тогда
		ОдинДеньСекунды = 60*60*24*1;
		ДатаОчистки = ТекущаяДата - ОдинДеньСекунды;
	ИначеЕсли ПериодХранения = Перечисления.ПериодХраненияИсторииПлатежныхОпераций.Неделя Тогда
		НеделяСекунды = 60*60*24*7;
		ДатаОчистки = ТекущаяДата - НеделяСекунды;
	ИначеЕсли ПериодХранения = Перечисления.ПериодХраненияИсторииПлатежныхОпераций.Декада Тогда
		ДекадаСекунды = 60*60*24*10;
		ДатаОчистки = ТекущаяДата - ДекадаСекунды;
	ИначеЕсли ПериодХранения = Перечисления.ПериодХраненияИсторииПлатежныхОпераций.Месяц Тогда
		ДатаОчистки = ДобавитьМесяц(ТекущаяДата, -1);
	ИначеЕсли ПериодХранения = Перечисления.ПериодХраненияИсторииПлатежныхОпераций.Квартал Тогда
		ДатаОчистки = ДобавитьМесяц(ТекущаяДата, -3);
	ИначеЕсли ПериодХранения = Перечисления.ПериодХраненияИсторииПлатежныхОпераций.Полугодие Тогда
		ДатаОчистки = ДобавитьМесяц(ТекущаяДата, -6);
	ИначеЕсли ПериодХранения = Перечисления.ПериодХраненияИсторииПлатежныхОпераций.Год Тогда
		ДатаОчистки = ДобавитьМесяц(ТекущаяДата, -12);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДатаОчистки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает период хранения фискальных операций в регистре сведений
//
// Возвращаемое значение:
//   ПериодХранения - ПеречислениеСсылка.ПериодХраненияИсторииПлатежныхОпераций
Функция ПериодХраненияИсторииФискальныхОпераций()
	
	ПериодХранения = Неопределено;
	Если ОбщегоНазначенияБПО.ИспользуетсяЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройства = ОбщегоНазначенияБПО.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройства");
		ПериодХранения = МодульОборудованиеЧекопечатающиеУстройства.ПериодХраненияИсторииФискальныхОпераций();
	КонецЕсли;
	Возврат ПериодХранения;
	
КонецФункции

// Возвращает период хранения платежных операций в регистре сведений
//
// Возвращаемое значение:
//   ПериодХранения - ПеречислениеСсылка.ПериодХраненияИсторииПлатежныхОпераций
Функция ПериодХраненияИсторииПлатежныхОпераций()
	
	ПериодХранения = Неопределено;
	Если ОбщегоНазначенияБПО.ИспользуетсяПлатежныеСистемы() Тогда
		МодульОборудованиеПлатежныеСистемы = ОбщегоНазначенияБПО.ОбщийМодуль("ОборудованиеПлатежныеСистемы");
		ПериодХранения = МодульОборудованиеПлатежныеСистемы.ПериодХраненияИсторииПлатежныхОпераций();
	КонецЕсли;
	Возврат ПериодХранения;
	
КонецФункции

// ++ Локализация

// Возвращает период хранения операций очереди чеков в регистре сведений
//
// Возвращаемое значение:
//   ПериодХранения - ПеречислениеСсылка.ПериодХраненияИсторииПлатежныхОпераций
Функция ПериодХраненияИсторииОперацийОчередиЧеков()
	
	ПериодХранения = Неопределено;
	Если ОбщегоНазначенияБПО.ИспользуетсяЧекопечатающиеУстройства() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		ПериодХранения = МодульРаспределеннаяФискализация.ПериодХраненияИсторииОперацийОчередиЧеков();
	КонецЕсли;
	Возврат ПериодХранения;
	
КонецФункции

// Возвращает период хранения операций проверки КМ в регистре сведений
//
// Возвращаемое значение:
//   ПериодХранения - ПеречислениеСсылка.ПериодХраненияИсторииПлатежныхОпераций
Функция ПериодХраненияИсторииОперацийПроверкиКМ()
	
	ПериодХранения = Неопределено;
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		ПериодХранения = МодульМенеджерОборудованияМаркировка.ПериодХраненияИсторииОперацийПроверкиКМ();
	КонецЕсли;
	Возврат ПериодХранения;
	
КонецФункции

// -- Локализация

Функция ТипПлатежнойОперацииПоКоманде(Команда)
	
	ТипыОпераций = Новый Соответствие();
	
	ТипыОпераций.Вставить("AuthorizeSales", Перечисления.ТипыПлатежныхОпераций.ОплатаПлатежнойКартой);
	ТипыОпераций.Вставить("AuthorizeRefund", Перечисления.ТипыПлатежныхОпераций.ВозвратПоПлатежнойКарте);
	ТипыОпераций.Вставить("AuthorizeVoid", Перечисления.ТипыПлатежныхОпераций.ОтменаПлатежаПоПлатежнойКарте);
	ТипыОпераций.Вставить("PayByPaymentCardWithCashWithdrawal", Перечисления.ТипыПлатежныхОпераций.ОплатаПлатежнойКартойСВыдачейНаличных);
	ТипыОпераций.Вставить("PayElectronicCertificate", Перечисления.ТипыПлатежныхОпераций.ОплатаЭС);
	ТипыОпераций.Вставить("ReturnElectronicCertificate", Перечисления.ТипыПлатежныхОпераций.ВозвратЭС);
	ТипыОпераций.Вставить("EmergencyVoid", Перечисления.ТипыПлатежныхОпераций.АварийнаяОтмена);
	
	Возврат ТипыОпераций.Получить(Команда);
	
КонецФункции

Функция ЗаписатьИсториюПлатежнойОперации_ПреобразованиеВJSON(Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт  
	
	Возврат Строка(Значение);   
	
КонецФункции

#КонецОбласти


