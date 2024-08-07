
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗагрузитьСписок(Неопределено, 1);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = Элементы.Страны.ТекущиеДанные;
	
	Данные = Новый Структура;
	Данные.Вставить("Активность",    ТекущиеДанные.Активность);
	Данные.Вставить("Актуальность",  ТекущиеДанные.Актуальность);
	Данные.Вставить("GUID",          ТекущиеДанные.GUID);
	Данные.Вставить("UUID",          ТекущиеДанные.UUID);
	Данные.Вставить("Статус",        ТекущиеДанные.Статус);
	Данные.Вставить("Наименование",  ТекущиеДанные.Наименование);
	Данные.Вставить("НаименованиеПолное",  ТекущиеДанные.НаименованиеПолное);
	Данные.Вставить("ДатаСоздания",  ТекущиеДанные.ДатаСоздания);
	Данные.Вставить("ДатаИзменения", ТекущиеДанные.ДатаИзменения);
	
	Закрыть(Данные);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписок(ПараметрыПоиска, НомерСтраницы)
	
	Результат = ИкарВЕТИСВызовСервера.СписокСтран(НомерСтраницы);
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Страны.Очистить();
	Для Каждого СтрокаТЧ Из Результат.Список Цикл
		
		НоваяСтрока = Страны.Добавить();
		НоваяСтрока.Активность    = СтрокаТЧ.active;
		НоваяСтрока.Актуальность  = СтрокаТЧ.last;
		НоваяСтрока.GUID          = СтрокаТЧ.GUID;
		НоваяСтрока.UUID          = СтрокаТЧ.UUID;
		НоваяСтрока.Наименование  = СтрокаТЧ.Name;
		НоваяСтрока.ДатаСоздания  = СтрокаТЧ.createDate;
		НоваяСтрока.ДатаИзменения = СтрокаТЧ.updateDate;
		
		НоваяСтрока.НаименованиеПолное = СтрокаТЧ.fullName;
		НоваяСтрока.КодАльфа2          = СтрокаТЧ.code;
		НоваяСтрока.КодАльфа3          = СтрокаТЧ.code3;
		
		НоваяСтрока.Статус = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(СтрокаТЧ.status);
		
	КонецЦикла;
	
	СтраныОбщееКоличество = Результат.ОбщееКоличество;
	СтраныНомерСтраницы   = НомерСтраницы;
	СтраныПараметрыПоиска = ПараметрыПоиска;
	
	КоличествоСтраниц = СтраныОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	Команды["НавигацияСтраницаТекущаяСтраница"].Заголовок =
		СтрШаблон(
			НСтр("ru = 'Страница %1 из %2'"),
			СтраныНомерСтраницы, КоличествоСтраниц);
	
	Элементы.СтраницаСледующая.Доступность  = (СтраныНомерСтраницы < КоличествоСтраниц);
	Элементы.СтраницаПредыдущая.Доступность = (СтраныНомерСтраницы > 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПервая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(СтраныПараметрыПоиска, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПоследняя(Команда)
	
	ОчиститьСообщения();
	
	КоличествоСтраниц = СтраныОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	ЗагрузитьСписок(СтраныПараметрыПоиска, КоличествоСтраниц);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПредыдущая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(СтраныПараметрыПоиска, СтраныНомерСтраницы - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаСледующая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(СтраныПараметрыПоиска, СтраныНомерСтраницы + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаТекущаяСтраница(Команда)
	
	ОчиститьСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Выбрать(Неопределено);
	
КонецПроцедуры
