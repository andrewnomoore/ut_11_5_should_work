///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Если НЕ МобильныйАвтономныйСервер Тогда

#Область ОписаниеПеременных

// Значения объекта до записи для использования в обработчике события ПриЗаписи.
Перем ЭтоНовый;
Перем ПараметрыОбработкиПользователяИБ; // Параметры, заполняемые при обработке пользователя ИБ.

#КонецОбласти

// *Область ПрограммныйИнтерфейс.
//
// Программный интерфейс объекта реализован через ДополнительныеСвойства:
//
// ОписаниеПользователяИБ - Структура со свойствами:
//   Действие - Строка - "Записать" или "Удалить".
//      1. Если Действие = "Удалить" другие свойства не требуются. Удаление
//      будет считаться успешным и в том случае, когда пользовательИБ
//      не найден по значению реквизита ИдентификаторПользователяИБ.
//      2. Если Действие = "Записать", тогда будет создан или обновлен
//      пользователь ИБ по указанным свойствам. Чтобы пользователь не создавался,
//      когда не найден, нужно вставить в структуру свойство "ТолькоОбновитьПользователяИБ".
//
//   ВходВПрограммуРазрешен - Неопределено - вычислить автоматически:
//                            если вход в программу запрещен, тогда остается запрещен,
//                            иначе остается разрешен, кроме случая, когда
//                            все виды аутентификации установлены в Ложь.
//                          - Булево - если Истина, тогда установить аутентификацию, как
//                            указана или сохранена в значениях одноименных реквизитов;
//                            если Ложь, тогда снять все виды аутентификации у пользователя ИБ.
//                            Если свойство не указано - прямая установка сохраняемых и
//                            действующих видов аутентификации (для поддержки обратной совместимости).
//
//   ПотребоватьСменуПароляПриВходе - Булево - изменяет одноименный флажок карточки пользователя.
//                                  - Неопределено - флажок не изменяется (аналогично,
//                                        если свойство не указано).
//
//   АутентификацияСтандартная, АутентификацияOpenID, АутентификацияOpenIDConnect,
//   АутентификацияТокеномДоступа, АутентификацияОС - установить сохраняемые значения
//      видов аутентификации и действующие значения видов аутентификации
//      в зависимости от использования свойства ВходВПрограммуРазрешен.
// 
//   Остальные свойства.
//      Состав остальных свойств указывается аналогично составу свойств параметра.
//      ОбновляемыеСвойства для процедуры Пользователи.УстановитьСвойстваПользователяИБ(),
//      кроме свойства ПолноеИмя - устанавливается по Наименованию.
//
//      Для сопоставления существующего свободного пользователя ИБ с пользователем в справочнике,
//      с которым не сопоставлен другой существующий пользователь ИБ, нужно вставить свойство.
//      УникальныйИдентификатор. Если указать идентификатор пользователя ИБ, который
//      сопоставлен с текущим пользователем, ничего не изменится.
//
//   При выполнении действий "Записать" и "Удалить" реквизит ИдентификаторПользователяИБ
//   объекта обновляется автоматически, его не следует изменять.
//
//   После выполнения действия в структуру вставляются (обновляются) следующие свойства:
//   - РезультатДействия - Строка, содержащая одно из значений:
//      - когда действие "Записать": "ДобавленПользовательИБ", "ИзмененПользовательИБ", "УдаленПользовательИБ" и
 //         если вставлено свойство "ТолькоОбновитьПользователяИБ" может быть "ПропущеноДобавлениеПользователяИБ".
