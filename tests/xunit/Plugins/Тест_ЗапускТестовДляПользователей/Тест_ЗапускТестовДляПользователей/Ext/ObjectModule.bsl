﻿Перем КонтекстЯдра;
Перем Утверждения;
Перем МенеджерЗапуска1С;
Перем Файлы;
Перем ПлагинНастройки;

//{ основная процедура для юнит-тестирования xUnitFor1C
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	МенеджерЗапуска1С = КонтекстЯдра.Плагин("ЗапускТестовДляПользователей");
	Файлы = КонтекстЯдра.Плагин("Файлы");
	ПлагинНастройки = КонтекстЯдра.Плагин("Настройки");

КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	Инициализация(КонтекстЯдраПараметр);
	
	НаборТестов.Добавить("ТестДолжен_ЗапуститьПользователя");
	
	//ДобавитьТестыПользователейИзНастроек();
КонецПроцедуры

//}

//{ Блок юнит-тестов

Процедура ДобавитьТестыПользователейИзНастроек()

//	СписокПользователей = ПлагинНастройки.ПолучитьНастройку("ТестыПользователей");
//	КонтекстЯдра.Отладка(СтрШаблон("СписокПользователей (ТестыПользователей) <%1>", ТипЗнч(СписокПользователей)));

//	Если Не ЗначениеЗаполнено(СписокПользователей) Тогда
//		КонтекстЯдра.ВывестиСообщение("Не найдено списка пользователей, не заполняю тесты для определенных пользователей");
//		Возврат;
//	КонецЕсли;
//	
//	СписокПользователей = СписокПользователей.Пользователи;
//	КонтекстЯдра.Отладка(СтрШаблон("СписокПользователей (Пользователи) <%1>", ТипЗнч(СписокПользователей)));
//	Если Не ЗначениеЗаполнено(СписокПользователей) Тогда
//		КонтекстЯдра.ВывестиСообщение("В файле настроек тестов для пользователей не найдено списка пользователей, 
//			|не заполняю тесты для определенных пользователей");
//		Возврат;
//	КонецЕсли;
//	
//	КонтекстЯдра.Отладка("Передан список пользователей:");
//	Для каждого ИмяПользователя Из СписокПользователей Цикл
//	
//		КонтекстЯдра.Отладка(СтрШаблон("ИмяПользователя <%1>", ИмяПользователя));
//	
//	КонецЦикла;
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	НачатьТранзакцию();
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	Если ТранзакцияАктивна() Тогда
	    ОтменитьТранзакцию();
	КонецЕсли;
КонецПроцедуры

Процедура ТестДолжен_ЗапуститьПользователя() Экспорт
	ТипКлиента = МенеджерЗапуска1С.ВозможныеТипыКлиентов().ТолстыйОФ;
	ОписаниеПользователя = Новый Структура("Логин,Пароль", "User", "");
	ПутьТестов = Файлы.КаталогЗапускателяТестов() + "/tests/xunit/plugins/Тесты_СтроковыеУтилиты.epf";
	
	ОписаниеРезультата = МенеджерЗапуска1С.ЗапуститьТестДляПользователя(
		ОписаниеПользователя, ПутьТестов, ТипКлиента);
	
	КодВозврата = ОписаниеРезультата.КодВозврата;
	СтатусВыполнения = ОписаниеРезультата.СтатусВыполнения;
	ТекстЛогФайла = ОписаниеРезультата.ТекстЛогФайла;
	ПутьОтчетаJUnit = ОписаниеРезультата.ПутьОтчетаJUnit;
	ТекстОтчетаJUnit = ОписаниеРезультата.ТекстОтчетаJUnit;
	ПутьОтчетаAllure = ОписаниеРезультата.ПутьОтчетаAllure;
	//ТекстОтчетаAllure = ОписаниеРезультата.ТекстОтчетаAllure;
	
	Утверждения.ПроверитьРавенство(КодВозврата, 0, "КодВозврата");
	
	Утверждения.ПроверитьИстину(СтатусВыполнения, "СтатусВыполнения");
	
	Утверждения.ПроверитьЗаполненность(ПутьОтчетаJUnit, "ПутьОтчетаJUnit");
	Файл = Новый Файл(ПутьОтчетаJUnit);
	Утверждения.ПроверитьИстину(Файл.Существует(), "Файл не существует - ПутьОтчетаJUnit: " + Файл.ПолноеИмя);
	
	Утверждения.ПроверитьВхождение(ТекстЛогФайла, "набор тестов Тесты_СтроковыеУтилиты", "ТекстЛогФайла");
	Утверждения.ПроверитьВхождение(ТекстЛогФайла, "набор тестов Функции парсинга текста и подстановки параметров", "ТекстЛогФайла");
	Утверждения.ПроверитьВхождение(ТекстЛогФайла, "тест Проверка работы функции СократитьДвойныеКавычки", 
		"ТекстЛогФайла");
	
	Утверждения.ПроверитьВхождение(ТекстОтчетаJUnit, 
		"<testsuite name=""Тесты_СтроковыеУтилиты - &lt;User&gt;"">", "ТекстОтчетаJUnit 1");
		//"<testsuite name=""Тесты_СтроковыеУтилиты"">", "ТекстОтчетаJUnit");
	Утверждения.ПроверитьВхождение(ТекстОтчетаJUnit, 
		"<testsuite name=""Функции парсинга текста и подстановки параметров", "ТекстОтчетаJUnit 2");
	Утверждения.ПроверитьВхождение(ТекстОтчетаJUnit, 
		"<testcase classname=""Функции преобразования текста и символов - &lt;User&gt;"" name=""Проверка работы функции ПреобразоватьЧислоВАрабскуюНотацию - &lt;User&gt;""", 
		"ТекстОтчетаJUnit 3");
	
	Утверждения.ПроверитьЗаполненность(ПутьОтчетаJUnit, "ПутьОтчетаAllure");
	//Файл = Новый Файл(ПутьОтчетаAllure);
	//Утверждения.ПроверитьИстину(Файл.Существует(), "Файл не существует - ПутьОтчетаAllure: " + Файл.ПолноеИмя);
	
КонецПроцедуры

//}