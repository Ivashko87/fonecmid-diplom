#Область ОбработчикиСобытийФормы 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Адрес = Параметры.АдресВХранилище;
	
	ОтпускаСотрудников = ПолучитьИзВременногоХранилища(Адрес);
	
	Для Каждого Стр Из ОтпускаСотрудников Цикл  
		
		Точка = Диаграмма.УстановитьТочку(Стр.Сотрудник);
		Серия = Диаграмма.УстановитьСерию("Отпуск");
		
		Значение = Диаграмма.ПолучитьЗначение(Точка, Серия);
		Интервал = Значение.Добавить();
		Интервал.Начало = Стр.ДатаНачала;
		Интервал.Конец = Стр.ДатаОкончания;	
		
	КонецЦикла; 

КонецПроцедуры

#КонецОбласти
