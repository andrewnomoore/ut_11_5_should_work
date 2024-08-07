
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДанныеЗаказа", ДанныеЗаказа);
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	ЗаполнитьФормуПоДаннымЗаказа();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияСостояниеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ДанныеЗаказа.НомерЗаказа) Тогда
		
		ПерейтиПоНавигационнойСсылке(
			СервисДоставкиКлиентСервер.АдресСтраницыЗаказаНаДоставку1СДоставка(ДанныеЗаказа.НомерЗаказа));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	СписокВыбора = Новый СписокЗначений();
	ВидыПечатныхФормДокументов = СервисДоставкиКлиентСервер.ВидыПечатныхФормДокументов();
	
	Для Каждого СтрокаДокумент Из ДанныеЗаказа.СписокПечатныхФорм Цикл
		
		Для Каждого СтрокаПечатнаяФорма Из СтрРазделить(СтрокаДокумент.Представление, ",") Цикл
			
			СписокВыбора.Добавить(
				Новый Структура("uid, type",
					СтрокаДокумент.Значение.uid,
					СтрокаПечатнаяФорма),
				СтрШаблон(НСтр("ru = '%1 № %2'"),
					ВидыПечатныхФормДокументов.Получить(СтрокаПечатнаяФорма),
					СтрокаДокумент.Значение.id));
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если СписокВыбора.Количество() > 0 Тогда
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ПослеВыбораПечатнойФормы", ЭтотОбъект);
		ПоказатьВыборИзМеню(ОбработчикОповещения,
			СписокВыбора,
			Элементы.ФормаПечать);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуПоДаннымЗаказа()
	
	Заголовок = СтрШаблон(НСтр("ru = 'Заказ № %1 от %2'"),
		ДанныеЗаказа.НомерЗаказа,
		Формат(ДанныеЗаказа.ДатаЗаказа, НСтр("ru = 'ДФ=dd.MM.yyyy'")));
	
	Элементы.ДекорацияСостояние.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Состояние заказа:'") + " ",
		Новый ФорматированнаяСтрока(ДанныеЗаказа.Состояние,,,, "Ссылка"));
	
	Если НРег(ДанныеЗаказа.ВариантОтгрузки) = НСтр("ru = 'от адреса'") Тогда
		Элементы.ДекорацияОткуда.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'от адреса'") + " ",
			Новый ФорматированнаяСтрока(ДанныеЗаказа.АдресОтгрузкиГород,, ЦветаСтиля.ЦветГиперссылкиБЭД));
	Иначе
		Элементы.ДекорацияОткуда.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'от терминала'") + " ",
			Новый ФорматированнаяСтрока(ДанныеЗаказа.ОтправительТерминал,, ЦветаСтиля.ЦветГиперссылкиБЭД));
	КонецЕсли;
	
	Если НРег(ДанныеЗаказа.ВариантДоставки) = НСтр("ru = 'до адреса'") Тогда
		Элементы.ДекорацияКуда.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'до адреса'") + " ",
			Новый ФорматированнаяСтрока(ДанныеЗаказа.АдресДоставкиГород,, ЦветаСтиля.ЦветГиперссылкиБЭД));
	Иначе
		Элементы.ДекорацияКуда.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'до терминала'") + " ",
			Новый ФорматированнаяСтрока(ДанныеЗаказа.ПолучательТерминал,, ЦветаСтиля.ЦветГиперссылкиБЭД));
	КонецЕсли;
	
	Элементы.ДекорацияОткуда.Подсказка = ДанныеЗаказа.АдресОтгрузкиПредставление;
	Элементы.ДекорацияКуда.Подсказка = ДанныеЗаказа.АдресДоставкиПредставление;
	
	Элементы.ДекорацияОтправитель.Заголовок = ДанныеЗаказа.ОтправительНаименование;
	Элементы.ДекорацияПолучатель.Заголовок = ДанныеЗаказа.ПолучательНаименование;
	
	Элементы.ДекорацияКонтактыОтправителя.Заголовок = ДанныеЗаказа.ОтправительКонтактноеЛицоТелефонПредставление;
	Элементы.ДекорацияКонтактноеЛицоОтправителя.Заголовок = ДанныеЗаказа.ОтправительКонтактноеЛицоНаименование;

	Элементы.ДекорацияКонтактыПолучателя.Заголовок = ДанныеЗаказа.ПолучательКонтактноеЛицоТелефонПредставление;
	Элементы.ДекорацияКонтактноеЛицоПолучателя.Заголовок = ДанныеЗаказа.ПолучательКонтактноеЛицоНаименование;

	МассивСклонений = ПолучитьСклоненияСтрокиПоЧислу(НСтр("ru = 'место'"), ДанныеЗаказа.КоличествоГрузовыхМест);
	
	Элементы.ДекорацияОписаниеГруза.Заголовок = СтрШаблон(НСтр("ru = '%1%2, %3 кг, %4 м3.'"),
		?(ЗначениеЗаполнено(ДанныеЗаказа.ГрузОписание),
			ДанныеЗаказа.ГрузОписание + ": ",
			""),
		?(МассивСклонений.Количество() = 0,
			Формат(ДанныеЗаказа.КоличествоГрузовыхМест, "ЧН=") + НСтр("ru = 'мест'"),
			МассивСклонений.Получить(0)),
		ДанныеЗаказа.ГрузВес,
		ДанныеЗаказа.ГрузОбъем);
		
	Элементы.ДекорацияМаксимальныеРазмерыГруза.Заголовок = СтрШаблон(НСтр("ru = 'Максимальные размеры (ДхШхВ): %1x%2x%3 (м).'"),
		ДанныеЗаказа.ГрузДлина,
		ДанныеЗаказа.ГрузШирина,
		ДанныеЗаказа.ГрузВысота);
	
	Если ДанныеЗаказа.Оплачен Тогда
		
		СостояниеОплаты = НСтр("ru = 'Оплачен'");
		Элементы.СостояниеОплаты.ЦветТекста = WebЦвета.Зеленый;
		
	Иначе
		
		СостояниеОплаты = НСтр("ru = 'Не оплачен'");
		Элементы.СостояниеОплаты.ЦветТекста = WebЦвета.Кирпичный;
		
	КонецЕсли;
		
	Для Каждого СтрокаДокументОснование Из ДанныеЗаказа.СписокДокументов Цикл
	
		Для Каждого СтрокаУслуга Из СтрокаДокументОснование.Значение.services Цикл
			
			НоваяСтрока = СписокУслуг.Добавить();
			НоваяСтрока.Наименование = СтрокаУслуга.name;
			НоваяСтрока.Количество = СтрокаУслуга.quantity;
			НоваяСтрока.Сумма = СтрокаУслуга.sum;
			НоваяСтрока.СуммаСНДС = СтрокаУслуга.totalSum;
			НоваяСтрока.СуммаНДС = СтрокаУслуга.vat;
			НоваяСтрока.СуммаСкидки = СтрокаУслуга.discountSum;
			НоваяСтрока.СтавкаНДС = СтрокаУслуга.vatRate;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ИтогКоличество = СписокУслуг.Итог("Количество");
	ИтогСумма = СписокУслуг.Итог("Сумма");
	ИтогСуммаСНДС = СписокУслуг.Итог("СуммаСНДС");
	ИтогСуммаНДС = СписокУслуг.Итог("СуммаНДС");
	ИтогСуммаСкидки = СписокУслуг.Итог("СуммаСкидки");
	
	Элементы.ФормаПечать.Видимость = ДанныеЗаказа.ДоступнаПечать;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПечатнойФормы(Значение, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Значение) = Тип("ЭлементСпискаЗначений") Тогда
		
		ИдентификаторДокумента = Значение.Значение.uid;
		ИдентификаторПечатнойФормы = Значение.Значение.type;
		ПредставлениеПечатнойФормы = Значение.Представление;
			
		ВыполнитьЗапросПолучитьПечатнуюФормуИзСервиса();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросПолучитьПечатнуюФормуИзСервиса() Экспорт
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьПечатнуюФормуИзСервиса();
	ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение печатной формы из сервиса.'");
	ПараметрыОперации.ВыводитьОкноОжидания = Истина;
	
	ВыполнитьЗапрос(ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапрос(ПараметрыОперации)
	
	ИнтернетПоддержкаПодключена = Ложь;
	ОчиститьСообщения();
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации);
	ЭтотОбъект[ИмяФоновогоЗадания] = ФоновоеЗадание;
	
	Если ИнтернетПоддержкаПодключена = Ложь Тогда
		
		Оповещение = Новый ОписаниеОповещения("ВыполнитьЗапросПродолжение", ЭтотОбъект, ПараметрыОперации);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение, ЭтотОбъект);
		Возврат;
		
	Иначе
		
		ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
		ВыполнитьЗапросПродолжение(Истина, ПараметрыОперации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ИмяФоновогоЗадания = "ФоновоеЗадание"+ ДополнительныеПараметры.ИмяПроцедуры;
	
	Если Результат = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru = 'Отсутствует подключение к Интернет-поддержке пользователей.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("Логин") Тогда
		
		ИнтернетПоддержкаПодключена = Ложь;
		ЭтотОбъект[ИмяФоновогоЗадания] = ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ДополнительныеПараметры);
		ДополнительныеПараметры.Вставить("ФоновоеЗадание", ЭтотОбъект[ИмяФоновогоЗадания]);
		
	КонецЕсли;
	
	Если ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект[ИмяФоновогоЗадания].Статус = "Выполняется" Тогда
		
		ОжидатьЗавершениеВыполненияЗапроса(ДополнительныеПараметры);
		
	ИначеЕсли ЭтотОбъект[ИмяФоновогоЗадания].Статус = "Выполнено" Тогда
		
		ВыполнитьЗапросЗавершение(ЭтотОбъект[ИмяФоновогоЗадания], ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации)
	
	ВыводитьОкноОжидания = ?(ЗначениеЗаполнено(ПараметрыОперации.ВыводитьОкноОжидания), 
		ПараметрыОперации.ВыводитьОкноОжидания,
		Ложь);
	
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
	
	Отказ = Ложь;
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ДополнительныеПараметры.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	
	СервисДоставкиКлиент.ОбработатьРезультатФоновогоЗадания(Результат, ДополнительныеПараметры, Отказ);
	Если Результат = Неопределено
		Или ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Результат.Статус = "Выполнено" Тогда
		
		Если ЗначениеЗаполнено(Результат.АдресРезультата)
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата)
			И ДополнительныеПараметры.ФоновоеЗадание.ИдентификаторЗадания = ЭтотОбъект[ИмяФоновогоЗадания].ИдентификаторЗадания Тогда
			
			Если ДополнительныеПараметры.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьПечатнуюФормуИзСервиса() Тогда
				
				ДвоичныеДанныеBase64 = РезультатПолученияПечатнойФормыИзСервиса(Результат.АдресРезультата);
				Если ЗначениеЗаполнено(ДвоичныеДанныеBase64) Тогда
					
					#Если ВебКлиент Тогда
						
						СодержимоеФайла = Base64Значение(ДвоичныеДанныеBase64);
						АдресХранилища = ПоместитьВоВременноеХранилище(СодержимоеФайла);
						ИмяФайла = СтрШаблон("%1.%2", ПредставлениеПечатнойФормы, "pdf");
						НачатьПолучениеФайлаССервера(АдресХранилища, ИмяФайла);
							
						ПоказатьОповещениеПользователя(НСтр("ru = 'Файл загружен'"),,
							ИмяФайла,
							БиблиотекаКартинок.СохранитьКак24,, );
						
					#Иначе
					
						ПараметрыОткрытияФормы = Новый Структура();
						ПараметрыОткрытияФормы.Вставить("Заголовок", ПредставлениеПечатнойФормы);
						ПараметрыОткрытияФормы.Вставить("ДанныеФайла", ДвоичныеДанныеBase64);
						
						ОткрытьФорму("Обработка.СервисДоставки.Форма.ФормаПросмотраPDF",
							ПараметрыОткрытияФормы,,
							Новый УникальныйИдентификатор(),,,,
							РежимОткрытияОкнаФормы.Независимый);
							
					#КонецЕсли
					
				Иначе
					
					ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ошибка загрузки печатной формы!'"));
					
				КонецЕсли;
				
				ФоновоеЗаданиеПолучитьПечатнуюФормуИзСервиса = Неопределено;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РезультатПолученияПечатнойФормыИзСервиса(АдресРезультата, ОперацияВыполнена = Истина)
	
	ДанныеФайла = Неопределено;
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат)
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если Результат.Свойство("Список")
				И ТипЗнч(Результат.Список) = Тип("Массив")
				И Результат.Список.Количество() > 0 Тогда
				
				ДанныеФайла = Результат.Список.Получить(0).base64;
				
			КонецЕсли;
			
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеФайла;
	
