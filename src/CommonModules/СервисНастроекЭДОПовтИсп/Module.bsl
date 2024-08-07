//@strict-types

#Область СлужебныеПроцедурыИФункции

// Возвращает объект HTTPСоединение для работы с сервисом электронного документооборота.
// 
// Параметры:
// 	Таймаут - Число
// 	НоваяВерсияАПИСервиса1СЭДО - Булево - использовать API v2 сервиса.
// Возвращаемое значение:
// 	см. ИнтернетСоединениеБЭД.ОписаниеHTTPСоединения
Функция СоединениеССервисом(Таймаут = 30) Экспорт
	
	Возврат ИнтернетСоединениеБЭД.ОписаниеHTTPСоединения(СервисНастроекЭДО.АдресСервисаНастроек(), Таймаут);
	
КонецФункции

// Возвращает неподдерживемые операторами форматы.
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//   * Ключ - Строка - идентификатор оператора
//   * Значение - Массив из Строка - идентификаторы форматов
//
Функция НеподдерживаемыеОператорамиФорматы() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОператорыЭДО.ИдентификаторОператора КАК ИдентификаторОператора,
	|	ОператорыЭДО.НеподдерживаемыеФорматы КАК НеподдерживаемыеФорматы
	|ИЗ
	|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.НеподдерживаемыеФорматы) Тогда
			Продолжить;
		КонецЕсли;
		Результат.Вставить(Выборка.ИдентификаторОператора,
			ОбщегоНазначения.JSONВЗначение(Выборка.НеподдерживаемыеФорматы, Неопределено, Истина));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти