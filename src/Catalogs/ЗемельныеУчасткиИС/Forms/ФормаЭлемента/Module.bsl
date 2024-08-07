#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриСозданииЧтенииНаСервере();
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресСтрокойПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных, сбрасываем как представления, так и внутренние значения полей.
		Объект.Адрес        = "";
		Объект.АдресСтрокой = "";
		КомментарийАдрес    = "";
		Возврат;
	КонецЕсли;
		
	// Формируем внутренние значения полей по тексту и параметрам формирования из
	// структуры ВидКонтактнойИнформацииАдрес.
	Объект.Адрес = ЗначенияПолейКонтактнойИнформацииСервер(
		Текст, ВидКонтактнойИнформацииАдрес, КомментарийАдрес);
	Объект.АдресСтрокой = Текст;

КонецПроцедуры

&НаКлиенте
Процедура АдресСтрокойОчистка(Элемент, СтандартнаяОбработка)
	
	// Сбрасываем как представления, так и внутренние значения полей.
	Объект.Адрес        = "";
	Объект.АдресСтрокой = "";
	КомментарийАдрес    = "";
	
КонецПроцедуры

&НаКлиенте
Процедура АдресСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны.
		Возврат;
	КонецЕсли;
	
	Объект.Адрес        = ВыбранноеЗначение.КонтактнаяИнформация;
	Объект.АдресСтрокой = ВыбранноеЗначение.Представление;
	КомментарийАдрес    = ВыбранноеЗначение.Комментарий;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата кнопка выбора, то необходимо 
	// привести данные в соответствие и сбросить внутренние поля для повторного разбора.
	Если Элемент.ТекстРедактирования <> Объект.АдресСтрокой Тогда
		Объект.АдресСтрокой = Элемент.ТекстРедактирования;
		Объект.Адрес = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдрес);
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           Объект.Адрес);
	ПараметрыОткрытия.Вставить("Представление",           Объект.АдресСтрокой);
	ПараметрыОткрытия.Вставить("Комментарий",             КомментарийАдрес);
	
	// Переопределямый заголовок формы, по умолчанию отобразятся данные по ВидКонтактнойИнформации.
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru = 'Адрес земельного участка'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнициализироватьПоляКонтактнойИнформации();
		
КонецПроцедуры

#Область РаботаСАдресами

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	ВидКонтактнойИнформацииАдрес = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	// Считываем данные из полей адреса в реквизиты для редактирования.
	Объект.АдресСтрокой = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Объект.Адрес);
	КомментарийАдрес = ИнтеграцияИС.КомментарийКонтактнойИнформации(Объект.Адрес);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначенияПолейКонтактнойИнформацииСервер(Знач Представление, Знач ВидКонтактнойИнформации, Знач Комментарий = Неопределено)
	
	// Создаем новый экземпляр по представлению.
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(
		Представление, ВидКонтактнойИнформации);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
