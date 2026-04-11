table 51102 "Query Formula Filter TPE"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Query Formula Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = "Query Formula TPE";
            ToolTip = 'Specifies the query formula code.';
        }
        field(2; "Field ID"; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = Field."No.";
            ToolTip = 'Specifies the field ID to filter.';
        }
        field(3; "Field Name"; Text[250])
        {
            Editable = false;
            ToolTip = 'Specifies the field name.';
        }
        field(4; "Filter Type"; Enum "Filter Type TPE")
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter type.';

            trigger OnValidate()
            begin
                UpdateValueCaptions();
            end;
        }
        field(10; "Value 1"; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';
        }
        field(11; "Value 2"; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the second filter value.';
        }
    }

    keys
    {
        key(Key1; "Query Formula Code", "Field ID")
        {
            Clustered = true;
        }
    }

    var
        Value1CaptionTxt: Text;
        Value2CaptionTxt: Text;

    local procedure UpdateValueCaptions()
    begin
        case "Filter Type" of
            "Filter Type"::"Less Than":
                begin
                    Value1CaptionTxt := 'Maximum Value';
                    Value2CaptionTxt := '';
                end;
            "Filter Type"::"Less Than or Equal":
                begin
                    Value1CaptionTxt := 'Maximum Value';
                    Value2CaptionTxt := '';
                end;
            "Filter Type"::"Greater Than":
                begin
                    Value1CaptionTxt := 'Minimum Value';
                    Value2CaptionTxt := '';
                end;
            "Filter Type"::"Greater Than or Equal":
                begin
                    Value1CaptionTxt := 'Minimum Value';
                    Value2CaptionTxt := '';
                end;
            "Filter Type"::Between:
                begin
                    Value1CaptionTxt := 'From Value';
                    Value2CaptionTxt := 'To Value';
                end;
            "Filter Type"::Filter:
                begin
                    Value1CaptionTxt := 'Filter Expression';
                    Value2CaptionTxt := '';
                end;
        end;
    end;

    procedure GetValue1Caption(): Text
    begin
        if Value1CaptionTxt = '' then
            UpdateValueCaptions();
        exit(Value1CaptionTxt);
    end;

    procedure GetValue2Caption(): Text
    begin
        if Value2CaptionTxt = '' then
            UpdateValueCaptions();
        exit(Value2CaptionTxt);
    end;
}
