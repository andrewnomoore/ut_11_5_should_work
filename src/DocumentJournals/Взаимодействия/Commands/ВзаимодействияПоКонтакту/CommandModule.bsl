///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Контакт", ПараметрКоманды);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТипВзаимодействия", "Контакт");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	
	ОткрытьФорму(
		"ЖурналДокументов.Взаимодействия.Форма.ФормаСпискаПараметрическая",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Источник.КлючУникальности,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
