# SPEC-VF-03 — Bloco 2: Verifica

**Versão:** 1.0 — 2026-10-16
**Entidade:** `Verifica` — ficheiro `Verifica.vhd`
**Testbench:** ainda não criado
**Depende de:** [SPEC-PRJ-00](00_projeto_controlo_acessos.md)
**Estado:** Implementado e verificado (sem testbench)

---

## 1. Descrição

Combinacional puro: valida se o departamento ativo no sistema (`S`, 2 bits) está autorizado no vetor de permissões (`D`, 4 bits) e gera o sinal de controlo da cancela (`R`: 1 = Abre, 0 = Fechada).

## 2. Requisitos

### Interfaces

| ID | Requisito |
|---|---|
| `REQ-VF-001` | Usar exclusivamente a biblioteca `ieee.std_logic_1164.all`. |
| `REQ-VF-002` | Entidade `Verifica` com entrada `D : in std_logic_vector(3 downto 0)` (departamentos autorizados), entrada `S : in std_logic_vector(1 downto 0)` (departamento ativo: `00`=D0, `01`=D1, `10`=D2, `11`=D3) e saída `R : out std_logic` (1 = Abre, 0 = Fechada). |
| `REQ-VF-003` | Arquitetura `Behavioral` com **atribuição concorrente** (sem processos) que implemente exatamente a equação de `REQ-PRJ-004`. |

### Funcional (equação)

| ID | Equação |
|---|---|
| `REQ-VF-004` | `R = (D(0) AND NOT(S(1)) AND NOT(S(0))) OR (D(1) AND NOT(S(1)) AND S(0)) OR (D(2) AND S(1) AND NOT(S(0))) OR (D(3) AND S(1) AND S(0))` |

### Verificação

| ID | Requisito |
|---|---|
| `REQ-VF-005` | Equivalência lógica da equação implementada vs. `R = D(S)` para todas as 64 combinações (16 × 4). |
| `REQ-VF-006` | Análise sintática/semântica sem erros (`vcom`, ModelSim-Altera 20.1). |
| `REQ-VF-007` | Síntese sem erros de compilação (`quartus_map`, Quartus Prime Lite 20.1). |

## 3. Decisões de design

### DEC-030 — Implementação direta da equação (2026-10-16)

- **Conteúdo:** arquitetura `Behavioral` com uma única atribuição concorrente `R <= ...` traduzindo literalmente os 4 product-terms da equação de `REQ-PRJ-004`/`REQ-VF-004`, usando apenas `and`/`or`/`not` (VHDL-93) e sem sinais intermédios nem processos.
- **Justificação:** a equação já é o resultado simplificado do mapa de Karnaugh (`tabelas_mapas_kernaugh.md`); qualquer reescrita só acresentaria risco sem ganho de área (a síntese usa 1 logic cell).
- **Impacto:** nenhuma alteração à especificação; `REQ-VF-003` e `REQ-VF-004` satisfeitos de forma idêntica ao Bloco 1 (mesmo estilo de código).

### Outras decisões

- Comentários no cabeçalho do `.vhd` identificam o que cada product-term cobre (`S=00` → D0, …), para rastreabilidade com a secção 4.
- Testbench do Bloco 2 **não foi pedido**; fica registado como pendente (quando existir, segue o padrão da [SPEC-TB-02](02_identifica_departamento_tb.md)).

## 4. Equação com mintermos (design)

| Saída | Product-term | Condição de S | Departamento |
|---|---|---|---|
| R | `D(0)·!S1·!S0` | `S = 00` | D0 |
| | `D(1)·!S1·S0` | `S = 01` | D1 |
| | `D(2)·S1·!S0` | `S = 10` | D2 |
| | `D(3)·S1·S0` | `S = 11` | D3 |

Cada termo só é avaliado para o bit de `D` correspondente ao departamento selecionado — `R` é, por construção, `D(S)`.

## 5. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-VF-001` | Equivalência da equação vs. `R = D(S)` nas 64 combinações (script Python). | **PASS** |
| `TC-VF-002` | Análise sintática/semântica do `.vhd` sem erros (`vcom`). | **PASS** |
| `TC-VF-003` | Simulação com testbench (auto-verificação das 64 combinações). | **PENDENTE** — sem testbench |
| `TC-VF-004` | Síntese sem erros de compilação (`quartus_map`). | **PASS** |

## 6. Traçabilidade requisito → implementação → verificação

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-VF-001` | `Verifica.vhd` (cláusulas `library/use`) | TC-VF-002 |
| `REQ-VF-002` | declaração de portas da entidade | TC-VF-002 |
| `REQ-VF-003` | arquitetura `Behavioral`, atribuição concorrente `R <=` | TC-VF-002, TC-VF-004 |
| `REQ-VF-004` | expressão da atribuição `R <=` (4 product-terms) | TC-VF-001 |
| `REQ-VF-005` | ver sec. 4 | TC-VF-001 |
| `REQ-VF-006` | — | TC-VF-002 |
| `REQ-VF-007` | — | TC-VF-004 |
| `DEC-030` | ver sec. 3 | TC-VF-001, TC-VF-004 |

## 7. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando / método | Resultado |
|---|---|---|---|
| TC-VF-001 | Python 3 (script próprio) | avaliação da equação VHDL vs. `R = D(S)` nas 16×4 = 64 combinações | **PASS** — 0 divergências em 64 combinações |
| TC-VF-002 | ModelSim-Altera 2020.1 | `vlib work` + `vcom -quiet Verifica.vhd` | **PASS** — exit 0, sem erros |
| TC-VF-004 | Quartus Prime Lite 20.1 | `quartus_map vf` (proj. temporário, `TOP_LEVEL_ENTITY = Verifica`) | **PASS** — `Analysis & Synthesis was successful. 0 errors, 1 warning` (warning só de NUM_PARALLEL_PROCESSORS); **6 input pins, 1 output pin, 1 logic cell** |
