//Generated by wsdl2apex

public class DCT_TelcelEquiposSoap_ws {
    public class simCardCaracteristicasVO {
        public String tipoSim;
        public String tecnologiaSim;
        public String tipoSimCaract;
        public DCT_TelcelEquiposSoap_ws.ArrayOfVersionSim versionesSim;
        private String[] tipoSim_type_info = new String[]{'tipoSim','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] tecnologiaSim_type_info = new String[]{'tecnologiaSim','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] tipoSimCaract_type_info = new String[]{'tipoSimCaract','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] versionesSim_type_info = new String[]{'versionesSim','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'tipoSim','tecnologiaSim','tipoSimCaract','versionesSim'};
    }
    public class ArrayOfVersionSim {
        public DCT_TelcelEquiposSoap_ws.versionSim[] versionSim;
        private String[] versionSim_type_info = new String[]{'versionSim','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'versionSim'};
    }
    public class caracteristicasVO {
        public String tamanoPantalla;
        public String nfc;
        public DCT_TelcelEquiposSoap_ws.simCardCaracteristicasVO simCard;
        public String dimensiones;
        public String camaraFrontal;
        public String camaraTrasera;
        public String memoriaInterna;
        public String memoriaLibre;
        public String memoriaRam;
        public String sistemaOperativo;
        public String duracionBateriaSb;
        public String duracionBateriaLlamada;
        public String tecnologiaPantalla;
        public String procesador;
        public String categoria;
        private String[] tamanoPantalla_type_info = new String[]{'tamanoPantalla','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] nfc_type_info = new String[]{'nfc','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] simCard_type_info = new String[]{'simCard','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] dimensiones_type_info = new String[]{'dimensiones','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] camaraFrontal_type_info = new String[]{'camaraFrontal','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] camaraTrasera_type_info = new String[]{'camaraTrasera','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] memoriaInterna_type_info = new String[]{'memoriaInterna','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] memoriaLibre_type_info = new String[]{'memoriaLibre','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] memoriaRam_type_info = new String[]{'memoriaRam','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] sistemaOperativo_type_info = new String[]{'sistemaOperativo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] duracionBateriaSb_type_info = new String[]{'duracionBateriaSb','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] duracionBateriaLlamada_type_info = new String[]{'duracionBateriaLlamada','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] tecnologiaPantalla_type_info = new String[]{'tecnologiaPantalla','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] procesador_type_info = new String[]{'procesador','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] categoria_type_info = new String[]{'categoria','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'tamanoPantalla','nfc','simCard','dimensiones','camaraFrontal','camaraTrasera','memoriaInterna','memoriaLibre','memoriaRam','sistemaOperativo','duracionBateriaSb','duracionBateriaLlamada','tecnologiaPantalla','procesador','categoria'};
    }
    public class getModelosResponseDTO {
        public DCT_TelcelEquiposSoap_ws.controlDataResponseCustom controlData;
        public DCT_TelcelEquiposSoapEsb_ws.detailResponse detailResponse;
        public DCT_TelcelEquiposSoap_ws.modelosOUTDTO listaModelos;
        private String[] controlData_type_info = new String[]{'controlData','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] detailResponse_type_info = new String[]{'detailResponse','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] listaModelos_type_info = new String[]{'listaModelos','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'controlData','detailResponse','listaModelos'};
    }
    public class modelo {
        public String cveModeloM2k;
        public String descripcionModelo;
        public String nombreComercial;
        private String[] cveModeloM2k_type_info = new String[]{'cveModeloM2k','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] descripcionModelo_type_info = new String[]{'descripcionModelo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] nombreComercial_type_info = new String[]{'nombreComercial','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'cveModeloM2k','descripcionModelo','nombreComercial'};
    }
    public class controlDataResponseCustom {
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class modelosOUTDTO {
        public DCT_TelcelEquiposSoap_ws.modelo[] Modelo;
        public Integer movimientoWS;
        public Integer estatusWS;
        public String descEstatusWS;
        private String[] Modelo_type_info = new String[]{'Modelo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','-1','false'};
        private String[] movimientoWS_type_info = new String[]{'movimientoWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] estatusWS_type_info = new String[]{'estatusWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','false'};
        private String[] descEstatusWS_type_info = new String[]{'descEstatusWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'Modelo','movimientoWS','estatusWS','descEstatusWS'};
    }
    public class informacionModelo {
        public String descripcionModelo;
        public String nombreComercial;
        public DCT_TelcelEquiposSoap_ws.caracteristicasVO caracteristicas;
        public DCT_TelcelEquiposSoap_ws.ArrayOfColorCaracteristicasVO colores;
        private String[] descripcionModelo_type_info = new String[]{'descripcionModelo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] nombreComercial_type_info = new String[]{'nombreComercial','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] caracteristicas_type_info = new String[]{'caracteristicas','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] colores_type_info = new String[]{'colores','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'descripcionModelo','nombreComercial','caracteristicas','colores'};
    }
    public class materialSapSim {
        public String numeroMaterialSapSim;
        private String[] numeroMaterialSapSim_type_info = new String[]{'numeroMaterialSapSim','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'numeroMaterialSapSim'};
    }
    public class ArrayOfColorCaracteristicasVO {
        public DCT_TelcelEquiposSoap_ws.colorCaracteristicasVO[] color;
        private String[] color_type_info = new String[]{'color','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'color'};
    }
    public class marcasOUTDTO {
        public DCT_TelcelEquiposSoap_ws.marca[] Marca;
        public Integer movimientoWS;
        public Integer estatusWS;
        public String descEstatusWS;
        private String[] Marca_type_info = new String[]{'Marca','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','-1','false'};
        private String[] movimientoWS_type_info = new String[]{'movimientoWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] estatusWS_type_info = new String[]{'estatusWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','false'};
        private String[] descEstatusWS_type_info = new String[]{'descEstatusWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'Marca','movimientoWS','estatusWS','descEstatusWS'};
    }
    public class marca {
        public Integer cveMarca;
        public String descripcionMarca;
        private String[] cveMarca_type_info = new String[]{'cveMarca','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] descripcionMarca_type_info = new String[]{'descripcionMarca','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'cveMarca','descripcionMarca'};
    }
    public class getMarcasResponseDTO {
        public DCT_TelcelEquiposSoap_ws.controlDataResponseCustom controlData;
        public DCT_TelcelEquiposSoapEsb_ws.detailResponse detailResponse;
        public DCT_TelcelEquiposSoap_ws.marcasOUTDTO listaMarcas;
        private String[] controlData_type_info = new String[]{'controlData','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] detailResponse_type_info = new String[]{'detailResponse','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] listaMarcas_type_info = new String[]{'listaMarcas','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'controlData','detailResponse','listaMarcas'};
    }
    public class colorCaracteristicasVO {
        public String nombre;
        public DCT_TelcelEquiposSoap_ws.ArrayOfModeloMaterialSap listaMaterialesSap;
        private String[] nombre_type_info = new String[]{'nombre','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] listaMaterialesSap_type_info = new String[]{'listaMaterialesSap','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'nombre','listaMaterialesSap'};
    }
    public class informacionModeloOUTDTO {
        public DCT_TelcelEquiposSoap_ws.informacionModelo[] Modelo;
        public Integer movimientoWS;
        public Integer estatusWS;
        public String descEstatusWS;
        private String[] Modelo_type_info = new String[]{'Modelo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','-1','false'};
        private String[] movimientoWS_type_info = new String[]{'movimientoWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] estatusWS_type_info = new String[]{'estatusWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'1','1','false'};
        private String[] descEstatusWS_type_info = new String[]{'descEstatusWS','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'Modelo','movimientoWS','estatusWS','descEstatusWS'};
    }
    public class versionSim {
        public String version;
        public DCT_TelcelEquiposSoap_ws.materialSapSim[] listaMaterialSapSim;
        private String[] version_type_info = new String[]{'version','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] listaMaterialSapSim_type_info = new String[]{'listaMaterialSapSim','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'version','listaMaterialSapSim'};
    }
    public class ArrayOfModeloMaterialSap {
        public DCT_TelcelEquiposSoap_ws.modeloMaterialSap[] materialSap;
        private String[] materialSap_type_info = new String[]{'materialSap','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'materialSap'};
    }
    public class getInformacionModeloResponseDTO {
        public DCT_TelcelEquiposSoap_ws.controlDataResponseCustom controlData;
        public DCT_TelcelEquiposSoapEsb_ws.detailResponse detailResponse;
        public DCT_TelcelEquiposSoap_ws.informacionModeloOUTDTO InformacionModelo;
        private String[] controlData_type_info = new String[]{'controlData','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] detailResponse_type_info = new String[]{'detailResponse','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] InformacionModelo_type_info = new String[]{'InformacionModelo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'controlData','detailResponse','InformacionModelo'};
    }
    public class modeloMaterialSap {
        public String descripcion;
        public String tipoMaterialSap;
        public Integer cveTipoMaterialSap;
        public Integer cveNumMaterial;
        public String numMaterial;
        public Double costo;
        public String modelo;
        public String denominacion;
        public String grupoArticulos;
        public String rotacion;
        public String color;
        public Integer cveModalidad;
        public Integer cvePromocionSiap;
        public Integer cveCicloVida;
        public Integer cveResurtibilidad;
        private String[] descripcion_type_info = new String[]{'descripcion','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] tipoMaterialSap_type_info = new String[]{'tipoMaterialSap','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] cveTipoMaterialSap_type_info = new String[]{'cveTipoMaterialSap','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] cveNumMaterial_type_info = new String[]{'cveNumMaterial','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] numMaterial_type_info = new String[]{'numMaterial','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] costo_type_info = new String[]{'costo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] modelo_type_info = new String[]{'modelo','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] denominacion_type_info = new String[]{'denominacion','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] grupoArticulos_type_info = new String[]{'grupoArticulos','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] rotacion_type_info = new String[]{'rotacion','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] color_type_info = new String[]{'color','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] cveModalidad_type_info = new String[]{'cveModalidad','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] cvePromocionSiap_type_info = new String[]{'cvePromocionSiap','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] cveCicloVida_type_info = new String[]{'cveCicloVida','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] cveResurtibilidad_type_info = new String[]{'cveResurtibilidad','http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.amx.com.mx/mexico/telcel/di/sds/crm/dlyscrm/equipos','true','false'};
        private String[] field_order_type_info = new String[]{'descripcion','tipoMaterialSap','cveTipoMaterialSap','cveNumMaterial','numMaterial','costo','modelo','denominacion','grupoArticulos','rotacion','color','cveModalidad','cvePromocionSiap','cveCicloVida','cveResurtibilidad'};
    }
}