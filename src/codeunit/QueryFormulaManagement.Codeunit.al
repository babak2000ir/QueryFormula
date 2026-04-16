codeunit 51102 "Query Formula Management TPE"
{
    var
        gQueryExecutionLog: Record "Query Execution Log TPE" temporary;
        gQueryFormulaParameters: Dictionary of [Code[20], Text];

    procedure SetLogger(var QueryExecutionLog: Record "Query Execution Log TPE" temporary)
    begin
        gQueryExecutionLog := QueryExecutionLog;
    end;

    procedure SetParameters(QueryFormulaParameters: Dictionary of [Code[20], Text])
    begin
        gQueryFormulaParameters := QueryFormulaParameters;
    end;

    procedure RunQuery(QueryFormulaCode: Code[20]) Result: Text
    var
        QueryFormula: Record "Query Formula TPE";
        AllObjWithCaption: Record AllObjWithCaption;
        Field: Record Field;
        QueryFormulaFilter: Record "Query Formula Filter TPE";
        SpecialFormula: Record "Special Formula TPE";
        SpecialFormulaManagement: Codeunit "Special Formula Management TPE";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        DecimalResult: Decimal;
        DecimalValue: Decimal;
        Counter: Integer;
        Value1: Text;
        Value2: Text;
    begin
        if not QueryFormula.Get(QueryFormulaCode) then begin
            this.Log(StrSubstNo('QFM: Query formula with code %1 not found.', QueryFormulaCode));
            exit;
        end;

        if (QueryFormula."Table ID" = 0) or not AllObjWithCaption.Get(ObjectType::Table, QueryFormula."Table ID") then begin
            this.Log(StrSubstNo('QFM: Query formula with code %1 has invalid table ID.', QueryFormulaCode));
            exit;
        end;

        RecRef.Open(QueryFormula."Table ID");

        QueryFormulaFilter.Reset();
        QueryFormulaFilter.SetRange("Query Formula Code", QueryFormulaCode);
        if QueryFormulaFilter.FindSet() then
            repeat
                if (QueryFormulaFilter."Field ID" = 0) or not Field.Get(QueryFormula."Table ID", QueryFormulaFilter."Field ID") then begin
                    this.Log(StrSubstNo('QFM: Query formula filter for field ID %1 is invalid.', QueryFormulaFilter."Field ID"));
                    exit;
                end;

                FieldRef := RecRef.Field(QueryFormulaFilter."Field ID");

                Value1 := '';
                Value2 := '';

                if (QueryFormulaFilter."Value 1 Type" = "Value Type TPE"::SpecialFormula) or (QueryFormulaFilter."Value 2 Type" = "Value Type TPE"::SpecialFormula) then
                    SpecialFormulaManagement.GetSpecialFormulas(SpecialFormula);

                Case QueryFormulaFilter."Value 1 Type" of
                    "Value Type TPE"::Const:
                        Value1 := QueryFormulaFilter."Value 1";
                    "Value Type TPE"::FormulaParameter:
                        if (QueryFormulaFilter."Value 1" = '') or not this.GetParameterValue(QueryFormulaFilter."Value 1", Value1) then
                            this.Log(StrSubstNo('QFM: Query formula filter has empty or invalid parameter name.', QueryFormulaFilter."Value 1"));
                    "Value Type TPE"::SpecialFormula:
                        if (QueryFormulaFilter."Value 1" = '') or not SpecialFormula.Get(QueryFormulaFilter."Value 1") then
                            this.Log(StrSubstNo('QFM: Query formula filter has invalid special formula name.', QueryFormulaFilter."Value 1"))
                        else
                            Value1 := SpecialFormulaManagement.ExecuteSpecialFormula(QueryFormulaFilter."Value 1")
                End;

                if QueryFormulaFilter."Filter Type" = "Filter Type TPE"::Between then
                    Case QueryFormulaFilter."Value 2 Type" of
                        "Value Type TPE"::Const:
                            Value2 := QueryFormulaFilter."Value 2";
                        "Value Type TPE"::FormulaParameter:
                            if (QueryFormulaFilter."Value 2" = '') or not this.GetParameterValue(QueryFormulaFilter."Value 2", Value2) then
                                this.Log(StrSubstNo('QFM: Query formula filter has empty or invalid parameter name.', QueryFormulaFilter."Value 2"));
                        "Value Type TPE"::SpecialFormula:
                            if (QueryFormulaFilter."Value 2" = '') or not SpecialFormula.Get(QueryFormulaFilter."Value 2") then
                                this.Log(StrSubstNo('QFM: Query formula filter has invalid special formula name.', QueryFormulaFilter."Value 2"))
                            else
                                Value2 := SpecialFormulaManagement.ExecuteSpecialFormula(QueryFormulaFilter."Value 2")
                    End;

                Case QueryFormulaFilter."Filter Type" of
                    "Filter Type TPE"::"Less Than":
                        FieldRef.SetFilter('<%1', Value1);
                    "Filter Type TPE"::"Less Than or Equal":
                        FieldRef.SetFilter('<=%1', Value1);
                    "Filter Type TPE"::"Equal":
                        FieldRef.SetRange(Value1);
                    "Filter Type TPE"::"Greater Than":
                        FieldRef.SetFilter('>%1', Value1);
                    "Filter Type TPE"::"Greater Than or Equal":
                        FieldRef.SetFilter('>=%1', Value1);
                    "Filter Type TPE"::"Between":
                        FieldRef.SetRange(Value1, Value2);
                    "Filter Type TPE"::Filter:
                        FieldRef.SetFilter(Value1);
                End;
            until QueryFormulaFilter.Next() = 0;

        case QueryFormula."Query Type" of
            "Query Type TPE"::Count:
                Result := Format(RecRef.Count(), 0, 9);
            "Query Type TPE"::First:
                if not RecRef.FindFirst() then begin
                    this.Log(StrSubstNo('QFM: No records found for query formula with code %1, for the table %2.', QueryFormulaCode, QueryFormula."Table ID"));
                    exit;
                end;
            "Query Type TPE"::Last:
                if not RecRef.FindLast() then begin
                    this.Log(StrSubstNo('QFM: No records found for query formula with code %1, for the table %2.', QueryFormulaCode, QueryFormula."Table ID"));
                    exit;
                end;
            "Query Type TPE"::Min,
            "Query Type TPE"::Max,
            "Query Type TPE"::Sum,
            "Query Type TPE"::Average,
            "Query Type TPE"::List:
                if not RecRef.FindSet() then begin
                    this.Log(StrSubstNo('QFM: No records found for query formula with code %1, for the table %2.', QueryFormulaCode, QueryFormula."Table ID"));
                    exit;
                end;
        end;

        if (QueryFormula."Field ID" = 0) or not Field.Get(QueryFormula."Table ID", QueryFormula."Field ID") then begin
            this.Log(StrSubstNo('QFM: Query formula with code %1 has invalid field ID.', QueryFormulaCode));
            exit;
        end;

        fieldRef := RecRef.Field(QueryFormula."Field ID");

        case QueryFormula."Query Type" of
            "Query Type TPE"::First:
                Result := Format(fieldRef.Value, 0, 9);
            "Query Type TPE"::Last:
                Result := Format(fieldRef.Value, 0, 9);
            "Query Type TPE"::Min:
                repeat
                    if Format(fieldRef.Value, 0, 9) < Result then
                        Result := Format(fieldRef.Value, 0, 9);
                until RecRef.Next() = 0;
            "Query Type TPE"::Max:
                repeat
                    if Format(fieldRef.Value, 0, 9) > Result then
                        Result := Format(fieldRef.Value, 0, 9);
                until RecRef.Next() = 0;
            "Query Type TPE"::Sum:
                begin
                    if not (FieldRef.Type in [FieldType::Integer, FieldType::BigInteger, FieldType::Decimal, FieldType::Duration]) then begin
                        this.Log(StrSubstNo('QFM: Query formula with code %1 has invalid field type for Sum query type.', QueryFormulaCode));
                        exit;
                    end;

                    repeat
                        Evaluate(DecimalValue, fieldRef.Value);
                        DecimalResult += DecimalValue;
                    until RecRef.Next() = 0;

                    Result := Format(DecimalResult, 0, 9);
                end;
            "Query Type TPE"::Average:
                begin
                    if not (FieldRef.Type in [FieldType::Integer, FieldType::BigInteger, FieldType::Decimal, FieldType::Duration]) then begin
                        this.Log(StrSubstNo('QFM: Query formula with code %1 has invalid field type for Average query type.', QueryFormulaCode));
                        exit;
                    end;

                    repeat
                        Evaluate(DecimalValue, fieldRef.Value);
                        DecimalResult += DecimalValue;
                        Counter += 1;
                    until RecRef.Next() = 0;

                    if Counter > 0 then
                        Result := Format(DecimalResult / Counter, 0, 9);
                end;
            "Query Type TPE"::List:
                repeat
                    if Result = '' then
                        Result := Format(fieldRef.Value, 0, 9)
                    else
                        Result += ',' + Format(fieldRef.Value, 0, 9);
                until RecRef.Next() = 0;
        end;
    end;

    local procedure Log(LogMessage: Text)
    begin
        gQueryExecutionLog.Init();
        gQueryExecutionLog.Message := CopyStr(LogMessage, 1, 2048);
        gQueryExecutionLog.Insert();
    end;

    local procedure GetParameterValue(ParameterName: Code[20]; var ParameterValue: Text) Result: Boolean
    begin
        if gQueryFormulaParameters.Get(ParameterName, ParameterValue) then
            exit(true);
    end;
}