&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ФормаБезОбработки") = Ложь И ЭтотОбъект.ЗапретитьИзменение = Ложь Тогда
		Элементы.СсылкаТитулГрузоотправителяВалюта.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Валюты");
		Элементы.СсылкаВалютаСтоимости.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Валюты");
		Элементы.СсылкаЗаказчик.ОграничениеТипа = Метаданные.ОпределяемыеТипы.КонтрагентБЭД.Тип;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяГрузыСтоимостьГрузаПриИзменении(Элемент)
	
	ПосчитатьОбщуюСумму();

КонецПроцедуры

&НаКлиенте
Процедура ПосчитатьОбщуюСумму()
	
	ВалютаСтроки = Неопределено;
	СуммаИтого = Неопределено;
	Для Каждого Стр Из ТитулГрузоотправителяГрузы Цикл
		Если СуммаИтого = Неопределено Тогда
			СуммаИтого = Стр.СтоимостьГруза;
			ВалютаСтроки = Стр.СсылкаВалютаСтоимости;
		ИначеЕсли ЗначениеЗаполнено(ВалютаСтроки)
			И ЗначениеЗаполнено(Стр.СсылкаВалютаСтоимости)
			И ВалютаСтроки <> Стр.СсылкаВалютаСтоимости Тогда
			СуммаИтого = Неопределено;
			Прервать;
		Иначе
			СуммаИтого = СуммаИтого + Стр.СтоимостьГруза;	
		КонецЕсли;
	КонецЦикла;
	
	Если СуммаИтого <> Неопределено Тогда
		ТитулГрузоотправителяСтоимостьГруза = СуммаИтого;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура Сохранить(Команда)
	
	ЭтоКонтейнернаяПеревозка = Ложь;
	Для Каждого СтрГруз Из ТитулГрузоотправителяГрузы Цикл
		Если СтрГруз.ОтгрузочноеНаименованиеГруза = "Контейнер" Тогда
			ЭтоКонтейнернаяПеревозка = Истина;
			Прервать;	
		КонецЕсли;
	КонецЦикла;
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции




