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


with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with D_Hash;
use D_Hash;

with Aa_Tree_Package;

package D_Arbol_Frases is

   --------------------
   -- Nodo del arbol --
   --------------------
   -- Contiene una frase y su Hash correspondiente
   type T_Frase is 
      record 
         Hash  : T_Hash;  
         Frase : Unbounded_String;  
      end record; 


   ----------------------------------
   -- Funciones para instanciación --
   ----------------------------------
   function Menorque (
         Left,           
         Right : T_Frase ) 
     return Boolean; 
   procedure Imprimir (
         X : T_Frase ); 



   -----------------------------
   -- Instanciación del arbol --
   -----------------------------
   package Arbol_Frases is new Aa_Tree_Package (T_Frase,Menorque,Imprimir);
   use Arbol_Frases;

   type Af_Arbol is new Arbol_Frases.Aa_Tree; 
   type Af_Ptr is new Arbol_Frases.Tree_Ptr; 


   -- Operaciones de T_Frase
   -------------------------
   -- Nueva_Frase: Dada una frase, busca su hash y crea un T_Frase
   function Nueva_Frase (
         Frase : String ) 
     return T_Frase; 
   -- Hash: Dada una T_Frase, devuelve su Hash
   function Hash (
         N : T_Frase ) 
     return T_Hash; 
   -- Frase: Dada una T_Frase, devuelve su Frase
   function Frase (
         F : T_Frase ) 
     return String; 





   -------------------------------
   ---     OPERACIONES         ---
   -------------------------------



   -----------------
   -- Constructor --
   -----------------
   procedure Inicializar (
         T : in out Af_Arbol ); 
   procedure Finalizar (
         T : in out Af_Arbol ); 

   procedure Borrar (
         X :        T_Frase; 
         T : in out Af_Arbol ); 


   function Buscar (
         X : T_Hash;  
         T : Af_Arbol ) 
     return Af_Ptr; 

   function Buscar_Min (
         T : Af_Arbol ) 
     return Af_Ptr; 

   function Buscar_Max (
         T : Af_Arbol ) 
     return Af_Ptr; 


   procedure Insertar (
         X :        T_Frase; 
         T : in out Af_Arbol ); 

   procedure Vaciar (
         T : in out Af_Arbol ); 

   procedure Imprimir_Arbol (
         T : Af_Arbol ); 

   function Recuperar (
         P : Af_Ptr ) 
     return T_Frase; 

   -----------------------------
   ---    EXCEPCIONES        ---
   -----------------------------

   Hash_Existente    : exception;  
   Hash_No_Existente : exception;  





end D_Arbol_Frases;