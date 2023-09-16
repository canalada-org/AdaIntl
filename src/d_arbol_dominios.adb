with Ada.Text_Io;
use Ada.Text_Io;

package body D_Arbol_Dominios is



   ----------------------------------
   -- Funciones para instanciación --
   ----------------------------------
   function Menorque (
         Left,             
         Right : T_Dominio ) 
     return Boolean is 
   begin
      if Left.Dominio<Right.Dominio then
         return True;
      else
         return False;
      end if;
   end Menorque;

   procedure Imprimir (
         X : T_Dominio ) is 
   begin
      Put_Line("Dominio: " & To_String(X.Dominio));
      Put_Line("Idioma: " & T_Language'Image(X.Idioma));
   end Imprimir;



   -- Implementación de operación del arbol
   procedure Inicializar (
         T : in out Ad_Arbol ) is 
   begin
      for I in reverse 0..Max_Dominios-1 loop
         T.Lista(I):=Null_Unbounded_String;
      end loop;
      T.Cursor:=0;
      Initialize(Aa_Tree(T.Arbol));
   end Inicializar;

   procedure Finalizar (
         T : in out Ad_Arbol ) is 

   begin

      -- Buscamos todos los dominios, accedemos a sus árboles de frase y los BORRAMOS
      if T.Cursor>0 then
         for I in 0..T.Cursor-1 loop
            D_Arbol_Frases.Finalizar(Recuperar(Buscar(To_String(T.Lista(I)),T)).Arbol_Frase.All);
         end loop;
         T.Cursor:=0;
      end if;
      T.Cursor:=0;
      Initialize(Aa_Tree(T.Arbol));
      Finalize(Aa_Tree(T.Arbol));
   end Finalizar;


   procedure Borrar (
         X :        T_Dominio; 
         T : in out Ad_Arbol   ) is 
   begin
      begin
         D_Arbol_Frases.Finalizar(X.Arbol_Frase.All);
         Delete(X,Aa_Tree(T.Arbol));
      exception
         when Item_Not_Found=>
            raise Dominio_No_Existente;
      end;
   end Borrar;


   function Buscar (
         X : String;  
         T : Ad_Arbol ) 
     return Ad_Ptr is 
      A : T_Dominio;  
   begin
      A.Dominio:=To_Unbounded_String(X);
      begin
         return Ad_Ptr(D_Arbol_Dominios.Find(A,Aa_Tree(T.Arbol)));
      exception
         when Item_Not_Found=>
            raise Dominio_No_Existente;
      end;
   end Buscar;

   function Buscar_Min (
         T : Ad_Arbol ) 
     return Ad_Ptr is 
   begin
      begin
         return Ad_Ptr(D_Arbol_Dominios.Find_Min(Aa_Tree(T.Arbol)));
      exception
         when Item_Not_Found=>
            raise Dominio_No_Existente;
      end;
   end Buscar_Min;

   function Buscar_Max (
         T : Ad_Arbol ) 
     return Ad_Ptr is 
   begin
      begin
         return Ad_Ptr(D_Arbol_Dominios.Find_Max(Aa_Tree(T.Arbol)));
      exception
         when Item_Not_Found=>
            raise Dominio_No_Existente;
      end;
   end Buscar_Max;


   procedure Insertar (
         X :        T_Dominio; 
         T : in out Ad_Arbol   ) is 
      Dominio_Ya_Insertado : Boolean := False;  
   begin

      begin
         Insert(X,Aa_Tree(T.Arbol));
      exception
         when Item_Exists=>
            raise Dominio_Existente;
      end;
      -- Si se ha insertado correctamente, lo metemos en la lista de dominios (a no ser que ya esté en ella)
      if T.Cursor<Max_Dominios  then
         if T.Cursor/=0 then
            for I in 0..T.Cursor-1 loop
               if T.Lista(I)=X.Dominio then
                  Dominio_Ya_Insertado:=True;
               end if;
            end loop;
         end if;
         if not Dominio_Ya_Insertado then
            T.Lista(T.Cursor):=X.Dominio;
            T.Cursor:=T.Cursor+1;
         end if;
      end if;
      -- Corregir: Si no quedan más dominios, al limpiar el arbol puede que queden
      -- restos en la memoria!!!!
         end Insertar;

   procedure Vaciar (
         T : in out Ad_Arbol ) is 
   begin
      Make_Empty(Aa_Tree(T.Arbol));
   end Vaciar;

   procedure Imprimir_Arbol (
         T : Ad_Arbol ) is 
   begin
      Print_Tree(Aa_Tree(T.Arbol));
   end Imprimir_Arbol;

   function Recuperar (
         P : Ad_Ptr ) 
     return T_Dominio is 
   begin
      begin
         return T_Dominio(D_Arbol_Dominios.Retrieve (Ad_Ptr(P)));
      exception
         when Item_Not_Found=>
            raise Dominio_No_Existente;
      end;
   end Recuperar;





   -- Nuevo dominio: crea un t_dominio
   function Nuevo_Dominio (
         Dominio : String;    
         Idioma  : T_Language ) 
     return T_Dominio is 
      X : T_Dominio;  
   begin
      X.Dominio:=To_Unbounded_String(Dominio);
      X.Idioma:=Idioma;
      X.Arbol_Frase:=new Af_Arbol;
      Inicializar(X.Arbol_Frase.All);
      return X;
   end Nuevo_Dominio;

   -- Dominio: Dada una t_dominio, devuelve su nombre de dominio
   function Dominio (
         N : T_Dominio ) 
     return String is 
   begin
      return  To_String(N.Dominio);
   end Dominio;
   -- Idioma: Dada una t_dominio, devuelve su idioma
   function Idioma (
         F : T_Dominio ) 
     return T_Language is 
   begin
      return F.Idioma;
   end Idioma;
   -- Arbol_Frases: Devuelve el arbol de frases
   function Arbol_Frases (
         F : T_Dominio ) 
     return Puntero_Arbol is 
   begin
      return F.Arbol_Frase;
   end Arbol_Frases;




end D_Arbol_Dominios;