#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Параметры:
//  Форма - см. ОтчетыПереопределяемый.ПриСозданииНаСервере.Форма - форма отчета или настроек отчета.
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	Отчет = Форма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Параметры:
//  Форма - см. ОтчетыПереопределяемый.ПриСозданииНаСервере.Форма
//  Отказ - см. ОтчетыПереопределяемый.ПриСозданииНаСервере.Отказ
//  СтандартнаяОбработка - см. ОтчетыПереопределяемый.ПриСозданииНаСервере.СтандартнаяОбработка
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если Не Форма.Параметры.Свойство("ПараметрКоманды") ИЛИ Не ЗначениеЗаполнено(Форма.Параметры.ПараметрКоманды) Тогда
		ТекстСообщения = НСтр("ru='Непосредственное открытие отчета ""План закупок"" не предусмотрено. 
			|Для открытия отчета можно воспользоваться командой ""План закупок"" в формах документов.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;

	Форма.ФормаПараметры.Отбор.Вставить("ПланЗакупок", Форма.Параметры.ПараметрКоманды);
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных -
//       Пользовательские настройки для загрузки в компоновщик настроек.
//
// См. синтакс-помощник "Расширение управляемой формы для отчета.ПриЗагрузкеПользовательскихНастроекНаСервере"
//    в синтакс-помощнике.
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если Форма.Параметры.Свойство("ПараметрКоманды") Тогда
		
		Период = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Форма.Параметры.ПараметрКоманды, "НачалоПериода, ОкончаниеПериода, Периодичность");
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек,
			"Период",
			Новый СтандартныйПериод(Период.НачалоПериода, Период.ОкончаниеПериода),
			ЗначениеЗаполнено(Период));
		
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек,
			"Периодичность",
			Период.Периодичность,
			ЗначениеЗаполнено(Период));
		
		НовыеПользовательскиеНастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
