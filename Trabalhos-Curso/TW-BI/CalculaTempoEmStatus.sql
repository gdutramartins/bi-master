CREATE DEFINER=`root`@`localhost` PROCEDURE `calculaTempoEmStatus`(IN id_issue INT, IN id_status INT, OUT total_dias INT)
BEGIN
	Declare dt_entrada timestamp;
    Declare status_entrada_novo_valor int;
    Declare status_entrada_antigo_valor int;
    Declare dt_saida timestamp;	
    Declare status_saida_novo_valor int;
    Declare status_saida_antigo_valor int;
    Declare tempo_total int;
    DECLARE finished INTEGER DEFAULT 0;

	DECLARE cur_transicoes CURSOR FOR 
		Select
			created_on, old_value, value
		From
			journals j
		Inner Join	journal_details jd On
			jd.journal_id = j.id
		Where 
			journalized_type = 'Issue' and
			prop_key = 'status_id'  and
            journalized_id = id_issue and
			(value = id_status or old_value = id_status)
		order by created_on;
        
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;
    
    OPEN cur_transicoes;
    
    SET tempo_total = 0;
    getPeriodo: LOOP
		FETCH cur_transicoes INTO dt_entrada, status_entrada_antigo_valor, status_entrada_novo_valor;
		IF finished = 1 THEN 
			LEAVE getPeriodo;
		END IF;
        FETCH cur_transicoes INTO dt_saida, status_saida_antigo_valor, status_saida_novo_valor;
		IF finished = 1 THEN 
			LEAVE getPeriodo;
		END IF;
        IF status_entrada_novo_valor <> id_status OR status_saida_antigo_valor <> id_status THEN
			SET tempo_total = -1;
            LEAVE getPeriodo;
		END IF;
        
        SET tempo_total = tempo_total + TIMESTAMPDIFF(HOUR, dt_entrada, dt_saida);
        
	END LOOP getPeriodo;
    
    CLOSE cur_transicoes;
    IF tempo_total = 0 THEN
		SET total_dias = 0;
    ELSEIF tempo_total > 24 THEN
    	SET total_dias = tempo_total DIV 24;
	ELSE
		SET total_dias = 1;
	END IF;
    
    
END