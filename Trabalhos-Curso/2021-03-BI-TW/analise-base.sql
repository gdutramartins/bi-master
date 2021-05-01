SELECT 
	i.id, t.name, s.name, c.name, i.priority_id
FROM 
	issues i
Inner Join trackers t on t.id = i.tracker_id
Inner Join issue_statuses s on s.id = i.status_id
Inner Join issue_categories c on c.id = i.category_id
Where 
	i.id = 40879;

select * from issues where root_id <> id and root_id <> parent_id order by created_on desc;

select * from projects;
Select 
	f.name, v.* 
From 
	custom_values v
Inner Join custom_fields f on v.custom_field_id = f.id
where 
	customized_id = 40853
Order by 
	f.name;
    
    
Select * from custom_fields where id=5;    


Select * from users where id = 319;
select * from groups_users gu where exists (select 1 from groups_users where group_id = gu.group_id and user_id = 165) and exists (select 1 from groups_users where group_id = gu.group_id and user_id = 448) ;
select * from members where project_id = 81;
    
Select * from issue_categories;

Select * from issue_statuses;
select * from issue_relations order by 1 desc;

Select * from custom_fields_trackers;

select * from attachments where container_id ;
Select * from time_entries order by 1 desc;
Select * from enumerations;


Select * from custom_fields where id = 110;

Select * from roles;
select * from groups_users where group_id = 7;

Select * from members where project_id = 82 and user_id = 150;
Select * from groups_users where user_id = 150;

Select * from projects where status = 1; and exists (select 1 from custom_fields where id = 32);
select * from enumerations where active = 1;



select * from issue_statuses ;

select  t.activity_id , e.name, count(*) from time_entries t inner join enumerations e on e.id = t.activity_id  group by t.Activity_id, e.name ;


Select 
	*
From 
	custom_values cv
Inner Join custom_fields cf ON cv.custom_field_id = cf.id
Left join custom_fields_projects cfp on cfp.custom_field_id = cf.id;	

--
select i.id, i.closed_on from issues i where i.status_id = 3 order by 1 desc;

/** ================================================= TIME_ENTRIES ===================================================================== **/
-- Consultar todas os tipos de categorias para registro de tempo que estão nas issues
Select 
	* 
From 
	Enumerations 
Where id in (
			Select
				distinct t.activity_id
			From Issues i
			Inner join time_entries t on t.issue_id = i.id
			Where
				i.project_id  in (81,82,91,92,93,160)
             ) ;

/** ================================================= CUSTOM FIELDS ===================================================================== **/
-- Custom Fiels por nome
Select * from custom_fields where name like 'In%';

-- Custom Fiels relacionados ao projeto
Select 
	distinct project_id
from 
	custom_fields_projects
where 
	custom_field_id = 8 and
    project_id in (81,82,91,92,93,160);

-- Verifica se tem nulos para um custom value
Select
	i.id
From
	issues i 
Where
	not exists (Select 1 from custom_values cv where cv.custom_field_id = 5 and cv.customized_id = i.id and cv.customized_type = 'Issue') and
	i.project_id  in (81,82,91,92,93,160) and
    i.status_id in (3) ;
    
select count(*) from  custom_values where custom_field_id = 1;
-- Valor do custom field em issue
Select
	cv.value, i.project_id
From
	custom_values cv
Inner join issues i on i.id = cv.customized_id
where
	cv.custom_field_id in (5) and i.id = 35853 and
    project_id in (81,82,91,92,93,160);
    
/*============== FIM CUSTOM FIELD ===================== */


-- Dimensão Departamento Solicitante
Select possible_values from custom_fields where id = 9;

Select
	distinct cv.value
From
	custom_values cv
Inner join issues i on i.id = cv.customized_id
where
	cv.custom_field_id in (9) and
    project_id in (81,82,91,92,93,160) and
    cv.value is not null and
    length(trim(cv.value)) > 0;

Update 
	dw_redmine.tb_dim_departamento_solicitante
Set 
     no_area_solicitante = SUBSTRING_INDEX(nk_departamento_solicitante , '/', 1) ,
     no_departamento_solicitante = SUBSTRING_INDEX(SUBSTRING_INDEX(nk_departamento_solicitante,'/', 2), '/',-1) ;

-- Dimensao Prioridade
Select id, name from enumerations e where type = 'IssuePriority';

-- Dimensão Categoria - Tratar repetição
Select * from issue_categories Where project_id in (81,82,91,92,93,160);

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


-- Dimensão Situação
Select id, name from issue_statuses s where exists (select 1 from issues i where i.status_id = s.id) order by position;

-- Dimensão Tipo de Tarefa (tracker)
Select 
	distinct t.id, t.name
From 
	projects_trackers pt
Inner Join trackers t On t.id = pt.tracker_id
Where 
	pt.project_id in (81,82,91,92,93,160);
    
-- Dimensão Projeto
SELECT SUBSTRING_INDEX(Name, '/', 1) AS fname,
SUBSTRING_INDEX(SUBSTRING_INDEX(Name,'/', 2), '/',-1) AS mname,
SUBSTRING_INDEX(Name, '/', -1) as lname 
From 
	projects
Where 
	id in (81,82,91,92,93,160);


