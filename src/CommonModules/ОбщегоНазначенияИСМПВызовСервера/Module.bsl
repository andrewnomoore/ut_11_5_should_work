#Область ПрограммныйИнтерфейс

Функция ЭтоРасширеннаяВерсияГосИС() Экспорт
	
	Возврат ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС();
	
КонецФункции

//Возвращает признак запроса данных из сервиса ИС МП.
//
//Возвращаемое значение:
//   Булево - Истина, в случае необходимости запроса данных сервиса.
//
Функция ЗапрашиватьДанныеСервиса() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ЗапрашиватьДанныеСервисаИСМП");

КонецФункции

// Возвращает признак включения режима работы с тестовым контуром ИС МП
//
// Возвращаемое значение:
//  Булево - Истина, если включен режим работы с тестовым контуром ИС МП.
//
Функция РежимРаботыСТестовымКонтуромИСМП() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("РежимРаботыСТестовымКонтуромИСМП");
	
КонецФункции

// Возвращает признак ведения учета маркируемой продукци переданного вида.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
// Возвращаемое значение:
// 	Булево - признак ведения учета маркируемой продукции переданного вида.
//
Функция ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции = Неопределено) Экспорт
	
	Если ВидМаркируемойПродукции = Неопределено Тогда
		
		Если ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС() Тогда
			//@skip-check wrong-string-literal-content
			Возврат ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП");
		Иначе
			Возврат ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМПРМК");
		КонецЕсли;

	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ПустаяСсылка() Тогда
		
		Если ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС() Тогда
			//@skip-check wrong-string-literal-content
			Возврат ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП");
		Иначе
			Возврат ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМПРМК");
		КонецЕсли;
		
	ИначеЕсли ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияИСМП(ВидМаркируемойПродукции, Истина) Тогда
		
		Возврат ОбщегоНазначенияИСМП.ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции);
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Возвращает настройки сканирования кодов маркировки ИС МП.
//
// Возвращаемое значение:
//  Булево - Истина, в случае необходимости контроля статусов.
Функция НастройкиСканированияКодовМаркировки() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ЗапрашиватьДанныеСервисаИСМП", ПолучитьФункциональнуюОпцию("ЗапрашиватьДанныеСервисаИСМП"));
	Результат.Вставить("ПараметрыКонтроляСтатусов",    НастройкаПараметровСканированияСлужебныйКлиентСервер.НоваяГруппаПараметровНастройки());
	Результат.Вставить("ПараметрыКонтроляВладельцев",  НастройкаПараметровСканированияСлужебныйКлиентСервер.НоваяГруппаПараметровНастройки());
	
	Результат.Вставить("ПараметрыИгнорированияПроверкиККТ", НастройкаПараметровСканированияСлужебныйКлиентСервер.НоваяГруппаПараметровНастройки(Ложь));
	Результат.Вставить("РежимКонтроляСредствамиККТ",        "");
	Результат.Вставить("ПропускатьПроверкуСредствамиККТ",   Ложь);
	
	Результат.Вставить("КонтролироватьСтандартнуюВложенность",      Ложь);
	Результат.Вставить("ПропускатьСтрокиСОшибкамиПриЗагрузкеИзТСД", Истина);
	Результат.Вставить("ПроверятьАлфавитКодовМаркировки",           Истина);
	
	Результат.Вставить("ПроверятьСтруктуруКодовМаркировки", Истина);
	
	Результат.Вставить("КоличествоКодовВПакетеДляЗапросаСтатусов", 500);

	Результат.Вставить("СлужебныйШтрихкодПечатиУпаковки", "");
	// Табачная продукция
	Результат.Вставить("ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП",          Истина);
	Результат.Вставить("ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП", Истина);
	Результат.Вставить("УчитыватьМРЦ",                                                       Истина);
	Результат.Вставить("ДатаПроизводстваНачалаКонтроляСтатусовКодовМаркировкиМОТП",          ОбщегоНазначенияИСМПКлиентСервер.ДатаНачалаКонтроляКодовМаркировкиМОТП());
	// Весовая продукция
	Результат.Вставить("ЗапрашиватьКоличествоМерногоТовара", Истина);
	// Частичное выбытие
	Результат.Вставить("ПодбиратьКодыМаркировкиВскрытыхПотребительскихУпаковокПоFIFO", Ложь);

	// Разрешительный режим розничной продажи
	Результат.Вставить("ИспользоватьПроверкуРозничнымМетодомДляОпределенныхТоварныхГрупп", Истина); // устарела, не используется
	Результат.Вставить("ВремяБлокировкиCDNПлощадок",                                       15);     // в минутах
	Результат.Вставить("ВремяОтветаCDNПлощадокПриПробитииЧека",                            1.5);    // в секундах
	Результат.Вставить("ЧастотаОбновленияCDNПлощадок",                                     6);      // в часах
	Результат.Вставить("СрокДействияИдентификатораРазрешительногоРежима",                  300);    // в секундах
	Результат.Вставить("АварийноеОтключенияРазрешительногоРежимаДоУниверсальнаяДата",      Дата(1, 1, 1));
	
	УстановитьПривилегированныйРежим(Истина);
	ЗначениеКонстанты = Константы.НастройкиСканированияКодовМаркировкиИСМП.Получить().Получить();
	Если ТипЗнч(ЗначениеКонстанты) = Тип("Структура") Тогда
		ИсключаемыеСвойства = Новый Массив();
		Если ЗначениеКонстанты.Свойство("ПараметрыКонтроляСтатусов") Тогда
			ЗаполнитьЗначенияСвойств(Результат.ПараметрыКонтроляСтатусов, ЗначениеКонстанты.ПараметрыКонтроляСтатусов);
			УбратьОбязательныеТоварныеГруппыПриПродажеВРозницуИзИсключений(Результат.ПараметрыКонтроляСтатусов);
			ИсключаемыеСвойства.Добавить("ПараметрыКонтроляСтатусов");
		КонецЕсли;
		Если ЗначениеКонстанты.Свойство("ПараметрыКонтроляВладельцев") Тогда
			ЗаполнитьЗначенияСвойств(Результат.ПараметрыКонтроляВладельцев, ЗначениеКонстанты.ПараметрыКонтроляВладельцев);
			УбратьОбязательныеТоварныеГруппыПриПродажеВРозницуИзИсключений(Результат.ПараметрыКонтроляВладельцев);
			ИсключаемыеСвойства.Добавить("ПараметрыКонтроляВладельцев");
		КонецЕсли;
		Если ЗначениеКонстанты.Свойство("ПараметрыИгнорированияПроверкиККТ") Тогда
			ЗаполнитьЗначенияСвойств(Результат.ПараметрыИгнорированияПроверкиККТ, ЗначениеКонстанты.ПараметрыИгнорированияПроверкиККТ);
			ИсключаемыеСвойства.Добавить("ПараметрыИгнорированияПроверкиККТ");
		Иначе
			Если ЗначениеКонстанты.Свойство("ПараметрыКонтроляСредствамиККТ") Тогда
				Если ЗначениеКонстанты.ПараметрыКонтроляСредствамиККТ.Включено Тогда
					Если ЗначениеКонстанты.ПараметрыКонтроляСредствамиККТ.Исключения.Количество() Тогда
						ВключитьИгнорирование  = Ложь;
						ПараметрыКонтроля      = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПараметрыКонтроля();
						ДопустимыеВидыОперации = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций(ПараметрыКонтроля.ПараметрыИгнорированияПроверкиККТ);
						Для Каждого КлючИЗначение Из ЗначениеКонстанты.ПараметрыКонтроляСредствамиККТ.Исключения Цикл
							ВидПродукции = КлючИЗначение.Ключ;
							Если КлючИЗначение.Значение.Количество() Тогда
								Для Каждого КлючИЗначениеОперация Из КлючИЗначение.Значение Цикл
									ВидОперации = КлючИЗначениеОперация.Ключ;
									Если ДопустимыеВидыОперации.НайтиПоЗначению(ВидОперации) <> Неопределено Тогда
										ВключитьИгнорирование = Истина;
										ОперацииПоВидуПродукции = Результат.ПараметрыИгнорированияПроверкиККТ.Исключения[ВидПродукции];
										Если ОперацииПоВидуПродукции = Неопределено Тогда
											ОперацииПоВидуПродукции = Новый Соответствие();
											Результат.ПараметрыИгнорированияПроверкиККТ.Исключения.Вставить(ВидПродукции, ОперацииПоВидуПродукции);
										КонецЕсли;
										ОперацииПоВидуПродукции.Вставить(ВидОперации, Истина);
									КонецЕсли;
								КонецЦикла;
							Иначе
								Результат.ПараметрыИгнорированияПроверкиККТ.Исключения.Вставить(ВидПродукции, Новый Соответствие());
							КонецЕсли;
						КонецЦикла;
						Результат.ПараметрыИгнорированияПроверкиККТ.Включено = ВключитьИгнорирование;
					КонецЕсли;
				Иначе
					Результат.ПараметрыИгнорированияПроверкиККТ.Включено = Истина;
				КонецЕсли;
				Если Результат.ПараметрыИгнорированияПроверкиККТ.Включено Тогда
					Результат.ПараметрыИгнорированияПроверкиККТ.ВариантОтображения = ЗначениеКонстанты.ПараметрыКонтроляСредствамиККТ.ВариантОтображения;
					Результат.ПропускатьПроверкуСредствамиККТ = Ложь;
					Если ЗначениеКонстанты.Свойство("ПропускатьПроверкуСредствамиККТ") Тогда
						ИсключаемыеСвойства.Добавить("ПропускатьПроверкуСредствамиККТ");
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Результат, ЗначениеКонстанты,, СтрСоединить(ИсключаемыеСвойства, ","));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//Возвращает учитываемые виды маркируемой продукции.
//  При вызове с параметрами -только находящиеся в тестовом/обязательном периоде эксплуатации.
//
//Параметры:
//   НаДату - Неопределено - все учитываемые
//          - Дата - требуется получение только видов продукции в тестовом/обязательном периоде на указанную дату
//   ТестовыйПериод - Булево - признак тестового периода
//
// Возвращаемое значение:
//   ФиксированныйМассив Из ПеречислениеСсылка.ВидыПродукцииИС - учитываемые виды маркируемой продукции.
//
Функция УчитываемыеВидыМаркируемойПродукции(НаДату = Неопределено, ТестовыйПериод = Ложь) Экспорт
	
	ВидыПродукции = Новый Массив;
	
	ИмяФункциональнойОпцииВестиУчет = "";
	
	Если ОбщегоНазначенияИС.ЭтоРасширеннаяВерсияГосИС() Тогда
		ИмяФункциональнойОпцииВестиУчет = "ВестиУчетМаркируемойПродукцииИСМП";
	Иначе
		ИмяФункциональнойОпцииВестиУчет = "ВестиУчетМаркируемойПродукцииИСМПРМК";
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию(ИмяФункциональнойОпцииВестиУчет) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	Настройки.ВидПродукции КАК ВидПродукции,
		|	Настройки.ДатаОбязательнойМаркировки КАК ДатаОбязательнойМаркировки
		|ИЗ
		|	РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП КАК Настройки
		|ГДЕ
		|	Настройки.ВестиУчетПродукции";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если НаДату = Неопределено Тогда
				ВидыПродукции.Добавить(Выборка.ВидПродукции);
			ИначеЕсли ТестовыйПериод = (НаДату < Выборка.ДатаОбязательнойМаркировки) Тогда
				ВидыПродукции.Добавить(Выборка.ВидПродукции);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(ВидыПродукции);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазрешительныйРежимРозничныхПродаж

