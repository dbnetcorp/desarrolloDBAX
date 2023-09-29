using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.DBAX.Modelo.DAC;
using System.Data;

namespace DBNeT.DBAX.Controlador
{
    public class DbaxEmpresaPeriodoController
    {
        RescateDeConceptos _goDbaxRescConc;
        ModeloMantencionCntx _goDbaxMantCntx;
        GeneracionHTML genHtml;
        Conexion con;
        MantencionCntx cntx;
        public DbaxEmpresaPeriodoController()
        {
            _goDbaxRescConc = new RescateDeConceptos();
            con = new Conexion().CrearInstancia();
            _goDbaxMantCntx = new ModeloMantencionCntx();
            genHtml = new GeneracionHTML();
            cntx = new MantencionCntx();
        }

        public DataTable GetEjesDimension(string CodiInfo, string PrefDime, string CodiDime)
        {
            return con.TraerResultados0(_goDbaxRescConc.GetEjesDimension(CodiInfo, PrefDime, CodiDime)).Tables[0];
        }
        public DataTable GetMiembDimension(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string PrefConc, string CodiAxis)
        {
            //DataTable dt = new DataTable();
            //return dt;
            return con.TraerResultados0(_goDbaxMantCntx.getInformesMiembros(CodiPers, CorrInst, VersInst, CodiInfo, PrefConc, CodiAxis)).Tables[0];
        }
        public DataTable GetMiembTaxoDimension(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string PrefConc, string CodiAxis)
        {
            //DataTable dt = new DataTable();
            //return dt;
            return con.TraerResultados0(_goDbaxMantCntx.getMiembrosTaxo(PrefConc, CodiAxis)).Tables[0];
        }
        public DataTable GetMiembDimensionCuadros(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string PrefConc, string CodiAxis, string OrdeMemb)
        {
            //DataTable dt = new DataTable();
            //return dt;
            return con.TraerResultados0(_goDbaxMantCntx.getInformesMiembrosCuadros(CodiPers, CorrInst, VersInst, CodiInfo, PrefConc, CodiAxis, OrdeMemb)).Tables[0];
        }
        public DataTable GetDescConcDime(string CodiInfo, string CodiDime, string TipoTaxo)
        {
            return con.TraerResultados0(_goDbaxRescConc.getInfoDimensionDescConc(CodiInfo, CodiDime, TipoTaxo)).Tables[0];
        }
        public int GetCounEjes(string CodiInfo, string CodiDime)
        {
            return Convert.ToInt32(con.StringEjecutarQuery(_goDbaxRescConc.GetCounEje(CodiInfo, CodiDime)));
        }
        public DataTable GetValoresPorInfoDimeCntx(string CodiPers, string CorrInst, string VersInst, string CodiCntx, string CodiInfo, string PrefDime, string CodiDime, string CodiMone)
        {
            return con.TraerResultados0(_goDbaxRescConc.GetValoresPorInfoDimeCntx(CodiPers, CorrInst, VersInst, CodiCntx, CodiInfo, PrefDime, CodiDime, CodiMone)).Tables[0];
        }
        public DataTable GetInstDicxPorContexto(string CodiPers, string CorrInst, string VersInst, string CodiCntx)
        {
            return con.TraerResultados0(_goDbaxMantCntx.getInstDicxPorContexto(CodiPers, CorrInst, VersInst, CodiCntx)).Tables[0];
        }

