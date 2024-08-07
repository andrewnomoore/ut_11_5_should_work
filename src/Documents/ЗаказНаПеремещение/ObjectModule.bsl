#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса
//								Конструктор структуры: ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа().
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыВнутреннихЗаказов[НовыйСтатус];
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		ЗаказыСервер.СкорректироватьСтрокиЗаказа(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
	Статус = ЗначениеНовогоСтатуса;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

// Корректирует строки, по которым не была оформлено перемещение или складские оредера или имеются расхождения по мерным
// товарам.
//
// Параметры:
// 		СтруктураПараметров - Структура - Структура параметров корректировки, конструктор: ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа().
//
// Возвращаемое значение:
// 		Структура
// 		*	КоличествоСтрок - Количество отмененных/скорректированных строк.
//
Функция СкорректироватьСтрокиЗаказа(СтруктураПараметров) Экспорт
	
	Если Не СтруктураПараметров.ОтменитьНеотработанныеСтроки И Не СтруктураПараметров.СкорректироватьМерныеТовары Тогда
		Возврат ЗаказыСервер.РезультатОтменыНеотработанныхСтрок(Неопределено)
	КонецЕсли;
	
	КоличествоСкорректированныхСтрок = 0;
	
	Если Не СтруктураПараметров.ПроверятьОстатки Тогда
		
		СвойстваОтмененнойСтроки = Новый Структура("Отменено, СтатусУказанияСерий", Истина, 0);
		
		Для каждого СтрокаТовары Из Товары Цикл
			Если Не СтрокаТовары.Отменено Тогда
				
				ЗаполнитьЗначенияСвойств(СтрокаТовары, СвойстваОтмененнойСтроки);
				КоличествоСкорректированныхСтрок = КоличествоСкорректированныхСтрок + 1;
				
			КонецЕсли;
		КонецЦикла;
		
		Возврат ЗаказыСервер.РезультатОтменыНеотработанныхСтрок(КоличествоСкорректированныхСтрок);
	КонецЕсли;
	
	ПараметрыЗаполнения = ЗаказыСервер.ПараметрыЗаполненияДляОтменыСтрок();
	ПараметрыЗаполнения.МенеджерРегистра  = РегистрыНакопления.ЗаказыНаПеремещение;
	ПараметрыЗаполнения.ИмяТабличнойЧасти = "Товары";
	ПараметрыЗаполнения.ПутиКДанным.Вставить("Склад", "СкладОтправитель");
	Если ОбосабливатьПоНазначениюЗаказа Тогда
		ПараметрыЗаполнения.ТаблицаЗамен = Товары.Выгрузить(,"НомерСтроки, Назначение");
		Справочники.Назначения.ЗаполнитьНазначениеОбеспечения(ПараметрыЗаполнения.ТаблицаЗамен, Назначение, "Назначение");
	КонецЕсли;
	
	ПараметрыОтмены = ЗаказыСервер.ПараметрыОтменыСтрокЗаказов();
	ПараметрыОтмены.ОтменятьТолькоМерныеТовары = НЕ СтруктураПараметров.ОтменитьНеотработанныеСтроки
		И СтруктураПараметров.СкорректироватьМерныеТовары;
	ПараметрыОтмены.СкорректироватьМерныеТовары = СтруктураПараметров.СкорректироватьМерныеТовары;
	
	РезультатОтмены = ЗаказыСервер.ОтменитьНеотработанныеСтрокиПоОтгрузке(ЭтотОбъект, ПараметрыЗаполнения, ПараметрыОтмены);
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Возврат РезультатОтмены;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

// Параметры:
//  ДанныеЗаполнения - Структура - данные для заполнения документа:
//    * Товары - ТаблицаЗначений - таблица которую нужно использовать для заполнения табличной части документа.
//    * СтандартнаяОбработка - Булево - Нужно установить ложь, если не нужно выполнять стандартную обработку события.
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеремещениеТоваров;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Основание") Тогда
		
		Если ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			ЗаполнитьПоЗаказуКлиента(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
			ЗаполнитьПоЗаявкеНаВозвратТоваровОтКлиента(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление") Тогда
			ЗаполнитьПоЗаказуНаВнутреннееПотребление(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ЗаказНаСборку") Тогда
			ЗаполнитьПоЗаказуНаСборку(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
			Или ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ПриемкаТоваровНаХранение") Тогда
			
			ЗаполнитьПоПриобретениюТоваров(ДанныеЗаполнения);
			
		Иначе
			ВызватьИсключение НСтр("ru = 'Неверные параметры создания документа на основании'");
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровНаСклад") Тогда
		ЗаполнитьПоПоступлениюТоваров(ДанныеЗаполнения);
	КонецЕсли;
	
	ЕстьВариантОбеспечения = ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
			И ДанныеЗаполнения.Свойство("Товары")
			И ТипЗнч(ДанныеЗаполнения.Товары) = Тип("ТаблицаЗначений")
			И ДанныеЗаполнения.Товары.Колонки.Найти("ВариантОбеспечения") <> Неопределено;
	
	ИнициализироватьДокумент(ДанныеЗаполнения, Не ЕстьВариантОбеспечения);
	
	ЗаказНаПеремещениеЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.ЗаказНаПеремещение.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	// Склад получатель и склад отправитель должны различаться
	Если ЗначениеЗаполнено(СкладОтправитель) И СкладОтправитель = СкладПолучатель Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Один склад не может быть как отправителем, так и получателем. Измените один из складов.'"),
			ЭтотОбъект,
			"СкладОтправитель",
			,
			Отказ);
		
	КонецЕсли;
	
	// Желаемая дата поступления в шапке должна быть не меньше даты документа
	Если ЗначениеЗаполнено(ЖелаемаяДатаПоступления) И ЖелаемаяДатаПоступления < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Желаемая дата поступления должна быть не меньше даты документа %Дата%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(Дата,"ДЛФ=DD"));
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ЖелаемаяДатаПоступления",
			,
			Отказ);
		
	КонецЕсли;
	
	// Организация-получатель должна быть взаимосвязана с организацией-отправителем по организационной структуре.
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами
		И ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ОрганизацияПолучатель)
		И Не Справочники.Организации.ОрганизацииВзаимосвязаныПоОрганизационнойСтруктуре(Организация, ОрганизацияПолучатель) Тогда
		
		ТекстОшибки = НСтр("ru='Организация-получатель должна быть взаимосвязана с организацией-отправителем по организационной структуре.'");
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ОрганизацияПолучатель",
			,
			Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("СкладОтправитель");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НачалоОтгрузки");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ОкончаниеПоступления");
	
	ПараметрыВстраивания = Документы.ЗаказНаПеремещение.ДоступныеОстаткиПараметрыВстраивания();
	ТаблицаОшибок = ОбеспечениеВДокументахСервер.ТаблицаОшибокЗаполнения(ЭтотОбъект, ПараметрыВстраивания);
	
	СкладОтправительОбязателен = Ложь;
	
	ШаблонТекста = ?(ИспользоватьДлительностьПеремещения,
		НСтр("ru='Не заполнена колонка ""Начало отгрузки"" в строке %НомерСтроки% списка ""Товары""'"),
		НСтр("ru='Не заполнена колонка ""Дата отгрузки"" в строке %НомерСтроки% списка ""Товары""'"));
		
	Для ТекИндекс = 0 По ТаблицаОшибок.Количество() - 1 Цикл
		
		СтрокаОшибки = ТаблицаОшибок[ТекИндекс];
		
		Если СтрокаОшибки.ДатаОтгрузкиОбязательна И СтрокаОшибки.ДатаОтгрузкиНеЗаполнена Тогда
			
			ТекстОшибки   = СтрЗаменить(ШаблонТекста, "%НомерСтроки%", СтрокаОшибки.НомерСтроки);
			ПутьКТабЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаОшибки.НомерСтроки, "НачалоОтгрузки");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ПутьКТабЧасти, , Отказ);
			
		КонецЕсли;
		
		СкладОтправительОбязателен = СкладОтправительОбязателен Или СтрокаОшибки.СкладОбязателен;
		
	КонецЦикла;
	
	Если СкладОтправительОбязателен И Не ЗначениеЗаполнено(СкладОтправитель) Тогда
		
		ТекстОшибки = НСтр("ru='Поле ""Склад-отправитель"" не заполнено'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "СкладОтправитель", , Отказ);
		
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из Товары Цикл
		
		АдресОшибки = " " + НСтр("ru='в строке %НомерСтроки% списка ""Товары""'");
		АдресОшибки = СтрЗаменить(АдресОшибки,"%НомерСтроки%", СтрокаТЧ.НомерСтроки);
		
		Если ИспользоватьДлительностьПеремещения
			И НЕ СтрокаТЧ.Отменено
			И НЕ ЗначениеЗаполнено(СтрокаТЧ.ОкончаниеПоступления)
			И СтрокаТЧ.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Отгрузить Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Окончание поступления""'");
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "ОкончаниеПоступления"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если ИспользоватьДлительностьПеремещения И ЗначениеЗаполнено(СтрокаТЧ.НачалоОтгрузки) И ЗначениеЗаполнено(СтрокаТЧ.ОкончаниеПоступления) И СтрокаТЧ.НачалоОтгрузки > СтрокаТЧ.ОкончаниеПоступления Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания поступления меньше даты начала отгрузки'");
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "ОкончаниеПоступления"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.НачалоОтгрузки) И СтрокаТЧ.НачалоОтгрузки < НачалоДня(Дата) Тогда
			
			ТекстОшибки = НСтр("ru='Дата начала отгрузки должна быть не меньше даты документа ""%Дата%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%Дата%", Формат(Дата, "ДЛФ=DD"));
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "НачалоОтгрузки"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если ИспользоватьДлительностьПеремещения И ЗначениеЗаполнено(СтрокаТЧ.ОкончаниеПоступления) И СтрокаТЧ.ОкончаниеПоступления < НачалоДня(Дата) Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания поступления должна быть не меньше даты документа ""%Дата%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%Дата%", Формат(Дата, "ДЛФ=DD"));
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "ОкончаниеПоступления"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДоставкаТоваров.ПроверитьЗаполнениеРеквизитовДоставки(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	ПараметрыПроверки = УчетНДСУП.ПараметрыПроверкиЗаполненияДокументаПоВидуДеятельностиНДС();
	ПараметрыПроверки.ИмяТабличнойЧасти = "Товары";
	УчетНДСУП.ПроверитьЗаполнениеДокументаПоВидуДеятельностиНДС(
		ЭтотОбъект, 
		ПеремещениеПодДеятельность, 
		ПараметрыПроверки, 
		Отказ);
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ЗаказНаПеремещениеЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ЗаказыСервер.УстановитьКлючВСтрокахТабличнойЧасти(ЭтотОбъект, "Товары");
	
	Если Не ИспользоватьДлительностьПеремещения Тогда
		Товары.ЗагрузитьКолонку(Товары.ВыгрузитьКолонку("НачалоОтгрузки"), "ОкончаниеПоступления");
	КонецЕсли;
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(
			ЭтотОбъект,
			Документы.ЗаказНаПеремещение));
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ЗаказНаПеремещение.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	ШаблонНазначения = Документы.ЗаказНаПеремещение.ШаблонНазначения(ЭтотОбъект);
	ПерегенерацияНазначения = Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(Назначение, ШаблонНазначения,
		ЭтотОбъект, "НаправлениеДеятельности", Отказ);
	
	Если ПерегенерацияНазначения Тогда
		ОбосабливатьПоНазначениюЗаказа = Константы.ВариантОбособленияТоваровВПеремещении.Получить()
			<> Перечисления.ВариантыОбособленияТоваровВПеремещении.НазначениеПолучателя;
	КонецЕсли;
	
	ЗаказНаПеремещениеЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ШаблонНазначения = Документы.ЗаказНаПеремещение.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПриЗаписиДокумента(Назначение, ШаблонНазначения, ЭтотОбъект, СкладПолучатель, ПеремещениеПодДеятельность);
	
	ЗаказНаПеремещениеЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование       = Неопределено;
	ЖелаемаяДатаПоступления = Дата(1, 1, 1);
	Если Документы.ЗаказНаПеремещение.ИспользоватьСтатусы() Тогда
		Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	Иначе
		Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт;
	КонецЕсли;
	МаксимальныйКодСтроки   = 0;
	Назначение              = Справочники.Назначения.ПустаяСсылка();
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	Для каждого СтрокаТовары Из Товары Цикл
	
		СтрокаТовары.НачалоОтгрузки = Дата(1, 1, 1);
		СтрокаТовары.ОкончаниеПоступления = Дата(1, 1, 1);
		СтрокаТовары.Отменено             = Ложь;
		СтрокаТовары.КодСтроки            = 0;
		СтрокаТовары.Назначение = Справочники.Назначения.ПустаяСсылка();
		
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
	ЗаказНаПеремещениеЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ);
	
	ВыполнитьКонтрольЗаказаПослеПроведения(Отказ);
	
	ЗаказНаПеремещениеЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ, Истина);
	ЗаказНаПеремещениеЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено, ЗаполнятьВариантОбеспечения = Истина)

	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если Не Документы.ЗаказНаПеремещение.ИспользоватьСтатусы() Тогда
		Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт;
	КонецЕсли;

	Если ЗаполнятьВариантОбеспечения Тогда
		ОбеспечениеВДокументахСервер.ЗаполнитьВариантОбеспеченияПоУмолчанию(Товары);
	КонецЕсли;
	
	ОбосабливатьПоНазначениюЗаказа = Константы.ВариантОбособленияТоваровВПеремещении.Получить()
		<> Перечисления.ВариантыОбособленияТоваровВПеремещении.НазначениеПолучателя;
	
	ВариантПриемкиТоваров = ЗакупкиСервер.ПолучитьВариантПриемкиТоваров();
	Приоритет = Справочники.Приоритеты.ПолучитьПриоритетПоУмолчанию(Приоритет);
	
	ЗначениеСклада = СкладПолучатель;
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	// При создании из ОбщаяФома.СозданиеНаОснованииУточнениеЗаказываемогоКоличества может осознанно быть пустым,
	// если в документ переносят данные по нескольким складам. Заполнение по статистике может заполнить это пустое значение,
	// нужно его очистить
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Основание") Тогда
		СкладПолучатель = ЗначениеСклада;
	КонецЕсли;
	
	Документы.ЗаказНаПеремещение.ПроверитьИОчиститьОрганизацию(ЭтотОбъект, ОрганизацияПолучатель);
	Документы.ЗаказНаПеремещение.ПроверитьИОчиститьОрганизацию(ЭтотОбъект, Организация);
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС();
	ПараметрыЗаполнения.Организация = Организация;
	ПараметрыЗаполнения.Дата = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	ПараметрыЗаполнения.Склад = СкладПолучатель;
	ПараметрыЗаполнения.ДвижениеТоваровНаСкладах = Истина;
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ПеремещениеПодДеятельность, ПараметрыЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ДанныеЗаполнения.Свойство("Товары") Тогда
		ЗаполнитьТоварыПоТаблице(ДанныеЗаполнения.Товары);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаявкеНаВозвратТоваровОтКлиента(ДанныеЗаполнения)
	
	ЗаявкаНаВозврат = ДанныеЗаполнения.Основание;
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаказКлиента.Приоритет КАК Приоритет,
		|	ЗаказКлиента.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА ЗаказКлиента.Сделка.ОбособленныйУчетТоваровПоСделке
		|			ТОГДА ЗаказКлиента.Сделка
		|	КОНЕЦ КАК Сделка,
		|	ЗаказКлиента.Подразделение КАК Подразделение,
		|	ЗаказКлиента.НаправлениеДеятельности КАК НаправлениеДеятельности
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &ЗаявкаНаВозврат");
	
	Запрос.УстановитьПараметр("ЗаявкаНаВозврат", ЗаявкаНаВозврат);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	// Заполнение шапки
	Организация             = Реквизиты.Организация;
	Приоритет               = Реквизиты.Приоритет;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаявкаНаВозврат;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	
	СкладПолучатель = ДанныеЗаполнения.Склад;
	
	// Заполнение табличной части.
	Товары.Загрузить(ПолучитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары));
	УдалитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуКлиента(ДанныеЗаполнения)
	
	ЗаказКлиента = ДанныеЗаполнения.Основание;
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаказКлиента.Приоритет КАК Приоритет,
		|	ЗаказКлиента.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА ЗаказКлиента.Сделка.ОбособленныйУчетТоваровПоСделке
		|			ТОГДА ЗаказКлиента.Сделка
		|	КОНЕЦ КАК Сделка,
		|	ЗаказКлиента.Подразделение КАК Подразделение,
		|	ЗаказКлиента.НаправлениеДеятельности КАК НаправлениеДеятельности
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &ЗаказКлиента");
	
	Запрос.УстановитьПараметр("ЗаказКлиента", ЗаказКлиента);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	// Заполнение шапки
	Организация             = Реквизиты.Организация;
	Приоритет               = Реквизиты.Приоритет;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаказКлиента;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	
	СкладПолучатель = ДанныеЗаполнения.Склад;
	
	// Заполнение табличной части.
	Товары.Загрузить(ПолучитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары));
	УдалитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуНаВнутреннееПотребление(ДанныеЗаполнения)
	
	ЗаказНаПотребление = ДанныеЗаполнения.Основание;
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Заказ.Приоритет КАК Приоритет,
		|	Заказ.Организация КАК Организация,
		|	Заказ.Сделка КАК Сделка,
		|	Заказ.Подразделение КАК Подразделение,
		|	Заказ.НаправлениеДеятельности КАК НаправлениеДеятельности
		|ИЗ
		|	Документ.ЗаказНаВнутреннееПотребление КАК Заказ
		|ГДЕ
		|	Заказ.Ссылка = &ЗаказНаПотребление");
	
	Запрос.УстановитьПараметр("ЗаказНаПотребление", ЗаказНаПотребление);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	// Заполнение шапки
	Организация             = Реквизиты.Организация;
	Приоритет               = Реквизиты.Приоритет;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаказНаПотребление;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	
	СкладПолучатель = ДанныеЗаполнения.Склад;
	
	// Заполнение табличной части.
	Товары.Загрузить(ПолучитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары));
	УдалитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуНаСборку(ДанныеЗаполнения)
	
	ЗаказНаСборку = ДанныеЗаполнения.Основание;
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Заказ.Приоритет КАК Приоритет,
		|	Заказ.Организация КАК Организация,
		|	Заказ.Сделка КАК Сделка,
		|	Заказ.Подразделение КАК Подразделение,
		|	Заказ.НаправлениеДеятельности КАК НаправлениеДеятельности
		|ИЗ
		|	Документ.ЗаказНаСборку КАК Заказ
		|ГДЕ
		|	Заказ.Ссылка = &ЗаказНаСборку");
	
	Запрос.УстановитьПараметр("ЗаказНаСборку", ЗаказНаСборку);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	// Заполнение шапки
	Организация             = Реквизиты.Организация;
	Сделка                  = Реквизиты.Сделка;
	Приоритет               = Реквизиты.Приоритет;
	ДокументОснование       = ЗаказНаСборку;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	
	СкладПолучатель = ДанныеЗаполнения.Склад;
	
	// Заполнение табличной части.
	Товары.Загрузить(ПолучитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары));
	УдалитьИзВременногоХранилища(ДанныеЗаполнения.АдресТовары);
	
