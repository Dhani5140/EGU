table 50100 "MII Setup"
{
    DataClassification = ToBeClassified;
    CAPTION = 'MII Setup';

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Material Req. Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; "PR Material Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4; "PR Asset Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5; "RFQ Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6; "Tax Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7; "Purchase Order Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(8; "No. G/L FA"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(9; "InvShip Nos. from MR"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(10; "No. G/L PPH22"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(11; "No. PBBKB"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Charge";
        }
        field(12; "Item Journal Document Nos"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(13; "FA Journal Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(14; "FA Journal Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("FA Journal Template"));
        }
        field(15; "MR Consignment Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(16; "PR Consignment Nos."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(17; "MR Consign. Journal Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(18; "MR Consign. Journal Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("MR Consign. Journal Template"));
        }
        field(19; "No. G/L Journal PR Consignment"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(20; "No. G/L Consignment PO"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(21; "Default Gen. Prod PO"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(22; "No. Direct Cost Applied Acc."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(23; "Vensel Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(24; "RFQ Vendor"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'RFQ Max Vendor';

        }
        field(25; "Vendor PR Mandatory"; Boolean)
        {
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(26; Hide; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Enable TO from RO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer Order to Request Order Active';
            InitValue = true;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}
