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

            trigger OnValidate()
            var
                Field: Record Field;
                QueryFormula: Record "Query Formula TPE";
            begin
                if Rec."Field ID" = 0 then begin
                    Rec.Validate("Field Name", '');
                    exit;
                end;
                if QueryFormula.Get(Rec."Query Formula Code") then begin
                    QueryFormula.TestField("Table ID");
                    if Field.Get(QueryFormula."Table ID", Rec."Field ID") then
                        Rec.Validate("Field Name", Field.FieldName)
                    else
                        Error('Field ID %1 is not valid for Table ID %2', Rec."Field ID", QueryFormula."Table ID");
                end;
            end;

            trigger OnLookup()
            var
                Field: Record Field;
                QueryFormula: Record "Query Formula TPE";
                FieldsLookup: Page "Fields Lookup";
            begin
                if QueryFormula.Get(Rec."Query Formula Code") and (QueryFormula."Table ID" <> 0) then begin
                    Field.Reset();
                    Field.SetRange(TableNo, QueryFormula."Table ID");
                    FieldsLookup.SetTableView(Field);
                    FieldsLookup.LookupMode(true);

                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                        FieldsLookup.GetRecord(Field);
                        Rec.Validate("Field ID", Field."No.");
                    end;
                end;
            end;
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
        }
        field(10; "Value 1 Type"; Enum "Value Type Filter TPE")
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';

            trigger OnValidate()
            begin
                if xRec."Value 1 Type" <> Rec."Value 1 Type" then
                    Rec."Value 1" := '';
            end;
        }
        field(11; "Value 1"; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';

            trigger OnLookup()
            begin
                this.LookupValue(Rec, Rec."Value 1 Type", Rec."Value 1");
            end;
        }
        field(12; "Value 2 Type"; Enum "Value Type Filter TPE")
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the second filter value.';

            trigger OnValidate()
            begin
                if xRec."Value 2 Type" <> Rec."Value 2 Type" then
                    Rec."Value 2" := '';
            end;
        }
        field(13; "Value 2"; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the second filter value.';

            trigger OnLookup()
            begin
                this.LookupValue(Rec, Rec."Value 2 Type", Rec."Value 2");
            end;
        }
    }

    keys
    {
        key(Key1; "Query Formula Code", "Field ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Field ID" = 0 then
            Error('Field ID must not be 0. Please select a valid field before saving.');
    end;

    procedure LookupValue(QueryFormulaFilter: Record "Query Formula Filter TPE"; ValueType: Enum "Value Type Filter TPE"; var Value: Text[250])
    var
        QueryFormula: Record "Query Formula TPE";
        GeneralFunctions: Codeunit "General Functions TPE";
    begin
        QueryFormula.Get(QueryFormulaFilter."Query Formula Code");
        case ValueType of
            "Value Type Filter TPE"::Const:
                GeneralFunctions.LookupValueFields(QueryFormula."Table ID", QueryFormulaFilter."Field ID", Value);
            "Value Type Filter TPE"::SpecialFormula:
                GeneralFunctions.LookupValueSpecialFormula(Value);
            "Value Type Filter TPE"::FormulaParameter:
                GeneralFunctions.LookupValueFormulaParameter(QueryFormula."Code", Value);
        end;
    end;

}
