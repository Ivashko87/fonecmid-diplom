﻿#language: ru

@tree
@ExportScenarios
@ТипШага:Бухгалтер Отчет
@Описание: Отчет Анализ выставленных актов
@ПримерИспользования: И я формирую отчет Анализ выставленных актов

Функционал: Формирование отчета Анализ выставленных актов

Как Бухгалтер я хочу
научится формировать отчет Анализ выставленных актов

Сценарий: Формирование отчета Анализ выставленных актов
* И я открываю форму отчета Анализ выставленных актов
	И В командном интерфейсе я выбираю 'Обслуживание клиентов' 'Анализ выставленных актов'
	Тогда открылось окно 'Анализ выставленных актов'
	И я нажимаю на кнопку с именем 'ВыбратьПериод1'
	Тогда открылось окно 'Выберите период'
	И в таблице "PeriodVariantTable" я выбираю текущую строку
* И я формирую отчета Анализ выставленных актов	
	Тогда открылось окно 'Анализ выставленных актов'
	И я нажимаю на кнопку с именем 'СформироватьОтчет'
	
		
	

