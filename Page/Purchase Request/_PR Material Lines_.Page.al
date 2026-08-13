page 50115 "PR Material Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = "PR Material Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Purchase Req. No."; Rec."Purchase Req. No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }

                field("Unit of Measure Code"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }

            }
        }
    }
    actions
    {
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Location;
                Caption = 'Show Document';
                Image = View;
                ShortCutKey = 'Shift+F7';
                ToolTip = 'Open the document that the selected line exists on.';

                trigger OnAction()
                var
                    lRecPRHeader: Record "PR Material Header";
                begin
                    lRecPRHeader.Get(Rec."Purchase Req. No.");
                    PAGE.Run(PAGE::"PR Material Card sh", lRecPRHeader);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Show Document_Promoted"; "Show Document")
                {
                }
            }
        }
    }
}
