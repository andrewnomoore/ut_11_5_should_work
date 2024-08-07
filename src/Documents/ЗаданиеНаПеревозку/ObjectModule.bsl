#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаданийНаПеревозку[НовыйСтатус];
	
	Если ЭтотОбъект.Операция = Перечисления.ВидыДоставки.СоСклада
		И Статус <> Перечисления.СтатусыЗаданийНаПеревозку.Отправлено
		И Статус <> Перечисления.СтатусыЗаданийНаПеревозку.Закрыто
		И СкладыСервер.ЕстьОрдерныйНаОтгрузкуСклад(Распоряжения.ВыгрузитьКолонку("Склад"),Дата)
		И (ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаданийНаПеревозку.Отправлено
			Или ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаданийНаПеревозку.Закрыто) Тогда
			
		Если ДоставкаТоваров.ПерезаполнитьЗаданиеНаПеревозкуПоРасходнымОрдерам(ЭтотОбъект) Тогда // есть изменения после перезаполнения
			
			Если Распоряжения.Количество() = 0 Тогда
				Текст = НСтр("ru = 'Статус документа %Задание% не установлен, т.к. после перезаполнения по расходным ордерам в нем не остается распоряжений.'");
				Текст = СтрЗаменить(Текст, "%Задание%", Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, Ссылка);
				Возврат Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаданиеНаПеревозкуЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыЗаданийНаПеревозку.Формируется;
	ДатаВремяРейсаПланС  = Макс(ОбъектКопирования.ДатаВремяРейсаПланС, ТекущаяДатаСеанса());
	ДатаВремяРейсаПланПо = Дата(1,1,1);
	ДатаВремяРейсаФактС  = Дата(1,1,1);
	ДатаВремяРейсаФактПо = Дата(1,1,1);
	Вес                  = 0;
	Объем                = 0;
	КоличествоПунктов    = 0;
	Ответственный        = Пользователи.ТекущийПользователь();
	Распоряжения.Очистить();
	Маршрут.Очистить();
	
	ЗаданиеНаПеревозкуЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Вручную ТЧ Распоряжения не редактируется
	МассивНепроверяемыхРеквизитов.Добавить("Распоряжения.Склад");
	
	Если Статус = Перечисления.СтатусыЗаданийНаПеревозку.Формируется
			Или Статус = Перечисления.СтатусыЗаданийНаПеревозку.ПустаяСсылка() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Перевозчик");
		МассивНепроверяемыхРеквизитов.Добавить("Распоряжения");
		Если ЗаданиеВыполняет = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.Перевозчик Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ТранспортноеСредство");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаданиеВыполняет <> Перечисления.ТипыИсполнителейЗаданийНаПеревозку.Перевозчик Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Перевозчик");
	КонецЕсли;
		
	КлючевыеРеквизиты = Новый Массив;
	КлючевыеРеквизиты.Добавить("Распоряжение");
	КлючевыеРеквизиты.Добавить("Склад");
	
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект,"Распоряжения",КлючевыеРеквизиты,Отказ);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ЗаданиеНаПеревозкуЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Документы.ЗаданиеНаПеревозку.ЗаполнитьВремяРейсаПланФакт(ЭтотОбъект);
	
	// Вес и Объем в единицах измерения
	Вес   = Маршрут.Итог("Вес") * ДоставкаТоваров.КоэффициентПересчетаВТонны();
	Объем = Маршрут.Итог("Объем") * ДоставкаТоваров.КоэффициентПересчетаВКубическиеМетры();
	
	КоличествоПунктов = Маршрут.Количество();
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение
		Или РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	Т.Распоряжение
		|ПОМЕСТИТЬ Распоряжения
		|ИЗ
		|	&Распоряжения КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Т.Распоряжение
		|ИЗ
		|	(ВЫБРАТЬ
		|		Т.Распоряжение КАК Распоряжение
		|	ИЗ
		|		Документ.ЗаданиеНаПеревозку.Распоряжения КАК Т
		|	ГДЕ
		|		Т.Ссылка = &Ссылка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Т.Распоряжение
		|	ИЗ
		|		Распоряжения КАК Т) КАК Т";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Распоряжения", Распоряжения.Выгрузить(,"Распоряжение"));
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		ДополнительныеСвойства.Вставить("РаспоряженияДляЗаписиСостояния", Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Распоряжение"));
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("СтатусПередЗаписью", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Статус"));
	ДополнительныеСвойства.Вставить("ПроведенПередЗаписью", Проведен);
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("ИзмененияСоставаРаспоряжений", ИзмененияСоставаРаспоряжений());
	
	ЗаданиеНаПеревозкуЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведенПередЗаписью = ДополнительныеСвойства.ПроведенПередЗаписью;
	СтатусПередЗаписью   = ДополнительныеСвойства.СтатусПередЗаписью;
	
	Если ДополнительныеСвойства.Свойство("ТоварыКДоставке") Тогда
		ДоставкаТоваров.ЗаписатьТоварыКДоставке(ДополнительныеСвойства.ТоварыКДоставке, Распоряжения, Ссылка);
	Иначе
		ОчиститьТоварыКДоставкеПоУдаленнымИзЗаданияРаспоряжениям();
	КонецЕсли;
	
	// Заполнение регистра товары к доставке в не конечном статусе (если требуется)
	Если Проведен И Статус <> Перечисления.СтатусыЗаданийНаПеревозку.Закрыто
		И (СтатусПередЗаписью = Перечисления.СтатусыЗаданийНаПеревозку.Закрыто
			Или Не ПроведенПередЗаписью) Тогда
		ПроверитьЗаполнитьТоварыКДоставке(Ссылка);
	КонецЕсли;
	
	Если Не ПроведенПередЗаписью
		И Не Проведен Тогда
		Возврат;
	КонецЕсли;
	
	// Состояние доставки зависит от РС ТоварыКДоставке, записываем после записи товаров к доставке.
	// При записи состояний доставки производится очистка архивных записей регистров СостоянияИРеквизитыДоставки и ТоварыКДоставке.
	Если ДополнительныеСвойства.Свойство("РаспоряженияДляЗаписиСостояния") Тогда
		ДоставкаТоваров.ОтразитьСостояниеДоставки(ДополнительныеСвойства.РаспоряженияДляЗаписиСостояния, Отказ);
	КонецЕсли;
	
	// Запуск автоматического создания расходных ордеров (выполняется, когда уже записано Задание и ТоварыКДоставке)
	// при отмене проведения, для складов с ФО НачинатьОтгрузкуПослеФормированияЗаданияНаПеревозку.
	Если Операция = Перечисления.ВидыДоставки.СоСклада
		И Константы.РежимФормированияРасходныхОрдеров.Получить() = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически
		
		И (Не Проведен
			И СтатусПередЗаписью <> Перечисления.СтатусыЗаданийНаПеревозку.Формируется
			И ПроведенПередЗаписью
				
			) Тогда
			
		Документы.ЗаданиеНаПеревозку.СформироватьОчередьПереоформленияРасходныхОрдеров(Ссылка, Отказ);
		
	КонецЕсли;

	ЗаданиеНаПеревозкуЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведенПередЗаписью = ДополнительныеСвойства.ПроведенПередЗаписью;
	СтатусПередЗаписью = ДополнительныеСвойства.СтатусПередЗаписью;
	
	// Проверка можно ли устанавливать статус
	Если Операция = Перечисления.ВидыДоставки.СоСклада
		И (Статус = Перечисления.СтатусыЗаданийНаПеревозку.Отправлено 
			Или Статус = Перечисления.СтатусыЗаданийНаПеревозку.Закрыто) Тогда
		
		// Проверка на все ли количество по заданию на перевозку оформлены расходные ордера,
		// только для складов с ФО НачинатьОтгрузкуПослеФормированияЗаданияНаПеревозку.
		КонтрольОформленныхОрдеровПоЗаданиюНаПеревозку(Ссылка, Отказ);
		
		// Проверка готовности расходных ордеров
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходныйОрдерНаТовары.Ссылка
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары КАК РасходныйОрдерНаТовары
		|ГДЕ
		|	РасходныйОрдерНаТовары.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
		|	И НЕ(РасходныйОрдерНаТовары.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРасходныхОрдеров.КОтгрузке)
		|				ИЛИ РасходныйОрдерНаТовары.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРасходныхОрдеров.Отгружен))
		|	И РасходныйОрдерНаТовары.Проведен";
		Запрос.УстановитьПараметр("ЗаданиеНаПеревозку", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ТекстСообщения = НСтр("ru = 'Расходный ордер ""%Ссылка%"" по заданию на перевозку не готов к отгрузке.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,Выборка.Ссылка,,,Отказ);
			
		КонецЦикла;
	
	// Запуск автоматического создания расходных ордеров
	// для складов с ФО НачинатьОтгрузкуПослеФормированияЗаданияНаПеревозку.
	ИначеЕсли Операция = Перечисления.ВидыДоставки.СоСклада
		И Константы.РежимФормированияРасходныхОрдеров.Получить() = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически
		И (Статус = Перечисления.СтатусыЗаданийНаПеревозку.КПогрузке 
			И Не ПроведенПередЗаписью
				Или 
					Статус = Перечисления.СтатусыЗаданийНаПеревозку.КПогрузке
					И СтатусПередЗаписью = Перечисления.СтатусыЗаданийНаПеревозку.Формируется
				Или
					Статус = Перечисления.СтатусыЗаданийНаПеревозку.Формируется
					И СтатусПередЗаписью <> Перечисления.СтатусыЗаданийНаПеревозку.Формируется
					И ПроведенПередЗаписью
				Или
					СтатусПередЗаписью <> Перечисления.СтатусыЗаданийНаПеревозку.Формируется
					И СтатусПередЗаписью <> Неопределено
					И ДополнительныеСвойства.ИзмененияСоставаРаспоряжений.Количество() > 0) Тогда
			
		Документы.ЗаданиеНаПеревозку.СформироватьОчередьПереоформленияРасходныхОрдеров(Ссылка,
			Отказ,
			ДополнительныеСвойства.ИзмененияСоставаРаспоряжений);
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЭтоНовый
		Или Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Изменить статус расходных ордеров на "Отгружен" по отправленным заданиям на перевозку,
	// если все ордера оформлены и находятся в статусе не ниже КОтгрузке (это проверяется выше).
	Если Операция = Перечисления.ВидыДоставки.СоСклада
		И (Статус = Перечисления.СтатусыЗаданийНаПеревозку.Закрыто
			ИЛИ Статус = Перечисления.СтатусыЗаданийНаПеревозку.Отправлено)
		И (Не ПроведенПередЗаписью
			Или 
				(СтатусПередЗаписью <> Перечисления.СтатусыЗаданийНаПеревозку.Закрыто
				И СтатусПередЗаписью <> Перечисления.СтатусыЗаданийНаПеревозку.Отправлено
				И Статус <> СтатусПередЗаписью)) Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РасходныйОрдерНаТовары.Ссылка
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары КАК РасходныйОрдерНаТовары
		|ГДЕ
		|	РасходныйОрдерНаТовары.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
		|	И РасходныйОрдерНаТовары.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРасходныхОрдеров.КОтгрузке)
		|	И РасходныйОрдерНаТовары.Проведен";
		Запрос.УстановитьПараметр("ЗаданиеНаПеревозку", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
			
		Если Не Запрос.Выполнить().Пустой() Тогда
			
			СкладыСервер.ЗапускВыполненияФоновогоПереводаСтатусаРасходногоОрдераВОтгружено(Ссылка);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеИИнициализация

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Склад          = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Ответственный  = Пользователи.ТекущийПользователь();
	Приоритет      = Справочники.Приоритеты.ПолучитьПриоритетПоУмолчанию(Приоритет);
	Распоряжения.Очистить();
	Маршрут.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура КонтрольОформленныхОрдеровПоЗаданиюНаПеревозку(Ссылка, Отказ)
		
	Запрос = Новый Запрос;
	Запрос.Текст = Документы.ЗаданиеНаПеревозку.ТекстЗапросаКонтроляРегистровТоварыКОтгрузкеИТоварыДоставке() +
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыКОтгрузкеИДоставке.Склад,
	|	ТоварыКОтгрузкеИДоставке.ДокументОтгрузки
	|ИЗ
	|	ТоварыКОтгрузкеИДоставке КАК ТоварыКОтгрузкеИДоставке
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКотгрузкеРасход КАК ТоварыКотгрузкеРасход
	|		ПО ТоварыКОтгрузкеИДоставке.ДокументОтгрузки = ТоварыКотгрузкеРасход.ДокументОтгрузки
	|			И ТоварыКОтгрузкеИДоставке.Склад = ТоварыКотгрузкеРасход.Склад
	|			И ТоварыКОтгрузкеИДоставке.Получатель = ТоварыКотгрузкеРасход.Получатель
	|			И ТоварыКОтгрузкеИДоставке.Номенклатура = ТоварыКотгрузкеРасход.Номенклатура
	|			И ТоварыКОтгрузкеИДоставке.Характеристика = ТоварыКотгрузкеРасход.Характеристика
	|			И ТоварыКОтгрузкеИДоставке.Назначение = ТоварыКотгрузкеРасход.Назначение
	|			И ТоварыКОтгрузкеИДоставке.Серия = ТоварыКотгрузкеРасход.Серия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыСобраноСобирается КАК ТоварыСобраноСобирается
	|		ПО ТоварыКОтгрузкеИДоставке.ДокументОтгрузки = ТоварыСобраноСобирается.ДокументОтгрузки
	|			И ТоварыКОтгрузкеИДоставке.Склад = ТоварыСобраноСобирается.Склад
	|			И ТоварыКОтгрузкеИДоставке.Получатель = ТоварыСобраноСобирается.Получатель
	|			И ТоварыКОтгрузкеИДоставке.Номенклатура = ТоварыСобраноСобирается.Номенклатура
	|			И ТоварыКОтгрузкеИДоставке.Характеристика = ТоварыСобраноСобирается.Характеристика
	|			И ТоварыКОтгрузкеИДоставке.Назначение = ТоварыСобраноСобирается.Назначение
	|			И ТоварыКОтгрузкеИДоставке.Серия = ТоварыСобраноСобирается.Серия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКСборке КАК ТоварыКСборке
	|		ПО ТоварыКОтгрузкеИДоставке.ДокументОтгрузки = ТоварыКСборке.ДокументОтгрузки
	|			И ТоварыКОтгрузкеИДоставке.Склад = ТоварыКСборке.Склад
	|			И ТоварыКОтгрузкеИДоставке.Получатель = ТоварыКСборке.Получатель
	|			И ТоварыКОтгрузкеИДоставке.Номенклатура = ТоварыКСборке.Номенклатура
	|			И ТоварыКОтгрузкеИДоставке.Характеристика = ТоварыКСборке.Характеристика
	|			И ТоварыКОтгрузкеИДоставке.Назначение = ТоварыКСборке.Назначение
	|			И ТоварыКОтгрузкеИДоставке.Серия = ТоварыКСборке.Серия
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ТоварыКОтгрузкеИДоставке.Количество < ТоварыКОтгрузкеИДоставке.КоличествоКотгрузке
	|				ТОГДА ТоварыКОтгрузкеИДоставке.Количество > ЕСТЬNULL(ТоварыКотгрузкеРасход.Количество, 0) + ЕСТЬNULL(ТоварыСобраноСобирается.Количество, 0) + ЕСТЬNULL(ТоварыКСборке.Количество, 0)
	|			ИНАЧЕ ТоварыКОтгрузкеИДоставке.КоличествоКотгрузке > ЕСТЬNULL(ТоварыКотгрузкеРасход.Количество, 0) + ЕСТЬNULL(ТоварыСобраноСобирается.Количество, 0) + ЕСТЬNULL(ТоварыКСборке.Количество, 0)
	|		КОНЕЦ";
	ОформлятьСначалаНакладные = Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаНакладные;
	Запрос.УстановитьПараметр("ОформлятьСначалаНакладные", ОформлятьСначалаНакладные);
	Запрос.УстановитьПараметр("ЗаданиеНаПеревозку", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = НСтр("ru = 'Не оформлены все расходные ордера по заданию на перевозку ""%ЗаданиеНаПеревозку%"" для распоряжения ""%ДокументОтгрузки%"" на  складе ""%Склад%"". Оформите ордера и(или) перезаполните задание на перевозку по расходным ордерам.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЗаданиеНаПеревозку%", Ссылка);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОтгрузки%", Выборка.ДокументОтгрузки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%", Выборка.Склад);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,Ссылка);
		Отказ = Истина;
		
	КонецЦикла;
			
КонецПроцедуры

Процедура ОчиститьТоварыКДоставкеПоУдаленнымИзЗаданияРаспоряжениям()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТоварыКДоставке.Распоряжение,
	|	ТоварыКДоставке.Склад
	|ИЗ
	|	РегистрСведений.ТоварыКДоставке КАК ТоварыКДоставке
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаданиеНаПеревозку.Распоряжения КАК РаспоряженияЗадания
	|		ПО (РаспоряженияЗадания.Ссылка = ТоварыКДоставке.ЗаданиеНаПеревозку)
	|			И (РаспоряженияЗадания.Распоряжение = ТоварыКДоставке.Распоряжение)
	|			И (РаспоряженияЗадания.Склад = ТоварыКДоставке.Склад)
	|ГДЕ
	|	ТоварыКДоставке.ЗаданиеНаПеревозку = &Ссылка
	|	И РаспоряженияЗадания.Распоряжение ЕСТЬ NULL ";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ТоварыКДоставке.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗаданиеНаПеревозку.Установить(Ссылка);
		НаборЗаписей.Отбор.Распоряжение.Установить(Выборка.Распоряжение);
		НаборЗаписей.Отбор.Склад.Установить(Выборка.Склад);
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнитьТоварыКДоставке(ЗаданиеНаПеревозку) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТоварыКДоставке.ЗаданиеНаПеревозку
	|ИЗ
	|	РегистрСведений.ТоварыКДоставке КАК ТоварыКДоставке
	|ГДЕ
	|	ТоварыКДоставке.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку";
	Запрос.УстановитьПараметр("ЗаданиеНаПеревозку", Ссылка);
	Если Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Номенклатура,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Характеристика,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Назначение,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Серия,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение,
	|	СУММА(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Количество) КАК Количество,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Получатель,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Склад
	|ПОМЕСТИТЬ ТоварыПоРасходномуОрдеру
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
	|ГДЕ
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
	|	И РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Склад,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Получатель,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Назначение,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Серия,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Номенклатура,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаданиеНаПеревозкуРаспоряжения.Распоряжение,
	|	ЗаданиеНаПеревозкуРаспоряжения.Склад,
	|	ЗаданиеНаПеревозкуРаспоряжения.ПолучательОтправитель,
	|	ЗаданиеНаПеревозкуРаспоряжения.Ссылка КАК ЗаданиеНаПеревозку,
	|	ВЫБОР
	|		КОГДА Склады.ИспользоватьОрдернуюСхемуПриОтгрузке
	|				И Склады.ДатаНачалаОрдернойСхемыПриОтгрузке < ЗаданиеНаПеревозкуРаспоряжения.Ссылка.Дата
	|				И НЕ ТоварыПоРасходномуОрдеру.Распоряжение ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА 
	|	КОНЕЦ КАК ВсеТовары,
	|	ТоварыПоРасходномуОрдеру.Номенклатура,
	|	ТоварыПоРасходномуОрдеру.Характеристика,
	|	ТоварыПоРасходномуОрдеру.Назначение,
	|	ТоварыПоРасходномуОрдеру.Серия,
	|	ТоварыПоРасходномуОрдеру.Количество
	|ИЗ
	|	Документ.ЗаданиеНаПеревозку.Распоряжения КАК ЗаданиеНаПеревозкуРаспоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО ЗаданиеНаПеревозкуРаспоряжения.Склад = Склады.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыПоРасходномуОрдеру КАК ТоварыПоРасходномуОрдеру
	|		ПО ЗаданиеНаПеревозкуРаспоряжения.Распоряжение = ТоварыПоРасходномуОрдеру.Распоряжение
	|			И ЗаданиеНаПеревозкуРаспоряжения.Склад = ТоварыПоРасходномуОрдеру.Склад
	|ГДЕ
	|	ЗаданиеНаПеревозкуРаспоряжения.Ссылка.Проведен
	|	И ЗаданиеНаПеревозкуРаспоряжения.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаданийНаПеревозку.Закрыто)
	|	И ЗаданиеНаПеревозкуРаспоряжения.Ссылка = &ЗаданиеНаПеревозку";
	
	Запрос.УстановитьПараметр("ЗаданиеНаПеревозку", ЗаданиеНаПеревозку);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ТоварыКДоставке.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗаданиеНаПеревозку.Установить(ЗаданиеНаПеревозку);
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
	КонецЦикла;
	НаборЗаписей.Записать();

