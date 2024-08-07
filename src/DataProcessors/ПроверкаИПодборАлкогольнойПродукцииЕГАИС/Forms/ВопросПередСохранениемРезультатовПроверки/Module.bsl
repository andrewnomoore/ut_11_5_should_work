
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КоличествоВсего         = Параметры.КоличествоВсего;
	КоличествоНеПроверенных = Параметры.КоличествоНеПроверенных;
	КоличествоОтложенных    = Параметры.КоличествоОтложенных;
	
	КоличествоСтрокНеМаркированнойВсего       = Параметры.КоличествоСтрокНеМаркированнойВсего;
	КоличествоСтрокНеМаркированнойОтсутствует = Параметры.КоличествоСтрокНеМаркированнойОтсутствует;
	
	Если КоличествоНеПроверенных > 0 
		Или КоличествоОтложенных > 0 Тогда
		
		ЕстьВопросПоМаркируемой = Истина;
		
	КонецЕсли;
	
	Если КоличествоСтрокНеМаркированнойОтсутствует > 0 Тогда
		
		ЕстьВопросПоНеМаркируемой = Истина;
		
	КонецЕсли;
	
	Если ЕстьВопросПоНеМаркируемой Тогда
		
		ПоказатьВопросПоНемаркируемой(ЭтотОбъект);
		
	ИначеЕсли ЕстьВопросПоМаркируемой Тогда
		
		ПоказатьВопросПоМаркируемой(ЭтотОбъект);
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВозвращаемоеЗначение = Неопределено;
	
	Если КакУчитыватьНеПроверенныеОтложенные = 0 Тогда
		ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отсутствует");
	Иначе
		ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии");
	КонецЕсли;
	
	Закрыть(ВозвращаемоеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОКНемаркируемая(Команда)
	
	Если ЕстьВопросПоМаркируемой Тогда
		
		ПоказатьВопросПоМаркируемой(ЭтотОбъект);
		
	Иначе
		
		Закрыть(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьВопросПоМаркируемой(Форма)

	Форма.Элементы.СтраницыТипыПродукции.ТекущаяСтраница = Форма.Элементы.СтраницаМаркируемая;
	Форма.Элементы.ОКМаркируемая.КнопкаПоУмолчанию       = Истина;
	
	Если Форма.КоличествоНеПроверенных > 0
		И Форма.КоличествоОтложенных > 0 Тогда
		
		ТекстРезультаты = СтрШаблон(НСтр("ru = 'Требовалось проверить наличие бутылок и упаковок - %1.
		                                        |Не проверено - %2. Отложено - %3.
		                                        |
		                                        |Отразить в результатах проверки отложенные и непроверенные как:'"),
		                            Форма.КоличествоВсего,
		                            Форма.КоличествоНеПроверенных,
		                            Форма.КоличествоОтложенных);
		
	ИначеЕсли Форма.КоличествоНеПроверенных > 0 Тогда
		
		ТекстРезультаты = СтрШаблон(НСтр("ru = 'Требовалось проверить наличие бутылок и упаковок - %1.
		                                        |Не проверено - %2.
		                                        |
		                                        |Отразить в результатах проверки непроверенные как:'"),
		                            Форма.КоличествоВсего,
		                            Форма.КоличествоНеПроверенных);
		
	Иначе
		
		ТекстРезультаты = СтрШаблон(НСтр("ru = 'Требовалось проверить наличие бутылок и упаковок - %1. 
		                                        |Отложено - %3.
		                                        |
		                                        |Отразить в результатах проверки отложенные как:'"),
		                            Форма.КоличествоВсего,
		                            Форма.КоличествоОтложенных);
		
	КонецЕсли;
	
	Форма.Элементы.ДекорацияРезультатыПроверкиМаркируемая.Заголовок = ТекстРезультаты;
	
	Если Форма.КоличествоВсего <> 0 
		И ((Форма.КоличествоНеПроверенных + Форма.КоличествоОтложенных) / Форма.КоличествоВсего > 0.5) Тогда
		
		Форма.КакУчитыватьНеПроверенныеОтложенные = 1;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьВопросПоНемаркируемой(Форма)

	Форма.Элементы.СтраницыТипыПродукции.ТекущаяСтраница = Форма.Элементы.СтраницаНеМаркируемая;
	
	Если Форма.ЕстьВопросПоМаркируемой Тогда
		Форма.Элементы.ОКНемаркируемая.Заголовок = НСтр("ru = 'Далее'");
	КонецЕсли;
	
	Если Форма.КоличествоСтрокНеМаркированнойОтсутствует > 0 Тогда
		
		ТекстРезультаты = СтрШаблон(НСтр("ru = 'Будет зафиксирована недостача партионной алкогольной продукции - %1.'"),
		                            Форма.КоличествоСтрокНеМаркированнойОтсутствует);
		
	КонецЕсли;
	
	Форма.Элементы.ДекорацияРезультатыПроверкиНемаркируемая.Заголовок = ТекстРезультаты;

КонецПроцедуры

#КонецОбласти
