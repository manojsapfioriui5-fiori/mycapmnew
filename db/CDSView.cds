using {
    manoj.db.master,
    manoj.db.transaction
} from './data-model';

namespace manoj.myviews;

context CDSViews {

    define view ![POWorklist] as
        select from transaction.purchaseorder {
            key PO_ID                             as ![PurchaseOrderId],
            key Items.PO_ITEM_POS                 as ![ItemPosition],
                PARTNER_GUID.BP_ID                as ![PartnerId],
                PARTNER_GUID.COMPANY_NAME         as ![CompanyName],
                Items.GROSS_AMOUNT                as ![GrossAmount],
                Items.NET_AMOUNT                  as ![NetAmount],
                Items.TAX_AMOUNT                  as ![TaxAmount],
                Items.CURRENCY                    as ![CurrencyCode],
                OVERALL_STATUS                    as ![Status],
                Items.PRODUCT_GUID.CATEGORY       as ![Category],
                Items.PRODUCT_GUID.DESCRIPTION    as ![ProductName],
                PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
                PARTNER_GUID.ADDRESS_GUID.CITY    as ![City]
        };

    define view ![ProductHelpView] as
        select from master.product {
            @EndUserText.Label: [
                {
                    language: 'EN',
                    text    : 'Product ID'
                },
                {
                    language: 'DE',
                    text    : 'Produkt ID'
                }
            ]
            PRODUCT_ID                 as ![ProductId],
            @EndUserText.Label: [
                {
                    language: 'EN',
                    text    : 'Description'
                },
                {
                    language: 'DE',
                    text    : 'Beschreibung'
                }
            ]
            DESCRIPTION                as ![Description],
            CATEGORY                   as ![Category],
            PRICE                      as ![Price],
            CURRENCY_CODE              as ![CurrencyCode],
            SUPPLIER_GUID.COMPANY_NAME as ![SupplierName]
        };

    define view ![ItemView] as
        select from transaction.poitems {
            key PRODUCT_GUID.NODE_KEY            as ![ProductKey], // we need product key in item view to link it with product view
            key PARENT_KEY.PARTNER_GUID.NODE_KEY as ![SupplierId],
                GROSS_AMOUNT                     as ![GrossAmount],
                NET_AMOUNT                       as ![NetAmount],
                TAX_AMOUNT                       as ![TaxAmount],
                CURRENCY                         as ![CurrencyCode],
                PARENT_KEY.OVERALL_STATUS        as ![Status]
        };

    //view on view along with lazy loading
    define view ![ProductView] as
        select from master.product
        // we want to load product details only when user clicks on product id in worklist, so we use association to item view and not select from item view directly
        //$projection is a predicate indicate the selection list of defined fields with alias
        mixin {
            PO_ITEMS : Association to many ItemView
                           on PO_ITEMS.ProductKey = $projection.ProductId
        }
        into {
            key NODE_KEY                           as ![ProductId],
                DESCRIPTION                        as ![ProductName],
                CATEGORY                           as ![Category],
                SUPPLIER_GUID.BP_ID                as ![SupplierId],
                SUPPLIER_GUID.COMPANY_NAME         as ![SupplierName],
                SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
                //exposed association, @ Runtime the data will be loaded on-demand- lazyloading
                PO_ITEMS                           as ![To_Items]
        };

    //view on view as a Consumption view, aggregation
    define view CproductSalesAnalytics as
        select from ![ProductView] {
                // we want to calculate total sales for each product, so we use association to item view
            key ProductName,
                Country,
                round(
                    sum(To_Items.GrossAmount), 2
                ) as ![TotalPurchaseAmount] : Decimal(15, 2),
                To_Items.CurrencyCode
        // we want to group the data by product name and country, so we use group by clause
        }
        group by
            ProductName,
            Country,
            To_Items.CurrencyCode;
}
