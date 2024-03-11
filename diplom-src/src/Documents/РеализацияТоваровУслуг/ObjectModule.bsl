
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ЗаполнитьНаОснованииЗаказаПокупателя(ДанныеЗаполнения);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	Движения.ОбработкаЗаказов.Записывать = Истина;
	Движения.ОстаткиТоваров.Записывать = Истина;
	
	Движение = Движения.ОбработкаЗаказов.Добавить();
	Движение.Период = Дата;
	Движение.Контрагент = Контрагент;
	Движение.Договор = Договор;
	Движение.Заказ = Основание;
	Движение.СуммаОтгрузки = СуммаДокумента;
	//***Добавлено Ивашко ВКМ_{
	Движение.ВКМ_СтоимостьУслуг =  Услуги.Итог("Сумма");
	// ВКМ_}
	
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.Количество = ТекСтрокаТовары.Количество;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОснованииЗаказаПокупателя(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказПокупателя.Организация КАК Организация,
	               |	ЗаказПокупателя.Контрагент КАК Контрагент,
	               |	ЗаказПокупателя.Договор КАК Договор,
	               |	ЗаказПокупателя.СуммаДокумента КАК СуммаДокумента,
	               |	ЗаказПокупателя.Товары.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Товары,
	               |	ЗаказПокупателя.Услуги.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Услуги
	               |ИЗ
	               |	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	               |ГДЕ
	               |	ЗаказПокупателя.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	ТоварыОснования = Выборка.Товары.Выбрать();
	Пока ТоварыОснования.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), ТоварыОснования);
	КонецЦикла;
	
	УслугиОснования = Выборка.Услуги.Выбрать();
	Пока ТоварыОснования.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Услуги.Добавить(), УслугиОснования);
	КонецЦикла;
	
	Основание = ДанныеЗаполнения;
	
КонецПроцедуры 

//***Добавлено Ивашко ВКМ_{ 
Процедура ВКМ_ВыполнитьАвтозаполнение () Экспорт

	НоменклатураАбонентскаяПлата = Константы.ВКМ_НоменклатураАбонентскаяПлата.Получить();
	НоменклатураРаботыСпециалиста = Константы.ВКМ_НоменклатураРаботыСпециалиста.Получить();
	
	Если Не ЗначениеЗаполнено(НоменклатураАбонентскаяПлата) Тогда
		ОбщегоНазначения.СообщитьПользователю("Не заполнена константа: Номенклатура абонентская плата");
		Возврат; 
	КонецЕсли;
	
	
	Если Не ЗначениеЗаполнено(НоменклатураРаботыСпециалиста) Тогда 
		ОбщегоНазначения.СообщитьПользователю("Не заполнена константа: Номенклатура работы специалиста");
		Возврат; 
	КонецЕсли;   
	
	Услуги.Очистить();
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ВКМ_СуммаАбоненсткойПлаты") > 0 Тогда  
		
		НоваяСтрока = Услуги.Добавить();
		НоваяСтрока.Номенклатура = НоменклатураАбонентскаяПлата;
		НоваяСтрока.Сумма = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ВКМ_СуммаАбоненсткойПлаты");
		
	КонецЕсли;
	
	СуммаРаботСпециалиста = ВКМ_РаботыСпециалиста(); 
	Если СуммаРаботСпециалиста > 0 Тогда
		
		НоваяСтрока = Услуги.Добавить();
		НоваяСтрока.Номенклатура = НоменклатураРаботыСпециалиста;
		НоваяСтрока.Сумма = СуммаРаботСпециалиста; 
		
	КонецЕсли;
		
	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
	// ВКМ_}
КонецПроцедуры 

//***Добавлено Ивашко ВКМ_{
Функция ВКМ_РаботыСпециалиста ()
	
	Запрос = Новый Запрос;
    Запрос.Текст =
	"ВЫБРАТЬ
	|	ВКМ_ВыполненныеКлиентуРаботыОбороты.СуммаОборот КАК Сумма,
	|	ВКМ_ВыполненныеКлиентуРаботыОбороты.Договор КАК Договор
	|ИЗ
	|	РегистрНакопления.ВКМ_ВыполненныеКлиентуРаботы.Обороты(
	|			&НачДата,
	|			&КонДата,
	|			,
	|			Контрагент = &Контрагент
	|				И Договор = &Договор) КАК ВКМ_ВыполненныеКлиентуРаботыОбороты";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
    Запрос.УстановитьПараметр("Договор", Договор);
    Запрос.УстановитьПараметр("НачДата", НачалоМесяца(Дата));
    Запрос.УстановитьПараметр("КонДата", КонецМесяца(Дата));
	
	РезультатЗапроса = Запрос.Выполнить();

	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Выборка.Следующий();
		
		Сумма = Выборка.Сумма;  
		
	Иначе
		
		Сумма = 0;
			
	КонецЕсли;  
	
	Возврат Сумма;
	// ВКМ_}
	
КонецФункции

#КонецОбласти    

#КонецЕсли


