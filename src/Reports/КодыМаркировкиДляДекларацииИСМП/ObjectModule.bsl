#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	НастройкиОтчета.ДополнительныеСвойства.Вставить("ИмяОтчета", ЭтотОбъект.Метаданные().Имя);
	
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
		
		Если ЗначениеЗаполнено(Параметры.ПараметрКоманды) Тогда
			ДальнейшееДействие = РегистрыСведений.СтатусыДокументовИСМП.ТекущееСостояние(Параметры.ПараметрКоманды).ДальнейшееДействие1;
			Если ДальнейшееДействие <> Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ПередайтеДанные
				И ДальнейшееДействие <> Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ПередайтеДанныеСИсправлениями Тогда
				Отказ = Истина;
				Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется Тогда
					ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Документ обработан. Выгрузка кодов в декларацию не требуется'"));
				Иначе
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru = '%1 перед выгрузкой кодов в декларацию'"), Строка(ДальнейшееДействие)));
				КонецЕсли;
				Возврат;
			КонецЕсли;
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