# Controlo de Acessos - TLAB1

Projeto VHDL de um sistema combinacional de controlo de acessos.

## Ficheiros principais

| Ficheiro | Funcao |
|---|---|
| `Identifica_Departamento.vhd` | Converte o codigo `A` do funcionario no vetor de permissoes `D` |
| `Verifica.vhd` | Consulta, atraves de `S`, a permissao correspondente e produz `R` |
| `Controlo_Acessos.vhd` | Top-level que liga os dois blocos |
| `Controlo_Acessos_tb.vhd` | Testbench global auto-verificavel |
| `Controlo_Acessos.qsf` | Configuracao Quartus e pinos da DE10-Lite |
| `template_relatorio/LSD_2627_template/report.pdf` | Relatorio final |
| `template_relatorio/LSD_2627_template/report.tex` | Fonte do relatorio |

## Interface

| Sinal | Significado |
|---|---|
| `A[3..0]` | Codigo do funcionario, de 0 a 15 |
| `S[1..0]` | Departamento selecionado: `00`=D0, `01`=D1, `10`=D2, `11`=D3 |
| `R` | Resultado: `1`=acesso autorizado, `0`=acesso negado |

O primeiro bloco calcula `D`, o vetor de permissoes. O segundo implementa
`R = D(S)`, isto e, seleciona a permissao do departamento indicado por `S`.

## Simulacao

No ModelSim/QuestaSim:

```tcl
vlib work
vcom Identifica_Departamento.vhd Verifica.vhd Controlo_Acessos.vhd Controlo_Acessos_tb.vhd
vsim work.Controlo_Acessos_tb
run -all
```

O resultado esperado e:

```text
SIMULACAO OK: 5/5 cenarios corretos, 0 erros
```

## DE10-Lite

O ficheiro `Controlo_Acessos.qsf` configura o dispositivo MAX 10
`10M50DAF484C7G`, define `Controlo_Acessos` como top-level e mapeia:

| Sinal | Elemento | Pino |
|---|---|---|
| `A[3]` | SW3 | `PIN_C12` |
| `A[2]` | SW2 | `PIN_C11` |
| `A[1]` | SW1 | `PIN_D12` |
| `A[0]` | SW0 | `PIN_C10` |
| `S[1]` | SW5 | `PIN_B12` |
| `S[0]` | SW4 | `PIN_A12` |
| `R` | LEDR0 | `PIN_A8` |

No Quartus:

1. abrir/criar o projeto com este `.qsf`;
2. confirmar `Controlo_Acessos` como top-level;
3. compilar com `Processing > Start Compilation`;
4. gerar o `.sof`;
5. programar a placa com `Tools > Programmer`.

Os testbenches nao devem ser usados como top-level da placa.
