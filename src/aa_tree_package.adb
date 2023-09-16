-- This library was made by Mark Allen Weiss
-- http://www.cs.fiu.edu/~weiss/ada.html
-- Used and modified with permission of author to use in AdaIntl

-- Implementation of AA_Tree_Package

with Unchecked_Deallocation;

package body Aa_Tree_Package is

   procedure Dispose is 
   new Unchecked_Deallocation( Tree_Node, Tree_Ptr );

   function "=" (
         Left,                
         Right : Element_Type ) 
     return Boolean; 
   procedure Skew (
         P : in out Tree_Ptr ); 
   procedure Split (
         P : in out Tree_Ptr ); 

   -- THE VISIBLE ROUTINES

   procedure Initialize (
         T : in out Aa_Tree ) is 
   begin
      T.Null_Node := new Tree_Node;
      T.Null_Node.Left := T.Null_Node;
      T.Null_Node.Right := T.Null_Node;
      T.Null_Node.Level := 0;
      T.Root := T.Null_Node;
   end Initialize;


   procedure Finalize (
         T : in out Aa_Tree ) is 
   begin
      Make_Empty( T );
      Dispose( T.Null_Node );
   end Finalize;


   procedure Delete (
         X :        Element_Type; 
         T : in out Aa_Tree       ) is 
      Delete_Ptr : Tree_Ptr;  
      Last_Ptr   : Tree_Ptr;  

      procedure Delete (
            X :        Element_Type; 
            P : in out Tree_Ptr      ) is 
      begin
         if P /= T.Null_Node then
            -- Search down the tree and set Last_Ptr and Delete_Ptr
            Last_Ptr := P;
            if X < P.Element then
               Delete( X, P.Left );
            else
               Delete_Ptr := P;
               Delete( X, P.Right );
            end if;

            -- If at bottom of the tree and X is present, remove it
            if P = Last_Ptr then
               if Delete_Ptr /= T.Null_Node and then
                     X = Delete_Ptr.Element then
                  Delete_Ptr.Element := P.Element;
                  Delete_Ptr := T.Null_Node;
                  P := P.Right;
                  Dispose( Last_Ptr );
               else
                  raise Item_Not_Found;
               end if;

               -- Otherwise, we are not at the bottom; rebalance
            else
               if P.Left.Level < P.Level - 1 or else
                     P.Right.Level < P.Level - 1 then

                  P.Level := P.Level - 1;
                  if P.Right.Level > P.Level then
                     P.Right.Level := P.Level;
                  end if;

                  Skew( P );
                  Skew( P.Right );
                  Skew( P.Right.Right );
                  Split( P );
                  Split( P.Right );
               end if;
            end if;
         end if;   -- P /= T.Null_Node
      end Delete;   -- Recursive routine
   begin
      Delete( X, T.Root );
   end Delete;


   function Find (
         X : Element_Type; 
         T : Aa_Tree       ) 
     return Tree_Ptr is 
      Current : Tree_Ptr := T.Root;  
   begin
      while Current /= T.Null_Node loop
         if X < Current.Element then
            Current := Current.Left;
         elsif Current.Element < X then
            Current := Current.Right;
         else
            return Current;
         end if;
      end loop;

      raise Item_Not_Found;
   end Find;

   function Find_Min (
         T : Aa_Tree ) 
     return Tree_Ptr is 
      Ptr : Tree_Ptr := T.Root;  
   begin
      if Ptr = T.Null_Node then
         raise Item_Not_Found;
      else
         while Ptr.Left /= T.Null_Node loop
            Ptr := Ptr.Left;
         end loop;
      end if;

      return Ptr;
   end Find_Min;

   function Find_Max (
         T : Aa_Tree ) 
     return Tree_Ptr is 
      Ptr : Tree_Ptr := T.Root;  
   begin
      if Ptr = T.Null_Node then
         raise Item_Not_Found;
      else
         while Ptr.Right /= T.Null_Node loop
            Ptr := Ptr.Right;
         end loop;
      end if;

      return Ptr;
   end Find_Max;

   procedure Insert (
         X :        Element_Type; 
         T : in out Aa_Tree       ) is 
      procedure Insert (
            X :        Element_Type; 
            P : in out Tree_Ptr      ) is 
      begin
         if P = T.Null_Node then
            P := new Tree_Node'( X, T.Null_Node, T.Null_Node, 0 );
         elsif X < P.Element then
            Insert( X, P.Left );
         elsif P.Element < X then
            Insert( X, P.Right );
         else
            raise Item_Exists;
         end if;

         Skew( P );
         Split ( P );
      end Insert;
   begin
      Insert( X, T.Root );
   end Insert;


   procedure Make_Empty (
         T : in out Aa_Tree ) is 
      procedure Make_Empty (
            P : in out Tree_Ptr ) is 
      begin
         if P /= T.Null_Node then
            Make_Empty( P.Left );
            Make_Empty( P.Right );
            Dispose( P );
         end if;
      end Make_Empty;
   begin
      Make_Empty( T.Root );
      -- T.Root.Left := T.Null_Node;
      -- T.Root.Right := T.Null_Node;
   end Make_Empty;

   procedure Print_Tree (
         T : Aa_Tree ) is 
      procedure Print_Tree (
            P : Tree_Ptr ) is 
      begin
         if P /= T.Null_Node then
            Print_Tree( P.Left );
            Put( P.Element ); --New_Line;
            Print_Tree( P.Right );
         end if;
      end Print_Tree;
   begin
      Print_Tree( T.Root );
   end Print_Tree;

   function Retrieve (
         P : Tree_Ptr ) 
     return Element_Type is 
   begin
      return P.Element;
   end Retrieve;

   -- INTERNAL ROUTINES
   -- "=" to make tree code look nicer
   function "=" (
         Left,                
         Right : Element_Type ) 
     return Boolean is 
   begin
      return not( Right < Left ) and then not( Left < Right );
   end "=";

   procedure Rotate_With_Left_Child (
         K2 : in out Tree_Ptr ) is 
      K1 : Tree_Ptr := K2.Left;  
   begin
      K2.Left := K1.Right;
      K1.Right := K2;
      K2 := K1;
   end Rotate_With_Left_Child;

   procedure Rotate_With_Right_Child (
         K1 : in out Tree_Ptr ) is 
      K2 : Tree_Ptr := K1.Right;  
   begin
      K1.Right := K2.Left;
      K2.Left := K1;
      K1 := K2;
   end Rotate_With_Right_Child;

   procedure Skew (
         P : in out Tree_Ptr ) is 
   begin
      if P.Left.Level = P.Level then
         Rotate_With_Left_Child( P );
      end if;
   end Skew;

   procedure Split (
         P : in out Tree_Ptr ) is 
   begin
      if P.Right.Right.Level = P.Level then
         Rotate_With_Right_Child( P );
         P.Level := P.Level + 1;
      end if;
   end Split;

end Aa_Tree_Package;
