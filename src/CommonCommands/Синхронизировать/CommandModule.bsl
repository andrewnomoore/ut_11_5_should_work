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
	
	Если Не ОбменДаннымиВызовСервера.УзелВходитВПланыОбменаБСД(ПараметрКоманды) Тогда
		
		Текст = НСтр("ru = 'Команда не предназначена для данного типа узлов'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
		ПоказатьПредупреждение(, Текст);
		
		Возврат;
	
	КонецЕсли;
	
	ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти
