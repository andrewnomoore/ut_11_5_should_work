
#Область ОписаниеПеременных

&НаКлиенте
Перем НужноЗадаватьВопросПередЗакрытием;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ПараметрыСоздания) <> Тип("Структура") Тогда
		ТекстСообщения = НСтр("ru = 'Предусмотрено открытие обработки только из документов.'");
		
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ЗаполнитьПоПараметрамСоздания();
	ИнициализироватьФорму();
	
	Элементы.ТипНомераГТД.Видимость = ИспользоватьУчетПрослеживаемыхИмпортныхТоваров;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НужноЗадаватьВопросПередЗакрытием = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НужноЗадаватьВопросПередЗакрытием Тогда
		СтандартнаяОбработка = Ложь;
		
		ОповещениеЗакрытия = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены.
							|Сохранить изменения?'");
		
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОповещениеЗакрытия,
																	Отказ,
																	ЗавершениеРаботы,
																	ТекстВопроса,
																	ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресВоВременномХранилище) Тогда
		Структура = Новый Структура("АдресВоВременномХранилище", АдресВоВременномХранилище);
		ОповеститьОВыборе(Структура);
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипНомераГТДПриИзменении(Элемент)
	
	Если Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерРНПТКомплекта") Тогда
		Объект.СтранаВвозаНеРФ = Ложь;
		КоличествоКомплектующих = Объект.ПрослеживаемыеКомплектующие.Количество();
		
		Если КоличествоКомплектующих = 0
			И ЗначениеЗаполнено(Объект.Код) Тогда
			
			ДанныеСтроки = ДанныеСтрокиПоКодуИСтранеПроисхождения(Объект.Код, Объект.СтранаПроисхождения);
			
			НоваяСтрока = Объект.ПрослеживаемыеКомплектующие.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
			
		ИначеЕсли КоличествоКомплектующих > 0 Тогда
			
			Объект.Код = ?(Объект.ПрослеживаемыеКомплектующие.Количество() > 0,
							Объект.ПрослеживаемыеКомплектующие[0].Код,
							Объект.Код);
			
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьИзменениеКода();
	НастроитьФорму(ЭтотОбъект);
	ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации,
										НачалоКорректногоПериода,
										КонецКорректногоПериода,
										Элементы.ОшибкаВНомереТаможеннойДекларации);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	ОбработатьИзменениеКода();
	
КонецПроцедуры

