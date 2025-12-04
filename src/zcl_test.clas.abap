CLASS zcl_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC . "test

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES tcs_reported_early TYPE RESPONSE FOR REPORTED EARLY I_SalesOrderTP.
    TYPES tcs_reported_late  TYPE RESPONSE FOR REPORTED LATE I_SalesOrderTP.

    "! This method concatenates the messages found in the reported structure for the entities.
    METHODS concatenate_reported_message
      IMPORTING it_reported TYPE ANY TABLE
      CHANGING  cv_message  TYPE string.

    "! This method concatenates and returns the result from the "CONCATENATE_REPORTED_MESSAGE" method for the entities.
    METHODS concatenate_message
      IMPORTING is_reported_early TYPE tcs_reported_early OPTIONAL
                is_reported_late  TYPE tcs_reported_late  OPTIONAL
      CHANGING  cv_message        TYPE string.  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
**********************************************************************
* Get XML from CDS
**********************************************************************
    DATA: lo_excep   TYPE REF TO cx_root,
          lv_message TYPE string.

    TRY.

        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZI_FORM' ).
      CATCH cx_fp_fdp_error INTO  lo_excep.
        "handle exception
        IF lo_excep IS NOT INITIAL.
          CALL METHOD lo_excep->if_message~get_text
            RECEIVING
              result = lv_message.
        ENDIF.
    ENDTRY.

*   Get initial select keys for service
    DATA(lt_keys)     = lo_fdp_util->get_keys( ).

    lt_keys[ name = 'BILLING' ]-value = '0090000006'.

    TRY.
*        DATA(lv_data) = lo_fdp_util->read_to_data( lt_keys ).
*
*        DATA(lv_xml2) = lo_fdp_util->read_to_xml_v2( lt_keys ).
*
        DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).


      CATCH cx_fp_fdp_error INTO  lo_excep.
        IF lo_excep IS NOT INITIAL.
          CALL METHOD lo_excep->if_message~get_text
            RECEIVING
              result = lv_message.

        ENDIF.
    ENDTRY.


    DATA(lv_xml_data) = cl_abap_conv_codepage=>create_in( )->convert( lv_xml ).

**********************************************************************
* Get XML from CDS
**********************************************************************

    data(lo_reader) = cl_fp_form_reader=>create_form_reader( 'ZFORM_TEST' ).
    TRY.
    data(ls_options) = VALUE cl_fp_ads_util=>ty_gs_options_pdf( ).
*Render PDF
    cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data      = lv_xml
                                          iv_xdp_layout    = lo_reader->get_layout( )
                                          iv_locale        = 'en_GB'
                                          is_options       = ls_options
                                IMPORTING ev_pdf           = data(lv_pdf)
                                          ev_pages         = Data(lv_pages)
                                          ev_trace_string  = data(lv_trace)
                                          ).


    SELECT * FROM zsd_so_file into TABLE @data(lt_so_file).
    LOOP AT lt_so_file INTO DATA(ls_so_file).
        ls_so_file-attachment = lv_pdf.
        ls_so_file-mimetype = 'application/pdf'.
        MODIFY zsd_so_file FROM @ls_so_file.
    ENDLOOP.
  CATCH cx_fp_ads_util INTO data(lx_fp_ads) .

          CALL METHOD lx_fp_ads->if_message~get_text
            RECEIVING
              result = lv_message.

              data(lv_longtext) = lx_fp_ads->get_longtext(  ).
ENDTRY.
  ENDMETHOD.

  METHOD concatenate_message.

  ENDMETHOD.


  METHOD concatenate_reported_message.
  ENDMETHOD.

ENDCLASS.