КонецПроцедуры

Функция ИзмененияСоставаРаспоряжений()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Распоряжения.Распоряжение КАК Распоряжение,
	|	Распоряжения.Вес КАК Вес,
	|	Распоряжения.Объем КАК Объем,
	|	Распоряжения.Перевозчик КАК Перевозчик,
	|	Распоряжения.ПолучательОтправитель КАК ПолучательОтправитель,
	|	Распоряжения.ВремяС КАК ВремяС,
	|	Распоряжения.ВремяПо КАК ВремяПо,
	|	Распоряжения.Доставлено КАК Доставлено,
	|	Распоряжения.Склад КАК Склад,
	|	Распоряжения.ДоставляетсяПолностью КАК ДоставляетсяПолностью,
	|	1 КАК ПолеПодсчета
	|ПОМЕСТИТЬ ВТТекущиеРаспоряжения
	|ИЗ
	|	&Распоряжения КАК Распоряжения
	|
	|;
	|
	|ВЫБРАТЬ
	|	ЗаданиеНаПеревозкуРаспоряжения.Распоряжение КАК Распоряжение,
	|	ЗаданиеНаПеревозкуРаспоряжения.Вес КАК Вес,
	|	ЗаданиеНаПеревозкуРаспоряжения.Объем КАК Объем,
	|	ЗаданиеНаПеревозкуРаспоряжения.Перевозчик КАК Перевозчик,
	|	ЗаданиеНаПеревозкуРаспоряжения.ПолучательОтправитель КАК ПолучательОтправитель,
	|	ЗаданиеНаПеревозкуРаспоряжения.ВремяС КАК ВремяС,
	|	ЗаданиеНаПеревозкуРаспоряжения.ВремяПо КАК ВремяПо,
	|	ЗаданиеНаПеревозкуРаспоряжения.Доставлено КАК Доставлено,
	|	ЗаданиеНаПеревозкуРаспоряжения.Склад КАК Склад,
	|	ЗаданиеНаПеревозкуРаспоряжения.ДоставляетсяПолностью КАК ДоставляетсяПолностью,
	|	-1 КАК ПолеПодсчета
	|ПОМЕСТИТЬ ВТИсходныеРаспоряжения
	|ИЗ
	|	Документ.ЗаданиеНаПеревозку.Распоряжения КАК ЗаданиеНаПеревозкуРаспоряжения
	|ГДЕ
	|	ЗаданиеНаПеревозкуРаспоряжения.Ссылка = &Ссылка
	|
	|;
	|ВЫБРАТЬ
	|	Распоряжения.ПолучательОтправитель КАК Получатель,
	|	Распоряжения.Склад КАК Склад,
	|	СУММА(Распоряжения.ПолеПодсчета) КАК ПолеПодсчета
	|ИЗ
	|	(ВЫБРАТЬ
	|		Распоряжения.Распоряжение КАК Распоряжение,
	|		Распоряжения.Вес КАК Вес,
	|		Распоряжения.Объем КАК Объем,
	|		Распоряжения.Перевозчик КАК Перевозчик,
	|		Распоряжения.ПолучательОтправитель КАК ПолучательОтправитель,
	|		Распоряжения.ВремяС КАК ВремяС,
	|		Распоряжения.ВремяПо КАК ВремяПо,
	|		Распоряжения.Доставлено КАК Доставлено,
	|		Распоряжения.Склад КАК Склад,
	|		Распоряжения.ДоставляетсяПолностью КАК ДоставляетсяПолностью,
	|		Распоряжения.ПолеПодсчета КАК ПолеПодсчета
	|	ИЗ
	|		ВТТекущиеРаспоряжения КАК Распоряжения
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Распоряжения.Распоряжение КАК Распоряжение,
	|		Распоряжения.Вес КАК Вес,
	|		Распоряжения.Объем КАК Объем,
	|		Распоряжения.Перевозчик КАК Перевозчик,
	|		Распоряжения.ПолучательОтправитель КАК ПолучательОтправитель,
	|		Распоряжения.ВремяС КАК ВремяС,
	|		Распоряжения.ВремяПо КАК ВремяПо,
	|		Распоряжения.Доставлено КАК Доставлено,
	|		Распоряжения.Склад КАК Склад,
	|		Распоряжения.ДоставляетсяПолностью КАК ДоставляетсяПолностью,
	|		Распоряжения.ПолеПодсчета КАК ПолеПодсчета
	|	ИЗ
	|		ВТИсходныеРаспоряжения КАК Распоряжения) КАК Распоряжения
	|
	|СГРУППИРОВАТЬ ПО
	|	Распоряжения.Распоряжение,
	|	Распоряжения.Вес,
	|	Распоряжения.Объем,
	|	Распоряжения.Перевозчик,
	|	Распоряжения.ПолучательОтправитель,
	|	Распоряжения.ВремяС,
	|	Распоряжения.ВремяПо,
	|	Распоряжения.Доставлено,
	|	Распоряжения.Склад,
	|	Распоряжения.ДоставляетсяПолностью
	|
	|ИМЕЮЩИЕ
	|	СУММА(Распоряжения.ПолеПодсчета) <> 0";
	
	СписокПолей = "Распоряжение, Вес, Объем, Перевозчик, ПолучательОтправитель, 
	|ВремяС, ВремяПо, Доставлено, Склад, ДоставляетсяПолностью";
	Запрос.УстановитьПараметр("Распоряжения", Распоряжения.Выгрузить(, СписокПолей));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
