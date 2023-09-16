package D_Debug is

   type T_Debug_Level is 
         (Deactivated,         
          No_Debug,            
          Only_Errors_No_Stop, 
          Only_Errors_Stop,    
          Total_No_Stop,       
          Total_Stop); 

end D_Debug;
