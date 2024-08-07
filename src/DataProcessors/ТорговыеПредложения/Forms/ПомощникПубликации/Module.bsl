
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НавигационнаяСсылка = "e1cib/app/" + ИмяФормы;
	
	Если Не ТорговыеПредложения.ПравоНастройкиТорговыхПредложений(Истина)
		Или Не БизнесСеть.ПравоНастройкиОбменаДокументами(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ТорговыеПредложенияСлужебный.ИспользоватьФункционалПубликации() Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Отсутствует функциональность публикации торговых предложений.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Ссылка", Соглашение);
	ОбновитьДанныеФормы();
	
	Элементы.ГруппаДлительнаяОперация.Видимость = Ложь;
	
	ТорговыеПредложенияСлужебный.НайтиДлительнуюОперациюСинхронизацииТорговыхПредложений(ДлительнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ТорговыеПредложения_ПослеЗаписи"
		Или ИмяСобытия = "ТорговыеПредложение_СопоставлениеНоменклатуры"
		Или ИмяСобытия = "СинхронизацияТорговыхПредложений_ПриИзменении"
		Или ИмяСобытия = "ТорговыеПредложения_ИзменениеСинхронизации" Тогда
		ОбновитьСтатистикуПубликации(Ложь, Истина, Ложь, Ложь);
	ИначеЕсли ИмяСобытия = "БизнесСеть_РегистрацияОрганизаций" Тогда
		ОбновитьСтатистикуПубликации(Ложь, Ложь, Ложь, Истина);
	ИначеЕсли ИмяСобытия = "ТорговыеПредложения_СохранениеРегионовАбонента" Тогда
		ОбновитьСтатистикуПубликации(Ложь, Ложь, Истина, Ложь);
	ИначеЕсли Источник = "ИспользоватьСервисРаботаСНоменклатурой" Тогда
		ОбновитьСтатистикуПубликации(Истина, Ложь, Истина, Ложь);
	ИначеЕсли ИмяСобытия = "РаботаСНоменклатурой_СопоставлениеНоменклатуры" Тогда	
		ОбновитьСтатистикуПубликации(Истина, Ложь, Ложь, Ложь);
	КонецЕсли;
	
	ТорговыеПредложенияКлиент.ОбработкаОповещенияСинхронизацииТорговыхПредложений(ИмяСобытия, Источник, Параметр, ДлительнаяОперация, ПараметрыСинхронизации());
	Элементы.РезультатНадпись.Видимость = ДлительнаяОперация = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоказатьСкрытьПояснения(ПоказыватьПояснения, Элементы);
	ОбновитьСтатистикуПубликации(Истина, Истина, Истина, Истина);
	ТорговыеПредложенияКлиент.ОтобразитьСостояниеСинхронизацииТорговыхПредложений(ПараметрыСинхронизации(), ДлительнаяОперация);
	Элементы.РезультатНадпись.Видимость = ДлительнаяОперация = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УсловияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьОрганизациюПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиСинхронизироватьПриИзменении(Элемент)
	
	ИзменитьРегламентноеЗаданиеСинхронизацияТорговыхПредложений("Использование", АвтоматическиСинхронизировать);
	Оповестить("СинхронизацияТорговыхПредложений_ПриИзменении", АвтоматическиСинхронизировать);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияЗаголовокНажатие(Элемент)
	
	ОчиститьСообщения();
	
	БизнесСетьСлужебныйКлиент.ОткрытьФормуРегистрацииОрганизаций();
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговыеПредложенияЗаголовокНажатие(Элемент)
	
	ОчиститьСообщения();
	ТорговыеПредложенияКлиент.ОткрытьФормуСпискаПубликаций(Неопределено, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьНоменклатуруСервисаНажатие(Элемент)
	
	ОчиститьСообщения();
	
	Если Не ИспользоватьСопоставление1СНоменклатура Тогда 
		
		ОбщийМодульРаботаСНоменклатуройКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСНоменклатуройКлиент");
		
		ПараметрыОткрытия = ОбщийМодульРаботаСНоменклатуройКлиент.ПараметрыФормыПанелиАдминистрирования();
		ПараметрыОткрытия.Раздел          =    "НастройкиРаботаСНоменклатурой";
		ПараметрыОткрытия.Заголовок       = НСтр("ru = 'Сервис 1С:Номенклатура'");
		ПараметрыОткрытия.ОписаниеРаздела = 
			НСтр("ru = 'Для возможности сопоставления номенклатуры необходимо включить использование сервиса 1С:Номенклатура.'");
			
		ОбщийМодульРаботаСНоменклатуройКлиент.ОткрытьФормуПанелиАдминистрирования(ПараметрыОткрытия, ЭтотОбъект, 
			Новый ОписаниеОповещения("СопоставитьНоменклатуруСервисаПродолжение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
		
		ОткрытьФормуСопоставленияНоменклатурыСервиса();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьНоменклатуруСРубрикаторомНажатие(Элемент)
	
	ОчиститьСообщения();
	
	Если Не ИспользоватьСопоставление1СНоменклатура Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Раздел",    "НастройкиРаботаСНоменклатурой");
		ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru = 'Сервис 1С:Номенклатура'"));
		ПараметрыОткрытия.Вставить("ОписаниеРаздела",
			НСтр("ru = 'Для возможности сопоставления номенклатуры необходимо включить использование сервиса 1С:Номенклатура.'"));
		
		
		ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ПанельАдминистрирования", ПараметрыОткрытия, ЭтотОбъект,,,, 
			Новый ОписаниеОповещения("СопоставитьНоменклатуруСРубрикаторомПродолжение", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
		
		ОткрытьФормуСопоставленияНоменклатурыСРубрикатором();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииТорговыхПредложенийГиперссылкаНажатие(Элемент)
	ОчиститьСообщения();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИспользоватьСтатистикуПубликации", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьСтатистикуПубликацииПоОповещению", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыОткрытияФормы = ТорговыеПредложенияКлиент.ПараметрыОткрытияФормы();
	
	ПараметрыОткрытияФормы.ВладелецФормы      = ЭтотОбъект;
	ПараметрыОткрытияФормы.ОписаниеОповещения = ОписаниеОповещения;
	
	ТорговыеПредложенияКлиент.ОткрытьФормуСостоянияПубликацииТоваров(ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияДлительнаяОперацияНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьФоновоеЗадание" Тогда
		СтандартнаяОбработка = Ложь;
		ДлительнаяОперация = ТорговыеПредложенияВызовСервера.ОтменитьФоновоеЗадание(ДлительнаяОперация);
		Элементы.ГруппаДлительнаяОперация.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМоиТорговыеПредложенияОрганизацияОбработкаНавигационнойСсылки(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораОрганизации", ЭтотОбъект);
	
	ПоказатьВыборИзМеню(Оповещение, Организации, Элементы.ОткрытьМоиТорговыеПредложенияОрганизация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМоиТорговыеПредложенияНажатие(Элемент)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Контрагент", ОрганизацияОтбораФормыПоиска);
	
	ТорговыеПредложенияКлиент.ОткрытьФормуПоискаПоОтборам(ПараметрыОткрытияФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СинхронизироватьТорговыеПредложения(Команда)
	
	Отказ = Ложь;
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОрганизацииТорговыхПредложений", Организации.ВыгрузитьЗначения());
	ДополнительныеПараметры.Вставить("Форма", ЭтотОбъект);
	ТорговыеПредложенияКлиент.ПодключитьОрганизацииТорговыхПредложений(ДополнительныеПараметры, Отказ);
	
	Если Не Отказ Тогда
		
		Элементы.РезультатНадпись.Видимость = Ложь;
		ПараметрыСинхронизации = ПараметрыСинхронизации();
		ТорговыеПредложенияКлиент.ВыполнитьСинхронизациюТорговыхПредложений(
			ПараметрыСинхронизации, 
			ДлительнаяОперация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСтатистикуПубликации(Истина, Истина, Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ИмяЗадания = ТорговыеПредложенияСлужебныйКлиент.ИмяЗаданияСинхронизацияТорговыхПредложений();
	Оповещение = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", 	ЭтотОбъект, ИмяЗадания);
	ОбщегоНазначенияБЭДКлиент.НастроитьРасписаниеРегламентногоЗадания(ИмяЗадания, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПояснения(Команда)
	
	ПоказыватьПояснения = Не ПоказыватьПояснения;
	ПоказатьСкрытьПояснения(ПоказыватьПояснения, Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РасписаниеПубликации

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Расписание.Заголовок = Расписание;
	
	Оповестить(
		"СинхронизацияТорговыхПредложений_ПриИзменении", АвтоматическиСинхронизировать);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьРегламентноеЗаданиеСинхронизацияТорговыхПредложений(ИмяПараметра, ЗначениеПараметра)
	
	УстановитьПривилегированныйРежим(Истина);
	
	БизнесСеть.ИзменитьРегламентноеЗадание(
		Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений.Имя,
		ИмяПараметра, 
		ЗначениеПараметра);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеФормы

&НаСервере
Процедура ОбновитьДанныеФормы(АдресРезультата = Неопределено)
	
	Элементы.СопоставлениеНоменклатурыОбновление.Видимость = Ложь;
	
	// Получение статистики
	Если АдресРезультата <> Неопределено
		И АдресРезультатаПодсчетаСтатистики <> АдресРезультата
		И ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		АдресРезультатаПодсчетаСтатистики = АдресРезультата;
		Статистика = БизнесСеть.ПолучитьУдалитьИзВременногоХранилища(АдресРезультатаПодсчетаСтатистики);
		ПараметрыВыполнения = Статистика.ПараметрыВыполнения;
	ИначеЕсли Статистика = Неопределено Тогда
		Статистика = Новый Структура;
		
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ИспользоватьСтатистикуСопоставления", Истина);
		ПараметрыВыполнения.Вставить("ИспользоватьСтатистикуПубликации"   , Истина);
		ПараметрыВыполнения.Вставить("ИспользоватьСведенияАбонента"       , Истина);
		ПараметрыВыполнения.Вставить("ИспользоватьРегистрациюОрганизации" , Истина);
		
	КонецЕсли;
	
#Область СтатистикаСопоставления
	
	Если ПараметрыВыполнения.ИспользоватьСтатистикуСопоставления Тогда
	
		КоличествоТоваров                    = 0;
		КоличествоСопоставленнойНоменклатуры = 0;
		КоличествоСопоставленныхКатегорий    = 0;
		КоличествоНесопоставленных           = 0;
		
		Если ТипЗнч(Статистика) = Тип("Структура") Тогда
			КоличествоТоваров = ?(Статистика.Свойство("КоличествоПозиций"), Статистика.КоличествоПозиций, КоличествоТоваров);
			КоличествоСопоставленнойНоменклатуры = ?(Статистика.Свойство("КоличествоСопоставлено1СНоменклатура"),
				Статистика.КоличествоСопоставлено1СНоменклатура, КоличествоСопоставленнойНоменклатуры);
			КоличествоСопоставленныхКатегорий = ?(Статистика.Свойство("КоличествоСопоставленоБизнесСеть"),
				Статистика.КоличествоСопоставленоБизнесСеть, КоличествоСопоставленныхКатегорий);
		КонецЕсли;
		
		Подсистема1СНоменклатураСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.РаботаСНоменклатурой");
		
		Элементы.СопоставлениеНоменклатуры.Видимость = Подсистема1СНоменклатураСуществует;
		
		Если Подсистема1СНоменклатураСуществует Тогда
			
			ИспользоватьСопоставление1СНоменклатура = ПолучитьФункциональнуюОпцию("ИспользоватьСервисРаботаСНоменклатурой");
			
			// Сопоставление с 1C:Номенклатура
			Элементы.СопоставлениеНоменклатурыУспех.Видимость = КоличествоСопоставленнойНоменклатуры <> 0
				И Не ПустаяСтрока(АдресРезультатаПодсчетаСтатистики);
			Элементы.СопоставлениеНоменклатурыОшибка.Видимость = КоличествоСопоставленнойНоменклатуры = 0
				И Не ПустаяСтрока(АдресРезультатаПодсчетаСтатистики);
			
			Если КоличествоСопоставленнойНоменклатуры Тогда
				ПроцентСопоставленоНоменклатуры = Окр(КоличествоСопоставленнойНоменклатуры/КоличествоТоваров*100, 1);
				Элементы.СопоставлениеНоменклатурыУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Сопоставлено %1%% (%2)'"),
					ПроцентСопоставленоНоменклатуры , КоличествоСопоставленнойНоменклатуры);
			Иначе
				ПроцентСопоставленоНоменклатуры = 0;
			КонецЕсли;
		
			Если ПроцентСопоставленоНоменклатуры = 100 Тогда 
				Элементы.СопоставлениеКатегорийЗаголовок.Подсказка = НСтр("ru = 'Сопоставление не требуется'");
			Иначе
				Элементы.СопоставлениеКатегорийЗаголовок.Подсказка = "";
				ПроцентСопоставленоКатегорий = ?(КоличествоТоваров,
					Окр(КоличествоСопоставленныхКатегорий/КоличествоТоваров * 100, 1), 0);
				Элементы.СопоставлениеКатегорийУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Сопоставлено %1%% (%2)'"),
					ПроцентСопоставленоКатегорий, КоличествоСопоставленныхКатегорий);
			КонецЕсли;
			
			Если ПроцентСопоставленоНоменклатуры = 100 Тогда 
				Элементы.СопоставлениеНоменклатуры.РасширеннаяПодсказка.Заголовок = СтрШаблон(НСтр("ru = 'Сопоставлено с 1С:Номенклатура %1%% (%2)'"),
					ПроцентСопоставленоНоменклатуры, КоличествоСопоставленнойНоменклатуры);
				Элементы.СопоставлениеНоменклатуры.РасширеннаяПодсказка.ЦветТекста = ЦветаСтиля.РезультатУспехЦвет;
			Иначе
				Элементы.СопоставлениеНоменклатуры.РасширеннаяПодсказка.Заголовок = СтрШаблон(НСтр("ru = 'Сопоставлено с 1С:Номенклатура %1%% (%2), сопоставлено по категориям %3%% (%4)'"),
					ПроцентСопоставленоНоменклатуры, КоличествоСопоставленнойНоменклатуры, ПроцентСопоставленоКатегорий, КоличествоСопоставленныхКатегорий);
				Элементы.СопоставлениеНоменклатуры.РасширеннаяПодсказка.ЦветТекста = ЦветаСтиля.ЦветАктивности;
			КонецЕсли;
			
			Элементы.СопоставлениеНоменклатуры.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
			Элементы.СопоставлениеНоменклатуры.Поведение = ПоведениеОбычнойГруппы.Всплывающая;
			Элементы.СопоставлениеНоменклатуры.ОтображатьЗаголовок = Истина;
		КонецЕсли;
		
		Элементы.СопоставлениеРазноеГруппа.Видимость = Не ПустаяСтрока(АдресРезультатаПодсчетаСтатистики);
		
		Если Не ПустаяСтрока(АдресРезультатаПодсчетаСтатистики) Тогда
			КоличествоНесопоставленных = КоличествоТоваров - (КоличествоСопоставленнойНоменклатуры
				+ КоличествоСопоставленныхКатегорий);
			Элементы.СопоставлениеРазноеЗаголовок.Заголовок = СтрШаблон(НСтр("ru = 'Несопоставлено %1%% (%2)'"),
				?(КоличествоТоваров, Окр(КоличествоНесопоставленных/КоличествоТоваров*100, 1), 0),
				КоличествоНесопоставленных);
		КонецЕсли;
		
		Элементы.СопоставлениеРазноеЗаголовок.Видимость = КоличествоНесопоставленных > 0;	
		Элементы.СопоставлениеРазноеПояснение.Видимость = КоличествоНесопоставленных > 0;	 
		Элементы.СопоставлениеКатегорийУспех.Видимость = КоличествоСопоставленныхКатегорий <> 0
			И Не ПустаяСтрока(АдресРезультатаПодсчетаСтатистики);
		Элементы.СопоставлениеКатегорийОшибка.Видимость = КоличествоНесопоставленных > 0 
			И КоличествоСопоставленныхКатегорий = 0 И Не ПустаяСтрока(АдресРезультатаПодсчетаСтатистики);
	
	КонецЕсли; 
	
#КонецОбласти
	
#Область СтатистикаПубликации
	
	Если ПараметрыВыполнения.ИспользоватьСтатистикуПубликации Тогда
	
		Успех = Ложь;
		ТребуетсяСинхронизация = Ложь;
		Ошибка = Ложь;
		
		ОшибкаСинхронизации          = ?(Статистика.Свойство("ОшибкаСинхронизации"), Статистика.ОшибкаСинхронизации, 0);
		СинхронизированоЧастично     = ?(Статистика.Свойство("СинхронизированоЧастично"), Статистика.СинхронизированоЧастично, 0);
		Синхронизировано             = ?(Статистика.Свойство("Синхронизировано"), Статистика.Синхронизировано, 0);
		КоличествоТорговыхСоглашений = ?(Статистика.Свойство("КоличествоТорговыхСоглашений"), Статистика.КоличествоТорговыхСоглашений, 0);
		КоличествоОрганизаций        = 
			?(Статистика.Свойство("ПодключенныеОрганизации"), Статистика.ПодключенныеОрганизации.Количество(), 0);
		ТорговоеПредложение          = ?(Статистика.Свойство("ТорговоеПредложение"), Статистика.ТорговоеПредложение, Неопределено);
		
		
		Если ОшибкаСинхронизации + СинхронизированоЧастично > 0 Тогда
			Ошибка = Истина;
			Элементы.ТорговыеПредложенияОшибкаНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Есть ошибки синхронизации (%1)'"), 
				ОшибкаСинхронизации + СинхронизированоЧастично);
		ИначеЕсли ТребуетсяСинхронизация > 0 Тогда
			ТребуетсяСинхронизация = Истина;
			Элементы.ТорговыеПредложенияТребуетсяСинхронизацияНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Требуется синхронизация (%1)'"),
				ТребуетсяСинхронизация);
		ИначеЕсли Синхронизировано > 0 Тогда
			Успех = Истина;
			Элементы.ТорговыеПредложенияУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Торговые предложения настроены (%1)'"), 
				Синхронизировано);
		Иначе
			Ошибка = Истина;
			Элементы.ТорговыеПредложенияОшибкаНадпись.Заголовок = НСтр("ru = 'Требуется настройка'");
		КонецЕсли; 
		
		Элементы.ТорговыеПредложенияУспех.Видимость = Успех;
		Элементы.ТорговыеПредложенияТребуетсяСинхронизация.Видимость = ТребуетсяСинхронизация;
		Элементы.ТорговыеПредложенияОшибка.Видимость = Ошибка;
		
		// Подсчет количества опубликованных и ошибочных позиций
		Элементы.ПозицииТорговыхПредложенийПояснениеГруппа.Видимость          = Истина;
		Элементы.ПозицииТорговыхПредложенийДлительнаяОперацияГруппа.Видимость = Ложь;
		Элементы.ТорговыеПредложенияОбновление.Видимость                      = Ложь;
		
		КоличествоОпубликованных = 0;
		КоличествоОшибок         = 0;
		
		Если ТипЗнч(Статистика) = Тип("Структура") И Статистика.Свойство("КоличествоОпубликованных") Тогда
			КоличествоОпубликованных = Статистика.КоличествоОпубликованных;
		КонецЕсли; 
		
		Если ТипЗнч(Статистика) = Тип("Структура") И Статистика.Свойство("КоличествоОшибок") Тогда
			КоличествоОшибок = Статистика.КоличествоОшибок;
		КонецЕсли;
		
		Если КоличествоОпубликованных = 0 И КоличествоОшибок = 0 Тогда
			
			ЗаголовокТекст = СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru = '<span style=""color: ПоясняющийТекст"">Отсутствуют предложения в сервисе</span>'"));
			
		ИначеЕсли КоличествоОшибок = 0 Тогда
			
			ЗаголовокТекст = СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru = '<span style=""color: РезультатУспехЦвет"">Опубликовано: %1</span>'"), 
					КоличествоОпубликованных);
			
		ИначеЕсли КоличествоОпубликованных = 0 И КоличествоОшибок = 1000 Тогда
			
			ЗаголовокТекст = СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru = '<span style=""color: ПоясняющийОшибкуТекст"">Ошибок: более 999</span>'"));
			
		ИначеЕсли КоличествоОпубликованных = 0 Тогда
			
			ЗаголовокТекст = СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru = '<span style=""color: ПоясняющийОшибкуТекст"">Ошибок: %1</span>'"), 
					КоличествоОшибок);
			
		ИначеЕсли КоличествоОшибок = 1000 Тогда
			
			ЗаголовокТекст = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
				"ru = '<span style=""color: РезультатУспехЦвет"">Опубликовано: %1</span><span style=""color: ПоясняющийТекст"">, </span><span style=""color: ПоясняющийОшибкуТекст"">Ошибок: более 999</span>'"), 
					КоличествоОпубликованных);
			
		Иначе
			
			ЗаголовокТекст = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
				"ru = '<span style=""color: РезультатУспехЦвет"">Опубликовано: %1</span><span style=""color: ПоясняющийТекст"">, </span><span style=""color: ПоясняющийОшибкуТекст"">Ошибок: %2</span>'"), 
					КоличествоОпубликованных, 
					КоличествоОшибок);
			
		КонецЕсли;
		
		Элементы.ПозицииТорговыхПредложенийПояснение.Заголовок = ЗаголовокТекст;
	
		ЕстьБлокирующиеОшибки = КоличествоТоваров = 0
			ИЛИ КоличествоОрганизаций = 0
			ИЛИ КоличествоТорговыхСоглашений = 0;
		
		Если Не ТорговоеПредложение = Неопределено Тогда
			ЭлементСостояния = Элементы.РезультатНадпись;
			ТорговыеПредложения.ОбновитьДекорациюСостоянияПубликации(ТорговоеПредложение, ЭлементСостояния);
			Если ПустаяСтрока(ЭлементСостояния.Заголовок) Тогда
				ЭлементСостояния.Заголовок = НСтр("ru = 'Новая публикация'");
			КонецЕсли;
			Элементы.РезультатНадпись.Гиперссылка = Ложь;
		Иначе
			Элементы.РезультатНадпись.Заголовок = "";
		КонецЕсли;
	КонецЕсли;
	
#КонецОбласти
	
#Область РегистрацияОрганизаций
	
	Если ПараметрыВыполнения.ИспользоватьРегистрациюОрганизации Тогда
		
		Элементы.ОрганизацияОбновление.Видимость = Ложь;
		
		КоличествоОрганизаций        = 
			?(Статистика.Свойство("ПодключенныеОрганизации"), Статистика.ПодключенныеОрганизации.Количество(), 0);
		
		ОпубликованныеОрганизации = ТорговыеПредложенияСлужебный.ПолучитьОрганизацииОпубликованныхТорговыхПредложений(Истина);
		Организации.ЗагрузитьЗначения(ОпубликованныеОрганизации);
		
		ИспользуетсяНесколькоОрганизаций = ?(Статистика.Свойство("ИспользуетсяНесколькоОрганизаций"), 
			Статистика.ИспользуетсяНесколькоОрганизаций, Ложь);
		
		Элементы.ОрганизацияУспех.Видимость = КоличествоОрганизаций <> 0;
		Элементы.ОрганизацияОшибка.Видимость  = КоличествоОрганизаций = 0;
		
		Если КоличествоОрганизаций <> 0 Тогда
			Если ИспользуетсяНесколькоОрганизаций Тогда
				Элементы.ОрганизацияУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Организации зарегистрированы (%1)'"),
				КоличествоОрганизаций);
			Иначе
				Элементы.ОрганизацияУспехНадпись.Заголовок = НСтр("ru = 'Организация зарегистрирована'");
			КонецЕсли;
		ИначеЕсли ИспользуетсяНесколькоОрганизаций Тогда
			Элементы.ОрганизацияОшибкаНадпись.Заголовок = НСтр("ru = 'Организации не зарегистрированы'");
		Иначе
			Элементы.ОрганизацияОшибкаНадпись.Заголовок = НСтр("ru = 'Организация не зарегистрирована'");
		КонецЕсли;
		
		КоличествоОпубликованныхОрганизаций = ОпубликованныеОрганизации.Количество();
		Если КоличествоОпубликованныхОрганизаций > 0 Тогда
			ОрганизацияОтбораФормыПоиска = Организации[0].Значение;
			СформироватьПредставлениеОрганизации();
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ОткрытьМоиТорговыеПредложенияОрганизация", "Видимость", КоличествоОпубликованныхОрганизаций > 1);
		
		ДоступностьСсылки = Не ОрганизацияОтбораФормыПоиска.Пустая();
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ОткрытьМоиТорговыеПредложения", "Доступность", ДоступностьСсылки);
		
	КонецЕсли;
	
#КонецОбласти
	
#Область АвтоматическаяПубликация
	
	УсловноеГруппыОформлениеСинхронизации();
	
#КонецОбласти 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатистикуПубликации(ИспользоватьСтатистикуСопоставления, ИспользоватьСтатистикуПубликации,
		ИспользоватьСведенияАбонента, ИспользоватьРегистрациюОрганизации)
	
	Если ИспользоватьСтатистикуСопоставления Тогда
		
		Элементы.СопоставлениеНоменклатурыУспех.Видимость  = Ложь;
		Элементы.СопоставлениеНоменклатурыОшибка.Видимость = Ложь;
		
		Элементы.СопоставлениеКатегорийУспех.Видимость  = Ложь;
		Элементы.СопоставлениеКатегорийОшибка.Видимость = Ложь;
		
		Элементы.СопоставлениеНоменклатурыОбновление.Видимость = Истина;
		
		Элементы.СопоставлениеНоменклатуры.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		
	КонецЕсли;
	
	Если ИспользоватьСтатистикуПубликации Тогда
		
		Элементы.ПозицииТорговыхПредложенийПояснениеГруппа.Видимость          = Ложь;
		
		Элементы.ТорговыеПредложенияУспех.Видимость                           = Ложь;
		Элементы.ТорговыеПредложенияТребуетсяСинхронизация.Видимость          = Ложь;
		Элементы.ТорговыеПредложенияОшибка.Видимость                          = Ложь;
		
		Элементы.ТорговыеПредложенияОбновление.Видимость                      = Истина;
		
		Элементы.ПозицииТорговыхПредложенийДлительнаяОперацияГруппа.Видимость = Истина;
		
	КонецЕсли;
	
	Если ИспользоватьРегистрациюОрганизации Тогда
		
		Элементы.ОрганизацияУспех.Видимость      = Ложь;
		Элементы.ОрганизацияОшибка.Видимость     = Ложь;
		
		Элементы.ОрганизацияОбновление.Видимость = Истина;
		
	КонецЕсли;
	
	ПараметрыПроцедуры = ТорговыеПредложенияКлиент.ПараметрыОбновленияСтатистикиСинхронизации(ЭтотОбъект);
	ПараметрыПроцедуры.ИспользоватьСтатистикуСопоставления = ИспользоватьСтатистикуСопоставления;
	ПараметрыПроцедуры.ИспользоватьСтатистикуПубликации    = ИспользоватьСтатистикуПубликации;
	ПараметрыПроцедуры.ИспользоватьСведенияАбонента        = ИспользоватьСведенияАбонента;
	ПараметрыПроцедуры.ИспользоватьРегистрациюОрганизации  = ИспользоватьРегистрациюОрганизации;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьСтатистикуПубликацииЗавершение", ЭтотОбъект);
	ТорговыеПредложенияКлиент.ОбновитьСтатистикуСинхронизации(ОповещениеОЗавершении, ПараметрыПроцедуры, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатистикуПубликацииПоОповещению(Результат, ДополнительныеПараметры) Экспорт
	
	ИспользоватьСтатистикуСопоставления = Ложь;
	ИспользоватьСтатистикуПубликации    = Ложь;
	
	Если Не ДополнительныеПараметры = Неопределено Тогда
		
		Если ДополнительныеПараметры.Свойство("ИспользоватьСтатистикуСопоставления") Тогда
			ИспользоватьСтатистикуСопоставления = ДополнительныеПараметры.ИспользоватьСтатистикуСопоставления;
		КонецЕсли;
		
		Если ДополнительныеПараметры.Свойство("ИспользоватьСтатистикуПубликации") Тогда
			ИспользоватьСтатистикуПубликации = ДополнительныеПараметры.ИспользоватьСтатистикуПубликации;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьСтатистикуПубликации(ИспользоватьСтатистикуСопоставления, ИспользоватьСтатистикуПубликации, Ложь, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатистикуПубликацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Результат.Статус <> "Выполнено" Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеФормы(Результат.АдресРезультата);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьСкрытьПояснения(ПоказыватьПояснения, Элементы)
	
	Элементы.ПоказатьСкрытьПояснения.Заголовок = ?(ПоказыватьПояснения, НСтр("ru = 'Скрыть пояснения'"),
		НСтр("ru = 'Показать пояснения'"));
	Элементы.ПояснениеОрганизация.Видимость         = ПоказыватьПояснения;
	Элементы.ПояснениеСинхронизация.Видимость       = ПоказыватьПояснения;
	Элементы.ПояснениеКатегорийСопоставление.Видимость       = ПоказыватьПояснения;
	Элементы.ПояснениеТорговыеПредложения.Видимость = ПоказыватьПояснения;
	Элементы.ПояснениеНоменклатурыСопоставление.Видимость = ПоказыватьПояснения;
	
КонецПроцедуры

#КонецОбласти

#Область СопоставлениеНоменклатуры

&НаКлиенте
Процедура СопоставитьНоменклатуруСРубрикаторомПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат = Неопределено И Результат.ИспользоватьСервисРаботаСНоменклатурой Тогда
		ОткрытьФормуСопоставленияНоменклатурыСРубрикатором();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьНоменклатуруСервисаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат = Неопределено И Результат.ИспользоватьСервисРаботаСНоменклатурой Тогда
		
		ОткрытьФормуСопоставленияНоменклатурыСервиса();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСопоставленияНоменклатурыСервиса()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИспользоватьСтатистикуСопоставления", Истина);
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьСтатистикуПубликацииПоОповещению", ЭтотОбъект, ДополнительныеПараметры);
	МодульРаботаСНоменклатуройКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСНоменклатуройКлиент");
	ПараметрыОткрытия = МодульРаботаСНоменклатуройКлиент.ПараметрыФормыСопоставленийНоменклатуры("ТорговыеПредложения");
	МодульРаботаСНоменклатуройКлиент.ОткрытьФормуСопоставленияНоменклатуры(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСопоставленияНоменклатурыСРубрикатором()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИспользоватьСтатистикуСопоставления", Истина);
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьСтатистикуПубликацииПоОповещению", ЭтотОбъект, ДополнительныеПараметры);
	МодульРаботаСНоменклатуройКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСНоменклатуройКлиент");
	ПараметрыОткрытия = МодульРаботаСНоменклатуройКлиент.ПараметрыФормыСопоставленияНоменклатурыСРубрикатором();
	
	ПараметрыОткрытия.Номенклатура = ТорговыеПредложенияВызовСервера.ПубликуемаяНоменклатураТорговыхПредложений();
	
	МодульРаботаСНоменклатуройКлиент.ОткрытьФормуСопоставленияНоменклатурыСРубрикатором(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СинхронизацияТорговыхПредложений

&НаКлиенте
Функция ПараметрыСинхронизации()
	
	ПараметрыСинхронизации = ТорговыеПредложенияКлиент.ПараметрыСинхронизацииТорговыхПредложений(ЭтотОбъект);
	ПараметрыСинхронизации.ВыводитьПрогрессВыполнения     = Истина;
	ПараметрыСинхронизации.ГруппаДлительнойОперации       = Элементы.ГруппаДлительнаяОперация;
	ПараметрыСинхронизации.НадписьПрогресса               = Элементы.ДекорацияДлительнаяОперацияНадпись;
	ПараметрыСинхронизации.ОповещениеОЗавершении          = 
		Новый ОписаниеОповещения("СинхронизироватьТорговыеПредложенияЗавершение", ЭтотОбъект);
	
	Возврат ПараметрыСинхронизации;
	
КонецФункции

&НаКлиенте
Процедура СинхронизироватьТорговыеПредложенияЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	Элементы.РезультатНадпись.Видимость         = Истина;
	ДлительнаяОперация                          = Неопределено;
КонецПроцедуры

&НаСервере
Процедура УсловноеГруппыОформлениеСинхронизации(РегламентоеЗаданиеВключено = Неопределено)
	
	ТорговыеПредложенияСлужебный.УсловноеОформлениеГруппыСинхронизации(ЭтотОбъект, РегламентоеЗаданиеВключено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияОрганизации(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Организации = ДополнительныеПараметры.ОрганизацииТорговыхПредложений;
	ПодключаемаяОрганизация = ДополнительныеПараметры.ПодключаемаяОрганизация;
	
	Организации.Удалить(Организации.Найти(ПодключаемаяОрганизация));
	
	Отказ = Ложь;
	Если Организации.Количество() > 0 Тогда
		ТорговыеПредложенияКлиент.ПодключитьОрганизацииТорговыхПредложений(ДополнительныеПараметры, Отказ);
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если РезультатЗакрытия <> Неопределено 
		Или Не Отказ Тогда
		
		Элементы.РезультатНадпись.Видимость = Ложь;
		ПараметрыСинхронизации = ПараметрыСинхронизации();
		ТорговыеПредложенияКлиент.ВыполнитьСинхронизациюТорговыхПредложений(
			ПараметрыСинхронизации, 
			ДлительнаяОперация);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПослеВыбораОрганизации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияОтбораФормыПоиска = Результат.Значение;
	
	СформироватьПредставлениеОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОрганизации()
	
	ШаблонПредставления = НСтр(
		"ru = 'от  <a href = ""ВыборОрганизации"">%1</a>'", 
		ОбщегоНазначения.КодОсновногоЯзыка());
	
	Элементы.ОткрытьМоиТорговыеПредложенияОрганизация.Заголовок = 
		СтроковыеФункции.ФорматированнаяСтрока(
			ШаблонПредставления, 
			ОрганизацияОтбораФормыПоиска);
	
КонецПроцедуры

#КонецОбласти
