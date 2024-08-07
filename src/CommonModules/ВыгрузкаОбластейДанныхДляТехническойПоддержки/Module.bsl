
#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
// 	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - 
// 	ТаблицаОбработчиков - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковВыгрузкиДанных.ТаблицаОбработчиков
Процедура ПередВыгрузкойДанных(Контейнер, ТаблицаОбработчиков) Экспорт
	
	Если Не Контейнер.ДляТехническойПоддержки() Тогда
		Возврат;
	КонецЕсли;
			
	Для Каждого ОбъектМетаданных Из ВыгрузкаОбластейДанныхДляТехническойПоддержкиПовтИсп.МетаданныеИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки() Цикл
				
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = ОбъектМетаданных;
		НовыйОбработчик.Обработчик = ВыгрузкаОбластейДанныхДляТехническойПоддержки;
		НовыйОбработчик.ПередВыгрузкойТипа = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
					
	КонецЦикла;
			
	СписокМетаданных = ВыгрузкаОбластейДанныхДляТехническойПоддержкиПовтИсп.МетаданныеИмеющиеСсылкиНаИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки();
	
	Для Каждого ЭлементСписка Из СписокМетаданных Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементСписка.Ключ);
		НовыйОбработчик.Обработчик = ВыгрузкаОбластейДанныхДляТехническойПоддержки;
		НовыйОбработчик.ПередВыгрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
		
КонецПроцедуры

Процедура ПередВыгрузкойТипа(Контейнер, Сериализатор, ОбъектМетаданных, Отказ) Экспорт
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные();
	
	РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки = РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки(ОбъектМетаданных);
	
	Если РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком %2!'"),
			ОбъектМетаданных.ПолноеИмя(),
			"ВыгрузкаОбластейДанныхДляТехподдержки.ПередВыгрузкойОбъекта");
		
	КонецЕсли;
	
	Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойКонстанты(Объект);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойСсылочногоОбъекта(Объект, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойНабораЗаписей(ОбъектМетаданных, Объект, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неожиданный объект метаданных: %1!'"),
		ОбъектМетаданных.ПолноеИмя);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередВыгрузкойКонстанты(Объект)
	
	ОчиститьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Объект.Значение);
	
КонецПроцедуры

Процедура ПередВыгрузкойСсылочногоОбъекта(Объект, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки)
	
	Для Каждого ТекущийРеквизит Из РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки Цикл
		
		ИмяРеквизита = ТекущийРеквизит.ИмяРеквизита;

		Если ТекущийРеквизит.ИмяТабличнойЧасти = Неопределено Тогда
						
			ОчиститьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Объект[ИмяРеквизита]);		
			
		Иначе
			
			ИмяТабличнойЧасти = ТекущийРеквизит.ИмяТабличнойЧасти;
			
			Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл 
				
				ОчиститьСсылкуНаИсключаемыйИзВыгрузкиОбъект(СтрокаТабличнойЧасти[ИмяРеквизита]);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыгрузкойНабораЗаписей(ОбъектМетаданных, НаборЗаписей, РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки)
	
	МассивВозможныхИзмерений = Новый Массив;
	МассивВозможныхИзмерений.Добавить("Регистратор");
	
	Если ОбщегоНазначенияБТС.ЭтоРегистрБухгалтерии(ОбъектМетаданных) Тогда
		МассивВозможныхИзмерений.Добавить("СчетДт");
		МассивВозможныхИзмерений.Добавить("СчетКт");		
		МассивВозможныхИзмерений.Добавить("Счет");
	КонецЕсли;
	
	Для Каждого ОбъектМетаданныхИзмерение Из ОбъектМетаданных.Измерения Цикл
		МассивВозможныхИзмерений.Добавить(ИмяОбъектаМетаданных(ОбъектМетаданныхИзмерение));
	КонецЦикла;
	
	Для Каждого ТекущийРеквизит Из РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки Цикл
		
		ИмяСвойства = ТекущийРеквизит.ИмяРеквизита;
		НаборЗаписейВГраница = НаборЗаписей.Количество() - 1;
		
		Если НаборЗаписейВГраница < 0 Тогда
			Прервать;
		КонецЕсли;
		
		Для ИндексЗаписи = 0 по НаборЗаписейВГраница Цикл
			
			Запись = НаборЗаписей[НаборЗаписейВГраница - ИндексЗаписи];
			
			Если ОчиститьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Запись[ИмяСвойства]) 
				И МассивВозможныхИзмерений.Найти(ИмяСвойства) <> Неопределено Тогда
				
				НаборЗаписей.Удалить(Запись);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОчиститьСсылкуНаИсключаемыйИзВыгрузкиОбъект(Ссылка)
	
	Если Не ЗначениеЗаполнено(Ссылка) Или Не ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Ссылка)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МетаданныеИсключаемыеИзВыгрузки = ВыгрузкаОбластейДанныхДляТехническойПоддержкиПовтИсп.МетаданныеИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки();
	МетаданныеСсылки = Ссылка.Метаданные();
	
	Если МетаданныеИсключаемыеИзВыгрузки.Найти(МетаданныеСсылки) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Ссылка = Неопределено;	
	
	Возврат Истина;
	
КонецФункции

Функция РеквизитыОбъектаИмеющиеСсылкиНаИсключаемыеИзВыгрузки(Знач МетаданныеОбъекта)
	
	ПолноеИмяМетаданных = МетаданныеОбъекта.ПолноеИмя();
	
	СписокМетаданных = ВыгрузкаОбластейДанныхДляТехническойПоддержкиПовтИсп.МетаданныеИмеющиеСсылкиНаИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки();
	
	Возврат СписокМетаданных.Получить(ПолноеИмяМетаданных);
	
КонецФункции

// Возвращает имя объекта метаданных.
// 
// Параметры:
// 	ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
// Возвращаемое значение:
// 	Строка - имя объекта метаданных.
Функция ИмяОбъектаМетаданных(ОбъектМетаданных)
	
	Возврат ОбъектМетаданных.Имя;
	
КонецФункции
#КонецОбласти
