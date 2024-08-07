#Область СлужебныйПрограммныйИнтерфейс

// Возвращает систему налогообложения организации
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации - ссылка на организацию.
// 	ДатаДействия - Дата - дата получения системы налогообложения.
// 	ПоУмолчанию - Булево - если истина, то возвращается система налогообложения по умолчанию,
// 	               иначе возвращается только из записи регистра.
// Возвращаемое значение:
// 	ПеречислениеСсылка.СистемыНалогообложения, Неопределено - система налогообложения организации.
Функция СистемаНалогообложенияОрганизации(Организация, ДатаДействия = Неопределено, ПоУмолчанию = Истина) Экспорт
	СистемаНалогообложения = НастройкиНалоговУчетныхПолитикЛокализация.СистемаНалогообложенияОрганизации(Организация,
		ДатаДействия,
		ПоУмолчанию);
	Возврат СистемаНалогообложения;
КонецФункции

// См. НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату
Функция ДействующиеПараметрыНалоговУчетныхПолитик(ИмяРегистра, Организация, ДатаДействия = Неопределено, ВозвращатьПоУмолчанию = Истина, ВыдаватьИсключение = Ложь) Экспорт
	
	НастройкиУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(ИмяРегистра,
		Организация,
		ДатаДействия,
		ВозвращатьПоУмолчанию,
		ВыдаватьИсключение);
		
	Возврат НастройкиУчетнойПолитики;
	
КонецФункции

// См. НастройкиНалоговУчетныхПолитик.ОрганизацииСЗаданнымПараметромПолитики
Функция ОрганизацииСЗаданнымПараметромПолитики(ИмяРегистра, ИмяПараметра, ЗначениеПараметра,
			Организации = Неопределено, Период = Неопределено) Экспорт
			
	СписокОрганизаций = НастройкиНалоговУчетныхПолитик.ОрганизацииСЗаданнымПараметромПолитики(
		ИмяРегистра, 
		ИмяПараметра, 
		ЗначениеПараметра,
		Организации, 
		Период);
			
	Возврат СписокОрганизаций;
	
КонецФункции

// Возвращает признак использования раздельного учета товаров по налогообложению НДС. 
//
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить признак учетной политики
// 	Период 		- Дата, Неопределено - Дата действия учетной политики, если Неопределено, то на текущую дату
//
// Возвращаемое значение:
// 	Булево - Значение признака.
// 
Функция РаздельныйУчетТоваровПоНалогообложениюНДС(Организация, Период = Неопределено) Экспорт
	
	Возврат НастройкиНалоговУчетныхПолитикЛокализация.РаздельныйУчетТоваровПоНалогообложениюНДС(Организация, Период);
	
КонецФункции

// Возвращает признак использования раздельного учета ВНА по налогообложению НДС. 
//
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить признак учетной политики
// 	Период 		- Дата, Неопределено - Дата действия учетной политики, если Неопределено, то на текущую дату
//
// Возвращаемое значение:
// 	Булево - Значение признака.
// 
Функция РаздельныйУчетВНАПоНалогообложениюНДС(Организация, Период = Неопределено) Экспорт
	
	Возврат НастройкиНалоговУчетныхПолитикЛокализация.РаздельныйУчетВНАПоНалогообложениюНДС(Организация, Период);
	
КонецФункции

// Возвращает признак использования раздельного учета постатейных производственных затрат по налогообложению НДС. 
//
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить признак учетной политики
// 	Период 		- Дата, Неопределено - Дата действия учетной политики, если Неопределено, то на текущую дату
//
// Возвращаемое значение:
// 	Булево - Значение признака.
// 
Функция РаздельныйУчетПостатейныхПроизводственныхЗатратПоНалогообложениюНДС(Организация, Период = Неопределено) Экспорт
	
	Возврат НастройкиНалоговУчетныхПолитикЛокализация.РаздельныйУчетПостатейныхПроизводственныхЗатратПоНалогообложениюНДС(Организация, Период);
	
КонецФункции

// Возвращает настройку формирования НДС Предъявленного при включении в стоимость
//
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить признак учетной политики
// 	Период 		- Дата, Неопределено - Дата действия учетной политики, если Неопределено, то на текущую дату
//
// Возвращаемое значение:
//	Булево - Значение признака
// 
Функция ФормироватьНДСПредъявленныйПриВключенииВСтоимость(Организация, Период = Неопределено) Экспорт
	
	ПараметрыПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату("НастройкиУчетаНДС",
		Организация,
		Период);
		
	ФормироватьНДСПредъявленныйПриВключенииВСтоимость = ?(ПараметрыПолитики <> Неопределено, ПараметрыПолитики.ФормироватьНДСПредъявленныйПриВключенииВСтоимость, Ложь);

	Возврат ФормироватьНДСПредъявленныйПриВключенииВСтоимость;
	
КонецФункции

// Возвращает настройку списания НДС по расходам, не принимаемым в НУ
//
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить признак учетной политики
// 	Период 		- Дата, Неопределено - Дата действия учетной политики, если Неопределено, то на текущую дату
//
// Возвращаемое значение:
//	Булево - Значение признака
// 
Функция СписыватьНДСПоРасходамНеПринимаемымВНУ(Организация, Период = Неопределено) Экспорт
	
	ПараметрыПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату("НастройкиУчетаНДС",
		Организация,
		Период);
		
	СписыватьНДСПоРасходамНеПринимаемымВНУ = ?(ПараметрыПолитики <> Неопределено, ПараметрыПолитики.СписыватьНДСПоРасходамНеПринимаемымВНУ, Ложь);

	Возврат СписыватьНДСПоРасходамНеПринимаемымВНУ;
	
КонецФункции

// Возвращает головную организацию для переданной организации-филиала, либо ссылку на себя.
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - ссылка на справочник Организации.
// 
// Возвращаемое значение:
//  СправочникСсылка.Организации - Головная организация.
Функция ГоловнаяОрганизация(Организация) Экспорт
	ГоловныеОрганизации = Справочники.Организации.ГоловныеОрганизации(Организация);
	
	ГоловнаяОрганизация = Организация;
	Если ГоловныеОрганизации.Количество() > 0 Тогда
		ГоловнаяОрганизация = ГоловныеОрганизации.Получить(0);
	КонецЕсли;
	
	Возврат ГоловнаяОрганизация
КонецФункции


#КонецОбласти
