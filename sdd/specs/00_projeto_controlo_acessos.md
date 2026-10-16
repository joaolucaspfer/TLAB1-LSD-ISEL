# SPEC-PRJ-00 — Controlo de Acessos (TLAB1)

**Versão:** 1.0 — 2026-10-16
**Fonte de verdade:** `tabelas_mapas_kernaugh.md` (relatório técnico TLAB1)
**Estado:** Ativa

---

## 1. Objetivo

Sistema de controlo de acessos que, a partir do código de um funcionário (`A`, 4 bits → 0..15), indica que departamentos (`D3..D0`) esse funcionário tem permissão para aceder, e valida o acesso quando o utilizador seleciona um departamento específico (sinal `R`).

## 2. Diagrama de blocos

```
                +----------------------+
  A[3..0] ----->| Identifica_Departamento |-----> D[3..0]  (permissões)
  (código)      +----------------------+
                          |
                          v
                +----------------------+
  S[1..0] ----->|       Verifica       |-----> R          (acesso concedido)
  (dept. sel.)  +----------------------+
```

## 3. Requisitos de projeto

| ID | Requisito | Origem |
|---|---|---|
| `REQ-PRJ-001` | O código de funcionário é uma entrada binária de 4 bits `A(3..0)`, representando os valores 0 a 15. | Tabela 1 |
| `REQ-PRJ-002` | A saída de permissões é `D(3..0)`, um bit por departamento D3, D2, D1, D0 (1 = autorizado). | Tabela 1 |
| `REQ-PRJ-003` | A tabela de verdade global (secção 4) é a especificação de referência de todos os blocos. | Tabela 1 |
| `REQ-PRJ-004` | O bloco `Verifica` gera `R = D0·!S1·!S0 + D1·!S1·S0 + D2·S1·!S0 + D3·S1·S0`. | Secção 4.2 |

## 4. Tabela de verdade global (especificação de referência)

| Func. | A3 | A2 | A1 | A0 | Mintermo | Depts. | D3 | D2 | D1 | D0 |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 0 | m0 | D0 | 0 | 0 | 0 | 1 |
| 1 | 0 | 0 | 0 | 1 | m1 | D2 | 0 | 1 | 0 | 0 |
| 2 | 0 | 0 | 1 | 0 | m2 | D1 | 0 | 0 | 1 | 0 |
| 3 | 0 | 0 | 1 | 1 | m3 | D3 | 1 | 0 | 0 | 0 |
| 4 | 0 | 1 | 0 | 0 | m4 | D1, D2 | 0 | 1 | 1 | 0 |
| 5 | 0 | 1 | 0 | 1 | m5 | D2, D0 | 0 | 1 | 0 | 1 |
| 6 | 0 | 1 | 1 | 0 | m6 | D0 | 0 | 0 | 0 | 1 |
| 7 | 0 | 1 | 1 | 1 | m7 | D2 | 0 | 1 | 0 | 0 |
| 8 | 1 | 0 | 0 | 0 | m8 | D3 | 1 | 0 | 0 | 0 |
| 9 | 1 | 0 | 0 | 1 | m9 | D3 | 1 | 0 | 0 | 0 |
| 10 | 1 | 0 | 1 | 0 | m10 | D0 | 0 | 0 | 0 | 1 |
| 11 | 1 | 0 | 1 | 1 | m11 | D2, D0 | 0 | 1 | 0 | 1 |
| 12 | 1 | 1 | 0 | 0 | m12 | D2, D0 | 0 | 1 | 0 | 1 |
| 13 | 1 | 1 | 0 | 1 | m13 | D1 | 0 | 0 | 1 | 0 |
| 14 | 1 | 1 | 1 | 0 | m14 | D2, D1 | 0 | 1 | 1 | 0 |
| 15 | 1 | 1 | 1 | 1 | m15 | D1, D3 | 1 | 0 | 1 | 0 |

## 5. Blocos planeados

| # | Bloco | Entidade | Ficheiro | Estado |
|---|---|---|---|---|
| 1 | Identificação de departamento | `Identifica_Departamento` | `Identifica_Departamento.vhd` | Implementado — [spec 01](01_identifica_departamento.md) |
| 2 | Verificação de acesso | `Verifica` | `Verifica.vhd` | Pendente |

## 6. Critérios de aceitação do projeto

- `REQ-PRJ-AC1`: Todos os blocos simulam sem erros e cumprem a tabela da secção 4 para os 16 códigos.
- `REQ-PRJ-AC2`: O projeto compila e sintetiza no Quartus Prime Lite 20.1 sem erros críticos.
