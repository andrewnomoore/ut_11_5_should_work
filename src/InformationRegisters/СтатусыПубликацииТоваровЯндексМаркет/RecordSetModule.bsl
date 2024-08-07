#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.ИдентификаторПубликации = "" Тогда
			 ИдентификаторПубликации  = Строка(Новый УникальныйИдентификатор());
			 ИдентификаторПредложения = Строка(Новый УникальныйИдентификатор());
			 
			 Если Не Отказ Тогда
				Номенклатура        = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Номенклатура, "Наименование");
				Характеристика      = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Характеристика, "Наименование");
				Упаковка            = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Упаковка, "Наименование");
				ПредставлениеТовара = Номенклатура.Наименование;
				Если ЗначениеЗаполнено(Характеристика.Наименование) Тогда
					ПредставлениеТовара = ПредставлениеТовара + ", " + Характеристика.Наименование;
				КонецЕсли;
				Если ЗначениеЗаполнено(Упаковка.Наименование) Тогда
					ПредставлениеТовара = ПредставлениеТовара + ", " + Упаковка.Наименование;
				КонецЕсли;
				
				Запись.ИдентификаторПубликации  = ИдентификаторПубликации;
				Запись.ИдентификаторПредложения = ИдентификаторПредложения;
				 Если Не ЗначениеЗаполнено(Запись.Статус) Тогда 
					 Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.Новый;  
				 КонецЕсли;
				Запись.ТоварнаяКатегория        = ИнтеграцияСЯндексМаркетСервер.КатегорияТовара(Запись.Номенклатура,Запись.УчетнаяЗапись);
				Запись.ПредставлениеТовара      = ПредставлениеТовара; 
			КонецЕсли;
		КонецЕсли;
		
		Если Запись.Статус =  Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.Новый 
				Или Запись.Статус =  Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.СозданиеНового Тогда
			
			Запись.МаркерСтатуса = 2;
			
		ИначеЕсли  Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.ПолученаРекомендация 
						Или Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.УтвержденаРекомендация 
						Или Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.НаМодерации 
						Или Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.ОжидаетМодерации  Тогда
				
			Запись.МаркерСтатуса = 1;
			
		ИначеЕсли Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.МодерацияПройдена Тогда
			
			Запись.МаркерСтатуса = 3;
			
		Иначе
				
			 Запись.МаркерСтатуса = 0;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.ИдентификаторТовараПлощадки) Тогда
			Запись.ЕстьИдентификаторПлощадки         = Истина;
			Запись.ГиперссылкаНаРекомендованныеТовар = "https://pokupki.market.yandex.ru/product/" + СокрЛП(СтрЗаменить(Запись.ИдентификаторТовараПлощадки, Символ(160), ""));
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
