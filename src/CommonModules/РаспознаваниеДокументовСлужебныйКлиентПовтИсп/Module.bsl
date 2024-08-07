#Область СлужебныеПроцедурыИФункции

Функция ПеречисленияТипВсеСсылки() Экспорт
	
	Возврат РаспознаваниеДокументовСлужебныйВызовСервераПовтИсп.ПеречисленияТипВсеСсылки();
	
КонецФункции

Функция ПолучитьИмяОткрываемойФормыПоТипу(ТипДокумента, ВариантОбработки) Экспорт
	
	Если ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.ТОРГ12")
		Или ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.УПД")
		Или ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.АктОбОказанииУслуг")
		Или ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетФактура") Тогда
		
		ИмяФормы = "Обработка.ТОРГ12РаспознаваниеДокументов.Форма";
		
	ИначеЕсли ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетНаОплату") Тогда
		ИмяФормы = "Обработка.СчетНаОплатуРаспознаваниеДокументов.Форма";
	Иначе
		
		Если ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.ПоступлениеТоваров")
			Или ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.РеализацияТоваров") Тогда 
			
			ИмяФормы = "Обработка.ТОРГ12РаспознаваниеДокументов.Форма";
			
		ИначеЕсли ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуПоставщика")
			Или ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуКлиента") Тогда
			
			ИмяФормы = "Обработка.СчетНаОплатуРаспознаваниеДокументов.Форма";
		Иначе
			ИмяФормы = "Документ.РаспознанныйДокумент.Форма.ФормаДокументаСОшибкой";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИмяФормы;
	
КонецФункции

Функция ТипДокументаПоВариантуОбработки(ВариантОбработки) Экспорт
	
	Если ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуКлиента")
		Или ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуПоставщика") Тогда 
		
		ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетНаОплату");
		
	Иначе
		ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.НеопознанныйДокумент");
	КонецЕсли;
	
	Возврат ТипДокумента;
	
КонецФункции

Функция НаправлениеПоВариантуОбработки(ВариантОбработки) Экспорт
	
	Если ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.ПоступлениеТоваров")
		Или ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуПоставщика") Тогда 
		
		Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Входящий");
		
	ИначеЕсли ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.РеализацияТоваров")
		Или ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуКлиента") Тогда
		
		Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Исходящий");
	Иначе
		Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Входящий");
	КонецЕсли;
	
	Возврат Направление;
	
КонецФункции

Функция ПолучитьСтавкуНДС(СтавкаНДС, ПрименяютсяСтавки4и2 = Ложь) Экспорт
	
	Возврат РаспознаваниеДокументовСлужебныйВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтавкаНДС, ПрименяютсяСтавки4и2);
	
КонецФункции

#КонецОбласти