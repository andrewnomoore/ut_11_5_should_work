#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	МашиночитаемыеДоверенности.ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация,
		СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	МашиночитаемыеДоверенности.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Получает данные МЧД.
// 
// Параметры:
//  МЧД - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов - Ссылка на МЧД контрагента
// 
// Возвращаемое значение:
//  См. МашиночитаемыеДоверенности.НовыеДанныеДоверенности
//  
Функция ПолучитьДанныеМЧД(МЧД) Экспорт
	
	РеквизитыМЧД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(МЧД, "НомерДоверенности, ДоверительИНН");
	ДанныеМЧД = МашиночитаемыеДоверенности.НовыеДанныеДоверенности();
	ДанныеМЧД.НомерДоверенности = РеквизитыМЧД.НомерДоверенности;
	ДанныеМЧД.ИННДоверителя = РеквизитыМЧД.ДоверительИНН;
	
	Возврат ДанныеМЧД;
	
КонецФункции

// Возвращает сведения МЧД.
// 
// Параметры:
//  МЧД - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
// 
// Возвращаемое значение:
//  См. МашиночитаемыеДоверенности.НовыеСведенияМЧД
//  
Функция СведенияМЧД(МЧД) Экспорт
	
	Реквизиты = "ДоверительИНН, СтатусВРеестреФНС, ДатаВыдачи, ДатаОкончания, ДатаЗагрузкиИзРеестра,
				|Подписана, Верна, Отозвана, ДатаОтзыва, ПолномочияОграничены, ВариантЗаполненияПолномочий,
				|СовместныеПолномочия, НесколькоПредставителей,
				|ИННДоверителяРодительскойДоверенности, НомерДоверенности, НомерРодительскойДоверенности, Представители";

	РеквизитыМЧД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(МЧД, Реквизиты);
	
	Результат = МашиночитаемыеДоверенности.НовыеСведенияМЧД();
	Результат.Ссылка = МЧД;
	Результат.НомерДоверенности = РеквизитыМЧД.НомерДоверенности;
	Результат.НомерРодительскойДоверенности = РеквизитыМЧД.НомерРодительскойДоверенности;
	Результат.ДатаВыдачи = РеквизитыМЧД.ДатаВыдачи;
	Результат.ДатаОкончания = РеквизитыМЧД.ДатаОкончания;
	Результат.ИННДоверителя = РеквизитыМЧД.ДоверительИНН;
	Результат.ИННДоверителяРодительскойДоверенности = РеквизитыМЧД.ИННДоверителяРодительскойДоверенности;
	
	Представители = РеквизитыМЧД.Представители.Выбрать(); 
	ИННПредставителей = Новый Массив;
	Пока Представители.Следующий() Цикл
		ИННПредставителей.Добавить(Представители.ПредставительИНН);	
	КонецЦикла;
	Результат.ИННПредставителей = ИННПредставителей;	
	
	Результат.СтатусВРеестреФНС = РеквизитыМЧД.СтатусВРеестреФНС;
	Результат.ДатаПолученияСведений = РеквизитыМЧД.ДатаЗагрузкиИзРеестра;
	Результат.Подписана = РеквизитыМЧД.Подписана;
	Результат.Верна = РеквизитыМЧД.Верна;
	Результат.Отозвана = РеквизитыМЧД.Отозвана;
	Результат.ДатаОтзыва = РеквизитыМЧД.ДатаОтзыва;
	Результат.ПолномочияОграничены = РеквизитыМЧД.ПолномочияОграничены;
	Результат.ПолномочияУказаныИзКлассификатора = МашиночитаемыеДоверенности.ПолномочияМЧДУказаныИзКлассификатора( ,
		РеквизитыМЧД.ВариантЗаполненияПолномочий);
	Результат.ПравилоПроверки = РегистрыСведений.ПравилаПроверкиПолномочийПоМЧД.ПравилоПроверки(МЧД);
	Результат.СовместныеПолномочия = РеквизитыМЧД.СовместныеПолномочия;
	Результат.НесколькоПредставителей = РеквизитыМЧД.НесколькоПредставителей;
	
	Возврат Результат;
	
КонецФункции

