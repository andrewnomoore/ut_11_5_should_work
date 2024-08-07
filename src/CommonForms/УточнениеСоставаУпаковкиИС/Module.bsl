#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОбработатьПереданныеПараметры();
	
	Элементы.ДанныеДляУточненияИдентификаторПроисхожденияВЕТИС.Заголовок = ИнтеграцияИСМПВЕТИСКлиентСервер.ИмяИдентификатораПроисхожденияВЕТИС();
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	ВывестиПоясняющийТекст();
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ДанныеДляУточненияХарактеристика", "Элементы.ДанныеДляУточнения.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ДанныеДляУточненияСерия", "Элементы.ДанныеДляУточнения.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(ЭтотОбъект, "ДанныеДляУточненияСерия", "Элементы.ДанныеДляУточнения.ТекущиеДанные.Характеристика");
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоясняющийТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСКлиент.СкопироватьШтрихКодВБуферОбмена(Элементы.БуферОбмена, КодМаркировки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеДляУточнения

&НаКлиенте
Процедура ДанныеДляУточненияПриАктивизацииСтроки(Элемент)
	
	ВыделенныеСтроки = Элементы.ДанныеДляУточнения.ВыделенныеСтроки;
	Отбор = Новый Структура;
	ДопустимОбщийВыбор = Истина;
	Для Счетчик=1 По ВыделенныеСтроки.Количество() Цикл
		Строка = ДанныеДляУточнения.НайтиПоИдентификатору(ВыделенныеСтроки[Счетчик-1]);
		ДопустимОбщийВыбор = ДопустимОбщийВыбор И ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "Номенклатура");
		ДопустимОбщийВыбор = ДопустимОбщийВыбор И ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "Характеристика");
		ДопустимОбщийВыбор = ДопустимОбщийВыбор И ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "Серия");
		ДопустимОбщийВыбор = ДопустимОбщийВыбор И ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "ИдентификаторПроисхожденияВЕТИС");
		ДопустимОбщийВыбор = ДопустимОбщийВыбор И ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "СрокГодности");
	КонецЦикла;
	
	Если Не ДопустимОбщийВыбор Тогда
		Отбор = Новый Структура("Выбрать", Неопределено);
	КонецЕсли;
		
	Если Отбор.Количество() Тогда
		Элементы.ДанныеДокумента.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	Иначе
		Элементы.ДанныеДокумента.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУточненияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	ИначеЕсли Не СтрокаЗаполнена(Элементы.ДанныеДляУточнения.ТекущиеДанные, Ложь) Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Элементы.ДанныеДляУточнения.ТекущиеДанные.Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Номенклатура");
	Отбор.Вставить("Характеристика");
	Отбор.Вставить("Серия");
	Отбор.Вставить("ИдентификаторПроисхожденияВЕТИС");
	Отбор.Вставить("СрокГодности");
	ЗаполнитьЗначенияСвойств(Отбор, Элементы.ДанныеДляУточнения.ТекущиеДанные);
	СтрокиДанныеДокумента = ДанныеДокумента.НайтиСтроки(Отбор);
	Если СтрокиДанныеДокумента.Количество() = 0 Тогда
		НоваяСтрокаДанныеДокумента = ДанныеДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДанныеДокумента, Элементы.ДанныеДляУточнения.ТекущиеДанные);
		Элементы.ДанныеДокумента.ТекущаяСтрока = НоваяСтрокаДанныеДокумента.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУточненияНоменклатураПриИзменении(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
		ТекущиеДанные = Элементы.ДанныеДляУточнения.ТекущиеДанные;
		ПоляУточнения = "Номенклатура,Характеристика,Серия,ХарактеристикиИспользуются,СтатусУказанияСерий,
		|	ТипНоменклатуры,Склад,Количество,ПроизвольнаяЕдиницаУчета,ТребуетВзвешивания";
		ТекущиеДанныеСтруктурой = Новый Структура(ПоляУточнения);
		ЗаполнитьЗначенияСвойств(ТекущиеДанныеСтруктурой, ТекущиеДанные);
		ТекущиеДанныеСтруктурой.Склад = Склад;
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("СобытияФормИСМПКлиентПереопределяемый");
		Модуль.ПриИзмененииНоменклатуры(ЭтотОбъект, ТекущиеДанныеСтруктурой, Неопределено, ПараметрыУказанияСерий);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ТекущиеДанныеСтруктурой);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУточненияСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		
		ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект, ПараметрыУказанияСерий, Элемент.ТекстРедактирования, СтандартнаяОбработка, Элементы.ДанныеДляУточнения.ТекущиеДанные);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУточненияНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВидыПродукции = ПараметрыСканирования.ДопустимыеВидыПродукции;
	
	Если РазборКодаМаркировкиИССлужебныйКлиентСервер.ЭтоШтрихкодВводаОстатков(КодМаркировки) Тогда
		ВидыПродукцииПоКодуМаркировкиОстатков(ВидыПродукции, КодМаркировки, ПараметрыСканирования.Организация);
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(Элемент, ВидыПродукции, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУточненияПриАктивизацииЯчейки(Элемент)
	
	Если Элемент.ТекущийЭлемент = Элементы.ДанныеДляУточненияНоменклатура Тогда
		
		ЗаполнитьСпискиВыбораНоменклатуры();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУточненияИдентификаторПроисхожденияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДанныеДляУточнения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияИСМПВЕТИСКлиент");
	ПараметрыОткрытия = Модуль.ПараметрыВыбораИдентификатораПросхождения(ПараметрыСканирования.ВидОперацииИСМП);
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ЭтотОбъект);
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ТекущиеДанные);
	ПараметрыОткрытия.ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИдентификатораПроисхожденияВЕТИСЗавершение", ЭтотОбъект);
	ПараметрыОткрытия.Организация = ПараметрыСканирования.Организация;
	Модуль.ОткрытьФормуВыбораИдентификатораПроисхожденияВЕТИС(ПараметрыОткрытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУточненияНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДанныеДляУточнения.ТекущиеДанные;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СопоставитьВыделенные(Команда)
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.ДанныеДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновленоСтрок = ВыбратьТекущиеНаСервере(Элементы.ДанныеДокумента.ТекущиеДанные.ПолучитьИдентификатор());
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Сопоставление завершено'"),,
		СтрШаблон(НСтр("ru = 'Обработано строк: %1'"), ОбновленоСтрок),
		БиблиотекаКартинок.Информация32ГосИС);
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьПохожие(Команда)
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.ДанныеДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновленоСтрок = ЗаполнитьТекущиеНаСервере(Элементы.ДанныеДокумента.ТекущиеДанные.ПолучитьИдентификатор());
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Сопоставление завершено'"),,
		СтрШаблон(НСтр("ru = 'Обработано строк: %1'"), ОбновленоСтрок),
		БиблиотекаКартинок.Информация32ГосИС);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияФормы

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект,
		"ДанныеДляУточненияХарактеристика", "ДанныеДляУточнения.ХарактеристикиИспользуются");
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект,
		"ДанныеДляУточненияСерия", "ДанныеДляУточнения.СтатусУказанияСерий", "ДанныеДляУточнения.ТипНоменклатуры");
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеДляУточненияНоменклатура.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ДанныеДляУточненияНоменклатура.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ДанныеДляУточнения.ПредставлениеНоменклатуры"));
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеДляУточненияИдентификаторПроисхожденияВЕТИС.Имя);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеДляУточненияСрокГодности.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДанныеДляУточнения.ВидУпаковки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыУпаковокИС.Набор;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не используется для наборов>'"));
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПереданныеПараметры()
	
	АдресДереваУпаковок    = Параметры.АдресДереваУпаковок;
	КодМаркировки          = Параметры.КодМаркировки;
	ПараметрыСканирования  = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ПараметрыСканирования);
	ПараметрыУказанияСерий = ПараметрыСканирования.ПараметрыУказанияСерий;
	ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий(ПараметрыУказанияСерий, Метаданные.ОбщиеФормы.УточнениеСоставаУпаковкиИС, ЭтотОбъект);
	Склад                  = ПараметрыСканирования.Склад;
	ДеревоУпаковок = ПолучитьИзВременногоХранилища(АдресДереваУпаковок);
	Упаковка = НайтиСтрокуДереваПоКодуМаркировки(ДеревоУпаковок, КодМаркировки);
	ЗаполнитьТребующиеУточненияДанныеУпаковки(Упаковка, ПараметрыСканирования.ДетализацияСтруктурыХранения);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, ДанныеДляУточнения);
	
	ОбработатьРежимВыбораИзДокумента();
	
	Если Не (ПараметрыСканирования.Свойство("ЗаполнятьДанныеВЕТИС") И ПараметрыСканирования.ЗаполнятьДанныеВЕТИС) Тогда
		Элементы.ДанныеДляУточненияИдентификаторПроисхожденияВЕТИС.Видимость = Ложь;
	КонецЕсли;
	
	Если Не (ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности") И ПараметрыСканирования.ЗаполнятьСрокГодности) Тогда
		Элементы.ДанныеДляУточненияСрокГодности.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПараметрыСканирования.РазрешенаОбработкаКодовСПустойНоменклатурой Тогда
		Элементы.ДанныеДляУточненияНоменклатура.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПоясняющийТекст()
	
	Если ГрупповаяОбработкаШтрихкодовИС.ЭтоАгрегатТСД(КодМаркировки) Тогда
		
		Заголовок = НСтр("ru = 'Групповая обработка кодов маркировки'");
		
	Иначе
		
		Элементы.ПоясняющийТекст.Высота = 2;
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Обработка кода упаковки:'"),, ЦветаСтиля.ПоясняющийТекст));
		МассивСтрок.Добавить(" ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(КодМаркировки, Новый Шрифт(,,,,Истина), ЦветаСтиля.ЦветГиперссылкиГосИС,, "СкопироватьКодМаркировкиВБуферОбмена"));
		МассивСтрок.Добавить(". ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Требуется уточнить коды маркировки.'"),, ЦветаСтиля.ПоясняющийТекст));
		ПоясняющийТекст = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРежимВыбораИзДокумента()
	
	Колонки = Новый Массив;
	
	Если Параметры.ДанныеДокумента.Количество() Тогда
		
		Элемент = Параметры.ДанныеДокумента[0];
		// Настроим колонки таблицы выбора
		Для Каждого Колонка Из ДанныеДокумента.Выгрузить().Колонки Цикл
			Если Элементы.Найти("ДанныеДокумента"+Колонка.Имя)=Неопределено Тогда
			ИначеЕсли Не Элемент.Свойство(Колонка.Имя) Тогда
				Элементы["ДанныеДокумента"+Колонка.Имя].Видимость = Ложь;
			Иначе
				Колонки.Добавить(Колонка.Имя);
			КонецЕсли;
		КонецЦикла;
		
		// Загрузим данные документа для выбора
		Для Каждого ВариантВыбора Из Параметры.ДанныеДокумента Цикл
			НоваяСтрока = ДанныеДокумента.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВариантВыбора);
		КонецЦикла;
		
		ТаблицаДанныеДокумента = ДанныеДокумента.Выгрузить();
		ТаблицаДанныеДокумента.Свернуть(
			"Номенклатура,Характеристика,Серия,ИдентификаторПроисхожденияВЕТИС,СрокГодности,ПроизвольнаяЕдиницаУчета,ТребуетВзвешивания",
			"Количество");
		ДанныеДокумента.Загрузить(ТаблицаДанныеДокумента);
		Для Каждого СтрокаДанныеДокумента Из ДанныеДокумента Цикл
			ЭтоПустаяСтрока = Истина;
			Для Каждого ВидимаяКолонка Из Колонки Цикл
				ЭтоПустаяСтрока = ЭтоПустаяСтрока И Не ЗначениеЗаполнено(СтрокаДанныеДокумента[ВидимаяКолонка]);
			КонецЦикла;
			Если ЭтоПустаяСтрока Тогда
				СтрокаДанныеДокумента.ПредставлениеПустого = НСтр("ru = '<указание не требуется>'");
			КонецЕсли;
		КонецЦикла;
		ВыполнитьПредзаполнениеЕдинственнымВариантом();
	Иначе
		Если Не (ПараметрыСканирования.Свойство("ЗаполнятьДанныеВЕТИС") И ПараметрыСканирования.ЗаполнятьДанныеВЕТИС) Тогда
			Элементы.ДанныеДокументаИдентификаторПроисхожденияВЕТИС.Видимость = Ложь;
		КонецЕсли;
		Если Не (ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности") И ПараметрыСканирования.ЗаполнятьСрокГодности) Тогда
			Элементы.ДанныеДокументаСрокГодности.Видимость = Ложь;
		КонецЕсли;
		Элементы.ДанныеДокументаКоличество.Видимость = Ложь;;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПредзаполнениеЕдинственнымВариантом()
	
	КэшированныеЗначения = Неопределено;
	Для Каждого Строка Из ДанныеДляУточнения Цикл
		Отбор = Новый Структура;
		ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "Номенклатура");
		ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "Характеристика");
		ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "Серия");
		ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "ИдентификаторПроисхожденияВЕТИС");
		ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, "СрокГодности");
		Если Отбор.Количество() Тогда
			ПодходящиеДанныеДокумента = ДанныеДокумента.НайтиСтроки(Отбор);
		Иначе
			ПодходящиеДанныеДокумента = ДанныеДокумента;
		КонецЕсли;
		Если ПодходящиеДанныеДокумента.Количество() = 1 Тогда
			ОбновитьСтрокуТаблицы(Строка, ПодходящиеДанныеДокумента[0], КэшированныеЗначения);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТребующиеУточненияДанныеУпаковки(СтрокаДерева, ДетализацияСтруктурыХранения)
	
	Если СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская
		Или СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Групповая
		Или СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Набор
		Или (ЗначениеЗаполнено(СтрокаДерева.GTIN)
			И ДетализацияСтруктурыХранения = Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками) Тогда
		
		ТребуетсяУточнение = Не ЗначениеЗаполнено(СтрокаДерева.Номенклатура);
		
		Если Не ТребуетсяУточнение
				И Не ЗначениеЗаполнено(СтрокаДерева.Серия)
				И ПараметрыУказанияСерий <> Неопределено Тогда
			ТребуетсяУточнение = ОбщегоНазначенияИС.ТребуетсяВыборСерии(СтрокаДерева, ПараметрыСканирования);
		КонецЕсли;
		
		Если ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности")
				И ПараметрыСканирования.ЗаполнятьСрокГодности
				И Не ЗначениеЗаполнено(СтрокаДерева.ГоденДо) Тогда
			ТребуетсяУточнение = Истина;
		КонецЕсли;
		
		Если ПараметрыСканирования.Свойство("ЗаполнятьДанныеВЕТИС")
				И ПараметрыСканирования.ЗаполнятьДанныеВЕТИС
				И Не ЗначениеЗаполнено(СтрокаДерева.ИдентификаторПроисхожденияВЕТИС) Тогда
			ТребуетсяУточнение = Истина;
		КонецЕсли;
		
		Если ТребуетсяУточнение Тогда
			НоваяСтрока = ДанныеДляУточнения.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДерева);
			Если ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности") И ПараметрыСканирования.ЗаполнятьСрокГодности Тогда
				НоваяСтрока.СрокГодности = СтрокаДерева.ГоденДо;
			КонецЕсли;
			НоваяСтрока.НомерСтроки = ДанныеДляУточнения.Количество();
		КонецЕсли;
		
		Если СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Набор
			И СтрокаДерева.ТипУпаковки = Перечисления.ТипыУпаковок.МультитоварнаяУпаковка Тогда
			
			Для Каждого ВложеннаяСтрока Из СтрокаДерева.Строки Цикл
				ЗаполнитьТребующиеУточненияДанныеУпаковки(ВложеннаяСтрока, ДетализацияСтруктурыХранения);
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		Для Каждого ВложеннаяСтрока Из СтрокаДерева.Строки Цикл
			ЗаполнитьТребующиеУточненияДанныеУпаковки(ВложеннаяСтрока, ДетализацияСтруктурыХранения);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьРеквизитВыделенныхСтрок(Строка, Отбор, ИмяРеквизита, Дополнять = Истина)
	Если ЗначениеЗаполнено(Строка[ИмяРеквизита]) Тогда
		Если Дополнять И Не Отбор.Свойство(ИмяРеквизита) Тогда
			Отбор.Вставить(ИмяРеквизита, Строка[ИмяРеквизита]);
		ИначеЕсли Строка[ИмяРеквизита] <> Отбор[ИмяРеквизита] Тогда
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Строка.СписокНоменклатуры) И Не Дополнять Тогда
		Для Каждого ЭлементСпискаВыбора Из Строка.СписокНоменклатуры Цикл
			Если ЭлементСпискаВыбора.Свойство(ИмяРеквизита) И ЭлементСпискаВыбора[ИмяРеквизита] = Отбор[ИмяРеквизита] Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаСервере
