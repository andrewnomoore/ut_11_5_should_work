#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Служебное имя формата.
// 
// Возвращаемое значение:
//  см. ПространствоИмен
Функция ИмяФормата() Экспорт
	Возврат ПространствоИмен();
КонецФункции

// Параметры:
//  ИмяФайла - Строка
// 
// Возвращаемое значение:
//  Булево - Истина если файл принадлежит формату
//
Функция ЭтоФайлФормата(ИмяФайла) Экспорт
	
	СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайла);
	
	ИмяСоответствуетФормату = СтрНачинаетсяС(СтруктураИмениФайла.Имя, ПрефиксФормата());
	
	Возврат ИмяСоответствуетФормату;
	
КонецФункции

// Параметры:
//  ДанныеФайла - ДвоичныеДанные
// 
// Возвращаемое значение:
//  Булево - Истина если двоичные данные принадлежат формату
//
Функция ЭтоДвоичныеДанныеФайлаФормата(ДанныеФайла) Экспорт
	
	ОбъектXDTO = ПолучитьДанныеФайлаXDTO(ДанныеФайла);
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат СтрНачинаетсяС(ОбъектXDTO.ИдФайл, ПрефиксФормата());
	
КонецФункции

// Возвращаемое значение:
//  Строка - КНД по данным формата
//
Функция КНД() Экспорт
	
	Возврат "1175016";
	
КонецФункции

// Возвращаемое значение:
//  Строка - Префикс по данным формата
//
Функция ПрефиксФормата() Экспорт
	
	Возврат "ON_SODSD";
	
КонецФункции

// Параметры:
//  ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//  Параметры   - см. ИнтеграцияЭДО.НовыеПараметрыФормированияДанныхОбъектаУчета
// 
// Возвращаемое значение:
//  см. ИнтеграцияЭДО.НовыйРезультатФормированияДанныхОбъектаУчета
//
Функция ОписаниеДанныхОбъектаУчета(ОбъектУчета, Параметры) Экспорт
	
	Результат = ИнтеграцияЭДО.НовыйРезультатФормированияДанныхОбъектаУчета();
	Результат.Данные = Создать();
	Результат.Основания.Добавить(ОбъектУчета);
	
	Возврат Результат;
	
КонецФункции

// Сформировать документ.
// 
// Параметры:
//  КонструкторЭД - ОбработкаОбъект.ФорматДоговорныйДокументИнформацияОтправителяЭДО
// 
// Возвращаемое значение:
//  см. ФорматыЭДО_ФНС.НовыйРезультатЗаполненияДокумента
//
Функция СформироватьДокумент(КонструкторЭД) Экспорт
	
	ПространствоИмен = ПространствоИмен();
	
	Документ = ФорматыЭДО_ФНС.НовыйРезультатЗаполненияДокумента();
	Файл = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("{" + ПространствоИмен + "}.Файл", ПространствоИмен);
	
	ЗаполнитьФайлИнформации(Файл, КонструкторЭД);
	
	ДвоичныеДанные = РаботаСФайламиБЭД.XDTOВДвоичныеДанные(Файл, Ложь, , "Файл");
	Документ.ДанныеОсновногоФайла.ДвоичныеДанные = ОбщегоНазначенияБЭД.УдалитьПространствоИмен(ДвоичныеДанные,
		ПространствоИмен);
	Расширение = "xml";
	Документ.ДанныеОсновногоФайла.ИмяФайла = СтрШаблон("%1.%2", КонструкторЭД.ИдентификаторФайла(), Расширение);
	
	Возврат Документ;
	
КонецФункции

// Параметры:
//  РазделыДополнительныхПолей - см. ФорматыЭДО.РазделыДополнительныхПолейФорматаЭлектронногоДокумента
//
Процедура ЗаполнитьРазделыДополнительныхПолей(РазделыДополнительныхПолей) Экспорт
	
КонецПроцедуры

// Параметры:
//  ДанныеФайлаЭД - ОбъектXDTO:
// 
// Возвращаемое значение:
//  Неопределено - значение по умолчанию
// 
Функция ИнформацияОТоваре(ДанныеФайлаЭД) Экспорт

	Возврат Неопределено;
	
КонецФункции

// При определении соответствия титулов.
// 
// Параметры:
//  СоответствиеОсновногоТитулаОтветному - Соответствие Из КлючИЗначение:
//  * Ключ - Строка - пространство имен основного титула
//  * Значение - Строка - пространство имен ответного титула
//
Процедура ЗаполнитьСоответствиеТитулов(СоответствиеОсновногоТитулаОтветному) Экспорт

КонецПроцедуры

// Возвращаемое значение:
//  Булево - Истина, если заполнение доступно
//
Функция ЗаполнениеДанныхПодписантаДоступно() Экспорт
	Возврат Ложь;
КонецФункции

// Возвращаемое значение:
//  Строка - Пространство имен по данным формата
//
Функция ПространствоИмен() Экспорт
	Возврат "ON_SODSD_1_999_02_01_01_01";
КонецФункции

// Параметры:
//  ДанныеФайла - ДвоичныеДанные
// 
// Возвращаемое значение:
//  см. РезультатФормированияДанныхДокумента
Функция ПредставлениеДанныхДокумента(ДанныеФайла) Экспорт
	
	ДанныеФайлаЭД = ПолучитьДанныеФайлаXDTO(ДанныеФайла);
	
	Если ДанныеФайлаЭД = Неопределено Тогда
		Возврат РезультатФормированияДанныхДокумента();
	КонецЕсли;
	
	КонструкторЭД = Создать();
	
	СодержаниеДокумента = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(ДанныеФайлаЭД, "Содержание");
	
	ТиповыеФрагменты = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(СодержаниеДокумента, "ФрагТиповой", , , Истина);
	
	Если ТиповыеФрагменты <> Неопределено Тогда
		
		Для Каждого Фрагмент Из ТиповыеФрагменты Цикл
			
			НоваяСтрока = КонструкторЭД.НовыйФрагмент();
			
			НоваяСтрока.ПорядковыйНомер = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "НомФраг");
			НоваяСтрока.СсылкаНаНомерФрагмента = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СсылБлок");
			НоваяСтрока.ЦифровойКодТиповогоНаименования = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "ЦифКЭлПер");
			НоваяСтрока.БуквенныйКодТиповогоНаименования = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "БукКЭлПер");
			НоваяСтрока.Выравнивание = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "МакетВыравн");
			НоваяСтрока.СодержаниеФрагмента = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СодержФраг");
			НоваяСтрока.ИностранноеСодержаниеФрагмента = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СодержФрагИн");
			НоваяСтрока.ВизуализацияТекста = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "МакетФрагТекст", , , Истина);
			НоваяСтрока.ВизуализацияСодержанияТаблиц = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "МакетФрагТаб", , , Истина);
			ПолучитьСтилиФрагмента(РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СтильФрагТекст"), НоваяСтрока);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПроизвольныеФрагменты = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(СодержаниеДокумента, "ФрагПроизв", , , Истина);
	
	Если ПроизвольныеФрагменты <> Неопределено Тогда
		
		Для Каждого Фрагмент Из ПроизвольныеФрагменты Цикл
			
			НоваяСтрока = КонструкторЭД.НовыйФрагмент();
			
			НоваяСтрока.ПорядковыйНомер = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "НомФраг");
			НоваяСтрока.СсылкаНаНомерФрагмента = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СсылБлок");
			НоваяСтрока.Выравнивание = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "МакетВыравн");
			НоваяСтрока.СодержаниеФрагмента = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СодержФраг");
			НоваяСтрока.ИностранноеСодержаниеФрагмента = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СодержФрагИн");
			
			НоваяСтрока.ВизуализацияТекста = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "МакетФрагТекст", , , Истина);
			НоваяСтрока.ВизуализацияСодержанияТаблиц = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "МакетФрагТаб", , , Истина);
			ПолучитьСтилиФрагмента(РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(Фрагмент, "СтильФрагТекст"), НоваяСтрока);
			
		КонецЦикла;
		
	КонецЕсли;
	
	КонструкторЭД.Фрагменты.Сортировать("ПорядковыйНомер");
	
	ПредставлениеДокумента = ВизуализироватьДанныеHTML(КонструкторЭД);
	
	РезультатФормирования = РезультатФормированияДанныхДокумента();
	РезультатФормирования.ПредставлениеДокумента = ПредставлениеДокумента;
	РезультатФормирования.Успех = ПредставлениеДокумента <> Неопределено;
	
	Возврат РезультатФормирования;
	
