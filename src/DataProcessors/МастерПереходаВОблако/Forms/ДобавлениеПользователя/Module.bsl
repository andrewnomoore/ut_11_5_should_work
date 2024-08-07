#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("КодАбонента", КодАбонента);
	Параметры.Свойство("Логин", АвторизацияЛогин);
	Параметры.Свойство("Пароль", АвторизацияПароль);
	Параметры.Свойство("АдресПрограммногоИнтерфейса", АдресПрограммногоИнтерфейса);
	Параметры.Свойство("ПолноеИмя", ПолноеИмя);
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("Почта", Почта);
	Если ЗначениеЗаполнено(Почта) Тогда
		Логин = Почта;
	КонецЕсли;

	Элементы.ПарольЗакрытый.КартинкаКнопкиВыбора = Элементы.КартинкаЗакрыто.Картинка;
	Элементы.ПарольОткрытый.КартинкаКнопкиВыбора = Элементы.КартинкаОткрыто.Картинка;

	РольПользователя = "user";
	ЧасовойПояс = ЧасовойПоясСеанса();

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если РольПользователя = Перечисления.РолиПользователейАбонентов.ПользовательАбонента Тогда
		ПроверяемыеРеквизиты.Добавить("Почта");
	КонецЕсли;

	Попытка
		Результат = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Почта);
	Исключение
		ТекстОшибки = ТехнологияСервиса.КраткийТекстОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "Почта", , Отказ);
		Возврат;
	КонецПопытки;
	Если Результат.Количество() > 1 Тогда
		ТекстОшибки = НСтр("ru = 'Можно ввести только один e-mail.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "Почта", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПочтаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Почта) И Не ЗначениеЗаполнено(Логин) Тогда
		Логин = Почта;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Элементы.ПарольЗакрытый.Видимость = Ложь;
	Элементы.ПарольОткрытый.Видимость = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПарольОткрытыйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Элементы.ПарольЗакрытый.Видимость = Истина;
	Элементы.ПарольОткрытый.Видимость = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)

	Если ГотовоНаСервере() Тогда

		ПараметрыВозврата = Новый Структура;
		ПараметрыВозврата.Вставить("Результат", Истина);
		ПараметрыВозврата.Вставить("Логин", Логин);
		ПараметрыВозврата.Вставить("ПолноеИмя", ПолноеИмя);
		ПараметрыВозврата.Вставить("Роль", РольПользователя);
		ПараметрыВозврата.Вставить("Идентификатор", Идентификатор);
		ПараметрыВозврата.Вставить("Почта", Почта);

		Закрыть(ПараметрыВозврата);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)

	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ГотовоНаСервере()

	Данные = Новый Структура;
	Данные.Вставить("id", КодАбонента);
	Данные.Вставить("login", Логин);
	Если ЗначениеЗаполнено(Пароль) Тогда
		Данные.Вставить("password", Пароль);
	КонецЕсли;
	Данные.Вставить("email_required", ЗначениеЗаполнено(Почта));
	Данные.Вставить("email", Почта);
	Данные.Вставить("role", РольПользователя);
	Данные.Вставить("name", ПолноеИмя);
	Данные.Вставить("phone", Телефон);
	Данные.Вставить("timezone", ЧасовойПоясСеанса());

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Авторизация = ОбработкаОбъект.ПараметрыАвторизации(АвторизацияЛогин, АвторизацияПароль, КодАбонента);

	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("АдресПрограммногоИнтерфейса", АдресПрограммногоИнтерфейса);
	ПараметрыЗапроса.Вставить("Метод", "usr/account/users/create");
	ПараметрыЗапроса.Вставить("Авторизация", Авторизация);
	ПараметрыЗапроса.Вставить("Данные", Данные);

	АдресРезальтата = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);

	ОбработкаОбъект.ВыполнитьМетодВнешнегоИнтерфейса(ПараметрыЗапроса, АдресРезальтата);
	Результат = ПолучитьИзВременногоХранилища(АдресРезальтата);

	Если Результат.Ошибка Тогда
		ВызватьИсключение Результат.СообщениеОбОшибке;
	ИначеЕсли Результат.Данные.general.Error Тогда
		ВызватьИсключение Результат.Данные.general.message;
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции
#КонецОбласти