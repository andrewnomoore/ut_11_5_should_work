
#Область СлужебныйПрограммныйИнтерфейс

// Инициализирует настройки формирования электронного документа по учету.
//
// Возвращаемое значение:
//  Структура - параметры формирования:
//   * Организация - ОпределяемыеТипы.Организации - вид документа.
//   * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО - вид документа.
//
Функция НовыеНастройкиФормированияДокумента() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация");
	Параметры.Вставить("ВидДокумента");
		
	Возврат Параметры;
	
КонецФункции

// Формирует электронный документ основного титула по учету.
//
// Параметры:
//  ОбъектУчета - ОпределяемыеТипы.ОснованияЭлектронныхДокументовЭДО
//  Настройки - см. НовыеНастройкиФормированияДокумента
//
// Возвращаемое значение:
//  См. НовыйРезультатФормированияДокумента
//
Функция СформироватьДанныеВнутреннегоДокумента(ОбъектУчета, Настройки) Экспорт
	
	ДанныеДокумента = СформироватьДокумент(ОбъектУчета, Настройки.ВидДокумента);
	
	РезультатФормирования = НовыйРезультатФормированияДокумента();
		
	Если ДанныеДокумента = Неопределено Тогда
		
		РезультатФормирования.ЕстьОшибки = Истина;
		ОбщегоНазначенияБЭД.ДобавитьОшибку(РезультатФормирования.Ошибки.ЗаполнениеДанных, СтрШаблон(НСтр(
		"ru = 'Нет данных для формирования внутреннего документа %1'", Настройки.ВидДокумента)));
	
		Возврат РезультатФормирования;
	КонецЕсли;
	
	РезультатФормирования.Документ = ДанныеДокумента;
	РезультатФормирования.Содержание.ИдентификаторДокумента = Строка(ОбъектУчета.УникальныйИдентификатор());
	РезультатФормирования.Содержание.ТипРегламента = Перечисления.ТипыРегламентовЭДО.Неформализованный;
	РезультатФормирования.Содержание.Организация = Настройки.Организация;
	РезультатФормирования.Содержание.НомерДокумента = ДанныеДокумента.НомерДокумента;
	РезультатФормирования.Содержание.ДатаДокумента = ДанныеДокумента.ДатаДокумента;
	
	РезультатФормирования.Содержание.НаборОбъектовУчета.Добавить(ОбъектУчета);

	Возврат РезультатФормирования;
	
КонецФункции


Функция ПредставлениеДанныхВнутреннегоДокумента(ДвоичныеДанныеАрхива) Экспорт
	
	КаталогРаспаковки = ФайловаяСистема.СоздатьВременныйКаталог();
	ПараметрыРаспаковки = РаботаСФайламиБЭД.НовыеПараметрыРаспаковкиАрхива();
	ПараметрыРаспаковки.ВосстанавливатьКаталоги = РежимВосстановленияПутейФайловZIP.Восстанавливать;;
	
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
	РезультатФормирования = Новый Структура;
	РезультатФормирования.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	РезультатФормирования.Вставить("ПредставлениеДокумента", Неопределено);
	РезультатФормирования.Вставить("Успех", Ложь);
	
	РаспакованныеФайлы = РаботаСФайламиБЭД.РаспаковатьАрхив(ДвоичныеДанныеАрхива, КаталогРаспаковки, КонтекстДиагностики,
		НСтр("ru = 'Распаковка архива внутреннего ЭД'"), ПараметрыРаспаковки);
	
	Для Каждого РаспакованныйФайл Из РаспакованныеФайлы Цикл
		Если ВРег(РаспакованныйФайл.Расширение) = ".MXL" Тогда
			ИмяФайлаДанных = РаспакованныйФайл.ПолноеИмя;
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ТабличныйДокумент.Прочитать(ИмяФайлаДанных);
			РаботаСФайламиБЭД.УдалитьВременныеФайлы(КаталогРаспаковки);
			РезультатФормирования.ПредставлениеДокумента = ТабличныйДокумент;
			РезультатФормирования.Успех = Истина;
		КонецЕсли;
	КонецЦикла;
	
	РаботаСФайламиБЭД.УдалитьВременныеФайлы(КаталогРаспаковки);
	Возврат РезультатФормирования;
	
КонецФункции

