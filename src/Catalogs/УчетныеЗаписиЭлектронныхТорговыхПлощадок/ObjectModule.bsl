#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Не ПометкаУдаления Тогда

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УчетныеЗаписиЭТП.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектронныхТорговыхПлощадок КАК УчетныеЗаписиЭТП
		|ГДЕ
		|	УчетныеЗаписиЭТП.Ссылка <> &Ссылка
		|	И УчетныеЗаписиЭТП.ВидЭТП = &ВидЭТП
		|	И УчетныеЗаписиЭТП.Организация = &Организация
		|	И НЕ УчетныеЗаписиЭТП.ПометкаУдаления";

		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ВидЭТП", ВидЭТП);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);

		УстановитьПривилегированныйРежим(Истина);
		РезультатЗапроса = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);

		Если Не РезультатЗапроса.Пустой() Тогда

			ТекстОшибки = НСтр(
				"ru='Для организации ""%1"" уже существует активная учетная запись. Создание новой учетной записи невозможно.'");
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстОшибки, Строка(Организация)), , , , Отказ);

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли