#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимВыбораФайла = "ПечатнаяФормаДокумента";
	
	ОбъектУчета = Параметры.ОбъектУчета;
	ИдентификаторОсновногоФайла = Параметры.ИдентификаторОсновногоФайла;
	
	Если Не ЗначениеЗаполнено(ОбъектУчета) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗаполнитьСписокШаблоновДоговоров(ОбъектУчета);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьКоманда(Команда) 
	
	ОчиститьСообщения();
	
	Если РежимВыбораФайла = "СДиска" Тогда
		
		Элементы.Продолжить.Доступность = Ложь;
		Элементы.ГруппаРежимВыбора.Доступность = Ложь;
		
		ОбработчикПроверки = Новый ОписаниеОповещения("ПроверитьФайл", ЭтотОбъект, ОбъектУчета);
		ОбработчикЗавершения = Новый ОписаниеОповещения("ЗагрузитьМакетИзФайла", ЭтотОбъект, ОбъектУчета);
		
		ПараметрыЗагрузкиФайла = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
		ПараметрыЗагрузкиФайла.Диалог.Заголовок = НСтр("ru = 'Выберите XML-файл'");
		ПараметрыЗагрузкиФайла.Диалог.Фильтр = НСтр("ru = 'Файл XML (*.xml)|*.xml'");
		ПараметрыЗагрузкиФайла.ДействиеПередНачаломПомещенияФайлов = ОбработчикПроверки;
		ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикЗавершения, ПараметрыЗагрузкиФайла);
		
	ИначеЕсли РежимВыбораФайла = "ПрисоединенныйФайл" Тогда
		
		Элементы.Продолжить.Доступность = Ложь;
		Элементы.ГруппаРежимВыбора.Доступность = Ложь;
		
		ОбработчикЗавершения = Новый ОписаниеОповещения("ЗагрузитьМакетИзФайла", ЭтотОбъект, ОбъектУчета);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВладелецФайла", ОбъектУчета);
		 
		ПараметрыФормы.Вставить("РежимВыбора", Истина); 
		
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы,,,,,ОбработчикЗавершения);
		
	ИначеЕсли РежимВыбораФайла = "ПечатнаяФормаДокумента" Тогда 
		
		Если ЗначениеЗаполнено(ТекущийШаблонДоговора) Тогда
			Элементы.Продолжить.Доступность = Ложь;
			Элементы.ГруппаРежимВыбора.Доступность = Ложь;
			ДлительнаяОперация = НачатьФормированиеПечатныхФорм(ТекущийШаблонДоговора);
			Контекст = Новый Структура("ИменаМакетов", ТекущийШаблонДоговора);
			ОповещениеОЗавершении = Новый ОписаниеОповещения("ПриЗавершенииФормированияПечатныхФорм", ЭтотОбъект, Контекст);
			ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания());
		Иначе
			ОчиститьСообщения();
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Не выбран шаблон договора.'");
			Сообщение.Поле="ТекущийШаблонДоговора";
			Сообщение.ПутьКДанным = "ТекущийШаблонДоговора";
			Сообщение.Сообщить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти  

#Область СлужебныеПроцедурыИФункции

// Проверяет файл перед его добавлением.
//
// Параметры:
// 	ПомещаемыеФайлы - СсылкаНаФайл - ссылка на файл, готовый к помещению во временное хранилище.
// 	ОтказОтПомещенияФайла - Булево - признак отказа от помещения файла.
// 	ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//
&НаКлиенте
Процедура ПроверитьФайл(ПомещаемыеФайлы, ОтказОтПомещенияФайла, ДополнительныеПараметры) Экспорт
	
	Если ПомещаемыеФайлы.Файл <> Неопределено Тогда
		ОтказОтПомещенияФайла = Истина;
		ИмяФайла = ПомещаемыеФайлы.Файл.ПолноеИмя;
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
		АдресДанныхФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
		Ошибки = ПроверитьТиповыеФрагментыНаСервере(АдресДанныхФайла);
		УдалитьИзВременногоХранилища(АдресДанныхФайла);
		Если Ошибки <> Неопределено Тогда
			Элементы.Продолжить.Доступность = Истина;
			Элементы.ГруппаРежимВыбора.Доступность = Истина;
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'При формировании фрагментов произошли следующие ошибки:'"));
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Иначе
			ОтказОтПомещенияФайла = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Загружаем макет из файла MXL.
// 
// Параметры:
//  Результат - Неопределено - в случае, когда файл MXL, для отправки договорного документа по ЭДО, не выбран. 
//			  - СправочникСсылка.ДоговорыКонтрагентовПрисоединенныеФайлы - ссылка на присоединенный файл к договору с контрагентом.
//			  - Структура - структура с данными файла, в случае, когда файл не присоединен к договору с контрагентом.
//	ВыбранныйДоговор - СправочникСсылка.ДоговорыКонтрагентов - ссылка на договор с контрагентом, отправляемый по ЭДО.
//					 - Структура - данные по присоедененному файлу:
//					  * ФайлСсылка - СправочникСсылка.ДоговорыКонтрагентов - ссылка на договор с контрагентом, отправляемый по ЭДО.
//
&НаКлиенте
Процедура ЗагрузитьМакетИзФайла(Результат, ВыбранныйДоговор) Экспорт
	
	Элементы.Продолжить.Доступность = Истина;
	Элементы.ГруппаРежимВыбора.Доступность = Истина;
	
	Если Не Результат = Неопределено Тогда
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			ВыбранныйФайл = ДобавитьФайлКДоговору(ОбъектУчета, ИдентификаторОсновногоФайла, Результат.Хранение);
		Иначе
			ВыбранныйФайл = Результат;
		КонецЕсли;
		
		Ошибки = ПроверитьТиповыеФрагментыНаСервере(ВыбранныйФайл);
		
		Если Ошибки <> Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'При формировании фрагментов произошли следующие ошибки:'"));
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Иначе
			Закрыть(ВыбранныйФайл);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьФайлКДоговору(Договор, ИдентификаторОсновногоФайла, АдресДанных)
	
	ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла();
	
	ПараметрыФайла.ВладелецФайлов = Договор;
	ПараметрыФайла.Автор = Пользователи.ТекущийПользователь();
	ПараметрыФайла.ИмяБезРасширения = ИдентификаторОсновногоФайла;
	ПараметрыФайла.РасширениеБезТочки = "xml";
	ДобавленныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресДанных);
	
	Возврат ДобавленныйФайл;
	
КонецФункции

&НаСервере
Функция ПроверитьТиповыеФрагментыНаСервере(ВыбранныйФайл)
	
	Если ТипЗнч(ВыбранныйФайл) = Тип("Строка") Тогда
		ДанныеФайла = ПолучитьИзВременногоХранилища(ВыбранныйФайл);
	Иначе
		ДанныеФайла = РаботаСФайлами.ДвоичныеДанныеФайла(ВыбранныйФайл);
	КонецЕсли;
	
	ТаблицаРеквизитов = Обработки.ФорматДоговорнойДокумент101XML.ЗагрузкаXMLВТаблицуФрагментов(ДанныеФайла);
	
	Возврат Обработки.ФорматДоговорнойДокумент101XML.ПроверитьЗаполненностьТиповыхФрагментов(ТаблицаРеквизитов);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокШаблоновДоговоров(СсылкаНаДоговор) 
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		Возврат;
	КонецЕсли;
	МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
	
	СписокОбъектов = Новый Массив;
	СписокОбъектов.Добавить(СсылкаНаДоговор.Метаданные());
	
	КомандыПечати = МодульУправлениеПечатью.КомандыПечатиФормы("Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента", СписокОбъектов);
	
	Для Каждого ПечатнаяФорма Из КомандыПечати Цикл
		ШаблоныДоговоров.Добавить(ПечатнаяФорма.Идентификатор, ПечатнаяФорма.Представление);
		Элементы.ТекущийШаблонДоговора.СписокВыбора.Добавить(ПечатнаяФорма.Идентификатор, ПечатнаяФорма.Представление);
	КонецЦикла; 
		
