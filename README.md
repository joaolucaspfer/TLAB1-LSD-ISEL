# Controlo de Acessos — TLAB1

Projeto **VHDL** de *Controlo de Acessos* para a discipliplina de **Lógica e Sistemas Digitais** (2026/2027) do ISEL.

O sistema recebe o código de um funcionário (`A`, 4 bits → 0..15) e indica os departamentos a que esse funcionário tem acesso (`D`, 4 bits: `D3..D0`). Um segundo bloco (`Verifica`, pendente) confirmará o acesso ao departamento selecionado (`S1..S0`) através do sinal `R`.

## Estrutura do repositório

```
.
├── .gitignore                         # Ignora artefactos do Quartus/ModelSim
├── Identifica_Departamento.vhd        # Bloco 1 — DUT (behavioral, combinacional)
├── Identifica_Departamento_tb.vhd     # Testbench auto-verificável (16 funcionários)
├── tabelas_mapas_kernaugh.md          # Relatório: tabela de verdade + mapas de Karnaugh
├── tabelas_mapas_kernaugh.pdf         #     "      (versão PDF)
├── tabelas_mapas_kernaugh.tex         #     "      (fonte LaTeX)
└── sdd/                               # Spec-Driven Development
    ├── README.md                      # Processo SDD, convenções de IDs, estado
    ├── CHANGELOG.md                   # Registo datado de specs/código/verificação
    └── specs/
        ├── 00_projeto_controlo_acessos.md         # Spec de projeto (tabela global, blocos)
        ├── 01_identifica_departamento.md          # Spec do Bloco 1 (REQ/DEC/TC + traçabilidade)
        └── 02_identifica_departamento_tb.md       # Spec do testbench (REQ-TB/TC + traçabilidade)
```

## Bloco 1 — `Identifica_Departamento`

| Porta | Direção | Tipo | Significado |
|---|---|---|---|
| `A` | in | `std_logic_vector(3 downto 0)` | Código do funcionário (`A3..A0`, 0..15) |
| `D` | out | `std_logic_vector(3 downto 0)` | Permissões (`D3..D0`, 1 = autorizado) |

Arquitetura `Behavioral` com atribuições concorrentes (apenas `and`, `or`, `not`), a partir das equações simplificadas por mapas de Karnaugh — ver [spec do bloco](sdd/specs/01_identifica_departamento.md) e [relatório](tabelas_mapas_kernaugh.md).

> **Nota (DEC-001):** o segundo termo de `D(0)` foi corrigido para `NOT(A3) AND A2 AND NOT(A1) AND A0`
> — a versão original (`A2 AND NOT(A1) AND A0`) daria acesso de `D0` ao funcionário 13, contrariando a tabela de verdade. Detalhe em [sdd/specs/01_identifica_departamento.md](sdd/specs/01_identifica_departamento.md).

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

## Verificação (2026-10-16)

| TC | Ferramenta | Resultado |
|---|---|---|
| TC-001 — Equivalência lógica das equações vs tabela de verdade (16 códigos) | Script Python | PASS |
| TC-002 — Análise sintática/semântica | `vcom` (ModelSim 2020.1) | PASS |
| TC-003 — Simulação do testbench (16/16, 0 erros) | `vsim -c` | PASS |
| TC-004 — Síntese (4 logic cells, 4 in / 4 out pins) | `quartus_map` (Quartus Prime Lite 20.1) | PASS |

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
| 2 — Verificação de acesso | `Verifica` | ⏳ Pendente |

## Licença / Uso

Material académico do ISEL — disciplina Lógica e Sistemas Digitais, ano letivo 2026/2027.
