
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПримененныеСкидки = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище); // см. СкидкиНаценкиСервер.Рассчитать.ДеревоСкидок
	
	ДеревоСкидок = ПримененныеСкидки.ДеревоСкидок.Скопировать(); // ДеревоЗначений
	ДеревоСкидок.Колонки.Добавить("ИндексКартинки",   Новый ОписаниеТипов("Число"));
	ДеревоСкидок.Колонки.Добавить("Действует",        Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("УсловияВыполнены", Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("Разворачивать",  Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("ТолькоПросмотр", Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("ЭтоУсловие",     Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("Значение",       Новый ОписаниеТипов("СправочникСсылка.СкидкиНаценки, СправочникСсылка.УсловияПредоставленияСкидокНаценок"));
	ДеревоСкидок.Колонки.Добавить("Представление",  Новый ОписаниеТипов("Строка"));
	
	РассчитатьИнформациюОРасчетеСкидокПоДокументу(ДеревоСкидок);
	
	// Если скидок для назначения нет, изменим заголовок.
	Если ДеревоСкидок.Строки.НайтиСтроки(Новый Структура("Управляемая", Истина), Истина).Количество() = 0 Тогда
		Элементы.Описание.Видимость = Ложь;
		Элементы.ОписаниеНетСкидокДляНазначения.Видимость = Истина;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоСкидок, "ИнформацияОРасчетеСкидокПоДокументуВЦелом");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьДеревоДоУсловийРекурсивно(ИнформацияОРасчетеСкидокПоДокументуВЦелом, Элементы.ИнформацияОРасчетеСкидокПоДокументуВЦелом);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Рассчитать(Команда)
	
	Закрыть(СписокНазначенныхСкидок());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоДокументуВЦелом.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.Управляемая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.НазначенаПользователем");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0, 128, 0));
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Ложь, Истина, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоДокументуВЦелом.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.Управляемая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.НазначенаПользователем");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0, 127, 0));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоДокументуВЦелом.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.УсловияВыполнены");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 0, 0));
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Ложь, Истина, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоДокументуВЦеломНазначенаПользователем.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.Управляемая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.Действует");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоДокументуВЦеломНазначенаПользователем.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.ТолькоПросмотр");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоДокументуВЦеломЗначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.Значение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.Ссылка");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоДокументуВЦелом.ЭтоУсловие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'В документе есть товары на которые предоставляется скидка (наценка)'"));
	
КонецПроцедуры

#Область Прочее

