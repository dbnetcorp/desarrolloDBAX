using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.DBAX.Modelo.DAC;

namespace DBNeT.DBAX.Controlador
{
    public class DbaxTipoConcController
    {
        DbaxTipoConcDAC _goDbaxTipoConcDAC;
        public DbaxTipoConcController()
        { _goDbaxTipoConcDAC = new DbaxTipoConcDAC(); }

        /// <summary>
        /// Metodo para Insertar Registros en el Procedimiento Almacenado S_I_dbax_tipo_conc
        /// </summary>
        /// <param name="toDbaxTipoConcBE"></param>
        public void createDbaxTipoConc(DbaxTipoConcBE toDbaxTipoConcBE)
        {
            _goDbaxTipoConcDAC.createDbaxTipoConc(toDbaxTipoConcBE);
        }

        /// <summary>
        /// Método para Obtener Los registros de la tabla dbax_tipo_conc, si se va a realizar un select para Mantenedor
        /// </summary>
        /// <param name="tnTipo">Tipo de Select S Select Mantenedor  L Listador  LV Lista de Valores</param>
        /// <param name="pnPagina">Página a Obtener</param>
        /// <param name="pnRegPag">Número de Registros por Páginas</param>
        /// <param name="psCondicion">SQL Dinámico</param>
        /// <param name="psPar1">Parámetro 1 ó P_PARAM_NAME</param>
        /// <param name="psPar2">Parámetro 2</param>
        /// <param name="psPar3">Parámetro 3</param>
        /// <param name="psPar4">Parámetro 4</param>
        /// <param name="psPar5">Parámetro 5</param>
        /// <param name="ts_codi_usua">Usuario</param>
        /// <param name="tn_codi_empr">Empresa</param>
        /// <param name="ts_codi_emex">Holding</param>
        /// <returns></returns>
        public List<DbaxTipoConcBE> readDbaxTipoConcList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            return _goDbaxTipoConcDAC.readDbaxTipoConcList(tsTipo, tnPagina, tnRegPag, tsCondicion, tsPar1, tsPar2, tsPar3, tsPar4, tsPar5, ts_codi_usua, tn_codi_empr, ts_codi_emex);
        }

        public DataTable readDbaxTipoConcDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            return _goDbaxTipoConcDAC.readDbaxTipoConcDt(tsTipo, tnPagina, tnRegPag, tsCondicion, tsPar1, tsPar2, tsPar3, tsPar4, tsPar5, ts_codi_usua, tn_codi_empr, ts_codi_emex);
        }

        /// <summary>
        /// Metodo para obtener 1 Registro desde la Base de Datos de la Tabla dbax_tipo_conc
        /// </summary>
        /// <param name="psTipo">S = para 1 Registro</param>
        /// <param name="pnPagina">0</param>
        /// <param name="pnRegPag">0</param>
        /// <param name="psCondicion">NULL</param>
        /// <param name="psPar1">PARAM_NAME</param>
        /// <param name="psPar2">NULL</param>
        /// <param name="psPar3">NULL</param>
        /// <param name="psPar4">NULL</param>
        /// <param name="psPar5">NULL</param>
        /// <param name="ts_codi_usua">Usuario</param>
        /// <param name="tn_codi_empr">Empresa</param>
        /// <param name="ts_codi_emex">Holding</param>
        /// <returns></returns>
        public DbaxTipoConcBE readDbaxTipoConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            return _goDbaxTipoConcDAC.readDbaxTipoConc(tsTipo, tnPagina, tnRegPag, tsCondicion, tsPar1, tsPar2, tsPar3, tsPar4, tsPar5, ts_codi_usua, tn_codi_empr, ts_codi_emex);
        }

        /// <summary>
        /// Metodo para Actualizar los Datos de la Tabla dbax_tipo_conc, todos los parametros se asignan a traves de las BE
        /// </summary>
        /// <param name="toDbaxTipoConcBE"></param>
        public void updateDbaxTipoConc(DbaxTipoConcBE toDbaxTipoConcBE)
        {
            _goDbaxTipoConcDAC.updateDbaxTipoConc(toDbaxTipoConcBE);
        }

        /// <summary>
        /// Método para Eliminar 1 Registro de la tabla dbax_tipo_conc
        /// <param name="tsTipoConc"></param>
        /// </summary>
        public void deleteDbaxTipoConc(string tsTipoConc)
        {
            _goDbaxTipoConcDAC.deleteDbaxTipoConc(tsTipoConc);
        }
    }
}