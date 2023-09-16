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


with D_Idiomas, D_Debug, Ada.Strings.Unbounded;
use D_Idiomas, D_Debug, Ada.Strings.Unbounded;

package D_Archivo_Conf is

   type T_Datos_Configuracion is tagged 
      record 
         Idioma        : T_Language;  
         Nombre_Idioma : Unbounded_String;  
      end record; 


   ------------------
   --- Escritura ----
   ------------------

   -- Crea un nuevo fichero de configuraci�n en la ruta especificada
   -- Si ya existe, lo sobreescribe
   procedure Escribir_Configuraci�n (
         Ruta   : String;                           
         Config : T_Datos_Configuracion;            
         Debug  : T_Debug_Level         := No_Debug ); 


   ------------------
   ---  Lectura  ----
   ------------------

   -- Carga del archivo de configuraci�n de la ruta especificada los datos de
   -- configuraci�n, guardandolos en Config.
   -- Si el fichero no existe, lanza la excepci�n "Fichero_Configuracion_Incorrecto"
   -- independientemente del nivel de debug
   procedure Cargar_Configuraci�n (
         Ruta   :        String;                           
         Config : in out T_Datos_Configuracion;            
         Debug  :        T_Debug_Level         := No_Debug ); 



   ------------------
   ----- Otros  -----
   ------------------


   -- Comprueba si existe el fichero de configuraci�n
   function Existe_Fichero_Configuraci�n (
         Ruta  : String;                   
         Debug : T_Debug_Level := No_Debug ) 
     return Boolean; 

   Fichero_Configuracion_Incorrecto : exception;  


private


end D_Archivo_Conf;
