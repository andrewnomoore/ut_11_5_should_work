
#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСервера = СистемаАналитики.ПолучитьАдресСервераСистемыАналитики(); 
	ЗагрузитьДополнительныеИсточники();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтотОбъект И ИмяСобытия = "ЗагрузитьДополнительныйИсточник" Тогда
		ЗагрузитьДополнительныйИсточник(Параметр);
	КонецЕсли;

КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеИсточники

&НаКлиенте
Процедура ДополнительныеИсточникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	ФорматСервера = ПроверитьВерсиюФорматаДополнительныхИсточниковСервера();
	
	Отказ = Истина;
	Если Копирование Тогда 
		ПараметрыИсточника = Новый Структура();
		ПараметрыИсточника.Вставить("Имя", СоздатьИмяДополнительногоИсточника(Элемент.ТекущиеДанные.Name));
		ПараметрыИсточника.Вставить("Идентификатор", Элемент.ТекущиеДанные.Id);
		ПараметрыИсточника.Вставить("Копирование", Истина);
		ПараметрыИсточника.Вставить("ИдентификаторФормы", Строка(Новый УникальныйИдентификатор()));
		ПараметрыИсточника.Вставить("СуществующиеИмена", ИменаДополнительныхИсточников());
		ПараметрыИсточника.Вставить("ФорматСервера", ФорматСервера);
		
		ОткрытьФорму("Обработка.УправлениеПанелями1САналитики.Форма.ДополнительныйИсточник", ПараметрыИсточника, ЭтотОбъект, ПараметрыИсточника["ИдентификаторФормы"],,,,
		РежимОткрытияОкнаФормы.Независимый);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеИсточникиПередНачаломИзменения(Элемент, Отказ)
	
	ФорматСервера = ПроверитьВерсиюФорматаДополнительныхИсточниковСервера();
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Идентификатор", Элемент.ТекущиеДанные.Id);
	ПараметрыФормы.Вставить("ИдентификаторФормы", Элемент.ТекущиеДанные.Id);
	ПараметрыФормы.Вставить("СуществующиеИмена", ИменаДополнительныхИсточников(Элемент.ТекущиеДанные.Name));
	ПараметрыФормы.Вставить("ФорматСервера", ФорматСервера);
	
	ОткрытьФорму("Обработка.УправлениеПанелями1САналитики.Форма.ДополнительныйИсточник", ПараметрыФормы, ЭтотОбъект, ПараметрыФормы["ИдентификаторФормы"],,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеИсточникиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	Оповещение = Новый ОписаниеОповещения("ДополнительныеИсточникиПослеПодтвержденияУдаления", ЭтотОбъект, Элемент.ТекущиеДанные.Id);
	ПоказатьВопрос(Оповещение,
	СтрШаблон(НСтр("ru = 'Удалить ''%1''?'"), Элемент.ТекущиеДанные.Name),
	РежимДиалогаВопрос.ДаНет); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ДополнительныеИсточники

&НаКлиенте
Асинх Процедура ДополнительныеИсточникиЗагрузитьИзФайла(Команда)
	
	Диалог = Новый ПараметрыДиалогаПомещенияФайлов();
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Фильтр = НСтр("ru = 'Json-файл'") + " (*.json)|*.json";
	
	ОписаниеФайла = Ждать ПоместитьФайлНаСерверАсинх(, , , Диалог);
	
	Если ОписаниеФайла <> Неопределено Тогда
		Содержимое = СодержимоеВременногоФайла(ОписаниеФайла.Address);
		ИсточникиСтруктура = ДополнительныеИсточникиДляЗагрузки(Содержимое);
		
		Если ИсточникиСтруктура.СовпадающиеИменаМассив.Количество() Тогда
			ТекстВопроса = НСтр("ru = 'Дополнительные источники будут перезаписаны:'")
			+ Символы.ПС + СтрСоединить(ИсточникиСтруктура.СовпадающиеИменаМассив, Символы.ПС);
			
			Оповещение = Новый ОписаниеОповещения("ПослеПодтвержденияПерезаписиДополнительныхИсточников", ЭтотОбъект, ИсточникиСтруктура.ДополнительныеИсточникиМассив);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, 0, КодВозвратаДиалога.Отмена);
		Иначе
			ПослеПодтвержденияПерезаписиДополнительныхИсточников(КодВозвратаДиалога.ОК, ИсточникиСтруктура.ДополнительныеИсточникиМассив);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ДополнительныеИсточникиОбновитьСписок(Команда)
	
	ЗагрузитьДополнительныеИсточники();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеИсточникиСохранитьВсеВФайл(Команда)
	
	ПроверитьВерсиюФорматаДополнительныхИсточниковСервера();
	СохранитьДополнительныеИсточникиВФайл(); 
	