КонецПроцедуры


Процедура ЗаполнитьПоПриобретениюТоваров(ДанныеЗаполнения)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Шапка.Ссылка                  КАК Ссылка,
	|	Шапка.Организация             КАК Организация,
	|	Шапка.Сделка                  КАК Сделка,
	|	Шапка.Склад                   КАК СкладОтправитель,
	|	Шапка.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕ Шапка.Проведен             КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура        КАК Номенклатура,
	|	Товары.Характеристика      КАК Характеристика,
	|	Товары.Назначение          КАК Назначение,
	|	Товары.Склад               КАК Склад,
	|	Товары.Серия               КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Количество          КАК Количество,
	|	Товары.КоличествоУпаковок  КАК КоличествоУпаковок,
	|	Товары.Упаковка            КАК Упаковка,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить) КАК ВариантОбеспечения,
	|	ВЫБОР
	|		КОГДА Товары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Обособленно
	|
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И Товары.Номенклатура.ТипНоменклатуры В(
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И Товары.Склад = &Склад
	|;
	|
	|////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура   КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Назначение     КАК Назначение,
	|	Серии.Склад          КАК Склад,
	|	Серии.Серия          КАК Серия,
	|	Серии.Количество     КАК Количество
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &ДокументОснование
	|	И Серии.Склад = &Склад";
	
	Если ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ПриемкаТоваровНаХранение") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
			"Документ.ПриобретениеТоваровУслуг", "Документ.ПриемкаТоваровНаХранение");
	КонецЕсли;
	
	Запрос       = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения.Основание);
	Запрос.УстановитьПараметр("Склад",             ДанныеЗаполнения.Склад);
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	ТоварыОснования  = ПакетРезультатов[1].Выгрузить();
	
	Если ТоварыОснования.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru='Документ %Документ% не содержит товаров. Ввод на основании документа запрещен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДанныеЗаполнения.Основание);
		
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Шапка = ПакетРезультатов[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(Шапка.Ссылка, Неопределено, Шапка.ЕстьОшибкиПроведен);
	
	// Заполнение шапки.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	ДокументОснование = ДанныеЗаполнения.Основание;
	СкладОтправитель  = ДанныеЗаполнения.Склад;
	
	// Разбиение строк, заполнение серий со статусом 10.
	ИндексыСтрок    = Новый Массив();
	
	Для Каждого СтрокаТовары Из ТоварыОснования Цикл
		Если СтрокаТовары.СтатусУказанияСерий = 10 Тогда
			ИндексыСтрок.Вставить(0, ТоварыОснования.Индекс(СтрокаТовары));
		КонецЕсли;
	КонецЦикла;
	
	Если ИндексыСтрок.Количество() > 0 Тогда
		СерииОснования = ПакетРезультатов[2].Выгрузить();
		КлючСерии      = "Номенклатура, Характеристика, Склад, Назначение";
		
		НакладныеСервер.ПеренестиСерииИзТаблицыВСтроки(ТоварыОснования, ИндексыСтрок, СерииОснования, КлючСерии);
	КонецЕсли;
	
	Товары.Загрузить(ТоварыОснования);
	
	// Заполнение статусов указания серий
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

Процедура ЗаполнитьПоПоступлениюТоваров(ДокументПоступления)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Шапка.Ссылка                  КАК Ссылка,
	|	Шапка.Организация             КАК Организация,
	|	Шапка.Сделка                  КАК Сделка,
	|	Шапка.Склад                   КАК СкладОтправитель,
	|	Шапка.Подразделение           КАК Подразделение,
	|	Шапка.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕ Шапка.Проведен             КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ПоступлениеТоваровНаСклад КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Назначение КАК Назначение,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Количество КАК Количество,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Упаковка КАК Упаковка,
	|	ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить) КАК ВариантОбеспечения,
	|	ВЫБОР
	|		КОГДА Товары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Обособленно
	|ИЗ
	|	Документ.ПоступлениеТоваровНаСклад.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Назначение КАК Назначение,
	|	Серии.Серия КАК Серия,
	|	Серии.Количество КАК Количество
	|ИЗ
	|	Документ.ПоступлениеТоваровНаСклад.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &ДокументОснование";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументПоступления);
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	ТоварыОснования = ПакетРезультатов[1].Выгрузить();
	Если ТоварыОснования.Количество() = 0 Тогда

		ТекстОшибки = НСтр("ru='Документ %Документ% не содержит товаров. Ввод на основании документа запрещен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДокументПоступления);
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Шапка = ПакетРезультатов[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		,
		Шапка.ЕстьОшибкиПроведен,);
	
	// Заполнение шапки.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	ДокументОснование = ДокументПоступления;
	
	// Разбиение строк, заполнение серий со статусом 10.
	ИндексыСтрок = Новый Массив();
	Для Каждого СтрокаТовары Из ТоварыОснования Цикл
		
		Если СтрокаТовары.СтатусУказанияСерий = 10 Тогда
			ИндексыСтрок.Вставить(0, ТоварыОснования.Индекс(СтрокаТовары));
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИндексыСтрок.Количество() > 0 Тогда
		
		СерииОснования = ПакетРезультатов[2].Выгрузить();
		КлючСерии = "Номенклатура, Характеристика, Склад, Назначение";
		НакладныеСервер.ПеренестиСерииИзТаблицыВСтроки(ТоварыОснования, ИндексыСтрок, СерииОснования, КлючСерии);
		
	КонецЕсли;
	
	// Заполнение табличной части товары.
	Товары.Загрузить(ТоварыОснования);
	
	СкладОтправитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументПоступления, "Склад");

	// Заполнение статусов указания серий
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьТоварыПоТаблице(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НачалоОтгрузки = НачалоДня(ДанныеЗаполнения[0].НачалоОтгрузки);
	ОкончаниеПоступления = НачалоДня(ДанныеЗаполнения[0].ОкончаниеПоступления);
	Длительность = Цел((ОкончаниеПоступления - НачалоОтгрузки) / 86400);
	ОбщаяДлительность = Истина;
	ОтгрузкаИПоступлениеОднойДатой = (НачалоОтгрузки = ОкончаниеПоступления);
	
	Для Каждого СтрокаДанныхЗаполнения Из ДанныеЗаполнения Цикл
		
		Строка = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, СтрокаДанныхЗаполнения);
		
		Если ОтгрузкаИПоступлениеОднойДатой
			И (НачалоДня(Строка.НачалоОтгрузки) <> НачалоДня(Строка.ОкончаниеПоступления)) Тогда
			
			ОтгрузкаИПоступлениеОднойДатой = Ложь;
			
		КонецЕсли;
		
		Если ОбщаяДлительность
			И Длительность <> Цел((НачалоДня(Строка.ОкончаниеПоступления) - НачалоДня(Строка.НачалоОтгрузки)) / 86400) Тогда
			
			ОбщаяДлительность = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИспользоватьДлительностьПеремещения = Не ОтгрузкаИПоступлениеОднойДатой;
	Если ИспользоватьДлительностьПеремещения И ОбщаяДлительность Тогда
		ДлительностьПеремещения = Длительность;
	Иначе
		ДлительностьПеремещения = 0;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет возможность проведения документа в статусе "Закрыт".
//
// Параметры:
//  Отказ	 - Булево - параметр "Отказ" обработки проведения.
//
Процедура ВыполнитьКонтрольЗаказаПослеПроведения(Отказ)

	КонтролироватьОтгрузку = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки");
	
	Если Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт
		И КонтролироватьОтгрузку Тогда
		Массив = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
		ДополнительныеПараметры = Новый Структура("КонтрольВыполненияЗаказа", Истина);
		
		Запрос = Документы.ЗаказНаПеремещение.СформироватьЗапросПроверкиПриСменеСтатуса(Массив, "Закрыт", ДополнительныеПараметры);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаОтгрузка = Результат.Выбрать();
		
		Пока ВыборкаОтгрузка.Следующий() Цикл
			
			ПроверкаПройдена = Документы.ЗаказНаПеремещение.ПроверкаПередСменойСтатуса(ВыборкаОтгрузка, Статус, ДополнительныеПараметры);
			Если Не ПроверкаПройдена Тогда
				Отказ = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