Select 
	distinct id, name,
    SUBSTRING_INDEX(Name, '/', 1) AS area,
	SUBSTRING_INDEX(SUBSTRING_INDEX(Name,'/', 2), '/',-1) AS departamento,
	SUBSTRING_INDEX(Name, '/', -1) as gerencia 		
    
From 
	projects
Where 
	id in (81,82,91,92,93,160);
   
-- Lista de tarefas que não estão nos projetos ativos
Select 
	p.name, count(*), min(i.start_date), max(start_date)
From 
	issues i
Inner Join projects p on p.id = i.project_id
Where 
	project_id not in (81,82,91,92,93,160)
Group by p.name
;
    
-- Dimensão Departamento Solicitante (Custom Value)
Select
	distinct cv.value
From
	custom_values cv
Inner Join custom_fields cf On cv.custom_field_id = cf.id
Inner Join issues i on cv.customized_id = i.id
Where
	cf.id  = 9 and
	i.project_id  in (81,82,91,92,93,160);
    
-- Dimensão Elaborado Por (Custom Value)
Select
	distinct cv.value
From
	custom_values cv
Inner Join custom_fields cf On cv.custom_field_id = cf.id
Inner Join issues i on cv.customized_id = i.id
Where
	cf.id  = 9 and
	i.project_id  in (81,82,91,92,93,160);
    
-- Dimensão Atividade Cobrança/Subcategoria de Atendimento/Tipo de Rotina (Custom Value)
Select
	distinct cv.value, cf.id
From
	custom_values cv
Inner Join custom_fields cf On cv.custom_field_id = cf.id
Inner Join issues i on cv.customized_id = i.id
Where
	cf.id  in (32,75,76) and
	i.project_id  in (81,82,91,92,93,160);
 
 --- Dimensão Tempo
 Select
	distinct STR_TO_DATE(cv.value, '%Y-%m-%d') as data
From
	custom_values cv
Inner Join issues i on cv.customized_id = i.id
Where
	cv.custom_field_id  in (1,5,7) and
	i.project_id  in (81,82,91,92,93,160) and
    cv.value is not null and
    length(TRIM(cv.value)) > 0
order by value;

SELECT EXTRACT(YEAR FROM nk_data_original)
FROM dw_redmine.tb_dim_tempo;
   
Update 
	dw_redmine.tb_dim_data
Set
	nu_dia = DAY(id_data),
    nu_mes = EXTRACT(MONTH from id_data),
    nu_ano = EXTRACT(YEAR from id_data),
    nu_semana = EXTRACT(WEEK from id_data),
    nu_quarter = EXTRACT(QUARTER from id_data),
    nu_dia_semana = dayofweek(id_data);
    
    
-- Tabela Fato
SET @row_number = 0;  
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
    
Select * from dw_redmine.tb_dim_departamento_solicitante;    
select * from db_redmine_asn.time_entries;where type = 'TimeEntryActivity';
select  t.activity_id , e.name, count(*), min(created_on), max(created_on) from time_entries t inner join enumerations e on e.id = t.activity_id  group by t.Activity_id, e.name ;

Select * from journals;
Select * from journal_details;
select * from issue_statuses;

-- Analise de Histórico Journals

Select
	journalized_id, created_on, old_value, value, property, prop_key
From
	journals j
Inner Join	journal_details jd On
	jd.journal_id = j.id
Where 
	journalized_type = 'Issue' and
    prop_key = 'status_id'     and
    journalized_id  > 34400 and journalized_id < 34500
     and  (value = 1 or old_value = 1)
order by journalized_id, created_on
    ;
Select
	value , old_value, count(*)
From
	journals j
Inner Join	journal_details jd On
	jd.journal_id = j.id
Where 
	journalized_type = 'Issue' and
    prop_key = 'status_id' 
group by value, old_value
order by value, old_value
    ;


call calculaTempoEmStatus(40801,8, @Total);
Select @total ;

call calculaTempoEmStatusNova(3586,1, @Total);
Select @total ;    




ALTER TABLE `dw_redmine`.`tb_fato` 
ADD INDEX `dim_nu_dias_est_agRev_tb_fato_fk_idx` (`nu_dias_aguardando_revisao` ASC);
;
ALTER TABLE `dw_redmine`.`tb_fato` 
ADD CONSTRAINT `dim_nu_dias_est_agRev_tb_fato_fk`
  FOREIGN KEY (`nu_dias_aguardando_revisao`)
  REFERENCES `dw_redmine`.`tb_dim_dias_estagio` (`nu_dias_estagio`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

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
		  Union All
		  Select -2 as nu_dias_aguardando_revisao from dw_redmine.tb_dim_dias_estagio where 1 = 2 and nu_dias_estagio = 2
		  ) as ext
	order by ext.nu_dias_estagio;

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
commit;

Select 
	nk_issue_id,
    id_data_solicitacao,
    id_data_conclusao,
    DATEDIFF(id_data_conclusao, id_data_solicitacao)  as diff
 From 
	tb_fato 
Where 
	id_data_conclusao < id_data_solicitacao 
and id_data_conclusao is not null 
and id_data_solicitacao is not null 

Order by
	diff ;
    rollback;