КонецФункции

&НаСервере
Функция ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации)
	
	ИнтернетПоддержкаПодключена = ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Если Не ИнтернетПоддержкаПодключена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отказ = Ложь;
	ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыОперации, Отказ);
	
	Если ПараметрыЗапроса.Свойство("ОрганизацияБизнесСетиСсылка") Тогда
		СервисДоставкиСлужебный.ПроверитьОрганизациюБизнесСети(ПараметрыЗапроса.ОрганизацияБизнесСетиСсылка, Отказ);
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	Если ФоновоеЗадание <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ФоновоеЗадание.ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1. %2'"),
		СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(ТипГрузоперевозки),
		ПараметрыОперации.НаименованиеОперации);
	Задание.ИмяПроцедуры = "СервисДоставки." + ПараметрыОперации.ИмяПроцедуры;
	Задание.ПараметрыПроцедуры = ПараметрыЗапроса;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Если ПараметрыОперации.Свойство("ЗапуститьВФоне")
		И ТипЗнч(ПараметрыОперации.ЗапуститьВФоне) = Тип("Булево") Тогда
		ПараметрыВыполнения.ЗапуститьВФоне = ПараметрыОперации.ЗапуститьВФоне;
	КонецЕсли; 
	
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
Функция ПараметрыЗапроса(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = Новый Структура();
	
	ИмяПроцедуры = ПараметрыОперации.ИмяПроцедуры;
	
	Если ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьПечатнуюФормуИзСервиса() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаПолучитьПечатнуюФормуИзСервиса(ПараметрыОперации, Отказ);
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

&НаСервере
Функция ПараметрыЗапросаПолучитьПечатнуюФормуИзСервиса(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаПолучитьПечатнуюФормуИзСервиса();
	
	Если ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		
		ПараметрыЗапроса.ИдентификаторДокумента = ИдентификаторДокумента;
		ПараметрыЗапроса.ИдентификаторПечатнойФормы = ИдентификаторПечатнойФормы;
		ПараметрыЗапроса.ТипГрузоперевозки = ТипГрузоперевозки;
		
	Иначе
		
		ТекстОшибки = НСтр("ru = 'Не выбран тип грузоперевозки.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Отказ = Истина;
		
	КонецЕсли;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

#КонецОбласти
