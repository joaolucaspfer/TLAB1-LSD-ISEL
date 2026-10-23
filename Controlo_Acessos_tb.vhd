library ieee;
use ieee.std_logic_1164.all;

entity Controlo_Acessos_tb is
end entity Controlo_Acessos_tb;

architecture sim of Controlo_Acessos_tb is

    signal A : std_logic_vector(3 downto 0);
    signal S : std_logic_vector(1 downto 0);
    signal R : std_logic;

    constant TEMPO_ESTIMULO : time := 20 ns;

begin

    UUT : entity work.Controlo_Acessos
        port map (
            A => A,
            S => S,
            R => R
        );

    stim_proc : process
        variable erros : natural := 0;

        procedure verificar (esperado : std_logic; descricao : string) is
        begin
            if R /= esperado then
                erros := erros + 1;
                report descricao & " | ERRO: R=" & std_logic'image(R) &
                       ", esperado=" & std_logic'image(esperado)
                    severity error;
            else
                report descricao & " | OK: R=" & std_logic'image(R);
            end if;
        end procedure;

    begin
        A <= "0000";
        S <= "00";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 1 | Func 0 | Dept 0 | esperado R=1 (D0 autorizado)");

        A <= "0000";
        S <= "01";
        wait for TEMPO_ESTIMULO;
        verificar('0', "Cenario 2 | Func 0 | Dept 1 | esperado R=0 (D1 nao autorizado)");

        A <= "0100";
        S <= "01";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 3 | Func 4 | Dept 1 | esperado R=1 (D1 autorizado)");

        A <= "0100";
        S <= "10";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 4 | Func 4 | Dept 2 | esperado R=1 (D2 autorizado)");

        A <= "1000";
        S <= "11";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 5 | Func 8 | Dept 3 | esperado R=1 (D3 autorizado)");

        if erros = 0 then
            report "=== SIMULACAO OK: 5/5 cenarios corretos, 0 erros ===";
        else
            report "=== SIMULACAO FALHOU: " & natural'image(erros) &
                   " erro(s) em 5 cenarios ===" severity failure;
        end if;

        wait;  
    end process stim_proc;

end architecture sim;
