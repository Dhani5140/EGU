// table 50162 "Table View Generate Header"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Faktur Pajak ID"; Code[20])
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(2; "Description"; Text[100])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(3; "Branch Code"; Integer)
//         {
//             DataClassification = ToBeClassified;

//         }

//         field(4; "Year"; Integer)
//         {
//             DataClassification = ToBeClassified;
//         }

//         field(5; "From No."; Integer)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(6; "To No"; Integer)
//         {
//             DataClassification = ToBeClassified;
//         }

//         field(7; Status; enum "Generate Pajak Status")
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(8; "Branch Code1"; code[3])
//         {
//             DataClassification = ToBeClassified;
//             trigger OnValidate()
//             begin
//                 UpdateLinesWithHeaderData();
//             end;
//         }
//         // field(9;"Branch Code1"; code[3])
//         // {
//         //     DataClassification = ToBeClassified;
//         // }

//         field(9; "Trasaction Code"; Option)
//         {
//             DataClassification = ToBeClassified;
//             OptionMembers = "00","01","02","03","04","05","06","07","08","09";
//             trigger OnValidate()
//             begin
//                 UpdateLinesWithHeaderData();
//             end;
//         }
//         field(10; "Status Code"; Option)
//         {
//             DataClassification = ToBeClassified;
//             OptionMembers = "0","1";
//         }
//     }

//     keys
//     {
//         key(Key1; "Faktur Pajak ID")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//         // Add changes to field groups here
//     }

//     var
//         myInt: Integer;





//     trigger OnInsert()
//     begin

//     end;

//     trigger OnModify()
//     begin

//     end;

//     trigger OnDelete()
//     begin

//     end;

//     trigger OnRename()
//     begin

//     end;

//     procedure UpdateLinesWithHeaderData()
//     var
//         LineRec: Record "Table View Generate Line2";
//     begin
//         LineRec.SetRange("Document No.", Rec."Faktur Pajak ID");

//         if LineRec.FindSet() then begin
//             repeat
//                 LineRec."Transaction Code" := Rec."Trasaction Code";
//                 LineRec."Branch Code" := Rec."Branch Code1";
//                 LineRec.Modify();
//             until LineRec.Next() = 0;

//             //Message('Lines updated with new Transaction Code and Branch Code.');
//         end else begin
//             Message('No lines found for the current Faktur Pajak ID.');
//         end;
//     end;

//     procedure CheckAndUpdateStatus()
//     var
//         LineRec: Record "Table View Generate Line2";
//         AllUsed: Boolean;
//         HasFree: Boolean;
//     begin
//         AllUsed := true;
//         HasFree := false;

//         // Cek semua line berdasarkan "Faktur Pajak ID"
//         LineRec.SetRange("Document No.", "Faktur Pajak ID");
//         if LineRec.FindSet() then begin
//             repeat
//                 // Jika ada line yang "Free", set HasFree ke true
//                 if LineRec.Status = LineRec.Status::Free then
//                     HasFree := true;

//                 // Jika ada line yang tidak "Used", set AllUsed ke false
//                 if LineRec.Status <> LineRec.Status::Used then
//                     AllUsed := false;

//             until LineRec.Next() = 0;
//         end;

//         // Jika semua line sudah "Used", ubah status header menjadi "Close"
//         if AllUsed then begin
//             Status := Status::Close;
//             Modify();
//             Message('All lines are used. Status updated to "Close".');
//         end
//         // Jika ada line yang "Free", ubah status header menjadi "Open"
//         else if HasFree then begin
//             Status := Status::Open;
//             Modify();
//             Message('Some lines are Free. Status updated to "Open".');
//         end;
//     end;
// }

