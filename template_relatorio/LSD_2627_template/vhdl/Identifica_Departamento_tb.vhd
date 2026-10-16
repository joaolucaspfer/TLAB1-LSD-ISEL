-- =====================================================================================
-- Ficheiro   : Identifica_Departamento_tb.vhd
-- Bloco      : 1 -- Controlo de Acessos (TLAB1) -- TESTBENCH
-- Especifica.: sdd/specs/01_identifica_departamento.md (REQ-ID-009 / DEC-002 / TC-003)
-- Descricao  : Testbench sem portas do bloco Identifica_Departamento. O processo de
--              estimulos (stim_perc) percorre ciclicamente as 16 combinacoes de
--              entrada -- funcionario 0 ("0000") ate funcionario 15 ("1111") -- com
--              um atraso de 20 ns entre cada variacao, e compara a saida D com a
--              tabela de verdade global (sdd/specs/00_projeto_controlo_acessos.md).
--              Apos o 16.o estimulo termina com wait; (paragem da simulacao).
-- Ferramentas: ModelSim / QuestaSim (analise: vcom; simulacao: vsim -c).
-- =====================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- apenas para os relatorios (integer'image / to_integer)

-- =====================================================================================
-- Entidade do testbench -- sem portas (req. 1)
-- =====================================================================================
entity Identifica_Departamento_tb is
end;

architecture sim of Identifica_Departamento_tb is

    -- Sinais ligados a UUT
    signal A : std_logic_vector(3 downto 0) := (others => '0');
    signal D : std_logic_vector(3 downto 0);

    -- Atraso aplicado entre cada variacao de A (req. 3)
    constant TEMPO_ESTIMULO : time := 20 ns;

    -- Tabela de verdade de referencia (spec do projeto, sec. 4):
    --   ESPERADO(funcionario) = D3 & D2 & D1 & D0
    type t_permissoes is array (0 to 15) of std_logic_vector(3 downto 0);
    constant ESPERADO : t_permissoes := (
        "0001",  -- funcionario  0 ("0000"): acesso a D0
        "0100",  -- funcionario  1 ("0001"): acesso a D2
        "0010",  -- funcionario  2 ("0010"): acesso a D1
        "1000",  -- funcionario  3 ("0011"): acesso a D3
        "0110",  -- funcionario  4 ("0100"): acesso a D2, D1
        "0101",  -- funcionario  5 ("0101"): acesso a D2, D0
        "0001",  -- funcionario  6 ("0110"): acesso a D0
        "0100",  -- funcionario  7 ("0111"): acesso a D2
        "1000",  -- funcionario  8 ("1000"): acesso a D3
        "1000",  -- funcionario  9 ("1001"): acesso a D3
        "0001",  -- funcionario 10 ("1010"): acesso a D0
        "0101",  -- funcionario 11 ("1011"): acesso a D2, D0
        "0101",  -- funcionario 12 ("1100"): acesso a D2, D0
        "0010",  -- funcionario 13 ("1101"): acesso a D1
        "0110",  -- funcionario 14 ("1110"): acesso a D2, D1
        "1010"   -- funcionario 15 ("1111"): acesso a D3, D1
    );

begin

    -- =================================================================================
    -- Unidade sob teste (req. 2)
    -- =================================================================================
    UUT : entity work.Identifica_Departamento
        port map (
            A => A,
            D => D
        );

    -- =================================================================================
    -- Processo de estimulos (req. 3): percorre ciclicamente as 16 combinacoes de
    -- entrada, de 20 ns em 20 ns, ate ao funcionario 15; termina com wait; (req. 5).
    -- =================================================================================
    stim_proc : process
        variable erros : natural := 0;
    begin
        report "=== Inicio da simulacao do Identifica_Departamento ===" severity note;

        for funcionario in 0 to 15 loop

            -- Aplica o codigo binario do funcionario atual a A:
            --   funcionario 0 -> "0000", funcionario 1 -> "0001", ...,
            --   funcionario 15 -> "1111"
            A <= std_logic_vector(to_unsigned(funcionario, A'length));

            -- Atraso de 20 ns: mantem o estimulo aplicado e deixa a saida estabilizar
            wait for TEMPO_ESTIMULO;

            -- Registo do funcionario em teste e dos valores observados
            report "Funcionario " & integer'image(funcionario)
                 & " | A = " & integer'image(to_integer(unsigned(A)))
                 & " | D = " & integer'image(to_integer(unsigned(D)))
                 & " | esperado = "
                 & integer'image(to_integer(unsigned(ESPERADO(funcionario))))
                severity note;

            -- Verificacao contra a tabela de verdade (TC-003 / REQ-ID-009)
            if D /= ESPERADO(funcionario) then
                erros := erros + 1;
                report "FALHA no funcionario " & integer'image(funcionario)
                     & " (codigo " & integer'image(to_integer(unsigned(A)))
                     & "): D = " & integer'image(to_integer(unsigned(D)))
                     & ", esperado " & integer'image(to_integer(unsigned(ESPERADO(funcionario))))
                    severity error;
            end if;

        end loop;

        -- Resumo final da simulacao
        if erros = 0 then
            report "=== SIMULACAO OK: 16/16 funcionarios corretos, 0 erros ==="
                severity note;
        else
            report "=== SIMULACAO COM ERROS: " & integer'image(erros)
                 & " divergencias ===" severity failure;
        end if;

        -- Paragem da simulacao apos o ciclo completo (req. 5)
        wait;

    end process stim_proc;

end architecture sim;
