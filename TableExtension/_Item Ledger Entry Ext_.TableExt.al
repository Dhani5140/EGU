tableextension 50111 "Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "PR Material Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Original Qty MR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Original Qty PR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "No. Shipping"; code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "No. Berita Acara"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "No. Surat Jalan"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Tanggal Surat Jalan"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "No. Polisi"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(50012; "Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Item Journal MR"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(70000; "Source Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Source Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }
}