// Включает аварийный режим на определенное пользователем время;
// Аварийный режим подразумевает полное отключение запросов к ГИС МТ и розничную продажу
// отслеживаемых товарных групп без проверок разрешительного режима
// 
// Параметры:
//  СрокДействияВЧасах - Число - Срок включения аварийного режима в часах
Процедура ВключитьАварийныйРежимРазрешительнойСистемы(СрокДействияВЧасах) Экспорт
	
	ОбщегоНазначенияИСМП.ВключитьАварийныйРежимРазрешительнойСистемы(СрокДействияВЧасах);
	
КонецПроцедуры

// Отключает действие аварийного режима
// Действие разрешительного режима возобновляется в штатном режиме
//
Процедура ОтключитьАварийныйРежимРазрешительнойСистемы() Экспорт
	
	ОбщегоНазначенияИСМП.ОтключитьАварийныйРежимРазрешительнойСистемы();
	
КонецПроцедуры

// Возвращает признак необходимости обновления списка CDN-площадок
// 
// Возвращаемое значение:
//  Булево - Истина, если все площадки обновлены ранее, чем указанное в настройках количество часов назад
Функция ПроверитьНеобходимостьОбновленияCDNПлощадок() Экспорт
	
	ТекущиеУчитываемыеТГОбязательнойОнлайнПроверки = СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницуНаДату();
	
	Если ТекущиеУчитываемыеТГОбязательнойОнлайнПроверки.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Истина КАК ЕстьАктуальныеПлощадки
		|ИЗ
		|	РегистрСведений.СостоянияCDNПлощадокИСМП КАК CDNПлощадкиИСМП
		|ГДЕ
		|	ДОБАВИТЬКДАТЕ(CDNПлощадкиИСМП.ДатаОбновленияУниверсальная, ЧАС,
		|		&ВремяОбновленияПлощадок) >= &ТекущаяУниверсальнаяДата";
	
	Запрос.УстановитьПараметр("ВремяОбновленияПлощадок",  ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ЧастотаОбновленияCDNПлощадок());
	Запрос.УстановитьПараметр("ТекущаяУниверсальнаяДата", ТекущаяУниверсальнаяДата());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	// если результат пустой, все площадки просрочены. надо обновить
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

