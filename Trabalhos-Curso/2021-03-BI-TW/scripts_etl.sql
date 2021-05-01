-- ================= ETL Carga das Dimensões ===================

-- Limpa Dim Depto Sol
	Delete FROM dw_redmine.tb_dim_departamento_solicitante;
	
-- Consulta Departamentos
	Select
		distinct cv.value
	From
		custom_values cv
	Inner join issues i on i.id = cv.customized_id
	Where
		cv.custom_field_id in (9) and
		project_id in (81,82,91,92,93,160) and
		cv.value is not null and
		length(trim(cv.value)) > 0;

-- Ajusta Campos Depto Solicitante
	Update 
		dw_redmine.tb_dim_departamento_solicitante
	Set 
		 no_area_solicitante = SUBSTRING_INDEX(nk_departamento_solicitante , '/', 1) ,
		 no_departamento_solicitante = SUBSTRING_INDEX(SUBSTRING_INDEX(nk_departamento_solicitante,'/', 2), '/',-1) ;
	
	-- Força execução síncrona.
	Select 1 from dw_redmine.tb_dim_departamento_solicitante where no_area_solicitante = ?;
	
-- Limpa Dim Prioridade
	Delete FROM dw_redmine.tb_dim_prioridade;
	
-- Consulta Prioridade
	Select id, name from enumerations e where type = 'IssuePriority';
	
- Limpa Dim Categoria
	Delete FROM dw_redmine.tb_dim_categoria;
	
-- Consulta Categoria
	Select
		distinct i.category_id, ic.name, cf.id, cv.value,
		CASE
			WHEN i.category_id is NULL Then 'CV'
			when i.category_id is not NULL Then 'CAT'
		END as tipo_categoria,
		CASE
			WHEN i.category_id is NULL Then cf.id
			when i.category_id is not NULL Then i.category_id
		END as id_categoria,
		CASE
			WHEN i.category_id is NULL Then replace(cv.value,'–','-')
			when i.category_id is not NULL Then ic.name
		END as nome_categoria,
		CASE
			WHEN cv.value is NULL OR LENGTH(TRIM(cv.value)) = 0 Then 'CAT'
			when cv.value is not NULL Then 'CV'
		END as tipo_subcategoria,
		CASE
			WHEN cv.value is NULL OR LENGTH(TRIM(cv.value)) = 0 Then i.category_id
			when cv.value is not NULL Then cf.id
		END as id_subcategoria,
		CASE
			WHEN cv.value is NULL OR LENGTH(TRIM(cv.value)) = 0 Then ic.name
			when cv.value is not NULL Then replace(cv.value,'–','-')
		END as nome_subcategoria
	From
		custom_values cv
	Inner Join custom_fields cf On cv.custom_field_id = cf.id
	Inner Join issues i on cv.customized_id = i.id
	Left Join issue_categories ic on ic.id = i.category_id
	Where
		cf.id  in (32,75,76,10,72) and
		i.project_id  in (81,82,91,92,93,160) and
		(i.category_id is not null or LENGTH(TRIM(cv.value)) > 0 );
		
-- Limpa Dim Situacao
	Delete FROM dw_redmine.tb_dim_situacao;
	
-- Consulta Situacao
	Select id, name from issue_statuses s where exists (select 1 from issues i where i.status_id = s.id) order by position;
	
-- Limpa Tipo Tarefa
	Delete FROM dw_redmine.tb_dim_tipo_tarefa;
	
-- Consulta Tipo Tarefa
	Select 
		distinct t.id, t.name
	From 
		projects_trackers pt
	Inner Join trackers t On t.id = pt.tracker_id
	Where 
		pt.project_id in (81,82,91,92,93,160);
		
-- Limpa Projeto
	Delete FROM dw_redmine.tb_dim_projeto;

-- Consulta Projeto
	Select 
		distinct id, name,
		SUBSTRING_INDEX(Name, '/', 1) AS area,
		SUBSTRING_INDEX(SUBSTRING_INDEX(Name,'/', 2), '/',-1) AS departamento,
		SUBSTRING_INDEX(Name, '/', -1) as gerencia 		
		
	From 
		projects
	Where 
		id in (81,82,91,92,93,160);
		
		
-- Limpa Dim TEMPORARY
	Delete FROM dw_redmine.tb_dim_data;
	
