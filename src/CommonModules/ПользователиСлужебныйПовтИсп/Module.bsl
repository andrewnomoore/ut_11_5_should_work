///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. ПользователиСлужебный.ВсеРоли
Функция ВсеРоли() Экспорт
	
	Массив = Новый Массив;
	Соответствие = Новый Соответствие;
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(256)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		ИмяРоли = Роль.Имя;
		
		Массив.Добавить(ИмяРоли);
		Соответствие.Вставить(ИмяРоли, Роль.Синоним);
		Таблица.Добавить().Имя = ИмяРоли;
	КонецЦикла;
	
	ВсеРоли = Новый Структура;
	ВсеРоли.Вставить("Массив",       Новый ФиксированныйМассив(Массив));
	ВсеРоли.Вставить("Соответствие", Новый ФиксированноеСоответствие(Соответствие));
	ВсеРоли.Вставить("Таблица",      Новый ХранилищеЗначения(Таблица));
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ВсеРоли, Ложь);
	
КонецФункции

// Возвращает роли, недоступные для указанного назначения (с учетом или без учета модели сервиса).
//
// Параметры:
//  Назначение - Строка - "ДляАдминистраторов", "ДляПользователей", "ДляВнешнихПользователей",
//                        "СовместноДляПользователейИВнешнихПользователей".
//     
//  Сервис     - Неопределено - определить текущий режим автоматически.
//             - Булево       - Ложь   - для локального режима (недоступные роли только для назначения),
//                              Истина - для модели сервиса (включая роли неразделенных пользователей).
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//   * Ключ     - Строка - имя роли.
//   * Значение - Булево - Истина.
//
Функция НедоступныеРоли(Назначение = "ДляПользователей", Сервис = Неопределено) Экспорт
	
	ПроверитьНазначение(Назначение, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка в функции %1 общего модуля %2.'"),
		"НедоступныеРоли", "ПользователиСлужебныйПовтИсп"));
	
	Если Сервис = Неопределено Тогда
		Сервис = ОбщегоНазначения.РазделениеВключено();
	КонецЕсли;
	
	НазначениеРолей = ПользователиСлужебныйПовтИсп.НазначениеРолей();
	НедоступныеРоли = Новый Соответствие;
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если (Назначение <> "ДляАдминистраторов" Или Сервис)
		   И НазначениеРолей.ТолькоДляАдминистраторовСистемы.Получить(Роль.Имя) <> Неопределено
		 // Для внешних пользователей.
		 Или Назначение = "ДляВнешнихПользователей"
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		   И НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		 // Для пользователей.
		 Или (Назначение = "ДляПользователей" Или Назначение = "ДляАдминистраторов")
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) <> Неопределено
		 // Совместно для пользователей и внешних пользователей.
		 Или Назначение = "СовместноДляПользователейИВнешнихПользователей"
		   И Не НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) <> Неопределено
		 // С учетом модели сервиса.
		 Или Сервис
		   И НазначениеРолей.ТолькоДляПользователейСистемы.Получить(Роль.Имя) <> Неопределено Тогда
			
			НедоступныеРоли.Вставить(Роль.Имя, Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(НедоступныеРоли);
	
КонецФункции

// Возвращает назначение ролей, определенное разработчиком.
// См. комментарий к процедуре ПриОпределенииНазначенияРолей общего модуля ПользователиПереопределяемый.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//   * ТолькоДляАдминистраторовСистемы - ФиксированноеСоответствие из КлючИЗначение:
//      ** Ключ     - Строка - имя роли.
//      ** Значение - Булево - Истина.
//   * ТолькоДляПользователейСистемы - ФиксированноеСоответствие из КлючИЗначение:
//      ** Ключ     - Строка - имя роли.
//      ** Значение - Булево - Истина.
//   * ТолькоДляВнешнихПользователей - ФиксированноеСоответствие из КлючИЗначение:
//      ** Ключ     - Строка - имя роли.
//      ** Значение - Булево - Истина.
//   * СовместноДляПользователейИВнешнихПользователей - ФиксированноеСоответствие из КлючИЗначение:
//      ** Ключ     - Строка - имя роли.
//      ** Значение - Булево - Истина.
//
Функция НазначениеРолей() Экспорт
	
	НазначениеРолей = Пользователи.НазначениеРолей();
	
	Назначение = Новый Структура;
	Для Каждого ОписаниеНазначенияРолей Из НазначениеРолей Цикл
		Имена = Новый Соответствие;
		Для Каждого Имя Из ОписаниеНазначенияРолей.Значение Цикл
			Роль = Метаданные.Роли.Найти(Имя);
			Если Роль = Неопределено Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Указана несуществующая роль ""%1""
					           |в процедуре %2
					           |общего модуля %3.'"),
					Имя,
					"ПриОпределенииНазначенияРолей",
					"ПользователиПереопределяемый");
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			Имена.Вставить(Роль.Имя, Истина);
		КонецЦикла;
		Назначение.Вставить(ОписаниеНазначенияРолей.Ключ, Новый ФиксированноеСоответствие(Имена));
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(Назначение);
	
