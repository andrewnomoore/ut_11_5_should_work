#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	ПараметрСценарий = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Сценарий");
	
	Если НЕ ЗначениеЗаполнено(ПараметрСценарий.Значение) Тогда
		ВызватьИсключение НСтр("ru= 'Не заполнено значение параметра ""Сценарий"".'");
	КонецЕсли;

	ПараметрОтборПоНоменклатуреПланов = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		КомпоновщикНастроек, "ИспользуетсяОтборПоНоменклатуреПланов");

	СтруктураЗначений = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрСценарий.Значение, "Периодичность, ПланированиеПоНазначениям, ПланЗакупокПланироватьПоСумме");
	Периодичность = СтруктураЗначений.Периодичность;
	ИспользоватьНазначения = СтруктураЗначений.ПланированиеПоНазначениям;
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИспользоватьНазначения", ИспользоватьНазначения);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПланироватьПоСумме", СтруктураЗначений.ПланЗакупокПланироватьПоСумме);
	
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПериодПоступления").Значение; // СтандартныйПериод - 
	
	ДатаОкончания = ПланированиеКлиентСервер.РассчитатьДатуОкончанияПериода(Период.ДатаНачала, Периодичность);
	
	Если ДатаОкончания < Период.ДатаОкончания Тогда
		ИспользоватьИтоги = Истина;
	Иначе
		ИспользоватьИтоги = Ложь;
	КонецЕсли;
	
	Для Каждого Группировка Из КомпоновщикНастроек.Настройки.Структура Цикл
		УстановитьДругиеНастройки(Группировка, ИспользоватьИтоги);
	КонецЦикла;

	ВложеннаяСхемаПоПоставщикам = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.ПоПоставщикам; //ВложеннаяСхемаКомпоновкиДанных - 
	ТекстЗапроса = ВложеннаяСхемаПоПоставщикам.Схема.НаборыДанных.НаборДанных1.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения", "ПланЗакупокФакт.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения", "ПланЗакупокФакт.Номенклатура"));
	
	Если ПараметрОтборПоНоменклатуреПланов <> Неопределено И НЕ ПараметрОтборПоНоменклатуреПланов.Значение Тогда
		
		ТекстЗапроса = УдалитьСоединениеВЗапросе(ТекстЗапроса, "ОтборНоменклатуры");
		
	КонецЕсли;

	ВложеннаяСхемаПоПоставщикам.Схема.НаборыДанных.НаборДанных1.Запрос = ОбработатьЗапрос(ТекстЗапроса);

	ВложеннаяСхемаПоПодразделениям = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.ПоПодразделениям; //ВложеннаяСхемаКомпоновкиДанных - 
	ТекстЗапроса = ВложеннаяСхемаПоПодразделениям.Схема.НаборыДанных.НаборДанных1.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения", "ПланЗакупокФакт.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения", "ПланЗакупокФакт.Номенклатура"));
	
	Если ПараметрОтборПоНоменклатуреПланов <> Неопределено И НЕ ПараметрОтборПоНоменклатуреПланов.Значение Тогда
		
		ТекстЗапроса = УдалитьСоединениеВЗапросе(ТекстЗапроса, "ОтборНоменклатуры");
		
	КонецЕсли;

	ВложеннаяСхемаПоПодразделениям.Схема.НаборыДанных.НаборДанных1.Запрос = ОбработатьЗапрос(ТекстЗапроса);

	ВложеннаяСхемаПоСкладам = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.ПоСкладам; //ВложеннаяСхемаКомпоновкиДанных - 
	ТекстЗапроса = ВложеннаяСхемаПоСкладам.Схема.НаборыДанных.НаборДанных1.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения", "ПланЗакупокФакт.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения", "ПланЗакупокФакт.Номенклатура"));
	
	Если ПараметрОтборПоНоменклатуреПланов <> Неопределено И НЕ ПараметрОтборПоНоменклатуреПланов.Значение Тогда
		
		ТекстЗапроса = УдалитьСоединениеВЗапросе(ТекстЗапроса, "ОтборНоменклатуры");
		
	КонецЕсли;

	ВложеннаяСхемаПоСкладам.Схема.НаборыДанных.НаборДанных1.Запрос = ОбработатьЗапрос(ТекстЗапроса);

	Планирование.ИсполнениеПлановПриКомпоновкеРезультата(СхемаКомпоновкиДанных, КомпоновщикНастроек, 
		ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);

	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КоллекцияЭлементовСтруктуры = НастройкиОтчета.Структура[0].Настройки.Структура;
	
	Если ТипЗнч(КоллекцияЭлементовСтруктуры[0]) = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		Если КоллекцияЭлементовСтруктуры[0].Колонки[0].Имя = "Расшифровка" Тогда
			ИмяЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Колонки[0].Имя;
			ПолеГруппировкиЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Колонки[0].ПоляГруппировки.Элементы[0].Поле;
		Иначе
			ИмяЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Строки[0].Имя;
			ПолеГруппировкиЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Строки[0].ПоляГруппировки.Элементы[0].Поле;
		КонецЕсли;
		
	Иначе
		
		ИмяЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Имя;
		ПолеГруппировкиЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].ПоляГруппировки.Элементы[0].Поле;
		
	КонецЕсли;
	
	// Переопределение структуры отчета при расшифровке по полю Регистратор
	Если ИмяЭлементаСтруктуры = "Расшифровка" Тогда
		
		ПолеРегистратор = Новый ПолеКомпоновкиДанных("Регистратор");
		
		Если ПолеГруппировкиЭлементаСтруктуры = ПолеРегистратор Тогда
			
			Планирование.ПереопределитьНастройкиРасшифровкиОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки);
			
			НастройкиОтчета = ДанныеРасшифровки.Настройки;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
			
		КонецЕсли;
	КонецЕсли;

	ЗаголовковПолей = ПараметризуемыеЗаголовкиПолей();
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ЗаголовковПолей, МакетКомпоновки);
	
	Для Каждого Макет Из МакетКомпоновки.Тело Цикл
		Если ТипЗнч(Макет) = Тип("ВложенныйОбъектМакетаКомпоновкиДанных") Тогда
			КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ЗаголовковПолей, Макет.КомпоновкаДанных);
		КонецЕсли;
	КонецЦикла;
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Планирование.ИсполнениеПлановОбработкаПроверкиЗаполнения(КомпоновщикНастроек, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	// Дополнительные команды
	НастройкиОтчета = ЭтаФорма.НастройкиОтчета;
	
	Если Параметры.Свойство("Расшифровка")
	   И Параметры.Расшифровка <> Неопределено Тогда
		
		// Исправление варианта отчета при расшифровке
		Если ЭтоАдресВременногоХранилища(Параметры.Расшифровка.Данные) Тогда
			
			ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Параметры.Расшифровка.Данные);
			
			Если Параметры.Свойство("КлючВарианта") И Параметры.КлючВарианта = Неопределено Тогда
				Параметры.КлючВарианта = ДанныеРасшифровки.Настройки.ДополнительныеСвойства.КлючВарианта;
			КонецЕсли;
			
			ЭтаФорма.КлючТекущегоВарианта = ДанныеРасшифровки.Настройки.ДополнительныеСвойства.КлючВарианта;
			
		КонецЕсли;
		
		НастройкиОтчета.ВариантСсылка = ВариантыОтчетов.ВариантОтчета(НастройкиОтчета.ОтчетСсылка, ЭтаФорма.КлючТекущегоВарианта);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// См. синтакс-помощник "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс-помощнике.
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Параметры = ЭтаФорма["Параметры"];
	
	Если Параметры.Свойство("Расшифровка")
	   И Параметры.Расшифровка <> Неопределено Тогда
		
		Если ЭтоАдресВременногоХранилища(Параметры.Расшифровка.Данные) Тогда
			
			ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Параметры.Расшифровка.Данные);
			
			// Определение варианта отчета, по которому происходит расшифровка
			ИдентификаторВариантаОтчета = ДанныеРасшифровки.Настройки.Структура[0].ИдентификаторОбъекта;
			Если ИдентификаторВариантаОтчета = Неопределено Тогда
				
				ВариантОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
					ДанныеРасшифровки.Настройки.Структура[0].Настройки, "ВариантОтчета");
				
				Если ВариантОтчета <> Неопределено Тогда
					ИдентификаторВариантаОтчета = ВариантОтчета.Значение;
				Иначе
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
			ДопустимыеОтклоненияКоличества = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДопустимыеОтклоненияПроцент");
			Если ДопустимыеОтклоненияКоличества <> Неопределено Тогда
				ДопустимыеОтклоненияКоличества.Использование = Ложь;
			КонецЕсли;
			
			ДопустимыеОтклоненияСуммы = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДопустимыеОтклоненияСуммаПроцент");
			Если ДопустимыеОтклоненияСуммы <> Неопределено Тогда
				ДопустимыеОтклоненияСуммы.Использование = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ИдентификаторВариантаОтчета = НовыеНастройкиКД.Структура[0].ИдентификаторОбъекта;
		Если ИдентификаторВариантаОтчета = Неопределено Тогда
			
			ВариантОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
				НовыеНастройкиКД.Структура[0].Настройки, "ВариантОтчета");
				
			Если ВариантОтчета <> Неопределено Тогда
				ИдентификаторВариантаОтчета = ВариантОтчета.Значение;
			Иначе
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрОтборПоНоменклатуреПланов      = СхемаКомпоновкиДанных.Параметры.Найти("ИспользуетсяОтборПоНоменклатуреПланов");
	ПараметрДопустимыеОтклоненияКоличества = СхемаКомпоновкиДанных.Параметры.Найти("ДопустимыеОтклоненияПроцент");
	ПараметрДопустимыеОтклоненияСуммы      = СхемаКомпоновкиДанных.Параметры.Найти("ДопустимыеОтклоненияСуммаПроцент");
	
	Если ИдентификаторВариантаОтчета = "ПоОплатам" Тогда
		
		ПараметрОтборПоНоменклатуреПланов.ВключатьВДоступныеПоля = Ложь;
		ПараметрОтборПоНоменклатуреПланов.ОграничениеИспользования = Истина;
		ПараметрДопустимыеОтклоненияКоличества.ВключатьВДоступныеПоля = Ложь;
		ПараметрДопустимыеОтклоненияКоличества.ОграничениеИспользования = Истина;
		ПараметрДопустимыеОтклоненияСуммы.Заголовок = "Допустимые отклонения оплаты, %";
		
	Иначе
		
		ПараметрОтборПоНоменклатуреПланов.ВключатьВДоступныеПоля = Истина;
		ПараметрОтборПоНоменклатуреПланов.ОграничениеИспользования = Ложь;
		ПараметрДопустимыеОтклоненияКоличества.ВключатьВДоступныеПоля = Истина;
		ПараметрДопустимыеОтклоненияКоличества.ОграничениеИспользования = Ложь;
		ПараметрДопустимыеОтклоненияСуммы.Заголовок = "Допустимые отклонения суммы, %";
		
	КонецЕсли;
	
	ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, ЭтаФорма, СхемаКомпоновкиДанных, "");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьДругиеНастройки(ВложенныйОтчет, ИспользоватьИтоги)
	
	Параметр = Новый ПараметрКомпоновкиДанных("ГоризонтальноеРасположениеОбщихИтогов");
	ПараметрГоризонтальноеРасположениеОбщихИтогов = ВложенныйОтчет.Настройки.ПараметрыВывода.Элементы.Найти(Параметр);
	
	Если ИспользоватьИтоги Тогда
		ПараметрГоризонтальноеРасположениеОбщихИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Конец;
	Иначе
		ПараметрГоризонтальноеРасположениеОбщихИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	КонецЕсли;

	ПараметрДопустимыеОтклоненияКоличества = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		КомпоновщикНастроек, "ДопустимыеОтклоненияПроцент");
	
	ПараметрДопустимыеОтклоненияСуммы = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		КомпоновщикНастроек, "ДопустимыеОтклоненияСуммаПроцент");
	
	// Включение пользовательских полей отклонений при использовании параметров доступных отклонений
	Если ПараметрДопустимыеОтклоненияКоличества <> Неопределено И ПараметрДопустимыеОтклоненияКоличества.Использование
	 ИЛИ ПараметрДопустимыеОтклоненияСуммы <> Неопределено И ПараметрДопустимыеОтклоненияСуммы.Использование Тогда
		
		ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
		ИдентификаторНастройкиВыбранныхПолей = ВложенныйОтчет.Настройки.Выбор.ИдентификаторПользовательскойНастройки;
		
		ПользовательскиеВыбранныеПоля = ПользовательскиеНастройки.Элементы.Найти(ИдентификаторНастройкиВыбранныхПолей);
		ПолеПользовательскихПолей = Новый ПолеКомпоновкиДанных("ПользовательскиеПоля");
		
		ДоступныеПольПоля = ПользовательскиеВыбранныеПоля.ДоступныеПоляВыбора.НайтиПоле(ПолеПользовательскихПолей);
		
		Для Каждого ПольПоле Из ДоступныеПольПоля.Элементы Цикл // КоллекцияДоступныхПолейКомпоновкиДанных -
			
			Если ПольПоле.Заголовок = "Количество (отклонение)" Тогда
				ПолеОтклонениеКоличествоПроцент = ПольПоле.Поле;
			КонецЕсли;
			Если ПольПоле.Заголовок = "Сумма (отклонение)" Тогда
				ПолеОтклонениеСуммаПроцент = ПольПоле.Поле;
			КонецЕсли;
			Если ПольПоле.Заголовок = "Исполнение плана оплат (отклонение), %" Тогда
				ПолеОтклонениеОплатПроцент = ПольПоле.Поле;
			КонецЕсли;
			
		КонецЦикла;
		
		Для каждого ГруппыВыбранныхПолей Из ПользовательскиеВыбранныеПоля.Элементы Цикл
			
			Если ГруппыВыбранныхПолей.Заголовок = "Исполнение плана, %"
			 ИЛИ ГруппыВыбранныхПолей.Заголовок = "Оплата" Тогда
				
				Для Каждого ВыбранныеПоле Из ГруппыВыбранныхПолей.Элементы Цикл
					
					Если ТипЗнч(ВыбранныеПоле) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
						Если ВыбранныеПоле.Поле = ПолеОтклонениеКоличествоПроцент
						И ПараметрДопустимыеОтклоненияКоличества.Использование Тогда
							ВыбранныеПоле.Использование = ПараметрДопустимыеОтклоненияКоличества.Использование;
						КонецЕсли;
						Если ВыбранныеПоле.Поле = ПолеОтклонениеСуммаПроцент
						И ПараметрДопустимыеОтклоненияСуммы.Использование Тогда
							ВыбранныеПоле.Использование = ПараметрДопустимыеОтклоненияСуммы.Использование;
						КонецЕсли;
						Если ВыбранныеПоле.Поле = ПолеОтклонениеОплатПроцент
						И ПараметрДопустимыеОтклоненияСуммы.Использование Тогда
							ВыбранныеПоле.Использование = ПараметрДопустимыеОтклоненияСуммы.Использование;
						КонецЕсли;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(ВложенныйОтчет);
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(ВложенныйОтчет);
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;
	
КонецФункции

Функция ПараметризуемыеЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.СоответствиеЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

Функция ОбработатьЗапрос(ТекстЗапроса)
	
	Возврат СтрЗаменить(
				ТекстЗапроса,
				"ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения",
				"ВЫРАЗИТЬ(ПланЗакупокФакт.Номенклатура.ЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения)");
	
КонецФункции

// Удалить соединение в запросе по псевдониму таблицы (источника)
// 
// Параметры:
//  ТекстЗапроса - Строка -Текст запроса
//  Псевдоним - строка - Псевдоним
// 
// Возвращаемое значение:
//  Строка - Текст запроса
Функция УдалитьСоединениеВЗапросе(ТекстЗапроса, Псевдоним)
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	ПакетЗапросов = СхемаЗапроса.ПакетЗапросов;

	Для Каждого ПакетЗапроса Из ПакетЗапросов Цикл

		Источники = ПакетЗапроса.Операторы[0].Источники;
		Источник = Источники.НайтиПоПсевдониму(Псевдоним);

		Если Источник <> Неопределено Тогда

			Источник.Соединения.Очистить();
			Источники.Удалить(Псевдоним);

		КонецЕсли;

	КонецЦикла;

	Возврат СхемаЗапроса.ПолучитьТекстЗапроса();
	
КонецФункции

#КонецОбласти

#КонецЕсли