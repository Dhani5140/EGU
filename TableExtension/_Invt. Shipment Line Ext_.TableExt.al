tableextension 50116 "Invt. Shipment Line Ext" extends "Invt. Shipment Line"
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
        field(50002; "Original Qty MR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "MR Purch. Receipt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}
