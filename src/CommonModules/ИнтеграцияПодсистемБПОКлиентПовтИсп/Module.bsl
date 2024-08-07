#Область СлужебныйПрограммныйИнтерфейс

// Создает структуру и заполняет параметры работы клиента на сервере
// Стандарт Минимизация количества серверных вызовов и трафика.
//
// Возвращаемое значение:
//   Структура:
//     * ТекущаяДатаНаКлиенте - Дата
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	Параметры = Новый Структура();
	ИнтеграцияПодсистемБПОСлужебныйВызовСервера.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