КонецФункции

// См. ПользователиСлужебный.ПоляТаблицы
Функция ПоляТаблицы(Знач ПолноеИмяТаблицы) Экспорт
	
	ПоляТаблицы = ПользователиСлужебный.ПоляТаблицы(ПолноеИмяТаблицы);
	Если ПоляТаблицы = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ПоляТаблицы);
	
КонецФункции

// Возвращаемое значение:
//  Булево
//
Функция РегистрироватьИзмененияПравДоступа() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольРаботыПользователей") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МодульКонтрольРаботыПользователейСлужебный = ОбщегоНазначения.ОбщийМодуль("КонтрольРаботыПользователейСлужебный");
	
	Возврат МодульКонтрольРаботыПользователейСлужебный.РегистрироватьИзмененияПравДоступа();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. Пользователи.ЭтоСеансВнешнегоПользователя.
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
	   И СеансЗапущенБезРазделителей Тогда
		// Неразделенные пользователи не могут быть внешними.
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено, ИдентификаторПользователяИБ);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПользователяИБ", ИдентификаторПользователяИБ);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	ВнешниеПользователи.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";
	
	// Пользователь, который не найден в справочнике ВнешниеПользователи не может быть внешним.
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Настройки работы подсистемы Пользователи.
// См. также описание процедуры ПриОпределенииНастроек в общем модуле ПользователиПереопределяемый.
//
// Возвращаемое значение:
//  Структура:
//   * ОбщиеНастройкиВхода - Булево - если Ложь,
//          тогда в панели администрирования "Настройки прав и пользователей" возможность
//          открытия формы настроек входа будет скрыта, как и поле СрокДействия в карточках
//          пользователя и внешнего пользователя.
//
//   * РедактированиеРолей - Булево - если Ложь, тогда
//          интерфейс изменения ролей в карточках пользователя, внешнего пользователя и
//          группы внешних пользователей будет скрыт (в том числе для администратора).
//
//   * ФизическоеЛицоИспользуется - Булево - по умолчанию Истина. Когда Истина, тогда
//                                             отображается в карточке Пользователя.
//
//   * ПодразделениеИспользуется  - Булево - по умолчанию Истина. Когда Истина, тогда
//                                             отображается в карточке Пользователя.
//
Функция Настройки() Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("ОбщиеНастройкиВхода", Истина);
	Настройки.Вставить("РедактированиеРолей", Истина);
	Настройки.Вставить("ФизическоеЛицоИспользуется", Истина);
	Настройки.Вставить("ПодразделениеИспользуется", Истина);
	
	ИнтеграцияПодсистемБСП.ПриОпределенииНастроек(Настройки);
	ПользователиПереопределяемый.ПриОпределенииНастроек(Настройки);
	
	Если Метаданные.ОпределяемыеТипы.Подразделение.Тип.Типы().Количество() = 1
	   И Метаданные.ОпределяемыеТипы.Подразделение.Тип.Типы()[0] = Тип("Строка") Тогда
		
		Настройки.ПодразделениеИспользуется = Ложь;
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ФизическоеЛицо.Тип.Типы().Количество() = 1
	   И Метаданные.ОпределяемыеТипы.ФизическоеЛицо.Тип.Типы()[0] = Тип("Строка") Тогда
		
		Настройки.ФизическоеЛицоИспользуется = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ПользователиСервиса") Тогда
			
			МодульПользователиСервиса = ОбщегоНазначения.ОбщийМодуль("ПользователиСервиса");
			
			Настройки.Вставить("ОбщиеНастройкиВхода",
				МодульПользователиСервиса.ИспользоватьОбщиеНастройкиВходаПользователейСервиса());
			
		Иначе
			Настройки.Вставить("ОбщиеНастройкиВхода", Ложь);
		КонецЕсли;
	
	ИначеЕсли СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	      Или ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Настройки.Вставить("ОбщиеНастройкиВхода", Ложь);
		
	КонецЕсли;
	
	ВсеНастройки = Новый Структура;
	ВсеНастройки.Вставить("ОбщиеНастройкиВхода",        Настройки.ОбщиеНастройкиВхода);
	ВсеНастройки.Вставить("РедактированиеРолей",        Настройки.РедактированиеРолей);
	ВсеНастройки.Вставить("ФизическоеЛицоИспользуется", Настройки.ФизическоеЛицоИспользуется);
	ВсеНастройки.Вставить("ПодразделениеИспользуется",  Настройки.ПодразделениеИспользуется);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ВсеНастройки);
	
КонецФункции


// Возвращаемое значение:
//  Булево - одно значение для всех пользователей.
//  Неопределено - могут быть разные значения для разных пользователей.
//
Функция ПоказыватьВСпискеВыбора() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
	 Или ВнешниеПользователи.ИспользоватьВнешнихПользователей() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не Пользователи.ОбщиеНастройкиВходаИспользуются() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбщаяНастройкаПоказыватьВСпискеВыбора =
		ПользователиСлужебный.НастройкиВхода().Общие.ПоказыватьВСпискеВыбора;
	
	Если ОбщаяНастройкаПоказыватьВСпискеВыбора = "СкрытоИВключеноДляВсехПользователей" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ОбщаяНастройкаПоказыватьВСпискеВыбора = "СкрытоИВыключеноДляВсехПользователей" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает дерево ролей с подсистемами или без них.
// Если роль не принадлежит ни одной подсистеме она добавляется "в корень".
// 
// Параметры:
//  ПоПодсистемам - Булево - если Ложь, все роли добавляются в "корень".
//  Назначение    - Строка - "ДляАдминистраторов", "ДляПользователей", "ДляВнешнихПользователей",
//                           "СовместноДляПользователейИВнешнихПользователей".
// 
// Возвращаемое значение:
//  ДеревоЗначений:
//    * ЭтоРоль - Булево
//    * Имя     - Строка - имя     роли или подсистемы.
//    * Синоним - Строка - синоним роли или подсистемы.
//
Функция ДеревоРолей(ПоПодсистемам = Истина, Назначение = "ДляПользователей") Экспорт
	
	ПроверитьНазначение(Назначение, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка в функции %1 общего модуля %2.'"),
		"ДеревоРолей", "ПользователиСлужебныйПовтИсп"));
	
	НедоступныеРоли = ПользователиСлужебныйПовтИсп.НедоступныеРоли(Назначение);
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",     Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Если ПоПодсистемам Тогда
		ЗаполнитьПодсистемыИРоли(Дерево.Строки, Неопределено, НедоступныеРоли);
	КонецЕсли;
	
	// Добавление ненайденных ролей.
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено
		 Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя);
		Если Дерево.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Роль.Имя;
			СтрокаДерева.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);
	
	Возврат Новый ХранилищеЗначения(Дерево);
	
КонецФункции

// См. Пользователи.СвойстваПроверяемогоПользователяИБ
Функция СвойстваТекущегоПользователяИБ() Экспорт
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	Свойства = Новый Структура;
	Свойства.Вставить("УказанТекущийПользовательИБ", Истина);
	Свойства.Вставить("УникальныйИдентификатор", ПользовательИБ.УникальныйИдентификатор);
	Свойства.Вставить("Имя",                     ПользовательИБ.Имя);
	
	Свойства.Вставить("ПравоАдминистрирование", ?(ПривилегированныйРежим(),
		ПравоДоступа("Администрирование", Метаданные, ПользовательИБ),
		ПравоДоступа("Администрирование", Метаданные)));
	
	// АПК:336-выкл Не заменять на РолиДоступны. Это специальная проверка ролей администратора.
	
	//@skip-check using-isinrole
	Свойства.Вставить("РольДоступнаАдминистраторСистемы",
		РольДоступна(Метаданные.Роли.АдминистраторСистемы));
	
	//@skip-check using-isinrole
	Свойства.Вставить("РольДоступнаПолныеПрава",
		РольДоступна(Метаданные.Роли.ПолныеПрава));
	
	// АПК:336-вкл
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает пустые ссылки типов объектов авторизации,
// указанных в определяемом типе ВнешнийПользователь.
//
// Если в определяемом типе указан тип Строка или
// другой нессылочный тип, то он пропускается.
//
// Возвращаемое значение:
//  ФиксированныйМассив - со значениями:
//   * Значение - ЛюбаяСсылка - пустая ссылка типа объекта авторизации.
//
Функция ПустыеСсылкиТиповОбъектовАвторизации() Экспорт
	
	ПустыеСсылки = Новый Массив;
	
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ВнешнийПользователь.Тип.Типы() Цикл
		Если Не ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
			Продолжить;
		КонецЕсли;
		ОписаниеТипаСсылки = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Тип));
		ПустыеСсылки.Добавить(ОписаниеТипаСсылки.ПривестиЗначение(Неопределено));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ПустыеСсылки);
	
КонецФункции

