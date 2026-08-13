tableextension 50162 "GL Account Ext" extends "G/L Account"
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