КонецФункции

// Параметры:
//  ДанныеФайлаЭД - ОбъектXDTO
//  ДеревоРазбора - см. ДеревоЭлектронногоДокументаБЭД.ИнициализироватьДеревоРазбора
//  НовыйЭД       - СтрокаДереваЗначений: см. ДеревоЭлектронногоДокументаБЭД.ИнициализироватьДеревоРазбора
//  ОшибкаРазбора - Булево
//
Процедура ПрочитатьФайлОбмена(ДанныеФайлаЭД, ДеревоРазбора, НовыйЭД, ОшибкаРазбора) Экспорт
	
	КонструкторЭД = Создать();
	КонструкторЭД.ОбъектXDTO = ДанныеФайлаЭД;
	
	НовыйЭД.ВерсияФормата = ПространствоИмен();
	НовыйЭД.ЗначениеРеквизита = КонструкторЭД;
	НовыйЭД.ВидЭД = Перечисления.ТипыДокументовЭДО.ДоговорныйДокумент;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеЭлектронногоДокумента

// Параметры:
//  Объект        - ОбъектXDTO
//  КонструкторЭД - ОбработкаОбъект.ФорматДоговорныйДокументИнформацияОтправителяЭДО
//
Процедура ЗаполнитьФайлИнформации(Объект, КонструкторЭД)
	
	Идентификатор = КонструкторЭД.ИдентификаторФайла();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ИдФайл", Идентификатор, Истина);
	ДополнительныеДанные = КонструкторЭД.ПолучитьДополнительныеДанныеДляФормирования();
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВерсПрог", ДополнительныеДанные.ВерсияПрограммы);
	РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Объект, "ВерсФорм", "1.01", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Визуализация

