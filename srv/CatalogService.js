const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService {
  init() {

    const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseOrderItemSet } = cds.entities('CatalogService')

    //NON-INSTANCE BOUND FUNCTION

    this.on('getMostExpensiveOrders', async(req) => {

      //GET THE tx API
      const zkas = req.data.zkas;
      const tx = cds.tx(req);
      //CDS QL to get the most expensive orders
      const response = await tx.read(PurchaseOrderSet).orderBy({
        GROSS_AMOUNT : 'desc'
      }).limit(zkas);
      return response;
        });

        //Implement
        //Set the field Overall status and Lifecycle status as N and Pending
        this.on('getDefualtOrderData', async(req) =>{

          return {
            OVERALL_STATUS : 'P',
            LIFECYCLE_STATUS : 'N'          }

        });

    this.on('boost', async (req) => {

      try {
        //Extract the primary key
        let primaryKey = req.params[0];

        console.log("Aaya Kya", JSON.stringify(primaryKey));

        //CDS QUERY LANGUAGE
        //GET THE CDS TRANSACTION API OBJECT
        const tx = cds.tx(req);
        //CDS QL to change the data in database

        await tx.update(PurchaseOrderSet).with({
          GROSS_AMOUNT: { '+=': 20000 },
          NOTE: 'boosted!!!'
        }).where(primaryKey);

        //Query data which is  now updated in DB
        return await tx.read(PurchaseOrderSet).where(primaryKey);
      }
      catch (error) {
        return new Error(error);
      }
    });

    this.before(['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
      //console.log('Before CREATE/UPDATE EmployeeSet', req.data)
      if(req.data.salaryAmount > 1000000){
        req.error(500,'Salary amount should not be greater than 1 million')
      }
    })
    this.after('READ', EmployeeSet, async (employeeSet, req) => {
      console.log('After READ EmployeeSet', employeeSet)
    })
    this.before(['CREATE', 'UPDATE'], ProductSet, async (req) => {
      console.log('Before CREATE/UPDATE ProductSet', req.data)
    })
    this.after('READ', ProductSet, async (productSet, req) => {
      console.log('After READ ProductSet', productSet)
    })
    this.before(['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
      console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
    })
    this.after('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
      console.log('After READ BusinessPartnerSet', businessPartnerSet)
    })
    this.before(['CREATE', 'UPDATE'], AddressSet, async (req) => {
      console.log('Before CREATE/UPDATE AddressSet', req.data)
    })
    this.after('READ', AddressSet, async (addressSet, req) => {
      console.log('After READ AddressSet', addressSet)
    })
    this.before(['CREATE'], PurchaseOrderSet, async (req) => {
      console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
      if(!req.data.PO_ID){
        req.error(500,'PO_ID is mandatory');
      }
    })
    this.after('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
      //console.log('After READ PurchaseOrderSet', purchaseOrderSet)
      for (let index = 0; index < purchaseOrderSet.length; index++) {
        const element = purchaseOrderSet[index];
        if(!element.NOTE){
          element.NOTE = "Not found"
        }
        
      }

    })
    this.before(['CREATE', 'UPDATE'], PurchaseOrderItemSet, async (req) => {
      console.log('Before CREATE/UPDATE PurchaseOrderItemSet', req.data)
    })
    this.after('READ', PurchaseOrderItemSet, async (purchaseOrderItemSet, req) => {
      console.log('After READ PurchaseOrderItemSet', purchaseOrderItemSet)
    })


    return super.init()
  }
}
