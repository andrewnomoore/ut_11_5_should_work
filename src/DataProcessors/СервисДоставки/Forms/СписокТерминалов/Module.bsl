#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СервисДоставки.ПравоРаботыССервисомДоставки(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	Параметры.Свойство("ВсеТерминалы", ВсеТерминалы);
	
	Если НЕ ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("Адрес", Адрес);
	Параметры.Свойство("АдресЗначение", АдресЗначение);
	Параметры.Свойство("Направление", Направление);
	Параметры.Свойство("ГрузоперевозчикИдентификатор", ГрузоперевозчикИдентификатор);
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	Параметры.Свойство("НаселенныйПунктИдентификатор", НаселенныйПункт);
	Параметры.Свойство("Идентификатор", ТекущийТерминалИдентификатор);
	
	СервисДоставкиСлужебный.ПроверитьОрганизациюБизнесСети(ОрганизацияБизнесСетиСсылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Запуск фонового задания для загрузки доступных форм.
	ФоновоеЗаданиеПолучитьДоступныеТерминалы = ПолучитьДоступныеТерминалыВФоне();
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ФоновоеЗаданиеПолучитьДоступныеТерминалы) Тогда
		
		ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
		ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеТерминалы();
		ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение списка доступных терминалов.'");
		
		ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации);
		
	КонецЕсли;
	
	Если ВсеТерминалы Тогда
		УстановитьОтборПоНаселенномуПункту();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КарточкаТерминалаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Если Расшифровка = "Грузоперевозчик" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуГрузоперевозчика();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктПриИзменении(Элемент)
	
	УстановитьОтборПоНаселенномуПункту();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура ТерминалыПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		КарточкаТерминала = Новый ТабличныйДокумент();
		Возврат;
	КонецЕсли;
	
	ТекущийТерминал = ТекущаяСтрока.Наименование;
	ТекущийТерминалИдентификатор = ТекущаяСтрока.Идентификатор;
	
	СформироватьКарточкуТерминала(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Выбрать(Элемент.Имя);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущийТерминалИдентификатор) Тогда
		
		ПараметрыРезультата = Новый Структура;
		ПараметрыРезультата.Вставить("Терминал", ТекущаяСтрока.Наименование);
		ПараметрыРезультата.Вставить("ТерминалИдентификатор", ТекущаяСтрока.Идентификатор);
		ПараметрыРезультата.Вставить("ТерминалИдентификаторВСистемеГрузоперевозчика", ТекущаяСтрока.ИдентификаторВСистемеГрузоперевозчика);
		ПараметрыРезультата.Вставить("ГрузоперевозчикНаименование", ТекущаяСтрока.ГрузоперевозчикНаименование);
		ПараметрыРезультата.Вставить("ГрузоперевозчикИдентификатор", ТекущаяСтрока.ГрузоперевозчикИдентификатор);
		ПараметрыРезультата.Вставить("Адрес", ТекущаяСтрока.Адрес);
		ПараметрыРезультата.Вставить("Телефон", ТекущаяСтрока.Телефон);
		ПараметрыРезультата.Вставить("ТипНаименование", ТекущаяСтрока.ТипНаименование);
		ПараметрыРезультата.Вставить("ТипИдентификатор", ТекущаяСтрока.ТипИдентификатор);
		ПараметрыРезультата.Вставить("НаселенныйПунктИдентификатор", ТекущаяСтрока.НаселенныйПунктИдентификатор);
		
		Закрыть(ПараметрыРезультата);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнитьЗапрос

