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
        field(10; "Value 1 Type"; Enum "Value Type TPE")
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
        field(12; "Value 2 Type"; Enum "Value Type TPE")
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


    procedure LookupValue(QueryFormulaFilter: Record "Query Formula Filter TPE"; ValueType: Enum "Value Type TPE"; var Value: Text[250])
    var
        QueryFormulaParameter: Record "Query Formula Parameter TPE";
        SpecialFormula: Record "Special Formula TPE";
        QueryFormula: Record "Query Formula TPE";
        Field: Record Field;
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        QueryFormulaParamLookup: Page "Query Formula Param Lookup TPE";
        SpecialFormulaList: Page "Special Formula List TPE";
        DateTimeDialog: Page "Date-Time Dialog TPE";
        GeneralTableLookup: Page "General Table Lookup TPE";
    begin
        case ValueType of
            "Value Type TPE"::Const:
                begin
                    QueryFormula.Get(QueryFormulaFilter."Query Formula Code");
                    Field.Get(QueryFormula."Table ID", QueryFormulaFilter."Field ID");
                    case Field.Type of
                        //Field.Type::TableFilter:
                        //Field.Type::RecordID:
                        //Field.Type::OemText:
                        //Field.Type::Media:
                        //Field.Type::MediaSet:
                        //Field.Type::Binary:
                        //Field.Type::BLOB:
                        //Field.Type::OemCode:

                        Field.Type::DateFormula,
                        Field.Type::Decimal,
                        Field.Type::Text,
                        Field.Type::Boolean,
                        Field.Type::Integer,
                        Field.Type::BigInteger,
                        Field.Type::Duration,
                        Field.Type::GUID:
                            Message('Please enter a constant value of type %1.', Field.Type);
                        Field.Type::DateTime:
                            begin
                                Clear(DateTimeDialog);
                                DateTimeDialog.LookupMode(true);
                                if DateTimeDialog.RunModal() = Action::LookupOK then
                                    Value := Format(DateTimeDialog.GetDateTime(), 0, 9);
                            end;
                        Field.Type::Date:
                            begin
                                Clear(DateTimeDialog);
                                DateTimeDialog.LookupMode(true);
                                DateTimeDialog.UseDateOnly();
                                if DateTimeDialog.RunModal() = Action::LookupOK then
                                    Value := Format(DateTimeDialog.GetDate(), 0, 9);
                            end;
                        Field.Type::Time:
                            begin
                                Clear(DateTimeDialog);
                                DateTimeDialog.LookupMode(true);
                                DateTimeDialog.UseTimeOnly();
                                if DateTimeDialog.RunModal() = Action::LookupOK then
                                    Value := Format(DateTimeDialog.GetTime(), 0, 9);
                            end;
                        Field.Type::Code:
                            if Field.RelationTableNo <> 0 then begin
                                GeneralTableLookup.LookupMode(true);
                                GeneralTableLookup.LoadData(Field.RelationTableNo);
                                GeneralTableLookup.Editable(false);
                                if GeneralTableLookup.RunModal() = Action::LookupOK then begin
                                    //Rec.Get(GeneralTableLookup.Rec."Entry No.");
                                    //Value := GeneralTableLookup.Rec.Key1;
                                end;
                            end;
                        Field.Type::Option:
                            begin
                                //TempOptionLookupBuffer.FillLookupBuffer("Option Lookup Type"::);
                            end;
                    end;

                end;
            "Value Type TPE"::SpecialFormula:
                begin
                    SpecialFormulaList.LookupMode(true);
                    if SpecialFormulaList.RunModal() = Action::LookupOK then begin
                        SpecialFormulaList.GetRecord(SpecialFormula);
                        Value := SpecialFormula."Code";
                    end;
                end;
            "Value Type TPE"::FormulaParameter:
                begin
                    QueryFormulaParameter.Reset();
                    QueryFormulaParameter.SetRange("Query Formula Code", Rec."Query Formula Code");
                    if not QueryFormulaParameter.IsEmpty then begin
                        QueryFormulaParamLookup.SetTableView(QueryFormulaParameter);
                        QueryFormulaParamLookup.LookupMode(true);

                        if QueryFormulaParamLookup.RunModal() = Action::LookupOK then begin
                            QueryFormulaParamLookup.GetRecord(QueryFormulaParameter);
                            Value := QueryFormulaParameter."Parameter Code";
                        end;
                    end;
                end;
        end;
    end;
}
