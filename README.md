# Controlo de Acessos — TLAB1

Projeto **VHDL** de *Controlo de Acessos* para a discipliplina de **Lógica e Sistemas Digitais** (2026/2027) do ISEL.

O sistema recebe o código de um funcionário (`A`, 4 bits → 0..15) e indica os departamentos a que esse funcionário tem acesso (`D`, 4 bits: `D3..D0`). O segundo bloco (`Verifica`) confirma o acesso ao departamento selecionado (`S1..S0`) e gera o sinal `R` (1 = cancela abre). O módulo principal **`Controlo_Acessos`** (top-level) interliga os dois blocos pelo sinal interno `internal_D`.

## Estrutura do repositório

```
.
├── .gitignore                         # Ignora artefactos do Quartus/ModelSim
├── Identifica_Departamento.vhd        # Bloco 1 — DUT (behavioral, combinacional)
├── Identifica_Departamento_tb.vhd     # Testbench auto-verificável (16 funcionários)
├── Verifica.vhd                       # Bloco 2 — DUT (behavioral, combinacional)
├── Verifica_tb.vhd                    # Testbench auto-verificável do Bloco 2 (4 cenários)
├── Controlo_Acessos.vhd               # Top-level — interliga Bloco 1 e Bloco 2 (structural)
├── Controlo_Acessos_tb.vhd            # Testbench auto-verificável do sistema (5 cenários)
├── Controlo_Acessos.qsf               # Atribuições Quartus — placa Intel DE10-Lite (MAX 10)
├── tabelas_mapas_kernaugh.md          # Relatório: tabela de verdade + mapas de Karnaugh
├── tabelas_mapas_kernaugh.pdf         #     "      (versão PDF)
├── tabelas_mapas_kernaugh.tex         #     "      (fonte LaTeX)
└── sdd/                               # Spec-Driven Development
    ├── README.md                      # Processo SDD, convenções de IDs, estado
    ├── CHANGELOG.md                   # Registo datado de specs/código/verificação
    └── specs/
        ├── 00_projeto_controlo_acessos.md         # Spec de projeto (tabela global, blocos)
        ├── 01_identifica_departamento.md          # Spec do Bloco 1 (REQ/DEC/TC + traçabilidade)
        ├── 02_identifica_departamento_tb.md       # Spec do testbench (REQ-TB/TC + traçabilidade)
        ├── 03_verifica.md                         # Spec do Bloco 2 (REQ-VF/TC + traçabilidade)
        ├── 04_verifica_tb.md                      # Spec do testbench do Bloco 2 (REQ-VTB/TC)
        ├── 05_controlo_acessos.md                 # Spec do top-level (REQ-CA/TC + traçabilidade)
        ├── 06_controlo_acessos_tb.md              # Spec do testbench global (REQ-CTB/TC)
        └── 07_quartus_de10_lite.md                # Spec do mapeamento DE10-Lite (REQ-QS/TC)
```

## Bloco 1 — `Identifica_Departamento`

| Porta | Direção | Tipo | Significado |
|---|---|---|---|
| `A` | in | `std_logic_vector(3 downto 0)` | Código do funcionário (`A3..A0`, 0..15) |
| `D` | out | `std_logic_vector(3 downto 0)` | Permissões (`D3..D0`, 1 = autorizado) |

Arquitetura `Behavioral` com atribuições concorrentes (apenas `and`, `or`, `not`), a partir das equações simplificadas por mapas de Karnaugh — ver [spec do bloco](sdd/specs/01_identifica_departamento.md) e [relatório](tabelas_mapas_kernaugh.md).

> **Nota (DEC-001):** o segundo termo de `D(0)` foi corrigido para `NOT(A3) AND A2 AND NOT(A1) AND A0`
> — a versão original (`A2 AND NOT(A1) AND A0`) daria acesso de `D0` ao funcionário 13, contrariando a tabela de verdade. Detalhe em [sdd/specs/01_identifica_departamento.md](sdd/specs/01_identifica_departamento.md).

## Bloco 2 — `Verifica`

| Porta | Direção | Tipo | Significado |
|---|---|---|---|
| `D` | in | `std_logic_vector(3 downto 0)` | Departamentos autorizados (`D3..D0`) |
| `S` | in | `std_logic_vector(1 downto 0)` | Departamento ativo (`00`=D0 … `11`=D3) |
| `R` | out | `std_logic` | Sinal da cancela (`1` = Abre, `0` = Fechada) |

