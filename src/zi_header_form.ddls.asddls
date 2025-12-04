@EndUserText.label: 'Header Form'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_DATA_PROVIDER_FORM'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER  ]
define custom entity ZI_HEADER_FORM
{
  key billing : abap.numc(10);
  
    
    _items: association [0..*] to ZI_ITEM_FORM on _items.billing = $projection.billing;
}
