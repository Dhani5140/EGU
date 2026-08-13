tableextension 50183 "Location Ext MII" extends Location
{
    fields
    {
        field(50100; "Default Supplying"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Default Supplying CK';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50101; "Default In-Transit"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Default In-Transit';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true));
        }
    }
}