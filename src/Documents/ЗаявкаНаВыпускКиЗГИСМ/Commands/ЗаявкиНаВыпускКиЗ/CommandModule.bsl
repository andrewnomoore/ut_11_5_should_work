
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды) 
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Документ.ЗаявкаНаВыпускКиЗГИСМ.Форма.ФормаСпискаДокументов",
	             ПараметрыФормы, 
	             ПараметрыВыполненияКоманды.Источник, 
	             ПараметрыВыполненияКоманды.Уникальность,
	             ПараметрыВыполненияКоманды.Окно, 
	             ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти