# SPEC-VTB-04 — Testbench do Bloco 2: Verifica_tb

**Versão:** 1.0 — 2026-10-16
**Entidade:** `Verifica_tb` (sem portas) — ficheiro `Verifica_tb.vhd`
**DUT:** `Verifica` — [SPEC-VF-03](03_verifica.md)
**Ferramentas:** ModelSim / QuestaSim (análise `vcom`, simulação `vsim`)
**Estado:** Implementado e verificado

---

## 1. Descrição

Testbench **auto-verificável** e **sem portas** do Bloco 2, para simulação isolada da DUT. Fixa `D = "0101"` (autorizado em D0 e D2) e percorre os 4 valores de `S` (`00`..`11`), com 20 ns por estímulo, comparando `R` com o valor esperado e terminando com `wait;`.

## 2. Requisitos

| ID | Requisito |
|---|---|
| `REQ-VTB-001` | Ficheiro `Verifica_tb.vhd` com entidade de testbench **sem portas**: `entity Verifica_tb is end;`. |
| `REQ-VTB-002` | Instanciação da UUT: `UUT : entity work.Verifica` com `port map (D => D, S => S, R => R)`. |
| `REQ-VTB-003` | Atrasos de **20 ns** entre os testes (`constant TEMPO_ESTIMULO : time := 20 ns`). |
| `REQ-VTB-004` | Cenários com `D = "0101"` (D0 e D2 autorizados): `S="00"` → espera `R=1`; `S="01"` → espera `R=0`; `S="10"` → espera `R=1`; `S="11"` → espera `R=0`. |
| `REQ-VTB-005` | Auto-verificação: contagem de divergências (`variable erros`), relatório por teste (`OK`/`ERRO`) e resumo final (`SIMULACAO OK …` ou `severity failure`). |
| `REQ-VTB-006` | Comentários explicativos em cada teste (departamento ativo e justificação de `R`) e processo terminado com **`wait;`**. |

## 3. Decisões

### DEC-040 — Cenários e interface do testbench (2026-10-16) — solicitada

- **Conteúdo:** D fixa a `"0101"`, varrimento de `S` = `00`,`01`,`10`,`11` (4 testes × 20 ns = **80 ns**), entidade sem portas, `UUT`, `stim_proc` com procedimento `verificar` e `wait;` final.
- **Justificação:** requisito explícito do utilizador; `D="0101"` exercita simultaneamente os dois ramos que devem abrir (`D0`, `D2`) e os dois que devem fechar (`D1`, `D3`), cobrindo os 4 product-terms da equação.
- **Impacto:** `TC-VF-003` da [SPEC-VF-03](03_verifica.md) passa de PENDENTE a PASS.

### Decisões de implementação

- **VHDL-93** (padrão do ModelSim/Quartus): sem `to_string`; nos relatórios usa-se `std_logic'image(R)` (devolve `'1'`/`'0'`).
- **Procedimento `verificar(esperado, descricao)`** dentro de `stim_proc`: mantém o código dos 4 testes curto e idêntico; a contagem de erros só falha no fim (`severity failure`), dando resumo inequívoco.
- **`D` é aplicada uma única vez** antes do loop de testes (constante nos 4 cenários), tal como pedido.

## 4. Mapa do ficheiro

| Secção do ficheiro | Conteúdo | Requisito |
|---|---|---|
| cabeçalho + `library/use` | `ieee.std_logic_1164` | `REQ-VTB-001` |
| `entity … is end;` | entidade sem portas | `REQ-VTB-001` |
| arquitetura `sim`: sinais + constante | `D`, `S`, `R`, `TEMPO_ESTIMULO` (20 ns) | `REQ-VTB-003` |
| `UUT : entity work.Verifica` | instanciação da DUT | `REQ-VTB-002` |
| `stim_proc` — 4 testes | `D="0101"`, `S` 00→01→10→11, `wait for 20 ns`, `verificar` | `REQ-VTB-004`, `REQ-VTB-005`, `REQ-VTB-006` |
| `stim_proc` — fim | resumo (`SIMULACAO OK` / falha) → `wait;` | `REQ-VTB-005`, `REQ-VTB-006` |

## 5. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-VTB-001` | Análise sintática/semântica dos ficheiros sem erros (`vcom`). | **PASS** |
| `TC-VTB-002` | Simulação com `vsim -c`: 4/4 testes corretos, 0 erros, termina aos 80 ns com `wait;`. | **PASS** |

## 6. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando | Resultado |
|---|---|---|---|
| TC-VTB-001 | ModelSim-Altera 2020.1 | `vlib work` + `vcom -quiet Verifica.vhd Verifica_tb.vhd` | **PASS** — exit 0, sem erros |
| TC-VTB-002 | ModelSim-Altera 2020.1 | `vsim -c work.Verifica_tb -do "run -all; quit -f"` | **PASS** — 4 relatórios `OK: R='1'/'0'` (testes 1..4 a 20/40/60/80 ns); `=== SIMULACAO OK: 4/4 testes corretos, 0 erros ===`; **0 errors / 0 warnings**; fim aos **80 ns** |

## 7. Traçabilidade requisito → implementação → verificação

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-VTB-001` | cláusula da entidade | TC-VTB-001 |
| `REQ-VTB-002` | instância `UUT` | TC-VTB-001, TC-VTB-002 |
| `REQ-VTB-003` | `TEMPO_ESTIMULO = 20 ns` + 4 × `wait for` | TC-VTB-002 (fim aos 80 ns) |
| `REQ-VTB-004` | testes 1..4 (`S` = `00`,`01`,`10`,`11` com `D="0101"`) | TC-VTB-002 (4 relatórios) |
| `REQ-VTB-005` | `variable erros` + procedimento `verificar` + resumo final | TC-VTB-002 (0 erros) |
| `REQ-VTB-006` | comentários por teste + `wait;` final | TC-VTB-002 |
| `DEC-040` | ver sec. 3 | TC-VTB-001, TC-VTB-002 |

## 8. Correspondência com SPEC-VF-03

| Cenário | `D` | `S` | `R` esperado | Product-term exercitado |
|---|---|---|---|---|
| Teste 1 | `"0101"` | `"00"` | `1` | `D(0)·!S1·!S0` |
| Teste 2 | `"0101"` | `"01"` | `0` | `D(1)·!S1·S0` (D1=0) |
| Teste 3 | `"0101"` | `"10"` | `1` | `D(2)·S1·!S0` |
| Teste 4 | `"0101"` | `"11"` | `0` | `D(3)·S1·S0` (D3=0) |
