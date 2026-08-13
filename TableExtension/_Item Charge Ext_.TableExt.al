tableextension 50168 "Item Charge Ext" extends "Item Charge"
{
    fields
    {
        field(50000; "Shipping Charge RFQ"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        // Add changes to keys here
    }
    fieldgroups
    {
        // Add changes to field groups here
    }
    var
        myInt: Integer;
}
