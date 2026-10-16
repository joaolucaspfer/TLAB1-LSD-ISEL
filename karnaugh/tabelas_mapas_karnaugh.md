# Relatório Técnico — TLAB1: Controlo de Acessos
**Disciplina:** Lógica e Sistemas Digitais (2026/2027) — ISEL

---

## 1. Tabela de Verdade Global

| Func. | $A_3$ | $A_2$ | $A_1$ | $A_0$ | Mintermo | Depts. Autorizados | $D_3$ | $D_2$ | $D_1$ | $D_0$ |
| :---: | :---: | :---: | :---: | :---: | :------: | :----------------: | :---: | :---: | :---: | :---: |
| **0**  | 0 | 0 | 0 | 0 | $m_0$    | $D_0$              | 0 | 0 | 0 | **1** |
| **1**  | 0 | 0 | 0 | 1 | $m_1$    | $D_2$              | 0 | **1** | 0 | 0 |
| **2**  | 0 | 0 | 1 | 0 | $m_2$    | $D_1$              | 0 | 0 | **1** | 0 |
| **3**  | 0 | 0 | 1 | 1 | $m_3$    | $D_3$              | **1** | 0 | 0 | 0 |
| **4**  | 0 | 1 | 0 | 0 | $m_4$    | $D_1, D_2$         | 0 | **1** | **1** | 0 |
| **5**  | 0 | 1 | 0 | 1 | $m_5$    | $D_2, D_0$         | 0 | **1** | 0 | **1** |
| **6**  | 0 | 1 | 1 | 0 | $m_6$    | $D_0$              | 0 | 0 | 0 | **1** |
| **7**  | 0 | 1 | 1 | 1 | $m_7$    | $D_2$              | 0 | **1** | 0 | 0 |
| **8**  | 1 | 0 | 0 | 0 | $m_8$    | $D_3$              | **1** | 0 | 0 | 0 |
| **9**  | 1 | 0 | 0 | 1 | $m_9$    | $D_3$              | **1** | 0 | 0 | 0 |
| **10** | 1 | 0 | 1 | 0 | $m_{10}$ | $D_0$              | 0 | 0 | 0 | **1** |
| **11** | 1 | 0 | 1 | 1 | $m_{11}$ | $D_2, D_0$         | 0 | **1** | 0 | **1** |
| **12** | 1 | 1 | 0 | 0 | $m_{12}$ | $D_2, D_0$         | 0 | **1** | 0 | **1** |
| **13** | 1 | 1 | 0 | 1 | $m_{13}$ | $D_1$              | 0 | 0 | **1** | 0 |
| **14** | 1 | 1 | 1 | 0 | $m_{14}$ | $D_2, D_1$         | 0 | **1** | **1** | 0 |
| **15** | 1 | 1 | 1 | 1 | $m_{15}$ | $D_1, D_3$         | **1** | 0 | **1** | 0 |

---

## 2. Grelha de Referência do Mapa de Karnaugh ($4 \times 4$)

A ordem de linhas e colunas segue a codificação de Gray ($00, 01, 11, 10$):

| $A_3 A_2 \backslash A_1 A_0$ | **00** | **01** | **11** | **10** |
| :--------------------------: | :----: | :----: | :----: | :----: |
| **00**                       | $m_0$  | $m_1$  | $m_3$  | $m_2$  |
| **01**                       | $m_4$  | $m_5$  | $m_7$  | $m_6$  |
| **11**                       | $m_{12}$ | $m_{13}$ | $m_{15}$ | $m_{14}$ |
| **10**                       | $m_8$  | $m_9$  | $m_{11}$ | $m_{10}$ |

---

## 3. Mapas de Karnaugh por Departamento

### 🟢 Mapa $D_0$ (Mintermos: $m_0, m_5, m_6, m_{10}, m_{11}, m_{12}$)