Функция ВизуализироватьДанныеHTML(КонструкторЭД)
	
	ДокументHTML = Новый ДокументHTML;
	ДобавитьНовыйАтрибут(ДокументHTML, ДокументHTML.ЭлементДокумента, "lang", "ru");
	ДобавитьНовыйАтрибут(ДокументHTML, ДокументHTML.ЭлементДокумента, "dir", "ltr");
	
	ЭлементТело = ДокументHTML.СоздатьЭлемент("body");
	
	СтилиCSS = "p {
	|    text-indent: 25px;
	|  }
	|";
	
	БлокСносок = Неопределено;
	
	ТаблицаСносок = ТаблицаСносок();
	
	Для Каждого Фрагмент Из КонструкторЭД.Фрагменты Цикл
		
		Если ЗначениеЗаполнено(Фрагмент.ВизуализацияТекста) Тогда
		
			НастройкаВизуализации = Фрагмент.ВизуализацияТекста[0];
			
			Если НастройкаВизуализации = "3" Тогда
				
				НовСноска = ТаблицаСносок.Добавить();
				НовСноска.ПорядковыйНомер = Фрагмент.ПорядковыйНомер;
				НовСноска.СсылкаНаНомерФрагмента = Фрагмент.СсылкаНаНомерФрагмента;
				
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаСносок.Количество() > 0 Тогда
		
		БлокСносок = ДокументHTML.СоздатьЭлемент("div");
		
		ЭлементНоваяСтрока = ДокументHTML.СоздатьЭлемент("br");
		
		Для Счетчик = 1 По 6 Цикл
			БлокСносок.ДобавитьДочерний(ЭлементНоваяСтрока);
		КонецЦикла;
		
		ТекстовыйУзел = ДокументHTML.СоздатьТекстовыйУзел("_______________________________");
		БлокСносок.ДобавитьДочерний(ТекстовыйУзел);
		БлокСносок.ДобавитьДочерний(ЭлементНоваяСтрока);
		
		ТаблицаСносок.Сортировать("СсылкаНаНомерФрагмента");
		Счетчик = 1;
		
		Для Каждого Сноска Из ТаблицаСносок Цикл
			
			Сноска.НомерВТексте = Счетчик;
			Счетчик = Счетчик + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
	НомерТекущейТаблицы = Неопределено;
	НомерТекущейСтрокиТаблицы = Неопределено;
	ЭлементВизуализации = Неопределено;
	ЭлементТаблицы = Неопределено;
	ЭлементСтроки = Неопределено;
	ЭлементЯчейки = Неопределено;
	
	Для каждого Фрагмент Из КонструкторЭД.Фрагменты Цикл
		
		Если ЗначениеЗаполнено(Фрагмент.СтильФрагмента) Тогда
			
			СтилиCSS = СтилиCSS + Символы.ПС + "." + Фрагмент.ИмяСтиляФрагмента + " { "
				+ Символы.ПС + Фрагмент.СтильФрагмента + " }";
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Фрагмент.ВизуализацияТекста) Тогда
			
			ДобавитьЭлементВизуализацииВПредка(ЭлементТаблицы, ЭлементСтроки);
			ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементТаблицы);
			
			НастройкаВизуализации = Фрагмент.ВизуализацияТекста[0];
			
			// Следующий за предыдущим
			Если НастройкаВизуализации = "0" Тогда
				
				Если ЭлементВизуализации = Неопределено Тогда
					
					Тег = "div";
					ЭлементВизуализации = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
					
				Иначе
					
					Тег = "span";
					ЭлементСтроковыйКонтейнер = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
					ЭлементВизуализации.ДобавитьДочерний(ЭлементСтроковыйКонтейнер);
					
				КонецЕсли;
				
			// Новый абзац
			ИначеЕсли НастройкаВизуализации = "1" Тогда
				
				ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементВизуализации);
				Тег = "p";
				ЭлементВизуализации = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
	
			// С новой строки
			ИначеЕсли НастройкаВизуализации = "2" Тогда
				
				ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементВизуализации);
				Тег = "div";
				ЭлементВизуализации = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
				
			// Сноска
			ИначеЕсли НастройкаВизуализации = "3" Тогда
				
				ИнформацияОСноске = ТаблицаСносок.Найти(Фрагмент.ПорядковыйНомер, "ПорядковыйНомер");
				ОбработатьДобавлениеСноски(ДокументHTML, БлокСносок, Фрагмент, ИнформацияОСноске.НомерВТексте);
				
			// Заголовок 1 уровня
			ИначеЕсли НастройкаВизуализации = "4" Тогда
				
				ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементВизуализации);
				Тег = "h1";
				ЭлементВизуализации = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
				
			// Заголовок 2 уровня
			ИначеЕсли НастройкаВизуализации = "5" Тогда
				
				ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементВизуализации);
				Тег = "h2";
				ЭлементВизуализации = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
				
			// Заголовок 3 уровня
			ИначеЕсли НастройкаВизуализации = "6" Тогда
				
				ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементВизуализации);
				Тег = "h3";
				ЭлементВизуализации = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
				
			КонецЕсли;
			
			ИнформацияОСноске = ТаблицаСносок.Найти(Фрагмент.ПорядковыйНомер, "СсылкаНаНомерФрагмента");
			
			Если ИнформацияОСноске <> Неопределено Тогда
				ОбработатьДобавлениеИдентификатораСноски(ДокументHTML, ЭлементВизуализации, Фрагмент.ПорядковыйНомер, ИнформацияОСноске.НомерВТексте);
			КонецЕсли;
		
		ИначеЕсли ЗначениеЗаполнено(Фрагмент.ВизуализацияСодержанияТаблиц) Тогда
			
			ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементВизуализации);
			
			НастройкаВизуализации = Фрагмент.ВизуализацияСодержанияТаблиц[0];
			
			ТаблицаВизуализации = Лев(НастройкаВизуализации, 2);
			СтрокаВизуализации = Сред(НастройкаВизуализации, 4, 4);
			
			Если ТаблицаВизуализации <> НомерТекущейТаблицы Тогда
				ДобавитьЭлементВизуализацииВПредка(ЭлементТаблицы, ЭлементСтроки);
				ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементТаблицы);
				
				НомерТекущейТаблицы = ТаблицаВизуализации;
				ЭлементТаблицы = НоваяТаблицаВизуализации(ДокументHTML);
				ЭлементСтроки = Неопределено;
				ЭлементЯчейки = Неопределено; 
				
			КонецЕсли;
			
			Если СтрокаВизуализации <> НомерТекущейСтрокиТаблицы Тогда
				
				ДобавитьЭлементВизуализацииВПредка(ЭлементТаблицы, ЭлементСтроки);
				
				ЭлементСтроки = ДокументHTML.СоздатьЭлемент("tr");
				НомерТекущейСтрокиТаблицы = СтрокаВизуализации;
				
			КонецЕсли;
			
			ЭлементЯчейки = ДокументHTML.СоздатьЭлемент("td");
			Тег = "span";
			ЭлементКонтейнер = НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег);
			ЭлементЯчейки.ДобавитьДочерний(ЭлементКонтейнер);
			ЭлементСтроки.ДобавитьДочерний(ЭлементЯчейки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементВизуализации);
	ДобавитьЭлементВизуализацииВПредка(ЭлементТаблицы, ЭлементСтроки);
	ДобавитьЭлементВизуализацииВПредка(ЭлементТело, ЭлементТаблицы);
	ДобавитьЭлементВизуализацииВПредка(ЭлементТело, БлокСносок);
	
	СформироватьЗаголовокВизуализацииHTML(ДокументHTML, СтилиCSS);
	ДокументHTML.ЭлементДокумента.ДобавитьДочерний(ЭлементТело);
	
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML, ЗаписьHTML);
	Возврат ЗаписьHTML.Закрыть();
	
