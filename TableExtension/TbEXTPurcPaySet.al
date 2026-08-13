namespace PR;

using Microsoft.Purchases.Setup;
using Microsoft.Foundation.NoSeries;

tableextension 50121 PurPaySet extends "Purchases & Payables Setup"
{
    fields
    {
        field(60100; "PB Noseries"; Code[20])
        {
            Caption = 'PB Nos.';
            TableRelation = "No. Series";
        }
        field(60101; "PPB Noseries"; Code[20])
        {
            Caption = 'PPB Nos.';
            TableRelation = "No. Series";
        }
        field(60102; "RFQ Noseries"; code[20])
        {
            Caption = 'RFQ Nos.';
            TableRelation = "No. Series";
        }

        field(60103; "vsl"; Code[20])
        {
            Caption = 'Vendor Selection Nos.';
            TableRelation = "No. Series";
        }
    }


}