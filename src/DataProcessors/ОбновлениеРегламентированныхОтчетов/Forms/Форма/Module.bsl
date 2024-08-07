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
	
	УстановитьУсловноеОформление();
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
		Элементы.ДекорацияОписаниеРезультата.Заголовок =
			НСтр("ru = 'Использование обработки недоступно при работе в модели сервиса.'");
		Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Ошибка32;
		Элементы.КнопкаНазад.Видимость                 = Ложь;
		Элементы.КнопкаДалее.Видимость                 = Ложь;
	Иначе
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	КонецЕсли;
	
	// Загрузка из файла в веб-клиенте невозможна.
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ИнформацияОДоступныхОбновленияхИзСервиса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОбновленияПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = НСтр("ru = 'Архив'") + "(*.zip)|*.zip";
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ФайлОбновленияНачалоВыбораЗавершение",
		ЭтотОбъект);
	
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(
		ОписаниеОповещения,
		ДиалогВыбораФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОписаниеРезультатаОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openLog" Тогда
		СтандартнаяОбработка = Ложь;
		Отбор = Новый Структура;
		Отбор.Вставить("Уровень", "Ошибка");
		Отбор.Вставить("СобытиеЖурналаРегистрации", ПолучениеРегламентированныхОтчетовКлиент.ИмяСобытияЖурналаРегистрации());
		ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
			ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
				,
				ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами()));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	
	СохранитьДанныеАутентификации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	СохранитьДанныеАутентификации = Истина;
	ИнтернетПоддержкаПользователейКлиент.ПриИзмененииСекретныхДанных(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтернетПоддержкаПользователейКлиент.ОтобразитьСекретныеДанные(
		ЭтотОбъект,
		Элемент,
		"Пароль");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеРегламентированныхОтчетов

&НаКлиенте
Процедура ДанныеРегламентированныхОтчетовПередНачаломДобавления(
		Элемент,
		Отказ,
		Копирование,
		Родитель,
		Группа,
		Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеРегламентированныхОтчетовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеРегламентированныхОтчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДанныеРегламентированныхОтчетовЗаголовокСсылкиДействия" Тогда
		ТекущиеДанные = Элементы.ДанныеРегламентированныхОтчетов.ТекущиеДанные;
		Если ТекущиеДанные.Развернута Тогда
			ТекущиеДанные.ОписаниеВерсииОтображаемое = ТекстСвернутогоОписания(ТекущиеДанные.ОписаниеВерсии);
			ТекущиеДанные.Развернута = Ложь;
			ТекущиеДанные.ЗаголовокСсылкиДействия = НСтр("ru = 'Подробнее'");
		Иначе
			ТекущиеДанные.ОписаниеВерсииОтображаемое = ТекущиеДанные.ОписаниеВерсии;
			ТекущиеДанные.Развернута = Истина;
			ТекущиеДанные.ЗаголовокСсылкиДействия = НСтр("ru = 'Свернуть'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		
		Результат = ИнтернетПоддержкаПользователейКлиентСервер.ПроверитьДанныеАутентификации(
			Новый Структура("Логин, Пароль",
			Логин, Пароль));
		
		Если Результат.Отказ Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				Результат.СообщениеОбОшибке,
				,
				Результат.Поле);
		КонецЕсли;
		
		Если Результат.Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПроверитьПодключениеКПорталу1СИТС();
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Если РежимОбновления = РежимОбновленияЧерезИнтернет() Тогда
			ИнформацияОДоступныхОбновленияхИзСервиса();
		Иначе
			ИнформацияОДоступныхОбновленияхИзФайла();
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРегламентированныхОтчетов Тогда
		Если РежимОбновления = РежимОбновленияЧерезИнтернет() Тогда
			НачатьОбновлениеРегламентированныхОтчетовСервис();
		Иначе
			НачатьОбновлениеРегламентированныхОтчетовИзФайла();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления;
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Логин  = "";
	Пароль = "";
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьОтметку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьОтметку(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСвернутогоОписания(Описание, ВозможноРазвертывание = Ложь)
	
	ВозможноРазвертывание = Истина;
	ПозицияСимволПС = СтрНайти(Описание, Символы.ПС);
	Если ПозицияСимволПС = 0 Тогда
		Если СтрДлина(Описание) > 100 Тогда
			Возврат Лев(Описание, 100) + "...";
		Иначе
			ВозможноРазвертывание = Ложь;
			Возврат Описание;
		КонецЕсли;
	ИначеЕсли ПозицияСимволПС > 100 Тогда
		Возврат Лев(Описание, 100) + "...";
	Иначе
		Возврат Лев(Описание, ПозицияСимволПС - 1) + "...";
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() <> 0 Тогда
		ФайлОбновления = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеКПорталу1СИТС()
	
	ДанныеРегламентированныхОтчетов.Очистить();
	ПараметрыПолучения = Неопределено;
	
	// Получение информации из сервиса регламентированных отчетов.
	РезультатОперации = ПолучениеРегламентированныхОтчетов.СлужебнаяДоступныеОбновленияРегламентированныхОтчетов(
		Новый Структура("Логин, Пароль",
			Логин, Пароль),
		Истина);
	
	Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ОбщегоНазначения.СообщитьПользователю(
			РезультатОперации.СообщениеОбОшибке,
			,
			"Логин");
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформациюОДоступныхОбновлениях(РезультатОперации);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОДоступныхОбновленияхИзСервиса()
	
	ДанныеРегламентированныхОтчетов.Очистить();
	ПараметрыПолучения = Неопределено;
	
	Если Не ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
		Если ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки() Тогда
			СохранитьДанныеАутентификации = Истина;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Иначе
			УстановитьОтображениеИнформацииОбОшибкеНаСервере(
				НСтр("ru = 'Интернет-поддержка пользователей не подключена, обратитесь к администратору.'"),
				Ложь,
				Ложь);
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Получение информации из сервиса регламентированных отчетов.
	РезультатОперации = ПолучениеРегламентированныхОтчетов.СлужебнаяДоступныеОбновленияРегламентированныхОтчетов(
		Неопределено,
		Истина);
	
	ЗаполнитьИнформациюОДоступныхОбновлениях(РезультатОперации);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОДоступныхОбновлениях(РезультатОперации)
	
	// Обработка ошибок операции.
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			Если ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки() Тогда
				СохранитьДанныеАутентификации = Истина;
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
				УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
			Иначе
				УстановитьОтображениеИнформацииОбОшибкеНаСервере(
					НСтр("ru = 'Введен неверный логин или пароль Интернет-поддержки пользователей, обратитесь к администратору.'"),
					Ложь,
					Ложь);
				УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
			КонецЕсли;
		Иначе
			// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
			Если СохранитьДанныеАутентификации Тогда
				Логин = "";
				Пароль = "";
				СохранитьДанныеАутентификации = Ложь;
			КонецЕсли;
			УстановитьОтображениеИнформацииОбОшибкеНаСервере(
				РезультатОперации.СообщениеОбОшибке);
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
	Если СохранитьДанныеАутентификации Тогда
		
		// Запись данных.
		УстановитьПривилегированныйРежим(Истина);
		ИнтернетПоддержкаПользователей.СлужебнаяСохранитьДанныеАутентификации(
			Новый Структура(
				"Логин, Пароль",
				Логин,
				Пароль));
		УстановитьПривилегированныйРежим(Ложь);
		
		Логин = "";
		Пароль = "";
		СохранитьДанныеАутентификации = Ложь;
		
	КонецЕсли;
	
	// Заполнение таблицы с обновлениями.
	
	Для Каждого ОписаниеВерсии Из РезультатОперации.ДоступныеВерсии Цикл
		
		СтрокаРегламентированногоОтчета = ДанныеРегламентированныхОтчетов.Добавить();
		ЗаполнитьЗначенияСвойств(
			СтрокаРегламентированногоОтчета,
			ОписаниеВерсии,
			"Идентификатор, ИдентификаторВидаОтчета, Наименование");
		
		СтрокаРегламентированногоОтчета.КонтрольнаяСумма    = ОписаниеВерсии.ИдентификаторФайла.КонтрольнаяСумма;
		СтрокаРегламентированногоОтчета.ИдентификаторФайла  = ОписаниеВерсии.ИдентификаторФайла.ИдентификаторФайла;
		СтрокаРегламентированногоОтчета.Версия              = ОписаниеВерсии.Версия;
		СтрокаРегламентированногоОтчета.ОписаниеВерсии      = ОписаниеВерсии.ОписаниеВерсии;
		СтрокаРегламентированногоОтчета.Размер              = ОписаниеВерсии.Размер;
		СтрокаРегламентированногоОтчета.ТребуетсяОбновление = Истина;
		СтрокаРегламентированногоОтчета.Отметка             = Истина;
		
		
		СтрокаРегламентированногоОтчета.ОписаниеВерсииОтображаемое = ТекстСвернутогоОписания(
			СтрокаРегламентированногоОтчета.ОписаниеВерсии,
			СтрокаРегламентированногоОтчета.ВозможноРазвертывание);

		Если СтрокаРегламентированногоОтчета.ВозможноРазвертывание Тогда
			// Изначально описание свернуто.
			СтрокаРегламентированногоОтчета.ЗаголовокСсылкиДействия = НСтр("ru = 'Подробнее'");
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДанныеРегламентированныхОтчетов.Количество() <> 0 Тогда
		ДанныеРегламентированныхОтчетов.Сортировать("Отметка Убыв, Наименование");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРегламентированныхОтчетов;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Иначе
		УстановитьОтображениеИнформацииОбОшибкеНаСервере(
			НСтр("ru = 'Не найдены доступные обновления регламентированных отчетов.'"),
			Ложь,
			Ложь);
	КонецЕсли;
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект)
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДоступныхОбновленияхИзФайла()
	
	ДанныеРегламентированныхОтчетов.Очистить();
	
	Если Не ЗначениеЗаполнено(ФайлОбновления) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не выбран файл обновления.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	КомпонентыПути = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ФайлОбновления);
	Если КомпонентыПути.Расширение <> ".zip" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Неверный формат файла.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	ВерсииРегламентированныхОтчетов = ПолучениеРегламентированныхОтчетовКлиент.ВерсииРегламентированныхОтчетовВФайле(
		ФайлОбновления);
	ИнформацияОДоступныхОбновленияхИзФайлаНаСервере(ВерсииРегламентированныхОтчетов);
	
	Если ДанныеРегламентированныхОтчетов.Количество() <> 0 Тогда
		ДанныеРегламентированныхОтчетов.Сортировать("Отметка Убыв, Наименование");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРегламентированныхОтчетов;
		
	Иначе
		УстановитьОтображениеИнформацииОбОшибке(
			НСтр("ru = 'Не найдены доступные обновления регламентированных отчетов.'"),
			Ложь,
			Ложь);
	КонецЕсли;
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОДоступныхОбновленияхИзФайлаНаСервере(Знач ВерсииРегламентированныхОтчетов)
	
	ВерсииРегламентированныхОтчетовИБ = ПолучениеРегламентированныхОтчетов.ВерсииРегламентированныхОтчетов();
	
	Для Каждого ВерсияРегламентированногоОтчета Из ВерсииРегламентированныхОтчетов Цикл
		
		ИмяКонфигурации    = ИнтернетПоддержкаПользователей.ИмяКонфигурации();
		ВерсияКонфигурации = ИнтернетПоддержкаПользователей.ВерсияКонфигурации();
		ТребуетсяЗагрузка  = Ложь;
		Для Каждого ОписаниеВерсии Из ВерсияРегламентированногоОтчета.ВерсииПрограмм Цикл
			Если ОписаниеВерсии.Программа = ИмяКонфигурации
				И ОписаниеВерсии.Версия = ВерсияКонфигурации Тогда
				ТребуетсяЗагрузка = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ТребуетсяЗагрузка Тогда
			Продолжить;
		КонецЕсли;
		
		ТребуетсяОбновление = Истина;
		
		Для Каждого ВерсияРегламентированногоОтчетаИБ Из ВерсииРегламентированныхОтчетовИБ Цикл
			Если ВерсияРегламентированногоОтчетаИБ.Идентификатор = ВерсияРегламентированногоОтчета.Идентификатор Тогда 
				Если ВерсияРегламентированногоОтчетаИБ.Версия >= ВерсияРегламентированногоОтчета.Версия Тогда
					ТребуетсяОбновление = Ложь;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		СтрокаЗагрузки = ДанныеРегламентированныхОтчетов.Добавить();
		СтрокаЗагрузки.Отметка                 = ТребуетсяОбновление;
		Если ТребуетсяОбновление Тогда
			СтрокаЗагрузки.Наименование        = ВерсияРегламентированногоОтчета.Наименование;
		Иначе
			СтрокаЗагрузки.Наименование        = ОбновлениеНеТребуется(ВерсияРегламентированногоОтчета.Наименование);
		КонецЕсли;
		СтрокаЗагрузки.Версия                  = ВерсияРегламентированногоОтчета.Версия;
		СтрокаЗагрузки.ОписаниеВерсии          = ВерсияРегламентированногоОтчета.ОписаниеВерсии;
		СтрокаЗагрузки.ТребуетсяОбновление     = ТребуетсяОбновление;
		СтрокаЗагрузки.Идентификатор           = ВерсияРегламентированногоОтчета.Идентификатор;
		СтрокаЗагрузки.ИдентификаторВидаОтчета = ВерсияРегламентированногоОтчета.ИдентификаторВидаОтчета;
		СтрокаЗагрузки.ИдентификаторФайла      = ВерсияРегламентированногоОтчета.Имя;
		
		СтрокаЗагрузки.ОписаниеВерсииОтображаемое = ТекстСвернутогоОписания(
			СтрокаЗагрузки.ОписаниеВерсии,
			СтрокаЗагрузки.ВозможноРазвертывание);

		Если СтрокаЗагрузки.ВозможноРазвертывание Тогда
			// Изначально описание свернуто.
			СтрокаЗагрузки.ЗаголовокСсылкиДействия = НСтр("ru = 'Подробнее'");
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеРегламентированныхОтчетовИзФайлаПослеЗагрузки(
	ПомещенныеФайлы, 
	ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Файл с обновлениями не загружен.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	
	РезультатВыполнения = ИнтерактивноеОбновлениеРегламентированныхОтчетовИзФайла(
		ПомещенныеФайлы[0].Хранение);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"НачатьОбновлениеРегламентированныхОтчетовЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		НачатьОбновлениеРегламентированныхОтчетовЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость  = Ложь;
	Элементы.ДекорацияСостояние.Заголовок   = НСтр("ru = 'Обработка файлов регламентированных отчетов на сервере.'");
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ИнтерактивноеОбновлениеРегламентированныхОтчетовИзФайла(Знач АдресФайла)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Отметка", Истина);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеФайла", ПолучитьИзВременногоХранилища(АдресФайла));
	ПараметрыПроцедуры.Вставить("ДанныеРегламентированныхОтчетов", ДанныеРегламентированныхОтчетов.Выгрузить(Отбор));
	УдалитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обработка файлов регламентированных отчетов.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ПолучениеРегламентированныхОтчетов.ИнтерактивноеОбновлениеРегламентированныхОтчетовИзФайла",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеРегламентированныхОтчетовСервис()
	
	ИндикаторОбновления = 0;
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения(
		"ОбновитьИндикаторЗагрузки",
		ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	РезультатВыполнения = ИнтерактивноеОбновлениеРегламентированныхОтчетовИзСервиса();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"НачатьОбновлениеРегламентированныхОтчетовЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		НачатьОбновлениеРегламентированныхОтчетовЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость = Истина;
	Элементы.ДекорацияСостояние.Заголовок  = НСтр("ru = 'Выполняется обновление регламентированных отчетов. Обновление
		|может занять от нескольких минут до нескольких часов в зависимости от размера обновления.'");
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ИнтерактивноеОбновлениеРегламентированныхОтчетовИзСервиса()
	
	ДанныеРегламентированныхОтчетовПодготовка = ДанныеРегламентированныхОтчетов.Выгрузить();
	ДанныеРегламентированныхОтчетовПодготовка.Колонки.Добавить("ДанныеФайла");
	СтрокиУдалить = Новый Массив;
	Для Каждого ОписаниеРегламентированногоОтчета Из ДанныеРегламентированныхОтчетовПодготовка Цикл
		Если Не ОписаниеРегламентированногоОтчета.Отметка Тогда
			СтрокиУдалить.Добавить(ОписаниеРегламентированногоОтчета);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ОписаниеРегламентированногоОтчета Из СтрокиУдалить Цикл
		ДанныеРегламентированныхОтчетовПодготовка.Удалить(ОписаниеРегламентированногоОтчета);
	КонецЦикла;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеРегламентированныхОтчетов", ДанныеРегламентированныхОтчетовПодготовка);
	ПараметрыПроцедуры.Вставить("РежимОбновления",                 РежимОбновления);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление данных регламентированных отчетов.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ПолучениеРегламентированныхОтчетов.ИнтерактивноеОбновлениеРегламентированныхОтчетовИзСервиса",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеРегламентированныхОтчетовИзФайла()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьОбновлениеРегламентированныхОтчетовИзФайлаПослеЗагрузки",
		ЭтотОбъект);
	
	ОписаниеПередаваемогоФайла = Новый ОписаниеПередаваемогоФайла(ФайлОбновления);
	
	ФайлыОбновлений = Новый Массив;
	ФайлыОбновлений.Добавить(ОписаниеПередаваемогоФайла);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Интерактивно = Ложь;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(
		ОписаниеОповещения,
		ПараметрыЗагрузки,
		ФайлыОбновлений);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндикаторЗагрузки(СтатусВыполнения, ДополнительныеПараметры) Экспорт
	
	Результат = ПрочитатьПрогресс(СтатусВыполнения.ИдентификаторЗадания);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИндикаторОбновления = Результат.Процент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеРегламентированныхОтчетовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			УстановитьОтображениеИнформацииОбОшибке(
				РезультатОперации.СообщениеОбОшибке,
				Ложь,
				Ложь);
		Иначе
			УстановитьОтображениеУспешногоЗавершения(ЭтотОбъект);
		КонецЕсли;
		
		// Обновление открытых форм регламентированных отчетов.
		Идентификаторы = Новый Массив;
		Для Каждого СтрокаТаблицы Из ДанныеРегламентированныхОтчетов Цикл
			Если СтрокаТаблицы.Отметка Тогда
				Идентификаторы.Добавить(СтрокаТаблицы.Идентификатор);
			КонецЕсли;
		КонецЦикла;
		
		Оповестить(
			ПолучениеРегламентированныхОтчетовКлиент.ИмяСобытияОповещенияОЗагрузки(),
			Идентификаторы,
			ЭтотОбъект);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке = Результат.КраткоеПредставлениеОшибки;
		УстановитьОтображениеИнформацииОбОшибке(ИнформацияОбОшибке);
	КонецЕсли;
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементовФормы(Форма)
	
	Элементы = Форма.Элементы;
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРегламентированныхОтчетов Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультатыОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Ложь;
	КонецЕсли;
	
	Если Форма.РежимОбновления = 0 Тогда
		Элементы.ФайлОбновления.Доступность = Ложь;
	Иначе
		Элементы.ФайлОбновления.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтображениеИнформацииОбОшибке(
		ИнформацияОбОшибке,
		Ошибка = Истина,
		ОтображатьЖР = Истина)
	
	Если ОтображатьЖР Тогда
		ПредставлениеОшибки = СтроковыеФункцииКлиент.ФорматированнаяСтрока(
			НСтр("ru = '%1
				|
				|Подробную информацию см. в <a href = ""action:openLog"">Журнале регистрации</a>.'"),
			ИнформацияОбОшибке);
	Иначе
		ПредставлениеОшибки = ИнформацияОбОшибке;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
	Элементы.ДекорацияОписаниеРезультата.Заголовок = ПредставлениеОшибки;
	Элементы.ДекорацияКартинкаРезультат.Картинка   = ?(
		Ошибка,
		БиблиотекаКартинок.Ошибка32,
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеИнформацииОбОшибкеНаСервере(
		ИнформацияОбОшибке,
		Ошибка = Истина,
		ОтображатьЖР = Истина)
	
	Если ОтображатьЖР Тогда
		ПредставлениеОшибки = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '%1
				|
				|Подробную информацию см. в <a href = ""action:openLog"">Журнале регистрации</a>.'"),
			ИнформацияОбОшибке);
	Иначе
		ПредставлениеОшибки = ИнформацияОбОшибке;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
	Элементы.ДекорацияОписаниеРезультата.Заголовок = ПредставлениеОшибки;
	Элементы.ДекорацияКартинкаРезультат.Картинка   = ?(
		Ошибка,
		БиблиотекаКартинок.Ошибка32,
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеУспешногоЗавершения(Форма)
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница        = Форма.Элементы.ГруппаРезультатыОбновления;
	Форма.Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Успешно32;
	Форма.Элементы.ДекорацияОписаниеРезультата.Заголовок = НСтр("ru = 'Обновление регламентированных отчетов успешно завершено.'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеРегламентированныхОтчетовВерсия.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеРегламентированныхОтчетовНаименование.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеРегламентированныхОтчетовОтметка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДанныеРегламентированныхОтчетов.ТребуетсяОбновление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра(
		"ЦветТекста",
		Метаданные.ЭлементыСтиля.ЦветНеАктивнойСтроки.Значение);
	
	Элемент.Оформление.УстановитьЗначениеПараметра(
		"Доступность",
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметку(Значение)
	
	Для Каждого СтрокаРегламентированногоОтчета Из ДанныеРегламентированныхОтчетов Цикл
		СтрокаРегламентированногоОтчета.Отметка = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РежимОбновленияЧерезИнтернет()
	
	Возврат 0;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбновлениеНеТребуется(Наименование)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (обновление не требуется)'"),
		Наименование);
	
КонецФункции

#КонецОбласти
