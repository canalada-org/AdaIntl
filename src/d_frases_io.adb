with Ada.Text_Io, Ada.Characters.Handling,Adaintl_Version;
use Ada.Text_Io, Ada.Characters.Handling,Adaintl_Version;

package body D_Frases_Io is



   ------------------
   --- Escritura ----
   ------------------

   procedure Escribir_Frase (
         Frase   : String;                   
         Hash    : T_Hash;                   
         Dominio : String;                   
         Idioma  : T_Language;               
         Debug   : T_Debug_Level := No_Debug ) is 
      F : File_Type;  
   begin

      -- Miramos si existe o no el fichero. Si no existe, lo creamos y escribimos una cabecera
      -- Si existe, añadimos la frase al final

      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Preparando escritura de '" & Frase &
            "' en el fichero de traduccion " & Ruta_Fichero(Dominio,
               Idioma));
      end if;

      if not Existe_Fichero (Dominio,Idioma,Debug) then

         if Debug=Total_No_Stop or Debug=Total_Stop then
            Put_Line("Creando fichero de traduccion " & Ruta_Fichero(
                  Dominio, Idioma));
         end if;
         begin
            Create (F,Out_File,Ruta_Fichero(Dominio, Idioma));
         exception
            when Name_Error=>
                  if Debug/=Deactivated and Debug/=No_Debug then
                  New_Line;
                  Put_Line("Error, no se puede crear el fichero " &
                     Ruta_Fichero(Dominio, Idioma));
                  Put_Line(
                     "Asegurese de que existe el directorio elegido.");
               end if;
               raise Fichero_Incorrecto;
         end;
         Put(F,"# Internationalization File Created with " &
            Adaintl_Version.Name_Of_Adaintl);
         New_Line(F);
         Put(F,"# "& Adaintl_Version.Name_Of_Adaintl &
            " is an internationalizing tool for Ada95 programs created by " &
            Adaintl_Version.Creator_Of_Adaintl);
         New_Line(F);
         Put(F,"# More info at "& Adaintl_Version.Web_Url_About_Ada );
         New_Line(F,2);
         Put(F,"# File: '" & Ruta_Fichero(Dominio, Idioma) & "'");
         New_Line(F);
         Put(F,"# Language: '" & T_Language'Image(Idioma) & "'");
         New_Line(F,2);
      else
         if Debug=Total_No_Stop or Debug=Total_Stop then
            Put_Line("Abriendo fichero de traduccion " & Ruta_Fichero(
                  Dominio, Idioma));
         end if;
         Open (F,Append_File,Ruta_Fichero(Dominio, Idioma));
      end if;

      -- Añadimos la frase
      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Escribiendo cadena.");
      end if;
      Put(F, "# " & '"' & Formatear_Texto_Para_Escribir(Frase) & '"');
      New_Line(F);
      Put(F,Quitar_Espacios(T_Hash'Image(Hash)) & "=" & '"'  &
         Formatear_Texto_Para_Escribir(Frase) & '"');
      New_Line(F,2);
      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Cadena escrita correctamente. Cerrando fichero.");
      end if;
      Close(F);
   end Escribir_Frase;


   ------------------
   ---  Lectura  ----
   ------------------

   procedure Cargar_Frases (
         Arbol   : in out Af_Arbol;                 
         Dominio :        String;                   
         Idioma  :        T_Language;               
         Debug   :        T_Debug_Level := No_Debug ) is 

      C           : Character        := ' ';  
      F           : File_Type;  
      Temp_Hash   : T_Hash           := 0;  
      Temp_String : Unbounded_String := Null_Unbounded_String;  
      Temp_Tfrase : T_Frase;  

      -- C es un digito, devuelve el valor del digito
      function Valor (
            C : Character ) 
        return Natural is 
         V_Digito      : String (1 .. 10) := "0123456789";  
         I             : Integer          := 1;  
         Encontrado    : Boolean          := False;  
         Error_Funcion : exception;  
      begin
         -- Buscamos el carácter en la tabla. 
         while I<=10 and (not Encontrado) loop
            Encontrado:= (V_Digito(I)=C);
            I:=I+1;
         end loop;

         if Encontrado then
            return I-2;
         else
            raise Error_Funcion;
         end if;
      exception
         when Error_Funcion=>
            return 0;
      end Valor;



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
         while (C=' ' or C=Ascii.Ht) and not End_Of_File(F) and not
               End_Of_Line(F) loop
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


      -- Gramática para lectura del fichero de traducción
      procedure L_Hash is 
      begin
         if not Is_Digit(C) then
            if Debug       /=Deactivated and Debug       /=No_Debug then
               New_Line;
               Put_Line("Error, fichero de configuracion " &  Ruta_Fichero(
                     Dominio, Idioma) & " incorrecto. ");
               Put_Line("Se esperaba un digito.");
            end if;
            Close(F);
            raise Fichero_Incorrecto;
         end if;
         while Is_Digit(C) loop
            Temp_Hash:=(10*Temp_Hash) + T_Hash(Valor(C));
            if End_Of_Line(F) or End_Of_File(F) then
               if Debug       /=Deactivated and Debug       /=No_Debug then
                  New_Line;
                  Put_Line("Error, fichero de configuracion " &
                     Ruta_Fichero(Dominio, Idioma) & " incorrecto. ");
                  Put_Line("Se esperaba  '='.");
               end if;
               Close(F);
               raise Fichero_Incorrecto;
            end if;
            Get(F,C);
         end loop;
         if C=' ' or C=Ascii.Ht then
            Leer_Proximo_Caracter;
         end if;

      end L_Hash;

      procedure L is 
      begin
         if C='#' then
            Leer_Todo;
         else
            L_Hash;
            if C/='=' then
               if  Debug/=Deactivated and Debug/=No_Debug then
                  New_Line;
                  Put_Line("Error, fichero de configuracion " &
                     Ruta_Fichero(Dominio, Idioma) & " incorrecto. ");
                  Put_Line("Se esperaba  '='.");
               end if;
               Close(F);
               raise Fichero_Incorrecto;
            end if;
            Leer_Proximo_Caracter;
            if C/='"' then -- " inicial
               if Debug/=Deactivated and Debug/=No_Debug then
                  New_Line;
                  Put_Line("Error, fichero de configuracion " &
                     Ruta_Fichero(Dominio, Idioma) & " incorrecto. ");
                  Put_Line(
                     "Se esperaban comillas para empezar la frase (" & '"' &
                     ").");
               end if;
               Close(F);
               raise Fichero_Incorrecto;
            end if;

            Leer_Caracter;

            while C/='"' loop  -- " final
               if End_Of_Line(F) or End_Of_File(F) then
                  if Debug/=Deactivated and Debug/=No_Debug then
                     New_Line;
                     Put_Line("Error, fichero de configuracion " &
                        Ruta_Fichero(Dominio, Idioma) & " incorrecto. ");
                     Put_Line(
                        "Se esperaban comillas para cerrar la frase (" & '"' &
                        ").");
                  end if;
                  Close(F);
                  raise Fichero_Incorrecto;
               end if;
               if C='\' then
                  Leer_Caracter;
                  if End_Of_Line(F) or End_Of_File(F) then
                     if Debug/=Deactivated and Debug/=No_Debug then
                        New_Line;
                        Put_Line("Error, fichero de configuracion " &
                           Ruta_Fichero(Dominio, Idioma) & " incorrecto. ");
                        Put_Line(
                           "Se esperaban comillas para cerrar la frase (" & '"' &
                           ").");
                     end if;
                     Close(F);
                     raise Fichero_Incorrecto;
                  end if;
               end if;
               Temp_String:=Temp_String & C;
               Leer_Caracter;
            end loop;

            Leer_Proximo_Caracter;


            -- Tenemos la frase y su hash
            -- La insertamos en el arbol
            Temp_Tfrase.Hash:=Temp_Hash;
            Temp_Tfrase.Frase:=Temp_String;
            begin
               Insertar(Temp_Tfrase,Arbol);
            exception
               when Hash_Existente=>
                  if Debug/=Deactivated and Debug/=No_Debug then
                     New_Line;
                     Put_Line("Error, fichero de configuracion " &
                        Ruta_Fichero(Dominio, Idioma) & " incorrecto. ");
                     Put_Line("Existen cadenas con el mismo hash" & T_Hash'
                        Image(Temp_Hash));
                  end if;
                  Close(F);
                  raise Fichero_Incorrecto;

            end;
            if Debug=Total_No_Stop or Debug=Total_Stop then
               Put_Line("Frase con hash " & T_Hash'Image(Temp_Hash) &
                  " leida y cargada correctamente.");

            end if;
            Temp_Hash:=0;
            Temp_String:=Null_Unbounded_String;
         end if;
      end L;

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

      procedure Doc is 
      begin
         if End_Of_File(F) then
            null;
         else
            Linea;
            Doc;
         end if;
      end Doc;

      Salir : exception;  
   begin
      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Abriendo fichero de traduccion " & Ruta_Fichero(
               Dominio, Idioma));
      end if;
      begin
         Open(F,In_File,Ruta_Fichero(Dominio, Idioma));
      exception
         when Name_Error=>
            if Debug=Total_No_Stop or Debug=Total_Stop then
               Put_Line("No se cargaran frases dado que no existe " &
                  Ruta_Fichero(Dominio, Idioma));
            end if;
            raise Salir;

      end;
      Leer_Proximo_Caracter;
      Doc;
      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Carga de frases completada. Cerrando fichero.");
      end if;
      Close(F);
   exception
      when Salir=>
         null;
   end Cargar_Frases;




   ------------------
   ----- Otros  -----
   ------------------


   -- Especifica si ha de usarse una organización tipo directorio 
   -- ej: x/Es_ES/fichero
   -- donde x es el directorio elegido
   -- o el idioma se pone de extensión en la misma carpeta
   -- ej: fichero.Es_ES
   -- Si S es "" (cadena nula), se usa extensión.
   -- Si S es una cadena no nula, se usa el directorio S. 
   -- El último caracter de S debe ser '/' (Unix) o '\' (Windows)
   -----------------
   -- Por ejemplo:
   -- Usar_Directorio("locale/");
   -- hará que los archivos de traducción se guarden en 
   -- locale/Es_ES/fichero
   procedure Usar_Directorio (
         S : String;                   
         D : T_Debug_Level := No_Debug ) is 
   begin
      Var_Usar_Directorio:=To_Unbounded_String(S);
      if D=Total_No_Stop or D=Total_Stop then
         Put("Tipo de organizacion: ");
         if S/="" then
            Put_Line("por directorios");
         else
            Put_Line("por extension");
         end if;
      end if;
   end Usar_Directorio;


   -- Comprueba si existe el fichero en el idioma 
   -- según la organización de directorios:
   -- /Es_ES/fichero o bien fichero.Es_ES
   function Existe_Fichero (
         Dominio : String;                   
         Idioma  : T_Language;               
         Debug   : T_Debug_Level := No_Debug ) 
     return Boolean is 
      F : File_Type;  
   begin


      if Debug=Total_No_Stop or Debug=Total_Stop then
         Put_Line("Comprobando fichero " & Ruta_Fichero(Dominio, Idioma));
      end if;
      begin
         Open (F,In_File,Ruta_Fichero(Dominio, Idioma));
         Close (F);
      exception
         when Name_Error=> -- No existe!
            if Debug=Total_No_Stop or Debug=Total_Stop then
               Put_Line("No existe el fichero " & Ruta_Fichero(Dominio,
                     Idioma));
            end if;
            return False;
      end;
      return True;


   end Existe_Fichero;



   -- Devuelve que ruta tiene el fichero de traducción
   function Ruta_Fichero (
         Dominio : String;    
         Idioma  : T_Language ) 
     return String is 
   begin
      if Var_Usar_Directorio/="" then
         return To_String(Var_Usar_Directorio) & T_Language'Image(Idioma)
            & To_String(Var_Usar_Directorio)(Length(Var_Usar_Directorio))
            -- / o \
            &  Dominio ;
      else
         return Dominio & "." & T_Language'Image(Idioma);
      end if;
   end Ruta_Fichero;


   -- Quita los espacios iniciales a la cadena S
   function Quitar_Espacios (
         S : in     String ) 
     return String is 
      I : Integer := S'First;  
   begin
      if S'Last>=I then
         while S(I)=' ' and I< S'Last loop
            I:=I+1;
         end loop;
      end if;
      return S(I..S'Last);
   end Quitar_Espacios;


   -- Prepara la cadena S para ser escrita en el archivo de traducción
   -- quitando las comillas, etc.
   -- Por ejemplo, la frase 
   -- El dijo "Hola"
   -- quedaría así:
   -- El dijo \"Hola\"
   function Formatear_Texto_Para_Escribir (
         S : in     String ) 
     return String is 

      U : Unbounded_String := Null_Unbounded_String;  

   begin
      for I in S'range loop
         case S(I) is
            when '"' =>
               U:=U & '\' & S(I);
            when '/' =>
               U:=U & '\' & S(I);
            when '\'=>
               U:=U & '\' & S(I);
            when others=>
               U:=U & S(I);
         end case;
      end loop;
      return To_String(U);
   end Formatear_Texto_Para_Escribir;



end D_Frases_Io;