| $A_3 A_2 \backslash A_1 A_0$ | **00** | **01** | **11** | **10** |
| :--------------------------: | :----: | :----: | :----: | :----: |
| **00**                       | **1**  |   0    |   0    |   0    |
| **01**                       |   0    | **1**  |   0    | **1**  |
| **11**                       | **1**  |   0    |   0    |   0    |
| **10**                       |   0    |   0    | **1**  | **1**  |

**Equação Simplificada ($D_0$):**
$$D_0 = A_3 \cdot \overline{A_2} \cdot A_1 + A_2 \cdot \overline{A_1} \cdot A_0 + \overline{A_3} \cdot \overline{A_2} \cdot \overline{A_1} \cdot \overline{A_0} + \overline{A_3} \cdot A_2 \cdot A_1 \cdot \overline{A_0} + A_3 \cdot A_2 \cdot \overline{A_1} \cdot \overline{A_0}$$

---

### 🔵 Mapa $D_1$ (Mintermos: $m_2, m_4, m_{13}, m_{14}, m_{15}$)

| $A_3 A_2 \backslash A_1 A_0$ | **00** | **01** | **11** | **10** |
| :--------------------------: | :----: | :----: | :----: | :----: |
| **00**                       |   0    |   0    |   0    | **1**  |
| **01**                       | **1**  |   0    |   0    |   0    |
| **11**                       |   0    | **1**  | **1**  | **1**  |
| **10**                       |   0    |   0    |   0    |   0    |

**Equação Simplificada ($D_1$):**
$$D_1 = A_3 \cdot A_2 \cdot A_0 + A_3 \cdot A_2 \cdot A_1 + \overline{A_3} \cdot \overline{A_2} \cdot A_1 \cdot \overline{A_0} + \overline{A_3} \cdot A_2 \cdot \overline{A_1} \cdot \overline{A_0}$$

---

### 🟡 Mapa $D_2$ (Mintermos: $m_1, m_4, m_5, m_7, m_{11}, m_{12}, m_{14}$)

| $A_3 A_2 \backslash A_1 A_0$ | **00** | **01** | **11** | **10** |
| :--------------------------: | :----: | :----: | :----: | :----: |
| **00**                       |   0    | **1**  |   0    |   0    |
| **01**                       | **1**  | **1**  | **1**  |   0    |
| **11**                       | **1**  |   0    |   0    | **1**  |
| **10**                       |   0    |   0    | **1**  |   0    |

**Equação Simplificada ($D_2$):**
$$D_2 = A_2 \cdot \overline{A_1} \cdot \overline{A_0} + A_3 \cdot A_2 \cdot \overline{A_0} + \overline{A_3} \cdot \overline{A_1} \cdot A_0 + \overline{A_3} \cdot A_2 \cdot A_0 + A_3 \cdot \overline{A_2} \cdot A_1 \cdot A_0$$

---

### 🔴 Mapa $D_3$ (Mintermos: $m_3, m_8, m_9, m_{15}$)

| $A_3 A_2 \backslash A_1 A_0$ | **00** | **01** | **11** | **10** |
| :--------------------------: | :----: | :----: | :----: | :----: |
| **00**                       |   0    |   0    | **1**  |   0    |
| **01**                       |   0    |   0    |   0    |   0    |
| **11**                       |   0    |   0    | **1**  |   0    |
| **10**                       | **1**  | **1**  |   0    |   0    |

**Equação Simplificada ($D_3$):**
$$D_3 = A_3 \cdot \overline{A_2} \cdot \overline{A_1} + \overline{A_3} \cdot \overline{A_2} \cdot A_1 \cdot A_0 + A_3 \cdot A_2 \cdot A_1 \cdot A_0$$

---

## 4. Função do Bloco Verifica (Sinal $R$)

$$R = D_0 \cdot \overline{S_1} \cdot \overline{S_0} + D_1 \cdot \overline{S_1} \cdot S_0 + D_2 \cdot S_1 \cdot \overline{S_0} + D_3 \cdot S_1 \cdot S_0$$
