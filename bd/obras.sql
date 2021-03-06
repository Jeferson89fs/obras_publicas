PGDMP     1    0                z            obras_publicas    9.6.23    9.6.23    g
           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            h
           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            i
           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            j
           1262    24652    obras_publicas    DATABASE     ?   CREATE DATABASE obras_publicas WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE obras_publicas;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            k
           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6            l
           0    0    SCHEMA public    ACL     &   GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6                        3079    12387    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            m
           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    24669    fn_cnpj_cpf(text)    FUNCTION     ?
  CREATE FUNCTION public.fn_cnpj_cpf(text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 v_string text := $1;
 v_caldv1 int4;
 v_caldv2 int4;
 v_dv1 int4;
 v_dv2 int4;
 v_array1 text[] ;
 v_array2 text[] ;
 v_tst_string int4;
BEGIN

if v_string in ('12345678910','12345678911','12345678912','12345678913') then --ignora os cpf´s dos usuários padrões/testes
return true;
end if;

if v_string in ('11111111111','22222222222','33333333333','44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999' ) then --Força falso para estes cpf´s
return false;
end if;

 v_string := translate(v_string, './-', '');
 IF (char_length(v_string)::int4) = 14 THEN

  SELECT INTO v_array1 '{5,4,3,2,9,8,7,6,5,4,3,2}';
  SELECT INTO v_array2 '{6,5,4,3,2,9,8,7,6,5,4,3,2}';
  v_dv1 := (substring(v_string, 13, 1))::int4;
  v_dv2 := (substring(v_string, 14, 1))::int4;
  /* COLETA DIG VER 1 CNPJ */
  v_caldv1 := 0;
  FOR va IN 1..12 LOOP
   v_caldv1 := v_caldv1 + ((SELECT substring(v_string, va, 1))::int4 * (v_array1[va]::int4));
  END LOOP;
  v_caldv1 := v_caldv1 % 11;
   IF (v_caldv1 = 0) OR (v_caldv1 = 1) THEN
    v_caldv1 := 0;
   ELSE
    v_caldv1 := 11 - v_caldv1;
   END IF;
  /* COLETA DIG VER 2 CNPJ */
  v_caldv2 := 0;
  FOR va IN 1..13 LOOP
   v_caldv2 := v_caldv2 + ((SELECT substring(v_string || v_caldv1::text, va, 1))::int4 * (v_array2[va]::int4));
  END LOOP;
  v_caldv2 := v_caldv2 % 11;
   IF (v_caldv2 = 0) OR (v_caldv2 = 1) THEN
    v_caldv2 := 0;
   ELSE
    v_caldv2 := 11 - v_caldv2;
   END IF;
  /* TESTA */
  IF (v_caldv1 = v_dv1) AND (v_caldv2 = v_dv2) THEN
   RETURN TRUE;
  ELSE
   RETURN FALSE;
  END IF;

 ELSIF (char_length(v_string)::int4) = 11 THEN

  v_dv1 := (substring(v_string, 10, 1))::int4;
  v_dv2 := (substring(v_string, 11, 1))::int4;
  v_string := substring(v_string, 1, 9);
  /* COLETA DIG VER 1 CPF */
  v_caldv1 := 0;
  FOR va IN 1..9 LOOP
   v_caldv1 := v_caldv1 + ((SELECT substring(v_string, va, 1))::int4 * (11 - va));
  END LOOP;
  v_caldv1 := v_caldv1 % 11;
  IF (v_caldv1 = 0) OR (v_caldv1 = 1) THEN
   v_caldv1 := 0;
  ELSE
   v_caldv1 := 11 - v_caldv1;
  END IF;
  /* COLETA DIG VER 2 CPF */
  v_caldv2 := 0;
  FOR va IN 1..10 LOOP
   v_caldv2 := v_caldv2 + ((SELECT substring((v_string || v_caldv1::text), va, 1))::int4 * (12 - va));
  END LOOP;
  v_caldv2 := v_caldv2 % 11;
  IF (v_caldv2 = 0) OR (v_caldv2 = 1) THEN
   v_caldv2 := 0;
  ELSE
   v_caldv2 := 11 - v_caldv2;
  END IF;
  /* TESTA */
  IF (v_caldv1 = v_dv1) AND (v_caldv2 = v_dv2) THEN
   RETURN TRUE;
  ELSE
   RETURN FALSE;
  END IF;

 END IF;

RETURN FALSE;
END;
$_$;
 (   DROP FUNCTION public.fn_cnpj_cpf(text);
       public       postgres    false    6    1            ?            1259    33862    acompanhamento    TABLE     ?  CREATE TABLE public.acompanhamento (
    id_acompanhamento integer NOT NULL,
    id_intervencao integer NOT NULL,
    id_origem_acompanhamento integer NOT NULL,
    nr_acompanhamento numeric(4,0) NOT NULL,
    dt_acompanhamento date NOT NULL,
    id_tipo_acompanhamento integer NOT NULL,
    fl_fisica_usuario_responsavel character(1) NOT NULL,
    nr_cpf_usuario_responsavel numeric(14,0) NOT NULL,
    ds_observacao character varying(250),
    id_tipo_medicao integer,
    nr_percent_fisico_medicao numeric(7,4),
    id_contrato integer,
    id_ato_contratual integer,
    id_motivo_paralisacao integer,
    id_leiato integer,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    cd_leiato numeric(6,0),
    id_boletim_medicao integer,
    CONSTRAINT ck_acompanhamento_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_acompanhamento_fl_fisica_resp CHECK ((fl_fisica_usuario_responsavel = 'F'::bpchar))
);
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_acompanhamento SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_intervencao SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_origem_acompanhamento SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN nr_acompanhamento SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN dt_acompanhamento SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_tipo_acompanhamento SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN fl_fisica_usuario_responsavel SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN ds_observacao SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_tipo_medicao SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN nr_percent_fisico_medicao SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_contrato SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_ato_contratual SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_motivo_paralisacao SET STATISTICS 0;
ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_leiato SET STATISTICS 0;
 "   DROP TABLE public.acompanhamento;
       public         postgres    true    6            n
           0    0    TABLE acompanhamento    COMMENT     ?  COMMENT ON TABLE public.acompanhamento IS 'Table Responsável pelo armazenamento dos dados cadastrais dos acompanhamentos das intervenções. Os acompanhamentos são realizados através de medições, paralisações, conclusões, cancelamentos e informações de cadastramento indevido realizados pelos jurisdicionados ou por entrada de informações provenientes do controle externo.';
            public       postgres    false    246            o
           0    0 '   COLUMN acompanhamento.id_acompanhamento    COMMENT     g   COMMENT ON COLUMN public.acompanhamento.id_acompanhamento IS 'ID|Identificador da Table; Primary Key';
            public       postgres    false    246            p
           0    0 $   COLUMN acompanhamento.id_intervencao    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.id_intervencao IS 'Interveção|Intervenção do respectivo acompanhamento de obra; foreing key oriun da table public.intervencao';
            public       postgres    false    246            q
           0    0 .   COLUMN acompanhamento.id_origem_acompanhamento    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.id_origem_acompanhamento IS 'Origem Acompanhamento|Valores possíveis, conforme a tabela (simam.OrigemAcompanhamento).';
            public       postgres    false    246            r
           0    0 '   COLUMN acompanhamento.nr_acompanhamento    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.nr_acompanhamento IS 'Nro. Acompanhamento|Número de controle de acompanhamento. Numeração sequencial por id_intervenção.';
            public       postgres    false    246            s
           0    0 '   COLUMN acompanhamento.dt_acompanhamento    COMMENT     l   COMMENT ON COLUMN public.acompanhamento.dt_acompanhamento IS 'Data Acompanhamento|Data do acompanhamento.';
            public       postgres    false    246            t
           0    0 ,   COLUMN acompanhamento.id_tipo_acompanhamento    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.id_tipo_acompanhamento IS 'Tipo Acompanhamento|Valores possíveis, conforme a tabela (simam.TipoAcompanhamento).';
            public       postgres    false    246            u
           0    0 3   COLUMN acompanhamento.fl_fisica_usuario_responsavel    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.fl_fisica_usuario_responsavel IS 'CPF|Flag Cpf/Cnpj do responsavel, sempre será F. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    246            v
           0    0 0   COLUMN acompanhamento.nr_cpf_usuario_responsavel    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.nr_cpf_usuario_responsavel IS 'Nr. CPF|Número do CPF do Responsável. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    246            w
           0    0 #   COLUMN acompanhamento.ds_observacao    COMMENT     V   COMMENT ON COLUMN public.acompanhamento.ds_observacao IS 'Observação|Observação';
            public       postgres    false    246            x
           0    0 %   COLUMN acompanhamento.id_tipo_medicao    COMMENT     
  COMMENT ON COLUMN public.acompanhamento.id_tipo_medicao IS 'Tipo Medição|Representa o tipo de medição. Os valores válidos estão disponíveis na tabela (simam.TipoMedicao).  Somente Obrigatório se id_origem_acompanhamento = 1 and id_tipo_acompanhamento = 1';
            public       postgres    false    246            y
           0    0 /   COLUMN acompanhamento.nr_percent_fisico_medicao    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.nr_percent_fisico_medicao IS 'Percentual Físico Medição|Percentual físico medido. Somente Obrigatório se id_origem_acompanhamento = 1 and id_tipo_acompanhamento = 1';
            public       postgres    false    246            z
           0    0 !   COLUMN acompanhamento.id_contrato    COMMENT       COMMENT ON COLUMN public.acompanhamento.id_contrato IS 'Contrato|ID contrato que está sendo executado Foreing Key oriunda da table compras.contrato; 
Somente Obrigatório se:
id_origem_acompanhamento = 1 and id_tipo_acompanhamento = 1 and
id_tipo_medicao = 1.';
            public       postgres    false    246            {
           0    0 '   COLUMN acompanhamento.id_ato_contratual    COMMENT       COMMENT ON COLUMN public.acompanhamento.id_ato_contratual IS 'Aditivo|ID Aditivo que está sendo executado Foreing Key oriunda da table compras.atos_contratuais;
Somente Obrigatório se:
id_origem_acompanhamento = 1 and id_tipo_acompanhamento = 1 and
id_tipo_medicao = 2.';
            public       postgres    false    246            |
           0    0 +   COLUMN acompanhamento.id_motivo_paralisacao    COMMENT       COMMENT ON COLUMN public.acompanhamento.id_motivo_paralisacao IS 'Motivo Paralisação|Motivo da Paralisação, foreing key oriunda da table simam.motivoparalisacao;
Somente Obrigatório Se:
Id_Origem_Acompanhamento = 1 and
Id_Tipo_Acompanhamento = 2.';
            public       postgres    false    246            }
           0    0    COLUMN acompanhamento.id_leiato    COMMENT     ?   COMMENT ON COLUMN public.acompanhamento.id_leiato IS 'Lei/Ato|Lei/Ato do Acompanhamento;
Somente Obrigatório se:
id_origem_acompanhamento = 1';
            public       postgres    false    246            ~
           0    0 0   COLUMN acompanhamento.fl_fisica_usuario_inclusao    COMMENT     9  COMMENT ON COLUMN public.acompanhamento.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    246            
           0    0 -   COLUMN acompanhamento.nr_cpf_usuario_inclusao    COMMENT     ,  COMMENT ON COLUMN public.acompanhamento.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    246            ?            1259    33860 $   acompanhamento_id_acompanhamento_seq    SEQUENCE     ?   CREATE SEQUENCE public.acompanhamento_id_acompanhamento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.acompanhamento_id_acompanhamento_seq;
       public       postgres    false    246    6            ?
           0    0 $   acompanhamento_id_acompanhamento_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.acompanhamento_id_acompanhamento_seq OWNED BY public.acompanhamento.id_acompanhamento;
            public       postgres    false    245            ?            1259    33965    aditivo_contrato    TABLE     @  CREATE TABLE public.aditivo_contrato (
    id_ato_contratual integer NOT NULL,
    id_contrato integer NOT NULL,
    nr_aditivo numeric(3,0) NOT NULL,
    nr_ano_aditivo numeric(4,0) NOT NULL,
    ds_objeto character varying(1500),
    dt_aditivo timestamp(6) without time zone NOT NULL,
    dt_assinatura_aditivo timestamp(6) without time zone NOT NULL,
    dt_publicacao_aditivo timestamp(6) without time zone NOT NULL,
    dt_termino_vigencia timestamp(6) without time zone,
    dt_termino_execucao timestamp(6) without time zone,
    vl_aditivo numeric(16,2),
    vl_aditivo_proprio numeric(16,2),
    vl_aditivo_estadual numeric(16,2),
    vl_aditivo_federal numeric(16,2),
    vl_aditivo_operacao numeric(16,2),
    vl_aditivo_material numeric(16,2),
    vl_aditivo_mao_obra numeric(16,2),
    vl_aditivo_equipamento numeric(16,2),
    fl_cpf_cnpj_inclusao character(1) NOT NULL,
    nr_cpf_cnpj_inclusao numeric(14,0) NOT NULL,
    dt_inclusao timestamp(6) without time zone NOT NULL,
    CONSTRAINT ck_acompanhamento_fl_fisica_resp CHECK ((fl_cpf_cnpj_inclusao = 'F'::bpchar))
);
 $   DROP TABLE public.aditivo_contrato;
       public         postgres    true    6            ?            1259    33963 &   aditivo_contrato_id_ato_contratual_seq    SEQUENCE     ?   CREATE SEQUENCE public.aditivo_contrato_id_ato_contratual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.aditivo_contrato_id_ato_contratual_seq;
       public       postgres    false    6    249            ?
           0    0 &   aditivo_contrato_id_ato_contratual_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.aditivo_contrato_id_ato_contratual_seq OWNED BY public.aditivo_contrato.id_ato_contratual;
            public       postgres    false    248            ?            1259    33901    anexo    TABLE     ?  CREATE TABLE public.anexo (
    id_anexo integer NOT NULL,
    id_tipo_anexo integer NOT NULL,
    id_intervencao integer,
    nm_url_arquivo character(100) NOT NULL,
    ds_anexo character(100),
    dt_inclusao timestamp(6) without time zone,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_data_1 timestamp(6) without time zone,
    dt_data_2 timestamp(6) without time zone,
    dt_data_3 timestamp(6) without time zone,
    nr_valor_1 numeric(14,2),
    nr_valor_2 numeric(14,2),
    ds_descricao character(200),
    id_acompanhamento integer,
    id_responsabilidade_tecnica integer,
    id_matricula_inss integer,
    id_cnd_obra integer,
    id_planilha_orcamento integer,
    id_planilha_execucao integer,
    id_orcamento integer,
    id_responsabilidade_tecnica_or integer,
    nr_valor_3 numeric(14,2),
    id_ordem_servico integer,
    CONSTRAINT ck_anexo_interv_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
    DROP TABLE public.anexo;
       public         postgres    false    6            ?
           0    0    TABLE anexo    COMMENT     ?   COMMENT ON TABLE public.anexo IS 'Table Responsável pelo armazenamento dos dados cadastrais dos anexos que podem ser anexados pelo sistema de obras públicas.';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.id_anexo    COMMENT     ^   COMMENT ON COLUMN public.anexo.id_anexo IS 'ID| IDENTIFICADOR DA TABELA  ANEXO_INTERVENCAO ';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.id_tipo_anexo    COMMENT     h   COMMENT ON COLUMN public.anexo.id_tipo_anexo IS 'ID TIPO ANEXO | IDENTIFICADOR DA TABELA  TIPO_ANEXO ';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.id_intervencao    COMMENT     X   COMMENT ON COLUMN public.anexo.id_intervencao IS 'INTERVENÇÃO| ID DA INTERVENÇÃO ';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.nm_url_arquivo    COMMENT     N   COMMENT ON COLUMN public.anexo.nm_url_arquivo IS 'URL| ENDEREÇO DA IMAGEM ';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.ds_anexo    COMMENT     R   COMMENT ON COLUMN public.anexo.ds_anexo IS 'NOME ANEXO | NOME DO ANEXO ORIGINAL';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.dt_inclusao    COMMENT     T   COMMENT ON COLUMN public.anexo.dt_inclusao IS 'DATA INCLUSÃO | DATA DA INCLUSÃO';
            public       postgres    false    247            ?
           0    0 '   COLUMN anexo.fl_fisica_usuario_inclusao    COMMENT     ?   COMMENT ON COLUMN public.anexo.fl_fisica_usuario_inclusao IS 'TIPO DA PESSOA| FLAG INDICATIVA DO TIPO D APESSOA QUE CADASTROU O REGISTRO ';
            public       postgres    false    247            ?
           0    0 $   COLUMN anexo.nr_cpf_usuario_inclusao    COMMENT     w   COMMENT ON COLUMN public.anexo.nr_cpf_usuario_inclusao IS 'DOCUMENTO | DOCUMENTO DA PESSOA QUE CADASTROU O REGISTRO ';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.dt_data_1    COMMENT     D   COMMENT ON COLUMN public.anexo.dt_data_1 IS 'DATA 1| DATA 1 ANEXO';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.dt_data_2    COMMENT     D   COMMENT ON COLUMN public.anexo.dt_data_2 IS 'DATA 2| DATA 2 ANEXO';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.dt_data_3    COMMENT     D   COMMENT ON COLUMN public.anexo.dt_data_3 IS 'DATA 3| DATA 3 ANEXO';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.nr_valor_1    COMMENT     G   COMMENT ON COLUMN public.anexo.nr_valor_1 IS 'VALOR 1| VALOR 1 ANEXO';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.nr_valor_2    COMMENT     G   COMMENT ON COLUMN public.anexo.nr_valor_2 IS 'VALOR 2| VALOR 2 ANEXO';
            public       postgres    false    247            ?
           0    0    COLUMN anexo.ds_descricao    COMMENT     d   COMMENT ON COLUMN public.anexo.ds_descricao IS 'DESCRIÇÃO | DESCRIÇÃO ESCOLHIDA PELO USUÁRIO';
            public       postgres    false    247            ?            1259    33633    boletim_medicao    TABLE     ?  CREATE TABLE public.boletim_medicao (
    id_boletim_medicao integer NOT NULL,
    id_intervencao integer NOT NULL,
    cd_boletim_medicao numeric(4,0) NOT NULL,
    data_abertura timestamp without time zone NOT NULL,
    fl_fisica_engenheiro_medicao character(1) NOT NULL,
    nr_cpf_engenheiro_medicao numeric(14,0) NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_fechamento timestamp without time zone,
    fl_fisica_usuario_fechamento character(1),
    nr_cpf_usuario_fechamento numeric(14,0),
    dt_inicio_execucao timestamp without time zone,
    dt_fim_execucao timestamp without time zone,
    ds_observacao character varying(800),
    CONSTRAINT ck_abertura_fechamento_boletim CHECK ((dt_fechamento >= data_abertura)),
    CONSTRAINT ck_boletim_fl_fisica_fecha CHECK ((fl_fisica_usuario_fechamento = 'F'::bpchar)),
    CONSTRAINT ck_boletim_fl_fisica_medicao CHECK ((fl_fisica_engenheiro_medicao = 'F'::bpchar)),
    CONSTRAINT ck_inicio_fim_execucao CHECK ((dt_fim_execucao >= dt_inicio_execucao))
);
 #   DROP TABLE public.boletim_medicao;
       public         postgres    false    6            ?            1259    33688    boletim_medicao_anexo    TABLE     ?  CREATE TABLE public.boletim_medicao_anexo (
    id_boletim_medicao_anexo integer NOT NULL,
    id_boletim_medicao integer NOT NULL,
    id_boletim_medicao_item integer,
    nm_url_arquivo character(100) NOT NULL,
    ds_anexo character(100) NOT NULL,
    dt_inclusao timestamp(6) without time zone,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL
);
 )   DROP TABLE public.boletim_medicao_anexo;
       public         postgres    false    6            ?            1259    33686 2   boletim_medicao_anexo_id_boletim_medicao_anexo_seq    SEQUENCE     ?   CREATE SEQUENCE public.boletim_medicao_anexo_id_boletim_medicao_anexo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 I   DROP SEQUENCE public.boletim_medicao_anexo_id_boletim_medicao_anexo_seq;
       public       postgres    false    6    240            ?
           0    0 2   boletim_medicao_anexo_id_boletim_medicao_anexo_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.boletim_medicao_anexo_id_boletim_medicao_anexo_seq OWNED BY public.boletim_medicao_anexo.id_boletim_medicao_anexo;
            public       postgres    false    239            ?            1259    33660    boletim_medicao_item    TABLE     T  CREATE TABLE public.boletim_medicao_item (
    id_boletim_medicao_item integer NOT NULL,
    id_boletim_medicao integer NOT NULL,
    id_planilha_orcamento integer NOT NULL,
    nm_agrupador_orcamento_item character varying(50) NOT NULL,
    nm_agrupador_orcamento_item2 character varying(50),
    cd_orcamento_item numeric(5,0) NOT NULL,
    id_codigo_produto integer NOT NULL,
    ds_produto character varying(1000) NOT NULL,
    vl_custo_produto numeric(16,2) NOT NULL,
    dt_registro_tabela timestamp without time zone NOT NULL,
    vl_custo_com_bdi numeric(16,2) NOT NULL,
    nr_quantidade numeric(15,3) NOT NULL,
    vl_custo_produto_ajustado numeric(16,2) NOT NULL,
    vl_custo_com_bdi_ajustado numeric(16,2) NOT NULL,
    vl_custo_produto_homologado numeric(16,2) NOT NULL,
    dt_inclusao timestamp without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_alteracao timestamp without time zone,
    fl_fisica_usuario_alteracao character(1),
    nr_cpf_usuario_alteracao numeric(14,0),
    nr_quantidade_medida numeric(15,3) NOT NULL,
    ds_observacao character varying(800),
    CONSTRAINT ck_boletim_it_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_boletin_it_fl_fisi_alt CHECK ((fl_fisica_usuario_alteracao = 'F'::bpchar))
);
 (   DROP TABLE public.boletim_medicao_item;
       public         postgres    false    6            ?
           0    0    TABLE boletim_medicao_item    COMMENT     ?   COMMENT ON TABLE public.boletim_medicao_item IS 'Table Responsável pelo Armazenamento dos Itens dos Boletins de Medição uma intervenção';
            public       postgres    false    238            ?            1259    32903    classificacaointervencao    TABLE     ?   CREATE TABLE public.classificacaointervencao (
    cd_classificacaointervencao integer NOT NULL,
    ds_classificacao_intervencao character varying(15) NOT NULL
);
 ,   DROP TABLE public.classificacaointervencao;
       public         postgres    false    6            ?            1259    32908    classificacaoobra    TABLE     ?   CREATE TABLE public.classificacaoobra (
    cd_classificacao_obra integer NOT NULL,
    ds_classificacao_obra character varying(30) NOT NULL
);
 %   DROP TABLE public.classificacaoobra;
       public         postgres    false    6            ?            1259    33620    cnd_obra    TABLE     ?  CREATE TABLE public.cnd_obra (
    id_cnd_obra integer NOT NULL,
    id_matricula_inss integer NOT NULL,
    nr_cnd_obra numeric(17,0) NOT NULL,
    nr_operacao numeric(3,0) NOT NULL,
    dt_emissao_cnd date NOT NULL,
    dt_validade_cnd date NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    CONSTRAINT ck_cnd_obra_fl_fisica CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
ALTER TABLE ONLY public.cnd_obra ALTER COLUMN id_cnd_obra SET STATISTICS 0;
ALTER TABLE ONLY public.cnd_obra ALTER COLUMN id_matricula_inss SET STATISTICS 0;
ALTER TABLE ONLY public.cnd_obra ALTER COLUMN nr_cnd_obra SET STATISTICS 0;
ALTER TABLE ONLY public.cnd_obra ALTER COLUMN nr_operacao SET STATISTICS 0;
ALTER TABLE ONLY public.cnd_obra ALTER COLUMN dt_emissao_cnd SET STATISTICS 0;
ALTER TABLE ONLY public.cnd_obra ALTER COLUMN dt_validade_cnd SET STATISTICS 0;
ALTER TABLE ONLY public.cnd_obra ALTER COLUMN fl_fisica_usuario_inclusao SET STATISTICS 0;
    DROP TABLE public.cnd_obra;
       public         postgres    true    6            ?
           0    0    TABLE cnd_obra    COMMENT     ?   COMMENT ON TABLE public.cnd_obra IS 'Table Responsável pelo Armazenamento das Certidões Negativas de Débitos junto ao INSS.';
            public       postgres    false    236            ?
           0    0    COLUMN cnd_obra.id_cnd_obra    COMMENT     Z   COMMENT ON COLUMN public.cnd_obra.id_cnd_obra IS 'ID|Identificador da Table Primary Key';
            public       postgres    false    236            ?
           0    0 !   COLUMN cnd_obra.id_matricula_inss    COMMENT     ?   COMMENT ON COLUMN public.cnd_obra.id_matricula_inss IS 'Matrícula INSS|Matrícula do Inss a qual esta CND se refere; Foreing Key oriunda da table public.matricula_inss';
            public       postgres    false    236            ?
           0    0    COLUMN cnd_obra.nr_cnd_obra    COMMENT     w   COMMENT ON COLUMN public.cnd_obra.nr_cnd_obra IS 'Nro. CND|Número da CND de uma respectiva Matrícula junto ao INSS';
            public       postgres    false    236            ?
           0    0    COLUMN cnd_obra.nr_operacao    COMMENT     ?   COMMENT ON COLUMN public.cnd_obra.nr_operacao IS 'Nro.|Número sequencial por Matricula INSS para identificar quantidade de CND´s por Matricula INSS';
            public       postgres    false    236            ?
           0    0    COLUMN cnd_obra.dt_emissao_cnd    COMMENT     ?   COMMENT ON COLUMN public.cnd_obra.dt_emissao_cnd IS 'Data Emissão|Data da emissão da Certidão Negativa de Débito da obra no INSS.';
            public       postgres    false    236            ?
           0    0    COLUMN cnd_obra.dt_validade_cnd    COMMENT     ?   COMMENT ON COLUMN public.cnd_obra.dt_validade_cnd IS 'Data Validade|Data da validade da Certidão Negativa de Débito da obra no INSS.';
            public       postgres    false    236            ?
           0    0 *   COLUMN cnd_obra.fl_fisica_usuario_inclusao    COMMENT     3  COMMENT ON COLUMN public.cnd_obra.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    236            ?
           0    0 '   COLUMN cnd_obra.nr_cpf_usuario_inclusao    COMMENT     &  COMMENT ON COLUMN public.cnd_obra.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    236            ?            1259    33618    cnd_obra_id_cnd_obra_seq    SEQUENCE     ?   CREATE SEQUENCE public.cnd_obra_id_cnd_obra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.cnd_obra_id_cnd_obra_seq;
       public       postgres    false    6    236            ?
           0    0    cnd_obra_id_cnd_obra_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.cnd_obra_id_cnd_obra_seq OWNED BY public.cnd_obra.id_cnd_obra;
            public       postgres    false    235            ?            1259    33586    contrato    TABLE     o  CREATE TABLE public.contrato (
    id_contrato integer NOT NULL,
    id_intervencao integer NOT NULL,
    cd_modalidade_licitacao integer,
    nr_licitacao numeric(3,0),
    nr_ano_licitacao numeric(4,0),
    cd_tipo_contrato integer,
    nr_contrato numeric(3,0) NOT NULL,
    nr_ano_contrato numeric(4,0) NOT NULL,
    ds_objeto character varying(1500) NOT NULL,
    fl_cnpj_fornecedor character(1) NOT NULL,
    nr_cnpj_fornecedor numeric(14,0) NOT NULL,
    dt_contrato timestamp(6) without time zone NOT NULL,
    dt_assinatura_contrato timestamp(6) without time zone NOT NULL,
    dt_publicacao_contrato timestamp(6) without time zone NOT NULL,
    dt_inicio_vigencia timestamp(6) without time zone NOT NULL,
    dt_termino_vigencia timestamp(6) without time zone NOT NULL,
    dt_inicio_execucao timestamp(6) without time zone,
    dt_termino_execucao timestamp(6) without time zone,
    vl_contrato numeric(16,2) NOT NULL,
    vl_contrato_proprio numeric(16,2),
    vl_contrato_estadual numeric(16,2),
    vl_contrato_federal numeric(16,2),
    vl_contrato_operacao numeric(16,2),
    vl_contrato_material numeric(16,2),
    vl_contrato_mao_obra numeric(16,2),
    vl_contrato_equipamento numeric(16,2),
    dt_recisao timestamp(6) without time zone,
    ds_motivo_recisao character varying(250),
    fl_cpf_cnpj_inclusao character(1) NOT NULL,
    nr_cpf_cnpj_inclusao numeric(14,0) NOT NULL,
    dt_inclusao timestamp(6) without time zone NOT NULL,
    CONSTRAINT ck_acompanhamento_fl_fisica_incl CHECK ((fl_cnpj_fornecedor = 'J'::bpchar)),
    CONSTRAINT ck_acompanhamento_fl_fisica_resp CHECK ((fl_cpf_cnpj_inclusao = 'F'::bpchar))
);
    DROP TABLE public.contrato;
       public         postgres    false    6            ?            1259    33584    contrato_id_contrato_seq    SEQUENCE     ?   CREATE SEQUENCE public.contrato_id_contrato_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.contrato_id_contrato_seq;
       public       postgres    false    234    6            ?
           0    0    contrato_id_contrato_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.contrato_id_contrato_seq OWNED BY public.contrato.id_contrato;
            public       postgres    false    233            ?            1259    33573    crea_cau    TABLE       CREATE TABLE public.crea_cau (
    nr_cpf_usuario_responsavel numeric(14,0) NOT NULL,
    id_tipo_doc_pessoa integer NOT NULL,
    ds_nr_crea_cau character varying(15) NOT NULL,
    CONSTRAINT ck_crea_cau_tipo CHECK ((id_tipo_doc_pessoa = ANY (ARRAY[5, 6])))
);
    DROP TABLE public.crea_cau;
       public         postgres    false    6            ?
           0    0    TABLE crea_cau    COMMENT     ?   COMMENT ON TABLE public.crea_cau IS 'Table Responsável pelo armazenamento dos dados Referente CREA(Conselho Regional de Arquitetura e Engenharia) ou CAU(Conselho e Arquitetura e Urbanismo) dos Engenheiros.';
            public       postgres    false    232            ?
           0    0 *   COLUMN crea_cau.nr_cpf_usuario_responsavel    COMMENT     h   COMMENT ON COLUMN public.crea_cau.nr_cpf_usuario_responsavel IS 'Nr. CPF|Número do CPF do Engenheiro';
            public       postgres    false    232            ?
           0    0 "   COLUMN crea_cau.id_tipo_doc_pessoa    COMMENT     ?   COMMENT ON COLUMN public.crea_cau.id_tipo_doc_pessoa IS 'Tipo Documento|Tipo do Documento oriundo da table simam.tipodocumentopessoa sendo somente possíveis 5=CREA ou 6=CAU';
            public       postgres    false    232            ?
           0    0    COLUMN crea_cau.ds_nr_crea_cau    COMMENT     y   COMMENT ON COLUMN public.crea_cau.ds_nr_crea_cau IS 'Nr. Documento|Número do Crea ou do CAu conforme doc selecionado.';
            public       postgres    false    232            ?            1259    33504    diario_obra    TABLE     ?  CREATE TABLE public.diario_obra (
    id_diario_obra integer NOT NULL,
    id_intervencao integer NOT NULL,
    dt_diario_obra date NOT NULL,
    fl_juridida_empreiteira character(1) NOT NULL,
    nr_cnpj_empreiteira numeric(14,0) NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_fechamento timestamp without time zone,
    fl_fisica_usuario_fechamento character(1),
    nr_cpf_usuario_fechamento numeric(14,0),
    CONSTRAINT ck_diario_obra_fl_fisicao CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_diario_obra_fl_juridica CHECK ((fl_juridida_empreiteira = 'J'::bpchar))
);
    DROP TABLE public.diario_obra;
       public         postgres    false    6            ?            1259    33550    diario_obra_anexo    TABLE     ?  CREATE TABLE public.diario_obra_anexo (
    id_diario_obra_anexo integer NOT NULL,
    id_diario_obra_detalhe integer NOT NULL,
    nm_url_arquivo character(100) NOT NULL,
    ds_anexo character(100) NOT NULL,
    dt_inclusao timestamp(6) without time zone,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    CONSTRAINT ck_dia_obra_an_fl_us_inclusao CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
 %   DROP TABLE public.diario_obra_anexo;
       public         postgres    false    6            ?            1259    33548 *   diario_obra_anexo_id_diario_obra_anexo_seq    SEQUENCE     ?   CREATE SEQUENCE public.diario_obra_anexo_id_diario_obra_anexo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public.diario_obra_anexo_id_diario_obra_anexo_seq;
       public       postgres    false    6    230            ?
           0    0 *   diario_obra_anexo_id_diario_obra_anexo_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.diario_obra_anexo_id_diario_obra_anexo_seq OWNED BY public.diario_obra_anexo.id_diario_obra_anexo;
            public       postgres    false    229            ?            1259    33529    diario_obra_detalhe    TABLE     m  CREATE TABLE public.diario_obra_detalhe (
    id_diario_obra_detalhe integer NOT NULL,
    id_diario_obra integer NOT NULL,
    fl_tipo_detalhe character(1) NOT NULL,
    nr_operarios_encarregados numeric(3,0) NOT NULL,
    nr_operarios_profissionais numeric(3,0) NOT NULL,
    nr_operarios_serventes numeric(3,0) NOT NULL,
    fl_tempo_matutino character(1) NOT NULL,
    fl_tempo_vespertino character(1) NOT NULL,
    fl_tempo_noturno character(1),
    ds_anotacoes character varying(2000),
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    CONSTRAINT ck_dia_obra_fl_tempo_mat CHECK ((fl_tempo_matutino = ANY (ARRAY['B'::bpchar, 'C'::bpchar]))),
    CONSTRAINT ck_dia_obra_fl_tempo_notu CHECK ((fl_tempo_noturno = ANY (ARRAY['B'::bpchar, 'C'::bpchar]))),
    CONSTRAINT ck_dia_obra_fl_tempo_vesp CHECK ((fl_tempo_vespertino = ANY (ARRAY['B'::bpchar, 'C'::bpchar]))),
    CONSTRAINT ck_dia_obra_fl_tp_detalhe CHECK ((fl_tipo_detalhe = ANY (ARRAY['E'::bpchar, 'F'::bpchar]))),
    CONSTRAINT ck_dia_obra_fl_us_inclusao CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
 '   DROP TABLE public.diario_obra_detalhe;
       public         postgres    false    6            ?            1259    33527 .   diario_obra_detalhe_id_diario_obra_detalhe_seq    SEQUENCE     ?   CREATE SEQUENCE public.diario_obra_detalhe_id_diario_obra_detalhe_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.diario_obra_detalhe_id_diario_obra_detalhe_seq;
       public       postgres    false    6    228            ?
           0    0 .   diario_obra_detalhe_id_diario_obra_detalhe_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.diario_obra_detalhe_id_diario_obra_detalhe_seq OWNED BY public.diario_obra_detalhe.id_diario_obra_detalhe;
            public       postgres    false    227            ?            1259    33502    diario_obra_id_diario_obra_seq    SEQUENCE     ?   CREATE SEQUENCE public.diario_obra_id_diario_obra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.diario_obra_id_diario_obra_seq;
       public       postgres    false    226    6            ?
           0    0    diario_obra_id_diario_obra_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.diario_obra_id_diario_obra_seq OWNED BY public.diario_obra.id_diario_obra;
            public       postgres    false    225            ?            1259    33078    intervencao    TABLE     ?  CREATE TABLE public.intervencao (
    id_intervencao integer NOT NULL,
    cd_entidade numeric(7,0) NOT NULL,
    cd_intervencao numeric(4,0) NOT NULL,
    nr_ano_intervencao numeric(4,0) NOT NULL,
    id_tipo_intervencao integer NOT NULL,
    id_classificacao_intervencao integer NOT NULL,
    nm_intervencao character varying(100) NOT NULL,
    id_tipo_obra integer NOT NULL,
    id_classificacao_obra integer NOT NULL,
    ds_objeto character(800) NOT NULL,
    nr_medida numeric(8,2) NOT NULL,
    id_unidade_medida_intervencao integer NOT NULL,
    vl_intervencao numeric(16,2) NOT NULL,
    dt_base_valor_intervencao date NOT NULL,
    nr_prazo_execucao numeric(4,0) NOT NULL,
    dt_inicio date NOT NULL,
    id_tipo_regime_intervencao integer NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    id_orcamento integer,
    fl_juridica_empreiteira character(1),
    nr_cnpj_empreiteira numeric(14,0),
    CONSTRAINT ck_intervencao_ano CHECK ((nr_ano_intervencao >= (2013)::numeric)),
    CONSTRAINT ck_intervencao_fl_fisicao CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
    DROP TABLE public.intervencao;
       public         postgres    false    6            ?
           0    0    COLUMN intervencao.cd_entidade    COMMENT     ?   COMMENT ON COLUMN public.intervencao.cd_entidade IS 'Identificador da Pessoa Jurídica junto ao TCE|Representa o código identificador da Entidade atribuído pelo Cadastro Interno do Tribunal de Contas';
            public       postgres    false    201            ?
           0    0 !   COLUMN intervencao.cd_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao.cd_intervencao IS 'Código da Intervenção|Representa o código da Intervenção. Número sequencial.';
            public       postgres    false    201            ?
           0    0 %   COLUMN intervencao.nr_ano_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao.nr_ano_intervencao IS 'Ano da Intervenção|Representa o ano do início da execução da Intervenção.';
            public       postgres    false    201            ?
           0    0 &   COLUMN intervencao.id_tipo_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao.id_tipo_intervencao IS 'Tipo de Intervenção|Tipo da intervenção. Os códigos para preenchimento deste campo encontram-se em tabela (TipoIntervencao).';
            public       postgres    false    201            ?
           0    0 /   COLUMN intervencao.id_classificacao_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao.id_classificacao_intervencao IS 'Classificação do Tipo de Intervenção|Classificação do tipo da intervenção, de acordo com a tabela (ClassificacaoTipoIntervencao).';
            public       postgres    false    201            ?
           0    0 !   COLUMN intervencao.nm_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao.nm_intervencao IS 'Nome da Intervenção|Denominação usual que identifica de forma única a intervenção a ser executada e que traduz o tipo de trabalho a ser realizado.';
            public       postgres    false    201            ?
           0    0    COLUMN intervencao.id_tipo_obra    COMMENT       COMMENT ON COLUMN public.intervencao.id_tipo_obra IS 'Tipo de Obra|Tipo da Obra.  Os códigos para preenchimento deste campo encontram-se em tabela (TipoObra). A regra de  combinação do tipo de obra com a classificação do  tipo de obra é dada pela tabela (AgrupamentoTipoObra).';
            public       postgres    false    201            ?
           0    0 (   COLUMN intervencao.id_classificacao_obra    COMMENT     ,  COMMENT ON COLUMN public.intervencao.id_classificacao_obra IS 'Classificação do Tipo de Obra|Classificação do tipo da obra, de acordo com a tabela (ClassificacaoObra). A regra de  combinação do tipo de obra com a classificação do  tipo de obra é dada pela tabela (TipoXClassificacaoObra).';
            public       postgres    false    201            ?
           0    0    COLUMN intervencao.ds_objeto    COMMENT     ?   COMMENT ON COLUMN public.intervencao.ds_objeto IS 'Objeto|Descrição precisa da intervenção a ser executada incluindo detalhes necessários à compreensão da obra ou serviço de engenharia à que se refere o contrato.';
            public       postgres    false    201            ?
           0    0 0   COLUMN intervencao.id_unidade_medida_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao.id_unidade_medida_intervencao IS 'Unidade de medida|Unidade de medida que melhor caracteriza a intervenção. Os códigos para preenchimento deste campo encontram-se na tabela (TipoUnidadeMedidaIntervencao).';
            public       postgres    false    201            ?
           0    0 !   COLUMN intervencao.vl_intervencao    COMMENT     4  COMMENT ON COLUMN public.intervencao.vl_intervencao IS 'Valor da Intervenção|Valor total da intervenção. Se for contratada toda a execução, deverá ser colocado o valor contratado. Se a intervenção for parcialmente contratada, deve ser o valor orçado para a execução total da intervenção (contrato + valor da execução direta). Se a execução for totalmente direta, deve ser o valor orçado para a execução total da intervenção (apropriação de todos os insumos utilizados – inclusive mão-de-obra - que deve ser feita antes da execução)';
            public       postgres    false    201            ?
           0    0 ,   COLUMN intervencao.dt_base_valor_intervencao    COMMENT     E  COMMENT ON COLUMN public.intervencao.dt_base_valor_intervencao IS 'Data base|Data referente ao valor preenchido no campo ‘Valor Total’. Se for contratada toda a execução, deverá ser informada a data do contrato ou a data base explicitada no mesmo.  Se a intervenção for parcialmente contratada, deverá ser informada a data referente à planilha orçamentária elaborada para a execução total da intervenção. Se a execução for totalmente direta, deverá ser informada a data referente à planilha orçamentária elaborada para a execução total da intervenção.';
            public       postgres    false    201            ?
           0    0 $   COLUMN intervencao.nr_prazo_execucao    COMMENT     	  COMMENT ON COLUMN public.intervencao.nr_prazo_execucao IS 'Prazo de execução (dias)|Prazo previsto para a execução da intervenção em dias. Se for contratada toda a execução, deverá ser informado o prazo previsto em contrato sem considerar os aditivos de prazo. Se a intervenção for parcialmente contratada, deverá ser informado o prazo previsto para a execução total da intervenção. Se a execução for totalmente direta, deverá ser informado o prazo previsto para a execução total da intervenção.';
            public       postgres    false    201            ?
           0    0    COLUMN intervencao.dt_inicio    COMMENT     z   COMMENT ON COLUMN public.intervencao.dt_inicio IS 'Data início|Data de efetivo início da execução da intervenção.';
            public       postgres    false    201            ?
           0    0 -   COLUMN intervencao.id_tipo_regime_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao.id_tipo_regime_intervencao IS 'Regime|Os códigos para preenchimento deste campo encontram-se na tabela Tipos de Regime (TipoRegimeIntervencao).';
            public       postgres    false    201            ?
           0    0 -   COLUMN intervencao.fl_fisica_usuario_inclusao    COMMENT     6  COMMENT ON COLUMN public.intervencao.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    201            ?
           0    0 *   COLUMN intervencao.nr_cpf_usuario_inclusao    COMMENT     )  COMMENT ON COLUMN public.intervencao.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    201            ?            1259    33491    intervencao_acao    TABLE     
  CREATE TABLE public.intervencao_acao (
    id_intervencao_acao integer NOT NULL,
    id_intervencao integer NOT NULL,
    cd_acao numeric(4,0),
    ds_acao character(100)
);
ALTER TABLE ONLY public.intervencao_acao ALTER COLUMN id_intervencao_acao SET STATISTICS 0;
 $   DROP TABLE public.intervencao_acao;
       public         postgres    false    6            ?
           0    0    TABLE intervencao_acao    COMMENT     ?   COMMENT ON TABLE public.intervencao_acao IS 'Table Responsável pelo Armazenamento dos Dados das Intervenções vinculadas com as Ações da Lei do Plano Plurianual – PPA.';
            public       postgres    false    224            ?
           0    0 +   COLUMN intervencao_acao.id_intervencao_acao    COMMENT     k   COMMENT ON COLUMN public.intervencao_acao.id_intervencao_acao IS 'ID|Identificador da Table; Primary Key';
            public       postgres    false    224            ?
           0    0 &   COLUMN intervencao_acao.id_intervencao    COMMENT     ?   COMMENT ON COLUMN public.intervencao_acao.id_intervencao IS 'Intervenção|Intervenção do Respectivo registro; Foreing Key oriunda da table obras_públicas.intervenção';
            public       postgres    false    224            ?            1259    33489 (   intervencao_acao_id_intervencao_acao_seq    SEQUENCE     ?   CREATE SEQUENCE public.intervencao_acao_id_intervencao_acao_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.intervencao_acao_id_intervencao_acao_seq;
       public       postgres    false    6    224            ?
           0    0 (   intervencao_acao_id_intervencao_acao_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.intervencao_acao_id_intervencao_acao_seq OWNED BY public.intervencao_acao.id_intervencao_acao;
            public       postgres    false    223            ?            1259    33432    intervencao_bens    TABLE     ?  CREATE TABLE public.intervencao_bens (
    id_intervencao_bens integer NOT NULL,
    id_intervencao integer NOT NULL,
    id_bem_patrimonial integer,
    cd_bem_patrimonial character varying(10),
    nm_bem_patrimonial character varying(100),
    nr_grau_sul numeric(2,0),
    nr_minuto_sul numeric(2,0),
    nr_segundo_sul numeric(6,4),
    nr_grau_oeste numeric(2,0),
    nr_minuto_oeste numeric(2,0),
    nr_segundo_oeste numeric(6,4),
    nr_numero character varying(9),
    ds_complemento character varying(100),
    ds_ponto_referencia character varying(100),
    dt_registro date,
    nr_matricula_imovel numeric(9,0),
    nm_logradouro character varying(100),
    nm_bairro character varying(50),
    cd_cep numeric(8,0),
    nm_cidade character varying(60),
    fl_fisica_usuario character(1),
    nr_cpf_cnpj_usuario numeric(12,0)
);
ALTER TABLE ONLY public.intervencao_bens ALTER COLUMN id_intervencao_bens SET STATISTICS 0;
ALTER TABLE ONLY public.intervencao_bens ALTER COLUMN id_intervencao SET STATISTICS 0;
 $   DROP TABLE public.intervencao_bens;
       public         postgres    true    6            ?
           0    0    TABLE intervencao_bens    COMMENT        COMMENT ON TABLE public.intervencao_bens IS 'Table responsável pelo armazenamento dos bens relacionados a uma intervenção';
            public       postgres    false    222            ?
           0    0 +   COLUMN intervencao_bens.id_intervencao_bens    COMMENT     \   COMMENT ON COLUMN public.intervencao_bens.id_intervencao_bens IS 'ID|Primary Key da Table';
            public       postgres    false    222            ?
           0    0 &   COLUMN intervencao_bens.id_intervencao    COMMENT     }   COMMENT ON COLUMN public.intervencao_bens.id_intervencao IS 'Intervenção|Foreing KEy oriunda da table public.intervencao';
            public       postgres    false    222            ?
           0    0 *   COLUMN intervencao_bens.id_bem_patrimonial    COMMENT     ?   COMMENT ON COLUMN public.intervencao_bens.id_bem_patrimonial IS 'Bem Patrimonial|id do Bem patrimonial, para SJP oriundo da table patrimonio.bens_patrimoniais';
            public       postgres    false    222            ?            1259    33430 (   intervencao_bens_id_intervencao_bens_seq    SEQUENCE     ?   CREATE SEQUENCE public.intervencao_bens_id_intervencao_bens_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.intervencao_bens_id_intervencao_bens_seq;
       public       postgres    false    222    6            ?
           0    0 (   intervencao_bens_id_intervencao_bens_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.intervencao_bens_id_intervencao_bens_seq OWNED BY public.intervencao_bens.id_intervencao_bens;
            public       postgres    false    221            ?            1259    33983    intervencao_bens_orcam    TABLE     N  CREATE TABLE public.intervencao_bens_orcam (
    id_intervencao_bens_orcam integer NOT NULL,
    id_orcamento integer NOT NULL,
    id_bem_patrimonial integer,
    cd_bem_patrimonial character(10),
    nm_bem_patrimonial character varying(100),
    nr_grau_sul numeric(2,0),
    nr_minuto_sul numeric(2,0),
    nr_segundo_sul numeric(6,4),
    nr_grau_oeste numeric(2,0),
    nr_minuto_oeste numeric(2,0),
    nr_segundo_oeste numeric(6,4),
    nr_numero character varying(9),
    ds_complemento character varying(100),
    ds_ponto_referencia character varying(100),
    dt_registro date,
    nr_matricula_imovel numeric(9,0),
    nm_logradouro character varying(100),
    nm_bairro character varying(50),
    cd_cep numeric(8,0),
    nm_cidade character varying(60),
    fl_fisica_usuario character(1),
    nr_cpf_cnpj_usuario numeric(12,0)
);
 *   DROP TABLE public.intervencao_bens_orcam;
       public         postgres    false    6            ?
           0    0    TABLE intervencao_bens_orcam    COMMENT     ?   COMMENT ON TABLE public.intervencao_bens_orcam IS 'Table responsável pelo armazenamento dos bens relacionados a um orcamento';
            public       postgres    false    251            ?            1259    33981 4   intervencao_bens_orcam_id_intervencao_bens_orcam_seq    SEQUENCE     ?   CREATE SEQUENCE public.intervencao_bens_orcam_id_intervencao_bens_orcam_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 K   DROP SEQUENCE public.intervencao_bens_orcam_id_intervencao_bens_orcam_seq;
       public       postgres    false    6    251            ?
           0    0 4   intervencao_bens_orcam_id_intervencao_bens_orcam_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.intervencao_bens_orcam_id_intervencao_bens_orcam_seq OWNED BY public.intervencao_bens_orcam.id_intervencao_bens_orcam;
            public       postgres    false    250            ?            1259    33398    matricula_inss    TABLE     !  CREATE TABLE public.matricula_inss (
    id_matricula_inss integer NOT NULL,
    id_intervencao integer NOT NULL,
    nr_matricula_cei numeric(12,0) NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_cancelamento date,
    ds_motivo_cancelamento character varying(250),
    fl_fisica_usuario_cancelamento character(1),
    nr_cpf_usuario_cancelamento numeric(14,0),
    dt_inclusao date NOT NULL,
    CONSTRAINT ck_matricula_inss_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_matricula_inss_fll_fisica_canc CHECK ((fl_fisica_usuario_cancelamento = 'F'::bpchar))
);
ALTER TABLE ONLY public.matricula_inss ALTER COLUMN id_matricula_inss SET STATISTICS 0;
ALTER TABLE ONLY public.matricula_inss ALTER COLUMN id_intervencao SET STATISTICS 0;
ALTER TABLE ONLY public.matricula_inss ALTER COLUMN nr_matricula_cei SET STATISTICS 0;
ALTER TABLE ONLY public.matricula_inss ALTER COLUMN fl_fisica_usuario_inclusao SET STATISTICS 0;
ALTER TABLE ONLY public.matricula_inss ALTER COLUMN dt_cancelamento SET STATISTICS 0;
ALTER TABLE ONLY public.matricula_inss ALTER COLUMN ds_motivo_cancelamento SET STATISTICS 0;
ALTER TABLE ONLY public.matricula_inss ALTER COLUMN fl_fisica_usuario_cancelamento SET STATISTICS 0;
 "   DROP TABLE public.matricula_inss;
       public         postgres    true    6            ?
           0    0    TABLE matricula_inss    COMMENT     ?   COMMENT ON TABLE public.matricula_inss IS 'Table Responsável pelo armazenamento das Matriculas de Obras/Intervenções junto ao INSS.';
            public       postgres    false    220            ?
           0    0 '   COLUMN matricula_inss.id_matricula_inss    COMMENT     g   COMMENT ON COLUMN public.matricula_inss.id_matricula_inss IS 'ID|Identificador da Table, Primary Key';
            public       postgres    false    220            ?
           0    0 $   COLUMN matricula_inss.id_intervencao    COMMENT     ?   COMMENT ON COLUMN public.matricula_inss.id_intervencao IS 'Intervenção|ID da Intervenção; Foreing Key oriunda da table public.intervencao';
            public       postgres    false    220            ?
           0    0 &   COLUMN matricula_inss.nr_matricula_cei    COMMENT     v   COMMENT ON COLUMN public.matricula_inss.nr_matricula_cei IS 'Nro. Matrícula|Número da matrícula da obra no INSS.';
            public       postgres    false    220            ?
           0    0 0   COLUMN matricula_inss.fl_fisica_usuario_inclusao    COMMENT     9  COMMENT ON COLUMN public.matricula_inss.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    220            ?
           0    0 -   COLUMN matricula_inss.nr_cpf_usuario_inclusao    COMMENT     ,  COMMENT ON COLUMN public.matricula_inss.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    220            ?
           0    0 %   COLUMN matricula_inss.dt_cancelamento    COMMENT     m   COMMENT ON COLUMN public.matricula_inss.dt_cancelamento IS 'Data Cancelamento|Data do cancelamento da CEI.';
            public       postgres    false    220            ?
           0    0 ,   COLUMN matricula_inss.ds_motivo_cancelamento    COMMENT     v   COMMENT ON COLUMN public.matricula_inss.ds_motivo_cancelamento IS 'Motivo Cancelamento|Motivo da anulação da CEI.';
            public       postgres    false    220            ?
           0    0 4   COLUMN matricula_inss.fl_fisica_usuario_cancelamento    COMMENT     M  COMMENT ON COLUMN public.matricula_inss.fl_fisica_usuario_cancelamento IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o Cancelamento do Cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    220            ?
           0    0 1   COLUMN matricula_inss.nr_cpf_usuario_cancelamento    COMMENT     @  COMMENT ON COLUMN public.matricula_inss.nr_cpf_usuario_cancelamento IS 'Nr. CPF|Número do CPF do Usuário que procedeu o Cancelamento do Cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    220            ?
           0    0 !   COLUMN matricula_inss.dt_inclusao    COMMENT     ?   COMMENT ON COLUMN public.matricula_inss.dt_inclusao IS 'Data Inclusão|Data de Inclusão do Registro deve ser preenchida automaticamente com o sysdate;';
            public       postgres    false    220            ?            1259    33396 $   matricula_inss_id_matricula_inss_seq    SEQUENCE     ?   CREATE SEQUENCE public.matricula_inss_id_matricula_inss_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.matricula_inss_id_matricula_inss_seq;
       public       postgres    false    220    6            ?
           0    0 $   matricula_inss_id_matricula_inss_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.matricula_inss_id_matricula_inss_seq OWNED BY public.matricula_inss.id_matricula_inss;
            public       postgres    false    219            ?            1259    33780    motivoparalisacao    TABLE     ?   CREATE TABLE public.motivoparalisacao (
    cd_motivo_paralisacao integer NOT NULL,
    ds_motivo_paralisacao character varying(90) NOT NULL
);
 %   DROP TABLE public.motivoparalisacao;
       public         postgres    false    6            ?            1259    32940 	   orcamento    TABLE     r  CREATE TABLE public.orcamento (
    id_orcamento integer NOT NULL,
    cd_entidade numeric(7,0) NOT NULL,
    cd_orcamento numeric(4,0) NOT NULL,
    nr_ano_orcamento numeric(4,0) NOT NULL,
    id_tipo_intervencao integer NOT NULL,
    id_classificacao_intervencao integer NOT NULL,
    nm_intervencao character varying(100) NOT NULL,
    id_tipo_obra integer NOT NULL,
    id_classificacao_obra integer NOT NULL,
    ds_objeto character varying(800) NOT NULL,
    nr_medida numeric(8,2) NOT NULL,
    id_unidade_medida_intervencao integer NOT NULL,
    nr_percentual_bdi numeric(5,2) NOT NULL,
    dt_inclusao timestamp(6) without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_fechamento timestamp(6) without time zone,
    fl_fisica_usuario_fechamento character(1),
    nr_cpf_usuario_fechamento numeric(14,0),
    classificacao_sjp character(1) NOT NULL,
    CONSTRAINT ck_orcamento_fl_fisica_alt CHECK ((fl_fisica_usuario_fechamento = 'F'::bpchar)),
    CONSTRAINT ck_orcamento_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
    DROP TABLE public.orcamento;
       public         postgres    false    6            ?            1259    33189    orcamento_item    TABLE     ?  CREATE TABLE public.orcamento_item (
    id_orcamento_item integer NOT NULL,
    id_orcamento integer NOT NULL,
    nm_agrupador_orcamento_item character varying(50) NOT NULL,
    nm_agrupador_orcamento_item2 character varying(50),
    cd_orcamento_item numeric(5,0) NOT NULL,
    id_codigo_produto integer NOT NULL,
    ds_produto character(1000) NOT NULL,
    vl_custo_produto numeric(16,2) NOT NULL,
    dt_registro_tabela timestamp(6) without time zone NOT NULL,
    vl_custo_com_bdi numeric(16,2) NOT NULL,
    nr_quantidade numeric(15,3) NOT NULL,
    vl_custo_produto_ajustado numeric(16,2) NOT NULL,
    vl_custo_com_bdi_ajustado numeric(16,2) NOT NULL,
    dt_inclusao timestamp(6) without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_alteracao timestamp(6) without time zone,
    fl_fisica_usuario_alteracao character(1),
    nr_cpf_usuario_alteracao numeric(14,0),
    CONSTRAINT ck_orcamento_it_fl_fisi_alt CHECK ((fl_fisica_usuario_alteracao = 'F'::bpchar)),
    CONSTRAINT ck_orcamento_it_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
 "   DROP TABLE public.orcamento_item;
       public         postgres    false    6            ?
           0    0    TABLE orcamento_item    COMMENT     ?   COMMENT ON TABLE public.orcamento_item IS 'Table Responsável pelo Armazenamento dos Itens dos Orçamentos de Obras que posteiormente seram vinculados a uma intervenção';
            public       postgres    false    207            ?
           0    0 '   COLUMN orcamento_item.id_orcamento_item    COMMENT     l   COMMENT ON COLUMN public.orcamento_item.id_orcamento_item IS 'ID|Identificador da Tabela, Chave Primária';
            public       postgres    false    207            ?
           0    0 "   COLUMN orcamento_item.id_orcamento    COMMENT     y   COMMENT ON COLUMN public.orcamento_item.id_orcamento IS 'ID Orçamento|Identificador da Tabela Mãe, Chave estrangeira';
            public       postgres    false    207            ?
           0    0 1   COLUMN orcamento_item.nm_agrupador_orcamento_item    COMMENT     w   COMMENT ON COLUMN public.orcamento_item.nm_agrupador_orcamento_item IS 'Agrupador|Nome para Agrupar os Itens Nivel 1';
            public       postgres    false    207            ?
           0    0 2   COLUMN orcamento_item.nm_agrupador_orcamento_item2    COMMENT     z   COMMENT ON COLUMN public.orcamento_item.nm_agrupador_orcamento_item2 IS 'Agrupador2|Nome para Agrupar os Itens Nível 2';
            public       postgres    false    207            ?
           0    0 '   COLUMN orcamento_item.cd_orcamento_item    COMMENT     |   COMMENT ON COLUMN public.orcamento_item.cd_orcamento_item IS 'Nro.|Número Sequencial do Item inserido para um Orçamento';
            public       postgres    false    207            ?
           0    0 '   COLUMN orcamento_item.id_codigo_produto    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.id_codigo_produto IS 'ID Produto|Identificador da Tabela de relacionamento public.produtos_servicos.id_codigo_produto';
            public       postgres    false    207            ?
           0    0     COLUMN orcamento_item.ds_produto    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.ds_produto IS 'Descrição|Sugerir a descrição do produto selecionado public.produtos_servicos.ds_produto';
            public       postgres    false    207            ?
           0    0 &   COLUMN orcamento_item.vl_custo_produto    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.vl_custo_produto IS 'Valor|Salvar aqui o valor oriundo de public.produtos_servicos.vl_custo_total NÃO PERMITIR ALTERAR NÃO MOSTRAR NA TELA';
            public       postgres    false    207            ?
           0    0 (   COLUMN orcamento_item.dt_registro_tabela    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.dt_registro_tabela IS 'Data da Tabela|Salvar aqui o valor oriundo de public.produtos_servicos.dt_alteracao NÃO PERMITOR ALTERAR NÃO MOSTRAR NA TELA';
            public       postgres    false    207            ?
           0    0 &   COLUMN orcamento_item.vl_custo_com_bdi    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.vl_custo_com_bdi IS 'Vl. c/ BDI|Salvar public.produtos_servicos.vl_custo_total *+ public.orcamento.nr_percentual_bdi NÃO PERMITIR ALTERAR NÃO MOSTRAR NA TELA';
            public       postgres    false    207            ?
           0    0 #   COLUMN orcamento_item.nr_quantidade    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.nr_quantidade IS 'Quantidade|Abrir campo para digitar quantidade informada pelo usuário';
            public       postgres    false    207            ?
           0    0 /   COLUMN orcamento_item.vl_custo_produto_ajustado    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.vl_custo_produto_ajustado IS 'Valor|Sugerir o valor oriundo de public.produtos_servicos.vl_custo_total ';
            public       postgres    false    207            ?
           0    0 /   COLUMN orcamento_item.vl_custo_com_bdi_ajustado    COMMENT     ?   COMMENT ON COLUMN public.orcamento_item.vl_custo_com_bdi_ajustado IS 'Vl c/ BDI|Sugerir Salvar public.produtos_servicos.vl_custo_total *+ public.orcamento.nr_percentual_bdi';
            public       postgres    false    207            ?
           0    0 !   COLUMN orcamento_item.dt_inclusao    COMMENT     X   COMMENT ON COLUMN public.orcamento_item.dt_inclusao IS 'Data Inclusão|Salvar Sysdate';
            public       postgres    false    207            ?
           0    0 0   COLUMN orcamento_item.fl_fisica_usuario_inclusao    COMMENT     9  COMMENT ON COLUMN public.orcamento_item.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    207            ?
           0    0 -   COLUMN orcamento_item.nr_cpf_usuario_inclusao    COMMENT     9  COMMENT ON COLUMN public.orcamento_item.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu a inclusão do registro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    207            ?
           0    0 "   COLUMN orcamento_item.dt_alteracao    COMMENT     |   COMMENT ON COLUMN public.orcamento_item.dt_alteracao IS 'Data Alteração|Salvar Sysdate caso registro venha ser alterado';
            public       postgres    false    207            ?
           0    0 1   COLUMN orcamento_item.fl_fisica_usuario_alteracao    COMMENT     >  COMMENT ON COLUMN public.orcamento_item.fl_fisica_usuario_alteracao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu a aletaração, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    207            ?
           0    0 .   COLUMN orcamento_item.nr_cpf_usuario_alteracao    COMMENT     <  COMMENT ON COLUMN public.orcamento_item.nr_cpf_usuario_alteracao IS 'Nr. CPF|Número do CPF do Usuário que procedeu a alteração do registro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    207            ?            1259    33212    ordem_servico    TABLE     ?  CREATE TABLE public.ordem_servico (
    id_ordem_servico integer NOT NULL,
    id_intervencao integer NOT NULL,
    nr_ordem_servico numeric(3,0) NOT NULL,
    nr_ano_ordem_servico numeric(4,0) NOT NULL,
    dt_ordem_servico timestamp without time zone NOT NULL,
    fl_juridica_empreiteira character(1) NOT NULL,
    nr_cnpj_empreiteira numeric(14,0) NOT NULL,
    ds_modalidade character varying(50) NOT NULL,
    nr_licitacao numeric(3,0) NOT NULL,
    nr_ano_licitacao numeric(4,0) NOT NULL,
    nr_contrato numeric(3,0) NOT NULL,
    nr_ano_contrato numeric(4,0) NOT NULL,
    dt_contrato timestamp without time zone NOT NULL,
    vl_contrato numeric(16,2) NOT NULL,
    nr_prazo_dias numeric(4,0) NOT NULL,
    fl_prazo_uteis_corridos character(1) NOT NULL,
    nm_contratante character varying(50) NOT NULL,
    nm_cargo_contratante character varying(50) NOT NULL,
    nm_contratada character varying(50),
    nm_cargo_contratada character varying(50),
    dt_inclusao timestamp without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    CONSTRAINT ck_ord_serv_fl_fisica_usuario_inclusao CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_ord_serv_fl_fl_prazo_uteis_corridos CHECK ((fl_prazo_uteis_corridos = ANY (ARRAY['U'::bpchar, 'C'::bpchar]))),
    CONSTRAINT ck_ord_serv_fl_juridica_empreiteira CHECK ((fl_juridica_empreiteira = 'J'::bpchar))
);
 !   DROP TABLE public.ordem_servico;
       public         postgres    true    6            ?            1259    33210 "   ordem_servico_id_ordem_servico_seq    SEQUENCE     ?   CREATE SEQUENCE public.ordem_servico_id_ordem_servico_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.ordem_servico_id_ordem_servico_seq;
       public       postgres    false    209    6            ?
           0    0 "   ordem_servico_id_ordem_servico_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.ordem_servico_id_ordem_servico_seq OWNED BY public.ordem_servico.id_ordem_servico;
            public       postgres    false    208            ?            1259    33750    origemacompanhamento    TABLE     ?   CREATE TABLE public.origemacompanhamento (
    cd_origem_acompanhamento integer NOT NULL,
    ds_origem_acompanhamento character varying(15) NOT NULL
);
 (   DROP TABLE public.origemacompanhamento;
       public         postgres    false    6            ?            1259    24697    pessoa    TABLE     O  CREATE TABLE public.pessoa (
    fl_fisica_juridica character(1) NOT NULL,
    nr_cpf_cnpj numeric(14,0) NOT NULL,
    nm_pessoa character varying(100) NOT NULL,
    cd_rg_insestadual character varying(30),
    nm_sigla_uf character varying(2),
    nm_municipio character varying(40),
    nm_bairro character varying(50),
    nm_endereco character varying(250),
    nr_endereco numeric(10,0),
    cd_cep numeric(8,0),
    nm_email character varying(100),
    nm_telefone_com character varying(14),
    nm_telefone_cel character varying(14),
    nm_url_foto character varying(255),
    CONSTRAINT ck_pessoa_cpf_cnpj CHECK ((public.fn_cnpj_cpf(
CASE
    WHEN (fl_fisica_juridica = 'F'::bpchar) THEN lpad(((nr_cpf_cnpj)::character varying)::text, 11, '0'::text)
    ELSE lpad(((nr_cpf_cnpj)::character varying)::text, 14, '0'::text)
END) = true))
);
    DROP TABLE public.pessoa;
       public         postgres    true    264    6            ?
           0    0    TABLE pessoa    COMMENT     y   COMMENT ON TABLE public.pessoa IS 'Table responsável pelo armazenamento de toda e qualquer Pessoa (Física/Jurídica)';
            public       postgres    false    185            ?
           0    0     COLUMN pessoa.fl_fisica_juridica    COMMENT     ?   COMMENT ON COLUMN public.pessoa.fl_fisica_juridica IS 'Física/Jurídica|Flag Indicador de Pessoa Física= "F" ou Jurídica="J". Altenar conforme caso.';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nr_cpf_cnpj    COMMENT        COMMENT ON COLUMN public.pessoa.nr_cpf_cnpj IS 'Nro. CPF/CNPJ|Número do Cpf ou Cnpj conforme o caso. Altenar conforme caso.';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_pessoa    COMMENT     ?   COMMENT ON COLUMN public.pessoa.nm_pessoa IS 'Nome/Razão Social|Nome no Caso de Física e Razão Social no caso de Jurídica. Altenar conforme caso.';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.cd_rg_insestadual    COMMENT     ?   COMMENT ON COLUMN public.pessoa.cd_rg_insestadual IS 'Nro. RG/Inscrição Estadual|Número do RG(Registro Geral) se pessoa Física ou Inscrição Estadual se pessoa Jurídica.  Altenar conforme caso.';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_sigla_uf    COMMENT     U   COMMENT ON COLUMN public.pessoa.nm_sigla_uf IS 'UF|Sigla Estado/Unidade Federativa';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_municipio    COMMENT     V   COMMENT ON COLUMN public.pessoa.nm_municipio IS 'Nome Município|Nome do Município';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_bairro    COMMENT     K   COMMENT ON COLUMN public.pessoa.nm_bairro IS 'Nome Bairro|Nome do Bairro';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_endereco    COMMENT     Y   COMMENT ON COLUMN public.pessoa.nm_endereco IS 'Endereço|Nome do Endereço/Logradouro';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nr_endereco    COMMENT     I   COMMENT ON COLUMN public.pessoa.nr_endereco IS 'Nro.|Número Endereço';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.cd_cep    COMMENT     O   COMMENT ON COLUMN public.pessoa.cd_cep IS 'CEP|Número do CEP/Código Postal';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_email    COMMENT     p   COMMENT ON COLUMN public.pessoa.nm_email IS 'e-mail|E-mail completo, preferencialemnte com verificação de @';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_telefone_com    COMMENT     ?   COMMENT ON COLUMN public.pessoa.nm_telefone_com IS 'Telefone Comercial|Número Telefone Comercial. adicionar mascara (99)9999-9999';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_telefone_cel    COMMENT     ?   COMMENT ON COLUMN public.pessoa.nm_telefone_cel IS 'Telefone Celular|Número Telefone Celular. adicionar mascara (99)99999-9999';
            public       postgres    false    185            ?
           0    0    COLUMN pessoa.nm_url_foto    COMMENT     c   COMMENT ON COLUMN public.pessoa.nm_url_foto IS 'URL FOTO| URL do armazenamento da foto da pessoa';
            public       postgres    false    185            ?            1259    33315    planilha_aditivo    TABLE     ?  CREATE TABLE public.planilha_aditivo (
    id_planilha_orcamento integer NOT NULL,
    vl_quantitativo_aditivado numeric(16,10),
    vl_qualitativo_aditivado numeric(16,10),
    dt_prazo_aditivado date,
    nr_prazo_dias_aditivado numeric(16,2),
    vl_quantitativo_supremido numeric(16,10),
    vl_qualitativo_supremido numeric(16,10),
    dt_prazo_supremido date,
    nr_prazo_dias_supremido numeric(16,2)
);
 $   DROP TABLE public.planilha_aditivo;
       public         postgres    false    6            ?
           0    0    TABLE planilha_aditivo    COMMENT     ?   COMMENT ON TABLE public.planilha_aditivo IS 'Table Responsável pelo armazenamento dos Dados Adicionais da Planilhas de Orçamento quando tratando-se de aditivo';
            public       postgres    false    214            ?
           0    0 -   COLUMN planilha_aditivo.id_planilha_orcamento    COMMENT     ?   COMMENT ON COLUMN public.planilha_aditivo.id_planilha_orcamento IS 'ID|Foreing Key oriunda da table obras_públicas.planilha_orçamento e sendo PK nesta tabela para assim garantir um relacionamento de 1 para 1';
            public       postgres    false    214            ?
           0    0 1   COLUMN planilha_aditivo.vl_quantitativo_aditivado    COMMENT     ?   COMMENT ON COLUMN public.planilha_aditivo.vl_quantitativo_aditivado IS 'Valor Quantitativo|Valor Quantitativo (Aumenta/corrige/reajusta quantidade de Itens já presentes na planilha de Orçamento base/contrato)';
            public       postgres    false    214            ?
           0    0 0   COLUMN planilha_aditivo.vl_qualitativo_aditivado    COMMENT     ?   COMMENT ON COLUMN public.planilha_aditivo.vl_qualitativo_aditivado IS 'Valor Qualitativo|Valor Qualitativo (Adiciona novos itens não presentes na planilha de Orçamento base/contrato)';
            public       postgres    false    214            ?
           0    0 *   COLUMN planilha_aditivo.dt_prazo_aditivado    COMMENT     u   COMMENT ON COLUMN public.planilha_aditivo.dt_prazo_aditivado IS 'Data|Prazo (Prorroga Prazo de conclusão da Obra)';
            public       postgres    false    214            ?
           0    0 1   COLUMN planilha_aditivo.vl_quantitativo_supremido    COMMENT     ?   COMMENT ON COLUMN public.planilha_aditivo.vl_quantitativo_supremido IS 'Valor Quantitativo|Valor Quantitativo (diminue/corrige/reajusta quantidade de Itens já presentes na planilha de Orçamento base/contrato)';
            public       postgres    false    214            ?
           0    0 0   COLUMN planilha_aditivo.vl_qualitativo_supremido    COMMENT     ?   COMMENT ON COLUMN public.planilha_aditivo.vl_qualitativo_supremido IS 'Valor Qualitativo|Valor Qualitativo (diminue/corrige/reajusta quantidade de Itens NÃO presentes na planilha de Orçamento base/contrato, que outrora foi adicionado em um aditivo)';
            public       postgres    false    214            ?
           0    0 *   COLUMN planilha_aditivo.dt_prazo_supremido    COMMENT     v   COMMENT ON COLUMN public.planilha_aditivo.dt_prazo_supremido IS 'Data|Prazo (Redução Prazo de conclusão da Obra)';
            public       postgres    false    214            ?            1259    33313 *   planilha_aditivo_id_planilha_orcamento_seq    SEQUENCE     ?   CREATE SEQUENCE public.planilha_aditivo_id_planilha_orcamento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public.planilha_aditivo_id_planilha_orcamento_seq;
       public       postgres    false    214    6            ?
           0    0 *   planilha_aditivo_id_planilha_orcamento_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.planilha_aditivo_id_planilha_orcamento_seq OWNED BY public.planilha_aditivo.id_planilha_orcamento;
            public       postgres    false    213            ?            1259    33352    planilha_execucao    TABLE     "  CREATE TABLE public.planilha_execucao (
    id_planilha_execucao integer NOT NULL,
    id_planilha_orcamento integer NOT NULL,
    nr_contrato numeric(6,0),
    nr_ano_contrato numeric(4,0) NOT NULL,
    id_ato_contratual integer NOT NULL,
    nr_ato_contratual numeric(6,0),
    nr_ano_ato_contratual numeric(4,0),
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    CONSTRAINT ck_planilha_execucao_fl_fisica CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
ALTER TABLE ONLY public.planilha_execucao ALTER COLUMN id_planilha_execucao SET STATISTICS 0;
ALTER TABLE ONLY public.planilha_execucao ALTER COLUMN id_planilha_orcamento SET STATISTICS 0;
ALTER TABLE ONLY public.planilha_execucao ALTER COLUMN id_ato_contratual SET STATISTICS 0;
 %   DROP TABLE public.planilha_execucao;
       public         postgres    false    6            ?
           0    0    TABLE planilha_execucao    COMMENT     ?   COMMENT ON TABLE public.planilha_execucao IS 'Table Responsável pelo armazenamento do execuções indiretas de contratos e aditivos';
            public       postgres    false    217            ?
           0    0 -   COLUMN planilha_execucao.id_planilha_execucao    COMMENT     l   COMMENT ON COLUMN public.planilha_execucao.id_planilha_execucao IS 'ID|Identificador da Table Primary Key';
            public       postgres    false    217            ?
           0    0 .   COLUMN planilha_execucao.id_planilha_orcamento    COMMENT     ?   COMMENT ON COLUMN public.planilha_execucao.id_planilha_orcamento IS 'Orçamento|Foreing Key da Planilha de Orçamento oriunda de public.planilha_orcamento que se está executando.';
            public       postgres    false    217            ?
           0    0 3   COLUMN planilha_execucao.fl_fisica_usuario_inclusao    COMMENT     <  COMMENT ON COLUMN public.planilha_execucao.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    217            ?
           0    0 0   COLUMN planilha_execucao.nr_cpf_usuario_inclusao    COMMENT     /  COMMENT ON COLUMN public.planilha_execucao.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    217            ?            1259    33350 '   planilha_execucao_id_ato_contratual_seq    SEQUENCE     ?   CREATE SEQUENCE public.planilha_execucao_id_ato_contratual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public.planilha_execucao_id_ato_contratual_seq;
       public       postgres    false    6    217            ?
           0    0 '   planilha_execucao_id_ato_contratual_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public.planilha_execucao_id_ato_contratual_seq OWNED BY public.planilha_execucao.id_ato_contratual;
            public       postgres    false    216            ?            1259    33348 *   planilha_execucao_id_planilha_execucao_seq    SEQUENCE     ?   CREATE SEQUENCE public.planilha_execucao_id_planilha_execucao_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public.planilha_execucao_id_planilha_execucao_seq;
       public       postgres    false    6    217                        0    0 *   planilha_execucao_id_planilha_execucao_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.planilha_execucao_id_planilha_execucao_seq OWNED BY public.planilha_execucao.id_planilha_execucao;
            public       postgres    false    215            ?            1259    33294    planilha_orcamento    TABLE       CREATE TABLE public.planilha_orcamento (
    id_planilha_orcamento integer NOT NULL,
    id_intervencao integer NOT NULL,
    fl_fisica_usuario_orcamento character(1) NOT NULL,
    nr_cpf_usuario_orcamento numeric(14,0) NOT NULL,
    id_leiato integer,
    vl_total numeric(16,2) NOT NULL,
    dt_base date NOT NULL,
    id_tipo_planilha_orcamento integer NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    cd_leiato numeric(6,0),
    dt_fechamento timestamp(6) without time zone,
    fl_fisica_usuario_fechamento character(1),
    nr_cpf_usuario_fechamento numeric(14,0),
    CONSTRAINT ck_planilha_orcamento_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_planilha_orcamento_fl_fisica_orcamento CHECK ((fl_fisica_usuario_orcamento = 'F'::bpchar))
);
ALTER TABLE ONLY public.planilha_orcamento ALTER COLUMN id_planilha_orcamento SET STATISTICS 0;
ALTER TABLE ONLY public.planilha_orcamento ALTER COLUMN id_intervencao SET STATISTICS 0;
 &   DROP TABLE public.planilha_orcamento;
       public         postgres    true    6                       0    0    TABLE planilha_orcamento    COMMENT     ?   COMMENT ON TABLE public.planilha_orcamento IS 'Table Responsável pelo armazenamento das Planilhas de Orçamento de uma determinada obra.';
            public       postgres    false    212                       0    0 /   COLUMN planilha_orcamento.id_planilha_orcamento    COMMENT     }   COMMENT ON COLUMN public.planilha_orcamento.id_planilha_orcamento IS 'ID|Identificador da table implementado pela sequence';
            public       postgres    false    212                       0    0 (   COLUMN planilha_orcamento.id_intervencao    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento.id_intervencao IS 'Intervenção|Foreing Key oriunda da table obras_públicas.intervenção';
            public       postgres    false    212                       0    0 5   COLUMN planilha_orcamento.fl_fisica_usuario_orcamento    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento.fl_fisica_usuario_orcamento IS 'CPF|Flag Cpf/Cnpj do Usuário Responsável pelo Orçamento, sempre será F. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    212                       0    0 2   COLUMN planilha_orcamento.nr_cpf_usuario_orcamento    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento.nr_cpf_usuario_orcamento IS 'Nr. CPF|Número do CPF do Usuário reponsável pelo Orçamento. Oriunda da table framework.usuario. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    212                       0    0 #   COLUMN planilha_orcamento.id_leiato    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento.id_leiato IS 'Lei/Ato|Representa o código identificador da lei/ato.  Oriundo da Table atoteca.leiato';
            public       postgres    false    212                       0    0 "   COLUMN planilha_orcamento.vl_total    COMMENT     \   COMMENT ON COLUMN public.planilha_orcamento.vl_total IS 'Valor|Valor total do orçamento.';
            public       postgres    false    212                       0    0 !   COLUMN planilha_orcamento.dt_base    COMMENT     b   COMMENT ON COLUMN public.planilha_orcamento.dt_base IS 'Data|Data de referência do orçamento.';
            public       postgres    false    212            	           0    0 4   COLUMN planilha_orcamento.id_tipo_planilha_orcamento    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento.id_tipo_planilha_orcamento IS 'Tipo Planilha|Tipo de Planilha de Orçamento. Os valores válidos estão na tabela (public.TipoPlanilhaOrcamento).';
            public       postgres    false    212            
           0    0 4   COLUMN planilha_orcamento.fl_fisica_usuario_inclusao    COMMENT     =  COMMENT ON COLUMN public.planilha_orcamento.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    212                       0    0 1   COLUMN planilha_orcamento.nr_cpf_usuario_inclusao    COMMENT     0  COMMENT ON COLUMN public.planilha_orcamento.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    212            ?            1259    33292 ,   planilha_orcamento_id_planilha_orcamento_seq    SEQUENCE     ?   CREATE SEQUENCE public.planilha_orcamento_id_planilha_orcamento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.planilha_orcamento_id_planilha_orcamento_seq;
       public       postgres    false    212    6                       0    0 ,   planilha_orcamento_id_planilha_orcamento_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.planilha_orcamento_id_planilha_orcamento_seq OWNED BY public.planilha_orcamento.id_planilha_orcamento;
            public       postgres    false    211            ?            1259    33370    planilha_orcamento_item    TABLE     	  CREATE TABLE public.planilha_orcamento_item (
    id_planilha_orcamento_item integer NOT NULL,
    id_planilha_orcamento integer NOT NULL,
    nm_agrupador_orcamento_item character varying(50) NOT NULL,
    nm_agrupador_orcamento_item2 character varying(50),
    id_tipo_planilha_orcamento integer NOT NULL,
    cd_orcamento_item numeric(5,0) NOT NULL,
    id_codigo_produto integer NOT NULL,
    ds_produto character varying(1000) NOT NULL,
    vl_custo_produto numeric(16,2) NOT NULL,
    dt_registro_tabela timestamp without time zone NOT NULL,
    vl_custo_com_bdi numeric(16,2) NOT NULL,
    nr_quantidade numeric(15,3) NOT NULL,
    vl_custo_produto_ajustado numeric(16,2) NOT NULL,
    vl_custo_com_bdi_ajustado numeric(16,2) NOT NULL,
    vl_custo_produto_homologado numeric(16,2) NOT NULL,
    dt_inclusao timestamp without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_alteracao timestamp without time zone,
    fl_fisica_usuario_alteracao character(1),
    nr_cpf_usuario_alteracao numeric(14,0),
    CONSTRAINT ck_planilha_it_fl_fisi_alt CHECK ((fl_fisica_usuario_alteracao = 'F'::bpchar)),
    CONSTRAINT ck_planilha_it_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
 +   DROP TABLE public.planilha_orcamento_item;
       public         postgres    false    6                       0    0    TABLE planilha_orcamento_item    COMMENT     ?   COMMENT ON TABLE public.planilha_orcamento_item IS 'Table Responsável pelo Armazenamento dos Itens das PLanilhas de Orçamentos/Contrato e Aditivos de Obras  vinculados a uma intervenção';
            public       postgres    false    218                       0    0 9   COLUMN planilha_orcamento_item.id_planilha_orcamento_item    COMMENT     ~   COMMENT ON COLUMN public.planilha_orcamento_item.id_planilha_orcamento_item IS 'ID|Identificador da Tabela, Chave Primária';
            public       postgres    false    218                       0    0 4   COLUMN planilha_orcamento_item.id_planilha_orcamento    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.id_planilha_orcamento IS 'ID Orçamento|Identificador da Tabela Mãe, Chave estrangeira';
            public       postgres    false    218                       0    0 :   COLUMN planilha_orcamento_item.nm_agrupador_orcamento_item    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.nm_agrupador_orcamento_item IS 'Agrupador|Nome para Agrupar os Itens Nível 1';
            public       postgres    false    218                       0    0 ;   COLUMN planilha_orcamento_item.nm_agrupador_orcamento_item2    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.nm_agrupador_orcamento_item2 IS 'Agrupador|Nome para Agrupar os Itens Nível 2';
            public       postgres    false    218                       0    0 9   COLUMN planilha_orcamento_item.id_tipo_planilha_orcamento    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.id_tipo_planilha_orcamento IS 'Tipo Planilha|Tipo de Planilha de Orçamento. Os valores válidos estão na tabela (public.TipoPlanilhaOrcamento).';
            public       postgres    false    218                       0    0 0   COLUMN planilha_orcamento_item.cd_orcamento_item    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.cd_orcamento_item IS 'Nro.|Número Sequencial do Item inserido para um Orçamento';
            public       postgres    false    218                       0    0 0   COLUMN planilha_orcamento_item.id_codigo_produto    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.id_codigo_produto IS 'ID Produto|Identificador da Tabela de relacionamento public.produtos_servicos.id_codigo_produto';
            public       postgres    false    218                       0    0 )   COLUMN planilha_orcamento_item.ds_produto    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.ds_produto IS 'Descrição|Sugerir a descrição do produto selecionado public.produtos_servicos.ds_produto';
            public       postgres    false    218                       0    0 /   COLUMN planilha_orcamento_item.vl_custo_produto    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.vl_custo_produto IS 'Valor|Salvar aqui o valor oriundo de public.produtos_servicos.vl_custo_total NÃO PERMITIR ALTERAR NÃO MOSTRAR NA TELA';
            public       postgres    false    218                       0    0 1   COLUMN planilha_orcamento_item.dt_registro_tabela    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.dt_registro_tabela IS 'Data da Tabela|Salvar aqui o valor oriundo de public.produtos_servicos.dt_alteracao NÃO PERMITOR ALTERAR NÃO MOSTRAR NA TELA';
            public       postgres    false    218                       0    0 /   COLUMN planilha_orcamento_item.vl_custo_com_bdi    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.vl_custo_com_bdi IS 'Vl. c/ BDI|Salvar public.produtos_servicos.vl_custo_total *+ public.orcamento.nr_percentual_bdi NÃO PERMITIR ALTERAR NÃO MOSTRAR NA TELA';
            public       postgres    false    218                       0    0 ,   COLUMN planilha_orcamento_item.nr_quantidade    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.nr_quantidade IS 'Quantidade|Abrir campo para digitar quantidade informada pelo usuário';
            public       postgres    false    218                       0    0 8   COLUMN planilha_orcamento_item.vl_custo_produto_ajustado    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.vl_custo_produto_ajustado IS 'Valor|Sugerir o valor oriundo de public.produtos_servicos.vl_custo_total ';
            public       postgres    false    218                       0    0 8   COLUMN planilha_orcamento_item.vl_custo_com_bdi_ajustado    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.vl_custo_com_bdi_ajustado IS 'Vl c/ BDI|Sugerir Salvar public.produtos_servicos.vl_custo_total *+ public.orcamento.nr_percentual_bdi';
            public       postgres    false    218                       0    0 :   COLUMN planilha_orcamento_item.vl_custo_produto_homologado    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.vl_custo_produto_homologado IS 'Vl Homologado|Entrada de dados pelo usuário';
            public       postgres    false    218                       0    0 *   COLUMN planilha_orcamento_item.dt_inclusao    COMMENT     a   COMMENT ON COLUMN public.planilha_orcamento_item.dt_inclusao IS 'Data Inclusão|Salvar Sysdate';
            public       postgres    false    218                       0    0 9   COLUMN planilha_orcamento_item.fl_fisica_usuario_inclusao    COMMENT     B  COMMENT ON COLUMN public.planilha_orcamento_item.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    218                       0    0 6   COLUMN planilha_orcamento_item.nr_cpf_usuario_inclusao    COMMENT     B  COMMENT ON COLUMN public.planilha_orcamento_item.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu a inclusão do registro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    218                        0    0 +   COLUMN planilha_orcamento_item.dt_alteracao    COMMENT     ?   COMMENT ON COLUMN public.planilha_orcamento_item.dt_alteracao IS 'Data Alteração|Salvar Sysdate caso registro venha ser alterado';
            public       postgres    false    218            !           0    0 :   COLUMN planilha_orcamento_item.fl_fisica_usuario_alteracao    COMMENT     G  COMMENT ON COLUMN public.planilha_orcamento_item.fl_fisica_usuario_alteracao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu a aletaração, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    218            "           0    0 7   COLUMN planilha_orcamento_item.nr_cpf_usuario_alteracao    COMMENT     E  COMMENT ON COLUMN public.planilha_orcamento_item.nr_cpf_usuario_alteracao IS 'Nr. CPF|Número do CPF do Usuário que procedeu a alteração do registro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    218            ?            1259    33174    produtos_servicos    TABLE     |  CREATE TABLE public.produtos_servicos (
    id_codigo_produto integer NOT NULL,
    nm_codigo_produto character varying(18) NOT NULL,
    ds_produto character(1000) NOT NULL,
    id_unidade_medida integer NOT NULL,
    nm_origem_tabela character(15) NOT NULL,
    vl_custo_total numeric(16,2) NOT NULL,
    nm_sigla_nivel_1 character(10),
    ds_nivel_1 character(1000),
    nm_sigla_nivel_2 character(10),
    ds_nivel_2 character(1000),
    nm_sigla_nivel_3 character(10),
    ds_nivel_3 character(1000),
    ds_origem_preco character(33),
    ds_vinculo character(30),
    dt_inclusao timestamp(6) without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_alteracao timestamp(6) without time zone NOT NULL,
    fl_fisica_usuario_alteracao character(1) NOT NULL,
    nr_cpf_usuario_alteracao numeric(14,0) NOT NULL,
    id_cliente integer,
    nm_uf_estado character(2),
    CONSTRAINT ck_prod_serv_fl_fisica_alt CHECK ((fl_fisica_usuario_alteracao = 'F'::bpchar)),
    CONSTRAINT ck_prod_serv_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
 %   DROP TABLE public.produtos_servicos;
       public         postgres    false    6            #           0    0    TABLE produtos_servicos    COMMENT     ?   COMMENT ON TABLE public.produtos_servicos IS 'Table Responsável pelo Armazenamento dos Produtos e Servições que são utilizadas na elaboração PLanilha Orçamentos Baseado na Tabelas SINAPI/SINCRO2 DENIT/DETRAN/PR';
            public       postgres    false    206            $           0    0 *   COLUMN produtos_servicos.id_codigo_produto    COMMENT     o   COMMENT ON COLUMN public.produtos_servicos.id_codigo_produto IS 'ID|Identificador da Tabela, Chave Primária';
            public       postgres    false    206            %           0    0 *   COLUMN produtos_servicos.nm_codigo_produto    COMMENT     g   COMMENT ON COLUMN public.produtos_servicos.nm_codigo_produto IS 'Código|Código do Produto/Serviço';
            public       postgres    false    206            &           0    0 #   COLUMN produtos_servicos.ds_produto    COMMENT     u   COMMENT ON COLUMN public.produtos_servicos.ds_produto IS 'Descrição|Descrição Detalhada do Produto ou Serviço';
            public       postgres    false    206            '           0    0 *   COLUMN produtos_servicos.id_unidade_medida    COMMENT     h   COMMENT ON COLUMN public.produtos_servicos.id_unidade_medida IS 'Unidade|Unidade de Medida do Produto';
            public       postgres    false    206            (           0    0 )   COLUMN produtos_servicos.nm_origem_tabela    COMMENT     y   COMMENT ON COLUMN public.produtos_servicos.nm_origem_tabela IS 'Origem|Origem da Tabela Ex. Sinapi/Sincro/Denit/Detran';
            public       postgres    false    206            )           0    0 '   COLUMN produtos_servicos.vl_custo_total    COMMENT     l   COMMENT ON COLUMN public.produtos_servicos.vl_custo_total IS 'Valor|Valor Custo Total do Produto/Serviço';
            public       postgres    false    206            *           0    0 )   COLUMN produtos_servicos.nm_sigla_nivel_1    COMMENT     s   COMMENT ON COLUMN public.produtos_servicos.nm_sigla_nivel_1 IS 'CódigoN1|Código do Produto/Serviço a nível 1';
            public       postgres    false    206            +           0    0 #   COLUMN produtos_servicos.ds_nivel_1    COMMENT     u   COMMENT ON COLUMN public.produtos_servicos.ds_nivel_1 IS 'DescriçãoN1|Descrição do Produto/Serviço a nível 1';
            public       postgres    false    206            ,           0    0 )   COLUMN produtos_servicos.nm_sigla_nivel_2    COMMENT     s   COMMENT ON COLUMN public.produtos_servicos.nm_sigla_nivel_2 IS 'CódigoN2|Código do Produto/Serviço a nível 2';
            public       postgres    false    206            -           0    0 #   COLUMN produtos_servicos.ds_nivel_2    COMMENT     u   COMMENT ON COLUMN public.produtos_servicos.ds_nivel_2 IS 'DescriçãoN2|Descrição do Produto/Serviço a nível 2';
            public       postgres    false    206            .           0    0 )   COLUMN produtos_servicos.nm_sigla_nivel_3    COMMENT     s   COMMENT ON COLUMN public.produtos_servicos.nm_sigla_nivel_3 IS 'CódigoN3|Código do Produto/Serviço a nível 3';
            public       postgres    false    206            /           0    0 #   COLUMN produtos_servicos.ds_nivel_3    COMMENT     u   COMMENT ON COLUMN public.produtos_servicos.ds_nivel_3 IS 'DescriçãoN3|Descrição do Produto/Serviço a nível 3';
            public       postgres    false    206            0           0    0 (   COLUMN produtos_servicos.ds_origem_preco    COMMENT     k   COMMENT ON COLUMN public.produtos_servicos.ds_origem_preco IS 'Origem|Origem do Proço atribuido no item';
            public       postgres    false    206            1           0    0 #   COLUMN produtos_servicos.ds_vinculo    COMMENT     x   COMMENT ON COLUMN public.produtos_servicos.ds_vinculo IS 'Vínculo|Vínculação do Item a Orgão Ex. Caixa Economica';
            public       postgres    false    206            2           0    0 $   COLUMN produtos_servicos.dt_inclusao    COMMENT     v   COMMENT ON COLUMN public.produtos_servicos.dt_inclusao IS 'Data Inclusão|Capturar sysdate do momento da inserção';
            public       postgres    false    206            3           0    0 3   COLUMN produtos_servicos.fl_fisica_usuario_inclusao    COMMENT     <  COMMENT ON COLUMN public.produtos_servicos.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    206            4           0    0 0   COLUMN produtos_servicos.nr_cpf_usuario_inclusao    COMMENT     /  COMMENT ON COLUMN public.produtos_servicos.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    206            5           0    0 %   COLUMN produtos_servicos.dt_alteracao    COMMENT     x   COMMENT ON COLUMN public.produtos_servicos.dt_alteracao IS 'Data Inclusão|Capturar sysdate do momento da alteração';
            public       postgres    false    206            6           0    0 4   COLUMN produtos_servicos.fl_fisica_usuario_alteracao    COMMENT     @  COMMENT ON COLUMN public.produtos_servicos.fl_fisica_usuario_alteracao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu a alteração, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    206            7           0    0 1   COLUMN produtos_servicos.nr_cpf_usuario_alteracao    COMMENT     3  COMMENT ON COLUMN public.produtos_servicos.nr_cpf_usuario_alteracao IS 'Nr. CPF|Número do CPF do Usuário que procedeu a alteração. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    206            ?            1259    33164    responsabilidade_contrato    TABLE     ?  CREATE TABLE public.responsabilidade_contrato (
    id_responsabilidade_contrato integer NOT NULL,
    cd_contrato integer NOT NULL,
    nr_ano_contrato integer NOT NULL,
    cd_tipo_responsavel integer NOT NULL,
    fl_cpf_responsavel character(1) NOT NULL,
    nr_cpf_responsavel numeric(14,0) NOT NULL,
    dt_inicio timestamp(6) without time zone NOT NULL,
    dt_fim timestamp(6) without time zone NOT NULL,
    fl_cpf_cnpj_inclusao character(1) NOT NULL,
    nr_cpf_cnpj_inclusao numeric(14,0) NOT NULL,
    dt_inclusao timestamp(6) without time zone NOT NULL,
    CONSTRAINT ck_acompanhamento_fl_fisica_resp CHECK ((fl_cpf_cnpj_inclusao = 'F'::bpchar))
);
 -   DROP TABLE public.responsabilidade_contrato;
       public         postgres    false    6            ?            1259    33162 :   responsabilidade_contrato_id_responsabilidade_contrato_seq    SEQUENCE     ?   CREATE SEQUENCE public.responsabilidade_contrato_id_responsabilidade_contrato_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 Q   DROP SEQUENCE public.responsabilidade_contrato_id_responsabilidade_contrato_seq;
       public       postgres    false    205    6            8           0    0 :   responsabilidade_contrato_id_responsabilidade_contrato_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.responsabilidade_contrato_id_responsabilidade_contrato_seq OWNED BY public.responsabilidade_contrato.id_responsabilidade_contrato;
            public       postgres    false    204            ?            1259    33126    responsabilidade_tecnica    TABLE     ?  CREATE TABLE public.responsabilidade_tecnica (
    id_responsabilidade_tecnica integer NOT NULL,
    id_intervencao integer NOT NULL,
    fl_fisica_responsavel_tecnico character(1) NOT NULL,
    nr_cpf_responsavel_tecnico numeric(14,0) NOT NULL,
    id_tipo_documento_orgao_classe integer NOT NULL,
    nr_documento_orgao_classe numeric(20,0) NOT NULL,
    id_tp_responsabilidade_tecnica integer NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_inclusao date NOT NULL,
    CONSTRAINT ck_responsabilidade_tecnica_fl_fisica_usuario_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_responsabilidade_tecnica_resp_tecnico CHECK ((fl_fisica_responsavel_tecnico = 'F'::bpchar))
);
ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN id_responsabilidade_tecnica SET STATISTICS 0;
ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN id_intervencao SET STATISTICS 0;
ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN fl_fisica_responsavel_tecnico SET STATISTICS 0;
ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN id_tipo_documento_orgao_classe SET STATISTICS 0;
ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN nr_documento_orgao_classe SET STATISTICS 0;
ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN id_tp_responsabilidade_tecnica SET STATISTICS 0;
ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN fl_fisica_usuario_inclusao SET STATISTICS 0;
 ,   DROP TABLE public.responsabilidade_tecnica;
       public         postgres    false    6            9           0    0    TABLE responsabilidade_tecnica    COMMENT     ?   COMMENT ON TABLE public.responsabilidade_tecnica IS 'Table responsável pelo armazenamento dos responsáveis técnicos pelas interveções.';
            public       postgres    false    203            :           0    0 ;   COLUMN responsabilidade_tecnica.id_responsabilidade_tecnica    COMMENT     z   COMMENT ON COLUMN public.responsabilidade_tecnica.id_responsabilidade_tecnica IS 'ID|Identificador da Table Primary Key';
            public       postgres    false    203            ;           0    0 .   COLUMN responsabilidade_tecnica.id_intervencao    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica.id_intervencao IS 'Intervenção|Foreing Key oriunda da Tale public.intervencao';
            public       postgres    false    203            <           0    0 =   COLUMN responsabilidade_tecnica.fl_fisica_responsavel_tecnico    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica.fl_fisica_responsavel_tecnico IS 'CPF|Flag Cpf/Cnpj do Responsável Técnico do cadastro, sempre será F.  No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    203            =           0    0 :   COLUMN responsabilidade_tecnica.nr_cpf_responsavel_tecnico    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica.nr_cpf_responsavel_tecnico IS 'Nr. CPF|Número do CPF do Responsável Técnico.  Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    203            >           0    0 >   COLUMN responsabilidade_tecnica.id_tipo_documento_orgao_classe    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica.id_tipo_documento_orgao_classe IS 'Tipo Documento|Tipo Documento Orgão de Classe, Foreing Key oriundo da table simam.tipodocumentoorgaoclasse';
            public       postgres    false    203            ?           0    0 9   COLUMN responsabilidade_tecnica.nr_documento_orgao_classe    COMMENT        COMMENT ON COLUMN public.responsabilidade_tecnica.nr_documento_orgao_classe IS 'Nr. Documento|Númedo do Documento de Classe';
            public       postgres    false    203            @           0    0 >   COLUMN responsabilidade_tecnica.id_tp_responsabilidade_tecnica    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica.id_tp_responsabilidade_tecnica IS 'Tipo Responsabilidade|Tipo Responsabilidade Técnica Foreing Key oriunda da Table simam.tiporesponsabilidadetecnica';
            public       postgres    false    203            A           0    0 :   COLUMN responsabilidade_tecnica.fl_fisica_usuario_inclusao    COMMENT     C  COMMENT ON COLUMN public.responsabilidade_tecnica.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    203            B           0    0 7   COLUMN responsabilidade_tecnica.nr_cpf_usuario_inclusao    COMMENT     6  COMMENT ON COLUMN public.responsabilidade_tecnica.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    203            C           0    0 +   COLUMN responsabilidade_tecnica.dt_inclusao    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica.dt_inclusao IS 'Data Inclusão|Data de Inclusão do Registro deve ser preenchida automaticamente com o sysdate;';
            public       postgres    false    203            ?            1259    33124 8   responsabilidade_tecnica_id_responsabilidade_tecnica_seq    SEQUENCE     ?   CREATE SEQUENCE public.responsabilidade_tecnica_id_responsabilidade_tecnica_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 O   DROP SEQUENCE public.responsabilidade_tecnica_id_responsabilidade_tecnica_seq;
       public       postgres    false    203    6            D           0    0 8   responsabilidade_tecnica_id_responsabilidade_tecnica_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.responsabilidade_tecnica_id_responsabilidade_tecnica_seq OWNED BY public.responsabilidade_tecnica.id_responsabilidade_tecnica;
            public       postgres    false    202            ?            1259    32975    responsabilidade_tecnica_orcam    TABLE     ?  CREATE TABLE public.responsabilidade_tecnica_orcam (
    id_responsabilidade_tecnica_or integer NOT NULL,
    id_orcamento integer NOT NULL,
    fl_fisica_responsavel_tecnico character(1) NOT NULL,
    nr_cpf_responsavel_tecnico numeric(14,0) NOT NULL,
    id_tipo_documento_orgao_classe integer NOT NULL,
    nr_documento_orgao_classe numeric(20,0),
    id_tp_responsabilidade_tecnica integer NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    dt_inclusao date NOT NULL,
    CONSTRAINT ck_resp_tec_o_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar)),
    CONSTRAINT ck_resp_tec_o_resp_tecnico CHECK ((fl_fisica_responsavel_tecnico = 'F'::bpchar))
);
 2   DROP TABLE public.responsabilidade_tecnica_orcam;
       public         postgres    false    6            E           0    0 $   TABLE responsabilidade_tecnica_orcam    COMMENT     ?   COMMENT ON TABLE public.responsabilidade_tecnica_orcam IS 'Table responsável pelo armazenamento dos responsáveis técnicos pelos orçamentos.';
            public       postgres    false    199            F           0    0 D   COLUMN responsabilidade_tecnica_orcam.id_responsabilidade_tecnica_or    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.id_responsabilidade_tecnica_or IS 'ID|Identificador da Table Primary Key';
            public       postgres    false    199            G           0    0 2   COLUMN responsabilidade_tecnica_orcam.id_orcamento    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.id_orcamento IS 'Intervenção|Foreing Key oriunda da Tale obras_publicas.orcamento';
            public       postgres    false    199            H           0    0 C   COLUMN responsabilidade_tecnica_orcam.fl_fisica_responsavel_tecnico    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.fl_fisica_responsavel_tecnico IS 'CPF|Flag Cpf/Cnpj do Responsável Técnico do cadastro, sempre será F.  No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    199            I           0    0 @   COLUMN responsabilidade_tecnica_orcam.nr_cpf_responsavel_tecnico    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.nr_cpf_responsavel_tecnico IS 'Nr. CPF|Número do CPF do Responsável Técnico.  Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    199            J           0    0 D   COLUMN responsabilidade_tecnica_orcam.id_tipo_documento_orgao_classe    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.id_tipo_documento_orgao_classe IS 'Tipo Documento|Tipo Documento Orgão de Classe, Foreing Key oriundo da table simam.tipodocumentoorgaoclasse';
            public       postgres    false    199            K           0    0 ?   COLUMN responsabilidade_tecnica_orcam.nr_documento_orgao_classe    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.nr_documento_orgao_classe IS 'Nr. Documento|Númedo do Documento de Classe';
            public       postgres    false    199            L           0    0 D   COLUMN responsabilidade_tecnica_orcam.id_tp_responsabilidade_tecnica    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.id_tp_responsabilidade_tecnica IS 'Tipo Responsabilidade|Tipo Responsabilidade Técnica Foreing Key oriunda da Table simam.tiporesponsabilidadetecnica';
            public       postgres    false    199            M           0    0 @   COLUMN responsabilidade_tecnica_orcam.fl_fisica_usuario_inclusao    COMMENT     I  COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.fl_fisica_usuario_inclusao IS 'CPF|Flag Cpf/Cnpj do Usuário que procedeu o cadastro, sempre será F. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. No Caso de SJP a mesma tambem será movido "F" fixo.';
            public       postgres    false    199            N           0    0 =   COLUMN responsabilidade_tecnica_orcam.nr_cpf_usuario_inclusao    COMMENT     <  COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.nr_cpf_usuario_inclusao IS 'Nr. CPF|Número do CPF do Usuário que procedeu o cadastro. Oriunda da table framework.usuario e deverá ser preenchido automaticamente, baseado no usuário logado no sistema. Para SJP o CPF será oriundo de admin.usuario.usucpf.';
            public       postgres    false    199            O           0    0 1   COLUMN responsabilidade_tecnica_orcam.dt_inclusao    COMMENT     ?   COMMENT ON COLUMN public.responsabilidade_tecnica_orcam.dt_inclusao IS 'Data Inclusão|Data de Inclusão do Registro deve ser preenchida automaticamente com o sysdate;';
            public       postgres    false    199            ?            1259    32869 
   tipo_anexo    TABLE     ?  CREATE TABLE public.tipo_anexo (
    id_tipo_anexo integer NOT NULL,
    cd_tipo_anexo integer NOT NULL,
    ds_tipo_anexo character varying(50) NOT NULL,
    id_cliente integer NOT NULL,
    dt_inclusao timestamp(6) without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    ds_caption_data_1 character varying(15),
    ds_caption_data_2 character varying(15),
    ds_caption_data_3 character varying(15),
    ds_caption_valor_1 character varying(15),
    ds_caption_valor_2 character varying(15),
    ds_caption_descricao character varying(15),
    dt_desativacao timestamp(6) without time zone,
    fl_fisica_usuario_desativacao character(1),
    nr_cpf_usuario_desativacao numeric(14,0),
    ds_caption_valor_3 character varying(15),
    CONSTRAINT ck_tipo_anexo_fl_fisica_incl CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
    DROP TABLE public.tipo_anexo;
       public         postgres    false    6            P           0    0    TABLE tipo_anexo    COMMENT     ?   COMMENT ON TABLE public.tipo_anexo IS 'Table Responsável pelo armazenamento dos dados cadastrais dos tipo de anexos que podem ser anexados pelo sistema de obras públicas.';
            public       postgres    false    189            Q           0    0    COLUMN tipo_anexo.id_tipo_anexo    COMMENT     `   COMMENT ON COLUMN public.tipo_anexo.id_tipo_anexo IS 'ID| IDENTIFICADOR DA TABELA  TIPO_ANEXO';
            public       postgres    false    189            R           0    0    COLUMN tipo_anexo.cd_tipo_anexo    COMMENT     Z   COMMENT ON COLUMN public.tipo_anexo.cd_tipo_anexo IS 'CÓDIGO| CÓDIGO DA INTERVENÇÃO';
            public       postgres    false    189            S           0    0    COLUMN tipo_anexo.ds_tipo_anexo    COMMENT     c   COMMENT ON COLUMN public.tipo_anexo.ds_tipo_anexo IS 'DESCRIÇÃO | DESCRIÇÃO DO TIPO DO ANEXO';
            public       postgres    false    189            T           0    0    COLUMN tipo_anexo.id_cliente    COMMENT     X   COMMENT ON COLUMN public.tipo_anexo.id_cliente IS 'CLIENTE | IDENTIFICADOR DO CLIENTE';
            public       postgres    false    189            U           0    0    COLUMN tipo_anexo.dt_inclusao    COMMENT     Y   COMMENT ON COLUMN public.tipo_anexo.dt_inclusao IS 'DATA INCLUSÃO | DATA DA INCLUSÃO';
            public       postgres    false    189            V           0    0 ,   COLUMN tipo_anexo.fl_fisica_usuario_inclusao    COMMENT     ?   COMMENT ON COLUMN public.tipo_anexo.fl_fisica_usuario_inclusao IS 'TIPO DA PESSOA| FLAG INDICATIVA DO TIPO D APESSOA QUE CADASTROU O REGISTRO ';
            public       postgres    false    189            W           0    0 )   COLUMN tipo_anexo.nr_cpf_usuario_inclusao    COMMENT     |   COMMENT ON COLUMN public.tipo_anexo.nr_cpf_usuario_inclusao IS 'DOCUMENTO | DOCUMENTO DA PESSOA QUE CADASTROU O REGISTRO ';
            public       postgres    false    189            X           0    0 #   COLUMN tipo_anexo.ds_caption_data_1    COMMENT     W   COMMENT ON COLUMN public.tipo_anexo.ds_caption_data_1 IS 'CAPTION 1 | CAPTION DATA 1';
            public       postgres    false    189            Y           0    0 #   COLUMN tipo_anexo.ds_caption_data_2    COMMENT     W   COMMENT ON COLUMN public.tipo_anexo.ds_caption_data_2 IS 'CAPTION 2 | CAPTION DATA 2';
            public       postgres    false    189            Z           0    0 #   COLUMN tipo_anexo.ds_caption_data_3    COMMENT     W   COMMENT ON COLUMN public.tipo_anexo.ds_caption_data_3 IS 'CAPTION 3 | CAPTION DATA 3';
            public       postgres    false    189            [           0    0 $   COLUMN tipo_anexo.ds_caption_valor_1    COMMENT     `   COMMENT ON COLUMN public.tipo_anexo.ds_caption_valor_1 IS 'CAPTION VALOR 1 | CAPTION VALOR  1';
            public       postgres    false    189            \           0    0 $   COLUMN tipo_anexo.ds_caption_valor_2    COMMENT     `   COMMENT ON COLUMN public.tipo_anexo.ds_caption_valor_2 IS 'CAPTION VALOR 2 | CAPTION VALOR  2';
            public       postgres    false    189            ]           0    0 &   COLUMN tipo_anexo.ds_caption_descricao    COMMENT     r   COMMENT ON COLUMN public.tipo_anexo.ds_caption_descricao IS 'DESCRIÇÃO |  DESCRIÇÃO ESCOLHIDA PELO USUÁRIO';
            public       postgres    false    189            ?            1259    32867    tipo_anexo_id_tipo_anexo_seq    SEQUENCE     ?   CREATE SEQUENCE public.tipo_anexo_id_tipo_anexo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.tipo_anexo_id_tipo_anexo_seq;
       public       postgres    false    189    6            ^           0    0    tipo_anexo_id_tipo_anexo_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.tipo_anexo_id_tipo_anexo_seq OWNED BY public.tipo_anexo.id_tipo_anexo;
            public       postgres    false    188            ?            1259    32883    tipo_anexo_menu    TABLE     ?   CREATE TABLE public.tipo_anexo_menu (
    id_cliente integer NOT NULL,
    id_menu integer NOT NULL,
    id_tipo_anexo integer NOT NULL
);
 #   DROP TABLE public.tipo_anexo_menu;
       public         postgres    false    6            ?            1259    33855    tipoacompanhamento    TABLE     ?   CREATE TABLE public.tipoacompanhamento (
    cd_tipo_acompanhamento integer NOT NULL,
    ds_tipo_acompanhamento character varying(30) NOT NULL
);
 &   DROP TABLE public.tipoacompanhamento;
       public         postgres    false    6            ?            1259    32893    tipodocumentoorgaoclasse    TABLE     ?   CREATE TABLE public.tipodocumentoorgaoclasse (
    cd_tipo_documento_orgao_classe integer NOT NULL,
    ds_tipo_documento_orgao_classe character varying(10) NOT NULL
);
 ,   DROP TABLE public.tipodocumentoorgaoclasse;
       public         postgres    false    6            ?            1259    33568    tipodocumentopessoa    TABLE       CREATE TABLE public.tipodocumentopessoa (
    cd_tipo_doc_pessoa integer NOT NULL,
    ds_tipo_doc_pessoa character varying(4) NOT NULL,
    ds_tipo_documento character varying(50) NOT NULL,
    fl_exige_uf character(1) NOT NULL,
    fl_exige_validade character(1) NOT NULL
);
 '   DROP TABLE public.tipodocumentopessoa;
       public         postgres    false    6            ?            1259    32913    tipointervencao    TABLE     ?   CREATE TABLE public.tipointervencao (
    cd_tipo_intervencao integer NOT NULL,
    ds_tipo_intervencao character varying(30) NOT NULL
);
 #   DROP TABLE public.tipointervencao;
       public         postgres    false    6            ?            1259    33815    tipomedicao    TABLE     ~   CREATE TABLE public.tipomedicao (
    cd_tipo_medicao integer NOT NULL,
    ds_tipo_medicao character varying(30) NOT NULL
);
    DROP TABLE public.tipomedicao;
       public         postgres    false    6            ?            1259    32918    tipoobra    TABLE     u   CREATE TABLE public.tipoobra (
    cd_tipo_obra integer NOT NULL,
    ds_tipo_obra character varying(20) NOT NULL
);
    DROP TABLE public.tipoobra;
       public         postgres    false    6            ?            1259    33265    tipoplanilhaorcamento    TABLE     ?   CREATE TABLE public.tipoplanilhaorcamento (
    cd_tipo_planilha_orcamento integer NOT NULL,
    ds_tipo_planilha_orcamento character varying(10) NOT NULL
);
 )   DROP TABLE public.tipoplanilhaorcamento;
       public         postgres    false    6            ?            1259    33073    tiporegimeintervencao    TABLE     ?   CREATE TABLE public.tiporegimeintervencao (
    cd_tipo_regime_intervencao integer NOT NULL,
    ds_tipo_regime_intervencao character varying(25) NOT NULL
);
 )   DROP TABLE public.tiporegimeintervencao;
       public         postgres    false    6            ?            1259    32898    tiporesponsabilidadetecnica    TABLE     ?   CREATE TABLE public.tiporesponsabilidadetecnica (
    cd_tp_responsabilidade_tecnica integer NOT NULL,
    ds_tp_responsabilidade_tecnica character varying(25) NOT NULL
);
 /   DROP TABLE public.tiporesponsabilidadetecnica;
       public         postgres    false    6            ?            1259    32923    tipounidademedidaintervencao    TABLE     ?   CREATE TABLE public.tipounidademedidaintervencao (
    cd_tp_unidade_medida_inter integer NOT NULL,
    ds_tp_unidade_medida_inter character varying(20) NOT NULL,
    ds_sigla character(2) NOT NULL
);
 0   DROP TABLE public.tipounidademedidaintervencao;
       public         postgres    false    6            ?            1259    32846    unidade_medida    TABLE     ?  CREATE TABLE public.unidade_medida (
    id_unidade_medida integer NOT NULL,
    cd_sigla character varying(5) NOT NULL,
    ds_unidade_medida character varying(30) NOT NULL,
    dt_inclusao timestamp(6) without time zone NOT NULL,
    fl_fisica_usuario_inclusao character(1) NOT NULL,
    nr_cpf_usuario_inclusao numeric(14,0) NOT NULL,
    CONSTRAINT ck_unidade_medida_fl_fisica CHECK ((fl_fisica_usuario_inclusao = 'F'::bpchar))
);
 "   DROP TABLE public.unidade_medida;
       public         postgres    false    6            ?            1259    32844 $   unidade_medida_id_unidade_medida_seq    SEQUENCE     ?   CREATE SEQUENCE public.unidade_medida_id_unidade_medida_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.unidade_medida_id_unidade_medida_seq;
       public       postgres    false    187    6            _           0    0 $   unidade_medida_id_unidade_medida_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.unidade_medida_id_unidade_medida_seq OWNED BY public.unidade_medida.id_unidade_medida;
            public       postgres    false    186            ?           2604    33865     acompanhamento id_acompanhamento    DEFAULT     ?   ALTER TABLE ONLY public.acompanhamento ALTER COLUMN id_acompanhamento SET DEFAULT nextval('public.acompanhamento_id_acompanhamento_seq'::regclass);
 O   ALTER TABLE public.acompanhamento ALTER COLUMN id_acompanhamento DROP DEFAULT;
       public       postgres    false    246    245    246            ?           2604    33968 "   aditivo_contrato id_ato_contratual    DEFAULT     ?   ALTER TABLE ONLY public.aditivo_contrato ALTER COLUMN id_ato_contratual SET DEFAULT nextval('public.aditivo_contrato_id_ato_contratual_seq'::regclass);
 Q   ALTER TABLE public.aditivo_contrato ALTER COLUMN id_ato_contratual DROP DEFAULT;
       public       postgres    false    249    248    249            ?           2604    33691 .   boletim_medicao_anexo id_boletim_medicao_anexo    DEFAULT     ?   ALTER TABLE ONLY public.boletim_medicao_anexo ALTER COLUMN id_boletim_medicao_anexo SET DEFAULT nextval('public.boletim_medicao_anexo_id_boletim_medicao_anexo_seq'::regclass);
 ]   ALTER TABLE public.boletim_medicao_anexo ALTER COLUMN id_boletim_medicao_anexo DROP DEFAULT;
       public       postgres    false    240    239    240            ?           2604    33623    cnd_obra id_cnd_obra    DEFAULT     |   ALTER TABLE ONLY public.cnd_obra ALTER COLUMN id_cnd_obra SET DEFAULT nextval('public.cnd_obra_id_cnd_obra_seq'::regclass);
 C   ALTER TABLE public.cnd_obra ALTER COLUMN id_cnd_obra DROP DEFAULT;
       public       postgres    false    236    235    236            ?           2604    33589    contrato id_contrato    DEFAULT     |   ALTER TABLE ONLY public.contrato ALTER COLUMN id_contrato SET DEFAULT nextval('public.contrato_id_contrato_seq'::regclass);
 C   ALTER TABLE public.contrato ALTER COLUMN id_contrato DROP DEFAULT;
       public       postgres    false    234    233    234            ?           2604    33507    diario_obra id_diario_obra    DEFAULT     ?   ALTER TABLE ONLY public.diario_obra ALTER COLUMN id_diario_obra SET DEFAULT nextval('public.diario_obra_id_diario_obra_seq'::regclass);
 I   ALTER TABLE public.diario_obra ALTER COLUMN id_diario_obra DROP DEFAULT;
       public       postgres    false    225    226    226            ?           2604    33553 &   diario_obra_anexo id_diario_obra_anexo    DEFAULT     ?   ALTER TABLE ONLY public.diario_obra_anexo ALTER COLUMN id_diario_obra_anexo SET DEFAULT nextval('public.diario_obra_anexo_id_diario_obra_anexo_seq'::regclass);
 U   ALTER TABLE public.diario_obra_anexo ALTER COLUMN id_diario_obra_anexo DROP DEFAULT;
       public       postgres    false    230    229    230            ?           2604    33532 *   diario_obra_detalhe id_diario_obra_detalhe    DEFAULT     ?   ALTER TABLE ONLY public.diario_obra_detalhe ALTER COLUMN id_diario_obra_detalhe SET DEFAULT nextval('public.diario_obra_detalhe_id_diario_obra_detalhe_seq'::regclass);
 Y   ALTER TABLE public.diario_obra_detalhe ALTER COLUMN id_diario_obra_detalhe DROP DEFAULT;
       public       postgres    false    228    227    228            ?           2604    33494 $   intervencao_acao id_intervencao_acao    DEFAULT     ?   ALTER TABLE ONLY public.intervencao_acao ALTER COLUMN id_intervencao_acao SET DEFAULT nextval('public.intervencao_acao_id_intervencao_acao_seq'::regclass);
 S   ALTER TABLE public.intervencao_acao ALTER COLUMN id_intervencao_acao DROP DEFAULT;
       public       postgres    false    223    224    224            ?           2604    33435 $   intervencao_bens id_intervencao_bens    DEFAULT     ?   ALTER TABLE ONLY public.intervencao_bens ALTER COLUMN id_intervencao_bens SET DEFAULT nextval('public.intervencao_bens_id_intervencao_bens_seq'::regclass);
 S   ALTER TABLE public.intervencao_bens ALTER COLUMN id_intervencao_bens DROP DEFAULT;
       public       postgres    false    222    221    222            ?           2604    33986 0   intervencao_bens_orcam id_intervencao_bens_orcam    DEFAULT     ?   ALTER TABLE ONLY public.intervencao_bens_orcam ALTER COLUMN id_intervencao_bens_orcam SET DEFAULT nextval('public.intervencao_bens_orcam_id_intervencao_bens_orcam_seq'::regclass);
 _   ALTER TABLE public.intervencao_bens_orcam ALTER COLUMN id_intervencao_bens_orcam DROP DEFAULT;
       public       postgres    false    250    251    251            ?           2604    33401     matricula_inss id_matricula_inss    DEFAULT     ?   ALTER TABLE ONLY public.matricula_inss ALTER COLUMN id_matricula_inss SET DEFAULT nextval('public.matricula_inss_id_matricula_inss_seq'::regclass);
 O   ALTER TABLE public.matricula_inss ALTER COLUMN id_matricula_inss DROP DEFAULT;
       public       postgres    false    220    219    220            ?           2604    33215    ordem_servico id_ordem_servico    DEFAULT     ?   ALTER TABLE ONLY public.ordem_servico ALTER COLUMN id_ordem_servico SET DEFAULT nextval('public.ordem_servico_id_ordem_servico_seq'::regclass);
 M   ALTER TABLE public.ordem_servico ALTER COLUMN id_ordem_servico DROP DEFAULT;
       public       postgres    false    208    209    209            ?           2604    33318 &   planilha_aditivo id_planilha_orcamento    DEFAULT     ?   ALTER TABLE ONLY public.planilha_aditivo ALTER COLUMN id_planilha_orcamento SET DEFAULT nextval('public.planilha_aditivo_id_planilha_orcamento_seq'::regclass);
 U   ALTER TABLE public.planilha_aditivo ALTER COLUMN id_planilha_orcamento DROP DEFAULT;
       public       postgres    false    214    213    214            ?           2604    33355 &   planilha_execucao id_planilha_execucao    DEFAULT     ?   ALTER TABLE ONLY public.planilha_execucao ALTER COLUMN id_planilha_execucao SET DEFAULT nextval('public.planilha_execucao_id_planilha_execucao_seq'::regclass);
 U   ALTER TABLE public.planilha_execucao ALTER COLUMN id_planilha_execucao DROP DEFAULT;
       public       postgres    false    217    215    217            ?           2604    33356 #   planilha_execucao id_ato_contratual    DEFAULT     ?   ALTER TABLE ONLY public.planilha_execucao ALTER COLUMN id_ato_contratual SET DEFAULT nextval('public.planilha_execucao_id_ato_contratual_seq'::regclass);
 R   ALTER TABLE public.planilha_execucao ALTER COLUMN id_ato_contratual DROP DEFAULT;
       public       postgres    false    217    216    217            ?           2604    33297 (   planilha_orcamento id_planilha_orcamento    DEFAULT     ?   ALTER TABLE ONLY public.planilha_orcamento ALTER COLUMN id_planilha_orcamento SET DEFAULT nextval('public.planilha_orcamento_id_planilha_orcamento_seq'::regclass);
 W   ALTER TABLE public.planilha_orcamento ALTER COLUMN id_planilha_orcamento DROP DEFAULT;
       public       postgres    false    211    212    212            ?           2604    33167 6   responsabilidade_contrato id_responsabilidade_contrato    DEFAULT     ?   ALTER TABLE ONLY public.responsabilidade_contrato ALTER COLUMN id_responsabilidade_contrato SET DEFAULT nextval('public.responsabilidade_contrato_id_responsabilidade_contrato_seq'::regclass);
 e   ALTER TABLE public.responsabilidade_contrato ALTER COLUMN id_responsabilidade_contrato DROP DEFAULT;
       public       postgres    false    204    205    205            ?           2604    33129 4   responsabilidade_tecnica id_responsabilidade_tecnica    DEFAULT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica ALTER COLUMN id_responsabilidade_tecnica SET DEFAULT nextval('public.responsabilidade_tecnica_id_responsabilidade_tecnica_seq'::regclass);
 c   ALTER TABLE public.responsabilidade_tecnica ALTER COLUMN id_responsabilidade_tecnica DROP DEFAULT;
       public       postgres    false    202    203    203            ?           2604    32872    tipo_anexo id_tipo_anexo    DEFAULT     ?   ALTER TABLE ONLY public.tipo_anexo ALTER COLUMN id_tipo_anexo SET DEFAULT nextval('public.tipo_anexo_id_tipo_anexo_seq'::regclass);
 G   ALTER TABLE public.tipo_anexo ALTER COLUMN id_tipo_anexo DROP DEFAULT;
       public       postgres    false    188    189    189            ?           2604    32849     unidade_medida id_unidade_medida    DEFAULT     ?   ALTER TABLE ONLY public.unidade_medida ALTER COLUMN id_unidade_medida SET DEFAULT nextval('public.unidade_medida_id_unidade_medida_seq'::regclass);
 O   ALTER TABLE public.unidade_medida ALTER COLUMN id_unidade_medida DROP DEFAULT;
       public       postgres    false    187    186    187            _
          0    33862    acompanhamento 
   TABLE DATA                     public       postgres    false    246   g%      `           0    0 $   acompanhamento_id_acompanhamento_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.acompanhamento_id_acompanhamento_seq', 1, false);
            public       postgres    false    245            b
          0    33965    aditivo_contrato 
   TABLE DATA                     public       postgres    false    249   ?%      a           0    0 &   aditivo_contrato_id_ato_contratual_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.aditivo_contrato_id_ato_contratual_seq', 1, false);
            public       postgres    false    248            `
          0    33901    anexo 
   TABLE DATA                     public       postgres    false    247   ?%      V
          0    33633    boletim_medicao 
   TABLE DATA                     public       postgres    false    237   ?%      Y
          0    33688    boletim_medicao_anexo 
   TABLE DATA                     public       postgres    false    240   ?%      b           0    0 2   boletim_medicao_anexo_id_boletim_medicao_anexo_seq    SEQUENCE SET     a   SELECT pg_catalog.setval('public.boletim_medicao_anexo_id_boletim_medicao_anexo_seq', 1, false);
            public       postgres    false    239            W
          0    33660    boletim_medicao_item 
   TABLE DATA                     public       postgres    false    238   ?%      *
          0    32903    classificacaointervencao 
   TABLE DATA                     public       postgres    false    193   &      +
          0    32908    classificacaoobra 
   TABLE DATA                     public       postgres    false    194   &      U
          0    33620    cnd_obra 
   TABLE DATA                     public       postgres    false    236   7&      c           0    0    cnd_obra_id_cnd_obra_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.cnd_obra_id_cnd_obra_seq', 1, false);
            public       postgres    false    235            S
          0    33586    contrato 
   TABLE DATA                     public       postgres    false    234   Q&      d           0    0    contrato_id_contrato_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.contrato_id_contrato_seq', 1, false);
            public       postgres    false    233            Q
          0    33573    crea_cau 
   TABLE DATA                     public       postgres    false    232   k&      K
          0    33504    diario_obra 
   TABLE DATA                     public       postgres    false    226   ?&      O
          0    33550    diario_obra_anexo 
   TABLE DATA                     public       postgres    false    230   ?&      e           0    0 *   diario_obra_anexo_id_diario_obra_anexo_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public.diario_obra_anexo_id_diario_obra_anexo_seq', 1, false);
            public       postgres    false    229            M
          0    33529    diario_obra_detalhe 
   TABLE DATA                     public       postgres    false    228   ?&      f           0    0 .   diario_obra_detalhe_id_diario_obra_detalhe_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public.diario_obra_detalhe_id_diario_obra_detalhe_seq', 1, false);
            public       postgres    false    227            g           0    0    diario_obra_id_diario_obra_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.diario_obra_id_diario_obra_seq', 1, false);
            public       postgres    false    225            2
          0    33078    intervencao 
   TABLE DATA                     public       postgres    false    201   ?&      I
          0    33491    intervencao_acao 
   TABLE DATA                     public       postgres    false    224   ?&      h           0    0 (   intervencao_acao_id_intervencao_acao_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.intervencao_acao_id_intervencao_acao_seq', 1, false);
            public       postgres    false    223            G
          0    33432    intervencao_bens 
   TABLE DATA                     public       postgres    false    222   '      i           0    0 (   intervencao_bens_id_intervencao_bens_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.intervencao_bens_id_intervencao_bens_seq', 1, false);
            public       postgres    false    221            d
          0    33983    intervencao_bens_orcam 
   TABLE DATA                     public       postgres    false    251   !'      j           0    0 4   intervencao_bens_orcam_id_intervencao_bens_orcam_seq    SEQUENCE SET     c   SELECT pg_catalog.setval('public.intervencao_bens_orcam_id_intervencao_bens_orcam_seq', 1, false);
            public       postgres    false    250            E
          0    33398    matricula_inss 
   TABLE DATA                     public       postgres    false    220   ;'      k           0    0 $   matricula_inss_id_matricula_inss_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.matricula_inss_id_matricula_inss_seq', 1, false);
            public       postgres    false    219            [
          0    33780    motivoparalisacao 
   TABLE DATA                     public       postgres    false    242   U'      /
          0    32940 	   orcamento 
   TABLE DATA                     public       postgres    false    198   o'      8
          0    33189    orcamento_item 
   TABLE DATA                     public       postgres    false    207   ?'      :
          0    33212    ordem_servico 
   TABLE DATA                     public       postgres    false    209   ?'      l           0    0 "   ordem_servico_id_ordem_servico_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.ordem_servico_id_ordem_servico_seq', 1, false);
            public       postgres    false    208            Z
          0    33750    origemacompanhamento 
   TABLE DATA                     public       postgres    false    241   ?'      "
          0    24697    pessoa 
   TABLE DATA                     public       postgres    false    185   F(      ?
          0    33315    planilha_aditivo 
   TABLE DATA                     public       postgres    false    214   `(      m           0    0 *   planilha_aditivo_id_planilha_orcamento_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public.planilha_aditivo_id_planilha_orcamento_seq', 1, false);
            public       postgres    false    213            B
          0    33352    planilha_execucao 
   TABLE DATA                     public       postgres    false    217   z(      n           0    0 '   planilha_execucao_id_ato_contratual_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.planilha_execucao_id_ato_contratual_seq', 1, false);
            public       postgres    false    216            o           0    0 *   planilha_execucao_id_planilha_execucao_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public.planilha_execucao_id_planilha_execucao_seq', 1, false);
            public       postgres    false    215            =
          0    33294    planilha_orcamento 
   TABLE DATA                     public       postgres    false    212   ?(      p           0    0 ,   planilha_orcamento_id_planilha_orcamento_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.planilha_orcamento_id_planilha_orcamento_seq', 1, false);
            public       postgres    false    211            C
          0    33370    planilha_orcamento_item 
   TABLE DATA                     public       postgres    false    218   ?(      7
          0    33174    produtos_servicos 
   TABLE DATA                     public       postgres    false    206   ?(      6
          0    33164    responsabilidade_contrato 
   TABLE DATA                     public       postgres    false    205   ?(      q           0    0 :   responsabilidade_contrato_id_responsabilidade_contrato_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('public.responsabilidade_contrato_id_responsabilidade_contrato_seq', 1, false);
            public       postgres    false    204            4
          0    33126    responsabilidade_tecnica 
   TABLE DATA                     public       postgres    false    203   ?(      r           0    0 8   responsabilidade_tecnica_id_responsabilidade_tecnica_seq    SEQUENCE SET     g   SELECT pg_catalog.setval('public.responsabilidade_tecnica_id_responsabilidade_tecnica_seq', 1, false);
            public       postgres    false    202            0
          0    32975    responsabilidade_tecnica_orcam 
   TABLE DATA                     public       postgres    false    199   )      &
          0    32869 
   tipo_anexo 
   TABLE DATA                     public       postgres    false    189   0)      s           0    0    tipo_anexo_id_tipo_anexo_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.tipo_anexo_id_tipo_anexo_seq', 1, false);
            public       postgres    false    188            '
          0    32883    tipo_anexo_menu 
   TABLE DATA                     public       postgres    false    190   J)      ]
          0    33855    tipoacompanhamento 
   TABLE DATA                     public       postgres    false    244   d)      (
          0    32893    tipodocumentoorgaoclasse 
   TABLE DATA                     public       postgres    false    191   *      P
          0    33568    tipodocumentopessoa 
   TABLE DATA                     public       postgres    false    231   ?*      ,
          0    32913    tipointervencao 
   TABLE DATA                     public       postgres    false    195   ?+      \
          0    33815    tipomedicao 
   TABLE DATA                     public       postgres    false    243   l,      -
          0    32918    tipoobra 
   TABLE DATA                     public       postgres    false    196   ?,      ;
          0    33265    tipoplanilhaorcamento 
   TABLE DATA                     public       postgres    false    210   ?-      1
          0    33073    tiporegimeintervencao 
   TABLE DATA                     public       postgres    false    200   ).      )
          0    32898    tiporesponsabilidadetecnica 
   TABLE DATA                     public       postgres    false    192   ?.      .
          0    32923    tipounidademedidaintervencao 
   TABLE DATA                     public       postgres    false    197   ?/      $
          0    32846    unidade_medida 
   TABLE DATA                     public       postgres    false    187   ?0      t           0    0 $   unidade_medida_id_unidade_medida_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.unidade_medida_id_unidade_medida_seq', 1, false);
            public       postgres    false    186            g	           2606    33906    anexo anexo_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT anexo_pkey PRIMARY KEY (id_anexo);
 :   ALTER TABLE ONLY public.anexo DROP CONSTRAINT anexo_pkey;
       public         postgres    false    247    247            d	           2606    33869     acompanhamento pk_acompanhamento 
   CONSTRAINT     m   ALTER TABLE ONLY public.acompanhamento
    ADD CONSTRAINT pk_acompanhamento PRIMARY KEY (id_acompanhamento);
 J   ALTER TABLE ONLY public.acompanhamento DROP CONSTRAINT pk_acompanhamento;
       public         postgres    false    246    246            i	           2606    33974 "   aditivo_contrato pk_ato_contratual 
   CONSTRAINT     o   ALTER TABLE ONLY public.aditivo_contrato
    ADD CONSTRAINT pk_ato_contratual PRIMARY KEY (id_ato_contratual);
 L   ALTER TABLE ONLY public.aditivo_contrato DROP CONSTRAINT pk_ato_contratual;
       public         postgres    false    249    249            T	           2606    33644 "   boletim_medicao pk_boletim_medicao 
   CONSTRAINT     p   ALTER TABLE ONLY public.boletim_medicao
    ADD CONSTRAINT pk_boletim_medicao PRIMARY KEY (id_boletim_medicao);
 L   ALTER TABLE ONLY public.boletim_medicao DROP CONSTRAINT pk_boletim_medicao;
       public         postgres    false    237    237            Z	           2606    33693 .   boletim_medicao_anexo pk_boletim_medicao_anexo 
   CONSTRAINT     ?   ALTER TABLE ONLY public.boletim_medicao_anexo
    ADD CONSTRAINT pk_boletim_medicao_anexo PRIMARY KEY (id_boletim_medicao_anexo);
 X   ALTER TABLE ONLY public.boletim_medicao_anexo DROP CONSTRAINT pk_boletim_medicao_anexo;
       public         postgres    false    240    240            	           2606    32912 *   classificacaoobra pk_cd_classificacao_obra 
   CONSTRAINT     {   ALTER TABLE ONLY public.classificacaoobra
    ADD CONSTRAINT pk_cd_classificacao_obra PRIMARY KEY (cd_classificacao_obra);
 T   ALTER TABLE ONLY public.classificacaoobra DROP CONSTRAINT pk_cd_classificacao_obra;
       public         postgres    false    194    194            ^	           2606    33784 *   motivoparalisacao pk_cd_motivo_paralisacao 
   CONSTRAINT     {   ALTER TABLE ONLY public.motivoparalisacao
    ADD CONSTRAINT pk_cd_motivo_paralisacao PRIMARY KEY (cd_motivo_paralisacao);
 T   ALTER TABLE ONLY public.motivoparalisacao DROP CONSTRAINT pk_cd_motivo_paralisacao;
       public         postgres    false    242    242            \	           2606    33754 0   origemacompanhamento pk_cd_origem_acompanhamento 
   CONSTRAINT     ?   ALTER TABLE ONLY public.origemacompanhamento
    ADD CONSTRAINT pk_cd_origem_acompanhamento PRIMARY KEY (cd_origem_acompanhamento);
 Z   ALTER TABLE ONLY public.origemacompanhamento DROP CONSTRAINT pk_cd_origem_acompanhamento;
       public         postgres    false    241    241            b	           2606    33859 ,   tipoacompanhamento pk_cd_tipo_acompanhamento 
   CONSTRAINT     ~   ALTER TABLE ONLY public.tipoacompanhamento
    ADD CONSTRAINT pk_cd_tipo_acompanhamento PRIMARY KEY (cd_tipo_acompanhamento);
 V   ALTER TABLE ONLY public.tipoacompanhamento DROP CONSTRAINT pk_cd_tipo_acompanhamento;
       public         postgres    false    244    244            K	           2606    33572 )   tipodocumentopessoa pk_cd_tipo_doc_pessoa 
   CONSTRAINT     w   ALTER TABLE ONLY public.tipodocumentopessoa
    ADD CONSTRAINT pk_cd_tipo_doc_pessoa PRIMARY KEY (cd_tipo_doc_pessoa);
 S   ALTER TABLE ONLY public.tipodocumentopessoa DROP CONSTRAINT pk_cd_tipo_doc_pessoa;
       public         postgres    false    231    231            	           2606    32917 &   tipointervencao pk_cd_tipo_intervencao 
   CONSTRAINT     u   ALTER TABLE ONLY public.tipointervencao
    ADD CONSTRAINT pk_cd_tipo_intervencao PRIMARY KEY (cd_tipo_intervencao);
 P   ALTER TABLE ONLY public.tipointervencao DROP CONSTRAINT pk_cd_tipo_intervencao;
       public         postgres    false    195    195            `	           2606    33819    tipomedicao pk_cd_tipo_medicao 
   CONSTRAINT     i   ALTER TABLE ONLY public.tipomedicao
    ADD CONSTRAINT pk_cd_tipo_medicao PRIMARY KEY (cd_tipo_medicao);
 H   ALTER TABLE ONLY public.tipomedicao DROP CONSTRAINT pk_cd_tipo_medicao;
       public         postgres    false    243    243            	           2606    32922    tipoobra pk_cd_tipo_obra 
   CONSTRAINT     `   ALTER TABLE ONLY public.tipoobra
    ADD CONSTRAINT pk_cd_tipo_obra PRIMARY KEY (cd_tipo_obra);
 B   ALTER TABLE ONLY public.tipoobra DROP CONSTRAINT pk_cd_tipo_obra;
       public         postgres    false    196    196            /	           2606    33269 3   tipoplanilhaorcamento pk_cd_tipo_planilha_orcamento 
   CONSTRAINT     ?   ALTER TABLE ONLY public.tipoplanilhaorcamento
    ADD CONSTRAINT pk_cd_tipo_planilha_orcamento PRIMARY KEY (cd_tipo_planilha_orcamento);
 ]   ALTER TABLE ONLY public.tipoplanilhaorcamento DROP CONSTRAINT pk_cd_tipo_planilha_orcamento;
       public         postgres    false    210    210            	           2606    33077 3   tiporegimeintervencao pk_cd_tipo_regime_intervencao 
   CONSTRAINT     ?   ALTER TABLE ONLY public.tiporegimeintervencao
    ADD CONSTRAINT pk_cd_tipo_regime_intervencao PRIMARY KEY (cd_tipo_regime_intervencao);
 ]   ALTER TABLE ONLY public.tiporegimeintervencao DROP CONSTRAINT pk_cd_tipo_regime_intervencao;
       public         postgres    false    200    200            	           2606    32927 :   tipounidademedidaintervencao pk_cd_tp_unidade_medida_inter 
   CONSTRAINT     ?   ALTER TABLE ONLY public.tipounidademedidaintervencao
    ADD CONSTRAINT pk_cd_tp_unidade_medida_inter PRIMARY KEY (cd_tp_unidade_medida_inter);
 d   ALTER TABLE ONLY public.tipounidademedidaintervencao DROP CONSTRAINT pk_cd_tp_unidade_medida_inter;
       public         postgres    false    197    197            	           2606    32907 4   classificacaointervencao pk_classificacaointervencao 
   CONSTRAINT     ?   ALTER TABLE ONLY public.classificacaointervencao
    ADD CONSTRAINT pk_classificacaointervencao PRIMARY KEY (cd_classificacaointervencao);
 ^   ALTER TABLE ONLY public.classificacaointervencao DROP CONSTRAINT pk_classificacaointervencao;
       public         postgres    false    193    193            Q	           2606    33626    cnd_obra pk_cnd_obra 
   CONSTRAINT     [   ALTER TABLE ONLY public.cnd_obra
    ADD CONSTRAINT pk_cnd_obra PRIMARY KEY (id_cnd_obra);
 >   ALTER TABLE ONLY public.cnd_obra DROP CONSTRAINT pk_cnd_obra;
       public         postgres    false    236    236            O	           2606    33596    contrato pk_contrato 
   CONSTRAINT     [   ALTER TABLE ONLY public.contrato
    ADD CONSTRAINT pk_contrato PRIMARY KEY (id_contrato);
 >   ALTER TABLE ONLY public.contrato DROP CONSTRAINT pk_contrato;
       public         postgres    false    234    234            	           2606    24705    pessoa pk_cpf_cnpj_pessoa 
   CONSTRAINT     t   ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pk_cpf_cnpj_pessoa PRIMARY KEY (nr_cpf_cnpj, fl_fisica_juridica);
 C   ALTER TABLE ONLY public.pessoa DROP CONSTRAINT pk_cpf_cnpj_pessoa;
       public         postgres    false    185    185    185            M	           2606    33578    crea_cau pk_crea_cau 
   CONSTRAINT     ~   ALTER TABLE ONLY public.crea_cau
    ADD CONSTRAINT pk_crea_cau PRIMARY KEY (nr_cpf_usuario_responsavel, id_tipo_doc_pessoa);
 >   ALTER TABLE ONLY public.crea_cau DROP CONSTRAINT pk_crea_cau;
       public         postgres    false    232    232    232            D	           2606    33511    diario_obra pk_diario_obra 
   CONSTRAINT     d   ALTER TABLE ONLY public.diario_obra
    ADD CONSTRAINT pk_diario_obra PRIMARY KEY (id_diario_obra);
 D   ALTER TABLE ONLY public.diario_obra DROP CONSTRAINT pk_diario_obra;
       public         postgres    false    226    226            I	           2606    33556 &   diario_obra_anexo pk_diario_obra_anexo 
   CONSTRAINT     v   ALTER TABLE ONLY public.diario_obra_anexo
    ADD CONSTRAINT pk_diario_obra_anexo PRIMARY KEY (id_diario_obra_anexo);
 P   ALTER TABLE ONLY public.diario_obra_anexo DROP CONSTRAINT pk_diario_obra_anexo;
       public         postgres    false    230    230            G	           2606    33542 *   diario_obra_detalhe pk_diario_obra_detalhe 
   CONSTRAINT     |   ALTER TABLE ONLY public.diario_obra_detalhe
    ADD CONSTRAINT pk_diario_obra_detalhe PRIMARY KEY (id_diario_obra_detalhe);
 T   ALTER TABLE ONLY public.diario_obra_detalhe DROP CONSTRAINT pk_diario_obra_detalhe;
       public         postgres    false    228    228            
	           2606    32897 2   tipodocumentoorgaoclasse pk_documento_orgao_classe 
   CONSTRAINT     ?   ALTER TABLE ONLY public.tipodocumentoorgaoclasse
    ADD CONSTRAINT pk_documento_orgao_classe PRIMARY KEY (cd_tipo_documento_orgao_classe);
 \   ALTER TABLE ONLY public.tipodocumentoorgaoclasse DROP CONSTRAINT pk_documento_orgao_classe;
       public         postgres    false    191    191            W	           2606    33669 '   boletim_medicao_item pk_id_boletin_item 
   CONSTRAINT     z   ALTER TABLE ONLY public.boletim_medicao_item
    ADD CONSTRAINT pk_id_boletin_item PRIMARY KEY (id_boletim_medicao_item);
 Q   ALTER TABLE ONLY public.boletim_medicao_item DROP CONSTRAINT pk_id_boletin_item;
       public         postgres    false    238    238            )	           2606    33198 $   orcamento_item pk_id_orcamento_item  
   CONSTRAINT     s   ALTER TABLE ONLY public.orcamento_item
    ADD CONSTRAINT "pk_id_orcamento_item " PRIMARY KEY (id_orcamento_item);
 P   ALTER TABLE ONLY public.orcamento_item DROP CONSTRAINT "pk_id_orcamento_item ";
       public         postgres    false    207    207            9	           2606    33379 +   planilha_orcamento_item pk_id_planilha_item 
   CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_orcamento_item
    ADD CONSTRAINT pk_id_planilha_item PRIMARY KEY (id_planilha_orcamento_item);
 U   ALTER TABLE ONLY public.planilha_orcamento_item DROP CONSTRAINT pk_id_planilha_item;
       public         postgres    false    218    218            	           2606    33087    intervencao pk_intervencao 
   CONSTRAINT     d   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT pk_intervencao PRIMARY KEY (id_intervencao);
 D   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT pk_intervencao;
       public         postgres    false    201    201            B	           2606    33496 $   intervencao_acao pk_intervencao_acao 
   CONSTRAINT     s   ALTER TABLE ONLY public.intervencao_acao
    ADD CONSTRAINT pk_intervencao_acao PRIMARY KEY (id_intervencao_acao);
 N   ALTER TABLE ONLY public.intervencao_acao DROP CONSTRAINT pk_intervencao_acao;
       public         postgres    false    224    224            ?	           2606    33440 $   intervencao_bens pk_intervencao_bens 
   CONSTRAINT     s   ALTER TABLE ONLY public.intervencao_bens
    ADD CONSTRAINT pk_intervencao_bens PRIMARY KEY (id_intervencao_bens);
 N   ALTER TABLE ONLY public.intervencao_bens DROP CONSTRAINT pk_intervencao_bens;
       public         postgres    false    222    222            l	           2606    33991 0   intervencao_bens_orcam pk_intervencao_bens_orcam 
   CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao_bens_orcam
    ADD CONSTRAINT pk_intervencao_bens_orcam PRIMARY KEY (id_intervencao_bens_orcam);
 Z   ALTER TABLE ONLY public.intervencao_bens_orcam DROP CONSTRAINT pk_intervencao_bens_orcam;
       public         postgres    false    251    251            <	           2606    33405     matricula_inss pk_matricula_inss 
   CONSTRAINT     m   ALTER TABLE ONLY public.matricula_inss
    ADD CONSTRAINT pk_matricula_inss PRIMARY KEY (id_matricula_inss);
 J   ALTER TABLE ONLY public.matricula_inss DROP CONSTRAINT pk_matricula_inss;
       public         postgres    false    220    220            	           2606    32949    orcamento pk_orcamento 
   CONSTRAINT     ^   ALTER TABLE ONLY public.orcamento
    ADD CONSTRAINT pk_orcamento PRIMARY KEY (id_orcamento);
 @   ALTER TABLE ONLY public.orcamento DROP CONSTRAINT pk_orcamento;
       public         postgres    false    198    198            ,	           2606    33220    ordem_servico pk_ordem_servico 
   CONSTRAINT     j   ALTER TABLE ONLY public.ordem_servico
    ADD CONSTRAINT pk_ordem_servico PRIMARY KEY (id_ordem_servico);
 H   ALTER TABLE ONLY public.ordem_servico DROP CONSTRAINT pk_ordem_servico;
       public         postgres    false    209    209            4	           2606    33320 $   planilha_aditivo pk_planilha_aditivo 
   CONSTRAINT     u   ALTER TABLE ONLY public.planilha_aditivo
    ADD CONSTRAINT pk_planilha_aditivo PRIMARY KEY (id_planilha_orcamento);
 N   ALTER TABLE ONLY public.planilha_aditivo DROP CONSTRAINT pk_planilha_aditivo;
       public         postgres    false    214    214            6	           2606    33359 &   planilha_execucao pk_planilha_execucao 
   CONSTRAINT     v   ALTER TABLE ONLY public.planilha_execucao
    ADD CONSTRAINT pk_planilha_execucao PRIMARY KEY (id_planilha_execucao);
 P   ALTER TABLE ONLY public.planilha_execucao DROP CONSTRAINT pk_planilha_execucao;
       public         postgres    false    217    217            1	           2606    33301 (   planilha_orcamento pk_planilha_orcamento 
   CONSTRAINT     y   ALTER TABLE ONLY public.planilha_orcamento
    ADD CONSTRAINT pk_planilha_orcamento PRIMARY KEY (id_planilha_orcamento);
 R   ALTER TABLE ONLY public.planilha_orcamento DROP CONSTRAINT pk_planilha_orcamento;
       public         postgres    false    212    212            '	           2606    33183 &   produtos_servicos pk_produtos_servicos 
   CONSTRAINT     s   ALTER TABLE ONLY public.produtos_servicos
    ADD CONSTRAINT pk_produtos_servicos PRIMARY KEY (id_codigo_produto);
 P   ALTER TABLE ONLY public.produtos_servicos DROP CONSTRAINT pk_produtos_servicos;
       public         postgres    false    206    206            $	           2606    33170 6   responsabilidade_contrato pk_responsabilidade_contrato 
   CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_contrato
    ADD CONSTRAINT pk_responsabilidade_contrato PRIMARY KEY (id_responsabilidade_contrato);
 `   ALTER TABLE ONLY public.responsabilidade_contrato DROP CONSTRAINT pk_responsabilidade_contrato;
       public         postgres    false    205    205            	           2606    32902 7   tiporesponsabilidadetecnica pk_responsabilidade_tecnica 
   CONSTRAINT     ?   ALTER TABLE ONLY public.tiporesponsabilidadetecnica
    ADD CONSTRAINT pk_responsabilidade_tecnica PRIMARY KEY (cd_tp_responsabilidade_tecnica);
 a   ALTER TABLE ONLY public.tiporesponsabilidadetecnica DROP CONSTRAINT pk_responsabilidade_tecnica;
       public         postgres    false    192    192            !	           2606    33133 5   responsabilidade_tecnica pk_responsabilidade_tecnica_ 
   CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica
    ADD CONSTRAINT pk_responsabilidade_tecnica_ PRIMARY KEY (id_responsabilidade_tecnica);
 _   ALTER TABLE ONLY public.responsabilidade_tecnica DROP CONSTRAINT pk_responsabilidade_tecnica_;
       public         postgres    false    203    203            	           2606    32981 =   responsabilidade_tecnica_orcam pk_responsabilidade_tecnica_or 
   CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam
    ADD CONSTRAINT pk_responsabilidade_tecnica_or PRIMARY KEY (id_responsabilidade_tecnica_or);
 g   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam DROP CONSTRAINT pk_responsabilidade_tecnica_or;
       public         postgres    false    199    199            	           2606    32887 "   tipo_anexo_menu pk_tipo_anexo_menu 
   CONSTRAINT     ?   ALTER TABLE ONLY public.tipo_anexo_menu
    ADD CONSTRAINT pk_tipo_anexo_menu PRIMARY KEY (id_cliente, id_menu, id_tipo_anexo);
 L   ALTER TABLE ONLY public.tipo_anexo_menu DROP CONSTRAINT pk_tipo_anexo_menu;
       public         postgres    false    190    190    190    190            	           2606    32875    tipo_anexo tipo_anexo_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.tipo_anexo
    ADD CONSTRAINT tipo_anexo_pkey PRIMARY KEY (id_tipo_anexo);
 D   ALTER TABLE ONLY public.tipo_anexo DROP CONSTRAINT tipo_anexo_pkey;
       public         postgres    false    189    189            	           2606    32852 "   unidade_medida unidade_medida_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.unidade_medida
    ADD CONSTRAINT unidade_medida_pkey PRIMARY KEY (id_unidade_medida);
 L   ALTER TABLE ONLY public.unidade_medida DROP CONSTRAINT unidade_medida_pkey;
       public         postgres    false    187    187             	           1259    24706    in_pessoa_fn_sem_acentos    INDEX     P   CREATE INDEX in_pessoa_fn_sem_acentos ON public.pessoa USING btree (nm_pessoa);
 ,   DROP INDEX public.in_pessoa_fn_sem_acentos;
       public         postgres    false    185            *	           1259    33209    public.uk_orcamento_item    INDEX     ?   CREATE UNIQUE INDEX "public.uk_orcamento_item" ON public.orcamento_item USING btree (id_orcamento, id_codigo_produto, nm_agrupador_orcamento_item, nm_agrupador_orcamento_item2);
 .   DROP INDEX public."public.uk_orcamento_item";
       public         postgres    false    207    207    207    207            e	           1259    33900    uk_acompanhamento    INDEX     ?   CREATE UNIQUE INDEX uk_acompanhamento ON public.acompanhamento USING btree (id_intervencao, id_origem_acompanhamento, nr_acompanhamento);
 %   DROP INDEX public.uk_acompanhamento;
       public         postgres    false    246    246    246            j	           1259    33980    uk_aditivo_contrato    INDEX     z   CREATE UNIQUE INDEX uk_aditivo_contrato ON public.aditivo_contrato USING btree (id_contrato, nr_aditivo, nr_ano_aditivo);
 '   DROP INDEX public.uk_aditivo_contrato;
       public         postgres    false    249    249    249            U	           1259    33650    uk_boletim_medicao    INDEX     s   CREATE UNIQUE INDEX uk_boletim_medicao ON public.boletim_medicao USING btree (id_intervencao, cd_boletim_medicao);
 &   DROP INDEX public.uk_boletim_medicao;
       public         postgres    false    237    237            X	           1259    33685    uk_boletim_medicao_item    INDEX     ?   CREATE UNIQUE INDEX uk_boletim_medicao_item ON public.boletim_medicao_item USING btree (id_boletim_medicao, id_planilha_orcamento, id_codigo_produto, nm_agrupador_orcamento_item, nm_agrupador_orcamento_item2);
 +   DROP INDEX public.uk_boletim_medicao_item;
       public         postgres    false    238    238    238    238    238            R	           1259    33632    uk_cnd_obra    INDEX     n   CREATE UNIQUE INDEX uk_cnd_obra ON public.cnd_obra USING btree (id_matricula_inss, nr_cnd_obra, nr_operacao);
    DROP INDEX public.uk_cnd_obra;
       public         postgres    false    236    236    236            E	           1259    33517    uk_diario_obra    INDEX     `   CREATE INDEX uk_diario_obra ON public.diario_obra USING btree (dt_diario_obra, id_intervencao);
 "   DROP INDEX public.uk_diario_obra;
       public         postgres    false    226    226            	           1259    33123    uk_intervencao    INDEX     x   CREATE UNIQUE INDEX uk_intervencao ON public.intervencao USING btree (cd_entidade, cd_intervencao, nr_ano_intervencao);
 "   DROP INDEX public.uk_intervencao;
       public         postgres    false    201    201    201            @	           1259    33446    uk_intervencao_bens    INDEX     u   CREATE UNIQUE INDEX uk_intervencao_bens ON public.intervencao_bens USING btree (id_intervencao, id_bem_patrimonial);
 '   DROP INDEX public.uk_intervencao_bens;
       public         postgres    false    222    222            =	           1259    33411    uk_matricula_inss    INDEX     o   CREATE UNIQUE INDEX uk_matricula_inss ON public.matricula_inss USING btree (id_intervencao, nr_matricula_cei);
 %   DROP INDEX public.uk_matricula_inss;
       public         postgres    false    220    220            -	           1259    33226    uk_ordem_servico    INDEX     ?   CREATE UNIQUE INDEX uk_ordem_servico ON public.ordem_servico USING btree (id_intervencao, nr_ordem_servico, nr_ano_ordem_servico);
 $   DROP INDEX public.uk_ordem_servico;
       public         postgres    false    209    209    209            7	           1259    33369    uk_planilha_execucao    INDEX     ?   CREATE UNIQUE INDEX uk_planilha_execucao ON public.planilha_execucao USING btree (id_planilha_orcamento, nr_contrato, nr_ano_contrato, id_ato_contratual);
 (   DROP INDEX public.uk_planilha_execucao;
       public         postgres    false    217    217    217    217            :	           1259    33395    uk_planilha_item    INDEX     ?   CREATE UNIQUE INDEX uk_planilha_item ON public.planilha_orcamento_item USING btree (id_planilha_orcamento, id_codigo_produto, nm_agrupador_orcamento_item, nm_agrupador_orcamento_item2, id_tipo_planilha_orcamento);
 $   DROP INDEX public.uk_planilha_item;
       public         postgres    false    218    218    218    218    218            2	           1259    33312    uk_planilha_orcamento    INDEX     ?   CREATE UNIQUE INDEX uk_planilha_orcamento ON public.planilha_orcamento USING btree (id_intervencao, fl_fisica_usuario_orcamento, id_leiato);
 )   DROP INDEX public.uk_planilha_orcamento;
       public         postgres    false    212    212    212            %	           1259    33173    uk_responsabilidade_contrato    INDEX     ?   CREATE UNIQUE INDEX uk_responsabilidade_contrato ON public.responsabilidade_contrato USING btree (cd_contrato, nr_ano_contrato, cd_tipo_responsavel, fl_cpf_responsavel, nr_cpf_responsavel, dt_inicio, dt_fim);
 0   DROP INDEX public.uk_responsabilidade_contrato;
       public         postgres    false    205    205    205    205    205    205    205            "	           1259    33151    uk_responsabilidade_tecnica    INDEX     ?   CREATE UNIQUE INDEX uk_responsabilidade_tecnica ON public.responsabilidade_tecnica USING btree (id_intervencao, fl_fisica_responsavel_tecnico, id_tipo_documento_orgao_classe, nr_documento_orgao_classe, id_tp_responsabilidade_tecnica);
 /   DROP INDEX public.uk_responsabilidade_tecnica;
       public         postgres    false    203    203    203    203    203            ?	           2606    33870 '   acompanhamento fk_acomp_boletim_medicao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.acompanhamento
    ADD CONSTRAINT fk_acomp_boletim_medicao FOREIGN KEY (id_boletim_medicao) REFERENCES public.boletim_medicao(id_boletim_medicao);
 Q   ALTER TABLE ONLY public.acompanhamento DROP CONSTRAINT fk_acomp_boletim_medicao;
       public       postgres    false    246    237    2388            ?	           2606    33875 ,   acompanhamento fk_acompanhamento_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.acompanhamento
    ADD CONSTRAINT fk_acompanhamento_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 V   ALTER TABLE ONLY public.acompanhamento DROP CONSTRAINT fk_acompanhamento_intervencao;
       public       postgres    false    201    246    2334            ?	           2606    33880 '   acompanhamento fk_acompanhamento_origem    FK CONSTRAINT     ?   ALTER TABLE ONLY public.acompanhamento
    ADD CONSTRAINT fk_acompanhamento_origem FOREIGN KEY (id_origem_acompanhamento) REFERENCES public.origemacompanhamento(cd_origem_acompanhamento);
 Q   ALTER TABLE ONLY public.acompanhamento DROP CONSTRAINT fk_acompanhamento_origem;
       public       postgres    false    2396    241    246            ?	           2606    33885 ,   acompanhamento fk_acompanhamento_paralisacao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.acompanhamento
    ADD CONSTRAINT fk_acompanhamento_paralisacao FOREIGN KEY (id_motivo_paralisacao) REFERENCES public.motivoparalisacao(cd_motivo_paralisacao);
 V   ALTER TABLE ONLY public.acompanhamento DROP CONSTRAINT fk_acompanhamento_paralisacao;
       public       postgres    false    2398    242    246            ?	           2606    33890 -   acompanhamento fk_acompanhamento_tipo_medicao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.acompanhamento
    ADD CONSTRAINT fk_acompanhamento_tipo_medicao FOREIGN KEY (id_tipo_medicao) REFERENCES public.tipomedicao(cd_tipo_medicao);
 W   ALTER TABLE ONLY public.acompanhamento DROP CONSTRAINT fk_acompanhamento_tipo_medicao;
       public       postgres    false    246    243    2400            ?	           2606    33895 2   acompanhamento fk_acompanhamento_tp_acompanhamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.acompanhamento
    ADD CONSTRAINT fk_acompanhamento_tp_acompanhamento FOREIGN KEY (id_tipo_acompanhamento) REFERENCES public.tipoacompanhamento(cd_tipo_acompanhamento);
 \   ALTER TABLE ONLY public.acompanhamento DROP CONSTRAINT fk_acompanhamento_tp_acompanhamento;
       public       postgres    false    244    246    2402            ?	           2606    33975 +   aditivo_contrato fk_ato_contratual_contrato    FK CONSTRAINT     ?   ALTER TABLE ONLY public.aditivo_contrato
    ADD CONSTRAINT fk_ato_contratual_contrato FOREIGN KEY (id_contrato) REFERENCES public.contrato(id_contrato);
 U   ALTER TABLE ONLY public.aditivo_contrato DROP CONSTRAINT fk_ato_contratual_contrato;
       public       postgres    false    249    2383    234            ?	           2606    33694 2   boletim_medicao_anexo fk_blm_anexo_id_boletim_item    FK CONSTRAINT     ?   ALTER TABLE ONLY public.boletim_medicao_anexo
    ADD CONSTRAINT fk_blm_anexo_id_boletim_item FOREIGN KEY (id_boletim_medicao_item) REFERENCES public.boletim_medicao_item(id_boletim_medicao_item);
 \   ALTER TABLE ONLY public.boletim_medicao_anexo DROP CONSTRAINT fk_blm_anexo_id_boletim_item;
       public       postgres    false    238    240    2391            ?	           2606    33699 1   boletim_medicao_anexo fk_boletim_anexo_id_boletim    FK CONSTRAINT     ?   ALTER TABLE ONLY public.boletim_medicao_anexo
    ADD CONSTRAINT fk_boletim_anexo_id_boletim FOREIGN KEY (id_boletim_medicao) REFERENCES public.boletim_medicao(id_boletim_medicao);
 [   ALTER TABLE ONLY public.boletim_medicao_anexo DROP CONSTRAINT fk_boletim_anexo_id_boletim;
       public       postgres    false    240    2388    237            ?	           2606    33645 )   boletim_medicao fk_boletim_id_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.boletim_medicao
    ADD CONSTRAINT fk_boletim_id_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 S   ALTER TABLE ONLY public.boletim_medicao DROP CONSTRAINT fk_boletim_id_intervencao;
       public       postgres    false    201    2334    237            ?	           2606    33670 ,   boletim_medicao_item fk_boletim_item_boletim    FK CONSTRAINT     ?   ALTER TABLE ONLY public.boletim_medicao_item
    ADD CONSTRAINT fk_boletim_item_boletim FOREIGN KEY (id_boletim_medicao) REFERENCES public.boletim_medicao(id_boletim_medicao);
 V   ALTER TABLE ONLY public.boletim_medicao_item DROP CONSTRAINT fk_boletim_item_boletim;
       public       postgres    false    237    238    2388            ?	           2606    33675 -   boletim_medicao_item fk_boletim_item_planilha    FK CONSTRAINT     ?   ALTER TABLE ONLY public.boletim_medicao_item
    ADD CONSTRAINT fk_boletim_item_planilha FOREIGN KEY (id_planilha_orcamento) REFERENCES public.planilha_orcamento(id_planilha_orcamento);
 W   ALTER TABLE ONLY public.boletim_medicao_item DROP CONSTRAINT fk_boletim_item_planilha;
       public       postgres    false    238    2353    212            ?	           2606    33680 ,   boletim_medicao_item fk_boletim_item_produto    FK CONSTRAINT     ?   ALTER TABLE ONLY public.boletim_medicao_item
    ADD CONSTRAINT fk_boletim_item_produto FOREIGN KEY (id_codigo_produto) REFERENCES public.produtos_servicos(id_codigo_produto);
 V   ALTER TABLE ONLY public.boletim_medicao_item DROP CONSTRAINT fk_boletim_item_produto;
       public       postgres    false    206    238    2343            v	           2606    33088 (   intervencao fk_classificacao_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT fk_classificacao_intervencao FOREIGN KEY (id_classificacao_intervencao) REFERENCES public.classificacaointervencao(cd_classificacaointervencao);
 R   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT fk_classificacao_intervencao;
       public       postgres    false    201    193    2318            w	           2606    33093 !   intervencao fk_classificacao_obra    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT fk_classificacao_obra FOREIGN KEY (id_classificacao_obra) REFERENCES public.classificacaoobra(cd_classificacao_obra);
 K   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT fk_classificacao_obra;
       public       postgres    false    2320    201    194            ?	           2606    33627 #   cnd_obra fk_cnd_obra_matricula_inss    FK CONSTRAINT     ?   ALTER TABLE ONLY public.cnd_obra
    ADD CONSTRAINT fk_cnd_obra_matricula_inss FOREIGN KEY (id_matricula_inss) REFERENCES public.matricula_inss(id_matricula_inss);
 M   ALTER TABLE ONLY public.cnd_obra DROP CONSTRAINT fk_cnd_obra_matricula_inss;
       public       postgres    false    236    2364    220            ?	           2606    33597     contrato fk_contrato_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.contrato
    ADD CONSTRAINT fk_contrato_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 J   ALTER TABLE ONLY public.contrato DROP CONSTRAINT fk_contrato_intervencao;
       public       postgres    false    201    234    2334            ?	           2606    33579    crea_cau fk_crea_cau_tipo_doc    FK CONSTRAINT     ?   ALTER TABLE ONLY public.crea_cau
    ADD CONSTRAINT fk_crea_cau_tipo_doc FOREIGN KEY (id_tipo_doc_pessoa) REFERENCES public.tipodocumentopessoa(cd_tipo_doc_pessoa);
 G   ALTER TABLE ONLY public.crea_cau DROP CONSTRAINT fk_crea_cau_tipo_doc;
       public       postgres    false    231    2379    232            ?	           2606    33557 .   diario_obra_anexo fk_diario_obra_anexo_detalhe    FK CONSTRAINT     ?   ALTER TABLE ONLY public.diario_obra_anexo
    ADD CONSTRAINT fk_diario_obra_anexo_detalhe FOREIGN KEY (id_diario_obra_detalhe) REFERENCES public.diario_obra_detalhe(id_diario_obra_detalhe) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.diario_obra_anexo DROP CONSTRAINT fk_diario_obra_anexo_detalhe;
       public       postgres    false    230    228    2375            ?	           2606    33543 1   diario_obra_detalhe fk_diario_obra_detalhe_diario    FK CONSTRAINT     ?   ALTER TABLE ONLY public.diario_obra_detalhe
    ADD CONSTRAINT fk_diario_obra_detalhe_diario FOREIGN KEY (id_diario_obra) REFERENCES public.diario_obra(id_diario_obra) ON UPDATE CASCADE ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.diario_obra_detalhe DROP CONSTRAINT fk_diario_obra_detalhe_diario;
       public       postgres    false    2372    228    226            ?	           2606    33512 &   diario_obra fk_diario_obra_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.diario_obra
    ADD CONSTRAINT fk_diario_obra_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 P   ALTER TABLE ONLY public.diario_obra DROP CONSTRAINT fk_diario_obra_intervencao;
       public       postgres    false    2334    226    201            ?	           2606    33907     anexo fk_id_acompanhamento_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_acompanhamento_anexo FOREIGN KEY (id_acompanhamento) REFERENCES public.acompanhamento(id_acompanhamento);
 J   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_acompanhamento_anexo;
       public       postgres    false    247    246    2404            ?	           2606    33912    anexo fk_id_cnd_obra_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_cnd_obra_anexo FOREIGN KEY (id_cnd_obra) REFERENCES public.cnd_obra(id_cnd_obra);
 D   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_cnd_obra_anexo;
       public       postgres    false    236    2385    247            ?	           2606    33917     anexo fk_id_matricula_inss_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_matricula_inss_anexo FOREIGN KEY (id_matricula_inss) REFERENCES public.matricula_inss(id_matricula_inss);
 J   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_matricula_inss_anexo;
       public       postgres    false    247    220    2364            ?	           2606    33922    anexo fk_id_orcamento_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_orcamento_anexo FOREIGN KEY (id_orcamento) REFERENCES public.orcamento(id_orcamento);
 E   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_orcamento_anexo;
       public       postgres    false    198    247    2328            ?	           2606    33221 -   ordem_servico fk_id_ordem_servico_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.ordem_servico
    ADD CONSTRAINT fk_id_ordem_servico_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 W   ALTER TABLE ONLY public.ordem_servico DROP CONSTRAINT fk_id_ordem_servico_intervencao;
       public       postgres    false    201    2334    209            ?	           2606    33927 #   anexo fk_id_planilha_execucao_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_planilha_execucao_anexo FOREIGN KEY (id_planilha_execucao) REFERENCES public.planilha_execucao(id_planilha_execucao);
 M   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_planilha_execucao_anexo;
       public       postgres    false    247    2358    217            ?	           2606    33932 $   anexo fk_id_planilha_orcamento_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_planilha_orcamento_anexo FOREIGN KEY (id_planilha_orcamento) REFERENCES public.planilha_orcamento(id_planilha_orcamento);
 N   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_planilha_orcamento_anexo;
       public       postgres    false    2353    212    247            ?	           2606    33937    anexo fk_id_reso_tecn_orc_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_reso_tecn_orc_anexo FOREIGN KEY (id_responsabilidade_tecnica_or) REFERENCES public.responsabilidade_tecnica_orcam(id_responsabilidade_tecnica_or);
 I   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_reso_tecn_orc_anexo;
       public       postgres    false    247    2330    199            ?	           2606    33942    anexo fk_id_resp_tecnica_anexo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_id_resp_tecnica_anexo FOREIGN KEY (id_responsabilidade_tecnica) REFERENCES public.responsabilidade_tecnica(id_responsabilidade_tecnica);
 H   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_id_resp_tecnica_anexo;
       public       postgres    false    203    2337    247            m	           2606    32888 %   tipo_anexo_menu fk_id_tipo_anexo_menu    FK CONSTRAINT     ?   ALTER TABLE ONLY public.tipo_anexo_menu
    ADD CONSTRAINT fk_id_tipo_anexo_menu FOREIGN KEY (id_tipo_anexo) REFERENCES public.tipo_anexo(id_tipo_anexo);
 O   ALTER TABLE ONLY public.tipo_anexo_menu DROP CONSTRAINT fk_id_tipo_anexo_menu;
       public       postgres    false    189    2310    190            ?	           2606    33992 /   intervencao_bens_orcam fk_interv_bens_orcamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao_bens_orcam
    ADD CONSTRAINT fk_interv_bens_orcamento FOREIGN KEY (id_orcamento) REFERENCES public.orcamento(id_orcamento);
 Y   ALTER TABLE ONLY public.intervencao_bens_orcam DROP CONSTRAINT fk_interv_bens_orcamento;
       public       postgres    false    2328    198    251            ?	           2606    33497 0   intervencao_acao fk_intervencao_acao_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao_acao
    ADD CONSTRAINT fk_intervencao_acao_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 Z   ALTER TABLE ONLY public.intervencao_acao DROP CONSTRAINT fk_intervencao_acao_intervencao;
       public       postgres    false    224    2334    201            ?	           2606    33441 0   intervencao_bens fk_intervencao_bens_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao_bens
    ADD CONSTRAINT fk_intervencao_bens_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 Z   ALTER TABLE ONLY public.intervencao_bens DROP CONSTRAINT fk_intervencao_bens_intervencao;
       public       postgres    false    201    2334    222            x	           2606    33098 (   intervencao fk_intervencao_id_orcamento     FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT "fk_intervencao_id_orcamento " FOREIGN KEY (id_orcamento) REFERENCES public.orcamento(id_orcamento);
 T   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT "fk_intervencao_id_orcamento ";
       public       postgres    false    201    198    2328            ?	           2606    33406 ,   matricula_inss fk_matricula_inss_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.matricula_inss
    ADD CONSTRAINT fk_matricula_inss_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 V   ALTER TABLE ONLY public.matricula_inss DROP CONSTRAINT fk_matricula_inss_intervencao;
       public       postgres    false    201    220    2334            n	           2606    32950 (   orcamento fk_orcamento_class_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orcamento
    ADD CONSTRAINT fk_orcamento_class_intervencao FOREIGN KEY (id_classificacao_intervencao) REFERENCES public.classificacaointervencao(cd_classificacaointervencao);
 R   ALTER TABLE ONLY public.orcamento DROP CONSTRAINT fk_orcamento_class_intervencao;
       public       postgres    false    193    2318    198            o	           2606    32955 !   orcamento fk_orcamento_class_obra    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orcamento
    ADD CONSTRAINT fk_orcamento_class_obra FOREIGN KEY (id_classificacao_obra) REFERENCES public.classificacaoobra(cd_classificacao_obra);
 K   ALTER TABLE ONLY public.orcamento DROP CONSTRAINT fk_orcamento_class_obra;
       public       postgres    false    198    2320    194            ?	           2606    33199 *   orcamento_item fk_orcamento_item_orcamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orcamento_item
    ADD CONSTRAINT fk_orcamento_item_orcamento FOREIGN KEY (id_orcamento) REFERENCES public.orcamento(id_orcamento);
 T   ALTER TABLE ONLY public.orcamento_item DROP CONSTRAINT fk_orcamento_item_orcamento;
       public       postgres    false    2328    207    198            ?	           2606    33204 (   orcamento_item fk_orcamento_item_produto    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orcamento_item
    ADD CONSTRAINT fk_orcamento_item_produto FOREIGN KEY (id_codigo_produto) REFERENCES public.produtos_servicos(id_codigo_produto);
 R   ALTER TABLE ONLY public.orcamento_item DROP CONSTRAINT fk_orcamento_item_produto;
       public       postgres    false    2343    206    207            p	           2606    32960 '   orcamento fk_orcamento_tipo_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orcamento
    ADD CONSTRAINT fk_orcamento_tipo_intervencao FOREIGN KEY (id_tipo_intervencao) REFERENCES public.tipointervencao(cd_tipo_intervencao);
 Q   ALTER TABLE ONLY public.orcamento DROP CONSTRAINT fk_orcamento_tipo_intervencao;
       public       postgres    false    198    2322    195            q	           2606    32965     orcamento fk_orcamento_tipo_obra    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orcamento
    ADD CONSTRAINT fk_orcamento_tipo_obra FOREIGN KEY (id_tipo_obra) REFERENCES public.tipoobra(cd_tipo_obra);
 J   ALTER TABLE ONLY public.orcamento DROP CONSTRAINT fk_orcamento_tipo_obra;
       public       postgres    false    2324    198    196            ?	           2606    33380 ,   planilha_orcamento_item fk_plan_or_item_tipo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_orcamento_item
    ADD CONSTRAINT fk_plan_or_item_tipo FOREIGN KEY (id_tipo_planilha_orcamento) REFERENCES public.tipoplanilhaorcamento(cd_tipo_planilha_orcamento);
 V   ALTER TABLE ONLY public.planilha_orcamento_item DROP CONSTRAINT fk_plan_or_item_tipo;
       public       postgres    false    2351    218    210            ?	           2606    33321 .   planilha_aditivo fk_planilha_aditivo_orcamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_aditivo
    ADD CONSTRAINT fk_planilha_aditivo_orcamento FOREIGN KEY (id_planilha_orcamento) REFERENCES public.planilha_orcamento(id_planilha_orcamento);
 X   ALTER TABLE ONLY public.planilha_aditivo DROP CONSTRAINT fk_planilha_aditivo_orcamento;
       public       postgres    false    214    2353    212            ?	           2606    33360 0   planilha_execucao fk_planilha_execucao_orcamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_execucao
    ADD CONSTRAINT fk_planilha_execucao_orcamento FOREIGN KEY (id_planilha_orcamento) REFERENCES public.planilha_orcamento(id_planilha_orcamento);
 Z   ALTER TABLE ONLY public.planilha_execucao DROP CONSTRAINT fk_planilha_execucao_orcamento;
       public       postgres    false    2353    212    217            ?	           2606    33385 1   planilha_orcamento_item fk_planilha_item_planilha    FK CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_orcamento_item
    ADD CONSTRAINT fk_planilha_item_planilha FOREIGN KEY (id_planilha_orcamento) REFERENCES public.planilha_orcamento(id_planilha_orcamento);
 [   ALTER TABLE ONLY public.planilha_orcamento_item DROP CONSTRAINT fk_planilha_item_planilha;
       public       postgres    false    2353    218    212            ?	           2606    33390 0   planilha_orcamento_item fk_planilha_item_produto    FK CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_orcamento_item
    ADD CONSTRAINT fk_planilha_item_produto FOREIGN KEY (id_codigo_produto) REFERENCES public.produtos_servicos(id_codigo_produto);
 Z   ALTER TABLE ONLY public.planilha_orcamento_item DROP CONSTRAINT fk_planilha_item_produto;
       public       postgres    false    206    2343    218            ?	           2606    33302 4   planilha_orcamento fk_planilha_orcamento_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_orcamento
    ADD CONSTRAINT fk_planilha_orcamento_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 ^   ALTER TABLE ONLY public.planilha_orcamento DROP CONSTRAINT fk_planilha_orcamento_intervencao;
       public       postgres    false    2334    201    212            ?	           2606    33307 -   planilha_orcamento fk_planilha_orcamento_tipo    FK CONSTRAINT     ?   ALTER TABLE ONLY public.planilha_orcamento
    ADD CONSTRAINT fk_planilha_orcamento_tipo FOREIGN KEY (id_tipo_planilha_orcamento) REFERENCES public.tipoplanilhaorcamento(cd_tipo_planilha_orcamento);
 W   ALTER TABLE ONLY public.planilha_orcamento DROP CONSTRAINT fk_planilha_orcamento_tipo;
       public       postgres    false    2351    210    212            ?	           2606    33184 .   produtos_servicos fk_produtos_servicos_unidade    FK CONSTRAINT     ?   ALTER TABLE ONLY public.produtos_servicos
    ADD CONSTRAINT fk_produtos_servicos_unidade FOREIGN KEY (id_unidade_medida) REFERENCES public.unidade_medida(id_unidade_medida);
 X   ALTER TABLE ONLY public.produtos_servicos DROP CONSTRAINT fk_produtos_servicos_unidade;
       public       postgres    false    2308    187    206            s	           2606    32982 7   responsabilidade_tecnica_orcam fk_resp_tec_o_doc_classe    FK CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam
    ADD CONSTRAINT fk_resp_tec_o_doc_classe FOREIGN KEY (id_tipo_documento_orgao_classe) REFERENCES public.tipodocumentoorgaoclasse(cd_tipo_documento_orgao_classe);
 a   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam DROP CONSTRAINT fk_resp_tec_o_doc_classe;
       public       postgres    false    191    2314    199            t	           2606    32987 6   responsabilidade_tecnica_orcam fk_resp_tec_o_orcamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam
    ADD CONSTRAINT fk_resp_tec_o_orcamento FOREIGN KEY (id_orcamento) REFERENCES public.orcamento(id_orcamento);
 `   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam DROP CONSTRAINT fk_resp_tec_o_orcamento;
       public       postgres    false    2328    199    198            }	           2606    33134 ?   responsabilidade_tecnica fk_responsabilidade_tecnica_doc_classe    FK CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica
    ADD CONSTRAINT fk_responsabilidade_tecnica_doc_classe FOREIGN KEY (id_tipo_documento_orgao_classe) REFERENCES public.tipodocumentoorgaoclasse(cd_tipo_documento_orgao_classe);
 i   ALTER TABLE ONLY public.responsabilidade_tecnica DROP CONSTRAINT fk_responsabilidade_tecnica_doc_classe;
       public       postgres    false    2314    203    191            ~	           2606    33139 @   responsabilidade_tecnica fk_responsabilidade_tecnica_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica
    ADD CONSTRAINT fk_responsabilidade_tecnica_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 j   ALTER TABLE ONLY public.responsabilidade_tecnica DROP CONSTRAINT fk_responsabilidade_tecnica_intervencao;
       public       postgres    false    2334    201    203            	           2606    33144 D   responsabilidade_tecnica fk_responsabilidade_tecnica_tp_resp_tecnica    FK CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica
    ADD CONSTRAINT fk_responsabilidade_tecnica_tp_resp_tecnica FOREIGN KEY (id_tp_responsabilidade_tecnica) REFERENCES public.tiporesponsabilidadetecnica(cd_tp_responsabilidade_tecnica);
 n   ALTER TABLE ONLY public.responsabilidade_tecnica DROP CONSTRAINT fk_responsabilidade_tecnica_tp_resp_tecnica;
       public       postgres    false    2316    203    192            ?	           2606    33947    anexo fk_tipo_anexo_interv    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_tipo_anexo_interv FOREIGN KEY (id_tipo_anexo) REFERENCES public.tipo_anexo(id_tipo_anexo);
 D   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_tipo_anexo_interv;
       public       postgres    false    247    2310    189            ?	           2606    33952    anexo fk_tipo_anexo_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_tipo_anexo_intervencao FOREIGN KEY (id_intervencao) REFERENCES public.intervencao(id_intervencao);
 I   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_tipo_anexo_intervencao;
       public       postgres    false    201    2334    247            ?	           2606    33957 !   anexo fk_tipo_anexo_ordem_servico    FK CONSTRAINT     ?   ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_tipo_anexo_ordem_servico FOREIGN KEY (id_ordem_servico) REFERENCES public.ordem_servico(id_ordem_servico);
 K   ALTER TABLE ONLY public.anexo DROP CONSTRAINT fk_tipo_anexo_ordem_servico;
       public       postgres    false    2348    247    209            y	           2606    33103    intervencao fk_tipo_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT fk_tipo_intervencao FOREIGN KEY (id_tipo_intervencao) REFERENCES public.tipointervencao(cd_tipo_intervencao);
 I   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT fk_tipo_intervencao;
       public       postgres    false    195    201    2322            z	           2606    33108    intervencao fk_tipo_obra    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT fk_tipo_obra FOREIGN KEY (id_tipo_obra) REFERENCES public.tipoobra(cd_tipo_obra);
 B   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT fk_tipo_obra;
       public       postgres    false    196    2324    201            {	           2606    33113 &   intervencao fk_tipo_regime_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT fk_tipo_regime_intervencao FOREIGN KEY (id_tipo_regime_intervencao) REFERENCES public.tiporegimeintervencao(cd_tipo_regime_intervencao);
 P   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT fk_tipo_regime_intervencao;
       public       postgres    false    2332    201    200            |	           2606    33118 .   intervencao fk_tipo_unidade_medida_intervencao    FK CONSTRAINT     ?   ALTER TABLE ONLY public.intervencao
    ADD CONSTRAINT fk_tipo_unidade_medida_intervencao FOREIGN KEY (id_unidade_medida_intervencao) REFERENCES public.tipounidademedidaintervencao(cd_tp_unidade_medida_inter);
 X   ALTER TABLE ONLY public.intervencao DROP CONSTRAINT fk_tipo_unidade_medida_intervencao;
       public       postgres    false    201    197    2326            u	           2606    32992 ;   responsabilidade_tecnica_orcam fk_tp_resp_tecnica_orcamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam
    ADD CONSTRAINT fk_tp_resp_tecnica_orcamento FOREIGN KEY (id_tp_responsabilidade_tecnica) REFERENCES public.tiporesponsabilidadetecnica(cd_tp_responsabilidade_tecnica);
 e   ALTER TABLE ONLY public.responsabilidade_tecnica_orcam DROP CONSTRAINT fk_tp_resp_tecnica_orcamento;
       public       postgres    false    199    192    2316            r	           2606    32970 %   orcamento fk_tp_unid_medida_orcamento    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orcamento
    ADD CONSTRAINT fk_tp_unid_medida_orcamento FOREIGN KEY (id_unidade_medida_intervencao) REFERENCES public.tipounidademedidaintervencao(cd_tp_unidade_medida_inter);
 O   ALTER TABLE ONLY public.orcamento DROP CONSTRAINT fk_tp_unid_medida_orcamento;
       public       postgres    false    2326    197    198            _
   
   x???          b
   
   x???          `
   
   x???          V
   
   x???          Y
   
   x???          W
   
   x???          *
   
   x???          +
   
   x???          U
   
   x???          S
   
   x???          Q
   
   x???          K
   
   x???          O
   
   x???          M
   
   x???          2
   
   x???          I
   
   x???          G
   
   x???          d
   
   x???          E
   
   x???          [
   
   x???          /
   
   x???          8
   
   x???          :
   
   x???          Z
   y   x???v
Q???W((M??L??/?LO?ML??-H??H?M?+?W?HN??Hģ??(?c??Ts?	uV?0?QP?*-?,N?L???KL?W״?????F@?C?]u??f?1?J? WG??\\ ?b{?      "
   
   x???          ?
   
   x???          B
   
   x???          =
   
   x???          C
   
   x???          7
   
   x???          6
   
   x???          4
   
   x???          0
   
   x???          &
   
   x???          '
   
   x???          ]
   ?   x???v
Q???W((M??L?+?,?OL??-H??H?M?+?W?HN?	ǣ??(?c?Ts?	uV?0?QP?MM?<????|uMk.O??g?/ ?(1'?8?^v?t??K?)-???& ??Ss?&??*x敤?????Ӧ`7?$??+d楤?e????? U??2      (
   t   x???v
Q???W((M??L?+?,?O?O.?M?+??/JO?O?I,.NU?HN?I??e????y??b|??
a?>???
?:
??@[5??\5?5??<?F@g???
v +?^?      P
     x?͒?j?@??>??L@
?{??SEEc?2q&fA]???/?????Pb={Yv??ǌ$^| ?8??t?R?w?h$ɼ??ne?ZK?UN?ɳ??M???ͦ?ʌ?D?Yw?y\???k?p?S/?սv?fg?W?$?OC???)$c?^?Z?r??m?3h[$??D??5???9?	}???<??3? s!k,oM????4sI??40??Ơ????\??͍$ljQ.v???b??!k??YB???0\?ى??N!0xu??????7?	??H?k?+9???i??b      ,
   ?   x???v
Q???W((M??L?+?,???+I-*K?KN?W?HN???#	?(?cj*?9???+h?(??V?&?^~xq?BJ??RQ???5?'M?3?P???Z?O;K??????%+8?d?e?$??+?^?????X??? ?Fv?      \
   ?   x???v
Q???W((M??L?+?,??MM?LN?W?HN????:
)?(?
a?>???
?:
???ɥ??^??????Y?Z???????WR?X???i??I5??p?瘒Y?YFe??Q?s[??? ?&p?      -
   ?   x???v
Q???W((M??L?+?,??O*JT?HN?q?A<??bOS!??'?5XA?PGA?5%3-39???Ë??5??<)5?hh@bYfnj^	?5????2?:F??]ZTX???_?PPtm"U6?kaifı
?EI?y`7sq ?ᓕ      ;
   w   x???v
Q???W((M??L?+?,?/?I????H?/JN?M?+?W?HN???ä??r:
)Ÿ?4?}B]?4uԝ?S?5??<?f??V?????Ē|??l??1%?$?l1 ????      1
   ~   x???v
Q???W((M??L?+?,?/JM??M??+I-*K?KN?W?HN???C????tR?q?i*?9???+h?(??d????kZsy??^#???y)`?1?f????Q??2?.?9?? ο??      )
   ?   x???;j1?~O1?m0?<??ʘ5,o???ˬ4y??Fr??@n??6Ia\?U?O?1?j?._6P?65??Z?.?x????????Tg?X?F|s7??t8?O?u??-?0??¨?$?}??@?-?h?XT?DWI???????????'ո???#U??DF?Sts$Z?????N?s?n???~?%????di?Bk??w?sjfI?H%ъc????
???e첷?aX?(??("?I      .
   ?   x??ѻ?0?ᝧ8????1$?TWRhc???ꃩ????^6?NM?9×?a??{a?vP霳b԰Jj?&???{?h?:SQ`	NA?????l8??H?wW??.Wۃ??3???h?d??Da"k?5{\lwi??d?????a??j??sV|:]?f?"?
???t?y?H4??????&2?Zt$???P?ɲ??:E      $
   
   x???         