КонецФункции

Процедура ДобавитьНовыйАтрибут(ДокументHTML, ВладелецАтрибута, ИмяАтрибута, ЗначениеАтрибута)
	
	Атрибут = ДокументHTML.СоздатьАтрибут(ИмяАтрибута);
	
	Атрибут.Значение = ЗначениеАтрибута;
	
	ВладелецАтрибута.Атрибуты.УстановитьИменованныйЭлемент(Атрибут);
	
КонецПроцедуры

Процедура СформироватьЗаголовокВизуализацииHTML(ДокументHTML, СтилиCSS)

	ЭлементЗаголовок = ДокументHTML.СоздатьЭлемент("head");
	
	ЭлементМета1 = ДокументHTML.СоздатьЭлемент("meta");
	ДобавитьНовыйАтрибут(ДокументHTML, ЭлементМета1, "charset", "utf-8");
	ЭлементЗаголовок.ДобавитьДочерний(ЭлементМета1);
	
	ЭлементМета2 = ДокументHTML.СоздатьЭлемент("meta");
	ДобавитьНовыйАтрибут(ДокументHTML, ЭлементМета2, "content", "width=device-width, initial-scale=1");
	ЭлементЗаголовок.ДобавитьДочерний(ЭлементМета2);
	
	ЭлементСтили = ДокументHTML.СоздатьЭлемент("style");
	ДобавитьНовыйАтрибут(ДокументHTML, ЭлементСтили, "media", "screen");
	ЭлементСтили.ТекстовоеСодержимое = СтилиCSS;
	ЭлементЗаголовок.ДобавитьДочерний(ЭлементСтили);
	
	ДокументHTML.ЭлементДокумента.ДобавитьДочерний(ЭлементЗаголовок);
	
КонецПроцедуры

Функция НовыйЭлементВизуализации(ДокументHTML, Фрагмент, Тег)
	
	ЭлементВизуализации = ДокументHTML.СоздатьЭлемент(Тег);
	
	ДобавитьВыравниваниеЭлементаВизуализации(ДокументHTML, ЭлементВизуализации, Фрагмент.Выравнивание);
	
	ДобавитьИмяКлассаЭлементаВизуализации(ДокументHTML, ЭлементВизуализации, Фрагмент.ИмяСтиляФрагмента);
	
	ТекстовыйУзел = ДокументHTML.СоздатьТекстовыйУзел(Фрагмент.СодержаниеФрагмента);
	ЭлементВизуализации.ДобавитьДочерний(ТекстовыйУзел);
	
	Возврат ЭлементВизуализации;
	
КонецФункции

Функция НоваяТаблицаВизуализации(ДокументHTML)
	
	ТаблицаВизуализации = ДокументHTML.СоздатьЭлемент("table");
	ТаблицаВизуализации.РасстояниеМеждуЯчейками = "0";
	ТаблицаВизуализации.Рамка = "1";
	
	Возврат ТаблицаВизуализации;
	
КонецФункции

