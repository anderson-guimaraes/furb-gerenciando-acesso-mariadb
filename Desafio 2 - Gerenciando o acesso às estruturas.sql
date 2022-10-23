CREATE USER 'user_gerente1' IDENTIFIED BY 'abc123'; -- user para gerente
CREATE USER 'user_recepcionista1' IDENTIFIED BY 'abc123'; -- user para recepcionista
CREATE USER 'user_atendente_geral1' IDENTIFIED BY 'abc123'; -- user para atendente geral

-- a) Haverá 03 (três) grupos (papéis) de usuários do sistema: Gerente, Recepcionista e o Atendente Geral;

CREATE ROLE 'role_gerente';
CREATE ROLE 'role_recepcionista';
CREATE ROLE 'role_atendente_geral';

-- b) O grupo "Gerente" poderá realizar qualquer operação sobre os dados, além de definir acesso (dar direitos) a outros usuários.

GRANT ALL PRIVILEGES ON base_hotelaria.* TO 'role_gerente' WITH GRANT OPTION; -- Add permissões para role de gerente.
GRANT 'role_gerente' TO 'user_gerente1';  -- atribuindo role a um usuário.
SET DEFAULT ROLE 'role_gerente' FOR 'user_gerente1';

-- SHOW GRANTS FOR 'role_gerente';
-- SHOW GRANTS FOR 'user_gerente1';

-- c) O grupo "Recepcionista" poderá realizar todas as operações sobre as estruturas: cliente, reserva e hospedagem.

GRANT ALL PRIVILEGES ON base_hotelaria.cliente TO 'role_recepcionista'; -- Add permissões para role de recepcionista.
GRANT ALL PRIVILEGES ON base_hotelaria.reserva TO 'role_recepcionista'; -- Add permissões para role de recepcionista.
GRANT ALL PRIVILEGES ON base_hotelaria.hospedagem TO 'role_recepcionista'; -- Add permissões para role de recepcionista.
GRANT 'role_recepcionista' TO 'user_recepcionista1';  -- atribuindo role a um usuário.
SET DEFAULT ROLE 'role_recepcionista' FOR 'user_recepcionista1';

-- SHOW GRANTS FOR 'role_recepcionista';
-- SHOW GRANTS FOR 'user_recepcionista1';

-- d) O grupo de usuários "Atendente Geral" poderá apenas realizar leitura dos dados do cliente (nome e número do quarto em que está hospedado)  
-- e realizar operações de inclusão e alteração na estrutura hospedagem serviço.
-- Dica: avaliar possibilidade de utilização de uma visão (view) pra limitar o acesso aos dados do cliente/hospedagem.

-- Criação da view.
CREATE VIEW vw_cliente_resumo AS
SELECT 
	c.NM_CLIENTE,
	h.NR_QUARTO
FROM 
	base_hotelaria.cliente c
INNER JOIN 
	base_hotelaria.hospedagem h
ON 
	h.CD_CLIENTE = c.CD_CLIENTE;
	
GRANT SELECT ON base_hotelaria.vw_cliente_resumo TO 'role_atendente_geral';	-- Add permissões para role de atendente geral.
GRANT SELECT, INSERT, UPDATE ON base_hotelaria.hospedagem_servico TO 'role_atendente_geral' -- Add permissões para role de atendente geral.
GRANT 'role_atendente_geral' TO 'user_atendente_geral1'; -- atribuindo role a um usuário.
SET DEFAULT ROLE 'role_atendente_geral' FOR 'user_atendente_geral1';

-- SHOW GRANTS FOR 'role_atendente_geral';
-- SHOW GRANTS FOR 'user_atendente_geral1';