page 50138 "Employee Request"
{
    Caption = 'Employee Request';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;
    AdditionalSearchTerms = 'Emp Req';
    SourceTable = Employee_Req;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = all;
                    LookupPageId = "User Lookup";
                }
                field("Request Dept"; Rec."Request Dept")
                {
                    ApplicationArea = all;

                }
                field(Default; Rec.Default)
                {
                    ApplicationArea = all;
                }
                field("ADCS USER"; Rec."ADCS USER")
                {
                    ApplicationArea = all;
                    Caption = 'ADCS USER';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }
}