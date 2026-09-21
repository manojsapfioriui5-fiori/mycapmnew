using {
    manoj.db.master,
    manoj.db.transaction
} from '../db/data-model';
using {manoj.myviews} from '../db/CDSView';

service CatalogService @(path: 'CatalogService', requires: 'authenticated-user') {
    //Entity which offer GET,PUT,POST and Delete
    // @readonly
    // @Capabilities : { Updatable:false }
    entity EmployeeSet @(restrict :[
        { grant :['READ'], to : 'Display', where: 'bankName = $user.BankName'},
        { grant :['WRITE'], to : 'Edit' }
    ])
            as projection on master.employees;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet @(restrict: [
        {grant: ['READ'], to : 'Display', where: 'COUNTRY = $user.Country'}
    ])         as projection on master.address;
    //Expose the CDS entity
    entity ProductSet         as projection on myviews.CDSViews.ProductView;
    //Expose the CDS Entity
    entity ItemsSet           as projection on myviews.CDSViews.ItemView;
    // @odata.draft.enabled: true
    entity POs                as projection on transaction.purchaseorder{
            *,
            case
                OVERALL_STATUS
                when 'A'
                     then 'Approved'
                when 'D'
                     then 'Delivered'
                when 'R'
                     then 'Rejected'
                when 'P'
                     then 'Pending'
                else 'New'
            end as OverallStatusText : String(10),
            case
                OVERALL_STATUS
                when 'A'
                     then 3
                when 'D'
                     then 3
                when 'R'
                     then 1
                when 'P'
                     then 2
                else 2
            end as IconColor         : Integer
        }
        
        actions {
            @Common.SideEffects: {TargetProperties: ['GROSS_AMOUNT']}
            action boost() returns POs;
        };

    @cds.redirection.target
    entity POItems            as projection on transaction.poitems;

    //non instance bound function
    function getMostExpensiveOrder() returns POs;
    function getDummy(email: String(40)) returns String;
}