// Ищет МЧД контрагента, а в случае неудачного поиска создает новую МЧД
// 
// Параметры:
//  ДанныеДоверенности - см. МашиночитаемыеДоверенности.НовыеДанныеДоверенности
// 
// Возвращаемое значение:
//  Структура:
//  * Ссылка - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
//  * Ошибка - Булево
//  * ОписаниеОшибки - Строка
//  
Функция НайтиСоздатьМЧД(ДанныеДоверенности) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Ссылка", ПустаяСсылка());
	Результат.Вставить("Ошибка", Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	
	МЧД = НайтиПоРеквизиту("НомерДоверенности", ДанныеДоверенности.НомерДоверенности);
	
	Если ЗначениеЗаполнено(МЧД) Тогда
		Результат.Ссылка = МЧД;
	Иначе
		
		НачатьТранзакцию();
		
		Попытка
		
			Блокировка = Новый БлокировкаДанных();
			ЭлементБлокировки = Блокировка.Добавить("Справочник.МашиночитаемыеДоверенностиКонтрагентов");
			ЭлементБлокировки.УстановитьЗначение("НомерДоверенности", ДанныеДоверенности.НомерДоверенности);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			МЧД = НайтиПоРеквизиту("НомерДоверенности", ДанныеДоверенности.НомерДоверенности);
			
			Если ЗначениеЗаполнено(МЧД) Тогда
				Результат.Ссылка = МЧД;
			Иначе
				
				УстановитьПривилегированныйРежим(Истина);
				МЧД = СоздатьЭлемент();
				МЧД.НомерДоверенности = ДанныеДоверенности.НомерДоверенности;
				МЧД.ДоверительИНН = ДанныеДоверенности.ИННДоверителя;
				МЧД.Записать();
				Результат.Ссылка = МЧД.Ссылка;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		
		Исключение
			
			ОтменитьТранзакцию();
			Результат.Ошибка = Истина;
			Результат.ОписаниеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
		КонецПопытки;
			
	КонецЕсли;
	
	Возврат Результат;
			
КонецФункции

// Заполняет элемент справочника МЧД сведениями.
// 
// Параметры:
//  НомерДоверенности - Строка
//  ИННДоверителя - Строка
//  Сведения - См. МашиночитаемыеДоверенности.ПолучитьСведенияДоверенностиНаСервереМЧД
//
// Возвращаемое значение:
//  См. МашиночитаемыеДоверенности.НовыеДанныеСтатусаМЧД
//
Функция ЗаполнитьМЧД(НомерДоверенности, ИННДоверителя, Сведения) Экспорт
	
	Результат = МашиночитаемыеДоверенности.НовыеДанныеСтатусаМЧД();
	
	ДанныеДоверенности = МашиночитаемыеДоверенности.НовыеДанныеДоверенности();
	ДанныеДоверенности.НомерДоверенности = НомерДоверенности;
	ДанныеДоверенности.ИННДоверителя = ИННДоверителя;
	
	РезультатСоздания = НайтиСоздатьМЧД(ДанныеДоверенности);
	
	Если РезультатСоздания.Ошибка Тогда
		
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = РезультатСоздания.ОписаниеОшибки;
		Возврат Результат;
		
	КонецЕсли;
	
	МЧД = РезультатСоздания.Ссылка;
	
	ДанныеПодготовлены = 0;
	КлючевыеРеквизиты = "";
	
	ДанныеДляЗагрузки = МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляЗагрузкиМЧД();

	Попытка
		
		ДанныеДляЗагрузки.ДанныеДоверенности = Сведения.ПолныеДанные.ДанныеВыгрузки;
		ДанныеДляЗагрузки.ДанныеПодписи = Сведения.ПолныеДанные.ДанныеПодписи;
		ДанныеДляЗагрузки.ДанныеПодписиЗаявленияНаОтмену = Сведения.ПолныеДанные.ДанныеПодписиЗаявленияНаОтмену;
		
		РезультатЧтения = МашиночитаемыеДоверенности.ДанныеИзФайлаОбмена(ДанныеДляЗагрузки.ДанныеДоверенности);
		Если НЕ РезультатЧтения.Успех Тогда
			Результат.Ошибка = Истина;
			Результат.ОписаниеОшибки = РезультатЧтения.ТекстОшибки;
			Возврат Результат;
		КонецЕсли;
		
		ДанныеДоверенности = РезультатЧтения.ДанныеДоверенности;
		
	Исключение
		
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Результат;
		
	КонецПопытки;

	СтатусДоверенности = 
		МашиночитаемыеДоверенностиКлиентСервер.СтатусВРеестреФНС(Сведения.ЧастичныеДанные.СтатусДоверенности);
	ДанныеДоверенности.Вставить("СтатусВРеестреФНС", СтатусДоверенности);
	ДанныеДоверенности.Вставить("ДатаЗагрузкиИзРеестра", Сведения.ДатаЗагрузкиИзРеестра);
	
	Если ДанныеДоверенности.ТипОрганизации = "ЮЛ" Тогда
		КлючевыеРеквизиты = "ДоверительЮЛ_ИНН, ДоверительЮЛ_КПП";
	ИначеЕсли ДанныеДоверенности.ТипОрганизации = "ФЛ" Тогда
		КлючевыеРеквизиты = "ДоверительФЛ_ИНН, ДоверительФЛ_СНИЛС";
	Иначе
		КлючевыеРеквизиты = ?(ЗначениеЗаполнено(ДанныеДоверенности.ДоверительЮЛ_ИНН), 
			"ДоверительЮЛ_ИНН", "ДоверительФЛ_ИНН");
	КонецЕсли;

	КлючевыеРеквизиты = КлючевыеРеквизиты + ", НомерДоверенности, ДатаВыдачи, ДатаОкончания, Представители";
	КлючевыеРеквизиты = Новый Структура(КлючевыеРеквизиты);
	
	ТекстОшибки = "";
	Для Каждого СтрокаКлюча Из КлючевыеРеквизиты Цикл
		Если ДанныеДоверенности.Свойство(СтрокаКлюча.Ключ)
			И ЗначениеЗаполнено(ДанныеДоверенности[СтрокаКлюча.Ключ]) Тогда
			ДанныеПодготовлены = ДанныеПодготовлены + 1;
		ИначеЕсли ПустаяСтрока(ТекстОшибки) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнены реквизиты справочника'") + ":  " + СтрокаКлюча.Ключ;
		Иначе
			ТекстОшибки = ТекстОшибки + ", " + СтрокаКлюча.Ключ;
		КонецЕсли;
	КонецЦикла;

	Если КлючевыеРеквизиты.Количество() <> ДанныеПодготовлены Тогда
		
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = ТекстОшибки;
		Возврат Результат;

	КонецЕсли;
			
	РезультатЗаписи = ЗаписатьЭлементСправочника(МЧД, РезультатЧтения, ДанныеДляЗагрузки);
	ЗаполнитьЗначенияСвойств(Результат, РезультатЗаписи);
		
	Возврат Результат;
	
КонецФункции

// Загружает в элемент справочника данные из архива с файлом МЧД и подписью.
// Если доверенности с таким номером нет, то создает новую, иначе перезаполняет существующую.
//
// Параметры:
//  ДанныеФайла - ДвоичныеДанные, Строка - Двоичные данные архива или адрес во временном хранилище,
//  			- см. МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляЗагрузкиМЧД.
//  МЧД			- Неопределено
//  			- СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
//  ДополнительныеСведения - См. МашиночитаемыеДоверенностиКлиентСервер.ДополнительныеСведенияПоЗагрузкеМЧД
//  						- Неопределено
//
// Возвращаемое значение:
//  Структура:
//  * ТекстОшибки - Строка
//  * МЧД - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов - Ссылка на МЧД контрагента.
//  * ТребуетсяПроверкаМЧДНаКлиенте - Булево - Флаг устанавливается в Истина, 
//                                             если отсутствует возможность проверить подпись МЧД на сервере 
//                                             (в настройках установлена проверка подписи на клиенте) 
//                                             и необходимо выполнить проверку на клиенте.
//  * ДанныеДляПроверки - Неопределено
//                      - см. МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляПроверкиМЧД
//
Функция ЗагрузитьМЧДИзФайла(ДанныеФайла, МЧД = Неопределено, ДополнительныеСведения = Неопределено) Экспорт
	
	ТребуетсяПроверкаМЧДНаКлиенте = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить("МЧД", ПустаяСсылка());
	Результат.Вставить("ТребуетсяПроверкаМЧДНаКлиенте", ТребуетсяПроверкаМЧДНаКлиенте);
	Результат.Вставить("ДанныеДляПроверки", Неопределено);
	Результат.Вставить("ТекстОшибки", "");
	
	Данные = Неопределено;
	
	Если ТипЗнч(ДанныеФайла) = Тип("Структура") Тогда
		Данные = ДанныеФайла;
	Иначе
		Данные = МашиночитаемыеДоверенности.ПрочитатьАрхив(ДанныеФайла);
		Если Данные = Неопределено Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
		
	ДанныеДляПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляПроверкиМЧД();
	ДанныеДляПроверки.ДанныеДоверенности = Данные.ДанныеДоверенности;
	ДанныеДляПроверки.ДанныеПодписи = Данные.ДанныеПодписи;

	Результат.ДанныеДляПроверки = ДанныеДляПроверки;
	
	ДанныеДляЗагрузки = МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляЗагрузкиМЧД();
	ДанныеДляЗагрузки.ДанныеДоверенности = Данные.ДанныеДоверенности;
	ДанныеДляЗагрузки.ДанныеПодписи = Данные.ДанныеПодписи;
	ДанныеДляЗагрузки.ДанныеПодписиЗаявленияНаОтмену = Данные.ДанныеПодписиЗаявленияНаОтмену;	
	
	ВидОперации = НСтр("ru = 'Загрузка машиночитаемой доверенности из файла.'");
	ДанныеДоверенности = Неопределено;
		
	Попытка
		
		РезультатЧтения = МашиночитаемыеДоверенности.ДанныеИзФайлаОбмена(ДанныеДляЗагрузки.ДанныеДоверенности);
		Если НЕ РезультатЧтения.Успех Тогда
			Результат.ТекстОшибки = РезультатЧтения.ТекстОшибки;
			Возврат Результат;
		КонецЕсли;
		
		ДанныеДоверенности = РезультатЧтения.ДанныеДоверенности;
		
	Исключение
		
		ТекстОшибки = НСтр("ru = 'Ошибка при чтении файла доверенности: файл не соответствует формату ФНС.'");
		ПодробныйТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстОшибки);
		Возврат Результат;
		
	КонецПопытки;
	
	РезультатПроверки =
		МашиночитаемыеДоверенности.ПроверитьКлючевыеРеквизитыДанныхФайлаДоверенности(ДанныеДоверенности);
	Если РезультатПроверки.ЕстьОшибки Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка при заполнении доверенности из файла:'")
			+ Символы.ПС + РезультатПроверки.ТекстОшибки;
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстОшибки);
		Возврат Результат;
	КонецЕсли;
	
	НайденнаяМЧД = МЧД;
	
	Если НЕ ЗначениеЗаполнено(НайденнаяМЧД) Тогда
		НайденнаяМЧД = НайтиПоРеквизиту("НомерДоверенности", ДанныеДоверенности.НомерДоверенности);
	КонецЕсли;
	
	Если ДополнительныеСведения = Неопределено Тогда
		ДополнительныеСведения = МашиночитаемыеДоверенностиКлиентСервер.ДополнительныеСведенияПоЗагрузкеМЧД();
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Если ЗначениеЗаполнено(НайденнаяМЧД) Тогда
			ОбъектСправочника = ОбщегоНазначенияБЭД.ОбъектПоСсылкеДляИзменения(НайденнаяМЧД);
		Иначе
			ОбъектСправочника = СоздатьЭлемент();
		КонецЕсли;
		
		ОбъектСправочника.ДатаЗагрузки = ДополнительныеСведения.ДатаЗагрузки;
		Если ЗначениеЗаполнено(ДополнительныеСведения.СтатусВРеестреФНС) Тогда
			ОбъектСправочника.СтатусВРеестреФНС = ДополнительныеСведения.СтатусВРеестреФНС;
		КонецЕсли;
		Если ДанныеДоверенности <> Неопределено Тогда
			ДанныеДоверенности.ДатаЗагрузкиИзРеестра = ДополнительныеСведения.ДатаЗагрузки;
		КонецЕсли;
		ЗаполнитьЭлементСправочника(ОбъектСправочника,
			РезультатЧтения, ДанныеДляЗагрузки, ТребуетсяПроверкаМЧДНаКлиенте);
		Результат.ТребуетсяПроверкаМЧДНаКлиенте = ТребуетсяПроверкаМЧДНаКлиенте;
		ОбъектСправочника.ПолномочияОграничены = МашиночитаемыеДоверенности.ПолномочияОграничены(ДанныеДоверенности);
		ОбъектСправочника.Записать();
		Результат.МЧД = ОбъектСправочника.Ссылка;
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Операция = НСтр("ru = 'Загрузка доверенности из файла'");
		ПодробныйТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'Не удалось загрузить доверенность. Подробности в журнале регистрации'");
		ОбработкаНеисправностейБЭД.ОбработатьОшибку(Операция,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами,
			ПодробныйТекстОшибки, ТекстСообщения, НайденнаяМЧД);
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Загружает элемент справочника из файла обмена.
// 
// Параметры:
//  ДанныеДляЗагрузки - см. МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляЗагрузкиМЧД
//  ТребуетсяПроверкаМЧДНаКлиенте - Булево - Флаг устанавливается в Истина, 
//                                             если отсутствует возможность проверить подпись МЧД на сервере 
//                                             (в настройках установлена проверка подписи на клиенте) 
//                                             и необходимо выполнить проверку на клиенте.
//  ОбновлятьСуществующий - Булево - Если Истина, то будет обновлен существующий элемент, если он найден.
//  ДополнительныеСведения - Неопределено, Структура - Если переданы, то будут заполнены в элементе справочника.
// 
// Возвращаемое значение:
//  Структура - Результат загрузки:
//   * Выполнено - Булево - Признак успешности выполнения загрузки.
//   * Ссылка - Неопределено, СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов - Ссылка на элемент справочника.
//   * Ошибка - Строка - Текст ошибки, если не удалось загрузить элемент.
//   * ОткрытьФормуДляОбновления - Булево - Признак открытия формы просмотра для обновления.
//
Функция ЗагрузитьЭлементИзФайлаОбмена(ДанныеДляЗагрузки, ТребуетсяПроверкаМЧДНаКлиенте, ОбновлятьСуществующий = Ложь,
	ДополнительныеСведения = Неопределено) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Выполнено", Ложь);
	Результат.Вставить("Ссылка", Неопределено);
	Результат.Вставить("Ошибка", "");
	Результат.Вставить("ОткрытьФормуДляОбновления", Ложь);

	ДанныеПодготовлены = 0;
	КлючевыеРеквизиты = "";
	ТекстОшибки = "";
	Успешно = Истина;
	ТекущийЭлемент = Неопределено;
	
	Попытка
		
		РезультатЧтения = МашиночитаемыеДоверенности.ДанныеИзФайлаОбмена(ДанныеДляЗагрузки.ДанныеДоверенности, Ложь);
		Если НЕ РезультатЧтения.Успех Тогда
			Результат.Ошибка = РезультатЧтения.ТекстОшибки;
			Возврат Результат;
		КонецЕсли;
		
		ДанныеДоверенности = РезультатЧтения.ДанныеДоверенности;
		
	Исключение
		
		ИмяСобытия = НСтр("ru = 'Не удалось получить данные доверенности.'", ОбщегоНазначения.КодОсновногоЯзыка());
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		Результат.Ошибка = ТекстОшибки;
		Успешно = Ложь;
		
	КонецПопытки;
	
	Если Успешно Тогда

		Если ДанныеДоверенности.ТипОрганизации = "ЮЛ" Тогда
			КлючевыеРеквизиты = "ДоверительЮЛ_ИНН, ДоверительЮЛ_КПП";
		ИначеЕсли ДанныеДоверенности.ТипОрганизации = "ФЛ" Тогда
			КлючевыеРеквизиты = "ДоверительФЛ_ИНН, ДоверительФЛ_СНИЛС";
		Иначе
			КлючевыеРеквизиты = "ДоверительЮЛ_ИНН, ДоверительЮЛ_КПП";
		КонецЕсли;

		КлючевыеРеквизиты = КлючевыеРеквизиты + ",НомерДоверенности, ДатаВыдачи, ДатаОкончания, Организация, Представители";

		КлючевыеРеквизиты = Новый Структура(КлючевыеРеквизиты);

		Для Каждого СтрокаКлюча Из КлючевыеРеквизиты Цикл
			Если ДанныеДоверенности.Свойство(СтрокаКлюча.Ключ) И ЗначениеЗаполнено(
				ДанныеДоверенности[СтрокаКлюча.Ключ]) Тогда
				ДанныеПодготовлены = ДанныеПодготовлены + 1;
			ИначеЕсли ПустаяСтрока(ТекстОшибки) Тогда
				ТекстОшибки = НСтр("ru = 'Не заполнены реквизиты справочника'") + ":  " + СтрокаКлюча.Ключ;
			Иначе
				ТекстОшибки = ТекстОшибки + ", " + СтрокаКлюча.Ключ;
			КонецЕсли;
		КонецЦикла;

		Если ЗначениеЗаполнено(ДополнительныеСведения) Тогда
			ДанныеДоверенности.Вставить("СтатусВРеестреФНС", ДополнительныеСведения.СтатусВРеестреФНС);
			ДанныеДоверенности.Вставить("ДатаЗагрузкиИзРеестра", ДополнительныеСведения.ДатаЗагрузкиИзРеестра);
		КонецЕсли;
		
		ТекущийЭлемент = 
			ЗаписатьЭлементСправочникаМЧДКонтрагентов(РезультатЧтения, ОбновлятьСуществующий, ДанныеДляЗагрузки, 
				ТребуетсяПроверкаМЧДНаКлиенте);
		Результат.Ссылка = ТекущийЭлемент.Ссылка;
		Результат.ОткрытьФормуДляОбновления = ТекущийЭлемент.ОткрытьФормуДляОбновления;

	КонецЕсли;

	Если ЗначениеЗаполнено(ТекущийЭлемент) Тогда
		Результат.Выполнено = Истина;
	Иначе
		Результат.Ошибка = НСтр(
			"ru = 'Не удалось записать элемент справочника. Подробности в журнале регистрации.'");
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Определяет наличие у пользователя прав на изменение машиночитаемых доверенностей контрагентов.
//
// Возвращаемое значение:
//  Булево - Истина, если у пользователя есть право на изменение, иначе Ложь.
//
Функция ЕстьПравоИзменения() Экспорт
	
	Возврат ПравоДоступа("Изменение", Метаданные.Справочники.МашиночитаемыеДоверенностиКонтрагентов);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Ищет доверенности