КонецПроцедуры  

&НаКлиенте
Процедура ДополнительныеИсточникиСохранитьВыбранныеВФайл(Команда)
	
	ПроверитьВерсиюФорматаДополнительныхИсточниковСервера();
	СохранитьДополнительныеИсточникиВФайл(Истина);
	
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьДополнительныйИсточник(Команда)
	
	ФорматСервера = ПроверитьВерсиюФорматаДополнительныхИсточниковСервера();
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Имя", СоздатьИмяДополнительногоИсточника());
	ПараметрыФормы.Вставить("ИдентификаторФормы", Строка(Новый УникальныйИдентификатор()));
	ПараметрыФормы.Вставить("СуществующиеИмена", ИменаДополнительныхИсточников());
	ПараметрыФормы.Вставить("ФорматСервера", ФорматСервера);
	
	ОткрытьФорму("Обработка.УправлениеПанелями1САналитики.Форма.ДополнительныйИсточник", ПараметрыФормы, ЭтотОбъект, ПараметрыФормы["ИдентификаторФормы"],,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДополнительныеИсточники

&НаСервере
Процедура ЗагрузитьДополнительныйИсточник(ИдентификаторИсточника = Неопределено)
	
	ЗагрузитьДополнительныеИсточники();
	Если ИдентификаторИсточника <> Неопределено Тогда
		Для Каждого Источник Из ДополнительныеИсточники Цикл
			Если Источник.Id = ИдентификаторИсточника Тогда
				Элементы.ДополнительныеИсточники.ТекущаяСтрока = Источник.ПолучитьИдентификатор();
				Прервать;
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДополнительныеИсточники()
	
	ДополнительныеИсточники.Очистить();
	
	Источники = Обработки.УправлениеПанелями1САналитики.ДополнительныеИсточникиИзСхемы();
	
	Для Каждого Источник Из Источники Цикл
		НоваяСтрока = ДополнительныеИсточники.Добавить();
		НоваяСтрока.id = Источник.Получить("id");
		Попытка
			ИсточникData = JSONВЗначение(Источник.Получить("data"));
		Исключение
			ИсточникData = Новый Соответствие();
		КонецПопытки;
		НоваяСтрока.Name = НеопределеноВПустуюСтроку(ИсточникData.Получить("name"));
		НоваяСтрока.Presentation = НеопределеноВПустуюСтроку(ИсточникData.Получить("synonym"));
		НоваяСтрока.Data = Источник.Получить("data");
		НоваяСтрока.Version = Источник.Получить("version");
	КонецЦикла;
	ДополнительныеИсточники.Сортировать("Name");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НеопределеноВПустуюСтроку(Значение) 
	
	Возврат ?(Значение = Неопределено, "", Значение); 
	
КонецФункции

&НаКлиенте
Функция ИменаДополнительныхИсточников(ТекущееИмя = "")
	
	Имена = Новый СписокЗначений();
	Для Каждого Строка Из ДополнительныеИсточники Цикл
		Если Строка.Name = ТекущееИмя Тогда
			Продолжить;
		КонецЕсли;
		Имена.Добавить(Строка.Name);
	КонецЦикла;
	Возврат Имена;
	
КонецФункции

&НаКлиенте
Процедура ДополнительныеИсточникиПослеПодтвержденияУдаления(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьДополнительныйИсточник(Параметры);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДополнительныйИсточник(ИдентификаторИсточника)
	
	Обработки.УправлениеПанелями1САналитики.УдалитьСхему(ИдентификаторИсточника);
	
	ЗагрузитьДополнительныеИсточники();
	
КонецПроцедуры

&НаКлиенте
Функция СоздатьИмяДополнительногоИсточника(Знач Префикс = Неопределено)
	
	Если Префикс <> Неопределено Тогда
		Пока СтрДлина(Префикс) > 0 Цикл
			Если КодСимвола(Префикс, СтрДлина(Префикс)) >= 48 И КодСимвола(Префикс, СтрДлина(Префикс)) <= 57 Тогда  
				Префикс = Лев(Префикс, СтрДлина(Префикс)-1);
			Иначе
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если СтрДлина(Префикс) = 0 Тогда
			Префикс = Неопределено;
		КонецЕсли;
	КонецЕсли;
	Если Префикс = Неопределено Тогда
		Префикс = НСтр("ru = 'Источник'");
	КонецЕсли;
	Инд = 0;
	Для Каждого Строка Из ДополнительныеИсточники Цикл
		Если СтрНачинаетсяС(Строка.Name, Префикс) Тогда
			Попытка
				ТекИнд = Number(Mid(Строка.Name, СтрДлина(Префикс)+1));
			Исключение
				ТекИнд = 0;
			КонецПопытки;
			Если ТекИнд > Инд Тогда
				Инд = ТекИнд;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Префикс + Формат(Инд+1, "NG=");
	
КонецФункции

&НаСервере
Функция ПроверитьВерсиюФорматаДополнительныхИсточниковСервера()
	
	ФорматСервера = ВерсияФорматаСервера("additional-datasource");
	Если ФорматСервера = -1 Тогда 
		ВызватьИсключение НСтр("ru = 'Не удалось определить версию формата дополнительных источников, поддерживаемую сервером 1С:Аналитики. Проверьте адрес и доступность сервера.'");
	ИначеЕсли ФорматСервера > 2 Тогда 
		ВызватьИсключение НСтр("ru = 'Версия формата дополнительных источников сервера 1C:Аналитики выше версии, поддерживаемой обработкой. Обновите платформу 1С:Предприятие'");
	КонецЕсли;
	Возврат ФорматСервера;
	
КонецФункции

&НаКлиенте
Асинх Процедура СохранитьДополнительныеИсточникиВФайл(ТолькоВыбранные = Ложь)
	
	Данные = ДополнительныеИсточникиJSON(ТолькоВыбранные);
	Адрес = ПоместитьВоВременноеХранилище(Данные); 
	
	Заголовок = НСтр("ru = 'Сохранение файла дополнительных источников'");
	ДиалогПолученияФайлов = Новый ПараметрыДиалогаПолученияФайлов(Заголовок, Ложь);
	
	Ждать ПолучитьФайлССервераАсинх(Адрес, "additional_datasources.json", ДиалогПолученияФайлов);
	
КонецПроцедуры

&НаСервере
Функция ДополнительныеИсточникиJSON(ТолькоВыбранные)
	
	Если ТолькоВыбранные Тогда
		ВыбранныеИсточники = Новый Массив();
		ВыбранныеСтрокиИд = Элементы.ДополнительныеИсточники.ВыделенныеСтроки;
		Для Каждого Ид Из ВыбранныеСтрокиИд Цикл
			ВыбранныеИсточники.Добавить(ДополнительныеИсточники.FindByID(Ид));
		КонецЦикла;
	Иначе
		ВыбранныеИсточники = ДополнительныеИсточники;
	КонецЕсли;
	
	ИсточникиМассив = Новый Массив();
	
	Для Каждого Строка Из ВыбранныеИсточники Цикл
		Элемент = Новый Соответствие();
		Элемент.Вставить("type", "additional-datasource");
		Элемент.Вставить("id", Строка.Id);
		Элемент.Вставить("data", Строка.Data);
		Элемент.Вставить("owner", "");
		Если Строка.Version >= 2 Тогда
			Элемент.Вставить("version", Строка.Version);
		КонецЕсли;
		
		ИсточникиМассив.Добавить(Элемент);
	КонецЦикла;
	
	Возврат ЗначениеВJSON(ИсточникиМассив);
	
КонецФункции

&НаСервереБезКонтекста
Функция СодержимоеВременногоФайла(Адрес)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Данные = ПолучитьИзВременногоХранилища(Адрес); //ДвоичныеДанные
	Данные.Записать(ИмяВременногоФайла);
	
	НовыйТекстовыйДокумент = Новый ТекстовыйДокумент();
	НовыйТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
	Содержимое = НовыйТекстовыйДокумент.ПолучитьТекст();
	
	УдалитьИзВременногоХранилища(Адрес);
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат Содержимое;
	
КонецФункции

&НаСервере
Функция ДополнительныеИсточникиДляЗагрузки(Содержимое)
	
	ФорматСервера = ВерсияФорматаСервера("additional-datasource");
	Если ФорматСервера = -1 Тогда 
		ВызватьИсключение НСтр("ru = 'Не удалось определить версию формата дополнительных источников, поддерживаемую сервером 1С:Аналитики. Проверьте адрес и доступность сервера.'");
	КонецЕсли;
	
	Результат = Новый Структура("ДополнительныеИсточникиМассив, СовпадающиеИменаМассив", Новый Массив(), Новый Массив());
	
	ЗагрузитьДополнительныеИсточники();
	
	ИсточникиМассив = JSONВЗначение(Содержимое);
	
	Для Каждого Источник Из ИсточникиМассив Цикл
		ИсточникType = Источник.Получить("type");
		ФорматИсточника = Источник.Получить("version");
		Если ФорматИсточника = Неопределено Тогда
			ФорматИсточника = 1;
		КонецЕсли;
		
		ИсточникId = Источник.Получить("id");
		
		Если ИсточникType <> "additional-datasource" Тогда
			ВызватьИсключение НСтр("ru = 'Выбранный файл не является файлом данных дополнительных источников'");
		КонецЕсли;
		
		Если ФорматИсточника = 2 И ФорматСервера < 2 Тогда
			ВызватьИсключение НСтр("ru = 'Версия формата дополнительных источников в файле выше версии, поддерживаемой сервером 1С:Аналитики. Обновите версию сервера 1С:Аналитики.'");
		КонецЕсли;
		
		Если ФорматИсточника > 2 Тогда
			ВызватьИсключение НСтр("ru = 'Версия формата дополнительных источников файла выше версии, поддерживаемой обработкой. Обновите платформу 1С:Предприятие.'");
		КонецЕсли;
		
		ДополнительныйИсточник = Новый Соответствие();
		ДополнительныйИсточник.Вставить("type", ИсточникType);
		ДополнительныйИсточник.Вставить("data", Источник.Получить("data"));
		ДополнительныйИсточник.Вставить("owner", "");
		ДополнительныйИсточник.Вставить("id", ИсточникId);
		Если ФорматИсточника <> 1 Тогда 
			ДополнительныйИсточник.Вставить("version", ФорматИсточника);
		КонецЕсли;
		
		Попытка
			ИсточникData = JSONВЗначение(Источник.Получить("data"));
		Исключение
			ИсточникData = Новый Соответствие();
		КонецПопытки;
		
		ИсточникName = НеопределеноВПустуюСтроку(ИсточникData.Получить("name"));
		
		ИмяСуществует = Ложь;
		Для Каждого Строка Из ДополнительныеИсточники Цикл
			Если Строка.Name = ИсточникName Тогда
				Результат.СовпадающиеИменаМассив.Добавить(ИсточникName);
				ДополнительныйИсточник.Вставить("id", Строка.Id);
				ИмяСуществует = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ИмяСуществует Тогда
			Для Каждого Строка Из ДополнительныеИсточники Цикл
				Если Строка.Id = ИсточникId Тогда
					ДополнительныйИсточник.Вставить("id", Строка(Новый УникальныйИдентификатор()));
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Результат.ДополнительныеИсточникиМассив.Добавить(ДополнительныйИсточник);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПослеПодтвержденияПерезаписиДополнительныхИсточников(Результат, ДополнительныеИсточникиМассив) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ЗаписатьДополнительныеИсточники(ДополнительныеИсточникиМассив);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДополнительныеИсточники(ДополнительныеИсточникиМассив)
	
	Для Каждого Источник Из ДополнительныеИсточникиМассив Цикл
		ИсточникJSON = ЗначениеВJSON(Источник);
		Обработки.УправлениеПанелями1САналитики.ЗаписатьСхему(ИсточникJSON);
	КонецЦикла;
	
	ЗагрузитьДополнительныеИсточники();
	
КонецПроцедуры

&НаСервере
Функция ВерсияФорматаСервера(ТипОбъекта)
	
	Возврат Обработки.УправлениеПанелями1САналитики.ВерсииФорматовСервера(АдресСервера).Получить(ТипОбъекта);
	
КонецФункции

#КонецОбласти

&НаСервереБезКонтекста
Функция JSONВЗначение(СтрокаJSON)
	
	Если СтрокаJSON = "" Тогда
		Возврат Новый Массив();
	КонецЕсли;
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Возврат ПрочитатьJSON(ЧтениеJSON, Истина);
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеВJSON(Значение)
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписатьJSON(ЗаписьJSON, Значение);
	
	Возврат ЗаписьJSON.Закрыть(); 
	
КонецФункции 

#КонецОбласти
