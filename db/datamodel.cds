using {anubhav.common} from './common';

using {
    cuid,
    Currency
} from '@sap/cds/common';

//unique name for project
namespace anubhav.db;


//Grouping of Data
// context master {
//     entity businesspartner{
//         key NODE_KEY : String(32);
//         BP_ROLE : String(2);
//         EMAIL_ADDRESS : String(125);
//         PHONE_NUMBER : String(32);
//         FAX_NUMBER : String(32);
//         WEB_ADDRESS : String(44);
//         COMPANY_NAME : String(250);
//         BP_ID : String(32);

//         //FOREIGN KEY RELATIOSHIP
//         ADDRESS_GUID : Association to one address;
//     }

// entity address {
//         key NODE_KEY        : String(32);
//             CITY            : String(44);
//             POSTAL_CODE     : String(8);
//             STREET          : String(44);
//             BUILDING        : String(128);
//             COUNTRY         : String(44);
//             ADDRESS_TYPE    : String(44);
//             VAL_START_DATE  : Date;
//             VAL_END_DATE    : Date;
//             LATITUDE        : Decimal;
//             LONGITUDE       : Decimal;
//             //WE CAN ALSO HAVE BACKWARD RELATIONSHIP - NOT MANDATORY

//             //$self - predicate provided by capm to refer current table primary key
//             businesspartner : Association to one businesspartner
//                                   on businesspartner.ADDRESS_GUID = $self;

//     }


//Business requirement is to change the NODE_KEY from String(32) to String 64
//CREATE OWN DATA TYPE, INSTEAD OF USING PRIMITIVE DATA TYPE
type Guid : String(32);

//Grouping of Data
context master {
    entity businesspartner {
        key NODE_KEY      : common.Guid @title: '{i18n>PARTNER_KEY}';
            BP_ROLE       : String(2);
            EMAIL_ADDRESS : String(125);
            PHONE_NUMBER  : String(32);
            FAX_NUMBER    : String(32);
            WEB_ADDRESS   : String(44);
            COMPANY_NAME  : String(250) @title: '{i18n>COMPANY_NAME}';
            BP_ID         : String(32);

            //FOREIGN KEY RELATIOSHIP
            ADDRESS_GUID  : Association to one address;
    }

    entity address {
        key NODE_KEY        : Guid;
            CITY            : String(44) @title: '{i18n>CITY}';
            POSTAL_CODE     : String(8);
            STREET          : String(44);
            BUILDING        : String(128);
            COUNTRY         : String(44) @title: '{i18n>COUNTRY}';
            ADDRESS_TYPE    : String(44);
            VAL_START_DATE  : Date;
            VAL_END_DATE    : Date;
            LATITUDE        : Decimal;
            LONGITUDE       : Decimal;
            //WE CAN ALSO HAVE BACKWARD RELATIONSHIP - NOT MANDATORY

            //$self - predicate provided by capm to refer current table primary key
            businesspartner : Association to one businesspartner
                                  on businesspartner.ADDRESS_GUID = $self;

    }

    entity employees : cuid { // CUID is a standard data type provided by SAP CAPM, which generates a unique identifier for each record in the entity.
        nameFirst     : String(256);
        nameMiddle    : String(256);
        nameLast      : String(256);
        nameInitials  : String(40);
        sex           : common.gender;
        language      : String(6);
        phoneNumber   : common.PhoneNumber;
        email         : common.Email;
        loginName     : String(256);
        currency      : Currency; // This is coming from @sap/cds/common.cds file, which is a standard data type provided by SAP CAPM
        salaryAmount  : common.AmountT;
        accountNumber : String(32);
        bankId        : String(32);
        bankName      : String(256);
        country       : String(3);


    }

    //Home Work - 28/July 2026
    //Create a student table
    // Create 2 tables student and subscription
    // Use cds add data command
    // Create mock data upload and check table
    // Make sure that pk for subscription table is auto created.

    entity student : cuid {
        ROLL_NUMBER       : String(32);
        FIRST_NAME        : String(32);
        LAST_NAME         : String(32);
        GENDER            : common.gender;
        DOB               : Date;
        EMAIL             : common.Email;
        PHONE_NUMBER      : common.PhoneNumber;
        ADDRESS           : String(32);
        CITY              : String(32);
        STATE             : String(32);
        POSTAL_CODE       : String(32);
        DEPARTMENT        : String(32);
        COURSE            : String(32);
        YEAR_OF_STUDY     : String(32);
        SECTION           : String(32);
        ADMISSION_DATE    : Date;
        STATUS            : common.Status;
        GUARDIAN_NAME     : String(32);
        GUARDIAN_PHONE    : common.PhoneNumber;
        //FOREIGN KEY RELATIOSHIP
        SUBSCRIPTION_GUID : Association to one subscription;
    }

    entity subscription : cuid {
        SUBSCRIPTION_ID     : String(32);
        STUDENT_ROLL_NUMBER : Association to student;
        SUBSCRIPTION_DATE   : Date;
        EXPIRY_DATE         : Date;
        STATUS              : common.Status;


    }

    entity product {
        key NODE_KEY       : common.Guid    @title                        : '{i18n>PRODUCT_KEY}';
            PRODUCT_ID     : String(28)     @title                        : '{i18n>PRODUCT_ID}';
            TYPE_CODE      : String(2);
            CATEGORY       : String(32) @title                        : '{i18n>CATEGORY}';
            DESCRIPTION    : String(255)    @title                        : '{i18n>PRODUCT_NAME}';
            SUPPLIER_GUID  : Association to one businesspartner;
            TAX_TARIF_CODE : Integer;
            MEASURE_UNIT   : String(2);
            WEIGHT_MEASURE : Decimal(5, 2);
            WEIGHT_UNIT    : String(2);
            CURRENCY       : Currency;
            PRICE          : Decimal(15, 2) @(Sementic.amount.currencyCode: 'CURRENCY_code');
            WIDTH          : Decimal(5, 2)  @(Sementic.quantity.unit      : 'DIM_UNIT');
            HEIGHT         : Decimal(5, 2)  @(Sementic.quantity.unit      : 'DIM_UNIT');
            DEPTH          : Decimal(5, 2)  @(Semantic.quantity.unit      : 'DIM_UNIT');
            DIM_UNIT       : String(2);
    }

    entity StatusCode {
        key STATUS : String(1);
            text   : String(10);
    }

}

context transaction {

    entity purchaseorder : common.Amount, cuid {
        //key NODE_KEY     : common.Guid                               @title: '{i18n>PO_KEY}';
            PO_ID        : String(32)                                @title: '{i18n>PO_ID}';
            PARTNER_GUID : Association to one master.businesspartner @title: '{i18n>PARTNER_KEY}';
            LIFECYCLE    : Association to one master.StatusCode      @title: '{i18n>STATUS}';
            OVERALL      : Association to one master.StatusCode      @title: '{i18n>OVERALL_STATUS}';
            NOTE         : String(255)                               @title: '{i18n>NOTE}';
            Items        : Association to many poitems
                               on Items.PARENT_KEY = $self
                                                                     @title: '{i18n>PO_ITEM_KEY}';
    }

    entity poitems : common.Amount, cuid {
            //key NODE_KEY     : common.Guid                       @title: '{i18n>PO_ITEM_KEY}';
            PARENT_KEY   : Association to one purchaseorder  @title: 'i18n>PO_KEY';
            PO_ITEM_POS  : Integer                           @title: '{i18n>PO_ITEM_POS}';
            PRODUCT_GUID : Association to one master.product @title: '{i18n>PRODUCT_KEY}';
    }

}
