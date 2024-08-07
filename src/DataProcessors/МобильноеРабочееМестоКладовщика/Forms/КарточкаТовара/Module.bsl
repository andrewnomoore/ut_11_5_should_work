
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Номенклатура          = Параметры.Номенклатура;
	Характеристика        = Параметры.Характеристика;
	Упаковка              = Параметры.Упаковка;
	ВидНоменклатуры       = Обработки.МобильноеРабочееМестоКладовщика.ПолучитьВидНоменклатуры(Номенклатура);
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;

	Если Параметры.Свойство("Склад") Тогда
		Склад = Параметры.Склад;
	КонецЕсли;
	
	Если Параметры.Свойство("Помещение") Тогда
		Помещение = Параметры.Помещение;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Упаковка) Тогда
		Упаковка = ЕдиницаИзмеренияНоменклатуры(Номенклатура);
	КонецЕсли;
	
	Если Параметры.Свойство("Серия") Тогда
		Серия = Параметры.Серия;
	КонецЕсли;
	
	Если Параметры.Свойство("ШтрихкодУпаковки") Тогда
		СтрокаШтрихкод = ШтрихкодыУпаковок.Добавить();
		СтрокаШтрихкод.ШтрихкодУпаковки = Параметры.ШтрихкодУпаковки;
		СтрокаШтрихкод.Номенклатура     = Параметры.Номенклатура;
		СтрокаШтрихкод.Характеристика   = Параметры.Характеристика;
	КонецЕсли;
	
	ИспользоватьХарактеристики = Справочники.Номенклатура.ХарактеристикиИспользуются(Номенклатура);
	ПолитикаУчетаСерий = Обработки.МобильноеРабочееМестоКладовщика.ПолитикаУчетаСерий(ВидНоменклатуры, Склад);
	
	Если Параметры.Свойство("ЭтоСканирование") И НЕ ИспользоватьСерии Тогда
		КоличествоУпаковок             = Параметры.Количество;
	ИначеЕсли Параметры.Свойство("ЭтоСканирование") И ИспользоватьСерии Тогда
		КоличествоУпаковок = 0;
	ИначеЕсли Параметры.Свойство("Количество") Тогда
		КоличествоУпаковок             = Параметры.Количество;
		МаксимальноеКоличествоУпаковок = Параметры.Количество;
	КонецЕсли;
	
	Если Параметры.Свойство("Назначение") Тогда
		Назначение = Параметры.Назначение;
	КонецЕсли; 
	
	Если Параметры.Свойство("Ячейка") Тогда
		Ячейка = Параметры.Ячейка;
	КонецЕсли;
	
	Режим = Параметры.Режим;
	Литерал = "НомерСтроки";
	НомерСтроки = Параметры[Литерал];
	
	СвойстваСклада = Обработки.МобильноеРабочееМестоКладовщика.СвойстваСклада(Склад);
	ИспользоватьАдресноеХранение            = СвойстваСклада.ИспользоватьАдресноеХранение;
	ИспользоватьОрдернуюСхемуПриПоступлении = СвойстваСклада.ИспользоватьОрдернуюСхемуПриПоступлении;
	ИспользоватьСкладскиеПомещения          = СвойстваСклада.ИспользоватьСкладскиеПомещения;
	
	Если СвойстваСклада.ИспользоватьСкладскиеПомещения Тогда
		СтруктураПомещения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Помещение, "ИспользоватьАдресноеХранение");
		ИспользоватьАдресноеХранение = СтруктураПомещения.ИспользоватьАдресноеХранение;
	КонецЕсли;
	
	Если ПоказыватьФотоТоваров Тогда 
		Элементы.ГруппаФотоДобавить.Доступность = ПравоДоступа("Добавление", Метаданные.Справочники.НоменклатураПрисоединенныеФайлы);
		ЗагрузитьФотоТовара(); 
	Иначе
		Элементы.ФотоТоваров.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ЗакрытьКарточкуТовара();
	
КонецПроцедуры

