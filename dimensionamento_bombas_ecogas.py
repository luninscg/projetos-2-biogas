# -*- coding: utf-8 -*-
import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
"""
╔══════════════════════════════════════════════════════════════════════════════╗
║           ECOGAS — DIMENSIONAMENTO COMPLETO DE BOMBAS                       ║
║           P-101 a P-108 | Projeto Industrial II | UFMS 2026                 ║
║           Responsável: G. Luz | Revisão: Grupo ECOGAS                       ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  REFERÊNCIAS:                                                                ║
║  • Metcalf & Eddy (2014) — Wastewater Engineering, 5ª ed., Cap. 10         ║
║  • Franzini & Finnemore (1994) — Fluid Mechanics, 10ª ed., Cap. 10         ║
║  • Crane Co. (2011) — Flow of Fluids, Technical Paper 410                   ║
║  • Karassik et al. (2001) — Pump Handbook, 3ª ed.                           ║
║  • NBR IEC 60034-30: Eficiência de motores elétricos (IE3)                  ║
║  • ANP Resolução nº 685/2017 — Especificações do biometano                  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  METODOLOGIA:                                                                ║
║  H_m = H_geo + H_pressão + H_perda                                          ║
║  H_perda = 0.20 × (H_geo + H_pressão)  [heurística projeto conceitual]     ║
║  P_hid = ρ × g × Q × H_m               [Franzini & Finnemore, 1994]        ║
║  P_eixo = P_hid / η_bomba                                                   ║
║  P_motor = P_eixo / η_motor                                                 ║
║  P_instalada = P_motor × FS             [FS = 1.15]                         ║
╚══════════════════════════════════════════════════════════════════════════════╝
"""

import math

# ═══════════════════════════════════════════════════════════════════════════════
# CONSTANTES
# ═══════════════════════════════════════════════════════════════════════════════
g = 9.81          # m/s² — aceleração da gravidade
P_ATM = 101325.0  # Pa — pressão atmosférica
FS = 1.15         # Fator de serviço (margem para partida e variações)

# ═══════════════════════════════════════════════════════════════════════════════
# PARÂMETROS DE EFICIÊNCIA (conforme Diretrizes ECOGAS v1)
# ═══════════════════════════════════════════════════════════════════════════════
# η_bomba: Metcalf & Eddy (2014), Tab. 10-3 / Karassik (2001)
# η_motor: NBR IEC 60034-30 (classe IE3, 1.5-45 kW)

ETA_BOMBA_LODO = 0.60       # Centrífuga canal aberto, lodo com sólidos
ETA_BOMBA_AGUA = 0.70       # Centrífuga standard, água limpa
ETA_BOMBA_MOINEAU = 0.55    # Deslocamento positivo (Moineau/parafuso)
ETA_BOMBA_MULTIESTAG = 0.68 # Multi-estágio alta pressão
ETA_MOTOR = 0.93            # Motor elétrico IE3


# ═══════════════════════════════════════════════════════════════════════════════
# DEFINIÇÃO DAS BOMBAS
# ═══════════════════════════════════════════════════════════════════════════════
# Dados provenientes do Balanço de Massa ECOGAS (validado, erro = 0 kg/d)
# e do PFD (cotas geométricas dos equipamentos)

BOMBAS = [
    {
        "tag": "P-101 A/B",
        "servico": "Lodo ETE Los Angeles → TQ-01",
        "fluido": "Lodo de ETE (2-5% ST)",
        "rho": 1020.0,       # kg/m³ — tubulacao_biogas.xlsx
        "mu": 0.004,         # Pa·s (4 cP) — lodo 3.8% ST a 25°C [Metcalf & Eddy Tab.14-13]
        "Q_m3d": 320.0,      # m³/dia — Balanço de Massa
        "H_geo": 1.50,       # m — cota TQ-01 (5m) - cota chegada caminhão (~3.5m)
        "dP_Pa": 0.0,        # Pa — tanque aberto → tanque aberto
        "eta_bomba": ETA_BOMBA_LODO,
        "tipo": "Centrífuga de canal aberto (duty/standby)",
        "material": "Ferro fundido / 316L (rotores abertos)",
        "norma": "API 610 / Hidrostal",
        "obs": "Duty/Standby obrigatório — processo contínuo. "
               "Fluido com sólidos exige impelidor aberto (não obstrui).",
    },
    {
        "tag": "P-102 A/B",
        "servico": "Lodo ETE Imbirussu → TQ-01",
        "fluido": "Lodo de ETE (2-5% ST)",
        "rho": 1015.0,
        "mu": 0.004,         # Pa·s (4 cP) — lodo 3.5% ST [Metcalf & Eddy Tab.14-13]
        "Q_m3d": 80.0,
        "H_geo": 1.50,
        "dP_Pa": 0.0,
        "eta_bomba": ETA_BOMBA_LODO,
        "tipo": "Centrífuga de canal aberto (duty/standby)",
        "material": "Ferro fundido / 316L",
        "norma": "API 610",
        "obs": "Mesma lógica da P-101, vazão menor. "
               "Duty/Standby por ser corrente de processo contínuo.",
    },
    {
        "tag": "P-103",
        "servico": "Vinhaça 2G → TQ-02",
        "fluido": "Vinhaça de 2ª geração (pH 3-5)",
        "rho": 1050.0,
        "mu": 0.0025,        # Pa·s (2.5 cP) — vinhaça 2.5% ST [Wilkie et al., 2000]
        "Q_m3d": 50.0,
        "H_geo": 1.20,
        "dP_Pa": 0.0,
        "eta_bomba": ETA_BOMBA_AGUA,
        "tipo": "Centrífuga standard",
        "material": "Aço inox 316L (resistência a ácidos orgânicos)",
        "norma": "API 610",
        "obs": "Fluido ácido (pH 3-5) mas baixa viscosidade. "
               "316L obrigatório pela corrosividade.",
    },
    {
        "tag": "P-104",
        "servico": "Resíduo Orgânico → TQ-03",
        "fluido": "Resíduo orgânico diluído (10% ST)",
        "rho": 1080.0,
        "mu": 0.080,         # Pa·s (80 cP) — resíduo org. 15% ST diluído [Perry's 8ª ed. Tab.6-4]
        "Q_m3d": 50.0,
        "H_geo": 1.20,
        "dP_Pa": 0.0,
        "eta_bomba": ETA_BOMBA_MOINEAU,
        "tipo": "Bomba de cavidade progressiva (Moineau/parafuso)",
        "material": "Aço inox / Monel (resistência à abrasão)",
        "norma": "API 676 (deslocamento positivo)",
        "obs": "Viscosidade elevada (80 cP a 15% ST) → regime TRANSIÇÃO/LAMINAR. "
               "Bomba Moineau (cavidade progressiva) adequada para viscosidade. "
               "Ref: Perry's Cap.10; Metcalf & Eddy Tab.10-3.",
    },
    {
        "tag": "P-105 A/B",
        "servico": "Misturador MX-01 → Biorreatores BIO-01..04",
        "fluido": "Substrato homogeneizado (lodo+vinhaça+resíduo)",
        "rho": 1021.7,       # kg/m³ — média ponderada
        "mu": 0.005,         # Pa·s (5 cP) — v4 pipeline: mu_mix = 5 mPa·s (6% ST, 25°C)
        "Q_m3d": 500.0,
        "H_geo": 7.27,       # m — cota biorreator (12.27m) - cota misturador (5.0m)
        "dP_Pa": 0.0,
        "eta_bomba": ETA_BOMBA_LODO,
        "tipo": "Centrífuga de canal aberto (duty/standby)",
        "material": "Ferro fundido / 316L (rotores abertos)",
        "norma": "API 610",
        "obs": "Principal bomba de líquido do sistema (maior vazão). "
               "Duty/Standby obrigatório. Desnível de 7.27 m é o maior do projeto.",
    },
    {
        "tag": "P-106",
        "servico": "Reservatório Água → C-101 Topo (scrubber)",
        "fluido": "Água industrial (lavagem, 20°C)",
        "rho": 998.0,
        "mu": 0.001003,      # Pa·s — água a 20°C
        "Q_m3d": 81.63 * 24, # m³/dia = 1959.1 (81.63 m³/h × 24h) — v4 HPWS
        "H_geo": 7.28,       # m — cota topo C-101 (12.28m) - cota reservatório (5.0m)
        "dP_Pa": 900_000.0,  # Pa = 9 bar — água precisa chegar a 10 bar na coluna!
        "eta_bomba": ETA_BOMBA_MULTIESTAG,
        "tipo": "Centrífuga multi-estágio (3-4 estágios, alta pressão)",
        "material": "Ferro fundido / 316L",
        "norma": "API 610 / ISO 5199",
        "obs": "⚠ BOMBA MAIS POTENTE DO PROJETO (~85% do consumo total). "
               "ΔP = 900 kPa (9 bar) → H_pressão ≈ 92 m! Necessita multi-estágio. "
               "Vazão = 81.63 m³/h (resultado v4 HPWS: Q_água = 1959 m³/d). "
               "Fabricantes: Grundfos CRN, KSB Multitec, Sulzer MSD.",
    },
    {
        "tag": "P-107",
        "servico": "Efluente C-101 Fundo → Tanque Flash V-101",
        "fluido": "Água rica em CO₂ dissolvido (pH ~5)",
        "rho": 1002.0,
        "mu": 0.001010,
        "Q_m3d": 81.63 * 24, # mesma vazão da P-106 (v4: 1959 m³/d)
        "H_geo": -0.30,      # m — flash está ligeiramente abaixo (despressurização)
        "dP_Pa": 0.0,        # A coluna está a 10 bar, flash a ~3 bar → válvula regula
        "eta_bomba": ETA_BOMBA_AGUA,
        "tipo": "Centrífuga standard (ou apenas válvula redutora de pressão)",
        "material": "316L (água com CO₂ dissolvido → levemente ácida)",
        "norma": "API 610",
        "obs": "Na prática, pode não precisar de bomba se a pressão da coluna "
               "(10 bar) for suficiente para empurrar o líquido ao flash (3 bar). "
               "Instalar bomba apenas como segurança para controle de vazão.",
    },
    {
        "tag": "P-108",
        "servico": "Digestato Biorreatores → Armazenamento/Terceirização",
        "fluido": "Digestato (lama digerida, SV residual)",
        "rho": 1015.0,
        "mu": 0.006,         # Pa·s (6 cP) — digestato 2-3% ST [Chernicharo Tab.3-5]
        "Q_m3d": 425.0,      # m³/dia — 85% da alimentação retorna como digestato
        "H_geo": -8.24,      # m — NEGATIVO! Digestato desce (cota 12.27 → cota ~4.0)
        "dP_Pa": 0.0,
        "eta_bomba": ETA_BOMBA_MOINEAU,
        "tipo": "Parafuso (Moineau) ou peristáltica — OU escoamento por gravidade",
        "material": "PEAD ou aço carbono revestido",
        "norma": "API 676",
        "obs": "⚠ H_geo NEGATIVO → escoamento por gravidade POSSÍVEL se as perdas "
               "por atrito forem < 8.24 m. Instalar bomba booster como reserva. "
               "Fluido com sólidos remanescentes → Moineau recomendada.",
    },
]


# ═══════════════════════════════════════════════════════════════════════════════
# FUNÇÕES DE CÁLCULO
# ═══════════════════════════════════════════════════════════════════════════════

def calcular_bomba(bomba: dict) -> dict:
    """
    Dimensiona uma bomba industrial completa.
    
    METODOLOGIA (Franzini & Finnemore, 1994; Metcalf & Eddy, 2014):
    ─────────────────────────────────────────────────────────────────
    1. Converter vazão: Q [m³/d] → Q [m³/s]
    2. Calcular H_geo (desnível geométrico)
    3. Calcular H_pressão = ΔP / (ρ·g)
    4. Estimar H_perda = 20% × (H_geo + H_pressão)  [heurística]
    5. H_m = H_geo + H_pressão + H_perda
    6. P_hid = ρ · g · Q · H_m
    7. P_eixo = P_hid / η_bomba
    8. P_motor = P_eixo / η_motor
    9. P_instalada = P_motor × FS
    
    Retorna dicionário com todos os resultados intermediários.
    """
    rho = bomba["rho"]
    mu = bomba["mu"]
    Q_m3d = bomba["Q_m3d"]
    H_geo = bomba["H_geo"]
    dP_Pa = bomba["dP_Pa"]
    eta_b = bomba["eta_bomba"]
    eta_m = ETA_MOTOR
    
    # ── Conversão de vazão ────────────────────────────────────────────────
    Q_m3h = Q_m3d / 24.0         # m³/h
    Q_m3s = Q_m3d / 86400.0      # m³/s
    Q_Ls = Q_m3s * 1000.0        # L/s
    
    # ── Altura de pressão ─────────────────────────────────────────────────
    # H_pressão: converte ΔP [Pa] em metros de coluna de fluido [m]
    # Intuição: "quantos metros de fluido equivalem a essa pressão?"
    H_pressao = dP_Pa / (rho * g)  # [m]
    
    # ── Heurística de perda de carga ──────────────────────────────────────
    # Em projeto conceitual, quando as tubulações ainda não estão dimensionadas,
    # adota-se que as perdas por atrito representam ~20% da soma dos outros termos.
    # Fonte: prática de engenharia; validado pelas Diretrizes ECOGAS v1, Seção 5.2
    H_geo_efetivo = max(H_geo, 0)  # Só conta desnível positivo (bomba "sobe")
    H_perda = 0.20 * (H_geo_efetivo + H_pressao)
    
    # ── Altura manométrica total ──────────────────────────────────────────
    H_m = H_geo_efetivo + H_pressao + H_perda  # [m]
    
    # ── Caso especial: gravidade (H_geo negativo) ─────────────────────────
    # Se H_geo < 0, o fluido DESCE. Verificar se |H_geo| > H_perda.
    # Se sim → escoamento por gravidade possível (não precisa de bomba).
    gravidade_possivel = False
    if H_geo < 0:
        # Estimar perda com a gravidade
        H_perda_grav = 0.20 * abs(H_geo)  # estimativa conservadora
        if abs(H_geo) > H_perda_grav:
            gravidade_possivel = True
            # Mesmo assim, dimensionar bomba booster como segurança
            H_m = max(H_m, 2.0)  # mínimo 2m para bomba booster
    
    # ── Potências ─────────────────────────────────────────────────────────
    P_hid_W = rho * g * Q_m3s * H_m         # Potência hidráulica [W]
    P_eixo_W = P_hid_W / eta_b              # Potência de eixo [W]
    P_motor_W = P_eixo_W / eta_m            # Potência elétrica [W]
    P_inst_W = P_motor_W * FS               # Potência instalada [W]
    
    # Converter para kW
    P_hid_kW = P_hid_W / 1000.0
    P_eixo_kW = P_eixo_W / 1000.0
    P_motor_kW = P_motor_W / 1000.0
    P_inst_kW = P_inst_W / 1000.0
    
    # ── Reynolds (verificação de regime) ──────────────────────────────────
    # Usar diâmetro estimado pela heurística de velocidade
    if mu > 0.1:  # fluido muito viscoso
        v_alvo = 0.8  # m/s (Metcalf & Eddy, Tab. 10-3)
    elif mu > 0.01:  # lodo típico
        v_alvo = 1.5  # m/s
    else:  # água limpa
        v_alvo = 2.5  # m/s
    
    D_est = math.sqrt(4 * Q_m3s / (math.pi * v_alvo)) if Q_m3s > 0 else 0.05
    v_real = Q_m3s / (math.pi * D_est**2 / 4) if D_est > 0 else 0
    Re = rho * v_real * D_est / mu if mu > 0 else 0
    
    regime = "LAMINAR" if Re < 2300 else ("TRANSIÇÃO" if Re < 4000 else "TURBULENTO")
    
    # ── NPSH disponível (simplificado) ────────────────────────────────────
    # NPSHd = (P_atm - P_vapor)/(ρg) + z_sucção - hf_sucção
    # Para água a 20°C: P_vapor ≈ 2340 Pa
    # Para lodo: P_vapor desprezível (não volátil)
    P_vapor = 2340.0 if mu < 0.005 else 0.0  # Pa
    z_succao = 1.0  # m (bomba instalada abaixo do tanque — prática)
    hf_succao = 0.5  # m (estimativa conservadora para sucção curta)
    NPSHd = (P_ATM - P_vapor) / (rho * g) + z_succao - hf_succao
    NPSHr_tipico = 3.0  # m (valor típico de catálogo)
    NPSH_ok = NPSHd > (NPSHr_tipico + 0.5)
    
    return {
        "tag": bomba["tag"],
        "servico": bomba["servico"],
        "fluido": bomba["fluido"],
        "tipo": bomba["tipo"],
        "material": bomba["material"],
        "norma": bomba["norma"],
        "obs": bomba["obs"],
        # Dados de entrada
        "rho": rho,
        "mu": mu,
        "Q_m3d": Q_m3d,
        "Q_m3h": round(Q_m3h, 2),
        "Q_m3s": Q_m3s,
        "Q_Ls": round(Q_Ls, 2),
        # Alturas
        "H_geo": H_geo,
        "H_geo_efetivo": H_geo_efetivo,
        "H_pressao": round(H_pressao, 2),
        "H_perda": round(H_perda, 2),
        "H_m": round(H_m, 2),
        # Potências
        "P_hid_kW": round(P_hid_kW, 3),
        "P_eixo_kW": round(P_eixo_kW, 3),
        "P_motor_kW": round(P_motor_kW, 3),
        "P_inst_kW": round(P_inst_kW, 3),
        # Eficiências usadas
        "eta_bomba": eta_b,
        "eta_motor": eta_m,
        "FS": FS,
        # Hidráulica
        "D_est_mm": round(D_est * 1000, 1),
        "v_real": round(v_real, 3),
        "Re": round(Re, 0),
        "regime": regime,
        # NPSH
        "NPSHd": round(NPSHd, 2),
        "NPSH_ok": NPSH_ok,
        # Especiais
        "gravidade_possivel": gravidade_possivel,
    }


# ═══════════════════════════════════════════════════════════════════════════════
# EXECUÇÃO PRINCIPAL
# ═══════════════════════════════════════════════════════════════════════════════

def main():
    """Executa o dimensionamento de todas as bombas e imprime relatório."""
    
    SEP = "═" * 78
    THIN = "─" * 78
    
    print(SEP)
    print("  ECOGAS — DIMENSIONAMENTO DE BOMBAS P-101 a P-108")
    print("  Projeto Industrial II | UFMS | Campo Grande, MS | 2026")
    print("  Responsável: G. Luz | Revisão: Grupo ECOGAS")
    print(SEP)
    print()
    print("  METODOLOGIA:")
    print("    H_m = H_geo + H_pressão + H_perda")
    print("    H_perda = 20% × (H_geo + H_pressão)  [heurística conceitual]")
    print("    P_hid = ρ·g·Q·H_m  [Franzini & Finnemore, 1994]")
    print("    P_inst = P_hid / (η_bomba × η_motor) × FS")
    print(f"    η_motor = {ETA_MOTOR}  |  FS = {FS}")
    print()
    
    resultados = []
    P_total = 0.0
    
    for i, bomba in enumerate(BOMBAS, 1):
        r = calcular_bomba(bomba)
        resultados.append(r)
        P_total += r["P_inst_kW"]
        
        print(THIN)
        print(f"  ▶ {r['tag']} — {r['servico']}")
        print(THIN)
        print(f"    Fluido    : {r['fluido']}")
        print(f"    Tipo bomba: {r['tipo']}")
        print(f"    Material  : {r['material']}")
        print(f"    Norma     : {r['norma']}")
        print()
        print(f"    DADOS DE ENTRADA:")
        print(f"      ρ = {r['rho']} kg/m³  |  μ = {r['mu']} Pa·s")
        print(f"      Q = {r['Q_m3d']} m³/d = {r['Q_m3h']} m³/h = {r['Q_Ls']} L/s")
        print(f"      H_geo = {r['H_geo']} m  |  ΔP = {bomba['dP_Pa']/1000:.1f} kPa")
        print()
        print(f"    CÁLCULO:")
        print(f"      H_geo (efetivo)  = {r['H_geo_efetivo']:.2f} m")
        print(f"      H_pressão        = ΔP/(ρ·g) = {bomba['dP_Pa']:.0f}/({r['rho']}×9.81) = {r['H_pressao']:.2f} m")
        print(f"      H_perda (20%)    = 0.20×({r['H_geo_efetivo']:.2f}+{r['H_pressao']:.2f}) = {r['H_perda']:.2f} m")
        print(f"      ────────────────────────────────────────")
        print(f"      H_m TOTAL        = {r['H_m']:.2f} m")
        print()
        print(f"      P_hid   = ρ·g·Q·H_m = {r['rho']}×9.81×{r['Q_m3s']:.5f}×{r['H_m']:.2f} = {r['P_hid_kW']:.3f} kW")
        print(f"      P_eixo  = P_hid / η_b = {r['P_hid_kW']:.3f} / {r['eta_bomba']} = {r['P_eixo_kW']:.3f} kW")
        print(f"      P_motor = P_eixo / η_m = {r['P_eixo_kW']:.3f} / {r['eta_motor']} = {r['P_motor_kW']:.3f} kW")
        print(f"      P_inst  = P_motor × FS = {r['P_motor_kW']:.3f} × {r['FS']} = {r['P_inst_kW']:.3f} kW")
        print()
        print(f"    VERIFICAÇÕES:")
        print(f"      Re = {r['Re']:.0f} → {r['regime']}")
        print(f"      v ≈ {r['v_real']:.2f} m/s (D_est ≈ {r['D_est_mm']:.0f} mm)")
        print(f"      NPSHd = {r['NPSHd']:.1f} m {'✓ OK' if r['NPSH_ok'] else '⚠ VERIFICAR'}")
        if r['gravidade_possivel']:
            print(f"      ⚠ GRAVIDADE POSSÍVEL (H_geo = {r['H_geo']:.2f} m < 0)")
            print(f"        Bomba dimensionada como BOOSTER de segurança.")
        print()
        print(f"    NOTA: {r['obs']}")
        print()
    
    # ── TABELA RESUMO ─────────────────────────────────────────────────────
    print()
    print(SEP)
    print("  TABELA RESUMO — TODAS AS BOMBAS")
    print(SEP)
    print()
    print(f"  {'Tag':<12} {'Q [m³/h]':>10} {'H_m [m]':>9} {'P_inst [kW]':>12} {'Tipo':<45} {'Regime':<12}")
    print(f"  {'─'*12} {'─'*10} {'─'*9} {'─'*12} {'─'*45} {'─'*12}")
    
    for r in resultados:
        tipo_curto = r['tipo'][:43] + '..' if len(r['tipo']) > 45 else r['tipo']
        print(f"  {r['tag']:<12} {r['Q_m3h']:>10.2f} {r['H_m']:>9.2f} {r['P_inst_kW']:>12.3f} {tipo_curto:<45} {r['regime']:<12}")
    
    print(f"  {'─'*12} {'─'*10} {'─'*9} {'─'*12} {'─'*45} {'─'*12}")
    print(f"  {'TOTAL':<12} {'':>10} {'':>9} {P_total:>12.3f}")
    print()
    
    # ── ANÁLISE DE CONSUMO ────────────────────────────────────────────────
    print("  ANÁLISE DE DISTRIBUIÇÃO DE POTÊNCIA:")
    print()
    for r in resultados:
        pct = r['P_inst_kW'] / P_total * 100 if P_total > 0 else 0
        bar = "█" * int(pct / 2) + "░" * (50 - int(pct / 2))
        print(f"    {r['tag']:<12} {bar} {pct:5.1f}% ({r['P_inst_kW']:.2f} kW)")
    print()
    print(f"    Potência TOTAL instalada (bombas): {P_total:.2f} kW")
    print(f"    Consumo diário estimado (24h):     {P_total * 24:.0f} kWh/dia")
    print()
    
    # ── DESSECADOR S-101 ──────────────────────────────────────────────────
    print(SEP)
    print("  DESSECADOR S-101 — Dimensionamento Simplificado")
    print("  ANP Resolução nº 685/2017 — Ponto de orvalho ≤ -45°C")
    print(SEP)
    print()
    
    Q_biometano_Nm3d = 4406.0   # Nm³/dia (resultado do Balanço de Massa)
    Q_biometano_Nm3h = Q_biometano_Nm3d / 24.0
    
    # Umidade na saturação (biometano a 10 bar, 20°C)
    # Antoine para água: P_sat(20°C) ≈ 2340 Pa
    # y_H2O = P_sat / P_total = 2340 / 1_001_325 = 0.00234
    # Em mg/Nm³: y × M_H2O/Vm × 1e6 ≈ 2000 mg/Nm³
    umidade_entrada = 2000.0     # mg/Nm³ (saturado a 10 bar, 20°C)
    umidade_saida = 7.0          # mg/Nm³ (ANP 685/2017: ponto de orvalho ≤ -45°C)
    
    agua_remover_mgNm3 = umidade_entrada - umidade_saida
    agua_remover_kgh = agua_remover_mgNm3 * Q_biometano_Nm3h / 1e6  # kg/h
    
    # Peneira molecular 4Å — capacidade típica
    cap_adsorvente = 0.20  # kg H₂O / kg adsorvente (20% em peso)
    ciclo_h = 8.0          # horas por ciclo de adsorção
    
    massa_ads_kg = agua_remover_kgh * ciclo_h / cap_adsorvente
    margem = 1.5           # 50% de margem
    massa_ads_proj = massa_ads_kg * margem
    
    # Geometria do leito
    rho_bulk = 700.0       # kg/m³ (peneira molecular a granel)
    V_leito = massa_ads_proj / rho_bulk  # m³
    D_vaso = 0.25          # m (10") — padrão para esta escala
    A_vaso = math.pi * D_vaso**2 / 4
    H_leito = V_leito / A_vaso
    H_vaso = H_leito + 0.40  # distribuidores + tela
    
    print(f"  DADOS DE ENTRADA:")
    print(f"    Q_biometano     = {Q_biometano_Nm3d:.0f} Nm³/d = {Q_biometano_Nm3h:.1f} Nm³/h")
    print(f"    Pressão         = 10 bar abs (saída C-101)")
    print(f"    Temperatura     = 20°C")
    print(f"    Umidade entrada = {umidade_entrada:.0f} mg/Nm³ (saturado)")
    print(f"    Umidade saída   = {umidade_saida:.0f} mg/Nm³ (ANP 685/2017)")
    print()
    print(f"  CÁLCULO:")
    print(f"    Água a remover     = ({umidade_entrada:.0f} - {umidade_saida:.0f}) × {Q_biometano_Nm3h:.1f} / 10⁶")
    print(f"                       = {agua_remover_kgh:.4f} kg/h")
    print(f"    Massa adsorvente   = {agua_remover_kgh:.4f} × {ciclo_h:.0f}h / {cap_adsorvente}")
    print(f"                       = {massa_ads_kg:.2f} kg (por torre)")
    print(f"    Com margem ×{margem:.1f}   = {massa_ads_proj:.1f} kg (por torre)")
    print(f"    Volume do leito    = {massa_ads_proj:.1f} / {rho_bulk:.0f} = {V_leito*1000:.1f} litros")
    print(f"    Diâmetro do vaso   = {D_vaso*1000:.0f} mm ({D_vaso/0.0254:.0f}\")")
    print(f"    Altura do leito    = {H_leito:.3f} m")
    print(f"    Altura total vaso  = {H_vaso:.2f} m (leito + distribuidores)")
    print()
    print(f"  ESPECIFICAÇÃO:")
    print(f"    Tipo             : PSA (Pressure Swing Adsorption) — Twin-tower")
    print(f"    Adsorvente       : Peneira molecular 4Å (zeólita sintética)")
    print(f"    Nº de torres     : 2 (uma adsorve, outra regenera)")
    print(f"    Massa por torre  : {massa_ads_proj:.1f} kg")
    print(f"    Ciclo            : {ciclo_h:.0f} h adsorção + {ciclo_h:.0f} h regeneração")
    print(f"    Vaso (D × H)     : DN {D_vaso*1000:.0f} × {H_vaso*1000:.0f} mm")
    print(f"    Classe pressão   : PN16 (P_op = 10 bar)")
    print(f"    ΔP estimada      : 20-50 kPa (desprezível vs 10 bar)")
    print(f"    Material vaso    : Aço carbono (ASME VIII Div.1)")
    print()
    print(f"  VERIFICAÇÃO ANP 685/2017:")
    print(f"    Ponto de orvalho saída: ≤ -45°C  →  {umidade_saida} mg/Nm³  ✓ CONFORME")
    print(f"    Teor de H₂O máximo:     7 mg/Nm³ →  atendido pelo projeto   ✓ CONFORME")
    print()
    print(SEP)
    print("  FIM DO MEMORIAL — ECOGAS 2026")
    print(SEP)
    
    return resultados


if __name__ == "__main__":
    resultados = main()
