#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем Менеджер; // ОбработкаМенеджер.ФорматДокументПредприятия
Перем ПространствоИмен; // Строка
Перем ДатаФормирования; // Дата
Перем ОшибкиЗаполнения; // Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область СтруктураДанных

// АПК:1243-выкл Отсутствует или неверно описана секция "Описание" в комментарии к экспортной процедуре (функции).

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.ИнформацияДокумента:
//   * Контрагент     - Неопределено - Значение по умолчанию
//                    - Массив Из См. СведенияОСторонахДокумента
//   * СвойстваФайлов - Неопределено - Значение по умолчанию
//                    - Массив Из сСм. НовыеСведенияОСторонахДокумента
//
Функция ИнформацияДокумента() Экспорт
	
	Если Не ЗначениеЗаполнено(ИнформацияДокумента) Тогда
		Запись = ИнформацияДокумента.Добавить();
		Запись.Контрагент     = Новый Массив;
		Запись.СвойстваФайлов = Новый Массив;
	КонецЕсли;
	
	Возврат ИнформацияДокумента[0];
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.Валюта
//
Функция НоваяВалюта() Экспорт
	
	Возврат Валюта.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.ПорядокПродления
//
Функция НовыйПорядокПродления() Экспорт
	
	Возврат ПорядокПродления.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.СоставБумажногоДокумента
//
Функция НовыйСоставБумажногоДокумента() Экспорт
	
	Возврат СоставБумажногоДокумента.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.СвойстваВидаДокумента
//
Функция НовыеСвойстваВидаДокумента() Экспорт
	
	Возврат СвойстваВидаДокумента.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.СвойстваФайлов
//
Функция НовыеСвойстваФайла() Экспорт
	
	Возврат СвойстваФайлов.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.СведенияОСторонахДокумента:
//   * ИдентификационныеСведения - Неопределено - Значение по умолчанию
//                               - см. НовыеИдентификационныеСведенияИП
//                               - см. НовыеИдентификационныеСведенияЮрЛица
//                               - см. НовыеИдентификационныеСведенияЮрЛица
//                               - см. НовыеИдентификационныеСведенияИностранногоЛица
//   * Адрес                     - Неопределено - Значение по умолчанию
//                               - см. НовыйАдресЗаПределамиРФ
//                               - см. НовыйАдресКЛАДР
//   * КонтактныеДанные          - Неопределено - Значение по умолчанию
//                               - см. НовыеКонтактныеДанные
//   * БанковскиеРеквизиты       - Неопределено - Значение по умолчанию
//                               - см. НовыеБанковскиеРеквизиты
//   * СведенияОПодписанте       - Неопределено - Значение по умолчанию
//                               - см. НовыеСведенияОПодписанте
//
Функция НовыеСведенияОСторонахДокумента() Экспорт
	
	Возврат СведенияОСторонахДокумента.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.ИдентификационныеСведенияИП
//
Функция НовыеИдентификационныеСведенияИП() Экспорт
	
	Возврат ИдентификационныеСведенияИП.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.ИдентификационныеСведенияЮрЛица
//
Функция НовыеИдентификационныеСведенияЮрЛица() Экспорт
	
	Возврат ИдентификационныеСведенияЮрЛица.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.ИдентификационныеСведенияИностранногоЛица
//
Функция НовыеИдентификационныеСведенияИностранногоЛица() Экспорт

	Возврат ИдентификационныеСведенияИностранногоЛица.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.ИдентификационныеСведенияФизЛица
//
Функция НовыеИдентификационныеСведенияФизЛица() Экспорт

	Возврат ИдентификационныеСведенияФизЛица.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.АдресЗаПределамиРФ
//
Функция НовыйАдресЗаПределамиРФ() Экспорт

	Возврат АдресЗаПределамиРФ.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.АдресКЛАДР
//
Функция НовыйАдресКЛАДР() Экспорт

	Возврат АдресКЛАДР.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.БанковскиеРеквизиты
//
Функция НовыеБанковскиеРеквизиты() Экспорт

	Возврат БанковскиеРеквизиты.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.КонтактныеДанные
//
Функция НовыеКонтактныеДанные() Экспорт

	Возврат КонтактныеДанные.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.СведенияОПодписанте
//
Функция НовыеСведенияОПодписанте() Экспорт

	Возврат СведенияОПодписанте.Добавить();
	
КонецФункции

