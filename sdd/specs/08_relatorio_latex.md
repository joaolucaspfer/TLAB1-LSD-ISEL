# SPEC-RP-08 — Relatório LaTeX do TLAB1

**Versão:** 1.0 — 2026-10-16
**Âmbito:** `template_relatorio/LSD_2627_template/report.tex` (+ `report.pdf`)
**Ferramenta:** pdfLaTeX (MiKTeX 24.1 local; compatível Overleaf)
**Estado:** Implementado e verificado

---

## 1. Descrição

Preenchimento do template oficial de relatório do TLAB1 (`LSD_2627_template`) com o conteúdo
completo do projeto *Sistema de Controlo de Acessos*: objetivo, descrição do circuito,
tabela de verdade global, simplificação lógica (mapas de Karnaugh), implementação VHDL,
resultados de simulação/síntese, conclusão, apêndices com as listagens VHDL e a atribuição de pinos.

**Restrição:** o preâmbulo, os estilos e os macros do template devem permanecer inalterados;
só o conteúdo (capa, corpo, apêndices) é editado. A codificação de ano do cabeçalho
(`2025/2026` → `2026/2027`) é corrigida por ser valor de conteúdo.

## 2. Requisitos

| ID | Requisito |
|---|---|
| `REQ-RP-001` | Manter o preâmbulo e os estilos do template intactos (só conteúdo). |
| `REQ-RP-002` | Capa com disciplina, ano, título do trabalho e autor. |
| `REQ-RP-003` | Secções do template na mesma ordem: Objetivo, Descrição, Desenvolvimento, Resultados e Discussão, Conclusão, Referências, Apêndice VHDL, Apêndice Pinos. |
| `REQ-RP-004` | Tabela de verdade global com as 16 linhas (Tabela 1). |
| `REQ-RP-005` | 4 mapas de Karnaugh (linhas `A3A2`, colunas `A1A0`, ordem de Gray) com os agrupamentos. |
| `REQ-RP-006` | Equações simplificadas de `D0..D3` e a equação de `R`. |
| `REQ-RP-007` | 6 listagens VHDL no apêndice (3 blocos + 3 testbenches) via `\lstinputlisting`. |
| `REQ-RP-008` | Tabela de atribuição de pinos no apêndice (7 pinos DE10-Lite). |
| `REQ-RP-009` | Compilar sem erros nem avisos críticos (Overleaf / pdfLaTeX). |

## 3. Decisões

### DEC-080 — Biblioteca de Karnaugh em modo tabular (2026-10-16) — solicitada

- **Conteúdo:** usar `\karnaughmaptab{4}{<id>}{{A3}{A2}{A1}{A0}}{<dados>}{<agrupamentos>}` em
  vez de `\karnaughmap` (modo recursivo). O modo recursivo intercala variáveis de linha e
  coluna (`label1,label3` = linhas), o que confunde a ordem. O modo tabular atribui as duas
  primeiras variáveis às barras laterais (linhas) e as duas últimas ao topo (colunas), e
  coloca o mintermo `m0` no canto superior esquerdo, como no padrão textbook.
- **Dados:** escritos na ordem de leitura do mapa (linhas de cima para baixo e colunas da
  esquerda para a direita, ambas em Gray `00,01,11,10`); `1` para valor 1, `{}` para 0.
- **Identificador:** o 2.º argumento de `\karnaughmaptab` é impresso como rótulo da função
  sobre o mapa; passa-se `{}` vazio para não exibir (como no exemplo do template).
- **Agrupamentos:** retângulos redesenhados com o estilo `grp` do template, centrados na
  caixa de cada célula (`x∈[coluna, coluna+1]`, `y∈[3−linha, 4−linha]`). Grupos que envolvem
  as colunas extremas (topologia toroidal) usam **dois** nós da mesma cor.

### DEC-081 — Cópias ASCII das listagens (2026-10-16) — solicitada

- **Conteúdo:** as cópias dos `.vhd` usadas no apêndice (`template_relatorio/.../vhdl/`) tiveram
  os caracteres não-ASCII dos comentários (em-dash `—`, `õ`, `…`, `º`) substituídos por equivalentes
  ASCII (`--`, `o`, `...`, `o`).
- **Justificação:** o pacote LaTeX `listings` não suporta UTF-8 e falhava com `Invalid UTF-8 byte`.
  Só os comentários são afetados; as fontes do repositório mantêm-se intactas e verificadas.
- **Impacto:** nenhum nas simulações/síntese (os `.vhd` originais não foram alterados).

## 4. Critérios de aceitação

| ID | Critério | Resultado |
|---|---|---|
| `TC-RP-001` | `pdflatex` ×2 sem erros e sem `Overfull`/`undefined reference`/`Missing character`. | **PASS** |
| `TC-RP-002` | As 16 linhas da tabela de verdade no PDF coincidem com a spec 00. | **PASS** |
| `TC-RP-003` | As células "1" dos 4 mapas no PDF coincidem com a tabela (verificação programática). | **PASS** |
| `TC-RP-004` | Os agrupamentos de cada mapa cobrem exatamente os mintermos previstos. | **PASS** |
| `TC-RP-005` | As 6 listagens VHDL e a tabela de pinos estão presentes. | **PASS** |

## 5. Registo de verificação (2026-10-16)

| TC | Ferramenta | Comando | Resultado |
|---|---|---|---|
| TC-RP-001 | pdfLaTeX (MiKTeX 24.1) | `pdflatex -interaction=nonstopmode report.tex` ×2 | **PASS** — `report.pdf` (18 páginas), `EXIT=0`, sem erros nem avisos |
| TC-RP-002 | PyMuPDF | extração de texto da tabela (página 5) | **PASS** — 16/16 linhas idênticas à spec 00 |
| TC-RP-003 | PyMuPDF | malha das células "1" dentro de cada caixa de mapa (págs. 6–8) | **PASS** — D0, D1, D2, D3 `MATCH` |
| TC-RP-004 | PyMuPDF | retângulos preenchidos por mapa vs mintermos | **PASS** — 5+4(+wrap 2 nós)+6+3 agrupamentos corretos |
| TC-RP-005 | PyMuPDF | legendas `VHDL 1..6` e tabela de pinos (pág. 18) | **PASS** |

## 6. Traçabilidade

| Requisito | Implementação | Verificação |
|---|---|---|
| `REQ-RP-001` | preâmbulo copiado do template | TC-RP-001 |
| `REQ-RP-002` | capa (titlepage) | manual |
| `REQ-RP-003` | secções + 2 subseções acrescentadas | manual |
| `REQ-RP-004` | `table` global (Tabela 1) | TC-RP-002 |
| `REQ-RP-005` | 4 × `\karnaughmaptab` (Figuras 2–5) | TC-RP-003, TC-RP-004 |
| `REQ-RP-006` | `align`/`equation` (equações 1–6) | TC-RP-003 |
| `REQ-RP-007` | 6 × `\lstinputlisting` | TC-RP-005 |
| `REQ-RP-008` | `table` de pinos (Tabela 3) | TC-RP-005 |
| `REQ-RP-009` | pdfLaTeX ×2 | TC-RP-001 |
