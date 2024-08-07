
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияБЭД.СброситьРазмерыИПоложениеОкна(ЭтаФорма);
	
	КонтекстДиагностики = Неопределено;
	Если Не Параметры.Свойство("КонтекстДиагностики", КонтекстДиагностики) Тогда
		Возврат; 
	КонецЕсли;
	
	КэшЭлементовФормы = Новый Структура;
	КэшЭлементовФормы.Вставить("Значения", Новый Соответствие);
	Параметры.Свойство("ВозможенПовторДействия", ВозможенПовторДействия);
	
	Если КонтекстДиагностики.ЗаголовокОперации = "" Тогда
		Заголовок = НСтр("ru = 'При выполнении операции произошли ошибки:'");
	Иначе 
		Заголовок = КонтекстДиагностики.ЗаголовокОперации + " " + НСтр("ru = 'произошли ошибки:'");
	КонецЕсли;
	
	КонтекстДиагностики.ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ОбщегоНазначения.СообщитьПользователю(Заголовок, , , , Отказ);
		Для каждого Ошибка Из ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики) Цикл
			ОбработкаНеисправностейБЭД.ОбработатьОшибку(
				Заголовок, Ошибка.Подсистема,
				Ошибка.ПодробноеПредставлениеОшибки, Ошибка.КраткоеПредставлениеОшибки);
		КонецЦикла;
	Иначе
		ВывестиОшибки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ОбработкаНеисправностейБЭДКлиент.ИмяСобытияИсправлениеОшибок() Тогда
		
		Если ТипЗнч(Параметр) = Тип("Массив") И Параметр.Количество() > 0 И ТипЗнч(Параметр[0]) = Тип("Структура")
			И Параметр[0].Свойство("ЭтоВидОшибки") Тогда // переданы виды ошибок
			ВидыОшибок = Параметр;
			ИдентификаторыВидовОшибок = Новый Соответствие;
			Для Каждого ВидОшибки Из ВидыОшибок Цикл
				ИдентификаторыВидовОшибок.Вставить(ВидОшибки.Идентификатор, Истина);
			КонецЦикла;
			Для Сч = - (Ошибки.Количество() - 1) По 0 Цикл 
				Если ИдентификаторыВидовОшибок.Получить(Ошибки[-Сч].ИдентификаторВидаОшибки) = Истина Тогда
					Ошибки.Удалить(-Сч);
				КонецЕсли;
			КонецЦикла;
			УникальныеИдентификаторыВидовОшибок = Новый Массив;
			Для каждого ИдентификаторВидаОшибки Из ИдентификаторыВидовОшибок Цикл
				УникальныеИдентификаторыВидовОшибок.Добавить(ИдентификаторВидаОшибки.Ключ);
			КонецЦикла;
			Отбор = Новый Соответствие;
			Отбор.Вставить("ВидОшибки.Идентификатор", УникальныеИдентификаторыВидовОшибок);
			ОбработкаНеисправностейБЭДКлиент.УдалитьОшибки(КонтекстДиагностики, Отбор);
		ИначеЕсли ТипЗнч(Параметр) = Тип("Структура") Или ТипЗнч(Параметр) = Тип("Соответствие") Тогда // передан отбор
			ВидыОшибок = Новый Массив;
			Отбор = Параметр;
			Для Сч = - (Ошибки.Количество() - 1) По 0 Цикл 
				Если ОбработкаНеисправностейБЭДКлиентСервер.ОшибкаСоответствуетОтбору(Ошибки[-Сч].Ошибка, Отбор) Тогда
					ВидыОшибок.Добавить(Ошибки[-Сч].ВидОшибки);
					Ошибки.Удалить(-Сч);
				КонецЕсли;
			КонецЦикла;
			ОбработкаНеисправностейБЭДКлиент.УдалитьОшибки(КонтекстДиагностики, Отбор);
		Иначе // передан массив ошибок
			ИдентификаторыОшибок = Новый Массив;
			ИдентификаторыВидовОшибок = Новый Соответствие;
			ВидыОшибок = Новый Массив;
			Для каждого Ошибка Из Параметр Цикл
				ИдентификаторыОшибок.Добавить(Ошибка.Идентификатор);
				СтрокиТЗ = Ошибки.НайтиСтроки(Новый Структура("Идентификатор", Ошибка.Идентификатор)); 
				Если СтрокиТЗ.Количество() Тогда
					Ошибки.Удалить(СтрокиТЗ[0]);
				КонецЕсли;
				Если ИдентификаторыВидовОшибок[Ошибка.ВидОшибки.Идентификатор] = Неопределено Тогда
					ВидыОшибок.Добавить(Ошибка.ВидОшибки);
				КонецЕсли;
				ИдентификаторыВидовОшибок.Вставить(Ошибка.ВидОшибки.Идентификатор, Истина);
			КонецЦикла;
			ОбработкаНеисправностейБЭДКлиент.УдалитьОшибки(КонтекстДиагностики, Новый Структура("Идентификатор", ИдентификаторыОшибок));
		КонецЕсли;
		
		Для каждого ВидОшибки Из ВидыОшибок Цикл
			ОшибкаЕстьНаФорме = Элементы.Найти(ИмяЭлементаКартинкаОшибки(ВидОшибки.Идентификатор)) <> Неопределено;
			Если Не ОшибкаЕстьНаФорме Тогда // Получено оповещение об исправлении ошибки, которая не была выведена на форму.
				Продолжить;
			КонецЕсли;
			ОбновитьЭлементыФормыРешения(ВидОшибки);
		КонецЦикла;
		Если ВозможенПовторДействия И Ошибки.Количество() = 0 Тогда
			Элементы.ПовторитьОперацию.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПовторитьОперацию(Команда)
	
	Закрыть(ОбработкаНеисправностейБЭДКлиент.ДействиеПовторитьДействие());
	
