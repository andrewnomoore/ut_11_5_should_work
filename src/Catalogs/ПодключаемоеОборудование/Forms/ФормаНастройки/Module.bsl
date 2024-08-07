
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	КодЯзыка = ?(Параметры.Свойство("КодЯзыка"), Параметры.КодЯзыка, ""); 
	ДанныеУстройстваСтруктура = МенеджерОборудования.ДанныеУстройства(Идентификатор, КодЯзыка); // Структура
	Если ДанныеУстройстваСтруктура = Неопределено Тогда
		Отказ = Истина;
		ОбщегоНазначенияБПО.СообщитьПользователю(НСтр("ru = 'Не удалось получить данные устройства.'"));
		Возврат;
	КонецЕсли;
	ДрайверОборудования = ДанныеУстройстваСтруктура.ДрайверОборудования;
	ЗначениеПараметров  = ДанныеУстройстваСтруктура.Параметры;
	ДанныеУстройства    = ДанныеУстройстваСтруктура;
	Если Не ЗначениеЗаполнено(ЗначениеПараметров) Тогда
		ЗначениеПараметров = Новый Структура();
	КонецЕсли;
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	ДрайверОборудованияТипОборудования = ОбщегоНазначенияБПО.ЗначениеРеквизитаОбъекта(ДрайверОборудования, "ТипОборудования");
	
	СчитывательМагнитныхКарт = ДрайверОборудованияТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт;
	Если СчитывательМагнитныхКарт Тогда
		времПараметрыДорожек = Неопределено;
		Если НЕ ЗначениеПараметров.Свойство("ПараметрыДорожек", времПараметрыДорожек) Тогда
			времПараметрыДорожек = Новый Массив();
			Для Индекс = 1 По 3 Цикл
				НоваяСтрока = Новый Структура();
				НоваяСтрока.Вставить("НомерДорожки", Индекс);
				НоваяСтрока.Вставить("Префикс"     , 0);
				НоваяСтрока.Вставить("Суффикс"     , ?(Индекс = 2, 13, 0));
				НоваяСтрока.Вставить("Использовать", ?(Индекс = 2, Истина, Ложь));
				времПараметрыДорожек.Добавить(НоваяСтрока);
			КонецЦикла;
		КонецЕсли;
		Для Каждого СтрокаДорожки Из времПараметрыДорожек Цикл
			НоваяСтрока = ПараметрыДорожек.Добавить();
			НоваяСтрока.НомерДорожки = СтрокаДорожки.НомерДорожки;
			НоваяСтрока.Префикс      = СтрокаДорожки.Префикс;
			НоваяСтрока.Суффикс      = СтрокаДорожки.Суффикс;
			НоваяСтрока.Использовать = СтрокаДорожки.Использовать;
		КонецЦикла;
	КонецЕсли;
	
	ИдентификаторРабочееМесто = ОбщегоНазначенияБПО.ЗначениеРеквизитаОбъекта(Идентификатор, "РабочееМесто");
	ТекущееРабочееМесто = (ПараметрыСеанса.РабочееМестоКлиента = ИдентификаторРабочееМесто);
	
	Элементы.ТестУстройства.Видимость         = ТекущееРабочееМесто;
	Элементы.СтатусКомпоненты.Видимость       = ТекущееРабочееМесто;
	Элементы.ДополнительныеДействия.Видимость = ТекущееРабочееМесто Или ПустаяСтрока(ИдентификаторРабочееМесто);
	
	Если ОбщегоНазначенияБПО.ЭтоМобильнаяПлатформа() Тогда
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.Версия);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.Статус);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.НаименованиеДрайвера);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ОписаниеДрайвера);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнформациюДрайверОборудования(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ВремНастройки = ПолучитьНастройки();
	
	Если СчитывательМагнитныхКарт Тогда
		
		НастроеноДорожек = 0;
		ДорожкаСПустымСуффиксом = Ложь;
		времПараметрыДорожек = Новый Массив();
		ПрефиксДрайвера = -1;
		СуффиксДрайвера = -1;

		Для Индекс = 1 По 3 Цикл
			Если ПараметрыДорожек[3 - Индекс].Использовать Тогда
				ДорожкаСПустымСуффиксом =
				    ДорожкаСПустымСуффиксом ИЛИ (ПараметрыДорожек[3 - Индекс].Суффикс = 0);
				НастроеноДорожек = НастроеноДорожек + 1;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ДорожкаСПустымСуффиксом Тогда
			
			Для Индекс = 1 По 3 Цикл
				НоваяСтрока = Новый Структура();
				НоваяСтрока.Вставить("НомерДорожки", ПараметрыДорожек[Индекс - 1].НомерДорожки);
				НоваяСтрока.Вставить("Использовать", ПараметрыДорожек[Индекс - 1].Использовать);
				НоваяСтрока.Вставить("Префикс"     , ПараметрыДорожек[Индекс - 1].Префикс);
				НоваяСтрока.Вставить("Суффикс"     , ПараметрыДорожек[Индекс - 1].Суффикс);
				времПараметрыДорожек.Добавить(НоваяСтрока);
			КонецЦикла;
			
			Для Индекс = 1 По 3 Цикл
				Если времПараметрыДорожек[Индекс - 1].Использовать Тогда
					ПрефиксДрайвера = времПараметрыДорожек[Индекс - 1].Префикс;
					ПрефиксДрайвера = ?(ПрефиксДрайвера = 0, -1, ПрефиксДрайвера);
					ВремНастройки.ПараметрыОборудования.Вставить("P_Prefix", ПрефиксДрайвера);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Для Индекс = 1 По 3 Цикл
				Если времПараметрыДорожек[3 - Индекс].Использовать Тогда
					СуффиксДрайвера = времПараметрыДорожек[3 - Индекс].Суффикс;
					СуффиксДрайвера = ?(СуффиксДрайвера = 0, -1, СуффиксДрайвера);
					ВремНастройки.ПараметрыОборудования.Вставить("P_Suffix", СуффиксДрайвера);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			ВремНастройки.ПараметрыОборудования.Вставить("ПараметрыДорожек", времПараметрыДорожек);
			
		КонецЕсли;
		
		Если ПрефиксДрайвера > 0 И СуффиксДрайвера > 0 И ПрефиксДрайвера = СуффиксДрайвера Тогда
			ТекстСообщения = НСтр("ru = 'Префикс первой используемой дорожки совпадает с суффикс последней используемой дорожки'");
			ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
		ИначеЕсли НастроеноДорожек > 0 И Не ДорожкаСПустымСуффиксом Тогда
			Закрыть(ВремНастройки);  
		ИначеЕсли НастроеноДорожек = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Необходимо указать использование хотя бы одной дорожки для считывателя'");
			ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
		ИначеЕсли ДорожкаСПустымСуффиксом Тогда
			ТекстСообщения = НСтр("ru = 'Для каждой используемой дорожки должен быть указан суффикс'");
			ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	Иначе
		Закрыть(ВремНастройки);  
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьЗапускПриложенияЗавершение(Результат, Параметры) Экспорт
	
	ОбщегоНазначенияБПОКлиент.СообщитьПользователю(НСтр("ru='Начата установка основной поставки драйвера.'")); 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаДрайвераОсновнаяПоставкаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Оповещения = Новый ОписаниеОповещения("НачатьЗапускПриложенияЗавершение", ЭтотОбъект);
		// АПК:534-выкл URLЗагрузкиДрайвера предоставляется производителем драйвера
		НачатьЗапускПриложения(Оповещения, URLЗагрузкиДрайвера, , Ложь);
		// АПК:534-вкл
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверЗавершение(РезультатОперации, Параметры) Экспорт 
	
	Если РезультатОперации.Результат Тогда
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
		ОбновитьИнформациюДрайверОборудования(Истина);
	Иначе
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(РезультатОперации.ОписаниеОшибки); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)
	
	Если ИнтеграционныйКомпонент Тогда
		Текст = НСтр("ru = 'Для перехода на сайт производителя необходимо подключение к Интернету.
			|Продолжить выполнение операции?'");
		Оповещение = Новый ОписаниеОповещения("УстановкаДрайвераОсновнаяПоставкаЗавершение",  ЭтотОбъект);
		ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	Иначе
		ОповещенияУстановитьДрайверЗавершение = Новый ОписаниеОповещения("УстановитьДрайверЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.УстановитьДрайверОборудования(ОповещенияУстановитьДрайверЗавершение, ДрайверОборудования);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройстваЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ТолькоПросмотр = Ложь;
	КоманднаяПанель.Доступность = Истина;
	
	Если  РезультатВыполнения.Результат Тогда
		ДополнительноеОписание = РезультатВыполнения.РезультатВыполнения;
		ДемонстрационныйРежим =  РезультатВыполнения.АктивированДемоРежим;
		Элементы.ГруппаДемонстрационныйРежим.Видимость = НЕ ПустаяСтрока(ДемонстрационныйРежим);
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");   
		Если Не ПустаяСтрока(ДополнительноеОписание) Тогда
			ТекстСообщения = ТекстСообщения + Символы.НПП + ДополнительноеОписание;    
		КонецЕсли
	Иначе
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Тест не пройден. %1'"), РезультатВыполнения.ОписаниеОшибки);
	КонецЕсли;
	ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестПодключения(Команда)
	
	ОчиститьСообщения();
	ТолькоПросмотр = Истина;
	КоманднаяПанель.Доступность = Ложь;
	
	ДемонстрационныйРежим = "";
	
	ПараметрыУстройства = ПолучитьНастройки().ПараметрыОборудования;
	Оповещение = Новый ОписаниеОповещения("ТестУстройстваЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьТестУстройства(Оповещение, Идентификатор, ПараметрыУстройства);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительноеДействиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ТекстСообщения = ?(РезультатВыполнения.Результат,  
						НСтр("ru = 'Операция выполнена успешно.'"),
						НСтр("ru = 'Ошибка выполнения операции:'") + РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
	
	ОчиститьНастраиваемыйИнтерфейс();
	
	ОбновитьИнформациюДрайверОборудования(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительноеДействие(Команда)
	
	ИмяДействия = Сред(Команда.Имя, 3);
	ПараметрыВыполнения = Новый Структура("ИмяДействия", ИмяДействия);
	
	ПараметрыУстройства = ПолучитьНастройки().ПараметрыОборудования;
	Оповещение = Новый ОписаниеОповещения("ДополнительноеДействиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыполнениеДополнительнойКоманды(Оповещение, Идентификатор, ПараметрыУстройства, ПараметрыВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьНастройки()
	            
	ПараметрыДрайвераРеквизиты = ПолучитьРеквизиты();
	
	НовыеЗначениеПараметров = Новый Структура;
	Для Каждого Параметр Из ПараметрыДрайвераРеквизиты Цикл
		Если Лев(Параметр.Имя, 2) = "P_" Тогда
			НовыеЗначениеПараметров.Вставить(Параметр.Имя, ЭтотОбъект[Параметр.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОчиститьНастраиваемыйИнтерфейс()
	
	Пока Элементы.Страницы.ПодчиненныеЭлементы.Количество() > 0 Цикл
		Элементы.Удалить(Элементы.Страницы.ПодчиненныеЭлементы.Получить(0));
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастраиваемыйИнтерфейс(ОписаниеИнтерфейса, ДополнительныеДействия, ПервыйЗапуск)
	
	Суффикс = Ложь;
	Префикс = Ложь;
	БазоваяГруппа = Неопределено;
	Элемент = Неопределено;
	ИндексГруппы = 0;
	КоличествоСтраниц = 0;
	ТекущаяСтраница = Элементы.Добавить("ОсновнаяСтраница", Тип("ГруппаФормы"), Элементы.Страницы);
	
	ЧтениеXML = Новый ЧтениеXML; 
	ЧтениеXML.УстановитьСтроку(ОписаниеИнтерфейса);
	ЧтениеXML.ПерейтиКСодержимому();
	
	Если ЧтениеXML.Имя = "Settings" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
		Пока ЧтениеXML.Прочитать() Цикл  
			
			Если ЧтениеXML.Имя = "Parameter" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				
				ТолькоЧтение = ?(ВРег(ЧтениеXML.ЗначениеАтрибута("ReadOnly")) = "TRUE", Истина, Ложь) 
										Или ?(ВРег(ЧтениеXML.ЗначениеАтрибута("ReadOnly")) = "ИСТИНА", Истина, Ложь);
				ОригинальноеИмя   =  ЧтениеXML.ЗначениеАтрибута("Name");
				ПараметрИмя       = ?(ТолькоЧтение, "R_", "P_") + ОригинальноеИмя;
				ПараметрЗаголовок = ЧтениеXML.ЗначениеАтрибута("Caption");
				ПараметрТип       = ВРег(ЧтениеXML.ЗначениеАтрибута("TypeValue"));
				ПараметрТип       = ?(НЕ ПустаяСтрока(ПараметрТип), ПараметрТип, "STRING");
				ПараметрЗначение  = ЧтениеXML.ЗначениеАтрибута("DefaultValue");
				ПараметрОписание  = ЧтениеXML.ЗначениеАтрибута("Description");
				СтрокаФорматирования = ЧтениеXML.ЗначениеАтрибута("FieldFormat");
				
				Если СчитывательМагнитныхКарт Тогда
					Суффикс = ВРег(ОригинальноеИмя) = "SUFFIX" Или ?(ВРег(ЧтениеXML.ЗначениеАтрибута("Suffix")) = "TRUE", Истина, Ложь);
					Префикс = ВРег(ОригинальноеИмя) = "PREFIX" Или ?(ВРег(ЧтениеXML.ЗначениеАтрибута("Prefix")) = "TRUE", Истина, Ложь);
				КонецЕсли;
				
				ПараметрСуществует = Ложь;
				ПараметрыДрайвераРеквизиты = ПолучитьРеквизиты();
				Для Каждого ПараметрДрайвераРеквизит Из ПараметрыДрайвераРеквизиты Цикл
					Если ПараметрДрайвераРеквизит.Имя = ПараметрИмя Тогда
						ПараметрСуществует = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ПараметрСуществует Тогда
					
					Если ПараметрТип = "NUMBER" Тогда 
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Число"), , ПараметрЗаголовок, Истина);
					ИначеЕсли ПараметрТип = "BOOLEAN" Тогда 
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Булево"), , ПараметрЗаголовок, Истина);
					Иначе
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Строка"), , ПараметрЗаголовок, Истина);
					КонецЕсли;
				
					// Добавляем новый реквизит в форму.
					ДобавляемыеРеквизиты = Новый Массив;
					ДобавляемыеРеквизиты.Добавить(Реквизит);
					ИзменитьРеквизиты(ДобавляемыеРеквизиты);
				
				КонецЕсли;
				
				Если Суффикс Тогда 
					Элемент = Элементы.ПараметрыДорожекСуффикс
				ИначеЕсли Префикс Тогда
					Элемент = Элементы.ПараметрыДорожекПрефикс;
				ИначеЕсли Элементы.Найти(ПараметрИмя) = Неопределено Тогда
					// Если не было создано не одной группы.
					Если БазоваяГруппа = Неопределено Тогда
						БазоваяГруппа = Элементы.Добавить("БазоваяГруппа" + КоличествоСтраниц, Тип("ГруппаФормы"), ТекущаяСтраница);
						БазоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
						БазоваяГруппа.Отображение = Элементы.ДрайверОборудования.Отображение;
						БазоваяГруппа.РастягиватьПоГоризонтали = Истина;
						БазоваяГруппа.Заголовок = НСтр("ru = 'Параметры'");
						БазоваяГруппа.Группировка = Элементы.ДрайверОборудования.Группировка;
					КонецЕсли;
					// Добавляем новое поле ввода на форму.
					Элемент = Элементы.Добавить(ПараметрИмя, Тип("ПолеФормы"), БазоваяГруппа);
					Если ПараметрТип = "BOOLEAN" Тогда 
						Элемент.Вид = ВидПоляФормы.ПолеФлажка
					Иначе
						Элемент.Вид = ВидПоляФормы.ПолеВвода;
						Элемент.АвтоМаксимальнаяШирина = Ложь;
						Элемент.РастягиватьПоГоризонтали = Истина;
						Элемент.Формат = СтрокаФорматирования;
						Элемент.ФорматРедактирования = СтрокаФорматирования;       
						Если ОбщегоНазначенияБПО.ЭтоМобильнаяПлатформа() Тогда
							ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элемент);
						КонецЕсли;
					КонецЕсли;
					Элемент.ПутьКДанным = ПараметрИмя;
					Элемент.Подсказка = ПараметрОписание;
					Элемент.ТолькоПросмотр = ТолькоЧтение; 
				КонецЕсли;
				
				ХранимоеЗначение = Неопределено;
				Если ЗначениеПараметров.Свойство(ПараметрИмя, ХранимоеЗначение) Тогда
					ПараметрЗначение = ХранимоеЗначение
				Иначе
					Если НЕ ПустаяСтрока(ПараметрЗначение) Тогда
						Если ПараметрТип = "BOOLEAN" Тогда
							ПараметрЗначение = ?(ВРег(ПараметрЗначение) = "TRUE", Истина, Ложь) Или  ?(ВРег(ПараметрЗначение) = "ИСТИНА", Истина, Ложь);
						ИначеЕсли ПараметрТип = "STRING" Тогда
							ПараметрЗначение = Строка(ПараметрЗначение);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
				ЭтотОбъект[ПараметрИмя] = ПараметрЗначение;
				
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "ChoiceList" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
				
				Если НЕ (Элемент = Неопределено) И НЕ (Элемент.Вид = ВидПоляФормы.ПолеФлажка) Тогда   
					Элемент.РежимВыбораИзСписка  = Истина; 
					Элемент.ВысотаСпискаВыбора   = 10;
					Элемент.РедактированиеТекста = Ложь; 
					Если Суффикс Или Префикс Тогда
						Элемент.СписокВыбора.Добавить(0, "<NONE>");
					КонецЕсли;
				КонецЕсли;
				
				Пока ЧтениеXML.Прочитать() И НЕ (ЧтениеXML.Имя = "ChoiceList") Цикл   
					
					Если ЧтениеXML.Имя = "Item" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
						ЗначениеАтрибута = ЧтениеXML.ЗначениеАтрибута("Value"); 
						Если ЧтениеXML.Прочитать() Тогда
							ПредставлениеАтрибута = ЧтениеXML.Значение;
						КонецЕсли;
						Если ПустаяСтрока(ЗначениеАтрибута) Тогда
							ЗначениеАтрибута = ПредставлениеАтрибута;
						КонецЕсли;
						
						Если Суффикс Или Префикс Тогда
							Если Число(ЗначениеАтрибута) > 0 Тогда
								Элемент.СписокВыбора.Добавить(Число(ЗначениеАтрибута), ПредставлениеАтрибута);
							КонецЕсли;
						ИначеЕсли ПараметрТип = "NUMBER" Тогда 
								Элемент.СписокВыбора.Добавить(Число(ЗначениеАтрибута), ПредставлениеАтрибута);
						Иначе
							Элемент.СписокВыбора.Добавить(ЗначениеАтрибута, ПредставлениеАтрибута)
						КонецЕсли;         
						Если ОбщегоНазначенияБПО.ЭтоМобильнаяПлатформа() Тогда
							ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элемент);   
						КонецЕсли; 
					КонецЕсли;
				КонецЦикла; 
				
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "Page" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				ЗаголовокСтраницы = ЧтениеXML.ЗначениеАтрибута("Caption");
				ЗаголовокСтраницы = ?(ПустаяСтрока(ЗаголовокСтраницы), НСтр("ru = 'Параметры'"), ЗаголовокСтраницы);
				
				КоличествоСтраниц = КоличествоСтраниц + 1;
				Если КоличествоСтраниц > 1 Тогда
					Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
					ТекущаяСтраница = Элементы.Добавить("Страница" + КоличествоСтраниц, Тип("ГруппаФормы"), Элементы.Страницы);
					БазоваяГруппа = Неопределено;
				КонецЕсли;
				ТекущаяСтраница.Заголовок = ЗаголовокСтраницы;
				
			КонецЕсли;
				
			Если ЧтениеXML.Имя = "Group" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				
				ЗаголовокГруппы = ЧтениеXML.ЗначениеАтрибута("Caption");
				ЗаголовокГруппы = ?(ПустаяСтрока(ЗаголовокГруппы), НСтр("ru = 'Параметры'"), ЗаголовокГруппы);
				
				БазоваяГруппа = Элементы.Добавить("Группа" + ИндексГруппы, Тип("ГруппаФормы"), ТекущаяСтраница);
				БазоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				БазоваяГруппа.Отображение = Элементы.ДрайверОборудования.Отображение;
				БазоваяГруппа.РастягиватьПоГоризонтали = Истина;
				БазоваяГруппа.Группировка = Элементы.ДрайверОборудования.Группировка;
				БазоваяГруппа.Заголовок = ЗаголовокГруппы;
				ИндексГруппы = ИндексГруппы + 1;
				
			КонецЕсли;
			
		КонецЦикла;  
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть(); 
	
	Если ПервыйЗапуск И НЕ ПустаяСтрока(ДополнительныеДействия) Тогда
		
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(ДополнительныеДействия);
		ЧтениеXML.ПерейтиКСодержимому();
		
		Если ЧтениеXML.Имя = "Actions" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
			
			Пока ЧтениеXML.Прочитать() Цикл  
				Если ЧтениеXML.Имя = "Action" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					
					ДействиеИмя       = "M_"  + ЧтениеXML.ЗначениеАтрибута("Name");
					ДействиеЗаголовок = ЧтениеXML.ЗначениеАтрибута("Caption");
					
					Команда = Команды.Добавить("A_" + ЧтениеXML.ЗначениеАтрибута("Name"));
					Команда.Заголовок = ДействиеЗаголовок;
					Команда.Действие = "ДополнительноеДействие";
					
					ПунктМеню = Элементы.Добавить(ДействиеИмя, Тип("КнопкаФормы"), Элементы.ДополнительныеДействия);
					ПунктМеню.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
					ПунктМеню.Заголовок = ДействиеЗаголовок;
					ПунктМеню.ИмяКоманды = "A_" + ЧтениеXML.ЗначениеАтрибута("Name");
					 
				КонецЕсли;
			КонецЦикла;  
			
		КонецЕсли;
		
		ЧтениеXML.Закрыть(); 
		
	КонецЕсли;
	
	Элементы.ПрефиксыИСуффиксыДорожек.Видимость = СчитывательМагнитныхКарт;
	
КонецПроцедуры                                   

&НаКлиенте
Процедура ОбновитьИнтерфейсФормы(ПервыйЗапуск, ПараметрыОперации)
	
	Если ПараметрыОперации.Результат Тогда
		
		Элементы.СтатусКомпоненты.ТекущаяСтраница = Элементы.КомпонентаУстановлена;
		ДрайверГотовКРаботе = Ложь;
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыОперации.ОписаниеДрайвера);
		
		Если КоличествоПодключенных > 0 Тогда 
			
			Элементы.СтатусКомпоненты.ТекущаяСтраница = Элементы.УстройствоПодключено;
			
		ИначеЕсли ИнтеграционныйКомпонент Тогда
			
			Если НЕ ОсновнойДрайверУстановлен Тогда
				Элементы.СтатусКомпоненты.ТекущаяСтраница = Элементы.ДрайверИнтеграционныйКомпонент;
				ДрайверУстановлен = НСтр("ru='Установлен интеграционный компонент'");
				ВерсияДрайвера = НСтр("ru='Не определена'");
				Элементы.ДрайверНаименования.Видимость = НЕ ПустаяСтрока(НаименованиеДрайвера); 
				Элементы.ДрайверНаименования.Заголовок = СтрЗаменить(Элементы.ДрайверНаименования.Заголовок, "%Наименование%", НаименованиеДрайвера);
				Элементы.ПерейтиНаСайтПроизводителя.Видимость = НЕ ПустаяСтрока(URLЗагрузкиДрайвера);
			Иначе
				ДрайверГотовКРаботе = Истина;
				ДрайверУстановлен = НСтр("ru='Установлен'");
			КонецЕсли
		Иначе
			ДрайверУстановлен = НСтр("ru='Установлен'");
			ДрайверГотовКРаботе = Истина;
		КонецЕсли;
		
		Если ДрайверГотовКРаботе И НЕ ПустаяСтрока(ПараметрыДрайвера) Тогда
			ОбновитьНастраиваемыйИнтерфейс(ПараметрыДрайвера, ДополнительныеДействия, ПервыйЗапуск);
		КонецЕсли;
		
	Иначе
		Элементы.СтатусКомпоненты.ТекущаяСтраница = Элементы.КомпонентаНеУстановлена;
		ДрайверГотовКРаботе = Ложь;
		ДрайверУстановлен = НСтр("ru='Не установлен'");
		ВерсияДрайвера    = НСтр("ru='Не определена'");
	КонецЕсли;
	
	Элементы.ТестУстройства.Видимость = ДрайверГотовКРаботе;
	Элементы.ЗаписатьИЗакрыть.Видимость = ДрайверГотовКРаботе;
	Элементы.ДрайверОборудования.Видимость   = ДрайверГотовКРаботе;
	Элементы.Функции.Видимость = ДрайверГотовКРаботе;
	Элементы.ОписаниеДрайвера.Видимость = ДрайверГотовКРаботе И НЕ ПустаяСтрока(ОписаниеДрайвера);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюДрайверОборудования_Завершение(РезультатВыполнения, Параметры) Экспорт
		
	Если Не ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ПервыйЗапуск = ?(Параметры.Свойство("ПервыйЗапуск"), Параметры.ПервыйЗапуск, Истина);
	ОбновитьИнтерфейсФормы(ПервыйЗапуск, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюДрайверОборудования(ПервыйЗапуск)

	ПараметрыКоманды = Новый Структура("ПервыйЗапуск", ПервыйЗапуск);
	Оповещение = Новый ОписаниеОповещения("ОбновитьИнформациюДрайверОборудования_Завершение", ЭтотОбъект, ПараметрыКоманды);
	МенеджерОборудованияКлиент.НачатьПолучениеОписанияОборудования(Оповещение, , ДанныеУстройства);
	  
КонецПроцедуры

#КонецОбласти