#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	НастройкиОтчета.ДополнительныеСвойства.Вставить("ИмяОтчета", Метаданные().Имя);
	
	ВнешниеНаборыДанных = Неопределено;
	ОтчетыИСМП.ПриКомпоновкеРезультата(НастройкиОтчета, ВнешниеНаборыДанных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = Форма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		КлючВарианта = Неопределено;
		Параметры.Свойство("КлючВарианта", КлючВарианта);
		Если КлючВарианта = "РасшифровкаПоКодамМаркировки" Тогда
			
			Форма.ФормаПараметры.Отбор.Вставить("ДокументИСМП", Параметры.ПараметрКоманды);
			Если Не Документы.ОтчетИСМП.РасшифровкаПоКодамДоступна(Параметры.ПараметрКоманды) Тогда
				Отказ = Истина;
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru = 'Расшифровка по кодам недоступна.
				               |Количество строк в выгрузке превышает максимальное количество кодов (25000) для расшифровки'"));
				Возврат;
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(Параметры.ПараметрКоманды) Тогда
			Форма.ФормаПараметры.Отбор.Вставить("ДокументИСМП", Параметры.ПараметрКоманды);
		КонецЕсли;
		ОтчетыИС.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ДокументИСМП", Параметры.ПараметрКоманды);
	КонецЕсли;
	
	ОтчетыИС.ИнициализироватьСхемуКомпоновки(ЭтотОбъект, Форма);
	
КонецПроцедуры

//Часть запроса отвечающего за данные прикладных документов
//
//Возвращаемое значение:
//   Строка - переопределяемая часть отчета о расхождениях
//
Функция ПереопределяемаяЧасть() Экспорт
	
	Возврат ОтчетыИС.ШаблонПолученияДанныхПрикладныхДокументов() + ИнтеграцияИСМП.ШаблонПолученияВидаПродукцииИзНоменклатуры();
	
КонецФункции

#КонецОбласти

#КонецЕсли