// См. Справочники.ГруппыПользователей.СтандартнаяГруппаПользователей
Функция СтандартнаяГруппаПользователей(ИмяГруппы) Экспорт
	
	Возврат Справочники.ГруппыПользователей.СтандартнаяГруппаПользователей(ИмяГруппы);
	
КонецФункции

// Возвращает свойства видов ссылок заполненных
// в процедурах ПриЗаполненииВидовРегистрируемыхСсылок общих модулей подсистем.
//
// Используется в функции ЗарегистрированныеСсылки и процедуре ЗарегистрироватьСсылки
// общего модуля ПользователиСлужебный
//
// Возвращаемое значение:
//  ФиксированноеСоответствие из КлючИЗначение:
//   * Ключ - Строка - имя видов ссылок.
//   * Значение -  ФиксированнаяСтруктура:
//      ** ДопустимыеТипы - ОписаниеТипов
//      ** ИмяПараметраРаботыРасширений - Строка
// 
Функция СвойстваВидовСсылок() Экспорт
	
	ВидыСсылок = Новый ТаблицаЗначений;
	ВидыСсылок.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	ВидыСсылок.Колонки.Добавить("ИмяПараметраРаботыРасширений", Новый ОписаниеТипов("Строка"));
	ВидыСсылок.Колонки.Добавить("ДопустимыеТипы", Новый ОписаниеТипов("ОписаниеТипов"));
	
	ПользователиСлужебный.ПриЗаполненииВидовРегистрируемыхСсылок(ВидыСсылок);
	
	ВсеИменаПараметров = Новый Соответствие;
	
	Результат = Новый Соответствие;
	Для Каждого ВидСсылок Из ВидыСсылок Цикл
		Если Результат.Получить(ВидСсылок.Имя) <> Неопределено Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имя вида ссылок ""%1"" уже определено.'"), ВидСсылок.Имя);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		Если ВсеИменаПараметров.Получить(ВидСсылок.ИмяПараметраРаботыРасширений) <> Неопределено Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У вида ссылок ""%1"" указано уже используемое имя параметра работы расширений
				           |""%2"".'"), ВидСсылок.Имя, ВидСсылок.ИмяПараметраРаботыРасширений);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		Свойства = Новый Структура;
		Свойства.Вставить("ИмяПараметраРаботыРасширений", ВидСсылок.ИмяПараметраРаботыРасширений);
		Свойства.Вставить("ДопустимыеТипы",               ВидСсылок.ДопустимыеТипы);
		Результат.Вставить(ВидСсылок.Имя, Новый ФиксированнаяСтруктура(Свойства));
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Процедура ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева, Подсистемы, НедоступныеРоли, ВсеРоли = Неопределено)
	
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;
	
	Если ВсеРоли = Неопределено Тогда
		ВсеРоли = Новый Соответствие;
		Для Каждого Роль Из Метаданные.Роли Цикл
			
			Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено
			 Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
				Продолжить;
			КонецЕсли;
			ВсеРоли.Вставить(Роль, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Подсистема Из Подсистемы Цикл
		
		ОписаниеПодсистемы = КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя     = Подсистема.Имя;
		ОписаниеПодсистемы.Синоним = ?(ЗначениеЗаполнено(Подсистема.Синоним), Подсистема.Синоним, Подсистема.Имя);
		
		ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы, НедоступныеРоли, ВсеРоли);
		
		Для Каждого ОбъектМетаданных Из Подсистема.Состав Цикл
			Если ВсеРоли[ОбъектМетаданных] = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Роль = ОбъектМетаданных;
			ОписаниеРоли = ОписаниеПодсистемы.Строки.Добавить();
			ОписаниеРоли.ЭтоРоль = Истина;
			ОписаниеРоли.Имя     = Роль.Имя;
			ОписаниеРоли.Синоним = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЦикла;
		
		Отбор = Новый Структура("ЭтоРоль", Истина);
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьНазначение(Назначение, ЗаголовокОшибки)
	
	Если Назначение <> "ДляАдминистраторов"
	   И Назначение <> "ДляПользователей"
	   И Назначение <> "ДляВнешнихПользователей"
	   И Назначение <> "СовместноДляПользователейИВнешнихПользователей" Тогда
		
		ТекстОшибки = ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Параметр %1 ""%2"" указан некорректно.
			           |
			           |Допустимы только следующие значения:
			           |- ""%3"",
			           |- ""%4"",
			           |- ""%5"",
			           |- ""%6"".'"),
			"Назначение",
			Назначение,
			"ДляАдминистраторов",
			"ДляПользователей",
			"ДляВнешнихПользователей",
			"СовместноДляПользователейИВнешнихПользователей");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
