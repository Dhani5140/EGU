table 50130 Employee_Req
{
    Caption = 'Employee Request';
    ReplicateData = true;
    LookupPageId = "Employee Request";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User Id"; Code[20])
        {
            Caption = 'User Id';
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                user: Codeunit "User Selection";
            begin
                user.ValidateUserName("User Id");
            end;
        }

        field(2; "Request Dept"; Code[20])
        {
            Caption = 'Request Dept';
            TableRelation = "Request Dept";
        }

        field(4; Default; Boolean)
        {
            Caption = 'Default';
        }

        field(5; "ADCS USER"; Code[50])
        {
            Caption = 'ADCS User';
            DataClassification = ToBeClassified;
            TableRelation = "ADCS User".Name;

            trigger OnValidate()
            var
                emplreq: Record Employee_Req;

            begin
                if ("ADCS USER" <> xRec."ADCS USER") and ("ADCS USER" <> '') then begin
                    emplreq.SetRange("ADCS USER", "ADCS USER");
                    if not emplreq.IsEmpty() then
                        Error('You can only assign an ADCS user name once.');
                end;
            end;
        }

    }

    keys
    {
        key(PK; "User Id", "Request Dept")
        {
            Clustered = true;
        }
        key(PK2; Default)
        {

        }

    }
    fieldgroups
    {

    }
    trigger OnInsert()
    begin


    end;

    local procedure Checkdefault()
    var
        empreq2: Record Employee_Req;
        IsHandled: Boolean;

    begin
        IsHandled := false;
        OnBeforeCheckDefault(Rec, IsHandled);
        if IsHandled then
            exit;

        empreq2.SetRange(Default, true);
        empreq2.SetRange("User Id", "User Id");
        empreq2.SetFilter("Request Dept", '<>%1', "Request Dept");
        if not empreq2.IsEmpty() then
            Error('Sudah');

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDefault(var empreq: Record Employee_Req; var IsHandled: Boolean)
    begin
    end;



}