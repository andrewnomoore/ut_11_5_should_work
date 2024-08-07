
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	БезопасноеХранилище = Новый Структура("Пароль,КлючAPI");
	
	УстановитьПривилегированныйРежим(Истина);
	БезопасныеСтроки = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.ХозяйствующийСубъект, "Пароль,КлючAPI");
	УстановитьПривилегированныйРежим(Ложь);
	
	Пароль  = ?(ЗначениеЗаполнено(БезопасныеСтроки.Пароль),  ЭтотОбъект.УникальныйИдентификатор, "");
	КлючAPI = ?(ЗначениеЗаполнено(БезопасныеСтроки.КлючAPI), ЭтотОбъект.УникальныйИдентификатор, "");
	
	УстановитьПризнакСобственнойОрганизации();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	ПоказатьСтраницуПроверкаНеВыполнялась(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПроверитьЗаполнениеФормы() Тогда
		ПодключитьОбработчикОжидания("ВыполнитьПроверкуПодключенияВЕТИСНачало", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(БезопасноеХранилище.Пароль) Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.ХозяйствующийСубъект, БезопасноеХранилище.Пароль);
		БезопасноеХранилище.Пароль = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(БезопасноеХранилище.КлючAPI) Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.ХозяйствующийСубъект, БезопасноеХранилище.КлючAPI, "КлючAPI");
		БезопасноеХранилище.КлючAPI = Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НадписьПроверкаНеВыполняласьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПроверкаНеВыполненаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ХозяйствующийСубъектПриИзменении(Элемент)
	
	ХозяйствующийСубъектПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ХозяйствующийСубъектПриИзмененииНаСервере()
	
	УстановитьПризнакСобственнойОрганизации();
	
	Если НЕ ЭтоСобственнаяОрганизация Тогда
		Запись.Администратор = Неопределено;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	ПоказатьСтраницуПроверкаНеВыполнялась(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	
	ПоказатьСтраницуПроверкаНеВыполнялась(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КлючAPIПриИзменении(Элемент)
	
	КлючAPIПриИзмененииНаСервере();
	
	ПоказатьСтраницуПроверкаНеВыполнялась(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура КлючAPIПриИзмененииНаСервере()
	
	БезопасноеХранилище.КлючAPI = КлючAPI;
	КлючAPI = ?(ЗначениеЗаполнено(КлючAPI), ЭтотОбъект.УникальныйИдентификатор, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ПарольПриИзмененииНаСервере();
	
	ПоказатьСтраницуПроверкаНеВыполнялась(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПарольПриИзмененииНаСервере()
	
	БезопасноеХранилище.Пароль = Пароль;
	Пароль = ?(ЗначениеЗаполнено(Пароль), ЭтотОбъект.УникальныйИдентификатор, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ТаймаутПриИзменении(Элемент)
	
	ПоказатьСтраницуПроверкаНеВыполнялась(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АдминистраторПриИзменении(Элемент)
	
	ПоказатьСтраницуПроверкаНеВыполнялась(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьНастройкуПриОтветеНаВопрос(ОтветНаВопрос, ОповещениеПриЗаписи) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		Если ПроверитьЗаполнение() Тогда
			Если Записать() Тогда
				ВыполнитьОбработкуОповещения(ОповещениеПриЗаписи);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНавигационнуюСсылку(Знач НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПроверитьПодключениеВЕТИС" Тогда
		СтандартнаяОбработка = Ложь;
		
		Если НЕ ЗначениеЗаполнено(Запись.ИсходныйКлючЗаписи) ИЛИ ЭтотОбъект.Модифицированность Тогда
			ТекстВопроса = НСтр("ru='Перед проверкой подключения настройку необходимо записать. Продолжить?'");
			ОповещениеПриЗаписи = Новый ОписаниеОповещения("ВыполнитьПроверкуПодключенияВЕТИС", ЭтотОбъект);
			ОповещениеПриОтвете = Новый ОписаниеОповещения("ЗаписатьНастройкуПриОтветеНаВопрос", ЭтотОбъект, ОповещениеПриЗаписи);
			ПоказатьВопрос(ОповещениеПриОтвете, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			ВыполнитьПроверкуПодключенияВЕТИС(,);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеФормы()
	
	ФормаЗаполнена = ЗначениеЗаполнено(Пароль) И ЗначениеЗаполнено(КлючAPI);
	
	Если ФормаЗаполнена Тогда
		ИменаРеквизитов = Новый Массив();
		ИменаРеквизитов.Добавить("ХозяйствующийСубъект");
		ИменаРеквизитов.Добавить("Логин");
		ИменаРеквизитов.Добавить("Таймаут");
		
		Для Каждого ИмяРеквизита Из ИменаРеквизитов Цикл
			ФормаЗаполнена = ФормаЗаполнена И ЗначениеЗаполнено(Запись[ИмяРеквизита]);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ФормаЗаполнена;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьСтраницуПроверкаНеВыполнялась(Форма)
	
	СтраницыПроверкиПодключения = Форма.Элементы.СтраницыПроверкаПодключения;
	
	Если СтраницыПроверкиПодключения.ТекущаяСтраница <> СтраницыПроверкиПодключения.ПодчиненныеЭлементы.СтраницаПроверкаНеВыполнялась Тогда
		СтраницыПроверкиПодключения.ТекущаяСтраница = СтраницыПроверкиПодключения.ПодчиненныеЭлементы.СтраницаПроверкаНеВыполнялась;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Если НЕ ИспользуетсяКомиссияПриЗакупкахИлиПереработкаДавальческогоСырья() Тогда
		ПараметрыВыбора = Новый Массив();
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.СоответствуетОрганизации", Истина));
		
		Форма.Элементы.ХозяйствующийСубъект.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	КонецЕсли;
	
	Форма.Элементы.Администратор.АвтоОтметкаНезаполненного = Форма.ЭтоСобственнаяОрганизация;
	Форма.Элементы.Администратор.ТолькоПросмотр            = НЕ Форма.ЭтоСобственнаяОрганизация;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользуетсяКомиссияПриЗакупкахИлиПереработкаДавальческогоСырья()
	
	Возврат ИнтеграцияВЕТИС.ИспользуетсяКомиссияПриЗакупкахИлиПереработкаДавальческогоСырья();
	
КонецФункции

&НаСервере
Процедура УстановитьПризнакСобственнойОрганизации()
	
	Если ЗначениеЗаполнено(Запись.ХозяйствующийСубъект) Тогда
		ЭтоСобственнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ХозяйствующийСубъект, "СоответствуетОрганизации");
	Иначе
		ЭтоСобственнаяОрганизация = Истина;
	КонецЕсли;
	
КонецПроцедуры

#Область ПроверкаПодключения

&НаКлиенте
Процедура ВыполнитьПроверкуПодключенияВЕТИС(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьПроверкуПодключенияВЕТИСНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуПодключенияВЕТИСНачало()
	
	ОчиститьСообщения();
	
	СтраницыПроверкиПодключения = Элементы.СтраницыПроверкаПодключения;
	СтраницыПроверкиПодключения.ТекущаяСтраница = СтраницыПроверкиПодключения.ПодчиненныеЭлементы.СтраницаПроверкаВыполняется;
	
	Попытка
		КоличествоЭлементов = 100;
		
		РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросДоступныхДляНазначенияПрав(
		                  Запись.ХозяйствующийСубъект, КоличествоЭлементов, УникальныйИдентификатор);
		
		ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
	Исключение
		ПоказатьОшибкуПроверкиПодключения(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуПодключенияВЕТИСОкончание()
	
	СтраницыПроверкиПодключения = Элементы.СтраницыПроверкаПодключения;
	СтраницыПроверкиПодключения.ТекущаяСтраница = СтраницыПроверкиПодключения.ПодчиненныеЭлементы.СтраницаПроверкаВыполнена;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеПриЗавершенииОбмена()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	
	Возврат ОписаниеОповещения;
	
КонецФункции

&НаКлиенте
Процедура ПослеПолученияРезультатОбработкиЗаявки(Изменения, ДополнительныеПараметры) Экспорт
	
	ДанныеДляОбработки = Неопределено;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		Если ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ЗапросДоступныхДляНазначенияПрав") Тогда
			ДанныеДляОбработки = ЭлементДанных;
		ИначеЕсли ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросДоступныхДляНазначенияПрав") Тогда
			ДанныеДляОбработки = ЭлементДанных;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ДанныеДляОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОтклонена")
		ИЛИ НЕ ПустаяСтрока(ДанныеДляОбработки.ТекстОшибки) Тогда
		ПоказатьОшибкуПроверкиПодключения(ДанныеДляОбработки.ТекстОшибки);
	ИначеЕсли ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаВыполнена") Тогда
		ВыполнитьПроверкуПодключенияВЕТИСОкончание();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуПроверкиПодключения(ТекстОшибки)
	
	СтраницыПроверкиПодключения = Элементы.СтраницыПроверкаПодключения;
	СтраницыПроверкиПодключения.ТекущаяСтраница = СтраницыПроверкиПодключения.ПодчиненныеЭлементы.СтраницаПроверкаНеВыполнена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
