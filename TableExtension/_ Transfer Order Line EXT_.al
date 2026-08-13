tableextension 50161 "Transfer Line Ext MII" extends "Transfer Line"
{
    fields
    {
        field(50100; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Material Req. No.';
        }
        field(50101; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Material Req. Line No.';
        }
    }
}