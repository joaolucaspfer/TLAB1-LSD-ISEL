# SPEC-QS-07 — Mapeamento Quartus para a placa Intel DE10-Lite (MAX 10)

**Versão:** 1.0 — 2026-10-16
**Entidade alvo:** `Controlo_Acessos` (top-level) — [SPEC-CA-05](05_controlo_acessos.md)
**Ficheiro:** `Controlo_Acessos.qsf` (raiz do repositório)
**Ferramenta:** Quartus Prime Lite 20.1
**Estado:** Implementado e verificado

---

## 1. Descrição

Atribuições do Quartus (`.qsf`) que mapeiam as portas do módulo principal `Controlo_Acessos` para os periféricos da placa **Intel DE10-Lite** (dispositivo MAX 10 `10M50DAF484C7G`): 6 interruptores (`SW0..SW5`) nas entradas e 1 LED (`LEDR0`) na saída.

## 2. Requisitos

| ID | Requisito |
|---|---|
| `REQ-QS-001` | Família `MAX 10`, dispositivo `10M50DAF484C7G` e `TOP_LEVEL_ENTITY Controlo_Acessos`. |
| `REQ-QS-002` | `A(3..0)` em `SW3, SW2, SW1, SW0` — `A3→PIN_C12`, `A2→PIN_C11`, `A1→PIN_D12`, `A0→PIN_C10`. |
| `REQ-QS-003` | `S(1..0)` em `SW5, SW4` — `S1→PIN_B12`, `S0→PIN_A12`. |
| `REQ-QS-004` | `R` em `LEDR0` — `PIN_A8`. |
| `REQ-QS-005` | Standard de E/S `3.3-V LVTTL` em todos os 7 pinos (nível da placa DE10-Lite). |
| `REQ-QS-006` | Incluir os 3 ficheiros `.vhd` (`Identifica_Departamento`, `Verifica`, `Controlo_Acessos`) como `VHDL_FILE` no mesmo `.qsf`. |
| `REQ-QS-007` | Verificação: síntese (`quartus_map`) e *fitter* (`quartus_fit`) sem erros, com os pinos atribuídos nas localizações pedidas. |

## 3. Decisões

### DEC-070 — Estrutura do `.qsf` (2026-10-16) — solicitada

- **Conteúdo:** um único ficheiro `Controlo_Acessos.qsf` com (a) definições globais (família, dispositivo, top, ficheiros), (b) `set_location_assignment` por pino e (c) `set_instance_assignment -name IO_STANDARD "3.3-V LVTTL"` por pino; comentários de cabeçalho e por bloco.
- **Justificação:** o utilizador pediu *linhas de atribuição do `.qsf`*; agrupar tudo num ficheiro pronto a usar permite abri-lo diretamente no Quartus (com um `.qpf` cuja revisão seja `Controlo_Acessos`).
- **Impacto:** nenhum em VHDL; a verificação faz-se com `quartus_map` + `quartus_fit` num projeto temporário.

### Decisões de implementação

- **Sem `.qpf` no repositório**: o `.qpf` é trivial de criar (revisão = `Controlo_Acessos`) e evita versões divergentes; as instruções estão no cabeçalho do `.qsf`.
- **Mapeamento posicional** exatamente como pedido: `A3..A0` = `SW3..SW0`, `S1..S0` = `SW5..SW4` (coincide com a tabela de pinos oficial da DE10-Lite).
- Warnings de projeto do *fitter* (AN 447 sobre 3.3 V, `Missing drive strength`) são informativos da plataforma e não bloqueiam — registados em `TC-QS-002`.

## 4. Atribuições (resumo)

| Porta | Sentido | Periférico | Pino | Atribuição Quartus |
|---|---|---|---|---|
| `A[3]` | entrada | SW3 | `PIN_C12` | `set_location_assignment PIN_C12 -to A[3]` |
| `A[2]` | entrada | SW2 | `PIN_C11` | `set_location_assignment PIN_C11 -to A[2]` |
| `A[1]` | entrada | SW1 | `PIN_D12` | `set_location_assignment PIN_D12 -to A[1]` |
| `A[0]` | entrada | SW0 | `PIN_C10` | `set_location_assignment PIN_C10 -to A[0]` |
| `S[1]` | entrada | SW5 | `PIN_B12` | `set_location_assignment PIN_B12 -to S[1]` |
| `S[0]` | entrada | SW4 | `PIN_A12` | `set_location_assignment PIN_A12 -to S[0]` |
| `R` | saída | LEDR0 | `PIN_A8` | `set_location_assignment PIN_A8 -to R` |

## 5. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-QS-001` | `quartus_map` sem erros com o `.qsf` (top = `Controlo_Acessos`, dispositivo DE10-Lite). | **PASS** |
| `TC-QS-002` | `quartus_fit` sem erros e tabela de pinos com os 7 pinos nas localizações da secção 4. | **PASS** |

## 6. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando | Resultado |
|---|---|---|---|
| TC-QS-001 | Quartus Prime Lite 20.1 | `quartus_map Controlo_Acessos` (proj. temporário com o `.qsf` do repositório + `.qpf` de revisão `Controlo_Acessos`) | **PASS** — `Analysis & Synthesis was successful. 0 errors` |
| TC-QS-002 | Quartus Prime Lite 20.1 | `quartus_fit Controlo_Acessos` + leitura de `Controlo_Acessos.fit.rpt` | **PASS** — `Quartus Prime Fitter was successful. 0 errors, 6 warnings` (AN 447 3.3 V e `Missing drive strength`, informativos); pinos confirmados: `A[3]=C12`, `A[2]=C11`, `A[1]=D12`, `A[0]=C10`, `S[1]=B12`, `S[0]=A12`, `R=A8`; I/O standard `3.3-V LVTTL` nos 7 pinos |

## 7. Traçabilidade requisito → implementação → verificação

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-QS-001` | `FAMILY`/`DEVICE`/`TOP_LEVEL_ENTITY` no `.qsf` | TC-QS-001 |
| `REQ-QS-002` | 4 × `set_location_assignment -to A[..]` | TC-QS-002 |
| `REQ-QS-003` | 2 × `set_location_assignment -to S[..]` | TC-QS-002 |
| `REQ-QS-004` | `set_location_assignment PIN_A8 -to R` | TC-QS-002 |
| `REQ-QS-005` | 7 × `IO_STANDARD "3.3-V LVTTL"` | TC-QS-002 |
| `REQ-QS-006` | 3 × `VHDL_FILE` | TC-QS-001 |
| `REQ-QS-007` | secções 5/6 | TC-QS-001, TC-QS-002 |
| `DEC-070` | ver sec. 3 | TC-QS-001, TC-QS-002 |

## 8. Teste manual na placa (não executado — pendente de hardware)

| Passo | Ação | Esperado |
|---|---|---|
| 1 | Programar o `.sof` na DE10-Lite | Programação OK |
| 2 | `SW = 000000` (func 0, dept 0) | `LEDR0` **aceso** (R=1) |
| 3 | `SW3..SW0=0000`, `SW5..SW4=01` (func 0, dept 1) | `LEDR0` **apagado** (R=0) |
| 4 | `SW3..SW0=0100`, `SW5..SW4=01` (func 4, dept 1) | `LEDR0` **aceso** |
| 5 | `SW3..SW0=0100`, `SW5..SW4=10` (func 4, dept 2) | `LEDR0` **aceso** |
| 6 | `SW3..SW0=1000`, `SW5..SW4=11` (func 8, dept 3) | `LEDR0` **aceso** |

(Cenários idênticos aos do testbench [SPEC-CTB-06](06_controlo_acessos_tb.md).)