Arquitetura `Behavioral` com atribuição concorrente a partir da equação `REQ-PRJ-004`:
`R = D(0)·!S1·!S0 + D(1)·!S1·S0 + D(2)·S1·!S0 + D(3)·S1·S0` — ou seja, `R = D(S)`.
Detalhe em [spec 03](sdd/specs/03_verifica.md). Testbench isolado em [`Verifica_tb.vhd`](Verifica_tb.vhd)
([spec 04](sdd/specs/04_verifica_tb.md)): `D = "0101"`, `S` = `00`..`11`, 20 ns por teste, auto-verificado (4/4 → `SIMULACAO OK`, fim aos 80 ns).

## Módulo principal — `Controlo_Acessos` (top-level)

| Porta | Direção | Tipo | Significado |
|---|---|---|---|
| `A` | in | `std_logic_vector(3 downto 0)` | Código do funcionário (`A3..A0`, 0..15) |
| `S` | in | `std_logic_vector(1 downto 0)` | Departamento ativo (`00`=D0 … `11`=D3) |
| `R` | out | `std_logic` | Cancela (`1` = Abre, `0` = Fechada) |

Arquitetura `Behavioral` (estrutural): instancia `U_IDENTIFICA` (`entity work.Identifica_Departamento`)
e `U_VERIFICA` (`entity work.Verifica`), ligados pelo sinal interno `internal_D` — ver [spec 05](sdd/specs/05_controlo_acessos.md).

## Simulação (ModelSim / QuestaSim)

```tcl
vlib work
vcom Identifica_Departamento.vhd Identifica_Departamento_tb.vhd
vsim work.Identifica_Departamento_tb
run -all
```

O testbench é **auto-verificável** ([spec 02](sdd/specs/02_identifica_departamento_tb.md)): percorre os 16 funcionários (0 = `"0000"` … 15 = `"1111"`) com 20 ns por estímulo, compara `D` com a tabela de verdade e termina com `wait;` (simulação acaba aos **320 ns**).

Saída esperada (fim da simulação):

```text
# ** Note: === SIMULACAO OK: 16/16 funcionarios corretos, 0 erros ===
```

No **Quartus Prime**: adicionar os ficheiros `.vhd` ao projeto e definir `Identifica_Departamento` como *top-level entity*.

### Bloco 2 — `Verifica`

```tcl
vlib work
vcom Verifica.vhd Verifica_tb.vhd
vsim work.Verifica_tb
run -all
```

Saída esperada (fim da simulação, 80 ns):

```text
# ** Note: === SIMULACAO OK: 4/4 testes corretos, 0 erros ===
```

### Módulo principal — `Controlo_Acessos`

```tcl
vlib work
vcom Identifica_Departamento.vhd Verifica.vhd Controlo_Acessos.vhd Controlo_Acessos_tb.vhd
vsim work.Controlo_Acessos_tb
run -all
```

O testbench é **auto-verificável** ([spec 06](sdd/specs/06_controlo_acessos_tb.md)): 5 cenários
reais (func. 0/4/8 em deps. 0/1/2/3) com 20 ns por cenário — saída esperada aos **100 ns**:

```text
# ** Note: === SIMULACAO OK: 5/5 cenarios corretos, 0 erros ===
```

Verificação adicional (`TC-CA-003`, [spec 05](sdd/specs/05_controlo_acessos.md)): testbench
temporário com as 64 combinações de `A`/`S` vs tabela de verdade → `=== TOP OK: 64/64 corretos ===`
(fim aos 1280 ns).

No **Quartus Prime**: adicionar os 3 ficheiros `.vhd` ao projeto e definir `Controlo_Acessos`
como *top-level entity* (nos testes de cada bloco isolado, usar esse bloco como top-level).

## Mapeamento na placa Intel DE10-Lite (MAX 10)

O ficheiro [`Controlo_Acessos.qsf`](Controlo_Acessos.qsf) ([spec 07](sdd/specs/07_quartus_de10_lite.md))
contém as atribuições para a DE10-Lite (dispositivo `10M50DAF484C7G`):

