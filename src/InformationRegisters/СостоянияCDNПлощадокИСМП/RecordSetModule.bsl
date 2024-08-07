
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Не ЗначениеЗаполнено(Запись.ДатаОбновленияУниверсальная) Тогда
			Запись.ДатаОбновленияУниверсальная = ТекущаяУниверсальнаяДата();
		КонецЕсли;
		
		СтруктураАдреса = РегистрыСведений.СостоянияCDNПлощадокИСМП.РазобратьАдресПлощадкиНаСерверИПорт(Запись.АдресПлощадки);
		
		Запись.Сервер               = СтруктураАдреса.Сервер;
		Запись.Порт                 = СтруктураАдреса.Порт;
		Запись.ЗащищенноеСоединение = СтруктураАдреса.ЗащищенноеСоединение;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
