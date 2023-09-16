-- Generic Package Specification for AA_Tree_Package
--
-- Requires:
--     Instantiated with any private type and
--     a "<" function for that type and
--     a Put procedure for that type
-- Types defined:
--     Tree_Ptr            private type
--     AA_Tree             limited private type
-- Exceptions defined:
--     Item_Not_Found      raised when searches or deletions fail
-- Operations defined:
--     (* throws Item_Not_Found)
--     Initialize and Finalize are defined for AA_Tree
--     Delete *            removes item from AA tree
--     Find  *             returns Tree_Ptr of item in AA tree
--     Find_Max *          returns Tree_Ptr of maximum item in AA tree
--     Find_Min *          returns Tree_Ptr of minimum item in AA tree
--     Insert              insert item into AA tree
--     Make_Empty          make an AA tree empty
--     Print_Tree          print AA tree in sorted order
--     Retrieve *          returns item in Tree_Ptr passed as parameter

with Ada.Finalization;
--with Text_IO; use Text_IO;

generic
    type Element_Type is private;
    with function "<" ( Left, Right: Element_Type ) return Boolean;
    with procedure Put( Element: Element_Type );
package AA_Tree_Package is
    type Tree_Ptr is private;
    type AA_Tree is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( T: in out AA_Tree );
    procedure Finalize( T: in out AA_Tree );

    procedure Delete( X: Element_Type; T: in out AA_Tree );
    function  Find( X: Element_Type; T: AA_Tree ) return Tree_Ptr;
    function  Find_Min( T: AA_Tree ) return Tree_Ptr;
    function  Find_Max( T: AA_Tree ) return Tree_Ptr;
    procedure Insert( X: Element_Type; T: in out AA_Tree );
    procedure Make_Empty( T: in out AA_Tree );
    procedure Print_Tree( T: AA_Tree );
    function  Retrieve( P: Tree_Ptr ) return Element_Type;

    Item_Not_Found : exception;
    Item_Exists: exception;    

private
    type Tree_Node;
    type Tree_Ptr is access Tree_Node;

    type AA_Tree is new Ada.Finalization.Limited_Controlled with
      record
        Root : Tree_Ptr;
        Null_Node : Tree_Ptr;
      end record;

    type Tree_Node is
      record
        Element : Element_Type;
        Left    : Tree_Ptr;
        Right   : Tree_Ptr;
        Level   : Integer;
      end record;

end AA_Tree_Package;