// Возвращает признак действия аварийного режима при розничных продажах
//  Запросы разрешительного режима не выполняются, их результаты не контролируются
// 
// Возвращаемое значение:
//  Булево - Истина, если аварийный режим включен
Функция ДействуетАварийныйРежимДляРозничныхПродаж() Экспорт
	
	НастройкиСканирования = НастройкиСканированияКодовМаркировки();
	ДатаДействияАварийногоРежима = НастройкиСканирования.АварийноеОтключенияРазрешительногоРежимаДоУниверсальнаяДата;
	
	Возврат ДатаДействияАварийногоРежима > ТекущаяУниверсальнаяДата();
	
КонецФункции

// Возвращает список товарных групп для обязательной проверки разрешительного режима
//  при розничной продажи на конкретную дату
// 
// Параметры:
//  НаДату - Дата - дата проверки
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.ВидыПродукцииИС
Функция СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницуНаДату(НаДату = Неопределено) Экспорт
	
	//@skip-check wrong-string-literal-content
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП");
	//@skip-check unknown-method-property
	Возврат МенеджерОбъекта.СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницуНаДату(НаДату);
	
КонецФункции

// Возвращает список учитываемых товарных групп для обязательной проверки разрешительного режима
//  при розничной продажи
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.ВидыПродукцииИС
Функция СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницу() Экспорт
	
	//@skip-check wrong-string-literal-content
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП");
	//@skip-check unknown-method-property
	Возврат МенеджерОбъекта.СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницу();
	
КонецФункции

Функция НачатьПолучениеИдентификаторовЗапросаГИСМТПриРозничнойПродаже(ПараметрыСканирования, ДанныеДляЗапроса, УникальныйИдентификатор) Экспорт
	
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыПроцедуры.Вставить("УникальныйИдентификатор",          УникальныйИдентификатор);
	ПараметрыПроцедуры.Вставить("ПараметрыСканирования",            ПараметрыСканирования);
	ПараметрыПроцедуры.Вставить("ДанныеДляЗапроса",                 ДанныеДляЗапроса);
	ПараметрыПроцедуры.Вставить("ПараметрыЛогированияЗапросовИСМП", ПараметрыСеанса.ПараметрыЛогированияЗапросовИСМП);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Фоновое получение идентификаторов запроса ГИС МТ при розничной продаже'");
	
	Если ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульИнтеграцияИСПереопределяемый = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСПереопределяемый");
		МодульИнтеграцияИСПереопределяемый.НастроитьДлительнуюОперацию(ПараметрыПроцедуры, ПараметрыВыполнения);
	КонецЕсли;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ОбщегоНазначенияИСМПВызовСервера.ПолучитьСокращеннуюИнформациюПоКМДлительнаяОперация",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

Процедура ПолучитьСокращеннуюИнформациюПоКМДлительнаяОперация(Параметры, АдресРезультата) Экспорт
	
	Результат = Новый Соответствие();
	
	СписокДанныхШтрихкодов = Новый Массив;
	
	ПараметрыСканированияЛокальные = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ПараметрыСканирования, Ложь);
	
	ПараметрыСканированияЛокальные.РазрешеноЗапрашиватьКодМаркировки = Ложь;
	ПараметрыСканированияЛокальные.КэшМаркируемойПродукции           = Неопределено;
	ПараметрыСканированияЛокальные.ВыводитьСообщенияОбОшибках        = Ложь;
	ПараметрыСканированияЛокальные.ИспользуетсяСоответствиеШтрихкодовСтрокДерева = Ложь;
	ПараметрыСканированияЛокальные.ВозможнаЗагрузкаТСД               = Ложь;
	
	ЛогированиеЗапросовИСМП.УстановитьПараметрыЛогированияЗапросов(Параметры.ПараметрыЛогированияЗапросовИСМП);
	ЛогированиеЗапросовИС.НастроитьПараметрыЛогированияВФоновомЗадании(Параметры.ПараметрыЛогированияЗапросовИСМП);
	ЛогированиеЗапросовИСМП.УстановитьПараметрыЛогированияЗапросов(Параметры.ПараметрыЛогированияЗапросовИСМП);
	
	КоличествоДанных                = Параметры.ДанныеДляЗапроса.Количество();
	КоличествоОбработано            = 0;
	СоответствиеКодаИндексаЭлемента = Новый Соответствие();
	
	Шаблон = НСтр("ru = 'Обработано %1 из %2 кодов маркировки.'");
	
	Для Каждого ЭлементДанных Из Параметры.ДанныеДляЗапроса Цикл
		
		СтруктураКодаМаркировки = Новый Структура();
		СтруктураКодаМаркировки.Вставить("ПолныйКодМаркировки",          "");
		СтруктураКодаМаркировки.Вставить("НормализованныйКодМаркировки", "");
		СтруктураКодаМаркировки.Вставить("ВидПродукции",                 Перечисления.ВидыПродукцииИС.ПустаяСсылка());
		СтруктураКодаМаркировки.Вставить("СоставКодаМаркировки",         Новый Структура);
		СтруктураКодаМаркировки.Вставить("ПредставлениеНоменклатуры",    "");
		
		ЗаполнитьЗначенияСвойств(СтруктураКодаМаркировки, ЭлементДанных);
		
		Если Не ЗначениеЗаполнено(ЭлементДанных.ПолныйКодМаркировки)
			Или Не ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ПродукцияПодлежитОбязательнойОнлайнПроверкеПередРозничнойПродажей(СтруктураКодаМаркировки.ВидПродукции) Тогда
			
			КоличествоОбработано = КоличествоОбработано + 1;
			ТекстПрогресса = СтрШаблон(Шаблон, КоличествоОбработано, КоличествоДанных);
			ДлительныеОперации.СообщитьПрогресс(КоличествоОбработано, ТекстПрогресса);
			
			Продолжить;
			
		КонецЕсли;
		
		СписокДанныхШтрихкодов.Добавить(
			Новый Структура(
				"Штрихкод, Количество, ШтрихкодBase64", 
				ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.Base64ВШтрихкод(ЭлементДанных.ПолныйКодМаркировки), 1, ЭлементДанных.ПолныйКодМаркировки));
				
		СоответствиеКодаИндексаЭлемента.Вставить(ЭлементДанных.ПолныйКодМаркировки, ЭлементДанных.ИндексЭлемента);
		
	КонецЦикла;
	
	ОтсутствуютCDNПлощадки          = Ложь;
	ТребуетсяАвторизацияИСМПРозница = Ложь;
	
	Если Не СписокДанныхШтрихкодов.Количество() = 0 Тогда
	
		РезультатОбработкиШтрихкодов = ШтрихкодированиеОбщегоНазначенияИС.ОбработатьШтрихкоды(
			СписокДанныхШтрихкодов, ПараметрыСканированияЛокальные, Неопределено, Параметры.УникальныйИдентификатор);
		
		Если РезультатОбработкиШтрихкодов.РезультатыОбработки <> Неопределено Тогда
		
			Для Каждого КлючИЗначение Из РезультатОбработкиШтрихкодов.РезультатыОбработки Цикл
				
				ДанныеПоШтрихкоду = КлючИЗначение.Значение.ДанныеШтрихкода;
				
				Если КлючИЗначение.Значение.ТребуетсяАвторизацияИСМПРозница Тогда
					ТребуетсяАвторизацияИСМПРозница = Истина;
					Прервать;
				КонецЕсли;
				
				Если КлючИЗначение.Значение.ОтсутствуютCDNПлощадки Тогда
					ОтсутствуютCDNПлощадки = Истина;
					Прервать;
				КонецЕсли;
				
				Если ДанныеПоШтрихкоду = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				ИндексЭлемента = СоответствиеКодаИндексаЭлемента.Получить(ДанныеПоШтрихкоду.ПолныйКодМаркировки);
				
				Если ИндексЭлемента = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				Результат.Вставить(ИндексЭлемента, КлючИЗначение.Значение);
				
				КоличествоОбработано = КоличествоОбработано + 1;
				
				ТекстПрогресса = СтрШаблон(Шаблон, КоличествоОбработано, КоличествоДанных);
				ДлительныеОперации.СообщитьПрогресс(КоличествоОбработано, ТекстПрогресса);
				
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		Результат = Новый Соответствие();
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ДанныеИдентификаторов",           Результат);
	ВозвращаемоеЗначение.Вставить("ОтсутствуютCDNПлощадки",          ОтсутствуютCDNПлощадки);
	ВозвращаемоеЗначение.Вставить("ТребуетсяАвторизацияИСМПРозница", ТребуетсяАвторизацияИСМПРозница);
	
	ЛогированиеЗапросовИСМП.ЗаполнитьВозвращаемыеДанныеФоновогоЗадания(ВозвращаемоеЗначение);
	
	ДлительныеОперации.СообщитьПрогресс(КоличествоДанных, ТекстПрогресса);
	ПоместитьВоВременноеХранилище(ВозвращаемоеЗначение, АдресРезультата);

