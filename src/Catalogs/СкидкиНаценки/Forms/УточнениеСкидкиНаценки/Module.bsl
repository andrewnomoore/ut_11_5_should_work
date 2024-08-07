
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТаблицаЗначений = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	УточненияЗначенияСкидкиНаценки.Загрузить(ТаблицаЗначений);
	ТолькоПросмотрЭлементов = Параметры.ТолькоПросмотр ИЛИ Не ПравоДоступа("Изменение", Метаданные.Справочники.СкидкиНаценки);
	Элементы.УточненияЗначенияСкидкиНаценки.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.ФормаЗавершитьРедактирование.Доступность = Не ТолькоПросмотрЭлементов;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	Для Каждого СтрокаТЧ Из УточненияЗначенияСкидкиНаценки Цикл
		НомерСтроки = УточненияЗначенияСкидкиНаценки.Индекс(СтрокаТЧ) + 1;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.ЦеноваяГруппа) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнена колонка ""Ценовая группа"" в строке %1 списка ""Уточнения значения скидки (наценки)""'"), НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,,ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УточненияЗначенияСкидкиНаценки", НомерСтроки, "СпособДоставки"),, Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(АдресТабличнойЧастиУточненияПоЦеновымГруппамВоВременномХранилище());
	
КонецПроцедуры

&НаСервере
Функция АдресТабличнойЧастиУточненияПоЦеновымГруппамВоВременномХранилище()

	Возврат ПоместитьВоВременноеХранилище(УточненияЗначенияСкидкиНаценки.Выгрузить(), УникальныйИдентификатор);

КонецФункции
