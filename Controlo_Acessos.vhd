library ieee;
use ieee.std_logic_1164.all;

entity Controlo_Acessos is
    port (
        A : in  std_logic_vector(3 downto 0);
        S : in  std_logic_vector(1 downto 0);
        R : out std_logic
    );
end entity Controlo_Acessos;

architecture Behavioral of Controlo_Acessos is

    signal internal_D : std_logic_vector(3 downto 0);

begin

    U_IDENTIFICA : entity work.Identifica_Departamento
        port map (
            A => A,
            D => internal_D
        );

    U_VERIFICA : entity work.Verifica
        port map (
            D => internal_D,
            S => S,
            R => R
        );

end architecture Behavioral;
