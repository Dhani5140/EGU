tableextension 50126 "No. Series Ext" extends "No. Series"
{
    fields
    {
        field(50000; "Invt. Shipment Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "PR Material Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "RFQ Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50003; "Purchase Order Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50004; "BPB Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50005; "Gen. Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50006; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Location";
        }
        field(50007; "Type Posted No. Series"; Enum "Type Posted No. Series")
        {
            DataClassification = ToBeClassified;
        }
    }
}