        private DataTable CreaTablaDime(string CodiPers, string CorrInst, string VersInst,string CodiInfo,DataTable[] dtArray, string[, ,] vDime, DataTable dtConcDime, string PrefDime,string CodiDime, string CodiMone)
        {
            //Crear la columnas
            //eliminar las vacias (o saltarselas al crear el datatable)
            DataTable dtDimeTabla, dtDataTable;
            bool vDtVacio;
            dtConcDime.Columns.Remove("codi_conc");
            dtConcDime.Columns.Remove("pref_conc");
            //dtConcDime.Columns.Remove("sald_ini");
            dtConcDime.Columns.Remove("orde_conc");
            string CodiCntxIn;
            int vColuInic = 3;
            int col = vColuInic;
            int i = 0;
            try
            {
                for (i = 0; i < dtArray.Length - 1; i++)
                {
                    // foreach (DataRow item in dtArray[i].Rows) 
                    //{
                    vDtVacio = true;
                    if (dtArray[i].Rows.Count > 0)
                    {
                        dtConcDime.Columns.Add();
                        for (int fil = 0; fil < vDime.GetLength(0); fil++) //Crea el encabezado por eje y columna
                        {
                            if (col == vColuInic)
                            {
                                DataRow newRow = dtConcDime.NewRow();
                                newRow[col] = vDime[fil, i + 1, 2];
                                dtConcDime.Rows.InsertAt(newRow, fil);
                            }
                            else
                                dtConcDime.Rows[fil][col] = vDime[fil, i + 1, 2];
                        }

                        dtConcDime = GetTableDime(CodiPers, CorrInst, VersInst, CodiInfo, dtArray[i], PrefDime, CodiDime, dtConcDime, vDime.GetLength(0), col, CodiMone);
                        if (CodiInfo.Contains("cuadro") && !CodiInfo.EndsWith("(2017)"))
                        {
                            for (int a = 2; a < dtConcDime.Rows.Count; a++)
                            {
                                if (dtConcDime.Rows[a][col].ToString() != string.Empty)
                                {
                                    vDtVacio = false;
                                    break;
                                }
                            }
                            if (vDtVacio)
                            {
                                dtConcDime.Columns.RemoveAt(col);
                                col--;
                                if (col + 1 == vColuInic)
                                {
                                    dtConcDime.Rows.RemoveAt(0);
                                    dtConcDime.Rows.RemoveAt(0);
                                }
                            }
                        }
                        col++;
                    }

                }
                dtConcDime.Columns.Remove("sald_ini");
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);

            }
            return dtConcDime;
        }

        private DataTable GetTableDime(string CodiPers, string CorrInst, string VersInst, string CodiInfo, DataTable dtContextos, string PrefDime, string CodiDime,DataTable dtConcDime,int vFilaInic,int vColuInic, string CodiMone)
        {
            try
            {
                DataTable dtValoColu;
                int CantEjes = vFilaInic;
               
                //Obtiene valores por columa
                dtValoColu = GetValoConcColuDime(CodiPers, CorrInst, VersInst, CodiInfo, dtContextos, dtConcDime, PrefDime, CodiDime, CantEjes, CodiMone);
                
                for (int i = 0; i < dtValoColu.Rows.Count; i++)
                {
                    dtConcDime.Rows[vFilaInic][vColuInic] = dtValoColu.Rows[vFilaInic - CantEjes][0];
                    vFilaInic++;
                }
               
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);
            }
            return dtConcDime;
        }
        private DataTable GetValoConcColuDime(string CodiPers, string CorrInst, string VersInst, string CodiInfo, DataTable dtContextos, DataTable dtConceptos, string PrefDime, string CodiDime, int numeEjes, string CodiMone)
        {
            DataTable dtValoColu, dtValoColu1;
            dtValoColu = null;
            try
            {
                for (int i = 0; i < dtContextos.Rows.Count; i++)
                {
                    if (i == 0)
                    {
                        dtValoColu = GetValoresPorInfoDimeCntx(CodiPers, CorrInst, VersInst, dtContextos.Rows[i]["codi_cntx"].ToString(), CodiInfo, PrefDime, CodiDime, CodiMone);
                        //dtValoColu = dtValoColu1.Copy();
                        if (CodiInfo.Contains("cuadro") && !CodiInfo.EndsWith("(2017)"))
                            dtValoColu.Rows.RemoveAt(0);
                        continue;
                    }
                    dtValoColu1 = GetValoresPorInfoDimeCntx(CodiPers, CorrInst, VersInst, dtContextos.Rows[i]["codi_cntx"].ToString(), CodiInfo, PrefDime, CodiDime, CodiMone);

                    if (CodiInfo.Contains("cuadro") && !CodiInfo.EndsWith("(2017)"))
                        dtValoColu1.Rows.RemoveAt(0);

                    for (int fil = 0; fil < dtValoColu1.Rows.Count; fil++)
                    {
                        //if (dtValoColu1.Rows[fil]["valo_cntx"].ToString()!="")
                        if (
                                (dtConceptos.Rows[fil + numeEjes]["sald_ini"].ToString() == "S" && dtContextos.Rows[i][1].ToString() == "2")
                                || 
                                (dtConceptos.Rows[fil + numeEjes]["sald_ini"].ToString() == "" && dtContextos.Rows[i][1].ToString() == "1" && dtValoColu1.Rows[fil]["valo_cntx"].ToString() != "")
                            )
                        {
                            dtValoColu.Rows[fil]["valo_cntx"] = dtValoColu1.Rows[fil]["valo_cntx"];
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);

            }
            return dtValoColu;
        }

        private DataTable[] GetContxColum(string CodiPers, string CorrInst, string VersInst, string[, ,] vDime, int NumeEjes, string vFecha1, string vFecha2, string vFecha3)
        {
            List<string> vIntersect = new List<string>();
            List<string> vExcept = new List<string>();
            DataTable[] dtArray = new DataTable[vDime.GetLength(1)];
            try
            {
                Console.WriteLine(System.DateTime.Now);
                for (int col = 1; col < vDime.GetLength(1); col++)
                {
                    if (NumeEjes == 1 && vDime[0, col, 1] != "dimension-default")
                    {
                        dtArray[col - 1] = con.TraerResultados0(_goDbaxMantCntx.getCntxDime1(CodiPers, CorrInst, VersInst, vDime[0, 0, 0], vDime[0, col, 0], vFecha1, vFecha2, vFecha3)).Tables[0];
                    }
                    else if (NumeEjes == 2 && vDime[0, col, 1] != "dimension-default" && vDime[1, col, 1] != "dimension-default")
                    {
                        dtArray[col - 1] = con.TraerResultados0(_goDbaxMantCntx.getCntxDime2(CodiPers, CorrInst, VersInst, vDime[0, 0, 0], vDime[0, col, 0], vDime[1, 0, 0], vDime[1, col, 0], vFecha1, vFecha2, vFecha3)).Tables[0];
                    }
                    else if (NumeEjes == 3 && vDime[0, col, 1] != "dimension-default" && vDime[1, col, 1] != "dimension-default" && vDime[2, col, 1] != "dimension-default")
                    {
                        dtArray[col - 1] = con.TraerResultados0(_goDbaxMantCntx.getCntxDime3(CodiPers, CorrInst, VersInst, vDime[0, 0, 0], vDime[0, col, 0], vDime[1, 0, 0], vDime[1, col, 0], vDime[2, 0, 0], vDime[2, col, 0], vFecha1, vFecha2, vFecha3)).Tables[0];
                    }
                    else
                    {
                        for (int fil = 0; fil < vDime.GetLength(0); fil++)
                        {
                            /*if (col == 287) {
                                 Console.WriteLine("asd");
                            }*/
                            if (vDime[fil, col, 1] == "dimension-default")
                            {
                                vExcept.Add(GetExceptDime(CodiPers, CorrInst, VersInst, vDime[fil, 0, 0]));

                            }
                            else
                            {
                                vIntersect.Add(GetIntersectDime(CodiPers, CorrInst, VersInst, vDime[fil, 0, 0], vDime[fil, col, 0]));
                            }
                        }
                         dtArray[col - 1] = con.TraerResultados0(CreaConsultaContx(CodiPers, CorrInst, VersInst, vExcept, vIntersect)).Tables[0];

                        /*if (dtArray[col - 1].Rows.Count > 0)
                        {
                            Console.WriteLine("En " + col + " hay datos");
                        }*/
                        //Console.WriteLine(System.DateTime.Now + ", " + col);
                        vExcept.Clear();
                        vIntersect.Clear();

                        /*for (int j = 0; j < dtArray[col - 1].Rows.Count; j++)
                        {
                            DataTable dtInstDicx = GetInstDicxPorContexto(CodiPers, CorrInst, VersInst, dtArray[col - 1].Rows[0][0].ToString());
                            if (dtInstDicx.Rows.Count > NumeEjes)
                            {
                                dtArray[col - 1].Rows[j].Delete();
                                dtArray[col - 1].AcceptChanges();
                            }
                        }*/
                        /*
                        if(col%200 == 0)
                            Console.WriteLine(col + " - " +System.DateTime.Now);
                        */
                    }
                }
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);

            }
            return dtArray;
        }


        private string CreaConsultaContx(string CodiPers, string CorrInst,string VersInst,List<string> vExcept, List<string> vIntersect)
        {
            string vQuery="",itemRemov;
            try
            {
                vQuery = GetCntxInst(CodiPers, CorrInst, VersInst);

                foreach (string item in vIntersect)
                {
                    vQuery += " Intersect " + item;
                }
                if (vIntersect.Count > 0)
                {
                    foreach (string item in vExcept)
                    {
                        vQuery += " Except " + item;
                    }
                }
                else
                {
                    foreach (string item in vExcept)
                    {
                        itemRemov = item.Remove(item.LastIndexOf("and "));
                        itemRemov += ")";

                        itemRemov = itemRemov.Substring(0, itemRemov.Substring(0, itemRemov.LastIndexOf("union")).LastIndexOf("and ")) + itemRemov.Substring(itemRemov.LastIndexOf("union"));

                        vQuery += " Except " + itemRemov;


                    }
                }
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);

            }
            return vQuery;
        }

        private string getCntxDime2(string CodiPers, string CorrInst, string VersInst, string vCodiAxis1, string vCodiMemb1, string vCodiAxis2, string vCodiMemb2)
        {
            string vQuery = "execute ";

            return vQuery;
        }

        private string GetCntxInst(string CodiPers, string CorrInst, string VersInst)
        {
            return _goDbaxRescConc.GetCntxInst(CodiPers, CorrInst, VersInst);
           
        }

        private string GetExceptDime(string CodiPers, string CorrInst, string VersInst, string CodiAxis)
        {
            return _goDbaxRescConc.GetExceptDime(CodiPers, CorrInst, VersInst, CodiAxis);
        }

        private string GetIntersectDime(string CodiPers, string CorrInst, string VersInst, string CodiAxis, string CodiMemb)
        {
            return _goDbaxRescConc.GetIntersectDime(CodiPers, CorrInst, VersInst, CodiAxis, CodiMemb);
        }
        public int GetNumeRepe(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string PrefConc, string CodiAxis,DataTable dtEjes,int NumeEje)
        {
            int vNumeRepe=1;
            try
            {
                for (int i = 0; i < dtEjes.Rows.Count; i++)
                {

                    if (Convert.ToInt16(dtEjes.Rows[i]["orde_axis"].ToString()) > NumeEje)
                    {
                        vNumeRepe = vNumeRepe * GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString()).Rows.Count;
                    }

                }
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);
            }
            return vNumeRepe;
        }
        public DataTable GenerateTransposedTable(DataTable inputTable)
        {
            DataTable outputTable = new DataTable();
            try
            {
                outputTable = genHtml.GenerateTransposedTable(inputTable);
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);

            }
            return outputTable;
        }
        public DataTable GenerarDimensiones(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string CodiDime, string TipoTaxo, string CodiMone)
        {
            DataTable dtEjes, dtDimeMemb, dtDescConc, dtDimeTable = null;
            string vPrefDime;
            string[, ,] vDime;
            int vTotalCol = 1;
            int vCol;
            int vCantRepe;
            int cont;
            int ContRepe = 0;
            DataTable[] dtArray;
            // CodiDime = "cl-cs:" + CodiDime;
            try
            {
                vPrefDime = CodiDime.Substring(0, CodiDime.IndexOf(":"));
                CodiDime = CodiDime.Substring(CodiDime.IndexOf(":") + 1);
                dtEjes = GetEjesDimension(CodiInfo, vPrefDime, CodiDime);
                dtDescConc = GetDescConcDime(CodiInfo, CodiDime, TipoTaxo);

                for (int i = 0; i < dtEjes.Rows.Count; i++)
                {
                    vTotalCol = vTotalCol * GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString()).Rows.Count;
                }
                vDime = new string[dtEjes.Rows.Count, vTotalCol + 1, 3];

                for (int i = 0; i < dtEjes.Rows.Count; i++)
                {
                    //vCantRepe guarda la cantidad de vueltas que debo dar para poder armar completamente el encabezado
                    vCantRepe = GetNumeRepe(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString(), dtEjes, i + 1);
                    vCol = 1;
                    ContRepe = 0;
                    dtDimeMemb = GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString());
                    vDime[i, 0, 0] = dtEjes.Rows[i]["pref_axis"].ToString() + ":" + dtEjes.Rows[i]["codi_axis"].ToString();
                    for (int a = 0; a < dtDimeMemb.Rows.Count; a++)
                    {
                        for (int b = 1; b < vCantRepe + 1; b++)
                        {
                            vDime[i, ContRepe + b, 0] = dtDimeMemb.Rows[a]["codi_memb"].ToString();
                            vDime[i, ContRepe + b, 1] = dtDimeMemb.Rows[a]["tipo_memb"].ToString();
                            vDime[i, ContRepe + b, 2] = dtDimeMemb.Rows[a]["desc_memb"].ToString();

                        }
                        ContRepe = ContRepe + vCantRepe;
                    }
                    cont = (vCantRepe * GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString()).Rows.Count + 1); //Celda de donde comenzará a copiar
                    while (cont <= vTotalCol)
                    {
                        vDime[i, cont, 0] = vDime[i, vCol, 0];
                        vDime[i, cont, 1] = vDime[i, vCol, 1];
                        vDime[i, cont, 2] = vDime[i, vCol, 2];
                        cont++;
                        vCol++;
                    }
                }

                string vFecha1 = cntx.getFechasCntx(CorrInst, "inicioano", "anoactual").Tables[0].Rows[0][0].ToString();
                string vFecha2 = cntx.getFechasCntx(CorrInst, "ultimodiatrimestreactual", "anoactual").Tables[0].Rows[0][0].ToString();
                string vFecha3 = cntx.getFechasCntx(CorrInst, "finano", "anoanterior").Tables[0].Rows[0][0].ToString();

                dtArray = GetContxColum(CodiPers, CorrInst, VersInst, vDime, dtEjes.Rows.Count, vFecha1, vFecha2, vFecha3);
                /*int l = 0;
                try
                {
                    for (l = 0; l < dtArray.Length; l++)
                    {
                        if (dtArray[l].Rows.Count == 0)
                            Console.WriteLine(l);
                        else
                            Console.WriteLine("no vacia: " + l);
                    }
                }
                catch (Exception ex)
                {

                }*/
                return dtDimeTable = CreaTablaDime(CodiPers, CorrInst, VersInst, CodiInfo, dtArray, vDime, dtDescConc, vPrefDime, CodiDime, CodiMone);
                //Log.putLog(System.DateTime.Now.ToString() + " DbaxEmpresaPeriodaController 3");
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);

            }
            return dtDimeTable;
        }
        public DataTable GenerarDimensionesCuadros(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string CodiDime, string TipoTaxo, string CodiMone, string OrdeMemb)
        {
            DataTable dtEjes, dtDimeMemb, dtDescConc, dtDimeTable = null;
            string vPrefDime;
            string[, ,] vDime;
            int vTotalCol = 1;
            int vCol;
            int vCantRepe = 0;
            int cont = 0;
            int ContRepe = 0;
            dtDimeMemb = null;
            DataTable[] dtArray;
            // CodiDime = "cl-cs:" + CodiDime;
            try
            {
                vPrefDime = CodiDime.Substring(0, CodiDime.IndexOf(":"));
                CodiDime = CodiDime.Substring(CodiDime.IndexOf(":") + 1);
                dtEjes = GetEjesDimension(CodiInfo, vPrefDime, CodiDime);
                dtDescConc = GetDescConcDime(CodiInfo, CodiDime, TipoTaxo);
                dtDescConc.Rows.RemoveAt(0);
                for (int i = 0; i < dtEjes.Rows.Count; i++)
                {
                    if (i == 0)
                        vTotalCol = vTotalCol * GetMiembDimensionCuadros(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString(), OrdeMemb).Rows.Count;
                }
                vDime = new string[dtEjes.Rows.Count, vTotalCol + 1, 3];

                for (int i = 0; i < dtEjes.Rows.Count; i++)
                {
                    vCol = 1;
                    ContRepe = 0;
                    //vCantRepe guarda la cantidad de vueltas que debo dar para poder armar completamente el encabezado
                    vCantRepe = GetNumeRepe(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString(), dtEjes, i + 1);
                    if (i == 0)
                    {
                        dtDimeMemb = GetMiembDimensionCuadros(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString(), OrdeMemb);
                    }
                    else
                    {
                        dtDimeMemb = GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString());
                    }
                    vDime[i, 0, 0] = dtEjes.Rows[i]["pref_axis"].ToString() + ":" + dtEjes.Rows[i]["codi_axis"].ToString();
                    for (int a = 0; a < dtDimeMemb.Rows.Count; a++)
                    {
                        for (int b = 1; b < vCantRepe + 1; b++)
                        {
                            if (a == 1 && b == 1)
                            {
                                Console.WriteLine(i + " " + ContRepe + " " + b);
                            }
                            vDime[i, ContRepe + b, 0] = dtDimeMemb.Rows[a]["codi_memb"].ToString();
                            vDime[i, ContRepe + b, 1] = dtDimeMemb.Rows[a]["tipo_memb"].ToString();
                            vDime[i, ContRepe + b, 2] = dtDimeMemb.Rows[a]["desc_memb"].ToString();

                        }
                        ContRepe = ContRepe + vCantRepe;
                    }
                    if (i == 0)
                    {
                        cont = vCantRepe + 1;//Celda de donde comenzará a copiar
                    }
                    else
                    {
                        cont = (vCantRepe * GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString()).Rows.Count + 1); //Celda de donde comenzará a copiar
                    }
                    while (cont <= vTotalCol)
                    {
                        vDime[i, cont, 0] = vDime[i, vCol, 0];
                        vDime[i, cont, 1] = vDime[i, vCol, 1];
                        vDime[i, cont, 2] = vDime[i, vCol, 2];
                        cont++;
                        vCol++;
                    }
                }

                //string vFecha1 = _goDbaxMantCntx.getFechasCntx(CorrInst, "inicioano", "anoactual");
                //string vFecha2 = _goDbaxMantCntx.getFechasCntx(CorrInst, "ultimodiatrimestreactual", "anoactual");
                //string vFecha3 = _goDbaxMantCntx.getFechasCntx(CorrInst, "finano", "anoanterior");

                string vFecha1 = cntx.getFechasCntx(CorrInst, "inicioano", "anoactual").Tables[0].Rows[0][0].ToString();
                string vFecha2 = cntx.getFechasCntx(CorrInst, "ultimodiatrimestreactual", "anoactual").Tables[0].Rows[0][0].ToString();
                string vFecha3 = cntx.getFechasCntx(CorrInst, "finano", "anoanterior").Tables[0].Rows[0][0].ToString();

                dtArray = GetContxColum(CodiPers, CorrInst, VersInst, vDime, dtEjes.Rows.Count, vFecha1, vFecha2,vFecha3);
                return dtDimeTable = CreaTablaDime(CodiPers, CorrInst, VersInst, CodiInfo, dtArray, vDime, dtDescConc, vPrefDime, CodiDime, CodiMone);
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);
            }

            return dtDimeTable;
        }
        public DataTable GenerarDimensionesCuadros2018(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string CodiDime, string TipoTaxo, string CodiMone, string OrdeMemb)
        {
            DataTable dtEjes, dtDimeMemb, dtDescConc, dtDimeTable = null;
            string vPrefDime;
            string[, ,] vDime;
            int vTotalCol = 1;
            int vCol;
            int vCantRepe = 0;
            int cont = 0;
            int ContRepe = 0;
            dtDimeMemb = null;
            DataTable[] dtArray;
            // CodiDime = "cl-cs:" + CodiDime;
            try
            {
                vPrefDime = CodiDime.Substring(0, CodiDime.IndexOf(":"));
                CodiDime = CodiDime.Substring(CodiDime.IndexOf(":") + 1);
                dtEjes = GetEjesDimension(CodiInfo, vPrefDime, CodiDime);
                dtDescConc = GetDescConcDime(CodiInfo, CodiDime, TipoTaxo);
                dtDescConc.Rows.RemoveAt(0);
                for (int i = 0; i < dtEjes.Rows.Count; i++)
                {
                    if (i == 0)
                        vTotalCol = vTotalCol * GetMiembDimensionCuadros(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString(), OrdeMemb).Rows.Count;
                }
                vDime = new string[dtEjes.Rows.Count, vTotalCol + 1, 3];

                for (int i = 0; i < dtEjes.Rows.Count; i++)
                {
                    vCol = 1;
                    ContRepe = 0;
                    //vCantRepe guarda la cantidad de vueltas que debo dar para poder armar completamente el encabezado
                    vCantRepe = GetNumeRepe(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString(), dtEjes, i + 1);
                    //if (i == 0)
                    //{
                        dtDimeMemb = GetMiembDimensionCuadros(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString(), OrdeMemb);
                    //}
                    //else
                    //{
                    //    dtDimeMemb = GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString());
                    //}
                    vDime[i, 0, 0] = dtEjes.Rows[i]["pref_axis"].ToString() + ":" + dtEjes.Rows[i]["codi_axis"].ToString();
                    for (int a = 0; a < dtDimeMemb.Rows.Count; a++)
                    {
                        for (int b = 1; b < vCantRepe + 1; b++)
                        {
                            if (a == 1 && b == 1)
                            {
                                Console.WriteLine(i + " " + ContRepe + " " + b);
                            }
                            vDime[i, ContRepe + b, 0] = dtDimeMemb.Rows[a]["codi_memb"].ToString();
                            vDime[i, ContRepe + b, 1] = dtDimeMemb.Rows[a]["tipo_memb"].ToString();
                            vDime[i, ContRepe + b, 2] = dtDimeMemb.Rows[a]["desc_memb"].ToString();

                        }
                        ContRepe = ContRepe + vCantRepe;
                    }
                    if (i == 0)
                    {
                        cont = vCantRepe + 1;//Celda de donde comenzará a copiar
                    }
                    else
                    {
                        cont = (vCantRepe * GetMiembDimension(CodiPers, CorrInst, VersInst, CodiInfo, dtEjes.Rows[i]["pref_axis"].ToString(), dtEjes.Rows[i]["codi_axis"].ToString()).Rows.Count + 1); //Celda de donde comenzará a copiar
                    }
                    //while (cont <= vTotalCol)
                    //{
                    //    vDime[i, cont, 0] = vDime[i, vCol, 0];
                    //    vDime[i, cont, 1] = vDime[i, vCol, 1];
                    //    vDime[i, cont, 2] = vDime[i, vCol, 2];
                    //    cont++;
                    //    vCol++;
                    //}
                }

                //string vFecha1 = _goDbaxMantCntx.getFechasCntx(CorrInst, "inicioano", "anoactual");
                //string vFecha2 = _goDbaxMantCntx.getFechasCntx(CorrInst, "ultimodiatrimestreactual", "anoactual");
                //string vFecha3 = _goDbaxMantCntx.getFechasCntx(CorrInst, "finano", "anoanterior");

                string vFecha1 = cntx.getFechasCntx(CorrInst, "inicioano", "anoactual").Tables[0].Rows[0][0].ToString();
                string vFecha2 = cntx.getFechasCntx(CorrInst, "ultimodiatrimestreactual", "anoactual").Tables[0].Rows[0][0].ToString();
                string vFecha3 = cntx.getFechasCntx(CorrInst, "finano", "anoanterior").Tables[0].Rows[0][0].ToString();

                dtArray = GetContxColum(CodiPers, CorrInst, VersInst, vDime, dtEjes.Rows.Count, vFecha1, vFecha2, vFecha3);
                return dtDimeTable = CreaTablaDime(CodiPers, CorrInst, VersInst, CodiInfo, dtArray, vDime, dtDescConc, vPrefDime, CodiDime, CodiMone);
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);
            }

            return dtDimeTable;
        }
    }
    
}
