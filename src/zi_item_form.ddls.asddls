@EndUserText.label: 'Item Form'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_DATA_PROVIDER_ITEM_FORM'
define custom entity ZI_ITEM_FORM
{
  key billing : abap.numc(10);
  key billing_item : abap.numc(6);
  material  : matnr;
}
