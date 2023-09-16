with Ada.Text_Io;
use Ada.Text_Io;

package body D_Arbol_Frases is



   ----------------------------------
   -- Funciones para instanciación --
   ----------------------------------
   function Menorque (
         Left,           
         Right : T_Frase ) 
     return Boolean is 
   begin
      if Left.Hash<Right.Hash then
         return True;
      else
         return False;
      end if;
   end Menorque;

   procedure Imprimir (
         X : T_Frase ) is 
   begin
      Put_Line("Hash: " & T_Hash'Image(X.Hash));
      Put_Line("Frase: " & To_String(X.Frase));
   end Imprimir;



   -- Implementación de operación del arbol
   procedure Inicializar (
         T : in out Af_Arbol ) is 
   begin
      Initialize(Aa_Tree(T));

   end Inicializar;

   procedure Finalizar (
         T : in out Af_Arbol ) is 
   begin 
      Finalize(Aa_Tree(T));
   end Finalizar;


   procedure Borrar (
         X :        T_Frase; 
         T : in out Af_Arbol ) is 
   begin
      begin
         Delete(X,Aa_Tree(T));
      exception
         when Item_Not_Found=>
            raise Hash_No_Existente;
      end;
   end Borrar;


   function Buscar (
         X : T_Hash;  
         T : Af_Arbol ) 
     return Af_Ptr is 
      A : T_Frase;  
   begin
      A.Hash:=X;
      begin
         return Af_Ptr(D_Arbol_Frases.Find(A,Aa_Tree(T)));
      exception
         when Item_Not_Found=>
            raise Hash_No_Existente;
      end;
   end Buscar;

   function Buscar_Min (
         T : Af_Arbol ) 
     return Af_Ptr is 
   begin
      begin
         return Af_Ptr(D_Arbol_Frases.Find_Min(Aa_Tree(T)));
      exception
         when Item_Not_Found=>
            raise Hash_No_Existente;
      end;
   end Buscar_Min;

   function Buscar_Max (
         T : Af_Arbol ) 
     return Af_Ptr is 
   begin
      begin
         return Af_Ptr(D_Arbol_Frases.Find_Max(Aa_Tree(T)));
      exception
         when Item_Not_Found=>
            raise Hash_No_Existente;
      end;
   end Buscar_Max;


   procedure Insertar (
         X :        T_Frase; 
         T : in out Af_Arbol ) is 
   begin
      begin
         Insert(X,Aa_Tree(T));
      exception
         when Item_Exists=>
            raise Hash_Existente;
      end;
   end Insertar;

   procedure Vaciar (
         T : in out Af_Arbol ) is 
   begin
      Make_Empty(Aa_Tree(T));
   end Vaciar;

   procedure Imprimir_Arbol (
         T : Af_Arbol ) is 
   begin
      Print_Tree(Aa_Tree(T));
   end Imprimir_Arbol;

   function Recuperar (
         P : Af_Ptr ) 
     return T_Frase is 
   begin
      begin

         return T_Frase(D_Arbol_Frases.Retrieve (Af_Ptr(P)));
      exception
         when Item_Not_Found=>
            raise Hash_No_Existente;
      end;
   end Recuperar;



   -- Nueva_Frase: Dada una frase, busca su hash y crea un T_Frase
   function Nueva_Frase (
         Frase : String ) 
     return T_Frase is 
      X : T_Frase;  
   begin
      X.Hash:=D_Hash.Hash(Frase);
      X.Frase:=To_Unbounded_String(Frase);
      return X;
   end Nueva_Frase;

   -- Hash: Dada una T_Frase, devuelve su Hash
   function Hash (
         N : T_Frase ) 
     return T_Hash is 
   begin
      return N.Hash;
   end Hash;

   -- Frase: Dada una T_Frase, devuelve su Frase
   function Frase (
         F : T_Frase ) 
     return String is 
   begin
      return To_String(F.Frase);
   end Frase;



end D_Arbol_Frases;