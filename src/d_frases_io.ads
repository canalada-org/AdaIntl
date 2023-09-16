--------------------------------------------------------------------------------------
-- AdaIntl: Internationalization library for Ada95 made in Ada95
-- Copyright (C) 2006  Andres_age
--
-- AdaIntl is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or any later version.
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
-- or look here: http://www.gnu.org/licenses/lgpl.html
--
-- You can contact the author at this e-mail: andres.age*AT*gmail*DOT*com
--------------------------------------------------------------------------------------


with D_Idiomas, D_Hash, D_Arbol_Frases,D_Debug,Ada.Strings.Unbounded;
use D_Idiomas, D_Hash, D_Arbol_Frases,D_Debug,Ada.Strings.Unbounded;

package D_Frases_Io is

   ------------------
   --- Escritura ----
   ------------------

   -- Escribe una frase al final del archivo de localización
   -- Si no existe, crea el fichero
   procedure Escribir_Frase (
         Frase   : String;                   
         Hash    : T_Hash;                   
         Dominio : String;                   
         Idioma  : T_Language;               
         Debug   : T_Debug_Level := No_Debug ); 


   ------------------
   ---  Lectura  ----
   ------------------

   -- Carga todas las frases de un fichero de localización en el arbol A
   -- Este árbol debe de estar vacío y/o inicializado 
   -- (es decir la última operación aplicada a A debe haber sido 
   -- "Inicializar" o "Vaciar")
   procedure Cargar_Frases (
         Arbol   : in out Af_Arbol;                 
         Dominio :        String;                   
         Idioma  :        T_Language;               
         Debug   :        T_Debug_Level := No_Debug ); 



   ------------------
   ----- Otros  -----
   ------------------

   -- Especifica si ha de usarse una organización tipo directorio 
   -- ej: x/ES_ES/fichero
   -- donde x es el directorio elegido
   -- o el idioma se pone de extensión en la misma carpeta
   -- ej: fichero.Es_ES
   -- Si S es "" (cadena nula), se usa extensión.
   -- Si S es una cadena no nula, se usa el directorio S. 
   -- El último caracter de S debe ser '/' (Unix) o '\' (Windows)
   --
   -- Por ejemplo:
   ---- Usar_Directorio("locale/");
   ---- hará que los archivos de traducción se guarden en 
   --   ---- locale/ES_ES/fichero
   --
   ---- Usar_Directorio("");
   ---- hará que los archivos de traducción se guarden en
   ---- el mismo directorio con el idioma de extensión
   procedure Usar_Directorio (
         S : String;                   
         D : T_Debug_Level := No_Debug ); 



   -- Comprueba si existe el fichero en el idioma 
   -- según la organización de directorios:
   -- /Es_ES/fichero o bien fichero.Es_ES
   function Existe_Fichero (
         Dominio : String;                   
         Idioma  : T_Language;               
         Debug   : T_Debug_Level := No_Debug ) 
     return Boolean; 

   Fichero_Incorrecto : exception;  


private
   Var_Usar_Directorio : Unbounded_String := To_Unbounded_String ("");  

   -- Devuelve que ruta tiene el fichero de traducción
   function Ruta_Fichero (
         Dominio : String;    
         Idioma  : T_Language ) 
     return String; 

   -- Quita los espacios iniciales a la cadena S
   function Quitar_Espacios (
         S : String ) 
     return String; 


   -- Prepara la cadena S para ser escrita en el archivo de traducción
   -- quitando las comillas, etc.
   -- Por ejemplo, la frase 
   -- El dijo "Hola"
   -- quedaría así:
   -- El dijo \"Hola\"
   function Formatear_Texto_Para_Escribir (
         S : in     String ) 
     return String; 

end D_Frases_Io;