// Проверяет актуальность двоичных данных во внутреннем документообороте.
//
// Параметры:
//  ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО.
//  ВидЭлектронногоДокумента - СправочникСсылка.ВидыДокументовЭДО.
//  ДвоичныеДанныеАрхива - ДвоичныеДанные.
//
// Возвращаемое значение:
//  Булево - Результат проверки текущего и архивного ОбъектУчета.
//
Функция ВнутреннийДокументооборотАктуален(ОбъектУчета, ВидЭлектронногоДокумента, ДвоичныеДанныеАрхива) Экспорт
	
	МетаданныеОбъекта = ОбъектУчета.Метаданные();
	
	ПолноеИмяФормы = МетаданныеОбъекта.ОсновнаяФормаОбъекта.Имя;
	СписокОбъектов = Новый Массив();
	СписокОбъектов.Добавить(МетаданныеОбъекта);
	
	КомандыПечати = УправлениеПечатью.КомандыПечатиФормы(ПолноеИмяФормы, СписокОбъектов);
	НайденнаяКоманда = КомандыПечати.Найти(ВидЭлектронногоДокумента.ИдентификаторКомандыПечати, "Идентификатор"); 
	
	КомандаПечатиВФайл = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(НайденнаяКоманда);	
	КомандаПечатиВФайл.ДополнительныеПараметры.Вставить("ИсключитьШтампы");
	
	МассивОбъектовУчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектУчета);
	
	НастройкиСохранения = УправлениеПечатью.НастройкиСохранения();
	НастройкиСохранения.ФорматыСохранения.Добавить(ТипФайлаТабличногоДокумента.MXL);
	НастройкиСохранения.ПереводитьИменаФайловВТранслит = Истина;
	
	РезультатПечати = УправлениеПечатью.НапечататьВФайл(КомандаПечатиВФайл, МассивОбъектовУчета, НастройкиСохранения);
	
	Если Не ЗначениеЗаполнено(РезультатПечати) Тогда
		Возврат Ложь;
	КонецЕсли;

	ДанныеТекущегоПредставления = РезультатПечати[0].ДвоичныеДанные;
	ТекущийТабличныйДокумент = ТабличныйДокументПоДвоичнымДанным(ДанныеТекущегоПредставления);
	ТекущийТабличныйДокументСтрокой = ТабличныйДокументСтрокой(ТекущийТабличныйДокумент);
	
	СуществующийТабличныйДокумент = ПредставлениеДанныхВнутреннегоДокумента(ДвоичныеДанныеАрхива).ПредставлениеДокумента;
	СуществующийТабличныйДокументСтрокой = ТабличныйДокументСтрокой(СуществующийТабличныйДокумент);
	
	Возврат ТекущийТабличныйДокументСтрокой = СуществующийТабличныйДокументСтрокой;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьДокумент(ОбъектУчета, ВидДокумента)
	
	ДвоичныеДанныеДокумента = ДвоичныеДанныеДокумента(ОбъектУчета, ВидДокумента);
	
	Если ДвоичныеДанныеДокумента = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Описание = Новый Структура;
	Описание.Вставить("ДвоичныеДанные",  ДвоичныеДанныеДокумента);
	
	Реквизиты = "Номер,Дата";
	ЗначенияРеквизитов = ИнтеграцияЭДО.ЗначенияРеквизитовОбъектаУчета(ОбъектУчета, Реквизиты);
	
	ПечатныйНомер = "";
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьПечатныйНомерДокумента(ОбъектУчета, ПечатныйНомер);
	
	Если ЗначениеЗаполнено(ПечатныйНомер) Тогда
		НомерДокумента = ПечатныйНомер;
	ИначеЕсли ЗначениеЗаполнено(ЗначенияРеквизитов.Номер) Тогда
		НомерДокумента = ЗначенияРеквизитов.Номер;
	КонецЕсли;
	
	ДатаДокумента = ЗначенияРеквизитов.Дата;
	
	ПараметрыПредставления = ЭлектронныеДокументыЭДО.НовыеСвойстваПредставленияДокумента();
	ПараметрыПредставления.ВидДокумента = ВидДокумента;
	ПараметрыПредставления.НомерДокумента = НомерДокумента;
	ПараметрыПредставления.ДатаДокумента = ДатаДокумента;
	
	ПредставлениеДокумента = ЭлектронныеДокументыЭДО.ПредставлениеДокументаПоСвойствам(ПараметрыПредставления);
	ПредставлениеДокументаЛатиницей = СтроковыеФункции.СтрокаЛатиницей(ПредставлениеДокумента);
	
	ИмяБезРасширения = СтрШаблон("%1_ver_%2", ПредставлениеДокументаЛатиницей,
		Формат(ТекущаяДатаСеанса(), "ДФ=yyyy-MM-dd_HH-mm-ss; ДП=_"));
	ИмяБезРасширения = СтрЗаменить(ИмяБезРасширения, " ", "_");
	ИмяБезРасширения = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяБезРасширения, "_");
	
	ПолноеИмяФайла = ИмяБезРасширения + ".zip";
	
	Описание.Вставить("ИмяФайла", ПолноеИмяФайла);
	Описание.Вставить("ИмяФайлаБезРасширения", ИмяБезРасширения);
	Описание.Вставить("ДатаДокумента", ДатаДокумента);
	Описание.Вставить("НомерДокумента", НомерДокумента);
	
	Возврат Описание;
	
КонецФункции

