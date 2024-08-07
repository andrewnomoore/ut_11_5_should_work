
#Область ПрограммныйИнтерфейс

// Выполняет отправку сообщения в адресный канал сообщений.
// Соответствует типу отправки "Конечная точка/Конечная точка".
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор адресного канала сообщений.
//  ТелоСообщения - Произвольный - Тело сообщения системы, которое необходимо отправить.
//  Получатель - Неопределено - получатель сообщения не указан. Сообщение будет отправлено конечным 
//  							    точкам, которые определяются настройками текущей информационной системы:
//                              в обработчике ОбменСообщениямиПереопределяемый.ПолучателиСообщения 
//                              (программно) и в 
//                              регистре сведений НастройкиОтправителя (настройка системы).
//             - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, который соответствует 
//                                                   конечной точке, для которой предназначено сообщение. 
//                                                   Сообщение будет отправлено только 
//                                                   этой конечной точке.
//             - Массив - массив получателей сообщения; элементы массива должны 
//             				иметь тип ПланОбменаСсылка.ОбменСообщениями.
//                        	Сообщение будет отправлено всем конечным точкам, указанным в массиве.
//
Процедура ОтправитьСообщение(КаналСообщений, ТелоСообщения = Неопределено, Получатель = Неопределено) Экспорт
КонецПроцедуры

// Выполняет отправку сообщения в адресный канал сообщений.
// Соответствует типу отправки "Конечная точка/Конечная точка".
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор адресного канала сообщений.
//  ТелоСообщения - Произвольный - Тело сообщения системы, которое необходимо отправить.
//  Получатель - Неопределено - получатель сообщения не указан. Сообщение будет отправлено 
//  							    конечным точкам, которые определяются настройками текущей 
//                              информационной системы: в обработчике 
//                              ОбменСообщениямиПереопределяемый.ПолучателиСообщения (программно) и 
//                              в регистре сведений НастройкиОтправителя (настройка системы).
//             - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, который соответствует 
//                                                   конечной точке, для которой предназначено 
//                                                   сообщение. Сообщение будет отправлено
//                                                   только этой конечной точке.
//             - Массив - массив получателей сообщения; элементы массива должны 
//                        иметь тип ПланОбменаСсылка.ОбменСообщениями. Сообщение будет отправлено 
//                        всем конечным точкам, указанным в массиве.
//
Процедура ОтправитьСообщениеСейчас(КаналСообщений, ТелоСообщения = Неопределено, Получатель = Неопределено) Экспорт
КонецПроцедуры

// Выполняет отправку сообщения в широковещательный канал сообщений.
// Соответствует типу отправки "Публикация/Подписка".
// Сообщение будет доставлено конечным точкам, которые подписаны на широковещательный канал.
// Настройка подписок на широковещательный канал выполняется через регистр сведений ПодпискиПолучателей.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор широковещательного канала сообщений.
//  ТелоСообщения - Произвольный - Тело сообщения системы, которое необходимо отправить.
//
Процедура ОтправитьСообщениеПодписчикам(КаналСообщений, ТелоСообщения = Неопределено) Экспорт
КонецПроцедуры

// Выполняет отправку быстрого сообщения в широковещательный канал сообщений.
// Соответствует типу отправки "Публикация/Подписка".
// Сообщение будет доставлено конечным точкам, которые подписаны на широковещательный канал.
// Настройка подписок на широковещательный канал выполняется через регистр сведений ПодпискиПолучателей.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор широковещательного канала сообщений.
//  ТелоСообщения - Произвольный - Тело сообщения системы, которое необходимо отправить.
//
Процедура ОтправитьСообщениеПодписчикамСейчас(КаналСообщений, ТелоСообщения = Неопределено) Экспорт	
КонецПроцедуры

// Выполняет немедленную отправку быстрых сообщений из общей очереди сообщений.
// Отправка сообщений выполняется в цикле до тех пор, пока из очереди сообщений 
// не будут отправлены все быстрые сообщения.
// На время отправки сообщений блокируется немедленная отправка сообщений из других сеансов.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ДоставитьСообщения() Экспорт
КонецПроцедуры