&НаКлиенте
Процедура КодИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТекущийТекстНомераДекларации = Текст;
	
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиИнформациюОбОшибкахВНомере", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ДанныеНоменклатуры = ДанныеНоменклатуры(Объект.Номенклатура);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеНоменклатуры);
		
		Объект.НаименованиеТовара = ДанныеНоменклатуры.НаименованиеПолное;
	Иначе
		Объект.НаименованиеТовара = "";
		
		ЕдиницаИзмеренияТНВЭД = ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка");
	КонецЕсли;
	
	УстановитьПредставлениеЕдиницыИзмеренияСтоимости(Элементы.ПредставлениеЕдиницыСтоимости.Заголовок,
													Валюта,
													ЕдиницаИзмеренияТНВЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеТовараПриИзменении(Элемент)
	
	Если Не ПустаяСтрока(Объект.НаименованиеТовара) Тогда
		Объект.НаименованиеТовара = СокрЛП(Объект.НаименованиеТовара);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрослеживаемыеКомплектующие

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеПослеУдаления(Элемент)
	
	Если Объект.ПрослеживаемыеКомплектующие.Количество() = 0 Тогда
		Объект.Код = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования
		И Объект.ПрослеживаемыеКомплектующие.Количество() = 0 Тогда
		
		Объект.Код = "";
		
		Возврат;
		
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ПрослеживаемыеКомплектующие.ТекущиеДанные;
	
	Если Не ОтменаРедактирования
		И ТекущаяСтрока <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Код)
			И ЗначениеЗаполнено(ТекущаяСтрока.ЕдиницаИзмеренияТНВЭД) Тогда
			
			ПодключитьОбработчикОжидания("ОбъединитьСтроки", 0.1, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеКодПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПрослеживаемыеКомплектующие.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока.Код = "" Тогда
		ТекущаяСтрока.НомерРНПТ = Неопределено;
		ТекущаяСтрока.СтатусНомераРНПТ = Ложь;
		
		УстановитьКодПоПервойСтрокеКомплектующих(ТекущаяСтрока);
		
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = ДанныеСтрокиПоКодуИСтранеПроисхождения(ТекущаяСтрока.Код, Объект.СтранаПроисхождения);
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеСтроки);
	
	УстановитьКодПоПервойСтрокеКомплектующих(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеКодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗакупкиКлиент.НомераГТДКодКомплектующейАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеКодОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.ПрослеживаемыеКомплектующие.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено
		И ЗначениеЗаполнено(ТекущаяСтрока.НомерРНПТ) Тогда
		
		ПоказатьЗначение(, ТекущаяСтрока.НомерРНПТ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеКодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.ПрослеживаемыеКомплектующие.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		ТекущаяСтрока.НомерРНПТ			= Неопределено;
		ТекущаяСтрока.СтатусНомераРНПТ	= Ложь;
		ТекущаяСтрока.Код				= "";
	Иначе
		ТекущаяСтрока.НомерРНПТ			= ВыбранноеЗначение; 
		ТекущаяСтрока.СтатусНомераРНПТ	= Истина;
		ТекущаяСтрока.Код				= Строка(ВыбранноеЗначение);
	КонецЕсли;
	
	УстановитьКодПоПервойСтрокеКомплектующих(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеКоличествоПоРНПТВДокументеПриИзменении(Элемент)
	
	Если КоличествоКомплектов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ПрослеживаемыеКомплектующие.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока.КоличествоПоРНПТ = ТекущаяСтрока.КоличествоПоРНПТВДокументе / КоличествоКомплектов;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрослеживаемыеКомплектующиеСуммаПоРНПТВДокументеПриИзменении(Элемент)
	
	Если КоличествоКомплектов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ПрослеживаемыеКомплектующие.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока.СуммаПоРНПТ = Окр(ТекущаяСтрока.СуммаПоРНПТВДокументе / КоличествоКомплектов, 2);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОбработатьВыборОК();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаРегистрации

&НаСервере
Процедура СохранитьДанныеРегистрации(Отказ)
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипНомераГТД = Перечисления.ТипыНомеровГТД.НомерРНПТКомплекта Тогда
		СохранитьНомерРНПТКомплекта(Отказ);
	Иначе
		СохранитьНомерГТД(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНомерРНПТКомплекта(Отказ)
	
	ЗаполнитьКомплектующиеЗарегистрированнымиНомерамиРНПТ();
	ЗаполнитьКомплектующиеНовымиНомерамиРНПТ();
	
	ТаблицаКомплектующих = ТаблицаКомплектующихДляСозданияНомераРНПТКомплекта();
	
	ПараметрыСоздания = ЗакупкиСервер.ПараметрыПоискаИлиСозданияСоставныхПрослеживаемыхКомплектов();
	ПараметрыСоздания.НоменклатураШапки = Объект.Номенклатура;
	ПараметрыСоздания.СуммаПоРНПТ = Объект.СуммаПоРНПТ;
	ПараметрыСоздания.ВсегдаИспользоватьСуммаПоРНПТДляСтоимостиКомплекта = Истина;
	
	ДанныеРНПТКомплекта = ЗакупкиСервер.НайтиИлиСоздатьСоставныеПрослеживаемыеНомераГТД(
							ТаблицаКомплектующих,
							КоличествоКомплектов,
							Дата(2399, 1, 1),
							Отказ,
							ПараметрыСоздания);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РезультатРегистрации = РезультатРегистрацииДанных();
	РезультатРегистрации.ЭтоРНПТКомплекта = Истина;
	РезультатРегистрации.ОсновнойНомерГТД = ДанныеРНПТКомплекта.ОсновнойСоставнойНомерГТД;
	
	Если ДанныеРНПТКомплекта.ОстаточныйСоставнойНомерГТД <> Неопределено Тогда
		РезультатРегистрации.ОстаточныйНомерГТД = ДанныеРНПТКомплекта.ОстаточныйСоставнойНомерГТД;
	КонецЕсли;
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(РезультатРегистрации, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ТаблицаКомплектующихДляСозданияНомераРНПТКомплекта()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)	КАК Номенклатура,
	|	Комплектующие.НомерРНПТ							КАК НомерГТД,
	|	Комплектующие.КоличествоПоРНПТВДокументе		КАК КоличествоПоРНПТ,
	|	Комплектующие.ЕдиницаИзмеренияТНВЭД				КАК ЕдиницаИзмерения,
	|	Комплектующие.СуммаПоРНПТ						КАК СуммаПоРНПТ
	|ПОМЕСТИТЬ ВТКомплектующие
	|ИЗ
	|	&Комплектующие КАК Комплектующие
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Комплектующие.Номенклатура				КАК Номенклатура,
	|	Комплектующие.НомерГТД					КАК НомерГТД,
	|	СУММА(Комплектующие.КоличествоПоРНПТ)	КАК КоличествоПоРНПТ,
	|	Комплектующие.ЕдиницаИзмерения			КАК ЕдиницаИзмерения,
	|	СУММА(Комплектующие.СуммаПоРНПТ)		КАК СуммаПоРНПТ
	|ИЗ
	|	ВТКомплектующие КАК Комплектующие
	|
	|СГРУППИРОВАТЬ ПО
	|	Комплектующие.Номенклатура,
	|	Комплектующие.НомерГТД,
	|	Комплектующие.ЕдиницаИзмерения";
	
	ВыгружаемыеКолонки = "НомерРНПТ, КоличествоПоРНПТВДокументе, ЕдиницаИзмеренияТНВЭД, СуммаПоРНПТ";
	Запрос.УстановитьПараметр("Комплектующие", Объект.ПрослеживаемыеКомплектующие.Выгрузить(, ВыгружаемыеКолонки));
	
	ТаблицаКомплектующих = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаКомплектующих;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКомплектующиеЗарегистрированнымиНомерамиРНПТ()
	
	Комплектующие = Объект.ПрослеживаемыеКомплектующие;
	
	ОтборСтрок = Новый Структура("НомерРНПТ", Справочники.НомераГТД.ПустаяСсылка());
	СтрокиБезРНПТ = Комплектующие.НайтиСтроки(ОтборСтрок);
	
	Если СтрокиБезРНПТ.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Комплектующие.НомерСтроки	КАК НомерСтроки,
	|	Комплектующие.Код			КАК Код
	|ПОМЕСТИТЬ ВТКомплектующие
	|ИЗ
	|	&Комплектующие КАК Комплектующие
	|
	|ГДЕ
	|	Комплектующие.НомерРНПТ = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Комплектующие.НомерСтроки	КАК НомерСтроки,
	|	НомераГТД.Ссылка			КАК НомерРНПТ
	|ИЗ
	|	ВТКомплектующие КАК Комплектующие
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НомераГТД КАК НомераГТД
	|		ПО Комплектующие.Код = НомераГТД.Код
	|			И НомераГТД.СтранаПроисхождения = &СтранаПроисхождения
	|			И НомераГТД.ТипНомераГТД = ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("Комплектующие",			Комплектующие.Выгрузить(, "НомерСтроки, НомерРНПТ, Код"));
	Запрос.УстановитьПараметр("СтранаПроисхождения",	Объект.СтранаПроисхождения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Комплектующие[Выборка.НомерСтроки - 1].НомерРНПТ = Выборка.НомерРНПТ;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКомплектующиеНовымиНомерамиРНПТ()
	
	ОтборСтрок = Новый Структура("НомерРНПТ", Справочники.НомераГТД.ПустаяСсылка());
	СтрокиБезРНПТ = Объект.ПрослеживаемыеКомплектующие.НайтиСтроки(ОтборСтрок);
	
	СопоставлениеНомеровРНПТ = Новый Соответствие;
	
	Для Каждого СтрокаКомплекта Из СтрокиБезРНПТ Цикл
		КодРНПТ		= СокрЛП(СтрокаКомплекта.Код);
		НомерРНПТ	= СопоставлениеНомеровРНПТ.Получить(КодРНПТ);
		
		Если НомерРНПТ = Неопределено Тогда
			СохранитьРНПТПоСтрокеКомплектующих(СтрокаКомплекта);
			
			СопоставлениеНомеровРНПТ.Вставить(КодРНПТ, СтрокаКомплекта.НомерРНПТ);
		Иначе
			СтрокаКомплекта.НомерРНПТ = НомерРНПТ;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРНПТПоСтрокеКомплектующих(СтрокаКомплекта)
	
	НомерРНПТ = Справочники.НомераГТД.СоздатьЭлемент();
	НомерРНПТ.РегистрационныйНомер	= СтрокаКомплекта.Код;
	НомерРНПТ.ТипНомераГТД			= Перечисления.ТипыНомеровГТД.НомерРНПТ;
	
	ИменаСвойствОбъекта = "СтранаПроисхождения, Номенклатура, НаименованиеТовара";
	ЗаполнитьЗначенияСвойств(НомерРНПТ, Объект, ИменаСвойствОбъекта);
	
	ИменаСвойствКомплекта = "Код, СуммаПоРНПТ";
	ЗаполнитьЗначенияСвойств(НомерРНПТ, СтрокаКомплекта, ИменаСвойствКомплекта);
	
	НомерРНПТ.Записать();
	
	СтрокаКомплекта.НомерРНПТ = НомерРНПТ.Ссылка;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНомерГТД(Отказ)
	
	НомерГТД = Справочники.НомераГТД.СоздатьЭлемент();
	
	Если НомерГТД <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НомерГТД, Объект);
		
		НомерГТД.Записать();
	Иначе
		ПредставлениеТипа = ?(Объект.ТипНомераГТД = Перечисления.ТипыНомеровГТД.НомерГТД,
								НСтр("ru = 'номер ГТД'"),
								НСтр("ru = 'номер РНПТ'"));
		
		ТекстСообщения = НСтр("ru = 'Не удалось зарегистрировать %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПредставлениеТипа);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РезультатРегистрации = РезультатРегистрацииДанных();
	РезультатРегистрации.ОсновнойНомерГТД = НомерГТД.Ссылка;
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(РезультатРегистрации, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция РезультатРегистрацииДанных()
	
	РезультатРегистрации = Новый Структура;
	РезультатРегистрации.Вставить("ЭтоРНПТКомплекта",	Ложь);
	РезультатРегистрации.Вставить("ОсновнойНомерГТД",	Неопределено);
	РезультатРегистрации.Вставить("ОстаточныйНомерГТД",	Неопределено);
	
	Возврат РезультатРегистрации;
	
КонецФункции

#КонецОбласти

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура ОбработатьИзменениеКода()
	
	ТекущийТекстНомераДекларации = Объект.Код;
	
	Если Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерГТД") Тогда
		Реквизиты = РегистрационныйНомерИСтранаВвоза(ТекущийТекстНомераДекларации);
		
		ЗаполнитьЗначенияСвойств(Объект, Реквизиты);
	ИначеЕсли Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерРНПТ") Тогда
		Объект.РегистрационныйНомер = ТекущийТекстНомераДекларации;
	Иначе
		Объект.РегистрационныйНомер		= "";
		ТекущийТекстНомераДекларации	= "";
	КонецЕсли;
	
	ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации,
										НачалоКорректногоПериода,
										КонецКорректногоПериода,
										Элементы.ОшибкаВНомереТаможеннойДекларации);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗаполнитьПоПараметрамСоздания()
	
	ДанныеСоздания = ЗакупкиСервер.ПараметрыСозданияНомераГТДПоУмолчанию();
	ИнициализироватьДанныеСоздания(ДанныеСоздания, Параметры.ПараметрыСоздания);
	
	ДанныеТовара = ДанныеСоздания.ДанныеТовара;
	
	Если Не ЗначениеЗаполнено(ДанныеТовара.Номенклатура) Тогда
		ТекстИсключения = НСтр("ru = 'Для открытия обработки не переданы сведения о товаре.'");
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеТовара);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеСоздания);
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьЗначенияПустыхСвойств(Объект, ДанныеТовара);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьЗначенияПустыхСвойств(Объект, ДанныеСоздания);
	
	ИменаРеквизитов			= "НаименованиеПолное, ЕдиницаИзмерения, ЕдиницаИзмеренияТНВЭД, СтранаПроисхождения";
	РеквизитыНоменклатуры	= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Номенклатура, ИменаРеквизитов);
	
	Если Не ЗначениеЗаполнено(Объект.СтранаПроисхождения) Тогда
		Объект.СтранаПроисхождения = РеквизитыНоменклатуры.СтранаПроисхождения;
	КонецЕсли;
	
	Объект.НаименованиеТовара	= РеквизитыНоменклатуры.НаименованиеПолное;
	ЕдиницаИзмеренияТНВЭД		= РеквизитыНоменклатуры.ЕдиницаИзмеренияТНВЭД;
	
	ДанныеНоменклатуры = Новый Структура("Номенклатура, Характеристика, Упаковка, ЕдиницаИзмерения, СуммаПоРНПТ");
	ЗаполнитьЗначенияСвойств(ДанныеНоменклатуры, ДанныеТовара);
	ЗаполнитьЗначенияСвойств(ДанныеНоменклатуры, РеквизитыНоменклатуры);
	
	ИнициализироватьСтоимостныеПоказатели(ДанныеСоздания, ДанныеНоменклатуры);
	УстановитьЗаголовокИнформацияОТовареДокумента(ДанныеНоменклатуры);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанныеСоздания(ДанныеСоздания, ПараметрыСоздания)
	
	Для Каждого КлючИЗначение Из ПараметрыСоздания Цикл
		Если ДанныеСоздания.Свойство(КлючИЗначение.Ключ)
			И ТипЗнч(ДанныеСоздания[КлючИЗначение.Ключ]) = ТипЗнч(КлючИЗначение.Значение) Тогда
			
			ДанныеСоздания[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСтоимостныеПоказатели(ПараметрыСоздания, ДанныеНоменклатуры)
	
	Валюта = УчетПрослеживаемыхТоваровЛокализация.ВалютаРегламентированногоУчетаНомераГТД();
	
	Если Не ПоказатьСтоимостьПоДокументу Тогда
		Возврат;
	КонецЕсли;
	
	ДатаДокумента	= ?(ЗначениеЗаполнено(ПараметрыСоздания.Дата),
						ПараметрыСоздания.Дата,
						ТекущаяДатаСеанса());
	ВалютаДокумента	= ?(ЗначениеЗаполнено(ПараметрыСоздания.ВалютаДокумента),
						ПараметрыСоздания.ВалютаДокумента,
						Валюта);
	
	Если ЗначениеЗаполнено(Валюта)
		И ЗначениеЗаполнено(ВалютаДокумента)
		И Валюта <> ВалютаДокумента Тогда
		
		КурсСтаройВалюты	= РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента, Валюта);
		КурсНовойВалюты		= РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(Валюта, ДатаДокумента, Валюта);
		
		Объект.СуммаПоРНПТ = РаботаСКурсамиВалютУТ.ПересчитатьПоКурсу(Объект.СуммаПоРНПТ,
																		КурсСтаройВалюты,
																		КурсНовойВалюты);
		
	КонецЕсли;
	
	ДанныеНоменклатуры.СуммаПоРНПТ = Объект.СуммаПоРНПТ;
	
	Если КоличествоКомплектов <> 0 Тогда
		Объект.СуммаПоРНПТ = Окр(Объект.СуммаПоРНПТ / КоличествоКомплектов, 2);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокИнформацияОТовареДокумента(ДанныеНоменклатуры)
	
	Упаковка = ?(ЗначениеЗаполнено(ДанныеНоменклатуры.Упаковка),
				ДанныеНоменклатуры.Упаковка,
				ДанныеНоменклатуры.ЕдиницаИзмерения);
	
	ДанныеТовара = Новый Массив;
	ДанныеТовара.Добавить(СокрЛП(Строка(ДанныеНоменклатуры.Номенклатура)));
	
	Если ЗначениеЗаполнено(ДанныеНоменклатуры.Характеристика) Тогда
		ДанныеТовара.Добавить(СокрЛП(Строка(ДанныеНоменклатуры.Характеристика)));
	КонецЕсли;
	
	ПредставлениеТовара = СтрСоединить(ДанныеТовара, ",");
	
	Если ПоказатьСтоимостьПоДокументу Тогда
		ЗаголовокИнформационнойНадписи = НСтр("ru = 'В документе указано %1 %2 комплекта ""%3"" стоимостью %4 %5'");
		ЗаголовокИнформационнойНадписи = СтрШаблон(ЗаголовокИнформационнойНадписи,
													Строка(КоличествоКомплектов),
													СокрЛП(Строка(Упаковка)),
													ПредставлениеТовара,
													Строка(ДанныеНоменклатуры.СуммаПоРНПТ),
													СокрЛП(Строка(Валюта)));
	Иначе
		ЗаголовокИнформационнойНадписи = НСтр("ru = 'В документе указано %1 %2 комплекта ""%3""'");
		ЗаголовокИнформационнойНадписи = СтрШаблон(ЗаголовокИнформационнойНадписи,
													Строка(КоличествоКомплектов),
													СокрЛП(Строка(Упаковка)),
													ПредставлениеТовара);
	КонецЕсли;
	
	Элементы.ИнформацияОТовареДокумента.Заголовок = ЗаголовокИнформационнойНадписи;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФорму()
	
	ПрослеживаемыйТовар = ?(ЗначениеЗаполнено(Объект.Номенклатура),
							ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Номенклатура, "ПрослеживаемыйТовар"),
							Ложь);
	
	Объект.ТипНомераГТД = ?(ЗначениеЗаполнено(Объект.ТипНомераГТД),
							Объект.ТипНомераГТД,
							?(ПрослеживаемыйТовар
								И ИспользоватьУчетПрослеживаемыхИмпортныхТоваров,
								Перечисления.ТипыНомеровГТД.НомерРНПТ,
								Перечисления.ТипыНомеровГТД.НомерГТД));
	
	ТекущийТекстНомераДекларации = ?(Объект.ТипНомераГТД = Перечисления.ТипыНомеровГТД.НомерРНПТКомплекта,
									"",
									Объект.Код);
	
	Если Объект.ТипНомераГТД = Перечисления.ТипыНомеровГТД.НомерГТД Тогда
		Реквизиты = РегистрационныйНомерИСтранаВвоза(ТекущийТекстНомераДекларации);
		
		ЗаполнитьЗначенияСвойств(Объект, Реквизиты);
	КонецЕсли;
	
	КорректныйПериод = ЗакупкиСервер.КорректныйПериодВводаДокументовНомераТаможеннойДекларации();
	
	НачалоКорректногоПериода	= КорректныйПериод.НачалоКорректногоПериода;
	КонецКорректногоПериода		= КорректныйПериод.КонецКорректногоПериода;
	
	НастроитьФорму(ЭтотОбъект);
	СформироватьПредставлениеНомераТД();
	УстановитьПредставлениеЕдиницыИзмеренияСтоимости(Элементы.ПредставлениеЕдиницыСтоимости.Заголовок,
													Валюта,
													ЕдиницаИзмеренияТНВЭД);
	ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации,
										НачалоКорректногоПериода,
										КонецКорректногоПериода,
										Элементы.ОшибкаВНомереТаможеннойДекларации);
	
