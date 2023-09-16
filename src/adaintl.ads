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


with D_Idiomas, D_Debug;
use D_Idiomas, D_Debug;

package Adaintl is

   -- This type is necessary if you want to initialize AdaIntl
   -- in the declarative part of your program. It has no other use.
   type Internationalization_Type is private; 



   -- 6 Debug levels available:
   -- * Deactivated
   -- * No_Debug
   -- * Only_Errors_No_Stop
   -- * Only_Errors_Stop 
   -- * Total_No_Stop     
   -- * Total_Stop

   -- See documentation for further information
   type Debug_Level_Type is new T_Debug_Level; 



   -- The list of languages available in AdaIntl.
   -- It follows the ISO 639-1, with a pair of modifications:
   --    "Is" (icelandic) is a reserved word in Ada95 (cannot be used).
   --    So "Is"-> "Isl"
   --    "Or" (Oriya)  is a reserved word in Ada95 (cannot be used).
   --    So "Or"->"Ori"
   --    There is a wildcard language: Nul
   type Language_Type is new D_Idiomas.T_Language; 



   -------------------------------
   --------- Constructor ---------
   -------------------------------

   -- Specify the default Language 
   -- The Default Domain that will be used
   -- Set the debug mode
   -- The directory structure ("" for saving the translations
   --   files in the same directory of the program, using the 
   --   language as extension, or "x/" for saving each transl. 
   --   file in "x" directory, for example "locale/" or "translations/")
   -- and if AdaIntl has to load the language from a file instead of
   -- using the first parameter (if "", language from first parameter will
   --   be used; if /="", it will load the language from that 
   --   configuration file, if conf. file doesn't exists, it will 
   --   create one with the language used in the first parameter).

   -- IMPORTANT: The "Directory" parameter MUST end with "/"

   -- See documentation for further information
   function Initialize_Adaintl (
         Language                : Language_Type;                  
         Default_Domain          : String           := "Language"; 
         Debug_Mode              : Debug_Level_Type := No_Debug;   
         Directory               : String           := "";         
         Load_Configuration_File : String           := ""          ) 
     return Internationalization_Type; 

   procedure Initialize_Adaintl (
         Language                : Language_Type;                  
         Default_Domain          : String           := "Language"; 
         Debug_Mode              : Debug_Level_Type := No_Debug;   
         Directory               : String           := "";         
         Load_Configuration_File : String           := ""          ); 


   --------------------------
   --------- Config ---------
   --------------------------

   -- You can change debug_mode, default domain and language
   -- on execution-time.
   -- You can also get that information.

   procedure Set_Default_Domain (
         Domain : String ); 
   procedure Set_Debug_Mode (
         Debug_Mode : Debug_Level_Type ); 
   procedure Set_Language (
         Language : Language_Type ); 

   function Get_Default_Domain return String; 
   function Get_Debug_Mode return Debug_Level_Type; 
   function Get_Language return Language_Type; 


   -----------------------
   ---- Localization -----
   -----------------------

   function "-" (
         Right : String ) 
     return String; 


   function "-" (
         Left  : String; 
         Right : String  ) 
     return String; 


   ------------------------------
   ---- Available languages -----
   ------------------------------

   type Availabe_Languages_Array is array (Language_Type'First.. Language_Type'Last) of Boolean; 

   -- Get_Available_Languages returns an array with all the languages supported by AdaIntl
   -- that says if you can use them with the default domain.
   function Get_Available_Languages return Availabe_Languages_Array; 



   --------------------
   ---- Cleaning  -----
   --------------------

   -- You should execute "Clean_Adaintl" before exiting your program.
   -- This will clean strings from memory.
   -- After cleaning, you have to exit the program or initialize again AdaIntl
   procedure Clean_Adaintl; 





   ---------------------
   ---- Exceptions -----
   ---------------------

   -- If debug mode is set to "x_No_Stop" (or no_debug or deactivated), exception are not raised and
   -- initial string is returned when "-" is executed (for example, -"Hello" would return "Hello").

   -- File_not_correct is raised when the translation file has errors and cannot be read
   File_Not_Correct : exception;  
   -- Conf_File_not_correct is raised when the configuration file has errors and cannot be read
   Conf_File_Not_Correct : exception;  
   -- Language_not_valid is raised when language is "nul". You must specify another one.
   Language_Not_Valid : exception;  
   -- Not_Initialized is raised when AdaIntl hasn't been initialized properly
   Not_Initialized : exception;  

private

   type Internationalization_Type is new Boolean; 

end Adaintl;
