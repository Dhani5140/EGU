pageextension 50126 "No. Series Ext" extends "No. Series"
{
    layout
    {
        addafter(AllowGapsCtrl)
        {
            field("Invt. Shipment Nos."; Rec."Invt. Shipment Nos.")
            {
                ApplicationArea = All;
            }
            field("PR Material Nos."; Rec."PR Material Nos.")
            {
                ApplicationArea = All;
            }
            field("RFQ Nos."; Rec."RFQ Nos.")
            {
                ApplicationArea = All;
            }
            field("Purchase Order Nos."; Rec."Purchase Order Nos.")
            {
                ApplicationArea = All;
            }
            field("BPB Nos."; Rec."BPB Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
    var
        myInt: Integer;
}
