-- ----------------------------------------------------------------------------
-- Controlo_Acessos.vhd
-- Modulo principal: interliga os blocos Identifica_Departamento e Verifica.
--   A (codigo do funcionario) -> Identifica_Departamento -> internal_D
--   internal_D + S (departamento ativo) -> Verifica -> R (cancela)
-- Conforme SPEC-CA-05.
-- ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- ----------------------------------------------------------------------------
-- Entidade
--   A : 4 bits - codigo do funcionario (0..15)
--   S : 2 bits - departamento ativo (00=D0, 01=D1, 10=D2, 11=D3)
--   R : 1 bit  - sinal de controlo da cancela (1 = Abre, 0 = Fechada)
-- ----------------------------------------------------------------------------
entity Controlo_Acessos is
    port (
        A : in  std_logic_vector(3 downto 0);
        S : in  std_logic_vector(1 downto 0);
        R : out std_logic
    );
end entity Controlo_Acessos;

-- ----------------------------------------------------------------------------
-- Arquitetura Behavioral (estrutural): instancia os dois blocos existentes e
-- liga a saida de permissões do primeiro a' entrada de permissoes do segundo
-- atraves do sinal interno internal_D.
-- ----------------------------------------------------------------------------
architecture Behavioral of Controlo_Acessos is

    -- Liga a saida D do Identifica_Departamento a' entrada D do Verifica
    signal internal_D : std_logic_vector(3 downto 0);

begin

    -- Bloco 1: decodifica o codigo do funcionario nas permissoes D3..D0
    U_IDENTIFICA : entity work.Identifica_Departamento
        port map (
            A => A,
            D => internal_D
        );

    -- Bloco 2: valida o departamento ativo S contra as permissoes internal_D
    U_VERIFICA : entity work.Verifica
        port map (
            D => internal_D,
            S => S,
            R => R
        );

end architecture Behavioral;
