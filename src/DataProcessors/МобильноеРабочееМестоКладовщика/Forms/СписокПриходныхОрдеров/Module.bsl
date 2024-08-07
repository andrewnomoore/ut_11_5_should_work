
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;
	Склад                 = Параметры.Склад;
	Помещение             = Параметры.Помещение;
	Исполнитель           = Параметры.Исполнитель;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьПредставлениеОтборов();
	СформироватьПредставлениеОтбораПомещение();
	
	ОбновитьДанныеФормыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Склады.Форма.ФормаВыбораМРМ") Тогда
		
		Склад = ВыбранноеЗначение;
		СформироватьПредставлениеОтборов();
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОрдеров

&НаКлиенте
Процедура СписокОрдеровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.СписокОрдеров.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", ТекущаяСтрока.Ссылка);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	
	Описание = Новый ОписаниеОповещения("ОбновитьДанныеФормы", ЭтаФорма);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.ПриходныйОрдер",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтборыОткрыть(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
		
	Отбор = Новый Структура();
	Отбор.Вставить("ИспользоватьОрдернуюСхемуПриПоступлении", Истина);
	ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму(
		"Справочник.Склады.Форма.ФормаВыбораМРМ",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	ОбновитьДанныеФормы();
	СформироватьПредставлениеОтборов();
КонецПроцедуры 

&НаКлиенте
Процедура ОтборыОчиститьСклад(Команда)
	
	Склад = Неопределено;
	СформироватьПредставлениеОтборов();
	СформироватьПредставлениеОтбораПомещение();
	ОбновитьДанныеФормы();
	
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
Процедура ОтборыОчиститьПомещение(Команда)
	
	Помещение = Неопределено;
	СформироватьПредставлениеОтбораПомещение();
	ОбновитьДанныеФормы(); 
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриходногоОрдераПриИзменении(Элемент) 
	
	СформироватьПредставлениеОтборов();
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
	
	ОбновитьДанныеФормыСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормыСервер()
	
	ЗаполнитьСписокРаспоряжений();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()

	ИспользоватьСтатусыПриходныхОрдеров = Ложь; 
	Если ЗначениеЗаполнено(Склад) Тогда
		ИспользоватьСтатусыПриходныхОрдеров = Склад["ИспользоватьСтатусыПриходныхОрдеров"];
	КонецЕсли;	
	Элементы.СтатусОрдера.Видимость = ИспользоватьСтатусыПриходныхОрдеров;
	
	СписокОрдеров.Очистить();
	
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокПриходныхОрдеров();
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Если ЗначениеЗаполнено(Помещение) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "И ПриходныйОрдерНаТовары.Помещение = &Помещение");
		Запрос.УстановитьПараметр("Помещение", Помещение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "И ПриходныйОрдерНаТовары.Исполнитель = &Исполнитель");
		Запрос.УстановитьПараметр("Исполнитель", Исполнитель);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "");
	КонецЕсли;
	
	Если ИспользоватьСтатусыПриходныхОрдеров И ЗначениеЗаполнено(Статус) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "И ПриходныйОрдерНаТовары.Статус = &Статус");
		Запрос.УстановитьПараметр("Статус", Статус);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "");
	КонецЕсли;
	
	СписокОрдеров.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтборов()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(Склад) Тогда
		ПредставленияОтборов = Склад;
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.Черный;
		Элементы.ГруппаКомандаОтборыКоличествоОчистить.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru = 'Склад'");
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.ГруппаКомандаОтборыКоличествоОчистить.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Если Склад["ЭтоГруппа"] Тогда
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
		ПредставленияОтборов = НСтр("ru = 'Выбрать помещение'");
		Элементы.КомандаОтборыОткрытьПомещение.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.КомандаОтборыОчиститьПомещение.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть2.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Элементы.КомандаОтборыОткрытьПомещение.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

#КонецОбласти