// АПК:1243-вкл Отсутствует или неверно описана секция "Описание" в комментарии к экспортной процедуре (функции).

#КонецОбласти

#Область Перечисления

// см. Обработки.ФорматДокументПредприятия.ВидыФормДокумента
//
Функция ВидыФормДокумента() Экспорт
	
	Возврат Менеджер.ВидыФормДокумента();

КонецФункции

#КонецОбласти

#Область ЗаполнениеДанных

// Возвращает строку с автоматически заполненным адресом.
// 
// Параметры:
//  ВидКонтактнойИнформации    - СправочникСсылка.ВидыКонтактнойИнформации - отбор по виду контактной информации.
//                             - ПеречислениеСсылка.ТипыКонтактнойИнформации - отбор по типу контактной информации.
//  ОбъектКонтактнойИнформации - ОпределяемыйТип.ВладелецКонтактнойИнформации
//  ДатаАдреса                 - Дата, Неопределено - дата среза, на которую будет производиться поиск адреса
//  КонструкторЭД              - ОбработкаОбъект.ФорматДокументПредприятия
//  
// Возвращаемое значение:
//  Неопределено - В случае, если адрес не найден.
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.АдресЗаПределамиРФ - Адрес в произвольном формате.
//  ОбработкаТабличнаяЧастьСтрока.ФорматДокументПредприятия.АдресКЛАДР - Адрес в формате КЛАДР.
//
Функция ЗаполнитьАдресАвтоматически(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса,
		КонструкторЭД) Экспорт
	
	НовыйАдрес = Неопределено;
	
	Если Не ЗначениеЗаполнено(ОбъектКонтактнойИнформации) Тогда
		Возврат НовыйАдрес;
	КонецЕсли;
	
	КонтактнаяИнформация = КонтактнаяИнформацияАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса);
	
	Если ЗначениеЗаполнено(КонтактнаяИнформация) Тогда
		
		АдресЗначение = КонтактнаяИнформация[0].Значение;
		Адрес = РаботаСАдресами.СведенияОбАдресе(АдресЗначение, Новый Структура("КодыАдреса", Ложь));
		
		Если Адрес.КодСтраны = "643" Тогда // Россия
			
			АдресФорматаФНС = ИнтеграцияЭДО.АдресСоответствуетСтруктурированномуФорматуФНС(Адрес);
			
			Если АдресФорматаФНС Тогда
				
				// Заполняем структурированный адрес.
				НовыйАдрес = КонструкторЭД.НовыйАдресКЛАДР();
				
				НовыйАдрес.Индекс          = Адрес.Индекс;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "Индекс", , , ОбъектКонтактнойИнформации);
				
				НовыйАдрес.КодРегиона      = Адрес.КодРегиона;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "КодРегиона", , , ОбъектКонтактнойИнформации);
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(Адрес.Район,
					Адрес.РайонСокращение);
				НовыйАдрес.Район           = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(Адрес.Город,
					Адрес.ГородСокращение);
				НовыйАдрес.Город           = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
					Адрес.НаселенныйПункт, Адрес.НаселенныйПунктСокращение);
				НовыйАдрес.НаселенныйПункт = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(Адрес.Улица,
					Адрес.УлицаСокращение);
				НовыйАдрес.Улица           = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
					НРег(Адрес.Здание.ТипЗдания), "№", Адрес.Здание.Номер);
				НовыйАдрес.Дом             = ПредставлениеЭлемента;
				
				Если Адрес.Корпуса.Количество() Тогда
					ПредставлениеЭлемента  = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
						НРег(Адрес.Корпуса[0].ТипКорпуса), Адрес.Корпуса[0].Номер);
				Иначе
					ПредставлениеЭлемента  = "";
				КонецЕсли;
				НовыйАдрес.Корпус          = ПредставлениеЭлемента;

				Если Адрес.Помещения.Количество() Тогда
					ПредставлениеЭлемента  = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
						НРег(Адрес.Помещения[0].ТипПомещения), Адрес.Помещения[0].Номер);
				Иначе
					ПредставлениеЭлемента  = "";
				КонецЕсли;
				НовыйАдрес.Квартира        = ПредставлениеЭлемента;
				
			Иначе
				
				// Заполняем адрес в произвольной форме.
				НовыйАдрес = КонструкторЭД.НовыйАдресЗаПределамиРФ();
				
				НовыйАдрес.КодСтраны      = Адрес.КодСтраны;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "КодСтраны", , , ОбъектКонтактнойИнформации);
				
				Если Адрес.ТипАдреса = "Муниципальный" Тогда
					НовыйАдрес.Адрес      = Адрес.МуниципальноеПредставление;
				Иначе
					НовыйАдрес.Адрес      = Адрес.Представление;
				КонецЕсли;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "Адрес", , , ОбъектКонтактнойИнформации);
				
			КонецЕсли;
			
		Иначе
			
			// Заполняем адрес за пределами РФ.
			НовыйАдрес = КонструкторЭД.НовыйАдресЗаПределамиРФ();
			
			НовыйАдрес.КодСтраны      = Адрес.КодСтраны;
			КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "КодСтраны", , , ОбъектКонтактнойИнформации);
			
			НовыйАдрес.Адрес      = Адрес.Представление;
			КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "Адрес", , , ОбъектКонтактнойИнформации);
		
		КонецЕсли;

	КонецЕсли;

	Возврат НовыйАдрес;

