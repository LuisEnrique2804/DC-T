/*******************************************************************************
Desarrollado por: Avanxo México
Autor: René Ayala
Proyecto: Telcel Directorio Comercial
Descripción: Clase que contiene los métodos de seguridad para todos los procesos de la organización.

Cambios (Versiones)
-------------------------------------
No.    Fecha      Autor                       Descripción
------ ---------- --------------------------  -----------   
0.1    04-02-2018 René Ayala Medina RAM       Creación
0.2    04-02-2018 René Ayala Medina RAM       Construcción         
*******************************************************************************/

public class TLCL_SecurityServices_cls {

    /**
     * Encriptar contraseña de usuario
     * @param  password  Contraseña a encriptar
     * @param  aesKey    Llave AES
     * @param  algorithm Algoritmo de cifrado
     * @return           Contraseña encriptada
    **/

    public static String encryptResource(String strResource, String aesKey, String algorithm) {
        String strEncryptedPassword = null;
        Blob cryptoKey = EncodingUtil.base64Decode(aesKey);
        Blob data = Blob.valueOf(strResource);
        Blob encryptedData = Crypto.encryptWithManagedIV(algorithm, cryptoKey, data);
        strEncryptedPassword = EncodingUtil.base64Encode(encryptedData);
        return strEncryptedPassword;
    }
    
    /**
     * Desencriptar contraseña de usuario
     * @param  password  Contraseña a desencriptar
     * @param  aesKey    Llave AES
     * @param  algorithm Algoritmo de cifrado
     * @return           Contraseña desencriptada
    **/

    public static String decryptResource(String strResource, String aesKey, String algorithm) {
        String strDecryptedPassword = null;
        Blob cryptoKey = EncodingUtil.base64Decode(aesKey);
        Blob data = EncodingUtil.base64Decode(strResource);
        Blob decryptedData = Crypto.decryptWithManagedIV(algorithm, cryptoKey, data);
        strDecryptedPassword = decryptedData.toString();
        return strDecryptedPassword;
    }


}