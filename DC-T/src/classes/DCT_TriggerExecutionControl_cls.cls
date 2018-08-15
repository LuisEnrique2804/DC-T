/*******************************************************************************
Desarrollado por: Avanxo México
Autor: René Ayala
Proyecto: Directorio Comercial de Telcel
Descripción: Clase de APEX que tiene como principal objetivo evitar la ejecución recursiva de desencadenadores. Es decir, evitar que la ejecución de un desencadenador provoque la ejecución -nuevamente- del mismo desencadenador.

Cambios (Versiones)
-------------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------
0.1    27-02-2018 René Ayala Medina RAM      Creación
0.2    27-02-2018 René Ayala Medina RAM      Construcción
1.0    27-02-2018 Rene Ayala Medina RAM      Finalización y documentación     
*******************************************************************************/
public class DCT_TriggerExecutionControl_cls {
    
    /* Conjunto que almacena las cadenas de texto referentes a los desencadenadores ejecutados. De manera que se sepa qué desencadenador ya se ha ejecutado y cuál no lo ha hecho */
    private static Set<String> setExecutedTrigger = new Set<String>();

    /*
        Método que valida si el desencadenador se ha ejecutado. Si lo ha hecho, retorna "verdadero". Si no, retorna "falso".
    */

    public static Boolean hasAlreadyBeenExecuted(String strTriggerName){
        if(!setExecutedTrigger.isEmpty())
            return setExecutedTrigger.contains(strTriggerName);   /* Si el conjunto no está vació, se retorna verdadero o falso según exista la cadena de texto o no en el conjunto */
        else
            return false;  /* El conjunto se encuentra vacío */
    }

    /* 
        Método que se utiliza para almacenar la cadena de texto correspondiente al desencadenador ejecutado. De manera que se sepa que dicho desencadenador ya se ha ejecutado.
    */

    public static void setAlreadyBeenExecuted(String strTriggerName){
        setExecutedTrigger.add(strTriggerName);  /* Se almacena la cadena de texto en el conjunto */
    }

    /*
        Método que se utiliza para eliminar una cadena de texto representativa de un desencadenador. Después de ejecutarse este método, dicho desencadenador puede volver a ejecutarse.
    */
    
    //public static void resetStatusExecutionTrigger(String strTriggerName){
    //    if(setExecutedTrigger.contains(strTriggerName))
    //        setExecutedTrigger.remove(strTriggerName);  /* Se elimina la cadena de texto especificada del conjunto */
    //}

}