&НаКлиенте
Процедура ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации)
	
	ВыводитьОкноОжидания = ?(ЗначениеЗаполнено(ПараметрыОперации.ВыводитьОкноОжидания),
																	ПараметрыОперации.ВыводитьОкноОжидания,
																	Ложь);
	// Установка картинки длительной операции.
	Если Не ВыводитьОкноОжидания Тогда
		
		Если ПараметрыОперации.ИмяПроцедуры 
			= СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеТерминалы() Тогда
			
			Элементы.ДекорацияОжидание.Видимость = Истина;
			Элементы.ДекорацияСостояние.Заголовок = НСтр("ru='Идет загрузка...'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Инициализация обработчик ожидания завершения.
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = ПараметрыОперации.НаименованиеОперации;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	ПараметрыОжидания.Вставить("ИдентификаторЗадания", ФоновоеЗадание.ИдентификаторЗадания);
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыполнитьЗапросЗавершение",
		ЭтотОбъект, ПараметрыОперации);
		
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, ОбработкаЗавершения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Инициализация.
	Отказ = Ложь;
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ДополнительныеПараметры.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	
	// Скрыть элементы ожидания на форме
	Элементы.ДекорацияОжидание.Видимость = Ложь;
	Элементы.ДекорацияСостояние.Заголовок = "";
	
	// Вывод сообщений из фонового задания.
	СервисДоставкиКлиент.ОбработатьРезультатФоновогоЗадания(Результат, ДополнительныеПараметры, Отказ);
	Если Результат = Неопределено ИЛИ ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка результата поиска.
	Если Не Отказ И Результат.Статус = "Выполнено" Тогда
		Если ЗначениеЗаполнено(Результат.АдресРезультата) И ЭтоАдресВременногоХранилища(Результат.АдресРезультата)
			И ДополнительныеПараметры.ФоновоеЗадание.ИдентификаторЗадания
			= ЭтотОбъект[ИмяФоновогоЗадания].ИдентификаторЗадания Тогда

			Если ДополнительныеПараметры.ИмяПроцедуры
				= СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеТерминалы() Тогда
				
				// Загрузка результатов запроса.
				ОперацияВыполнена = Истина;
				ПредыдущийТерминалИдентификатор = ТекущийТерминалИдентификатор;
				ЗагрузитьРезультатПолученияСпискаДоступныхТерминалов(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				Если ВсеТерминалы Тогда
					Элементы.НаселенныйПункт.Доступность = ОперацияВыполнена;
					Если ПредыдущийТерминалИдентификатор <> "" Тогда
						ПоискТерминала = Список.НайтиСтроки(Новый Структура("Идентификатор",
							ПредыдущийТерминалИдентификатор));
						Если ПоискТерминала.Количество() Тогда
							Элементы.Список.ТекущаяСтрока = ПоискТерминала[0].ПолучитьИдентификатор();
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;
	
	// Отработать видимость доступность после запроса
	КоличествоСтрок = Список.Количество();
	Если КоличествоСтрок = 0 Тогда
		СостояниеВыполненияЗапроса = НСтр("ru = 'Нет доступных терминалов по указанному адресу'");
	ИначеЕсли ВсеТерминалы И Не ЗначениеЗаполнено(НаселенныйПункт) Тогда
		СостояниеВыполненияЗапроса = НСтр("ru = 'Выберите населенный пункт и подходящий терминал'");
	Иначе
		СостояниеВыполненияЗапроса = НСтр("ru = 'Выберите подходящий терминал'");
	КонецЕсли;
	
	Элементы.ДекорацияСостояние.Заголовок = СостояниеВыполненияЗапроса;
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнитьЗапросВФоне

&НаСервере
Функция ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации)
	
	// Проверка подключения Интернет-поддержки пользователей.
	ИнтернетПоддержкаПодключена
	= ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Если Не ИнтернетПоддержкаПодключена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отказ = Ложь;
	ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыОперации, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	Если ФоновоеЗадание <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ФоновоеЗадание.ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.'"),
		ПараметрыОперации.НаименованиеОперации);
	Задание.ИмяПроцедуры = "СервисДоставки." + ПараметрыОперации.ИмяПроцедуры;
	Задание.ПараметрыПроцедуры = ПараметрыЗапроса;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры,
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДоступныеТерминалыВФоне()
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеТерминалы();
	ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение списка доступных терминалов.'");
	
	Возврат ВыполнитьЗапросВФоне(Ложь, ПараметрыОперации);
	
КонецФункции

#КонецОбласти

#Область ПараметрыЗапроса

