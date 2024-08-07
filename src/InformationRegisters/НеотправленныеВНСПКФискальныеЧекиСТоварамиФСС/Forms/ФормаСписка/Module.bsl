
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПодтверждениеНСПК(Команда)
	
	ДокументыКПовторнойОтправке.Очистить();
	ДокументыКОтправке(Элементы.Список.ВыделенныеСтроки);
	ОтправитьПодтверждениеНСПКНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДокументыКОтправке(Знач ВыделенныеДокументы)
	
	Для каждого Элем Из ВыделенныеДокументы Цикл
		ДокументыКПовторнойОтправке.Добавить(Элем.ДокументОснование);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПодтверждениеНСПКНаКлиенте() Экспорт
	
	Если ДокументыКПовторнойОтправке.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДокументКОтправке = ДокументыКПовторнойОтправке[0].Значение;
	
	ПроверятьДокументКОтправке = Истина;
	Пока ПроверятьДокументКОтправке Цикл
		СуммаСертификатамиЭСФСС = ПодготовитьФискальныйЧекКОтправкеВНСПК(ДокументКОтправке);
		Если СуммаСертификатамиЭСФСС = Неопределено Тогда
			ДокументыКПовторнойОтправке.Удалить(0);
			ДокументКОтправке = ДокументыКПовторнойОтправке[0].Значение;
		Иначе
			ПроверятьДокументКОтправке = Ложь;
		КонецЕсли;
	КонецЦикла;
	Элементы.Список.Обновить();
	
	ПараметрыОперации = ПараметрыПередачиДанныхФискальногоЧека(ДокументКОтправке, СуммаСертификатамиЭСФСС);
	Если ПараметрыОперации = Неопределено Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Отсутствуют данные о фискализации чека: %1'"), СокрЛП(ДокументКОтправке));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ОповещениеМетода = Новый ОписаниеОповещения("ПередатьДанныеФискальногоЧекаНСПКЗавершение", ЭтотОбъект, ПараметрыОперации);
		ЭлектронныеСертификатыНСПККлиент.НачатьПередачуДанныхФискальногоЧека(ОповещениеМетода, ПараметрыОперации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанныеФискальногоЧекаНСПКЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	РезультатПередачи = Новый Структура("Результат, КодРезультата, ОписаниеОшибки", Ложь, 999, "");
	ЗаполнитьЗначенияСвойств(РезультатПередачи, РезультатВыполнения);
	
	Если Не РезультатПередачи.Результат Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'При отправке подтверждения операции %1 на сервер произошла ошибка (код %2):
			|%3'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			ДополнительныеПараметры.ИдентификаторКорзины,
			Строка(РезультатПередачи.КодРезультата),
			РезультатПередачи.ОписаниеОшибки);
			
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Подтверждение операции %1 успешно отправлено на сервер НСПК'",
				ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			ДополнительныеПараметры.ИдентификаторКорзины);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		УдалитьЗаписьПоОтправленномуВНСПКФискальномуЧеку(ДополнительныеПараметры.ОснованиеФискальнойОперации);
	КонецЕсли;
	
	ДокументыКПовторнойОтправке.Удалить(0);
	ПодключитьОбработчикОжидания("ОтправитьПодтверждениеНСПКНаКлиенте", 0.1, Истина);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Функция ПараметрыПередачиДанныхФискальногоЧека(ДокументОснование, СуммаСертификатамиЭСФСС)
	
	Возврат ЭлектронныеСертификатыНСПКУТ.ПараметрыПередачиДанныхФискальногоЧека(ДокументОснование, СуммаСертификатамиЭСФСС);
	
КонецФункции

// Подготовить фискальный чек к отправке в НСПК
// 
// Параметры:
//  ДокументОснование - ДокументСсылка - Документ, по которому отправляется фискальный чек в НСПК
// 
// Возвращаемое значение:
//  Неопределено, Число - Сумма серфтификатами ЭС ФСС
//
&НаСервереБезКонтекста
Функция ПодготовитьФискальныйЧекКОтправкеВНСПК(ДокументОснование)
	
	ПолучаемыеРеквизитыДокумента = "ЦенаВключаетНДС,Товары,ОплатаПлатежнымиКартами";
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, ПолучаемыеРеквизитыДокумента);
	
	СтрокиДляОплатыЭС = ЧекККМЛокализация.ТоварыФССВДокументеКОплате(
		РеквизитыДокумента.Товары.Выгрузить(),
		РеквизитыДокумента.ЦенаВключаетНДС);
	
	Если СтрокиДляОплатыЭС.Количество() = 0 Тогда
		УдалитьЗаписьПоОтправленномуВНСПКФискальномуЧеку(ДокументОснование);
		Возврат Неопределено;
	КонецЕсли;
	
	СуммаСертификатамиЭСФСС = СуммаОплатыЭСФССПоДокументу(РеквизитыДокумента.ОплатаПлатежнымиКартами.Выгрузить());
	
	Если СуммаСертификатамиЭСФСС = 0 Тогда
		УдалитьЗаписьПоОтправленномуВНСПКФискальномуЧеку(ДокументОснование);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СуммаСертификатамиЭСФСС;
	
КонецФункции

&НаСервереБезКонтекста
Функция СуммаОплатыЭСФССПоДокументу(ОплатыПлатежнойКартой)
	
	Возврат РозничныеПродажиЛокализация.СуммаОплатыЭСФССПоДокументу(ОплатыПлатежнойКартой);
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьЗаписьПоОтправленномуВНСПКФискальномуЧеку(ДокументОснование)
	
	ЭлектронныеСертификатыНСПКУТ.УдалитьЗаписьПоОтправленномуВНСПКФискальномуЧеку(ДокументОснование);
	
КонецПроцедуры

#КонецОбласти