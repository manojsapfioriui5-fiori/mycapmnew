using CatalogService as service from '../../srv/CatalogService';

annotate service.POs with @(
    UI.SelectionFields      : [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        CURRENCY,
        OVERALL_STATUS
    ],
    UI.LineItem             : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.boost',
            Inline: true,
            Label : 'Boost'
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type      : 'UI.DataField',
            Value      : OverallStatusText,
            Criticality: IconColor
        },
    ],
    UI.HeaderInfo           : {
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {Value: PO_ID},
        Description   : {Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRM6Pu9-1qRVa_iqzgejaz6b0P84cb-GuzBqkn4nU16bQ&s=10'
    },
    UI.Facets               : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.Identification',
                    Label : 'Order Details',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Spiderman',
                    Label : 'Configuration Details',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Ironman',
                    Label : 'Status Info',
                },
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Details',
            Target: 'Items/@UI.LineItem'
        }
    ],
    UI.Identification       : [
        {
            Value: PO_ID,
            $Type: 'UI.DataField'
        },
        {
            Value: PARTNER_GUID_NODE_KEY,
            $Type: 'UI.DataField'
        },
        {
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY,
            $Type: 'UI.DataField'
        },
        {
            Value: LIFECYCLE_STATUS,
            $Type: 'UI.DataField'
        }
    ],
    UI.FieldGroup #Spiderman: {
        Label: 'Pricing',
        Data : [
            {
                Value: GROSS_AMOUNT,
                $Type: 'UI.DataField'
            },
            {
                Value: NET_AMOUNT,
                $Type: 'UI.DataField'
            },
            {
                Value: TAX_AMOUNT,
                $Type: 'UI.DataField'
            }
        ]

    },
    UI.FieldGroup #Ironman  : {
        Label: 'Status Info',
        Data : [
            {
                Value: OVERALL_STATUS,
                $Type: 'UI.DataField'
            },
            {
                Value: CURRENCY_code,
                $Type: 'UI.DataField'
            }
        ]
    }
);

annotate service.POItems with @(
    UI.LineItem: 
    [
{
            Value: PO_ITEM_POS,
            $Type: 'UI.DataField'
        },
        {
            Value: PRODUCT_GUID_NODE_KEY,
            $Type: 'UI.DataField'
        },
        {
            Value: GROSS_AMOUNT,
            $Type: 'UI.DataField'
        },
        {
            Value: NET_AMOUNT,
            $Type: 'UI.DataField'
        },
        {
            Value: TAX_AMOUNT,
            $Type: 'UI.DataField'
        },
        {
            Value: CURRENCY_code,
            $Type: 'UI.DataField'
        }
    ],
    UI.HeaderInfo           : {
        TypeName      : 'Purchase Order Item',
        TypeNamePlural: 'Purchase Order Items',
        Title         : {Value: PO_ITEM_POS},
        Description   : {Value: PRODUCT_GUID.ProductName}
    },
     UI.Facets               : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Details',
            Target: '@UI.Identification'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Product Details',
            Target: '@UI.FieldGroup#Superman'
        }
    ],
    UI.Identification       : [
        {
            Value: PO_ITEM_POS,
            $Type: 'UI.DataField'
        },
        {
            Value: PRODUCT_GUID_NODE_KEY,
            $Type: 'UI.DataField'
        },
        {
            Value: GROSS_AMOUNT,
            $Type: 'UI.DataField'
        },
        {
            Value: NET_AMOUNT,
            $Type: 'UI.DataField'
        },
        {
            Value: TAX_AMOUNT,
            $Type: 'UI.DataField'
        },
        {
            Value: CURRENCY_code,
            $Type: 'UI.DataField'
        }
    ],
    UI.FieldGroup #Superman: {
        Data : [
            {
                Value: PRODUCT_GUID.ProductId,
                $Type: 'UI.DataField'
            },
            {
                Value: PRODUCT_GUID.ProductName,
                $Type: 'UI.DataField'
            },
            {
                Value: PRODUCT_GUID.SupplierName,
                $Type: 'UI.DataField'
            },
            {
                Value: PRODUCT_GUID.Category,
                $Type: 'UI.DataField'
            }
        ]

    }
);
//To display text along with ID
annotate service.POs with {
    PARTNER_GUID @(
        Common.Text: PARTNER_GUID.COMPANY_NAME
    );
    OVERALL_STATUS @(
        Common.Text: OverallStatusText
    )
};

annotate service.POItems with {
    PRODUCT_GUID @(
        Common.Text: PRODUCT_GUID.ProductName
    )
};
// Value help annotations
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification: [
        {Value: COMPANY_NAME, $Type: 'UI.DataField'}
    ]
);
// Value help annotations
@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification: [
        {Value: ProductName, $Type: 'UI.DataField'}
    ]
);

annotate service.POs with @odata.draft.enabled ;
