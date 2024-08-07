#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыбранныйЭлемент = Неопределено;
	Параметры.Свойство("ВыбранныйЭлемент", ВыбранныйЭлемент);
	
	Если Параметры.СписокЗначенийДляВыбора <> Неопределено
			И Параметры.СписокЗначенийДляВыбора.Количество() > 0 Тогда
		
		ЭлементыДерева = Дерево.ПолучитьЭлементы();
		Для Каждого Элемент Из Параметры.СписокЗначенийДляВыбора Цикл
			НоваяСтрока = ЭлементыДерева.Добавить();
			НоваяСтрока.Наименование = Элемент.Значение.Name;
			НоваяСтрока.ID = Элемент.Значение.ID;
			НоваяСтрока.Тип = Элемент.Значение.Type;
			НоваяСтрока.Картинка = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексКартинкиЭлементаСправочника();
		КонецЦикла;
		
		Элементы.ФормаНайти.Видимость = Ложь;
		Элементы.ФормаОтменитьПоиск.Видимость = Ложь;
		Элементы.ДеревоКонтекстноеМенюНайти.Видимость = Ложь;
		Элементы.ДеревоКонтекстноеМенюОтменитьПоиск.Видимость = Ложь;
		
	Иначе
		
		ТипОбъектаВыбора = Параметры.ТипОбъектаВыбора;
		Отбор = Параметры.Отбор;
		
		ЗаполнитьДеревоПапок(Дерево.ПолучитьЭлементы(), , , ВыбранныйЭлемент); // Корневые папки.
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Элементы.ФормаСоздатьПапкуВнутреннихДокументов.Видимость = (ТипОбъектаВыбора = "DMInternalDocumentFolder");
	
	ВыборГрупп = Параметры.ВыборГрупп;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Дерево.НайтиПоИдентификатору(Значение);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоГруппа И Не ВыборГрупп Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите элемент, а не группу.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("РеквизитID",  ТекущиеДанные.ID);
	Результат.Вставить("РеквизитТип", ТекущиеДанные.Тип);
	Результат.Вставить("РеквизитПредставление", ТекущиеДанные.Наименование);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = Дерево.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.ID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиВыполнить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("НайтиВыполнитьЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ПоискВСписке",,,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыполнитьЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ЗаполнитьДеревоПапокОтКорня(, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПоиск(Команда)
	
	// Отменяем режим поиска.
	ЗаполнитьДеревоПапокОтКорня(""); // Корневые папки.
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоГруппа И Не ВыборГрупп Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите элемент, а не группу.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("РеквизитID",  ТекущиеДанные.ID);
	Результат.Вставить("РеквизитТип", ТекущиеДанные.Тип);
	Результат.Вставить("РеквизитПредставление", ТекущиеДанные.Наименование);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПапкуВнутреннихДокументов(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ПараметрыФормы.Вставить("РодительID",  ТекущиеДанные.ID);
		ПараметрыФормы.Вставить("РодительТип", ТекущиеДанные.Тип);
		ПараметрыФормы.Вставить("Родитель", ТекущиеДанные.Наименование);
	КонецЕсли;
	
	ИмяФормыПапкаВнутреннихДокументов = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ПапкаВнутреннихДокументов";
	ОткрытьФорму(
		ИмяФормыПапкаВнутреннихДокументов,
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("СоздатьЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПапок(ВеткаДерева, ИдентификаторПапки = "", СтрокаПоиска = Неопределено,
		ВыбранныйЭлемент = Неопределено)
	
	ВеткаДерева.Очистить();
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Условия = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	СписокУсловийОтбора = Условия.conditions; // СписокXDTO
	
	Если ЗначениеЗаполнено(ИдентификаторПапки) Тогда
		
		РодительИд = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ИдентификаторПапки,
			ТипОбъектаВыбора);
		
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Parent";
		Условие.value = РодительИд;
		Если Условие.Свойства().Получить("comparisonOperator") <> Неопределено Тогда
			Условие.comparisonOperator = "=";
		КонецЕсли;
		
		СписокУсловийОтбора.Добавить(Условие);
		
	КонецЕсли;
	
	Если СтрокаПоиска <> Неопределено Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Name";
		Условие.value = СтрокаПоиска;
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "SelectedItem"; // Имеет смысл только для иерархического справочника.
		РодительИд = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ВыбранныйЭлемент,
			ТипОбъектаВыбора);
		Условие.value = РодительИд;
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда
		Для Каждого СтрокаОтбора Из Отбор Цикл
			Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
			Условие.property = СтрокаОтбора.Ключ;
			
			Если ТипЗнч(СтрокаОтбора.Значение) = Тип("Структура") Тогда
				Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
					Прокси,
					СтрокаОтбора.Значение.ID,
					СтрокаОтбора.Значение.type);
			Иначе
				Условие.value = СтрокаОтбора.Значение;
			КонецЕсли;
			
			СписокУсловийОтбора.Добавить(Условие);
		КонецЦикла;
	КонецЕсли;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		ТипОбъектаВыбора,
		Условия);
	
	Если Не ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		
		Для Каждого Элемент Из Результат.items Цикл
			Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(Элемент, "parentID") Тогда
				ИдентификаторРодителяЭлемента = Элемент.parentID.ID;
			Иначе
				ИдентификаторРодителяЭлемента = "";
			КонецЕсли;
			Если ИдентификаторПапки = ИдентификаторРодителяЭлемента
				Или ЗначениеЗаполнено(СтрокаПоиска) Тогда
				НоваяСтрока = ВеткаДерева.Добавить();
				ЗаполнитьЭлементДерева(НоваяСтрока, Элемент, СтрокаПоиска);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		// Заполним дерево - для каждого уровня нужные элементы вставим и восстановим текущую строку.
		ЕстьДочерниеЭлементы = Ложь;
		ИдентификаторВеткиВыбранногоЭлемента = Неопределено;
		ЗаполнитьУровеньДерева(
			ВеткаДерева,
			"", // "" - корень.
			Результат.items,
			СтрокаПоиска,
			ЕстьДочерниеЭлементы,
			ВыбранныйЭлемент,
			ИдентификаторВеткиВыбранногоЭлемента);
		
		Если ИдентификаторВеткиВыбранногоЭлемента <> Неопределено Тогда
			Элементы.Дерево.ТекущаяСтрока = ИдентификаторВеткиВыбранногоЭлемента;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУровеньДерева(ВеткаДерева, ИдентификаторРодителя, ЭлементыXDTO, СтрокаПоиска, ЕстьДочерниеЭлементы,
		ВыбранныйЭлемент, ИдентификаторВеткиВыбранногоЭлемента)
	
	ЕстьДочерниеЭлементы = Ложь;
	
	Для Каждого Элемент Из ЭлементыXDTO Цикл
		
		Если (Элемент.parentID <> Неопределено И Элемент.parentID.ID = ИдентификаторРодителя)
				Или (Элемент.parentID = Неопределено И ИдентификаторРодителя = "") Тогда
			
			НоваяСтрока = ВеткаДерева.Добавить();
			ЗаполнитьЭлементДерева(НоваяСтрока, Элемент, СтрокаПоиска, Ложь);
			ЕстьДочерниеЭлементы = Истина;
			
			Если НоваяСтрока.ID = ВыбранныйЭлемент Тогда
				ИдентификаторВеткиВыбранногоЭлемента = НоваяСтрока.ПолучитьИдентификатор();
			КонецЕсли;
			
			ЕстьДочерниеЭлементыВПодчиненнойВетке = Ложь;
			ЗаполнитьУровеньДерева(
				НоваяСтрока.ПолучитьЭлементы(),
				Элемент.object.objectID.ID,
				ЭлементыXDTO,
				СтрокаПоиска,
				ЕстьДочерниеЭлементыВПодчиненнойВетке,
				ВыбранныйЭлемент,
				ИдентификаторВеткиВыбранногоЭлемента);
			
			Если ЕстьДочерниеЭлементыВПодчиненнойВетке Тогда
				НоваяСтрока.ПодпапкиСчитаны = Истина;
			Иначе
				Если Элемент.canHaveChildren И (СтрокаПоиска = Неопределено) Тогда
					НоваяСтрока.ПодпапкиСчитаны = Ложь;
					НоваяСтрока.ПолучитьЭлементы().Добавить(); // Чтобы появился плюсик.
				Иначе
					НоваяСтрока.ПодпапкиСчитаны = Истина;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементДерева(НоваяСтрока, Элемент, СтрокаПоиска, СоздаватьФиктивныйЛист = Истина)
	
	НоваяСтрока.Наименование = Элемент.object.name;
	НоваяСтрока.ID = Элемент.object.objectID.ID;
	НоваяСтрока.Тип = Элемент.object.objectID.type;
	НоваяСтрока.ЭтоГруппа = Элемент.isFolder;
	
	Если ТипОбъектаВыбора = "DMFileFolder" Или ТипОбъектаВыбора = "DMInternalDocumentFolder" Тогда
		НоваяСтрока.Картинка = 0;
	Иначе
		Если Элемент.isFolder Тогда
			НоваяСтрока.Картинка = 0;
		Иначе
			НоваяСтрока.Картинка = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексКартинкиЭлементаСправочника();
		КонецЕсли;
	КонецЕсли;
	
	Если СоздаватьФиктивныйЛист Тогда
		Если Элемент.canHaveChildren И (СтрокаПоиска = Неопределено) Тогда
			НоваяСтрока.ПодпапкиСчитаны = Ложь;
			НоваяСтрока.ПолучитьЭлементы().Добавить(); // Чтобы появился плюсик.
		Иначе
			НоваяСтрока.ПодпапкиСчитаны = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = Дерево.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПапок(Лист.ПолучитьЭлементы(), Лист.ID);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокОтКорня(ИдентификаторПапки = Неопределено, СтрокаПоиска = Неопределено)
	
	ЗаполнитьДеревоПапок(Дерево.ПолучитьЭлементы(), ИдентификаторПапки, СтрокаПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ОбновитьДеревоИАктивизировать(Результат.ID);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоИАктивизировать(ВыбранныйЭлемент)
	
	ЗаполнитьДеревоПапок(Дерево.ПолучитьЭлементы(),,, ВыбранныйЭлемент);
	
КонецПроцедуры

#КонецОбласти
