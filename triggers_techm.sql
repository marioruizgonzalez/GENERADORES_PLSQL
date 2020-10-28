----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
CREATE OR REPLACE TRIGGER GG_ADMIN.tr_mock_master_compuesto
  FOR insert or delete or update  ON gg_admin.tab_mock_master
  COMPOUND TRIGGER

  v_Contador NUMBER;

  -- Se lanzará después de cada fila actualizada
  AFTER EACH ROW IS
  BEGIN
	
    dbms_output.put_line('modificacion despues de cada fila');
  END AFTER EACH ROW;

  -- Se lanzará después de la sentencia
  AFTER STATEMENT IS
    cursor c_datos is
      select cadena, numero, fecha
        from gg_admin.tab_mock_master
       where numero = :new.numero;
			 
		cursor c_datos_old is
      select cadena, numero, fecha
        from gg_admin.tab_mock_master
       where numero = :old.numero;
			 
		registro number :=:old.numero;
  BEGIN
  
    if inserting then
    
      for i in c_datos loop
        insert into gg_admin.tab_mock_backup
          (cadena, numero, fecha)
        values
          (i.cadena, i.numero, i.fecha);
      end loop;
    
    elsif deleting then
    
      for i in c_datos loop
        delete from gg_admin.tab_mock_backup del
         where del.numero = registro;

      end loop;
    
    elsif updating then
    
      for i in c_datos_old loop
        update gg_admin.tab_mock_backup upd
           set upd.cadena = i.cadena, upd.fecha = i.fecha
         where upd.numero = i.numero;
      end loop;
    
    end if;
  
    DBMS_OUTPUT.PUT_LINE('modificacion despues de sentencia');
  END AFTER STATEMENT;
END tr_mock_master_compuesto;


---------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER GG_ADMIN.TR_SKU_INSTANCE
      AFTER INSERT OR UPDATE 
      ON GG_ADMIN.MTL_MATERIAL_TRANSACTIONS
      FOR EACH ROW

