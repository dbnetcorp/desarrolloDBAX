using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.DBAX.Modelo;

namespace DBNeT.DBAX.Controlador
{
    public class DescomprimirZipController
    {
        public DescomprimirZipController()
        {}

        /// <summary>
        /// Metodo para Crear los Archivos que son de tipo Base 64, ocula Libreria Ionic
        /// </summary>
        /// <param name="tsRuta">Ruta mas Nombre de Archivo</param>
        /// <param name="tsArchivoB64">Archivo de Base 64</param>
        /// <returns>Mensaje de error</returns>
        public static string CrearArchivo(string tsRuta, string tsArchivoB64)
        {
            return DescomprimirZip.CrearAchivo(tsRuta, tsArchivoB64);
        }

        /// <summary>
        /// Metodo que crea las carpetas si es que no se encuentran creadas
        /// </summary>
        /// <param name="tsRuta">Ruta de la carpeta de PDF</param>
        /// <param name="tsRutaTemporal">Ruta de la carpeta Temporal</param>
        /// <returns>Estado de la creación de las carpetas</returns>
        public static string CrearCarpeta(string tsRutaPdf, string tsRutaTemp)
        {
            return DescomprimirZip.CrearCarpetas(tsRutaPdf, tsRutaTemp);
        }

        /// <summary>
        /// Método que Descomprime el pdf
        /// </summary>
        /// <param name="tsRuta">Ruta donde quedará el pdf</param>
        /// <param name="tsNombreArchivo">Nombre del archivo .pdf.zip</param>
        /// <param name="tsRutaTemporal">Carpeta donde esta el pdf comprimido</param>
        /// <returns>Mensaje de error</returns>
        public static string Descromprimir2(string tsRuta, string tsNombreArchivo, string tsRutaTemporal)
        {
            return DescomprimirZip.Descromprimir2(tsRuta, tsNombreArchivo, tsRutaTemporal);
        }
        /// <summary>
        /// Método que descomprime archivos
        /// </summary>
        /// <param name="tsRutaZip">Ruta y nombre de archivo zip</param>
        /// <param name="tsNombreArchivo">Nombre final del archivo</param>
        /// <param name="tsRutaTemporal">Ruta donde se descomprime</param>
        /// <returns>Estado de la descompresión</returns>
        public static string Descromprimir3(string tsRutaZip, string tsNombreArchivo, string tsRutaTemporal)
        {
            return DescomprimirZip.Descromprimir3(tsRutaZip, tsNombreArchivo, tsRutaTemporal);
        }
      

        /// <summary>
        /// Metodo que elimina PDF
        /// </summary>
        /// <param name="tsRutaArchivo">Ruta y nombre de archivo</param>
        /// <returns>Estado de la eliminación</returns>
        public static string EliminaPdf(string tsRutaArchivo)
        {
            return DescomprimirZip.EliminarPdf(tsRutaArchivo);
        }
        public static void DirectoryCopy(string sourceDirName, string destDirName, bool copySubDirs)
        {
            DescomprimirZip.DirectoryCopy(sourceDirName, destDirName, copySubDirs);
        }
    }
}