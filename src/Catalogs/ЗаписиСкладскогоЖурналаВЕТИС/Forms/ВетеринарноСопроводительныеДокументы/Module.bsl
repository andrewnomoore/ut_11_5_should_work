
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ВетеринарноСопроводительныеДокументы") Тогда
		Для каждого Строка Из Параметры.ВетеринарноСопроводительныеДокументы Цикл
			ЗаполнитьЗначенияСвойств(ВетеринарноСопроводительныеДокументы.Добавить(), Строка);
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "ВетеринарноСопроводительныеДокументы");
	
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПроизводственныеПартии

&НаКлиенте
Процедура ПроизводственныеПартииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	СформироватьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПроизводственныеПартииПослеУдаления(Элемент)
	СформироватьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПроизводственныеПартииПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "ВетеринарноСопроводительныеДокументы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СохранитьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьИзменения();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения()
	
	ОчиститьСообщения();
	
	СтруктураПроверяемыхПолей = Новый Структура;
	СтруктураПроверяемыхПолей.Вставить("ВетеринарноСопроводительныйДокумент", НСтр("ru='ВСД'"));
	
	Если ИнтеграцияВЕТИСКлиент.ПроверитьЗаполнениеТаблицы(ЭтаФорма, "ВетеринарноСопроводительныеДокументы", СтруктураПроверяемыхПолей) Тогда
		Модифицированность = Ложь;
		ОповеститьОВыборе(ВетеринарноСопроводительныеДокументы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Ветеринарно-сопроводительные документы'")
		+ ?(ВетеринарноСопроводительныеДокументы.Количество()," ("+ВетеринарноСопроводительныеДокументы.Количество()+")","");
	
КонецПроцедуры

#КонецОбласти