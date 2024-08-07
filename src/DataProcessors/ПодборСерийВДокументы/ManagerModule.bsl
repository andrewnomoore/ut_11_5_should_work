#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаФормированияТаблицыДанныеРегистров(ВариантПолучениеДанныхИзРегистров, СкладИлиПодразделение = Неопределено) Экспорт
	
	Если ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка" Тогда
		
		Если СкладИлиПодразделение = Неопределено ИЛИ ТипЗнч(СкладИлиПодразделение) <> Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			
			// В накладной (или заказе) могут быть указаны любые незарезервированные серии
			// Из остатков серий нужно вычесть резервы серий.
			
			ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ДанныеРегистров.Серия КАК Серия,
			|	СУММА(ДанныеРегистров.СвободныйОстаток) КАК СвободныйОстаток
			|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
			|ИЗ
			|	(ВЫБРАТЬ
			|		ТоварыНаСкладахОстатки.Серия КАК Серия,
			|		ТоварыНаСкладахОстатки.ВНаличииОстаток КАК СвободныйОстаток
			|	ИЗ
			|		РегистрНакопления.ТоварыНаСкладах.Остатки(
			|				,
			|				Номенклатура = &Номенклатура
			|					И Характеристика = &Характеристика
			|					И (Назначение = &Назначение
			|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
			|					И Склад = &Склад) КАК ТоварыНаСкладахОстатки
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		ТоварыКОтгрузкеОстатки.Серия,
			|		-ТоварыКОтгрузкеОстатки.КОтгрузкеОстаток - ТоварыКОтгрузкеОстатки.ВРезервеОстаток
			|	ИЗ
			|		РегистрНакопления.ТоварыКОтгрузке.Остатки(
			|				,
			|				Номенклатура = &Номенклатура
			|					И Склад = &Склад
			|					И Характеристика = &Характеристика
			|					И (Назначение = &Назначение
			|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
			|					И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК ТоварыКОтгрузкеОстатки
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		ТоварыНаСкладах.Серия,
			|		ВЫБОР
			|			КОГДА ТоварыНаСкладах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|				ТОГДА -ТоварыНаСкладах.ВНаличии + ТоварыНаСкладах.КОтгрузке
			|			ИНАЧЕ ТоварыНаСкладах.ВНаличии - ТоварыНаСкладах.КОтгрузке
			|		КОНЕЦ
			|	ИЗ
			|		РегистрНакопления.ТоварыНаСкладах КАК ТоварыНаСкладах
			|	ГДЕ
			|		ТоварыНаСкладах.Номенклатура = &Номенклатура
			|		И ТоварыНаСкладах.Характеристика = &Характеристика
			|		И (ТоварыНаСкладах.Назначение = &Назначение
			|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
			|		И ТоварыНаСкладах.Склад = &Склад
			|		И ТоварыНаСкладах.Регистратор = &Регистратор
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		РезервыСерий.Серия,
			|		ВЫБОР
			|			КОГДА РезервыСерий.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|				ТОГДА РезервыСерий.КОтгрузке + РезервыСерий.ВРезерве
			|			ИНАЧЕ -РезервыСерий.КОтгрузке - РезервыСерий.ВРезерве
			|		КОНЕЦ
			|	ИЗ
			|		РегистрНакопления.ТоварыКОтгрузке КАК РезервыСерий
			|	ГДЕ
			|		РезервыСерий.Номенклатура = &Номенклатура
			|		И РезервыСерий.Характеристика = &Характеристика
			|		И (РезервыСерий.Назначение = &Назначение
			|						ИЛИ РезервыСерий.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
			|		И РезервыСерий.Склад = &Склад
			|		И РезервыСерий.Регистратор = &Регистратор
			|		И РезервыСерий.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК ДанныеРегистров
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеРегистров.Серия";
			
		КонецЕсли; 
		
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзЗаказа" Тогда
		
		// В накладной могут быть указаны только серии, указанные в заказе, по которым еще не выписаны накладные
		// Нужно взять остатки резервов серий по заказу.
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ  
		|	ДанныеРегистров.Серия КАК Серия,
		|	СУММА(ДанныеРегистров.СвободныйОстаток) КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыКОтгрузкеОстатки.Серия КАК Серия,
		|		ТоварыКОтгрузкеОстатки.КОформлениюОстаток КАК СвободныйОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке.Остатки(
		|				,
		|				Номенклатура = &Номенклатура
		|					И Склад = &Склад
		|					И Характеристика = &Характеристика
		|					И (Назначение = &Назначение
		|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|					И ДокументОтгрузки = &Распоряжение
		|					И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК ТоварыКОтгрузкеОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		РезервыСерий.Серия,
		|		ВЫБОР
		|			КОГДА РезервыСерий.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -РезервыСерий.КОформлению
		|			ИНАЧЕ РезервыСерий.КОформлению
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК РезервыСерий
		|	ГДЕ
		|		РезервыСерий.Номенклатура = &Номенклатура
		|		И РезервыСерий.Характеристика = &Характеристика
		|		И (РезервыСерий.Назначение = &Назначение
		|						ИЛИ РезервыСерий.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|		И РезервыСерий.Склад = &Склад
		|		И РезервыСерий.Регистратор = &Регистратор
		|		И РезервыСерий.ДокументОтгрузки = &Распоряжение
		|		И РезервыСерий.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК ДанныеРегистров
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистров.Серия";
		
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзОстатка" Тогда
		
		// В ордере могут быть указаны любые серии, которые есть на остатке (еще не указаны в других ордерах)
		// Также этот вариант можно использовать в документах по рознице.
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистров.Серия КАК Серия,
		|	СУММА(ДанныеРегистров.СвободныйОстаток) КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыНаСкладахОстатки.Серия КАК Серия,
		|		ТоварыНаСкладахОстатки.ВНаличииОстаток - ТоварыНаСкладахОстатки.КОтгрузкеОстаток КАК СвободныйОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыНаСкладах.Остатки(
		|				,
		|				Номенклатура = &Номенклатура
		|					И Характеристика = &Характеристика
		|					И (Назначение = &Назначение
		|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|					И Склад = &Склад
		|					И Помещение = &Помещение) КАК ТоварыНаСкладахОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыНаСкладах.Серия,
		|		ВЫБОР
		|			КОГДА ТоварыНаСкладах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -ТоварыНаСкладах.ВНаличии + ТоварыНаСкладах.КОтгрузке
		|			ИНАЧЕ ТоварыНаСкладах.ВНаличии - ТоварыНаСкладах.КОтгрузке
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыНаСкладах КАК ТоварыНаСкладах
		|	ГДЕ
		|		ТоварыНаСкладах.Номенклатура = &Номенклатура
		|		И ТоварыНаСкладах.Характеристика = &Характеристика
		|		И (ТоварыНаСкладах.Назначение = &Назначение
		|						ИЛИ ТоварыНаСкладах.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|		И ТоварыНаСкладах.Склад = &Склад
		|		И ТоварыНаСкладах.Помещение = &Помещение
		|		И ТоварыНаСкладах.Регистратор = &Регистратор) КАК ДанныеРегистров
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистров.Серия";
		
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзНакладной" Тогда
		
		// Если серии указываются в накладной, то в ордере можно указывать только те серии, которые есть в накладной
		// Информация из накладной в ордер о том, какие серии отгружать передается через регистр "ТоварыКОтгрузке",
		// в нем же фиксируется, что серия уже указана в ордере, поэтому для получения информации, какие серии в накладной
		// нужно использовать регистр "ТоварыКОтгрузке"
		// Накладная резервирует серии в целом по складу без учета помещений, но в ордере нельзя указать больше,
		// чем есть в помещении - поэтому нужно дополнительно анализировать регистр "ТоварыНаСкладах".
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистраТоварыКОтрузке.Серия КАК Серия,
		|	СУММА(ДанныеРегистраТоварыКОтрузке.СвободныйОстаток) КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистраТоварыКОтрузке
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыКОтгрузкеОстатки.Серия КАК Серия,
		|		ТоварыКОтгрузкеОстатки.КОтгрузкеОстаток - ТоварыКОтгрузкеОстатки.СобираетсяОстаток - ТоварыКОтгрузкеОстатки.СобраноОстаток КАК СвободныйОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке.Остатки(
		|				,
		|				ДокументОтгрузки = &Распоряжение
		|					И Характеристика = &Характеристика
		|					И Номенклатура = &Номенклатура
		|					И (Назначение = &Назначение
		|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|					И Склад = &Склад
		|					И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК ТоварыКОтгрузкеОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыКОтгрузке.Серия,
		|		ВЫБОР
		|			КОГДА ТоварыКОтгрузке.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -ТоварыКОтгрузке.КОтгрузке + ТоварыКОтгрузке.Собирается + ТоварыКОтгрузке.Собрано
		|			ИНАЧЕ ТоварыКОтгрузке.КОтгрузке - ТоварыКОтгрузке.Собирается - ТоварыКОтгрузке.Собрано
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК ТоварыКОтгрузке
		|	ГДЕ
		|		ТоварыКОтгрузке.Номенклатура = &Номенклатура
		|		И ТоварыКОтгрузке.Характеристика = &Характеристика
		|		И (ТоварыКОтгрузке.Назначение = &Назначение
		|						ИЛИ ТоварыКОтгрузке.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|		И ТоварыКОтгрузке.Склад = &Склад
		|		И ТоварыКОтгрузке.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|		И ТоварыКОтгрузке.Регистратор = &Регистратор
		|		И ТоварыКОтгрузке.ДокументОтгрузки = &Распоряжение) КАК ДанныеРегистраТоварыКОтрузке
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистраТоварыКОтрузке.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистраТоварыНаСкладах.Серия КАК Серия,
		|	СУММА(ДанныеРегистраТоварыНаСкладах.СвободныйОстаток) КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистраТоварыНаСкладах
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыНаСкладахОстатки.Серия КАК Серия,
		|		ТоварыНаСкладахОстатки.ВНаличииОстаток - ТоварыНаСкладахОстатки.КОтгрузкеОстаток КАК СвободныйОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыНаСкладах.Остатки(
		|				,
		|				Номенклатура = &Номенклатура
		|					И Характеристика = &Характеристика
		|					И (Назначение = &Назначение
		|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|					И Склад = &Склад
		|					И Помещение = &Помещение) КАК ТоварыНаСкладахОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыНаСкладах.Серия,
		|		ВЫБОР
		|			КОГДА ТоварыНаСкладах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -ТоварыНаСкладах.ВНаличии + ТоварыНаСкладах.КОтгрузке
		|			ИНАЧЕ ТоварыНаСкладах.ВНаличии - ТоварыНаСкладах.КОтгрузке
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыНаСкладах КАК ТоварыНаСкладах
		|	ГДЕ
		|		ТоварыНаСкладах.Номенклатура = &Номенклатура
		|		И ТоварыНаСкладах.Характеристика = &Характеристика
		|		И (ТоварыНаСкладах.Назначение = &Назначение
		|						ИЛИ ТоварыНаСкладах.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|		И ТоварыНаСкладах.Склад = &Склад
		|		И ТоварыНаСкладах.Помещение = &Помещение
		|		И ТоварыНаСкладах.Регистратор = &Регистратор) КАК ДанныеРегистраТоварыНаСкладах
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистраТоварыНаСкладах.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистраТоварыКОтрузке.Серия,
		|	ВЫБОР
		|		КОГДА ДанныеРегистраТоварыКОтрузке.СвободныйОстаток < ЕСТЬNULL(ДанныеРегистраТоварыНаСкладах.СвободныйОстаток, 0)
		|			ТОГДА ДанныеРегистраТоварыКОтрузке.СвободныйОстаток
		|		ИНАЧЕ ЕСТЬNULL(ДанныеРегистраТоварыНаСкладах.СвободныйОстаток, 0)
		|	КОНЕЦ КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
		|ИЗ
		|	ДанныеРегистраТоварыКОтрузке КАК ДанныеРегистраТоварыКОтрузке
		|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеРегистраТоварыНаСкладах КАК ДанныеРегистраТоварыНаСкладах
		|		ПО ДанныеРегистраТоварыКОтрузке.Серия = ДанныеРегистраТоварыНаСкладах.Серия";
		
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ТоварыВЯчейках" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистра.Серия КАК Серия,
		|	СУММА(ДанныеРегистра.СвободныйОстаток) КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыВЯчейкахОстатки.Серия КАК Серия,
		|		ТоварыВЯчейкахОстатки.ВНаличииОстаток - ТоварыВЯчейкахОстатки.КОтборуОстаток КАК СвободныйОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыВЯчейках.Остатки(
		|				,
		|				Ячейка = &Ячейка
		|					И Упаковка = &Упаковка
		|					И Характеристика = &Характеристика
		|					И (Назначение = &Назначение
		|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|					И Номенклатура = &Номенклатура) КАК ТоварыВЯчейкахОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыВЯчейках.Серия,
		|		ВЫБОР
		|			КОГДА ТоварыВЯчейках.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -ТоварыВЯчейках.ВНаличии + ТоварыВЯчейках.КОтбору
		|			ИНАЧЕ ТоварыВЯчейках.ВНаличии - ТоварыВЯчейках.КОтбору
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыВЯчейках КАК ТоварыВЯчейках
		|	ГДЕ
		|		ТоварыВЯчейках.Номенклатура = &Номенклатура
		|		И ТоварыВЯчейках.Характеристика = &Характеристика
		|		И (ТоварыВЯчейках.Назначение = &Назначение
		|						ИЛИ ТоварыВЯчейках.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|		И ТоварыВЯчейках.Упаковка = &Упаковка
		|		И ТоварыВЯчейках.Регистратор = &Регистратор
		|		И ТоварыВЯчейках.Ячейка = &Ячейка) КАК ДанныеРегистра
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистра.Серия";
		
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ТоварыКОформлениюПоступления" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистров.Серия КАК Серия,
		|	СУММА(ДанныеРегистров.СвободныйОстаток) КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыКОформлениюПоступленияОстатки.Серия КАК Серия,
		|		ТоварыКОформлениюПоступленияОстатки.КОформлениюПоступленийПоОрдерамОстаток КАК СвободныйОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыКПоступлению.Остатки(
		|				,
		|				Номенклатура = &Номенклатура
		|					И Склад = &Склад
		|					И Характеристика = &Характеристика
		|					И (Назначение = &Назначение
		|						ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|					И ДокументПоступления = &Распоряжение
		|					И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК ТоварыКОформлениюПоступленияОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыКОформлениюПоступления.Серия,
		|		ВЫБОР
		|			КОГДА ТоварыКОформлениюПоступления.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -ТоварыКОформлениюПоступления.КОформлениюПоступленийПоОрдерам
		|			ИНАЧЕ ТоварыКОформлениюПоступления.КОформлениюПоступленийПоОрдерам
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКПоступлению КАК ТоварыКОформлениюПоступления
		|	ГДЕ
		|		ТоварыКОформлениюПоступления.Номенклатура = &Номенклатура
		|		И ТоварыКОформлениюПоступления.Характеристика = &Характеристика
		|		И (ТоварыКОформлениюПоступления.Назначение = &Назначение
		|						ИЛИ ТоварыКОформлениюПоступления.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|							И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|		И ТоварыКОформлениюПоступления.Склад = &Склад
		|		И ТоварыКОформлениюПоступления.Регистратор = &Регистратор
		|		И ТоварыКОформлениюПоступления.ДокументПоступления = &Распоряжение
		|		И ТоварыКОформлениюПоступления.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|) КАК ДанныеРегистров
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистров.Серия";
		
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииПоОстаткамУХранителя"
		Или ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииПоОстаткамУКомиссионера" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Аналитики.КлючАналитики КАК Ссылка
		|ПОМЕСТИТЬ ВТАналитикиУчетаНоменклатуры
		|ИЗ
		|	РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитики
		|ГДЕ
		|	Номенклатура = &Номенклатура
		|	И Характеристика = &Характеристика
		|	И МестоХранения = &Склад
		|	И (Назначение = &Назначение
		|		ИЛИ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|			И НЕ ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).ДвиженияПоСкладскимРегистрам)
		|	И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|
		|;
		|
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеРегистров.Серия КАК Серия,
		|	СУММА(ДанныеРегистров.СвободныйОстаток) КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|		ТоварыОрганизацийОстатки.КоличествоОстаток КАК СвободныйОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыОрганизаций.Остатки(, АналитикаУчетаНоменклатуры В 
		|			(ВЫБРАТЬ
		|				Аналитика.Ссылка
		|			ИЗ
		|				ВТАналитикиУчетаНоменклатуры КАК Аналитика
		|			)
		|		) КАК ТоварыОрганизацийОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия,
		|		ВЫБОР
		|			КОГДА ТоварыОрганизацийОстатки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -ТоварыОрганизацийОстатки.Количество
		|			ИНАЧЕ ТоварыОрганизацийОстатки.Количество
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизацийОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТАналитикиУчетаНоменклатуры КАК Аналитика
		|		ПО ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
		|	ГДЕ
		|		НЕ Аналитика.Ссылка ЕСТЬ NULL
		|		И ТоварыОрганизацийОстатки.Регистратор = &Регистратор
		|		И ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|
		|	) КАК ДанныеРегистров
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистров.Серия";
	
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ТоварыНаСкладахБезУчетаНазначений" Тогда
		
		// Используется в СертификатыНоменклатуры.ФормаПодбораОбластиДействияСерия
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|		ТоварыНаСкладахОстатки.Серия КАК Серия,
		|		ТоварыНаСкладахОстатки.ВНаличииОстаток - ТоварыНаСкладахОстатки.КОтгрузкеОстаток КАК СвободныйОстаток
		|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
		|	ИЗ
		|		РегистрНакопления.ТоварыНаСкладах.Остатки(
		|				,
		|				Номенклатура = &Номенклатура
		|					И Характеристика = &Характеристика
		|					И Склад = &Склад
		|					И Помещение = &Помещение
		|					И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК ТоварыНаСкладахОстатки";
		
	//++ Локализация


	//-- Локализация
	ИначеЕсли ВариантПолучениеДанныхИзРегистров <> "ВсеСерииНоменклатуры" Тогда
		
		ВызватьИсключение НСтр("ru = 'Неподдерживаемый вариант получения данных по сериям.'");
		
	КонецЕсли;
	
	ЕстьПравоНаЧтениеДвиженийСерий = ПравоДоступа("Чтение",Метаданные.РегистрыНакопления.ДвиженияСерийТоваров);
	
	Если ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры" Тогда
		Если ЕстьПравоНаЧтениеДвиженийСерий Тогда
			ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ДвиженияСерийТоваров.Серия,
			|	0 КАК СвободныйОстаток
			|ПОМЕСТИТЬ ДанныеРегистров
			|ИЗ
			|	РегистрНакопления.ДвиженияСерийТоваров КАК ДвиженияСерийТоваров
			|ГДЕ
			|	ДвиженияСерийТоваров.Номенклатура = &Номенклатура
			|	И ДвиженияСерийТоваров.Характеристика = &Характеристика";
		Иначе
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
			|	0 КАК СвободныйОстаток
			|ПОМЕСТИТЬ ДанныеРегистров
			|ГДЕ
			|	ЛОЖЬ";
		КонецЕсли;
	Иначе
		
		ЧастиЗапроса = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекстЗапроса, "РегистрНакопления.");
		ЧастиЗапроса.Удалить(0);
		ПроверенныеРегистры = Новый Соответствие;
		Для Каждого ЧастьЗапроса Из ЧастиЗапроса Цикл
			ИмяРегистра = СтрРазделить(ЧастьЗапроса, "."+" "+Символы.ПС+Символы.НПП)[0];
			Если ПроверенныеРегистры[ИмяРегистра] = Неопределено Тогда
				ПроверенныеРегистры.Вставить(ИмяРегистра);
				Если Не ПравоДоступа("Чтение",Метаданные.РегистрыНакопления[ИмяРегистра]) Тогда
					ТекстЗапроса = 
					"ВЫБРАТЬ
					|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
					|	0 КАК СвободныйОстаток
					|ПОМЕСТИТЬ ДанныеРегистровДляЗапроса
					|ГДЕ
					|	ЛОЖЬ";
					
					Прервать;
					
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	
		ТекстЗапроса = ТекстЗапроса + "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		Если ЕстьПравоНаЧтениеДвиженийСерий Тогда
			
			ТекстЗапроса = ТекстЗапроса + 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ДвиженияСерийТоваров.Серия
			|ПОМЕСТИТЬ ВсеСерии
			|ИЗ
			|	РегистрНакопления.ДвиженияСерийТоваров КАК ДвиженияСерийТоваров
			|ГДЕ
			|	ДвиженияСерийТоваров.Номенклатура = &Номенклатура
			|	И ДвиженияСерийТоваров.Характеристика = &Характеристика
			|	И &ВсеСерии
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВложенныйЗапрос.Серия КАК Серия,
			|	СУММА(ВложенныйЗапрос.СвободныйОстаток) КАК СвободныйОстаток
			|ПОМЕСТИТЬ ДанныеРегистров
			|ИЗ
			|	(ВЫБРАТЬ
			|		ДвиженияСерийТоваров.Серия КАК Серия,
			|		0 КАК СвободныйОстаток
			|	ИЗ
			|		ВсеСерии КАК ДвиженияСерийТоваров
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		ДанныеРегистровДляЗапроса.Серия,
			|		ДанныеРегистровДляЗапроса.СвободныйОстаток
			|	ИЗ
			|		ДанныеРегистровДляЗапроса КАК ДанныеРегистровДляЗапроса) КАК ВложенныйЗапрос
			|
			|СГРУППИРОВАТЬ ПО
			|	ВложенныйЗапрос.Серия";
		Иначе
			ТекстЗапроса = ТекстЗапроса + 
			"ВЫБРАТЬ
			|	ДанныеРегистровДляЗапроса.Серия,
			|	ДанныеРегистровДляЗапроса.СвободныйОстаток
			|ПОМЕСТИТЬ ДанныеРегистров
			|ИЗ
			|	ДанныеРегистровДляЗапроса КАК ДанныеРегистровДляЗапроса";
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ЕстьПраваНаЧтениеДанныхРегистров(ВариантПолучениеДанныхИзРегистров, СкладИлиПодразделение) Экспорт
	
	ТекстЗапроса = ТекстЗапросаФормированияТаблицыДанныеРегистров(ВариантПолучениеДанныхИзРегистров, СкладИлиПодразделение);
	ЕстьПраваНаЧтениеДанныхРегистров = СтрНайти(ТекстЗапроса,"РегистрНакопления.") <> 0
		И ПравоДоступа("Чтение",Метаданные.РегистрыНакопления.ДвиженияСерийТоваров);
	
	Возврат ЕстьПраваНаЧтениеДанныхРегистров;
	
КонецФункции

Функция ВариантПолучениеДанныхИзРегистровПоПараметрамФормы(ПараметрыУказанияСерий, Распоряжение, Склад, ВидНоменклатуры) Экспорт
	
	ПараметрыУчетнойПолитикиСерий = Новый ФиксированнаяСтруктура(Справочники.ВидыНоменклатуры.НастройкиИспользованияСерий(
																											ВидНоменклатуры,
																											ПараметрыУказанияСерий,
																											Новый Структура("Склад", Склад)));
	
	Если ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ОтгрузкаВРозницу) <> Неопределено Тогда
		// Эта форма из расходных ордеров не отрывается, поэтому эта складская операция может быть только 
		// в ОтчетеОРозничныхПродажах, ЧекеККМ и ВводеОстатков.
		
		Если ПараметрыУчетнойПолитикиСерий.УчитыватьОстаткиСерий Тогда	
			ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка";
		Иначе
			ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		КонецЕсли;
	ИначеЕсли ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ВводОстатков) <> Неопределено Тогда
		
		ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		
	ИначеЕсли ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ПриемкаПоВозвратуОтКлиента) <> Неопределено
		И ПараметрыУказанияСерий.ПолноеИмяОбъекта <> Метаданные.Документы.ПоступлениеТоваровОтХранителя.Имя Тогда
		
		ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		
	ИначеЕсли ПараметрыУказанияСерий.ИмяПоляСкладОтправитель <> Неопределено
			И ПараметрыУказанияСерий.ИмяПоляСкладПолучатель <> Неопределено Тогда //это перемещение товаров
		
		Если ПараметрыУчетнойПолитикиСерий.УчитыватьОстаткиСерий Тогда
			Если ПараметрыУчетнойПолитикиСерий.УказыватьПриПланированииОтгрузки 
				И ЗначениеЗаполнено(Распоряжение) Тогда
				ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзЗаказа";
			Иначе
				ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка";
			КонецЕсли;
		Иначе
			ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		КонецЕсли;
		
	ИначеЕсли ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ВозвратНепринятыхТоваров) <> Неопределено Тогда
		ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		
	ИначеЕсли ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ПеремещениеТМЦВЭксплуатации) <> Неопределено
		ИЛИ ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ОприходованиеТМЦВЭксплуатации) <> Неопределено
		ИЛИ ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ИнвентаризацияТМЦВЭксплуатации) <> Неопределено Тогда
		
		ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзОстаткаТМЦВЭксплуатации";
		
	ИначеЕсли Распоряжение <> Неопределено
		И Перечисления.СкладскиеОперации.ЕстьПриемка(ПараметрыУказанияСерий.СкладскиеОперации) Тогда
		
		ЭтоРаспоряжениеНаПоступление = Истина;
		Если ЭтоРаспоряжениеНаПоступление
			И СкладыСервер.ИспользоватьОрдернуюСхемуПриПоступлении(Склад,ПараметрыУказанияСерий.Дата)
			И ПараметрыУчетнойПолитикиСерий.УчитыватьСебестоимостьПоСериям Тогда
			ВариантПолучениеДанныхИзРегистров = "ТоварыКОформлениюПоступления";
		Иначе
			ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		КонецЕсли;
		
	ИначеЕсли ПараметрыУказанияСерий.ПолноеИмяОбъекта = Метаданные.Документы.ВыкупТоваровХранителем
		Или (ПараметрыУказанияСерий.ПолноеИмяОбъекта = Метаданные.Документы.ПоступлениеТоваровОтХранителя.ПолноеИмя()
			И ПараметрыУказанияСерий.ОперацияДокумента = Перечисления.ХозяйственныеОперации.ВозвратОтХранителя)
		Или (ПараметрыУказанияСерий.ПолноеИмяОбъекта = Метаданные.Документы.ОтчетОСписанииТоваровУХранителя.ПолноеИмя()
			И ПараметрыУказанияСерий.ОперацияДокумента = Перечисления.ХозяйственныеОперации.СписаниеНедостачЗаСчетПоклажедателя)  Тогда
		
		ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииПоОстаткамУХранителя";
		
	ИначеЕсли ПараметрыУказанияСерий.ПолноеИмяОбъекта = Метаданные.Документы.ОтчетКомиссионера.ПолноеИмя()
		Или (ПараметрыУказанияСерий.ПолноеИмяОбъекта = Метаданные.Документы.ПоступлениеТоваровОтХранителя.ПолноеИмя()
			И ПараметрыУказанияСерий.ОперацияДокумента = Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера)
		Или (ПараметрыУказанияСерий.ПолноеИмяОбъекта = Метаданные.Документы.ОтчетОСписанииТоваровУХранителя.ПолноеИмя()
			И ПараметрыУказанияСерий.ОперацияДокумента = Перечисления.ХозяйственныеОперации.СписаниеНедостачЗаСчетКомитента) Тогда
		
		ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииПоОстаткамУКомиссионера";
		
	ИначеЕсли ПараметрыУказанияСерий.ЭтоЗаказ
		Или (ПараметрыУказанияСерий.ЭтоНакладная
		И (Не ЗначениеЗаполнено(Распоряжение)
		Или Не ПараметрыУчетнойПолитикиСерий.УказыватьПриПланированииОтгрузки))
		И ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ВводОстатков) = Неопределено 
		И ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ПриемкаПоВозвратуОтКлиента) = Неопределено 
		И ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ПустаяСсылка()) = Неопределено Тогда
		
		Если ПараметрыУчетнойПолитикиСерий.УчитыватьОстаткиСерий
			И Не Перечисления.СкладскиеОперации.ЕстьПриемка(ПараметрыУказанияСерий.СкладскиеОперации) Тогда
			ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка";
		Иначе
			ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		КонецЕсли;
		
	ИначеЕсли ПараметрыУказанияСерий.ЭтоНакладная
		И ЗначениеЗаполнено(Распоряжение) Тогда
		
		Если ПараметрыУчетнойПолитикиСерий.УчитыватьОстаткиСерий
			И ПараметрыУчетнойПолитикиСерий.УказыватьПриПланированииОтгрузки Тогда
			Если Не ПродажиСервер.ИспользоватьЗаказКлиентаКакСчет(Распоряжение) Тогда
				ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзЗаказа";
			Иначе
				ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка";
			КонецЕсли;
		Иначе
			ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		КонецЕсли;
		
	Иначе
		Если ПараметрыУчетнойПолитикиСерий.УчитыватьОстаткиСерий
			И ПараметрыУказанияСерий.ПолноеИмяОбъекта <> Метаданные.Документы.ПередачаТоваровМеждуОрганизациями.ПолноеИмя() Тогда
			Если ПараметрыУказанияСерий.ЭтоОрдер Тогда
				Если ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ПеремещениеМеждуПомещениями) <> Неопределено
					Или Не ПараметрыУчетнойПолитикиСерий.УказыватьПриПланированииОтгрузки
					Или Не ЗначениеЗаполнено(Распоряжение) Тогда
					ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзОстатка";
				Иначе
					ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзНакладной";
				КонецЕсли;
			ИначеЕсли ПараметрыУказанияСерий.ПолноеИмяОбъекта <> "Документ.ВыкупПринятыхНаХранениеТоваров"
				Тогда
				
				ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка";
			Иначе
				ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
			КонецЕсли;
		Иначе
			ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры";
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВариантПолучениеДанныхИзРегистров;
	
КонецФункции

Функция ЗаголовкиПоВариантуПолучениеДанныхИзРегистров(ВариантПолучениеДанныхИзРегистров) Экспорт
	
	Если ВариантПолучениеДанныхИзРегистров = "ТоварыКОформлениюПоступления" Тогда
		ЗаголовокКнопки            = НСтр("ru = 'К оформлению поступления'");
		ЗаголовокСвободногоОстатка = НСтр("ru = 'Остаток по распоряжению, %ЕдиницаИзмерения%'");
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка"
		Или ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзОстатка" Тогда
		ЗаголовокКнопки            = НСтр("ru = 'Свободные остатки'");
		ЗаголовокСвободногоОстатка = НСтр("ru = 'Свободный остаток, %ЕдиницаИзмерения%'");
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзЗаказа" Тогда
		ЗаголовокКнопки = НСтр("ru = 'Остатки по заказу'");
		ЗаголовокСвободногоОстатка = НСтр("ru = 'Остаток по заказу, %ЕдиницаИзмерения%'");
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииПоОстаткамУХранителя" Тогда
		ЗаголовокКнопки            = НСтр("ru = 'Переданные хранителю'");
		ЗаголовокСвободногоОстатка = НСтр("ru = 'Переданные хранителю, %ЕдиницаИзмерения%'");
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииПоОстаткамУКомиссионера" Тогда
		ЗаголовокКнопки            = НСтр("ru = 'У комиссионера'");
		ЗаголовокСвободногоОстатка = НСтр("ru = 'У комиссионера, %ЕдиницаИзмерения%'");
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзНакладной" Тогда
		ЗаголовокКнопки = НСтр("ru = 'Остатки по распоряжению'");
		ЗаголовокСвободногоОстатка = НСтр("ru = 'Остаток по распоряжению, %ЕдиницаИзмерения%'");
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ВсеСерииНоменклатуры" Тогда
		ЗаголовокКнопки = "";
		ЗаголовокСвободногоОстатка = "";
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзОстаткаТМЦВЭксплуатации" Тогда
		ЗаголовокКнопки = НСтр("ru = 'В эксплуатации'");
		ЗаголовокСвободногоОстатка = НСтр("ru = 'В эксплуатации, %ЕдиницаИзмерения%'");
	КонецЕсли;

	Результат = Новый Структура;
	Результат.Вставить("ЗаголовокКнопки", ЗаголовокКнопки);
	Результат.Вставить("ЗаголовокСвободногоОстатка", ЗаголовокСвободногоОстатка);
	
	Возврат Результат;
	
КонецФункции

Функция РаспоряжениеПоПараметрамФормы(ПараметрыФормы) Экспорт
	
	Если ПараметрыФормы.ЗначенияПолейДляОпределенияРаспоряжения.Количество() > 0 Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПараметрыФормы.ПараметрыУказанияСерий.ПолноеИмяОбъекта);
		Распоряжение = МенеджерОбъекта.РаспоряжениеНаВыполнениеСкладскойОперации(ПараметрыФормы.ЗначенияПолейДляОпределенияРаспоряжения);
	Иначе
		Распоряжение = Неопределено;
	КонецЕсли;
	
	Возврат Распоряжение;
	
КонецФункции

Функция ТекстЗапросаРеквизитыСерий(ИмяТаблицы, НастройкиИспользованияСерий, ДляПолейГруппировки = Ложь, ЗначенияРеквизитовБратьИзСсылки = Истина) Экспорт
	
	Если ЗначенияРеквизитовБратьИзСсылки Тогда
		ШаблонВыборкиРеквизита = "	ТаблицаСерий.Серия.%ИмяРеквизита% КАК %ИмяРеквизита%";
	Иначе
		ШаблонВыборкиРеквизита = "	ТаблицаСерий.%ИмяРеквизита% КАК %ИмяРеквизита%";
	КонецЕсли;
	
	МассивТекстов = Новый Массив;
	
	Для Каждого Описание Из НастройкиИспользованияСерий.ОписанияИспользованияРеквизитовСерии Цикл
		
		Если ДляПолейГруппировки Тогда
			ТекстРеквизита = СтрЗаменить(ШаблонВыборкиРеквизита, "КАК %ИмяРеквизита%", "");
		Иначе
			ТекстРеквизита = ШаблонВыборкиРеквизита;
		КонецЕсли;
		
		ТекстРеквизита = СтрЗаменить(ТекстРеквизита, "%ИмяРеквизита%", Описание.ИмяРеквизита);
		
		МассивТекстов.Добавить(ТекстРеквизита);
		
		Если Описание.ИмяРеквизита = "RFIDTID" Тогда
			
			Если ЗначенияРеквизитовБратьИзСсылки Тогда
				ТекстРеквизита = "	ТаблицаСерий.Серия.RFIDTID <> """" КАК ЗаполненRFIDTID";
			Иначе
				ТекстРеквизита = "	ТаблицаСерий.RFIDTID <> """" КАК ЗаполненRFIDTID";
			КонецЕсли;
			
			Если ДляПолейГруппировки Тогда
				ТекстРеквизита = СтрЗаменить(ТекстРеквизита, "КАК ЗаполненRFIDTID", "");
			КонецЕсли;
			МассивТекстов.Добавить(ТекстРеквизита);
			
			Если ЗначенияРеквизитовБратьИзСсылки Тогда
				ТекстРеквизита = 
				"	ВЫБОР
				|		КОГДА ТаблицаСерий.Серия.RFIDTID <> """"
				|			ТОГДА 2
				|		ИНАЧЕ 0
				|	КОНЕЦ КАК СтатусРаботыRFID"; 
			Иначе
				ТекстРеквизита = 
				"	ВЫБОР
				|		КОГДА ТаблицаСерий.RFIDTID <> """"
				|			ТОГДА 2
				|		ИНАЧЕ 0
				|	КОНЕЦ КАК СтатусРаботыRFID"; 
			КонецЕсли;
			
			Если ДляПолейГруппировки Тогда
				ТекстРеквизита = СтрЗаменить(ТекстРеквизита, "КАК СтатусРаботыRFID", "");
			КонецЕсли;
			МассивТекстов.Добавить(ТекстРеквизита);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапросаРеквизитыСерий = СтрСоединить(МассивТекстов, "," + Символы.ПС);
	
	ТекстЗапросаРеквизитыСерий = СтрЗаменить(ТекстЗапросаРеквизитыСерий, "ТаблицаСерий", ИмяТаблицы);
	
	Возврат ТекстЗапросаРеквизитыСерий;
	
КонецФункции

Функция НазванияЭлементовСерий(ИмяРеквизита) Экспорт
	
	СтруктураВозврата = Новый Структура("Серии, ОстаткиСерий");
	
	Если ИмяРеквизита = "Номер" Тогда
		СтруктураВозврата.Серии = "СерииНомер";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийНомер";
	ИначеЕсли ИмяРеквизита = "ДатаПроизводства" Тогда
		СтруктураВозврата.Серии = "СерииДатаПроизводства";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийДатаПроизводства";
	ИначеЕсли ИмяРеквизита = "ГоденДо" Тогда
		СтруктураВозврата.Серии = "СерииГоденДо";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийГоденДо";
	ИначеЕсли ВРег(ИмяРеквизита) = ВРег("НомерКИЗГИСМ") Тогда
		СтруктураВозврата.Серии = "СерииНомерКИЗГИСМ";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийНомерКИЗГИСМ";
	ИначеЕсли ИмяРеквизита = "ПроизводительЕГАИС" Тогда
		СтруктураВозврата.Серии = "СерииПроизводительЕГАИС";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийПроизводительЕГАИС";
	ИначеЕсли ИмяРеквизита = "Справка2ЕГАИС" Тогда
		СтруктураВозврата.Серии = "СерииСправка2ЕГАИС";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийСправка2ЕГАИС";
	ИначеЕсли ИмяРеквизита = "ПроизводительВЕТИС" Тогда
		СтруктураВозврата.Серии = "СерииПроизводительВЕТИС";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийПроизводительВЕТИС";
	ИначеЕсли ИмяРеквизита = "ЗаписьСкладскогоЖурналаВЕТИС" Тогда
		СтруктураВозврата.Серии = "СерииЗаписьСкладскогоЖурналаВЕТИС";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийЗаписьСкладскогоЖурналаВЕТИС";
	ИначеЕсли ИмяРеквизита = "ИдентификаторПартииВЕТИС" Тогда
		СтруктураВозврата.Серии = "СерииИдентификаторПартииВЕТИС";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийИдентификаторПартииВЕТИС";
	ИначеЕсли ИмяРеквизита = "МаксимальнаяРозничнаяЦенаМОТП" Тогда
		СтруктураВозврата.Серии = "СерииМаксимальнаяРозничнаяЦенаМОТП";
		СтруктураВозврата.ОстаткиСерий = "ОстаткиСерийМаксимальнаяРозничнаяЦенаМОТП";
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#КонецЕсли
