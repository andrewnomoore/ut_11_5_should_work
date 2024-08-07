
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Информация = Параметры.Информация;
	Элементы.ВыгрузитьВФайл.Видимость = Параметры.ПоказатьКнопкуСохранения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	
	АдресХраненияРезультата = ПоместитьВоВременноеХранилище(Информация);
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Интерактивно = Истина;
	ПараметрыСохранения.Диалог.Фильтр = "Текстовые файлы (*.txt)|*.txt";

	ФайловаяСистемаКлиент.СохранитьФайл(
		Неопределено,
		АдресХраненияРезультата,
		Неопределено,
		ПараметрыСохранения);
		
КонецПроцедуры

#КонецОбласти