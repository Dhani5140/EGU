pageextension 50100 Payjour extends "Payment Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field(whtldgTaxProdPostGroup; Rec."Wthldg. Tax Prod. Post. Group")
            {
                ApplicationArea = All;
            }

            field("Wthldg. Tax Prod. Post. Group31071"; Rec."Wthldg. Tax Prod. Post. Group")
            {
                ApplicationArea = All;
            }
        }
    }

}