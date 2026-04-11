page 51104 "Query Formula Filter Sub TPE"
{
    ApplicationArea = All;
    Caption = 'Filters';
    PageType = ListPart;
    SourceTable = "Query Formula Filter TPE";


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Field: Record Field;
                    begin
                        if Rec."Field ID" = 0 then begin
                            Rec.Validate("Field Name", '');
                            exit;
                        end;
                        if Field.Get(gParentRecord."Table ID", Rec."Field ID") then
                            Rec.Validate("Field Name", Field.FieldName)
                        else
                            Error('Field ID %1 is not valid for Table ID %2', Rec."Field ID", gParentRecord."Table ID");
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Field: Record Field;
                        FieldsLookup: Page "Fields Lookup";
                    begin
                        if this.gParentRecord."Table ID" <> 0 then begin
                            Field.Reset();
                            Field.SetRange(TableNo, this.gParentRecord."Table ID");
                            FieldsLookup.SetTableView(Field);
                            FieldsLookup.LookupMode(true);

                            if FieldsLookup.RunModal() = Action::LookupOK then begin
                                FieldsLookup.GetRecord(Field);
                                Rec.Validate("Field ID", Field."No.");
                                Rec.Validate("Field Name", Field.FieldName)
                            end;
                        end;
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
                field("Filter Type"; Rec."Filter Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = All;
                    Caption = 'Value 1';

                    trigger OnAssistEdit()
                    var
                        CaptionTxt: Text;
                    begin
                        CaptionTxt := Rec.GetValue1Caption();
                    end;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = All;
                    Caption = 'Value 2';
                    Visible = Value2Visible;
                }
            }
        }
    }

    var
        gParentRecord: Record "Query Formula TPE";
        Value2Visible: Boolean;

    trigger OnAfterGetRecord()
    begin
        UpdateVisibility();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateVisibility();
    end;

    local procedure UpdateVisibility()
    begin
        Value2Visible := Rec."Filter Type" = Rec."Filter Type"::Between;
    end;

    procedure SetParentRecord(ParentRecord: Record "Query Formula TPE")
    begin
        this.gParentRecord := ParentRecord;
    end;

}
