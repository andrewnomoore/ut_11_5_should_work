
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	ОткрытьФорму("Документ.ЗапросКоммерческихПредложенийПоставщиков.ФормаОбъекта",
		Неопределено,
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры

#КонецОбласти