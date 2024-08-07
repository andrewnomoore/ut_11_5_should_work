
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокументов="";
	
	Если Параметры.Свойство("ВидСоздаваемыхДокументов", ВидДокументов) Тогда
		Если ВидДокументов = "ЗаказНаПеремещение" Тогда
			ПредставлениеВидаСоздаваемыхДокументов = Нстр("ru='Заказ на перемещение товаров'");
			Элементы.ОсновныеСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаказыНаПеремещениеТоваров;
			Элементы.СтраницаЗаказыНаВнутреннееПотребление.Видимость = Ложь;
		ИначеЕсли ВидДокументов = "ЗаказНаВнутреннееПотребление" Тогда
			ПредставлениеВидаСоздаваемыхДокументов = Нстр("ru='Заказ на внутреннее потребление'");
			Элементы.ОсновныеСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаказыНаВнутреннееПотребление;
			Элементы.СтраницаЗаказыНаПеремещениеТоваров.Видимость = Ложь;
		Иначе
			ТекстИсключения = Нстр("ru='Некорректные параметры открытия формы'");
			Отказ = Истина;
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
	Иначе
		ТекстИсключения = Нстр("ru='Некорректные параметры открытия формы'");
		Отказ = Истина;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если Параметры.Свойство("ДокументОснование") Тогда
		Объект.ДокументОснование = Параметры.ДокументОснование;
	КонецЕсли;
	
	//
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "Проведен") Тогда
		ТекстИсключения = Нстр("ru='Документ-основание %1 не проведен. Формирование документов не возможно.'");
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИсключения, Объект.ДокументОснование);
		Отказ = Истина;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	//
	
	Объект.ВидСоздаваемыхДокументов = ВидДокументов;
	ЗаполнитьСписокСкладов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказынаперемещениетоваров

&НаКлиенте
Процедура ЗаказыНаПеремещениеТоваровПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаПеремещениеТоваровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаПеремещениеТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ПеремещенияПеремещениеТоваров" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.ЗаказНаПеремещение)
			И ТипЗнч(Элемент.ТекущиеДанные.ЗаказНаПеремещение) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
			ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.ЗаказНаПеремещение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказынавнутреннеепотребление

&НаКлиенте
Процедура ЗаказыНаВнутреннееПотреблениеПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаВнутреннееПотреблениеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаВнутреннееПотреблениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ЗаказыЗаказНаВнутреннееПотребление" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.ЗаказНаВнутреннееПотребление)
			И ТипЗнч(Элемент.ТекущиеДанные.ЗаказНаВнутреннееПотребление) = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление") Тогда
			ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.ЗаказНаВнутреннееПотребление);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	СоздатьДокументыСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьДокументыСервер()
	Если Объект.ОбработкаВыполнена Тогда
		ТекстСообщения = Нстр("ru='Все возможные документы уже созданы'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидСоздаваемыхДокументов = "ЗаказНаПеремещение" Тогда
		ИмяТЧ = "ЗаказыНаПеремещениеТоваров";
		ИмяСклада = "СкладОтправитель";
		ИмяСкладаПолучателя = "СкладПолучатель";
		ИмяДатыОтгрузки = "НачалоОтгрузки";
		ИмяДатыПриемки = "ОкончаниеПоступления";
	ИначеЕсли Объект.ВидСоздаваемыхДокументов = "ЗаказНаВнутреннееПотребление" Тогда
		ИмяТЧ = "ЗаказыНаВнутреннееПотребление";
		ИмяСклада = "Склад";
		ИмяСкладаПолучателя = "";
		ИмяДатыОтгрузки = "ДатаОтгрузки";
		ИмяДатыПриемки = "";
	Иначе
		ТекстИсключения = Нстр("ru='Некорректные параметры заполнения'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	МассивСкладов = Объект[ИмяТЧ].Выгрузить().ВыгрузитьКолонку("Склад");
	РезультатЗапроса = РезультатЗапросаОстатковПоВыводуИзАссортимента(ИмяТЧ);
	
	ВыборкаСклады = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСклады.Следующий() Цикл
		ТекущаяДата = ТекущаяДатаСеанса();
		НовыйЗаказ = Документы[Объект.ВидСоздаваемыхДокументов].СоздатьДокумент(); // ДокументОбъект.ЗаказНаПеремещение, ДокументОбъект.ЗаказНаВнутреннееПотребление
		НовыйЗаказ.Дата = ТекущаяДата;
		НовыйЗаказ.Заполнить(Неопределено);
		НовыйЗаказ[ИмяСклада] = ВыборкаСклады.Склад;
		Если НЕ ПустаяСтрока(ИмяСкладаПолучателя) Тогда
			НовыйЗаказ[ИмяСкладаПолучателя] = ВыборкаСклады.СкладПолучатель;
		КонецЕсли;
		НовыйЗаказ.ДокументОснование = Объект.ДокументОснование;
		НовыйЗаказ.Подразделение = ВыборкаСклады.Подразделение;
		ВыборкаТовары = ВыборкаСклады.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаТовары.Следующий() Цикл
			НоваяСтрокаДокумента = НовыйЗаказ.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДокумента, ВыборкаТовары);
			НоваяСтрокаДокумента[ИмяДатыОтгрузки] = ТекущаяДата;
			Если НЕ ПустаяСтрока(ИмяДатыПриемки) Тогда
				НоваяСтрокаДокумента[ИмяДатыПриемки] = ТекущаяДата;
			КонецЕсли;
		КонецЦикла;
		ОбеспечениеВДокументахСервер.ЗаполнитьВариантОбеспеченияПоУмолчанию(НовыйЗаказ.Товары);
		НовыйЗаказ.Записать(РежимЗаписиДокумента.Запись);
		СтрокиТЧ = Объект[ИмяТЧ].НайтиСтроки(Новый Структура("Склад", ВыборкаСклады.Склад));
		Если СтрокиТЧ.Количество() = 0 Тогда
			СтрокаТЧ = Объект[ИмяТЧ].Добавить();
		Иначе
			СтрокаТЧ = СтрокиТЧ[0];
		КонецЕсли;
		СтрокаТЧ.Склад = ВыборкаСклады.Склад;
		СтрокаТЧ[Объект.ВидСоздаваемыхДокументов] = НовыйЗаказ.Ссылка;
		Если НЕ ПустаяСтрока(ИмяСкладаПолучателя) Тогда
			СтрокаТЧ[ИмяСкладаПолучателя] = ВыборкаСклады.СкладПолучатель;
		КонецЕсли;
	КонецЦикла;
	Объект.ОбработкаВыполнена = Истина;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСкладов()
	
	Тексты = Новый Массив();
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	История.Склад
		|ПОМЕСТИТЬ Склады
		|ИЗ
		|	РегистрСведений.ИсторияИзмененияФорматовМагазинов.СрезПоследних(&Дата, ) КАК История
		|ГДЕ
		|	История.ФорматМагазина = &ФорматМагазина
		|	И История.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)
		|	И НЕ История.Склад.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИзменениеАссортиментаТовары.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ втТовары
		|ИЗ
		|	Документ.ИзменениеАссортимента.Товары КАК ИзменениеАссортиментаТовары
		|ГДЕ
		|	ИзменениеАссортиментаТовары.Ссылка = &ДокументОснование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Склады.Склад КАК Склад
		|ИЗ
		|	Склады КАК Склады";
	Тексты.Добавить(ТекстЗапроса);
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Запасы.Склад КАК Склад,
		|	Запасы.Склад.Наименование КАК НаименованиеСклада
		|ИЗ
		|	РегистрНакопления.ЗапасыИПотребности.Остатки(,
		|		Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|			И Номенклатура В(
		|				ВЫБРАТЬ
		|					втТовары.Номенклатура
		|				ИЗ
		|					втТовары)
		|			И Склад В(
		|				ВЫБРАТЬ
		|					Склады.Склад
		|				ИЗ
		|					Склады)) КАК Запасы
		|ГДЕ
		|	Запасы.ВНаличииОстаток > 0
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеСклада";
	Тексты.Добавить(ТекстЗапроса);
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(Тексты, ОбщегоНазначения.РазделительПакетаЗапросов());
	ФорматМагазина = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "ОбъектПланирования");
	Запрос.УстановитьПараметр("ФорматМагазина", ФорматМагазина);
	Запрос.УстановитьПараметр("ДокументОснование",Объект.ДокументОснование);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	Если Объект.ВидСоздаваемыхДокументов = "ЗаказНаПеремещение" Тогда
		ИмяТабличнойЧасти = "ЗаказыНаПеремещениеТоваров";
	Иначе
		ИмяТабличнойЧасти = "ЗаказыНаВнутреннееПотребление";
	КонецЕсли;
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатСклады = МассивРезультатов[2];
	РезультатОстатки = МассивРезультатов[3];
	СозданиеДоступно = Ложь;
	Если РезультатСклады.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Не существует ни одного розничного магазина, принадлежащего формату ""%1"". Создание документов не требуется.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФорматМагазина);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли РезультатОстатки.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В свободных остатках не числится ни одного товара, выводимого из ассортимента. Создание документов не требуется.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТабличнаяЧасть = Объект[ИмяТабличнойЧасти]; // ТабличнаяЧасть
		Выборка = РезультатОстатки.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			СозданиеДоступно = Истина;
		КонецЦикла;
	КонецЕсли;
	Элементы.ФормаСоздатьДокументы.Доступность = СозданиеДоступно;
