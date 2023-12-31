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


with D_Frases_Io,D_Hash, D_Arbol_Frases,Ada.Strings.Unbounded,
   D_Arbol_Dominios, D_Archivo_Conf, adaintl_version;
use D_Frases_Io,D_Hash, D_Arbol_Frases,Ada.Strings.Unbounded,
   D_Arbol_Dominios, D_Archivo_Conf, adaintl_version;

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


   -------------------------
   -- Initialize_Adaintl  --
   -------------------------
   procedure Initialize_Adaintl (
         Language                : Language_Type;                  
         Default_Domain          : String           := "Language"; 
         Debug_Mode              : Debug_Level_Type := No_Debug;   
         Directory               : String           := "";         
         Load_Configuration_File : String           := ""          ) is 
      I_Temp : Internationalization_Type;  
   begin
      I_Temp:=Initialize_Adaintl (Language, Default_Domain,Debug_Mode,
         Directory, Load_Configuration_File);
   end Initialize_Adaintl ;


   function Initialize_Adaintl (
         Language                : Language_Type;                  
         Default_Domain          : String           := "Language"; 
         Debug_Mode              : Debug_Level_Type := No_Debug;   
         Directory               : String           := "";         
         Load_Configuration_File : String           := ""          ) 
     return Internationalization_Type is 
      Dominio_Temp : T_Dominio;  
   begin

      -- Comprobamos errores y dem�s
      -- * AdaIntl no est� desactivado
      -- * El lenguaje elegido no es Nul

      if Debug_Mode=Deactivated then
         raise No_Execution;
      elsif Language=Nul then
         -- Lenguaje nul
         if  Debug_Mode=No_Debug then
            raise No_Execution;
         else
            Put_Line("Error: Language not valid (nul).");
            if  Debug_Mode=Only_Errors_Stop or  Debug_Mode=Total_Stop then
               raise Language_Not_Valid;
            else -- No stop
               raise No_Execution;
            end if;
         end if;
      end if;



      -- Informaci�n de Debug
      if Debug_Mode=Total_No_Stop or Debug_Mode=Total_Stop then
         Put_Line("Initializing " & Name_Of_Adaintl);
         Put_Line("Debug mode: " & Debug_Level_Type'Image(Debug_Mode));
         Put_Line("Language: " & Language_Type'Image(Language));
         Put_Line("Default Domain: " & Default_Domain);
         Put_Line("---------------------------------------------");
      end if;

      -- Inicializamos
      Var_Default_Domain:=To_Unbounded_String(Default_Domain);
      Var_Language:=Language;
      Var_Debug_Level:=Debug_Mode;

      -- Cargamos idioma de archivo si procede
      if Load_Configuration_File/="" then
         declare
            Datos_Configuracion : T_Datos_Configuracion := (D_Idiomas.Nul, null_unbounded_string);  
         begin
            if not Existe_Fichero_Configuraci�n(Load_Configuration_File,
                  T_Debug_Level(Debug_Mode)) then
               -- Guardamos
               Datos_Configuracion.Idioma:=T_Language(Language);
               Datos_Configuracion.Nombre_Idioma:=To_Unbounded_String(
                  Language_Name(Language));
               Escribir_Configuraci�n (
                  Load_Configuration_File,
                  Datos_Configuracion,
                  T_Debug_Level(Debug_Mode) );
            else
               begin
                  -- Cargamos
                  Cargar_Configuraci�n (
                     Load_Configuration_File,
                     Datos_Configuracion,
                     T_Debug_Level(Debug_Mode) );
                  Var_Language:=Language_Type(Datos_Configuracion.Idioma);
               exception
                  when Fichero_Configuracion_Incorrecto=>
                     if Var_Debug_Level=Only_Errors_Stop or
                           Var_Debug_Level=Total_Stop then
                        raise Conf_File_Not_Correct;
                     end if;
               end;
            end if;
         end;
      end if;

      -- Cargamos directorio y dem�s
      Usar_Directorio(Directory,T_Debug_Level(Var_Debug_Level));
      if Primera_Ejecucion then
         -- Inicializamos el arbol de dominios
         D_Arbol_Dominios.Inicializar (Domain_Tree);
         Primera_Ejecucion:=False;
      end if;


      -------

      Dominio_Temp:=Nuevo_Dominio(Default_Domain,T_Language(Language));

      if Debug_Mode=Total_No_Stop or Debug_Mode=Total_Stop then
         Put_Line("Loading strings from domain '" & Default_Domain &
            "' in " & Language_Type'Image(Language));

      end if;
      -- Cargamos las frases y las insertamos en el arbol de dominios
      Cargar_Frases(D_Arbol_Dominios.Arbol_Frases(Dominio_Temp).all,
         Default_Domain,T_Language(Language),T_Debug_Level(Debug_Mode));
      begin
         Insertar(Dominio_Temp,Domain_Tree);
      exception
         when Dominio_Existente=> Finalizar(Dominio_temp.Arbol_Frase.all);
      end;


      return True;
   exception
      when No_Execution=>
         return False;
   end Initialize_Adaintl ;


   ------------------------
   -- Get_Default_Domain --
   ------------------------

   function Get_Default_Domain return String is 
   begin
      return To_String(Var_Default_Domain);
   end Get_Default_Domain;


   --------------------
   -- Get_Debug_Mode --
   --------------------

   function Get_Debug_Mode return Debug_Level_Type is 
   begin
      return Var_Debug_Level;
   end Get_Debug_Mode;


   ------------------
   -- Get_Language --
   ------------------

   function Get_Language return Language_Type is 
   begin
      return Var_Language;
   end Get_Language;


   --------------------
   -- Set_Debug_Mode --
   --------------------

   procedure Set_Debug_Mode (
         Debug_Mode : Debug_Level_Type ) is 
   begin

      if Debug_Mode=Total_No_Stop or Debug_Mode=Total_Stop then
         Put_Line("Debug mode: " & Debug_Level_Type'Image(Debug_Mode));
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
         Cargar_Frases(D_Arbol_Dominios.Arbol_Frases(Dominio_Temp).all,
            Domain,T_Language(Var_Language),T_Debug_Level(Var_Debug_Level));
         Insertar(Dominio_Temp,Domain_Tree);
      exception
         when Fichero_Incorrecto=>
            -- El fichero es incorrecto!
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=
                  Total_Stop then
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
         -- Si no est� cargado...
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
            Put_Line("Error: Language not valid (nul).");
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=
                  Total_Stop then
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
         Left  : String; 
         Right : String  ) 
     return String is 
      F_Temp : T_Frase;  
      H      : T_Hash        := Hash (Right);  
      A      : Puntero_Arbol;  
      D      : T_Dominio;  


      -- A�ade la frase al archivo correspondiente y al arbol de frases
      -- Se ejecuta solo cuando no se encuentra el hash de la frase en el arbol
      procedure Escribir_Frase_Y_A�adir_Al_Arbol is 
         Insertar_En_Arbol : Boolean := True;  
      begin
         if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
            Put_Line("String not found on translation file.");
         end if;
         begin
            Escribir_Frase(Right,H, Left, T_Language(Var_Language),
               T_Debug_Level(Var_Debug_Level));
         exception
            -- El fichero no es correcto o no se puede crear 
            when Fichero_Incorrecto=>
               Insertar_En_Arbol:=False;
               if Var_Debug_Level=Total_Stop or Var_Debug_Level=
                     Only_Errors_Stop then
                  raise File_Not_Correct;
               end if;
         end;
         -- Si falla la escritura en fichero, no escribimos en el arbol
         if Insertar_En_Arbol then
            Insertar(Nueva_Frase(Right),A.All);
         end if;
      end Escribir_Frase_Y_A�adir_Al_Arbol;



      -- Devuelve cierto si se pueden cargar las frases correctamente
      -- Devuelve falso si el fichero de traducci�n es incorrecto (no existe, tiene fallos, etc)
      function Cargar_Frases_En_Arbol return Boolean is 
      begin
         Cargar_Frases(D_Arbol_Dominios.Arbol_Frases(D).all,Left,
            T_Language(Var_Language),T_Debug_Level(Var_Debug_Level));
         Insertar(D,Domain_Tree);
         return True;
      exception
         when Fichero_Incorrecto=>
            -- El fichero es incorrecto!
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=
                  Total_Stop then
               raise File_Not_Correct;
            else
               return False;
            end if;

      end Cargar_Frases_En_Arbol;



   begin

      -- Comprobamos errores y dem�s
      -- * AdaIntl no est� desactivado
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
            Put_Line("Error: AdaIntl is not initialized.");
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=
                  Total_Stop then
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
            Put_Line("Error: Language not valid (nul).");
            if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=
                  Total_Stop then
               raise Language_Not_Valid;
            else -- No stop
               raise No_Execution;
            end if;
         end if;
      end if;


      ---------------
      -- Ejecuci�n --
      ---------------

      -- Comprobamos que el dominio est� cargado
      if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
         Put_Line("Checking that domain '" & Left & "' is loaded.");
      end if;


      begin
         D:=D_Arbol_Dominios.Recuperar (D_Arbol_Dominios.Buscar (Left,
               Domain_Tree));
      exception
         -- Si no est� cargado...
         when Dominio_No_Existente =>
            D:=Nuevo_Dominio(Left,T_Language(Var_Language));
            -- Cargamos las frases y las insertamos en el arbol de dominios
            if not Cargar_Frases_En_Arbol then
               return Right;
            end if;
      end;

      -- Comprobamos que el dominio cargado sea correcto y el idioma coincida
      if Idioma(D)/=T_Language(Var_Language) then
         if Var_Debug_Level=Total_No_Stop or Var_Debug_Level=Total_Stop then
            Put_Line("Found loaded domain '" & Left & "' in " &
               T_Language'Image(Idioma(D)));
         end if;
         -- Si no coincide debemos quitar de memoria el dominio y cargar el correcto
         Borrar(D,Domain_Tree);
         D:=Nuevo_Dominio(Left,T_Language(Var_Language));
         -- Cargamos las frases y las insertamos en el arbol de dominios
         begin
            Cargar_Frases(
               D_Arbol_Dominios.Arbol_Frases(D).all,
               Left,
               T_Language(Var_Language),
               T_Debug_Level(Var_Debug_Level)
               );
            Insertar(D,Domain_Tree);
         exception
            when Fichero_Incorrecto=>
               -- El fichero es incorrecto!
               if Var_Debug_Level=Only_Errors_Stop or Var_Debug_Level=
                     Total_Stop then
                  raise File_Not_Correct;
               else
                  return Right;
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
         Put_Line("String on translation file.");
      end if;

      return Frase(F_Temp);
   exception
      -- Si el hash no existe, escribimos en fichero y a�adimos al arbol de frases del dominio
      when Hash_No_Existente =>
         Escribir_Frase_Y_A�adir_Al_Arbol;
         return Right;

      when No_Execution=>
         return Right;
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
         Put_Line("Deleting information and cleaning domain tree.");
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
      -- Nuestro lenguage "comod�n" (Nul) siempre devolver� false.
      for I in Language_Type'range loop
         if I=Nul then
            Languages_Available(I):=False;
         else
            Languages_Available(I):=Existe_Fichero(To_String(
                  Var_Default_Domain), T_Language(I), No_Debug);
         end if;
      end loop;
      return Languages_Available;
   end Get_Available_Languages;


end Adaintl;

