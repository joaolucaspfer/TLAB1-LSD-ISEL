-- ----------------------------------------------------------------------------
-- Verifica.vhd
-- Segundo bloco do sistema: verifica se o departamento ativo (S) esta
-- autorizado (D) e gera o sinal de controlo da cancela (R).
-- ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- ----------------------------------------------------------------------------
-- Entidade
--   D : 4 bits - departamentos autorizados (D(0)..D(3))
--   S : 2 bits - departamento ativo no sistema
--         00 = D0, 01 = D1, 10 = D2, 11 = D3
--   R : 1 bit  - sinal de controlo da cancela (1 = Abre, 0 = Fechada)
-- ----------------------------------------------------------------------------
entity Verifica is
    port (
        D : in  std_logic_vector(3 downto 0);
        S : in  std_logic_vector(1 downto 0);
        R : out std_logic
    );
end entity Verifica;

-- ----------------------------------------------------------------------------
-- Arquitetura Behavioral
--   R = (D(0) AND NOT S(1) AND NOT S(0))  -- S = 00 -> D0
--     OR (D(1) AND NOT S(1) AND     S(0))  -- S = 01 -> D1
--     OR (D(2) AND     S(1) AND NOT S(0))  -- S = 10 -> D2
--     OR (D(3) AND     S(1) AND     S(0))  -- S = 11 -> D3
-- ----------------------------------------------------------------------------
architecture Behavioral of Verifica is
begin

    R <= (D(0) and (not S(1)) and (not S(0))) or
         (D(1) and (not S(1)) and      S(0) ) or
         (D(2) and      S(1)  and (not S(0))) or
         (D(3) and      S(1)  and      S(0) );

end architecture Behavioral;
