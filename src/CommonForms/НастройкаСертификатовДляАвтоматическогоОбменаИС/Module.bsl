
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подсистема = Параметры.Подсистема;
	
	УстановитьУсловноеОформление();
	
	Если Подсистема = "ЗЕРНО" Тогда
		Заголовок = НСтр("ru = 'Настройка сертификатов организаций для автоматического обмена по расписанию и подписания сообщений на сервере'");
	КонецЕсли;
	
	Элементы.НастройкиПодразделение.Видимость = ОбщегоНазначенияИС.ИспользоватьПодразделения()
		Или ОбщегоНазначенияИС.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс();
	
	ХранилищеЗначения = Константы.НастройкиОбменаГосИС.Получить();
	СохраненныеНастройки = ХранилищеЗначения.Получить();
	
	Если СохраненныеНастройки <> Неопределено Тогда
		
		Настройки.Загрузить(СохраненныеНастройки);
		
		Индекс = 1;
		Для Каждого СтрокаТЧ Из Настройки Цикл
			
			Если ПарольУстановлен(СтрокаТЧ.Сертификат) Тогда
				СтрокаТЧ.Пароль = НСтр("ru = 'Установлен'");
			Иначе
				СтрокаТЧ.Пароль = НСтр("ru = 'Не установлен'");
			КонецЕсли;
			
			Индекс = Индекс + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТолькоПросмотр = Не ПравоДоступа("Изменение", Метаданные.Константы.НастройкиОбменаГосИС);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НомерСтроки = 0;
	Для Каждого Строка Из Настройки Цикл
		НомерСтроки = НомерСтроки + 1;
		Если Не ЗначениеЗаполнено(Строка.Организация) Тогда
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
					НСтр("ru = 'В строке %1 табличной части не заполнено поле ""Организация""'"),
					НомерСтроки),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Настройки", НомерСтроки, "Организация"),,
				Отказ);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Строка.Сертификат) Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
					НСтр("ru = 'В строке %1 табличной части не заполнено поле ""Сертификат""'"),
					НомерСтроки),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Настройки", НомерСтроки, "Сертификат"),,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПослеОтветаНаВопросОЗакрытииФормы", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Сохранить изменения?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройки

&НаКлиенте
Процедура НастройкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПарольУстановлен(ТекущиеДанные.Сертификат) Тогда
		ТекущиеДанные.Пароль = НСтр("ru = 'Установлен'");
	Иначе
		ТекущиеДанные.Пароль = НСтр("ru = 'Не установлен'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьИЗакрытьНаСервере();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПароль(Команда)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Сертификат) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сертификат", ТекущиеДанные.Сертификат);
	
	ОткрытьФорму("ОбщаяФорма.ЗаписьПароляСертификатаИС",
		ПараметрыФормы,,,,,Новый ОписаниеОповещения("ПослеУстановкиПароля", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	Если Подсистема <> "ЗЕРНО" Тогда
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиПодразделение.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.Подразделение");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<любое подразделение>'"));
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПарольУстановлен(Сертификат)
	
	Значение = Ложь;
	
	Пароль = ОбщегоНазначенияИС.ПарольКСертификату(Сертификат);
	Если ЗначениеЗаполнено(Пароль) Тогда
		Значение = Истина;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	СохраняемыеНастройки = Настройки.Выгрузить(, "Организация, Подразделение, Сертификат");
	
	ХранилищеЗначения = Новый ХранилищеЗначения(СохраняемыеНастройки);
	
	Константы.НастройкиОбменаГосИС.Установить(ХранилищеЗначения);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиПароля(Результат, ДополнительныеПараметры) Экспорт
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПарольУстановлен(ТекущиеДанные.Сертификат) Тогда
		ТекущиеДанные.Пароль = НСтр("ru = 'Установлен'");
	Иначе
		ТекущиеДанные.Пароль = НСтр("ru = 'Не установлен'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОЗакрытииФормы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		
		ОчиститьСообщения();
		
		Если ПроверитьЗаполнение() Тогда
			ЗаписатьИЗакрытьНаСервере();
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
