CREATE TABLE usuario (
    id          BIGSERIAL PRIMARY KEY,
    nome        VARCHAR(120)        NOT NULL,
    email       VARCHAR(255)        NOT NULL,
    senha_hash  VARCHAR(255)        NOT NULL,
    tipo        VARCHAR(20)         NOT NULL,
    CONSTRAINT uq_usuario_email UNIQUE (email)
);

CREATE TABLE ocorrencia (
    id                  BIGSERIAL PRIMARY KEY,
    categoria           VARCHAR(30)         NOT NULL,
    status              VARCHAR(30)         NOT NULL DEFAULT 'RECEBIDA',
    descricao           TEXT                NOT NULL,
    foto                BYTEA,
    prioridade          INTEGER             NOT NULL DEFAULT 0,
    criado_por_id       BIGINT              NOT NULL REFERENCES usuario(id),
    criado_em           TIMESTAMP           NOT NULL DEFAULT NOW(),
    loc_latitude        DOUBLE PRECISION    NOT NULL,
    loc_longitude       DOUBLE PRECISION    NOT NULL,
    loc_endereco        VARCHAR(255),
    loc_bairro          VARCHAR(120)
);

CREATE TABLE historico_status (
    id              BIGSERIAL PRIMARY KEY,
    ocorrencia_id   BIGINT          NOT NULL REFERENCES ocorrencia(id),
    de              VARCHAR(30),
    para            VARCHAR(30)     NOT NULL,
    observacao      TEXT,
    data_hora       TIMESTAMP       NOT NULL DEFAULT NOW(),
    responsavel_id  BIGINT          REFERENCES usuario(id)
);

CREATE TABLE avaliacao (
    id              BIGSERIAL PRIMARY KEY,
    ocorrencia_id   BIGINT          NOT NULL REFERENCES ocorrencia(id),
    nota            SMALLINT        NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario      TEXT,
    criado_em       TIMESTAMP       NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_avaliacao_ocorrencia UNIQUE (ocorrencia_id)
);

CREATE INDEX idx_ocorrencia_status      ON ocorrencia (status);
CREATE INDEX idx_ocorrencia_categoria   ON ocorrencia (categoria);
CREATE INDEX idx_ocorrencia_bairro      ON ocorrencia (loc_bairro);
CREATE INDEX idx_ocorrencia_prioridade  ON ocorrencia (prioridade DESC);
