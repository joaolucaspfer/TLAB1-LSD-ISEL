# SPEC-TB-02 — Testbench do Bloco 1: Identifica_Departamento_tb

**Versão:** 1.0 — 2026-10-16
**Entidade:** `Identifica_Departamento_tb` (sem portas) — ficheiro `Identifica_Departamento_tb.vhd`
**DUT:** `Identifica_Departamento` — [SPEC-ID-01](01_identifica_departamento.md)
**Ferramentas:** ModelSim / QuestaSim (analise `vcom`, simulacao `vsim`)
**Estado:** Implementado e verificado

---

## 1. Descrição

Testbench **auto-verificável** e **sem portas** do Bloco 1. O processo de estímulos percorre ciclicamente as 16 combinações de entrada — funcionário 0 (`"0000"`) até funcionário 15 (`"1111"`) — com 20 ns por estímulo, compara a saída `D` com a tabela de verdade global ([SPEC-PRJ-00](00_projeto_controlo_acessos.md), sec. 4) e termina com `wait;`.

## 2. Requisitos

| ID | Requisito |
|---|---|
| `REQ-TB-001` | Entidade de testbench **sem portas**: `entity Identifica_Departamento_tb is end;`. |
| `REQ-TB-002` | Instanciação da UUT: `UUT : entity work.Identifica_Departamento` com `port map (A => A, D => D)`. |
| `REQ-TB-003` | Processo de estímulos designado **`stim_proc`** que percorra ciclicamente as 16 combinações de entrada (funcionário 0 = `"0000"` … funcionário 15 = `"1111"`), aplicando **20 ns** de atraso entre cada variação de `A`. |
| `REQ-TB-004` | Comentários explicativos identificando o funcionário testado (tabela `ESPERADO` comentada linha a linha e `report` por iteração com o número do funcionário). |
| `REQ-TB-005` | O processo termina com **`wait;`** para parar a simulação (`run -all` termina aos 320 ns). |
| `REQ-TB-006` | Auto-verificação: comparar `D` com a tabela de verdade para cada código, contando divergências e emitindo resumo final (`SIMULACAO OK …` ou falha com `severity failure`). |

## 3. Decisões

### DEC-002 — Interface e tempos do testbench (2026-10-16) — aprovada

Entidade sem portas, `UUT`, `stim_proc`, 20 ns por estímulo (antes 10 ns), comentários por funcionário e `wait;` final. Detalhe e justificação em [SPEC-ID-01, sec. 3](01_identifica_departamento.md).

### Decisões de implementação

- **VHDL-93** (padrão do Quartus/ModelSim): sem `to_string`, os relatórios usam `integer'image(to_integer(unsigned(...)))` (`ieee.numeric_std` só no testbench).
- **Constantes** `TEMPO_ESTIMULO : time := 20 ns` e `ESPERADO : array(0 to 15)` — tabela de verdade legível e comentada, centrada num único sítio.
- **Auto-checking com contagem de erros** (`variable erros`) em vez de `assert` solto: o teste só falha no fim, dando resumo inequívoco (`severity failure` em caso de divergência).
- **Traço por iteração** (`report "Funcionario N | A | D | esperado"`) para deixar rasto legível da simulação, útil para o relatório.

## 4. Mapa do ficheiro

| Secção do ficheiro | Conteúdo | Requisito |
|---|---|---|
| cabeçalho + `library/use` | `ieee.std_logic_1164`, `ieee.numeric_std` | — |
| `entity … is end;` | entidade sem portas | `REQ-TB-001` |
| arquitetura `sim`: sinais + constantes | `A`, `D`, `TEMPO_ESTIMULO` (20 ns), `ESPERADO` (16 entradas comentadas) | `REQ-TB-003`, `REQ-TB-004` |
| `UUT : entity work.Identifica_Departamento` | instanciação da DUT | `REQ-TB-002` |
| `stim_proc` — loop 0..15 | estimulo `A` → `wait for 20 ns` → `report` → verificação | `REQ-TB-003`, `REQ-TB-004`, `REQ-TB-006` |
| `stim_proc` — fim | resumo (`SIMULACAO OK` / falha) → `wait;` | `REQ-TB-005`, `REQ-TB-006` |

## 5. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-002` | Análise sintática/semântica do ficheiro sem erros (`vcom`). | **PASS** |
| `TC-003` | Simulação com `vsim -c`: 16 funcionários corretos, 0 erros, termina aos 320 ns com `wait;`. | **PASS** |
| `TC-001b` | A tabela `ESPERADO` do testbench tem exatamente as 16 entradas da tabela de verdade do projeto (validado pelo script de equivalência). | **PASS** |

## 6. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando | Resultado |
|---|---|---|---|
| TC-002 | ModelSim-Altera 2020.1 | `vcom -quiet Identifica_Departamento.vhd Identifica_Departamento_tb.vhd` | **PASS** — exit 0, sem erros |
| TC-003 | ModelSim-Altera 2020.1 | `vsim -c work.Identifica_Departamento_tb -do "run -all; quit -f"` | **PASS** — 16 reportes `Funcionario 0..15 \| A \| D \| esperado`; `SIMULACAO OK: 16/16 funcionarios corretos, 0 erros`; 0 errors / 0 warnings; fim aos **320 ns** |
| TC-001b | Python 3 (script próprio) | extração da constante `ESPERADO` (comentários removidos) e comparação com a spec | **PASS** — 16 entradas lidas, iguais à SPEC-PRJ-00 |

## 7. Traçabilidade requisito → implementação → verificação

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-TB-001` | cláusula da entidade | TC-002 |
| `REQ-TB-002` | instância `UUT` | TC-002, TC-003 |
| `REQ-TB-003` | loop `for funcionario in 0 to 15` + `wait for TEMPO_ESTIMULO` | TC-003 (20 ns × 16 = 320 ns) |
| `REQ-TB-004` | comentários da tabela `ESPERADO` + `report` por iteração | TC-003 (16 reportes) |
| `REQ-TB-005` | `wait;` final | TC-003 (`run -all` termina) |
| `REQ-TB-006` | `variable erros` + resumo final | TC-003 (0 erros), TC-001b |
| `DEC-002` | ver sec. 3 | TC-002, TC-003 |