DECLARE   
    CURSOR C_QRY IS SELECT A.ERP_INVENTORY_ID,
                          A.SKU,
                          A.ADD_DATE,
                          A.MOD_DATE,
                          A.ORG_ID,
                          A.UOM_,
                          A.SUBINVENTORY_SHORT_CODE,
                          A.LOCATOR_ID,
                          A.LOCATOR_SHORT_NAME,
                          A.SOURCE_TYPE,
                          A.TRANSACTION_TYPE,
                          A.TRANSACTION_SOURCE,
                          A.TRANSACTION_TIME,
                          A.LPN_NO,
                          A.SHIPMENT_NO,
                          A.TRANSACTION_ACTION,
                          A.LOCATION,
                          A.SOURCE_PROJECT_NUMBER,
                          A.SOURCE_TASK_NUMBER,
                          A.PROJECT_NUMBER,
                          A.TASK_NUMBER,
                          A.TO_PROJECT_NUMBER,
                          A.TO_TASK_NUMBER,
                          A.FROM_OWNING_PARTY,
                          CASE
                             WHEN A.TRANSACTION_TYPE_ID = 21
                             THEN
                                A.FREIGHT_CODE
                             WHEN A.TRANSACTION_TYPE_ID = 3
                             THEN
                                A.CARRIER_ID
                             WHEN    A.TRANSACTION_TYPE_ID != 3
                                  OR A.TRANSACTION_TYPE_ID != 21
                                  OR A.TRANSACTION_TYPE_ID != 64
                             THEN
                                A.CARRIER_ID
                          END
                             TRANSPORT_COMPANY_ID,
                          CASE
                             WHEN A.TRANSACTION_TYPE_ID = 21
                             THEN
                                A.FREIGHT_CODE1
                             WHEN A.TRANSACTION_TYPE_ID = 3
                             THEN
                                A.FREIGHT_CODE
                             WHEN A.TRANSACTION_TYPE_ID != 3
                                  OR A.TRANSACTION_TYPE_ID != 21
                                  OR A.TRANSACTION_TYPE_ID != 64
                             THEN
                                A.FREIGHT_CODE1
                          END
                             TRANSPORT_COMPANY_NAME,
                          CASE
                             WHEN A.TRANSACTION_TYPE_ID = 21
                             THEN
                                'NA'
                             WHEN A.TRANSACTION_TYPE_ID = 3
                             THEN
                                'NA'
                             WHEN A.TRANSACTION_TYPE_ID != 3
                                  OR A.TRANSACTION_TYPE_ID != 21
                                  OR A.TRANSACTION_TYPE_ID != 64
                             THEN
                                A.NAME_DELIVERY_PERSON
                          END
                             NAME_DELIVERY_PERSON,
                          CASE
                             WHEN A.TRANSACTION_TYPE_ID = 21
                             THEN
                                A.WAYBILL_AIRBILL
                             WHEN A.TRANSACTION_TYPE_ID = 3
                             THEN
                                A.WAYBILL_AIRBILL
                             WHEN   A.TRANSACTION_TYPE_ID != 3
                                  OR A.TRANSACTION_TYPE_ID != 21
                                  OR A.TRANSACTION_TYPE_ID != 64
                             THEN
                                A.VEHICLE_NUMBER
                          END
                             PLATE_NO,
                          'NA' TRANSPORT_ATT_ID,
                          A.MOD_BY,
                          A.POSTAL_CODE FORM_ZIP_CODE,
                          A.POSTAL_CODE TO_ZIP_CODE,
                          A.ORG_DES,
                          A.SUBINV_DES,
                          A.LOC_DES,
                          A.MOVE_ORDER_LINE_ID,
                          A.TRANSACTION_SOURCE_ID,
                          A.SHIP_TO_LOCATION_ID,
                          A.OC
                     FROM (SELECT MMT.TRANSACTION_ID ERP_INVENTORY_ID,
                                  (SELECT UNIQUE MSI.SEGMENT1
                                     FROM GG_ADMIN.MTL_SYSTEM_ITEMS_B MSI
                                    WHERE     MSI.ORGANIZATION_ID = MMT.ORGANIZATION_ID
                                          AND MSI.INVENTORY_ITEM_ID = MMT.INVENTORY_ITEM_ID)
                                     SKU,
                                  MMT.CREATION_DATE ADD_DATE,
                                  MMT.LAST_UPDATE_DATE MOD_DATE,
                                  MMT.ORGANIZATION_ID ORG_ID,
                                  MMT.TRANSACTION_UOM UOM_,
                                  MMT.SUBINVENTORY_CODE SUBINVENTORY_SHORT_CODE,
                                  MMT.LOCATOR_ID LOCATOR_ID,
                                  (SELECT UNIQUE MIL.SEGMENT1
                                     FROM GG_ADMIN.MTL_ITEM_LOCATIONS MIL
                                    WHERE     1 = 1
                                          AND INVENTORY_LOCATION_ID = MMT.LOCATOR_ID
                                          AND ROWNUM = 1)
                                     LOCATOR_SHORT_NAME,
                                  (SELECT UNIQUE MTST_ST.TRANSACTION_SOURCE_TYPE_NAME
                                     FROM GG_ADMIN.MTL_TXN_SOURCE_TYPES MTST_ST
                                    WHERE     1 = 1
                                          AND MTST_ST.TRANSACTION_SOURCE_TYPE_ID =
                                                 MMT.TRANSACTION_SOURCE_TYPE_ID
                                          AND ROWNUM = 1)
                                     SOURCE_TYPE,
                                  (SELECT UNIQUE TRANSACTION_TYPE_NAME
                                     FROM GG_ADMIN.MTL_TRANSACTION_TYPES MTTRX
                                    WHERE     1 = 1
                                          AND MTTRX.TRANSACTION_TYPE_ID =
                                                 MMT.TRANSACTION_TYPE_ID
                                          AND ROWNUM = 1)
                                     TRANSACTION_TYPE,
                                  MMT.TRANSACTION_SOURCE_NAME TRANSACTION_SOURCE,
                                  MMT.TRANSACTION_DATE TRANSACTION_TIME,
                                  (SELECT UNIQUE SLPN.LICENSE_PLATE_NUMBER
                                     FROM GG_ADMIN.WMS_LICENSE_PLATE_NUMBERS SLPN
                                    WHERE SLPN.LOCATOR_ID = MMT.LOCATOR_ID AND ROWNUM = 1)
                                     LPN_NO,
                                  MMT.SHIPMENT_NUMBER SHIPMENT_NO,
                                  (SELECT UNIQUE NVL (FLV.MEANING, 'Def_Tx_Action')
                                     FROM GG_ADMIN.FND_LOOKUP_VALUES FLV
                                    WHERE     1 = 1
                                          AND FLV.LOOKUP_TYPE = 'MTL_TRANSACTION_ACTION'
                                          AND LANGUAGE = 'ESA'
                                          AND FLV.LOOKUP_CODE = MMT.TRANSACTION_ACTION_ID)
                                     TRANSACTION_ACTION,
                                  (SELECT UNIQUE HLA.LOCATION_CODE
                                     FROM GG_ADMIN.HR_ALL_ORGANIZATION_UNITS HAOU,
                                          GG_ADMIN.HR_LOCATIONS_ALL HLA
                                    WHERE     1 = 1
                                          AND HAOU.ORGANIZATION_ID = MMT.ORGANIZATION_ID
                                          AND HAOU.LOCATION_ID = HLA.LOCATION_ID)
                                     LOCATION,
                                  MMT.SOURCE_PROJECT_ID SOURCE_PROJECT_NUMBER,
                                  MMT.SOURCE_TASK_ID SOURCE_TASK_NUMBER,
                                  MMT.RCV_TRANSACTION_ID,
                                  (SELECT UNIQUE NVL (RCV.PROJECT_ID, 0)
                                     FROM GG_ADMIN.RCV_TRANSACTIONS RCV,
                                          GG_ADMIN.PA_PROJECTS_ALL PRO,
                                          GG_ADMIN.PA_TASKS TSK
                                    WHERE     1 = 1
                                          AND RCV.TRANSACTION_ID = MMT.RCV_TRANSACTION_ID --) Project_number
                                          AND PRO.PROJECT_ID = RCV.PROJECT_ID             ---+
                                          AND TSK.TASK_ID = RCV.TASK_ID)
                                     PROJECT_NUMBER,
                                  (SELECT UNIQUE NVL (RCV.TASK_ID, 0)                ---Number
                                     FROM GG_ADMIN.RCV_TRANSACTIONS RCV,
                                          GG_ADMIN.PA_PROJECTS_ALL PRO,
                                          GG_ADMIN.PA_TASKS TSK
                                    WHERE     1 = 1
                                          AND RCV.TRANSACTION_ID = MMT.RCV_TRANSACTION_ID --+
                                          AND PRO.PROJECT_ID = RCV.PROJECT_ID --+
                                          AND TSK.TASK_ID = RCV.TASK_ID)
                                     TASK_NUMBER,
                                  MMT.TO_PROJECT_ID TO_PROJECT_NUMBER,
                                  MMT.TO_TASK_ID TO_TASK_NUMBER,
                                  MMT.XFR_OWNING_ORGANIZATION_ID FROM_OWNING_PARTY,
                                  MMT.TRANSACTION_TYPE_ID,
                                  MMT.WAYBILL_AIRBILL,
                                  MMT.FREIGHT_CODE,
                                  MMT.SOURCE_PROJECT_ID,
                                  (SELECT UNIQUE FREIGHT_CODE
                                     FROM GG_ADMIN.WSH_CARRIERS WSC,
                                          GG_ADMIN.WSH_DELIVERY_DETAILS WDD
                                    WHERE     1 = 1
                                          AND WSC.CARRIER_ID = WDD.CARRIER_ID
                                          AND WDD.DELIVERY_DETAIL_ID = MMT.PICKING_LINE_ID)
                                     FREIGHT_CODE1,
                                  (SELECT UNIQUE TO_CHAR (WSC.CARRIER_ID) CARRIER_ID
                                     FROM GG_ADMIN.WSH_CARRIERS WSC,
                                          GG_ADMIN.WSH_DELIVERY_DETAILS WDD
                                    WHERE     1 = 1
                                          AND WSC.CARRIER_ID = WDD.CARRIER_ID
                                          AND WDD.DELIVERY_DETAIL_ID = MMT.PICKING_LINE_ID)
                                     CARRIER_ID,
                                  (SELECT UNIQUE
                                             WCCV.PERSON_FIRST_NAME
                                          || ' '
                                          || WCCV.PERSON_LAST_NAME
                                     FROM GG_ADMIN.WSH_CARRIER_CONTACTS_V WCCV,
                                          GG_ADMIN.WSH_DELIVERY_DETAILS WDD
                                    WHERE     1 = 1
                                          AND WCCV.CARRIER_ID = WDD.CARRIER_ID
                                          AND WDD.DELIVERY_DETAIL_ID = MMT.PICKING_LINE_ID)
                                     NAME_DELIVERY_PERSON,
                                  (SELECT UNIQUE WT.VEHICLE_NUMBER
                                     FROM GG_ADMIN.WSH_TRIPS WT,
                                          GG_ADMIN.WSH_TRIP_STOPS WTP,
                                          GG_ADMIN.WSH_TRIP_STOPS WTD,
                                          GG_ADMIN.WSH_DELIVERY_LEGS WDL,
                                          GG_ADMIN.WSH_DELIVERY_ASSIGNMENTS WDA,
                                          GG_ADMIN.WSH_NEW_DELIVERIES WND,
                                          GG_ADMIN.WSH_DELIVERY_DETAILS WDD
                                    WHERE     1 = 1
                                          AND WT.TRIP_ID = WTP.TRIP_ID
                                          AND WT.TRIP_ID = WTD.TRIP_ID
                                          AND WTP.STOP_ID = WDL.PICK_UP_STOP_ID
                                          AND WTD.STOP_ID = WDL.DROP_OFF_STOP_ID
                                          AND WDD.DELIVERY_DETAIL_ID = WDA.DELIVERY_DETAIL_ID
                                          AND WDA.DELIVERY_ID = WND.DELIVERY_ID
                                          AND WDL.DELIVERY_ID = WND.DELIVERY_ID
                                          AND WDD.DELIVERY_DETAIL_ID = MMT.PICKING_LINE_ID)
                                     VEHICLE_NUMBER,
                                  (SELECT UNIQUE FU.USER_NAME
                                     FROM GG_ADMIN.FND_USER FU
                                    WHERE 1 = 1 AND FU.USER_ID = MMT.CREATED_BY)
                                     MOD_BY,
                                  (SELECT UNIQUE HLA.POSTAL_CODE
                                     FROM GG_ADMIN.HR_ALL_ORGANIZATION_UNITS HAOU,
                                          GG_ADMIN.HR_LOCATIONS_ALL HLA
                                    WHERE     1 = 1
                                          AND HAOU.ORGANIZATION_ID = MMT.ORGANIZATION_ID
                                          AND HAOU.LOCATION_ID = HLA.LOCATION_ID)
                                     POSTAL_CODE,
                                  (SELECT UNIQUE ORGANIZATION_CODE
                                     FROM GG_ADMIN.MTL_PARAMETERS MP
                                    WHERE     1 = 1
                                          AND MP.ORGANIZATION_ID = MMT.TRANSFER_ORGANIZATION_ID)
                                     ORG_DES,
                                  MMT.TRANSFER_SUBINVENTORY SUBINV_DES,
                                  (SELECT UNIQUE SEGMENT1
                                     FROM GG_ADMIN.MTL_ITEM_LOCATIONS MIL
                                    WHERE     1 = 1
                                          AND MIL.INVENTORY_LOCATION_ID =
                                                 MMT.TRANSFER_LOCATOR_ID)
                                     LOC_DES,
                                  MMT.MOVE_ORDER_LINE_ID,
                                  MMT.TRANSACTION_SOURCE_ID,
                                  MMT.SHIP_TO_LOCATION_ID,
                                  (SELECT POH.SEGMENT1
                                     FROM GG_ADMIN.PO_HEADERS_ALL POH
                                    WHERE     1 = 1
                                          AND MMT.TRANSACTION_SOURCE_ID = POH.PO_HEADER_ID
                                          AND MMT.TRANSACTION_SOURCE_TYPE_ID = NVL (NULL, 1))
                                     OC
                             FROM (SELECT :NEW.TRANSACTION_ID TRANSACTION_ID,
										  :NEW.CREATION_DATE CREATION_DATE,
										  :NEW.LAST_UPDATE_DATE LAST_UPDATE_DATE,
										  :NEW.ORGANIZATION_ID ORGANIZATION_ID,
										  :NEW.INVENTORY_ITEM_ID INVENTORY_ITEM_ID,
										  :NEW.TRANSACTION_UOM TRANSACTION_UOM,
										  :NEW.SUBINVENTORY_CODE SUBINVENTORY_CODE,
										  :NEW.LOCATOR_ID LOCATOR_ID,
										  :NEW.TRANSACTION_SOURCE_TYPE_ID TRANSACTION_SOURCE_TYPE_ID,
										  :NEW.TRANSACTION_SOURCE_NAME TRANSACTION_SOURCE_NAME,
										  :NEW.TRANSACTION_DATE TRANSACTION_DATE,
										  :NEW.TRANSACTION_ACTION_ID TRANSACTION_ACTION_ID,
										  :NEW.SHIPMENT_NUMBER SHIPMENT_NUMBER,
										  :NEW.SOURCE_PROJECT_ID SOURCE_PROJECT_ID,
										  :NEW.SOURCE_TASK_ID SOURCE_TASK_ID,
										  :NEW.RCV_TRANSACTION_ID RCV_TRANSACTION_ID,
										  :NEW.TO_PROJECT_ID TO_PROJECT_ID,
										  :NEW.TO_TASK_ID TO_TASK_ID,
										  :NEW.XFR_OWNING_ORGANIZATION_ID XFR_OWNING_ORGANIZATION_ID,
										  :NEW.TRANSACTION_TYPE_ID TRANSACTION_TYPE_ID, 
										  :NEW.WAYBILL_AIRBILL WAYBILL_AIRBILL,
										  :NEW.FREIGHT_CODE FREIGHT_CODE,
										  :NEW.CREATED_BY CREATED_BY,
										  :NEW.PICKING_LINE_ID PICKING_LINE_ID,
										  :NEW.TRANSFER_ORGANIZATION_ID TRANSFER_ORGANIZATION_ID,
										  :NEW.TRANSFER_SUBINVENTORY TRANSFER_SUBINVENTORY,
										  :NEW.TRANSFER_LOCATOR_ID TRANSFER_LOCATOR_ID,
										  :NEW.MOVE_ORDER_LINE_ID MOVE_ORDER_LINE_ID,
										  :NEW.TRANSACTION_SOURCE_ID TRANSACTION_SOURCE_ID,
										  :NEW.SHIP_TO_LOCATION_ID SHIP_TO_LOCATION_ID
									 FROM DUAL) MMT
									) A;

BEGIN
	IF INSERTING THEN		
		FOR V_DATOS IN C_QRY
		LOOP
          INSERT INTO GG_ADMIN.SKU_INSTANCE_T	 
				(ERP_INVENTORY_ID,
				SKU,
				ADD_DATE,
				MOD_DATE,
				ORG_ID,
				UOM_,
				SUBINVENTORY_SHORT_CODE,
				LOCATOR_ID,
				LOCATOR_SHORT_NAME,
				SOURCE_TYPE,
				TRANSACTION_TYPE,
				TRANSACTION_SOURCE,
				TRANSACTION_TIME,
				LPN_NO,
				SHIPMENT_NO,
				TRANSACTION_ACTION,
				LOCATION,
				SOURCE_PROJECT_NUMBER,
				SOURCE_TASK_NUMBER,
				PROJECT_NUMBER,
				TASK_NUMBER,
				TO_PROJECT_NUMBER,
				TO_TASK_NUMBER,
				FROM_OWNING_PARTY,
				TRANSPORT_COMPANY_ID,
				TRANSPORT_COMPANY_NAME,
				NAME_DELIVERY_PERSON,
				PLATE_NO,
				TRANSPORT_ATT_ID,
				MOD_BY,
				FORM_ZIP_CODE,
				TO_ZIP_CODE,
				ORG_DES,
				SUBINV_DES,
				LOC_DES,
				MOVE_ORDER_LINE_ID,
				TRANSACTION_SOURCE_ID)
			 --   SHIP_TO_LOCATION_ID,
			 --   OC)
		VALUES (V_DATOS.ERP_INVENTORY_ID,
				V_DATOS.SKU,
				V_DATOS.ADD_DATE,
				V_DATOS.MOD_DATE,
				V_DATOS.ORG_ID,
				V_DATOS.UOM_,
				V_DATOS.SUBINVENTORY_SHORT_CODE,
				V_DATOS.LOCATOR_ID,
				V_DATOS.LOCATOR_SHORT_NAME,
				V_DATOS.SOURCE_TYPE,
				V_DATOS.TRANSACTION_TYPE,
				V_DATOS.TRANSACTION_SOURCE,
				V_DATOS.TRANSACTION_TIME,
				V_DATOS.LPN_NO,
				V_DATOS.SHIPMENT_NO,
				V_DATOS.TRANSACTION_ACTION,
				V_DATOS.LOCATION,
				V_DATOS.SOURCE_PROJECT_NUMBER,
				V_DATOS.SOURCE_TASK_NUMBER,
				V_DATOS.PROJECT_NUMBER,
				V_DATOS.TASK_NUMBER,
				V_DATOS.TO_PROJECT_NUMBER,
				V_DATOS.TO_TASK_NUMBER,
				V_DATOS.FROM_OWNING_PARTY,
				V_DATOS.TRANSPORT_COMPANY_ID,
				V_DATOS.TRANSPORT_COMPANY_NAME,
				V_DATOS.NAME_DELIVERY_PERSON,
				V_DATOS.PLATE_NO,
				V_DATOS.TRANSPORT_ATT_ID,
				V_DATOS.MOD_BY,
				V_DATOS.FORM_ZIP_CODE,
				V_DATOS.TO_ZIP_CODE,
				V_DATOS.ORG_DES,
				V_DATOS.SUBINV_DES,
				V_DATOS.LOC_DES,
				V_DATOS.MOVE_ORDER_LINE_ID,
				V_DATOS.TRANSACTION_SOURCE_ID);
			  --  V_DATOS.SHIP_TO_LOCATION_ID,
			  --  V_DATOS.OC);
		END LOOP;

	ELSIF UPDATING THEN
		FOR V_DATOS IN C_QRY
		LOOP
            MERGE INTO GG_ADMIN.SKU_INSTANCE_T NVA
                USING (SELECT V_DATOS.ERP_INVENTORY_ID ERP_INVENTORY_ID,
                        V_DATOS.SKU SKU,
                        V_DATOS.ADD_DATE ADD_DATE,
                        V_DATOS.MOD_DATE MOD_DATE,
                        V_DATOS.ORG_ID ORG_ID,
                        V_DATOS.UOM_ UOM_,
                        V_DATOS.SUBINVENTORY_SHORT_CODE SUBINVENTORY_SHORT_CODE,
                        V_DATOS.LOCATOR_ID LOCATOR_ID,
                        V_DATOS.LOCATOR_SHORT_NAME LOCATOR_SHORT_NAME,
                        V_DATOS.SOURCE_TYPE SOURCE_TYPE,
                        V_DATOS.TRANSACTION_TYPE TRANSACTION_TYPE,
                        V_DATOS.TRANSACTION_SOURCE TRANSACTION_SOURCE,
                        V_DATOS.TRANSACTION_TIME TRANSACTION_TIME,
                        V_DATOS.LPN_NO LPN_NO,
                        V_DATOS.SHIPMENT_NO SHIPMENT_NO,
                        V_DATOS.TRANSACTION_ACTION TRANSACTION_ACTION,
                        V_DATOS.LOCATION LOCATION,
                        V_DATOS.SOURCE_PROJECT_NUMBER SOURCE_PROJECT_NUMBER,
                        V_DATOS.SOURCE_TASK_NUMBER SOURCE_TASK_NUMBER,
                        V_DATOS.PROJECT_NUMBER PROJECT_NUMBER,
                        V_DATOS.TASK_NUMBER TASK_NUMBER,
                        V_DATOS.TO_PROJECT_NUMBER TO_PROJECT_NUMBER,
                        V_DATOS.TO_TASK_NUMBER TO_TASK_NUMBER,
                        V_DATOS.FROM_OWNING_PARTY FROM_OWNING_PARTY,
                        V_DATOS.TRANSPORT_COMPANY_ID TRANSPORT_COMPANY_ID,
                        V_DATOS.TRANSPORT_COMPANY_NAME TRANSPORT_COMPANY_NAME,
                        V_DATOS.NAME_DELIVERY_PERSON NAME_DELIVERY_PERSON,
                        V_DATOS.PLATE_NO PLATE_NO,
                        V_DATOS.TRANSPORT_ATT_ID TRANSPORT_ATT_ID,
                        V_DATOS.MOD_BY MOD_BY,
                        V_DATOS.FORM_ZIP_CODE FORM_ZIP_CODE,
                        V_DATOS.TO_ZIP_CODE TO_ZIP_CODE,
                        V_DATOS.ORG_DES ORG_DES,
                        V_DATOS.SUBINV_DES SUBINV_DES,
                        V_DATOS.LOC_DES LOC_DES,
                        V_DATOS.MOVE_ORDER_LINE_ID MOVE_ORDER_LINE_ID,
                        V_DATOS.TRANSACTION_SOURCE_ID TRANSACTION_SOURCE_ID
                    --V_DATOS.SHIP_TO_LOCATION_ID SHIP_TO_LOCATION_ID,
                    --V_DATOS.OC OC
                    FROM DUAL) QRY
            ON (QRY.ERP_INVENTORY_ID = NVA.ERP_INVENTORY_ID)
            WHEN MATCHED THEN        
                UPDATE SET 
                    NVA.SKU = QRY.SKU,
                    NVA.ADD_DATE = QRY.ADD_DATE,
                    NVA.MOD_DATE = QRY.MOD_DATE,
                    NVA.ORG_ID = QRY.ORG_ID,
                    NVA.UOM_ = QRY.UOM_,
                    NVA.SUBINVENTORY_SHORT_CODE = QRY.SUBINVENTORY_SHORT_CODE,
                    NVA.LOCATOR_ID = QRY.LOCATOR_ID,
                    NVA.LOCATOR_SHORT_NAME = QRY.LOCATOR_SHORT_NAME,
                    NVA.SOURCE_TYPE = QRY.SOURCE_TYPE,
                    NVA.TRANSACTION_TYPE = QRY.TRANSACTION_TYPE,
                    NVA.TRANSACTION_SOURCE = QRY.TRANSACTION_SOURCE,
                    NVA.TRANSACTION_TIME = QRY.TRANSACTION_TIME,
                    NVA.LPN_NO = QRY.LPN_NO,
                    NVA.SHIPMENT_NO = QRY.SHIPMENT_NO,
                    NVA.TRANSACTION_ACTION = QRY.TRANSACTION_ACTION,
                    NVA.LOCATION = QRY.LOCATION,
                    NVA.SOURCE_PROJECT_NUMBER = QRY.SOURCE_PROJECT_NUMBER,
                    NVA.SOURCE_TASK_NUMBER = QRY.SOURCE_TASK_NUMBER,
                    NVA.PROJECT_NUMBER = V_DATOS.PROJECT_NUMBER,
                    NVA.TASK_NUMBER = QRY.TASK_NUMBER,
                    NVA.TO_PROJECT_NUMBER = QRY.TO_PROJECT_NUMBER,
                    NVA.TO_TASK_NUMBER = QRY.TO_TASK_NUMBER,
                    NVA.FROM_OWNING_PARTY = QRY.FROM_OWNING_PARTY,
                    NVA.TRANSPORT_COMPANY_ID = QRY.TRANSPORT_COMPANY_ID,
                    NVA.TRANSPORT_COMPANY_NAME = QRY.TRANSPORT_COMPANY_NAME,
                    NVA.NAME_DELIVERY_PERSON = QRY.NAME_DELIVERY_PERSON,
                    NVA.PLATE_NO = QRY.PLATE_NO,
                    NVA.TRANSPORT_ATT_ID = QRY.TRANSPORT_ATT_ID,
                    NVA.MOD_BY = QRY.MOD_BY,
                    NVA.FORM_ZIP_CODE = QRY.FORM_ZIP_CODE,
                    NVA.TO_ZIP_CODE = QRY.TO_ZIP_CODE,
                    NVA.ORG_DES = QRY.ORG_DES,
                    NVA.SUBINV_DES = QRY.SUBINV_DES,
                    NVA.LOC_DES = QRY.LOC_DES,
                    NVA.MOVE_ORDER_LINE_ID = QRY.MOVE_ORDER_LINE_ID,
                    NVA.TRANSACTION_SOURCE_ID = QRY.TRANSACTION_SOURCE_ID
                    --NVA.SHIP_TO_LOCATION_ID = QRY.SHIP_TO_LOCATION_ID,
                    --NVA.OC = QRY.OC
            WHEN NOT MATCHED THEN
                INSERT (ERP_INVENTORY_ID,
                    SKU,
                    ADD_DATE,
                    MOD_DATE,
                    ORG_ID,
                    UOM_,
                    SUBINVENTORY_SHORT_CODE,
                    LOCATOR_ID,
                    LOCATOR_SHORT_NAME,
                    SOURCE_TYPE,
                    TRANSACTION_TYPE,
                    TRANSACTION_SOURCE,
                    TRANSACTION_TIME,
                    LPN_NO,
                    SHIPMENT_NO,
                    TRANSACTION_ACTION,
                    LOCATION,
                    SOURCE_PROJECT_NUMBER,
                    SOURCE_TASK_NUMBER,
                    PROJECT_NUMBER,
                    TASK_NUMBER,
                    TO_PROJECT_NUMBER,
                    TO_TASK_NUMBER,
                    FROM_OWNING_PARTY,
                    TRANSPORT_COMPANY_ID,
                    TRANSPORT_COMPANY_NAME,
                    NAME_DELIVERY_PERSON,
                    PLATE_NO,
                    TRANSPORT_ATT_ID,
                    MOD_BY,
                    FORM_ZIP_CODE,
                    TO_ZIP_CODE,
                    ORG_DES,
                    SUBINV_DES,
                    LOC_DES,
                    MOVE_ORDER_LINE_ID,
                    TRANSACTION_SOURCE_ID)
                 --   SHIP_TO_LOCATION_ID,
                 --   OC)
            VALUES (QRY.ERP_INVENTORY_ID,
                    QRY.SKU,
                    QRY.ADD_DATE,
                    QRY.MOD_DATE,
                    QRY.ORG_ID,
                    QRY.UOM_,
                    QRY.SUBINVENTORY_SHORT_CODE,
                    QRY.LOCATOR_ID,
                    QRY.LOCATOR_SHORT_NAME,
                    QRY.SOURCE_TYPE,
                    QRY.TRANSACTION_TYPE,
                    QRY.TRANSACTION_SOURCE,
                    QRY.TRANSACTION_TIME,
                    QRY.LPN_NO,
                    QRY.SHIPMENT_NO,
                    QRY.TRANSACTION_ACTION,
                    QRY.LOCATION,
                    QRY.SOURCE_PROJECT_NUMBER,
                    QRY.SOURCE_TASK_NUMBER,
                    QRY.PROJECT_NUMBER,
                    QRY.TASK_NUMBER,
                    QRY.TO_PROJECT_NUMBER,
                    QRY.TO_TASK_NUMBER,
                    QRY.FROM_OWNING_PARTY,
                    QRY.TRANSPORT_COMPANY_ID,
                    QRY.TRANSPORT_COMPANY_NAME,
                    QRY.NAME_DELIVERY_PERSON,
                    QRY.PLATE_NO,
                    QRY.TRANSPORT_ATT_ID,
                    QRY.MOD_BY,
                    QRY.FORM_ZIP_CODE,
                    QRY.TO_ZIP_CODE,
                    QRY.ORG_DES,
                    QRY.SUBINV_DES,
                    QRY.LOC_DES,
                    QRY.MOVE_ORDER_LINE_ID,
                    QRY.TRANSACTION_SOURCE_ID);
                  --  QRY.SHIP_TO_LOCATION_ID,
                  --  QRY.OC);
		END LOOP;
	END IF;	