&НаКлиенте
Процедура ТитулГрузоотправителяГрузыПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ТекущиеДанные.ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулГрузоотправителяГрузНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулГрузоотправителяГрузПриИзменении(Элемент)
	
	ЗначениеРеквизита = Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные.ХранимыеДанныеГруз;
	Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		ВходящийКонтекст = Новый Структура;
		ВходящийКонтекст.Вставить("ЗапретитьИзменение", Ложь);
		ВходящийКонтекст.Вставить("Форма", ЭтотОбъект);
		ВходящийКонтекст.Вставить("ГруппаДанных", СтрЗаменить(Элемент.Имя, "ХранимыеДанные", ""));
		ВходящийКонтекст.Вставить("ТекущиеДанные", Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
		ОбменСГИСЭПДКлиент.ОткрытиеФормыПоГиперссылке_Завершение(ЗначениеРеквизита, ВходящийКонтекст);	
	Иначе
		ОбменСГИСЭПДКлиентСервер.ИзменитьОформлениеЭлементовФормы(ЭтотОбъект, СтрЗаменить(Элемент.Имя, "ХранимыеДанные", ""));	
	КонецЕсли;
	
	ТекущиеДанныеСтроки = Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные;
	Если ТекущиеДанныеСтроки = Неопределено Тогда
		ИзменитьОформлениеКнопок(Новый ФиксированнаяСтруктура("ИмяКнопки, ИдентификаторСтроки",
			"ЗаполнитьТитулГрузоотправителяСведенияОКонтейнерах", Неопределено));
	Иначе
		ИзменитьОформлениеКнопок(Новый ФиксированнаяСтруктура("ИмяКнопки, ИдентификаторСтроки",
			"ЗаполнитьТитулГрузоотправителяСведенияОКонтейнерах", ТекущиеДанныеСтроки.ИдентификаторСтроки));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулГрузоотправителяГрузАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ГруппаДанных = СтрЗаменить(Элемент.Имя, "ХранимыеДанные", "");
	ПараметрыПолученияДанных.Отбор = ОбменСГИСЭПДКлиент.ПолучитьОтборХранимыхДанных(ЭтотОбъект, ЭтотОбъект, ГруппаДанных);
	ПараметрыПолученияДанных.СпособПоискаСтроки = ПредопределенноеЗначение("СпособПоискаСтрокиПриВводеПоСтроке.ЛюбаяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеГрузОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные;
	Если ТипЗнч(ТекущиеДанные.ХранимыеДанныеГруз) <> Тип("СправочникСсылка.ХранимыеДанныеЭПД") Тогда
		СтандартнаяОбработка = Ложь;
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, ТекущиеДанные, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулГрузоотправителяПереченьМаркировокГрузаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулГрузоотправителяГрузыУчетВГИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулГрузоотправителяСведенияОбОпасныхГрузахНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулГрузоотправителяСведенияОКонтейнерахНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаВалютаСтоимостиПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыПоСсылке(Элемент, ЭтотОбъект, Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаЗаказчикПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыПоСсылке(Элемент, ЭтотОбъект, Элементы.ТитулГрузоотправителяГрузы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаТитулГрузоотправителяВалютаПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыПоСсылке(Элемент, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяГрузыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ЗаполнитьТитулГрузоотправителяПереченьМаркировокГруза" 
		Или Поле.Имя = "ЗаполнитьТитулГрузоотправителяСведенияОбОпасныхГрузах"
		Или Поле.Имя = "ЗаполнитьТитулГрузоотправителяСведенияОКонтейнерах"
		Или Поле.Имя = "ЗаполнитьТитулГрузоотправителяГрузыУчетВГИС"
		Или Поле.Имя = "ХранимыеДанныеГруз" Тогда
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Поле.Имя, Элемент.ТекущиеДанные, ЭтотОбъект.ЗапретитьИзменение = Ложь);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяГрузыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);

	Если НоваяСтрока = Истина Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.КодВалютыСтоимости = ТитулГрузоотправителяКодВалюты;
		ТекущиеДанные.НаименованиеВалютыСтоимости = ТитулГрузоотправителяНаименованиеВалюты;
		ТекущиеДанные.СсылкаВалютаСтоимости = СсылкаТитулГрузоотправителяВалюта;
	КонецЕсли;
	
	ПосчитатьОбщуюСумму();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтметитьОбязательныеНеЗаполненныеЭлементыФормы" Тогда
		Если УникальныйИдентификатор <> Параметр Тогда
			Возврат;
		КонецЕсли;
		ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр);
	ИначеЕсли ИмяСобытия = "ИзменитьОформлениеКнопокФормы" Тогда
		Если УникальныйИдентификатор <> Параметр.УникальныйИдентификаторОбновляемойФормы Тогда
			Возврат;
		КонецЕсли;
		ИзменитьОформлениеКнопок(Параметр);	 
	ИначеЕсли СтрНачинаетсяС(ИмяСобытия, "Запись_") Тогда
		Если ТипЗнч(Источник) = Тип("СправочникСсылка.ХранимыеДанныеЭПД") Тогда
			Для Каждого СтрокаГруз Из ТитулГрузоотправителяГрузы Цикл
				Если Источник = СтрокаГруз.ХранимыеДанныеГруз Тогда
					ВходящийКонтекст = Новый Структура;
					ВходящийКонтекст.Вставить("ЗапретитьИзменение", Ложь);
					ВходящийКонтекст.Вставить("Форма", ЭтотОбъект);
					ВходящийКонтекст.Вставить("ГруппаДанных", "Груз");
					ВходящийКонтекст.Вставить("ТекущиеДанные", СтрокаГруз);
					ОбменСГИСЭПДКлиент.ОткрытиеФормыПоГиперссылке_Завершение(Источник, ВходящийКонтекст);	
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбъектыОбязательныеДляЗаполнения

&НаКлиенте
Процедура ИзменитьОформлениеКнопок(Параметр) Экспорт

	Если Не ЭтотОбъект.НачальноеОформлениеВыполнено Тогда
		ЭтотОбъект.ТребуетсяДополнительноеОформлениеКнопок = Истина;
		Если ЭтотОбъект.СтруктураДополнительногоОформленияКнопок <> Неопределено Тогда
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = 
				Новый ФиксированнаяСтруктура("ИмяКнопки, ИдентификаторСтроки");
		Иначе
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = Параметр;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	СтруктураДанныхОбъекта = ОбменСГИСЭПДКлиентСервер.ПолучитьСериализуемыйОбъектСДаннымиДокумента(ЭтотОбъект);
	СтруктураСДаннымиФормыДляОформленияКнопок = 
		ОбменСГИСЭПДКлиентСервер.СтруктураСДаннымиФормыДляОформленияКнопок(ЭтотОбъект);
	
	Результат = ИзменитьОформлениеКнопокНаСервере(СтруктураСТекущимиДаннымиРеквизитов,
		Параметр.ИмяКнопки,
		Параметр.ИдентификаторСтроки,
		СтруктураДанныхОбъекта,
		СтруктураСДаннымиФормыДляОформленияКнопок);
		
	Если Результат.Успешно Тогда
		ЭтотОбъект.АдресДереваСоответствийИтаблицыКнопок = Результат.НовыйАдресВХранилище;	
		МассивОформления = Результат.МассивОформления;
		ОбменСГИСЭПДКлиентСервер.ОформлениеКнопокНаФорме(ЭтотОбъект,
			СтруктураСТекущимиДаннымиРеквизитов, МассивОформления);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьОформлениеКнопокНаСервере(Знач СтруктураСТекущимиДаннымиРеквизитов,
	ИмяКнопки = Неопределено,
	ИдентификаторСтроки = Неопределено,
	Знач СтруктураДанныхОбъекта,
	Знач СтруктураСДаннымиФормыДляОформленияКнопок)
	
	НовыйАдресВХранилище = ОбменСГИСЭПД.ЗапуститьИзменениеОформленияКнопок(СтруктураСДаннымиФормыДляОформленияКнопок,
		СтруктураСТекущимиДаннымиРеквизитов, ИмяКнопки, ИдентификаторСтроки, СтруктураДанныхОбъекта);

	Результат = ОбменСГИСЭПД.ОбработатьРезультатИзмененияОформленияКнопок(НовыйАдресВХранилище);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр)
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(СтруктураСТекущимиДаннымиРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(Знач СтруктураСТекущимиДанными)
	
	ОбменСГИСЭПД.ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(ЭтотОбъект, СтруктураСТекущимиДанными);
	
КонецПроцедуры

#КонецОбласти