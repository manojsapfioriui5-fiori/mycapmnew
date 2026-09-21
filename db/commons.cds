namespace mycapm.commons;

using {Currency} from '@sap/cds/common';

type Guid         : String(32);

type Gender       : String(1) enum {
    male = 'M';
    female = 'F';
    undisclosed = 'U';
};

aspect Amount : {
    CURRENCY     : Currency @title: '{i18n>XLBL_CURRENCY}';
    GROSS_AMOUNT : AmountT  @title: '{i18n>XLBL_GROSSAMOUNT}';
    NET_AMOUNT   : AmountT  @title: '{i18n>XLBL_NETAMOUNT}';
    TAX_AMOUNT   : AmountT  @title: '{i18n>XLBL_TAXAMOUNT}';
};

// @- annotation
type AmountT      : Decimal(10, 2) @(
    Semantic.amount.CurrencyCode: 'CURRENCY_code',
    sap.unit                    : 'CURRENCY_code'
);

type PhoneNumber  : String(30); // @assert.format: '((?:\+|00)[17](?: |\-)?|(?:\+|00)[1-9]\d{0,2}(?: |\-)?|(?:\+|00)1\-\d{3}(?: |\-)?)?(0\d|\([0-9]{3}\)|[1-9]{0,3})(?:((?: |\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\-)[0-9]{3}(?: |\-)[0-9]{4})|([0-9]{7}))';
type EmailAddress : String(255) // @assert.format: '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';