// Параметры:
// 	ДеревоСкидок - СтрокаДереваЗначений, ДеревоЗначений - доп.поля:
// 		* Ссылка - СправочникСсылка.СкидкиНаценки
// 		* ИндексКартинки - Число
// 		* Действует - Булево
// 		* УсловияВыполнены - Булево
// 		* Разворачивать - Булево
// 		* ТолькоПросмотр - Булево
// 		* ЭтоУсловие - Булево
// 		* Значение - СправочникСсылка.СкидкиНаценки, СправочникСсылка.УсловияПредоставленияСкидокНаценок -
// 		* Представление - Строка
//
// Описание ДеревоСкидок в модуле СкидкиНаценкиСервер.СформироватьДеревоСкидок
//
&НаСервере
Процедура РассчитатьИнформациюОРасчетеСкидокПоДокументу(ДеревоСкидок)
	
	Для Каждого СтрокаДерева Из ДеревоСкидок.Строки Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			РассчитатьИнформациюОРасчетеСкидокПоДокументу(СтрокаДерева);
			
			СтрокаДерева.ИндексКартинки = СкидкиНаценкиСервер.ПолучитьИндексКартинкиДляГруппы(СтрокаДерева);
			СтрокаДерева.Значение       = СтрокаДерева.Ссылка;
			СтрокаДерева.Представление  = Строка(СтрокаДерева.Значение);
			СтрокаДерева.Разворачивать  = Истина;
			СтрокаДерева.ТолькоПросмотр         = Истина;
			СтрокаДерева.НазначенаПользователем = Ложь;
			
			Для каждого Стр Из СтрокаДерева.Строки Цикл
				Если Стр.Действует Тогда
					СтрокаДерева.Действует        = Истина;
					СтрокаДерева.УсловияВыполнены = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			
			СтрокаДерева.ИндексКартинки = СкидкиНаценкиСервер.ПолучитьИндексКартинкиДляСкидки(СтрокаДерева);
			СтрокаДерева.Значение = СтрокаДерева.Ссылка;
			СтрокаДерева.Представление = Строка(СтрокаДерева.Значение);
			Если Не СтрокаДерева.Управляемая Тогда
				СтрокаДерева.ТолькоПросмотр   = Истина;
				СтрокаДерева.НазначенаПользователем = Ложь;
			КонецЕсли;
			
			ВсеУсловияВыполнены = Истина;
			Для каждого СтрокаУсловие Из СтрокаДерева.ПараметрыУсловий.ТаблицаУсловий Цикл
				
				НоваяСтрокаУсловие = СтрокаДерева.Строки.Добавить();
				НоваяСтрокаУсловие.Значение = СтрокаУсловие.УсловиеПредоставления;
				Если СтрокаУсловие.ЗначениеПоказателя <> Неопределено Тогда
					НоваяСтрокаУсловие.Представление = СтрШаблон(НСтр("ru = '%1 (Текущее значение: %2)'"), Строка(СтрокаУсловие.УсловиеПредоставления), Формат(СтрокаУсловие.ЗначениеПоказателя, "ЧН=0"));
				Иначе
					НоваяСтрокаУсловие.Представление = Строка(СтрокаУсловие.УсловиеПредоставления);
				КонецЕсли;
				НоваяСтрокаУсловие.Действует        = СтрокаУсловие.Выполнено;
				НоваяСтрокаУсловие.УсловияВыполнены = СтрокаУсловие.Выполнено;
				НоваяСтрокаУсловие.Ссылка           = СтрокаДерева.Ссылка;
				НоваяСтрокаУсловие.ЭтоУсловие       = Истина;
				НоваяСтрокаУсловие.ИндексКартинки   = -1;
				НоваяСтрокаУсловие.ТолькоПросмотр   = Истина;
				НоваяСтрокаУсловие.НазначенаПользователем = Ложь;
				
				Если НЕ НоваяСтрокаУсловие.Действует Тогда
					ВсеУсловияВыполнены = Ложь;
				КонецЕсли;
				
			КонецЦикла;
			
			Если ВсеУсловияВыполнены Тогда
				СтрокаДерева.Действует = Истина;
				СтрокаДерева.УсловияВыполнены = Истина;
			Иначе
				СтрокаДерева.УсловияВыполнены = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СписокНазначенныхСкидок()
	
	УправляемыеСкидки = Новый СписокЗначений;
	
	ДеревоСкидок = РеквизитФормыВЗначение("ИнформацияОРасчетеСкидокПоДокументуВЦелом");
	НайденныеСтроки = ДеревоСкидок.Строки.НайтиСтроки(Новый Структура("НазначенаПользователем", Истина), Истина);
	Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		УправляемыеСкидки.Добавить(НайденнаяСтрока.Значение);
	КонецЦикла;
	
	Возврат УправляемыеСкидки;
	
КонецФункции

&НаКлиенте
Процедура РазвернутьДеревоДоУсловийРекурсивно(СтрокаДерева, ЭлементФормы)
	
	КоллекцияЭлементов = СтрокаДерева.ПолучитьЭлементы();
	Для каждого Элемент Из КоллекцияЭлементов Цикл
	
		Если Элемент.Разворачивать Тогда
			ЭлементФормы.Развернуть(Элемент.ПолучитьИдентификатор());
			РазвернутьДеревоДоУсловийРекурсивно(Элемент, ЭлементФормы);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
