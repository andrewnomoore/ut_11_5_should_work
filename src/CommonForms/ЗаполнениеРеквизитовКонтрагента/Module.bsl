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
	
	СтрокаПоиска                = Параметры.СтрокаПоиска;
	Регион                      = Параметры.Регион;
	Адрес                       = Параметры.Адрес;
	РасширенныйРезультатПодбора = Параметры.РасширенныйРезультатПодбора;
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ЗаполнитьСписокРегионов();
	
	ВыполняетсяПоиск = ЗначениеЗаполнено(СтрокаПоиска);
	УправлениеФормой(ЭтотОбъект);
	
	ПоказатьУведомления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВыполняетсяПоиск Тогда
		ПодключитьОбработчикОжидания("НачатьПоискКонтрагентов", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Регион = Настройки["Регион"];
	Если Элементы.Регион.СписокВыбора.НайтиПоЗначению(Регион) = Неопределено Тогда
		Регион = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("НачатьПоискКонтрагентов", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РегионПриИзменении(Элемент)
	
	Если Элементы.Регион.СписокВыбора.НайтиПоЗначению(Регион) = Неопределено Тогда
		Регион = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУведомлениеПодробнееНажатие(Элемент)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторПортала1СИТС") Тогда
		Возврат;
	КонецЕсли;
	
	МодульМониторПортала1СИТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МониторПортала1СИТСКлиент");
	МодульМониторПортала1СИТСКлиент.ОткрытьСообщениеОбОпцияхИнтернетПоддержки(
		УведомленияМонитораПортала);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКонтрагенты

&НаКлиенте
Процедура КонтрагентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполнитьВыборКонтрагента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиКонтрагентов(Команда)
	
	НачатьПоискКонтрагентов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКонтрагента(Команда)
	
	ВыполнитьВыборКонтрагента();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокРегионов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификатор = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификатор");
		ТаблицаРегионов = МодульАдресныйКлассификатор.СубъектыРФ();
		Элементы.Регион.СписокВыбора.Очистить();
		Для Каждого СтрокаТаблицы Из ТаблицаРегионов Цикл
			Элементы.Регион.СписокВыбора.Добавить(
				Формат(СтрокаТаблицы.КодСубъектаРФ, "ЧЦ=2; ЧДЦ=; ЧВН="), 
				СтрокаТаблицы.Наименование + " " + СтрокаТаблицы.Сокращение);
		КонецЦикла;
		Элементы.Регион.СписокВыбора.СортироватьПоПредставлению();
	КонецЕсли;
	
	Элементы.Регион.СписокВыбора.Вставить(0, "", НСтр("ru='Все регионы'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИННЮридическогоЛица(СтрокаПоиска)
	
	Результат = ЗначениеЗаполнено(СтрокаПоиска)
		И СтрДлина(СтрокаПоиска) = 10
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоиска);
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИННПредпринимателя(СтрокаПоиска)
	
	Результат = ЗначениеЗаполнено(СтрокаПоиска)
		И СтрДлина(СтрокаПоиска) = 12
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоиска);
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура НачатьПоискКонтрагентов()
	
	ОтключитьОбработчикОжидания("НачатьПоискКонтрагентов");
	
	// Для того, чтобы не передавать в серверный контекст
	// заполненный список при последующих вызовах
	Контрагенты.ПолучитьЭлементы().Очистить();
	
	Если Не ПроверитьЗаполнение() Тогда
		ВыполняетсяПоиск = Ложь;
		УправлениеФормой(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	НачатьПоискНаСервере();
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперация,
			Новый ОписаниеОповещения("ПриЗавершенииЗадания", ЭтотОбъект),
			ПараметрыОжидания);
		
	Иначе
		
		// Задание завершено
		ПриЗавершенииЗадания(ДлительнаяОперация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииЗадания(РезультатЗадания, ДополнительныеПараметры = Неопределено) Экспорт
	
	ДлительнаяОперация = РезультатЗадания;
	Результат = ПриЗавершенииЗаданияНаСервере();
	КоличествоНайденных = Результат.КоличествоНайденных;
	Если ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		ОбработатьОшибкуПоискаКонтрагента(Результат.ОписаниеОшибки);
	ИначеЕсли Результат.Повторить Тогда
		ПодключитьОбработчикОжидания("НачатьПоискКонтрагентов", 5, Истина);
	ИначеЕсли КоличествоНайденных > 20 Тогда
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Показаны первые 20 контрагентов из %1 найденных. Уточните реквизиты для поиска.'"), 
			Результат.КоличествоНайденных));
	ИначеЕсли Не ПустаяСтрока(СтрокаПоиска)
		И КоличествоНайденных = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Ничего не найдено. Уточните реквизиты для поиска.'"));
	ИначеЕсли КоличествоНайденных > 0 Тогда
		ТекущийЭлемент = Элементы.Контрагенты;
		Элементы.Контрагенты.ТекущаяСтрока = Контрагенты.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
	Иначе
		ТекущийЭлемент = Элементы.СтрокаПоиска;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуПоискаКонтрагента(ОписаниеОшибки)
	
	// Обработка ошибок
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		
		ОбработчикЗавершенияОбработкиОшибки = Новый ОписаниеОповещения(
			"ОбработатьОшибкуПоискаКонтрагентаЗавершение",
			ЭтотОбъект);
		ДополнительныеПараметрыОбработкиОшибки =
			РаботаСКонтрагентамиКлиент.НовыйДополнительныеПараметрыОбработкиОшибки();
		ДополнительныеПараметрыОбработкиОшибки.ПредставлениеДействия    = НСтр("ru = 'Автоматическое заполнение реквизитов контрагентов'");
		ДополнительныеПараметрыОбработкиОшибки.ИдентификаторМестаВызова = "zapolnenie_rekvizitov";
		ДополнительныеПараметрыОбработкиОшибки.Форма                    = ЭтотОбъект;
		
		РаботаСКонтрагентамиКлиент.ОбработатьОшибку(
			ОписаниеОшибки,
			ОбработчикЗавершенияОбработкиОшибки,
			ДополнительныеПараметрыОбработкиОшибки);
		
	ИначеЕсли КоличествоНайденных > Контрагенты.ПолучитьЭлементы().Количество() Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Найдено слишком много похожих контрагентов (%1). Уточните реквизиты для поиска.'"),
			КоличествоНайденных);
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуПоискаКонтрагентаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.ПовторитьДействие Тогда
		НачатьПоискКонтрагентов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачатьПоискНаСервере()
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполняется" Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ВыполняетсяПоиск = Истина;
	УправлениеФормой(ЭтотОбъект);
	
	Контрагенты.ПолучитьЭлементы().Очистить();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	Если ЭтоИННПредпринимателя(СтрокаПоиска) Тогда
		ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(
			ПараметрыВыполнения,
			"РаботаСКонтрагентами.РеквизитыПредпринимателяПоИНН",
			СтрокаПоиска);
		ИмяМетодаФоновогоЗадания = "РеквизитыПредпринимателяПоИНН";
	ИначеЕсли ЭтоИННЮридическогоЛица(СтрокаПоиска) Тогда
		ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(
			ПараметрыВыполнения,
			"РаботаСКонтрагентами.ЮридическиеЛицаПоИНН",
			СтрокаПоиска,
			Регион,
			Адрес);
		ИмяМетодаФоновогоЗадания = "ЮридическиеЛицаПоИНН";
	Иначе
		ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(
			ПараметрыВыполнения,
			"РаботаСКонтрагентами.ЮридическиеЛицаПоНаименованию",
			СтрокаПоиска,
			Регион,
			Адрес);
		ИмяМетодаФоновогоЗадания = "ЮридическиеЛицаПоНаименованию";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриЗавершенииЗаданияНаСервере()
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеОшибки");
	Результат.Вставить("КоличествоНайденных", 0);
	Результат.Вставить("Повторить"          , Ложь);
	
	Если ТипЗнч(ДлительнаяОперация) <> Тип("Структура") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		
		РезультатЗадания = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатЗадания.ОписаниеОшибки) Тогда
			Результат.ОписаниеОшибки = РезультатЗадания.ОписаниеОшибки;
		ИначеЕсли ИмяМетодаФоновогоЗадания = "ЮридическиеЛицаПоНаименованию"
			Или ИмяМетодаФоновогоЗадания = "ЮридическиеЛицаПоИНН" Тогда
			
			Если РезультатЗадания.ОжиданиеОтвета Тогда
				Результат.Повторить = Истина;
			Иначе
				ЗаполнитьПоДаннымЮридическихЛиц(РезультатЗадания.РеквизитыОрганизаций);
				Результат.КоличествоНайденных = РезультатЗадания.КоличествоНайденных;
			КонецЕсли;
			
		ИначеЕсли ИмяМетодаФоновогоЗадания = "РеквизитыПредпринимателяПоИНН" Тогда
			ЗаполнитьПоДаннымПредпринимателя(РезультатЗадания);
			Результат.КоличествоНайденных = 1;
		КонецЕсли;
		
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		
		Результат.ОписаниеОшибки = НСтр("ru = 'Ошибка при обращении к сервису.
			|Подробнее см. в журнале регистрации.'");
		РаботаСКонтрагентами.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при поиске контрагентов по наименованию. %1'"),
				ДлительнаяОперация.ПодробноеПредставлениеОшибки),
			"Контрагент");
		
	ИначеЕсли ДлительнаяОперация.Статус = "Отменено" Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Задание отменено администратором.'");
	КонецЕсли;
	
	Если Не Результат.Повторить Тогда
		ВыполняетсяПоиск = Ложь;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоДаннымЮридическихЛиц(РеквизитыОрганизаций)
	
	КонтрагентыДерево = РеквизитФормыВЗначение("Контрагенты");
	Для Каждого РеквизитыОрганизации Из РеквизитыОрганизаций Цикл
		КонтрагентКорневаяСтрока = КонтрагентыДерево.Строки.Добавить();
		КонтрагентКорневаяСтрока.ИНН = РеквизитыОрганизации.ИНН;
		КонтрагентКорневаяСтрока.Наименование = РеквизитыОрганизации.НаименованиеПолное;
		Если РеквизитыОрганизации.ЮридическийАдрес <> Неопределено Тогда
			КонтрагентКорневаяСтрока.ЮридическийАдрес = РеквизитыОрганизации.ЮридическийАдрес.Представление;
		КонецЕсли;
		КонтрагентКорневаяСтрока.Руководитель = ПредставлениеСпискаРуководителей(РеквизитыОрганизации.Руководители);
		ЗаполнитьПодразделенияЮридическихЛиц(
			КонтрагентКорневаяСтрока,
			РеквизитыОрганизации.Подразделения);
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(КонтрагентыДерево, "Контрагенты");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеСпискаРуководителей(Руководители)
	
	Результат = "";
	Для Каждого ТекущийРуководитель Из Руководители Цикл
		Результат = Результат + ?(ПустаяСтрока(Результат), "", ", ")
			+ ТекущийРуководитель.Представление;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьПодразделенияЮридическихЛиц(
	КонтрагентСтрока,
	Подразделения)
	
	Если Подразделения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Подразделение Из Подразделения Цикл
		ПодразделениеСтрокаДерева = КонтрагентСтрока.Строки.Добавить();
		ПодразделениеСтрокаДерева.ИНН = Подразделение.ИНН;
		ПодразделениеСтрокаДерева.Наименование = Подразделение.Наименование;
		Если Подразделение.ЮридическийАдрес <> Неопределено Тогда
			ПодразделениеСтрокаДерева.ЮридическийАдрес = Подразделение.ЮридическийАдрес.Представление;
		КонецЕсли;
		ПодразделениеСтрокаДерева.Идентификатор = Подразделение.Идентификатор;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымПредпринимателя(РезультатЗадания);
	
	КонтрагентыДерево = Контрагенты.ПолучитьЭлементы();
	КонтрагентКорневаяСтрока              = КонтрагентыДерево.Добавить();
	КонтрагентКорневаяСтрока.ИНН          = РезультатЗадания.ИНН;
	КонтрагентКорневаяСтрока.Наименование = РезультатЗадания.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыборКонтрагента()
	
	ТекДанные = Элементы.Контрагенты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Если Контрагенты.ПолучитьЭлементы().Количество() = 0 Тогда
			ТекстПредупреждения = НСтр("ru='Ничего не найдено. Уточните реквизиты и нажмите ""Найти"".'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекДанные.ИНН) Тогда
		ТекстПредупреждения = НСтр("ru='Выберите контрагента, у которого указан ИНН.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если РасширенныйРезультатПодбора Тогда
		Результат = Новый Структура();
		Результат.Вставить("ИНН",              ТекДанные.ИНН);
		Результат.Вставить("ЭтоПодразделение", ЗначениеЗаполнено(ТекДанные.Идентификатор));
		Результат.Вставить("Идентификатор",    ТекДанные.Идентификатор);
	Иначе
		Результат = ТекДанные.ИНН;
	КонецЕсли;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.КнопкаВыбратьКонтрагента.Видимость   = Не Форма.ВыполняетсяПоиск;
	Форма.Элементы.КнопкаВыбратьКонтрагента.Доступность = Форма.Контрагенты.ПолучитьЭлементы().Количество() > 0;
	Если Форма.ВыполняетсяПоиск Тогда
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаОжидание;
	Иначе
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаРезультат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУведомления()
	
	УведомленияМонитораПортала = РаботаСКонтрагентами.УведомлениеПользователя(
		РаботаСКонтрагентами.ИдентификаторУслугиЗаполнениеРеквизитовКонтрагентов());
	
	Если УведомленияМонитораПортала = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаУведомлениеСервиса.Видимость = Истина;
	Элементы.ДекорацияТекстУведомления.Заголовок = УведомленияМонитораПортала.ТекстУведомления;
	
КонецПроцедуры

#КонецОбласти