////////////////////////////////////////////////////////////////////////////////
//
// ЗатратыСервер: Распределение производственных затрат и затрат незавершенного производства.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура проверяет дату документа на соответствие дате перехода на партионный учет версии 2.2.
// Проверка выполняется для документов нового производства.
//
// Параметры:
//	Объект - ДокументОбъект.ЭтапПроизводства2_2, ДокументОбъект.ДвижениеПродукцииИМатериалов - проверяемый документ,
//	Дата - Дата - дата, на которую выполняется проверка,
//	Отказ - Булево - устанавливается в ИСТИНА, если дата перехода на новый партионный учет больше переданной даты.
//
Процедура ПроверитьИспользованиеПартионногоУчета22(Объект, Дата, Отказ) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия")
		И (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеНедостачЗаСчетКомитента
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеИзлишковТоваровВПользуКомитента) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаПереходаНаПартионныйУчетВерсии22 = РасчетСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22();
	
	ТекстОшибки = Неопределено;
	
	Если НЕ РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22() Тогда
		
		ТекстОшибки = НСтр("ru='Для операций, доступных с версии 2.2, требуется установить соответствующий режим партионного учета.'");
		
	ИначеЕсли ДатаПереходаНаПартионныйУчетВерсии22 > НачалоМесяца(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Регистрация операций, доступных с версии 2.2, раньше даты перехода на партионный учет версии 2.2 недоступна.
								|Требуется изменить дату операции (%1) или дату перехода на партионный учет 2.2 (%2).'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстОшибки,
			Формат(Дата, "ДЛФ=D"),
			Формат(ДатаПереходаНаПартионныйУчетВерсии22, "ДЛФ=D"));
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры


// Добавляет отбор в набор данных схемы компоновки данных по переданным ресурсам.
// 
// Параметры:
// 	Ресурсы - Массив из Строка - имена ресурсов, на которые необходимо наложить отбор на "<> 0".
// 	НаборДанных - НаборДанныхЗапросМакетаКомпоновкиДанных  - корректируемый набор данных. 
Процедура ДобавитьОтборПоВыбраннымРесурсам(Ресурсы, НаборДанных) Экспорт
	
	Если СтрНайти(НаборДанных.Запрос, "ИМЕЮЩИЕ") > 0 Тогда
		// в запросе уже есть отбор
		Возврат;
	КонецЕсли;
	
	НачалоЗапроса = "
	|ИМЕЮЩИЕ
	|	СУММА(%1) <> 0";
	
	ШаблонРесурса = "
	|	ИЛИ СУММА(%1) <> 0";
	
	ТекстОтбора = "";

	Для Каждого ОписаниеПоля Из НаборДанных.Поля Цикл
		Если Ресурсы.Найти(ОписаниеПоля.Имя) <> Неопределено Тогда
			
			Если ТекстОтбора = "" Тогда
				ТекстОтбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НачалоЗапроса, ОписаниеПоля.Имя);
			Иначе
				ТекстОтбора = ТекстОтбора + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонРесурса, ОписаниеПоля.Имя);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	ПозицияУпорядочить = СтрНайти(НаборДанных.Запрос, "УПОРЯДОЧИТЬ", НаправлениеПоиска.СКонца);
	Если ПозицияУпорядочить > 0 Тогда
		НаборДанных.Запрос = Лев(НаборДанных.Запрос, ПозицияУпорядочить - 1) + ТекстОтбора + Символы.ПС + Сред(НаборДанных.Запрос, ПозицияУпорядочить);
	Иначе
		НаборДанных.Запрос = НаборДанных.Запрос + ТекстОтбора;
	КонецЕсли;
		
КонецПроцедуры

// Обрабатывает объекты Справочник.ПравилаРаспределенияРасходов и Документ.РаспределениеПрочихЗатрат при обновлении ИБ.
// Параметры:
//	Объект - СправочникОбъект.ПравилаРаспределенияРасходов, ДокументОбъект.РаспределениеПрочихЗатрат - объект для обновления.
//	МакетыБазРаспределений - Соответствие из КлючИЗначение- макеты баз распределения по имена базы распределения:
//		* Ключ - Строка - упрощенное имя базы распределения (материалы, продукция и т.д.).
//		* Значение - СхемаКомпоновкиДанных - схема на основании которой будут заполняться настройки.
Процедура ОбработатьЗаполнениеНастроекКомпоновки(Объект, МакетыБазРаспределений) Экспорт

	Если Объект.НастройкиНаправленияРаспределенияИзменены ИЛИ Объект.НастройкиБазыРаспределенияПоПартиямИзменены Тогда
		// Объекты уже обработаны
		Возврат;
	КонецЕсли;

	ТабличныеЧастиКОбработке = Новый Соответствие;
	ТабличныеЧастиКОбработке.Вставить("ОтборПоГруппамПродукции", "ГруппаПродукции");
	ТабличныеЧастиКОбработке.Вставить("ОтборПоМатериалам", "Материал");
	ТабличныеЧастиКОбработке.Вставить("ОтборПоВидамРабот", "ВидРабот");
	ТабличныеЧастиКОбработке.Вставить("ОтборПоПродукции", "Продукция");

	РеквизитНазначения = "НазначениеНастройкиРаспределения";
	Если ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ПравилаРаспределенияРасходов") Тогда
		РеквизитНазначения = "НазначениеПравила";
	КонецЕсли;
	
	Если Объект[РеквизитНазначения]= Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства
		И Не Объект.НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.ПустаяСсылка() Тогда
		
		НастройкиПоУмолчанию = МакетыБазРаспределений["НаправлениеРаспределения"].НастройкиПоУмолчанию; // НастройкиКомпоновкиДанных
		НастройкиПоУмолчанию.Отбор.Элементы.Очистить();
		
		ОтборПоПодразделению = НастройкиПоУмолчанию.Отбор.Элементы.Добавить(
			Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоПодразделению.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
		
		Если Объект.НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Текущее
			И ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.РаспределениеПрочихЗатрат") Тогда
			
			ОтборПоПодразделению.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ТекущееПодразделение");
			ОтборПоПодразделению.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Объект.НастройкиНаправленияРаспределенияИзменены = Истина;
				
		ИначеЕсли Объект.НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Вышестоящее
			И ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.РаспределениеПрочихЗатрат") Тогда
			
			ОтборПоПодразделению.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ВышестоящееПодразделение");
			ОтборПоПодразделению.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Объект.НастройкиНаправленияРаспределенияИзменены = Истина;
				
		ИначеЕсли Объект.НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Нижестоящие
			И ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.РаспределениеПрочихЗатрат") Тогда
			
			ОтборПоПодразделению.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ТекущееПодразделение");
			ОтборПоПодразделению.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			
			ОтборПоПодразделениюНеРавно = НастройкиПоУмолчанию.Отбор.Элементы.Добавить(
				Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборПоПодразделениюНеРавно.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
			ОтборПоПодразделениюНеРавно.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
			ОтборПоПодразделениюНеРавно.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ТекущееПодразделение");
			
			Объект.НастройкиНаправленияРаспределенияИзменены = Истина;
			
		ИначеЕсли Объект.НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Указанные Тогда
			
			СписокПодразделений = Новый СписокЗначений();
			СписокПодразделений.ЗагрузитьЗначения(
				Объект.ОтборПоПодразделениям.ВыгрузитьКолонку("Подразделение"));
			ОтборПоПодразделению.ПравоеЗначение = СписокПодразделений;
			ОтборПоПодразделению.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Объект.НастройкиНаправленияРаспределенияИзменены = Истина;

		КонецЕсли;

		Если Объект.НастройкиНаправленияРаспределенияИзменены Тогда
			ОтборПоПодразделению.Использование = Истина;
			Объект.НастройкиНаправленияРаспределения = Новый ХранилищеЗначения(НастройкиПоУмолчанию);
		КонецЕсли;
	
	КонецЕсли;

	ИмяСхемы = Перечисления.ТипыБазыРаспределенияРасходов.ИмяСхемыБазыРаспределения(Объект.БазаРаспределенияПоПартиям);
	Если ПустаяСтрока(ИмяСхемы) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиПоУмолчанию = МакетыБазРаспределений[ИмяСхемы].НастройкиПоУмолчанию; // НастройкиКомпоновкиДанных
	НастройкиПоУмолчанию.Отбор.Элементы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Т.Ссылка КАК Материал,
		|	Т.ЭтоГруппа КАК ЭтоГруппа
		|ИЗ
		|	Справочник.Номенклатура КАК Т
		|ГДЕ
		|	Т.Ссылка В (&СписокМатериалов)";
	Запрос.УстановитьПараметр("СписокМатериалов", Объект.ОтборПоМатериалам.ВыгрузитьКолонку("Материал"));
	
	Для Каждого КлючИЗначение Из ТабличныеЧастиКОбработке Цикл
		
		Если Объект[КлючИЗначение.Ключ].Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Объект.НастройкиБазыРаспределенияПоПартиямИзменены = Истина;
		
		ЭлементыОтбора = Новый СписокЗначений;
		ГруппыОтбора = Новый СписокЗначений;
		
		Если КлючИЗначение.Ключ = "ОтборПоМатериалам" Тогда
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Если Выборка.ЭтоГруппа Тогда
					ГруппыОтбора.Добавить(Выборка.Материал);
				Иначе
					ЭлементыОтбора.Добавить(Выборка.Материал);
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			ЭлементыОтбора.ЗагрузитьЗначения(Объект[КлючИЗначение.Ключ].ВыгрузитьКолонку(КлючИЗначение.Значение));
		КонецЕсли;
		
		Отбор = Неопределено;
		Если ГруппыОтбора.Количество() = 0 Тогда
			
			Отбор = НастройкиПоУмолчанию.Отбор.Элементы.Добавить(
				Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(КлючИЗначение.Значение);
			Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Отбор.ПравоеЗначение = ЭлементыОтбора;
		
		Иначе
			
			ГруппаЭлементовОтбора = НастройкиПоУмолчанию.Отбор.Элементы.Добавить(
					Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаЭлементовОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
			
			ЭлементОтбораДляГрупп = ГруппаЭлементовОтбора.Элементы.Добавить(
				Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДляГрупп.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(КлючИЗначение.Значение);
			ЭлементОтбораДляГрупп.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			ЭлементОтбораДляГрупп.ПравоеЗначение = ГруппыОтбора;
				
			ЭлементОтбораДляЭлементов = ГруппаЭлементовОтбора.Элементы.Добавить(
				Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДляЭлементов.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(КлючИЗначение.Значение);
			ЭлементОтбораДляЭлементов.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбораДляЭлементов.ПравоеЗначение = ЭлементыОтбора;
			
		КонецЕсли;
		
	КонецЦикла;

	Если Объект.НастройкиБазыРаспределенияПоПартиямИзменены Тогда
		Объект.НастройкиБазыРаспределенияПоПартиям = Новый ХранилищеЗначения(НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиЭтаповЗакрытияМесяца


#Область НастройкаРаспределенияРасходов

// Добавляет этап в таблицу этапов закрытия месяца.
// Элементы данной таблицы являются элементами второго уровня в дереве этапов в форме закрытия месяца.
// 
// Параметры:
// 	ТаблицаЭтапов - см. Обработки.ОперацииЗакрытияМесяца.ЗаполнитьОписаниеЭтаповЗакрытияМесяца
// 	ТекущийРодитель - Строка - идентификатор группы.
Процедура ДобавитьЭтап_НастройкаРаспределенияРасходов(ТаблицаЭтапов,ТекущийРодитель) Экспорт
	НоваяСтрока = ЗакрытиеМесяцаСервер.ДобавитьЭтапВТаблицу(ТаблицаЭтапов, ТекущийРодитель,
		Перечисления.ОперацииЗакрытияМесяца.НастройкаРаспределенияРасходов);
	НоваяСтрока.ТекстВыполнить = НСтр("ru='Выполнить'");
	НоваяСтрока.ТекстПодробнее = ЗакрытиеМесяцаСервер.ТекстПодробнееПоУмолчанию();
	НоваяСтрока.ДействиеИспользование = ЗакрытиеМесяцаСервер.ОписаниеДействия_СервернаяПроцедура(
		"ЗатратыСервер.Использование_НастройкаРаспределенияРасходов");
	НоваяСтрока.ДействиеВыполнить  = ЗакрытиеМесяцаСервер.ОписаниеДействия_ВыполнитьРасчет(
		"ЗатратыСервер.Выполнить_НастройкаРаспределенияРасходов");
	НоваяСтрока.ДействиеПодробнее = ЗакрытиеМесяцаСервер.ОписаниеДействия_ОткрытьФорму(
		Метаданные.Документы.РаспределениеПрочихЗатрат.Формы.ФормаРабочееМесто.ПолноеИмя());
	// Доп. параметры формы.
	НоваяСтрока.ДействиеПодробнее.ПараметрыФормы.Вставить("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
	НоваяСтрока.ДействиеПодробнее.ПараметрыФормы.Вставить("Состояние", Перечисления.СостоянияРаспределенияРасходов.ТребуетсяСформироватьДокумент);
	НоваяСтрока.ВыполняетсяПриПредварительномЗакрытииМесяца = Истина;
КонецПроцедуры

// Обработчики этапа.

Процедура Использование_НастройкаРаспределенияРасходов(ПараметрыОбработчика) Экспорт
	
	Запрос = Новый Запрос;
	ЗакрытиеМесяцаСервер.ИнициализироватьЗапрос(Запрос, ПараметрыОбработчика);
	
	ВариантыРаспределения = Новый Массив();
	Если РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(ПараметрыОбработчика.ПараметрыРасчета.ПериодРегистрации)
	 И (ЗакрытиеМесяцаСервер.ОбщиеПараметрыЗакрытияМесяца().РаспределениеДопРасходовМеждуПартиямиИТоварами
	 	ИЛИ ПараметрыОбработчика.ПараметрыРасчета.РежимЗакрытияМесяца <> Перечисления.РежимыЗакрытияМесяца.ПредварительноеЗакрытие) Тогда
		ВариантыРаспределения.Добавить(Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров);
	КонецЕсли;
	
	Если ВариантыРаспределения.Количество() = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Нет данных для распределения расходов.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		Возврат;
	
	КонецЕсли;

	ПараметрыЗапроса = Документы.РаспределениеПрочихЗатрат.ОписаниеПараметровЗапросаПолученияДанныхДляРаспределения();
	ПараметрыЗапроса.Состояние = Перечисления.СостоянияРаспределенияРасходов.ТребуетсяСформироватьДокумент;
	ПараметрыЗапроса.ВариантРаспределения = ВариантыРаспределения;
	ПараметрыЗапроса.ИсключитьТранспортныеРасходы = Истина;
	Документы.РаспределениеПрочихЗатрат.ИнициализироватьЗапросПолученияДанныхДляРаспределения(Запрос, ПараметрыЗапроса);
	
	Запрос.Текст = Документы.РаспределениеПрочихЗатрат.ТекстЗапросаДанныеДляРаспределения(, Истина);
	
	Запрос.Выполнить();	
	
	РазмерыВременныхТаблиц = ЗакрытиеМесяцаСервер.РазмерыВременныхТаблиц(Запрос, ПараметрыОбработчика);
	
	Если РазмерыВременныхТаблиц.ВТДанныеДляРаспределения = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Нет данных для распределения расходов.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		Возврат;
		
	КонецЕсли;
	
	Если РазмерыВременныхТаблиц.СостояниеРаспределенияРасходов = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Все расходы полностью распределены.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Выполнить_НастройкаРаспределенияРасходов(ПараметрыОбработчика) Экспорт
	
	ПараметрыРасчета = ПараметрыОбработчика.ПараметрыРасчета;
	
	ВариантыРаспределения = Новый Массив;
	Если РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(ПараметрыРасчета.ПериодРегистрации) Тогда
		ВариантыРаспределения.Добавить(Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров);
	КонецЕсли;
	
	Если ВариантыРаспределения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	СтатьиКРаспределению = Документы.РаспределениеПрочихЗатрат.СтатьиКРаспределению(
		ПараметрыРасчета.ПериодРегистрации,
		ПараметрыРасчета.МассивОрганизаций,
		Новый Массив,
		Перечисления.СостоянияРаспределенияРасходов.ТребуетсяСформироватьДокумент,
		ВариантыРаспределения);
		
	Если СтатьиКРаспределению.Количество() = 0 Тогда // нет данных для распределения
		Возврат;
	КонецЕсли;
	
	СтатьиКРаспределению.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	СтатьиКРаспределению.Колонки.Добавить("ИДСтроки", Новый ОписаниеТипов("Число"));
	СтатьиКРаспределению.ЗаполнитьЗначения(КонецМесяца(ПараметрыРасчета.ПериодРегистрации), "Дата");
	
	ПараметрыРаспределения = Новый Структура("ПараметрыРасходов", СтатьиКРаспределению);
	ПараметрыРаспределения.Вставить("МассивОрганизаций", ПараметрыРасчета.МассивОрганизаций);
	ПараметрыРаспределения.Вставить("ПериодРегистрации", ПараметрыРасчета.ПериодРегистрации);
	
	// Формирование документов распределения так же выполняется в процедуре РасчетСебестоимости.РассчитатьПредварительнуюСебестоимость().
	// При изменении процедуры Выполнить_НастройкаРаспределенияРасходов() нужно проверить код в РасчетСебестоимости.РассчитатьПредварительнуюСебестоимость().
	
	Попытка
		РезультатыФормирования = Документы.РаспределениеПрочихЗатрат.СформироватьДокументы(ПараметрыРаспределения, Неопределено);
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось создать документы распределения за период %1. Необходимость возникла из-за ошибки:
				|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			РасчетСебестоимостиПротоколРасчета.ПредставлениеПериодаРасчета(ПараметрыРасчета.ПериодРегистрации),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗакрытиеМесяцаСервер.ЗафиксироватьНаличиеПроблемыПриВыполненииРасчета(
			ПараметрыОбработчика,
			ТекстОшибки);
		
	КонецПопытки;
	
	Для Каждого РезультатПоОрганизации Из РезультатыФормирования Цикл
		
		ДетализацияФормирования = РезультатПоОрганизации.Значение;
		
		Если Не ДетализацияФормирования.ОписаниеОшибок.Количество() Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ОписаниеОшибки Из ДетализацияФормирования.ОписаниеОшибок Цикл
			ЗакрытиеМесяцаСервер.ЗафиксироватьНаличиеПроблемыПриВыполненииРасчета(
				ПараметрыОбработчика,
				ОписаниеОшибки.ТекстОшибки,
				РезультатПоОрганизации.Ключ,
				,
				,
				ОписаниеОшибки.СтатьяРасходов);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Проверки состояния системы, относящиеся к этапу.

Процедура ОписаниеПроверок_НастройкаРаспределенияРасходов(ТаблицаПроверок) Экспорт
	
	// Настройка распределения расходов.
	ОписаниеПроверки = ЗакрытиеМесяцаСервер.ДобавитьОписаниеНовойПроверки(ТаблицаПроверок,
		"НеВыполненаНастройкаРаспределенияРасходов",
		Перечисления.ОперацииЗакрытияМесяца.НастройкаРаспределенияРасходов,
		Перечисления.МоментЗапускаПроверкиОперацииЗакрытияМесяца.ДоИПослеРасчета,
		"ЗатратыСервер.ПроверкаНеобходимостиНастройкиРаспределенияРасходов");
	
	ЗакрытиеМесяцаСервер.ЗаполнитьПредставлениеНовойПроверки(ОписаниеПроверки,
		НСтр("ru='Не выполненные настройки распределения расходов'", ОбщегоНазначения.КодОсновногоЯзыка()),
		НСтр("ru='Все расходы должны быть распределены.'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
КонецПроцедуры

// Проверка необходимости настройки распределения расходов.
//
// Параметры:
//	ПараметрыПроверки - см. АудитСостоянияСистемы.ИнициализироватьПараметрыПроверки
//
Процедура ПроверкаНеобходимостиНастройкиРаспределенияРасходов(ПараметрыПроверки) Экспорт
	
	Если НЕ ЗакрытиеМесяцаСервер.ПроверкаВыполняетсяМеханизмомЗакрытияМесяца(ПараметрыПроверки) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПроверки.ДополнительныеПараметры.АвтоматическоеТестирование Тогда
		Возврат;
	КонецЕсли;
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить("Организация", 			НСтр("ru='Организация'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("Подразделение", 			НСтр("ru='Подразделение'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("НаправлениеДеятельности", НСтр("ru='Направление деятельности'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("СтатьяРасходов", 			НСтр("ru='Статья расходов'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("АналитикаРасходов", 		НСтр("ru='Аналитика расходов'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	ПараметрыРегистрации = ЗакрытиеМесяцаСервер.ИнициализироватьПараметрыРегистрацииПроблемПроверки(
		"СостояниеРаспределенияРасходов",
		НСтр("ru='Требуется сформировать документы распределения расходов по организации ""%1"" в периоде %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
		СписокПолей);
	
	ЗакрытиеМесяцаСервер.ЗарегистрироватьПроблемыВыполненияПроверки(
	 	ПараметрыПроверки,
		ПараметрыРегистрации);
		
КонецПроцедуры

#КонецОбласти

#Область НастройкаРаспределенияРасходовВручную

// Добавляет этап в таблицу этапов закрытия месяца.
// Элементы данной таблицы являются элементами второго уровня в дереве этапов в форме закрытия месяца.
// 
// Параметры:
// 	ТаблицаЭтапов - см. Обработки.ОперацииЗакрытияМесяца.ЗаполнитьОписаниеЭтаповЗакрытияМесяца
// 	ТекущийРодитель - Строка - идентификатор группы.
Процедура ДобавитьЭтап_НастройкаРаспределенияРасходовВручную(ТаблицаЭтапов,ТекущийРодитель) Экспорт
	НоваяСтрока = ЗакрытиеМесяцаСервер.ДобавитьЭтапВТаблицу(ТаблицаЭтапов, ТекущийРодитель,
		Перечисления.ОперацииЗакрытияМесяца.НастройкаРаспределенияРасходовВручную);
	НоваяСтрока.ВыполняетсяВручную = Истина;
	НоваяСтрока.ТекстВыполнить = НСтр("ru='Ввести'");
	НоваяСтрока.ТекстПодробнее = ЗакрытиеМесяцаСервер.ТекстПодробнееПоУмолчанию();
	НоваяСтрока.ДействиеИспользование = ЗакрытиеМесяцаСервер.ОписаниеДействия_СервернаяПроцедура(
		"ЗатратыСервер.Использование_НастройкаРаспределенияРасходовВручную");
	НоваяСтрока.ДействиеВыполнить = ЗакрытиеМесяцаСервер.ОписаниеДействия_ОткрытьФорму(
		Метаданные.Документы.РаспределениеПрочихЗатрат.Формы.ФормаРабочееМесто.ПолноеИмя());
	// Доп. параметры формы.
	НоваяСтрока.ДействиеВыполнить.ПараметрыФормы.Вставить("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
	НоваяСтрока.ДействиеВыполнить.ПараметрыФормы.Вставить("Состояние", Перечисления.СостоянияРаспределенияРасходов.ТребуетсяРучнойВводДокумента);

	НоваяСтрока.ДействиеПодробнее = ЗакрытиеМесяцаСервер.ОписаниеДействия_ОткрытьФорму(
		Метаданные.Документы.РаспределениеПрочихЗатрат.Формы.ФормаРабочееМесто.ПолноеИмя());
	// Доп. параметры формы.
	НоваяСтрока.ДействиеПодробнее.ПараметрыФормы.Вставить("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
	НоваяСтрока.ДействиеПодробнее.ПараметрыФормы.Вставить("Состояние", Перечисления.СостоянияРаспределенияРасходов.ТребуетсяРучнойВводДокумента);
КонецПроцедуры

// Обработчики этапа.

Процедура Использование_НастройкаРаспределенияРасходовВручную(ПараметрыОбработчика) Экспорт
	
	Запрос = Новый Запрос;
	ЗакрытиеМесяцаСервер.ИнициализироватьЗапрос(Запрос, ПараметрыОбработчика);
	
	ВариантыРаспределения = Новый Массив();
	Если РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(ПараметрыОбработчика.ПараметрыРасчета.ПериодРегистрации) Тогда
		ВариантыРаспределения.Добавить(Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров);
	КонецЕсли;
	
	Если ВариантыРаспределения.Количество() = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Нет данных для распределения расходов.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		Возврат;
	
	КонецЕсли;

	ПараметрыЗапроса = Документы.РаспределениеПрочихЗатрат.ОписаниеПараметровЗапросаПолученияДанныхДляРаспределения();
	ПараметрыЗапроса.Состояние = Перечисления.СостоянияРаспределенияРасходов.ТребуетсяРучнойВводДокумента;
	ПараметрыЗапроса.ВариантРаспределения = ВариантыРаспределения;
	ПараметрыЗапроса.ИсключитьТранспортныеРасходы = Истина;
	Документы.РаспределениеПрочихЗатрат.ИнициализироватьЗапросПолученияДанныхДляРаспределения(Запрос, ПараметрыЗапроса);
	
	Запрос.Текст = Документы.РаспределениеПрочихЗатрат.ТекстЗапросаДанныеДляРаспределения(, Истина);
	
	Запрос.Выполнить();	
	
	РазмерыВременныхТаблиц = ЗакрытиеМесяцаСервер.РазмерыВременныхТаблиц(Запрос, ПараметрыОбработчика);
	
	Если РазмерыВременныхТаблиц.ВТДанныеДляРаспределения = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Нет данных для распределения расходов.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		Возврат;
		
	КонецЕсли;
	
	Если РазмерыВременныхТаблиц.СостояниеРаспределенияРасходов = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Все производственные расходы полностью распределены по статьям калькуляции.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
	КонецЕсли;
	
КонецПроцедуры

// Проверки состояния системы, относящиеся к этапу.

Процедура ОписаниеПроверок_НастройкаРаспределенияРасходовВручную(ТаблицаПроверок) Экспорт
	
	// Настройка распределения расходов.
	ОписаниеПроверки = ЗакрытиеМесяцаСервер.ДобавитьОписаниеНовойПроверки(ТаблицаПроверок,
		"НеВыполненаНастройкаРаспределенияРасходовВручную",
		Перечисления.ОперацииЗакрытияМесяца.НастройкаРаспределенияРасходовВручную,
		Перечисления.МоментЗапускаПроверкиОперацииЗакрытияМесяца.ДоРасчета,
		"ЗатратыСервер.ПроверкаНеобходимостиНастройкиРаспределенияРасходовВручную");
	
	ЗакрытиеМесяцаСервер.ЗаполнитьПредставлениеНовойПроверки(ОписаниеПроверки,
		НСтр("ru='Не внесены настройки распределения расходов, требующие ручной ввод'", ОбщегоНазначения.КодОсновногоЯзыка()),
		НСтр("ru='Все производственные расходы должны быть полностью распределены'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
КонецПроцедуры

Процедура ПроверкаНеобходимостиНастройкиРаспределенияРасходовВручную(ПараметрыПроверки) Экспорт
	
	Если НЕ ЗакрытиеМесяцаСервер.ПроверкаВыполняетсяМеханизмомЗакрытияМесяца(ПараметрыПроверки) Тогда
		Возврат;
	КонецЕсли;
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить("Организация", 			НСтр("ru='Организация'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("Подразделение", 			НСтр("ru='Подразделение'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("НаправлениеДеятельности", НСтр("ru='Направление деятельности'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("СтатьяРасходов", 			НСтр("ru='Статья расходов'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("АналитикаРасходов", 		НСтр("ru='Аналитика расходов'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	ПараметрыРегистрации = ЗакрытиеМесяцаСервер.ИнициализироватьПараметрыРегистрацииПроблемПроверки(
		"СостояниеРаспределенияРасходов",
		НСтр("ru='Обнаружены статьи расходов, требующие ручной настройки распределения, по организации ""%1"" на конец периода %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
		СписокПолей);
	
	ЗакрытиеМесяцаСервер.ЗарегистрироватьПроблемыВыполненияПроверки(
	 	ПараметрыПроверки,
		ПараметрыРегистрации);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиПроверкиПриЗаписи


#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

