with D_Idiomas, D_Debug;
use D_Idiomas, D_Debug;

package Adaintl is

   type Internationalization_Type is private; 
   type Language_Type is new D_Idiomas.T_Language; 

   -- Debug levels available:
   -- * Deactivated
   -- * No_Debug
   -- * Only_Errors_No_Stop
   -- * Only_Errors_Stop 
   -- * Total_No_Stop     
   -- * Total_Stop
   type Debug_Level_Type is new T_Debug_Level; 


   -------------------------------
   --------- Constructor ---------
   -------------------------------

   function Initialize (
         Language                : Language_Type;                  
         Default_Domain          : String           := "Language"; 
         Debug_Mode              : Debug_Level_Type := No_Debug;   
         Directory               : String           := "";         
         Load_Configuration_File : String           := ""          ) 
     return Internationalization_Type; 


   --------------------------
   --------- Config ---------
   --------------------------

   procedure Set_Default_Domain (
         Domain : String ); 
   procedure Set_Debug_Mode (
         Debug_Mode : Debug_Level_Type ); 
   procedure Set_Language (
         Language : Language_Type ); 


   -----------------------
   ---- Localization -----
   -----------------------

   function "-" (
         Right : String ) 
     return String; 


   function "-" (
         Domain : String; 
         Phrase : String  ) 
     return String; 


   --------------------
   ---- Cleaning  -----
   --------------------

   -- You should execute "Clean_Adaintl" before exiting your program.
   -- This will clean strings from memory.
   -- After cleaning, you have to exit the program or initialize again AdaIntl
   procedure Clean_Adaintl; 



   ------------------------------
   ---- Available languages -----
   ------------------------------

   type Availabe_Languages_Array is array (Language_Type'First.. Language_Type'Last) of Boolean; 

   -- Get_Available_Languages returns an array with all the languages supported by AdaIntl
   -- that says if you can use them with the default domain.
   function Get_Available_Languages return Availabe_Languages_Array; 


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
