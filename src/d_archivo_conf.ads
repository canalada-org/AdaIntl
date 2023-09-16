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
