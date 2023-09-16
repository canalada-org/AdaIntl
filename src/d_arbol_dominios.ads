
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with D_Idiomas,D_Arbol_Frases;
use D_Idiomas,D_Arbol_Frases;

with Aa_Tree_Package;

package D_Arbol_Dominios is

   --------------------
   -- Nodo del arbol --
   --------------------
   -- Contiene una un dominio y un idioma
   type Puntero_Arbol is access Af_Arbol; 
   type T_Dominio is 
      record 
         Dominio     : Unbounded_String;  
         Idioma      : T_Language;  
         Arbol_Frase : Puntero_Arbol;  
      end record; 


   ----------------------------------
   -- Funciones para instanciación --
   ----------------------------------
   function Menorque (
         Left,             
         Right : T_Dominio ) 
     return Boolean; 
   procedure Imprimir (
         X : T_Dominio ); 



   -----------------------------
   -- Instanciación del arbol --
   -----------------------------
   package Arbol_Dominios is new Aa_Tree_Package (T_Dominio,Menorque,
      Imprimir);
   use Arbol_Dominios ;

   type Ad_Arbol is limited private; 
   type Ad_Ptr is new Arbol_Dominios.Tree_Ptr; 


   -- Operaciones de t_dominio
   -------------------------
   -- Nuevo dominio: crea un t_dominio
   function Nuevo_Dominio (
         Dominio : String;    
         Idioma  : T_Language ) 
     return T_Dominio; 
   -- Dominio: Dada una t_dominio, devuelve su nombre de dominio
   function Dominio (
         N : T_Dominio ) 
     return String; 
   -- Idioma: Dada una t_dominio, devuelve su idioma
   function Idioma (
         F : T_Dominio ) 
     return T_Language; 
   -- Arbol_Frases: Devuelve el arbol de frases
   function Arbol_Frases (
         F : T_Dominio ) 
     return puntero_arbol; 





   -------------------------------
   ---     OPERACIONES         ---
   -------------------------------



   -----------------
   -- Constructor --
   -----------------
   procedure Inicializar (
         T : in out Ad_Arbol ); 

   procedure Finalizar (
         T : in out Ad_Arbol ); 

   procedure Borrar (
         X :        T_Dominio; 
         T : in out Ad_Arbol   ); 


   function Buscar (
         X : String;  
         T : Ad_Arbol ) 
     return Ad_Ptr; 

   function Buscar_Min (
         T : Ad_Arbol ) 
     return Ad_Ptr; 

   function Buscar_Max (
         T : Ad_Arbol ) 
     return Ad_Ptr; 


   procedure Insertar (
         X :        T_Dominio; 
         T : in out Ad_Arbol   ); 

   procedure Vaciar (
         T : in out Ad_Arbol ); 

   procedure Imprimir_Arbol (
         T : Ad_Arbol ); 

   function Recuperar (
         P : Ad_Ptr ) 
     return T_Dominio; 

   -----------------------------
   ---    EXCEPCIONES        ---
   -----------------------------

   Dominio_Existente    : exception;  
   Dominio_No_Existente : exception;  

   private
   -- Debido a que de cada nodo del arbol de dominios "cuelga"
   -- un arbol completo de frases, si borramos el arbol de dominios tendremos
   -- que borrar cada arbol de frases (o dejarlo como basura y que un recolector
   -- se encargue de eliminarlo). Dado que la implementación del arbol AA
   -- que usamos no dispone de "iterador" para recorrer cada elemento, 
   -- guardamos el nombre de cada dominio para saber cuales tenemos y así
   -- poder acceder a ellos y borrar su arbol de frases cuando sea necesario.
   Max_Dominios : constant Natural := 512;  
   type Tlista is array (0 .. Max_Dominios - 1) of Unbounded_String; 

   type Ad_Arbol is 
      record 
         Arbol  : Arbol_Dominios.Aa_Tree;  
         Lista  : Tlista;  
         Cursor : Natural;  
      end record; 


end D_Arbol_Dominios;