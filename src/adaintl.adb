with D_Frases_Io,D_Hash, D_Arbol_Frases,Ada.Strings.Unbounded,D_Arbol_Dominios, D_Archivo_Conf;
use D_Frases_Io,D_Hash, D_Arbol_Frases,Ada.Strings.Unbounded,D_Arbol_Dominios, D_Archivo_Conf;

with Ada.Text_Io;
use Ada.Text_Io;
package body Adaintl is

   ---------------------
   -- Inner variables --
   ---------------------
   Constant_Default_Domain : constant String           := "Language";  
   Var_Default_Domain      :          Unbounded_String := To_Unbounded_String (Constant_Default_Domain);  
   Var_Language            :          Language_Type    := Nul;  
   Var_Debug_Level         :          Debug_Level_Type := No_Debug;  
   Domain_Tree             :          Ad_Arbol;  
   Primera_Ejecucion       :          Boolean          := True;  

   No_Execution : exception; -- If AdaIntl mode is set to "Deactivated", nothing is executed                                                                     

   ----------------
   -- Initialize --
   ----------------
   function Initialize (
         Language                : Language_Type;                  
         Default_Domain          : String           := "Language"; 
         Debug_Mode              : Debug_Level_Type := No_Debug;   
         Directory               : String           := "";         
         Load_Configuration_File : String           := ""          ) 
     return Internationalization_Type is 
      Dominio_Temp : T_Dominio;  
   begin

      -- Comprobamos errores y demás
      -- * AdaIntl no está desactivado
      -- * El lenguaje elegido no es Nul

      if Debug_Mode=Deactivated then
         raise No_Execution;
      elsif Language=Nul then
         -- Lenguaje nul
         if  Debug_Mode=No_Debug then
            raise No_Execution;
         else
            Put_Line("Error: Lenguaje no valido (nul).");
            if  Debug_Mode=Only_Errors_Stop or  Debug_Mode=Total_Stop then
               raise Language_Not_Valid;
            else -- No stop
               raise No_Execution;
            end if;
         end if;
      end if;



      -- Información de Debug
      if Debug_Mode=Total_No_Stop or Debug_Mode=Total_Stop then
         Put_Line("Iniciando AdaIntl");
         Put_Line("Modo de debug: " & Debug_Level_Type'Image(Debug_Mode));
         Put_Line("Idioma: " & Language_Type'Image(Language));
         Put_Line("Dominio por defecto: " & Default_Domain);
         Put_Line("---------------------------------------------");
      end if;

      -- Inicializamos
      Var_Default_Domain:=To_Unbounded_String(Default_Domain);
      Var_Language:=Language;
      Var_Debug_Level:=Debug_Mode;

      -- Cargamos idioma de archivo si procede
      if Load_Configuration_File/="" then
         declare
            Datos_Configuracion : T_Datos_Configuracion := (D_Idiomas.Nul, To_Unbounded_String (""));  
         begin
            if not Existe_Fichero_Configuración(Load_Configuration_File, T_Debug_Level(Debug_Mode)) then
               -- Guardamos
               Datos_Configuracion.Idioma:=T_Language(Language);
               Datos_Configuracion.Nombre_Idioma:=To_Unbounded_String(Language_Name(Language));
               Escribir_Configuración (
                  Load_Configuration_File,
                  Datos_Configuracion,
                  T_Debug_Level(Debug_Mode) );
            else
               begin
                  -- Cargamos
                  Cargar_Configuración (
                     Load_Configuration_File,
                     Datos_Configuracion,
                     T_Debug_Level(Debug_Mode) );
                  Var_Language:=Language_Type(Datos_Configuracion.Idioma);
               exception
                  when Fichero_Configuracion_Incorrecto=>
                     if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=Total_Stop then
                        raise Conf_File_Not_Correct;
                     end if;
               end;
            end if;
         end;
      end if;

      -- Cargamos directorio y demás
      Usar_Directorio(Directory,T_Debug_Level(Var_Debug_Level));
      if Primera_Ejecucion then
         -- Inicializamos el arbol de dominios
         D_Arbol_Dominios.Inicializar (Domain_Tree);
         Primera_Ejecucion:=False;
      end if;

      Dominio_Temp:=Nuevo_Dominio(Default_Domain,T_Language(Language));

      if Debug_Mode=Total_No_Stop or Debug_Mode=Total_Stop then
         Put_Line("Cargando frases de dominio '" & Default_Domain & "' en " & Language_Type'Image(Language));

      end if;
      -- Cargamos las frases y las insertamos en el arbol de dominios
      Cargar_Frases(D_Arbol_Dominios.Arbol_Frases(Dominio_Temp).all,Default_Domain,T_Language(Language),T_Debug_Level(Debug_Mode));
      Insertar(Dominio_Temp,Domain_Tree);

      return True;
   exception
      when No_Execution=>
         return False;
   end Initialize;


   --------------------
   -- Set_Debug_Mode --
   --------------------

   procedure Set_Debug_Mode (
         Debug_Mode : Debug_Level_Type ) is 
   begin

      if Debug_Mode=Total_No_Stop or Debug_Mode=Total_Stop then
         Put_Line("Modo de debug: " & Debug_Level_Type'Image(Debug_Mode));
      end if;
      Var_Debug_Level:=Debug_Mode;


   end Set_Debug_Mode;


   ------------------------
   -- Set_Default_Domain --
   ------------------------

   procedure Set_Default_Domain (
         Domain : String ) is 
      Dominio_Temp           : T_Dominio;  
      Pos_Arbol_Dominio_Temp : Ad_Ptr;  



      -- Se encarga de cargar todas las frases en el arbol de frases del dominio "dominio_temp" e insertar
      -- este dominio en el arbol de dominios
      procedure Cargar_Frases_En_Arbol is 
      begin
         Cargar_Frases(D_Arbol_Dominios.Arbol_Frases(Dominio_Temp).all,Domain,T_Language(Var_Language),T_Debug_Level(Var_Debug_Level));
         Insertar(Dominio_Temp,Domain_Tree);
      exception
         when Fichero_Incorrecto=>
            -- El fichero es incorrecto!
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=Total_Stop then
               raise File_Not_Correct;
            end if;
      end Cargar_Frases_En_Arbol;

   begin
      if Var_Debug_Level=Deactivated then
         raise No_Execution;
      end if;

      -- Comprobamos si ya esta cargado el arbol de dominios
      Dominio_Temp:=Nuevo_Dominio(Domain,T_Language(Var_Language));
      begin
         Pos_Arbol_Dominio_Temp:=Buscar(Domain,Domain_Tree);
      exception
         -- Si no está cargado...
         when Dominio_No_Existente =>
            -- Cargamos las frases y las insertamos en el arbol de dominios
            Cargar_Frases_En_Arbol;
      end;

      Var_Default_Domain:=To_Unbounded_String(Domain);

   exception
      when No_Execution=>
         null;

   end Set_Default_Domain;


   ------------------
   -- Set_Language --
   ------------------

   procedure Set_Language (
         Language : Language_Type ) is 
   begin
      if Var_Debug_Level=Deactivated then
         -- AdaIntl desactivado
         raise No_Execution;

      elsif Language=Nul then
         -- Lenguaje nul
         if Var_Debug_Level=No_Debug then
            raise No_Execution;
         else
            Put_Line("Error: Lenguaje no valido (nul).");
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=Total_Stop then
               raise Language_Not_Valid;
            else -- No stop
               raise No_Execution;
            end if;
         end if;
      end if;

      Var_Language:=Language;
   exception
      when No_Execution=>
         null;
   end Set_Language;




   ---------
   -- "-" --
   ---------

   function "-" (
         Right : String ) 
     return String is 
   begin
      return "-"(To_String(Var_Default_Domain),Right);
   end "-";


   ---------
   -- "-" --
   ---------

   function "-" (
         Domain : String; 
         Phrase : String  ) 
     return String is 
      F_Temp : T_Frase;  
      H      : T_Hash        := Hash (Phrase);  
      A      : Puntero_Arbol;  
      D      : T_Dominio;  


      -- Añade la frase al archivo correspondiente y al arbol de frases
      -- Se ejecuta solo cuando no se encuentra el hash de la frase en el arbol
      procedure Escribir_Frase_Y_Añadir_Al_Arbol is 
         Insertar_En_Arbol : Boolean := True;  
      begin
         if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
            Put_Line("Frase no encontrada en fichero de traduccion.");
         end if;
         begin
            Escribir_Frase(Phrase,H, Domain, T_Language(Var_Language),T_Debug_Level(Var_Debug_Level));
         exception
            -- El fichero no es correcto o no se puede crear 
            when Fichero_Incorrecto=>
               Insertar_En_Arbol:=False;
               if Var_Debug_Level=Total_Stop or Var_Debug_Level=Only_Errors_Stop then
                  raise File_Not_Correct;
               end if;
         end;
         -- Si falla la escritura en fichero, no escribimos en el arbol
         if Insertar_En_Arbol then
            Insertar(Nueva_Frase(Phrase),A.All);
         end if;
      end Escribir_Frase_Y_Añadir_Al_Arbol;



      -- Devuelve cierto si se pueden cargar las frases correctamente
      -- Devuelve falso si el fichero de traducción es incorrecto (no existe, tiene fallos, etc)
      function Cargar_Frases_En_Arbol return Boolean is 
      begin
         Cargar_Frases(D_Arbol_Dominios.Arbol_Frases(D).all,Domain,T_Language(Var_Language),T_Debug_Level(Var_Debug_Level));
         Insertar(D,Domain_Tree);
         return True;
      exception
         when Fichero_Incorrecto=>
            -- El fichero es incorrecto!
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=Total_Stop then
               raise File_Not_Correct;
            else
               return False;
            end if;

      end Cargar_Frases_En_Arbol;



   begin

      -- Comprobamos errores y demás
      -- * AdaIntl no está desactivado
      -- * Se ha inicializado AdaIntl
      -- * El lenguaje elegido no es Nul

      if Var_Debug_Level=Deactivated then
         -- Adaintl desactivado
         raise No_Execution;


      elsif Primera_Ejecucion then
         -- No se ha inicializado adaintl
         if Var_Debug_Level=No_Debug then
            raise No_Execution;
         else
            Put_Line("Error: No se ha inicializado AdaIntl.");
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=Total_Stop then
               raise Not_Initialized;
            else -- No stop
               raise No_Execution;
            end if;
         end if;



      elsif Var_Language=Nul then
         -- Lenguaje nul
         if Var_Debug_Level=No_Debug then
            raise No_Execution;
         else
            Put_Line("Error: Lenguaje no valido (nul).");
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=Total_Stop then
               raise Language_Not_Valid;
            else -- No stop
               raise No_Execution;
            end if;
         end if;
      end if;


      ---------------
      -- Ejecución --
      ---------------

      -- Comprobamos que el dominio está cargado
      if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
         Put_Line("Comprobando que este cargado el dominio '" & Domain & "'");
      end if;


      begin
         D:=D_Arbol_Dominios.Recuperar (D_Arbol_Dominios.Buscar (Domain, Domain_Tree));
      exception
         -- Si no está cargado...
         when Dominio_No_Existente =>
            D:=Nuevo_Dominio(Domain,T_Language(Var_Language));
            -- Cargamos las frases y las insertamos en el arbol de dominios
            if not Cargar_Frases_En_Arbol then
               return Phrase;
            end if;
      end;

      -- Comprobamos que el dominio cargado sea correcto y el idioma coincida
      if Idioma(D)/=T_Language(Var_Language) then
         if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
            Put_Line("Encontrado en memoria dominio '" & Domain & "' en " & T_Language'Image(Idioma(D)));
         end if;
         -- Si no coincide debemos quitar de memoria el dominio y cargar el correcto
         Borrar(D,Domain_Tree);
         D:=Nuevo_Dominio(Domain,T_Language(Var_Language));
         -- Cargamos las frases y las insertamos en el arbol de dominios
         begin
            Cargar_Frases(
               D_Arbol_Dominios.Arbol_Frases(D).all,
               Domain,
               T_Language(Var_Language),
               T_Debug_Level(Var_Debug_Level)
               );
            Insertar(D,Domain_Tree);
         exception
            when Fichero_Incorrecto=>
               -- El fichero es incorrecto!
               if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=Total_Stop then
                  raise File_Not_Correct;
               else
                  return Phrase;
               end if;
         end;
      end if;

      -- Buscamos el arbol de frases del dominio por defecto
      A:=D_Arbol_Dominios.Arbol_Frases (D);

      -- Buscamos el hash (si existe) y recuperamos la frase
      F_Temp:=D_Arbol_Frases.Recuperar(
         D_Arbol_Frases.Buscar(
            H
            ,
            A.All
            )
         );
      if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
         Put_Line("Frase en fichero de traduccion.");
      end if;

      return Frase(F_Temp);
   exception
      -- Si el hash no existe, escribimos en fichero y añadimos al arbol de frases del dominio
      when Hash_No_Existente =>
         Escribir_Frase_Y_Añadir_Al_Arbol;
         return Phrase;

      when No_Execution=>
         return Phrase;
   end "-";


   --------------------
   ---- Cleaning  -----
   --------------------

   -- You should execute "Clean" before exiting your program.
   -- This will clean strings from memory.
   -- After cleaning, you have to exit the program or initialize again AdaIntl
   procedure Clean_Adaintl is 
   begin
      if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
         Put_Line("Borrando datos y vaciando arbol de dominios");
      end if;
      Var_Default_Domain:=To_Unbounded_String(Constant_Default_Domain);
      Var_Language:=Nul;
      Primera_Ejecucion:=True;
      Var_Debug_Level:=No_Debug;
      Finalizar(Domain_Tree);

   end Clean_Adaintl;




   ------------------------------
   ---- Available languages -----
   ------------------------------

   -- Get_Available_Languages returns an array with all the languages supported by AdaIntl
   -- that says if you can use them with the default domain.
   function Get_Available_Languages return Availabe_Languages_Array is 
      Languages_Available : Availabe_Languages_Array;  
   begin
      -- Recorremos todos los idiomas y vemos si existe un dominio para ellos. 
      -- Nuestro lenguage "comodín" (Nul) siempre devolverá false.
      for I in Language_Type'range loop
         if I=Nul then
            Languages_Available(I):=False;
         else
            Languages_Available(I):=Existe_Fichero(To_String(Var_Default_Domain), T_Language(I), No_Debug);
         end if;
      end loop;
      return Languages_Available;
   end Get_Available_Languages;


end Adaintl;

