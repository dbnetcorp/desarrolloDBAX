using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.DBAX.Modelo.DAC;

namespace DBNeT.DBAX.Controlador
{
    public class GrupoRamosController
    {
        GrupoRamosDAC _goGrupoRamosDAC;
        public GrupoRamosController()
        { _goGrupoRamosDAC = new GrupoRamosDAC(); }

        /// <summary>
        /// Obtiene los segmentos de las compañías
        /// </summary>
        /// <returns></returns>
        public DataTable getSegmentos()
        { return _goGrupoRamosDAC.getSegmentos(); }

        /// <summary>
        /// Obtiene todos los informes de tipo cuadros tecnicos
        /// </summary>
        /// <returns></returns>
        public DataTable getCuadros()
        { return _goGrupoRamosDAC.getCuadros(); }

        public DataTable getPeriodos(string tsCodiPers, int tnCorrInst)
        { return _goGrupoRamosDAC.getPeriodos(tsCodiPers, tnCorrInst); }

        /// <summary>
        /// Obtiene la(s) dimension(es) de un informe
        /// </summary>
        /// <param name="tsCodiDein">Código Informe</param>
        /// <returns>datatable</returns>
        public DataTable getDimension(string tsCodiDein)
        { return _goGrupoRamosDAC.getDimensiones(tsCodiDein); }
        /// <summary>
        /// Metodo que obtiene los conceptos para un informe
        /// </summary>
        /// <param name="ts_codi_dein">Código Informe</param>
        /// <param name="ts_codi_dime">Código Dimensión</param>
        /// <returns>datatable</returns>
        public DataTable getConceptos(string ts_codi_dein, string ts_codi_dime)
        { return _goGrupoRamosDAC.getConceptos(ts_codi_dein, ts_codi_dime); }

        public DataTable getMiembros(string tsCodiPers, string tsCorrInst, string tsVersInst, string tsCodiInfo, string tsDimension)
        { return _goGrupoRamosDAC.getMiembros(tsCodiPers, tsCorrInst, tsVersInst, tsCodiInfo, tsDimension); }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tsCodiSegm">Segmento</param>
        /// <param name="tsCodiConc">Código Concepto</param>
        /// <param name="tsCodiInfoCuadro">Cuadro Tecnico</param>
        /// <returns></returns>
        public DataTable getInformeRamosEmpresa(string tsCodiSegm, string tsCodiConc, string tsCodiInfoCuadro, string tsCodiDime, int tnCorrInst, string tsCodiMone)
        {
            DataTable dtEmpresa = _goGrupoRamosDAC.getEmpresas(tsCodiSegm, tnCorrInst);
            DataTable dtRamos = _goGrupoRamosDAC.getRamos(tsCodiSegm);
            DataTable dtInforme = _goGrupoRamosDAC.getInformeRamosEmpresa(tsCodiSegm, tsCodiInfoCuadro, tsCodiConc, tnCorrInst, dtEmpresa, dtRamos, tsCodiMone);
            dtInforme = _goGrupoRamosDAC.eliminaColumna(dtInforme).Copy(); 
            return dtInforme;
        }

        public void generaHTML(string tsRuta, DataTable tdInforme)
        {_goGrupoRamosDAC.GeneraHtml(tsRuta, tdInforme);}
    }
}