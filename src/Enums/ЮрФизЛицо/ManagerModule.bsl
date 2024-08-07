#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// ИнтернетПоддержкаПользователей.СПАРКРиски

Функция ВидКонтрагентаСПАРКРиски(Контрагент) Экспорт
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Контрагент)) Тогда
		ЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ЮрФизЛицо");
	Иначе
		ЮрФизЛицо = Контрагент.ЮрФизЛицо;
	КонецЕсли;
	
	Если ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		Или ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
			ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ЮридическоеЛицо");
	ИначеЕсли ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель") Тогда
		ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ИндивидуальныйПредприниматель");
	Иначе
		ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ПустаяСсылка");
	КонецЕсли;
	
	Возврат ВидКонтрагента
		
КонецФункции

// Конец ИнтернетПоддержкаПользователей.СПАРКРиски

#КонецОбласти

#КонецЕсли
