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
                field("Value 1 Type"; Rec."Value 1 Type")
                {
                    ApplicationArea = All;
                    CaptionClass = this.GetCaption(1);
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = All;
                    CaptionClass = this.GetCaption(2);
                }
                field("Value 2 Type"; Rec."Value 2 Type")
                {
                    ApplicationArea = All;
                    Caption = '';
                    CaptionClass = this.GetCaption(3);
                    Enabled = Rec."Filter Type" = Rec."Filter Type"::Between;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = All;
                    Caption = '';
                    CaptionClass = this.GetCaption(4);
                    Enabled = Rec."Filter Type" = Rec."Filter Type"::Between;
                }
            }
        }
    }

    local procedure GetCaption(i: Integer): Text
    var
        ValueType1Caption: Text;
        ValueType2Caption: Text;
        Value1Caption: Text;
        Value2Caption: Text;
    begin
        case Rec."Filter Type" of
            Rec."Filter Type"::Equal,
            Rec."Filter Type"::NotEqual:
                begin
                    ValueType1Caption := 'Value Type';
                    ValueType2Caption := '';
                    Value1Caption := 'Value';
                    Value2Caption := '';
                end;
            Rec."Filter Type"::"Less Than",
            Rec."Filter Type"::"Less Than or Equal":
                begin
                    ValueType1Caption := 'Value Type';
                    ValueType2Caption := '';
                    Value1Caption := 'Maximum';
                    Value2Caption := '';
                end;
            Rec."Filter Type"::"Greater Than",
            Rec."Filter Type"::"Greater Than or Equal":
                begin
                    ValueType1Caption := 'Value Type';
                    ValueType2Caption := '';
                    Value1Caption := 'Minimum';
                    Value2Caption := '';
                end;
            Rec."Filter Type"::Between:
                begin
                    ValueType1Caption := 'Value Type';
                    ValueType2Caption := 'Value Type';
                    Value1Caption := 'From Value';
                    Value2Caption := 'To Value';
                end;
            Rec."Filter Type"::Filter:
                begin
                    ValueType1Caption := 'Filter Type';
                    ValueType2Caption := '';
                    Value1Caption := 'Filter';
                    Value2Caption := '';
                end;
        end;

        case i of
            1:
                exit(ValueType1Caption);
            2:
                exit(Value1Caption);
            3:
                exit(ValueType2Caption);
            4:
                exit(Value2Caption);
        end;
    end;
}