// Выполняет подключение конечной точки.
// Перед подключением конечной точки выполняется проверка установки соединения 
// отправителя к получателю и получателя к отправителю. 
// Также проверяется то, что настройки подключения получателя указывают на текущего отправителя.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Отказ - Булево - Флаг выполнения операции; поднимается в случае ошибок 
//   при подключении конечной точки.
//  НастройкиПодключенияОтправителя - Структура - Параметры подключения отправителя. Содержит свойства: 
//   Для инициализации используется функция ОбменДаннымиСервер.СтруктураПараметровWS. 
//    * WSURLВебСервиса   - Строка - Веб-адрес подключаемой конечной точки.
//    * WSИмяПользователя  - Строка - Пользователь для аутентификации в подключаемой конечной точке
//                          при работе через web-сервис подсистемы обмена сообщениями.
//    * WSПароль - Строка - Пароль пользователя в подключаемой конечной точке.
//  НастройкиПодключенияПолучателя - Структура - Параметры подключения получателя. Содержит свойства:
//   Для инициализации используется функция ОбменДаннымиСервер.СтруктураПараметровWS. 
//    * WSURLВебСервиса   - Строка - Веб-адрес этой информационной базы со стороны 
//    	подключаемой конечной точки.
//    * WSИмяПользователя - Строка - Пользователь для аутентификации в этой информационной базе 
//                          при работе через web-сервис подсистемы обмена сообщениями.
//    * WSПароль - Строка - Пароль пользователя в этой информационной базе.
//  КонечнаяТочка - ПланОбменаСсылка.ОбменСообщениями, Неопределено - Если подключение конечной 
//		точки завершилось успешно, то в этот параметр возвращается ссылка на узел плана обмена,
//     который соответствует подключенной конечной точке.
//     Если подключить конечную точку не удалось, то возвращается Неопределено.
//  НаименованиеКонечнойТочкиПолучателя - Строка - Наименование подключаемой конечной точки. 
//     Если значение не задано, то в качестве наименования используется синоним
//     конфигурации подключаемой конечной точки.
//  НаименованиеКонечнойТочкиОтправителя - Строка - Наименование конечной точки, которая соответствует
//     этой информационной базе. Если значение не задано, то в качестве
//     наименования используется синоним конфигурации этой информационной базы.
//
Процедура ПодключитьКонечнуюТочку(Отказ, НастройкиПодключенияОтправителя, НастройкиПодключенияПолучателя,
	КонечнаяТочка = Неопределено, НаименованиеКонечнойТочкиПолучателя = "", 
	НаименованиеКонечнойТочкиОтправителя = "") Экспорт	
КонецПроцедуры

// Выполняет обновление настроек подключения для конечной точки.
// Обновляются настройки подключения этой информационной базы к указанной конечной точке
// и настройки подключения конечной точки к этой информационной базе.
// Перед применением настроек выполняется проверка подключения на правильность задания настроек.
// Также проверяется то, что настройки подключения получателя указывают на текущего отправителя.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Отказ - Булево - Флаг выполнения операции; поднимается в случае ошибок.
//  КонечнаяТочка - ПланОбменаСсылка.ОбменСообщениями - Ссылка на узел плана обмена, 
//   который соответствует конечной точке.
//   
//  НастройкиПодключенияОтправителя - Структура - Параметры подключения отправителя. Содержит свойства:
//   Для инициализации используется функция ОбменДаннымиСервер.СтруктураПараметровWS. 
//    * WSURLВебСервиса   - Строка - Веб-адрес подключаемой конечной точки.
//    * WSИмяПользователя - Строка - Пользователь для аутентификации в подключаемой конечной точке
//                          при работе через web-сервис подсистемы обмена сообщениями.
//    * WSПароль - Строка - Пароль пользователя в подключаемой конечной точке.
//  НастройкиПодключенияПолучателя - Структура - Параметры подключения получателя. Содержит свойства: 
//   Для инициализации используется функция ОбменДаннымиСервер.СтруктураПараметровWS. 
//    * WSURLВебСервиса   - Строка - Веб-адрес этой информационной базы со стороны подключаемой 
//    		конечной точки.
//    * WSИмяПользователя - Строка - Пользователь для аутентификации в этой информационной базе 
//                          при работе через web-сервис подсистемы обмена сообщениями.
//    * WSПароль - Строка - Пароль пользователя в этой информационной базе.
//
Процедура ОбновитьНастройкиПодключенияКонечнойТочки(Отказ, КонечнаяТочка,
	НастройкиПодключенияОтправителя, НастройкиПодключенияПолучателя) Экспорт
КонецПроцедуры

#КонецОбласти

