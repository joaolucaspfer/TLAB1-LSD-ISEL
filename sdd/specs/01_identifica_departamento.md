# SPEC-ID-01 — Bloco 1: Identifica_Departamento

**Versão:** 1.1 — 2026-10-16
**Entidade:** `Identifica_Departamento` — ficheiro `Identifica_Departamento.vhd`
**Testbench:** `Identifica_Departamento_tb.vhd` — especificação detalhada em [SPEC-TB-02](02_identifica_departamento_tb.md)
**Depende de:** [SPEC-PRJ-00](00_projeto_controlo_acessos.md)
**Estado:** Implementado e verificado

---

## 1. Descrição

Combinacional puro: decodifica o código do funcionário (`A`, 4 bits) para o vetor de permissões dos departamentos (`D`, 4 bits), segundo a tabela de verdade global do projeto.

## 2. Requisitos

### Interfaces

| ID | Requisito |
|---|---|
| `REQ-ID-001` | Usar exclusivamente a biblioteca `ieee.std_logic_1164.all`. |
| `REQ-ID-002` | Entidade `Identifica_Departamento` com entrada `A : in std_logic_vector(3 downto 0)` — `A(3)`=A3 … `A(0)`=A0 (código do funcionário 0..15) e saída `D : out std_logic_vector(3 downto 0)` — `D(3)`..`D(0)` = permissões D3..D0. |
| `REQ-ID-003` | Arquitetura `Behavioral` usando **atribuição concorrente** (atribuição direta de sinal), sem processos. |

### Funcionais (equações)

Equações definidas em `REQ-PRJ-003` + secção 4 deste documento. Cada product-term identifica os mintermos que cobre.

| ID | Equação |
|---|---|
| `REQ-ID-005` | `D(0) = A3·!A2·A1 + !A3·A2·!A1·A0 + !A3·!A2·!A1·!A0 + !A3·A2·A1·!A0 + A3·A2·!A1·!A0` |
| `REQ-ID-006` | `D(1) = A3·A2·A0 + A3·A2·A1 + !A3·!A2·A1·!A0 + !A3·A2·!A1·!A0` |
| `REQ-ID-007` | `D(2) = A2·!A1·!A0 + A3·A2·!A0 + !A3·!A1·A0 + !A3·A2·A0 + A3·!A2·A1·A0` |
| `REQ-ID-008` | `D(3) = A3·!A2·!A1 + !A3·!A2·A1·A0 + A3·A2·A1·A0` |

### Verificação

| ID | Requisito |
|---|---|
| `REQ-ID-009` | Testbench **[SPEC-TB-02](02_identifica_departamento_tb.md)** — resumo: `Identifica_Departamento_tb.vhd` **sem portas** (`entity Identifica_Departamento_tb is end;`), com UUT instanciado (`UUT : entity work.Identifica_Departamento`) e processo `stim_proc` que percorre **ciclicamente as 16 combinações** de entrada (funcionário 0 = `"0000"` … funcionário 15 = `"1111"`), com **20 ns** de atraso entre cada variação, **comentários identificando cada funcionário testado**, terminando com **`wait;`**. Compara ainda `D` com a tabela de verdade, assinalando qualquer divergência. |

## 3. Decisões de design

### DEC-001 — Correção do 2.º termo de D(0) (2026-10-16) — aprovada

- **Especificação original pedida:** `A2 AND NOT(A1) AND A0`
- **Especificação implementada:** `NOT(A3) AND A2 AND NOT(A1) AND A0`
- **Problema:** o termo original não contém `A3`, pelo que vale 1 para `m5 (0101)` **e** `m13 (1101)`. A tabela de verdade atribui ao funcionário 13 apenas D1 (D0=0), e a célula m13 do mapa de Karnaugh de D0 é 0 — logo o grupo `m5+m13` é inválido e o termo não é um implicant da função.
- **Justificação da correção:** m5 é um 1 isolado no mapa (vizinhos m1, m4, m7, m13 todos a 0), logo tem de ser coberto por `!A3·A2·!A1·A0`.
- **Impacto:** D(0) passa a coincidir com a tabela de verdade nos 16 códigos; D(1), D(2), D(3) inalterados (todos conferidos contra os mapas).

### DEC-002 — Interface e tempos do testbench (2026-10-16) — solicitada

- **Conteúdo:**
  - Entidade de testbench **sem portas**: `entity Identifica_Departamento_tb is end;`
  - Instanciação explícita da DUT: `UUT : entity work.Identifica_Departamento`
  - Processo de estímulos designado `stim_proc`, que percorre ciclicamente as 16 combinações (`0` → `"0000"` até `15` → `"1111"`)
  - Atraso de **20 ns** entre variações de `A` (anteriormente 10 ns)
  - Comentários identificando o funcionário testado em cada iteração
  - Termina com `wait;` para parar a simulação (`run -all` termina aos 320 ns)
