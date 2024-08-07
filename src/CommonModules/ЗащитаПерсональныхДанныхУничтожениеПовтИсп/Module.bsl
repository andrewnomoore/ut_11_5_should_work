///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. Обработки.СкрытиеКонфиденциальнойИнформации.ДеревоОбрабатываемыхОбъектов
Функция ДеревоОбрабатываемыхОбъектов() Экспорт

	Возврат Обработки.СкрытиеКонфиденциальнойИнформации.ДеревоОбрабатываемыхОбъектов();
	
КонецФункции

// См. Обработки.СкрытиеКонфиденциальнойИнформации.ДеревоОбрабатываемыхОбъектовБезНастроек
Функция ДеревоОбрабатываемыхОбъектовБезНастроек() Экспорт
	
	Возврат Обработки.СкрытиеКонфиденциальнойИнформации.ДеревоОбрабатываемыхОбъектовБезНастроек();
	
КонецФункции

// См. Обработки.СкрытиеКонфиденциальнойИнформации.ЭлементИмениПоТипуМетаданных
Функция ЭлементИмениПоТипуМетаданных(ТипМетаданных) Экспорт
	
	Возврат Обработки.СкрытиеКонфиденциальнойИнформации.ЭлементИмениПоТипуМетаданных(ТипМетаданных);
	
КонецФункции

#КонецОбласти
