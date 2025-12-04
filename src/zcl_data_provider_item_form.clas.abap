CLASS zcl_data_provider_item_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_data_provider_item_form IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
*    If no data is needed
    IF NOT io_request->is_data_requested( ).
      RETURN.
    ENDIF.
    "Get the filters
    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    "If no filter exists
    IF NOT line_exists( lt_range[ name = 'BILLING' ] ).
      RETURN.
    ENDIF.

    DATA lt_ret_data TYPE TABLE OF zi_item_form.
    LOOP AT lt_range ASSIGNING FIELD-SYMBOL(<lfs_range>).

      SELECT * FROM I_BillingDocumentItem
       WHERE BillingDocument IN @<lfs_range>-range
        INTO TABLE @DATA(lt_I_BillingDocument).

      LOOP AT lt_I_BillingDocument INTO DATA(ls_I_BillingDocument).

        INSERT VALUE zi_item_form(
          billing = ls_I_BillingDocument-BillingDocument
          billing_item    = ls_I_BillingDocument-BillingDocumentItem
          material = ls_I_BillingDocument-Material

      ) INTO TABLE lt_ret_data.
      ENDLOOP.

    ENDLOOP.

    io_response->set_data( lt_ret_data ).
    io_response->set_total_number_of_records( lines( lt_ret_data ) ).
  ENDMETHOD.
ENDCLASS.
