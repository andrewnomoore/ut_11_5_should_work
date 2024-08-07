#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КодФормы = "Справочник_Номенклатура_ФормаСписка";
	
	ПодборТоваровСервер.ПриСозданииНаСервере(ЭтаФорма);
	
	ДоступенВводБезКонтроля = Справочники.Номенклатура.ДоступенВводБезКонтроля();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ЕстьПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.Справочники.Номенклатура);
	
	Элементы.КоманднаяПанельСписокСтандартныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры) Тогда
		Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатураФормаПоискПоШтрихкоду.Видимость = Ложь;
		Элементы.КоманднаяПанельСписокСтандартныйПоискНоменклатураФормаПоискПоШтрихкоду.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НоменклатураФильтраПоСвойствам) Тогда
		ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтаФорма, Параметры.НоменклатураФильтраПоСвойствам);
	КонецЕсли;
	
	ПанельКомандПечати = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.ПодменюПечатьСписокРасширенный,
		Элементы.ПодменюПечатьСписокСтандартный);
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
											Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатура,
											Элементы.СписокСтандартныйПоискНоменклатураКоманднаяПанель);
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, ПанельКомандПечати);
	// Конец ИнтеграцияС1СДокументооборотом
	
	Если ПраваПользователяПовтИсп.ЭтоПартнер() Тогда
		Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатураФормаПоискПоШтрихкоду.Видимость = Ложь;
		Элементы.КоманднаяПанельСписокСтандартныйПоискНоменклатураФормаПоискПоШтрихкоду.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.СписокРасширенныйПоискНоменклатураКонтекстноеМенюИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.КоманднаяПанельСписокСтандартныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.СписокСтандартныйПоискНоменклатураКонтекстноеМенюИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.ИерархияНоменклатурыКонтекстноеМенюИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	
	Параметры.Свойство("ТекущаяСтрока", НоменклатураЭлементПриОткрытии);
	
	Если ЗначениеЗаполнено(НоменклатураЭлементПриОткрытии)
		И ИспользоватьФильтры Тогда
		Если ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии") Тогда
			НоменклатураРодительПриОткрытии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоменклатураЭлементПриОткрытии, "Родитель");
		ИначеЕсли ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоСвойствам")
			Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам")
			Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам") Тогда
			ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоменклатураЭлементПриОткрытии, "ВидНоменклатуры");
			ВидНоменклатурыПриИзмененииНаСервере();
			ВидНоменклатурыПриОткрытии = ВидНоменклатуры;
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("ОтборПоВидуНоменклатуры") Тогда
		ВидНоменклатурыПриОткрытии = ВидНоменклатуры;
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	Если РаботаСНоменклатурой.ПравоИзмененияДанных() Тогда 
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ОсновнаяТаблица = СписокНоменклатура.ОсновнаяТаблица;
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		РаботаСНоменклатуройУТ.ПолучитьДополненныйЗапросДинамическогоСписка(СвойстваСписка.ТекстЗапроса);
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокРасширенныйПоискНоменклатура,	СвойстваСписка);
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокСтандартныйПоискНоменклатура,	СвойстваСписка);
		
		КП = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
						Элементы.ГруппаКомандыСписокРасширенныйПоискНоменклатура, Элементы.СписокСтандартныйПоискНоменклатура.КоманднаяПанель);
		ДС = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
				Элементы.СписокРасширенныйПоискНоменклатура, Элементы.СписокСтандартныйПоискНоменклатура);
				
		РаботаСНоменклатурой.ПриСозданииНаСервереФормаСпискаНоменклатуры(ЭтотОбъект, КП, ДС, Истина);
		
	КонецЕсли;
	
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, ,"СписокНоменклатура");
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Установим позиционирование на выбранный элемент номенклатуры в форме, вызвавшей открытие этой формы выбора.
	Если ЗначениеЗаполнено(НоменклатураЭлементПриОткрытии) Тогда
		Если ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии") Тогда
			Элементы.ИерархияНоменклатуры.ТекущаяСтрока = НоменклатураРодительПриОткрытии;
			ПодборТоваровКлиент.ОбработчикАктивизацииСтрокиИерархииНоменклатуры(ЭтаФорма);
		КонецЕсли;
		ТаблицаФормыНоменклатура = Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма)]; // ТаблицаФормы
		ТаблицаФормыНоменклатура.ТекущаяСтрока = НоменклатураЭлементПриОткрытии;
		Элементы.ВидыНоменклатуры.ТекущаяСтрока = ВидНоменклатурыПриОткрытии;
	ИначеЕсли ЗначениеЗаполнено(ВидНоменклатурыПриОткрытии) Тогда
		Элементы.ВидыНоменклатуры.ТекущаяСтрока = ВидНоменклатурыПриОткрытии;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройкиФормыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	Если ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().ЗагрузкаНоменклатуры Тогда
		Если Параметр.СозданныеОбъекты.Количество() > 0 Тогда
			
			ТекущийСписок = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
				Элементы.СписокРасширенныйПоискНоменклатура, Элементы.СписокСтандартныйПоискНоменклатура);
				
			ТекущийСписок.ТекущаяСтрока = Параметр.СозданныеОбъекты[0].Номенклатура;
			
		КонецЕсли;
	ИначеЕсли ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().СопоставлениеНоменклатуры Тогда	
		
		ТекущийСписок = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
			Элементы.СписокРасширенныйПоискНоменклатура, Элементы.СписокСтандартныйПоискНоменклатура);
			
		ТекущийСписок.Обновить();
		
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	Если ИмяСобытия = "Запись_Номенклатура" Тогда
		Если ЗначениеЗаполнено(СтрокаПоискаНоменклатура) Тогда
			ВыполнитьПоискНоменклатуры();
		КонецЕсли;
		Если ЗначениеЗаполнено(Источник) Тогда
			ТаблицаФормыНоменклатура = Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма)]; // ТаблицаФормы
			ТаблицаФормыНоменклатура.ТекущаяСтрока = Источник;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "ФильтрПоАналогичнымСвойствам_Номенклатура" Тогда
		Если ЗначениеЗаполнено(Параметр) Тогда
			ОтфильтроватьПоАналогичнымСвойствам(Параметр);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОбработчикиСобытийСтрокПоиска

&НаКлиенте
Процедура СтрокаПоискаНоменклатураПриИзменении(Элемент)
	
	ВыполнитьПоискНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаНоменклатураОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаПоискаНоменклатура = "";
	
	СнятьОтборПоСтрокеПоискаНоменклатурыНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФлаговТочногоСоответствия

&НаКлиенте
Процедура НайтиНоменклатуруПоТочномуСоответствиюПриИзменении(Элемент)
	
	ВыполнитьПоискНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура СегментНоменклатурыПриИзменении(Элемент)
	
	СегментНоменклатурыПриИзмененииНаСервере();
	
	Если ЗначениеЗаполнено(СтрокаПоискаНоменклатура) Тогда
		ВыполнитьПоискНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ВидНоменклатурыПриИзмененииНаСервере();
	
	Если ЗначениеЗаполнено(СтрокаПоискаНоменклатура) Тогда
		ВыполнитьПоискНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФильтрыПриИзменении(Элемент)
	
	ИспользоватьФильтрыПриИзмененииНаСервере();
	
	Если ЗначениеЗаполнено(СтрокаПоискаНоменклатура) Тогда
		ВыполнитьПоискНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураИсходногоКачестваПриИзменении(Элемент)
	
	НоменклатураИсходногоКачестваПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование И Не Группа Тогда
		
		Отказ = Истина;
		
		ПараметрыСозданияВФорму = Новый Структура("Родитель, ВидНоменклатуры,  АдресТаблицыПараметров, АдресТаблицыСопоставления");
		
		Если ИспользоватьФильтры Тогда
			
			Если ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам")
				Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоСвойствам") Тогда
				
				Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
					
					СтруктураАдресовТаблиц = АдресТаблицПараметровДереваОтборовНаСервере();
					
					ПараметрыСозданияВФорму.АдресТаблицыПараметров = СтруктураАдресовТаблиц.АдресТаблицыПараметров;
					ПараметрыСозданияВФорму.АдресТаблицыСопоставления = СтруктураАдресовТаблиц.АдресТаблицыСопоставления;
					
					ПараметрыСозданияВФорму.ВидНоменклатуры = ВидНоменклатуры;
					
				КонецЕсли;
			ИначеЕсли ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам") Тогда
				Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
					ПараметрыСозданияВФорму.ВидНоменклатуры = ВидНоменклатуры;
				КонецЕсли;
			Иначе
				
				ПараметрыСозданияВФорму.Родитель = ?(Элементы.ИерархияНоменклатуры.ТекущиеДанные = Неопределено, ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"),
				Элементы.ИерархияНоменклатуры.ТекущиеДанные.Ссылка);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", Новый Структура("ДополнительныеПараметры", ПараметрыСозданияВФорму), ЭтаФорма);
	
	ИначеЕсли Группа Тогда
		
		ТекущиеДанные = Элементы.ИерархияНоменклатуры.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда
			
			Отказ = Истина;
			
			ПараметрыСозданияВФорму = Новый Структура("Родитель", ТекущиеДанные.Ссылка);
			ОткрытьФорму("Справочник.Номенклатура.ФормаГруппы", Новый Структура("ДополнительныеПараметры", ПараметрыСозданияВФорму), ЭтаФорма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодборТоваровКлиент.ПриАктивизацииСтрокиСпискаНоменклатуры(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОтборов

&НаКлиенте
Процедура ДеревоОтборовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПодборТоваровКлиент.ДеревоОтборовВыбор(ЭтаФорма, Новый ОписаниеОповещения("ДеревоОтборовПриИзмененииЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтборовПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат Тогда
		ПодборТоваровКлиент.ДеревоОтборовПриИзмененииЗавершение(ЭтаФорма);
		
		ДеревоОтборовОтборПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтборовОтборПриИзменении(Элемент)
	
	ПодборТоваровКлиент.ДеревоОтборовОтборПриИзменении(ЭтаФорма, Новый ОписаниеОповещения("ДеревоОтборовПриИзмененииЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыНоменклатуры

&НаКлиенте
Процедура ВидыНоменклатурыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
	 	СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидыНоменклатурыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		СтандартнаяОбработка = Ложь;
		ВидыНоменклатурыПеретаскиваниеНаСервере(ПараметрыПеретаскивания.Значение, СтандартнаяОбработка, Строка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВидыНоменклатурыПеретаскиваниеНаСервере(МассивНоменклатур, СтандартнаяОбработка, ВидНоменклатуры)
	
	ОбновитьСписок = Ложь;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "ЭтоГруппа") Тогда
		СтандартнаяОбработка = Ложь;
	Иначе
		Для Каждого Номенклатура Из МассивНоменклатур Цикл
			НоменклатураОбъект = Номенклатура.ПолучитьОбъект();	// СправочникОбъект.Номенклатура
			Если НоменклатураОбъект.ВидНоменклатуры <> ВидНоменклатуры Тогда
				НоменклатураОбъект.ВидНоменклатуры = ВидНоменклатуры;
				НоменклатураОбъект.Записать();
				ОбновитьСписок = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ОбновитьСписок Тогда
		ТаблицаФормыНоменклатура = Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма)]; // ТаблицаФормы
		ТаблицаФормыНоменклатура.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИерархияНоменклатуры

&НаКлиенте
Процедура ИерархияНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ПодборТоваровКлиент.ПриАктивизацииСтрокиИерархииНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияНоменклатурыПриАктивизацииСтрокиОбработчикОжидания()
	
	ПодборТоваровКлиент.ОбработчикАктивизацииСтрокиИерархииНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКачества

&НаКлиенте
Процедура СписокКачестваПометкаПриИзменении(Элемент)
	
	СписокКачестваПометкаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенныеРасширенныйПоиск(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.СписокРасширенныйПоискНоменклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеСтандартныйПоиск(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.СписокСтандартныйПоискНоменклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеГруппы(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.ИерархияНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура Поиск(Команда)
	
	ВыполнитьПоискНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныхШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ДанныхШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСАналогичнымиСвойствами(Команда)
	
	НоменклатураСАналогичнымиСвойствамиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыДругогоКачества(Команда)
	
	ТоварыДругогоКачестваНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьОтборыПоСвойствам(Команда)
	
	СброситьОтборыПоСвойствамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПоиск(Команда)
	
	ПодборТоваровКлиент.НастроитьПоиск(ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	СписокКоманды = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.СписокРасширенныйПоискНоменклатура,
		Элементы.СписокСтандартныйПоискНоменклатура);
		
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, СписокКоманды);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Процедура ОтфильтроватьПоАналогичнымСвойствам(НоменклатураФильтраПоСвойствам)
	ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтаФорма, НоменклатураФильтраПоСвойствам);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтрокаПоискаНоменклатура.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоискНоменклатурыНеУдачный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ПолеСОшибкойФон);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтборовПредставлениеОтбора.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтборов.ФиксированноеЗначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Истина, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтборовПредставление.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтборов.Отбор");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИерархияНоменклатуры.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтборов.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидыНоменклатуры.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокКачества.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьФильтры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.FormBackColor);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидНоменклатуры.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьФильтры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//

КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

// МеханизмВнешнегоОборудования
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкода)
	
	ПараметрыОбработки = ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов();
	ПараметрыОбработки.Штрихкоды                        = ДанныеШтрихкода;
	ПараметрыОбработки.ИзменятьКоличество               = Истина;
	ПараметрыОбработки.БлокироватьДанныеФормы           = Ложь;
	ПараметрыОбработки.ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать";
	
	Номенклатура = НоменклатураПоШтрихкоду(ПараметрыОбработки, КэшированныеЗначения);
	Если Номенклатура <> Неопределено Тогда
		ТаблицаФормыНоменклатура = Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма)]; // ТаблицаФормы
		ТаблицаФормыНоменклатура.ТекущаяСтрока = Номенклатура;
		ПоказатьЗначение(,Номенклатура);
	Иначе
		ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(ПараметрыОбработки, КэшированныеЗначения, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры
// Конец МеханизмВнешнегоОборудования

&НаСервереБезКонтекста
Функция НоменклатураПоШтрихкоду(ПараметрыОбработки, КэшированныеЗначения)
	
	Возврат ШтрихкодированиеНоменклатурыСервер.НоменклатураПоШтрихкоду(ПараметрыОбработки, КэшированныеЗначения); 
	
КонецФункции

#КонецОбласти

#Область Поиск

&НаКлиенте
Процедура ВыполнитьПоискНоменклатуры()
	
	ПодборТоваровКлиент.ВыполнениеРасширенногоПоискаВозможно(ЭтаФорма, 
		Новый ОписаниеОповещения("ВыполнитьПоискНоменклатурыЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ВыполнитьПоискНоменклатурыНаСервере();
	ПодборТоваровКлиент.ПослеВыполненияПоискаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНоменклатурыНаСервере()
	
	ПодборТоваровСервер.ВыполнитьПоискНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СнятьОтборПоСтрокеПоискаНоменклатурыНаСервере()
	
	ПодборТоваровКлиентСервер.СнятьОтборПоСтрокеПоискаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийНаСервере

&НаСервере
Процедура ИспользоватьФильтрыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииИспользованияФильтров(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВидНоменклатурыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииВидаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СегментНоменклатурыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииСегментаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураСАналогичнымиСвойствамиНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииОтображенияНоменклатураСАналогичнымиСвойствами(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДеревоОтборовОтборПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ДеревоОтборовОтборПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураИсходногоКачестваПриИзмененииНаСервере()
	
	ПодборТоваровСервер.НоменклатураИсходногоКачестваПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СписокКачестваПометкаПриИзмененииНаСервере()
	
	ПодборТоваровСервер.СписокКачестваПометкаПриИзменении(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ГорячиеКлавиши

&НаКлиенте
Процедура УстановитьТекущийЭлементСтрокаПоиска(Команда)
	
	ПодборТоваровКлиент.УстановитьТекущийЭлементСтрокаПоиска(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОжидания

&НаКлиенте
Процедура СписокПриАктивизацииСтрокиОбработчикОжидания()
	
	ПодборТоваровКлиент.УстановитьТекущуюСтрокуИерархииНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеВариантомНавигации

&НаКлиенте
Процедура ВидыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ПодборТоваровКлиент.ПриАктивизацииСтрокиСпискаВидыНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания()
	
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ВидНоменклатурыПриИзмененииНаСервере();
		
		Если ЗначениеЗаполнено(СтрокаПоискаНоменклатура) Тогда
			ВыполнитьПоискНоменклатуры();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВариантНавигацииНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	ВидНоменклатурыДоПерехода = ВидНоменклатуры;
	НадписьВариантНавигацииНавигационнойСсылкиНаСервере(НавигационнаяСсылка, СтандартнаяОбработка);
	
	Если ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам") Тогда
		Элементы.ВидыНоменклатуры.ТекущаяСтрока = ВидНоменклатурыДоПерехода;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НадписьВариантНавигацииНавигационнойСсылкиНаСервере(НавигационнаяСсылка, СтандартнаяОбработка)
	
	ПодборТоваровСервер.НадписьВариантНавигацииНавигационнойСсылки(ЭтаФорма, НавигационнаяСсылка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариантНавигации(Команда)
	ПодборТоваровКлиент.ИзменитьВариантНавигации(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариантНавигацииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено 
		Или ВариантНавигации = Результат.Значение Тогда
		Возврат;
	КонецЕсли;
	
	ВариантНавигации = Результат.Значение;
	ВариантНавигацииПриИзмененииНаСервере();	
	
КонецПроцедуры

&НаСервере
Процедура ВариантНавигацииПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииВариантаНавигации(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция АдресТаблицПараметровДереваОтборовНаСервере()
	
	Структура = Новый Структура("АдресТаблицыПараметров, АдресТаблицыСопоставления");
	
	Структура.АдресТаблицыПараметров = ПодборТоваровСервер.АдресТаблицыПараметровДереваОтборов(ЭтаФорма);
	Структура.АдресТаблицыСопоставления = ПодборТоваровСервер.АдресТаблицыСопоставленияДереваОтборов(ЭтаФорма);

	Возврат Структура;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкиФормыНаСервере()
	
	ПодборТоваровСервер.СохранитьНастройкиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыДругогоКачестваНаСервере()
	
	ПодборТоваровСервер.УстановитьОтборПоНоменклатуреДругогоКачества(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СброситьОтборыПоСвойствамНаСервере()
	
	ПодборТоваровСервер.СброситьОтборыПоСвойствам(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	СписокДляПечати = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.СписокРасширенныйПоискНоменклатура,
		Элементы.СписокСтандартныйПоискНоменклатура);
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, СписокДляПечати);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	СписокДляПечати = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.СписокРасширенныйПоискНоменклатура,
		Элементы.СписокСтандартныйПоискНоменклатура);	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, СписокДляПечати, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	СписокДляПечати = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.СписокРасширенныйПоискНоменклатура,
		Элементы.СписокСтандартныйПоискНоменклатура);	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, СписокДляПечати);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.РаботаСНоменклатурой

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуРаботаСНоменклатурой(Команда)
	
	РаботаСНоменклатуройКлиент.ВыполнитьПодключаемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой

#КонецОбласти

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокСтандартныйПоискНоменклатураВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Справочник.Номенклатура.ФормаСписка.Элемент.СписокСтандартныйПоискНоменклатура.Выбор");
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	РаботаСНоменклатуройКлиент.ВыборВТаблицеФормы(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенныйПоискНоменклатураВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Справочник.Номенклатура.ФормаСписка.Элемент.СписокРасширенныйПоискНоменклатура.Выбор");
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	РаботаСНоменклатуройКлиент.ВыборВТаблицеФормы(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой 	
	
КонецПроцедуры

#КонецОбласти
