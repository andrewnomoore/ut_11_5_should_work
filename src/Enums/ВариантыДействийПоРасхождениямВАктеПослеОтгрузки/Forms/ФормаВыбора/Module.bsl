
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасхожденияСервер.УправлениеСтраницамиВыборДействия(ЭтотОбъект, Параметры);
	
	ИспользоватьЗаявкиНаВозврат = ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов");
	ИспользоватьЗаказыКлиентов = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов");
	ИспользоватьЗаказыНаПеремещение = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение");
	КоличествоУпаковокРасхождения = Параметры.КоличествоУпаковокРасхождения;
	ГрупповоеИзменение = Параметры.ГрупповоеИзменение;
	
	Если Параметры.ОтгрузкаПринципалу
		Или Не ГрупповоеИзменение
			И КоличествоУпаковокРасхождения >= 0
			И (Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа
				Или Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга) Тогда
		Если ДействиеИзлишки = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ВозвратПерепоставленного Тогда
			ДействиеИзлишки = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПустаяСсылка();
		КонецЕсли;
		Элементы.ВозвратПерепоставленного.Доступность = Ложь;
	КонецЕсли;
	
	Если Не ГрупповоеИзменение Тогда
		Если КоличествоУпаковокРасхождения >= 0 Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Излишки;
			ДействиеИзлишки = Параметры.ВыбранноеДействие;
		Иначе
			Элементы.Страницы.ТекущаяСтраница = Элементы.Недостачи;
			ДействиеНедостачи = Параметры.ВыбранноеДействие;
		КонецЕсли;
	КонецЕсли;
	
	Если ГрупповоеИзменение Тогда
		Заголовок = НСтр("ru='Как отработать расхождения'");
	Иначе
		Если КоличествоУпаковокРасхождения >= 0 Тогда
			Элементы.Недостачи.Видимость = Ложь;
			Заголовок = НСтр("ru='Как отработать излишек'");
		Иначе
			Элементы.Излишки.Видимость = Ложь;
			Заголовок = НСтр("ru='Как отработать недостачу'");
		КонецЕсли;
	КонецЕсли;
	
	Элементы.КартинкаПояснения.Видимость = Параметры.ПоказыватьПояснение;
	Элементы.Пояснение.Видимость = Параметры.ПоказыватьПояснение;
	
	СформироватьЗаголовки(
		Параметры.ТипАкта,
		Параметры.КоличествоУпаковокРасхождения,
		Параметры.СпособОтраженияРасхождений,
		Параметры.ГрупповоеИзменение,
		Параметры.СтрокаПоЗаказу);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность И НЕ ЗавершениеРаботы Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
		               НСтр("ru='Выполненные изменения будут утеряны. Все равно закрыть?'"),
		               РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыполняетсяЗакрытие = Истина;
	
	Если ГрупповоеИзменение Тогда
		ПараметрыЗакрытия = Новый Структура();
		ПараметрыЗакрытия.Вставить("ДействиеИзлишки", ДействиеИзлишки);
		ПараметрыЗакрытия.Вставить("ДействиеНедостачи", ДействиеНедостачи);
		Закрыть(ПараметрыЗакрытия);
	ИначеЕсли КоличествоУпаковокРасхождения > 0 Тогда
		Закрыть(ДействиеИзлишки);
	ИначеЕсли КоличествоУпаковокРасхождения < 0 Тогда
		Закрыть(ДействиеНедостачи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ВыполняетсяЗакрытие = Истина;
	Закрыть(Неопределено);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьЗаголовки(ТипАкта, КоличествоУпаковокРасхождения, СпособОтраженияРасхождений, ГрупповоеИзменение, СтрокаПоЗаказу)
	
	Если ТипАкта = "Реализация" Тогда
		
		// Недостачи
		Элементы.ДекорацияНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при реализации согласованы с клиентом'");
		Элементы.ДекорацияНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при реализации не согласованы с клиентом'");
		
		Если СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ИсправлениеПервичныхДокументов Тогда
			Если СтрокаПоЗаказу Или (ГрупповоеИзменение И ИспользоватьЗаказыКлиентов) Тогда
				Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Реализация уменьшается на недопоставленный товар с последующей отменой недопоставленных строк заказа'");
			Иначе
				Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Реализация уменьшается на недопоставленный товар'");
			КонецЕсли;
			Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'Реализация уменьшается на недопоставленный товар с последующим оформлением новой реализации недопоставленного товара'");
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировкиКакИсправлениеПервичныхДокументов Тогда
			Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка реализации (исправление ошибок)'");
			Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка реализации (исправление ошибок) с последующим оформлением реализации недопоставленного товара'");
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировкиПоСогласованию Тогда
			Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка реализации (по согласованию сторон)'");
			Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка реализации (по согласованию сторон) с последующим оформлением реализации недопоставленного товара'");
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировокКакНовыеПервичныеДокументы Тогда
			Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка реализации (возврат недопоставленного товара)'");
			Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка реализации (возврат недопоставленного товара) с последующим оформлением реализации на допоставку'");
		КонецЕсли;
		
		Элементы.НедостачаНеПризнанаДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар не отгружается со склада, документы не переоформляются'");
		Элементы.ОтгрузитьСейчасДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар отгружается со склада, документы не переоформляются'");
		
		// Излишки
		
		Элементы.ДекорацияИзлишкиСогласованы.Заголовок   = НСтр("ru = 'Излишки при реализации согласованы с клиентом'");
		Элементы.ДекорацияИзлишкиНеСогласованы.Заголовок = НСтр("ru = 'Излишки при реализации не согласованы с клиентом'");
		
		Если СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ИсправлениеПервичныхДокументов Тогда
			Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Реализация увеличивается на перепоставленный товар'");
			Если ИспользоватьЗаявкиНаВозврат Тогда
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Реализация увеличивается на перепоставленный товар с последующим оформлением заявки на возврат перепоставленного товара'");
			Иначе
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Реализация увеличивается на перепоставленный товар с последующим оформлением возврата перепоставленного товара'");
			КонецЕсли;
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировкиКакИсправлениеПервичныхДокументов Тогда
			Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (исправление ошибок)'");
			Если ИспользоватьЗаявкиНаВозврат Тогда
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (исправление ошибок) с последующим оформлением заявки на возврат перепоставленного товара'");
			Иначе
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (исправление ошибок) с последующим оформлением возврата перепоставленного товара'");
			КонецЕсли;
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировкиПоСогласованию Тогда
			Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (по согласованию сторон)'");
			Если ИспользоватьЗаявкиНаВозврат Тогда
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (по согласованию сторон) с последующим оформлением заявки на возврат перепоставленного товара'");
			Иначе
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (по согласованию сторон) с последующим оформлением возврата перепоставленного товара'");
			КонецЕсли;
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировокКакНовыеПервичныеДокументы Тогда
			Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (реализация перепоставленного)'");
			Если ИспользоватьЗаявкиНаВозврат Тогда
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (реализация перепоставленного товара) с последующим оформлением заявки на возврат перепоставленного товара'");
			Иначе
				Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка реализации (реализация перепоставленного товара) с последующим оформлением возврата перепоставленного товара'");
			КонецЕсли;
		КонецЕсли;
		
		Элементы.ПерепоставленноеДаритсяДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар не возвращается на склад, документы не переоформляются'");
		Элементы.ОприходоватьСейчасДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар возвращается на склад, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = "Возврат" Тогда
		
		// Недостачи
		Элементы.ДекорацияНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при возврате согласованы с поставщиком'");
		Элементы.ДекорацияНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при возврате не согласованы с поставщиком'");
		
		Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Возврат товаров поставщику уменьшается на недопоставленный товар'");
		Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'Возврат товаров поставщику уменьшается на недопоставленный товар с последующим оформлением нового возврата недопоставленного товара'");
		Элементы.НедостачаНеПризнанаДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар не отгружается со склада, документы не переоформляются'");
		Элементы.ОтгрузитьСейчасДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар отгружается со склада, документы не переоформляются'");
		
		// Излишки
		Элементы.ДекорацияИзлишкиСогласованы.Заголовок   = НСтр("ru = 'Излишки при возврате согласованы с поставщиком'");
		Элементы.ДекорацияИзлишкиНеСогласованы.Заголовок = НСтр("ru = 'Излишки при возврате не согласованы с поставщиком'");
		
		Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Возврат товаров поставщику увеличивается на перепоставленный товар'");
		Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Возврат товаров поставщику увеличивается на перепоставленный товар с последующим оформлением поступления перепоставленного товара'");
		Элементы.ПерепоставленноеДаритсяДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар не возвращается на склад, документы не переоформляются'");
		Элементы.ОприходоватьСейчасДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар возвращается на склад, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = "Перемещение" Тогда
		
		// Недостачи
		Элементы.ДекорацияНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при поступлении согласованы с отправителем'");
		Элементы.ДекорацияНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при поступлении не согласованы с отправителем'");
		
		Если СтрокаПоЗаказу Или (ГрупповоеИзменение И ИспользоватьЗаказыНаПеремещение) Тогда
			Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Перемещение товаров уменьшается на недопоставленный товар с последующей отменой недопоставленных строк заказа'");
		Иначе
			Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Перемещение товаров уменьшается на недопоставленный товар'");
		КонецЕсли;
		Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'Перемещение товаров уменьшается на недопоставленный товар с последующим оформлением нового перемещения недопоставленного товара'");
		Элементы.НедостачаНеПризнанаДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар не отгружается со склада-отправителя, документы не переоформляются'");
		Элементы.ОтгрузитьСейчасДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар отгружается со склада-отправителя, документы не переоформляются'");
		
		// Излишки
		Элементы.ДекорацияИзлишкиСогласованы.Заголовок   = НСтр("ru = 'Излишки при поступлении согласованы с отправителем'");
		Элементы.ДекорацияИзлишкиНеСогласованы.Заголовок = НСтр("ru = 'Излишки при поступлении не согласованы с отправителем'");
		
		Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Перемещение товаров увеличивается на перепоставленный товар'");
		Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Перемещение товаров увеличивается на перепоставленный товар с последующим оформлением обратного перемещения перепоставленного товара'");
		Элементы.ПерепоставленноеДаритсяДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар не возвращается на склад-отправитель, документы не переоформляются'");
		Элементы.ОприходоватьСейчасДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар возвращается на склад-отправитель, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = "Передача" Тогда
		
		// Недостачи
		Элементы.ДекорацияНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при передаче согласованы с партнером'");
		Элементы.ДекорацияНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при передаче не согласованы с партнером'");
		
		Если СтрокаПоЗаказу
			Или (ГрупповоеИзменение
				И ИспользоватьЗаказыКлиентов) Тогда
			
			Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Передача уменьшается на недопоставленный товар с последующей отменой недопоставленных строк заказа'");
			
		Иначе
			Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Передача уменьшается на недопоставленный товар'");
		КонецЕсли;
		
		Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'Передача уменьшается на недопоставленный товар с последующим оформлением новой передачи недопоставленного товара'");
		
		Элементы.НедостачаНеПризнанаДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар не отгружается со склада, документы не переоформляются'");
		Элементы.ОтгрузитьСейчасДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар отгружается со склада, документы не переоформляются'");
		
		// Излишки
		Элементы.ДекорацияИзлишкиСогласованы.Заголовок   = НСтр("ru = 'Излишки при передаче согласованы с партнером'");
		Элементы.ДекорацияИзлишкиНеСогласованы.Заголовок = НСтр("ru = 'Излишки при передаче не согласованы с партнером'");
		
		Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Передача увеличивается на перепоставленный товар'");
		
		Если ИспользоватьЗаявкиНаВозврат
		   Тогда
			Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Передача увеличивается на перепоставленный товар с последующим оформлением заявки на возврат перепоставленного товара'");
		Иначе
			Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Передача увеличивается на перепоставленный товар с последующим оформлением поступления перепоставленного товара'");
		КонецЕсли;
		
		Элементы.ПерепоставленноеДаритсяДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар не возвращается на склад, документы не переоформляются'");
		Элементы.ОприходоватьСейчасДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар возвращается на склад, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = "ОтветственноеХранение" Тогда
		
		// Недостачи
		Элементы.ДекорацияНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при отгрузке с ответственного хранения согласованы с поставщиком'");
		Элементы.ДекорацияНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при отгрузке с ответственного хранения не согласованы с поставщиком'");
		
		Элементы.ДопоставкаНеТребуетсяДекорация.Заголовок = НСтр("ru = 'Отгрузка товаров поклажедателю уменьшается на недопоставленный товар'");
		Элементы.ТребуетсяДопоставкаДекорация.Заголовок = НСтр("ru = 'Отгрузка товаров поклажедателю уменьшается на недопоставленный товар с последующим оформлением новой отгрузки недопоставленного товара'");
		Элементы.НедостачаНеПризнанаДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар не отгружается со склада, документы не переоформляются'");
		Элементы.ОтгрузитьСейчасДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар отгружается со склада, документы не переоформляются'");
		
		// Излишки
		Элементы.ДекорацияИзлишкиСогласованы.Заголовок   = НСтр("ru = 'Излишки при отгрузке с ответственного хранения согласованы с поставщиком'");
		Элементы.ДекорацияИзлишкиНеСогласованы.Заголовок = НСтр("ru = 'Излишки при отгрузке с ответственного хранения не согласованы с поставщиком'");
		
		Элементы.ПокупкаПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Отгрузка товаров поклажедателю увеличивается на перепоставленный товар'");
		Элементы.ВозвратПерепоставленногоДекорация.Заголовок = НСтр("ru = 'Отгрузка товаров поклажедателю увеличивается на перепоставленный товар с последующим оформлением поступления перепоставленного товара'");
		Элементы.ПерепоставленноеДаритсяДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар не возвращается на склад, документы не переоформляются'");
		Элементы.ОприходоватьСейчасДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар возвращается на склад, документы не переоформляются'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