КонецПроцедуры

// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма элемента справочника.
&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФорму(Форма)
	
	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;
	
	ЭтоГТД				= Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерГТД");
	ЭтоРНПТКомплекта	= Форма.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
							И Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерРНПТКомплекта");
	
	Элементы.Код.Видимость = Не ЭтоРНПТКомплекта;
	Элементы.Код.Заголовок = ?(ЭтоГТД,
								НСтр("ru = 'Номер декларации'"),
								НСтр("ru = 'Номер РНПТ'"));
	
	Элементы.СуммаПоРНПТ.Заголовок = ?(ЭтоРНПТКомплекта,
										НСтр("ru = 'Стоимость комплекта'"),
										НСтр("ru = 'Стоимость'"));
	
	Элементы.ГруппаДанныеПрослеживаемости.Видимость			= Не ЭтоГТД;
	Элементы.ГруппаНоменклатура.Видимость					= Не ЭтоРНПТКомплекта;
	Элементы.ГруппаПрослеживаемыеКомплектующие.Видимость	= ЭтоРНПТКомплекта;
	
	Элементы.ПрослеживаемыеКомплектующиеСуммаПоРНПТВДокументе.Видимость = Форма.ПоказатьСтоимостьПоДокументу;
	
	УстановитьЗаголовокФормы(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма)
	
	Объект = Форма.Объект;
	
	ШаблонЗаголовка = НСтр("ru = 'Регистрация %1'");
	
	Если Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерГТД") Тогда
		ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка, НСтр("ru = 'номера грузовой таможенной декларации'"));
	ИначеЕсли Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерРНПТ") Тогда
		ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка, НСтр("ru = 'номера РНПТ'"));
	ИначеЕсли Объект.ТипНомераГТД = ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерРНПТКомплекта") Тогда
		ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка, НСтр("ru = 'номера РНПТ комплекта'"));
	КонецЕсли;
	
	Форма.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеНомераТД()
	
	ТаможеннаяДекларация = "";
	
	Если ПравоДоступа("Просмотр", Метаданные.Документы.ТаможеннаяДекларацияИмпорт) Тогда
		Если Не Объект.СтранаВвозаНеРФ
			И ЗначениеЗаполнено(Объект.РегистрационныйНомер) Тогда
			
			ТаможеннаяДекларацияСсылка = Документы.ТаможеннаяДекларацияИмпорт.НайтиПоРеквизиту(
											"НомерДекларации",
											Объект.РегистрационныйНомер);
			
			Если Не ТаможеннаяДекларацияСсылка.Пустая() Тогда
				ТаможеннаяДекларация = ПолучитьНавигационнуюСсылку(ТаможеннаяДекларацияСсылка);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТаможеннаяДекларация)
		И ЗначениеЗаполнено(Объект.РегистрационныйНомер) Тогда
		
		Часть1 = Новый ФорматированнаяСтрока(НСтр("ru = 'Зарегистрирована декларация:'") + " ");
		Часть2 = Новый ФорматированнаяСтрока(Объект.РегистрационныйНомер, , , , ТаможеннаяДекларация);
		
		Элементы.ПредставлениеНомераТД.Заголовок = Новый ФорматированнаяСтрока(Часть1, Часть2);
		Элементы.ПредставлениеНомераТД.Видимость = Истина;
		
	Иначе
		Элементы.ПредставлениеНомераТД.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеЕдиницыИзмеренияСтоимости(ПредставлениеЭлемента, Валюта, ЕдиницаИзмеренияТНВЭД)
	
	ЕдиницаИзмеренияПредставление = ?(ЗначениеЗаполнено(ЕдиницаИзмеренияТНВЭД),
										СокрЛП(Строка(ЕдиницаИзмеренияТНВЭД)),
										НСтр("ru = 'единицу'"));
	
	ТекстПредставления		= НСтр("ru = '%1 за %2'");
	ПредставлениеЭлемента	= СтрШаблон(ТекстПредставления, СокрЛП(Строка(Валюта)), ЕдиницаИзмеренияПредставление);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации,
											НачалоКорректногоПериода,
											КонецКорректногоПериода,
											ЭлементОшибкаВНомереТаможеннойДекларации)
	
	РезультатПроверки = УчетНДСКлиентСерверЛокализация.ПроверитьКорректностьНомераТаможеннойДекларации(
							ТекущийТекстНомераДекларации,
							НачалоКорректногоПериода,
							КонецКорректногоПериода);
	
	ЭлементОшибкаВНомереТаможеннойДекларации.Заголовок = УчетНДСКлиентСерверЛокализация.ТекстОшибкиВНомереТаможеннойДекларации(
															РезультатПроверки.КодОшибки);
	ЭлементОшибкаВНомереТаможеннойДекларации.Видимость = РезультатПроверки.КодОшибки <> 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		НужноЗадаватьВопросПередЗакрытием = Ложь;
		
		ОбработатьВыборОк();
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		НужноЗадаватьВопросПередЗакрытием = Ложь;
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеСтрокиПоКодуИСтранеПроисхождения(Знач Код, СтранаПроисхождения)
	
	ДанныеПервойСтроки = Новый Структура;
	ДанныеПервойСтроки.Вставить("Код", Код);
	ДанныеПервойСтроки.Вставить("НомерРНПТ", Справочники.НомераГТД.ПустаяСсылка());
	ДанныеПервойСтроки.Вставить("СтатусНомераРНПТ", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НомераГТД.Ссылка	КАК НомерРНПТ,
	|	НомераГТД.Код		КАК Код,
	|	ИСТИНА				КАК СтатусНомераРНПТ
	|ИЗ
	|	Справочник.НомераГТД КАК НомераГТД
	|ГДЕ
	|	НЕ НомераГТД.ПометкаУдаления
	|	И НомераГТД.Код = &Код
	|	И НомераГТД.ТипНомераГТД = ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	
	Запрос.УстановитьПараметр("Код", СокрЛП(Код));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат ДанныеПервойСтроки;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Количество() > 1 Тогда
		Возврат ДанныеПервойСтроки;
	КонецЕсли;
	
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ДанныеПервойСтроки, Выборка);
	
	Возврат ДанныеПервойСтроки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеНоменклатуры(Номенклатура)
	
	ИменаРеквизитов		= "НаименованиеПолное, ЕдиницаИзмеренияТНВЭД";
	ДанныеНоменклатуры	= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, ИменаРеквизитов);
	
	ДанныеНоменклатуры.НаименованиеПолное = СокрЛП(ДанныеНоменклатуры.НаименованиеПолное);
	
	Возврат ДанныеНоменклатуры;
	
