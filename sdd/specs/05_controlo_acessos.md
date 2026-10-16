# SPEC-CA-05 — Módulo principal: Controlo_Acessos

**Versão:** 1.0 — 2026-10-16
**Entidade:** `Controlo_Acessos` — ficheiro `Controlo_Acessos.vhd`
**Testbench:** gerado temporariamente para verificação (não versionado) — os testes ficam registados em `TC-CA-003`
**Depende de:** [SPEC-PRJ-00](00_projeto_controlo_acessos.md), [SPEC-ID-01](01_identifica_departamento.md), [SPEC-VF-03](03_verifica.md)
**Estado:** Implementado e verificado

---

## 1. Descrição

Módulo **top-level** do sistema: instancia os dois blocos existentes e liga a saída de permissões `D` do `Identifica_Departamento` à entrada `D` do `Verifica` através de um sinal interno (`internal_D`). Ligação puramente estrutural, sem lógica própria.

## 2. Requisitos

| ID | Requisito |
|---|---|
| `REQ-CA-001` | Ficheiro e entidade `Controlo_Acessos` (`Controlo_Acessos.vhd`). |
| `REQ-CA-002` | Entradas externas: `A : in std_logic_vector(3 downto 0)` (código do funcionário) e `S : in std_logic_vector(1 downto 0)` (departamento ativo). |
| `REQ-CA-003` | Saída externa: `R : out std_logic` (cancela). |
| `REQ-CA-004` | Arquitetura `Behavioral` (interpretada como estrutural) com **instanciação de componentes** via `entity work.Identifica_Departamento` e `entity work.Verifica`. |
| `REQ-CA-005` | Sinal interno `internal_D : std_logic_vector(3 downto 0)` que liga a saída `D` do Bloco 1 à entrada `D` do Bloco 2. |
| `REQ-CA-006` | Usar `ieee.std_logic_1164.all`. |
| `REQ-CA-007` | Verificação: equivalência do sistema completo com a tabela de verdade global (64 combinações), `vcom` e `quartus_map`. |

## 3. Decisões de design

### DEC-050 — Estilo estrutural e sinal interno (2026-10-16) — solicitada

- **Conteúdo:** arquitetura `Behavioral` com apenas duas instâncias diretas (`U_IDENTIFICA`, `U_VERIFICA`) e um `signal internal_D : std_logic_vector(3 downto 0)` a ligar `D` do Bloco 1 a `D` do Bloco 2; sem sinais nem lógica adicionais.
- **Justificação:** requisito explícito do utilizador; mantém `S` a ser a única seleção de departamento (`R = D(S)`) e preserva a separação de responsabilidades dos dois blocos já verificados.
- **Impacto:** nenhuma alteração às specs 01/03; o sistema completo colapsa em **1 logic cell** na síntese (a tabela de verdade global já era o resultado combinado dos dois blocos).

### Outras decisões

- **Rótulos de instância** `U_IDENTIFICA` e `U_VERIFICA` para leitura fácil em simulação/relatório.
- **Instanciação direta** (`entity work.X`) em vez de `component` + `configuration`: menos código, mesmo resultado, alinhado com os testbenches do projeto.

## 4. Mapa do ficheiro

| Secção do ficheiro | Conteúdo | Requisito |
|---|---|---|
| cabeçalho + `library/use` | `ieee.std_logic_1164` | `REQ-CA-006` |
| `entity Controlo_Acessos` | `A`, `S`, `R` | `REQ-CA-002`, `REQ-CA-003` |
| arquitetura — declarativa | `signal internal_D` | `REQ-CA-005` |
| arquitetura — `U_IDENTIFICA` | `entity work.Identifica_Departamento port map (A => A, D => internal_D)` | `REQ-CA-004`, `REQ-CA-005` |
| arquitetura — `U_VERIFICA` | `entity work.Verifica port map (D => internal_D, S => S, R => R)` | `REQ-CA-004`, `REQ-CA-005` |

## 5. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-CA-001` | Análise sintática/semântica dos 3 ficheiros sem erros (`vcom`). | **PASS** |
| `TC-CA-002` | Síntese do top-level sem erros (`quartus_map`). | **PASS** |
| `TC-CA-003` | Simulação do sistema completo: `R` igual à tabela de verdade global nas 64 combinações. | **PASS** |

## 6. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando / método | Resultado |
|---|---|---|---|
| TC-CA-001 | ModelSim-Altera 2020.1 | `vcom -quiet Identifica_Departamento.vhd Verifica.vhd Controlo_Acessos.vhd Controlo_Acessos_tb.vhd` | **PASS** — exit 0, sem erros |
| TC-CA-003 | ModelSim-Altera 2020.1 | `vsim -c work.Controlo_Acessos_tb -do "run -all; quit -f"` (TB temporário: 16×4 combinações de `A`/`S`, 20 ns por estímulo, `R` comparado com `D(A)(S)` da tabela de verdade) | **PASS** — `=== TOP OK: 64/64 corretos ===`; **0 errors / 0 warnings**; fim aos **1280 ns** |
| TC-CA-002 | Quartus Prime Lite 20.1 | `quartus_map ca` (proj. temporário, `TOP_LEVEL_ENTITY = Controlo_Acessos`, 3 ficheiros) | **PASS** — `Analysis & Synthesis was successful. 0 errors, 1 warning` (só NUM_PARALLEL_PROCESSORS); **6 input pins, 1 output pin, 1 logic cell** |

## 7. Traçabilidade requisito → implementação → verificação

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-CA-001` | `Controlo_Acessos.vhd` (entidade homónima) | TC-CA-001 |
| `REQ-CA-002` | portas `A`, `S` | TC-CA-001, TC-CA-003 |
| `REQ-CA-003` | porta `R` | TC-CA-001, TC-CA-003 |
| `REQ-CA-004` | `U_IDENTIFICA` / `U_VERIFICA` (`entity work.*`) | TC-CA-001, TC-CA-002 |
| `REQ-CA-005` | `signal internal_D` nas duas `port map` | TC-CA-003 |
| `REQ-CA-006` | cláusulas `library/use` | TC-CA-001 |
| `REQ-CA-007` | secções 5/6 | TC-CA-001, TC-CA-002, TC-CA-003 |
| `DEC-050` | ver sec. 3 | TC-CA-002 (1 logic cell), TC-CA-003 |
