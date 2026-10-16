-- =====================================================================================
-- Ficheiro   : Identifica_Departamento.vhd
-- Bloco      : 1 — Controlo de Acessos (TLAB1)
-- Especifica.: sdd/specs/01_identifica_departamento.md (REQ-ID-001..008, DEC-001)
-- Descricao  : Combinacional que decodifica o codigo do funcionario (A, 4 bits,
--              0..15) no vetor de permissoes dos departamentos (D, 4 bits).
-- Biblioteca : ieee.std_logic_1164.all  (REQ-ID-001)
-- =====================================================================================

library ieee;
use ieee.std_logic_1164.all;

-- =====================================================================================
-- Entidade Identifica_Departamento (REQ-ID-002)
--   Entrada A (4 bits): codigo do funcionario, A(3)=A3 … A(0)=A0.
--   Saida   D (4 bits): permissoes dos departamentos, D(3)=D3 … D(0)=D0 (1=autorizado).
-- =====================================================================================
entity Identifica_Departamento is
    port (
        A : in  std_logic_vector(3 downto 0);
        D : out std_logic_vector(3 downto 0)
    );
end entity Identifica_Departamento;

-- =====================================================================================
-- Arquitetura Behavioral (REQ-ID-003): atribuicoes concorrentes de sinal, sem processos.
-- Cada linha abaixo e uma atribuicao concorrente (equacao booleana das seccoes 4/5 da
-- spec), construida apenas com os operadores logicos and, or e not.
-- =====================================================================================
architecture Behavioral of Identifica_Departamento is
begin

    -- ------------------------------------------------------------------------------
    -- D(0) — REQ-ID-005 | Mintermos: m0, m5, m6, m10, m11, m12
    -- ------------------------------------------------------------------------------
    D(0) <= (A(3) and not A(2) and A(1))                         -- m10, m11
         or (not A(3) and A(2) and not A(1) and A(0))            -- m5   [DEC-001]
         or (not A(3) and not A(2) and not A(1) and not A(0))    -- m0
         or (not A(3) and A(2) and A(1) and not A(0))            -- m6
         or (A(3) and A(2) and not A(1) and not A(0));           -- m12

    -- ------------------------------------------------------------------------------
    -- D(1) — REQ-ID-006 | Mintermos: m2, m4, m13, m14, m15
    -- ------------------------------------------------------------------------------
    D(1) <= (A(3) and A(2) and A(0))                             -- m13, m15
         or (A(3) and A(2) and A(1))                             -- m14, m15
         or (not A(3) and not A(2) and A(1) and not A(0))        -- m2
         or (not A(3) and A(2) and not A(1) and not A(0));       -- m4

    -- ------------------------------------------------------------------------------
    -- D(2) — REQ-ID-007 | Mintermos: m1, m4, m5, m7, m11, m12, m14
    -- ------------------------------------------------------------------------------
    D(2) <= (A(2) and not A(1) and not A(0))                     -- m4, m12
         or (A(3) and A(2) and not A(0))                         -- m12, m14
         or (not A(3) and not A(1) and A(0))                     -- m1, m5
         or (not A(3) and A(2) and A(0))                         -- m5, m7
         or (A(3) and not A(2) and A(1) and A(0));               -- m11

    -- ------------------------------------------------------------------------------
    -- D(3) — REQ-ID-008 | Mintermos: m3, m8, m9, m15
    -- ------------------------------------------------------------------------------
    D(3) <= (A(3) and not A(2) and not A(1))                     -- m8, m9
         or (not A(3) and not A(2) and A(1) and A(0))            -- m3
         or (A(3) and A(2) and A(1) and A(0));                   -- m15

end architecture Behavioral;