&НаСервере
Функция ПараметрыЗапроса(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = Новый Структура();
	
	ИмяПроцедуры = ПараметрыОперации.ИмяПроцедуры;
	
	Если ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеТерминалы() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаСпискаДоступныхТерминалов(ПараметрыЗапроса, Отказ);
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

&НаСервере
Функция ПараметрыЗапросаСпискаДоступныхТерминалов(ПараметрыЗапроса, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаПолучитьДоступныеТерминалы();
	
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ЭтотОбъект);
	
	Отказ = Не ЗначениеЗаполнено(Направление);
	Отказ = Не ЗначениеЗаполнено(ГрузоперевозчикИдентификатор);
	
	Если Не ВсеТерминалы Тогда
		Отказ = Не ЗначениеЗаполнено(АдресЗначение);
		ПараметрыЗапроса.АдресЗначение = Новый ХранилищеЗначения(АдресЗначение,Новый СжатиеДанных(9));
	КонецЕсли;
	
	Возврат ПараметрыЗапроса;

КонецФункции

#КонецОбласти

#Область ЗагрузитьРезультаты

&НаСервере
Процедура ЗагрузитьРезультатПолученияСпискаДоступныхТерминалов(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если ВсеТерминалы И Результат.Свойство("СписокНаселенныхПунктов") Тогда
				Если Не ЗначениеЗаполнено(Результат.СписокНаселенныхПунктов) Тогда
					ОперацияВыполнена = Ложь;
					ОбщегоНазначения.СообщитьПользователю(НСтр(
						"ru = 'Не удалось определить населенные пункты, повторите действие позже'"));
					Возврат;
				КонецЕсли;	
				Для Каждого Элемент Из Результат.СписокНаселенныхПунктов Цикл
					ЗаполнитьЗначенияСвойств(Элементы.НаселенныйПункт.СписокВыбора.Добавить(), Элемент);
				КонецЦикла;
			КонецЕсли;
			
			Список.Очистить();
			Если Результат.Свойство("Список") Тогда
				Если ТипЗнч(Результат.Список) = Тип("Массив") Тогда
					Для Каждого Терминал Из Результат.Список Цикл
						
						НовыйТерминал = Список.Добавить();
						ЗаполнитьЗначенияСвойств(НовыйТерминал, Терминал);
						
						ГрафикРаботы = Терминал.ГрафикРаботы;
						Для Каждого ТекущаяСтрока Из ГрафикРаботы Цикл
							
							НоваяСтрока = НовыйТерминал.ГрафикРаботыСписок.Добавить();
							ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
							
						КонецЦикла;
						
					КонецЦикла;
				КонецЕсли;
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление() 
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифтБЭД);
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Адрес");
	Элементы.НаселенныйПункт.Видимость = ВсеТерминалы;
	Элементы.Адрес.Видимость = Не ВсеТерминалы;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКарточкуТерминала(ИдентификаторСтроки)
	
	ДанныеТерминала = Список.НайтиПоИдентификатору(ИдентификаторСтроки);
	КарточкаТерминала = ТабличныйДокументКарточкаТерминала(ДанныеТерминала);
	
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументКарточкаТерминала(ДанныеТерминала)
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Макет = Обработка.ПолучитьМакет("Терминал");
	
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	
	ПараметрыОбласти = ОбластьМакетаШапка.Параметры;
	
	ПараметрыОбласти.Наименование = ДанныеТерминала.Наименование;
	ПараметрыОбласти.ТипНаименование = ДанныеТерминала.ТипНаименование;
	ПараметрыОбласти.Адрес = ДанныеТерминала.Адрес;
	ПараметрыОбласти.Телефон = ДанныеТерминала.Телефон;
	ПараметрыОбласти.ГрузоперевозчикНаименование = ДанныеТерминала.ГрузоперевозчикНаименование;
	ПараметрыОбласти.РасшифровкаГрузоперевозчик = "Грузоперевозчик";
	
	ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
	
	Если ДанныеТерминала.Описание <> "" Тогда
		ОбластьМакетаОписание = Макет.ПолучитьОбласть("Описание");
		ОбластьМакетаОписание.Параметры.Описание = ДанныеТерминала.Описание;
		ТабличныйДокумент.Вывести(ОбластьМакетаОписание);
	КонецЕсли;
	
	Если ДанныеТерминала.ГрафикРаботыСписок.Количество() > 0 Тогда
		
		ОбластьМакетаЗаголовокТаблицыГрафикРаботы = Макет.ПолучитьОбласть("ЗаголовокТаблицыГрафикРаботы");
		ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовокТаблицыГрафикРаботы);
		
		ОбластьМакетаСтрокаТаблицыГрафикРаботы = Макет.ПолучитьОбласть("СтрокаТаблицыГрафикРаботы");
		
		Для Каждого ТекущаяСтрока Из ДанныеТерминала.ГрафикРаботыСписок Цикл
			ОбластьМакетаСтрокаТаблицыГрафикРаботы.Параметры.Заполнить(ТекущаяСтрока);
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрокаТаблицыГрафикРаботы);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуГрузоперевозчика()
	
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Идентификатор", ГрузоперевозчикИдентификатор);
	ПараметрыОткрытияФормы.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	ПараметрыОткрытияФормы.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
	
	ОткрытьФорму("Обработка.СервисДоставки.Форма.КарточкаГрузоперевозчика", 
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
							
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокФормы()
	
	Если Направление = 1 Тогда
		ЗаголовокПредставление = НСтр("ru='Пункты приемки заказов'");
	ИначеЕсли Направление = 2 Тогда
		ЗаголовокПредставление = НСтр("ru='Пункты выдачи заказов'");
	Иначе
		ЗаголовокПредставление = НСтр("ru='Пункты приема-выдачи заказов'");
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='%1: %2'"),
		СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(ТипГрузоперевозки),
		ЗаголовокПредставление);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоНаселенномуПункту()
	
	Отбор = Новый Структура("НаселенныйПунктИдентификатор", НаселенныйПункт);
	Элементы.Список.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	
КонецПроцедуры

#КонецОбласти