КонецФункции

&НаКлиенте
Процедура УстановитьКодПоПервойСтрокеКомплектующих(ТекущаяСтрока)
	
	Если ТекущаяСтрока.НомерСтроки = 1 Тогда
		Если Объект.Код <> ТекущаяСтрока.Код Тогда
			Объект.Код = ТекущаяСтрока.Код;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РегистрационныйНомерИСтранаВвоза(ТекущийТекстНомераДекларации)
	
	Возврат Справочники.НомераГТД.РегистрационныйНомерИСтранаВвоза(ТекущийТекстНомераДекларации);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ВывестиИнформациюОбОшибкахВНомере()
	
	ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации,
										НачалоКорректногоПериода,
										КонецКорректногоПериода,
										Элементы.ОшибкаВНомереТаможеннойДекларации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОК()
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	СохранитьДанныеРегистрации(Отказ);
	
	Если Не Отказ Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьСтроки()
	
	ТекущаяСтрока = Элементы.ПрослеживаемыеКомплектующие.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбъединитьСтрокиСервер(ТекущаяСтрока.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаСервере
Процедура ОбъединитьСтрокиСервер(ИдентификаторТекущейСтроки)
	
	Комплектующие = Объект.ПрослеживаемыеКомплектующие;
	ТекущаяСтрока = Комплектующие.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	
	Индекс = Комплектующие.Количество() - 1;
	ИндексТекущейСтроки = 0;
	
	УдаляемаяСтрока = Неопределено;
	РеквизитыСтроки = "НомерРНПТ, Код, ЕдиницаИзмеренияТНВЭД";
	
	СвойстваТекущейСтроки = Новый Структура(РеквизитыСтроки);
	ЗаполнитьЗначенияСвойств(СвойстваТекущейСтроки, ТекущаяСтрока, , "Код");
	
	СвойстваТекущейСтроки.Код = СокрЛП(ТекущаяСтрока.Код);
	
	Пока Индекс >= 0 Цикл
		Если Комплектующие[Индекс].ПолучитьИдентификатор() = ИдентификаторТекущейСтроки Тогда
			ИндексТекущейСтроки = Индекс;
			Индекс = Индекс - 1;
			
			Продолжить;
		КонецЕсли;
		
		СвойстваСтрокиКомплекта = Новый Структура(РеквизитыСтроки);
		ЗаполнитьЗначенияСвойств(СвойстваСтрокиКомплекта, Комплектующие[Индекс], , "Код");
		СвойстваСтрокиКомплекта.Код = СокрЛП(Комплектующие[Индекс].Код);
		
		СтрокиСовпадают = ОбщегоНазначенияУТКлиентСервер.СтруктурыРавны(СвойстваТекущейСтроки, СвойстваСтрокиКомплекта);
		
		Если Не СтрокиСовпадают Тогда
			Индекс = Индекс - 1;
			
			Продолжить;
		КонецЕсли;
		
		Если Индекс > ИндексТекущейСтроки Тогда
			УдаляемаяСтрока = Комплектующие[Индекс];
			
			ТекущаяСтрока.КоличествоПоРНПТ = ТекущаяСтрока.КоличествоПоРНПТ + Комплектующие[Индекс].КоличествоПоРНПТ;
			ТекущаяСтрока.КоличествоПоРНПТВДокументе = ТекущаяСтрока.КоличествоПоРНПТВДокументе
														+ Комплектующие[Индекс].КоличествоПоРНПТВДокументе;
			
			ТекущаяСтрока.СуммаПоРНПТ = ТекущаяСтрока.СуммаПоРНПТ + Комплектующие[Индекс].СуммаПоРНПТ;
			ТекущаяСтрока.СуммаПоРНПТВДокументе = ТекущаяСтрока.СуммаПоРНПТВДокументе
													+ Комплектующие[Индекс].СуммаПоРНПТВДокументе;
		Иначе
			УдаляемаяСтрока = ТекущаяСтрока;
			
			Комплектующие[Индекс].КоличествоПоРНПТ = Комплектующие[Индекс].КоличествоПоРНПТ
														+ ТекущаяСтрока.КоличествоПоРНПТ;
			Комплектующие[Индекс].КоличествоПоРНПТВДокументе = Комплектующие[Индекс].КоличествоПоРНПТВДокументе
																+ ТекущаяСтрока.КоличествоПоРНПТВДокументе;
			
			Комплектующие[Индекс].СуммаПоРНПТ = Комплектующие[Индекс].СуммаПоРНПТ + ТекущаяСтрока.СуммаПоРНПТ;
			Комплектующие[Индекс].СуммаПоРНПТВДокументе = Комплектующие[Индекс].СуммаПоРНПТВДокументе
															+ ТекущаяСтрока.СуммаПоРНПТВДокументе;
		КонецЕсли;
		
		Прервать;
		
	КонецЦикла;
	
	Если УдаляемаяСтрока <> Неопределено Тогда
		Комплектующие.Удалить(УдаляемаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
