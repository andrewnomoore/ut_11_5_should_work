#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполним реквизиты формы из параметров.
	Если Не ПустаяСтрока(Параметры.Комментарий) Тогда
		ДанныеJson = РаспознаваниеДокументовСериализацияСлужебный.JsonLoad(Параметры.Комментарий);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеJson, "ТекстПользователя, АдресEmail");
	КонецЕсли;
	
	Если ПустаяСтрока(АдресEmail) Тогда
		ТекущиеНастройки = РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов.ТекущиеНастройки();
		АдресEmail = ТекущиеНастройки.АдресЭлПочты;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		СохранитьАдресЭлПочтыНаСервере();
		СтруктураРезультат = Новый Структура("Комментарий", РеквизитыФормыВJsonСтроку());
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		
	ИначеЕсли Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ВопросСохраненияДанныхЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
	ИначеЕсли ПеренестиВДокумент Тогда
		
		Если Отказ Тогда
			Модифицированность = Истина;
			ПеренестиВДокумент = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РеквизитыФормыВJsonСтроку()
	
	ДанныеJson = Новый Структура("ТекстПользователя, АдресEmail", ТекстПользователя, АдресEmail);
	Возврат РаспознаваниеДокументовСериализацияСлужебный.JsonDump(ДанныеJson);
	
КонецФункции

&НаКлиенте
Процедура ВопросСохраненияДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьАдресЭлПочтыНаСервере()
	
	Если ПустаяСтрока(АдресEmail) Тогда
		Возврат
	КонецЕсли;
	
	ТекущиеНастройки = РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов.ТекущиеНастройки();
	Если ПустаяСтрока(ТекущиеНастройки.АдресЭлПочты) Тогда
		Возврат;
	КонецЕсли;
	
	РаспознаваниеДокументовSDK.УстановитьАдресЭлектроннойПочты(АдресEmail);
	
	МенеджерЗаписи = РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.АдресЭлПочты = АдресEmail;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

