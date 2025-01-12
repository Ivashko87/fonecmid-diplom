
#Область ОбработчикиСобытийМодуляОбъекта

Процедура ОбработкаПроведения(Отказ, РежимПроведения)  
	
	Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
	Движения.ВКМ_Удержания.Записывать = Истина;
	
	ВКМ_СформироватьДвиженияДополнительныеНачиления();
	
	ВКМ_СформироватьДвиженияУдержания();
	
	Движения.ВКМ_ДополнительныеНачисления.Записать();
	Движения.ВКМ_Удержания.Записать(); 
	
	ВКМ_ДвиженияВзаиморасчетыССотрудниками();
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыФункции

Процедура ВКМ_СформироватьДвиженияДополнительныеНачиления()
	
	Для Каждого Строка Из СписокСотрудников Цикл
		
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		Движение.ПериодРегистрации = Дата;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.Премия;
		Движение.Сотрудник = Строка.Сотрудник;	
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
		Движение.Результат = Строка.СуммаПремии;
		Движение.Показатель = Строка.СуммаПремии;
		
	КонецЦикла;
	
КонецПроцедуры  

Процедура ВКМ_СформироватьДвиженияУдержания();	
	
	Для Каждого Строка Из СписокСотрудников Цикл
		
		Движение = Движения.ВКМ_Удержания.Добавить();
		Движение.ПериодРегистрации = Дата;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ13;
		Движение.Сотрудник = Строка.Сотрудник;
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
		Движение.Результат = Строка.СуммаПремии/100*13;
		Движение.Показатель = Строка.СуммаПремии;
		
	КонецЦикла;
	
КонецПроцедуры 

Процедура ВКМ_ДвиженияВзаиморасчетыССотрудниками() 
	
	// регистр ВзаиморасчетыССотрудниками Приход
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник КАК Сотрудник,
		|	СУММА(ВКМ_НачислениеФиксированнойПремииСписокСотрудников.СуммаПремии) КАК СуммаПремии
		|ИЗ
		|	Документ.ВКМ_НачислениеФиксированнойПремии.СписокСотрудников КАК ВКМ_НачислениеФиксированнойПремииСписокСотрудников
		|ГДЕ
		|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
		СуммаУдержания = ВыборкаДетальныеЗаписи.СуммаПремии/100*13;
		Движение.Сумма = ВыборкаДетальныеЗаписи.СуммаПремии-СуммаУдержания;
		
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

