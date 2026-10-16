-- ----------------------------------------------------------------------------
-- Verifica_tb.vhd
-- Testbench auto-verificavel do bloco Verifica (simulacao isolada).
-- Cenarios: D = "0101" (autorizado em D0 e D2), varrimento de S = 00..11
-- com 20 ns por estimulo, conforme SPEC-VTB-04.
-- ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- ----------------------------------------------------------------------------
-- Entidade de testbench sem portas (padrao do projeto)
-- ----------------------------------------------------------------------------
entity Verifica_tb is
end entity Verifica_tb;

architecture sim of Verifica_tb is

    -- Sinais ligados a UUT
    signal D : std_logic_vector(3 downto 0);
    signal S : std_logic_vector(1 downto 0);
    signal R : std_logic;

    -- 20 ns por estimulo (REQ-VTB-003)
    constant TEMPO_ESTIMULO : time := 20 ns;

begin

    -- ----------------------------------------------------------------------------
    -- Instanciacao da DUT
    -- ----------------------------------------------------------------------------
    UUT : entity work.Verifica
        port map (
            D => D,
            S => S,
            R => R
        );

    -- ----------------------------------------------------------------------------
    -- Processo de estimulos: 4 cenarios com D = "0101"
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
        -- Departamentos autorizados: D0 e D2 (D = "0101", D3..D0)
        D <= "0101";

        -- Teste 1: S = "00" -> departamento D0 ativo; D0 autorizado => R = 1 (Abre)
        S <= "00";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Teste 1 | D=0101 | S=00 (D0 autorizado)");

        -- Teste 2: S = "01" -> departamento D1 ativo; D1 NAO autorizado => R = 0 (Fechada)
        S <= "01";
        wait for TEMPO_ESTIMULO;
        verificar('0', "Teste 2 | D=0101 | S=01 (D1 nao autorizado)");

        -- Teste 3: S = "10" -> departamento D2 ativo; D2 autorizado => R = 1 (Abre)
        S <= "10";
        wait for TEMPO_ESTIMULO;
        verificar('1', "Teste 3 | D=0101 | S=10 (D2 autorizado)");

        -- Teste 4: S = "11" -> departamento D3 ativo; D3 NAO autorizado => R = 0 (Fechada)
        S <= "11";
        wait for TEMPO_ESTIMULO;
        verificar('0', "Teste 4 | D=0101 | S=11 (D3 nao autorizado)");

        -- Resumo final (auto-verificacao, REQ-VTB-005)
        if erros = 0 then
            report "=== SIMULACAO OK: 4/4 testes corretos, 0 erros ===";
        else
            report "=== SIMULACAO FALHOU: " & natural'image(erros) &
                   " erro(s) em 4 testes ===" severity failure;
        end if;

        wait;  -- termina a simulacao (run -all)
    end process stim_proc;

end architecture sim;
