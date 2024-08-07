
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ДатаСегодня = НачалоДня(ТекущаяДатаСеанса());
	Справочники.СпособыОбеспеченияПотребностей.АктуализироватьГрафикЗаказовНаСервере(Объект, ДатаСегодня);

	ПереключательЗаказыФормируютсяНеПоПлану = ?(Объект.ФормироватьПлановыеЗаказы, 0, 1);
	ПереключательЗаказыФормируютсяПоПлану   = ?(Объект.ФормироватьПлановыеЗаказы, 1, 0);

	ОдинИсточник = ЗначениеЗаполнено(Объект.ИсточникОбеспеченияПотребностей);
	СписокВыбора = ЗаполнитьСписокВыбораТипаОбеспечения();
	
	// Приведение значения типа обеспечения к допустимому.
	Если СписокВыбора.НайтиПоЗначению(Объект.ТипОбеспечения) = Неопределено Тогда
		Если СписокВыбора.НайтиПоЗначению(Перечисления.ТипыОбеспечения.Покупка) <> Неопределено Тогда
			Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка;
		ИначеЕсли СписокВыбора.Количество() > 0 Тогда
			Объект.ТипОбеспечения = СписокВыбора[0].Значение;
		КонецЕсли;
	КонецЕсли;

	Если СписокВыбора.Количество() = 1 Тогда
		Элементы.ТипОбеспечения1.Видимость = Ложь;
		Элементы.ТипОбеспечения2.Видимость = Ложь;
		Элементы.ТипОбеспечения3.Видимость = Ложь;
		Элементы.ТипОбеспечения4.Видимость = Ложь;
		Элементы.ТипОбеспечения5.Видимость = Ложь;
	КонецЕсли;

	НастроитьФормуПоТипуОбеспечения();
	СоглашениеПриИзмененииСервер(Ложь);
	АктивизироватьСтраницыРежимИспользования(Элементы, ОдинИсточник);
	АктивизироватьСтраницыПравилоФормирования(Элементы, Объект.ФормироватьПлановыеЗаказы);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);
	СформироватьЗаголовкиПоясняющихНадписей();

	Элементы.Поставщик.ОграничениеТипа              = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
	Элементы.Склад.ОграничениеТипа                  = Новый ОписаниеТипов("СправочникСсылка.Склады");
	Элементы.Переработчик.ОграничениеТипа           = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
	Элементы.ПодразделениеДиспетчер.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ФормироватьПлановыеЗаказы Тогда
		ТекущийОбъект.ОбеспечиваемыйПериод = 0;
		ТекущийОбъект.ГарантированныйСрокОбеспечения = 0;
	Иначе
		// Очистка дат по графику заказов.
		ТекущийОбъект.ПлановаяДатаЗаказа    = '00010101';
		ТекущийОбъект.ПлановаяДатаПоставки  = '00010101';
		ТекущийОбъект.ДатаСледующейПоставки = '00010101';
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОбеспечения", Объект.ТипОбеспечения);
	Оповестить("Запись_СпособОбеспеченияПотребностей", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОдинИсточник = 1 И Не ЗначениеЗаполнено(Объект.ИсточникОбеспеченияПотребностей) Тогда
		
		Если Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка Тогда
			ТекстСообщения = НСтр("ru='Поле ""Поставщик"" не заполнено'");
		ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
			ТекстСообщения = НСтр("ru='Поле ""Распределительный центр"" не заполнено'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ИсточникОбеспеченияПотребностей", "Объект"); 
		Отказ = Истина;
	КонецЕсли;
	
	ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОбеспеченияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	Объект.ИсточникОбеспеченияПотребностей = Неопределено;
	Объект.Соглашение = Неопределено;
	Объект.ВидЦеныПоставщика = Неопределено;
	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда
		ОдинИсточник = 0;
		Объект.ДлительностьВДнях = 0;
		АктивизироватьСтраницыРежимИспользования(Элементы, Ложь);
	КонецЕсли;
	
	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда
		Объект.ДлительностьВДнях = 0;
	КонецЕсли;
	
	
	НастроитьФормуПоТипуОбеспечения();
	СоглашениеПриИзмененииСервер(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПокупкиПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокПеремещенияПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокСборкиПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокПроизводстваПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияЗаказаПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбеспечиваемыйПериодПриИзменении(Элемент)

	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПереключательЗаказыФормируютсяНеПоПлануПриИзменении(Элемент)

	ПереключательЗаказыФормируютсяНеПоПлану = 1;
	ПереключательЗаказыФормируютсяПоПлану   = 0;
	
	Объект.ПлановаяДатаПоставки  = '00010101'; //очистка даты
	Объект.ДатаСледующейПоставки = '00010101'; //очистка даты
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);

	Объект.ФормироватьПлановыеЗаказы        = Ложь;
	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();

	АктивизироватьСтраницыПравилоФормирования(Элементы, Объект.ФормироватьПлановыеЗаказы);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПереключательЗаказыФормируютсяПоПлануПриИзменении(Элемент)

	ПереключательЗаказыФормируютсяНеПоПлану = 0;
	ПереключательЗаказыФормируютсяПоПлану   = 1;

	Объект.ОбеспечиваемыйПериод = 0;
	Объект.ГарантированныйСрокОбеспечения = 0;

	Объект.ФормироватьПлановыеЗаказы        = Истина;

	АктивизироватьСтраницыПравилоФормирования(Элементы, Объект.ФормироватьПлановыеЗаказы);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПереключательПолуфабрикатыПланироватьАвтоматическиПриИзменении(Элемент)
	
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательПолуфабрикатыПланироватьВручнуюПриИзменении(Элемент)
	
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимИспользованияНесколькоИсточниковПриИзменении(Элемент)
	
	Объект.ИсточникОбеспеченияПотребностей = Неопределено;
	Объект.Соглашение = Неопределено;
	СоглашениеПриИзмененииСервер(Истина);
	
	АктивизироватьСтраницыРежимИспользования(Элементы, Ложь);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикПриИзменении(Элемент)
	СоглашениеПриИзмененииСервер(Истина);
КонецПроцедуры


&НаКлиенте
Процедура РежимИспользованияОдинИсточникПриИзменении(Элемент)
	
	АктивизироватьСтраницыРежимИспользования(Элементы, Истина);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаБлижайшейПоставкиПриИзменении(Элемент)

	ОчиститьСообщения();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДатаСледующейПоставкиПриИзменении(Элемент)

	ОчиститьСообщения();
	ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СборкаДлительностьВДняхПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПеремещениеДлительностьВДняхПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОбеспечения();
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СоглашениеПриИзменении(Элемент)
	
	СоглашениеПриИзмененииСервер(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииРаботыСДатами

&НаСервереБезКонтекста
Функция ОпределитьДатуЗаказаПоДатеПоставки(ДатаПоставки, СрокИсполненияЗаказа)

	Если Не ЗначениеЗаполнено(ДатаПоставки) Тогда
		Возврат НСтр("ru = 'для расчета заполните дату ближайшей поставки'");
	КонецЕсли;

	Возврат Справочники.СпособыОбеспеченияПотребностей.ОпределитьДатуЗаказаПоДатеПоставки(ДатаПоставки, СрокИсполненияЗаказа);

КонецФункции

&НаСервереБезКонтекста
Функция ОпределитьДатуПоставкиПоДатеЗаказа(СрокИсполненияЗаказа, ОбеспечиваемыйПериод)

	ДатаЗаказа = НачалоДня(ТекущаяДатаСеанса());
	Результат = Новый Структура("ДатаПоставки, ГраницаПериода");

	КалендарьПредприятия = Константы.ОсновнойКалендарьПредприятия.Получить();

	Если ЗначениеЗаполнено(КалендарьПредприятия) Тогда

		Результат.ДатаПоставки = КалендарныеГрафики.ДатаПоКалендарю(
			КалендарьПредприятия, ДатаЗаказа, СрокИсполненияЗаказа, Ложь);

	Иначе

		Результат.ДатаПоставки = ДатаЗаказа + СрокИсполненияЗаказа * 86400; //86400 - длительность суток в секундах

	КонецЕсли;

	Если Результат.ДатаПоставки = Неопределено Тогда

		Результат.ДатаПоставки   = НСтр("ru = 'не заполнен график работы предприятия'");
		Результат.ГраницаПериода = НСтр("ru = 'не заполнен график работы предприятия'");

	Иначе

		Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда

			Результат.ДатаПоставки = Формат(Результат.ДатаПоставки, "ДЛФ=D");
			Результат.ГраницаПериода = НСтр("ru = '<варьируется по складам>'");

		ИначеЕсли ОбеспечиваемыйПериод = 0 Тогда

			Результат.ДатаПоставки = Формат(Результат.ДатаПоставки, "ДЛФ=D");
			Результат.ГраницаПериода = НСтр("ru = 'не ограничена'");

		Иначе

			СкладПоУмолчанию = Справочники.Склады.СкладПоУмолчанию();
			Если ЗначениеЗаполнено(СкладПоУмолчанию) Тогда

				КалендарьСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СкладПоУмолчанию, "Календарь");
				Если Не ЗначениеЗаполнено(КалендарьСклада) Тогда
					КалендарьСклада = КалендарьПредприятия;
				КонецЕсли;

				Если ЗначениеЗаполнено(КалендарьСклада) Тогда

					Результат.ГраницаПериода = КалендарныеГрафики.ДатаПоКалендарю(
						КалендарьСклада, Результат.ДатаПоставки, ОбеспечиваемыйПериод, Ложь);

					Если Результат.ГраницаПериода = Неопределено Тогда
						Результат.ГраницаПериода = НСтр("ru = 'не заполнен график работы склада'");
					Иначе
						Результат.ГраницаПериода = Формат(Результат.ГраницаПериода, "ДЛФ=D");
					КонецЕсли;

				Иначе

					Результат.ГраницаПериода = Результат.ДатаПоставки + ОбеспечиваемыйПериод * 86400; //86400 - длительность суток в секундах
					Результат.ГраницаПериода = Формат(Результат.ГраницаПериода, "ДЛФ=D");

				КонецЕсли;

			Иначе

				Результат.ГраницаПериода = НСтр("ru = '<варьируется по складам>'");

			КонецЕсли;

			Результат.ДатаПоставки = Формат(Результат.ДатаПоставки, "ДЛФ=D");

		КонецЕсли;

	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня, Отказ = Неопределено)

	ДатаПоставки                = Объект.ПлановаяДатаПоставки;
	ДатаСледующейПоставки       = Объект.ДатаСледующейПоставки;
	ФормироватьПлановыеЗаказы   = Объект.ФормироватьПлановыеЗаказы;
	ПлановаяДатаЗаказа          = Объект.ПлановаяДатаЗаказа;

	Если ФормироватьПлановыеЗаказы Тогда

		Если ЗначениеЗаполнено(ДатаПоставки) И ДатаПоставки < НачалоДня(ДатаСегодня) Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Недопустимо устанавливать в график прошедшую дату.
				| Если ближайшая поставка не запланирована, необходимо оставить дату пустой.'"),
				, "Объект.ПлановаяДатаПоставки");
			Отказ = Истина;

		КонецЕсли;

		Если ЗначениеЗаполнено(ДатаСледующейПоставки) И НачалоДня(ДатаСледующейПоставки) <= НачалоДня(ДатаПоставки) Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Дата следующей поставки должна быть позднее даты ближайшей поставки.
				| Если следующая поставка не запланирована, необходимо оставить дату пустой.'"),
				, "Объект.ДатаСледующейПоставки");
			Отказ = Истина;

		КонецЕсли;

		Если ЗначениеЗаполнено(ДатаПоставки) И НачалоДня(ПлановаяДатаЗаказа) < НачалоДня(ДатаСегодня) Тогда
			
			Если ЗначениеЗаполнено(ПлановаяДатаЗаказа) Тогда
				Шаблон = НСтр("ru = 'Недопустимо устанавливать в график дату поставки, на которую просрочена дата заказа (%1). Если ближайшая поставка не запланирована, необходимо оставить дату поставки пустой.'");
				ДатаСтрокой = Формат(ПлановаяДатаЗаказа, "ДЛФ=D;");
				ТекстСообщения = СтрШаблон(Шаблон, ДатаСтрокой);
			Иначе
				ТекстСообщения = НСтр("ru = 'Недопустимо устанавливать в график дату поставки, на которую не определена дата заказа. Если ближайшая поставка не запланирована, необходимо оставить дату поставки пустой.'");
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ПлановаяДатаПоставки");
			Отказ = Истина;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьТекстПоясняющихНадписей(Форма)

	Форма.ДатаФормированияЗаказаИнфо = "";
	Форма.ДатаОтгрузкиПоГарантированномуСрокуИнфо = "";
	Форма.ДатаБлижайшейПоставкиИнфо  = "";
	Форма.ГраницаОбеспечиваемогоПериодаИнфо = "";

	Если Форма.Объект.ФормироватьПлановыеЗаказы Тогда

		Форма.ДатаФормированияЗаказаИнфо        = Формат(Форма.Объект.ПлановаяДатаЗаказа,    "ДЛФ=D");
		Форма.ДатаБлижайшейПоставкиИнфо         = Формат(Форма.Объект.ПлановаяДатаПоставки,  "ДЛФ=D");
		Форма.ДатаОтгрузкиПоГарантированномуСрокуИнфо = Формат(Форма.Объект.ПлановаяДатаПоставки, "ДЛФ=D");
		Форма.ГраницаОбеспечиваемогоПериодаИнфо = Формат(Форма.Объект.ДатаСледующейПоставки, "ДЛФ=D");

	Иначе

		ГарантированныйСрок = ОпределитьДатуПоставкиПоДатеЗаказа(
			Форма.Объект.ГарантированныйСрокОбеспечения, Форма.Объект.ОбеспечиваемыйПериод);

		Длительность = ОпределитьДатуПоставкиПоДатеЗаказа(Форма.Объект.СрокИсполненияЗаказа, Форма.Объект.ОбеспечиваемыйПериод);
		Форма.ДатаФормированияЗаказаИнфо        = Формат(Форма.ДатаСегодня, "ДЛФ=D");
		Форма.ДатаБлижайшейПоставкиИнфо         = Длительность.ДатаПоставки;
		Форма.ДатаОтгрузкиПоГарантированномуСрокуИнфо = ГарантированныйСрок.ДатаПоставки;
		Форма.ГраницаОбеспечиваемогоПериодаИнфо = Длительность.ГраницаПериода;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовкиПоясняющихНадписей()

	НадписьРасчет = НСтр("ru = 'Расчет даты ближайшей возможной поставки и даты отгрузки при приеме заказов к обеспечению.'");
	НадписьДатаОтгрузки = НСтр("ru = 'Дата отгрузки заказов к обеспечению:'");

	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа поставщику:'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата поступления по заказу:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:'");

	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа на перемещение:'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата окончания перемещения по заказу:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:'");

	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа на сборку:'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата окончания сборки по заказу:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:'");
	КонецЕсли;

	Если Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы поставщику.'");
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы на перемещение.'");
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.СборкаРазборка Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы на сборку.'");
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Производство Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы на производство.'");
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.ПроизводствоНаСтороне Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы переработчику.'");
	Иначе
		ПояснениеТипаОбеспечения = "";
	КонецЕсли; 
	
	Элементы.ПояснениеТипОбеспечения.Заголовок = ПояснениеТипаОбеспечения;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоТипуОбеспечения()
	
	Элементы.Соглашение.Видимость = Ложь;
	Элементы.ВидЦеныПоставщика.Видимость = Ложь;
	Элементы.СтраницаОрганизацияПоСоглашению.Видимость = Ложь;
	Если Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Истина;
		Элементы.СтраницыТипОбеспечения.Видимость = Ложь;
		Элементы.Соглашение.Видимость = Истина;
		Элементы.ВидЦеныПоставщика.Видимость = Истина;
		Элементы.СтраницаОрганизацияПоСоглашению.Видимость = Истина;
		
		Элементы.СтраницыРежимИспользования.ТекущаяСтраница = Элементы.СтраницаРежимИспользованияПокупка;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница    = Элементы.СтраницаСрокПокупки;
		
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Истина;
		Элементы.СтраницыТипОбеспечения.Видимость     = Истина;
		
		Элементы.СтраницыРежимИспользования.ТекущаяСтраница = Элементы.СтраницаРежимИспользованияПеремещение;
		Элементы.СтраницыТипОбеспечения.ТекущаяСтраница     = Элементы.СтраницаПеремещение;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница    = Элементы.СтраницаСрокПеремещения;
		
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.СборкаРазборка Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Ложь;
		Элементы.СтраницыТипОбеспечения.Видимость     = Истина;
		
		Элементы.СтраницыТипОбеспечения.ТекущаяСтраница  = Элементы.СтраницаСборка;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница = Элементы.СтраницаСрокСборки;
		
	КонецЕсли;
	
	Элементы.Подразделение.Видимость = Объект.ТипОбеспечения <> Перечисления.ТипыОбеспечения.Производство;
	
	Элементы.ГруппаПравилоФормированияЗаказовНаПроизводствоПолуфабрикатов.Видимость = Ложь;
	
	СформироватьЗаголовкиПоясняющихНадписей();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура АктивизироватьСтраницыРежимИспользования(Элементы, ОдинИсточник)
	
	Элементы.СтраницыРежимИспользованияПокупкаПояснение.ТекущаяСтраница = ?(ОдинИсточник,
		Элементы.РежимИспользованияОдинПоставщикПояснение, Элементы.РежимИспользованияНесколькоПоставщиковПояснение);
		
	Элементы.СтраницыРежимИспользованияПеремещениеПояснение.ТекущаяСтраница = ?(ОдинИсточник,
		Элементы.РежимИспользованияОдинСкладПояснение, Элементы.РежимИспользованияНесколькоСкладовПояснение);
	
	Элементы.Поставщик.Доступность = ОдинИсточник;
	Элементы.Склад.Доступность     = ОдинИсточник;
	
	Элементы.ВидЦеныПоставщика.Доступность = ОдинИсточник;
	Элементы.Соглашение.Доступность        = ОдинИсточник;
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура АктивизироватьСтраницыПравилоФормирования(Элементы, ФормироватьПлановыеЗаказы)
	
	Элементы.СтраницыОбеспечиваемыйПериод.ТекущаяСтраница = ?(ФормироватьПлановыеЗаказы,
		Элементы.СтраницаОбеспечиваемыйПериодНедоступен,
		Элементы.СтраницаОбеспечиваемыйПериод);
	
	Элементы.СтраницыДатыПоставок.ТекущаяСтраница = ?(ФормироватьПлановыеЗаказы,
		Элементы.СтраницаДатыПоставок,
		Элементы.СтраницаДатыПоставокНедоступны);
	