-- Consulta Dim Tempo
	Select
		distinct cv.value as data
		
	From
		custom_values cv
	Inner Join issues i on cv.customized_id = i.id
	Where
		cv.custom_field_id  in (1,5,7) and
		i.project_id  in (81,82,91,92,93,160) and
		cv.value is not null and
		length(TRIM(cv.value)) > 0
	order by value ;
	
	
-- Ajusta Campos Dim TEMPORARY
	Update 
		dw_redmine.tb_dim_data
	Set
		nu_dia = DAY(id_data),
		nu_mes = EXTRACT(MONTH from id_data),
		nu_ano = EXTRACT(YEAR from id_data),
		nu_semana = EXTRACT(WEEK from id_data),
		nu_quarter = EXTRACT(QUARTER from id_data),
		nu_dia_semana = dayofweek(id_data);

	-- Força execução síncrona
	Select 1 from dw_redmine.tb_dim_data where id_data = ?;
	
	
	
	
-- ================= ETL Carga dos Fatos ===================

-- Limpa Fatos - retira também os relacionamentos com a dimensão de dias no estágio. No final da execução do ETL os relacionamentos serão recriados.
	Delete FROM dw_redmine.tb_fato;

	ALTER TABLE `dw_redmine`.`tb_fato` 
	DROP FOREIGN KEY `dim_nu_dias_est_susp_tb_fato_fk`,
	DROP FOREIGN KEY `dim_nu_dias_est_rev_tb_fato_fk`,
	DROP FOREIGN KEY `dim_nu_dias_est_nova_tb_fato_fk`,
	DROP FOREIGN KEY `dim_nu_dias_est_andamento_tb_fato_fk`,
	DROP FOREIGN KEY `dim_nu_dias_est_agRev_tb_fato_fk`;
	ALTER TABLE `dw_redmine`.`tb_fato` 
	DROP INDEX `dim_nu_dias_est_agRev_tb_fato_fk_idx` ,
	DROP INDEX `dim_nu_dias_est_susp_tb_fato_fk_idx` ,
	DROP INDEX `dim_nu_dias_est_andamento_tb_fato_fk_idx` ,
	DROP INDEX `dim_nu_dias_est_rev_tb_fato_fk_idx` ,
	DROP INDEX `dim_nu_dias_est_nova_tb_fato_fk_idx` ;
	
-- Get Fatos
	Select
		i.id,
		8 as id_estagio_revisao,
		1 as id_estagio_nova,
		16 as id_estagio_aguardando_revisao,
		10 as id_estagio_suspensa,
		2 as id_estagio_andamento,
		9 as id_estagio_aguardando_info,
		(Select sum(hours) from time_entries where issue_id = i.id) as total_tempo,
		(Select sum(hours) from time_entries where issue_id = i.id and activity_id in (80,84,85,88, 91, 100)) as total_analise,
		(Select sum(hours) from time_entries where issue_id = i.id and activity_id in (66)) as total_execucao,
		(Select sum(hours) from time_entries where issue_id = i.id and activity_id in (67)) as total_revisao,
		(Select sum(hours) from time_entries where issue_id = i.id and activity_id in (103)) as total_especificacao,
		(Select sum(hours) from time_entries where issue_id = i.id and activity_id in (104)) as total_gestao,
		(Select sum(hours) from time_entries where issue_id = i.id and activity_id in (110)) as total_reuniao,
		(Select sum(hours) from time_entries where issue_id = i.id and activity_id in (111)) as total_capacitacao,
		If(i.parent_id is not null, true, false) as tem_tarefa_pai,
		(select count(*) from issues Ifilho where parent_id = i.id) as quantidade_filhos,
		(Select value from custom_values where customized_id = i.id and custom_field_id = 5 and customized_type = 'Issue') as data_solicitacao,
		(Select value from custom_values where customized_id = i.id and custom_field_id = 1 and customized_type = 'Issue') as data_conclusao,
		(Select value from custom_values where customized_id = i.id and custom_field_id = 7 and customized_type = 'Issue') as data_conclusao_solicitada,
		
		(Select value from custom_values where customized_id = i.id and custom_field_id = 9 and customized_type = 'Issue') as depto_solicitante,
		i.priority_id,
		i.category_id,
		cv.value as cutom_field_categoria,
		cv.custom_field_id,
		i.status_id,
		i.tracker_id,
		i.project_id,
		CASE 
			WHEN cvIndDesempenho.value = 1  THEN 'S' 
			ELSE 'N' 
		END as ind_desempenho,
		CASE
			WHEN i.category_id is NULL Then replace(cv.value,'–','-')
			when i.category_id is not NULL Then cat.name
		END as no_categoria,
		CASE
			WHEN cv.value is NULL OR LENGTH(TRIM(cv.value)) = 0 Then cat.name
			when cv.value is not NULL Then replace(cv.value,'–','-')
		END as no_subcategoria
		
	From Issues i
	Left Join custom_values cv on cv.customized_id = i.id and cv.custom_field_id in (32,75,76,10,72) and cv.customized_type = 'Issue'
	Left Join custom_values cvIndDesempenho on cvIndDesempenho.customized_id = i.id and cvIndDesempenho.custom_field_id = 73 and cvIndDesempenho.customized_type = 'Issue'
	Left Join issue_categories cat on i.category_id = cat.id
	Where
		i.project_id  in (81,82,91,92,93,160) ;
		