| Porta | Sentido | Periférico | Pino |
|---|---|---|---|
| `A[3]` | entrada | SW3 | `PIN_C12` |
| `A[2]` | entrada | SW2 | `PIN_C11` |
| `A[1]` | entrada | SW1 | `PIN_D12` |
| `A[0]` | entrada | SW0 | `PIN_C10` |
| `S[1]` | entrada | SW5 | `PIN_B12` |
| `S[0]` | entrada | SW4 | `PIN_A12` |
| `R` | saída | LEDR0 | `PIN_A8` |

Todos os pinos com `IO_STANDARD "3.3-V LVTTL"`. Para programar: criar/abrir o projeto
Quartus com revisão `Controlo_Acessos`, incluir o `.qsf` e os 3 ficheiros `.vhd`,
correr `Processing > Start Compilation` e programar o `.sof` (`Tools > Programmer`).

## Verificação (2026-10-16)

| TC | Ferramenta | Resultado |
|---|---|---|
| TC-001 — Equivalência lógica das equações vs tabela de verdade (16 códigos) | Script Python | PASS |
| TC-002 — Análise sintática/semântica | `vcom` (ModelSim 2020.1) | PASS |
| TC-003 — Simulação do testbench (16/16, 0 erros) | `vsim -c` | PASS |
| TC-004 — Síntese (4 logic cells, 4 in / 4 out pins) | `quartus_map` (Quartus Prime Lite 20.1) | PASS |
| TC-VF-001 — Equivalência de `R` vs `D(S)` (64 combinações) | Script Python | PASS |
| TC-VF-002 — Análise sintática/semântica de `Verifica.vhd` | `vcom` (ModelSim 2020.1) | PASS |
| TC-VF-004 — Síntese de `Verifica` (1 logic cell, 6 in / 1 out pins) | `quartus_map` (Quartus Prime Lite 20.1) | PASS |
| TC-VF-003 / TC-VTB-001 — Análise do testbench do Bloco 2 | `vcom` (ModelSim 2020.1) | PASS |
| TC-VTB-002 — Simulação do Bloco 2 (4/4 testes, 0 erros, 80 ns) | `vsim -c` | PASS |
| TC-CA-001 — Análise sintática/semântica do top-level (3 ficheiros) | `vcom` (ModelSim 2020.1) | PASS |
| TC-CA-003 — Simulação do sistema completo (64/64 combinações, 1280 ns) | `vsim -c` | PASS |
| TC-CA-002 — Síntese do top-level (1 logic cell, 6 in / 1 out pins) | `quartus_map` (Quartus Prime Lite 20.1) | PASS |
| TC-CTB-001 — Análise sintática/semântica do testbench global (4 ficheiros) | `vcom` (ModelSim 2020.1) | PASS |
| TC-CTB-002 — Simulação global (5/5 cenários, 0 erros, 100 ns) | `vsim -c` | PASS |
| TC-QS-001 — Síntese com o `.qsf` da DE10-Lite | `quartus_map` (Quartus Prime Lite 20.1) | PASS |
| TC-QS-002 — Fitter e pinos (7 pinos mapeados, 0 errors) | `quartus_fit` (Quartus Prime Lite 20.1) | PASS |

## Metodologia — SDD (Spec-Driven Development)

A especificação é escrita **antes** do código e serve de referência para implementação e verificação:

```
SPEC → DESIGN → IMPLEMENT → VERIFY → LOG
```

- Requisitos `REQ-*`, decisões `DEC-*`, casos de teste `TC-*`
- Toda a alteração fica registada no [`sdd/CHANGELOG.md`](sdd/CHANGELOG.md)
- Cada bloco tem a sua spec com **traçabilidade** requisito → código → verificação

Ver [`sdd/README.md`](sdd/README.md) para o processo completo e convenções.

## Estado do projeto

| Bloco | Entidade | Estado |
|---|---|---|
| 1 — Identificação de departamento | `Identifica_Departamento` | ✅ Implementado e verificado |
| 2 — Verificação de acesso | `Verifica` | ✅ Implementado e verificado |
| 2 — Testbench | `Verifica_tb` | ✅ Implementado e verificado |
| Top-level — Módulo principal | `Controlo_Acessos` | ✅ Implementado e verificado |
| Top-level — Testbench | `Controlo_Acessos_tb` | ✅ Implementado e verificado |
| Mapeamento DE10-Lite | `Controlo_Acessos.qsf` | ✅ Implementado e verificado (teste manual na placa pendente) |

## Licença / Uso

Material académico do ISEL — disciplina Lógica e Sistemas Digitais, ano letivo 2026/2027.
