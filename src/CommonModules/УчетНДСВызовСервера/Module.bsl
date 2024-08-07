#Область СлужебныйПрограммныйИнтерфейс

// См. Перечисления.ВариантыРасширенногоПервогоНалоговогоПериода.БлижайшийНалоговыйПериод.
Функция БлижайшийНалоговыйПериодСервер(Организация, Период) Экспорт
	
	Возврат УчетНДСПереопределяемый.БлижайшийНалоговыйПериод(
		Организация,
		Период);
	
КонецФункции

Функция ПолучитьИдентификаторМакетаРасшифровкиДекларацииПоНДС(Знач ПараметрыОтчета, Знач Показатель, ПользовательскиеНастройки) Экспорт
	
	ИдентификаторМакета = "";
	
	ТаблицаРасшифровок = ПолучитьИзВременногоХранилища(ПараметрыОтчета.АдресВременногоХранилищаРасшифровки);
	
	Если ТипЗнч(ТаблицаРасшифровок) = Тип("ТаблицаЗначений") Тогда
		
		НомерТекущейСтраницы = 0;
		
		ПараметрыОтчета.Свойство("НомерТекущейСтраницы", НомерТекущейСтраницы);
		
		Если НомерТекущейСтраницы = Неопределено ИЛИ НомерТекущейСтраницы = 0 Тогда
			ИмяПоказателя = Показатель;
		Иначе
			ИмяПоказателя = Показатель + "_" + НомерТекущейСтраницы;
		КонецЕсли;
		
		Расшифровка = ТаблицаРасшифровок.Найти(ИмяПоказателя,"ИмяПоказателя");
		
		Если Расшифровка <> Неопределено Тогда
			
			ДополнительныеПараметры = Расшифровка.ДополнительныеПараметры;
			
			ИдентификаторМакета = ДополнительныеПараметры.ИдентификаторМакета;
			
			Если ИдентификаторМакета = "ОткрытьОбъект" Тогда
				
				ДополнительныеПараметры.Свойство("Объект", ИдентификаторМакета);
				
			Иначе
				
				ДополнительныеПараметры.Свойство("ПользовательскиеНастройки", ПользовательскиеНастройки);
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат ИдентификаторМакета;
	
КонецФункции  