END;



--------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER GG_ADMIN.TR_WAREHOUSE_STOCK_AVAILABILITY
  FOR insert or delete or update ON GG_ADMIN.MTL_ONHAND_QUANTITIES_DETAIL
  COMPOUND TRIGGER

  v_Contador NUMBER;

  -- Se lanzará después de cada fila actualizada
  AFTER EACH ROW IS
  BEGIN
    dbms_output.put_line('modificacion despues de cada fila');
  END AFTER EACH ROW;

  -- Se lanzará después de la sentencia
  AFTER STATEMENT IS
    CURSOR C_DATOS IS
      SELECT OH.ORGANIZATION_ID              ORG_ID,
             IL.segment1                     LOCATOR,
             MSI.segment1                    SKU_ID,
             OH.PRIMARY_TRANSACTION_QUANTITY QTY,
             OH.CREATION_DATE                ADD_DATE,
             OH.LAST_UPDATE_DATE             MOD_DATE,
             OH.SUBINVENTORY_CODE            SUBINVENTORY,
             OH.TRANSACTION_UOM_CODE         UOM,
             MSN.SERIAL_NUMBER               SERIAL_NO,
             OH.LOT_NUMBER
        FROM erp.MTL_ONHAND_QUANTITIES_DETAIL OH,
             erp.MTL_ITEM_LOCATIONS           IL,
             erp.MTL_SYSTEM_ITEMS_B           MSI,
             erp.MTL_SERIAL_NUMBERS           MSN
       WHERE oh.organization_id(+) = msi.organization_id
         AND oh.inventory_item_id(+) = msi.inventory_item_id
         AND oh.organization_id = il.organization_id(+)
         AND oh.locator_id = il.inventory_location_id(+)
         AND oh.inventory_item_id = msn.inventory_item_id(+)
         AND oh.last_update_date = msn.last_update_date(+)
         and oh.ORGANIZATION_ID = :new.ORGANIZATION_ID
         and oh.PRIMARY_TRANSACTION_QUANTITY =
             :new.PRIMARY_TRANSACTION_QUANTITY
         and oh.CREATION_DATE = :new.CREATION_DATE
         and oh.LAST_UPDATE_DATE = :new.LAST_UPDATE_DATE
         and oh.SUBINVENTORY_CODE = :new.SUBINVENTORY_CODE
         and oh.TRANSACTION_UOM_CODE = :new.TRANSACTION_UOM_CODE
         and oh.LOT_NUMBER = :new.LOT_NUMBER;
  
    P_ORGANIZATION_ID              MTL_ONHAND_QUANTITIES_DETAIL.ORGANIZATION_ID%TYPE := :OLD.ORGANIZATION_ID;
    P_PRIMARY_TRANSACTION_QUANTITY MTL_ONHAND_QUANTITIES_DETAIL.PRIMARY_TRANSACTION_QUANTITY%TYPE := :OLD.PRIMARY_TRANSACTION_QUANTITY;
    P_CREATION_DATE                MTL_ONHAND_QUANTITIES_DETAIL.CREATION_DATE%TYPE := :OLD.CREATION_DATE;
    P_LAST_UPDATE_DATE             MTL_ONHAND_QUANTITIES_DETAIL.LAST_UPDATE_DATE%TYPE := :OLD.LAST_UPDATE_DATE;
    P_SUBINVENTORY_CODE            MTL_ONHAND_QUANTITIES_DETAIL.SUBINVENTORY_CODE%TYPE := :OLD.SUBINVENTORY_CODE;
    P_TRANSACTION_UOM_CODE         MTL_ONHAND_QUANTITIES_DETAIL.TRANSACTION_UOM_CODE%TYPE := :OLD.TRANSACTION_UOM_CODE;
    P_LOT_NUMBER                   MTL_ONHAND_QUANTITIES_DETAIL.LOT_NUMBER%TYPE := :OLD.LOT_NUMBER;
  
  BEGIN
  
    if inserting then
    
      FOR I_REGISTROS IN C_DATOS LOOP
      
        INSERT INTO GG_ADMIN.WH_STOCK_AVAIL_EXC_SITE_T
          (org_id,
           locator,
           sku_id,
           qty,
           add_date,
           mod_date,
           subinventory,
           uom,
           serial_no,
           LOT_NUMBER)
        VALUES
          (I_REGISTROS.ORG_ID,
           I_REGISTROS.LOCATOR,
           I_REGISTROS.SKU_ID,
           I_REGISTROS.QTY,
           I_REGISTROS.ADD_DATE,
           I_REGISTROS.MOD_DATE,
           I_REGISTROS.SUBINVENTORY,
           I_REGISTROS.UOM,
           I_REGISTROS.SERIAL_NO,
           I_REGISTROS.LOT_NUMBER);
      END LOOP;
    
    elsif deleting then
    
      for i in c_datos loop
        DELETE FROM GG_ADMIN.WH_STOCK_AVAIL_EXC_SITE_T DEL
         WHERE del.ORG_ID = P_ORGANIZATION_ID
           and del.qty = P_PRIMARY_TRANSACTION_QUANTITY
           and del.ADD_DATE = P_CREATION_DATE
           and del.MOD_DATE = P_LAST_UPDATE_DATE
           and del.SUBINVENTORY = P_SUBINVENTORY_CODE
           and del.UOM = P_TRANSACTION_UOM_CODE
           and del.LOT_NUMBER = P_LOT_NUMBER;
      end loop;
    
    elsif updating then
    
      FOR I_REGISTROS IN C_DATOS LOOP
      
        UPDATE GG_ADMIN.WH_STOCK_AVAIL_EXC_SITE_T UPD
           SET UPD.ORG_ID       = I_REGISTROS.ORG_ID,
               UPD.LOCATOR      = I_REGISTROS.LOCATOR,
               UPD.SKU_ID       = I_REGISTROS.SKU_ID,
               UPD.qty          = I_REGISTROS.QTY,
               UPD.ADD_DATE     = I_REGISTROS.ADD_DATE,
               UPD.MOD_DATE     = I_REGISTROS.MOD_DATE,
               UPD.SUBINVENTORY = I_REGISTROS.SUBINVENTORY,
               UPD.UOM          = I_REGISTROS.UOM,
               UPD.SERIAL_NO    = I_REGISTROS.SERIAL_NO,
               UPD.LOT_NUMBER   = I_REGISTROS.LOT_NUMBER
         WHERE UPD.ORG_ID = I_REGISTROS.ORG_ID
           and UPD.qty = I_REGISTROS.QTY
           and UPD.ADD_DATE = I_REGISTROS.ADD_DATE
           and UPD.MOD_DATE = I_REGISTROS.MOD_DATE
           and UPD.SUBINVENTORY = I_REGISTROS.SUBINVENTORY
           and UPD.UOM = I_REGISTROS.UOM
           and UPD.LOT_NUMBER = I_REGISTROS.LOT_NUMBER;
      
      END LOOP;
    
    end if;
  
    DBMS_OUTPUT.PUT_LINE('modificacion despues de sentencia');
  END AFTER STATEMENT;
