# CHANGELOG — SDD

Registo cronológico das alterações à especificação e ao código.
Formato: data — tipo (`SPEC`/`CODE`/`DOCS`/`VERIFY`/`BUG`) — descrição.

---

## 2026-10-16

### SPEC
- Criada a estrutura SDD (`sdd/README.md`, `sdd/specs/`, `sdd/CHANGELOG.md`).
- Criada a spec de projeto [`specs/00_projeto_controlo_acessos.md`](specs/00_projeto_controlo_acessos.md) a partir de `tabelas_mapas_kernaugh.md` (tabela de verdade global, mapas, função R do bloco Verifica).
- Criada a spec do Bloco 1 [`specs/01_identifica_departamento.md`](specs/01_identifica_departamento.md): portas, arquitetura `Behavioral`, equações de D3..D0 e critérios de aceitação (`REQ-ID-001..008`).
- **DEC-001** — corrigido o 2.º termo de D(0) da equação originalmente pedido:
  - `A2 AND NOT(A1) AND A0` → `NOT(A3) AND A2 AND NOT(A1) AND A0`.
  - Justificação: o termo original evalua a 1 no código 13 (`1101`), mas a tabela de verdade atribui D0=0 ao funcionário 13 (só D1); o grupo `m5+m13` é inválido porque m13=0 no mapa de Karnaugh de D0 e m5 é um 1 isolado.
  - Aprovada pelo utilizador.

### CODE
- Criado `Identifica_Departamento.vhd` (entidade + arquitetura `Behavioral`, atribuições concorrentes com `and`/`or`/`not`, conforme `REQ-ID-002`, `REQ-ID-005..008`).
- Criado `Identifica_Departamento_tb.vhd` (varrimento dos 16 códigos, asserções contra a tabela de verdade, conforme `REQ-ID-009`).

### VERIFY
- TC-001 — Equivalência lógica das 4 equações vs tabela de verdade (16 códigos, parser de expressões VHDL): **PASS** — `D(0)..D(3)` idênticos à spec nos 16 códigos; constante `ESPERADO` do testbench também validada.
- TC-002 — Análise sintática/semântica dos 2 ficheiros com `vcom` (ModelSim-Altera 2020.1): **PASS** — exit 0, sem erros nem warnings.
- TC-003 — Simulação do testbench com `vsim -c`: **PASS** — `SIMULACAO OK: 16/16 codigos corretos, 0 erros` (170 ns, 0 errors / 0 warnings).
- TC-004 — Síntese com `quartus_map` (Quartus Prime Lite 20.1, projeto temporário, top = `Identifica_Departamento`): **PASS** — `Analysis & Synthesis was successful. 0 errors`; recursos: 4 input pins, 4 output pins, 4 logic cells.

---

## 2026-10-16 (revisão 2) — Testbench com novos requisitos

### SPEC
- **DEC-002** — fixada a interface e tempos do testbench: entidade **sem portas** (`entity Identifica_Departamento_tb is end;`), instanciação `UUT : entity work.Identifica_Departamento`, processo `stim_proc`, ciclo único pelas 16 combinações (funcionário 0 = `"0000"` … 15 = `"1111"`) com atraso de **20 ns** entre variações (antes 10 ns), comentários por funcionário e `wait;` final.
- `REQ-ID-009` reescrito para refletir os novos requisitos; secção 7 da [spec 01](specs/01_identifica_departamento.md) e traçabilidade atualizadas.

### CODE
- `Identifica_Departamento_tb.vhd` reescrito: rotina `stim_proc` com loop 0..15, `UUT`, tabela `ESPERADO` comentada por funcionário, `report` de traço por código e `wait;` no fim. Mantida a verificação automática (auto-checking) com contagem de erros.

### VERIFY
- TC-001 — **PASS** (reexecutado; script corrigido para extrair a tabela `ESPERADO` ignorando os códigos binários dos comentários).
- TC-002 — **PASS** (`vcom`, ambos os ficheiros, exit 0).
- TC-003 — **PASS** — `SIMULACAO OK: 16/16 funcionarios corretos, 0 erros`; traço `Funcionario 0..15 | A | D | esperado`; ciclo de 16×20 ns, termina aos **320 ns** com `wait;` (0 errors / 0 warnings).
- TC-004 — sem alteração (o testbench não é sintetizado; DUT inalterado).

---

## 2026-10-16 (revisão 3) — Spec do testbench + documentação GitHub

### SPEC
- Criada [`specs/02_identifica_departamento_tb.md`](specs/02_identifica_departamento_tb.md) (SPEC-TB-02): formaliza os requisitos do testbench definidos na revisão 2 (`REQ-TB-001..006` = DEC-002: entidade sem portas, `UUT`, `stim_proc`, 20 ns, comentários por funcionário, `wait;`), mais a auto-verificação (`REQ-TB-006`), mapa do ficheiro, critérios e registo de verificação (TC-002, TC-003, TC-001b) e tabela de traçabilidade.
- Índice do `sdd/README.md` atualizado: `02` passa a ser a spec do testbench; o bloco `Verifica` passa para `specs/03_verifica.md` (pendente). Corrigida a linha do testbench na tabela de estado (verificação era TC-004 → passa a TC-001b/TC-002/TC-003).
- Referência cruzada adicionada à SPEC-ID-01 (cabeçalho e `REQ-ID-009` apontam para SPEC-TB-02).