КонецФункции

// Возвращает код страны из адреса.
// 
// Параметры:
//  ВидКонтактнойИнформации    - СправочникСсылка.ВидыКонтактнойИнформации - отбор по виду контактной информации.
//                             - ПеречислениеСсылка.ТипыКонтактнойИнформации - отбор по типу контактной информации.
//  ОбъектКонтактнойИнформации - ОпределяемыйТип.ВладелецКонтактнойИнформации
//  ДатаАдреса                 - Дата, Неопределено - дата среза, на которую будет производиться поиск адреса
//  
// Возвращаемое значение:
//  Строка - Значение кода страны.
//
Функция ЗаполнитьКодСтраныИностранногоАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса) Экспорт
	
	КодСтраны = "";
	
	Если Не ЗначениеЗаполнено(ОбъектКонтактнойИнформации) Тогда
		Возврат КодСтраны;
	КонецЕсли;
	
	КонтактнаяИнформация = КонтактнаяИнформацияАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса);
	
	Если ЗначениеЗаполнено(КонтактнаяИнформация) Тогда
		
		АдресЗначение = КонтактнаяИнформация[0].Значение;
		Адрес = РаботаСАдресами.СведенияОбАдресе(АдресЗначение, Новый Структура("КодыАдреса", Ложь));
		
		Возврат Адрес.КодСтраны;

	КонецЕсли;

	Возврат КодСтраны;

КонецФункции

// Контактная информация адреса.
//
// Параметры:
//  ВидКонтактнойИнформации    - СправочникСсылка.ВидыКонтактнойИнформации - отбор по виду контактной информации.
//                             - ПеречислениеСсылка.ТипыКонтактнойИнформации - отбор по типу контактной информации.
//  ОбъектКонтактнойИнформации - ОпределяемыйТип.ВладелецКонтактнойИнформации
//  ДатаАдреса                 - Дата, Неопределено - дата среза, на которую будет производиться поиск адреса
//
// Возвращаемое значение:
// - Неопределено 
// - См. УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта
//
Функция КонтактнаяИнформацияАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса) Экспорт
	
	ДатаАнализа = ?(ЗначениеЗаполнено(ДатаАдреса), ДатаАдреса, Неопределено);
	
	Если ТипЗнч(ВидКонтактнойИнформации) <> Тип("Массив") Тогда
		ВидыКонтактнойИнформации = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидКонтактнойИнформации);
	Иначе
		ВидыКонтактнойИнформации = ВидКонтактнойИнформации;
	КонецЕсли;
	
	КонтактнаяИнформация = Неопределено;
	Для Каждого ПроверяемыйВид Из ВидыКонтактнойИнформации Цикл 
		КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			ОбъектКонтактнойИнформации, ПроверяемыйВид, ДатаАнализа, Ложь);
			
		Если КонтактнаяИнформация.Количество() Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;

	Возврат КонтактнаяИнформация;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТекущаяИнформация = ИнформацияДокумента();
	ОшибкиЗаполнения = ОбработчикОшибок.ПроверитьЗаполнениеДанных(ТекущаяИнформация, ПроверяемыеРеквизиты);
	//Проверяет метаданные, но не простые типы.
	
	Если ЗначениеЗаполнено(ОшибкиЗаполнения) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ФормированиеЭлектронногоДокумента

// Возвращаемое значение:
//  Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Функция ПолучитьОшибкиЗаполнения() Экспорт
	Возврат ОшибкиЗаполнения;
КонецФункции

// Параметры:
//  ДополнительныеДанные - см. ФорматыЭДО.НовыеДанныеДляФормированияОсновногоТитула 
//
Процедура УстановитьДополнительныеДанныеДляФормирования(ДополнительныеДанные) Экспорт
	ДополнительныеДанныеДляФормирования = ДополнительныеДанные;
КонецПроцедуры

// Возвращаемое значение:
//  см. ФорматыЭДО.НовыеДанныеДляФормированияОсновногоТитула
//
Функция ПолучитьДополнительныеДанныеДляФормирования() Экспорт
	Возврат ДополнительныеДанныеДляФормирования;
КонецФункции

// Возвращаемое значение:
//  Строка
//
Функция ИдентификаторФайла() Экспорт
	
	ДополнительныеДанные = ПолучитьДополнительныеДанныеДляФормирования();

	ДанныеШаблона = Новый Структура;
	ДанныеШаблона.Вставить("ТипФайла", Менеджер.ПрефиксФормата());
	ДанныеШаблона.Вставить("Получатель", ДополнительныеДанные.Участники.ИдентификаторПолучателя);
	ДанныеШаблона.Вставить("Отправитель", ДополнительныеДанные.Участники.ИдентификаторОтправителя);
	ДанныеШаблона.Вставить("Дата", Формат(ДатаФормирования, "ДФ=yyyyMMdd"));

	ДанныеШаблона.Вставить("ИДФайл", ДополнительныеДанные.УникальныйИдентификатор);

	Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(
		"[ТипФайла]_[Получатель]_[Отправитель]_[Дата]_[ИДФайл]", ДанныеШаблона);

КонецФункции

// АПК:216-выкл - Встречается элемент, содержащий кириллицу и латиницу в имени согласно схеме формата.

// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//   * Файл                         - Строка
//   * Документ                     - Строка
//   * ВнешнийИдентификатор         - Строка
//   * Дата                         - Строка
//   * Номер                        - Строка
//   * Сумма                        - Строка
//   * СуммаНДС                     - Строка
//   * Валюта                       - Строка
//   * Содержание                   - Строка
//   * ДатаНачалаДействия           - Строка
//   * ДатаОкончанияДействия        - Строка
//   * ЯвляетсяБессрочным           - Строка
//   * ПорядокПродления             - Строка
//   * ФормаДокумента               - Строка
//   * Состав                       - Строка
//   * СвойстваВидаДокумента        - Строка
//   * Наименование                 - Строка
//   * Организация                  - Строка
//   * Контрагент                   - Строка
//   * СвойстваФайлов               - Строка
//   * БанковскиеРеквизитыТип       - Строка
//   * ИдентификационныеСведенияТип - Строка
//   * АдресТип                     - Строка
//   * КонтактТип                   - Строка
//   * СведенияОПодписантеТип       - Строка
//   * АдресКЛАДРТип                - Строка
//   * АдресЗаПределамиРФТип        - Строка
//   * ИПТип                        - Строка
//   * ИностранноеЛицоТип           - Строка
//   * ФизЛицоТип                   - Строка
//   * ЮРЛицоТип                    - Строка
//
Функция ТипыОбъектов() Экспорт
	
	// BSLLS:Typo-off
	Типы = Новый Структура;
	Типы.Вставить("Файл", АнонимныйТип("Файл"));
	Типы.Вставить("Документ", АнонимныйТип("Файл.Документ"));
	Типы.Вставить("ВнешнийИдентификатор", АнонимныйТип("Файл.Документ.ВнешнийИдентификатор"));
	Типы.Вставить("Дата", АнонимныйТип("Файл.Документ.Дата"));
	Типы.Вставить("Номер", АнонимныйТип("Файл.Документ.Номер"));
	Типы.Вставить("Сумма", АнонимныйТип("Файл.Документ.Сумма"));
	Типы.Вставить("СуммаНДС", АнонимныйТип("Файл.Документ.СуммаНДС"));
	Типы.Вставить("Валюта", АнонимныйТип("Файл.Документ.Валюта"));
	Типы.Вставить("Содержание", АнонимныйТип("Файл.Документ.Содержание"));
	Типы.Вставить("ДатаНачалаДействия", АнонимныйТип("Файл.Документ.ДатаНачалаДействия"));
	Типы.Вставить("ДатаОкончанияДействия", АнонимныйТип("Файл.Документ.ДатаОкончанияДействия"));
	Типы.Вставить("ЯвляетсяБесрочным", АнонимныйТип("Файл.Документ.ЯвляетсяБесрочным"));
	Типы.Вставить("ПорядокПродления", АнонимныйТип("Файл.Документ.ПорядокПродления"));
	Типы.Вставить("ФормаДокумента", АнонимныйТип("Файл.Документ.ФормаДокумента"));
	Типы.Вставить("Состав", АнонимныйТип("Файл.Документ.Состав"));
	Типы.Вставить("СвойстваВидаДокумента", АнонимныйТип("Файл.Документ.СвойстваВидаДокумента"));
	Типы.Вставить("Наименование", АнонимныйТип("Файл.Документ.Наименование"));
	Типы.Вставить("СтороныДокумента", АнонимныйТип("Файл.Документ.СтороныДокумента"));
	Типы.Вставить("СвойстваФайла", АнонимныйТип("Файл.Документ.СвойстваФайла"));
	Типы.Вставить("Организация", АнонимныйТип("Файл.Документ.СтороныДокумента.Организация"));
	Типы.Вставить("Контрагент", АнонимныйТип("Файл.Документ.СтороныДокумента.Контрагент"));
	
	Типы.Вставить("БанковскиеРеквизитыТип", "БанковскиеРеквизитыТип");
	Типы.Вставить("ИдентификационныеСведенияТип", "СторонаДокументаТип.ИдентификационныеСведения");
	Типы.Вставить("АдресТип", "АдресТип");
	Типы.Вставить("КонтактТип", "КонтактТип");
	Типы.Вставить("СведенияОПодписантеТип", "СведенияОПодписантеТип");
	
	Типы.Вставить("АдресКЛАДРТип", "АдресКЛАДРТип");
	Типы.Вставить("АдресЗаПределамиРФТип", "АдресЗаПределамиРФТип");
	
	Типы.Вставить("ЮРЛицоТип", "СторонаДокументаТип.ИдентификационныеСведения.ЮРЛицо");
	Типы.Вставить("ИностранноеЛицоТип", "СторонаДокументаТип.ИдентификационныеСведения.ИностранноеЛицо");
	Типы.Вставить("ИПТип", "СторонаДокументаТип.ИдентификационныеСведения.ИП");
	Типы.Вставить("ФизЛицоТип", "СторонаДокументаТип.ИдентификационныеСведения.ФизЛицо");
	
	Возврат Новый ФиксированнаяСтруктура(Типы);
	// BSLLS:Typo-on
	
КонецФункции

// АПК:216-вкл

// Параметры:
//  ТипОбъекта - Строка - см. ТипыОбъектов
// 
// Возвращаемое значение:
//  ОбъектXDTO
//
Функция ПолучитьXDTOОбъект(ТипОбъекта) Экспорт
	Возврат РаботаСФайламиБЭД.ПолучитьОбъектТипаCML(ТипОбъекта, ПространствоИмен);
КонецФункции

Функция СтрокиТребующиеСопоставления() Экспорт
	
	Возврат Новый Соответствие;

КонецФункции

Процедура ЗаполнитьДанныеСопоставления(СоответствиеНоменклатуры) Экспорт

КонецПроцедуры


#КонецОбласти

#Область Общее

// см. ОбработкаМенеджер.ФорматДокументПредприятия.ПространствоИмен
//
Функция ПространствоИмен() Экспорт
	Возврат Менеджер.ПространствоИмен();
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция АнонимныйТип(Тип)
	Возврат СтрШаблон("{%1}.%2", ПространствоИмен, Тип);
КонецФункции

Процедура Инициализировать()
	
	Менеджер = Обработки.ФорматДокументПредприятия;
	ПространствоИмен = ПространствоИмен();
	ДатаФормирования = ТекущаяДатаСеанса();
	ОбработчикОшибок.Инициализировать(ЭтотОбъект);
	ОшибкиЗаполнения = Новый Массив;
	
КонецПроцедуры

// см. Обработки.ФорматДоговорныйДокумент101.ТекстСправки
//
Функция ТекстСправки() Экспорт
	
	Возврат Менеджер.ТекстСправки();
	
КонецФункции

#КонецОбласти

#Область Инициализация

Инициализировать();

#КонецОбласти

#КонецЕсли
