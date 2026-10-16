# SPEC-CTB-06 — Testbench do sistema global: Controlo_Acessos_tb

**Versão:** 1.0 — 2026-10-16
**Entidade:** `Controlo_Acessos_tb` (sem portas) — ficheiro `Controlo_Acessos_tb.vhd`
**DUT:** `Controlo_Acessos` — [SPEC-CA-05](05_controlo_acessos.md)
**Ferramentas:** ModelSim / QuestaSim (análise `vcom`, simulação `vsim`)
**Estado:** Implementado e verificado

---

## 1. Descrição

Testbench **auto-verificável** e **sem portas** do sistema global. Instancia `Controlo_Acessos` e percorre 5 cenários reais de acesso (funcionário × departamento ativo) com 20 ns por estímulo, comparando `R` com o valor esperado da tabela de verdade global e terminando com `wait;`.

## 2. Requisitos

| ID | Requisito |
|---|---|
| `REQ-CTB-001` | Instanciar a entidade `Controlo_Acessos` (`UUT : entity work.Controlo_Acessos`, portas `A`, `S`, `R`). |
| `REQ-CTB-002` | Cenários: Func. 0 (`"0000"`) + Dept 0 (`"00"`) → `R=1`; Func. 0 + Dept 1 (`"01"`) → `R=0`; Func. 4 (`"0100"`) + Dept 1 → `R=1`; Func. 4 + Dept 2 (`"10"`) → `R=1`; Func. 8 (`"1000"`) + Dept 3 (`"11"`) → `R=1`. |
| `REQ-CTB-003` | Intervalos de **20 ns** entre cenários (`constant TEMPO_ESTIMULO : time := 20 ns`). |
| `REQ-CTB-004` | Auto-verificação: contagem de divergências, relatório por cenário (`OK`/`ERRO`) e resumo final (`SIMULACAO OK …` ou `severity failure`). |
| `REQ-CTB-005` | Comentários com o **resultado esperado** em cada cenário e processo terminado com **`wait;`**. |

## 3. Decisões

### DEC-060 — Seleção dos 5 cenários (2026-10-16) — solicitada

- **Conteúdo:** cenários 1 e 2 (func. 0, permissões `0001`) cobrem um acesso concedido e outro negado no mesmo funcionário; cenários 3 e 4 (func. 4, permissões `0110`) cobrem os dois departamentos em que está autorizado; cenário 5 (func. 8, permissões `1000`) cobre D3.
- **Justificação:** requisito explícito do utilizador; o conjunto exercita `R=0` e `R=1`, os dois blocos e 3 dos 4 valores de `S`, com valores de `A` retirados da tabela de verdade global (SPEC-PRJ-00 sec. 4).
- **Impacto:** 5 cenários × 20 ns = **100 ns** de simulação.

### Decisões de implementação

- **VHDL-93**: relatórios com `std_logic'image(R)` (sem `to_string`).
- Mesmo padrão dos testbenches 01/04: entidade sem portas, `UUT`, `stim_proc` com procedimento `verificar(esperado, descricao)`, contagem de erros e `wait;` final.
- **Complementar** ao testbench temporário de 64 combinações usado em `TC-CA-003` ([SPEC-CA-05](05_controlo_acessos.md)); este é o TB permanente versionado no repositório.

## 4. Mapa do ficheiro

| Secção do ficheiro | Conteúdo | Requisito |
|---|---|---|
| cabeçalho + `library/use` | `ieee.std_logic_1164` | — |
| `entity … is end;` | entidade sem portas | — |
| arquitetura `sim`: sinais + constante | `A`, `S`, `R`, `TEMPO_ESTIMULO` (20 ns) | `REQ-CTB-003` |
| `UUT : entity work.Controlo_Acessos` | instanciação do DUT | `REQ-CTB-001` |
| `stim_proc` — 5 cenários | `A`/`S` → `wait for 20 ns` → `verificar` | `REQ-CTB-002`, `REQ-CTB-003`, `REQ-CTB-004`, `REQ-CTB-005` |
| `stim_proc` — fim | resumo (`SIMULACAO OK` / falha) → `wait;` | `REQ-CTB-004`, `REQ-CTB-005` |

## 5. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-CTB-001` | Análise sintática/semântica dos 4 ficheiros sem erros (`vcom`). | **PASS** |
| `TC-CTB-002` | Simulação com `vsim -c`: 5/5 cenários corretos, 0 erros, termina aos 100 ns com `wait;`. | **PASS** |

## 6. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando | Resultado |
|---|---|---|---|
| TC-CTB-001 | ModelSim-Altera 2020.1 | `vcom -quiet Identifica_Departamento.vhd Verifica.vhd Controlo_Acessos.vhd Controlo_Acessos_tb.vhd` | **PASS** — exit 0, sem erros |
| TC-CTB-002 | ModelSim-Altera 2020.1 | `vsim -c work.Controlo_Acessos_tb -do "run -all; quit -f"` | **PASS** — 5 relatórios `OK: R='1'/'0'` (cenários 1..5 a 20/40/60/80/100 ns); `=== SIMULACAO OK: 5/5 cenarios corretos, 0 erros ===`; **0 errors / 0 warnings**; fim aos **100 ns** |

## 7. Traçabilidade requisito → implementação → verificação

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-CTB-001` | instância `UUT` | TC-CTB-001, TC-CTB-002 |
| `REQ-CTB-002` | cenários 1..5 | TC-CTB-002 (5 relatórios) |
| `REQ-CTB-003` | `TEMPO_ESTIMULO = 20 ns` + 5 × `wait for` | TC-CTB-002 (fim aos 100 ns) |
| `REQ-CTB-004` | `variable erros` + procedimento `verificar` + resumo | TC-CTB-002 (0 erros) |
| `REQ-CTB-005` | comentários com resultado esperado + `wait;` | TC-CTB-002 |
| `DEC-060` | ver sec. 3 | TC-CTB-002 |

## 8. Cenários e correspondência com a tabela de verdade

| Cenário | A | S | Permissões `D` (tabela) | `R` esperado | Justificação |
|---|---|---|---|---|---|
| 1 | `"0000"` | `"00"` | `0001` (D0) | `1` | Func. 0 autorizado em D0 → cancela abre |
| 2 | `"0000"` | `"01"` | `0001` (D0) | `0` | Func. 0 sem permissão em D1 → fecha |
| 3 | `"0100"` | `"01"` | `0110` (D1, D2) | `1` | Func. 4 autorizado em D1 → abre |
| 4 | `"0100"` | `"10"` | `0110` (D1, D2) | `1` | Func. 4 autorizado em D2 → abre |
| 5 | `"1000"` | `"11"` | `1000` (D3) | `1` | Func. 8 autorizado em D3 → abre |
