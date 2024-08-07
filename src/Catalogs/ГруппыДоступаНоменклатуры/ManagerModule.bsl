#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет, используются или нет группы доступа номенклатуры.
//
//	Возвращаемое значение:
//		Булево - если ИСТИНА, значит группы доступа используются.
//
Функция ИспользуютсяГруппыДоступа() Экспорт
	
	Возврат
		ПолучитьФункциональнуюОпцию("ОграничиватьДоступНаУровнеЗаписей")
		И ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаНоменклатуры");
	
КонецФункции

// Функция определяет, есть ли у текущего пользователя право изменять номенклатуру.
//
// Параметры:
//  Объект	 - ДанныеФормыКоллекция, СправочникОбъект	 - любая коллекция с полями:
//  	*ГруппаДоступа - СправочникСсылка.ГруппыДоступаНоменклатуры - группа доступа объекта
//  	*Ссылка - СправочникСсылка - ссылка на справочник, к которому возможно ограничение доступа по группе доступа номенклатуры.
// 
// Возвращаемое значение:
//  Булево - если ИСТИНА, значит право изменения есть.
//
Функция ЕстьПравоИзменения(Объект) Экспорт
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат Истина;
	ИначеЕсли Не ПравоДоступа("Изменение", Метаданные.НайтиПоТипу(ТипЗнч(Объект.Ссылка))) Тогда
		Возврат Ложь;
	ИначеЕсли Не ИспользуютсяГруппыДоступа() Тогда
		Возврат Истина;
	ИначеЕсли Не ЗначениеЗаполнено(Объект.ГруппаДоступа) Тогда
		Возврат Истина;
	КонецЕсли;
	
	МассивГруппДоступа =
		УправлениеДоступом.ГруппыЗначенийДоступаРазрешающиеИзменениеЗначенийДоступа(ТипЗнч(Объект.Ссылка), Истина);
	
	Возврат МассивГруппДоступа.Найти(Объект.ГруппаДоступа) <> Неопределено;
	
КонецФункции

// Функция возвращает группу доступа номенклатуры по умолчанию для текущего пользователя.
//
// Параметры:
//  Объект	 - ДанныеФормыКоллекция, СправочникОбъект	 - любая коллекция с полями:
//  	*ГруппаДоступа - СправочникСсылка.ГруппыДоступаНоменклатуры - группа доступа объекта
//  	*Ссылка - СправочникСсылка - ссылка на справочник, к которому возможно ограничение доступа по группе доступа номенклатуры.
// 
// Возвращаемое значение:
//  СправочникСсылка.ГруппыДоступаНоменклатуры - группа доступа по умолчанию.
//
Функция ПолучитьГруппуДоступаПоУмолчанию(Объект) Экспорт
	
	ГруппаДоступаПоУмолчанию = Справочники.ГруппыДоступаНоменклатуры.ПустаяСсылка();
	
	МассивГруппДоступа =
		УправлениеДоступом.ГруппыЗначенийДоступаРазрешающиеИзменениеЗначенийДоступа(ТипЗнч(Объект.Ссылка), Истина);
	
	Если ЗначениеЗаполнено(Объект.ГруппаДоступа) Тогда
		Если МассивГруппДоступа.Найти(Объект.ГруппаДоступа) <> Неопределено Тогда
			ГруппаДоступаПоУмолчанию = Объект.ГруппаДоступа;
		КонецЕсли;
	ИначеЕсли МассивГруппДоступа.Количество() = 1 Тогда
		ГруппаДоступаПоУмолчанию = МассивГруппДоступа[0];
	КонецЕсли;
	
	Возврат ГруппаДоступаПоУмолчанию;
	
КонецФункции

#КонецОбласти

#КонецЕсли
