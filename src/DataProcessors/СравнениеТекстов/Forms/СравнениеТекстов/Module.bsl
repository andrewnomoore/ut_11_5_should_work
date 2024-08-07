#Область ОписаниеПеременных

&НаКлиенте
Перем ЗакладкиРедактора;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьДанныеФормы();
	
	ТекстДляСравнения1 = Параметры.ТекстДляСравнения1;
	ТекстДляСравнения2 = Параметры.ТекстДляСравнения2;
	ОписаниеТекста1 = Параметры.ОписаниеТекста1;
	ОписаниеТекста2 = Параметры.ОписаниеТекста2;
	
	Заголовок = Параметры.ЗаголовокФормы;
	
	Если Не ПустаяСтрока(Параметры.НачальноеОтображение) Тогда
		
		Если Параметры.НачальноеОтображение <> "РазличияВОдномОкне" Тогда
			
			ПоказыватьРазличияДвумяСтолбцами = Истина;
			
		КонецЕсли;
		
	Иначе
		
		ПоказыватьРазличияДвумяСтолбцами = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"СравнениеФайлов", 
			"ПоказыватьРазличияДвумяСтолбцами");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если НЕ ВебКлиент Тогда
	
	КаталогРедактора = ПолучитьИмяВременногоФайла();  //@skip удаляется при закрытии формы
	СоздатьКаталог(КаталогРедактора);
	НадоУдалитьКаталогРедактора = Истина;
	
	Файл = Новый Файл(КаталогРедактора);
	Если НЕ Файл.Существует() Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Каталог <%1> не существует.'"),КаталогРедактора);
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(МакетРедактора);
	УдалитьИзВременногоХранилища(МакетРедактора);
	МакетРедактора = ""; 
	ЧтениеZipФайла = Новый ЧтениеZipФайла(ДвоичныеДанные.ОткрытьПотокДляЧтения());
	ЧтениеZipФайла.ИзвлечьВсе(КаталогРедактора, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	ЧтениеZipФайла.Закрыть();
	
	Файл = Новый Файл(КаталогРедактора);
	Если НЕ Файл.Существует() Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Каталог <%1> не существует.'"),КаталогРедактора);
	КонецЕсли;
	
	СсылкаРедактора = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогРедактора) + "index.html?localeCode=" + Лев(ТекущийЯзыкСистемы(), 2);
	
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НадоУдалитьКаталогРедактора Тогда
		Попытка
			УдалитьФайлы(КаталогРедактора);
		Исключение
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации("РедакторСценариев","Ошибка",ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СсылкаРедактораДокументСформирован(Элемент)
	
	ИнициализироватьРедактор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьРазличияДвумяСтолбцамиПриИзменении(Элемент)
	
	ЗакладкиРедактора.current.editor.setSideBySide(ПоказыватьРазличияДвумяСтолбцами);
	СохранитьНастройкиСервер(ПоказыватьРазличияДвумяСтолбцами);
	
КонецПроцедуры

&НаКлиенте
Процедура РедакторПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	НужноЗакрытьФорму = Ложь;
	
	ЭлементСобытия = ДанныеСобытия.Element; 
	
	Если ЭлементСобытия.id = "VanessaEditorEventForwarder" Тогда
		
		Пока Истина Цикл
			
			СообщениеРедактора = Элементы.Редактор.Document.defaultView.popVanessaMessage();
			Если (СообщениеРедактора = Неопределено) Тогда
				Прервать;
			КонецЕсли;
			
			Если СообщениеРедактора.type = "PRESS_ESCAPE" Тогда
				НужноЗакрытьФорму = Истина;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Если НужноЗакрытьФорму Тогда
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКПредыдущемуИзменению(Команда)
	
	ЗакладкиРедактора.previousDiff();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующемуИзменению(Команда) 
	
	ЗакладкиРедактора.nextDiff();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИнициализироватьРедактор()
	
	ВидПоУмолчанию    = Элементы.Редактор.Document.defaultView;
	ЗакладкиРедактора = ВидПоУмолчанию.createVanessaTabs();
	
	ЗакладкиРедактора.diff(
		ТекстДляСравнения1,
		ОписаниеТекста1,
		"Файл1",
		ТекстДляСравнения2,
		ОписаниеТекста2,
		"Файл2",
		СтрШаблон(НСтр("ru = 'Сравнивается <%1> с <%2>'"), ОписаниеТекста1, ОписаниеТекста2),
		0,
		Истина, Истина); 
		
	ЗакладкиРедактора.current.editor.setSideBySide(ПоказыватьРазличияДвумяСтолбцами);
	
	Элементы.СтраницыРедакторОжидание.ТекущаяСтраница = Элементы.СтраницаРедактор;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиСервер(ПоказыватьРазличияДвумяСтолбцами)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СравнениеФайлов",
	                                                 "ПоказыватьРазличияДвумяСтолбцами",
	                                                 ПоказыватьРазличияДвумяСтолбцами
	                                                 ,
	                                                 ,
	                                                 ,
	                                                 Истина);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанныеФормы()
	
	ДвоичныеДанные = Обработки.СравнениеТекстов.ПолучитьМакет("РедакторТекстов");
	МакетРедактора = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	
	УстановитьСостояниеОбновляется(Элементы.ИдетОбновление, БиблиотекаКартинок.ДлительнаяОперация48);
	Элементы.СтраницыРедакторОжидание.ТекущаяСтраница = Элементы.СтраницаОжидание;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеОбновляется(ПолеТабличногоДокумента, КартинкаДлительнаяОперация)

	ОтображениеСостояния = ПолеТабличногоДокумента.ОтображениеСостояния;
	ОтображениеСостояния.Видимость                      = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Картинка                       = КартинкаДлительнаяОперация;
	ОтображениеСостояния.Текст                          = НСтр("ru = 'Данные обновляются, ожидайте...'");

КонецПроцедуры

#КонецОбласти