// 
// Параметры:
//  НомерДоверенности - Строка
//  ВключаяПомеченныеНаУдаление - Булево
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
Функция НайтиДоверенности(НомерДоверенности, ВключаяПомеченныеНаУдаление = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МашиночитаемыеДоверенностиКонтрагентов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.МашиночитаемыеДоверенностиКонтрагентов КАК МашиночитаемыеДоверенностиКонтрагентов
		|ГДЕ
		|	МашиночитаемыеДоверенностиКонтрагентов.НомерДоверенности = &НомерДоверенности
		|	И (&ВключаяПомеченныеНаУдаление	ИЛИ НЕ МашиночитаемыеДоверенностиКонтрагентов.ПометкаУдаления)";
	
	Запрос.УстановитьПараметр("НомерДоверенности", НомерДоверенности);
	Запрос.УстановитьПараметр("ВключаяПомеченныеНаУдаление", ВключаяПомеченныеНаУдаление);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Записывает элемент справочника, заполнив переданными данными.
// 
// Параметры:
//  МЧД - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов - МЧД
//  ДанныеИзФайлаОбмена - см. МашиночитаемыеДоверенности.ДанныеИзФайлаОбмена
//  ДанныеДляЗагрузки - см. МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляЗагрузкиМЧД
// 
// Возвращаемое значение:
//  См. МашиночитаемыеДоверенности.НовыеДанныеСтатусаМЧД
//	
Функция ЗаписатьЭлементСправочника(МЧД, ДанныеИзФайлаОбмена, ДанныеДляЗагрузки)
	
	ДанныеДоверенности = ДанныеИзФайлаОбмена.ДанныеДоверенности;
	
	ТребуетсяПроверкаМЧДНаКлиенте = Ложь;	
	Результат = МашиночитаемыеДоверенности.НовыеДанныеСтатусаМЧД();
	
	НеочищаемыеРеквизиты = Новый Массив;
	НеочищаемыеРеквизиты.Добавить("НомерДоверенности");
	НеочищаемыеРеквизиты.Добавить("ДоверительИНН");
	
	ОбъектСправочника = МЧД.ПолучитьОбъект();
	
	ДанныеДляПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляПроверкиМЧД();
	ДанныеДляПроверки.ДанныеДоверенности = ДанныеДляЗагрузки.ДанныеДоверенности;
	ДанныеДляПроверки.ДанныеПодписи = ДанныеДляЗагрузки.ДанныеПодписи;
	
	Если МашиночитаемыеДоверенности.ТребуетсяПерезаполнениеМЧД(ОбъектСправочника, ДанныеДляЗагрузки) Тогда
			
		Для Каждого СтрокаРеквизита Из ОбъектСправочника.Метаданные().Реквизиты Цикл
			Если НеочищаемыеРеквизиты.Найти(СтрокаРеквизита.Имя) = Неопределено Тогда
				ОбъектСправочника[СтрокаРеквизита.Имя] = Неопределено;
			КонецЕсли;
		КонецЦикла;
		
		ЗаполнитьЭлементСправочника(ОбъектСправочника, ДанныеИзФайлаОбмена, ДанныеДляЗагрузки,
			ТребуетсяПроверкаМЧДНаКлиенте);
		Результат.ТребуетсяПроверкаМЧДНаКлиенте = ТребуетсяПроверкаМЧДНаКлиенте;
		
		ОбъектСправочника.СтатусВРеестреФНС = ДанныеДоверенности.СтатусВРеестреФНС;
		
	КонецЕсли;

	ОтсутствуетВозможностьПроверитьНаСервере = Не ЭлектроннаяПодпись.ПроверятьЭлектронныеПодписиНаСервере();
	ЭтоПровереннаяРеестроваяМЧД =
		МашиночитаемыеДоверенности.ЭтоПровереннаяРеестроваяМЧД(ДанныеДляПроверки, ДанныеДоверенности);
	
	Если ЭтоПровереннаяРеестроваяМЧД И ОтсутствуетВозможностьПроверитьНаСервере Тогда
		ОбъектСправочника.Верна = Истина;
	КонецЕсли;
	
	ОбъектСправочника.ПолномочияОграничены = МашиночитаемыеДоверенности.ПолномочияОграничены(ДанныеДоверенности);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.МашиночитаемыеДоверенностиКонтрагентов");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", ОбъектСправочника.Ссылка);
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		ОбъектСправочника.Записать();
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИмяСобытия = НСтр("ru = 'Ошибка изменения МЧД.'", ОбщегоНазначения.КодОсновногоЯзыка());
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = ТекстОшибки;
		Возврат Результат;
		
	КонецПопытки;
	
	СведенияМЧД = МашиночитаемыеДоверенности.НовыеСведенияМЧД();
	СведенияМЧД.Ссылка = МЧД;
	СведенияМЧД.ИННДоверителя = ОбъектСправочника.ДоверительИНН;
	
	ИННПредставителей = Новый Массив();
	Для Каждого Представитель Из ОбъектСправочника.Представители Цикл
		ИННПредставителей.Добавить(Представитель.ПредставительИНН);	
	КонецЦикла;
	СведенияМЧД.ИННПредставителей = ИННПредставителей;
	
	СведенияМЧД.ДатаПолученияСведений = ОбъектСправочника.ДатаЗагрузкиИзРеестра;
	СведенияМЧД.Полномочия = ДанныеДоверенности.Полномочия;
	
	Свойства = "ДатаВыдачи, ДатаОкончания, СтатусВРеестреФНС, Подписана, Верна, Отозвана, ДатаОтзыва,
		|ПолномочияОграничены, ВариантЗаполненияПолномочий, СовместныеПолномочия, НесколькоПредставителей,
		|ИННДоверителяРодительскойДоверенности, НомерРодительскойДоверенности";
	
	ЗаполнитьЗначенияСвойств(СведенияМЧД, ОбъектСправочника, Свойства);
	СведенияМЧД.ПравилоПроверки = РегистрыСведений.ПравилаПроверкиПолномочийПоМЧД.ПравилоПроверки(МЧД);
	СведенияМЧД.ПолномочияУказаныИзКлассификатора = МашиночитаемыеДоверенности.ПолномочияМЧДУказаныИзКлассификатора( ,
		ОбъектСправочника.ВариантЗаполненияПолномочий);
	Результат.Сведения = СведенияМЧД;
	
	Возврат Результат;
	
