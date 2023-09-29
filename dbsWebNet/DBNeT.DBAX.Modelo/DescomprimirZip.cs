using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Compression;
using System.Security.Permissions;
using ICSharpCode.SharpZipLib.Zip;


namespace DBNeT.DBAX.Modelo
{
    public static class DescomprimirZip
    {
        /// <summary>
        /// Metodo que crea las carpetas si es que no se encuentran creadas
        /// </summary>
        /// <param name="tsRuta">Ruta de la carpeta de PDF</param>
        /// <param name="tsRutaTemporal">Ruta de la carpeta Temporal</param>
        /// <returns>Estado de la creación de las carpetas</returns>
        public static string CrearCarpetas(string tsRuta,string  tsRutaTemporal)
        {
            try
            {
                if (!System.IO.Directory.Exists(tsRuta))
                { System.IO.Directory.CreateDirectory(tsRuta); }
                if (!System.IO.Directory.Exists(tsRutaTemporal))
                { System.IO.Directory.CreateDirectory(tsRutaTemporal); }

            }
            catch (Exception ex)
            { return ex.Message; }

            FileIOPermission fileIO = new FileIOPermission(PermissionState.None);
            fileIO.AddPathList(FileIOPermissionAccess.AllAccess, tsRuta);
            fileIO.AllLocalFiles = FileIOPermissionAccess.AllAccess;

            FileIOPermission fileIO2 = new FileIOPermission(PermissionState.None);
            fileIO2.AddPathList(FileIOPermissionAccess.AllAccess, tsRutaTemporal);
            fileIO2.AllLocalFiles = FileIOPermissionAccess.AllAccess;

            try
            {
                fileIO.Demand();
                return "";
            }
            catch (System.Security.SecurityException sq)
            { return sq.Message; }
        }

        /// <summary>
        /// Metodo para Crear los Archivos que son de tipo Base 64, ocula Libreria Ionic
        /// </summary>
        /// <param name="tsRuta">Ruta mas Nombre de Archivo</param>
        /// <param name="tsArchivoB64">Archivo de Base 64</param>
        /// <returns>Mensaje de error</returns>
        public static string CrearAchivo(string tsRuta, string tsArchivoB64)
        {
            try
            {
                using (System.IO.FileStream fs = File.Create(tsRuta))
                {
                    byte[] lbArchivo = Convert.FromBase64String(tsArchivoB64);
                    foreach (byte item in lbArchivo)
                    {
                        fs.WriteByte(item);
                    }
                    fs.Flush();
                    fs.Close();
                }
                return "";
            }
            catch(Exception ex)
            { 
                return "No se pudo crear el archivo: " + ex.Message; 
            }
        }

        /// <summary>
        /// Metodo que Descomprime el pdf
        /// </summary>
        /// <param name="tsRuta">Ruta donde quedará el pdf</param>
        /// <param name="tsNombreArchivo">Nombre del archivo .pdf.zip</param>
        /// <param name="tsRutaTemporal">Carpeta donde esta el pdf comprimido</param>
        /// <returns>Mensaje de error</returns>
        public static string Descromprimir2(string tsRutaPdf, string tsNombreArchivo, string tsRutaTemporal)
        {
            try
            {
                if(!System.IO.Directory.Exists(tsRutaPdf))
                {System.IO.Directory.CreateDirectory(tsRutaPdf);}
                
                if(!System.IO.Directory.Exists(tsRutaTemporal))
                {System.IO.Directory.CreateDirectory(tsRutaTemporal);}

                string vNombArchivo = tsNombreArchivo;
                if (vNombArchivo.Contains(".pdf.zip"))
                    vNombArchivo = vNombArchivo.Replace(".pdf.zip", ".pdf");

                using (FileStream ficheroSalida = File.Create(tsRutaPdf + "\\" + vNombArchivo))
                //using (FileStream ficheroSalida = File.Create(tsRutaPdf + "\\966123101_201303_I.xbrl"))
                {
                    using (FileStream ficheroEntrada = File.OpenRead(tsRutaTemporal + "\\" + tsNombreArchivo))
                    {
                        using (System.IO.Compression.GZipStream zip = new System.IO.Compression.GZipStream(ficheroEntrada, System.IO.Compression.CompressionMode.Decompress))
                        {
                            zip.CopyTo(ficheroSalida);
                        }
                    }
                    ficheroSalida.Flush();
                    ficheroSalida.Close();
                }
                System.IO.File.Delete(tsRutaTemporal + "\\" + tsNombreArchivo);
                return "";
              
            }
            catch(Exception ex)
            { 
                return "No se pudo descomprimir pdf"; 
            }
        }

        /// <summary>
        /// Método que descomprime archivos
        /// </summary>
        /// <param name="tsRutaZip">Ruta y nombre de archivo</param>
        /// <param name="tsNombreArchivo">Nombre final del archivo</param>
        /// <param name="tsRutaZip">Ruta donde se descomprime</param>
        /// <returns>Estado de la descompresión</returns>
        public static string Descromprimir3(string tsRutaZip, string tsNombreArchivo, string tsRutaTemporal)
        {
            try
            {
                if (!System.IO.Directory.Exists(tsRutaZip))
                { System.IO.Directory.CreateDirectory(tsRutaZip); }

                if (!System.IO.Directory.Exists(tsRutaTemporal))
                { System.IO.Directory.CreateDirectory(tsRutaTemporal); }

                FastZip fzip = new FastZip();
                fzip.ExtractZip(tsRutaTemporal + "\\" + tsNombreArchivo, tsRutaZip,"");
                return "";

            }
            catch
            { return "No se pudo descomprimir "; }
        }
      
        public static string EliminarPdf(string tsRutaArchivo)
        {
            try
            {
                System.IO.File.Delete(tsRutaArchivo);
                return "";
            }
            catch (FileNotFoundException)
            { return "Archivo no encontrado"; }
            catch (Exception ex)
            { return ex.Message; }
        }
        public static void DirectoryCopy(string sourceDirName, string destDirName, bool copySubDirs)
        {
            DirectoryInfo dir = new DirectoryInfo(sourceDirName);
            DirectoryInfo[] dirs = dir.GetDirectories();

            if (!dir.Exists)
            {
                throw new DirectoryNotFoundException(
                    "Source directory does not exist or could not be found: "
                    + sourceDirName);
            }

            if (!Directory.Exists(destDirName))
            {
                Directory.CreateDirectory(destDirName);
            }

            FileInfo[] files = dir.GetFiles();
            foreach (FileInfo file in files)
            {
                string temppath = Path.Combine(destDirName, file.Name);
                file.CopyTo(temppath, false);
            }

            if (copySubDirs)
            {
                foreach (DirectoryInfo subdir in dirs)
                {
                    string temppath = Path.Combine(destDirName, subdir.Name);
                    DirectoryCopy(subdir.FullName, temppath, copySubDirs);
                }
            }
        }
    }
}