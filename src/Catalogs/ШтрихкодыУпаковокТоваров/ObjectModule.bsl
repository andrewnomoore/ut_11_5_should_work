#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(ЗначениеШтрихкода) И ЭтоНовый() Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ЗначениеШтрихкода", ЗначениеШтрихкода);
		Запрос.УстановитьПараметр("ХешСуммаЗначенияШтрихкода", ИнтеграцияИС.ХешированиеДанныхSHA256(ЗначениеШтрихкода));
		Запрос.Текст ="ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШтрихкодыУпаковокТоваров.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
		|ГДЕ
		|	ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода = &ЗначениеШтрихкода
		|	И ШтрихкодыУпаковокТоваров.ХешСуммаЗначенияШтрихкода = &ХешСуммаЗначенияШтрихкода";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Данное значение штрихкода уже присвоено другому элементу'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"ЗначениеШтрихкода", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	GTINПроверки = ?(СтрНайти(ЗначениеШтрихкода, "(")=1, Сред(ЗначениеШтрихкода,5,14), Сред(ЗначениеШтрихкода,3,14));
	Если ВложенныеШтрихкоды.Количество()>0
		И (ТипУпаковки <> Перечисления.ТипыУпаковок.МаркированныйТовар
			Или Не РегистрыСведений.ОписаниеGTINИС.ЭтоНабор(GTINПроверки)) Тогда
		
		ПараметрыНоменклатуры = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыНоменклатурыВложенныхШтрихкодов(ЭтотОбъект);
		
		Если ТипУпаковки <> ПараметрыНоменклатуры.ТипУпаковки Тогда
			ТекстСообщения = НСтр("ru = 'Неправильно указано значение типа упаковки: по данным вложенных упаковок должно быть значение %1'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, ПараметрыНоменклатуры.ТипУпаковки);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"ТипУпаковки","Объект", Отказ);
		КонецЕсли;
	
		Если Номенклатура <> ПараметрыНоменклатуры.Номенклатура Тогда
			Если ЗначениеЗаполнено(ПараметрыНоменклатуры.Номенклатура) Тогда
				ТекстСообщения = НСтр("ru = 'Неправильно указано значение номенклатуры: по данным вложенных упаковок должно быть значение %1'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Неправильно указано значение номенклатуры: по данным вложенных упаковок значение не должно быть заполнено'");
			КонецЕсли;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПараметрыНоменклатуры.Номенклатура);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Номенклатура","Объект", Отказ);
		КонецЕсли;
	
		Если Характеристика <> ПараметрыНоменклатуры.Характеристика Тогда
			Если ЗначениеЗаполнено(ПараметрыНоменклатуры.Характеристика) Тогда
				ТекстСообщения = НСтр("ru = 'Неправильно указано значение характеристики: по данным вложенных упаковок должно быть значение %1'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Неправильно указано значение характеристики: по данным вложенных упаковок значение не должно быть заполнено'");
			КонецЕсли;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПараметрыНоменклатуры.Характеристика);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Характеристика","Объект", Отказ);
		КонецЕсли;
	
		Если Упаковка <> ПараметрыНоменклатуры.Упаковка Тогда
			Если ЗначениеЗаполнено(ПараметрыНоменклатуры.Упаковка) Тогда
				ТекстСообщения = НСтр("ru = 'Не правильно указано значение упаковки: по данным вложенных упаковок должно быть значение %1'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Не правильно указано значение упаковки: по данным вложенных упаковок значение не должно быть заполнено'");
			КонецЕсли;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПараметрыНоменклатуры.Упаковка);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Упаковка","Объект", Отказ);
		КонецЕсли;
		
		Если Серия <> ПараметрыНоменклатуры.Серия Тогда
			Если ЗначениеЗаполнено(ПараметрыНоменклатуры.Серия) Тогда
				ТекстСообщения = НСтр("ru = 'Не правильно указано значение серии: по данным вложенных упаковок должно быть значение %1'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Не правильно указано значение серии: по данным вложенных упаковок значение не должно быть заполнено'");
			КонецЕсли;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПараметрыНоменклатуры.Упаковка);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Серия","Объект", Отказ);
		КонецЕсли;
	
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не (ДополнительныеСвойства.Свойство("НеРассчитыватьКоличествоВложенныхШтрихкодов")
		И ДополнительныеСвойства.НеРассчитыватьКоличествоВложенныхШтрихкодов) Тогда
	
		РассчитатьКоличествоВложенныхШтрихкодов();
		
	КонецЕсли;
	
	Если Не (ДополнительныеСвойства.Свойство("НеРассчитыватьХешСумму")
		И ДополнительныеСвойства.НеРассчитыватьХешСумму) Тогда
		
		Если ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
			ХешСумма = "";
		Иначе
			ДанныеДляВычисления = Справочники.ШтрихкодыУпаковокТоваров.ДанныеДляВычисленияХешСуммы(ЭтотОбъект);
			ХешСумма = Справочники.ШтрихкодыУпаковокТоваров.ХешСуммаСодержимогоУпаковки(ДанныеДляВычисления);
		КонецЕсли;
		
	КонецЕсли;
	
	ХешСуммаЗначенияШтрихкода = ОбщегоНазначенияИС.ХэшСуммаСтроки(ЗначениеШтрихкода);
	
	ЗаполнениеСлужебныхПолейДляGS1();
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗначениеШтрихкода         = "";
	ХешСумма                  = "";
	ХешСуммаНормализации      = "";
	ХешСуммаЗначенияШтрихкода = "";
	
	// Служебные поля GS1
	НомерПартии   = "";
	СерийныйНомер = 0;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьКоличествоВложенныхШтрихкодов() Экспорт
	
	Итоги = Новый Структура("УчетноеКоличество, ТолькоШтучнаяПродукция, КоличествоПотребительскихУпаковок", 0, Истина, 0);
	
	Если ВложенныеШтрихкоды.Количество() Тогда
		
		МассивВложенныхШтрихкодов = ВложенныеШтрихкоды.Выгрузить(, "Штрихкод").ВыгрузитьКолонку("Штрихкод");
		
		Результат = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковок(
			МассивВложенныхШтрихкодов,
			ШтрихкодированиеОбщегоНазначенияИС.ПараметрыСканирования(ЭтотОбъект));
		
		Для Каждого СтрокаДерева Из Результат.ДеревоУпаковок.Строки Цикл
			
			ПроизвольнаяЕдиницаУчета = ЗначениеЗаполнено(СтрокаДерева.Номенклатура) И СтрокаДерева.ПроизвольнаяЕдиницаУчета;
			
			Итоги.ТолькоШтучнаяПродукция = Итоги.ТолькоШтучнаяПродукция И Не ПроизвольнаяЕдиницаУчета;
			
			Если СтрокаДерева.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
				Если ПроизвольнаяЕдиницаУчета Тогда
					Итоги.УчетноеКоличество                 = Итоги.УчетноеКоличество                 + СтрокаДерева.КоличествоПоДаннымИБ;
					Итоги.КоличествоПотребительскихУпаковок = Итоги.КоличествоПотребительскихУпаковок + 1;
				Иначе
					Итоги.УчетноеКоличество                 = Итоги.УчетноеКоличество                 + 1;
					Итоги.КоличествоПотребительскихУпаковок = Итоги.КоличествоПотребительскихУпаковок + 1;
				КонецЕсли;
			Иначе
				Если ПроизвольнаяЕдиницаУчета Тогда
					Итоги.УчетноеКоличество                 = Итоги.УчетноеКоличество                 + СтрокаДерева.КоличествоПоДаннымИБ;
					Итоги.КоличествоПотребительскихУпаковок = Итоги.КоличествоПотребительскихУпаковок + СтрокаДерева.КоличествоПотребительскихУпаковокПоДаннымИБ;
				Иначе
					Итоги.УчетноеКоличество                 = Итоги.УчетноеКоличество                 + СтрокаДерева.КоличествоПотребительскихУпаковокПоДаннымИБ;
					Итоги.КоличествоПотребительскихУпаковок = Итоги.КоличествоПотребительскихУпаковок + СтрокаДерева.КоличествоПотребительскихУпаковокПоДаннымИБ;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Итоги.ТолькоШтучнаяПродукция Тогда
			Количество                        = Итоги.КоличествоПотребительскихУпаковок;
			КоличествоПотребительскихУпаковок = 0;
		Иначе
			Количество                        = Итоги.УчетноеКоличество;
			КоличествоПотребительскихУпаковок = Итоги.КоличествоПотребительскихУпаковок;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнениеСлужебныхПолейДляGS1()
	
	// Только для типов штрихкодов GS1_128 и GS1_DataBarExpandedStacked, для SSCC и Code-128 в ЕГАИС формат штрихкода жестко установлен
	Если ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_128
		Или ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_DataBarExpandedStacked
		Или ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_DataMatrix Тогда
		
		Если ЭтоНовый() Тогда
			ОбновитьРеквизитыGS1 = (ЗначениеЗаполнено(ЗначениеШтрихкода) И Не ЗначениеЗаполнено(ХешСуммаНормализации));
		Иначе
			ОбновитьРеквизитыGS1 = ЗначениеШтрихкода <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ЗначениеШтрихкода");
		КонецЕсли;
		
		Если ОбновитьРеквизитыGS1 Тогда
			
			ХешСуммаНормализации = "";
			
			ВидыПродукции = Новый Массив;
			Если ДополнительныеСвойства.Свойство("ВидПродукции") Тогда
				ВидыПродукции.Добавить(ДополнительныеСвойства.ВидПродукции);
			ИначеЕсли ЗначениеЗаполнено(Номенклатура) Тогда
				ВидыПродукции.Добавить(ИнтеграцияИСПовтИсп.ВидПродукцииПоНоменклатуре(Номенклатура));
			КонецЕсли;
			
			ВключаяТабачнуюПродукцию = Истина;
			Если ШтрихкодированиеОбщегоНазначенияИС.ПрисутствуетПродукцияИСМП(ВидыПродукции, ВключаяТабачнуюПродукцию) Тогда
				
				ДанныеРазбора = Неопределено;
				ПримечаниеКРазборуШтрихкода = Неопределено;
				Если ВидыПродукции.Количество() Тогда
					ДанныеРазбора = РазборКодаМаркировкиИССлужебный.РазобратьКодМаркировки(
						ЗначениеШтрихкода,
						ВидыПродукции, ПримечаниеКРазборуШтрихкода);
				КонецЕсли;
				
				Если ДанныеРазбора <> Неопределено
					И (ДанныеРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская
						Или ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ВозможнаГрупповаяУпаковкаИлиНабор(
							ДанныеРазбора.ВидУпаковки, ДанныеРазбора)) Тогда
					
					ПараметрыНормализацииКМ = РазборКодаМаркировкиИССлужебныйКлиентСервер.НастройкиРазбораКодаМаркировкиДляХэшаНормализации();
					НормализованныйШтрихкод = РазборКодаМаркировкиИССлужебныйКлиентСервер.НормализоватьКодМаркировки(
						ДанныеРазбора, ВидыПродукции[0], ПараметрыНормализацииКМ);
					
					ХешСуммаНормализации = ОбщегоНазначенияИС.ХэшСуммаСтроки(НормализованныйШтрихкод);
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ХешСуммаНормализации)
				И ТипУпаковки <> Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
				
				ПараметрыШтрихкода = ШтрихкодыУпаковокКлиентСервер.ПараметрыШтрихкода(ЗначениеШтрихкода);
				Результат          = ПараметрыШтрихкода.Результат;
				
				Если Результат <> Неопределено Тогда
					
					НомерПартии   = "";
					СерийныйНомер = 0;
					
					Если ПараметрыШтрихкода.ТипШтрихкода <> Перечисления.ТипыШтрихкодов.SSCC Тогда
						
						Для Каждого СвойствоШтрихкода Из Результат Цикл
							Если СвойствоШтрихкода.ИмяИдентификатора = ВРег("НомерПартии") Тогда
								НомерПартии = СвойствоШтрихкода.Значение;
							ИначеЕсли СвойствоШтрихкода.ИмяИдентификатора = ВРег("СерийныйНомер") Тогда
								СерийныйНомер = СвойствоШтрихкода.Значение;
							КонецЕсли;
							Если ЗначениеЗаполнено(НомерПартии) И ЗначениеЗаполнено(СерийныйНомер) Тогда
								Прервать;
							КонецЕсли;
						КонецЦикла;
						
					КонецЕсли;
					
					Справочники.ШтрихкодыУпаковокТоваров.ЗаполнитьСвойствоХешСуммаЗначенияШтрихкода(ЭтотОбъект, ПараметрыШтрихкода);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(ХешСуммаНормализации) И Не ЭтоНовый()
			И ЗначениеШтрихкода <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ЗначениеШтрихкода") Тогда
			ХешСуммаНормализации = "";
		КонецЕсли;
		
		НомерПартии   = "";
		СерийныйНомер = 0;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли