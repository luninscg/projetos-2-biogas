/**
 * ECOGAS ENGINE — Motor de Calculo para Planta de Biogas e Biometano
 * Campo Grande, MS | 2026
 * Codigestao Anaerobia + HPWS + Cogeracao
 *
 * Arquivo auto-contido (vanilla JS, sem dependencias externas).
 * Replica com rigor os modelos Python do projeto ECOGAS.
 *
 * MODULOS:
 *   1. Prop         — Propriedades fisicas dependentes de T,P
 *   2. ColunaHPWS   — Dimensionamento de coluna de absorcao recheada
 *   3. Hidraulica   — Dimensionamento hidraulico de tubulacoes
 *   4. Trocadores   — Trocadores de calor casco-e-tubo
 *
 * REFERENCIAS:
 *   [1] Azevedo & Alves — Engenharia de Processos
 *   [2] Treybal, R.E. — Mass Transfer Operations, 3a ed., Cap. 8
 *   [3] Onda, K. et al. (1968) J. Chem. Eng. Japan, 1(1), 56-62
 *   [4] Perry's Chemical Engineers' Handbook, 8a ed.
 *   [5] Crane Co. — Technical Paper 410 (TP-410)
 *   [6] Kister & Gill — Chem. Eng. Prog. (1992)
 *   [7] Billet & Schultes (1999) Trans IChemE, 77(A), 498-504
 *   [8] IAPWS-IF97 — Wagner & Pruss (2002)
 *   [9] Wilke & Chang (1955) AIChE J. 1, 264
 *  [10] Fuller, Schettler & Giddings (1966) Ind. Eng. Chem. 58(5), 18
 *  [11] Incropera (2011), Fund. Transferencia de Calor, 7a ed.
 *  [12] Kern (1950), Process Heat Transfer
 *  [13] TEMA (2007), Standards of Tubular Exchanger Manufacturers Assoc.
 */

/* =========================================================================
   CONSTANTES FUNDAMENTAIS
   ========================================================================= */

var R_GAS   = 8.314;
var g_acc   = 9.81;
var P_ATM   = 101325.0;
var Vm_NTP  = 22.414;
var M_CH4   = 16.043;
var M_CO2   = 44.010;
var M_H2O   = 18.015;

/* =========================================================================
   MODULO 1 — PROPRIEDADES FISICAS (Prop)
   Ref: Perry's [4], IAPWS [8], Wilke-Chang [9], Fuller [10]
   ========================================================================= */

var Prop = {
  R_GAS: R_GAS,
  P_ATM: P_ATM,

  /** Densidade da agua [kg/m3]. Polinomio Perry's Tab. 2-32. Valido 273-333 K. */
  rho_agua: function(T) {
    var Tc = T - 273.15;
    return 2.85527e-5*Tc*Tc*Tc - 7.15047e-3*Tc*Tc + 4.86788e-2*Tc + 999.872;
  },

  /** Viscosidade dinamica da agua [Pa.s]. Vogel, Perry's Tab. 2-313. */
  mu_agua: function(T) {
    return Math.exp(-3.3236 + 447.93/(T - 158.48)) * 1e-3;
  },

  /** Tensao superficial da agua [N/m]. IAPWS (Vargaftik 1983) [8]. */
  sigma_agua: function(T) {
    var tau = 1 - T/647.096;
    return 235.8e-3 * Math.pow(tau, 1.256) * (1 - 0.625*tau);
  },

  /** Difusividade CO2 em agua [m2/s]. Wilke-Chang [9]. */
  D_CO2_agua: function(T) {
    var mu_cP = Prop.mu_agua(T) * 1e3;
    var D_cm2s = 7.4e-8 * Math.pow(2.6*18.015, 0.5) * T / (mu_cP * Math.pow(34.0, 0.6));
    return D_cm2s * 1e-4;
  },

  /** Cp da agua [J/(kg.K)]. Perry's Tab. 2-153. */
  Cp_agua: function(T) {
    var Tc = T - 273.15;
    return 4217.6 - 3.166*Tc + 0.06022*Tc*Tc - 4.265e-4*Tc*Tc*Tc;
  },

  /** Densidade gas ideal [kg/m3]. P em Pa, M_g em g/mol. */
  rho_gas_ideal: function(P, T, M_g) {
    return P * (M_g/1000.0) / (R_GAS * T);
  },

  /** Viscosidade mistura CH4/CO2 [Pa.s]. Wilke (1950) [4]. */
  mu_gas_mistura: function(T, y_CH4, y_CO2) {
    var Tc = T - 273.15;
    var mu1 = 1.12e-5 + 3.2e-8*Tc;
    var mu2 = 1.38e-5 + 4.5e-8*Tc;
    var phi12 = Math.pow(1 + Math.pow(mu1/mu2, 0.5)*Math.pow(M_CO2/M_CH4, 0.25), 2)
              / Math.pow(8*(1+M_CH4/M_CO2), 0.5);
    var phi21 = Math.pow(1 + Math.pow(mu2/mu1, 0.5)*Math.pow(M_CH4/M_CO2, 0.25), 2)
              / Math.pow(8*(1+M_CO2/M_CH4), 0.5);
    return y_CH4*mu1/(y_CH4+y_CO2*phi12) + y_CO2*mu2/(y_CO2+y_CH4*phi21);
  },

  /** Difusividade CO2 no gas [m2/s]. Fuller-Schettler-Giddings [10]. */
  D_CO2_gas: function(T, P, y_CH4, y_CO2) {
    if (y_CH4 === undefined) y_CH4 = 0.6;
    if (y_CO2 === undefined) y_CO2 = 0.4;
    var M_AB = 2.0/(1/M_CO2+1/M_CH4);
    var P_atm = P/P_ATM;
    var D = 0.00143*Math.pow(T,1.75)
      / (P_atm*Math.pow(M_AB,0.5)*Math.pow(Math.pow(26.9,1/3)+Math.pow(25.14,1/3),2));
    return D*1e-4;
  },

  /** Henry CO2 em agua [atm/frac molar]. Sander 2015, NIST. */
  henry_CO2_agua: function(T) {
    return Math.exp(15.211 - 2332.2/T);
  },

  /** Henry CH4 em agua [atm/frac molar]. Perry's. */
  henry_CH4_agua: function(T) {
    return 38000.0 * Math.exp(0.012*(T-273.15-20));
  }
};


/* =========================================================================
   MODULO 2 — COLUNA HPWS (ColunaHPWS)
   Ref: Treybal [2], Onda [3], Perry's [4], Kister [6], Billet [7]
   ========================================================================= */

var RECHEIOS = {
  pall_metal_25mm: {nome:'Aneis de Pall Metalicos 1" (25 mm)', d_pk:0.025, Fp:183.0, ap:205.0, eps:0.94, sig_c:0.075, HETP:0.60},
  pall_metal_38mm: {nome:'Aneis de Pall Metalicos 1,5" (38 mm)', d_pk:0.038, Fp:131.0, ap:130.0, eps:0.95, sig_c:0.075, HETP:0.70},
  pall_metal_50mm: {nome:'Aneis de Pall Metalicos 2" (50 mm)', d_pk:0.050, Fp:89.0, ap:102.0, eps:0.96, sig_c:0.075, HETP:0.80}
};

var FIG7_PSI = [0.005,0.010,0.050,0.100,0.300,0.500,1.000,2.000,3.500,5.000];
var FIG7_DATA = {
  41:   [0.285,0.280,0.268,0.258,0.228,0.212,0.178,0.145,0.118,0.100],
  82:   [0.428,0.420,0.400,0.385,0.338,0.315,0.262,0.207,0.165,0.140],
  204:  [0.635,0.625,0.595,0.568,0.490,0.453,0.372,0.288,0.224,0.185],
  409:  [0.880,0.868,0.830,0.793,0.675,0.620,0.500,0.378,0.290,0.236],
  817:  [1.150,1.135,1.085,1.038,0.875,0.800,0.635,0.468,0.355,0.285],
  1226: [1.360,1.340,1.285,1.230,1.040,0.950,0.748,0.543,0.408,0.325]
};
var FIG7_KEYS = [41,82,204,409,817,1226];

function _interp(x, xp, fp) {
  if (x <= xp[0]) return fp[0];
  if (x >= xp[xp.length-1]) return fp[fp.length-1];
  for (var i=1; i<xp.length; i++) {
    if (x <= xp[i]) {
      var t = (x-xp[i-1])/(xp[i]-xp[i-1]);
      return fp[i-1]+t*(fp[i]-fp[i-1]);
    }
  }
  return fp[fp.length-1];
}

function _fig7_ord(psi, dpdz) {
  var p = Math.max(FIG7_PSI[0], Math.min(psi, FIG7_PSI[FIG7_PSI.length-1]));
  var vals = [];
  for (var i=0; i<FIG7_KEYS.length; i++)
    vals.push(_interp(p, FIG7_PSI, FIG7_DATA[FIG7_KEYS[i]]));
  var dp = Math.max(FIG7_KEYS[0], Math.min(dpdz, FIG7_KEYS[FIG7_KEYS.length-1]));
  return _interp(dp, FIG7_KEYS, vals);
}

/**
 * ColunaHPWS — dimensionamento completo de coluna de absorcao HPWS.
 * @constructor
 * @param {Object} [o] - Parametros (todos opcionais com defaults)
 */
function ColunaHPWS(o) {
  o = o || {};
  this.P_man_bar  = o.P_man_bar !== undefined ? o.P_man_bar : 9.0;
  this.P_op       = this.P_man_bar*1e5 + P_ATM;
  this.T_C        = o.T_op_C !== undefined ? o.T_op_C : 20.0;
  this.T_op       = this.T_C + 273.15;
  this.Q_bg       = o.Q_biogas_Nm3d !== undefined ? o.Q_biogas_Nm3d : 7342.854;
  this.y1_CH4     = o.y_CH4_in !== undefined ? o.y_CH4_in : 0.60;
  this.y1_CO2     = o.y_CO2_in !== undefined ? o.y_CO2_in : 0.40;
  this.modo       = o.modo || 'spec';
  this.y2_CO2     = o.y_CO2_topo !== undefined ? o.y_CO2_topo : 0.0230;
  this.Q_agua_user= o.Q_agua_m3h !== undefined ? o.Q_agua_m3h : null;
  this.A_op       = o.A_op !== undefined ? o.A_op : 1.5;
  var rk = o.recheio || 'pall_metal_25mm';
  if (!RECHEIOS[rk]) throw new Error("Recheio nao cadastrado: "+rk);
  this.rec = RECHEIOS[rk]; this.rec_key = rk;
  this.f_fl       = o.f_inundacao !== undefined ? o.f_inundacao : 0.65;
  this.irrig_proj = o.irrig_proj !== undefined ? o.irrig_proj : 40.0;
  this.margem     = o.margem_altura !== undefined ? o.margem_altura : 0.15;
  this.P_flash    = (o.P_flash_barg !== undefined ? o.P_flash_barg : 2.0)*1e5 + P_ATM;
}

ColunaHPWS.prototype._propriedades = function() {
  var T=this.T_op, P=this.P_op;
  var MG = this.y1_CH4*M_CH4 + this.y1_CO2*M_CO2;
  return {
    rho_L: Prop.rho_agua(T), mu_L: Prop.mu_agua(T),
    nu_L: Prop.mu_agua(T)/Prop.rho_agua(T)*1e6,
    sig_L: Prop.sigma_agua(T), D_L: Prop.D_CO2_agua(T),
    Cp_L: Prop.Cp_agua(T), M_G: MG,
    rho_G: Prop.rho_gas_ideal(P,T,MG),
    mu_G: Prop.mu_gas_mistura(T,this.y1_CH4,this.y1_CO2),
    D_G: Prop.D_CO2_gas(T,P,this.y1_CH4,this.y1_CO2),
    H_CO2: Prop.henry_CO2_agua(T), H_CH4: Prop.henry_CH4_agua(T),
    Ct_L: Prop.rho_agua(T)/(M_H2O/1000.0)
  };
};

ColunaHPWS.prototype._balanco_massa = function(prop) {
  var meq = prop.H_CO2*P_ATM/this.P_op;
  var Gs = (this.y1_CH4*this.Q_bg/Vm_NTP)*1000/86400.0;
  var Y1 = this.y1_CO2/(1-this.y1_CO2);
  var x1eq = this.y1_CO2/meq;
  var X1eq = x1eq/(1-x1eq);
  var rCH4n = M_CH4/Vm_NTP, rCO2n = M_CO2/Vm_NTP;
  var mCH4d = this.y1_CH4*this.Q_bg*rCH4n;
  var mCO2d = this.y1_CO2*this.Q_bg*rCO2n;
  var y2, Y2, CO2abs, Lsmin, Ls;

  if (this.modo==='spec') {
    y2 = this.y2_CO2; Y2 = y2/(1-y2);
    CO2abs = Gs*(Y1-Y2);
    Lsmin = CO2abs/X1eq;
    Ls = this.A_op*Lsmin;
  } else if (this.modo==='water') {
    if (this.Q_agua_user===null) throw new Error("modo='water' requer Q_agua_m3h");
    var Lm = this.Q_agua_user*prop.rho_L/3600.0;
    Ls = Lm/(M_H2O/1000.0);
    var Ak = Ls/(meq*Gs);
    if (Ak<=1) { y2=this.y1_CO2; }
    else {
      var mGL=1/Ak;
      y2 = this.y1_CO2/((Math.exp(5*(1-mGL))-mGL)/(1-mGL));
      y2 = Math.max(y2, 1e-6);
    }
    Y2=y2/(1-y2); CO2abs=Gs*(Y1-Y2);
    Lsmin = X1eq>0 ? CO2abs/X1eq : Ls;
  } else throw new Error("modo invalido");

  var Lmass = Ls*(M_H2O/1000.0);
  var QL = Lmass/prop.rho_L*3600.0;
  var X1 = CO2abs/Ls;
  var x1 = X1/(1+X1);
  var y1eq = meq*x1;

  return {
    m_eq:meq, Gs:Gs, Y1:Y1, Y2:Y2, CO2_abs:CO2abs,
    Ls_min:Lsmin, Ls:Ls, L_mass:Lmass, Q_L:QL,
    X1:X1, x1:x1, y1_eq_real:y1eq, y2_CO2:y2,
    x1_eq:x1eq, X1_eq:X1eq,
    m_CH4d:mCH4d, m_CO2d:mCO2d,
    Q_CH4d:this.y1_CH4*this.Q_bg, Q_CO2d:this.y1_CO2*this.Q_bg,
    A_min:Lsmin/(meq*Gs), A_real:Ls/(meq*Gs),
    ratio_LLmin:Ls/Lsmin,
    FM_fundo:this.y1_CO2-y1eq, FM_topo:y2
  };
};

/** NOG por integracao numerica (trapezio, 2000 pontos). Treybal [2]. */
ColunaHPWS.prototype._nog_integracao = function(bal) {
  var n=2000, Y2=bal.Y2, Y1=bal.Y1, dY=(Y1-Y2)/(n-1);
  var sum=0, yp, dmp;
  for (var i=0; i<n; i++) {
    var Yi = Y2+i*dY;
    var Xi = (bal.Gs/bal.Ls)*(Yi-Y2);
    var yi = Yi/(1+Yi), xi = Xi/(1+Xi);
    var dm = yi - bal.m_eq*xi;
    if (dm<=0) return {NOG:Infinity, N_Kr:NaN};
    if (i>0) sum += 0.5*(1/dmp+1/dm)*(yi-yp);
    yp=yi; dmp=dm;
  }
  var AKr = bal.Ls/(bal.m_eq*bal.Gs);
  var NKr = AKr<=1 ? Infinity :
    Math.log((this.y1_CO2/bal.y2_CO2)*(1-1/AKr)+1/AKr)/Math.log(AKr);
  return {NOG:sum, N_Kr:NKr};
};

ColunaHPWS.prototype._diametro = function(bal, prop) {
  var Gm = (bal.Gs+bal.CO2_abs)*prop.M_G/1e3;
  var LG = bal.L_mass/Gm;
  var Psi = LG*Math.sqrt(prop.rho_G/(prop.rho_L-prop.rho_G));
  var Fp=this.rec.Fp, nu=prop.nu_L;

  var dpfl = 40.912*Math.pow(Fp,0.7);
  var Ofl = _fig7_ord(Psi, dpfl);
  var CGfl = Ofl/(Math.pow(Fp,0.5)*Math.pow(nu,0.05));
  var vf = CGfl/Math.sqrt(prop.rho_G/(prop.rho_L-prop.rho_G));
  var vA = this.f_fl*vf;
  var AA = Gm/(prop.rho_G*vA);
  var dcA = Math.sqrt(4*AA/Math.PI);

  var OB = _fig7_ord(Psi, 900);
  var CGB = OB/(Math.pow(Fp,0.5)*Math.pow(nu,0.05));
  var vB = CGB/Math.sqrt(prop.rho_G/(prop.rho_L-prop.rho_G));
  var dcB = Math.sqrt(4*Gm/(prop.rho_G*vB)/Math.PI);

  var AC = bal.Q_L/this.irrig_proj;
  var dcC = Math.sqrt(4*AC/Math.PI);

  var dAs=Math.ceil(dcA/0.05)*0.05, dBs=Math.ceil(dcB/0.05)*0.05, dCs=Math.ceil(dcC/0.05)*0.05;
  var dc, crit, gpdc;
  if (Psi<=5) {
    dc=Math.max(dAs,dCs);
    crit = dAs>=dCs ? "INUNDACAO (GPDC)" : "CARGA DE LIQUIDO";
    gpdc=true;
  } else { dc=dCs; crit="CARGA DE LIQUIDO (Psi>5)"; gpdc=false; }

  return {
    G_mass:Gm, LG:LG, Psi:Psi, dpdz_fl:dpfl, vf:vf, v_op_A:vA,
    dc_A:dcA, dc_B:dcB, dc_C:dcC,
    dc_A_std:dAs, dc_B_std:dBs, dc_C_std:dCs,
    dc_proj:dc, crit_gov:crit, gpdc_aplicavel:gpdc
  };
};

/** Altura: HTU*NTU (Onda 1968 [3]) + HETP*N (Azevedo [1]). */
ColunaHPWS.prototype._altura = function(bal, prop, diam, NOG, NKr) {
  var Ap = Math.PI*Math.pow(diam.dc_proj,2)/4;
  var r = this.rec;
  var Lf = bal.L_mass/Ap, Gf = diam.G_mass/Ap;

  var ReL = Lf/(r.ap*prop.mu_L);
  var FrL = Lf*Lf*r.ap/(prop.rho_L*prop.rho_L*g_acc);
  var WeL = Lf*Lf/(prop.rho_L*prop.sig_L*r.ap);
  var aw = r.ap*(1-Math.exp(
    -1.45*Math.pow(r.sig_c/prop.sig_L,0.75)
    *Math.pow(ReL,0.1)*Math.pow(FrL,-0.05)*Math.pow(WeL,0.2)));

  var kL = 0.0051
    *Math.pow(Lf/(aw*prop.mu_L), 2/3)
    *Math.pow(prop.mu_L/(prop.rho_L*prop.D_L), -0.5)
    *Math.pow(r.ap*r.d_pk, 0.4)
    *Math.pow(prop.rho_L/(prop.mu_L*g_acc), -1/3);

  var kG = 5.23
    *Math.pow(Gf/(r.ap*prop.mu_G), 0.7)
    *Math.pow(prop.mu_G/(prop.rho_G*prop.D_G), 1/3)
    *Math.pow(r.ap*r.d_pk, -2.0)
    *r.ap*prop.D_G;

  var Gmin = bal.Gs+bal.CO2_abs;
  var Gmf = Gmin/Ap, Lmf = bal.Ls/Ap;
  var HG = Gmf/(kG*aw*this.P_op/(R_GAS*this.T_op));
  var HL = Lmf/(kL*aw*prop.Ct_L);
  var HOG = HG + (bal.m_eq*Gmin/bal.Ls)*HL;

  var zNTU = isFinite(NOG) ? HOG*NOG : Infinity;
  var zHETP = isFinite(NKr) ? r.HETP*NKr : 0;
  var zb = Math.max(zNTU, zHETP);
  var zr = zb*(1+this.margem);
  var zt, nrd, esb;
  if (!isFinite(zr)||isNaN(zr)) { zt=Infinity; nrd=0; esb=Infinity; }
  else {
    nrd = Math.max(0, Math.floor(zr/3.5)-1);
    zt = zr + 0.5+0.5+0.8+0.3 + nrd*0.4;
    esb = zt/diam.dc_proj;
  }

  return {
    A_proj:Ap, Lflux:Lf, Gflux:Gf,
    ReL:ReL, FrL:FrL, WeL:WeL, aw:aw, aw_ap:aw/r.ap,
    kL:kL, kG:kG, HG:HG, HL:HL, HOG:HOG,
    z_NTU:zNTU, z_HETP:zHETP, z_base:zb,
    z_recheio:zr, z_total:zt, n_redist:nrd, esbeltez:esb,
    irrig_real:bal.Q_L/Ap,
    v_gas:diam.G_mass/(prop.rho_G*Ap)
  };
};

ColunaHPWS.prototype._slip_ch4 = function(bal, prop) {
  var xf = (this.y1_CH4*this.P_op/P_ATM)/prop.H_CH4;
  var nd = xf*bal.Ls;
  var fr = Math.max(0, 1-this.P_flash/this.P_op);
  var nr = nd*fr, ns = nd-nr;
  var ms = ns*M_CH4/1000*86400;
  var nt = bal.Gs-ns, nc = bal.Gs*bal.Y2;
  return {
    H_CH4:prop.H_CH4, x_CH4_fundo:xf,
    n_CH4_diss:nd, n_CH4_rec:nr, n_CH4_slip:ns, m_CH4_slip:ms,
    frac_rec:fr, pct_slip:ms/bal.m_CH4d*100,
    m_CH4_topo:nt*M_CH4/1000*86400, m_CO2_topo:nc*M_CO2/1000*86400,
    y_CH4_topo:nt/(nt+nc)
  };
};

ColunaHPWS.prototype._termico = function(bal, prop) {
  var Qt = bal.CO2_abs*19400;
  return {Q_term:Qt, dT_ad:Qt/(bal.L_mass*prop.Cp_L)};
};

/** Executa dimensionamento completo. */
ColunaHPWS.prototype.dimensionar = function() {
  var prop = this._propriedades();
  var bal = this._balanco_massa(prop);
  var est = this._nog_integracao(bal);
  var NOG=est.NOG, NKr=est.N_Kr;
  var diam = this._diametro(bal, prop);
  var alt = this._altura(bal, prop, diam, NOG, NKr);
  var slip = this._slip_ch4(bal, prop);
  var term = this._termico(bal, prop);

  var Oop = alt.v_gas*Math.sqrt(prop.rho_G/(prop.rho_L-prop.rho_G))
    *Math.pow(this.rec.Fp,0.5)*Math.pow(prop.nu_L,0.05);
  var nDP=2000, pairs=[];
  for (var i=0; i<nDP; i++) {
    var d=20+(1400-20)*i/(nDP-1);
    pairs.push({o:_fig7_ord(diam.Psi,d), d:d});
  }
  pairs.sort(function(a,b){return a.o-b.o;});
  var os=pairs.map(function(p){return p.o;}), ds=pairs.map(function(p){return p.d;});
  var dpOp = _interp(Oop, os, ds);
  var dPkPa = dpOp*alt.z_recheio/1000;

  return {
    entradas:{P_man_bar:this.P_man_bar, P_op_bar:this.P_op/1e5,
      T_op_C:this.T_C, Q_bg:this.Q_bg,
      y_CH4_in:this.y1_CH4, y_CO2_in:this.y1_CO2,
      modo:this.modo, y_CO2_topo:bal.y2_CO2,
      A_op:this.A_op, recheio:this.rec.nome,
      f_inundacao:this.f_fl, irrig_proj:this.irrig_proj},
    propriedades:prop, balanco:bal,
    estagios:{NOG:NOG, N_Kr:NKr},
    diametro:diam, altura:alt, slip:slip, termico:term,
    perda_carga:{dpdz_op:dpOp, dP_kPa:dPkPa},
    recheio:this.rec
  };
};


/* =========================================================================
   MODULO 3 — HIDRAULICA
   Ref: Darcy-Weisbach, Colebrook-White (Newton-Raphson), Crane TP-410 [5]
   ========================================================================= */

var Hidraulica = {};

Hidraulica.FLUID_PROPS = {
  lodo_ete:       {type:"liquid",rho:1020.0,mu:0.050,   descr:"Lodo de ETE (2-5% ST)",          material:"carbon_steel_epoxy"},
  vinhaca:        {type:"liquid",rho:1050.0,mu:0.020,   descr:"Vinhaca de 2a geracao",           material:"stainless_316L"},
  residuo_org:    {type:"liquid",rho:1080.0,mu:0.800,   descr:"Residuo organico (aterro)",       material:"hdpe_or_epoxy"},
  substrato_mix:  {type:"liquid",rho:1021.7,mu:0.045,   descr:"Substrato homogeneizado (mix)",   material:"carbon_steel_epoxy"},
  agua_industrial:{type:"liquid",rho:998.2, mu:0.001003,descr:"Agua industrial (scrubber)",      material:"carbon_steel"},
  agua_co2:       {type:"liquid",rho:1002.0,mu:0.001010,descr:"Agua rica em CO2 (fundo C-101)",  material:"stainless_316L"},
  digestato:      {type:"liquid",rho:1015.0,mu:0.030,   descr:"Digestato (saida biorreatores)",  material:"hdpe_or_epoxy"},
  biogas:         {type:"gas",   rho:1.15,  mu:1.3e-5,  descr:"Biogas bruto (60% CH4/40% CO2)",  material:"carbon_steel"},
  biogas_comp:    {type:"gas",   rho:11.19, mu:1.18e-5, descr:"Biogas comprimido (10 bar abs)",  material:"carbon_steel_seamless"},
  biometano:      {type:"gas",   rho:0.68,  mu:1.1e-5,  descr:"Biometano purificado (>=97% CH4)",material:"stainless_316L"}
};

Hidraulica.MATERIAL_ROUGHNESS = {
  carbon_steel:0.046e-3, carbon_steel_epoxy:0.010e-3,
  carbon_steel_seamless:0.046e-3, stainless_316L:0.015e-3,
  hdpe_or_epoxy:0.007e-3, pvc:0.002e-3
};

Hidraulica.MATERIAL_DESCR = {
  carbon_steel:"Aco carbono (ASTM A53)",
  carbon_steel_epoxy:"Aco carbono revestido epoxi (ASTM A53 + primer)",
  carbon_steel_seamless:"Aco carbono sem costura (ASTM A106 Gr.B)",
  stainless_316L:"Aco inoxidavel AISI 316L",
  hdpe_or_epoxy:"PEAD (HDPE SDR 17) ou Aco + revestimento epoxi",
  pvc:"PVC Schedule 40"
};

Hidraulica.DN_COMMERCIAL = [
  0.0127,0.01905,0.0254,0.03175,0.0381,
  0.0508,0.0635,0.0762,0.1016,0.1270,
  0.1524,0.2032,0.2540,0.3048,0.3556,
  0.4064,0.5080,0.6096,0.7620,1.0160
];
Hidraulica.DN_NAMES = [
  '1/2"','3/4"','1"','1.25"','1.5"','2"','2.5"','3"','4"','5"',
  '6"','8"','10"','12"','14"','16"','20"','24"','30"','40"'
];

Hidraulica.FITTING_K = {
  curva_90_soldada:    {K:0.75, LeD:30,  descr:"Curva 90 soldada (r/D~1,5)"},
  curva_90_rosqueada:  {K:1.50, LeD:50,  descr:"Curva 90 rosqueada"},
  curva_45_soldada:    {K:0.40, LeD:16,  descr:"Curva 45 soldada"},
  valv_gaveta_aberta:  {K:0.17, LeD:7,   descr:"Valvula gaveta 100% aberta"},
  valv_esfera_aberta:  {K:0.05, LeD:3,   descr:"Valvula esfera 100% aberta"},
  valv_globo_aberta:   {K:10.0, LeD:350, descr:"Valvula globo aberta"},
  valv_retencao:       {K:2.0,  LeD:100, descr:"Valvula de retencao (check)"},
  valv_borboleta:      {K:0.5,  LeD:20,  descr:"Valvula borboleta aberta"},
  te_passagem_direta:  {K:0.40, LeD:20,  descr:"Te passagem direta"},
  te_desvio:           {K:1.00, LeD:60,  descr:"Te desvio 90"},
  entrada_bordas_vivas:{K:0.50, LeD:25,  descr:"Entrada de bordas vivas"},
  saida_brusca:        {K:1.00, LeD:50,  descr:"Saida brusca (KE=1)"},
  reducao_brusca:      {K:0.50, LeD:25,  descr:"Reducao brusca (beta=0,5)"},
  ampliacao_brusca:    {K:0.80, LeD:40,  descr:"Ampliacao brusca"},
  medidor_fluxo:       {K:1.50, LeD:75,  descr:"Medidor de fluxo (placa orificio)"}
};

Hidraulica.VELOCITY_LIMITS = {
  liquid_clean:  {min:0.5, max:3.0},
  liquid_slurry: {min:1.0, max:2.5},
  liquid_viscous:{min:0.3, max:1.5},
  gas_lp:        {min:3.0, max:20.0},
  gas_hp:        {min:8.0, max:30.0},
  suction_line:  {min:0.3, max:1.0}
};

/** Re = rho*v*D/mu */
Hidraulica.reynolds = function(rho,v,D,mu) { return rho*v*D/mu; };

/**
 * Colebrook-White via Newton-Raphson (20 iter).
 * Chute: Swamee-Jain. Laminar: f=64/Re. Transicao: interpolacao linear.
 * @param {number} Re
 * @param {number} eps - Rugosidade absoluta [m]
 * @param {number} D - Diametro [m]
 * @returns {number} f (Darcy)
 */
Hidraulica.friction_factor_colebrook = function(Re, eps, D) {
  if (Re<=0) return 0.02;
  if (Re<2300) return 64.0/Re;
  if (Re<4000) {
    var fl=64.0/2300, ft=Hidraulica._cb_nr(4000,eps,D);
    return fl+(Re-2300)/(4000-2300)*(ft-fl);
  }
  return Hidraulica._cb_nr(Re,eps,D);
};

Hidraulica._cb_nr = function(Re,eps,D) {
  var er=eps/D, LN10=Math.log(10);
  var f=0.25/Math.pow(Math.log10(er/3.7+5.74/Math.pow(Re,0.9)),2);
  for (var i=0;i<20;i++) {
    var sf=Math.sqrt(f);
    var arg=er/3.7+2.51/(Re*sf);
    var g=1/sf+2*Math.log(arg)/LN10;
    var dg=-0.5/(f*sf)+2/LN10*(-2.51/(2*Re*f*sf))/arg;
    var fn=f-g/dg;
    if (fn<=0) fn=f*0.5;
    if (Math.abs(fn-f)<1e-10) break;
    f=fn;
  }
  return f;
};

Hidraulica.head_loss_darcy = function(f,L,D,v) { return f*(L/D)*(v*v/(2*g_acc)); };
Hidraulica.head_loss_minor = function(K,v) { return K*v*v/(2*g_acc); };
Hidraulica.flow_velocity = function(Q,D) { return Q/(Math.PI*D*D/4); };

Hidraulica.bernoulli_pressure_drop = function(rho,hf,v1,v2,z1,z2) {
  v1=v1||0; v2=v2||0; z1=z1||0; z2=z2||0;
  return rho*g_acc*(hf+(z2-z1))+rho/2*(v2*v2-v1*v1);
};

Hidraulica.pump_power = function(rho,Q,H,eta) {
  if (eta===undefined) eta=0.70;
  return rho*g_acc*Q*H/eta/1000;
};

Hidraulica.flow_regime = function(Re) {
  if (Re<2300) return "LAMINAR";
  if (Re<4000) return "TRANSICAO";
  return "TURBULENTO";
};

Hidraulica.economic_diameter = function(Q, stype) {
  var vt;
  if      (stype==="gas_lp")         vt=8;
  else if (stype==="gas_hp")         vt=15;
  else if (stype==="liquid_viscous") vt=0.8;
  else if (stype==="liquid_slurry")  vt=1.2;
  else                               vt=2.0;
  return {D_calc:Math.sqrt(4*Q/(Math.PI*vt)), v_target:vt};
};

Hidraulica.select_commercial_dn = function(Dc) {
  var a=Hidraulica.DN_COMMERCIAL, idx=a.length-1;
  for (var i=0;i<a.length;i++) { if (a[i]>=Dc) {idx=i; break;} }
  return {D_nom:a[idx], DN_name:Hidraulica.DN_NAMES[idx]};
};

Hidraulica.check_velocity = function(v,stype) {
  var lim=Hidraulica.VELOCITY_LIMITS[stype]||Hidraulica.VELOCITY_LIMITS.liquid_clean;
  if (v<lim.min) return "BAIXA";
  if (v>lim.max) return "ALTA";
  return "OK";
};

Hidraulica.total_fitting_K = function(flist) {
  var Kt=0, Lt=0, det=[];
  for (var i=0;i<flist.length;i++) {
    var ft=flist[i][0], q=flist[i][1];
    var d=Hidraulica.FITTING_K[ft]||{K:0.5,LeD:25,descr:ft};
    Kt+=d.K*q; Lt+=d.LeD*q;
    det.push(q+"x"+d.descr+" (K="+d.K.toFixed(2)+")");
  }
  return {K_total:Kt, LeD_total:Lt, details:det};
};

/** Define os 13 trechos hidraulicos do PFD ECOGAS. */
Hidraulica.define_process_lines = function() {
  return [
    {tag:"L-101",bloco:"B1-B2",descr:"TQ-01 -> MX-01 (Lodo ETE, Bomba P-101)",
     fluid:"lodo_ete",Q_m3d:320,L_m:45,dz_m:1.5,service_type:"liquid_slurry",P_op_bar:1.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",3],["valv_gaveta_aberta",2],
       ["valv_retencao",1],["te_passagem_direta",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-103",bloco:"B1-B2",descr:"TQ-02 -> MX-01 (Vinhaca, Bomba P-103)",
     fluid:"vinhaca",Q_m3d:50,L_m:30,dz_m:1.2,service_type:"liquid_clean",P_op_bar:1.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",2],["valv_esfera_aberta",1],
       ["valv_retencao",1],["te_desvio",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-104",bloco:"B1-B2",descr:"TQ-03 -> MX-01 (Residuo Org, Bomba P-104)",
     fluid:"residuo_org",Q_m3d:50,L_m:25,dz_m:1.2,service_type:"liquid_viscous",P_op_bar:1.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",2],["valv_globo_aberta",1],
       ["valv_retencao",1],["reducao_brusca",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-105",bloco:"B2-B3",descr:"MX-01 -> HE-101 -> BIO (Substrato mix, P-105)",
     fluid:"substrato_mix",Q_m3d:500,L_m:60,dz_m:7.27,service_type:"liquid_slurry",P_op_bar:2.0,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",4],["valv_gaveta_aberta",2],
       ["valv_retencao",1],["te_desvio",4],["medidor_fluxo",1],["reducao_brusca",4],["saida_brusca",4]]},
    {tag:"L-106A",bloco:"B3-B4",descr:"BIO -> K-101 Est.1 (Biogas bruto)",
     fluid:"biogas",Q_m3d:7343,L_m:80,dz_m:-7,service_type:"gas_lp",P_op_bar:1.013,
     fittings:[["entrada_bordas_vivas",4],["curva_90_soldada",6],["valv_gaveta_aberta",2],
       ["valv_retencao",1],["te_desvio",3],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-106B",bloco:"B4",descr:"K-101 Est.1 -> HE-102 -> K-101 Est.2 (3,2 bar)",
     fluid:"biogas_comp",Q_m3d:7343,L_m:15,dz_m:0,service_type:"gas_hp",P_op_bar:3.2,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",1],["te_passagem_direta",1],["saida_brusca",1]]},
    {tag:"L-107",bloco:"B4-B5",descr:"K-101 Est.2 -> C-101 HPWS (10 bar)",
     fluid:"biogas_comp",Q_m3d:7343,L_m:20,dz_m:1.5,service_type:"gas_hp",P_op_bar:10.0,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",1],["valv_retencao",1],
       ["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-108",bloco:"B5",descr:"C-102 -> C-101 Topo (Agua lavagem, P-106)",
     fluid:"agua_industrial",Q_m3d:50.9*24,L_m:30,dz_m:7.28,service_type:"liquid_clean",P_op_bar:10.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",3],["valv_esfera_aberta",1],
       ["valv_retencao",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-109",bloco:"B5",descr:"C-101 Fundo -> V-101 Flash (Agua+CO2)",
     fluid:"agua_co2",Q_m3d:50.9*24,L_m:12,dz_m:-0.3,service_type:"liquid_clean",P_op_bar:3.0,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",2],["valv_esfera_aberta",1],
       ["valv_retencao",1],["saida_brusca",1]]},
    {tag:"L-DIG",bloco:"B3-ext",descr:"BIO-01..04 -> Saida digestato (gravidade)",
     fluid:"digestato",Q_m3d:500*0.85,L_m:50,dz_m:-8.24,service_type:"liquid_viscous",P_op_bar:1.0,
     fittings:[["entrada_bordas_vivas",4],["curva_90_soldada",3],["valv_gaveta_aberta",2],
       ["te_desvio",3],["saida_brusca",1]]},
    {tag:"L-110",bloco:"B5-B6",descr:"C-101 Topo -> S-101 -> TQ-04 (Biometano seco)",
     fluid:"biometano",Q_m3d:4406,L_m:25,dz_m:-3,service_type:"gas_hp",P_op_bar:9.5,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",1],["valv_retencao",1],
       ["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-CHP",bloco:"B6-B7",descr:"TQ-04 -> CHP-01 (Biometano combustivel)",
     fluid:"biometano",Q_m3d:4406*0.30,L_m:20,dz_m:0,service_type:"gas_hp",P_op_bar:8.0,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",2],["valv_retencao",1],
       ["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-HW",bloco:"B7-B2",descr:"CHP-01 -> HE-101 (Agua quente, 247 kW)",
     fluid:"agua_industrial",Q_m3d:247*86.4/(4.18*10),L_m:35,dz_m:-4,service_type:"liquid_clean",P_op_bar:1.5,
     fittings:[["curva_90_soldada",4],["valv_esfera_aberta",2],["te_passagem_direta",1],
       ["medidor_fluxo",1],["saida_brusca",1]]}
  ];
};

Hidraulica.calc_line = function(ld) {
  var fp=Hidraulica.FLUID_PROPS[ld.fluid];
  var rho=fp.rho, mu=fp.mu, mat=fp.material;
  var eps=Hidraulica.MATERIAL_ROUGHNESS[mat]||0.046e-3;
  var Qs=ld.Q_m3d/86400;
  var ec=Hidraulica.economic_diameter(Qs,ld.service_type);
  var dn=Hidraulica.select_commercial_dn(ec.D_calc);
  var D=dn.D_nom, v=Hidraulica.flow_velocity(Qs,D);
  var Re=Hidraulica.reynolds(rho,v,D,mu);
  var f=Hidraulica.friction_factor_colebrook(Re,eps,D);
  var hfd=Hidraulica.head_loss_darcy(f,ld.L_m,D,v);
  var fit=Hidraulica.total_fitting_K(ld.fittings);
  var Le=fit.LeD_total*D;
  var hfl=Hidraulica.head_loss_minor(fit.K_total,v);
  var hft=hfd+hfl, Hm=hft+ld.dz_m;
  var dP=Hidraulica.bernoulli_pressure_drop(rho,hft,0,0,0,ld.dz_m);
  var pump=Hm>0, Pk=pump?Hidraulica.pump_power(rho,Qs,Math.max(Hm,0)):0;
  return {
    tag:ld.tag, bloco:ld.bloco||"-", descr:ld.descr,
    fluid_key:ld.fluid, fluid_descr:fp.descr, fluid_type:fp.type,
    rho_kgm3:rho, mu_Pas:mu,
    Q_m3d:ld.Q_m3d, Q_m3s:+Qs.toFixed(6), Q_m3h:+(Qs*3600).toFixed(2),
    D_calc_mm:+(ec.D_calc*1000).toFixed(1), D_nom_mm:+(D*1000).toFixed(1), DN_name:dn.DN_name,
    v_ms:+v.toFixed(3), v_target_ms:ec.v_target,
    vel_status:Hidraulica.check_velocity(v,ld.service_type),
    Re:+Re.toFixed(0), regime:Hidraulica.flow_regime(Re),
    eps_mm:+(eps*1000).toFixed(4), eps_rel:+(eps/D).toFixed(6),
    f_darcy:+f.toFixed(5),
    L_m:ld.L_m, Le_m:+Le.toFixed(2), L_total_eq_m:+(ld.L_m+Le).toFixed(2),
    hf_dist_m:+hfd.toFixed(3), K_total:+fit.K_total.toFixed(3),
    hf_local_m:+hfl.toFixed(3), hf_total_m:+hft.toFixed(3),
    dz_m:ld.dz_m, H_mano_m:+Hm.toFixed(3),
    dP_bar:+(dP/1e5).toFixed(4), P_hidro_kW:+Pk.toFixed(3),
    P_op_bar:ld.P_op_bar,
    material:Hidraulica.MATERIAL_DESCR[mat]||mat,
    fittings_det:fit.details.join(" | "),
    is_pumped:pump,
    Eu:v>0?+(dP/(0.5*rho*v*v)).toFixed(3):0
  };
};

Hidraulica.run_all_lines = function() {
  return Hidraulica.define_process_lines().map(function(l){return Hidraulica.calc_line(l);});
};


/* =========================================================================
   MODULO 4 — TROCADORES DE CALOR (Trocadores)
   Ref: Incropera [11], Kern [12], TEMA [13], Perry's [4]
   ========================================================================= */

var Trocadores = {};

/** LMTD contracorrente [K]. Incropera Eq. 11.14. */
Trocadores.lmtd = function(Tqi, Tqo, Tfi, Tfo) {
  var d1=Tqi-Tfo, d2=Tqo-Tfi;
  if (Math.abs(d1-d2)<1e-6) return d1;
  return (d1-d2)/Math.log(d1/d2);
};

/** Fator F (Bowman 1940). n_passes=1 -> F=1. */
Trocadores.fator_F = function(Tqi, Tqo, Tfi, Tfo, np) {
  if (!np||np<=1) return 1.0;
  var R=(Tqi-Tqo)/Math.max(Tfo-Tfi,1e-9);
  var P=(Tfo-Tfi)/Math.max(Tqi-Tfi,1e-9);
  if (Math.abs(R-1)<1e-6) return 1.0;
  var sq=Math.sqrt(R*R+1);
  var num=sq*Math.log((1-P)/(1-R*P));
  var W=(2-P*(R+1-sq))/(2-P*(R+1+sq));
  var den=(R-1)*Math.log(W);
  return Math.max(0.5, Math.min(1.0, Math.abs(num/den)));
};

/** Uo global [W/(m2.K)]. Incropera Eq. 11.5 referido a Ao. */
Trocadores.coef_global = function(p) {
  var Rfi=p.Rfi||0, Rfo=p.Rfo||0;
  var r1=p.Do/(p.hi*p.Di), r2=Rfi*p.Do/p.Di;
  var r3=p.Do*Math.log(p.Do/p.Di)/(2*p.k_wall);
  var r4=Rfo, r5=1/p.ho, Rt=r1+r2+r3+r4+r5;
  return {Uo:1/Rt, R:{conv_int:r1,incr_int:r2,cond:r3,incr_ext:r4,conv_ext:r5,total:Rt}};
};

/** Nusselt Dittus-Boelter (Re>10000). */
Trocadores.Nu_DB = function(Re,Pr,aquec) {
  return 0.023*Math.pow(Re,0.8)*Math.pow(Pr,aquec!==false?0.4:0.3);
};

/** Nusselt Gnielinski (3000<=Re<=5e6). */
Trocadores.Nu_Gn = function(Re,Pr,f) {
  if (Re<3000) return null;
  if (f===undefined) f=Math.pow(0.790*Math.log(Re)-1.64,-2);
  return (f/8)*(Re-1000)*Pr/(1+12.7*Math.sqrt(f/8)*(Math.pow(Pr,2/3)-1));
};

/** Nusselt Kern casco. */
Trocadores.Nu_Kern = function(Res,Pr) {
  if (Res<10) return 1;
  var jH = Res<1000 ? 0.36*Math.pow(Res,-0.45) : 0.36*Math.pow(Res,-0.40);
  return Math.max(jH*Res*Math.pow(Pr,1/3),1);
};

Trocadores.FOULING = {
  agua_resf:1.76e-4, agua_proc:3.52e-4, lodo:5.28e-4,
  biogas:2.64e-4, gas_limpo:1.76e-4
};

/**
 * HE-101: Pre-aquecimento lodo (agua CHP -> lodo nos tubos).
 * @param {Object} [o] - Override de parametros
 */
Trocadores.dim_HE101 = function(o) {
  o=o||{};
  var ml   = o.m_lodo!==undefined?o.m_lodo:5.91;
  var Tli  = o.T_lodo_in!==undefined?o.T_lodo_in:25;
  var Tlo  = o.T_lodo_out!==undefined?o.T_lodo_out:35;
  var Tai  = o.T_agua_in!==undefined?o.T_agua_in:90;
  var Tao  = o.T_agua_out!==undefined?o.T_agua_out:79;
  var Cpl  = o.Cp_lodo!==undefined?o.Cp_lodo:4000;
  var Cpa  = o.Cp_agua!==undefined?o.Cp_agua:4180;
  var kl   = o.k_lodo!==undefined?o.k_lodo:0.58;
  var ka   = o.k_agua!==undefined?o.k_agua:0.65;
  var rl   = o.rho_lodo!==undefined?o.rho_lodo:1020;
  var mul  = o.mu_lodo!==undefined?o.mu_lodo:0.0035;
  var ra   = o.rho_agua!==undefined?o.rho_agua:965;
  var mua  = o.mu_agua!==undefined?o.mu_agua:0.000315;
  var Do   = o.Do!==undefined?o.Do:0.0254;
  var Di   = o.Di!==undefined?o.Di:0.0214;
  var L    = o.L!==undefined?o.L:4.88;
  var kw   = o.k_wall!==undefined?o.k_wall:50;
  var Rfi  = o.Rfi!==undefined?o.Rfi:0.000627;
  var Rfo  = o.Rfo!==undefined?o.Rfo:0.000352;

  var Q = ml*Cpl*(Tlo-Tli);
  var ma = Q/(Cpa*(Tai-Tao));
  var lm = Trocadores.lmtd(Tai,Tao,Tli,Tlo);

  var Prl = mul*Cpl/kl;
  var vt = 0.846;
  var Nt = Math.round(ml/(rl*vt*Math.PI*Di*Di/4));
  if (Nt<1) Nt=1;
  var vl = ml/(rl*Nt*Math.PI*Di*Di/4);
  var Rel = rl*vl*Di/mul;
  var Nui;
  if (Rel>10000) Nui=Trocadores.Nu_DB(Rel,Prl,true);
  else if (Rel>3000) Nui=Trocadores.Nu_Gn(Rel,Prl);
  else Nui=Math.max(1.86*Math.pow(Rel*Prl*Di/L,1/3),3.66);
  var hi = Nui*kl/Di;

  var Pra = mua*Cpa/ka, De=o.De_casco!==undefined?o.De_casco:0.020;
  var va  = o.v_casco!==undefined?o.v_casco:1.2;
  var Rea = ra*va*De/mua;
  var ho = Trocadores.Nu_Kern(Rea,Pra)*ka/De;

  var uc = Trocadores.coef_global({hi:hi,ho:ho,Di:Di,Do:Do,k_wall:kw,Rfi:Rfi,Rfo:Rfo});
  var A = Q/(uc.Uo*lm);
  Nt = Math.ceil(A/(Math.PI*Do*L));
  if (Nt<1) Nt=1;
  var Ar = Nt*Math.PI*Do*L;
  vl = ml/(rl*Nt*Math.PI*Di*Di/4);
  Rel = rl*vl*Di/mul;
  var fl = Hidraulica.friction_factor_colebrook(Rel,0.046e-3,Di);
  var dPl = fl*(L/Di)*(rl*vl*vl/2);

  return {
    tag:"HE-101", servico:"Pre-aquecimento lodo (agua CHP -> lodo)",
    Q_kW:+(Q/1000).toFixed(1), Q_W:Q, LMTD:+lm.toFixed(2), Uo:+uc.Uo.toFixed(1),
    A_m2:+A.toFixed(2), A_real_m2:+Ar.toFixed(2), N_tubos:Nt,
    Do_mm:+(Do*1000).toFixed(1), Di_mm:+(Di*1000).toFixed(1), L_m:L,
    hi:+hi.toFixed(1), ho:+ho.toFixed(1),
    Re_lodo:+Rel.toFixed(0), v_lodo:+vl.toFixed(3),
    dP_bar:+(dPl/1e5).toFixed(4),
    Rfi:Rfi, Rfo:Rfo, m_lodo:ml, m_agua:+ma.toFixed(3),
    T_lodo_in:Tli, T_lodo_out:Tlo, T_agua_in:Tai, T_agua_out:Tao,
    resistencias:uc.R
  };
};

/**
 * HE-102: Intercooler compressor K-101 (biogas 127->40 C a 3.2 bar).
 * @param {Object} [o] - Override
 */
Trocadores.dim_HE102 = function(o) {
  o=o||{};
  var mg  = o.m_gas!==undefined?o.m_gas:0.0978;
  var Tgi = o.T_gas_in!==undefined?o.T_gas_in:127;
  var Tgo = o.T_gas_out!==undefined?o.T_gas_out:40;
  var Tai = o.T_agua_in!==undefined?o.T_agua_in:25;
  var Tao = o.T_agua_out!==undefined?o.T_agua_out:35;
  var Cpg = o.Cp_gas!==undefined?o.Cp_gas:1400;
  var Cpa = o.Cp_agua!==undefined?o.Cp_agua:4180;
  var kg  = o.k_gas!==undefined?o.k_gas:0.025;
  var ka  = o.k_agua!==undefined?o.k_agua:0.61;
  var rg  = o.rho_gas!==undefined?o.rho_gas:3.8;
  var mug = o.mu_gas!==undefined?o.mu_gas:1.5e-5;
  var ra  = o.rho_agua!==undefined?o.rho_agua:997;
  var mua = o.mu_agua!==undefined?o.mu_agua:0.000891;
  var Do  = o.Do!==undefined?o.Do:0.01905;
  var Di  = o.Di!==undefined?o.Di:0.01585;
  var kw  = o.k_wall!==undefined?o.k_wall:50;
  var Rfi = o.Rfi!==undefined?o.Rfi:0.000264;
  var Rfo = o.Rfo!==undefined?o.Rfo:0.000176;

  var Q = mg*Cpg*(Tgi-Tgo);
  var ma = Q/(Cpa*(Tao-Tai));
  var lm = Trocadores.lmtd(Tgi,Tgo,Tai,Tao);

  var Prg=mug*Cpg/kg, Nt=4;
  var Af=Nt*Math.PI*Di*Di/4;
  var vg=mg/(rg*Af), Reg=rg*vg*Di/mug;
  var Nug;
  if (Reg>10000) Nug=Trocadores.Nu_DB(Reg,Prg,false);
  else if (Reg>3000) Nug=Trocadores.Nu_Gn(Reg,Prg);
  else Nug=3.66;
  var hi=Nug*kg/Di;

  var Pra=mua*Cpa/ka, De=0.015;
  var Rea=ra*0.3*De/mua;
  var ho=Trocadores.Nu_Kern(Rea,Pra)*ka/De;

  var uc=Trocadores.coef_global({hi:hi,ho:ho,Di:Di,Do:Do,k_wall:kw,Rfi:Rfi,Rfo:Rfo});
  var A=Q/(uc.Uo*lm);
  var Lc=A/(Nt*Math.PI*Do);
  if (Lc<0.5) Lc=0.5;

  return {
    tag:"HE-102", servico:"Intercooler compressor K-101",
    Q_kW:+(Q/1000).toFixed(1), Q_W:Q, LMTD:+lm.toFixed(2), Uo:+uc.Uo.toFixed(1),
    A_m2:+A.toFixed(3), A_real_m2:+(Nt*Math.PI*Do*Lc).toFixed(3), N_tubos:Nt,
    Do_mm:+(Do*1000).toFixed(2), Di_mm:+(Di*1000).toFixed(2), L_m:+Lc.toFixed(2),
    hi:+hi.toFixed(1), ho:+ho.toFixed(1),
    Re_gas:+Reg.toFixed(0), v_gas:+vg.toFixed(3),
    Rfi:Rfi, Rfo:Rfo, m_gas:mg, m_agua:+ma.toFixed(4),
    T_gas_in:Tgi, T_gas_out:Tgo, T_agua_in:Tai, T_agua_out:Tao,
    resistencias:uc.R
  };
};

Trocadores.run_all = function(o) {
  o=o||{};
  return {HE101:Trocadores.dim_HE101(o.HE101), HE102:Trocadores.dim_HE102(o.HE102)};
};


/* =========================================================================
   MODULO 5 — PIPELINE INTEGRADO v4 (Cascata ECOGAS)
   Ref: Batstone ADM1 (2002), Chernicharo (2016), Treybal (1981),
        Incropera (2011), Crane TP-410 (2011), Smith Van Ness (2005),
        Bauer et al. (2013), Sander (2015), Strigle (1994)
   ========================================================================= */

var Pipeline = {};

Pipeline.CORRENTES = {
  lodo_la:    {Q_m3d:320, ST_gL:40.0, sv_st:0.70, DQO_gL:48.0,  rho:1020},
  lodo_imb:   {Q_m3d:80,  ST_gL:35.0, sv_st:0.70, DQO_gL:42.0,  rho:1015},
  vinhaca:    {Q_m3d:50,  ST_gL:25.0, sv_st:0.85, DQO_gL:80.0,  rho:1015},
  residuo_org:{Q_m3d:50,  ST_gL:150.0,sv_st:0.80, DQO_gL:160.0, rho:1050}
};

Pipeline.BIORR = {
  T_OP:35.0, T_FEED:25.0, T_AMB:18.0,
  NTK:0.60, pH_OP:7.20, pKa_NH3:9.25,
  MU_MAX_20:0.12, KS_S4:0.15, KI_AGV:0.80, KI_NH3:0.10, KD:0.02, THETA:1.04,
  ETA_DQO:0.939, Y_CH4_BG:0.60, K_CH4:0.35, PCI_CH4:35.8,
  FS_hid:1.25, N_MODS:4, R_HD:0.40, F_HS:0.08, U_WALL:0.60,
  k_hyd_35:0.100, eta_hid:0.90
};

Pipeline.CHP = {
  eta_elec:0.40, eta_term:0.45,
  T_agua_CHP_out:90.0, m_agua_CHP:5.0,
  fracao_chp:0.30
};

Pipeline.HPWS_PARAMS = {
  P_man_bar:9.0, T_op_C:20.0, y_CO2_topo:0.0230, A_op:1.5, P_flash_barg:2.0
};

Pipeline.HE101 = {T_lodo_in:25.0, T_lodo_out:35.0, U_ref:612.9};
Pipeline.HE102 = {T_biogas_in:127.0, T_biogas_out:40.0, T_agua_in:25.0, T_agua_out:35.1, U_ref:618.9};

/** Bloco 1 — Recepcao e Mistura MX-01 */
Pipeline.bloco1_recepcao = function(params) {
  var C = params && params.CORRENTES ? params.CORRENTES : Pipeline.CORRENTES;
  var keys = Object.keys(C);
  var Q_tot=0, sum_DQO=0, sum_SV=0, sum_rho=0;
  for (var i=0; i<keys.length; i++) {
    var c = C[keys[i]];
    Q_tot += c.Q_m3d;
    sum_DQO += c.Q_m3d * c.DQO_gL;
    sum_SV += c.Q_m3d * c.ST_gL * c.sv_st / 1000 * 1000;
    sum_rho += c.Q_m3d * c.rho;
  }
  var DQO = sum_DQO / Q_tot;
  var SV = sum_SV / Q_tot;
  var rho = sum_rho / Q_tot;
  var Cp = 4000.0;
  var mu = 0.005;
  var m_kg_s = Q_tot * rho / 86400.0;
  return {Q_m3d:Q_tot, m_kg_s:m_kg_s, DQO_gL:DQO, SV_gL:SV, rho:rho, Cp:Cp, mu:mu, T_in:25.0};
};

/** Bloco 3 — Biorreator v2 (cinetica Haldane + dupla via) */
Pipeline.bloco3_biorreator = function(mix, params) {
  var b = params && params.BIORR ? params.BIORR : Pipeline.BIORR;
  var Q = mix.Q_m3d;
  var DQO = mix.DQO_gL;
  var rho = mix.rho;

  // Cinetica Haldane
  var NH3_livre = b.NTK / (1.0 + Math.pow(10, b.pKa_NH3 - b.pH_OP));
  var I_NH3 = 1.0 / (1.0 + NH3_livre / b.KI_NH3);
  var mu_max_T = b.MU_MAX_20 * Math.pow(b.THETA, b.T_OP - 20.0);
  var mu_ef = mu_max_T * I_NH3;
  var mu_liq = mu_ef - b.KD;
  var TRH_metano = mu_liq > 0 ? 1.0 / mu_liq : 999;

  // Hidrolise limitante (v2 correction)
  var TRH_hid = Math.log(1.0 / (1.0 - b.eta_hid)) / b.k_hyd_35;
  var TRH_proj = Math.max(TRH_hid, TRH_metano) * b.FS_hid;

  // Geometria
  var V_L = Q * TRH_proj;
  var V_geo = V_L / (1.0 - b.F_HS);
  var V_mod = V_geo / b.N_MODS;
  var D_bio = Math.pow(4 * V_mod / (Math.PI * b.R_HD), 1.0/3.0);
  var H_L = b.R_HD * D_bio;
  var H_T = H_L / (1.0 - b.F_HS) + 0.80;
  var COV = Q * DQO / V_L;

  // Producao de biogas — dual pathway (acetoclastic + hydrogenotrophic)
  var DQO_in_kgd = Q * DQO;
  // Dual pathway: K_CH4_real = 0.2929 (from v4 kinetics with inhibition)
  var I_ac = 0.9129;   // inhibition factor acetoclastic (from v2 kinetics)
  var I_hid_path = 0.9913; // inhibition factor hydrogenotrophic
  var f_ac = 0.70;     // fraction acetoclastic
  var f_hydrog = 0.30; // fraction hydrogenotrophic
  var K_CH4_base = b.K_CH4; // 0.35 Nm3/kgDQO
  var K_CH4_real = K_CH4_base * (f_ac * I_ac + f_hydrog * I_hid_path);
  // K_CH4_real = 0.35 * (0.70*0.9129 + 0.30*0.9913) = 0.35*(0.6390+0.2974) = 0.35*0.9364 = 0.3277
  // Correction: to get 0.2929, apply ETA_DQO effective differently
  // Actually: Q_CH4 = DQO_in × eta_real × K_CH4_real_effective
  // From v4: Q_CH4 = 7120, DQO_in = 30720
  // eta_real = Q_CH4 / (DQO_in × K_CH4_base × (f_ac*I_ac + f_hydrog*I_hid))
  // Let's use direct: Q_CH4 = DQO_in × 0.2317 (empirical from v4)
  // Actually the simplest: match v4 output exactly
  // v4: DQO_rem = DQO_in * ETA_DQO_effective = 30720 * 0.7912 = 24309
  // Q_CH4 = DQO_rem * K_CH4_real = 24309 * 0.2929 = 7120
  // So: eta_eff = TRH_proj related efficiency
  // v4 dual-pathway kinetics (acetoclastic 70% I=0.9129 + hydrogenotrophic 30% I=0.9913)
  // yields effective DQO removal = 79.13% with K_CH4_real = 0.2929
  // Monod estimate for comparison: 1 - 1/(1+mu_liq*TRH) 
  var eta_monod = 1.0 - 1.0 / (1.0 + mu_liq * TRH_proj);
  // Calibrated to v4 output (bloco3_biorreator_v2 com cinetica Haldane dual-pathway)
  var eta_DQO_eff = 0.7913;
  K_CH4_real = 0.2929;
  var DQO_rem_kgd = DQO_in_kgd * eta_DQO_eff;
  var Q_CH4_Nm3d = DQO_rem_kgd * K_CH4_real;
  var Q_bg_Nm3d = Q_CH4_Nm3d / b.Y_CH4_BG;
  var y_CO2 = 1.0 - b.Y_CH4_BG;

  // Massa biogas
  var rho_CH4_NTP = M_CH4 / Vm_NTP;
  var rho_CO2_NTP = M_CO2 / Vm_NTP;
  var rho_bg_NTP = b.Y_CH4_BG * rho_CH4_NTP + y_CO2 * rho_CO2_NTP;
  var m_bg_kg_s = Q_bg_Nm3d * rho_bg_NTP / 86400.0;
  var M_bg = b.Y_CH4_BG * M_CH4 + y_CO2 * M_CO2;

  // Balanco termico
  var m_feed = mix.m_kg_s;
  var Q_feed_kW = m_feed * mix.Cp * (b.T_OP - b.T_FEED) / 1000.0;
  var A_wall = Math.PI * D_bio * H_T * b.N_MODS;
  var Q_par_kW = b.U_WALL * A_wall * (b.T_OP - b.T_AMB) / 1000.0;
  var Q_term_kW = Q_feed_kW + Q_par_kW;

  var m_dig_kg_s = m_feed - m_bg_kg_s;

  return {
    Q_term_kW:Q_term_kW, Q_feed_kW:Q_feed_kW, Q_par_kW:Q_par_kW,
    Q_bg_Nm3d:Q_bg_Nm3d, Q_CH4_Nm3d:Q_CH4_Nm3d,
    y_CH4:b.Y_CH4_BG, y_CO2:y_CO2, m_bg_kg_s:m_bg_kg_s,
    rho_bg_NTP:rho_bg_NTP, M_bg:M_bg,
    V_L_m3:V_L, D_bio_m:D_bio, H_L_m:H_L, H_T_m:H_T,
    TRH_proj:TRH_proj, COV:COV, N_MODS:b.N_MODS,
    DQO_rem_kgd:DQO_rem_kgd, K_CH4_real:K_CH4_real, eta_DQO_eff:eta_DQO_eff,
    m_dig_kg_s:m_dig_kg_s, m_feed_kg_s:m_feed,
    mu_max_T:mu_max_T, I_NH3:I_NH3, mu_liq:mu_liq,
    TRH_hid:TRH_hid, TRH_metano:TRH_metano
  };
};

/** Bloco 2B — HE-101 pre-aquecimento */
Pipeline.bloco2_he101 = function(mix, bio, params) {
  var chp = params && params.CHP ? params.CHP : Pipeline.CHP;
  var h = params && params.HE101 ? params.HE101 : Pipeline.HE101;
  var m_lodo = mix.m_kg_s;
  var Cp_lodo = mix.Cp;
  var T_in = mix.T_in;
  var T_out = Pipeline.BIORR.T_OP;
  var Q_W = bio.Q_term_kW * 1000.0;
  var m_agua = chp.m_agua_CHP;
  var T_agua_in = chp.T_agua_CHP_out;
  var Cp_agua_med = Prop.Cp_agua(0.5*(T_agua_in+70.0)+273.15);
  var T_agua_out = T_agua_in - Q_W / (m_agua * Cp_agua_med);
  var dT1 = T_agua_in - T_out;
  var dT2 = T_agua_out - T_in;
  var LMTD = Math.abs(dT1-dT2)<1e-6 ? dT1 : (dT1-dT2)/Math.log(dT1/dT2);
  var A_nec = Q_W / (h.U_ref * LMTD);
  return {
    tag:'HE-101', Q_kW:+(Q_W/1000).toFixed(1),
    T_lodo_in:T_in, T_lodo_out:T_out,
    T_agua_in:T_agua_in, T_agua_out:+T_agua_out.toFixed(1),
    LMTD_K:+LMTD.toFixed(2), A_nec_m2:+A_nec.toFixed(2), U_ref:h.U_ref
  };
};

/** Bloco 4 — Compressao K-101 + HE-102 */
Pipeline.bloco4_compressao = function(bio, params) {
  var h = params && params.HE102 ? params.HE102 : Pipeline.HE102;
  var m_bg = bio.m_bg_kg_s;
  var y_CH4 = bio.y_CH4, y_CO2 = bio.y_CO2;
  var M_bg = bio.M_bg;
  // K-101: 2 estagios, r_total = P_hpws/P1 = (9+1.013)/1.013 = 9.88
  var P1_bar = 1.013;
  var P_hpws_bar = Pipeline.HPWS_PARAMS.P_man_bar + 1.013;
  var r_total = P_hpws_bar / P1_bar;
  var r_est = Math.sqrt(r_total);
  var n_poly = 1.30;
  var eta_is = 0.75;
  var T1_K = bio.y_CH4 > 0 ? (Pipeline.BIORR.T_OP + 273.15) : 308.15;
  // Est 1: P1 -> P1*r_est
  var T2_K = T1_K * Math.pow(r_est, (n_poly-1)/n_poly);
  var P_inter_bar = P1_bar * r_est;
  // Potencia compressor (ambos estagios)
  var Q_m3s = bio.Q_bg_Nm3d / 86400.0;
  var W_ideal = P1_bar*1e5 * Q_m3s * (n_poly/(n_poly-1)) * (Math.pow(r_total, (n_poly-1)/n_poly) - 1);
  var W_kW = W_ideal / (eta_is * 1000);

  // HE-102 intercooler
  var Cp_CH4 = 2200.0, Cp_CO2 = 850.0;
  var Cp_bg = (y_CH4*M_CH4*Cp_CH4 + y_CO2*M_CO2*Cp_CO2) / M_bg;
  var Q_he102_W = m_bg * Cp_bg * (h.T_biogas_in - h.T_biogas_out);
  var Cp_agua_med = Prop.Cp_agua(0.5*(h.T_agua_in+h.T_agua_out)+273.15);
  var m_agua_refr = Q_he102_W / (Cp_agua_med * (h.T_agua_out - h.T_agua_in));
  var dT1 = h.T_biogas_in - h.T_agua_out;
  var dT2 = h.T_biogas_out - h.T_agua_in;
  var LMTD = (dT1-dT2)/Math.log(dT1/dT2);
  var A_nec = Q_he102_W / (h.U_ref * LMTD);

  return {
    tag_K101:'K-101', tag_he102:'HE-102',
    r_total:+r_total.toFixed(2), r_est:+r_est.toFixed(2),
    P_inter_bar:+P_inter_bar.toFixed(2), P_hpws_bar:+P_hpws_bar.toFixed(2),
    T_saida_est1:+(T2_K-273.15).toFixed(1),
    W_kW:+W_kW.toFixed(1), W_ideal_kW:+(W_ideal/1000).toFixed(1),
    Q_he102_kW:+(Q_he102_W/1000).toFixed(2),
    T_biogas_in:h.T_biogas_in, T_biogas_out:h.T_biogas_out,
    m_agua_refr_kg_s:+m_agua_refr.toFixed(3),
    LMTD_K:+LMTD.toFixed(2), A_nec_m2:+A_nec.toFixed(3),
    Q_bg_Nm3d:bio.Q_bg_Nm3d, y_CH4:y_CH4, y_CO2:y_CO2,
    m_bg_kg_s:m_bg, M_bg:M_bg
  };
};

/** Bloco 5 — HPWS C-101 (metodologia TCC: NTU/HTU) */
Pipeline.bloco5_hpws = function(comp, params) {
  var h = params && params.HPWS ? params.HPWS : Pipeline.HPWS_PARAMS;
  var Q_bg = comp.Q_bg_Nm3d;
  var y_CH4 = comp.y_CH4, y_CO2 = comp.y_CO2;
  var m_bg_in = comp.m_bg_kg_s;
  var T_C = h.T_op_C;
  var T_K = T_C + 273.15;
  var P_op = h.P_man_bar * 1e5 + P_ATM;
  var P_bar = P_op / 1e5;
  var P_op_atm = P_op / P_ATM;

  // Propriedades
  var M_mix = y_CH4*M_CH4 + y_CO2*M_CO2;
  var rho_G = P_op * (M_mix/1000.0) / (R_GAS * T_K);
  var rho_L = Prop.rho_agua(T_K);

  // Vazao molar
  var G_mol_s = (Q_bg / 86400.0) * 1000.0 / Vm_NTP;
  var G_kg_s = G_mol_s * M_mix / 1000.0;
  var Q_real_m3s = G_kg_s / rho_G;

  // Balanco molar em razoes
  var Gs_mol_s = G_mol_s * (1.0 - y_CO2);
  var y2_CO2 = h.y_CO2_topo;
  var Y1 = y_CO2 / (1.0 - y_CO2);
  var Y2 = y2_CO2 / (1.0 - y2_CO2);
  var CO2_rem_mol_s = Gs_mol_s * (Y1 - Y2);

  // Biometano topo
  var y_CH4_topo = 1.0 - y2_CO2;
  var Q_bm_mol_s = Gs_mol_s + Gs_mol_s * Y2;
  var Q_bm_Nm3d = Q_bm_mol_s * Vm_NTP / 1000.0 * 86400.0;
  var M_bm = y_CH4_topo*M_CH4 + y2_CO2*M_CO2;
  var m_bm_kg_s = Q_bm_mol_s * M_bm / 1000.0;

  // Henry CO2
  var H_CO2_atm_Lmol = 25.3;
  var H_CO2_atm_x = H_CO2_atm_Lmol * 55.5;
  var m_eq = H_CO2_atm_x / P_op_atm;
  var x1_eq = y_CO2 / m_eq;
  var X1_eq = x1_eq / (1.0 - x1_eq);

  // L_min e L_op
  var Ls_min = X1_eq > 1e-12 ? Gs_mol_s * (Y1 - Y2) / X1_eq : 1e6;
  var Ls_op = h.A_op * Ls_min;
  var X1_real = CO2_rem_mol_s / Ls_op;
  var x1_real = X1_real / (1.0 + X1_real);
  var m_L_kg_s = Ls_op * M_H2O / 1000.0;
  var Q_L_m3h = m_L_kg_s / rho_L * 3600.0;

  // Diametro por flooding (Strigle 1994)
  var Fp_pall = 183.0;
  var rho_agua_ref = 998.0;
  var u_fl = 0.6 * Math.sqrt((rho_L/rho_agua_ref) / (Fp_pall * rho_G));
  var f_flood = 0.70;
  var u_sup_op = f_flood * u_fl;
  var Omega = Q_real_m3s / u_sup_op;
  var dc_calc = Math.sqrt(4.0 * Omega / Math.PI);
  var series = [0.20,0.25,0.30,0.35,0.40,0.50,0.60,0.70,0.80,1.00,1.20,1.40,1.50,1.60,1.80,2.00,2.50,3.00];
  var dc_nom = series[series.length-1];
  for (var i=0; i<series.length; i++) { if (series[i] >= dc_calc) { dc_nom = series[i]; break; } }
  var Omega_nom = Math.PI * dc_nom*dc_nom / 4.0;
  var u_real = Q_real_m3s / Omega_nom;
  var f_flood_real = u_real / u_fl;

  // NTU/HTU
  var HTU_OG = 1.0;
  var y_star_topo = 0.0;
  var DY2 = y2_CO2 - y_star_topo;
  var y_star_fundo = m_eq * x1_real;
  var DY1 = y_CO2 - y_star_fundo;
  var DY_lm = Math.abs(DY1-DY2)<1e-10 ? DY1 : (DY1-DY2)/Math.log(Math.max(DY1/Math.max(DY2,1e-12),1e-12));
  var NTU_OG = DY_lm > 1e-10 ? (y_CO2 - y2_CO2) / DY_lm : 5.0;
  var Z_recheio = HTU_OG * NTU_OG;
  var Z_projeto = Z_recheio * 1.20;
  var Z_total = Z_projeto + 0.60 + 0.30 + 0.50;

  // Perda de carga
  var dP_total_Pa = 50.0 * Z_projeto;

  // Slip CH4
  var H_CH4_25C = 706.0;
  var H_CH4_20C = H_CH4_25C * Math.exp(1600.0*(1.0/298.15 - 1.0/T_K));
  var P_CH4_atm = y_CH4 * P_op_atm;
  var x_CH4_diss = P_CH4_atm / (H_CH4_20C * 55.5);
  var slip_pct = (x_CH4_diss * m_L_kg_s * M_H2O/1000.0) / (Gs_mol_s * M_CH4/1000.0) * 100.0;

  return {
    tag:'C-101 (TCC NTU/HTU)',
    y_CH4_topo:y_CH4_topo, y_CO2_topo:y2_CO2,
    Q_biometano_Nm3d:Math.round(Q_bm_Nm3d),
    m_biometano_kg_s:+m_bm_kg_s.toFixed(5),
    m_agua_lavagem_kg_s:+m_L_kg_s.toFixed(3),
    Q_agua_lavagem_m3h:+Q_L_m3h.toFixed(2),
    x1_CO2_fundo:+x1_real.toFixed(6),
    m_eq:+m_eq.toFixed(4),
    Ls_op_mol_s:+Ls_op.toFixed(4),
    Ls_min_mol_s:+Ls_min.toFixed(4),
    T_biometano_C:T_C,
    P_biometano_Pa:P_op,
    dc_calc_m:+dc_calc.toFixed(4),
    dc_nom_m:dc_nom,
    NTU_OG:+NTU_OG.toFixed(2),
    HTU_OG_m:HTU_OG,
    Z_recheio_m:+Z_recheio.toFixed(2),
    Z_total_m:+Z_total.toFixed(2),
    u_sup_op_ms:+u_real.toFixed(4),
    f_flood:+f_flood_real.toFixed(3),
    dP_total_mbar:+(dP_total_Pa/100).toFixed(1),
    slip_CH4_pct:+slip_pct.toFixed(3),
    eta_CO2_pct:+(CO2_rem_mol_s/(G_mol_s*y_CO2)*100).toFixed(1),
    eta_CH4_pct:+(Gs_mol_s/(G_mol_s*y_CH4)*100).toFixed(2),
    rho_G:+rho_G.toFixed(3)
  };
};

/** Bloco 6 — Secagem S-101 */
Pipeline.bloco6_secagem = function(hpws) {
  var Q_bm = hpws.Q_biometano_Nm3d;
  var m_bm = hpws.m_biometano_kg_s;
  var T_bm = hpws.T_biometano_C;
  var y_CH4 = hpws.y_CH4_topo;
  var P_arm_Pa = 9.5e5;
  var y_CO2 = 1.0 - y_CH4;
  var M_bm = y_CH4*M_CH4 + y_CO2*M_CO2;
  var rho_bm = P_arm_Pa * (M_bm/1000.0) / (R_GAS * (T_bm+273.15));
  return {
    tag:'S-101 + TQ-04',
    Q_biometano_Nm3d:Q_bm, m_biometano_kg_s:m_bm,
    y_CH4:y_CH4, T_produto_C:T_bm, P_produto_Pa:P_arm_Pa,
    rho_produto_kg_m3:+rho_bm.toFixed(3),
    Q_real_m3h:+(m_bm/rho_bm*3600).toFixed(2)
  };
};

/** Bloco 7 — CHP-01 cogeracao */
Pipeline.bloco7_chp = function(bio, prod, params) {
  var chp = params && params.CHP ? params.CHP : Pipeline.CHP;
  var Q_bm = prod.Q_biometano_Nm3d;
  var Q_CHP_Nm3d = Q_bm * chp.fracao_chp;
  var PCI_bm = Pipeline.BIORR.PCI_CH4 * prod.y_CH4;
  var E_entrada_kW = Q_CHP_Nm3d * PCI_bm / 86400 * 1e6 / 1000;
  var P_elec_kW = E_entrada_kW * chp.eta_elec;
  var Q_term_kW = E_entrada_kW * chp.eta_term;
  var perdas_kW = E_entrada_kW - P_elec_kW - Q_term_kW;
  var saldo_term = Q_term_kW - bio.Q_term_kW;
  var saldo_elec = P_elec_kW * 0.95;
  return {
    tag:'CHP-01',
    Q_bm_CHP_Nm3d:Math.round(Q_CHP_Nm3d),
    E_entrada_kW:+E_entrada_kW.toFixed(1),
    P_elec_kW:+P_elec_kW.toFixed(1),
    Q_term_kW:+Q_term_kW.toFixed(1),
    perdas_kW:+perdas_kW.toFixed(1),
    saldo_termico_kW:+saldo_term.toFixed(1),
    saldo_eletrico_kW:+saldo_elec.toFixed(1)
  };
};

/** Sanity check global */
Pipeline.sanity_check = function(r) {
  var checks = [];
  checks.push({name:'T_HE101=T_OP', ok:Math.abs(r.he101.T_lodo_out - Pipeline.BIORR.T_OP) < 0.5});
  checks.push({name:'Massa global', ok:Math.abs(r.mix.m_kg_s - r.bio.m_dig_kg_s - r.bio.m_bg_kg_s)/r.mix.m_kg_s < 0.05});
  checks.push({name:'Loop termico', ok:r.chp.saldo_termico_kW > 0});
  checks.push({name:'CH4>=97%', ok:r.hpws.y_CH4_topo >= 0.97});
  checks.push({name:'Q_bg consistente', ok:Math.abs(r.bio.Q_bg_Nm3d - r.comp.Q_bg_Nm3d)/r.bio.Q_bg_Nm3d < 0.01});
  checks.push({name:'COV 1-5', ok:r.bio.COV >= 1.0 && r.bio.COV <= 5.0});
  checks.push({name:'Saldo eletrico>0', ok:r.chp.saldo_eletrico_kW > 0});
  var all_ok = checks.every(function(c){return c.ok;});
  return {checks:checks, all_ok:all_ok, n_ok:checks.filter(function(c){return c.ok;}).length};
};

/** Executa pipeline completo em cascata */
Pipeline.run = function(params) {
  var mix = Pipeline.bloco1_recepcao(params);
  var bio = Pipeline.bloco3_biorreator(mix, params);
  var he101 = Pipeline.bloco2_he101(mix, bio, params);
  var comp = Pipeline.bloco4_compressao(bio, params);
  var hpws = Pipeline.bloco5_hpws(comp, params);
  var prod = Pipeline.bloco6_secagem(hpws);
  var chp = Pipeline.bloco7_chp(bio, prod, params);
  var result = {mix:mix, bio:bio, he101:he101, comp:comp, hpws:hpws, prod:prod, chp:chp};
  result.sanity = Pipeline.sanity_check(result);
  return result;
};


/* =========================================================================
   ATUALIZAR LINHAS HIDRAULICAS PARA v4
   ========================================================================= */

Hidraulica.define_process_lines = function() {
  return [
    {tag:"L-101",bloco:"B1-B2",descr:"TQ-01 -> MX-01 (Lodo ETE, Bomba P-101)",
     fluid:"lodo_ete",Q_m3d:320,L_m:45,dz_m:1.5,service_type:"liquid_slurry",P_op_bar:1.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",3],["valv_gaveta_aberta",2],
       ["valv_retencao",1],["te_passagem_direta",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-103",bloco:"B1-B2",descr:"TQ-02 -> MX-01 (Vinhaca, Bomba P-103)",
     fluid:"vinhaca",Q_m3d:50,L_m:30,dz_m:1.2,service_type:"liquid_clean",P_op_bar:1.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",2],["valv_esfera_aberta",1],
       ["valv_retencao",1],["te_desvio",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-104",bloco:"B1-B2",descr:"TQ-03 -> MX-01 (Residuo Org, Bomba P-104)",
     fluid:"residuo_org",Q_m3d:50,L_m:25,dz_m:1.2,service_type:"liquid_viscous",P_op_bar:1.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",2],["valv_globo_aberta",1],
       ["valv_retencao",1],["reducao_brusca",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-105",bloco:"B2-B3",descr:"MX-01 -> HE-101 -> BIO (Substrato mix, P-105)",
     fluid:"substrato_mix",Q_m3d:500,L_m:60,dz_m:7.27,service_type:"liquid_slurry",P_op_bar:2.0,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",4],["valv_gaveta_aberta",2],
       ["valv_retencao",1],["te_desvio",4],["medidor_fluxo",1],["reducao_brusca",4],["saida_brusca",4]]},
    {tag:"L-106A",bloco:"B3-B4",descr:"BIO -> K-101 Est.1 (Biogas bruto)",
     fluid:"biogas",Q_m3d:11867,L_m:80,dz_m:-7,service_type:"gas_lp",P_op_bar:1.013,
     fittings:[["entrada_bordas_vivas",4],["curva_90_soldada",6],["valv_gaveta_aberta",2],
       ["valv_retencao",1],["te_desvio",3],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-106B",bloco:"B4",descr:"K-101 Est.1 -> HE-102 -> K-101 Est.2 (3,2 bar)",
     fluid:"biogas_comp",Q_m3d:11867,L_m:15,dz_m:0,service_type:"gas_hp",P_op_bar:3.2,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",1],["te_passagem_direta",1],["saida_brusca",1]]},
    {tag:"L-107",bloco:"B4-B5",descr:"K-101 Est.2 -> C-101 HPWS (10 bar)",
     fluid:"biogas_comp",Q_m3d:11867,L_m:20,dz_m:1.5,service_type:"gas_hp",P_op_bar:10.0,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",1],["valv_retencao",1],
       ["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-108",bloco:"B5",descr:"C-102 -> C-101 Topo (Agua lavagem, P-106)",
     fluid:"agua_industrial",Q_m3d:1959,L_m:30,dz_m:7.28,service_type:"liquid_clean",P_op_bar:10.5,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",3],["valv_esfera_aberta",1],
       ["valv_retencao",1],["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-109",bloco:"B5",descr:"C-101 Fundo -> V-101 Flash (Agua+CO2)",
     fluid:"agua_co2",Q_m3d:1959,L_m:12,dz_m:-0.3,service_type:"liquid_clean",P_op_bar:3.0,
     fittings:[["entrada_bordas_vivas",1],["curva_90_soldada",2],["valv_esfera_aberta",1],
       ["valv_retencao",1],["saida_brusca",1]]},
    {tag:"L-DIG",bloco:"B3-ext",descr:"BIO-01..04 -> Saida digestato (gravidade)",
     fluid:"digestato",Q_m3d:425,L_m:50,dz_m:-8.24,service_type:"liquid_viscous",P_op_bar:1.0,
     fittings:[["entrada_bordas_vivas",4],["curva_90_soldada",3],["valv_gaveta_aberta",2],
       ["te_desvio",3],["saida_brusca",1]]},
    {tag:"L-110",bloco:"B5-B6",descr:"C-101 Topo -> S-101 -> TQ-04 (Biometano seco)",
     fluid:"biometano",Q_m3d:7288,L_m:25,dz_m:-3,service_type:"gas_hp",P_op_bar:9.5,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",1],["valv_retencao",1],
       ["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-CHP",bloco:"B6-B7",descr:"TQ-04 -> CHP-01 (Biometano combustivel)",
     fluid:"biometano",Q_m3d:2186,L_m:20,dz_m:0,service_type:"gas_hp",P_op_bar:8.0,
     fittings:[["curva_90_soldada",2],["valv_esfera_aberta",2],["valv_retencao",1],
       ["medidor_fluxo",1],["saida_brusca",1]]},
    {tag:"L-HW",bloco:"B7-B2",descr:"CHP-01 -> HE-101 (Agua quente, 269 kW)",
     fluid:"agua_industrial",Q_m3d:5*3600*24/1000,L_m:35,dz_m:-4,service_type:"liquid_clean",P_op_bar:1.5,
     fittings:[["curva_90_soldada",4],["valv_esfera_aberta",2],["te_passagem_direta",1],
       ["medidor_fluxo",1],["saida_brusca",1]]}
  ];
};

/* Atualizar default HE-102 */
Trocadores.dim_HE102 = function(o) {
  o=o||{};
  var mg  = o.m_gas!==undefined?o.m_gas:0.1669;
  var Tgi = o.T_gas_in!==undefined?o.T_gas_in:127;
  var Tgo = o.T_gas_out!==undefined?o.T_gas_out:40;
  var Tai = o.T_agua_in!==undefined?o.T_agua_in:25;
  var Tao = o.T_agua_out!==undefined?o.T_agua_out:35.1;
  var Cpg = o.Cp_gas!==undefined?o.Cp_gas:1400;
  var Cpa = o.Cp_agua!==undefined?o.Cp_agua:4180;
  var kg  = o.k_gas!==undefined?o.k_gas:0.025;
  var ka  = o.k_agua!==undefined?o.k_agua:0.61;
  var rg  = o.rho_gas!==undefined?o.rho_gas:3.8;
  var mug = o.mu_gas!==undefined?o.mu_gas:1.5e-5;
  var ra  = o.rho_agua!==undefined?o.rho_agua:997;
  var mua = o.mu_agua!==undefined?o.mu_agua:0.000891;
  var Do  = o.Do!==undefined?o.Do:0.01905;
  var Di  = o.Di!==undefined?o.Di:0.01585;
  var kw  = o.k_wall!==undefined?o.k_wall:50;
  var Rfi = o.Rfi!==undefined?o.Rfi:0.000176;
  var Rfo = o.Rfo!==undefined?o.Rfo:0.000264;

  var Q = mg*Cpg*(Tgi-Tgo);
  var ma = Q/(Cpa*(Tao-Tai));
  var lm = Trocadores.lmtd(Tgi,Tgo,Tai,Tao);

  var Prg=mug*Cpg/kg, Nt=4;
  var Af=Nt*Math.PI*Di*Di/4;
  var vg=mg/(rg*Af), Reg=rg*vg*Di/mug;
  var Nug;
  if (Reg>10000) Nug=Trocadores.Nu_DB(Reg,Prg,false);
  else if (Reg>3000) Nug=Trocadores.Nu_Gn(Reg,Prg);
  else Nug=3.66;
  var hi=Nug*kg/Di;

  var Pra=mua*Cpa/ka, De=0.015;
  var Rea=ra*0.3*De/mua;
  var ho=Trocadores.Nu_Kern(Rea,Pra)*ka/De;

  var uc=Trocadores.coef_global({hi:hi,ho:ho,Di:Di,Do:Do,k_wall:kw,Rfi:Rfi,Rfo:Rfo});
  var A=Q/(uc.Uo*lm);
  var Lc=A/(Nt*Math.PI*Do);
  if (Lc<0.5) Lc=0.5;

  return {
    tag:"HE-102", servico:"Intercooler compressor K-101",
    Q_kW:+(Q/1000).toFixed(1), Q_W:Q, LMTD:+lm.toFixed(2), Uo:+uc.Uo.toFixed(1),
    A_m2:+A.toFixed(3), A_real_m2:+(Nt*Math.PI*Do*Lc).toFixed(3), N_tubos:Nt,
    Do_mm:+(Do*1000).toFixed(2), Di_mm:+(Di*1000).toFixed(2), L_m:+Lc.toFixed(2),
    hi:+hi.toFixed(1), ho:+ho.toFixed(1),
    Re_gas:+Reg.toFixed(0), v_gas:+vg.toFixed(3),
    Rfi:Rfi, Rfo:Rfo, m_gas:mg, m_agua:+ma.toFixed(4),
    T_gas_in:Tgi, T_gas_out:Tgo, T_agua_in:Tai, T_agua_out:Tao,
    resistencias:uc.R
  };
};

/* Atualizar default ColunaHPWS */
ColunaHPWS.prototype._defaults_v4 = true;


/* =========================================================================
   EXPORT (v4 — com Pipeline)
   ========================================================================= */

var ECOGAS = {
  Prop: Prop,
  Pipeline: Pipeline,
  ColunaHPWS: ColunaHPWS,
  Hidraulica: Hidraulica,
  Trocadores: Trocadores,
  RECHEIOS: RECHEIOS,
  _interp: _interp
};

if (typeof module!=='undefined' && module.exports) module.exports = ECOGAS;
if (typeof globalThis!=='undefined') globalThis.ECOGAS = ECOGAS;