КонецПроцедуры

// Запуск в фоне актуализации списка и скорости отклика CDN-площадок
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, от имени которой выполняется запрос к ГИС МТ
//  УникальныйИдентификатор - УникальныйИдентификатор, Неопределено - Уникальный идентификатор формы
//  ОбновлятьБезПроверкиДатыОбновления - Булево - если Истина, то запускается процедура обновления списка вне зависимости от даты актуальности
//   В противном случае обновление будет вызвано только если прошел срок актуальности загрузки площадок
// 
// Возвращаемое значение:
//  см. ДлительныеОперации.ВыполнитьВФоне.
Функция ЗапуститьОбновлениеCDNПлощадок(Организация, УникальныйИдентификатор = Неопределено, ОбновлятьБезПроверкиДатыОбновления = Ложь) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление CDN-площадок'");
	
	ПараметрыФоновогоЗадания = Новый Структура;
	ПараметрыФоновогоЗадания.Вставить("Организация",                        Организация);
	ПараметрыФоновогоЗадания.Вставить("ПараметрыЛогированияЗапросовИСМП",   ПараметрыСеанса.ПараметрыЛогированияЗапросовИСМП);
	ПараметрыФоновогоЗадания.Вставить("ОбновлятьБезПроверкиДатыОбновления", ОбновлятьБезПроверкиДатыОбновления);
	
	Если ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульИнтеграцияИСПереопределяемый = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСПереопределяемый");
		МодульИнтеграцияИСПереопределяемый.НастроитьДлительнуюОперацию(ПараметрыФоновогоЗадания, ПараметрыВыполнения);
	КонецЕсли;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"ОбщегоНазначенияИСМП.ВыполнитьАктуализациюCDNПлощадокДлительнаяОперация",
		ПараметрыФоновогоЗадания, ПараметрыВыполнения);
	
	Возврат ДлительнаяОперация;
	
