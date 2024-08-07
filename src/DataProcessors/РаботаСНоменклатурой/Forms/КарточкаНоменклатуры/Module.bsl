
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	////////////////////////////////////////////////////////////////////////////////
	
	ИдентификаторыНоменклатуры = Новый Массив;
	
	Параметры.Свойство("ИдентификаторыНоменклатуры", ИдентификаторыНоменклатуры);
	Параметры.Свойство("СтрокаШтрихкода",            СтрокаШтрихкода);
	Параметры.Свойство("РежимВыбора",                РежимВыбора);
	Параметры.Свойство("ЭтоРежимПросмотра",          ЭтоРежимПросмотра);
		
	РежимПоискаПоШтрихкоду = ЗначениеЗаполнено(СтрокаШтрихкода);
	
	Если ИдентификаторыНоменклатуры = Неопределено
		ИЛИ ИдентификаторыНоменклатуры.Количество() = 0 
		ИЛИ Не ЗначениеЗаполнено(ИдентификаторыНоменклатуры[0].ИдентификаторНоменклатуры) Тогда
		
		ВызватьИсключение НСтр("ru = 'Не задан идентификатор номенклатуры'");
	КонецЕсли;
	
	Для каждого ЭлементКоллекции Из ИдентификаторыНоменклатуры Цикл
		НоваяСтрока = КэшПредставленийНоменклатуры.Добавить();
		
		НоваяСтрока.ИдентификаторНоменклатуры   = ЭлементКоллекции.ИдентификаторНоменклатуры;
		НоваяСтрока.ИдентификаторХарактеристики = ЭлементКоллекции.ИдентификаторХарактеристики;
	КонецЦикла;
	
	МножественныйРежим = КэшПредставленийНоменклатуры.Количество() > 1;
	
	Если РежимПоискаПоШтрихкоду Тогда
		Элементы.ПодсказкаКФорме.Заголовок 
			= ЗаголовокФормыПриПоискеПоШтрихкоду(МножественныйРежим, СтрокаШтрихкода);
	КонецЕсли;
	
	ТипНоменклатура = Метаданные.ОпределяемыеТипы.НоменклатураРаботаСНоменклатурой.Тип.Типы()[0];
	ИмяФормыСпискаНоменклатура = Метаданные.НайтиПоТипу(ТипНоменклатура).ПолноеИмя()+".Форма.ФормаСписка";
	
	////////////////////////////////////////////////////////////////////////////////
	
	ПравоИзмененияДанных = РаботаСНоменклатурой.ПравоИзмененияДанных() И Не ЭтоРежимПросмотра;
	
	УстановитьВидимостьДоступность();
	
	Элементы.ГруппаОсновныеКнопкиФормы.Доступность       = Ложь;
	Элементы.ГруппаКнопкиНавигации.Доступность           = Ложь;
	Элементы.ГруппаДекорацииДлительнойОперации.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьПредставлениеНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		Возврат
	КонецЕсли;
	
	Закрыть(Новый Структура("СозданнаяНоменклатура", СозданнаяНоменклатура.ВыгрузитьЗначения()));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().ЗагрузкаНоменклатуры 
		ИЛИ ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().СопоставлениеНоменклатуры Тогда	
		
		Если ЗначениеЗаполнено(Параметр) Тогда
			СозданныйОбъект = Параметр.СозданныеОбъекты[0];
			
			Если СозданныйОбъект.ИдентификаторНоменклатуры = КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры].ИдентификаторНоменклатуры Тогда
				ЗаполнитьСсылкуНоменклатуры(Параметр.СозданныеОбъекты[0], ТекущийИндексНоменклатуры);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КарточкаНоменклатурыОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Если Элемент.ТекущаяОбласть.Имя = "Шапка_НоменклатураПрограммы" Тогда	
		
		// Отработка создания номенклатуры и открытия ссылки.
		
		Если ТипЗнч(Расшифровка) = Тип("Массив")
			И ЗначениеЗаполнено(Расшифровка) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПараметрыОткрытияФормыСписка = Новый Структура();
			ПараметрыОткрытияФормыСписка.Вставить("Отбор", Новый Структура("Ссылка", Расшифровка));
			ОткрытьФорму(ИмяФормыСпискаНоменклатура, ПараметрыОткрытияФормыСписка, Элемент, УникальныйИдентификатор);
			
		ИначеЕсли Не ЗначениеЗаполнено(Расшифровка) Тогда 
			
			СтандартнаяОбработка = Ложь;
			
			Если ПравоИзмененияДанных И Не РежимВыбора Тогда
				СозданиеНоменклатурыНачало();
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Элемент.ТекущаяОбласть.Имя = "Шапка_Категория" Тогда
		
		// Отработка перехода к категории.
		
		СтандартнаяОбработка = Ложь;
		
		ОткрытьФормуСпискаНоменклатуры(Расшифровка);
		
	ИначеЕсли Элемент.ТекущаяОбласть.Имя = "Свойства_ИмяСвойства"
		И Расшифровка = "ПоказатьХарактеристики" Тогда
		
		// Открытие формы просмотра характеристик.
		
		СтандартнаяОбработка = Ложь;
		
		ПолучитьДанныеПоНоменклатуре();
				
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеПоНоменклатуре()
	
	НастроитьФормуПриДлительнойОперации(Истина, "ПодборХарактеристик");
	
	ПараметрыЗавершения = Новый Структура;
	
	ПолучитьНоменклатуруЗавершение = Новый ОписаниеОповещения("ПолучитьДанныеПоНоменклатуреЗавершение", ЭтотОбъект, ПараметрыЗавершения);
			
	ИдентификаторНоменклатуры = КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры].ИдентификаторНоменклатуры;
	
	ПараметрыМетода = РаботаСНоменклатуройКлиент.ПараметрыЗапросаДанныхНоменклатуры();
	
	ПараметрыМетода.Идентификаторы                       = ИдентификаторНоменклатуры;
	ПараметрыМетода.АктуализироватьВспомогательныеДанные = Истина;
		
	РаботаСНоменклатуройКлиент.ПолучитьДанныеНоменклатурыСервиса(
		ПолучитьНоменклатуруЗавершение, 
		ПараметрыМетода, 
		ЭтотОбъект.ВладелецФормы, 
		Неопределено, 
		Элементы.КартинкаДлительнойОперации);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПолучитьДанныеПоНоменклатуреЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	НастроитьФормуПриДлительнойОперации(Ложь, "ПодборХарактеристик");
	
	РаботаСНоменклатуройКлиент.ОткрытьФормуПодбораХарактеристик(
		КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры].ИдентификаторНоменклатуры, Результат.АдресРезультата, Неопределено, Истина, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура БаннерНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ПустаяСтрока(СсылкаПереходаПоБаннеру) Тогда 
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СсылкаПереходаПоБаннеру); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложениеПокупкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	КупитьКарточкиНоменклатуры();	
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуСпискаНоменклатуры(ИдентификаторКатегории)
	
	ПараметрыОткрытия = РаботаСНоменклатуройКлиент.ПараметрыФормыЗагрузкиНоменклатуры();
	
	ПараметрыОткрытия.ИдентификаторКатегории = ИдентификаторКатегории;
	
	// при открытии формы загрузки номенклатуры не формировать сразу данные сервиса.
	ПараметрыОткрытия.Вставить("НеЗагружатьДанныеСервисаПриОткрытии", Истина);
	
	РаботаСНоменклатуройКлиент.ОткрытьФормуЗагрузкиНоменклатуры(ПараметрыОткрытия);
	
	// Оповещение формы загрузки номенклатуры, для отработки перехода к категории.
	
	Оповестить("РаботаСНоменклатурой_ПерейтиККатегории", ПараметрыОткрытия, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ЛистатьНазад(Команда)
	Если ТекущийИндексНоменклатуры = 0 Тогда
		Возврат;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	
	ТекущийИндексНоменклатуры = ТекущийИндексНоменклатуры - 1;
	СформироватьПредставлениеНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ЛистатьВперед(Команда)
	
	Если ТекущийИндексНоменклатуры = КэшПредставленийНоменклатуры.Количество() - 1 Тогда
		Возврат;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	
	ТекущийИндексНоменклатуры = ТекущийИндексНоменклатуры + 1;
	СформироватьПредставлениеНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуру(Команда)
	
	Если ПравоИзмененияДанных Тогда
		СозданиеНоменклатурыНачало();
	Иначе
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокФормыПриПоискеПоШтрихкоду(МножественныйРежим, СтрокаШтрихКода)
	
	Если МножественныйРежим Тогда
		Возврат СтрШаблон(
			НСтр("ru = 'По штрихкоду %1 найдено несколько карточек в сервисе 1С:Номенклатура. Выберите нужную и нажмите кнопку Создать номенклатуру.'"), 
				СтрокаШтрихКода);
	Иначе
		Возврат СтрШаблон(
			НСтр("ru = 'По штрихкоду %1 найдена карточка в сервисе 1С:Номенклатура.'"), 
				СтрокаШтрихКода);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура КарточкаНоменклатурыВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Область.Имя = "Шапка_ПредставлениеПревышенияЛимита" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СформироватьПредставлениеНоменклатуры();
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Данные обновлены.'"), , , БиблиотекаКартинок.Информация32);
		
	ИначеЕсли Область.Имя = "СледующееИзображение" Тогда	

		Если Не ТекущаяКарточкаКуплена() Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
				
		Элементы.КарточкаНоменклатуры.ТекущаяОбласть = КарточкаНоменклатуры.Области.ЗаголовокИзображения;
		
		ПереключитьИзображение(Истина);
		
	ИначеЕсли Область.Имя = "ПредыдущееИзображение" Тогда	

		Если Не ТекущаяКарточкаКуплена() Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
		
		Элементы.КарточкаНоменклатуры.ТекущаяОбласть = КарточкаНоменклатуры.Области.ЗаголовокИзображения;
		
		ПереключитьИзображение(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьИзображение(СледующееИзображение)
		
	СтрокаДанных = КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры];
		
	Если СледующееИзображение И СтрокаДанных.ИндексТекущегоИзображения + 1 = СтрокаДанных.Изображения.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СледующееИзображение И СтрокаДанных.ИндексТекущегоИзображения = 0 Тогда
		Возврат;
	КонецЕсли;
		
	Если СледующееИзображение Тогда
		СтрокаДанных.ИндексТекущегоИзображения = СтрокаДанных.ИндексТекущегоИзображения + 1;
	Иначе
		СтрокаДанных.ИндексТекущегоИзображения = СтрокаДанных.ИндексТекущегоИзображения - 1;	
	КонецЕсли;
	
	ДанныеКартинки = ПолучитьИзВременногоХранилища(СтрокаДанных.Изображения[СтрокаДанных.ИндексТекущегоИзображения]);
	
	КарточкаНоменклатуры.Области.ЗаголовокИзображения.Текст 
		= СтрШаблон("Изображение (%1/%2)", 
			СтрокаДанных.ИндексТекущегоИзображения + 1, СтрокаДанных.Изображения.Количество());
						
	КарточкаНоменклатуры.Рисунки.Рисунок.Картинка = Новый Картинка(ДанныеКартинки);
	
	СтрокаДанных.ПутьКТабличномуДокументу = ПоместитьВоВременноеХранилище(КарточкаНоменклатуры, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеНоменклатурыНачало()
	
	НастроитьФормуПриДлительнойОперации(Истина, "ЗагрузкаНоменклатуры");
	
	СтрокаДанных = Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики", 
		КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры].ИдентификаторНоменклатуры, "");
	
	Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаДанных);
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ТекущийИндексНоменклатуры", ТекущийИндексНоменклатуры);
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания",      Неопределено);
	
	СоздатьНоменклатуруПродолжение = Новый ОписаниеОповещения("СоздатьНоменклатуруПродолжение",
		ЭтотОбъект, ПараметрыЗавершения);
	
	РаботаСНоменклатуройКлиент.ЗагрузитьНоменклатуруИХарактеристики(
		СоздатьНоменклатуруПродолжение, 
		Идентификаторы, 
		ЭтотОбъект,
		Неопределено,
		Неопределено,
		Элементы.ГруппаДекорацииДлительнойОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуруПродолжение(РезультатСоздания, ДополнительныеПараметры) Экспорт 
	
	НастроитьФормуПриДлительнойОперации(Ложь, "ЗагрузкаНоменклатуры");
	
	Если РезультатСоздания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийИндексНоменклатуры = ДополнительныеПараметры.ТекущийИндексНоменклатуры;
	
	ПереключитьНоменклатуру(ТекущийИндексНоменклатуры);
		
	ЗаполнитьСсылкуНоменклатуры(РезультатСоздания.НовыеЭлементы[0], ТекущийИндексНоменклатуры);
	
	// Оповещение о создании.
	
	СозданныеЭлементы = Новый Структура;
	
	СозданныеЭлементы.Вставить("СозданныеОбъекты", РезультатСоздания.НовыеЭлементы);
	СозданныеЭлементы.Вставить("ИдентификаторВладельца", 
		?(ВладелецФормы = Неопределено, Неопределено, ВладелецФормы.УникальныйИдентификатор));
		
	Оповестить(РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().ЗагрузкаНоменклатуры, 
		СозданныеЭлементы, "РаботаСНоменклатурой_КарточкаНоменклатуры");
		
	Оповестить(РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().СопоставлениеНоменклатуры);	
	
	СозданнаяНоменклатура.Добавить(РезультатСоздания.НовыеЭлементы[0].Номенклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСсылкуНоменклатуры(СозданныеОбъекты, ТекущийИндексНоменклатуры)
	
	Шапка_НоменклатураПрограммы = КарточкаНоменклатуры.Области.Найти("Шапка_НоменклатураПрограммы");
	
	Если Шапка_НоменклатураПрограммы <> Неопределено Тогда 
		
		Шапка_НоменклатураПрограммы.Расшифровка = СозданныеОбъекты.Номенклатура;
		Шапка_НоменклатураПрограммы.Текст = СозданныеОбъекты.Номенклатура;
		
		ЗаписьКэша = КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры];
		ПоместитьВоВременноеХранилище(КарточкаНоменклатуры, ЗаписьКэша.ПутьКТабличномуДокументу);
		
	КонецЕсли;
	
	УстановитьДоступностьКомандыСоздатьНоменклатуру();
	
КонецПроцедуры

&НаКлиенте
Процедура НажатиеОповещенияПользователя(ДополнительныеПараметры) Экспорт 
	
	ПараметрыОткрытияФормыСписка = Новый Структура();
	ПараметрыОткрытияФормыСписка.Вставить("Отбор", Новый Структура("Ссылка", ДополнительныеПараметры));
	ОткрытьФорму(ИмяФормыСпискаНоменклатура, ПараметрыОткрытияФормыСписка, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьНоменклатуру(Индекс)
	
	ЗаписьКэша = КэшПредставленийНоменклатуры[Индекс];
	
	Баннер                  = ЗаписьКэша.ПутьКДаннымБаннера;
	СсылкаПереходаПоБаннеру = ЗаписьКэша.СсылкаПереходаПоБаннеру;
	КарточкаНоменклатуры    = ПолучитьПредставлениеНоменклатуры(ЗаписьКэша.ПутьКТабличномуДокументу);
	ОбновитьСчетчикКарточек();
	
	Элементы.ГруппаБаннер.Видимость = Не ПустаяСтрока(Баннер);
	УстановитьДоступностьКомандыСоздатьНоменклатуру();
	УправлениеДоступностьюКнопокНавигации();
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандыСоздатьНоменклатуру()

	Если ПравоИзмененияДанных Тогда
		
		Элементы.СоздатьНоменклатуру.Доступность = Ложь;
		Шапка_НоменклатураПрограммы = КарточкаНоменклатуры.Области.Найти("Шапка_НоменклатураПрограммы");
		Если Не Шапка_НоменклатураПрограммы = Неопределено Тогда 
			Элементы.СоздатьНоменклатуру.Доступность 
			= Не ЗначениеЗаполнено(КарточкаНоменклатуры.Области.Шапка_НоменклатураПрограммы.Расшифровка)
		КонецЕсли;
		
	Иначе
		Элементы.СоздатьНоменклатуру.Заголовок = НСтр("ru = 'Закрыть'");
		Элементы.СоздатьНоменклатуру.Ширина    = 10;
	КонецЕсли;
		
КонецПроцедуры
	
&НаКлиенте
Процедура УправлениеДоступностьюКнопокНавигации()
	
	Элементы.ЛистатьВперед.Доступность = ТекущийИндексНоменклатуры <> КэшПредставленийНоменклатуры.Количество() - 1;
	Элементы.ЛистатьНазад.Доступность = ТекущийИндексНоменклатуры <> 0;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если ПравоИзмененияДанных Тогда
		
		Элементы.Выбрать.Видимость                     = РежимВыбора;
		Элементы.Выбрать.КнопкаПоУмолчанию             = РежимВыбора;
		
		Элементы.СоздатьНоменклатуру.Видимость         = НЕ РежимВыбора;
		Элементы.СоздатьНоменклатуру.КнопкаПоУмолчанию = НЕ РежимВыбора;

	Иначе
		Элементы.СоздатьНоменклатуру.Заголовок = НСтр("ru = 'Закрыть'");
		Элементы.СоздатьНоменклатуру.Ширина    = 10;
		Элементы.Выбрать.Видимость             = Ложь;
	КонецЕсли;
	
	Элементы.ПодсказкаКФорме.Видимость        = РежимПоискаПоШтрихкоду;
	Элементы.ГруппаКнопкиНавигации.Видимость  = МножественныйРежим;
	
	Элементы.ГруппаБаннер.Видимость = Не ПустаяСтрока(Баннер);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеНоменклатуры()
	
	СтрокаКэша = КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры];
	
	ТекущийИдентификатор = Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики",
		СтрокаКэша.ИдентификаторНоменклатуры, СтрокаКэша.ИдентификаторХарактеристики);
	
	Если ЗначениеЗаполнено(СтрокаКэша.ПутьКТабличномуДокументу) И НЕ СтрокаКэша.ПревышенЛимит Тогда
		ПереключитьНоменклатуру(ТекущийИндексНоменклатуры);
		Возврат;	
	КонецЕсли;
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания", Неопределено);
	
	СформироватьПредставлениеНоменклатурыЗавершение = Новый ОписаниеОповещения("СформироватьПредставлениеНоменклатурыЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
		
	РаботаСНоменклатуройКлиент.СформироватьПредставленияКарточекНоменклатуры(СформироватьПредставлениеНоменклатурыЗавершение,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущийИдентификатор), 
		ЭтотОбъект, 
		Неопределено, 
		Элементы.КарточкаНоменклатуры.ОтображениеСостояния,
		Не ПравоИзмененияДанных Или РежимВыбора);
		
	Если Элементы.КарточкаНоменклатуры.ОтображениеСостояния.Картинка.Вид <> ВидКартинки.Пустая Тогда 
		Элементы.КарточкаНоменклатуры.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
		Элементы.КарточкаНоменклатуры.ОтображениеСостояния.Текст = НСтр("ru = 'Карточка 1С:Номенклатуры загружается...'");
		Элементы.КарточкаНоменклатуры.ОтображениеСостояния.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	НастроитьФормуПриДлительнойОперации(Ложь, "ЗагрузкаНоменклатуры");
	
	РаботаСНоменклатуройКлиент.ВывестиСообщения(Результат);
	
	КарточкаКуплена = Истина;
	
	ЗагрузитьКэшПредставленийНоменклатуры(Результат.АдресРезультата, ДополнительныеПараметры, КарточкаКуплена);
		
	Элементы.КарточкаНоменклатуры.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	Элементы.КарточкаНоменклатуры.ОтображениеСостояния.Видимость = Ложь;
	Элементы.КарточкаНоменклатуры.ОтображениеСостояния.Текст = "";
	Элементы.КарточкаНоменклатуры.ОтображениеСостояния.Картинка = Неопределено;
	
	Если КэшПредставленийНоменклатуры.Количество() >= (ТекущийИндексНоменклатуры + 1) Тогда
		ПереключитьНоменклатуру(ТекущийИндексНоменклатуры);
	КонецЕсли;
	
	Элементы.ГруппаОсновныеКнопкиФормы.Доступность = КэшПредставленийНоменклатуры.Количество();
	Элементы.ГруппаКнопкиНавигации.Доступность = КэшПредставленийНоменклатуры.Количество();
		
	ОбновитьСчетчикКарточек();
	УправлениеДоступностьюКнопокНавигации();
	ЗакэшироватьИзображенияБаннеров();
	ОбновитьТекущийБаланс();
	
	Оповестить("РаботаСНоменклатурой_ОбновитьТекущийБаланс", Новый Структура("ТекущийБаланс", ТекущийБаланс));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКэшПредставленийНоменклатуры(АдресРезультата, ДополнительныеПараметры, КарточкаКуплена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда 
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если Результат = Неопределено Тогда 
			Возврат;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	КарточкаКуплена = Результат.КарточкаКуплена;
	
	СтрокиКэша = КэшПредставленийНоменклатуры.НайтиСтроки(
		Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики", 
			Результат.ИдентификаторНоменклатуры, Результат.ИдентификаторХарактеристики));
	
	ТекущийБаланс = Результат.ТекущийБаланс;
		
	Если СтрокиКэша.Количество() <> 0 Тогда
		ЗаполнитьЗначенияСвойств(СтрокиКэша[0], Результат);	
		СохранитьИзображения(Результат.ДанныеИзображений, СтрокиКэша[0].ПолучитьИдентификатор());
	КонецЕсли;
	
	Если НЕ КарточкаКуплена И Не Результат.ЕстьОшибкиСервиса Тогда
		ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ОшибкаПокупкиНоменклатуры", 
			Новый Структура("Ошибка", Результат.ОписаниеОшибки));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзображения(Изображения, ИдентификаторСтроки)
	
	СтрокаКэша = КэшПредставленийНоменклатуры.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Для каждого ЭлементКоллекции Из Изображения Цикл
		
		АдресКартинки = ПоместитьВоВременноеХранилище(ЭлементКоллекции, Новый УникальныйИдентификатор);
		
		СтрокаКэша.Изображения.Добавить(АдресКартинки);
		
	КонецЦикла;
			
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПредставлениеНоменклатуры(ПутьКТабличномуДокументу)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Если НЕ ЭтоАдресВременногоХранилища(ПутьКТабличномуДокументу) Тогда
		Возврат ТабличныйДокумент;
	КонецЕсли;
	
	ЗначениеХранилища = ПолучитьИзВременногоХранилища(ПутьКТабличномуДокументу);
	
	Если ТипЗнч(ЗначениеХранилища) <> Тип("ТабличныйДокумент") Тогда
		Возврат ТабличныйДокумент;
	КонецЕсли;
	
	Возврат ЗначениеХранилища;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСчетчикКарточек()
	
	НадписьТекущаяПозиция = СтрШаблон("%1/%2", ТекущийИндексНоменклатуры + 1,  КэшПредставленийНоменклатуры.Количество());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакэшироватьИзображенияБаннеров()
	
	ИдентификаторыИсточников = Новый Массив;
	
	Для Каждого ЗаписьКэша Из КэшПредставленийНоменклатуры Цикл 
		Если Не ПустаяСтрока(ЗаписьКэша.ИдентификаторРекламнойЗаписи) 
			И ИдентификаторыИсточников.Найти(ЗаписьКэша.ИдентификаторРекламнойЗаписи) = Неопределено Тогда 
			ИдентификаторыИсточников.Добавить(ЗаписьКэша.ИдентификаторРекламнойЗаписи);
		КонецЕсли;
	КонецЦикла;

	Если ИдентификаторыИсточников.Количество() Тогда 
		ЗакэшироватьИзображенияБаннеровЗавершение = Новый ОписаниеОповещения("ЗакэшироватьИзображенияБаннеровЗавершение",
			ЭтотОбъект);
			
		РаботаСНоменклатуройКлиент.ЗакэшироватьИзображенияБаннеров(ЗакэшироватьИзображенияБаннеровЗавершение, ИдентификаторыИсточников, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакэшироватьИзображенияБаннеровЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда 
		КэшБаннеров = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если КэшБаннеров = Неопределено Тогда 
			Возврат;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Кэш Из КэшБаннеров Цикл 
		МассивДляКэширования = КэшПредставленийНоменклатуры.НайтиСтроки(Новый Структура("ИдентификаторРекламнойЗаписи", Кэш.Ключ));
		Для Каждого ЗаписьКэша Из МассивДляКэширования Цикл 
			ЗаписьКэша.ПутьКДаннымБаннера      = Кэш.Значение.ПутьКДаннымБаннера;
			ЗаписьКэша.СсылкаПереходаПоБаннеру = Кэш.Значение.СсылкаПереходаПоБаннеру;
		КонецЦикла;
	КонецЦикла;
	
	Если КэшПредставленийНоменклатуры.Количество() > 0 Тогда 
		ЗаписьКэша = КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры];
		Баннер = ЗаписьКэша.ПутьКДаннымБаннера;
		СсылкаПереходаПоБаннеру = ЗаписьКэша.СсылкаПереходаПоБаннеру;
	КонецЕсли;

	Элементы.ГруппаБаннер.Видимость = Не ПустаяСтрока(Баннер);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийБаланс()
	
	Элементы.ДекорацияДоступноДляПокупки.Заголовок = 
		Новый ФорматированнаяСтрока(НСтр("ru = 'Доступно для покупки'") + 
			": " + Строка(Формат(ТекущийБаланс, "ЧН=0")),,,, "https://catalog-api.1c.ru/lk");
		
