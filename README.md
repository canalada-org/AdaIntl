# AdaIntl
Internationalization for Ada programs

# ¿Que es AdaIntl ?

AdaIntl es una librería multiplataforma hecha totalmente en Ada95 y liberada bajo licencia LGPL que permite localizar software multilingüe de forma sencilla.

Para traducir un programa sin ninguna librería para ello, es necesario modificar todas las cadenas de texto del código fuente de forma manual, y volver a compilarlas y linkarlas. 
Se pueden crear estructuras complejas que devuelvan cadenas de texto en distintos idiomas, pero cualquier traducción nueva o corrección pasa necesariamente por la edición del código fuente, lo que lo dota de muy poca flexibilidad.

AdaIntl permite de una forma extremadamente sencilla crear archivos de texto donde se guarden todas las cadenas de texto que usa el programa. Para traducir la aplicación a otros idiomas, tan solo será necesario editar esos archivos de texto (manualmente, con otras aplicaciones, etc). De esa forma un mismo binario puede estar en tantos idiomas como se desee, y permite cambiar de uno a otro en tiempo de ejecución.

Funciona de forma muy similar a GNU/gettext, el cual si se quiere usar en Ada se debe importar desde C (como hace GTKAda.Intl). AdaIntl evita el tener que instalar gettext o importar y depender de código externo a Ada. AdaIntl es directo, sencillo y fácil de usar.

Es importante resaltar que AdaIntl NO traduce el programa, AdaIntl NO es un traductor.

Resumen de características:
- Guarda las cadenas de texto en archivos para ser traducidas fácilmente.
- 100% hecho en Ada95.
- Multiplataforma.
- No usa variables de entorno.
- Posibilidad de cambiar de idioma en tiempo de ejecución.
- Guarda el idioma elegido en un archivo para cargar ese idioma en la próxima ejecución.
- 2 tipos de estructura de archivos: en carpetas o en el mismo directorio.
- Identificación de las cadenas de texto mediante el hash “Elf”.
- 6 modos de Debug.
- Posibilidad de adaptar y convertir a archivos *.po.
- Soporte para 175 idiomas.

# ¿Cómo funciona?

AdaIntl guarda las cadenas de texto del código fuente en archivos de texto (llamados “dominios”) para poder ser traducidas y posteriormente leerlas. 
Las cadenas de texto que se guardan son las que llevan “-” antes de cada string. Por ejemplo, una cadena que no guardaría sería:
```ada
   Put_Line("Cadena de texto");
```
En cambio sí que se guardaría en el dominio la siguiente cadena:
```ada
   Put_Line(-"Cadena de texto");
```
Dado que las cadenas de texto van a ser traducidas, se calcula un hash para identificarlas en el archivo de localización. Por tanto las cadenas que tengan el mismo hash se consideran iguales.

Al ejecutar el programa, AdaIntl calcula el hash de "Cadena de texto" y mira si está en el archivo de localización. Si no es así, lo escribe en él. Si el hash está en el dominio, lee la cadena de texto del fichero (identificada por el hash, ya que la cadena puede variar al ser traducida) y la devuelve para ser visualizada por pantalla. 

Para acelerar el proceso, las cadenas de texto de cada dominio están cargadas en memoria y almacenadas en un árbol AA. Para más detalles sobre el funcionamiento interno, se puede consultar el punto 4.3.

Para organizar mejor la traducción, AdaIntl permite usar varios dominios. Por ejemplo, puede haber un dominio “Mensajes_de_error”, otro “Avisos”, otro “Acerca_de”, etc. En cualquier momento se puede pasar de un dominio a otro, ya sea especificando el dominio por defecto, o especificando explícitamente que dominio usar con la función “-”.

Además permite elegir el idioma y cambiarlo en cualquier momento, guardar un archivo de configuración con el idioma elegido por el usuario (y así usar ese mismo idioma en la próxima ejecución), obtener todos los idiomas en los que está disponible la aplicación, etc.

# Documentación

Documentación completa en [doc/AdaIntl.pdf](doc/AdaIntl.pdf)
