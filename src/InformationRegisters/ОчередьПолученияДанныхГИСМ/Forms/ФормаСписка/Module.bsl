#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура Обработать(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗагруженногоДокумента = ОбработатьНаСервере(ТекущиеДанные.GLN, ТекущиеДанные.output_id);
	
	Если ДанныеЗагруженногоДокумента <> Неопределено Тогда
		
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ДанныеЗагруженногоДокумента.Ссылка);
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ОбработатьНаСервере(GLN, output_id)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Данные,
	|	Т.GLN,
	|	Т.output_id,
	|	Т.ДатаРегистрации,
	|	Т.action_id
	|ИЗ
	|	РегистрСведений.ОчередьПолученияДанныхГИСМ КАК Т
	|ГДЕ
	|	Т.GLN = &GLN
	|	И Т.output_id = &output_id");
	
	Запрос.УстановитьПараметр("GLN", GLN);
	Запрос.УстановитьПараметр("output_id", output_id);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Сообщения = Выборка.Данные.Получить();
		
		Если Сообщения = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не удалось обработать сообщение. SOAP-конверт не загружен.'"));
			Возврат Неопределено;
		КонецЕсли;
		
		ДанныеДляПолученияДокумента = Новый Структура;
		ДанныеДляПолученияДокумента.Вставить("ДобавленВОчередь",  Истина);
		ДанныеДляПолученияДокумента.Вставить("ДатаРегистрации",   Выборка.ДатаРегистрации);
		ДанныеДляПолученияДокумента.Вставить("Данные",            Выборка.Данные);
		ДанныеДляПолученияДокумента.Вставить("GLN",               Выборка.GLN);
		ДанныеДляПолученияДокумента.Вставить("action_id",         Выборка.action_id);
		ДанныеДляПолученияДокумента.Вставить("output_id",         Выборка.output_id);
		ДанныеДляПолученияДокумента.Вставить("ТекстСообщенияXML", "");
		
		ДанныеЗагруженногоДокумента = ИнтеграцияГИСМ.ОбработатьЗагрузкуДокумента(
			Сообщения.ТекстВходящегоСообщенияXML,
			Сообщения.ТекстИсходящегоСообщенияXML,
			ДанныеДляПолученияДокумента);
		
	КонецЕсли;
	
	Возврат ДанныеЗагруженногоДокумента;
	
КонецФункции

#КонецОбласти