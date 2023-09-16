package D_Hash is

   -- Tipo "T_Hash"
   type T_Hash is mod 2**32; 

   -- Función que devuelve el hash de un string
   -- Usamos "Elf Hash"
   function Hash (
         Key : String ) 
     return T_Hash; 
end D_Hash;