Функция НайтиСтрокуДереваПоКодуМаркировки(ДеревоУпаковок, КодМаркировки)
	
	Возврат ДеревоУпаковок.Строки.Найти(КодМаркировки, "ШтрихКод", Истина);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВидыПродукцииПоКодуМаркировкиОстатков(ВидыПродукции, КодМаркировки, Организация)
	
	Если ВидыПродукции.Количество() = 1
		Или Не ЗначениеЗаполнено(КодМаркировки) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИСМП");
		ВидыПродукцииКодаМаркировки = Модуль.ВидыПродукцииПоКодуМаркировкиОстатков(КодМаркировки, Организация);
		Если ВидыПродукцииКодаМаркировки <> Неопределено Тогда
			ВидыПродукции = ИнтеграцияИС.ПересечениеМассивов(ВидыПродукции, ВидыПродукцииКодаМаркировки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыбратьТекущиеНаСервере(ИдентификаторДанныеДокумента)
	
	ОбновленоСтрок = 0;
	
	КэшированныеЗначения = Неопределено;
	СтрокаДанныеДокумента = ДанныеДокумента.НайтиПоИдентификатору(ИдентификаторДанныеДокумента);
	Для Каждого Идентификатор Из Элементы.ДанныеДляУточнения.ВыделенныеСтроки Цикл
		СтрокаТаблицы = ДанныеДляУточнения.НайтиПоИдентификатору(Идентификатор);
		ОбновленоСтрок = ОбновленоСтрок + ОбновитьСтрокуТаблицы(СтрокаТаблицы, СтрокаДанныеДокумента, КэшированныеЗначения);
	КонецЦикла;
	
	Возврат ОбновленоСтрок;
	
КонецФункции

&НаСервере
Функция ЗаполнитьТекущиеНаСервере(ИдентификаторДанныеДокумента)
	
	ОбновленоСтрок = 0;
	
	КэшированныеЗначения = Неопределено;
	СтрокаДанныеДокумента = ДанныеДокумента.НайтиПоИдентификатору(ИдентификаторДанныеДокумента);
	Для Каждого СтрокаТаблицы Из ДанныеДляУточнения Цикл
		ОбновленоСтрок = ОбновленоСтрок + ОбновитьСтрокуТаблицы(СтрокаТаблицы, СтрокаДанныеДокумента, КэшированныеЗначения);
	КонецЦикла;
	
	Возврат ОбновленоСтрок;
	
КонецФункции

&НаСервере
Функция ОбновитьСтрокуТаблицы(СтрокаТаблицы, ДанныеЗаполнения, КэшированныеЗначения)
	
	Если Не СтрокаТаблицыМожетБытьЗаполнена(СтрокаТаблицы, ДанныеЗаполнения) Тогда
		Возврат 0;
	КонецЕсли;
	ТребуетсяВызовПриИзмененииНоменклатуры = (СтрокаТаблицы.Номенклатура <> ДанныеЗаполнения.Номенклатура);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДанныеЗаполнения,, "Количество, ВидПродукции");
	Если ТребуетсяВызовПриИзмененииНоменклатуры
		И ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("СобытияФормИСМППереопределяемый");
		Модуль.ПриИзмененииНоменклатуры(ЭтотОбъект, СтрокаТаблицы, КэшированныеЗначения, ПараметрыУказанияСерий);
	КонецЕсли;
	Возврат 1;
	
