
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ВКМ_УстановитьВидимость();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВКМ_УстановитьВидимость(); 
	
КонецПроцедуры


#КонецОбласти  

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	
	ВКМ_УстановитьВидимость();
	
КонецПроцедуры  

#КонецОбласти 

#Область ДоработкаФормы

&НаСервере
Процедура ВКМ_УстановитьВидимость() 
	
	// *** Ивашко 04.02.2024 /*Модуль_Работа с заявками клиентов*\ /*Договоры на абонентское обслуживание*\  {
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.АбоненскоеОбслуживание Тогда
		Элементы.ГруппаАбоненскоеОбслуживание.Видимость = Истина; 
	Иначе
		Элементы.ГруппаАбоненскоеОбслуживание.Видимость = Ложь;
	КонецЕсли;	
	// *** Ивашко 04.02.2024 }  
	
КонецПроцедуры

#КонецОбласти