КонецФункции

// Записать элемент справочника Машиночитаемые Доверенности Контрагентов.
// 
// Параметры:
//  ДанныеИзФайлаОбмена   - см. МашиночитаемыеДоверенности.ДанныеИзФайлаОбмена
//  ОбновлятьСуществующий - Булево - Обновлять существующий
//  ДанныеДляЗагрузки - см. МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляЗагрузкиМЧД
//  ТребуетсяПроверкаМЧДНаКлиенте - Булево - Флаг устанавливается в Истина, 
//                                             если отсутствует возможность проверить подпись МЧД на сервере 
//                                             (в настройках установлена проверка подписи на клиенте) 
//                                             и необходимо выполнить проверку на клиенте.
//  
//  Возвращаемое значение:
//  Структура:
//	* Ссылка - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов - Ссылка на элемент справочника.
//	* ОткрытьФормуДляОбновления - Булево - Признак открытия формы просмотра для обновления.
//	* ТребуетсяПроверкаМЧДНаКлиенте - Булево - Флаг устанавливается в Истина, 
//                                             если отсутствует возможность проверить подпись МЧД на сервере 
//                                             (в настройках установлена проверка подписи на клиенте) 
//                                             и необходимо выполнить проверку на клиенте.
//
Функция ЗаписатьЭлементСправочникаМЧДКонтрагентов(ДанныеИзФайлаОбмена, ОбновлятьСуществующий, ДанныеДляЗагрузки, 
	ТребуетсяПроверкаМЧДНаКлиенте)
	
	ДанныеДоверенности = ДанныеИзФайлаОбмена.ДанныеДоверенности;
	
	Результат = Новый Структура;
	Результат.Вставить("Ссылка", ПустаяСсылка());
	Результат.Вставить("ОткрытьФормуДляОбновления", Ложь); 
	Результат.Вставить("ТребуетсяПроверкаМЧДНаКлиенте", Ложь);
	
	НайденнаяМЧД = Неопределено;

	Если ОбновлятьСуществующий Тогда
		НайденнаяМЧД = НайтиПоРеквизиту("НомерДоверенности", ДанныеДоверенности.НомерДоверенности);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Если Не ЗначениеЗаполнено(НайденнаяМЧД) Тогда
			ОбъектСправочника = СоздатьЭлемент();
		Иначе
			ОбъектСправочника = ОбщегоНазначенияБЭД.ОбъектПоСсылкеДляИзменения(НайденнаяМЧД);
		КонецЕсли;
		
		ЗаполнитьЭлементСправочника(ОбъектСправочника, ДанныеИзФайлаОбмена, ДанныеДляЗагрузки,
			ТребуетсяПроверкаМЧДНаКлиенте);
		Удачно = Ложь;
		
		Если ОбъектСправочника.ПроверитьЗаполнение() Тогда
			
			ОбъектСправочника.ПолномочияОграничены = МашиночитаемыеДоверенности.ПолномочияОграничены(ДанныеДоверенности);
			ОбъектСправочника.Записать();
			Удачно = Истина;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		Удачно = Ложь;
		ОтменитьТранзакцию();
		Операция = НСтр("ru = 'Запись МЧД контрагента'");
		ПодробныйТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'Не удалось записать данные доверенности. Подробности в журнале регистрации'");
		ОбработкаНеисправностейБЭД.ОбработатьОшибку(Операция,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами,
			ПодробныйТекстОшибки, ТекстСообщения, НайденнаяМЧД);
		
	КонецПопытки;
	
	Если Удачно Тогда
		Результат.Ссылка = ОбъектСправочника.Ссылка;
		Результат.ОткрытьФормуДляОбновления = Ложь; 
		Результат.ТребуетсяПроверкаМЧДНаКлиенте = ТребуетсяПроверкаМЧДНаКлиенте;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Заполняет элемент справочника.
