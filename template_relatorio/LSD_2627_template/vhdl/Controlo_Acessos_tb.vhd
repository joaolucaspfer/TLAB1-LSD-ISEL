-- ----------------------------------------------------------------------------
-- Controlo_Acessos_tb.vhd
-- Testbench auto-verificavel do sistema global Controlo_Acessos.
-- Simula cenarios reais de acesso (funcionario x departamento ativo),
-- conforme SPEC-CTB-06.
-- ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- ----------------------------------------------------------------------------
-- Entidade de testbench sem portas (padrao do projeto)
-- ----------------------------------------------------------------------------
entity Controlo_Acessos_tb is
end entity Controlo_Acessos_tb;

architecture sim of Controlo_Acessos_tb is

    -- Sinais ligados a UUT
    signal A : std_logic_vector(3 downto 0);
    signal S : std_logic_vector(1 downto 0);
    signal R : std_logic;

    -- 20 ns por estimulo (REQ-CTB-003)
    constant TEMPO_ESTIMULO : time := 20 ns;

begin

    -- ----------------------------------------------------------------------------
    -- Instanciacao do modulo principal
    -- ----------------------------------------------------------------------------
    UUT : entity work.Controlo_Acessos
        port map (
            A => A,
            S => S,
            R => R
        );

    -- ----------------------------------------------------------------------------
    -- Processo de estimulos: 5 cenarios reais de acesso
    -- ----------------------------------------------------------------------------
    stim_proc : process
        variable erros : natural := 0;

        -- Compara R com o valor esperado e regista divergencias
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
        -- Cenario 1: funcionario 0 (permissoes: apenas D0) no departamento 0
        -- Esperado: R = 1 (cancela abre, acesso autorizado)
        A <= "0000";
        S <= "00";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 1 | Func 0 | Dept 0 | esperado R=1 (D0 autorizado)");

        -- Cenario 2: funcionario 0 (sem permissao em D1) no departamento 1
        -- Esperado: R = 0 (cancela fecha, acesso negado)
        A <= "0000";
        S <= "01";
        wait for TEMPO_ESTIMULO;
        verificar('0', "Cenario 2 | Func 0 | Dept 1 | esperado R=0 (D1 nao autorizado)");

        -- Cenario 3: funcionario 4 (permissoes: D1 e D2) no departamento 1
        -- Esperado: R = 1 (cancela abre, acesso autorizado)
        A <= "0100";
        S <= "01";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 3 | Func 4 | Dept 1 | esperado R=1 (D1 autorizado)");

        -- Cenario 4: funcionario 4 (permissoes: D1 e D2) no departamento 2
        -- Esperado: R = 1 (cancela abre, acesso autorizado)
        A <= "0100";
        S <= "10";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 4 | Func 4 | Dept 2 | esperado R=1 (D2 autorizado)");

        -- Cenario 5: funcionario 8 (permissoes: apenas D3) no departamento 3
        -- Esperado: R = 1 (cancela abre, acesso autorizado)
        A <= "1000";
        S <= "11";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Cenario 5 | Func 8 | Dept 3 | esperado R=1 (D3 autorizado)");

        -- Resumo final (auto-verificacao, REQ-CTB-004)
        if erros = 0 then
            report "=== SIMULACAO OK: 5/5 cenarios corretos, 0 erros ===";
        else
            report "=== SIMULACAO FALHOU: " & natural'image(erros) &
                   " erro(s) em 5 cenarios ===" severity failure;
        end if;

        wait;  -- termina a simulacao (run -all)
    end process stim_proc;

end architecture sim;
