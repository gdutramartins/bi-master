CREATE DEFINER=`root`@`localhost` PROCEDURE `calculaTempoEmStatusNova`(IN id_issue INT, IN id_status INT, OUT total_dias INT)
proc:BEGIN
	Declare dt_entrada timestamp;
    Declare status_entrada_novo_valor int;
    Declare status_entrada_antigo_valor int;
    Declare dt_saida timestamp;	
    Declare status_saida_novo_valor int;
    Declare status_saida_antigo_valor int;
    Declare tempo_total int;
    DECLARE finished INTEGER DEFAULT 0;
	Declare num_transicoes INT;
    
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
    
    Set num_transicoes = 0;
    SET tempo_total = 0;
    
    SELECT
		CASE
			WHEN length(trim(value)) = 0 THEN null
			WHEN DAYNAME(value) is not null THEN value
            ELSE null
		END
    FROM 
		custom_values 
    WHERE customized_id = id_issue and 
          custom_field_id = 5 
          and customized_type = 'Issue' 
	INTO dt_entrada;
    IF dt_entrada is null THEN
		SET TOTAL_DIAS = -1;
		LEAVE proc;
    END IF;
      
    SET status_entrada_novo_valor = id_status;
    OPEN cur_transicoes;    
    
    getPeriodo: LOOP
		IF num_transicoes <> 0 THEN
			FETCH cur_transicoes INTO dt_entrada, status_entrada_antigo_valor, status_entrada_novo_valor;
			IF finished = 1 THEN 
				LEAVE getPeriodo;
			END IF;
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
        
        Set num_transicoes = num_transicoes + 1;
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