КонецПроцедуры

&НаКлиенте
Функция ТекстОшибкиСрокаИсполненияЗаказа()

	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда
		Пояснение = НСтр("ru = 'Срок перемещения не может быть меньше длительности перемещения. Срок перемещения увеличен.'");
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда
		Пояснение = НСтр("ru = 'Срок сборки не может быть меньше длительности сборки/разборки. Срок сборки увеличен.'");
	Иначе
		Пояснение = "";
	КонецЕсли;

	Возврат Пояснение;

КонецФункции

&НаКлиенте
Процедура СкорректироватьСрокИсполненияЗаказа()

	Если Не Объект.ФормироватьПлановыеЗаказы
		И Объект.СрокИсполненияЗаказа < Объект.ДлительностьВДнях Тогда

		ТекстОшибки = ТекстОшибкиСрокаИсполненияЗаказа();
		Если ТекстОшибки <> "" Тогда

			ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение связанных реквизитов'"),,ТекстОшибки);
			Объект.СрокИсполненияЗаказа = Объект.ДлительностьВДнях;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ТекстОшибкиГарантированногоСрокаОтгрузки()

	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока перемещения. Гарантированный срок отгрузки увеличен.'");
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока сборки/разборки. Гарантированный срок отгрузки увеличен.'");
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока покупки. Гарантированный срок отгрузки увеличен.'");
	Иначе
		Пояснение = "";
	КонецЕсли;

	Возврат Пояснение;

