&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Типовое", Истина);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Типовое", Истина));
	
	ОткрытьФорму(
		"Справочник.СоглашенияСКлиентами.ФормаОбъекта",
		ПараметрыФормы,
		,
		,);

КонецПроцедуры