-- Limpas Dim Dias Estagio
	Delete FROM dw_redmine.tb_dim_dias_estagio;
	Select 1 from dw_redmine.tb_dim_dias_estagio where nu_dias_estagio = ?;
	
-- Cria Range Dias Estagio e Adiciona FK
	Insert into tb_dim_dias_estagio(nu_dias_estagio)
	Select distinct ext.nu_dias_estagio
		From (Select nova.nu_dias_nova as nu_dias_estagio from tb_fato nova 
			  Union All 
			  Select revisao.nu_dias_revisao as nu_dias_estagio from tb_fato revisao 
			  Union All 
			  Select andamento.nu_dias_andamento as nu_dias_estagio from tb_fato andamento
			  Union All 
			  Select susp.nu_dias_suspensa as nu_dias_estagio from tb_fato susp
			  Union All 
			  Select agRev.nu_dias_aguardando_revisao as nu_dias_estagio from tb_fato agRev		 
			  ) as ext
		order by ext.nu_dias_estagio;
	
	Select 1 from tb_dim_dias_estagio where nu_dias_estagio = ?;

	Alter table tb_fato
	Add KEY `dim_nu_dias_est_nova_tb_fato_fk_idx` (`nu_dias_nova`),
	Add KEY `dim_nu_dias_est_rev_tb_fato_fk_idx` (`nu_dias_revisao`),
	Add KEY `dim_nu_dias_est_andamento_tb_fato_fk_idx` (`nu_dias_andamento`),
	Add KEY `dim_nu_dias_est_susp_tb_fato_fk_idx` (`nu_dias_suspensa`),
	Add KEY `dim_nu_dias_est_agRev_tb_fato_fk_idx` (`nu_dias_aguardando_revisao`),
	Add CONSTRAINT `dim_nu_dias_est_agRev_tb_fato_fk` FOREIGN KEY (`nu_dias_aguardando_revisao`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	Add CONSTRAINT `dim_nu_dias_est_andamento_tb_fato_fk` FOREIGN KEY (`nu_dias_andamento`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	Add CONSTRAINT `dim_nu_dias_est_nova_tb_fato_fk` FOREIGN KEY (`nu_dias_nova`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	Add CONSTRAINT `dim_nu_dias_est_rev_tb_fato_fk` FOREIGN KEY (`nu_dias_revisao`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	Add CONSTRAINT `dim_nu_dias_est_susp_tb_fato_fk` FOREIGN KEY (`nu_dias_suspensa`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

	
	-- Stored Procedure para calcular o tempo que uma tarefa ficou no estágio "Nova". Durante a carga de fatos a procedure é chamada para cada tarefa. O registro histórico de tarefas é consultado para 
	-- que seja possível realizar o cálculo (calculo através do par -> entrada no status e saída dele).
	-- O status Nova precisou de uma procedure diferente porque ele é o primeiro estágio, então o primeiro par (entrada/saída) tem a entrada como data de solicitação.
	
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


	-- Stored Procedure para calcular o tempo que uma tarefa ficou no estágio passado por parâmetro. Durante a carga de fatos a procedure é chamada para cada tarefa. O registro histórico de tarefas é consultado para 
	-- que seja possível realizar o cálculo (calculo através do par -> entrada no status e saída dele).
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