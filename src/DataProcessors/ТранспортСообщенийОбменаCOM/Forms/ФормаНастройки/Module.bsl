///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТранспортСообщенийОбмена.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВариантРаботыИнформационнойБазы();
	
	АутентификацияОперационнойСистемы();

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантРаботыИнформационнойБазыПриИзменении(Элемент)
	
	ВариантРаботыИнформационнойБазы();
	
КонецПроцедуры

&НаКлиенте
Процедура АутентификацияОперационнойСистемыПриИзменении(Элемент)
	
	АутентификацияОперационнойСистемы()
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаботыИнформационнойБазы()
	
	ТекущаяСтраница = ?(Объект.ВариантРаботыИнформационнойБазы = 0, Элементы.СтраницаВариантРаботыФайловый, Элементы.СтраницаВариантРаботыКлиентСерверный);
	
	Элементы.ВариантыРаботыИнформационнойБазы.ТекущаяСтраница = ТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура АутентификацияОперационнойСистемы()
	
	Элементы.Пользователь.Доступность = Не Объект.АутентификацияОперационнойСистемы;
	Элементы.Пароль.Доступность = Не Объект.АутентификацияОперационнойСистемы;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Объект, "КаталогИнформационнойБазы", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогИнформационнойБазыОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Объект, "КаталогИнформационнойБазы", СтандартнаяОбработка)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатЗакрытия = РезультатЗакрытияНаСервере();
		Закрыть(РезультатЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Объект);
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РезультатЗакрытияНаСервере()
	
	Возврат ТранспортСообщенийОбмена.РезультатЗакрытияФормыТранспорта(ЭтаФорма);
	
КонецФункции

&НаСервереБезКонтекста
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(Знач Объект)
	
	ЗапросыРазрешений = Новый Массив;
	Разрешения = Новый Массив;
	
	Если Не ПустаяСтрока(Объект.КаталогИнформационнойБазы)
		Или Не ПустаяСтрока(Объект.ИмяИнформационнойБазыНаСервере1СПредприятия) Тогда
		
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
				
		ИмяCOMСоединителя = ОбщегоНазначенияКлиентСервер.ИмяCOMСоединителя();
		Разрешение = МодульРаботаВБезопасномРежиме.РазрешениеНаСозданиеCOMКласса(
			ИмяCOMСоединителя, ОбщегоНазначения.ИдентификаторCOMСоединителя(ИмяCOMСоединителя));
		
		Разрешения.Добавить(Разрешение);
		
		ЗапросыРазрешений.Добавить(
			МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения));
		
	КонецЕсли;
	
	Возврат ЗапросыРазрешений;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		ПодключениеУстановлено = Ложь;
		ПроверитьПодключениеНаСервере(ПодключениеУстановлено);
		
		ТекстПредупреждения = ?(ПодключениеУстановлено, НСтр("ru = 'Подключение успешно установлено.'"),
								НСтр("ru = 'Не удалось установить подключение.'"));
								
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере(ПодключениеУстановлено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	// Заполним пароль.
	ТранспортСообщенийОбмена.ЗаполнитьНастройкиИзБезопасногоХранилищаДляФормы(ЭтаФорма, ОбработкаОбъект);
	
	// Выполняем проверку подключения.
	ПодключениеУстановлено = ОбработкаОбъект.ПодключениеУстановлено();
	Если Не ПодключениеУстановлено Тогда
		
		Отказ = Истина;
		
		СообщениеОбОшибке = ОбработкаОбъект.СообщениеОбОшибке
			+ Символы.ПС + НСтр("ru = 'Техническую информацию об ошибке см. в журнале регистрации.'");
					
		ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке, , , , Отказ);
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


#КонецОбласти


