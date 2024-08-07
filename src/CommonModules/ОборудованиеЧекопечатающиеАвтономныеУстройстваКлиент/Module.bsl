#Область ПрограммныйИнтерфейс

// Начать выполнение команды
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - событие описания оповещения.
//  ИдентификаторКлиента - УникальныйИдентификатор - уникальный идентификатор клиента.
//  ПараметрыОперации - Структура
//  ПараметрыВыполнениеКоманды - см. ПараметрыВыполненияОперацииНаАвтономнойККТ
//  ДополнительныеПараметры - Структура
//
Процедура НачатьВыполнениеКоманды(ОповещениеПриЗавершении, ИдентификаторКлиента, ПараметрыОперации, ПараметрыВыполнениеКоманды, ДополнительныеПараметры = Неопределено) Экспорт
	
	РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, Неопределено, Неопределено);
	Команда = ПараметрыВыполнениеКоманды.Команда;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыОперации", ПараметрыОперации);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("Команда", ПараметрыВыполнениеКоманды.Команда);
	ДополнительныеПараметры.Вставить("ПечатающееУстройствоДополнительныхДокументов"); 
	ДополнительныеПараметры.Вставить("ПодключенноеПечатающееУстройствоДополнительныхДокументов");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьКомандуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Отказ = Истина;
	СтандартнаяОбработка = Истина;

	Если Команда = "CheckFiscalization" Тогда
		
		ТекстВопроса = НСтр("ru='Подтвердите пробитие чека на устройстве'");
		ЗаголовокВопроса = НСтр("ru='Пробитие чека'");
		Отказ = Ложь;
		
	ИначеЕсли Команда = "PrintReceiptCorrection" Тогда
		
	ИначеЕсли Команда = "PrintCheckCopy" Тогда
		
	ИначеЕсли Команда = "PrintText" Тогда
		
	ИначеЕсли Команда = "PrintQRCode" Тогда
		
	ИначеЕсли Команда = "OpenShift"  Тогда
		
		ТекстВопроса = НСтр("ru='Подтвердите открытие смены на устройстве'");
		ЗаголовокВопроса = НСтр("ru='Открытие смены'");
		Отказ = Ложь;
		
	ИначеЕсли Команда = "CloseShift" Тогда
		
		ТекстВопроса = НСтр("ru='Подтвердите закрытие смены на устройстве'");
		ЗаголовокВопроса = НСтр("ru='Закрытие смены'");
		Отказ = Ложь;
		
	ИначеЕсли Команда = "ReportCurrentStatusOfSettlements" Или Команда = "GetCurrentStatus"  Тогда
		
	ИначеЕсли Команда = "PrintXReport"  Тогда
		
	ИначеЕсли Команда = "Encash" Тогда
		
		ТекстВопроса = НСтр("ru='Внесение выполнено на устройстве'");
		ЗаголовокВопроса = НСтр("ru='Внесение'");
		Отказ = Ложь;
		
	ИначеЕсли Команда = "OperationFN" Тогда
		
		
	ИначеЕсли Команда = "RequestKM" Тогда

	КонецЕсли;
	
	ОткрытьСтандартныйВопросОбработкиАвтономнойККТ(Отказ, СтандартнаяОбработка, ПараметрыВыполнениеКоманды, ДополнительныеПараметры);
	
	Если Не Отказ И СтандартнаяОбработка Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , , ЗаголовокВопроса);
	ИначеЕсли Отказ И СтандартнаяОбработка Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Завершает выполнение команды
