# AGENTS.md — Instruções do projeto (TLAB1)

## Regra SDD (pedido explícito do utilizador, 2026-10-16)

Sempre que o utilizador pedir uma tarefa **grande** (criação de bloco/componente VHDL,
testbench, feature multi-ficheiro, alteração de especificação), é **obrigatório**:

1. **SPEC** — criar/atualizar a spec correspondente em `sdd/specs/` (`REQ-*`, `DEC-*`, `TC-*`)
   antes ou imediatamente a seguir ao código.
2. **README** — atualizar o índice/estado em `sdd/README.md` e a tabela de estado no
   `README.md` da raiz.
3. **LOG** — acrescentar entrada (`SPEC`/`CODE`/`VERIFY`) em `sdd/CHANGELOG.md`.

Tarefas pequenas (correções pontuais, uma linha) continuam a ser registadas apenas se
alterarem especificação ou código relevante — ver processo completo em `sdd/README.md`.

## Convenções

- Specs numeradas: `00` projeto, `01`..`NN` por bloco/testbench; prefixos de ID em
  `sdd/README.md` secção 2.
- Verificação obrigatória antes de registar PASS: equivalência (Python), `vcom`
  (ModelSim-Altera 20.1), `quartus_map` (Quartus Prime Lite 20.1); testbench com `vsim -c`.
