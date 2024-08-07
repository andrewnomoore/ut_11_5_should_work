///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.ПоддерживаемыеКлиенты) = Тип("Структура") Тогда 
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПоддерживаемыеКлиенты);
	КонецЕсли;
	
	КартинкаДоступна = БиблиотекаКартинок.ВнешняяКомпонентаДоступна;
	КартинкаНеДоступна = БиблиотекаКартинок.СерыйКрест;
	
	Элементы.Windows_x86_1СПредприятие.Картинка = ?(Windows_x86, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_Chrome.Картинка = ?(Windows_x86_Chrome, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_Firefox.Картинка = ?(Windows_x86_Firefox, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_MSIE.Картинка = ?(Windows_x86_MSIE, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_64_1СПредприятие.Картинка = ?(Windows_x86_64, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_64_Chrome.Картинка = ?(Windows_x86_Chrome, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_64_Firefox.Картинка = ?(Windows_x86_Firefox, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_64_MSIE.Картинка = ?(Windows_x86_64_MSIE, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_1СПредприятие.Картинка = ?(Linux_x86, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_Chrome.Картинка = ?(Linux_x86_Chrome, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_Firefox.Картинка = ?(Linux_x86_Firefox, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_64_1СПредприятие.Картинка = ?(Linux_x86_64, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_64_Chrome.Картинка = ?(Linux_x86_64_Chrome, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_64_Firefox.Картинка = ?(Linux_x86_64_Firefox, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.MacOS_x86_64_1СПредприятие.Картинка = ?(MacOS_x86_64, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.MacOS_x86_64_Safari.Картинка = ?(MacOS_x86_64_Safari, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.MacOS_x86_64_Chrome.Картинка = ?(MacOS_x86_64_Chrome, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.MacOS_x86_64_Firefox.Картинка = ?(MacOS_x86_64_Firefox, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_ЯндексБраузер.Картинка = ?(Windows_x86_ЯндексБраузер, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Windows_x86_64_ЯндексБраузер.Картинка = ?(Windows_x86_64_ЯндексБраузер, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_ЯндексБраузер.Картинка = ?(Linux_x86_ЯндексБраузер, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_x86_64_ЯндексБраузер.Картинка = ?(Linux_x86_64_ЯндексБраузер, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.MacOS_x86_64_ЯндексБраузер.Картинка = ?(MacOS_x86_64_ЯндексБраузер, КартинкаДоступна, КартинкаНеДоступна);
		
	Элементы.Linux_E2K_1СПредприятие.Картинка = ?(Linux_E2K, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_E2K_Chrome.Картинка = ?(Linux_E2K_Chrome, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_E2K_Firefox.Картинка = ?(Linux_E2K_Firefox, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_E2K_ЯндексБраузер.Картинка = ?(Linux_E2K_ЯндексБраузер, КартинкаДоступна, КартинкаНеДоступна);
	
	Элементы.Linux_ARM64_1СПредприятие.Картинка = ?(Linux_ARM64, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_ARM64_Chrome.Картинка = ?(Linux_ARM64_Chrome, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_ARM64_Firefox.Картинка = ?(Linux_ARM64_Firefox, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Linux_ARM64_ЯндексБраузер.Картинка = ?(Linux_ARM64_ЯндексБраузер, КартинкаДоступна, КартинкаНеДоступна);
		
	Элементы.iOS_ARM.Картинка = ?(iOS_ARM, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.iOS_ARM64.Картинка = ?(iOS_ARM64, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Android_ARM.Картинка = ?(Android_ARM, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Android_x86_64.Картинка = ?(Android_x86_64, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Android_x86.Картинка = ?(Android_x86, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.Android_ARM64.Картинка = ?(Android_ARM64, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.WindowsRT_ARM.Картинка = ?(WindowsRT_ARM, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.WindowsRT_x86.Картинка = ?(WindowsRT_x86, КартинкаДоступна, КартинкаНеДоступна);
	Элементы.WindowsRT_x86_64.Картинка = ?(WindowsRT_x86_64, КартинкаДоступна, КартинкаНеДоступна);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСсылку(Команда)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://its.1c.ru/db/v83doc#bookmark:adm:TI000000069");
КонецПроцедуры

#КонецОбласти