//
// Параметры:
//  Результат - КодВозвратаДиалога
//  ДополнительныеПараметры - Структура
Процедура ВыполнитьКомандуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("КодВозвратаДиалога") Тогда
		Если Результат = КодВозвратаДиалога.Да Тогда
			РезультатПробития = Истина;
		Иначе
			РезультатПробития = Ложь;
		КонецЕсли;
	КонецЕсли; 
	
	Если ДополнительныеПараметры.Свойство("ОповещениеПриЗавершении") И ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		Если ОбщегоНазначенияБПОКлиент.ИспользуетсяРаспределеннаяФискализация() Тогда
			МодульРаспределеннаяФискализацияКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("РаспределеннаяФискализацияКлиент");
			ДополнительныеПараметры.ОповещениеПриЗавершении = Новый ОписаниеОповещения("ФискализацияЧековВОчереди_Завершение", МодульРаспределеннаяФискализацияКлиент, ДополнительныеПараметры.ПараметрыОперации);
		КонецЕсли;
	КонецЕсли;
		
	РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(РезультатПробития, Неопределено, Неопределено);
	
	Если Не РезультатВыполнения.Результат Тогда
		
		РезультатВыполнения.Вставить("Результат"              , Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки"         , НСтр("ru='Операция отменена на устройстве'"));
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		Возврат;
		
	КонецЕсли;
	
	Команда = ДополнительныеПараметры.Команда;
	ПараметрыОперации = ДополнительныеПараметры.ПараметрыОперации;
	
	Если Команда = "CheckFiscalization" Тогда
		ПробитиеЧека(РезультатВыполнения, ПараметрыОперации);
	ИначеЕсли Команда = "PrintReceiptCorrection" Тогда
		
	ИначеЕсли Команда = "PrintCheckCopy" Тогда
		
	ИначеЕсли Команда = "PrintText" Тогда
		
	ИначеЕсли Команда = "PrintQRCode" Тогда
		
	ИначеЕсли Команда = "OpenShift"  Тогда
		
		ОткрытиеСмены(РезультатВыполнения, ПараметрыОперации);
		
	ИначеЕсли Команда = "CloseShift" Тогда
		
		ЗакрытиеСмены(РезультатВыполнения, ПараметрыОперации);
		
	ИначеЕсли Команда = "ReportCurrentStatusOfSettlements" Или Команда = "GetCurrentStatus"  Тогда
		
	ИначеЕсли Команда = "PrintXReport"  Тогда
		
	ИначеЕсли Команда = "Encash" Тогда
		
	ИначеЕсли Команда = "OperationFN" Тогда
		
		
	ИначеЕсли Команда = "RequestKM" Тогда
	
	КонецЕсли;
	
	Если ПараметрыОперации.Свойство("УстройствоПечати")
		И ПараметрыОперации.Свойство("ПакетДокументов") 
		И (ЗначениеЗаполнено(ПараметрыОперации.УстройствоПечати) 
		ИЛИ ЗначениеЗаполнено(ПараметрыОперации.ПакетДокументов)) Тогда
			НачатьПодключениеУстройстваПечатиДополнительныхДокументов(РезультатВыполнения, ДополнительныеПараметры);
	Иначе
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру для параметров операции
// 
// Возвращаемое значение:
//  Структура:
//   * ПараметрыОперации - Структура
//   * Команда - Строка
//   * ОповещениеПриЗавершении - ОписаниеОповещения
//   * ИспользуетсяОчередьПробития - Булево
//
Функция ПараметрыВыполненияОперацииНаАвтономнойККТ() Экспорт
	
	ПараметрыОперации = Новый Структура;
	
	ПараметрыОперации.Вставить("ПараметрыОперации", Новый Структура);
	ПараметрыОперации.Вставить("Команда", "");
	ПараметрыОперации.Вставить("ОповещениеПриЗавершении", Неопределено);
	ПараметрыОперации.Вставить("ИспользуетсяОчередьПробития", Ложь);
	ПараметрыОперации.Вставить("ПечатающееУстройствоДополнительныхДокументов"); 
	ПараметрыОперации.Вставить("ПодключенноеПечатающееУстройствоДополнительныхДокументов"); 
	ПараметрыОперации.Вставить("ИдентификаторКлиента");
	
	Возврат ПараметрыОперации;
	
КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьСтандартныйВопросОбработкиАвтономнойККТ(Отказ, СтандартнаяОбработка, ПараметрыОперации, ДополнительныеПараметры = Неопределено)
	
	СтандартнаяОбработка = Истина;
	Отказ = Ложь;
	ОборудованиеЧекопечатающиеАвтономныеУстройстваКлиентПереопределяемый.ОткрытьСтандартныйВопросОбработкиАвтономнойККТ(Отказ, СтандартнаяОбработка, ПараметрыОперации, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ЗакрытиеСмены(РезультатВыполнения, ПараметрыОперации)
	
	ПараметрыПодключения = Новый Структура("ИдентификаторУстройства", ПараметрыОперации.КассаККМ);
	ДанныеОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыФискальнойОперации();
	Если ОборудованиеЧекопечатающиеУстройстваВызовСервера.ПередЗакрытиемКассовойСмены(ПараметрыПодключения, ДанныеОперации) Тогда
		
		РезультатВыполнения.Вставить("СтатусСмены"   , 1);
		РезультатВыполнения.Вставить("КассоваяСмена" , ДанныеОперации.КассоваяСмена);
		РезультатВыполнения.Результат = Истина;
		
		ОборудованиеЧекопечатающиеУстройстваВызовСервера.ПослеЗакрытияКассовойСмены(ПараметрыПодключения, РезультатВыполнения);
		
	Иначе
		
		РезультатВыполнения.ОписаниеОшибки = ДанныеОперации.ТекстОшибки;
		
	КонецЕсли;
КонецПроцедуры

Процедура ОткрытиеСмены(РезультатВыполнения, ПараметрыОперации)
	
	ПараметрыПодключения = Новый Структура("ИдентификаторУстройства", ПараметрыОперации.КассаККМ);
	ДанныеОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыФискальнойОперации();
	Если ОборудованиеЧекопечатающиеУстройстваВызовСервера.ПередОткрытиемКассовойСмены(ПараметрыПодключения, ДанныеОперации) Тогда
		
		РезультатВыполнения.Вставить("СтатусСмены"   , 2);
		РезультатВыполнения.Вставить("КассоваяСмена" , ДанныеОперации.КассоваяСмена);
		РезультатВыполнения.Результат = Истина;
		
		ОборудованиеЧекопечатающиеУстройстваВызовСервера.ПослеОткрытияКассовойСмены(ПараметрыПодключения, РезультатВыполнения);
		
	Иначе
		
		РезультатВыполнения.ОписаниеОшибки = ДанныеОперации.ТекстОшибки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПробитиеЧека(РезультатВыполнения, ПараметрыОперации)
	
	РезультатВыполнения.Вставить("НомерСменыККТ" , ПараметрыОперации.НомерСмены);
	РезультатВыполнения.Вставить("НомерЧекаККТ"  , ПараметрыОперации.НомерЧека);
	
	РезультатВыполнения.Вставить("СтатусСмены", 2);
	РезультатВыполнения.Вставить("ДатаВремяЧека"          , ПараметрыОперации.ДатаВремя);
	РезультатВыполнения.Вставить("ОперацияЗаписана"       , Истина);
	РезультатВыполнения.Вставить("Результат"       , Истина);
	
КонецПроцедуры

Процедура НачатьПодключениеУстройстваПечатиДополнительныхДокументов(РезультатВыполнения, ПараметрыВыполнениеКоманды) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("РезультатВыполнения", РезультатВыполнения);
	ДополнительныеПараметры.Вставить("ПараметрыВыполнениеКоманды", ПараметрыВыполнениеКоманды);
	ДополнительныеПараметры.Вставить("УстройствКПодключению", 0);
	ДополнительныеПараметры.Вставить("ПодключеноУстройств", 0);
	ДополнительныеПараметры.Вставить("МассивУстройствДляПодключения", Новый Массив);
	ДополнительныеПараметры.Вставить("НеобходимаПечатьКопииЧека", Истина);
	
	ПечатающееУстройство = МенеджерОборудованияКлиент.ПолучитьПодключенноеУстройство(ПараметрыВыполнениеКоманды.ПараметрыОперации.УстройствоПечати);
	Если ПечатающееУстройство = Неопределено И ЗначениеЗаполнено(ПараметрыВыполнениеКоманды.ПараметрыОперации.УстройствоПечати) Тогда
		ДополнительныеПараметры.МассивУстройствДляПодключения.Добавить(ПараметрыВыполнениеКоманды.ПараметрыОперации.УстройствоПечати);
		ДополнительныеПараметры.УстройствКПодключению = 1;
	ИначеЕсли ПечатающееУстройство <> Неопределено Тогда
		ДополнительныеПараметры.ПараметрыВыполнениеКоманды.ПодключенноеПечатающееУстройствоДополнительныхДокументов = ПечатающееУстройство;
		ДополнительныеПараметры.ПараметрыВыполнениеКоманды.ПечатающееУстройствоДополнительныхДокументов = ПечатающееУстройство.ИдентификаторУстройства;
	Иначе
		ДополнительныеПараметры.НеобходимаПечатьКопииЧека = Ложь;
	КонецЕсли;
	
	Для Каждого СоответствиеУстройства Из ПараметрыВыполнениеКоманды.ПараметрыОперации.ПакетДокументов Цикл
		Если ДополнительныеПараметры.МассивУстройствДляПодключения.Найти(СоответствиеУстройства.Значение) = Неопределено 
			И МенеджерОборудованияКлиент.ПолучитьПодключенноеУстройство(СоответствиеУстройства.Значение) = Неопределено Тогда
			
			ДополнительныеПараметры.МассивУстройствДляПодключения.Добавить(СоответствиеУстройства.Значение);
			ДополнительныеПараметры.УстройствКПодключению = ДополнительныеПараметры.УстройствКПодключению + 1;
		КонецЕсли;
		
		Если ДополнительныеПараметры.ПараметрыВыполнениеКоманды.ПечатающееУстройствоДополнительныхДокументов = Неопределено Тогда
			ДополнительныеПараметры.ПараметрыВыполнениеКоманды.ПечатающееУстройствоДополнительныхДокументов = СоответствиеУстройства.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если ДополнительныеПараметры.УстройствКПодключению > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыполнениеКоманды_ПечатьДополнительныхДокументов", ЭтотОбъект, ДополнительныеПараметры);
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоИдентификатору(ОписаниеОповещения, ПараметрыВыполнениеКоманды.ИдентификаторКлиента, ДополнительныеПараметры.МассивУстройствДляПодключения);
	Иначе
		НачатьВыполнениеКоманды_ПечатьДополнительныхДокументов(РезультатВыполнения, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыполнениеКоманды_ПечатьДополнительныхДокументов(РезультатВыполнения, ПараметрыВыполнение) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		ПараметрыВыполнение.ПодключеноУстройств = ПараметрыВыполнение.ПодключеноУстройств + 1;
		Если ПараметрыВыполнение.ПодключеноУстройств < ПараметрыВыполнение.УстройствКПодключению Тогда
			Возврат;
		КонецЕсли;
		
		Если ПараметрыВыполнение.ПараметрыВыполнениеКоманды.Свойство("КопияРаспечатана") И ПараметрыВыполнение.ПараметрыВыполнениеКоманды.КопияРаспечатана 
			ИЛИ НЕ ПараметрыВыполнение.НеобходимаПечатьКопииЧека Тогда
			
			Если Не ПараметрыВыполнение.Свойство("ДанныеОперации") Тогда 
				УстройствоПечати = МенеджерОборудованияКлиент.ПолучитьПодключенноеУстройство(ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ПечатающееУстройствоДополнительныхДокументов);
				ПолучитьДанныеОперацииПечати(ПараметрыВыполнение, УстройствоПечати);
			КонецЕсли;
			Команда = "PrintText";
			СоответствиеПечати = ПараметрыВыполнение.ДанныеОперации.ДополнительныеДокументы;
			ДокументПечати = СоответствиеПечати.Получить(0);
			
			УстройствоПечати = МенеджерОборудованияКлиент.ПолучитьПодключенноеУстройство(ДокументПечати.УстройствоПечати);
			ДанныеОперации = Новый Структура;
			ДанныеОперации.Вставить("ТестовыеЧеки", Новый Массив);
			ДанныеОперации.ТестовыеЧеки = ДокументПечати.ТекстПечати;

			ПараметрыВыполнение.Вставить("РезультатВыполнения", РезультатВыполнения);
			ПараметрыВыполнение.ДанныеОперации.ДополнительныеДокументы.Удалить(0);
			ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыполнениеКоманды_ПечатьДополнительныхДокументовЗавершение", ЭтотОбъект, ПараметрыВыполнение);
			УстройствоПечати.ОбработчикДрайвера.НачатьВыполнениеКоманды(ОписаниеОповещения, УстройствоПечати, Команда, ДанныеОперации);

		Иначе
			
			ПараметрыВыполнениеКоманды = ПараметрыВыполнение.ПараметрыВыполнениеКоманды;
			Если Не ЗначениеЗаполнено(ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ПечатающееУстройствоДополнительныхДокументов) Тогда
				ПараметрыВыполнениеКоманды.ПечатающееУстройствоДополнительныхДокументов = РезультатВыполнения.ИдентификаторУстройства;
				ПараметрыВыполнениеКоманды.ПодключенноеПечатающееУстройствоДополнительныхДокументов = РезультатВыполнения.ПодключенноеУстройство;
			КонецЕсли;
			Команда = "PrintText";
			ПолучитьДанныеОперацииПечати(ПараметрыВыполнение, ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ПодключенноеПечатающееУстройствоДополнительныхДокументов);
			ПараметрыПодключения = ПараметрыВыполнениеКоманды.ПодключенноеПечатающееУстройствоДополнительныхДокументов;
			ОбработчикДрайвера = ПараметрыВыполнениеКоманды.ПодключенноеПечатающееУстройствоДополнительныхДокументов.ОбработчикДрайвера;
			
			// Результат выполнения исходной операции
			ПараметрыВыполнение.Вставить("РезультатВыполнения", РезультатВыполнения); 
			ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыполнениеКоманды_ПечатьДополнительныхДокументовЗавершение", ЭтотОбъект, ПараметрыВыполнение);
			ОбработчикДрайвера.НачатьВыполнениеКоманды(ОписаниеОповещения, ПараметрыПодключения, Команда, ПараметрыВыполнение.ДанныеОперации);
			
		КонецЕсли;
		
	Иначе
		// Отключение оборудования при завершение
		МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоИдентификатору(Неопределено, Неопределено, ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ПечатающееУстройствоДополнительныхДокументов);
		// Завершение с ошибкой
		ВыполнитьОбработкуОповещения(ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыполнениеКоманды_ПечатьДополнительныхДокументовЗавершение(РезультатВыполнения, ПараметрыВыполнение) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ДополнительныеДокументы = ПараметрыВыполнение.ДанныеОперации.ДополнительныеДокументы;
		Если ПараметрыВыполнение.ПараметрыВыполнениеКоманды.Свойство("КопияРаспечатана") И ПараметрыВыполнение.ПараметрыВыполнениеКоманды.КопияРаспечатана И ДополнительныеДокументы.Количество() > 0 Тогда
			НачатьВыполнениеКоманды_ПечатьДополнительныхДокументов(РезультатВыполнения, ПараметрыВыполнение);
		ИначеЕсли НЕ ПараметрыВыполнение.ПараметрыВыполнениеКоманды.Свойство("КопияРаспечатана") И ДополнительныеДокументы.Количество() > 0 Тогда
			ПараметрыВыполнение.ПараметрыВыполнениеКоманды.Вставить("КопияРаспечатана", Истина);
			НачатьВыполнениеКоманды_ПечатьДополнительныхДокументов(РезультатВыполнения, ПараметрыВыполнение);
		Иначе
			// Отключение оборудования.
			МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоИдентификатору(Неопределено, Неопределено, ПараметрыВыполнение.МассивУстройствДляПодключения);
			// Завершение команды.
			ВыполнитьОбработкуОповещения(ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ОповещениеПриЗавершении, ПараметрыВыполнение.РезультатВыполнения);
		КонецЕсли; 
	Иначе
		// Отключение оборудования.
		МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоИдентификатору(Неопределено, Неопределено, ПараметрыВыполнение.МассивУстройствДляПодключения);
		// Завершение команды.
		ВыполнитьОбработкуОповещения(ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ОповещениеПриЗавершении, ПараметрыВыполнение.РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьДанныеОперацииПечати(ПараметрыВыполнение, УстройствоПечати)
	
	Команда = "CheckFiscalization";
	ПроцессорДанных = "ОборудованиеЧекопечатающиеУстройства";
	ПараметрыПодключенияСервер = МенеджерОборудованияКлиентСервер.ПараметрыПодключения(УстройствоПечати);
	ДанныеОперации = МенеджерОборудованияВызовСервера.ПодготовитьДанныеОперации(ПараметрыПодключенияСервер, ПроцессорДанных, Команда, ПараметрыВыполнение.ПараметрыВыполнениеКоманды.ПараметрыОперации);
	ПараметрыВыполнение.Вставить("ДанныеОперации", ДанныеОперации);
	
КонецПроцедуры
#КонецОбласти