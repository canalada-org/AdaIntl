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