#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ОтражатьВОперативномУчете И Не ОтражатьВБУиНУ И Не ОтражатьВУУ Тогда
		ТекстСообщения = НСтр("ru='Операция должна отражаться в одном из учетов'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , 
			"Объект.ОтражатьВОперативномУчете", , Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ОтражатьВОперативномУчете
		И (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПоставщикам
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам) Тогда
		
		ПроверитьРазрядностьНомеровОбъектовРасчета(Отказ);
		
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам
		Или Не ОтражатьВОперативномУчете Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДатаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДатаРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.НомерРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ОбъектРасчетовОтправитель");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДокументРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.СуммаРегл");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.СуммаУпр");
		
		ПроверитьЗаполнениеТабличнойЧастиРасчетыСПартнерами(Отказ, ХозяйственнаяОперация);
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПоставщикам Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДатаРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.НомерРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ОбъектРасчетовОтправитель");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДокументРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.СуммаРегл");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.СуммаУпр");
		
		ПроверитьЗаполнениеТабличнойЧастиРасчетыСПартнерами(Отказ, ХозяйственнаяОперация);
		
	КонецЕсли;
	
	ПроверитьДатыПервичныхДокументов(Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучатель");

	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
			ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Комментарий") Тогда
			Комментарий = ДанныеЗаполнения.Комментарий;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗначениеКопирования") Тогда
			ВводОстатковСервер.ЗаполнитьЗначенияПоСтаромуВводуОстатков(ЭтотОбъект, ДанныеЗаполнения.ЗначениеКопирования);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьЗаполнениеТабличнойЧастиРасчетыСПартнерами(Отказ, ХозяйственнаяОперация)

	НеобходимоПроверитьЗаполнениеПодарочныхСертификатов = Ложь;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам Тогда
		ИмяКолонкиСумма = НСтр("ru='Аванс'");
	Иначе
		ИмяКолонкиСумма = НСтр("ru='Долг'");
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из РасчетыСПартнерами Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ОбъектРасчетовОтправитель) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнена колонка ""Объект расчетов"" в строке %1 списка ""Расчеты с партнерами""'"),
					СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].ОбъектРасчетовОтправитель",
				,
				Отказ);
		КонецЕсли;
			
		Если ОтражатьВОперативномУчете
			 И Не ЗначениеЗаполнено(СтрокаТаблицы.ДокументРасчетов) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Не заполнена колонка ""Расчетный документ"" в строке %1 списка ""Расчеты с партнерами""'"),
						СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].ДокументРасчетов",
				,
				Отказ);
		КонецЕсли;
		
		Если ОтражатьВОперативномУчете = Истина
			И ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
			И ТипЗнч(СтрокаТаблицы.ОбъектРасчетов) = Тип("СправочникСсылка.ПодарочныеСертификаты") Тогда
			НеобходимоПроверитьЗаполнениеПодарочныхСертификатов = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Сумма) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнена колонка ""%1"" в строке %2 списка ""Расчеты с партнерами""'"),
					ИмяКолонкиСумма,
					СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].Сумма",
				,
				Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.СуммаРегл) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнена колонка ""%1 %2"" в строке %3 списка ""Расчеты с партнерами""'"),
					ИмяКолонкиСумма,
					НСтр("ru='(регл.)'"),
					СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].СуммаРегл",
				,
				Отказ);
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.СуммаУпр) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнена колонка ""%1 %2"" в строке %3 списка ""Расчеты с партнерами""'"),
					ИмяКолонкиСумма,
					НСтр("ru='(упр.)'"),
					СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].СуммаУпр",
				,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Если НеобходимоПроверитьЗаполнениеПодарочныхСертификатов Тогда
		ПодарочныеСертификатыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьРазрядностьНомеровОбъектовРасчета(Отказ)
	
	ШаблонСообщения = НСтр("ru='Длина номера объекта расчетов превышает допустимую длину (%Длина%) для выбранного объекта расчетов в строке %НомерСтроки%.'");
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПоставщикам
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам Тогда
		
		ТабличнаяЧасть    = РасчетыСПартнерами;
		ИмяТабличнойЧасти = "РасчетыСПартнерами";

	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТабличнаяЧасть Цикл
		Если СтрокаТаблицы.ОбъектРасчетов <> Неопределено Тогда
			ТипОбъектаРасчетов = ТипЗнч(СтрокаТаблицы.ОбъектРасчетов);
			ЭтоСправочник = Справочники.ТипВсеСсылки().СодержитТип(ТипОбъектаРасчетов);
			ЭтоДокумент = Документы.ТипВсеСсылки().СодержитТип(ТипОбъектаРасчетов);
			ДлинаНомера = 0;
			МетаданныеОбъектаРасчетов = Метаданные.НайтиПоТипу(ТипОбъектаРасчетов);
			Если ЭтоСправочник И МетаданныеОбъектаРасчетов <> Неопределено Тогда
				ДлинаНомера = МетаданныеОбъектаРасчетов.ДлинаКода;
			ИначеЕсли ЭтоДокумент И МетаданныеОбъектаРасчетов <> Неопределено Тогда
				ДлинаНомера = МетаданныеОбъектаРасчетов.ДлинаНомера;
			Иначе
				Возврат;
			КонецЕсли;
			Если (СтрДлина(СтрокаТаблицы.НомерРасчетногоДокумента) > ДлинаНомера)
				И ДлинаНомера > 0 Тогда
			ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Длина%", ДлинаНомера);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабличнойЧасти, СтрокаТаблицы.НомерСтроки, "НомерРасчетногоДокумента"),
				,
				Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДатыПервичныхДокументов(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивДокументов", РасчетыСПартнерами.ВыгрузитьКолонку("ДокументРасчетов"));
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПервичныйДокумент.Ссылка КАК Ссылка,
		|	НАЧАЛОПЕРИОДА(ПервичныйДокумент.Дата, ДЕНЬ) КАК Дата,
		|	ПервичныйДокумент.ТипПервичногоДокумента КАК ТипПервичногоДокумента
		|ИЗ
		|	Документ.ПервичныйДокумент КАК ПервичныйДокумент
		|ГДЕ
		|	ПервичныйДокумент.Ссылка В (&МассивДокументов)";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокиРасчетовПоДокументу = РасчетыСПартнерами.НайтиСтроки(Новый Структура("ДокументРасчетов", Выборка.Ссылка));
		Для Каждого СтрокаТаблицы Из СтрокиРасчетовПоДокументу Цикл
			Если Дата < Выборка.Дата Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Дата расчетного документа больше даты ввода начальных остатков в строке %1 списка ""Расчеты с партнерами""'"),
						СтрокаТаблицы.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ЭтотОбъект,
					,
					"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].ДокументРасчетов",
					Отказ);
			КонецЕсли;
			Если (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
					И (Выборка.ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ОплатаОтКлиента
						Или Выборка.ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.КорректировкаРеализации)
				Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам
					И (Выборка.ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ОплатаПоставщику
						Или Выборка.ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.КорректировкаПриобретения))
				И ЗначениеЗаполнено(СтрокаТаблицы.ДатаПлатежа)
				И СтрокаТаблицы.ДатаПлатежа < Выборка.Дата Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Дата погашения не может быть раньше даты платежа.'"),
						СтрокаТаблицы.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ЭтотОбъект,
					,
					"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].ДатаПлатежа",
					Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
