
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;
	Склад                 = Параметры.Склад;
	Помещение             = Параметры.Помещение;
	Исполнитель           = Параметры.Исполнитель;
	
	ЗаполнитьСписокПересчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Склады.Форма.ФормаВыбораМРМ") Тогда
		
		Склад = ВыбранноеЗначение;
		Помещение = Неопределено;
		СформироватьПредставлениеОтбораСклад();
		СформироватьПредставлениеОтбораПомещение();
		ОбновитьДанныеФормы();
		
	КонецЕсли;
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.СкладскиеПомещения.Форма.ФормаВыбораМРМ") Тогда
		
		Помещение = ВыбранноеЗначение;
		СформироватьПредставлениеОтбораПомещение();
		ОбновитьДанныеФормы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряжений

&НаКлиенте
Процедура СписокПересчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.СписокПересчетов.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", ТекущаяСтрока.Ссылка);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);

	Описание = Новый ОписаниеОповещения("ОбновитьДанныеФормы", ЭтаФорма);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.ПересчетТоваров",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтборыОткрытьСклад(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
		
	ОткрытьФорму(
		"Справочник.Склады.Форма.ФормаВыбораМРМ",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОтборыОткрытьПомещение(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	Отбор = Новый Структура();
	Отбор.Вставить("Владелец", Склад);
	
	ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму(
		"Справочник.СкладскиеПомещения.Форма.ФормаВыбораМРМ",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	ОбновитьДанныеФормы();
	СформироватьПредставлениеОтбораСклад();
КонецПроцедуры 

&НаКлиенте
Процедура ОтборыОчиститьСклад(Команда)
	
	Склад = Неопределено;
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение();
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОчиститьПомещение(Команда)

	Помещение = Неопределено;
	СформироватьПредставлениеОтбораПомещение();
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОчиститьДату(Команда)
	
	ДатаПоступления = Неопределено;
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	ОбновитьДанныеФормы();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДанныеФормы(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаполнитьСписокПересчетов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПересчетов()
	
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокПересчетов();
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "И ПересчетТоваров.Исполнитель = &Исполнитель");
		Запрос.УстановитьПараметр("Исполнитель", Исполнитель);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Помещение) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "И ПересчетТоваров.Помещение = &Помещение");
		Запрос.УстановитьПараметр("Помещение", Помещение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПересчетовТоваров.ВнесениеРезультатов);
	
	СписокПересчетов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтбораСклад()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(Склад) Тогда
		ПредставленияОтборов = Склад;
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.Черный;
		Элементы.КомандаОтборыОчистить.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru = 'Склад'");
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.КомандаОтборыОчистить.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Если Склад["ЭтоГруппа"] = Истина Тогда
		ИспользоватьСкладскиеПомещения = Ложь;
	Иначе
		ИспользоватьСкладскиеПомещения = Склад["ИспользоватьСкладскиеПомещения"];
	КонецЕсли;
	Элементы.ГруппаКомандаОтборыОткрыть2.Видимость    = ИспользоватьСкладскиеПомещения;
	Элементы.КомандаОтборыОчиститьПомещение.Видимость = ИспользоватьСкладскиеПомещения;
	
	Элементы.КомандаОтборыОткрыть.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеОтбораПомещение()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(Помещение) Тогда
		ПредставленияОтборов = Помещение;
		Элементы.КомандаОтборыОткрытьПомещение.ЦветТекста = WebЦвета.Черный;
		Элементы.КомандаОтборыОчиститьПомещение.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть2.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru = 'Помещение'");
		Элементы.КомандаОтборыОткрытьПомещение.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.КомандаОтборыОчиститьПомещение.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть2.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Элементы.КомандаОтборыОткрытьПомещение.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

#КонецОбласти