Процедура ДобавитьВыравниваниеЭлементаВизуализации(ДокументHTML, ЭлементВизуализации, Выравнивание)
	
	Если Выравнивание = "0" Тогда
		ЗначениеАтрибута = "left";
	ИначеЕсли Выравнивание = "1" Тогда
		ЗначениеАтрибута = "right";
	ИначеЕсли Выравнивание = "2" Тогда  
		ЗначениеАтрибута = "center";
	ИначеЕсли Выравнивание = "3" Тогда
		ЗначениеАтрибута = "justify";
	КонецЕсли; 
	
	ДобавитьНовыйАтрибут(ДокументHTML, ЭлементВизуализации, "align", ЗначениеАтрибута);
	
КонецПроцедуры

Процедура ДобавитьИмяКлассаЭлементаВизуализации(ДокументHTML, ЭлементВизуализации, ИмяКласса)
	
	ЭлементВизуализации.ИмяКласса = ИмяКласса;
	
КонецПроцедуры

Процедура ДобавитьЭлементВизуализацииВПредка(ЭлементПредок, ЭлементВизуализации)
	
	Если ЭлементВизуализации <> Неопределено Тогда
		
		ЭлементПредок.ДобавитьДочерний(ЭлементВизуализации);
		
	КонецЕсли;	
	
	ЭлементВизуализации = Неопределено;
	
КонецПроцедуры

Процедура ОбработатьДобавлениеСноски(ДокументHTML, БлокСносок, Фрагмент, НомерСноски)
	
	Сноска = ДокументHTML.СоздатьЭлемент("div");
	Якорь = ДокументHTML.СоздатьЭлемент("a");
	Якорь.Идентификатор = "footnoteResolver" + Строка(Фрагмент.СсылкаНаНомерФрагмента);
	Якорь.Гиперссылка = "#footnote" + Строка(Фрагмент.СсылкаНаНомерФрагмента);
	
	ТекстовыйУзел = ДокументHTML.СоздатьТекстовыйУзел(Строка(НомерСноски) + ". ");
	Якорь.ДобавитьДочерний(ТекстовыйУзел);
	Сноска.ДобавитьДочерний(Якорь);
	ТекстовыйУзел = ДокументHTML.СоздатьТекстовыйУзел(Фрагмент.СодержаниеФрагмента);
	Сноска.ДобавитьДочерний(ТекстовыйУзел);
	БлокСносок.ДобавитьДочерний(Сноска);
	
КонецПроцедуры

Процедура ОбработатьДобавлениеИдентификатораСноски(ДокументHTML, ЭлементВизуализации, ПорядковыйНомер, НомерВТексте)
	
	Якорь = ДокументHTML.СоздатьЭлемент("a");
	Якорь.Идентификатор = "footnote" + Строка(ПорядковыйНомер);
	Якорь.Гиперссылка = "#footnoteResolver" + Строка(ПорядковыйНомер);
	
	ТекстовыйУзел = ДокументHTML.СоздатьТекстовыйУзел("[" + Строка(НомерВТексте) + "]");
	Якорь.ДобавитьДочерний(ТекстовыйУзел);
	ЭлементВизуализации.ДобавитьДочерний(Якорь);
	
КонецПроцедуры

Процедура ПолучитьСтилиФрагмента(СтильОбъект, НоваяСтрока) 

	Если ТипЗнч(СтильОбъект) <> Тип("ОбъектXDTO") Тогда
	
		Возврат;
	
	КонецЕсли;

	СвойстваОбъектаXDTO = СтильОбъект.Свойства();
	
	Для Каждого СвойствоОбъекта Из СвойстваОбъектаXDTO Цикл
		
		ЗначениеСвойстваОбъекта = РаботаСФайламиБЭД.ЗначениеСвойстваXDTO(СтильОбъект, СвойствоОбъекта.Имя);
		
		Если СвойствоОбъекта.Имя = "name" Тогда
			НоваяСтрока.ИмяСтиляФрагмента = ЗначениеСвойстваОбъекта;
		Иначе
			
			Если ЗначениеЗаполнено(СокрЛП(ЗначениеСвойстваОбъекта)) Тогда
				
				ЛокальноеИмя = СвойствоОбъекта.ЛокальноеИмя;
				
				// Заменяем сolor - с русской буквой "с" на валидное значение для визуализации html
				Если ЛокальноеИмя = "сolor" Тогда
					ЛокальноеИмя = "color";
				КонецЕсли;
				
				НоваяСтрока.СтильФрагмента = НоваяСтрока.СтильФрагмента + ЛокальноеИмя + ":"
					+ ЗначениеСвойстваОбъекта + ";" + Символы.ПС;
				
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЦикла;
	
	// Если существуют настройки стиля, но отсутствует имя, то генерируем автоматическое имя.
	Если ЗначениеЗаполнено(НоваяСтрока.СтильФрагмента) И Не ЗначениеЗаполнено(НоваяСтрока.ИмяСтиляФрагмента) Тогда
		НоваяСтрока.ИмяСтиляФрагмента = СтрШаблон("style_%1", Формат(НоваяСтрока.ПорядковыйНомер, "ЧГ=0"));
	КонецЕсли;
	