END TR_WAREHOUSE_STOCK_AVAILABILITY;



-------------------------------------------------------------------------------------------------------



CREATE OR REPLACE TRIGGER GG_ADMIN.TR_SITE_STOCK_AVAILABILITY_1
  FOR insert or delete or update  ON gg_admin.CSI_ITEM_INSTANCES
  COMPOUND TRIGGER

  v_Contador NUMBER;

  -- Se lanzará después de cada fila actualizada
  AFTER EACH ROW IS
  BEGIN
  
    dbms_output.put_line('modificacion despues de cada fila');
  END AFTER EACH ROW;

  -- Se lanzará después de la sentencia
  AFTER STATEMENT IS
			 
			  CURSOR C_DATOS IS SELECT DISTINCT CIIN.instance_id INSTANCE_ID,
                   CIIN.inventory_item_id INVENTORY_ID,
                   CIIN.inv_master_organization_id MASTER_ORGANIZATION_ID,
                   CIIN.serial_number SERIAL_NUMBER,
                   CIIN.lot_number FA_NUMBER,
                   CIIN.quantity QUANTITY,
                   CIIN.unit_of_measure UOM,
                   CIIN.location_type_code LOCATION_TYPE_CODE,
                   CIIN.location_id LOCATION_ID,
                   CIIN.inv_organization_id ORGANIZATION_ID,
                   CIIN.inv_subinventory_name SUBINVENTORY_NAME,
                   CIIN.INV_LOCATOR_ID LOCATOR_ID,
                   CIIN.pa_project_id PROJECT_ID,
                   CIIN.pa_project_task_id PROJECT_TASK_ID,
                   CIIN.install_date INSTALL_DATE,
                   CIIN.return_by_date RETURN_BY_DATE,
                   CIIN.actual_return_date ACTUAL_RETURN_DATE,
                   CIIN.creation_date ADD_DATE,
                   CIIN.last_update_date MOD_DATE,
                   CIIN.install_location_id INSTALL_LOCATION_ID,
                   FAAB.asset_id CAPEX,
                   FAAB.attribute_category_code ASSET_CATEGORY,
                   FAAB.asset_id ASSET_ID,
                   FAAB.ASSET_NUMBER ASSET_NUMBER,
                   FAAB.current_units CURRENT_UNITS,
                   FAAB.asset_type ASSET_TYPE,
                   FAAB.tag_number TAG_NUMBER,
                   FAAB.asset_category_id ASSET_CATEGORY_ID,
                   FAAB.serial_number SERIAL_NUMBER_FA,
                   FAAB.last_update_date LAST_UPDATE_DATE,
                   FAAB.creation_date CREATION_DATE,
                   CT.INV_MATERIAL_TRANSACTION_ID
     FROM erp.mtl_parameters MTLP,
          erp.csi_item_instances CIIN,
          gg_admin.csi_i_assets CIAS,
          gg_admin.fa_additions_b FAAB,
          (SELECT instance_id, transaction_id
             FROM gg_admin.CSI_ITEM_INSTANCES_H
            WHERE (instance_id, creation_date) IN
                     (  SELECT instance_id, MAX (creation_date)
                          FROM gg_admin.CSI_ITEM_INSTANCES_H
                      GROUP BY instance_id)) CIH,
          gg_admin.CSI_TRANSACTIONS CT
    WHERE     MTLP.attribute9 = 'INFRA'
          AND CT.TRANSACTION_ID = CIH.TRANSACTION_ID
          AND CIH.INSTANCE_ID = CIIN.INSTANCE_ID
          AND CIIN.last_vld_organization_id = MTLP.organization_id
          AND CIIN.instance_id = CIAS.instance_id(+)
          AND CIAS.fa_asset_id = FAAB.asset_id(+);
					
				
		CURSOR C_DATOS_OLD IS SELECT DISTINCT CIIN.instance_id INSTANCE_ID,
                   CIIN.inventory_item_id INVENTORY_ID,
                   CIIN.inv_master_organization_id MASTER_ORGANIZATION_ID,
                   CIIN.serial_number SERIAL_NUMBER,
                   CIIN.lot_number FA_NUMBER,
                   CIIN.quantity QUANTITY,
                   CIIN.unit_of_measure UOM,
                   CIIN.location_type_code LOCATION_TYPE_CODE,
                   CIIN.location_id LOCATION_ID,
                   CIIN.inv_organization_id ORGANIZATION_ID,
                   CIIN.inv_subinventory_name SUBINVENTORY_NAME,
                   CIIN.INV_LOCATOR_ID LOCATOR_ID,
                   CIIN.pa_project_id PROJECT_ID,
                   CIIN.pa_project_task_id PROJECT_TASK_ID,
                   CIIN.install_date INSTALL_DATE,
                   CIIN.return_by_date RETURN_BY_DATE,
                   CIIN.actual_return_date ACTUAL_RETURN_DATE,
                   CIIN.creation_date ADD_DATE,
                   CIIN.last_update_date MOD_DATE,
                   CIIN.install_location_id INSTALL_LOCATION_ID,
                   FAAB.asset_id CAPEX,
                   FAAB.attribute_category_code ASSET_CATEGORY,
                   FAAB.asset_id ASSET_ID,
                   FAAB.ASSET_NUMBER ASSET_NUMBER,
                   FAAB.current_units CURRENT_UNITS,
                   FAAB.asset_type ASSET_TYPE,
                   FAAB.tag_number TAG_NUMBER,
                   FAAB.asset_category_id ASSET_CATEGORY_ID,
                   FAAB.serial_number SERIAL_NUMBER_FA,
                   FAAB.last_update_date LAST_UPDATE_DATE,
                   FAAB.creation_date CREATION_DATE,
                   CT.INV_MATERIAL_TRANSACTION_ID
     FROM erp.mtl_parameters MTLP,
          erp.csi_item_instances CIIN,
          gg_admin.csi_i_assets CIAS,
          gg_admin.fa_additions_b FAAB,
          (SELECT instance_id, transaction_id
             FROM gg_admin.CSI_ITEM_INSTANCES_H
            WHERE (instance_id, creation_date) IN
                     (  SELECT instance_id, MAX (creation_date)
                          FROM gg_admin.CSI_ITEM_INSTANCES_H
                      GROUP BY instance_id)) CIH,
          gg_admin.CSI_TRANSACTIONS CT
    WHERE     MTLP.attribute9 = 'INFRA'
          AND CT.TRANSACTION_ID = CIH.TRANSACTION_ID
          AND CIH.INSTANCE_ID = CIIN.INSTANCE_ID
          AND CIIN.last_vld_organization_id = MTLP.organization_id
          AND CIIN.instance_id = CIAS.instance_id(+)
          AND CIAS.fa_asset_id = FAAB.asset_id(+);
       
    --registro number :=:old.numero;
		P_instance_id CSI_ITEM_INSTANCES.instance_id%TYPE := :OLD.instance_id;
    P_inventory_item_id CSI_ITEM_INSTANCES.inventory_item_id%TYPE := :OLD.inventory_item_id;
    P_inv_master_organization_id CSI_ITEM_INSTANCES.inv_master_organization_id%TYPE := :OLD.inv_master_organization_id;
    P_serial_number CSI_ITEM_INSTANCES.serial_number%TYPE := :OLD.serial_number;
    P_quantity CSI_ITEM_INSTANCES.quantity%TYPE := :OLD.quantity;
    P_unit_of_measure CSI_ITEM_INSTANCES.unit_of_measure%TYPE := :OLD.unit_of_measure;
    P_location_type_code CSI_ITEM_INSTANCES.location_type_code%TYPE := :OLD.location_type_code;
    P_location_id CSI_ITEM_INSTANCES.location_id%TYPE := :OLD.location_id;
    P_inv_organization_id CSI_ITEM_INSTANCES.inv_organization_id%TYPE := :OLD.inv_organization_id;
    P_inv_subinventory_name CSI_ITEM_INSTANCES.inv_subinventory_name%TYPE := :OLD.inv_subinventory_name;
    P_INV_LOCATOR_ID CSI_ITEM_INSTANCES.INV_LOCATOR_ID%TYPE := :OLD.INV_LOCATOR_ID;
    P_pa_project_id CSI_ITEM_INSTANCES.pa_project_id%TYPE := :OLD.pa_project_id;
    P_pa_project_task_id CSI_ITEM_INSTANCES.pa_project_task_id%TYPE := :OLD.pa_project_task_id;
    P_install_date CSI_ITEM_INSTANCES.install_date%TYPE := :OLD.install_date;
    P_return_by_date CSI_ITEM_INSTANCES.return_by_date%TYPE := :OLD.return_by_date;
    P_actual_return_date CSI_ITEM_INSTANCES.actual_return_date%TYPE := :OLD.actual_return_date;
    P_creation_date CSI_ITEM_INSTANCES.creation_date%TYPE := :OLD.creation_date;
    P_last_update_date  CSI_ITEM_INSTANCES.last_update_date%TYPE := :OLD.last_update_date;
    P_install_location_id CSI_ITEM_INSTANCES.install_location_id%TYPE := :OLD.install_location_id;
						 
  BEGIN
  
    if inserting then
			
			FOR I_REGISTROS IN C_DATOS
    LOOP

      INSERT INTO GG_ADMIN.SITE_STOCK_AVAILABILITY_T
          (
          instance_id,
          inventory_id,
          master_organization_id,
          serial_number,
          fa_number,
          quantity,
          uom,
          location_type_code,
          location_id,
          organization_id,
          subinventory_name,
          locator_id ,
          project_id ,
          project_task_id,
          install_date,
          return_by_date,
          actual_return_date,
          add_date,
          mod_date,
          install_location_id,
          capex,
          asset_category,
          asset_id,
          asset_number,
          current_units,
          asset_type,
          tag_number ,
          asset_category_id,
          serial_number_fa,
          last_update_date,
          creation_date
          )
      VALUES
          (
          I_REGISTROS.INSTANCE_ID,
          I_REGISTROS.INVENTORY_ID,
          I_REGISTROS.MASTER_ORGANIZATION_ID,
          I_REGISTROS.SERIAL_NUMBER,
          I_REGISTROS.FA_NUMBER,
          I_REGISTROS.QUANTITY,
          I_REGISTROS.UOM,
          I_REGISTROS.LOCATION_TYPE_CODE,
          I_REGISTROS.LOCATION_ID,
          I_REGISTROS.ORGANIZATION_ID,
          I_REGISTROS.SUBINVENTORY_NAME,
          I_REGISTROS.LOCATOR_ID,
          I_REGISTROS.PROJECT_ID,
          I_REGISTROS.PROJECT_TASK_ID,
          I_REGISTROS.INSTALL_DATE,
          I_REGISTROS.RETURN_BY_DATE,
          I_REGISTROS.ACTUAL_RETURN_DATE,
          I_REGISTROS.ADD_DATE,
          I_REGISTROS.MOD_DATE,
          I_REGISTROS.INSTALL_LOCATION_ID,
          I_REGISTROS.CAPEX,
          I_REGISTROS.ASSET_CATEGORY,
          I_REGISTROS.ASSET_ID,
          I_REGISTROS.ASSET_NUMBER,
          I_REGISTROS.CURRENT_UNITS,
          I_REGISTROS.ASSET_TYPE,
          I_REGISTROS.TAG_NUMBER,
          I_REGISTROS.ASSET_CATEGORY_ID,
          I_REGISTROS.SERIAL_NUMBER_FA,
          I_REGISTROS.LAST_UPDATE_DATE,
          I_REGISTROS.CREATION_DATE
          );

    END LOOP;
    
    elsif deleting then
    
    For i in c_datos loop

			DELETE FROM GG_ADMIN.SITE_STOCK_AVAILABILITY_T DEL
    WHERE DEL.instance_id = P_instance_id
             AND DEL.inventory_id  = P_inventory_item_id
             AND DEL.master_organization_id = P_inv_master_organization_id
             AND DEL.serial_number  = P_serial_number
             AND DEL.quantity = P_quantity
             AND DEL.uom  =  P_unit_of_measure
             AND DEL.location_type_code = P_location_type_code
             AND DEL.location_id = P_location_id
             AND DEL.organization_id = P_inv_organization_id
             AND DEL.subinventory_name = P_inv_subinventory_name
             AND DEL.LOCATOR_ID  = P_INV_LOCATOR_ID
             AND DEL.project_id = P_pa_project_id
             AND DEL.project_task_id = P_pa_project_task_id
             AND DEL.install_date = P_install_date
             AND DEL.return_by_date  =  P_return_by_date
             AND DEL.actual_return_date =  P_actual_return_date
             AND DEL.creation_date = P_creation_date
             AND DEL.last_update_date =  P_Last_update_date
             AND DEL.install_location_id =  P_install_location_id;
    end loop;
		
		
    elsif updating then
	
			FOR I_REGISTROS IN C_DATOS_OLD
    LOOP

    UPDATE GG_ADMIN.SITE_STOCK_AVAILABILITY_T UPD
    SET         UPD.instance_id  = I_REGISTROS.INSTANCE_ID,
                UPD.inventory_id  = I_REGISTROS.INVENTORY_ID,
                UPD.master_organization_id  = I_REGISTROS.MASTER_ORGANIZATION_ID,
                UPD.SERIAL_NUMBER_FA  = I_REGISTROS.SERIAL_NUMBER_FA,
                UPD.FA_NUMBER  = I_REGISTROS.FA_NUMBER,
                UPD.quantity  = I_REGISTROS.QUANTITY,
                UPD.UOM  = I_REGISTROS.UOM,
                UPD.location_type_code  = I_REGISTROS.LOCATION_TYPE_CODE,
                UPD.location_id  = I_REGISTROS.LOCATION_ID,
                UPD.organization_id  = I_REGISTROS.ORGANIZATION_ID,
                UPD.subinventory_name  = I_REGISTROS.SUBINVENTORY_NAME,
                UPD.LOCATOR_ID  = I_REGISTROS.LOCATOR_ID,
                UPD.project_id  = I_REGISTROS.PROJECT_ID,
                UPD.project_task_id  = I_REGISTROS.PROJECT_TASK_ID,
                UPD.install_date  = I_REGISTROS.INSTALL_DATE,
                UPD.return_by_date  = I_REGISTROS.RETURN_BY_DATE,
                UPD.actual_return_date  = I_REGISTROS.ACTUAL_RETURN_DATE,
                UPD.ADD_DATE = I_REGISTROS.ADD_DATE,
                UPD.MOD_DATE = I_REGISTROS.MOD_DATE,
                UPD.install_location_id  = I_REGISTROS.INSTALL_LOCATION_ID,
                UPD.CAPEX = I_REGISTROS.CAPEX,
                UPD.ASSET_CATEGORY = I_REGISTROS.ASSET_CATEGORY,
                UPD.ASSET_ID = I_REGISTROS.ASSET_ID,
                UPD.ASSET_NUMBER = I_REGISTROS.ASSET_NUMBER,
                UPD.CURRENT_UNITS = I_REGISTROS.CURRENT_UNITS,
                UPD.ASSET_TYPE = I_REGISTROS.ASSET_TYPE,
                UPD.TAG_NUMBER = I_REGISTROS.TAG_NUMBER,
                UPD.ASSET_CATEGORY_ID = I_REGISTROS.ASSET_CATEGORY_ID,
                UPD.SERIAL_NUMBER_FA = I_REGISTROS.SERIAL_NUMBER_FA,
                UPD.creation_date  = I_REGISTROS.CREATION_DATE,
                UPD.last_update_date  = I_REGISTROS.LAST_UPDATE_DATE
		       WHERE UPD.instance_id = I_REGISTROS.instance_id
             AND UPD.inventory_id  = I_REGISTROS.inventory_id
             AND UPD.master_organization_id = I_REGISTROS.master_organization_id
             AND UPD.serial_number  = I_REGISTROS.serial_number
             AND UPD.quantity = I_REGISTROS.quantity
             AND UPD.uom =  I_REGISTROS.UOM
             AND UPD.location_type_code = I_REGISTROS.location_type_code
             AND UPD.location_id = I_REGISTROS.location_id
             AND UPD.organization_id = I_REGISTROS.organization_id
             AND UPD.subinventory_name = I_REGISTROS.subinventory_name
             AND UPD.LOCATOR_ID  = I_REGISTROS.LOCATOR_ID
             AND UPD.project_id =  I_REGISTROS.project_id
             AND UPD.project_task_id = I_REGISTROS.project_task_id
             AND UPD.install_date = I_REGISTROS.install_date
             AND UPD.return_by_date  =  I_REGISTROS.return_by_date
             AND UPD.actual_return_date =  I_REGISTROS.actual_return_date
             AND UPD.creation_date = I_REGISTROS.creation_date
             AND UPD.last_update_date =  I_REGISTROS.last_update_date
             AND UPD.install_location_id =  I_REGISTROS.install_location_id;
       END LOOP;
    
    end if;
  
    DBMS_OUTPUT.PUT_LINE('modificacion despues de sentencia');
  END AFTER STATEMENT;