//      - когда действие "Удалить": "ОчищеноСопоставлениеСНесуществующимПользователемИБ",
//          "НеТребуетсяУдалениеПользовательИБ"
//   - УникальныйИдентификатор - УникальныйИдентификатор пользователя ИБ.
//
//   ОписаниеПользователяИБ обрабатывается в режиме ОбменДанными.Загрузка = Истина.
//
// СозданиеАдминистратора - Строка - свойство должно быть вставлено с непустой строкой,
//   чтобы вызвать событие ПриСозданииАдминистратора после обработки структуры ОписаниеПользователяИБ
//   когда у созданного или измененного пользователя ИБ имеются роли администратора.
//   Это нужно, чтобы сделать связанные действия при создании администратора, например,
//   автоматически добавить пользователя в группу доступа Администраторы.
//
// *КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после обработки пользователя ИБ, когда требуется.
	ПользователиСлужебный.ПользовательОбъектПередЗаписью(ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	// АПК:75-вкл
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после блокировки регистра.
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		// Установка сразу исключительной блокировки на регистры вместо установки
		// разделяемой блокировки автоматически при чтении, которая приводит
		// к взаимоблокировке при обновлении составов групп пользователей.
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("РегистрСведений.ИерархияГруппПользователей");
		Блокировка.Добавить("РегистрСведений.СоставыГруппПользователей");
		Блокировка.Добавить("РегистрСведений.СведенияОПользователях");
		Блокировка.Заблокировать();
	КонецЕсли;
	// АПК:75-вкл
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после обработки пользователя ИБ, когда требуется.
	Если ОбменДанными.Загрузка И ПараметрыОбработкиПользователяИБ <> Неопределено Тогда
		ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(
			ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	КонецЕсли;
	// АПК:75-вкл
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ГруппаНовогоПользователя")
		И ЗначениеЗаполнено(ДополнительныеСвойства.ГруппаНовогоПользователя) Тогда
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ГруппыПользователей");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ДополнительныеСвойства.ГруппаНовогоПользователя);
		Блокировка.Заблокировать();
		
		ОбъектГруппы = ДополнительныеСвойства.ГруппаНовогоПользователя.ПолучитьОбъект(); // СправочникОбъект.ГруппыПользователей
		ОбъектГруппы.Состав.Добавить().Пользователь = Ссылка;
		ОбъектГруппы.Записать();
	КонецЕсли;
	
	// Обновление состава автоматической группы "Все пользователи".
	ИзмененияСоставов = ПользователиСлужебный.НовыеИзмененияСоставовГрупп();
	ПользователиСлужебный.ОбновитьИспользуемостьСоставовГруппПользователей(Ссылка, ИзмененияСоставов);
	ПользователиСлужебный.ОбновитьСоставГруппыВсеПользователи(Ссылка, ИзмененияСоставов);
	
	ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(ЭтотОбъект,
		ПараметрыОбработкиПользователяИБ);
	
	ПользователиСлужебный.ПослеОбновленияСоставовГруппПользователей(ИзмененияСоставов);
	
	ИнтеграцияПодсистемБСП.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	
	Если ЭтоНовый 
		//++ НЕ ГОСИС
		И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоступом") И ПолучитьФункциональнуюОпцию("БазоваяВерсия") 
		//-- НЕ ГОСИС
		Тогда
	 
		// При добавлении нового пользователя запишем его в группу Администраторы
	 	Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДоступаПользователи.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|ГДЕ
		|	ГруппыДоступаПользователи.Ссылка = ЗНАЧЕНИЕ(Справочник.ГруппыДоступа.Администраторы)
		|	И ГруппыДоступаПользователи.Пользователь = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Если Запрос.Выполнить().Пустой() Тогда
			
			ГруппаАдминистраторы = Справочники.ГруппыДоступа.Администраторы.ПолучитьОбъект();
			НовыйАдминистратор   = ГруппаАдминистраторы.Пользователи.Добавить();
			
			НовыйАдминистратор.Пользователь = Ссылка;
			
			ГруппаАдминистраторы.Записать();
			
		КонецЕсли;
		
 	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после обработки пользователя ИБ, когда требуется.
	ПользователиСлужебный.ПользовательОбъектПередУдалением(ЭтотОбъект);
	// АПК:75-вкл
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПользователиСлужебный.ОбновитьСоставыГруппПередУдалениемПользователяИлиГруппы(Ссылка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДополнительныеСвойства.Вставить("ЗначениеКопирования", ОбъектКопирования.Ссылка);
	
	ИдентификаторПользователяИБ = Неопределено;
	ИдентификаторПользователяСервиса = Неопределено;
	Подготовлен = Ложь;
	
	Свойства = Новый Структура("КонтактнаяИнформация");
	ЗаполнитьЗначенияСвойств(Свойства, ЭтотОбъект);
	Если Свойства.КонтактнаяИнформация <> Неопределено Тогда
		Свойства.КонтактнаяИнформация.Очистить();
	КонецЕсли;
	
	Комментарий = "";
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли