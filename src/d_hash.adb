with Interfaces;
use Interfaces;


package body D_Hash is

   -- Usamos el algoritmo de hashing "Elf Hash" 
   function Hash (
         Key : String ) 
     return T_Hash is 

      H,  
      G : Unsigned_32 := 0;  


   begin
      for I in Key'range loop
         H :=Rotate_Left( H, 4 ) +Character'Pos(Key(I));
         -- h & 0xF0000000
         G := (H and Unsigned_32(4026531840));
         if ( G /= 0 ) then
            H := (H xor Unsigned_32(Shift_Right(G, 24)));
         end if;

         H := Unsigned_32(H) and not(G);
      end loop;

      return T_Hash(H);

   end Hash;

end D_Hash;