END TR_SITE_STOCK_AVAILABILITY_1;



--------------------------------------------------------------------------------------------------------------




CREATE OR REPLACE TRIGGER GG_ADMIN.TR_SITE_STOCK_AVAILABILITY_2
  FOR insert or delete or update  ON gg_admin.FA_ADDITIONS_B
  COMPOUND TRIGGER

  v_Contador NUMBER;

  -- Se lanzará después de cada fila actualizada
  AFTER EACH ROW IS
  BEGIN
  
    dbms_output.put_line('modificacion despues de cada fila');
  END AFTER EACH ROW;

  -- Se lanzará después de la sentencia
  AFTER STATEMENT IS
			
			CURSOR C_DATOS IS SELECT DISTINCT CIIN.instance_id INSTANCE_ID,
                   CIIN.inventory_item_id INVENTORY_ID,
                   CIIN.inv_master_organization_id MASTER_ORGANIZATION_ID,
                   CIIN.serial_number SERIAL_NUMBER,
                   CIIN.lot_number FA_NUMBER,
                   CIIN.quantity QUANTITY,
                   CIIN.unit_of_measure UOM,
                   CIIN.location_type_code LOCATION_TYPE_CODE,
                   CIIN.location_id LOCATION_ID,
                   CIIN.inv_organization_id ORGANIZATION_ID,
                   CIIN.inv_subinventory_name SUBINVENTORY_NAME,
                   CIIN.INV_LOCATOR_ID LOCATOR_ID,
                   CIIN.pa_project_id PROJECT_ID,
                   CIIN.pa_project_task_id PROJECT_TASK_ID,
                   CIIN.install_date INSTALL_DATE,
                   CIIN.return_by_date RETURN_BY_DATE,
                   CIIN.actual_return_date ACTUAL_RETURN_DATE,
                   CIIN.creation_date ADD_DATE,
                   CIIN.last_update_date MOD_DATE,
                   CIIN.install_location_id INSTALL_LOCATION_ID,
                   FAAB.asset_id CAPEX,
                   FAAB.attribute_category_code ASSET_CATEGORY,
                   FAAB.asset_id ASSET_ID,
                   FAAB.ASSET_NUMBER ASSET_NUMBER,
                   FAAB.current_units CURRENT_UNITS,
                   FAAB.asset_type ASSET_TYPE,
                   FAAB.tag_number TAG_NUMBER,
                   FAAB.asset_category_id ASSET_CATEGORY_ID,
                   FAAB.serial_number SERIAL_NUMBER_FA,
                   FAAB.last_update_date LAST_UPDATE_DATE,
                   FAAB.creation_date CREATION_DATE,
                   CT.INV_MATERIAL_TRANSACTION_ID
     FROM erp.mtl_parameters MTLP,
          erp.csi_item_instances CIIN,
          gg_admin.csi_i_assets CIAS,
          gg_admin.fa_additions_b FAAB,
          (SELECT instance_id, transaction_id
             FROM gg_admin.CSI_ITEM_INSTANCES_H
            WHERE (instance_id, creation_date) IN
                     (  SELECT instance_id, MAX (creation_date)
                          FROM gg_admin.CSI_ITEM_INSTANCES_H
                      GROUP BY instance_id)) CIH,
          gg_admin.CSI_TRANSACTIONS CT
    WHERE     MTLP.attribute9 = 'INFRA'
          AND CT.TRANSACTION_ID = CIH.TRANSACTION_ID
          AND CIH.INSTANCE_ID = CIIN.INSTANCE_ID
          AND CIIN.last_vld_organization_id = MTLP.organization_id
          AND CIIN.instance_id = CIAS.instance_id(+)
          AND CIAS.fa_asset_id = FAAB.asset_id(+);
       
		
					CURSOR C_DATOS_OLD IS SELECT DISTINCT CIIN.instance_id INSTANCE_ID,
                   CIIN.inventory_item_id INVENTORY_ID,
                   CIIN.inv_master_organization_id MASTER_ORGANIZATION_ID,
                   CIIN.serial_number SERIAL_NUMBER,
                   CIIN.lot_number FA_NUMBER,
                   CIIN.quantity QUANTITY,
                   CIIN.unit_of_measure UOM,
                   CIIN.location_type_code LOCATION_TYPE_CODE,
                   CIIN.location_id LOCATION_ID,
                   CIIN.inv_organization_id ORGANIZATION_ID,
                   CIIN.inv_subinventory_name SUBINVENTORY_NAME,
                   CIIN.INV_LOCATOR_ID LOCATOR_ID,
                   CIIN.pa_project_id PROJECT_ID,
                   CIIN.pa_project_task_id PROJECT_TASK_ID,
                   CIIN.install_date INSTALL_DATE,
                   CIIN.return_by_date RETURN_BY_DATE,
                   CIIN.actual_return_date ACTUAL_RETURN_DATE,
                   CIIN.creation_date ADD_DATE,
                   CIIN.last_update_date MOD_DATE,
                   CIIN.install_location_id INSTALL_LOCATION_ID,
                   FAAB.asset_id CAPEX,
                   FAAB.attribute_category_code ASSET_CATEGORY,
                   FAAB.asset_id ASSET_ID,
                   FAAB.ASSET_NUMBER ASSET_NUMBER,
                   FAAB.current_units CURRENT_UNITS,
                   FAAB.asset_type ASSET_TYPE,
                   FAAB.tag_number TAG_NUMBER,
                   FAAB.asset_category_id ASSET_CATEGORY_ID,
                   FAAB.serial_number SERIAL_NUMBER_FA,
                   FAAB.last_update_date LAST_UPDATE_DATE,
                   FAAB.creation_date CREATION_DATE,
                   CT.INV_MATERIAL_TRANSACTION_ID
     FROM erp.mtl_parameters MTLP,
          erp.csi_item_instances CIIN,
          gg_admin.csi_i_assets CIAS,
          gg_admin.fa_additions_b FAAB,
          (SELECT instance_id, transaction_id
             FROM gg_admin.CSI_ITEM_INSTANCES_H
            WHERE (instance_id, creation_date) IN
                     (  SELECT instance_id, MAX (creation_date)
                          FROM gg_admin.CSI_ITEM_INSTANCES_H
                      GROUP BY instance_id)) CIH,
          gg_admin.CSI_TRANSACTIONS CT
    WHERE     MTLP.attribute9 = 'INFRA'
          AND CT.TRANSACTION_ID = CIH.TRANSACTION_ID
          AND CIH.INSTANCE_ID = CIIN.INSTANCE_ID
          AND CIIN.last_vld_organization_id = MTLP.organization_id
          AND CIIN.instance_id = CIAS.instance_id(+)
          AND CIAS.fa_asset_id = FAAB.asset_id(+);

		
		P_asset_id FA_ADDITIONS_B.asset_id%TYPE := :OLD.asset_id;
    P_attribute_category_code FA_ADDITIONS_B.attribute_category_code%TYPE := :OLD.attribute_category_code;
    P_ASSET_NUMBER FA_ADDITIONS_B.ASSET_NUMBER%TYPE := :OLD.ASSET_NUMBER;
    P_current_units FA_ADDITIONS_B.current_units%TYPE := :OLD.current_units;
    P_asset_type FA_ADDITIONS_B.asset_type%TYPE := :OLD.asset_type;
    P_tag_number FA_ADDITIONS_B.tag_number%TYPE := :OLD.tag_number;
    P_asset_category_id FA_ADDITIONS_B.asset_category_id%TYPE := :OLD.asset_category_id;
    P_serial_number FA_ADDITIONS_B.serial_number%TYPE := :OLD.serial_number;
    P_last_update_date FA_ADDITIONS_B.last_update_date%TYPE := :OLD.last_update_date;
    P_creation_date FA_ADDITIONS_B.creation_date%TYPE := :OLD.creation_date;
				 
				 
  BEGIN
  
    if inserting then

    FOR I_REGISTROS IN C_DATOS
    LOOP

          INSERT INTO GG_ADMIN.SITE_STOCK_AVAILABILITY_T
          (
          instance_id,
          inventory_id,
          master_organization_id,
          serial_number,
          fa_number,
          quantity,
          uom,
          location_type_code,
          location_id,
          organization_id,
          subinventory_name,
          locator_id ,
          project_id ,
          project_task_id,
          install_date,
          return_by_date,
          actual_return_date,
          add_date,
          mod_date,
          install_location_id,
          capex,
          asset_category,
          asset_id,
          asset_number,
          current_units,
          asset_type,
          tag_number ,
          asset_category_id,
          serial_number_fa,
          last_update_date,
          creation_date
          )
      VALUES
          (
          I_REGISTROS.INSTANCE_ID,
          I_REGISTROS.INVENTORY_ID,
          I_REGISTROS.MASTER_ORGANIZATION_ID,
          I_REGISTROS.SERIAL_NUMBER,
          I_REGISTROS.FA_NUMBER,
          I_REGISTROS.QUANTITY,
          I_REGISTROS.UOM,
          I_REGISTROS.LOCATION_TYPE_CODE,
          I_REGISTROS.LOCATION_ID,
          I_REGISTROS.ORGANIZATION_ID,
          I_REGISTROS.SUBINVENTORY_NAME,
          I_REGISTROS.LOCATOR_ID,
          I_REGISTROS.PROJECT_ID,
          I_REGISTROS.PROJECT_TASK_ID,
          I_REGISTROS.INSTALL_DATE,
          I_REGISTROS.RETURN_BY_DATE,
          I_REGISTROS.ACTUAL_RETURN_DATE,
          I_REGISTROS.ADD_DATE,
          I_REGISTROS.MOD_DATE,
          I_REGISTROS.INSTALL_LOCATION_ID,
          I_REGISTROS.CAPEX,
          I_REGISTROS.ASSET_CATEGORY,
          I_REGISTROS.ASSET_ID,
          I_REGISTROS.ASSET_NUMBER,
          I_REGISTROS.CURRENT_UNITS,
          I_REGISTROS.ASSET_TYPE,
          I_REGISTROS.TAG_NUMBER,
          I_REGISTROS.ASSET_CATEGORY_ID,
          I_REGISTROS.SERIAL_NUMBER_FA,
          I_REGISTROS.LAST_UPDATE_DATE,
          I_REGISTROS.CREATION_DATE
          );

    END LOOP;

    
    elsif deleting then
    
      for i in c_datos loop

      DELETE FROM GG_ADMIN.SITE_STOCK_AVAILABILITY_T DEL
    WHERE DEL.asset_id = P_asset_id
         AND DEL.asset_category  = P_attribute_category_code
         AND DEL.ASSET_NUMBER = P_ASSET_NUMBER
         AND DEL.current_units  = P_current_units
         AND DEL.asset_type = P_asset_type
         AND DEL.tag_number  = P_tag_number
         AND DEL.asset_category_id  = P_asset_category_id
         AND DEL.serial_number = P_serial_number
         AND DEL.last_update_date  = P_last_update_date
         AND DEL.creation_date = P_creation_date ;
				 
				  end loop;
    
    elsif updating then
    
			
			FOR I_REGISTROS IN C_DATOS_OLD
    LOOP

    UPDATE GG_ADMIN.SITE_STOCK_AVAILABILITY_T UPD
    SET         UPD.instance_id  = I_REGISTROS.INSTANCE_ID,
                UPD.inventory_id  = I_REGISTROS.INVENTORY_ID,
                UPD.master_organization_id  = I_REGISTROS.MASTER_ORGANIZATION_ID,
                UPD.SERIAL_NUMBER_FA  = I_REGISTROS.SERIAL_NUMBER_FA,
                UPD.FA_NUMBER  = I_REGISTROS.FA_NUMBER,
                UPD.quantity  = I_REGISTROS.QUANTITY,
                UPD.UOM  = I_REGISTROS.UOM,
                UPD.location_type_code  = I_REGISTROS.LOCATION_TYPE_CODE,
                UPD.location_id  = I_REGISTROS.LOCATION_ID,
                UPD.organization_id  = I_REGISTROS.ORGANIZATION_ID,
                UPD.subinventory_name  = I_REGISTROS.SUBINVENTORY_NAME,
                UPD.LOCATOR_ID  = I_REGISTROS.LOCATOR_ID,
                UPD.project_id  = I_REGISTROS.PROJECT_ID,
                UPD.project_task_id  = I_REGISTROS.PROJECT_TASK_ID,
                UPD.install_date  = I_REGISTROS.INSTALL_DATE,
                UPD.return_by_date  = I_REGISTROS.RETURN_BY_DATE,
                UPD.actual_return_date  = I_REGISTROS.ACTUAL_RETURN_DATE,
                UPD.ADD_DATE = I_REGISTROS.ADD_DATE,
                UPD.MOD_DATE = I_REGISTROS.MOD_DATE,
                UPD.install_location_id  = I_REGISTROS.INSTALL_LOCATION_ID,
                UPD.CAPEX = I_REGISTROS.CAPEX,
                UPD.ASSET_CATEGORY = I_REGISTROS.ASSET_CATEGORY,
                UPD.ASSET_ID = I_REGISTROS.ASSET_ID,
                UPD.ASSET_NUMBER = I_REGISTROS.ASSET_NUMBER,
                UPD.CURRENT_UNITS = I_REGISTROS.CURRENT_UNITS,
                UPD.ASSET_TYPE = I_REGISTROS.ASSET_TYPE,
                UPD.TAG_NUMBER = I_REGISTROS.TAG_NUMBER,
                UPD.ASSET_CATEGORY_ID = I_REGISTROS.ASSET_CATEGORY_ID,
                UPD.SERIAL_NUMBER_FA = I_REGISTROS.SERIAL_NUMBER_FA,
                UPD.creation_date  = I_REGISTROS.CREATION_DATE,
                UPD.last_update_date  = I_REGISTROS.LAST_UPDATE_DATE
    WHERE UPD.asset_id = I_REGISTROS.asset_id
         AND UPD.asset_category  = I_REGISTROS.asset_category
         AND UPD.ASSET_NUMBER = I_REGISTROS.ASSET_NUMBER
         AND UPD.current_units  = I_REGISTROS.current_units
         AND UPD.asset_type = I_REGISTROS.asset_type
         AND UPD.tag_number  = I_REGISTROS.tag_number
         AND UPD.asset_category_id  = I_REGISTROS.asset_category_id
         AND UPD.serial_number = I_REGISTROS.serial_number
         AND UPD.last_update_date  = I_REGISTROS.last_update_date
         AND UPD.creation_date = I_REGISTROS.creation_date ;
  END LOOP;
    
    end if;
  
    DBMS_OUTPUT.PUT_LINE('modificacion despues de sentencia');
  END AFTER STATEMENT;
END TR_SITE_STOCK_AVAILABILITY_2;