//
// Параметры:
//  ОбъектСправочника - СправочникОбъект.МашиночитаемыеДоверенностиКонтрагентов
//  ДанныеИзФайлаОбмена - см. МашиночитаемыеДоверенности.ДанныеИзФайлаОбмена
//  ДанныеДляЗагрузки - см. МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляЗагрузкиМЧД
//  ТребуетсяПроверкаМЧДНаКлиенте - Булево - Флаг устанавливается в Истина, 
//                                             если отсутствует возможность проверить подпись МЧД на сервере 
//                                             (в настройках установлена проверка подписи на клиенте) 
//                                             и необходимо выполнить проверку на клиенте.
//
Процедура ЗаполнитьЭлементСправочника(ОбъектСправочника, ДанныеИзФайлаОбмена, ДанныеДляЗагрузки,
	ТребуетсяПроверкаМЧДНаКлиенте)
	
	ДанныеДоверенности = ДанныеИзФайлаОбмена.ДанныеДоверенности;
	
	ЗаполнитьЗначенияСвойств(ОбъектСправочника, ДанныеДоверенности);
	
	ДоверительФЛ = "";

	Для каждого Строка Из ДанныеДоверенности.ФИО Цикл
		ФИО = Строка.Фамилия + " " + Строка.Имя;
		Если Строка.Отчество <> Неопределено Тогда
			ФИО = ФИО + " " + Строка.Отчество;
		КонецЕсли;
		Если Строка.Владелец = Перечисления.СубъектыДоверенности.ДоверительФЛ Тогда
			ДоверительФЛ = ФИО;
		КонецЕсли; 
	КонецЦикла;
	
	Если ДанныеДоверенности.ТипОрганизации = "ФЛ" Тогда
		ОбъектСправочника.Доверитель = ДоверительФЛ;
		ОбъектСправочника.ДоверительИНН = ДанныеДоверенности.ДоверительФЛ_ИНН;
	Иначе
		ОбъектСправочника.Доверитель = ДанныеДоверенности.ДоверительЮЛ_НаимОрг;
		ОбъектСправочника.ДоверительИНН = ?(ЗначениеЗаполнено(ДанныеДоверенности.ДоверительЮЛ_ИНН),
			ДанныеДоверенности.ДоверительЮЛ_ИНН, ДанныеДоверенности.ДоверительФЛ_ИНН);
	КонецЕсли;
	
	Если ОбъектСправочника.Представители.Количество() > 0 Тогда
		ОбъектСправочника.Представители.Очистить();	
	КонецЕсли;
	
	Для Каждого Представитель Из ДанныеДоверенности.Представители Цикл
		
		НовыйПредставитель = ОбъектСправочника.Представители.Добавить();
		
		Если Представитель.Свойство("ПредставительФЛ_ИНН") Тогда

			ФИО = Представитель.Фамилия + " " + Представитель.Имя;
			Если Строка.Отчество <> Неопределено Тогда
				ФИО = ФИО + " " + Представитель.Отчество;
			КонецЕсли;
			
			НовыйПредставитель.Представитель = ФИО;
			НовыйПредставитель.ПредставительИНН = Представитель.ПредставительФЛ_ИНН;
		Иначе
			НовыйПредставитель.Представитель = Представитель.ПредставительЮЛ_НаимОрг;
			НовыйПредставитель.ПредставительИНН = Представитель.ПредставительЮЛ_ИНН;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбъектСправочника.ЕстьВРеестреФНС = ЗначениеЗаполнено(ОбъектСправочника.ДатаЗагрузкиИзРеестра);
	
	МашиночитаемыеДоверенности.ЗаполнитьРеквизитыОтзыва(ОбъектСправочника, ДанныеДляЗагрузки);
	Если Не ЗначениеЗаполнено(ОбъектСправочника.ДатаОтзыва)
		И ОбъектСправочника.СтатусВРеестреФНС = Перечисления.СтатусыМашиночитаемойДоверенностиВРеестреФНС.Отозвано Тогда
		ОбъектСправочника.Отозвана = Истина;
		ОбъектСправочника.ДатаОтзыва = ОбъектСправочника.ДатаЗагрузкиИзРеестра;
	КонецЕсли;
		
	ДанныеДляПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляПроверкиМЧД();
	ДанныеДляПроверки.ДанныеДоверенности = ДанныеДляЗагрузки.ДанныеДоверенности;
	ДанныеДляПроверки.ДанныеПодписи = ДанныеДляЗагрузки.ДанныеПодписи;
	МашиночитаемыеДоверенности.ЗаполнитьПодписанаВерна(ОбъектСправочника, ДанныеДляПроверки, ТребуетсяПроверкаМЧДНаКлиенте);
	
	Если Не ЗначениеЗаполнено(ОбъектСправочника.ВариантЗаполненияПолномочий) Тогда
		
		Если МашиночитаемыеДоверенности.ФорматМЧДПоддерживаетКлассификаторПолномочий(ДанныеИзФайлаОбмена.ВерсияФорматаМЧД)
			И ДанныеДоверенности.Полномочия.Количество() > 0 Тогда
			
			ПолномочияКодифицированы = Истина;
			
			Для Каждого Полномочие Из ДанныеДоверенности.Полномочия Цикл
				Если Не ЗначениеЗаполнено(Полномочие.Код) Тогда
					ПолномочияКодифицированы = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ПолномочияКодифицированы Тогда
				ОбъектСправочника.ВариантЗаполненияПолномочий = Перечисления.ВариантыЗаполненияПолномочийМЧД.КлассификаторФНС;
			Иначе
				ОбъектСправочника.ВариантЗаполненияПолномочий = Перечисления.ВариантыЗаполненияПолномочийМЧД.Текст;
			КонецЕсли;
		
		Иначе
			
			ОбъектСправочника.ВариантЗаполненияПолномочий = Перечисления.ВариантыЗаполненияПолномочийМЧД.Текст;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Идентифицирует нереестровую МЧД.
// 
// Параметры:
//  МЧД - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
// 
// Возвращаемое значение:
//  Булево
//  
Функция ЭтоНереестроваяМЧД(МЧД) Экспорт
	
	ДанныеДоверенностиМЧД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(МЧД, "Подписана, СтатусВРеестреФНС");
	Возврат ДанныеДоверенностиМЧД.Подписана И НЕ ЗначениеЗаполнено(ДанныеДоверенностиМЧД.СтатусВРеестреФНС);
	
КонецФункции

#КонецОбласти

#КонецЕсли