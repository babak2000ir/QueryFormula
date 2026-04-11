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
                field("Value 1 Parameter"; Rec."Value 1 Parameter")
                {
                    ApplicationArea = All;
                    CaptionClass = this.GetValue1Caption(true);
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = All;
                    CaptionClass = this.GetValue1Caption(false);
                }
                field("Value 2 Parameter"; Rec."Value 2 Parameter")
                {
                    ApplicationArea = All;
                    Caption = '';
                    CaptionClass = this.GetValue2Caption(true);
                    Enabled = this.Value2CaptionTxt <> '';
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = All;
                    Caption = '';
                    CaptionClass = this.GetValue2Caption(false);
                    Enabled = this.Value2CaptionTxt <> '';
                }
            }
        }
    }

    var
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

    local procedure GetValue1Caption(ParamCaption: Boolean): Text
    begin
        if ParamCaption and (this.Value1CaptionTxt <> '') then
            exit('Use Parameter for ' + this.Value1CaptionTxt)
        else
            exit(this.Value1CaptionTxt);
    end;

    local procedure GetValue2Caption(ParamCaption: Boolean): Text
    begin
        if ParamCaption and (this.Value2CaptionTxt <> '') then
            exit('Use Parameter for ' + this.Value2CaptionTxt)
        else
            exit(this.Value2CaptionTxt);
    end;
}
