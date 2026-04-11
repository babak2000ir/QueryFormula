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
                    CaptionClass = this.GetValue1Caption();
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = All;
                    Caption = '';
                    CaptionClass = this.GetValue2Caption();
                    Enabled = this.Value2CaptionTxt <> '';
                }
            }
        }
    }

    var
        gParentRecord: Record "Query Formula TPE";
        Value1CaptionTxt: Text;
        Value2CaptionTxt: Text;

    trigger OnOpenPage()
    begin
        this.UpdateValueCaptions();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        this.UpdateValueCaptions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        this.UpdateValueCaptions();
    end;

    local procedure UpdateValueCaptions()
    begin
        case Rec."Filter Type" of
            Rec."Filter Type"::"Less Than",
            Rec."Filter Type"::"Less Than or Equal":
                begin
                    this.Value1CaptionTxt := 'Maximum Value';
                    this.Value2CaptionTxt := '';
                end;
            Rec."Filter Type"::"Greater Than",
            Rec."Filter Type"::"Greater Than or Equal":
                begin
                    this.Value1CaptionTxt := 'Minimum Value';
                    this.Value2CaptionTxt := '';
                end;
            Rec."Filter Type"::Between:
                begin
                    this.Value1CaptionTxt := 'From Value';
                    this.Value2CaptionTxt := 'To Value';
                end;
            Rec."Filter Type"::Filter:
                begin
                    this.Value1CaptionTxt := 'Filter Expression';
                    this.Value2CaptionTxt := '';
                end;
        end;
    end;

    local procedure GetValue1Caption(): Text
    begin
        exit(this.Value1CaptionTxt);
    end;

    local procedure GetValue2Caption(): Text
    begin
        exit(this.Value2CaptionTxt);
    end;

    procedure SetParentRecord(ParentRecord: Record "Query Formula TPE")
    begin
        this.gParentRecord := ParentRecord;
    end;

}