// Функция разбиения табличной части (табличный частей) на несколько документов
//
// Параметры:
//   ПараметрыПереносаСтрокТЧ - Структура - структура входных параметров с ключами:
//     * ТабличныеЧасти          - Соответствие - соотствие между проверяемой табличной частью и подчиненной.
//               * Ключ             - Строка - имя проверяемой табличной части
//               * Значение         - Структура - структура с ключами:
//....................* КоличествоСтрокДляПереноса - Число - обязательный ключ в него записывается вычисляемое в функции
//..........................................................количество строк для переноса проверяемой табличной части
//                    * ПодчиненныеТабличныеЧасти - Массив - необязательный ключ массив подчинённых табличных частей,
//                                                           строки из которых нужно перенести в новый документ.
//                    * ПодчиненнаяТЧМаксимальноеКоличествоСтрок - Строка - имя подчиненной табличной части с
//                                                                          максимальным количеством строк.
//                    * МаксимальноеКоличествоСтрокВДокументе    - Число - максимальное количество строк основной
//                                                                         табличной части в новом документе.
//     * РеквизитыДокумента      - Строка - список реквизитов для копирования из документа.
//     * РежимЗаписи             - РежимЗаписиДокумента - режим записи документа.
//     * МаксимальноеКоличествоСтрок - Число - максимальное количество строк, хранимое платформой в табличной части.
//     * Объект                      - ДанныеФормыСтруктура - объект клиентской формы документа, для которого нужно
//                                                            перености строк табличных частей в новые документы.
// Возвращаемое значение:
//  - Булево - Истина в случае успешного переноса строк в новые документы.
//  В случае не удачной транзакции по переносу документов в другой доукмент к структуре ПараметрыПереносаСтрокТЧ
//  добавляется поле ИнформацияОбОшибке - Строка - содержит подробное описание ошибки.
Функция ПеренестиСтрокиТабличныхЧастейВДругойДокументНаСервере(ПараметрыПереносаСтрокТЧ) Экспорт
	
	Объект = ПараметрыПереносаСтрокТЧ.Объект;
	ОбъектМетоданных = Метаданные.НайтиПоТипу(ТипЗнч(Объект.Ссылка));
	Если ОбъектМетоданных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	МаксимальноеКоличествоСтрок = ПараметрыПереносаСтрокТЧ.МаксимальноеКоличествоСтрок;
	РежимЗаписи = ПараметрыПереносаСтрокТЧ.РежимЗаписи;
	ТабличныеЧасти = ПараметрыПереносаСтрокТЧ.ТабличныеЧасти;
	РеквизитыДокумента = ПараметрыПереносаСтрокТЧ.РеквизитыДокумента;
	
	НачатьТранзакцию();
	
	Попытка
	
		Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
			
			КоличествоСтрокДляПереноса = ТабличнаяЧасть.Значение.КоличествоСтрокДляПереноса;
			Если КоличествоСтрокДляПереноса = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			ИндексПоследнийСтроки = Объект[ТабличнаяЧасть.Ключ].Количество()-1;
			
			ПодчиненныеТабличныеЧасти = Новый Массив;
			Если ТабличнаяЧасть.Значение.Свойство("ПодчиненныеТабличныеЧасти") Тогда
				ПодчиненныеТабличныеЧасти = ТабличнаяЧасть.Значение.ПодчиненныеТабличныеЧасти;
			КонецЕсли;
			
			ПодчиненнаяТЧМаксимальноеКоличествоСтрок = "";
			Если ТабличнаяЧасть.Значение.Свойство("ПодчиненнаяТЧМаксимальноеКоличествоСтрок") Тогда
				ПодчиненнаяТЧМаксимальноеКоличествоСтрок = ТабличнаяЧасть.Значение.ПодчиненнаяТЧМаксимальноеКоличествоСтрок;
			КонецЕсли;
			
			МаксимальноеКоличествоСтрокВДокументе = 0;
			Если ТабличнаяЧасть.Значение.Свойство("МаксимальноеКоличествоСтрокВДокументе") Тогда
				МаксимальноеКоличествоСтрокВДокументе = ТабличнаяЧасть.Значение.МаксимальноеКоличествоСтрокВДокументе;
			КонецЕсли;
			
			ИндексСтроки = 0;
			КоличествоСтрокТЧ = 0;
			
			СтрокиДляУдаленияТЧ = Новый Массив;
			
			СоответвиеПодчиненныхТЧДляУдаления = Новый Соответствие;
			Для каждого ПодчиненнаяТабличнаяЧасть Из ПодчиненныеТабличныеЧасти Цикл
				СоответвиеПодчиненныхТЧДляУдаления.Вставить(ПодчиненнаяТабличнаяЧасть, Новый Массив);
			КонецЦикла;
			
			Пока ИндексСтроки < КоличествоСтрокДляПереноса Цикл
				
				Если КоличествоСтрокТЧ = 0 Тогда
					НовыйДокументОбъект = Документы[ОбъектМетоданных.Имя].СоздатьДокумент();
					ЗаполнитьЗначенияСвойств(НовыйДокументОбъект, Объект , РеквизитыДокумента);
				КонецЕсли;
				
				СтрокаТЧНовогоДокумента = НовыйДокументОбъект[ТабличнаяЧасть.Ключ].Добавить();
				СтрокаТЧТекущегоДокумента = Объект[ТабличнаяЧасть.Ключ][ИндексПоследнийСтроки - ИндексСтроки];
				СтрокиДляУдаленияТЧ.Добавить(СтрокаТЧТекущегоДокумента);
				ЗаполнитьЗначенияСвойств(СтрокаТЧНовогоДокумента, СтрокаТЧТекущегоДокумента);
				
				Для Каждого ПодчиненнаяТЧ Из ПодчиненныеТабличныеЧасти Цикл
					КлючПоиска = Новый Структура("КлючСтроки", СтрокаТЧТекущегоДокумента.КлючСтроки);
					МассивСтрок = Объект[ПодчиненнаяТЧ].НайтиСтроки(КлючПоиска);
					
					Для Каждого СтрокаТЧ Из МассивСтрок Цикл
						СтрокаПодчиненнойТЧНовогоДокумента = НовыйДокументОбъект[ПодчиненнаяТЧ].Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаПодчиненнойТЧНовогоДокумента, СтрокаТЧ);
						СоответвиеПодчиненныхТЧДляУдаления[ПодчиненнаяТЧ].Добавить(СтрокаТЧ);
					КонецЦикла;
					
				КонецЦикла;
				
				КоличествоСтрокТЧ = КоличествоСтрокТЧ + 1;
				
				ИндексСтроки = ИндексСтроки + 1; 
				
				НовыйДокументКоличествоСтрок = НовыйДокументОбъект[ТабличнаяЧасть.Ключ].Количество();
				
				Если КоличествоСтрокТЧ = МаксимальноеКоличествоСтрок
					ИЛИ ИндексСтроки = КоличествоСтрокДляПереноса
					ИЛИ (ЗначениеЗаполнено(ПодчиненнаяТЧМаксимальноеКоличествоСтрок)
						И НовыйДокументКоличествоСтрок = МаксимальноеКоличествоСтрокВДокументе)Тогда
					НовыйДокументОбъект.Записать(РежимЗаписи);
					КоличествоСтрокТЧ = 0;
				КонецЕсли;
				
			КонецЦикла;
			
			Для Каждого СтрокаТЧ Из СтрокиДляУдаленияТЧ Цикл
				Объект[ТабличнаяЧасть.Ключ].Удалить(СтрокаТЧ);
			КонецЦикла;
			
			Для Каждого ПодчиненнаяТабличнаяЧастьДляУдаления Из СоответвиеПодчиненныхТЧДляУдаления Цикл
				МассивСтрокДляУдаления = ПодчиненнаяТабличнаяЧастьДляУдаления.Значение;
				Для Каждого СтрокаТЧ Из МассивСтрокДляУдаления Цикл
					Объект[ПодчиненнаяТабличнаяЧастьДляУдаления.Ключ].Удалить(СтрокаТЧ);
				КонецЦикла;
			КонецЦикла;
			
			ДокументОбъект = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект."+ОбъектМетоданных.Имя));
			ДокументОбъект.Записать(РежимЗаписи);
			
		КонецЦикла;
	
	Исключение
		
		ОтменитьТранзакцию();
		ПараметрыПереносаСтрокТЧ.Вставить("ИнформацияОбОшибке", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
		
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;

КонецФункции

#КонецОбласти