КонецФункции

&НаСервере
Функция СтрокаТаблицыМожетБытьЗаполнена(СтрокаТаблицы, ДанныеЗаполнения)
	
	Результат = ПроверитьРеквизитВыделенныхСтрок(СтрокаТаблицы, ДанныеЗаполнения, "Номенклатура", Ложь);
	Результат = Результат И ПроверитьРеквизитВыделенныхСтрок(СтрокаТаблицы, ДанныеЗаполнения, "Характеристика", Ложь);
	Результат = Результат И ПроверитьРеквизитВыделенныхСтрок(СтрокаТаблицы, ДанныеЗаполнения, "Серия", Ложь);
	Результат = Результат И ПроверитьРеквизитВыделенныхСтрок(СтрокаТаблицы, ДанныеЗаполнения, "ИдентификаторПроисхожденияВЕТИС", Ложь);
	Результат = Результат И ПроверитьРеквизитВыделенныхСтрок(СтрокаТаблицы, ДанныеЗаполнения, "СрокГодности", Ложь);
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыборИдентификатораПроисхожденияВЕТИСЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДанныеДляУточнения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные.ИдентификаторПроисхожденияВЕТИС = Результат;
	Если ПараметрыСканирования.ЗаполнятьСрокГодности Тогда
		СрокГодности = СрокГодностиПоИдентификаторуПроисхожденияВЕТИС(Результат);
		Если ЗначениеЗаполнено(СрокГодности) Тогда
			ТекущиеДанные.СрокГодности = СрокГодности;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СрокГодностиПоИдентификаторуПроисхожденияВЕТИС(ИдентификаторПроисхождения)
	
	ИдентификаторыПроисхождения = Новый Массив;
	ИдентификаторыПроисхождения.Добавить(ИдентификаторПроисхождения);
	Модуль = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСМПВЕТИС");
	ДанныеИдентификаторов = Модуль.ДанныеИдентификаторовПроисхождения(ИдентификаторыПроисхождения);
	Если ДанныеИдентификаторов.Получить(ИдентификаторПроисхождения) <> Неопределено Тогда
		Возврат ДанныеИдентификаторов.Получить(ИдентификаторПроисхождения).СрокГодности;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНоменклатуры()
	
	СписокВыбораНоменклатура = Элементы.ДанныеДляУточненияНоменклатура.СписокВыбора;
	СписокВыбораНоменклатура.Очистить();
	
	ТекущиеДанные = Элементы.ДанныеДляУточнения.ТекущиеДанные;
	Если ТипЗнч(ТекущиеДанные.СписокНоменклатуры) = Тип("ФиксированныйМассив") И ТекущиеДанные.СписокНоменклатуры.Количество() Тогда
		Для Каждого ЭлементСписка Из ТекущиеДанные.СписокНоменклатуры Цикл
			СписокВыбораНоменклатура.Добавить(ЭлементСписка, ЭлементСписка.ПредставлениеНоменклатуры);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#Область ЗавершениеОбработки

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Если Не ПроверитьЗаполнениеНаКлиенте() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбновитьИзмененныеОбъекты() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(КодМаркировки);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	Отказ = Ложь;
	
	Для Каждого СтрокаТаблицы Из ДанныеДляУточнения Цикл
		
		Отказ = Отказ Или Не СтрокаЗаполнена(СтрокаТаблицы, Истина);
		
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