КонецПроцедуры

&НаСервере
Функция НачатьФормированиеПечатныхФорм(ИмяМакета)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	ПараметрКоманды = Новый Массив();
	ПараметрКоманды.Добавить(ОбъектУчета); 
	
	ПараметрыПечати = Новый Структура("ИмяМакета, ОбъектыПечати");
	ПараметрыПечати.Вставить("ИмяМакета", ИмяМакета);
	ПараметрыПечати.Вставить("ОбъектыПечати", ПараметрКоманды);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "Обработки.ФорматДоговорнойДокумент101XML.СоздатьXMLВФоне", ПараметрыПечати);
	
КонецФункции

&НаСервере
Функция ПолучитьРезультатФоновогоЗадания(Результат)
	
	РезультатФоновойОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	ДанныеРезультата = Неопределено;
	ТаблицаФрагментов = РезультатФоновойОперации.ТаблицаФрагментов;
	Ошибки = РезультатФоновойОперации.Ошибки;
	Предупреждения = РезультатФоновойОперации.Предупреждения;
	ДобавленныйФайл = Неопределено;
	АдресДанныхXML = "";
	
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'При формировании фрагментов произошли следующие ошибки:'"));
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;
	
	Если Ошибки = Неопределено Тогда
		Обработки.ФорматДоговорнойДокумент101XML.ЗаполнитьСсылкуНаНомерФрагмента(ТаблицаФрагментов);
		ДвоичныеДанныеXML = Обработки.ФорматДоговорнойДокумент101XML.СформироватьXMLПоДоговору(ОбъектУчета, ТаблицаФрагментов, ИдентификаторОсновногоФайла, Ошибки);
		АдресДанныхXML = ПоместитьВоВременноеХранилище(ДвоичныеДанныеXML);
	
		Если Ошибки = Неопределено И Предупреждения = Неопределено Тогда
			ДобавленныйФайл = ДобавитьФайлКДоговору(ОбъектУчета, ИдентификаторОсновногоФайла, АдресДанныхXML);
		КонецЕсли;
	
		Если Ошибки <> Неопределено Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'При формировании XML-файла произошли следующие ошибки:'"));
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Иначе
			ДанныеРезультата = Новый Структура();
			ДанныеРезультата.Вставить("Предупреждения", Предупреждения);
			ДанныеРезультата.Вставить("ДобавленныйФайл", ДобавленныйФайл);
			ДанныеРезультата.Вставить("АдресТаблицыФрагментов", ПоместитьВоВременноеХранилище(ТаблицаФрагментов));
			ДанныеРезультата.Вставить("АдресДанныхXML", АдресДанныхXML);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеРезультата;
	
КонецФункции

&НаКлиенте
Функция ПараметрыОжидания()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ВладелецФормы);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Подготовка данных для файла XML.'");
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.Интервал = 0;
	ПараметрыОжидания.ВыводитьСообщения = Ложь;
	Возврат ПараметрыОжидания;

КонецФункции

&НаКлиенте
Процедура ПриЗавершенииФормированияПечатныхФорм(Результат, Знач Контекст) Экспорт
	
	Элементы.Продолжить.Доступность = Истина;
	Элементы.ГруппаРежимВыбора.Доступность = Истина;
	
	Если Результат <> Неопределено Тогда
		Если Результат.Статус = "Ошибка" Тогда
			ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
		КонецЕсли;
		
		ДанныеЗакрытия = ПолучитьРезультатФоновогоЗадания(Результат);
		
		Если ДанныеЗакрытия <> Неопределено Тогда
			Закрыть(ДанныеЗакрытия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 