### DOCS
- Criado `README.md` na raiz para o GitHub: visão geral do projeto, árvore de ficheiros, portas do Bloco 1, comandos de simulação (ModelSim/QuestaSim) e de síntese (Quartus), tabela de resultados TC-001..TC-004, metodologia SDD e estado dos blocos.
- Criado `.gitignore` para artefactos do Quartus (`db/`, `incremental_db/`, `output_files/`, `*.sof`, `*.rpt`, …) e do ModelSim (`work/`, `transcript`, `*.wlf`, …), mantendo `*.qpf`/`*.qsf` trackeáveis; validado com `git check-ignore` — nenhum ficheiro do repositório é apanhado.

### VERIFY
- Sem alterações de código: TC-001..TC-004 mantêm-se **PASS** (apenas documentação).

---

## 2026-10-16 (revisão 4) — Bloco 2: Verifica

### SPEC
- Criada [`specs/03_verifica.md`](specs/03_verifica.md) (SPEC-VF-03): interface (`D` 4 bits, `S` 2 bits, `R` 1 bit), equação `R = D(S)` em 4 product-terms (`REQ-VF-001..007`), **DEC-030** (implementação direta da equação, atribuição concorrente, sem sinais intermédios), critérios `TC-VF-001..004`, mapa do ficheiro e traçabilidade.
- Atualizados o índice e a tabela de estado do `sdd/README.md` e a tabela de blocos da [SPEC-PRJ-00](specs/00_projeto_controlo_acessos.md): Bloco 2 passa a **Implementado e verificado** (testbench pendente).

### CODE
- Criado `Verifica.vhd` (entidade `Verifica` + arquitetura `Behavioral`, atribuição concorrente `R <=` com os 4 termos `D(i) AND S-decodificado`, conforme `REQ-VF-001..004`), com comentários que identificam o departamento coberto por cada termo.

### VERIFY
- TC-VF-001 — Equivalência da equação vs. `R = D(S)` nas 64 combinações (16×4, script Python): **PASS** — 0 divergências.
- TC-VF-002 — Análise sintática/semântica com `vcom` (ModelSim-Altera 2020.1): **PASS** — exit 0, sem erros.
- TC-VF-004 — Síntese com `quartus_map` (Quartus Prime Lite 20.1, projeto temporário, top = `Verifica`): **PASS** — `0 errors, 1 warning` (só NUM_PARALLEL_PROCESSORS); 6 input pins, 1 output pin, **1 logic cell**.
- TC-VF-003 — **PENDENTE**: testbench do Bloco 2 ainda não criado.

### DOCS
- Criado `AGENTS.md` na raiz e registada a **regra SDD**: toda a tarefa grande exige spec em `sdd/specs/`, atualização do `sdd/README.md` + `README.md` da raiz e entrada no CHANGELOG. Regra também adicionada à secção 1 (Regras) do `sdd/README.md`.

---

## 2026-10-16 (revisão 5) — Testbench do Bloco 2

### SPEC
- Criada [`specs/04_verifica_tb.md`](specs/04_verifica_tb.md) (SPEC-VTB-04): entidade sem portas, `UUT`, `stim_proc` com procedimento `verificar`, 4 cenários com `D="0101"` e `S` = `00`..`11` a 20 ns (`REQ-VTB-001..006`), **DEC-040**, critérios `TC-VTB-001/002`, mapa do ficheiro, traçabilidade e correspondência com os product-terms da SPEC-VF-03.
- [SPEC-VF-03](specs/03_verifica.md) atualizada (v1.1): cabeçalho liga ao testbench, `TC-VF-003` passa de PENDENTE a **PASS** (secção 7) e a decisão sobre o testbench deixa de estar pendente.
- `sdd/README.md`: novo prefixo `REQ-VTB-*`, índice com a spec 04 e linha de testbench na tabela de estado.

### CODE
- Criado `Verifica_tb.vhd` (testbench auto-verificável sem portas, conforme `REQ-VTB-001..006`): `D="0101"`, varrimento de `S` com 20 ns por teste, contagem de erros, resumo `SIMULACAO OK` e `wait;` final.

### VERIFY
- TC-VTB-001 — Análise sintática/semântica com `vcom` (ModelSim-Altera 2020.1): **PASS** — exit 0, sem erros.
- TC-VTB-002 / TC-VF-003 — Simulação com `vsim -c work.Verifica_tb`: **PASS** — 4 testes OK (`S=00→R=1`, `S=01→R=0`, `S=10→R=1`, `S=11→R=0`), `SIMULACAO OK: 4/4 testes corretos, 0 erros`, fim aos **80 ns**, 0 errors / 0 warnings.