&НаКлиенте
Функция СтрокаЗаполнена(СтрокаТаблицы, ВыводитьСообщения = Истина)
	
	СтрокаНеЗаполнена = Ложь;
	Индекс = ДанныеДляУточнения.Индекс(СтрокаТаблицы) + 1;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура)
		И Не ПараметрыСканирования.РазрешенаОбработкаКодовСПустойНоменклатурой Тогда
		Если ВыводитьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Требуется уточнение номенклатуры кода маркировки'"),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДанныеДляУточнения", Индекс, "Номенклатура"),,
				СтрокаНеЗаполнена);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицы.Характеристика)
		И СтрокаТаблицы.ХарактеристикиИспользуются Тогда
		Если ВыводитьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Требуется уточнение характеристики номенклатуры'"),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДанныеДляУточнения", Индекс, "Характеристика"),,
				СтрокаНеЗаполнена);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицы.Серия)
		И ИнтеграцияИСКлиентСервер.НеобходимоУказатьСерию(СтрокаТаблицы.СтатусУказанияСерий) Тогда
		Если ВыводитьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Требуется уточнение серии номенклатуры'"),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДанныеДляУточнения", Индекс, "Серия"),,
				СтрокаНеЗаполнена);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыСканирования.Свойство("ЗаполнятьДанныеВЕТИС")
		И ПараметрыСканирования.ЗаполнятьДанныеВЕТИС
		И СтрокаТаблицы.ВидУпаковки <> ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Набор")
		И Не ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторПроисхожденияВЕТИС) Тогда
		Если ВыводитьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Требуется уточнение идентификатора происхождения ВетИС'"),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДанныеДляУточнения", Индекс, "ИдентификаторПроисхожденияВЕТИС"),,
				СтрокаНеЗаполнена);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности")
		И ПараметрыСканирования.ЗаполнятьСрокГодности
		И СтрокаТаблицы.ВидУпаковки <> ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Набор")
		И Не ЗначениеЗаполнено(СтрокаТаблицы.СрокГодности) Тогда
		Если ВыводитьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Требуется уточнение срока годности'"),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДанныеДляУточнения", Индекс, "СрокГодности"),,
				СтрокаНеЗаполнена);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не СтрокаНеЗаполнена;
	
