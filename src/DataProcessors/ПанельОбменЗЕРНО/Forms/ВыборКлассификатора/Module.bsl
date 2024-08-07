
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьФорму();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКлассификатор(Команда)
	
	ВидКлассификатора = ПредопределенноеЗначение("Перечисление.ВидыКлассификаторовЗЕРНО." + Команда.Имя);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКлассификатора", ВидКлассификатора);
	
	ОткрытьФорму("Справочник.КлассификаторНСИЗЕРНО.ФормаСписка", ПараметрыОткрытия, ЭтотОбъект, ВидКлассификатора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФорму()
	
	Для Каждого ЗначениеКлассификатора Из Метаданные.Перечисления.ВидыКлассификаторовЗЕРНО.ЗначенияПеречисления Цикл
		
		Если ЗначениеКлассификатора.Имя = XMLСтрока(Перечисления.ВидыКлассификаторовЗЕРНО.ДопустимыеЗначенияПотребительскихСвойств)
			Или ЗначениеКлассификатора.Имя = XMLСтрока(Перечисления.ВидыКлассификаторовЗЕРНО.ВидСельскохозяйственнойКультуры) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(ЗначениеКлассификатора.Комментарий) Тогда
			Подсказка = СтрШаблон(
				НСтр("ru = 'Открыть классификатор ""%1""'"),
				ЗначениеКлассификатора.Синоним);
		Иначе
			Подсказка = ЗначениеКлассификатора.Комментарий;
		КонецЕсли; 
		
		Команда = Команды.Добавить(ЗначениеКлассификатора.Имя);
		Команда.Заголовок = ЗначениеКлассификатора.Синоним;
		Команда.Подсказка = Подсказка;
		Команда.Действие  = "ОткрытьКлассификатор";
		
		ЭлементФормы = Элементы.Добавить(ЗначениеКлассификатора.Имя, Тип("КнопкаФормы"), Элементы.ГруппаКлассификаторы);
		ЭлементФормы.ИмяКоманды           = Команда.Имя;
		ЭлементФормы.Вид                  = ВидКнопкиФормы.Гиперссылка;
		ЭлементФормы.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
