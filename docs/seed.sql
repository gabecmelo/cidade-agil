-- Usuários de teste para desenvolvimento local.
-- Senhas: gestor -> "admin123" | cidadão -> "cidadao123"
-- Hashes gerados com BCryptPasswordEncoder (strength 10).
-- Executar após aplicar a migration V1 com o banco já no ar.

INSERT INTO usuario (nome, email, senha_hash, tipo) VALUES
    ('Gestor Teste', 'gestor@cidadeagil.gov.br', '$2a$10$tpfwHxG7OzuOcaRDcRm22e5GlczN2nif4pAfjDhHVBAuaOVhclyv2', 'GESTOR'),
    ('Cidadão Teste', 'cidadao@teste.com',        '$2a$10$xzxzOmSmH9phSH5bmqKH..IgUv0GUtrwtOc4V4vzVOeopiaNk46l.', 'CIDADAO')
ON CONFLICT (email) DO NOTHING;
