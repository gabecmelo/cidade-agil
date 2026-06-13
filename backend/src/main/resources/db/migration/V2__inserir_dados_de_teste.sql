-- Usuários de teste para desenvolvimento local.
-- Senhas: gestor -> "admin123" | cidadão -> "cidadao123"
-- Hashes gerados com BCryptPasswordEncoder (strength 10).
-- Executar após aplicar a migration V1 com o banco já no ar.
TRUNCATE TABLE avaliacao, historico_status, ocorrencia, usuario RESTART IDENTITY CASCADE;

-- 3. Insere os usuários gerando o BCrypt direto pelo motor do Postgres (10 rounds padrão)
INSERT INTO usuario (nome, email, senha_hash, tipo) VALUES
    ('Gestor Teste', 'gestor@cidadeagil.gov.br', '$2a$10$8JqUiZKlr2IrRH6tn0tQgOQn1FgbO.Ek7wYmuEV0sL/tTG5t2nFN2', 'GESTOR'),
    ('Cidadão Teste', 'cidadao@teste.com',       '$2a$10$bsJyT3tOtSsrLQVBgXmjE.Aw/2w7Ou5QdhjBj1Ki6qCVhKUVxmu5.', 'CIDADAO')
ON CONFLICT (email) DO NOTHING;

-- Ocorrências de teste (foto NULL — sem imagem no seed).
-- Cobre os 4 status e 5 categorias para exercitar toda a UI e endpoints.

INSERT INTO ocorrencia (categoria, status, descricao, prioridade, criado_por_id, criado_em, loc_latitude, loc_longitude, loc_endereco, loc_bairro)
VALUES
    ('BURACO',      'RECEBIDA',       'Buraco profundo na Rua das Flores, próximo ao número 142. Risco para veículos.',           5,  (SELECT id FROM usuario WHERE email = 'cidadao@teste.com'), NOW() - INTERVAL '3 days',  -23.5505, -46.6333, 'Rua das Flores, 142',        'Centro'),
    ('ILUMINACAO',  'EM_ANALISE',     'Poste apagado há mais de uma semana na Av. Brasil. Trecho escuro à noite.',                 6,  (SELECT id FROM usuario WHERE email = 'cidadao@teste.com'), NOW() - INTERVAL '7 days',  -23.5520, -46.6350, 'Av. Brasil, 890',            'Jardim América'),
    ('ALAGAMENTO',  'EM_ATENDIMENTO', 'Calha entupida causa alagamento a cada chuva. Afeta entrada de escola.',                    12, (SELECT id FROM usuario WHERE email = 'cidadao@teste.com'), NOW() - INTERVAL '5 days',  -23.5490, -46.6310, 'Rua Marechal Deodoro, 55',   'Vila Nova'),
    ('VANDALISMO',  'RESOLVIDA',      'Pichações em toda a extensão do muro do parque municipal. Patrimônio danificado.',          4,  (SELECT id FROM usuario WHERE email = 'cidadao@teste.com'), NOW() - INTERVAL '14 days', -23.5540, -46.6380, 'Parque Municipal, portão 2', 'Bela Vista'),
    ('CALCADA',     'RECEBIDA',       'Calçada com placas soltas e irregulares. Idosos e cadeirantes em risco de queda.',          3,  (SELECT id FROM usuario WHERE email = 'cidadao@teste.com'), NOW() - INTERVAL '1 day',   -23.5510, -46.6340, 'Rua Consolação, 310',        'Consolação')
;

-- Histórico de status para as ocorrências que avançaram de RECEBIDA.

INSERT INTO historico_status (ocorrencia_id, de, para, observacao, data_hora, responsavel_id)
VALUES
    (
        (SELECT id FROM ocorrencia WHERE descricao LIKE 'Poste apagado%'),
        'RECEBIDA', 'EM_ANALISE',
        'Solicitação de vistoria enviada à concessionária de energia.',
        NOW() - INTERVAL '5 days',
        (SELECT id FROM usuario WHERE email = 'gestor@cidadeagil.gov.br')
    ),
    (
        (SELECT id FROM ocorrencia WHERE descricao LIKE 'Calha entupida%'),
        'RECEBIDA', 'EM_ANALISE',
        'Equipe de drenagem acionada para avaliação.',
        NOW() - INTERVAL '4 days',
        (SELECT id FROM usuario WHERE email = 'gestor@cidadeagil.gov.br')
    ),
    (
        (SELECT id FROM ocorrencia WHERE descricao LIKE 'Calha entupida%'),
        'EM_ANALISE', 'EM_ATENDIMENTO',
        'Equipe no local realizando desobstrução da calha.',
        NOW() - INTERVAL '2 days',
        (SELECT id FROM usuario WHERE email = 'gestor@cidadeagil.gov.br')
    ),
    (
        (SELECT id FROM ocorrencia WHERE descricao LIKE 'Pichações%'),
        'RECEBIDA', 'EM_ANALISE',
        'Ordem de serviço gerada para equipe de manutenção.',
        NOW() - INTERVAL '12 days',
        (SELECT id FROM usuario WHERE email = 'gestor@cidadeagil.gov.br')
    ),
    (
        (SELECT id FROM ocorrencia WHERE descricao LIKE 'Pichações%'),
        'EM_ANALISE', 'EM_ATENDIMENTO',
        'Equipe de pintura iniciou limpeza do muro.',
        NOW() - INTERVAL '10 days',
        (SELECT id FROM usuario WHERE email = 'gestor@cidadeagil.gov.br')
    ),
    (
        (SELECT id FROM ocorrencia WHERE descricao LIKE 'Pichações%'),
        'EM_ATENDIMENTO', 'RESOLVIDA',
        'Muro limpo e repintado. Ocorrência encerrada.',
        NOW() - INTERVAL '7 days',
        (SELECT id FROM usuario WHERE email = 'gestor@cidadeagil.gov.br')
    )
;

-- Avaliação para a ocorrência resolvida.

INSERT INTO avaliacao (ocorrencia_id, nota, comentario, criado_em)
VALUES (
    (SELECT id FROM ocorrencia WHERE descricao LIKE 'Pichações%'),
    4,
    'Atendimento rápido e eficiente. O muro ficou limpo.',
    NOW() - INTERVAL '6 days'
)
ON CONFLICT ON CONSTRAINT uq_avaliacao_ocorrencia DO NOTHING;
