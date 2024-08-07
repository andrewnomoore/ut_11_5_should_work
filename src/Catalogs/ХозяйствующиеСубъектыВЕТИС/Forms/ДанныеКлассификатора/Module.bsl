#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПредприятияХозяйствующиеСубъектыВЕТИС.ЗаполнитьСписокВыбораОрганизационноПравовыхФорм(Элементы.ОрганизационноПравоваяФорма);
	
	ЕстьПравоИзменения = ПравоДоступа("Изменение", Метаданные.Справочники.ХозяйствующиеСубъектыВЕТИС);
	
	ОбработатьПереданныеПараметры(Отказ);
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) 
		И Элементы.Контрагент.ОграничениеТипа.Типы().Найти(ТипЗнч(ВыбранноеЗначение)) <> Неопределено Тогда
		
		Контрагент = ВыбранноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформацияСостояниеЗагрузкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьХозяйствующийСубъект" Тогда
		
		ПоказатьЗначение(, ХозяйствующийСубъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеКонтрагента = ИнтеграцияВЕТИСКлиентСервер.РеквизитыСозданияКонтрагента();
	ЗаполнитьЗначенияСвойств(ДанныеКонтрагента, ЭтотОбъект);
	ДанныеКонтрагента.ЮридическийАдрес = ПредставлениеАдреса;
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОткрытьФормуСозданияКонтрагента(ЭтотОбъект, ДанныеКонтрагента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредприятия

 &НаКлиенте
Процедура ПредприятияЗагрузитьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Предприятия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Загрузить = Ложь Тогда
		
		КоличествоПредприятийКЗагрузке = КоличествоПредприятийКЗагрузке - 1;
		ПредприятияКЗагрузке.Удалить(ПредприятияКЗагрузке.НайтиСтроки(Новый Структура("GUID", ТекущиеДанные.GUID))[0]);
		
	Иначе
		
		КоличествоПредприятийКЗагрузке = КоличествоПредприятийКЗагрузке + 1;
		ЗаполнитьЗначенияСвойств(ПредприятияКЗагрузке.Добавить(), ТекущиеДанные);
		
	КонецЕсли;
	
	СформироватьСостояниеЗагрузки(ЭтотОбъект);
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Результат = РезультатЗагрузки();
	
	Если Не Результат.ЕстьОшибки Тогда
		
		ТекстЗаголовка = НСтр("ru = 'Загрузка из классификатора'");
		
		Если Результат.ЗагруженныеОбъекты.Количество() = 1 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Выполнена загрузка %1.'"), Результат.ЗагруженныеОбъекты[0]);
		ИначеЕсли Результат.ЗагруженныеОбъекты.Количество()> 1 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Загружено объектов %1.'"), Результат.ЗагруженныеОбъекты.Количество());
		КонецЕсли;
		
		Для Каждого ЗагруженныйОбъект Из Результат.ЗагруженныеОбъекты Цикл
			Если ТипЗнч(ЗагруженныйОбъект) = Тип("СправочникСсылка.ХозяйствующиеСубъектыВЕТИС") Тогда
				ПараметрыЗаписи = Новый Структура;
				Оповестить(
					"Запись_ХозяйствующиеСубъектыВЕТИС",
					ПараметрыЗаписи,
					ЗагруженныйОбъект);
			КонецЕсли;
		КонецЦикла;
		
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32ГосИС);
		
		Закрыть(ХозяйствующийСубъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияПоискСтраницаПервая(Команда)
	
	ОчиститьСообщения();
	
	ОбработатьНайденныеПредприятия(1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияПоискСтраницаПоследняя(Команда)
	
	ОчиститьСообщения();
	
	КоличествоСтраниц = ОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	ОбработатьНайденныеПредприятия(КоличествоСтраниц);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияПоискСтраницаПредыдущая(Команда)
	
	ОчиститьСообщения();
	
	ОбработатьНайденныеПредприятия(ТекущийНомерСтраницы - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияПоискСтраницаСледующая(Команда)
	
	ОчиститьСообщения();
	
	ОбработатьНайденныеПредприятия(ТекущийНомерСтраницы + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияПоискТекущаяСтраница(Команда)
	
	КоличествоСтраниц = ОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	ТекущийНомерСтраницы = ТекущийНомерСтраницы;
	
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("МаксимальныйНомерСтраницы", КоличествоСтраниц);
	ПараметрыОткрытияФормы.Вставить("НомерСтраницы",             ТекущийНомерСтраницы);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.ПереходКСтраницеПоНомеру",
		ПараметрыОткрытияФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПослеВыбораНомераСтраницыПредприятия", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РезультатЗагрузки()

	РезультатЗагрузки = Новый Структура;
	РезультатЗагрузки.Вставить("ЕстьОшибки",         Ложь);
	РезультатЗагрузки.Вставить("ЗагруженныеОбъекты", Новый Массив);
	
	Если ЗначениеЗаполнено(ХозяйствующийСубъект) Тогда
		
		ХозяйствующийСубъектОбъект = ХозяйствующийСубъект.ПолучитьОбъект();
		
		Попытка
			
			ХозяйствующийСубъектОбъект.Заблокировать();
			
		Исключение
			
			ТекстИсключенияЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось изменить хозяйствующий субъект %1.
				           |Возможно он редактируются другим пользователем'"),
				ХозяйствующийСубъектОбъект.Наименование);
			
			ВызватьИсключение ТекстИсключенияЗаписи;
			
		КонецПопытки;
		
	Иначе
		
		ХозяйствующийСубъектОбъект = Справочники.ХозяйствующиеСубъектыВЕТИС.СоздатьЭлемент();
		ХозяйствующийСубъектОбъект.Заполнить(Неопределено);
		ХозяйствующийСубъектОбъект.УстановитьСсылкуНового(Справочники.ХозяйствующиеСубъектыВЕТИС.ПолучитьСсылку(Новый УникальныйИдентификатор(Идентификатор)));
		
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
	
		Для Каждого НайденнаяСтрока Из ПредприятияКЗагрузке Цикл
			
			ЗагрузитьПредприятие(НайденнаяСтрока, РезультатЗагрузки.ЗагруженныеОбъекты);
			
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(ХозяйствующийСубъект) Тогда
			
			ЗаполнитьЭлементСправочникаХозяйствующийСубъект(ХозяйствующийСубъектОбъект);
			
		КонецЕсли;
		
		ЗаполнитьПредприятияХозяйствующегоСубъекта(ХозяйствующийСубъектОбъект);
		
		ХозяйствующийСубъектОбъект.Записать();
		
		Если Не ЗначениеЗаполнено(ХозяйствующийСубъект) Тогда
			ХозяйствующийСубъект = ХозяйствующийСубъектОбъект.Ссылка;
			РезультатЗагрузки.ЗагруженныеОбъекты.Добавить(ХозяйствующийСубъект);
		КонецЕсли;
		
		ПредприятияКЗагрузке.Очистить();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		РезультатЗагрузки.ЗагруженныеОбъекты.Очистить();
		РезультатЗагрузки.ЕстьОшибки = Истина;
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось выполнить загрузку по причине: %1'"), 
			                        ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецПопытки;
	
	Возврат РезультатЗагрузки;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьЭлементСправочникаХозяйствующийСубъект(ХозяйствующийСубъектОбъект)
	
	ДанныеХозяйствующегоСубъекта = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныеХозяйствующегоСубъекта();
	
	Если Тип <> Перечисления.ТипыХозяйствующихСубъектовВЕТИС.ЮридическоеЛицо Тогда
		ДанныеХозяйствующегоСубъекта.ФИО = ФИО;
	Иначе
		ДанныеХозяйствующегоСубъекта.Наименование       = Наименование;
		ДанныеХозяйствующегоСубъекта.НаименованиеПолное = НаименованиеПолное;
	КонецЕсли;
	
	ДанныеХозяйствующегоСубъекта.Идентификатор            = Идентификатор;
	ДанныеХозяйствующегоСубъекта.ИдентификаторВерсии      = ИдентификаторВерсии;
	ДанныеХозяйствующегоСубъекта.Статус                   = Статус;
	ДанныеХозяйствующегоСубъекта.Тип                      = Тип;
	ДанныеХозяйствующегоСубъекта.ИНН                      = ИНН;
	ДанныеХозяйствующегоСубъекта.КПП                      = КПП;
	ДанныеХозяйствующегоСубъекта.ДанныеАдреса             = ДанныеАдреса;
	ДанныеХозяйствующегоСубъекта.ПредставлениеАдреса      = ПредставлениеАдреса;
	ДанныеХозяйствующегоСубъекта.СоответствуетОрганизации = Ложь;
	ДанныеХозяйствующегоСубъекта.Вставить("Контрагент", Контрагент);
	
	ХозяйствующийСубъект = ИнтеграцияВЕТИС.ЗагрузитьХозяйствующийСубъект(ДанныеХозяйствующегоСубъекта, ХозяйствующийСубъектОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНомераСтраницыПредприятия(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьНайденныеПредприятия(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПредприятие(НайденнаяСтрока, ЗагруженныеОбъекты)
	
	ДанныеПредприятия = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныеПредприятия();
	
	ДанныеПредприятия.Наименование        = НайденнаяСтрока.Наименование;
	ДанныеПредприятия.Идентификатор       = НайденнаяСтрока.GUID;
	ДанныеПредприятия.ИдентификаторВерсии = НайденнаяСтрока.UUID;
	ДанныеПредприятия.Статус              = НайденнаяСтрока.Статус;
	ДанныеПредприятия.СтатусВРеестре      = НайденнаяСтрока.СтатусВРеестре;
	ДанныеПредприятия.Тип                 = НайденнаяСтрока.Тип;
	ДанныеПредприятия.ДанныеАдреса        = ИнтеграцияВЕТИС.ДанныеАдреса(НайденнаяСтрока.ДанныеАдреса);
	ДанныеПредприятия.ПредставлениеАдреса = НайденнаяСтрока.ПредставлениеАдреса;
	ДанныеПредприятия.НомераПредприятий   = НайденнаяСтрока.НомераПредприятий.ВыгрузитьЗначения();
	
	Предприятие = ИнтеграцияВЕТИС.ЗагрузитьПредприятие(ДанныеПредприятия);
	
	ЗагруженныеОбъекты.Добавить(Предприятие);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредприятияХозяйствующегоСубъекта(ХозяйствующийСубъектОбъект)
	
	//При многостраничном списке предприятий, ориентироваться на список текущей страницы нельзя.
	//Выполним только добавление данных.
	
	ТаблицаИдентификаторовПредприятий = ПредприятияКЗагрузке.Выгрузить(, "GUID, GLN");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(ИдентификаторыGLNПредприятий.GUID КАК СТРОКА(36)) КАК GUID,
	|	ВЫРАЗИТЬ(ИдентификаторыGLNПредприятий.GLN  КАК СТРОКА(13)) КАК GLN
	|ПОМЕСТИТЬ ИдентификаторыGLNПредприятий
	|ИЗ
	|	&ИдентификаторыGLNПредприятий КАК ИдентификаторыGLNПредприятий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПредприятияВЕТИС.Ссылка КАК Предприятие,
	|	ИдентификаторыGLNПредприятий.GLN КАК GLN
	|ИЗ
	|	ИдентификаторыGLNПредприятий КАК ИдентификаторыGLNПредприятий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПредприятияВЕТИС КАК ПредприятияВЕТИС
	|		ПО ИдентификаторыGLNПредприятий.GUID = ПредприятияВЕТИС.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
	|		ПО (ПредприятияВЕТИС.Ссылка = ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие)
	|			И ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = &ХозяйствующийСубъект
	|ГДЕ
	|	ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка ЕСТЬ NULL
	|";
		
	Запрос.УстановитьПараметр("ИдентификаторыGLNПредприятий", ТаблицаИдентификаторовПредприятий);
	Запрос.УстановитьПараметр("ХозяйствующийСубъект",         ХозяйствующийСубъектОбъект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ХозяйствующийСубъектОбъект.Предприятия.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПереданныеПараметры(Отказ)

	Если Не ЗначениеЗаполнено(Параметры.Идентификатор) Тогда
		
		ВызватьИсключение НСтр("ru = 'Форма не предназначена для открытия без передачи в неё идентификатора хозяйствующего субъекта.'");
		
	Иначе
		
		НеПоказыватьПереходКЗагруженномуХС = Параметры.НеПоказыватьПереходКЗагруженномуХС;
		Идентификатор = Параметры.Идентификатор;
		Результат = ЦерберВЕТИСВызовСервера.ХозяйствующийСубъектПоGUID(Идентификатор);
		ОпределитьНаличиеВИБ();
		
		Если Не ПустаяСтрока(Результат.ТекстОшибки) Тогда
			
			ЕстьОшибкаДанныеХозяйствующегоСубъекта = Истина;
			ТекстОшибкиХозяйствующийСубъект        = ПредприятияХозяйствующиеСубъектыВЕТИС.ТекстОшибкиПолученияДанных(Результат.ТекстОшибки);
			
		Иначе
			
			ЗаполнитьДанныеХозяйствующегоСубъекта(ИнтеграцияВЕТИС.ДанныеХозяйствующегоСубъекта(Результат.Элемент));
			Результат = ЦерберВЕТИСВызовСервера.СписокПредприятийХозяйствующегоСубъекта(Идентификатор, 1);
			
			Если Не ПустаяСтрока(Результат.ТекстОшибки) Тогда
				
				ТекстОшибкиДанныеПредприятий = ПредприятияХозяйствующиеСубъектыВЕТИС.ТекстОшибкиПолученияДанных(Результат.ТекстОшибки);
				ЕстьОшибкаДанныеПредприятий  = Истина;
				
			Иначе
				
				СобственнаяОрганизацияЗначениеПоУмолчанию            = Неопределено;
				СобственныйТорговыйОбъектЗначениеПоУмолчанию         = Неопределено;
				СобственныйПроизводственныйОбъектЗначениеПоУмолчанию = Неопределено;
				СторонняяОрганизацияЗначениеПоУмолчанию              = Неопределено;
				СтороннийТорговыйОбъектЗначениеПоУмолчанию           = Неопределено;
			
				ИнтеграцияВЕТИСПереопределяемый.ЗначенияПоУмолчаниюНеСопоставленныхОбъектов(
					СобственнаяОрганизацияЗначениеПоУмолчанию,
					СобственныйТорговыйОбъектЗначениеПоУмолчанию,
					СобственныйПроизводственныйОбъектЗначениеПоУмолчанию,
					СторонняяОрганизацияЗначениеПоУмолчанию,
					СтороннийТорговыйОбъектЗначениеПоУмолчанию);
				
				МассивТиповКонтрагент = Новый Массив;
				МассивТиповКонтрагент.Добавить(ТипЗнч(СторонняяОрганизацияЗначениеПоУмолчанию));
				Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповКонтрагент);
				
				ЗаполнитьСписокПредприятий(Результат, 1);
				
				Если Параметры.ПереходитьКПредприятиям Тогда
					Элементы.СтраницыДанныеКлассификатора.ТекущаяСтраница = Элементы.СтраницаПредприятия;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеВИБ()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.Текст = "ВЫБРАТЬ
	|	ХозяйствующиеСубъектыВЕТИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
	|ГДЕ
	|	ХозяйствующиеСубъектыВЕТИС.Идентификатор = &Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПредприятияВЕТИС.Предприятие.Идентификатор КАК ИдентификаторПредприятия
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ПредприятияВЕТИС
	|		ПО ПредприятияВЕТИС.Ссылка = ХозяйствующиеСубъектыВЕТИС.Ссылка
	|ГДЕ
	|	ХозяйствующиеСубъектыВЕТИС.Идентификатор = &Идентификатор";
	
	Результат = Запрос.ВыполнитьПакет();
	
	ВыборкаХС = Результат[0].Выбрать();
	ЗагруженныеПредприятияХС = Новый Соответствие;
	
	Если ВыборкаХС.Следующий() Тогда
		
		ХозяйствующийСубъект = ВыборкаХС.Ссылка;
		
	КонецЕсли;
	
	ВыборкаПредприятия = Результат[1].Выбрать();
	КоличествоЗагруженныхПредприятий = ВыборкаПредприятия.Количество();
	
	Пока ВыборкаПредприятия.Следующий() Цикл
		
		ЗагруженныеПредприятияХС.Вставить(ВыборкаПредприятия.ИдентификаторПредприятия, Истина);
		
	КонецЦикла;
	
	ПредприятияХозяйствующегоСубъекта = Новый ФиксированноеСоответствие(ЗагруженныеПредприятияХС);
	
	УправлениеРеквизитамиФормыПослеОпределенияНаличияВИБ();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеРеквизитамиФормыПослеОпределенияНаличияВИБ()
	
	Если ЗначениеЗаполнено(ХозяйствующийСубъект) Тогда
		
		Элементы.ВИнформационнойБазеСоответствует.Видимость = Ложь;
		
		Элементы.ФормаЗагрузить.Видимость   = Истина;
		Элементы.ФормаЗагрузить.Доступность = Ложь;
		
	Иначе
		
		Элементы.ФормаЗагрузить.Видимость   = Истина;
		Элементы.ФормаЗагрузить.Доступность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПредприятий(Результат, НомерСтраницы)
	
	Предприятия.Очистить();
	
	Для Каждого businessEntity Из Результат.Список Цикл
		
		ДобавитьСтрокуСПредприятием(businessEntity.enterprise, businessEntity.globalID);
		
	КонецЦикла;
	
	ОбщееКоличество = Результат.ОбщееКоличество;
	ТекущийНомерСтраницы = НомерСтраницы;
	
	КоличествоСтраниц = ОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	Элементы.НавигацияНайденоВКлассификатореСтраницаТекущая.Заголовок =
		СтрШаблон(НСтр("ru = '%1 из %2'"), ТекущийНомерСтраницы, КоличествоСтраниц);
		
	УправлениеЭлементамиФормы(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработатьНайденныеПредприятия(НомерСтраницы)

	Результат = ЦерберВЕТИСВызовСервера.СписокПредприятийХозяйствующегоСубъекта(Идентификатор, НомерСтраницы);
	ЗаполнитьСписокПредприятий(Результат, НомерСтраницы);

КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуСПредприятием(ДанныеПредприятия, GLN)

	НоваяСтрока = Предприятия.Добавить();
	НоваяСтрока.Активность    = ДанныеПредприятия.active;
	НоваяСтрока.Актуальность  = ДанныеПредприятия.last;
	НоваяСтрока.GUID          = ДанныеПредприятия.GUID;
	НоваяСтрока.UUID          = ДанныеПредприятия.UUID;
	
	НоваяСтрока.Загрузить = ПредприятияКЗагрузке.НайтиСтроки(Новый Структура("GUID", НоваяСтрока.GUID)).Количество();
	НоваяСтрока.ИндексКартинкиЕстьВБазе = ПредприятияХозяйствующегоСубъекта.Получить(НоваяСтрока.GUID);
	
	Если GLN.Количество() > 0 Тогда
		НоваяСтрока.GLN = GLN[0];
	Иначе
		НоваяСтрока.GLN = "";
	КонецЕсли;
	
	НоваяСтрока.Наименование  = ДанныеПредприятия.Name;
	НоваяСтрока.ДатаСоздания  = ДанныеПредприятия.createDate;
	НоваяСтрока.ДатаИзменения = ДанныеПредприятия.updateDate;
	
	НоваяСтрока.ДанныеАдреса = ДанныеПредприятия.address;
	Если ДанныеПредприятия.address <> Неопределено Тогда
		НоваяСтрока.ПредставлениеАдреса = ДанныеПредприятия.address.addressView;
	КонецЕсли;
	
	НоваяСтрока.Статус         = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(ДанныеПредприятия.status);
	НоваяСтрока.СтатусВРеестре = ИнтеграцияВЕТИСПовтИсп.СтатусПредприятияВРеестре(ДанныеПредприятия.registryStatus);
	НоваяСтрока.Тип            = ИнтеграцияВЕТИСПовтИсп.ТипПредприятия(ДанныеПредприятия.type);
	
	Если ЗначениеЗаполнено(ДанныеПредприятия.activityList) Тогда
		Для Каждого activity Из ДанныеПредприятия.activityList.activity Цикл
			НоваяСтрока.ВидыДеятельности.Добавить(activity.name);
		КонецЦикла;
	КонецЕсли;
	
	НоваяСтрока.КоличествоВидовДеятельности = НоваяСтрока.ВидыДеятельности.Количество();
	
	Если ЗначениеЗаполнено(ДанныеПредприятия.numberList) Тогда
		Для Каждого НомерПредприятия Из ДанныеПредприятия.numberList.enterpriseNumber Цикл
			НоваяСтрока.НомераПредприятий.Добавить(НомерПредприятия);
		КонецЦикла;
	КонецЕсли;
	
	НоваяСтрока.КоличествоНомеровПредприятий = НоваяСтрока.НомераПредприятий.Количество();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеХозяйствующегоСубъекта(ДанныеХозяйствующегоСубъекта)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеХозяйствующегоСубъекта);
	Контрагент = ИнтеграцияИС.КонтрагентПоИННКПП(ИНН, КПП);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)

	Элементы = Форма.Элементы;
	
	Если Форма.ЕстьОшибкаДанныеХозяйствующегоСубъекта Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОшибкаПолученияДанныхХозяйствующегоСубъекта;
		Элементы.ФормаОтмена.Видимость         = Ложь;
		Элементы.ФормаЗакрыть.Видимость        = Истина;
		Элементы.ФормаЗагрузить.Видимость      = Ложь;
		
	Иначе
		
		СформироватьСостояниеЗагрузки(Форма);
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаДанныеКлассификатора;
		
		Если Форма.Тип = ПредопределенноеЗначение("Перечисление.ТипыХозяйствующихСубъектовВЕТИС.ЮридическоеЛицо") Тогда
			
			Элементы.КПП.Видимость                                = Истина;
			Элементы.ОГРН.Видимость                               = Истина;
			Элементы.НаименованиеХозяйствующегоСубъекта.Видимость = Истина;
			Элементы.ФИО.Видимость                                = Ложь;
			
		ИначеЕсли Форма.Тип = ПредопределенноеЗначение("Перечисление.ТипыХозяйствующихСубъектовВЕТИС.ИндивидуальныйПредприниматель") Тогда
			
			Элементы.КПП.Видимость                                = Ложь;
			Элементы.ОГРН.Видимость                               = Истина;
			Элементы.НаименованиеХозяйствующегоСубъекта.Видимость = Ложь;
			Элементы.ФИО.Видимость                                = Истина;
			
		ИначеЕсли Форма.Тип = ПредопределенноеЗначение("Перечисление.ТипыХозяйствующихСубъектовВЕТИС.ФизическоеЛицо") Тогда
			
			Элементы.КПП.Видимость                                = Ложь;
			Элементы.ОГРН.Видимость                               = Ложь;
			Элементы.НаименованиеХозяйствующегоСубъекта.Видимость = Ложь;
			Элементы.ФИО.Видимость                                = Истина;
			
		КонецЕсли;
		
		Если Форма.ЕстьОшибкаДанныеПредприятий Тогда
			
			Элементы.СтраницыПредприятия.ТекущаяСтраница = Элементы.СтраницаОшибкаПолученияДанныхПредприятий;
			Если ЗначениеЗаполнено(Форма.ХозяйствующийСубъект) Тогда
				Элементы.ФормаОтмена.Видимость      = Ложь;
				Элементы.ФормаЗакрыть.Видимость     = Истина;
				Элементы.ФормаЗагрузить.Доступность = Ложь;
			Иначе
				Элементы.ФормаОтмена.Видимость      = Истина;
				Элементы.ФормаЗакрыть.Видимость     = Ложь;
				Элементы.ФормаЗагрузить.Доступность = Истина;
			КонецЕсли;
			
		Иначе
			
			Элементы.СтраницыПредприятия.ТекущаяСтраница = Элементы.СтраницаСписокПредприятий;
			Элементы.ФормаОтмена.Видимость  = Истина;
			Элементы.ФормаЗакрыть.Видимость = Ложь;
			
			Элементы.Предприятия.ТолькоПросмотр = Не Форма.ЕстьПравоИзменения;
			
			Если Форма.ЕстьПравоИзменения 
				И (Не ЗначениеЗаполнено(Форма.ХозяйствующийСубъект)
				Или Форма.КоличествоПредприятийКЗагрузке > 0) Тогда
				
				Элементы.ФормаЗагрузить.Доступность = Истина;
				
			Иначе
				
				Элементы.ФормаЗагрузить.Доступность = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.КоличествоСтраниц < 2 Тогда
		Элементы.НавигацияНайденоВКлассификаторе.Видимость = Ложь;
	Иначе
		Элементы.НавигацияНайденоВКлассификаторе.Видимость = Истина;
		Элементы.НавигацияНайденоВКлассификатореСтраницаСледующая.Доступность  = (Форма.ТекущийНомерСтраницы < Форма.КоличествоСтраниц);
		Элементы.НавигацияНайденоВКлассификатореСтраницаПоследняя.Доступность  = (Форма.ТекущийНомерСтраницы < Форма.КоличествоСтраниц);
		Элементы.НавигацияНайденоВКлассификатореСтраницаПредыдущая.Доступность = (Форма.ТекущийНомерСтраницы > 1);
		Элементы.НавигацияНайденоВКлассификатореСтраницаПервая.Доступность     = (Форма.ТекущийНомерСтраницы > 1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьСостояниеЗагрузки(Форма)

	Строки = Новый Массив;
	
	Если ЗначениеЗаполнено(Форма.ХозяйствующийСубъект) Тогда
		
		Строки.Добавить(НСтр("ru = 'Хозяйствующий субъект уже загружен'"));
		
		Если Форма.НеПоказыватьПереходКЗагруженномуХС Тогда
			Строки.Добавить(НСтр("ru = '.'"));
		Иначе
			Строки.Добавить(" (");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'открыть'"),, Форма.ЦветГиперссылки,, "ОткрытьХозяйствующийСубъект"));
			Строки.Добавить(").");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.ОбщееКоличество > 0 Тогда
		
		Строки.Добавить(" ");
		Строки.Добавить(СтрШаблон(НСтр("ru = 'Предприятий - %1'"), Форма.ОбщееКоличество));
		
		Если Форма.КоличествоЗагруженныхПредприятий > 0 Тогда
			
			Строки.Добавить(", ");
			
			Если Форма.КоличествоЗагруженныхПредприятий = Форма.ОбщееКоличество Тогда
				
				Строки.Добавить(НСтр("ru = 'все загружены'"));
				
			Иначе
				
				Строки.Добавить(СтрШаблон(НСтр("ru = 'загружено - %1'"), Форма.КоличествоЗагруженныхПредприятий));
				
			КонецЕсли;
				
		КонецЕсли;
		
		Если Форма.КоличествоПредприятийКЗагрузке > 0 Тогда
			
			Строки.Добавить(", ");
			Строки.Добавить(СтрШаблон(НСтр("ru = 'к загрузке - %1'"), Форма.КоличествоПредприятийКЗагрузке));
			
		КонецЕсли;
	
	Иначе
		
		Строки.Добавить(НСтр("ru = 'Предприятия отсутствуют'"));
		
	КонецЕсли;
	
	Строки.Добавить(".");
	
	Форма.ИнформацияСостояниеЗагрузки = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

#Область ПредприятияЗагрузитьОтображение

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияЗагрузить.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.ИндексКартинкиЕстьВБазе");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
#КонецОбласти

#Область ПредприятияЕстьВБазеОтображение

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияИндексКартинкиЕстьВБазе.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.ИндексКартинкиЕстьВБазе");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
#КонецОбласти

#Область ПредприятияТипНеизвестен

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияТип.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.Тип");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыХозяйствующихСубъектовВЕТИС.ФизическоеЛицо;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<неизвестен>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти

#Область ПредприятияВидыДеятельностиНеизвестны

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияВидыДеятельности.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.КоличествоВидовДеятельности");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<неизвестны>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти

#Область ПредприятияНомераНеизвестны

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияНомераПредприятий.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.КоличествоНомеровПредприятий");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<неизвестны>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти

КонецПроцедуры

#КонецОбласти
