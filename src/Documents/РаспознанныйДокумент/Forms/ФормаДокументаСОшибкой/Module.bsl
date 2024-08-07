#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Объект.Наименование;
	ПолеПросмотра = РаспознаваниеДокументовСлужебный.МакетОтображенияКартинкиДокументаHTML();
	
	Если Объект.ТребуетсяОплата Тогда
		Элементы.ИмяФайла.Видимость = Ложь;
		Элементы.ТипДокумента.Видимость = Ложь;
		Элементы.ГруппаПодсказки.Видимость = Ложь;
		КоличествоФайлов = РаспознаваниеДокументовСлужебныйВызовСервера.КоличествоФайловРаспознанногоДокумента(Объект.Ссылка);
		Если КоличествоФайлов > 1 Тогда
			Элементы.СохранитьФайл.Заголовок = НСтр("ru = 'Сохранить файлы'");
		КонецЕсли;
	Иначе
		Элементы.КоличествоФайлов.Видимость = Ложь;
		Элементы.ОтправитьПовторно.Видимость = Ложь;
	КонецЕсли;
	
	Если Не РаспознаваниеДокументовСлужебныйВызовСервера.ДоступенНеоплаченныйРаспознанныйДокумент(Объект.Ссылка)
		Или Объект.ТребуетсяОплата Тогда
		
		Элементы.ГруппаПраво.Видимость = Ложь;
	Иначе
		АдресКартинки = ПоместитьВоВременноеХранилище(
			РаспознаваниеДокументовСлужебный.ИсходноеИзображение(Объект.Ссылка),
			УникальныйИдентификатор
		);
	КонецЕсли;
	
	Если Объект.ТребуетсяОплата Тогда
		Попытка
			ТекущийБаланс = РаспознаваниеДокументовSDK.ТекущийБаланс();
			Лимит = ТекущийБаланс.Лимит;
		Исключение
			Лимит = 0;
		КонецПопытки;
		
		Если Лимит < КоличествоФайлов
			Или Не РаспознаваниеДокументовСлужебныйВызовСервера.ДоступенНеоплаченныйРаспознанныйДокумент(Объект.Ссылка) Тогда
			
			Элементы.ОтправитьПовторно.Доступность = Ложь;
			Элементы.ОписаниеОшибки.Высота = 4;
			
			Объект.ОписаниеОшибки =
			НСтр("ru = 'Не хватило средств на счете для распознавания документов.
			           |Пожалуйста, пополните баланс.'");
			
		Иначе
			Элементы.СохранитьФайл.КнопкаПоУмолчанию = Ложь;
			Элементы.ОтправитьПовторно.КнопкаПоУмолчанию = Истина;
			Элементы.Переместить(Элементы.ОтправитьПовторно, Элементы.ГруппаКомандыИНастройки, Элементы.СохранитьФайл);
			
			Объект.ОписаниеОшибки =
			НСтр("ru = 'Не хватило средств на счете для распознавания документов. Пожалуйста, пополните баланс.
			           |Нажмите ""Отправить повторно"", чтобы отправить файлы на распознавание еще раз.'");
			
			Модифицированность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.ОписаниеОшибки) Тогда
		Элементы.ГруппаДополнительно.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.РаспознанныйДокумент.Форма.ФормаОбратнойСвязи" Тогда
		РаспознаваниеДокументовСлужебныйКлиент.ОбработкаВыбораОбратнойСвязи(ЭтотОбъект, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаспознаваниеДокументовСлужебный.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КартинкаЗакрытьПодсказкуНажатие(Элемент)
	
	Элементы.ГруппаПодсказки.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	
	Обработчик = Новый ОписаниеОповещения("ПослеПроверкиИзменения", ЭтотОбъект);
	ПредлагатьЗаписать = Ложь;
	РаспознаваниеДокументовСлужебныйКлиент.ИзменитьТипДокумента(ЭтотОбъект, Обработчик, ПредлагатьЗаписать);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбработкиПриИзменении(Элемент)
	
	Обработчик = Новый ОписаниеОповещения("ПослеПроверкиИзменения", ЭтотОбъект);
	ПредлагатьЗаписать = Ложь;
	РаспознаваниеДокументовСлужебныйКлиент.ИзменитьВариантОбработки(ЭтотОбъект, Обработчик, ПредлагатьЗаписать);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбработкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПолеПросмотраДокументСформирован(Элемент)
	
	Если Элемент.Документ.baseURI = "about:blank" Тогда
		Возврат;
	КонецЕсли;
	
	РаспознаваниеДокументовСлужебныйКлиент.ЗагрузитьКартинкуПоАдресу(Элементы.ПолеПросмотра, АдресКартинки);
	HTMLДокументСформирован = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	РаспознаваниеДокументовСлужебныйКлиент.СохранитьФайлыДокумента(Объект.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПожаловатьсяНаКачество(Команда)
	
	РаспознаваниеДокументовСлужебныйКлиент.ОткрытьФормуОбратнойСвязи(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПовторно(Команда)
	
	ИнформацияОФайлах = РаспознаваниеДокументовСлужебныйВызовСервера.ФайлыРаспознанногоДокумента(Объект.Ссылка, УникальныйИдентификатор);
	РаспознаваниеДокументовКлиент.ПоказатьДобавлениеФайлов(УникальныйИдентификатор, , ИнформацияОФайлах);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьСкан(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораОбъектаПрикрепления", ЭтотОбъект);
	ОткрытьФорму(
		"РегистрСведений.СвязанныеОбъектыРаспознаниеДокументов.Форма.ФормаВыбораСвязанного", , , , , ,
		ОписаниеОповещения
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПроверкиИзменения(ТребуетсяИзменениеФормы, Контекст) Экспорт
	
	Если Не ТребуетсяИзменениеФормы Тогда
		УправлениеФормой();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ТребуетсяУказатьВариантОбработки =
		(Объект.ТипДокумента = Перечисления.ТипыДокументовРаспознаваниеДокументов.НеопознанныйДокумент);
	Элементы.ВариантОбработки.Видимость = ТребуетсяУказатьВариантОбработки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОбъектаПрикрепления(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьИсходноеИзображениеНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИсходноеИзображениеНаСервере(КудаДобавляемСсылка)
	
	РаспознаваниеДокументовСлужебный.ПрикрепитьИсходныеФайлы(Объект.Ссылка, КудаДобавляемСсылка);
	
КонецПроцедуры

#КонецОбласти