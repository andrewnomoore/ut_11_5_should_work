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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогОбменаИнформациейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Объект, "КаталогОбменаИнформацией", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура КаталогОбменаИнформациейОткрытие(Элемент, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Объект, "КаталогОбменаИнформацией", СтандартнаяОбработка)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Если Не Объект.ЗапомнитьПароль Тогда
			Объект.Пароль = "";
		КонецЕсли;
		
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

&НаКлиенте
Процедура ПараметрыДоступаВИнтернет(Команда)
	
	ТранспортСообщенийОбменаКлиент.ОткрытьФормуПараметровПроксиСервера();
	
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
	
	Если Не ПустаяСтрока(Объект.АдресВебСервиса) Тогда
		
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(Объект.АдресВебСервиса);
		Если ЗначениеЗаполнено(СтруктураАдреса.Схема) Тогда
			
			Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				СтруктураАдреса.Схема, СтруктураАдреса.Хост, СтруктураАдреса.Порт));
				
			ЗапросыРазрешений.Добавить(
				МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения));
			
		КонецЕсли;
		
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