КонецПроцедуры

&НаКлиенте
Функция КупитьКарточкиНоменклатуры()
	
	ИдентификаторНоменклатуры = КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры].ИдентификаторНоменклатуры;
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания", Неопределено);
	ПараметрыЗавершения.Вставить("ИдентификаторНоменклатуры", ИдентификаторНоменклатуры);
	
	КупитьКарточкиНоменклатурыЗавершение = Новый ОписаниеОповещения("КупитьКарточкиНоменклатурыЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
	
	РаботаСНоменклатуройКлиент.КупитьКарточкиНоменклатуры(КупитьКарточкиНоменклатурыЗавершение,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторНоменклатуры), 
		ЭтотОбъект);
	
КонецФункции
	
&НаКлиенте
Процедура КупитьКарточкиНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если НЕ ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда 
		Возврат;
	КонецЕсли;
	
	РезультатПокупки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если РезультатПокупки = Неопределено Тогда 
		Возврат;
	КонецЕсли;
		
	Если РезультатПокупки.ЕстьОшибки Тогда
		ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ОшибкаПокупкиНоменклатуры", 
			Новый Структура("Ошибка", РезультатПокупки.ОписаниеОшибки));
	Иначе
		
		ПараметрыЗавершения = Новый Структура;
		ПараметрыЗавершения.Вставить("ИдентификаторЗадания", Неопределено);
		
		СформироватьПредставлениеНоменклатурыЗавершение = Новый ОписаниеОповещения("СформироватьПредставлениеНоменклатурыЗавершение",
			ЭтотОбъект, ПараметрыЗавершения);
		
		РаботаСНоменклатуройКлиент.СформироватьПредставленияКарточекНоменклатуры(СформироватьПредставлениеНоменклатурыЗавершение,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДополнительныеПараметры.ИдентификаторНоменклатуры), 
			ЭтотОбъект, 
			Неопределено, 
			Элементы.КарточкаНоменклатуры.ОтображениеСостояния,
			Не ПравоИзмененияДанных);
			
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура НастроитьФормуПриДлительнойОперации(ЭтоНачалоДлительнойОперации, Режим)
	
	Элементы.ГруппаДекорацииДлительнойОперации.Видимость = ЭтоНачалоДлительнойОперации;
	Элементы.СоздатьНоменклатуру.Доступность             = Не ЭтоНачалоДлительнойОперации;
	Элементы.ГруппаКнопкиНавигации.Доступность           = ЭтоНачалоДлительнойОперации;
	
	Если Режим = "ПодборХарактеристик" Тогда
		Элементы.НадписьДлительнойОперации.Заголовок = НСтр("ru = 'Чтение характеристик'");
	ИначеЕсли Режим = "ЗагрузкаНоменклатуры" Тогда	
		Элементы.НадписьДлительнойОперации.Заголовок = НСтр("ru = 'Загрузка номенклатуры'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ТекущаяКарточкаКуплена()
	
	Возврат КэшПредставленийНоменклатуры[ТекущийИндексНоменклатуры].КарточкаКуплена;
	
КонецФункции

#КонецОбласти