КонецФункции

&НаКлиенте
Процедура СкорректироватьГарантированныйСрокОбеспечения()

	Если Не Объект.ФормироватьПлановыеЗаказы
		И Объект.ГарантированныйСрокОбеспечения < Объект.СрокИсполненияЗаказа Тогда

		ТекстОшибки = ТекстОшибкиГарантированногоСрокаОтгрузки();
		Если ТекстОшибки <> "" Тогда

			ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение связанных реквизитов'"),,ТекстОшибки);
			Объект.ГарантированныйСрокОбеспечения = Объект.СрокИсполненияЗаказа;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписокВыбораТипаОбеспечения()
	
	// Заполнение списка выбора доступных типов обеспечения.
	СписокВыбора = Новый СписокЗначений;
	
	// Заполняем возможные типы обеспечения в зависимости от функциональных опций.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Покупка);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеТоваров")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение")
		Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Перемещение);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСборкуРазборку")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.СборкаРазборка, НСтр("ru = 'Сборка'"));
	КонецЕсли;
	
	
	Для НомерПереключателя = 1 По 5 Цикл
		ИмяЭлемента = "ТипОбеспечения" + НомерПереключателя;
		Элементы[ИмяЭлемента].СписокВыбора.Очистить();
		Если НомерПереключателя <= СписокВыбора.Количество() Тогда
			ЗначениеВыбора = СписокВыбора.Получить(НомерПереключателя-1);
			Элементы[ИмяЭлемента].СписокВыбора.Добавить(ЗначениеВыбора.Значение, ЗначениеВыбора.Представление);
		Иначе
			Элементы[ИмяЭлемента].Видимость = Ложь;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат СписокВыбора;

КонецФункции

&НаСервере
Процедура СоглашениеПриИзмененииСервер(ОчиститьПодчиненныеРеквизиты)
	
	Если ОчиститьПодчиненныеРеквизиты Тогда
		Объект.ВидЦеныПоставщика = Неопределено;
		Объект.Организация = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Соглашение)
			И Не ЗначениеЗаполнено(Объект.ВидЦеныПоставщика)
			И Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Соглашение, "ВидЦеныПоставщика,Организация,СрокПоставки");
		ВидЦеныПоСоглашению = ЗначенияРеквизитов.ВидЦеныПоставщика;
		ОрганизацияПоСоглашению = ЗначенияРеквизитов.Организация;
		Если ОчиститьПодчиненныеРеквизиты Тогда
			Объект.СрокИсполненияЗаказа = ЗначенияРеквизитов.СрокПоставки;
		КонецЕсли;
		Элементы.СтраницыОрганизация.ТекущаяСтраница = Элементы.СтраницаОрганизацияПоСоглашению;
	Иначе
		Элементы.СтраницыОрганизация.ТекущаяСтраница = Элементы.СтраницаОрганизация;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
