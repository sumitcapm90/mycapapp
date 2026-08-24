using {anubhav.db.master, anubhav.db.transaction} from '../db/datamodel';

service CatalogService @(path: 'CatalogService',
                                requires : 'authenticated-user'){
//     @readonly
//    //Update resctriction
//    @(restrict: ['UPDATE'])


    entity EmployeeSet @(restrict: 
                                    [
                                        {
                                        grant: ['READ'],
                                        to: 'Display',
                                        where: 'bankName = $user.spiderman'
                                        },

                                        {
                                        grant: ['WRITE','DELETE'],
                                        to: 'Edit'
                                        }
                                        
                                    ]
                                    
                        )
    
    
     as projection on master.employees;
    entity ProductSet as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    entity StatusCodeSet as projection on master.StatusCode;
    entity PurchaseOrderSet
        @(odata.draft.enabled: true,
          odata.draft.bypass: true,
          Common.DefaultValuesFunction : 'getDefualtOrderData')
     as projection on transaction.purchaseorder{
        *,
       case 
            when OVERALL.STATUS ='A' then cast(3 as Integer)
            when OVERALL.STATUS ='D' then cast(3 as Integer)
            when OVERALL.STATUS ='X' then cast(1 as Integer)
            when OVERALL.STATUS ='P' then cast(2 as Integer)
            when OVERALL.STATUS ='N' then cast(2 as Integer)
            else cast(0 as Integer)

            end as VirtualStatusField: Integer
    }
    
        actions{
            //The annotation side effect will inform fiori that there is a change in backend data for
            //Gross amount, hence once the boost action is triggered , kindly load the Gross_amount from backend
            @Common : { SideEffects : {
                    $Type : 'Common.SideEffectsType',
                    TargetProperties : ['in/GROSS_AMOUNT']
            }}

                action boost() 
                returns PurchaseOrderSet;
        };
        //INSTANCE BOUND ACTION, when we can this action , as a caller  we must pass PK
        //We will receive the PK as a input automatically
        // actions{
        //     action boost() returns PurchaseOrderSet;
        // };
    entity PurchaseOrderItemSet
        @(odata.draft.enabled:true)
     as projection on transaction.poitems;
    //Define
    function getDefualtOrderData() returns PurchaseOrderSet;

    //Define
    //non-instance bound function - get top 3 expensive pos.
    function getMostExpensiveOrders(zkas : Integer) returns many PurchaseOrderSet;
}