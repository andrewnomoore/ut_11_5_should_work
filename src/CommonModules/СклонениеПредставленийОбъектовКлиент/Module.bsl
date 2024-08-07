///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Склоняет переданную фразу по всем падежам.
// Результат фиксируется в данных формы.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - форма объекта склонения.
//  Представление		 - Строка			 - строка для склонения.
//  ПараметрыСклонения	 - Структура		 - параметры склонения, созданные методом СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения().
//  ПоказыватьСообщения	 - Булево			 - признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
Процедура ПросклонятьПредставление(Форма, Представление, ПараметрыСклонения = Неопределено, ПоказыватьСообщения = Ложь) Экспорт
	
	Форма.ИзмененоПредставление = Истина;
	НачатьСклонение(Форма, Представление, ПараметрыСклонения, ПоказыватьСообщения);
	
КонецПроцедуры

// Обработчик команды "Склонения" формы объекта склонения.
// Открывает форму редактирования склонений представления по всем падежам.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - форма объекта склонения.
//  Представление		 - Строка			 - строка для склонения.
//  ПараметрыСклонения	 - Структура		 - параметры склонения, созданные методом СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения().
//
Процедура ПоказатьСклонение(Форма, Представление, ПараметрыСклонения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуСклоненияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ЕстьПравоДоступаКОбъекту = СклонениеПредставленийОбъектовВызовСервера.ЕстьПравоДоступаКОбъекту(Форма.Параметры.Ключ);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Склонения", Форма.Склонения);
	СтруктураПараметров.Вставить("Представление", Представление);
	СтруктураПараметров.Вставить("ПараметрыСклонения", ПараметрыСклонения);
	СтруктураПараметров.Вставить("ИзмененоПредставление", Форма.ИзмененоПредставление);
	СтруктураПараметров.Вставить("ТолькоПросмотр", Не ЕстьПравоДоступаКОбъекту);
	
	ОткрытьФорму("ОбщаяФорма.Склонения", СтруктураПараметров, Форма, , , , Оповещение);
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. См. СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление.
Процедура ПриИзмененииПредставления(Форма) Экспорт
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Метод %1 более не поддерживается. 
			 |Вместо него следует использовать %2'"),
		"СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления",
		"СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление");
	ОбщегоНазначенияКлиентСервер.Проверить(Ложь, ТекстСообщения, Форма.ИмяФормы);
	
КонецПроцедуры

// Устарела. См. СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление.
// Склоняет переданную фразу по всем падежам.
//
// Параметры:
//  Форма 			- ФормаКлиентскогоПриложения - форма объекта склонения.
//  Представление   - Строка - строка для склонения.
//  ЭтоФИО       	- Булево - признак склонения ФИО.
//  Пол				- Число	- пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//  ПоказыватьСообщения - Булево - признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
Процедура ПросклонятьПредставлениеПоВсемПадежам(Форма, Представление, ЭтоФИО = Ложь, Пол = Неопределено, ПоказыватьСообщения = Ложь) Экспорт
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ПараметрыСклонения.ЭтоФИО = ЭтоФИО;
	ПараметрыСклонения.Пол = Пол;
	
	ПросклонятьПредставление(Форма, Представление, ПараметрыСклонения, ПоказыватьСообщения);
	
КонецПроцедуры

// Устарела. См. СклонениеПредставленийОбъектовКлиент.ПоказатьСклонение.
// Обработчик команды "Склонения" формы объекта склонения.
//
// Параметры:
//  Форма 			- ФормаКлиентскогоПриложения - форма объекта склонения.
//  Представление   - Строка - строка для склонения.
//  ЭтоФИО       	- Булево - признак склонения ФИО.
//  Пол				- Число	- пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//
Процедура ОбработатьКомандуСклонения(Форма, Представление, ЭтоФИО = Ложь, Пол = Неопределено) Экспорт
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ПараметрыСклонения.ЭтоФИО = ЭтоФИО;
	ПараметрыСклонения.Пол = Пол;
	
	ПоказатьСклонение(Форма, Представление, ПараметрыСклонения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПоказатьНастройкиДоступаКСервисуMorpher() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкаДоступаКСервисуMorpher");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Завершение процедуры ОбработатьКомандуСклонения.
//
Процедура ОткрытьФормуСклоненияЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Если РезультатРедактирования <> Неопределено Тогда
		Форма.Склонения = Новый ФиксированнаяСтруктура(РезультатРедактирования);
		Форма.Модифицированность = Истина;
		Форма.ИзмененоПредставление = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьСклонение(Форма, Представление, ПараметрыСклонения = Неопределено, ПоказыватьСообщения = Ложь, ОповещениеОЗавершении = Неопределено) Экспорт
	
	ДлительнаяОперация = СклонениеПредставленийОбъектовВызовСервера.ДлительнаяОперацияСклоненияПоПадежам(
		Форма.УникальныйИдентификатор, 
		Представление, 
		ПараметрыСклонения, 
		ПоказыватьСообщения);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = ПоказыватьСообщения;
	ПараметрыОжидания.ВыводитьСообщения = ПоказыватьСообщения;
	
	ПараметрыОповещения = Новый Структура(
		"Форма, 
		|ОповещениеОЗавершении,
		|ПоказыватьСообщения");
	ПараметрыОповещения.Форма = Форма;
	ПараметрыОповещения.ОповещениеОЗавершении = ОповещениеОЗавершении;
	ПараметрыОповещения.ПоказыватьСообщения = ПоказыватьСообщения;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьСклонение", ЭтотОбъект, ПараметрыОповещения);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Структура
//
Процедура ЗавершитьСклонение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		Если ДополнительныеПараметры.ПоказыватьСообщения Тогда
			СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
				Результат.ИнформацияОбОшибке);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Форма.Склонения = Неопределено;
	
	Склонения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если ТипЗнч(Склонения) = Тип("Структура") Тогда
		Форма.Склонения = Новый ФиксированнаяСтруктура(Склонения);
	КонецЕсли;
	
	Форма.ИзмененоПредставление = Ложь;
	
	Если ДополнительныеПараметры.ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти