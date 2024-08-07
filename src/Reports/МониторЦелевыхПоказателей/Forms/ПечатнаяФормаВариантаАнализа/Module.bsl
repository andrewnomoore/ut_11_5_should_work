#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчика;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Поддержка интеграции с рассылками-отчетов
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("ОтборВариантовАнализа")
			И ЗначениеЗаполнено(Параметры.Отбор.ОтборВариантовАнализа) Тогда
			ОтборВариантовАнализа = Параметры.Отбор.ОтборВариантовАнализа; // СправочникСсылка.ВариантыАнализаЦелевыхПоказателей -
			Заголовок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтборВариантовАнализа, "Наименование");
		Иначе
			Заголовок = НСтр("ru= 'Монитор целевых показателей (печать)'");
		КонецЕсли;
		Если Параметры.Отбор.Свойство("ДемонстрационныйРежим")
			И Параметры.Отбор.ДемонстрационныйРежим Тогда
			Заголовок = НСтр("ru= 'Демонстрационный режим'") + ": " + Заголовок;
		КонецЕсли;
	КонецЕсли;
	
	ОтчетНаименованиеТекущегоВарианта = Заголовок;
	
	РежимВариантаОтчета = Истина;
	КлючТекущегоВарианта = "МониторЦелевыхПоказателей";
	
	// Локальные переменные
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	ОтчетМетаданные = ОтчетОбъект.Метаданные();
	НастройкиОтчета = ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию();
	АдресСхемы = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	НастройкиОтчета.Вставить("АдресСхемы", АдресСхемы);
	НастройкиОтчета.Вставить("ПолноеИмя", ОтчетМетаданные.ПолноеИмя());
	НастройкиОтчета.Вставить("Наименование", СокрЛП(ОтчетМетаданные.Представление()));
	
	Информация = ВариантыОтчетов.ИнформацияОбОтчете(НастройкиОтчета.ПолноеИмя);
	НастройкиОтчета.Вставить("ОтчетСсылка", Информация.Отчет);
	НастройкиОтчета.Вставить("ВариантСсылка", ВариантыОтчетов.ВариантОтчета(НастройкиОтчета.ОтчетСсылка, КлючТекущегоВарианта));
	НастройкиОтчета.Вставить("Внешний", Ложь);
	
	// Тесная интеграция с почтой и рассылкой.
	ДоступнаОтправкаПисем = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
		ДоступнаОтправкаПисем = МодульРаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем();
	КонецЕсли;
	Если ДоступнаОтправкаПисем Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
			МодульРассылкаОтчетов = ОбщегоНазначения.ОбщийМодуль("РассылкаОтчетов");
			МодульРассылкаОтчетов.ФормаОтчетаДобавитьКоманды(ЭтотОбъект, Отказ, СтандартнаяОбработка);
		Иначе // Если в подменю одна команда, то выпадающий список не отображается.
			Элементы.ОтправитьПоЭлектроннойПочте.Заголовок = Элементы.ГруппаОтправить.Заголовок + "...";
			Элементы.Переместить(Элементы.ОтправитьПоЭлектроннойПочте, Элементы.ГруппаОтправить.Родитель, Элементы.ГруппаОтправить);
		КонецЕсли;
	Иначе
		Элементы.ГруппаОтправить.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(Результат, ПодчиненнаяФорма)
	РезультатОбработан = Ложь;
	
	// Механизмы расширения.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		МодульРассылкаОтчетовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РассылкаОтчетовКлиент");
		МодульРассылкаОтчетовКлиент.ФормаОтчетаОбработкаВыбора(ЭтотОбъект, Результат, ПодчиненнаяФорма, РезультатОбработан);
	КонецЕсли;
	ОтчетыКлиентПереопределяемый.ОбработкаВыбора(ЭтотОбъект, Результат, ПодчиненнаяФорма, РезультатОбработан);
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

// Подключаемый обработчик события элемента формы.
// 
// Параметры:
// 	Команда - КомандаФормы - 
&НаКлиенте
Процедура Подключаемый_Команда(Команда)
	ПостояннаяКоманда = ПостоянныеКоманды.НайтиПоЗначению(Команда.Имя);
	Если ПостояннаяКоманда <> Неопределено И ЗначениеЗаполнено(ПостояннаяКоманда.Представление) Тогда
		МассивПодстрок = СтрРазделить(ПостояннаяКоманда.Представление, ".");
		КлиентскийМодуль = ОбщегоНазначенияКлиент.ОбщийМодуль(МассивПодстрок[0]);
		Обработчик = Новый ОписаниеОповещения(МассивПодстрок[1], КлиентскийМодуль, Команда);
		ВыполнитьОбработкуОповещения(Обработчик, ЭтотОбъект);
	Иначе
		ОтчетыКлиентПереопределяемый.ОбработчикКоманды(ЭтотОбъект, Команда, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	ПоказатьДиалогОтправкиПоЭлектроннойПочте();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	ФлагЗащиты = Результат.Защита;
	Результат.Защита = Ложь;
	Вложение = Новый Структура;
	Вложение.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор));
	Вложение.Вставить("Представление", Заголовок);
	Результат.Защита = ФлагЗащиты;
	
	СписокВложений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Вложение);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		ПараметрыОтправки = МодульРаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма();
		ПараметрыОтправки.Тема = Заголовок;
		ПараметрыОтправки.Вложения = СписокВложений;
		МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
