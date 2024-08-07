#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Установка значений по умолчанию
	НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	// Проверим, что хотя бы одна группировка отчета включена
	Если МакетКомпоновки.НаборыДанных.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru= 'Отчет не сформирован. Включите хотя бы одну группировку или таблицу.'");
	КонецЕсли;
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	#Область ПроверкаАктуальностиОтчета
	Отчеты.УправленческийБаланс.ВывестиАктуальностьОтчета(НастройкиОтчета, ДокументРезультат);
	#КонецОбласти

	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ПараметрПериодичность = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Периодичность");
	Если Не ЗначениеЗаполнено(ПараметрПериодичность.Значение)
		ИЛИ ТипЗнч(ПараметрПериодичность.Значение) = Тип("Строка") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Перечисления.Периодичность.Месяц);
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	КомпоновкаДанныхСервер.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, КомпоновщикНастроек);
	
	ПараметрПериодичность = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Периодичность");
	ИскомоеПоле = СхемаКомпоновкиДанных.ВычисляемыеПоля.Найти("ДинамическийПериод");
	ИскомоеПоле.Выражение = ФинансоваяОтчетностьКлиентСервер.СтрокиПериода(ПараметрПериодичность.Значение).Период;
	ИскомоеПоле.ВыражениеПредставления = "ФинансоваяОтчетностьСервер.ПредставлениеИнтервала("+ИскомоеПоле.Выражение+",&Периодичность)";
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Таб", Символы.Таб);
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	ПараметрВалютаУправленческогоУчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВалютаУправленческогоУчета");
	Если ПараметрВалютаУправленческогоУчета <> Неопределено 
		И НЕ (ЗначениеЗаполнено(ПараметрВалютаУправленческогоУчета.Значение)
			ИЛИ ТипЗнч(ПараметрВалютаУправленческогоУчета.Значение) = Тип("Строка")) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВалютаУправленческогоУчета", ВалютаУправленческогоУчета);
		
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	ПараметрВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВалютаОтчета");
	Если ПараметрВалютаОтчета <> Неопределено 
		И (НЕ ЗначениеЗаполнено(ПараметрВалютаОтчета.Значение)
			ИЛИ ТипЗнч(ПараметрВалютаОтчета.Значение) = Тип("Строка")) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВалютаОтчета", ВалютаУправленческогоУчета);
		
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	ПараметрГруппироватьАП = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ГруппироватьПоАктивамПассивам");
	Если КомпоновщикНастроек.Настройки.Структура.Количество() > 0 Тогда
		Таблица = КомпоновщикНастроек.Настройки.Структура[0];
		Если ТипЗнч(Таблица) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Таблица.Имя = "ПоПериодам" ИЛИ Таблица.Имя = "ПоНаправлениям" ИЛИ Таблица.Имя = "ПоОрганизациям" Тогда
				СтрокиТаблицы = КомпоновщикНастроек.Настройки.Структура[0].Строки;
				ГруппировкаТипПоказателя = ФинансоваяОтчетностьСервер.НайтиГруппировку(СтрокиТаблицы, "ТипПоказателя");
				ГруппировкаПоказатель = ФинансоваяОтчетностьСервер.НайтиГруппировку(СтрокиТаблицы, "Показатель");
				Если ГруппировкаТипПоказателя <> Неопределено И ГруппировкаПоказатель <> Неопределено Тогда
					ГруппировкаТипПоказателя.Использование = ПараметрГруппироватьАП.Значение;
					ГруппировкаПоказатель.Использование = НЕ ПараметрГруппироватьАП.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("Периодичность");
	ВспомогательныеПараметры.Добавить("ВыводитьОборотыПоСтатьям");
	ВспомогательныеПараметры.Добавить("ГруппироватьПоАктивамПассивам");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;
КонецФункции

Процедура НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы, ПользовательскиеНастройки = Ложь)
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	Параметр = НастройкаПараметра(КомпоновщикНастроекФормы, "ВалютаОтчета", ПользовательскиеНастройки);
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Если Не ЗначениеЗаполнено(Параметр.Значение) Тогда
			Параметр.Значение = ВалютаУправленческогоУчета;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


// Описание
// 
// Параметры:
// 	КомпоновщикНастроекФормы - КомпоновщикНастроекКомпоновкиДанных - 
// 	ИмяПараметра - Строка - Описание
// 	Пользовательский - Булево - Описание
// Возвращаемое значение:
// 	Неопределено, ПараметрКомпоновкиДанных - Описание
//
Функция НастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра, Пользовательский = Ложь)
	
	ПараметрДанных = КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроекФормы.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если Пользовательский И ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;
	
КонецФункции

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
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Показатель", Параметры.ПараметрКоманды);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли