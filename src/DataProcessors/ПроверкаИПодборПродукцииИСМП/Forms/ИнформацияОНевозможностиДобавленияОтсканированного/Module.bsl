#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидПродукции = Параметры.ВидПродукции;
	
	ИдентификаторСтрокиПозиционирования   = - 1;
	ПоказатьДерево                        = Ложь;
	СкрытьБезПроблем                      = Истина;
	СсылкаНаОбъект                        = Параметры.СсылкаНаОбъект;
	
	Элементы.ИгнорироватьОшибку.Видимость             = Ложь;
	Элементы.ГруппаКоманднаяПанельСКнопками.Видимость = Ложь;
	
	Элементы.ДеревоОтсканированнойУпаковкиИгнорироватьОшибку.Видимость = Ложь;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресДереваУпаковок) Тогда
		
		ИнформацияВДереве = Истина;
		
		ДеревоУпаковки = ПолучитьИзВременногоХранилища(Параметры.АдресДереваУпаковок);
		
		ПоказатьДерево = ДеревоУпаковки.Строки.Количество() > 1;
		
		Для Каждого СтрокаДерева Из ДеревоУпаковки.Строки Цикл
			
			Если СтрокаДерева.Строки.Количество() > 0 Тогда
				ПоказатьДерево = Истина;
			КонецЕсли;
			
			ДобавитьСтрокуВДерево(ДеревоОтсканированнойУпаковки.ПолучитьЭлементы(), СтрокаДерева);
			
		КонецЦикла;
		
	Иначе 
		
		ИнформацияВДереве = Ложь;
		ЭтоУпаковка       = Ложь; 
		
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	ШтрихкодированиеИСМПСлужебный.ЗаполнитьРасширенноеПредставлениеОшибки(
		ПредставлениеОшибки,
		Параметры.ПараметрыОшибки,
		ЭтотОбъект);
	
	ДоступнаПечатьКодаМаркировки = Параметры.ДоступнаПечатьКодаМаркировки;
	Если ДоступнаПечатьКодаМаркировки Тогда
		АдресДанныхКодаМаркировки = ПоместитьВоВременноеХранилище(Параметры.ДанныеКодаМаркировки, УникальныйИдентификатор);
	КонецЕсли;
	
	Если ПоказатьДерево Тогда
		
		ПоказатьИнформациюОПроблемахСУпаковкой();
		
	Иначе
		
		ПоказатьИнформациюОПроблемахСМаркируемойПродукцией(ИнформацияВДереве);
		
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого ЭлементСписка Из ИдентификаторыРаскрываемыхСтрок Цикл
		
		Элементы.ДеревоОтсканированнойУпаковки.Развернуть(ЭлементСписка.Значение, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОшибкаДобавленияМаркируемойПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СкопироватьШтриховойКодВБуферОбмена" Тогда
		
		СтандартнаяОбработка = Ложь;
		ИнтеграцияИСКлиент.СкопироватьШтрихКодВБуферОбмена(Элементы.БуферОбмена, Штрихкод);
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "РаспечататьКодМаркировки" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресДанныхКодаМаркировки", АдресДанныхКодаМаркировки);
		
		ОткрытьФорму(
			"РегистрСведений.ПулКодовМаркировкиСУЗ.Форма.ФормаПечатиКодаМаркировки",
			ПараметрыОткрытияФормы,
			ЭтотОбъект,,,,
			Новый ОписаниеОповещения("ПечатьКодаМаркировкиЗавершение", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
	ШтрихкодированиеИСМПКлиент.ОбработкаНавигационнойСсылкиТекстаОшибки(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОтсканированнойУпаковки

&НаКлиенте
Процедура ДеревоОтсканированнойУпаковкиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоОтсканированнойУпаковки.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено 
		И ТекущиеДанные.ЕстьОшибки Тогда
		
		МассивОшибок = Новый Массив;
		
		Если ЗначениеЗаполнено(ТекущиеДанные.ТекстОшибки) Тогда
			МассивОшибок.Добавить(ТекущиеДанные.ТекстОшибки);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущиеДанные.ТекстОшибкиГИСМТ) Тогда
			МассивОшибок.Добавить(ТекущиеДанные.ТекстОшибкиГИСМТ);
		КонецЕсли;
		
		ТекстОшибки = СтрСоединить(МассивОшибок, Символы.ПС);
		
	Иначе
		
		ТекстОшибки = "";
		
	КонецЕсли;
	
	ПредставлениеОшибкиТекущейСтроки = Новый ФорматированнаяСтрока(ТекстОшибки,,ЦветТекстаПроблемаГосИС());
	Элементы.ПредставлениеОшибкиТекущейСтроки.Высота = СтрРазделить(ПредставлениеОшибкиТекущейСтроки, Символы.ПС).Количество();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрытьСтрокиБезПроблем(Команда)
	
	СкрытьБезПроблем = Не СкрытьБезПроблем;
	Элементы.ДеревоОтсканированнойУпаковкиСкрытьСтрокиБезПроблем.Пометка = СкрытьБезПроблем;
	
	Если СкрытьБезПроблем Тогда
		СкрытьСтрокиБезПроблемНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИгнорироватьОшибку(Команда)
	
	ПараметрыПроверки = ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ПараметрыПроверки;
	ПараметрыПроверки.Результат.ВыполнитьФискализацию = Истина;
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьФормуПроверкиИПодбора(Команда) Экспорт
	
	ПроверкаИПодборПродукцииИСМПКлиент.ОткрытьФормуПроверкиИПодбораПоВыделеннойСтроке(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьСтрокуВДерево(КоллекцияСтрокПриемника, СтрокаИсточник)

	НоваяСтрока = КоллекцияСтрокПриемника.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник);
	
	Если НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар
		Или Не ЗначениеЗаполнено(НоваяСтрока.ТипУпаковки) Тогда
		КоличествоСтрокСМаркируемойПродукцией = КоличествоСтрокСМаркируемойПродукцией + 1;
	КонецЕсли;
	
	Если НоваяСтрока.ЕстьОшибки Тогда
		
		Если НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар
			Или Не ЗначениеЗаполнено(НоваяСтрока.ТипУпаковки) Тогда
			КоличествоСтрокСПроблемами = КоличествоСтрокСПроблемами + 1;
		КонецЕсли;
		
		СтрокаРодитель = НоваяСтрока.ПолучитьРодителя();
		
		Если СтрокаРодитель <> Неопределено Тогда
			
			ИдентификаторСтрокиРодителя = СтрокаРодитель.ПолучитьИдентификатор();
			Если ИдентификаторыРаскрываемыхСтрок.НайтиПоЗначению(ИдентификаторСтрокиРодителя) = Неопределено Тогда
				ИдентификаторыРаскрываемыхСтрок.Добавить(ИдентификаторСтрокиРодителя);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИдентификаторСтрокиПозиционирования = - 1 Тогда
			ИдентификаторСтрокиПозиционирования = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ПодчиненнаяСтрока Из СтрокаИсточник.Строки Цикл
		
		ДобавитьСтрокуВДерево(НоваяСтрока.ПолучитьЭлементы(), ПодчиненнаяСтрока);
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ПодчиненнаяСтрока.ТипУпаковки) Тогда
			
			НоваяСтрока.СодержитУпаковок = НоваяСтрока.СодержитУпаковок + 1;
			
		Иначе 
			
			НоваяСтрока.СодержитПачек = НоваяСтрока.СодержитПачек + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(НоваяСтрока.ТипУпаковки) Тогда
		
		Для Каждого ПодчиненнаяСтрока Из НоваяСтрока.ПолучитьЭлементы() Цикл
			
			НоваяСтрока.СодержитУпаковок = НоваяСтрока.СодержитУпаковок + ПодчиненнаяСтрока.СодержитУпаковок;
			НоваяСтрока.СодержитПачек  = НоваяСтрока.СодержитПачек + ПодчиненнаяСтрока.СодержитПачек;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(НоваяСтрока.ТипУпаковки) Тогда
		
		Если НоваяСтрока.СодержитУпаковок > 0 
			И НоваяСтрока.СодержитПачек > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(
				НСтр("ru = 'Упаковок - %1, кодов маркировки - %2.'"),
					НоваяСтрока.СодержитУпаковок,
					НоваяСтрока.СодержитПачек);
			
		ИначеЕсли НоваяСтрока.СодержитУпаковок > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(
				НСтр("ru = 'Упаковок - %1.'"),
				НоваяСтрока.СодержитУпаковок);
			
		ИначеЕсли НоваяСтрока.СодержитПачек > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(
				НСтр("ru = 'Кодов маркировки - %1.'"),
				НоваяСтрока.СодержитПачек);
			
		Иначе
			
			НоваяСтрока.ПредставлениеНоменклатуры = НСтр("ru = '<пустая упаковка>'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
		НоваяСтрока.ПредставлениеНоменклатуры = НоваяСтрока.Номенклатура;
	ИначеЕсли ЗначениеЗаполнено(НоваяСтрока.ПредставлениеНоменклатуры) Тогда
		НоваяСтрока.ПредставлениеНоменклатуры = НоваяСтрока.ПредставлениеНоменклатуры;
	Иначе
		НоваяСтрока.ПредставлениеНоменклатуры = НСтр("ru = '<не определена>'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НоваяСтрока.ВидПродукции) Тогда
		НоваяСтрока.ВидПродукции = ВидПродукции;
	КонецЕсли;
	
	НоваяСтрока.ИндексКартинкиТипУпаковки = ИнтеграцияИСМПСлужебный.ИндексКартинкиПоВидуУпаковкиИВидуПродукции(
		НоваяСтрока.ВидУпаковки,
		НоваяСтрока.ВидПродукции);
	
	Если ГрупповаяОбработкаШтрихкодовИС.ЭтоАгрегатТСД(НоваяСтрока.Штрихкод) Тогда
		НоваяСтрока.Штрихкод = НСтр("ru = 'Групповая загрузка кодов маркировки'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
#Область ЕстьОшибки
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковкиТекстОшибки.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковкиТекстОшибкиГИСМТ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.ЕстьОшибки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаГосИС);

#КонецОбласти

#Область Отбор

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковки.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СкрытьБезПроблем");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.НеСоответствуетОтбору");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона" , ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);

#КонецОбласти

#Область Представление

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковкиПредставление.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.ТипУпаковки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыУпаковок.МаркированныйТовар;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);

#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура СкрытьСтрокиБезПроблемНаСервере()

	Если СкрытьБезПроблем Тогда
	
		СтрокиДерева = ДеревоОтсканированнойУпаковки.ПолучитьЭлементы();
		
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			
			СоответствуетОтбору = Ложь;
			СкрытьБезОшибокВСтрокеДерева(СтрокаДерева, СоответствуетОтбору);
			
		КонецЦикла;
		
		Элементы.ДеревоОтсканированнойУпаковкиСкрытьСтрокиБезПроблем.Пометка = СкрытьБезПроблем;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкрытьБезОшибокВСтрокеДерева(Знач СтрокаДерева, СоответствуетОтбору)

	Если ТипЗнч(СтрокаДерева) = Тип("Число") Тогда
		СтрокаДерева = ДеревоОтсканированнойУпаковки.НайтиПоИдентификатору(СтрокаДерева);
	КонецЕсли;
	
	ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();

	ТекущаяСтрокаСоответствуетОтбору = Ложь;
	
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		
		СоответствуетОтбору = Ложь;
		
		СкрытьБезОшибокВСтрокеДерева(ПодчиненнаяСтрока, СоответствуетОтбору);
		
		Если СоответствуетОтбору Тогда
			ТекущаяСтрокаСоответствуетОтбору = Истина;
		КонецЕсли;
		
	КонецЦикла;

	Если Не ТекущаяСтрокаСоответствуетОтбору Тогда
		
		ТекущаяСтрокаСоответствуетОтбору = СтрокаДерева.ЕстьОшибки;
		
	КонецЕсли;
	
	СоответствуетОтбору = ТекущаяСтрокаСоответствуетОтбору;
	СтрокаДерева.НеСоответствуетОтбору = Не СоответствуетОтбору;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьРекурсивноНаличиеОшибокГИСМТ(Дерево, ТекущийЭлемент = Неопределено)
	
	ЕстьОшибкиГИСМТ = Ложь;
	
	Если ТекущийЭлемент = Неопределено Тогда
		СтрокиДерева = Дерево.Строки;
	Иначе
		СтрокиДерева = ТекущийЭлемент.Строки;
	КонецЕсли;
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если ЗначениеЗаполнено(СтрокаДерева.ТекстОшибкиГИСМТ) Тогда
			ЕстьОшибкиГИСМТ = Истина;
			Прервать;
		КонецЕсли;
		
		ЕстьОшибкиГИСМТ = ПроверитьРекурсивноНаличиеОшибокГИСМТ(Дерево, СтрокаДерева);
		
	КонецЦикла;
	
	Возврат ЕстьОшибкиГИСМТ;
	
КонецФункции

&НаСервере
Процедура СформироватьИнформациюОПроблемах();
	
	Если Параметры.ОбратноеСканирование Тогда
		ШаблонСообщения = НСтр("ru = 'Удаление отсканированной упаковки невозможно. Невозможно удалить единиц маркируемой продукции %1 из %2.'");
	ИначеЕсли Не ЗначениеЗаполнено(ШаблонСообщения) Тогда
		ШаблонСообщения = НСтр("ru = 'Добавление отсканированной упаковки невозможно. Невозможно добавить единиц маркируемой продукции %1 из %2.'");
	КонецЕсли;
	
	Элементы.ДекорацияИнформацияОПроблемах.Заголовок = СтрШаблон(ШаблонСообщения, КоличествоСтрокСПроблемами, КоличествоСтрокСМаркируемойПродукцией);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПроблемахСМаркируемойПродукцией(ИнформацияВДереве)

	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаМаркируемаяПродукция;
	Элементы.СтраницаУпаковка.Видимость    = Ложь;
	
	Элементы.ЗакрытьМаркируемаяПродукция.КнопкаПоУмолчанию = Истина;
	
	ПрефиксМаркируемаяПродукцияИдентифицирована   = НСтр("ru = 'Невозможно добавить маркируемую продукцию ""%1"" с кодом маркировки'");
	ПрефиксМаркируемаяПродукцияНеИдентифицирована = НСтр("ru = 'Невозможно добавить неопознанную маркируемую продукцию с кодом маркировки'");
	
	ТекстОшибкиФорматированнаяСтрока = Неопределено;
	ОбратноеСканирование             = Ложь;
	
	Если ИнформацияВДереве Тогда
	
		СтрокиВерхнегоУровня = ДеревоОтсканированнойУпаковки.ПолучитьЭлементы();
		
		Если СтрокиВерхнегоУровня.Количество() = 0 Тогда
			
			Элементы.ДекорацияОшибкаДобавленияМаркируемойПродукции.Заголовок = НСтр("ru = 'Нет информации по отсканированному штрихкоду'");
			Возврат;
			
		Иначе
			
			ДаннныеМаркируемойПродукции = СтрокиВерхнегоУровня[0];
			
			Штрихкод                  = ДаннныеМаркируемойПродукции.Штрихкод;
			ПредставлениеНоменклатуры = ДаннныеМаркируемойПродукции.Номенклатура;
			ТекстОшибки               = ДаннныеМаркируемойПродукции.ТекстОшибки;
		
		КонецЕсли;
		
	Иначе
		
		ТекстОшибки          = Параметры.ТекстОшибки;
		ВидПродукции         = Параметры.ВидПродукции;
		Организация          = Параметры.Организация;
		ОбратноеСканирование = Параметры.ОбратноеСканирование;
		Параметры.Свойство("ТекстОшибкиФорматированнаяСтрока", ТекстОшибкиФорматированнаяСтрока);
		Если Не ЗначениеЗаполнено(Штрихкод) Тогда
			Штрихкод = Параметры.Штрихкод;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ПредставлениеНоменклатуры) Тогда
			ПредставлениеНоменклатуры = Параметры.ПредставлениеНоменклатуры;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбратноеСканирование Тогда
		Префикс = НСтр("ru = 'Невозможно удалить маркируемую продукцию с кодом маркировки'");
		Заголовок = НСтр("ru = 'Проблемы при удалении'");
	ИначеЕсли ЗначениеЗаполнено(ПредставлениеНоменклатуры)
		И Не ЗначениеЗаполнено(Префикс) Тогда
		Префикс = СтрШаблон(ПрефиксМаркируемаяПродукцияИдентифицирована, ПредставлениеНоменклатуры);
	ИначеЕсли Не ЗначениеЗаполнено(Префикс) Тогда
		Префикс = ПрефиксМаркируемаяПродукцияНеИдентифицирована;
	КонецЕсли;
	
	СоставСтрокиПричины = Новый Массив();
	СоставСтрокиПричины.Добавить(Префикс);
	СоставСтрокиПричины.Добавить(" ");
	
	Если ЗначениеЗаполнено(Штрихкод) Тогда
		
		СтрокаГиперссылка = Новый ФорматированнаяСтрока(
			ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ПредставлениеШтрихкода(Штрихкод),
			Новый Шрифт(,,,,Истина),
			ЦветаСтиля.ЦветГиперссылкиГосИС,,
			"СкопироватьШтриховойКодВБуферОбмена");
		
		СоставСтрокиПричины.Добавить(СтрокаГиперссылка);
		СоставСтрокиПричины.Добавить(" ");
		
	КонецЕсли;
	
	Если ТекстОшибкиФорматированнаяСтрока <> Неопределено Тогда
		ТекстСОшибкой = ТекстОшибкиФорматированнаяСтрока;
	Иначе
		ТекстСОшибкой = ТекстОшибки;
	КонецЕсли;
	
	СоставСтрокиПричины.Добавить(НСтр("ru = 'по причине:'"));
	СоставСтрокиПричины.Добавить(Символы.ПС);
	СоставСтрокиПричины.Добавить(ТекстСОшибкой);
	
	Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
		СоставСтрокиПричины.Добавить(Символы.ПС);
		СоставСтрокиПричины.Добавить(ПредставлениеОшибки);
	КонецЕсли;
	
	Если ДоступнаПечатьКодаМаркировки Тогда
		СоставСтрокиПричины.Добавить(Символы.ПС);
		СоставСтрокиПричины.Добавить(НСтр("ru = 'Возможные причины:
		|- не корректно настроен сканер штрихкода,
		|- не корректно распечатан код маркировки'"));
		СоставСтрокиПричины.Добавить(" ");
		СоставСтрокиПричины.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'распечатать'"),
			Новый Шрифт(,,,,Истина),
			ЦветаСтиля.ЦветГиперссылкиГосИС,,
			"РаспечататьКодМаркировки"));
	КонецЕсли;
	
	Элементы.ДекорацияОшибкаДобавленияМаркируемойПродукции.Заголовок = Новый ФорматированнаяСтрока(СоставСтрокиПричины);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПроблемахСУпаковкой()
	
	Элементы.СтраницыФормы.ТекущаяСтраница          = Элементы.СтраницаУпаковка;
	Элементы.СтраницаМаркируемаяПродукция.Видимость = Ложь;
	
	Ширина = 200;
	Высота = 40;
	
	СкрытьСтрокиБезПроблемНаСервере();
	СформироватьИнформациюОПроблемах();
	
	Элементы.ДеревоОтсканированнойУпаковки.ТекущаяСтрока = ИдентификаторСтрокиПозиционирования;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЦветТекстаПроблемаГосИС()
	
	Возврат ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	
КонецФункции

&НаКлиенте
Процедура ПечатьКодаМаркировкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	ДанныеДерева = РеквизитФормыВЗначение("ДеревоОтсканированнойУпаковки");
	ЕстьОшибкиГИСМТ = ПроверитьРекурсивноНаличиеОшибокГИСМТ(ДанныеДерева);
	
	Элементы.ДеревоОтсканированнойУпаковкиТекстОшибкиГИСМТ.Видимость = ЕстьОшибкиГИСМТ;
	
КонецПроцедуры

#КонецОбласти
