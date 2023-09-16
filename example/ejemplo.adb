
with Adaintl;
use Adaintl;


with Ada.Text_Io;
use Ada.Text_Io;

procedure Ejemplo is 

   C : Character;  


begin

   Initialize_Adaintl (Es, "Frases", No_Debug, "", "Language.txt");

   Put_Line("A continuacion se ejecutaran algunas pruebas");
   Put_Line("para comprobar el correcto funcionamiento de AdaIntl.");
   New_Line;
   Put_Line("AdaIntl extrae las frases de los archivos de traduccion");
   Put_Line(
      "automaticamente. Estos ficheros se llaman 'dominios' (domain).");
   New_Line;
   Put_Line(
      "Las frases a traducir vienen precedidas por '-' en el codigo fuente.");
   Put_Line("Se puede usar el dominio por defecto, o especificar uno.");
   Put_Line("El idioma se puede cambiar en tiempo de ejecucion.");


   New_Line(2);
   Put_Line("Castellano:");
   Put_Line(-"* Frase numero 1 para probar");
   Put_Line(-"* Frase numero 2 para probar");
   Put_Line("Paises"-"* España");   -- Dominio (explicito): "Paises"
   Put_Line("Paises"-"* Italia");   -- Dominio (explicito): "Paises"

   New_Line(2);
   Set_Language(En);
   Put_Line("Ingles:");
   Put_Line(-"* Frase numero 1 para probar");
   Put_Line(-"* Frase numero 2 para probar");
   Put_Line("Paises"-"* España");   -- Dominio (explicito): "Paises"
   Put_Line("Paises"-"* Italia");   -- Dominio (explicito): "Paises"


   New_Line(2);
   Set_Language(Ca);
   Put_Line("Catalan:");
   Put_Line(-"* Frase numero 1 para probar");
   Put_Line(-"* Frase numero 2 para probar");
   Put_Line("Paises"-"* España");   -- Dominio (explicito): "Paises"
   Put_Line("Paises"-"* Italia");   -- Dominio (explicito): "Paises"


   Clean_Adaintl;

   Get_Immediate(C);

end Ejemplo;