КонецПроцедуры

&НаСервере
Функция РезультатЗапросаОстатковПоВыводуИзАссортимента(ИмяТЧ)
	
	Запрос=Новый Запрос();
	Тексты = Новый Массив();
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Склады.Склад КАК Склад,
		|	Склады.СкладПолучатель КАК СкладПолучатель
		|ПОМЕСТИТЬ Склады
		|ИЗ
		|	&Склады КАК Склады
		|;
		|
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИзменениеАссортиментаТовары.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ втТовары
		|ИЗ
		|	Документ.ИзменениеАссортимента.Товары КАК ИзменениеАссортиментаТовары
		|ГДЕ
		|	ИзменениеАссортиментаТовары.Ссылка = &ДокументОснование";
	Тексты.Добавить(ТекстЗапроса);
		
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Запасы.Склад КАК Склад,
		|	Запасы.Номенклатура КАК Номенклатура,
		|	Запасы.Характеристика КАК Характеристика,
		|	Запасы.ВНаличииОстаток КАК Количество
		|ПОМЕСТИТЬ ТаблицаОстатков
		|ИЗ
		|	РегистрНакопления.ЗапасыИПотребности.Остатки(,
		|		Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|			И Номенклатура В(
		|				ВЫБРАТЬ
		|					втТовары.Номенклатура
		|				ИЗ
		|					втТовары)
		|			И Склад В(
		|				ВЫБРАТЬ
		|					Склады.Склад
		|				ИЗ
		|					Склады)) КАК Запасы
		|ИНДЕКСИРОВАТЬ ПО
		|	Склад";
	Тексты.Добавить(ТекстЗапроса);
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Остатки.Склад КАК Склад,
		|	Остатки.Склад.Подразделение КАК Подразделение,
		|	Склады.СкладПолучатель КАК СкладПолучатель,
		|	Остатки.Номенклатура КАК Номенклатура,
		|	Остатки.Характеристика КАК Характеристика,
		|	СУММА(Остатки.Количество) КАК Количество,
		|	СУММА(Остатки.Количество) КАК КоличествоУпаковок
		|ИЗ
		|	ТаблицаОстатков КАК Остатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Склады КАК Склады ПО Склады.Склад = Остатки.Склад
		|
		|СГРУППИРОВАТЬ ПО
		|	Остатки.Склад, Остатки.Номенклатура, Остатки.Характеристика, Склады.СкладПолучатель
		|
		|УПОРЯДОЧИТЬ ПО
		|	Остатки.Склад.Наименование, Остатки.Номенклатура.Наименование
		|ИТОГИ
		|	МАКСИМУМ(Склады.СкладПолучатель) КАК СкладПолучатель
		|ПО Склад";
	Тексты.Добавить(ТекстЗапроса);
	Запрос.Текст = СтрСоединить(Тексты, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.УстановитьПараметр("ДокументОснование",Объект.ДокументОснование);
	ТаблицаОбъекта = Объект[ИмяТЧ].Выгрузить(Новый Массив()); //ТаблицаЗначений
	ПустаяСсылка = Документы[Объект.ВидСоздаваемыхДокументов].ПустаяСсылка();
	Для Каждого Строка Из Объект[ИмяТЧ] Цикл
		
		Если Строка[Объект.ВидСоздаваемыхДокументов] = ПустаяСсылка
				Или ТипЗнч(Строка[Объект.ВидСоздаваемыхДокументов])
					<> Тип("ДокументСсылка." + Объект.ВидСоздаваемыхДокументов) Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаОбъекта.Добавить(), Строка);
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Склады", ТаблицаОбъекта);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса;
	
КонецФункции

#КонецОбласти
