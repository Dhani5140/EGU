pageextension 50100 Payjour extends Microsoft.Finance.GeneralLedger.Journal."Payment Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("Wthldg. Tax Bus. Post. Group71648"; Rec."Wthldg. Tax Bus. Post. Group")
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