КонецПроцедуры

&НаКлиенте
Процедура Техподдержка(Команда)
	ИнтерфейсДокументовЭДОКлиент.ОткрытьОбращениеВСлужбуТехническойПоддержки();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВывестиОшибки()
	
	Сч = 0;
	ОбработанныеВидыОшибок = Новый Соответствие;
	Для каждого Ошибка Из ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики) Цикл
		ИдентификаторВидаОшибки = Ошибка.ВидОшибки.Идентификатор;
		ВидОшибки = Ошибка.ВидОшибки;
		НоваяСтрока = Ошибки.Добавить();
		НоваяСтрока.Ошибка = Ошибка;
		НоваяСтрока.Идентификатор = Ошибка.Идентификатор;
		НоваяСтрока.ИдентификаторВидаОшибки = ИдентификаторВидаОшибки;
		НоваяСтрока.ВидОшибки = ВидОшибки;
		
		СвойстваОшибокВидаДиагностики = ОбработанныеВидыОшибок.Получить(ИдентификаторВидаОшибки);
		Если СвойстваОшибокВидаДиагностики = Неопределено Тогда
			СвойстваОшибок = Новый Структура;
			СвойстваОшибок.Вставить("Количество", 1);
			СвойстваОшибок.Вставить("ВидОшибки", Ошибка.ВидОшибки);
			ОбработанныеВидыОшибок.Вставить(ИдентификаторВидаОшибки, СвойстваОшибок);
		Иначе 
			СвойстваОшибокВидаДиагностики.Количество = СвойстваОшибокВидаДиагностики.Количество + 1;
			Продолжить;
		КонецЕсли;
		ГруппаОшибка = Элементы.Добавить(ИдентификаторВидаОшибки + "_ГруппаОшибка", Тип("ГруппаФормы"), Элементы.ГруппаОшибки);
		ГруппаОшибка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаОшибка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		ГруппаОшибка.Объединенная = Ложь;
		ГруппаОшибка.ОтображатьЗаголовок = Ложь;
		Если Сч%2 <> 0 Тогда
			ГруппаОшибка.ЦветФона = ЦветаСтиля.ЦветФонаЧередованияСтрокиБЭД;
		КонецЕсли;
		
		ЭлементыКолонки = СоздатьКолонкуТаблицыОшибок(ГруппаОшибка, ВидОшибки, Истина);
		Если ВидОшибки.Статус = ОбработкаНеисправностейБЭДКлиентСервер.СтатусыОшибок().Обычная Тогда
			КартинкаОшибки = БиблиотекаКартинок.ЖелтыйШарБЭД;
		ИначеЕсли ВидОшибки.Статус = ОбработкаНеисправностейБЭДКлиентСервер.СтатусыОшибок().Важная Тогда
			КартинкаОшибки = БиблиотекаКартинок.КрасныйШарБЭД;
		Иначе
			КартинкаОшибки = БиблиотекаКартинок.КрасныйШарБЭД;
		КонецЕсли;
		ЭлементыКолонки.ДекорацияКартинка.Картинка = КартинкаОшибки;
		ЭлементыКолонки.ДекорацияОписание.Заголовок = ВидОшибки.ЗаголовокПроблемы;
		ЭлементыКолонки.ДекорацияПояснение.Заголовок = ВидОшибки.ОписаниеПроблемы;
		Если Не ЗначениеЗаполнено(ВидОшибки.ОписаниеПроблемы) Тогда
			ЭлементыКолонки.ДекорацияПояснение.Видимость = Ложь;
		КонецЕсли;
		
		Если ВидОшибки.ВыводитьСсылкуНаСписокОшибок Тогда
			ДекорацияСписокОшибок = Элементы.Добавить(ИдентификаторВидаОшибки + "_ДекорацияСписокОшибок", Тип("ДекорацияФормы"), ЭлементыКолонки.ГруппаОписание);
			ДекорацияСписокОшибок.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'См. <a href = ""ОбработкаНеисправностейБЭДОткрытьСписокОшибок"">список ошибок</a>'"));
			ДекорацияСписокОшибок.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОбработкаНавигационнойСсылки");
			КэшЭлементовФормы.Значения.Вставить(ДекорацияСписокОшибок.Имя, ВидОшибки);
		КонецЕсли;
	
		ЭлементыКолонки = СоздатьКолонкуТаблицыОшибок(ГруппаОшибка, ВидОшибки, Ложь);
		ЭлементыКолонки.ДекорацияКартинка.Картинка = БиблиотекаКартинок.Информация;
		ЭлементыКолонки.ДекорацияОписание.Заголовок = НСтр("ru = 'Решение'");
		Если ТипЗнч(ВидОшибки.ОписаниеРешения) = Тип("Строка") Тогда
			ОписаниеРешения = СтроковыеФункции.ФорматированнаяСтрока(ВидОшибки.ОписаниеРешения);
		Иначе
			ОписаниеРешения = ВидОшибки.ОписаниеРешения;
		КонецЕсли;
		ЭлементыКолонки.ДекорацияПояснение.Заголовок = ОписаниеРешения;
		
		Сч = Сч + 1;
	КонецЦикла;
	
	Для каждого КлючИЗначение Из ОбработанныеВидыОшибок Цикл
		ВидОшибки = КлючИЗначение.Значение.ВидОшибки;
		УстановитьЗаголовокОписаниеОшибки(ЭтаФорма, ВидОшибки, КлючИЗначение.Ключ,
			КлючИЗначение.Значение.Количество);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СоздатьКолонкуТаблицыОшибок(Родитель, ВидОшибки, ЭтоКолонкаОшибка)
	
	ИдентификаторВидаОшибки = ВидОшибки.Идентификатор;
	Если ЭтоКолонкаОшибка Тогда
		ПостфиксИмениЭлементов = "Ошибка";
		ИмяЭлементаДекорацияОписание = ИмяЭлементаОписаниеОшибки(ИдентификаторВидаОшибки);
		ИмяЭлементаДекорацияПояснение = ИмяЭлементаПояснениеОшибки(ИдентификаторВидаОшибки);
		ИмяЭлементаДекорацияКартинка = ИмяЭлементаКартинкаОшибки(ИдентификаторВидаОшибки);
	Иначе 
		ИмяЭлементаДекорацияОписание = ИмяЭлементаОписаниеРешения(ИдентификаторВидаОшибки);
		ИмяЭлементаДекорацияПояснение = ИмяЭлементаПояснениеРешения(ИдентификаторВидаОшибки);
		ИмяЭлементаДекорацияКартинка = ИдентификаторВидаОшибки + "_ДекорацияКартинкаРешение";
		ПостфиксИмениЭлементов = "Решение";
	КонецЕсли;
	
	ЭлементыКолонки = Новый Структура;
	
	ГруппаОписание = Элементы.Добавить(ИдентификаторВидаОшибки + "_ГруппаОписание" + ПостфиксИмениЭлементов, Тип("ГруппаФормы"), Родитель);
	ГруппаОписание.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаОписание.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаОписание.Объединенная = Истина;
	ГруппаОписание.ОтображатьЗаголовок = Ложь;
	ЭлементыКолонки.Вставить("ГруппаОписание", ГруппаОписание);
	
	ГруппаЗаголовок = Элементы.Добавить(ИдентификаторВидаОшибки + "_ГруппаЗаголовок" + ПостфиксИмениЭлементов, Тип("ГруппаФормы"), ГруппаОписание);
	ГруппаЗаголовок.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЗаголовок.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаЗаголовок.ОтображатьЗаголовок = Ложь;
	
	ДекорацияКартинка = Элементы.Добавить(ИмяЭлементаДекорацияКартинка, Тип("ДекорацияФормы"), ГруппаЗаголовок);
	ДекорацияКартинка.Вид = ВидДекорацииФормы.Картинка;
	ЭлементыКолонки.Вставить("ДекорацияКартинка", ДекорацияКартинка);
	
	ДекорацияОписание = Элементы.Добавить(ИмяЭлементаДекорацияОписание, Тип("ДекорацияФормы"), ГруппаЗаголовок);
	ДекорацияОписание.Шрифт = ШрифтыСтиля.УвеличенныйПолужирныйШрифтБЭД;
	ДекорацияОписание.АвтоМаксимальнаяШирина = Ложь;
	ЭлементыКолонки.Вставить("ДекорацияОписание", ДекорацияОписание);
	
	ДекорацияПояснение = Элементы.Добавить(ИмяЭлементаДекорацияПояснение, Тип("ДекорацияФормы"), ГруппаОписание);
	ДекорацияПояснение.АвтоМаксимальнаяШирина = Ложь;
	ДекорацияПояснение.РастягиватьПоГоризонтали = Истина;
	ДекорацияПояснение.МаксимальнаяШирина = 70;
	ДекорацияПояснение.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОбработкаНавигационнойСсылки");
	КэшЭлементовФормы.Значения.Вставить(ДекорацияПояснение.Имя, ВидОшибки);
	ЭлементыКолонки.Вставить("ДекорацияПояснение", ДекорацияПояснение);
	
	Возврат ЭлементыКолонки;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ВидОшибки = КэшЭлементовФормы.Значения[Элемент.Имя];
	Если ВидОшибки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = ВидОшибки.ОбработчикиНажатия.Получить(НавигационнаяСсылкаФорматированнойСтроки);
	Если Обработчик <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОбработчика = ВидОшибки.ПараметрыОбработчиков.Получить(НавигационнаяСсылкаФорматированнойСтроки);
		ОбработкаНеисправностейБЭДКлиент.ВыполнитьОбработчикВидаОшибки(ВидОшибки, Обработчик, КонтекстДиагностики, ПараметрыОбработчика);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлементыФормыРешения(ВидОшибки) 
	
	КоличествоОшибок = Ошибки.НайтиСтроки(Новый Структура("ИдентификаторВидаОшибки", ВидОшибки.Идентификатор)).Количество();
	Если КоличествоОшибок = 0 Тогда
		Элементы[ИмяЭлементаКартинкаОшибки(ВидОшибки.Идентификатор)].Картинка = БиблиотекаКартинок.ЗеленыйШарБЭД;
		Элементы[ИмяЭлементаПояснениеРешения(ВидОшибки.Идентификатор)].Заголовок = НСтр("ru = 'Не требуется'");
		Элементы[ИмяЭлементаПояснениеОшибки(ВидОшибки.Идентификатор)].Заголовок = НСтр("ru = 'Проблемы устранены'");
	КонецЕсли;
	УстановитьЗаголовокОписаниеОшибки(ЭтаФорма, ВидОшибки, ВидОшибки.Идентификатор, КоличествоОшибок);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаКартинкаОшибки(ИдентификаторВидаОшибки) 
	
	Возврат ИдентификаторВидаОшибки + "_ДекорацияКартинкаОшибка";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаПояснениеРешения(ИдентификаторВидаОшибки) 
	
	Возврат ИдентификаторВидаОшибки + "_ДекорацияПояснениеРешения";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаПояснениеОшибки(ИдентификаторВидаОшибки) 
	
	Возврат ИдентификаторВидаОшибки + "_ДекорацияПояснениеОшибки";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаОписаниеОшибки(ВидОшибки) 
	
	Возврат ВидОшибки + "_ДекорацияОписаниеОшибки";
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаОписаниеРешения(ИдентификаторВидаОшибки) 
	
	Возврат ИдентификаторВидаОшибки + "_ДекорацияОписаниеРешения";
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокОписаниеОшибки(Форма, ВидОшибки, ИдентификаторВидаОшибки, КоличествоОшибок = Неопределено)
	
	Если КоличествоОшибок = Неопределено Тогда
		КоличествоОшибок = Форма.Ошибки.НайтиСтроки(Новый Структура("ИдентификаторВидаОшибки", ИдентификаторВидаОшибки)).Количество();
	КонецЕсли;
	Если КоличествоОшибок > 1 Тогда
		ЗаголовокОписаниеОшибки = СтрШаблон("%1 (%2)", ВидОшибки.ЗаголовокПроблемы, КоличествоОшибок);
	Иначе 
		ЗаголовокОписаниеОшибки = ВидОшибки.ЗаголовокПроблемы;
	КонецЕсли;
	
	Форма.Элементы[ИмяЭлементаОписаниеОшибки(ИдентификаторВидаОшибки)].Заголовок = ЗаголовокОписаниеОшибки;
	
КонецПроцедуры

#КонецОбласти

