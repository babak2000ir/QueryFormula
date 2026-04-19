codeunit 51103 "General Functions TPE"
{
    procedure LookupValueFields(TableId: Integer; FieldId: Integer; var Value: Text[250])
    var
        Field: Record Field;
        GeneralTableBuffer: Record "General Table Buffer TPE";
        DateTimeDialog: Page "Date-Time Dialog TPE";
        GeneralTableLookup: Page "General Table Lookup TPE";
        ValueDate: Date;
        ValueDateTime: DateTime;
        ValueTime: Time;
    begin
        Field.Get(TableId, FieldId);
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
                    if (Value <> '') and Evaluate(ValueDateTime, Value) then
                        DateTimeDialog.SetDateTime(ValueDateTime);
                    if DateTimeDialog.RunModal() = Action::LookupOK then
                        Value := Format(DateTimeDialog.GetDateTime(), 0, 9);
                end;
            Field.Type::Date:
                begin
                    Clear(DateTimeDialog);
                    DateTimeDialog.LookupMode(true);
                    DateTimeDialog.UseDateOnly();
                    if (Value <> '') and Evaluate(ValueDate, Value) then
                        DateTimeDialog.SetDate(ValueDate);
                    if DateTimeDialog.RunModal() = Action::LookupOK then
                        Value := Format(DateTimeDialog.GetDate(), 0, 9);
                end;
            Field.Type::Time:
                begin
                    Clear(DateTimeDialog);
                    DateTimeDialog.LookupMode(true);
                    DateTimeDialog.UseTimeOnly();
                    if (Value <> '') and Evaluate(ValueTime, Value) then
                        DateTimeDialog.SetTime(ValueTime);
                    if DateTimeDialog.RunModal() = Action::LookupOK then
                        Value := Format(DateTimeDialog.GetTime(), 0, 9);
                end;
            Field.Type::Code:
                if Field.RelationTableNo <> 0 then begin
                    GeneralTableLookup.LookupMode(true);
                    GeneralTableLookup.LoadData(Field.RelationTableNo, Value);
                    GeneralTableLookup.Editable(false);
                    if GeneralTableLookup.RunModal() = Action::LookupOK then begin
                        GeneralTableLookup.GetRecord(GeneralTableBuffer);
                        Value := GeneralTableBuffer.Field1;
                    end;
                end;
            Field.Type::Option:
                begin
                    GeneralTableLookup.LookupMode(true);
                    GeneralTableLookup.LoadData(Field.OptionString, Value);
                    GeneralTableLookup.Editable(false);
                    if GeneralTableLookup.RunModal() = Action::LookupOK then begin
                        GeneralTableLookup.GetRecord(GeneralTableBuffer);
                        Value := GeneralTableBuffer.Field2;
                    end;
                end;
        end;
    end;

    procedure LookupValueSpecialFormula(var Value: Text[250])
    var
        SpecialFormula: Record "Special Formula TPE";
        SpecialFormulaList: Page "Special Formula List TPE";
    begin
        SpecialFormulaList.LookupMode(true);
        SpecialFormulaList.SetRecord(Value);
        if SpecialFormulaList.RunModal() = Action::LookupOK then begin
            SpecialFormulaList.GetRecord(SpecialFormula);
            Value := SpecialFormula."Code";
        end;
    end;

    procedure LookupValueFormulaParameter(QueryFormulaCode: Code[20]; var Value: Text[250])
    var
        QueryFormulaParameter: Record "Query Formula Parameter TPE";
        QueryFormulaParamLookup: Page "Query Formula Param Lookup TPE";
    begin
        QueryFormulaParameter.Reset();
        QueryFormulaParameter.SetRange("Query Formula Code", QueryFormulaCode);
        if not QueryFormulaParameter.IsEmpty then begin
            QueryFormulaParamLookup.SetTableView(QueryFormulaParameter);
            if Value <> '' then begin
                QueryFormulaParameter.SetRange("Parameter Code", Value);
                if QueryFormulaParameter.FindFirst() then
                    QueryFormulaParamLookup.SetRecord(QueryFormulaParameter);
            end;
            QueryFormulaParamLookup.LookupMode(true);
            if QueryFormulaParamLookup.RunModal() = Action::LookupOK then begin
                QueryFormulaParamLookup.GetRecord(QueryFormulaParameter);
                Value := QueryFormulaParameter."Parameter Code";
            end;
        end;
    end;
}