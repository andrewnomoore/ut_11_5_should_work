
#Область ОписаниеПеременных

&НаКлиенте
Перем ЭтоЗакрытиеФормы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ИдентификаторКэшаКатегорий = "ДеревоКатегорий";

	УчетнаяЗаписьТорговойПлощадки = Параметры.УчетнаяЗаписьТорговойПлощадки;
	КатегорииТорговойПлощадки     = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ВыбранныеКатегории);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ЗаполнитьДеревоКатегорий();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	ЭтоЗакрытиеФормы = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоКатегорийМаркетплейса

&НаКлиенте
Процедура ДеревоКатегорийМаркетплейсаПометкаПриИзменении(Элемент)

	СтрокаДерева = Элементы.ДеревоКатегорийМаркетплейса.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ИнтеграцияСМаркетплейсомOzonКлиентСервер.УстановитьСнятьПометки(СтрокаДерева, СтрокаДерева.Пометка);
	ИнтеграцияСМаркетплейсомOzonКлиентСервер.УстановитьСнятьПометки(СтрокаДерева, СтрокаДерева.Пометка, Ложь);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПометки(Команда)

	Для Каждого СтрокаДерева Из ДеревоКатегорийМаркетплейса.ПолучитьЭлементы() Цикл
		ИнтеграцияСМаркетплейсомOzonКлиентСервер.УстановитьСнятьПометки(СтрокаДерева, Истина);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)

	Для Каждого СтрокаДерева Из ДеревоКатегорийМаркетплейса.ПолучитьЭлементы() Цикл
		ИнтеграцияСМаркетплейсомOzonКлиентСервер.УстановитьСнятьПометки(СтрокаДерева, Ложь);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)

	ВыбранныеКатегории = ВыбранныеКатегории(ДеревоКатегорийМаркетплейса.ПолучитьЭлементы());
	Закрыть(ВыбранныеКатегории);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьДеревоКатегорий()

	ОчиститьСообщения();

	Элементы.СтраницыЭлементовДлительногоОжидания.ТекущаяСтраница = Элементы.СтраницаДлительногоОжидания;

	ДанныеКэша = ИнтеграцияСМаркетплейсомOzonКлиент.ПолучитьДанныеИзКэшаКатегорий(ИдентификаторКэшаКатегорий);
	ДлительнаяОперация = ПолучитьКатегорииМаркетплейсаНаСервере(ДанныеКэша);

	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьДеревоКатегорийМаркетплейсаЗавершение", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

&НаСервере
Функция ПолучитьКатегорииМаркетплейсаНаСервере(ДанныеКэша)

	ИмяМетода = "ИнтеграцияСМаркетплейсомOzonСервер.ЗаполнитьДеревоКатегорийИТиповТоваров";
	НаименованиеФоновогоЗадания = НСтр("ru = 'Ozon. Получение категорий маркетплейса'");

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеФоновогоЗадания;

	ДеревоКатегорийМаркетплейсаФормы = РеквизитФормыВЗначение("ДеревоКатегорийМаркетплейса");
	ДеревоКатегорийМаркетплейсаФормы.Строки.Очистить();

	ПараметрыУстановкиПометокВКоллекции =
		ИнтеграцияСМаркетплейсомOzonСервер.НовыеПараметрыУстановкиПометокВКоллекции();
	ПараметрыУстановкиПометокВКоллекции.ЭлементыПометки = КатегорииТорговойПлощадки.ВыгрузитьЗначения();

	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода,
				УчетнаяЗаписьТорговойПлощадки, ДеревоКатегорийМаркетплейсаФормы, ДанныеКэша,
				Истина, ПараметрыУстановкиПометокВКоллекции);

КонецФункции

&НаКлиенте
Процедура ЗаполнитьДеревоКатегорийМаркетплейсаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ОчиститьСообщения();

	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		ДанныеКэша = Неопределено;
		ЗаполнитьДеревоКатегорийМаркетплейсаНаСервере(Результат.АдресРезультата, ДанныеКэша);

		Если ЗначениеЗаполнено(ДанныеКэша) Тогда
			ИнтеграцияСМаркетплейсомOzonКлиент.СохранитьДанныеВКэшКатегорий(ДанныеКэша, ИдентификаторКэшаКатегорий);
			ДанныеКэша = Неопределено;
		КонецЕсли;
	ИначеЕсли ЭтоЗакрытиеФормы <> Истина Тогда
		ШаблонОшибки = НСтр("ru = 'Не удалось получить категории маркетплейса по причине: %1. Подробнее см. журнал регистрации.'");
		ПредставлениеНеизвестнойОшибки = НСтр("ru = 'Неизвестная ошибка выполнения операции'");
		ПодробноеПредставлениеОшибки = ?(Результат = Неопределено, ПредставлениеНеизвестнойОшибки, Результат.ПодробноеПредставлениеОшибки);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибки,
				ПодробноеПредставлениеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;

	Элементы.СтраницыЭлементовДлительногоОжидания.ТекущаяСтраница = Элементы.СтраницаКоманды;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоКатегорийМаркетплейсаНаСервере(АдресХранилища, ДанныеКэша)

	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	УдалитьИзВременногоХранилища(АдресХранилища);

	ДеревоКатегорий = Результат.ДеревоКатегорий;
	ДанныеКэша = Результат.ДанныеКэша;

	Если ДеревоКатегорий = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ЗначениеВРеквизитФормы(ДеревоКатегорий, "ДеревоКатегорийМаркетплейса");

КонецПроцедуры

&НаКлиенте
Функция ВыбранныеКатегории(Знач ЭлементДерева)

	ВыбранныеКатегории = Новый СписокЗначений;

	Для Каждого ПодчиненнаяСтрокаДерева Из ЭлементДерева Цикл
		Если ПодчиненнаяСтрокаДерева.Пометка Тогда
			Если ПодчиненнаяСтрокаДерева.Уровень = 3 Тогда
				ВыбранныеКатегории.Добавить(ПодчиненнаяСтрокаДерева.ИдентификаторКатегорииМаркетплейса,
					ПодчиненнаяСтрокаДерева.НаименованиеКатегорииМаркетплейса);
			Иначе
				ПодчиненныеВыбранныеКатегории = ВыбранныеКатегории(ПодчиненнаяСтрокаДерева.ПолучитьЭлементы());
				Для Каждого ЭлементСписка Из ПодчиненныеВыбранныеКатегории Цикл
					ВыбранныеКатегории.Добавить(ЭлементСписка.Значение,
						ЭлементСписка.Представление);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат ВыбранныеКатегории;

КонецФункции

#КонецОбласти