- **Justificação:** requisito explícito do utilizador para uso em ModelSim/QuestaSim; 20 ns dá margem clara de observação por código e mantém a simulação curta.
- **Impacto:** `REQ-ID-009` reescrito; TC-003 re-executado com o novo ficheiro.

### Outras decisões

- Arquitetura única com atribuições concorrentes e operadores `and`/`or`/`not` (VHDL-93), sem `signal` intermédios — é a forma mais direta e a exigida em `REQ-ID-003`.
- Testbench sem clock (circuitos puramente combinacionais): `wait for 20 ns` entre estímulos (DEC-002) e verificação por código com `if/report`.

## 4. Equações com mintermos (design)

| Saída | Termos (product-terms) | Mintermos cobertos |
|---|---|---|
| D(0) | `A3·!A2·A1` | m10, m11 |
| | `!A3·A2·!A1·A0` | m5 |
| | `!A3·!A2·!A1·!A0` | m0 |
| | `!A3·A2·A1·!A0` | m6 |
| | `A3·A2·!A1·!A0` | m12 |
| D(1) | `A3·A2·A0` | m13, m15 |
| | `A3·A2·A1` | m14, m15 |
| | `!A3·!A2·A1·!A0` | m2 |
| | `!A3·A2·!A1·!A0` | m4 |
| D(2) | `A2·!A1·!A0` | m4, m12 |
| | `A3·A2·!A0` | m12, m14 |
| | `!A3·!A1·A0` | m1, m5 |
| | `!A3·A2·A0` | m5, m7 |
| | `A3·!A2·A1·A0` | m11 |
| D(3) | `A3·!A2·!A1` | m8, m9 |
| | `!A3·!A2·A1·A0` | m3 |
| | `A3·A2·A1·A0` | m15 |

## 5. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-001` | As 4 equações do ficheiro equivalem à tabela de verdade para os 16 códigos (script Python, parser de expressões VHDL). | **PASS** |
| `TC-002` | Análise sintática/semântica dos `.vhd` sem erros (`vcom`, ModelSim-Altera 20.1). | **PASS** |
| `TC-003` | Simulação do testbench (20 ns por estímulo): 16 funcionários, 0 divergências (`vsim -c`, termina aos 320 ns com `wait;`). | **PASS** |
| `TC-004` | Síntese sem erros de compilação (`quartus_map`, Quartus Prime Lite 20.1). | **PASS** |

## 6. Traçabilidade requisito → implementação → verificação

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-ID-001` | `Identifica_Departamento.vhd` (cláusulas `library/use`) | TC-002 |
| `REQ-ID-002` | declaração de portas da entidade | TC-002, TC-003 |
| `REQ-ID-003` | arquitetura `Behavioral`, 4 `D(i) <= ...` concorrentes | TC-002, TC-004 |
| `REQ-ID-005` | atribuição `D(0) <=` | TC-001, TC-003 |
| `REQ-ID-006` | atribuição `D(1) <=` | TC-001, TC-003 |
| `REQ-ID-007` | atribuição `D(2) <=` | TC-001, TC-003 |
| `REQ-ID-008` | atribuição `D(3) <=` | TC-001, TC-003 |
| `REQ-ID-009` | `Identifica_Departamento_tb.vhd` | TC-003 |
| `DEC-001` | 2.º termo de `D(0)` | TC-001 (código 13), TC-003 |
| `DEC-002` | `Identifica_Departamento_tb.vhd` (entidade sem portas, `UUT`, `stim_proc`, 20 ns, `wait;`) | TC-002, TC-003 |

## 7. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando / método | Resultado |
|---|---|---|---|
| TC-001 | Python 3 (script próprio) | parser recursivo-descendente das atribuições `D(i) <=` do `.vhd`, avaliação nos 16 códigos vs spec | **PASS** — `D(0): 1000011000111000`, `D(1): 0010100000000111`, `D(2): 0100110100011010`, `D(3): 0001000011000001` (iguais à spec) |
| TC-002 | ModelSim-Altera 2020.1 | `vcom -quiet Identifica_Departamento.vhd Identifica_Departamento_tb.vhd` | **PASS** — exit 0, sem erros |
| TC-003 | ModelSim-Altera 2020.1 | `vsim -c work.Identifica_Departamento_tb -do "run -all; quit -f"` (testbench revisto, DEC-002) | **PASS** — `SIMULACAO OK: 16/16 funcionarios corretos, 0 erros` (ciclo 0→15, 20 ns por estímulo, termina aos 320 ns com `wait;`; 0 errors/0 warnings) |
| TC-004 | Quartus Prime Lite 20.1 | `quartus_map identifica` (proj. temporário, `TOP_LEVEL_ENTITY = Identifica_Departamento`) | **PASS** — `Analysis & Synthesis was successful. 0 errors, 1 warning` (warning só de NUM_PARALLEL_PROCESSORS); 4 pins entrada, 4 pins saída, **4 logic cells** |
