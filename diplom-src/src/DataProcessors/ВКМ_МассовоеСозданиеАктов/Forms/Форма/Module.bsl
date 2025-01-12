
#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Объект.Период = ТекущаяДата();
	Месяц = Формат(Объект.Период, "ДФ = ""ММММ гггг""");
	Если Год(Объект.Период) = 1 Тогда
		ВКМ_СформироватьСписокВыбораМесяца(Год(ТекущаяДата()));
	Иначе
		ВКМ_СформироватьСписокВыбораМесяца(Год(Объект.Период));
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура МесяцПриИзменении(Элемент) 
	
	Если Месяц <> "" Тогда
		Если СтрДлина(Месяц)=4 Тогда 
			ВКМ_СформироватьСписокВыбораМесяца(Число(Месяц));
			Оповещение = новый ОписаниеОповещения("ВКМ_ПослеВыбораГода", ЭтаФорма);
			ЭтаФорма.ПоказатьВыборИзМеню(Оповещение, Элементы.Месяц.СписокВыбора, Элементы.Месяц);	
		Иначе
			НомМесяца = (Найти("янвфевмарапрмайиюниюлавгсеноктноядек",Нрег(Лев(Месяц,3)))+2)/3; 
			ВыбрГод = Число(Прав(Месяц, 4));
			Объект.Период = НачалоМесяца(Дата(ВыбрГод, НомМесяца, 1));
		КонецЕсли;    
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура Заполнить(Команда) 
	  
	СоздатьРеализацию = Ложь;
	ДлительнаяОперация = ВКМ_НачатьВыполнениеНаСервере(СоздатьРеализацию);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповещениеОЗавершении", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры  


 &НаКлиенте
Процедура СоздатьРеализации(Команда)
	
	СоздатьРеализацию = Истина;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ОповещениеОПрогрессе", ЭтотОбъект);
	ПараметрыОжидания.Интервал = 1;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;  
	
	ДлительнаяОперация = ВКМ_НачатьВыполнениеНаСервере(СоздатьРеализацию);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповещениеОЗавершении", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВКМ_СформироватьСписокВыбораМесяца(Год)
    
	Элементы.Месяц.СписокВыбора.Очистить();
	Элементы.Месяц.СписокВыбора.Добавить(Формат(Год-1, "ЧГ=0"));
	Для к = 1 По 12  Цикл
		СформДата = Дата(Год, к, 1);
		Наим = Формат(СформДата, "ДФ = ""ММММ гггг""");
		Элементы.Месяц.СписокВыбора.Добавить(Наим);    
	КонецЦикла; 
	Элементы.Месяц.СписокВыбора.Добавить(Формат(Год+1, "ЧГ=0")); 
	
КонецПроцедуры

&НаКлиенте
Процедура ВКМ_ПослеВыбораГода (Результат, Параметры)  Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	Иначе
		Месяц = Результат.Значение;
	КонецЕсли;
	
	
	Если Месяц <> "" Тогда
		Если СтрДлина(Месяц)=4 Тогда 
			ВКМ_СформироватьСписокВыбораМесяца(Число(Месяц));
			Оповещение = новый ОписаниеОповещения("ВКМ_ПослеВыбораГода", ЭтаФорма);
			ЭтаФорма.ПоказатьВыборИзМеню(Оповещение, Элементы.Месяц.СписокВыбора, Элементы.Месяц);
			
		Иначе
			НомМесяца = (Найти("янвфевмарапрмайиюниюлавгсеноктноядек",Нрег(Лев(Месяц,3)))+2)/3; //получаем номер месяца
			ВыбрГод = Число(Прав(Месяц, 4));
			Объект.Период = НачалоМесяца(Дата(ВыбрГод, НомМесяца, 1));
		КонецЕсли;    
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Функция ВКМ_НачатьВыполнениеНаСервере(СоздатьРеализацию); 
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	Возврат ДлительныеОперации.ВыполнитьФункцию(УникальныйИдентификатор,"Обработки.ВКМ_МассовоеСозданиеАктов.СоздатьСписокНаСервере", Объект.Период, СоздатьРеализацию);
	
КонецФункции 

&НаКлиенте
Процедура ОповещениеОЗавершении(Результат, ДополнительныеПараметры) Экспорт

	Если Результат.Статус = "Выполнено" Тогда
		СписокРеализацийМассив = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ЗаполнитьСписокДоговоров(СписокРеализацийМассив);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ОповещениеОПрогрессе(Прогресс, ДополнительныеПараметры) Экспорт

    Если Прогресс.Прогресс <> Неопределено Тогда
        Состояние("выполняется заполнение докуметов", Прогресс.Прогресс.Процент);
    КонецЕсли;
	
КонецПроцедуры 


&НаКлиенте
Процедура ЗаполнитьСписокДоговоров (СписокРеализацийМассив) 
	
	Объект.СписокДоговоров.Очистить();
	
	Для Каждого Строка Из СписокРеализацийМассив Цикл
		НоваяСтрока = Объект.СписокДоговоров.Добавить();
		НоваяСтрока.Договор = Строка.Договор;
		НоваяСтрока.Реализация = Строка.Реализация;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти


 






 