// Получает двоичные данные документа ЭДО.
//
// Параметры:
//  ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО.
//  ВидДокумента - СправочникСсылка.ВидыДокументовЭДО.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - Если найдены данные, то возврат двоичных данных иначе неопределено.
//
Функция ДвоичныеДанныеДокумента(ОбъектУчета, ВидДокумента)
	
	МетаданныеОбъекта = ОбъектУчета.Метаданные();
	
	ПолноеИмяФормы = МетаданныеОбъекта.ОсновнаяФормаОбъекта.Имя;
	СписокОбъектов = Новый Массив();
	СписокОбъектов.Добавить(МетаданныеОбъекта);
	
	КомандыПечати = УправлениеПечатью.КомандыПечатиФормы(ПолноеИмяФормы, СписокОбъектов);
	НайденнаяКоманда = КомандыПечати.Найти(ВидДокумента.ИдентификаторКомандыПечати, "Идентификатор");
	Если НайденнаяКоманда = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КомандаПечатиВФайл = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(НайденнаяКоманда);
	
	МассивОбъектовУчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектУчета);
	
	НастройкиСохранения = УправлениеПечатью.НастройкиСохранения();
	НастройкиСохранения.ФорматыСохранения.Добавить(ТипФайлаТабличногоДокумента.MXL);
	НастройкиСохранения.ФорматыСохранения.Добавить(ТипФайлаТабличногоДокумента.PDF);
	НастройкиСохранения.УпаковатьВАрхив = Истина;
	НастройкиСохранения.ПереводитьИменаФайловВТранслит = Истина;
	
	РезультатПечати = УправлениеПечатью.НапечататьВФайл(КомандаПечатиВФайл, МассивОбъектовУчета, НастройкиСохранения);

	Если ЗначениеЗаполнено(РезультатПечати) Тогда
		Возврат РезультатПечати[0].ДвоичныеДанные;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Инициализирует результат формирования документа по учету.
//
// Возвращаемое значение:
//  Структура - результат формирования:
//   * Документ - см. РаботаСФайламиБЭД.НовоеОписаниеФайла
//   * ДополнительныйДокумент - см. РаботаСФайламиБЭД.НовоеОписаниеФайла
//   * Содержание - см. НовоеСодержаниеДокумента
//   * Ошибки - Структура - ошибки при формировании документа.
//		** ЗаполнениеДанных - Массив - ошибки заполнения данных. 
//   * ЕстьОшибки - Булево - признак наличия ошибок формирования документа.
//
Функция НовыйРезультатФормированияДокумента()
		
	Результат = Новый Структура;
	Результат.Вставить("Документ", РаботаСФайламиБЭД.НовоеОписаниеФайла());
	Результат.Вставить("ДополнительныйДокумент", РаботаСФайламиБЭД.НовоеОписаниеФайла());
	Результат.Вставить("Содержание", НовоеСодержаниеДокумента());
	Результат.Вставить("Ошибки", Новый Структура("ЗаполнениеДанных, ЗначенияДополнительныхПолей", Новый Массив,
		Новый Массив));
	Результат.Вставить("ЕстьОшибки", Ложь);
		
	Возврат Результат;
	
КонецФункции

// Инициализирует содержание документа.
//
// Возвращаемое значение:
//  Структура:
//   * ИдентификаторДокумента - Строка
//   * НомерДокумента - Строка
//   * ТипДокумента - ПеречислениеСсылка.ТипыДокументовЭДО
//   * ТипРегламента - ПеречислениеСсылка.ТипыРегламентовЭДО
//   * ДатаДокумента - Дата
//   * СуммаДокумента - Число
//   * НаборОбъектовУчета - Массив из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//   * СвязанныеОбъектыУчета - Массив из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//   * ЕстьМаркировка - Булево
//   * Организация - ОпределяемыйТип.Организация
//   * Контрагент - ОпределяемыйТип.КонтрагентБЭД
//   * Формат - Строка
//
Функция НовоеСодержаниеДокумента()
	
	Содержание = Новый Структура;
	Содержание.Вставить("ИдентификаторДокумента", "");
	Содержание.Вставить("ТипРегламента", Перечисления.ТипыРегламентовЭДО.ПустаяСсылка());
	Содержание.Вставить("ТипДокумента", Перечисления.ТипыДокументовЭДО.ПустаяСсылка());
	Содержание.Вставить("НомерДокумента", "");
	Содержание.Вставить("ДатаДокумента", Дата(1,1,1));
	Содержание.Вставить("СуммаДокумента", 0);
	Содержание.Вставить("НаборОбъектовУчета", Новый Массив);
	Содержание.Вставить("СвязанныеОбъектыУчета", Новый Массив);
	Содержание.Вставить("ЕстьМаркировка", Ложь);
	Содержание.Вставить("Организация", Метаданные.ОпределяемыеТипы.Организация.Тип.ПривестиЗначение());
	Содержание.Вставить("Контрагент", Метаданные.ОпределяемыеТипы.КонтрагентБЭД.Тип.ПривестиЗначение());
	Содержание.Вставить("Формат", "");
	
	Возврат Содержание;
	
КонецФункции

Функция ТабличныйДокументПоДвоичнымДанным(ДвоичныеДанныеДокумента)
	
	Результат = Новый ТабличныйДокумент;
	
	Поток = ДвоичныеДанныеДокумента.ОткрытьПотокДляЧтения();
	Результат.Прочитать(Поток);
	
	Возврат Результат;
	
КонецФункции

Функция ТабличныйДокументСтрокой(ТабличныйДокумент)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ТабличныйДокумент);
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

#КонецОбласти