&НаКлиенте
Процедура Упаковка(Команда)
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("Номенклатура", Номенклатура);
	ПараметрыОткрытияФормы.Вставить("Склад", Склад);
	ПараметрыОткрытияФормы.Вставить("Помещение", Помещение);
		
	ОткрытьФорму(
		"Справочник.УпаковкиЕдиницыИзмерения.Форма.ФормаВыбораИзДокументов",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьКоличество(Команда)
	КоличествоУпаковок = КоличествоУпаковок + 1;
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьКоличество(Команда)
	
	КоличествоУпаковок = КоличествоУпаковок - 1;
	
	Если КоличествоУпаковок < 0 Тогда
		КоличествоУпаковок = 0 ;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЯчейку(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("РезультатЗаменыЯчейки", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Номенклатура", Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Характеристика);
	ПараметрыФормы.Вставить("Серия", Серия);
	ПараметрыФормы.Вставить("Режим", Режим);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.Ячейки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальноеКоличество(Команда)
	КоличествоУпаковок = МаксимальноеКоличествоУпаковок;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФото(Команда)
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить("ВыбратьФото", НСтр("ru = 'Выбрать фото'"));
	СписокЗначений.Добавить("СделатьФото", НСтр("ru = 'Сделать фото'"));
	СписокЗначений.Добавить("Отмена", НСтр("ru = 'Отмена'"));
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаФото", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Добавить фотографию к товару'"), СписокЗначений, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура КодыМаркировки(Команда)
	
	Описание = Новый ОписаниеОповещения("ИзменитьШтрихкодыУпаковок", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ШтрихкодыУпаковок", ШтрихкодыУпаковок);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокКодовМаркировки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура();
	Отбор.Вставить("ВидНоменклатуры", ПолучитьВидНоменклатуры(Номенклатура));
	
	ВыборСерии = Новый ОписаниеОповещения("ВыборСерии",ЭтаФорма);
	
	ОткрытьФорму("Справочник.СерииНоменклатуры.Форма.ФормаВыбора", Отбор, ЭтаФорма,,,,ВыборСерии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		
		ЕстьНеобработанноеСобытие = Ложь;
		Выполнить("ЕстьНеобработанноеСобытие = МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие()");
		
		Если ИмяСобытия = "ScanData" И ЕстьНеобработанноеСобытие Тогда
			
			// Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				Штрихкод = Параметр[0];
			Иначе
				Штрихкод = Параметр[1][1];
			КонецЕсли;
			
			Если ИспользоватьСерии Тогда
				
				ПараметрыСерии = ПолучитьПараметрыСерииНаСервере(Штрихкод, ВидНоменклатуры);
				
				Если ЗначениеЗаполнено(ПараметрыСерии.Серия) Тогда
					Серия = ПараметрыСерии.Серия;
					КоличествоУпаковок = КоличествоУпаковок + 1;
				Иначе
					
				КонецЕсли;
				
				Возврат;
			КонецЕсли;
			
			ПараметрыКарточкаТовара = НайтиТоварСервер(Штрихкод);
			
			Если ПараметрыКарточкаТовара.Номенклатура = Номенклатура
				И ПараметрыКарточкаТовара.Характеристика = Характеристика
				И ПараметрыКарточкаТовара.Упаковка = Упаковка 
				И НЕ ИспользоватьСерии Тогда
				
				КоличествоУпаковок = КоличествоУпаковок + ПараметрыКарточкаТовара.Количество;
				
			Иначе
				
				ЗакрытьКарточкуТовара();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	ИмяСобытия = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элементы.Характеристика.Видимость = ИспользоватьХарактеристики;
	Элементы.Упаковка.Заголовок = Упаковка;
	
	Элементы.ГруппаФотоДобавить.Видимость = НЕ ЗначениеЗаполнено(ФотоТовара1) 
	И НЕ ЗначениеЗаполнено(ФотоТовара2)
	И НЕ ЗначениеЗаполнено(ФотоТовара3);
	Элементы.ГруппаФото1.Видимость = ЗначениеЗаполнено(ФотоТовара1);
	Элементы.ГруппаФото2.Видимость = ЗначениеЗаполнено(ФотоТовара2);
	Элементы.ГруппаФото3.Видимость = ЗначениеЗаполнено(ФотоТовара3);
	
	Элементы.ВыбратьЯчейку.Видимость      = Ложь;
	
	#Если НЕ МобильныйАвтономныйСервер Тогда
		Элементы.Назначение.Видимость = Константы.ИспользоватьОбособленноеОбеспечениеЗаказов.Получить();
	#Иначе
		Элементы.Назначение.Видимость = Ложь;
	#КонецЕсли
	
	Если Режим = "Просмотр" Тогда
		
		Элементы.Количество.Вид                   = ВидПоляФормы.ПолеНадписи;
		Элементы.Упаковка.Доступность             = Ложь;
		Элементы.Характеристика.Доступность       = Ложь;
		Элементы.Серия.Доступность                = Ложь;
		Элементы.Назначение.Доступность           = Ложь;
		Элементы.Подтвердить.Видимость            = Ложь;
		Элементы.Количество.ТолькоПросмотр        = Истина;
		Элементы.МаксимальноеКоличество.Видимость = Ложь;
		Элементы.Минус.Видимость                  = Ложь;
		Элементы.Плюс.Видимость                   = Ложь;
		
	ИначеЕсли Режим = "Приемка" ИЛИ Режим = "РедактированиеПриемка" Тогда
		Элементы.Количество.Вид             = ВидПоляФормы.ПолеВвода;
		Элементы.Подтвердить.Видимость      = Истина;
		Элементы.Подтвердить.Заголовок      = НСтр("ru = 'Принять'");
		Элементы.МаксимальноеКоличество.Заголовок = СтрШаблон(НСтр("ru = 'Заполнить %1'"), МаксимальноеКоличествоУпаковок);
		
		Если ЗначениеЗаполнено(Упаковка) Тогда
			Элементы.Упаковка.Заголовок = Упаковка;
		КонецЕсли;
		
		ИспользоватьСерии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПолитикаУчетаСерий, "УказыватьПриПриемке");
		
	ИначеЕсли Режим = "ПодборВКорзину" Тогда
		Элементы.Количество.Вид             = ВидПоляФормы.ПолеВвода;
		Элементы.Подтвердить.Видимость      = Истина;
		Элементы.Упаковка.Доступность       = Ложь;
		Элементы.Подтвердить.Заголовок      = НСтр("ru = 'Подтвердить'");
		
		Если ЗначениеЗаполнено(Упаковка) Тогда
			Элементы.Упаковка.Заголовок = Упаковка;
		КонецЕсли;
		
	ИначеЕсли Режим = "Отгрузка" ИЛИ Режим = "РедактированиеОтгрузка" Тогда
		Элементы.Количество.Вид             = ВидПоляФормы.ПолеВвода;
		Элементы.Подтвердить.Видимость      = Истина; 
		Элементы.Подтвердить.Заголовок      = НСтр("ru = 'Отгрузить'"); 
		Элементы.МаксимальноеКоличество.Заголовок = СтрШаблон(НСтр("ru = 'Заполнить %1'"), МаксимальноеКоличествоУпаковок);
		
		Если ЗначениеЗаполнено(Упаковка) Тогда
			Элементы.Упаковка.Заголовок = Упаковка;
		КонецЕсли;
		
		ИспользоватьСерии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПолитикаУчетаСерий, "УказыватьПриОтгрузке");
		
	ИначеЕсли Режим = "Пересчет" ИЛИ Режим = "РедактированиеПересчет" Тогда
		
		Элементы.Количество.Вид                   = ВидПоляФормы.ПолеВвода;
		Элементы.Упаковка.Видимость               = Ложь;
		Элементы.Подтвердить.Видимость            = Истина;
		Элементы.Упаковка.Доступность             = Ложь;
		Элементы.МаксимальноеКоличество.Видимость = Ложь;
		
		ИспользоватьСерии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПолитикаУчетаСерий, "УказыватьПриПересчетеТоваров");
		
		Элементы.ВыбратьЯчейку.Видимость = ИспользоватьАдресноеХранение;
		Если ЗначениеЗаполнено(Ячейка) Тогда
			Элементы.ВыбратьЯчейку.Заголовок = Ячейка;
		КонецЕсли;
		
	ИначеЕсли Режим = "Перемещение" Тогда
		
		Элементы.Количество.Вид                   = ВидПоляФормы.ПолеВвода;
		Элементы.Подтвердить.Видимость            = Истина;
		Элементы.МаксимальноеКоличество.Видимость = Ложь;
		
	ИначеЕсли Режим = "РазмещениеВЯчейку" ИЛИ Режим = "РедактированиеРазмещениеПоЯчейкам" Тогда
		
		Элементы.Количество.Вид             = ВидПоляФормы.ПолеВвода;
		Элементы.Подтвердить.Видимость      = Истина;
		Элементы.ВыбратьЯчейку.Видимость    = Истина;
		Элементы.Подтвердить.Заголовок      = НСтр("ru = 'Разместить'");
		Элементы.МаксимальноеКоличество.Заголовок = СтрШаблон(НСтр("ru = 'Заполнить %1'"), МаксимальноеКоличествоУпаковок);
		
		Если ЗначениеЗаполнено(Упаковка) Тогда
			Элементы.Упаковка.Заголовок = Упаковка;
		КонецЕсли;
		
		Элементы.ВыбратьЯчейку.Видимость = ИспользоватьАдресноеХранение;
		Если ЗначениеЗаполнено(Ячейка) Тогда
			Элементы.ВыбратьЯчейку.Заголовок = Ячейка;
		КонецЕсли;
		
	ИначеЕсли Режим = "ОтборИзЯчейки" ИЛИ Режим = "РедактированиеОтборИзЯчейки" Тогда
		
		Элементы.Количество.Вид             = ВидПоляФормы.ПолеВвода;
		Элементы.Подтвердить.Видимость      = Истина;
		Элементы.Упаковка.Доступность       = Ложь;
		Элементы.ВыбратьЯчейку.Видимость    = Истина;
		Элементы.Подтвердить.Заголовок      = НСтр("ru = 'Отобрать'");
		Элементы.МаксимальноеКоличество.Заголовок = СтрШаблон(НСтр("ru = 'Заполнить %1'"), МаксимальноеКоличествоУпаковок);
		
		Элементы.ВыбратьЯчейку.Видимость = ИспользоватьАдресноеХранение;
		Если ЗначениеЗаполнено(Ячейка) Тогда
			Элементы.ВыбратьЯчейку.Заголовок = Ячейка;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Количество.Шрифт = Новый Шрифт(, 16, Истина, , , );
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьФотоТовара()
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НоменклатураПрисоединенныеФайлы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НоменклатураПрисоединенныеФайлы КАК НоменклатураПрисоединенныеФайлы
		|ГДЕ
		|	НоменклатураПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
		|	И НЕ НоменклатураПрисоединенныеФайлы.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Сч = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если Сч > 3 Тогда
			Продолжить;
		КонецЕсли;
		
		СсылкаНаДДФ = РаботаСФайлами.ДанныеФайла(ВыборкаДетальныеЗаписи.Ссылка, ЭтотОбъект.УникальныйИдентификатор).СсылкаНаДвоичныеДанныеФайла;
		ЭтаФорма["ФотоТовара" + Сч] = СсылкаНаДДФ;
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.УпаковкиЕдиницыИзмерения.Форма.ФормаВыбораИзДокументов") Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			Упаковка = ВыбранноеЗначение;
		Иначе
			Упаковка = ЕдиницаИзмеренияНоменклатуры(Номенклатура);
		КонецЕсли;
		
		Элементы.Упаковка.Заголовок = Упаковка;
		
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕдиницаИзмеренияНоменклатуры(Номенклатура)
	
	Возврат Обработки.МобильноеРабочееМестоКладовщика.ПолучитьРеквизитСправочника(Номенклатура, "ЕдиницаИзмерения");
	
КонецФункции

&НаСервереБезКонтекста
Функция УпаковкаЗаполнена(Упаковка)
	
	Если Обработки.МобильноеРабочееМестоКладовщика.ПолучитьРеквизитСправочника(Упаковка, "Владелец") = Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения 
		И Обработки.МобильноеРабочееМестоКладовщика.ПолучитьРеквизитСправочника(Упаковка, "ТипИзмеряемойВеличины") = Перечисления.ТипыИзмеряемыхВеличин.КоличествоШтук Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура Штрихкоды(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Номенклатура);
	ПараметрыФормы.Вставить("Упаковка", Упаковка);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.Штрихкоды",ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Номенклатура);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.РедактированиеТовара",ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатЗаменыЯчейки(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Ячейка = Результат;
	Элементы.ВыбратьЯчейку.Заголовок = Ячейка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаФото(Результат, Параметры) Экспорт
	
	Если Результат = "ВыбратьФото" Тогда
		
		#Если МобильныйКлиент Тогда
			Выполнить("РаботаСФайламиКлиент.ДобавитьФайлы(Номенклатура, УникальныйИдентификатор, , Неопределено)");
		#Иначе	
			РаботаСФайламиКлиент.ДобавитьФайлы(Номенклатура, УникальныйИдентификатор, , Неопределено);
		#КонецЕсли
		ЗагрузитьФотоТовара();
		УстановитьУсловноеОформление();
		
	ИначеЕсли Результат = "СделатьФото" Тогда
		
		#Если МобильныйКлиент Тогда
			ДвоичныеДанные = ПолучитьДанныеФотоСнимка();
			ПрисоединитьФайл(ДвоичныеДанные);
			ЗагрузитьФотоТовара();
			УстановитьУсловноеОформление();
		#Иначе
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = НСтр("ru = 'Данное устройство не поддерживает фотоснимок!'");
			СообщениеПользователю.Сообщить();
		#КонецЕсли
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьШтрихкодыУпаковок(Результат, Параметры) Экспорт
	
	ИзменитьШтрихкодыУпаковокНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьШтрихкодыУпаковокНаСервере(Результат) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШтрихкодыУпаковок.Очистить();
	
	ШтрихкодыУпаковок.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДанныеФотоСнимка()
	
	Данные = Неопределено;
	
	#Если МобильныйКлиент Тогда 
		
		Если СредстваМультимедиа.ПоддерживаетсяФотоснимок() Тогда
			
			Данные = СредстваМультимедиа.СделатьФотоснимок();
			
			Возврат Данные.ПолучитьДвоичныеДанные();
			
		Иначе
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = НСтр("ru = 'Данное устройство не поддерживает фотоснимок!'");
			СообщениеПользователю.Сообщить();
		КонецЕсли;
		
	#КонецЕсли
	
	Возврат Данные;
	
КонецФункции

&НаСервере
Процедура ПрисоединитьФайл(ДвоичныеДанные)
	#Если НЕ МобильныйАвтономныйСервер Тогда
		
	ВременноеХранилище                = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	ПараметрыФайла                    = РаботаСФайлами.ПараметрыДобавленияФайла();
	ПараметрыФайла.Автор              = Пользователи.ТекущийПользователь();
	ПараметрыФайла.ИмяБезРасширения   = Строка(Номенклатура);
	ПараметрыФайла.РасширениеБезТочки = "jpg";
	ПараметрыФайла.ВладелецФайлов = Номенклатура;
	РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, ВременноеХранилище);
	
	#КонецЕсли
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиТоварСервер(Штрихкод)
	
	Возврат Обработки.МобильноеРабочееМестоКладовщика.НайтиТоварПоШК(Штрихкод);
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьКарточкуТовара()
	
	ТекстОшибки = "";
	
	Если НЕ УпаковкаЗаполнена(Упаковка) И Режим = "Приемка" И ИспользоватьАдресноеХранение Тогда
		ТекстОшибки = ТекстОшибки + НСтр("ru = 'Укажите упаковку'");
	КонецЕсли;
	
	Если Режим = "Приемка" ИЛИ Режим = "РедактированиеПриемка" 
		ИЛИ Режим = "Отгрузка" ИЛИ Режим = "РедактированиеОтгрузка" ИЛИ Режим = "Пересчет" ИЛИ Режим = "Перемещение" Тогда
		
		Если ИспользоватьХарактеристики и НЕ ЗначениеЗаполнено(Характеристика) Тогда
			ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Укажите характеристику'");
		КонецЕсли;
		
		Если ИспользоватьСерии и НЕ ЗначениеЗаполнено(Серия) Тогда
			ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Укажите серию'");
		КонецЕсли;
		
		Если КоличествоУпаковок = 0 Тогда
			ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Укажите количество'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если (Режим = "РазмещениеВЯчейку" ИЛИ Режим = "ОтборИзЯчейки") И НЕ ЗначениеЗаполнено(Ячейка) Тогда
		ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Укажите ячейку'");
	КонецЕсли;
	
	Если НЕ МаркиОтсканированыСервер() Тогда
		
		ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Укажите коды маркировки'");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СокрЛП(ТекстОшибки);
		СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	Структура = Новый Структура;
	Структура.Вставить("Номенклатура",       Номенклатура);
	Структура.Вставить("Характеристика",     Характеристика);
	Структура.Вставить("Серия",              Серия);
	Структура.Вставить("Упаковка",           Упаковка);
	Структура.Вставить("КоличествоУпаковок", КоличествоУпаковок);
	Структура.Вставить("Назначение",         Назначение);
	Структура.Вставить("НомерСтроки",        НомерСтроки);
	Структура.Вставить("Ячейка",             Ячейка);
	Структура.Вставить("Режим",              Режим);
	Структура.Вставить("ШтрихкодыУпаковок",  ШтрихкодыУпаковок);
	
	Закрыть(Структура);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыСерииНаСервере(ЗначениеШтрихкода, ВидНоменклатуры)
	
	Возврат Обработки.МобильноеРабочееМестоКладовщика.ПолучитьПараметрыСерииПоШК(ЗначениеШтрихкода, ВидНоменклатуры);
	
КонецФункции

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	Если КоличествоУпаковок < 0 Тогда
		КоличествоУпаковок = 0;
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Нельзя указать отрицательное значение!'");
		СообщениеПользователю.Сообщить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция МаркиОтсканированыСервер()
	
	МаркиОтсканированы = Обработки.МобильноеРабочееМестоКладовщика.МаркиОтсканированы(Номенклатура, КоличествоУпаковок, Упаковка, ШтрихкодыУпаковок);
	Возврат МаркиОтсканированы;
	
КонецФункции

&НаКлиенте
Процедура ВыборСерии(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Серия = Результат;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВидНоменклатуры(Номенклатура)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ВидНоменклатуры");
	
КонецФункции

#КонецОбласти