КонецФункции

&НаСервере
Функция ОбновитьИзмененныеОбъекты()
	
	Отказ = ОбновитьЗаполненныеШтрихкодыУпаковок();
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОбновитьДанныеУпаковокПоАдресуДереваУпаковок();
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ОбновитьЗаполненныеШтрихкодыУпаковок()
	
	ДеревоУпаковок = ПолучитьИзВременногоХранилища(АдресДереваУпаковок);
	
	ОписаниеНоменклатуры = ОбщегоНазначенияИС.ОписаниеНоменклатуры(ДанныеДляУточнения.Выгрузить(,"Номенклатура").ВыгрузитьКолонку("Номенклатура"));
	
	Для Каждого СтрокаРезультат Из ДанныеДляУточнения Цикл
		
		СтрокаДерева = НайтиСтрокуДереваПоКодуМаркировки(ДеревоУпаковок, СтрокаРезультат.Штрихкод);
		
		// Уточнение номенклатуры в дереве - только коды остатков (для потребительской упаковки)
		Если СтрокаДерева.Номенклатура <> СтрокаРезультат.Номенклатура
			И Не РазборКодаМаркировкиИССлужебныйКлиентСервер.ЭтоEANИлиGTIN(СтрокаРезультат.Штрихкод) Тогда
			СтрокаДерева.Количество = ОписаниеНоменклатуры.Получить(СтрокаРезультат.Номенклатура).КоличествоВПотребительскойУпаковке;
			Если СтрокаДерева.Количество <> 1 Тогда
				СтрокаДерева.КоличествоПотребительскихУпаковок = 1;
			КонецЕсли;
		КонецЕсли;
		
		Если (СтрокаДерева.Номенклатура <> СтрокаРезультат.Номенклатура
				Или СтрокаДерева.Характеристика <> СтрокаРезультат.Характеристика
				Или СтрокаДерева.Серия <> СтрокаРезультат.Серия)
			И ПараметрыСканирования.СоздаватьШтрихкодУпаковки Тогда
			
			// Уточнение серии - распространить на нижележащие уровни (для групповой/логистической упаковки)
			Для Каждого ВложенныйЭлемент Из СтрокаДерева.Строки Цикл
				Если Не ОбновитьВложениеОднороднойУпаковки(СтрокаРезультат, ВложенныйЭлемент) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
		
			ИсходныеРеквизиты = Новый Структура("Номенклатура, Характеристика, Серия");
			ЗаполнитьЗначенияСвойств(ИсходныеРеквизиты, СтрокаРезультат);
			ЗаполнитьЗначенияСвойств(СтрокаДерева, ИсходныеРеквизиты);
			
			НачатьТранзакцию();
			Попытка
				ШтрихкодированиеИС.ОбновитьСоздатьШтрихкодУпаковкиДанныхШтрихкода(СтрокаДерева, Неопределено, ПараметрыСканирования);
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ИмяСобытияЖурналРегистрации = НСтр("ru = 'ГосИС: Запись штрихкода упаковки'", ОбщегоНазначения.КодОсновногоЯзыка());
				ЗаписьЖурналаРегистрации(ИмяСобытияЖурналРегистрации, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки);
				Возврат Истина;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ГрупповаяОбработкаШтрихкодовИС.ЭтоАгрегатТСД(КодМаркировки)
		И ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
		МодульШтрихкодированиеИСМПСлужебный = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИСМПСлужебный");
		МодульШтрихкодированиеИСМПСлужебный.СохранениеКодовМаркировкиВПул(
			ДеревоУпаковок, ПараметрыСканирования);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ДеревоУпаковок, АдресДереваУпаковок);
	Возврат Ложь;
	
КонецФункции

// Обновить вложение однородной упаковки.
// 
// Параметры:
//  Источник - ДанныеФормыЭлементКоллекции - данные заполнения
//  Приемник  - СтрокаДереваЗначений - данные штрихкода упаковки (в некоторой иерархии)
// 
// Возвращаемое значение:
//  Булево - произошла ошибка обновления элементов справочника "Штрихкоды упаковок товаров" в ИБ
&НаСервере
Функция ОбновитьВложениеОднороднойУпаковки(Источник, Приемник)
	
	Если Приемник.Номенклатура = Источник.Номенклатура
			И Приемник.Характеристика = Источник.Характеристика
			И Приемник.Серия = Источник.Серия Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого ВложенныйЭлемент Из Приемник.Строки Цикл
		Если ОбновитьВложениеОднороднойУпаковки(Источник, ВложенныйЭлемент) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	ИсходныеРеквизиты = Новый Структура("Номенклатура, Характеристика, Серия");
	ЗаполнитьЗначенияСвойств(ИсходныеРеквизиты, Источник);
	ЗаполнитьЗначенияСвойств(Приемник, ИсходныеРеквизиты);
	
	НачатьТранзакцию();
	Попытка
		ШтрихкодированиеИС.ОбновитьСоздатьШтрихкодУпаковкиДанныхШтрихкода(Приемник, Неопределено, ПараметрыСканирования);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ИмяСобытияЖурналРегистрации = НСтр("ru = 'ГосИС: Запись штрихкода упаковки'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналРегистрации, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки);
		Возврат Истина;
	КонецПопытки;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеУпаковокПоАдресуДереваУпаковок()
	
	ДеревоУпаковок = ПолучитьИзВременногоХранилища(АдресДереваУпаковок);
	
	ГруппыКПересортировке = Новый Соответствие;
	
	ВидПродукции = Неопределено;
	
	Для Каждого СтрокаРезультат Из ДанныеДляУточнения Цикл
		
		СтрокаДерева = НайтиСтрокуДереваПоКодуМаркировки(ДеревоУпаковок, СтрокаРезультат.Штрихкод);
		ОбновитьВложенныеДанныеУпаковокПоУпаковке(СтрокаРезультат, СтрокаДерева, ВидПродукции, ГруппыКПересортировке);
		
	КонецЦикла;
	
	Для Каждого Группа Из ГруппыКПересортировке Цикл
		Группа.Ключ.Строки.Сортировать("Номенклатура, Характеристика, Серия, Штрихкод");
	КонецЦикла;
	
	Если (ПараметрыСканирования.Свойство("ЗаполнятьДанныеВЕТИС")
			И ПараметрыСканирования.ЗаполнятьДанныеВЕТИС)
		Или (ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности")
			И ПараметрыСканирования.ЗаполнятьСрокГодности) Тогда
		СтрокаДерева = НайтиСтрокуДереваПоКодуМаркировки(ДеревоУпаковок, КодМаркировки);
		ЗаполнитьСрокиГодностиВУпаковках(СтрокаДерева);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		
		Если ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияИСМП(ВидПродукции) Тогда
			
			МодульШтрихкодированиеИСМПСлужебный = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИСМПСлужебный");
			МодульШтрихкодированиеИСМПСлужебный.НормализоватьДанныеДереваУпаковок(
				ДеревоУпаковок, ПараметрыСканирования);
			
		ИначеЕсли ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукции) Тогда
			
			МодульШтрихкодированиеМОТП = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеМОТП");
			МодульШтрихкодированиеМОТП.НормализоватьДанныеДереваУпаковок(
				ДеревоУпаковок, ПараметрыСканирования);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ДеревоУпаковок, АдресДереваУпаковок);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВложенныеДанныеУпаковокПоУпаковке(СтрокаРезультат, СтрокаДерева, ВидПродукции, ГруппыКПересортировке)
	
	Для Каждого ВложенныйЭлемент Из СтрокаДерева.Строки Цикл
		ОбновитьВложенныеДанныеУпаковокПоУпаковке(СтрокаРезультат, ВложенныйЭлемент, ВидПродукции, ГруппыКПересортировке);
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(СтрокаДерева, СтрокаРезультат,,"Количество, Штрихкод, ВидУпаковки, ВидПродукции");
	
	Если СтрокаДерева.Родитель <> Неопределено Тогда
		ГруппыКПересортировке.Вставить(СтрокаДерева.Родитель);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаДерева.ВидПродукции) Тогда
		ВидПродукции = СтрокаДерева.ВидПродукции;
	КонецЕсли;
	
	Если ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности") И ПараметрыСканирования.ЗаполнятьСрокГодности Тогда
		СтрокаДерева.ГоденДо = СтрокаРезультат.СрокГодности;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСрокиГодностиВУпаковках(СтрокаДерева)
	
	Для Каждого ВложеннаяСтрока Из СтрокаДерева.Строки Цикл
		ЗаполнитьСрокиГодностиВУпаковках(ВложеннаяСтрока);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СтрокаДерева.ГоденДо) Тогда
		Возврат;
	КонецЕсли;
	
	ОбщиеДанные = Новый Структура("Заполнено,ИдентификаторПроисхожденияВЕТИС, ГоденДо");
	
	ЭлементДляПроверки = Новый Структура("ИдентификаторПроисхожденияВЕТИС, ГоденДо");
	
	Для Каждого ВложеннаяСтрока Из СтрокаДерева.Строки Цикл
		Если ОбщиеДанные.Заполнено = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ОбщиеДанные, ВложеннаяСтрока);
			ОбщиеДанные.Заполнено = Истина;
		Иначе
			ЗаполнитьЗначенияСвойств(ЭлементДляПроверки, ВложеннаяСтрока);
			ОбщиеДанные.Заполнено = ОбщиеДанные.Заполнено
				И ОбщиеДанные.ИдентификаторПроисхожденияВЕТИС = ЭлементДляПроверки.ИдентификаторПроисхожденияВЕТИС
				И ОбщиеДанные.ГоденДо = ЭлементДляПроверки.ГоденДо;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбщиеДанные.Заполнено = Истина Тогда
		ЗаполнитьЗначенияСвойств(ЭлементДляПроверки, ОбщиеДанные);
		ЗаполнитьЗначенияСвойств(СтрокаДерева, ЭлементДляПроверки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти