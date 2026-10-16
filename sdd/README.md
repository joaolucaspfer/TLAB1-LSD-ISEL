# SDD — Controlo de Acessos (TLAB1)

**Disciplina:** Lógica e Sistemas Digitais (2026/2027) — ISEL
**Metodologia:** Spec-Driven Development (SDD) — a especificação é escrita primeiro e serve de referência para implementação, verificação e alterações.

---

## 1. Processo

Cada bloco do projeto percorre o ciclo:

```
SPEC  →  DESIGN  →  IMPLEMENT  →  VERIFY  →  LOG
 (1)      (2)        (3)          (4)       (5)
```

1. **SPEC** — escrever/atualizar o ficheiro em `sdd/specs/` com requisitos (`REQ-*`), decisões (`DEC-*`) e critérios de aceitação, *antes* do código.
2. **DESIGN** — equações, mapa de Karnaugh, escolha de arquitetura; registada na spec com justificação.
3. **IMPLEMENT** — gerar o ficheiro `.vhd`, com comentários que remetem para os requisitos.
4. **VERIFY** — correr verificação (equivale a tabela de verdade, análise sintática, simulação) e registar o resultado na spec e no CHANGELOG.
5. **LOG** — adicionar entrada em `sdd/CHANGELOG.md`.

Regras:

- **Tarefas grandes** (bloco/componente VHDL, testbench, feature multi-ficheiro): criar a spec
  em `sdd/specs/`, atualizar o índice/estado neste README e no `README.md` da raiz, e registar
  no CHANGELOG — sempre, sem exceção (pedido do utilizador, 2026-10-16).
- Uma alteração à especificação exige um novo `DEC-*` com justificação e data, e atualização do CHANGELOG.
- Nenhuma alteração de código sem o correspondente registo.
- Se a verificação falhar, é criado um `BUG-*` na spec com o estado (aberto/corrigido).

---

## 2. Convenções de identificadores

| Prefixo | Significado | Exemplo |
|---|---|---|
| `REQ-PRJ-*` | Requisito de projeto (nível sistema) | `REQ-PRJ-001` |
| `REQ-ID-*` | Requisito do bloco Identifica_Departamento | `REQ-ID-003` |
| `REQ-VF-*` | Requisito do bloco Verifica | `REQ-VF-001` |
| `REQ-VTB-*` | Requisito do testbench do bloco Verifica | `REQ-VTB-003` |
| `REQ-CA-*` | Requisito do módulo principal Controlo_Acessos | `REQ-CA-004` |
| `REQ-CTB-*` | Requisito do testbench do sistema global | `REQ-CTB-003` |
| `REQ-QS-*` | Requisito do mapeamento Quartus / placa | `REQ-QS-002` |
| `REQ-RP-*` | Requisito do relatório LaTeX | `REQ-RP-005` |
| `REQ-RP-*` | Requisito do relatório LaTeX | `REQ-RP-005` |
| `DEC-*` | Decisão de design/especificação | `DEC-001` |
| `BUG-*` | Defeito detetado na verificação | `BUG-001` |
| `TC-*` | Caso de teste | `TC-001` |

---

## 3. Índice de especificações

| Ficheiro | Âmbito | Estado |
|---|---|---|
| [`specs/00_projeto_controlo_acessos.md`](specs/00_projeto_controlo_acessos.md) | Visão geral do sistema, tabela de verdade global, blocos | Ativa |
| [`specs/01_identifica_departamento.md`](specs/01_identifica_departamento.md) | Bloco 1 — `Identifica_Departamento.vhd` | **Implementado e verificado** |
| [`specs/02_identifica_departamento_tb.md`](specs/02_identifica_departamento_tb.md) | Testbench do Bloco 1 — `Identifica_Departamento_tb.vhd` | **Implementado e verificado** |
| [`specs/03_verifica.md`](specs/03_verifica.md) | Bloco 2 — `Verifica` (sinal R) | **Implementado e verificado** |
| [`specs/04_verifica_tb.md`](specs/04_verifica_tb.md) | Testbench do Bloco 2 — `Verifica_tb.vhd` | **Implementado e verificado** |
| [`specs/05_controlo_acessos.md`](specs/05_controlo_acessos.md) | Módulo principal — `Controlo_Acessos.vhd` (top-level) | **Implementado e verificado** |
| [`specs/06_controlo_acessos_tb.md`](specs/06_controlo_acessos_tb.md) | Testbench do sistema global — `Controlo_Acessos_tb.vhd` | **Implementado e verificado** |
| [`specs/07_quartus_de10_lite.md`](specs/07_quartus_de10_lite.md) | Mapeamento Quartus p/ DE10-Lite — `Controlo_Acessos.qsf` | **Implementado e verificado** (teste na placa pendente) |
| [`specs/08_relatorio_latex.md`](specs/08_relatorio_latex.md) | Relatório LaTeX do TLAB1 — `template_relatorio/.../report.tex` | **Implementado e verificado** |

---

## 4. Estado de implementação

| Bloco | Ficheiro | Spec | Estado | Verificação |
|---|---|---|---|---|
| 1 — Identifica_Departamento | `Identifica_Departamento.vhd` | [01](specs/01_identifica_departamento.md) | Implementado | TC-001, TC-002, TC-004 ✔ |
| 1 — Testbench | `Identifica_Departamento_tb.vhd` | [02](specs/02_identifica_departamento_tb.md) | Implementado | TC-001b, TC-002, TC-003 ✔ |
| 2 — Verifica | `Verifica.vhd` | [03](specs/03_verifica.md) | Implementado | TC-VF-001, TC-VF-002, TC-VF-004 ✔ |
| 2 — Testbench | `Verifica_tb.vhd` | [04](specs/04_verifica_tb.md) | Implementado | TC-VTB-001, TC-VTB-002 ✔ (TC-VF-003 ✔) |
| Top-level — Controlo de acessos | `Controlo_Acessos.vhd` | [05](specs/05_controlo_acessos.md) | Implementado | TC-CA-001, TC-CA-002, TC-CA-003 ✔ |
| Top-level — Testbench | `Controlo_Acessos_tb.vhd` | [06](specs/06_controlo_acessos_tb.md) | Implementado | TC-CTB-001, TC-CTB-002 ✔ |
| Mapeamento DE10-Lite | `Controlo_Acessos.qsf` | [07](specs/07_quartus_de10_lite.md) | Implementado | TC-QS-001, TC-QS-002 ✔ (teste manual pendente) |
| Relatório LaTeX | `template_relatorio/.../report.tex` | [08](specs/08_relatorio_latex.md) | Implementado | TC-RP-001..005 ✔ |

---

## 5. Ferramentas de verificação (validadas a 2026-10-16)

- **Equivalência lógica:** script Python com parser de expressões VHDL vs tabela de verdade (`TC-001`).
- **Análise sintática/semântica:** ModelSim-Altera 2020.1 `vcom` (`TC-002`).
- **Simulação:** ModelSim-Altera 2020.1 `vsim -c` com o testbench (`TC-003`).
- **Síntese:** Quartus Prime Lite 20.1 `quartus_map` (`TC-004`).

Resultados detalhados: secção 7 da spec de cada bloco + entradas `VERIFY` do [CHANGELOG](CHANGELOG.md).