КонецПроцедуры

Функция ТаблицаСносок()
	
	ТаблицаСносок = Новый ТаблицаЗначений;
	ТаблицаСносок.Колонки.Добавить("ПорядковыйНомер", Новый ОписаниеТипов("Число"));
	ТаблицаСносок.Колонки.Добавить("СсылкаНаНомерФрагмента", Новый ОписаниеТипов("Число"));
	ТаблицаСносок.Колонки.Добавить("НомерВТексте", Новый ОписаниеТипов("Число"));
	
	Возврат ТаблицаСносок;
	
КонецФункции

#КонецОбласти

Функция ПолучитьДанныеФайлаXDTO(Знач ДвоичныеДанные)
	
	ОписаниеФайла = РаботаСФайламиБЭДКлиентСервер.НовоеОписаниеФайла();
	
	ОписаниеФайла.ДвоичныеДанные = ДвоичныеДанные;
	ОписаниеФайла.ИмяФайла = "ON_SODSD_1_999_02_01_01_01.xml";
	ОписаниеОшибки = "";
	
	ДанныеФайлаЭД = ФорматыЭДО.ДанныеФайлаЭД(ОписаниеФайла, ОписаниеОшибки, ПространствоИмен());
	
	Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДанныеФайлаЭД;
	
КонецФункции

// Возвращаемое значение:
//  Структура:
//   * ПредставлениеДокумента -  Строка, Неопределено - HTML-представление документа.
//   * Успех - Булево - Документ сформирован.
//
Функция РезультатФормированияДанныхДокумента()
	
	РезультатФормирования = Новый Структура;
	РезультатФормирования.Вставить("ПредставлениеДокумента", Неопределено);
	РезультатФормирования.Вставить("Успех", Ложь);
	
	Возврат РезультатФормирования;
	
КонецФункции

// Заменить описание сообщения подготовленными данными.
// 
// Параметры:
//  РезультатПодготовкиДанных - см. ИнтерфейсДокументовЭДО.ПодготовитьДанныеПредварительногоПросмотра
//  ПомещенныйФайл - Структура:
//   * Имя      - Строка - Имя файла.
//   * Хранение - Строка - Адрес временного хранилища двоичных данных файла.
//
Процедура ЗаменитьОписаниеСообщенияПодготовленнымиДанными(РезультатПодготовкиДанных, ПомещенныйФайл) Экспорт
	
	АдресаОписанийСообщений = ПолучитьИзВременногоХранилища(РезультатПодготовкиДанных.АдресаОписанийСообщений);
	
	Для Каждого АдресОписанияСообщения Из АдресаОписанийСообщений Цикл
	
		ПодготовленныеПараметры = ПолучитьИзВременногоХранилища(АдресОписанияСообщения);
		ПодготовленныеПараметры.Данные.Документ.ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение);
		
		Содержание = ФорматыЭДО.ПрочитатьСодержаниеДокумента(ПодготовленныеПараметры.Данные.Документ);
		Если Содержание <> Неопределено Тогда
			ПодготовленныеПараметры.Данные.Содержание = Содержание;
		КонецЕсли;
		
		АдресОписанияСообщения = ПоместитьВоВременноеХранилище(ПодготовленныеПараметры,
			Новый УникальныйИдентификатор());
		
	КонецЦикла;
	
	РезультатПодготовкиДанных.АдресаОписанийСообщений = ПоместитьВоВременноеХранилище(АдресаОписанийСообщений,
		Новый УникальныйИдентификатор());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
