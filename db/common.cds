using {Currency} from '@sap/cds/common'; 
namespace anubhav.common;

type Guid : String(32);

type gender : String(1) enum{
    male = 'M';
    female = 'F';
    unspecified = 'U';
}

type PhoneNumber : String(32);

type Email : String(250);

type AmountT : Decimal(15,2) @(sementic.amount.currencyCode : 'Currency');

type Status : String(1) enum {
    active = 'A';
    Passed = 'P';
    Dropped = 'D';
}

//CREATE ASPECT FOR GROSS, NET and TAX AMOUNT
 aspect Amount {
    GROSS_AMOUNT : Decimal(15,2) @(sementic.amount.CURRENCY_code, title:'{i18n>GROSS_AMOUNT}') ;
    NET_AMOUNT : Decimal(15,2) @(sementic.amount.CURRENCY_code, title:'{i18n>NET_AMOUNT}');
    TAX_AMOUNT : Decimal (15,2) @(semantic.amount,CURRENCY_code, title:'{i18n>TAX_AMOUNT}');
    CURRENCY : Currency @title:'{i18n>CURRENCY_CODE}';
 }