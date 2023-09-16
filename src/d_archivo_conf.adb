with Ada.Text_Io, Ada.Characters.Handling;
use Ada.Text_Io, Ada.Characters.Handling;

with Adaintl_Version;
use Adaintl_Version;

package body D_Archivo_Conf is

   --------------------------
   -- Cargar_Configuración --
   --------------------------

   procedure Cargar_Configuración (
         Ruta   :        String;                           
         Config : in out T_Datos_Configuracion;            
         Debug  :        T_Debug_Level         := No_Debug ) is 


      C : Character := ' ';  
      F : File_Type;  

      -- Operaciones de lectura
      procedure Leer_Todo is 
      begin
         while not End_Of_File(F) and not End_Of_Line(F) loop
            Get(F,C);
         end loop;
      end Leer_Todo;

      procedure Leer_Caracter is 
      begin
         if not End_Of_File(F) and not End_Of_Line(F) then
            Get(F,C);
         end if;
      end Leer_Caracter;

      procedure Leer_Proximo_Caracter is 
      begin
         Leer_Caracter;
         while (C=' ' or C=Ascii.Ht) and not End_Of_File(F) and not End_Of_Line(F) loop
            Get(F,C);
         end loop;
      end Leer_Proximo_Caracter;

      procedure Leer_Caracter_Sin_Comprobar is 
      begin
         Get(F,C);
         while (C=' ' or C=Ascii.Ht) and not End_Of_File(F) and not
               End_Of_Line(F) loop
            Get(F,C);
         end loop;
      end  Leer_Caracter_Sin_Comprobar;


      -- Leemos una palabra, quitando espacios antes y después de la palabra
      function Leer_Palabra return Unbounded_String is 
         String_Temp : Unbounded_String := Null_Unbounded_String;  
      begin
         while (C=' ' or C=Ascii.Ht) and not End_Of_File(F) and not
               End_Of_Line(F) loop
            Get(F,C);
         end loop;
         while C/=' ' and C/=Ascii.Ht and C/='=' and (not End_Of_File(F)) and (not End_Of_Line(F)) loop
            String_Temp:=String_Temp & To_Upper(C);
            Get(F,C);
         end loop;
         while (C=' ' or C=Ascii.Ht) and not End_Of_File(F) and not
               End_Of_Line(F) loop
            Get(F,C);
         end loop;
         return String_Temp;
      end Leer_Palabra;




      -- Gramática para lectura del fichero de configuración

      procedure L is 
         Nombre_Variable,  
         Valor_Variable  : Unbounded_String := Null_Unbounded_String;  
      begin
         if C='#' then
            Leer_Todo;
         else
            Nombre_Variable:=Leer_Palabra;

            if Nombre_Variable/=To_Unbounded_String("LANGUAGE") and Nombre_Variable/=To_Unbounded_String("LANGUAGE_NAME")then
               if  Debug/=Deactivated and Debug/=No_Debug then
                  New_Line;
                  Put_Line("Error, fichero de configuracion '" &
                     Ruta & "' incorrecto. ");
                  Put_Line("Se esperaba  'Language' o 'Language_Name'");
               end if;
               Close(F);
               raise Fichero_Configuracion_Incorrecto;
            end if;


            if C/='=' then
               if  Debug/=Deactivated and Debug/=No_Debug then
                  New_Line;
                  Put_Line("Error, fichero de configuracion '" &
                     Ruta & "' incorrecto. ");
                  Put_Line("Se esperaba  '='.");
               end if;
               Close(F);
               raise Fichero_Configuracion_Incorrecto;
            end if;
            Leer_Proximo_Caracter;
            if C/='"' then -- " inicial
               if Debug/=Deactivated and Debug/=No_Debug then
                  New_Line;
                  Put_Line("Error, fichero de configuracion '" &
                     Ruta & "' incorrecto. ");
                  Put_Line(
                     "Se esperaban comillas (" & '"' &
                     ").");
               end if;
               Close(F);
               raise Fichero_Configuracion_Incorrecto;
            end if;

            Leer_Caracter;

            while C/='"' loop  -- " final
               if End_Of_Line(F) or End_Of_File(F) then
                  if Debug/=Deactivated and Debug/=No_Debug then
                     New_Line;
                     Put_Line("Error, fichero de configuracion " &
                        Ruta & " incorrecto. ");
                     Put_Line(
                        "Se esperaban comillas (" & '"' &
                        ").");
                  end if;
                  Close(F);
                  raise Fichero_Configuracion_Incorrecto;
               end if;


               Valor_Variable:=Valor_Variable & To_Upper(C);
               Leer_Caracter;
            end loop;

            Leer_Proximo_Caracter;


            -- Tenemos la variable y su valor
            if Nombre_Variable=To_Unbounded_String("LANGUAGE_NAME") then
               if Debug=Total_No_Stop or Debug=Total_Stop then
                  Put_Line("Language_Name = " & To_String(Valor_Variable));
               end if;
               Config.Nombre_Idioma:=Valor_Variable;

            elsif Nombre_Variable=To_Unbounded_String("LANGUAGE") then
               if Debug=Total_No_Stop or Debug=Total_Stop then
                  Put_Line("Language = " & To_String(Valor_Variable));
               end if;
               declare
                  Iterador : T_Language := T_Language'First;  
               begin
                  -- Buscamos el idioma
                  while Iterador/=T_Language'Last and T_Language'Image(Iterador)/=To_String(Valor_Variable) loop
                     Iterador:=T_Language'Succ(Iterador);
                  end loop;
                  if Iterador=T_Language'Last then  -- NULL, idioma NO VALIDO
                     if Debug/=Deactivated and Debug/=No_Debug then
                        New_Line;
                        Put_Line("Error, fichero de configuracion " &
                           Ruta & " incorrecto. ");
                        Put_Line(
                           "Idioma '" & To_String(Valor_Variable)  & "' no valido.");
                     end if;
                     raise Fichero_Configuracion_Incorrecto;

                  else
                     Config.Idioma:=Iterador ;
                  end if;

               end;
            end if;
            Nombre_Variable:=Null_Unbounded_String;
            Valor_Variable:=Null_Unbounded_String;

         end if;
      end L;


      ----------------------------------------------------------------------------------------

      procedure Linea is 
      begin
         if End_Of_Line(F) then
            begin
               Leer_Caracter_Sin_Comprobar;
            exception
               when End_Error=>
                  null;
            end;
         else
            L;
         end if;
      end Linea;

      procedure Conf_File is 
      begin
         if End_Of_File(F) then
            null;
         else
            Linea;
            Conf_File;
         end if;
      end Conf_File ;


      Salir : exception;  
   begin
      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Abriendo fichero de configuracion " & Ruta);
      end if;
      begin
         Open(F,In_File,Ruta);
      exception
         when Name_Error=>
            if Debug=Total_No_Stop or Debug=Total_Stop then
               Put_Line("No se cargara la configuracion dado que no existe " & Ruta);
            end if;
            raise Salir;

      end;
      Leer_Proximo_Caracter;
      Conf_File;
      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Configuracion leida correctamente. Cerrando fichero.");
      end if;
      Close(F);
   exception
      when Salir=>
         null;
   end Cargar_Configuración;






   ----------------------------
   -- Escribir_Configuración --
   ----------------------------

   procedure Escribir_Configuración (
         Ruta   : String;                           
         Config : T_Datos_Configuracion;            
         Debug  : T_Debug_Level         := No_Debug ) is 
      F : File_Type;  
   begin


      -- Miramos si existe o no el fichero. Si no existe, lo creamos y escribimos una cabecera
      -- Si existe, añadimos la frase al final

      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Preparando escritura de fichero de configuracion");
      end if;


      begin
         Create (F,Out_File,Ruta);
      exception
         when Name_Error=>
            if Debug/=Deactivated and Debug/=No_Debug then
               New_Line;
               Put_Line("Error, no se puede crear el fichero " &
                  Ruta);
            end if;
            raise Fichero_Configuracion_Incorrecto;
      end;

      Put(F,"# Internationalization Configuration File Created with " &
         Adaintl_Version.Name_Of_Adaintl);
      New_Line(F);
      Put(F,"# "& Adaintl_Version.Name_Of_Adaintl &
         " is an internationalizing tool for Ada95 programs created by " &
         Adaintl_Version.Creator_Of_Adaintl);
      New_Line(F);
      Put(F,"# More info at "& Adaintl_Version.Web_Url_About_Ada );
      New_Line(F,2);
      Put(F,"# File: '" & Ruta & "'");
      New_Line(F);


      -- Añadimos los datos de configuración
      Put(F, "Language = " & '"' & T_Language'Image(Config.Idioma) & '"');
      New_Line(F);
      Put(F, "Language_name = " & '"' & To_String(Config.Nombre_Idioma) & '"');
      New_Line(F);

      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line(
            "Fichero de configuracion creado correctamente. Cerrando fichero.");
      end if;
      Close(F);
   end Escribir_Configuración;



   ----------------------------------
   -- Existe_Fichero_Configuración --
   ----------------------------------

   function Existe_Fichero_Configuración (
         Ruta  : String;                   
         Debug : T_Debug_Level := No_Debug ) 
     return Boolean is 
      F : File_Type;  
   begin
      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Comprobando fichero de configuracion " & Ruta);
      end if;
      begin
         Open (F,In_File,Ruta);
         Close (F);
      exception
         when Name_Error=> -- No existe!
            if Debug=Total_No_Stop or Debug=Total_Stop then
               Put_Line("No existe el fichero de configuracion " & Ruta);
            end if;
            return False;
      end;
      return True;

   end Existe_Fichero_Configuración;

end D_Archivo_Conf;