КонецФункции

Процедура УбратьОбязательныеТоварныеГруппыПриПродажеВРозницуИзИсключений(ПараметрыКонтроля)
	
	Если Не ТипЗнч(ПараметрыКонтроля) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыКонтроля.Свойство("Исключения") Тогда
		Возврат;
	КонецЕсли;
	
	СписокТоварныхГруппИсключений = 
		РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП.СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницуНаДату();
	
	Если ПараметрыКонтроля.ВариантОтображения = "ПоТоварнымГруппам" Тогда
		
		Для Каждого ТоварнаяГруппаИсключений Из СписокТоварныхГруппИсключений Цикл
			
			ИсключенияПоТГ = ПараметрыКонтроля.Исключения.Получить(ТоварнаяГруппаИсключений);
			
			Если ИсключенияПоТГ <> Неопределено Тогда
				
				Если ИсключенияПоТГ.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Если ИсключенияПоТГ.Получить(Перечисления.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа) <> Неопределено Тогда
					ИсключенияПоТГ.Удалить(Перечисления.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа);
				КонецЕсли;
				
				Если ИсключенияПоТГ.Количество() = 0 Тогда
					ПараметрыКонтроля.Исключения.Удалить(ТоварнаяГруппаИсключений);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ПараметрыКонтроля.ВариантОтображения = "ПоОперациям" Тогда
		
		ИсключенияПоОперации = ПараметрыКонтроля.Исключения.Получить(Перечисления.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа);
		
		Если ИсключенияПоОперации <> Неопределено Тогда
			
			Если ИсключенияПоОперации.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
			
			Для Каждого ТоварнаяГруппаИсключений Из СписокТоварныхГруппИсключений Цикл
			
				Если ИсключенияПоОперации.Получить(ТоварнаяГруппаИсключений) <> Неопределено Тогда
					ИсключенияПоОперации.Удалить(ТоварнаяГруппаИсключений);
				КонецЕсли;
				
			КонецЦикла;
			
			Если ИсключенияПоОперации.Количество() = 0 Тогда
				ПараметрыКонтроля.Исключения.Удалить(Перечисления.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
