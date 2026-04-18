codeunit 51102 "Query Formula Management TPE"
{
    var
        gQueryExecutionLog: Record "Query Execution Log TPE" temporary;
        gQueryFormulaParameters: Dictionary of [Code[20], Text];

    procedure GetLogger(var QueryExecutionLog: Record "Query Execution Log TPE" temporary)
    begin
        gQueryExecutionLog.Reset();
        if gQueryExecutionLog.FindSet() then
            repeat
                QueryExecutionLog.Insert(gQueryExecutionLog.Message);
            until gQueryExecutionLog.Next() = 0;
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
                        if QueryFormulaFilter."Value 1" = '' then
                            this.Log(StrSubstNo('QFM: Query formula filter has empty value 1.', QueryFormulaFilter."Field ID"))
                        else
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
                            if QueryFormulaFilter."Value 2" = '' then
                                this.Log(StrSubstNo('QFM: Query formula filter has empty value 2 for Between filter type.', QueryFormulaFilter."Field ID"))
                            else
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
                        SetFilterWithType(FieldRef, '<%1', Value1);
                    "Filter Type TPE"::"Less Than or Equal":
                        SetFilterWithType(FieldRef, '<=%1', Value1);
                    "Filter Type TPE"::"Equal":
                        SetFilterWithType(FieldRef, '=%1', Value1);
                    "Filter Type TPE"::"Greater Than":
                        SetFilterWithType(FieldRef, '>%1', Value1);
                    "Filter Type TPE"::"Greater Than or Equal":
                        SetFilterWithType(FieldRef, '>=%1', Value1);
                    "Filter Type TPE"::"Between":
                        SetFilterWithType(FieldRef, '>=%1&<=%2', Value1, Value2);
                    "Filter Type TPE"::Filter:
                        SetFilterWithType(FieldRef, Value1);
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
        gQueryExecutionLog.Insert(LogMessage)
    end;

    local procedure GetParameterValue(ParameterName: Code[20]; var ParameterValue: Text) Result: Boolean
    begin
        if gQueryFormulaParameters.Get(ParameterName, ParameterValue) then
            exit(true);
    end;

    local procedure SetFilterWithType(FieldRef: FieldRef; Filter: Text)
    begin
        if FieldRef.Type = FieldType::BLOB then begin
            this.Log(StrSubstNo('QFM: Cannot set filter on BLOB field %1.', FieldRef.Name));
            exit;
        end;

        FieldRef.SetFilter(Filter);
    end;

    local procedure SetFilterWithType(FieldRef: FieldRef; Filter: Text; Value1: Text)
    var
        RecordIdValue: RecordID;
        BigIntegerValue: BigInteger;
        BooleanValue: Boolean;
        DateValue: Date;
        DateTimeValue: DateTime;
        DecimalValue: Decimal;
        DurationValue: Duration;
        GuidValue: Guid;
        IntegerValue: Integer;
        TimeValue: Time;
    begin
        case FieldRef.Type of
            FieldRef.Type::TableFilter:
                FieldRef.SetFilter(Filter, Value1);
            FieldRef.Type::RecordID:
                begin
                    if not Evaluate(RecordIdValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid RecordID value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, RecordIdValue);
                end;
            FieldRef.Type::Date:
                begin
                    if not Evaluate(DateValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid Date value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DateValue);
                end;
            FieldRef.Type::Time:
                begin
                    if not Evaluate(TimeValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid Time value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, TimeValue);
                end;
            FieldRef.Type::DateFormula:
                FieldRef.SetFilter(Filter, Value1);
            FieldRef.Type::Decimal:
                begin
                    if not Evaluate(DecimalValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid Decimal value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DecimalValue);
                end;
            FieldRef.Type::Media:
                FieldRef.SetFilter(Filter, Value1);
            FieldRef.Type::MediaSet:
                FieldRef.SetFilter(Filter, Value1);
            FieldRef.Type::Text:
                FieldRef.SetFilter(Filter, Value1);
            FieldRef.Type::Code:
                FieldRef.SetFilter(Filter, Value1);
            FieldRef.Type::BLOB:
                this.Log(StrSubstNo('QFM: Cannot set filter on BLOB field %1.', FieldRef.Name));
            FieldRef.Type::Boolean:
                begin
                    if not Evaluate(BooleanValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid Boolean value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, BooleanValue);
                end;
            FieldRef.Type::Integer:
                begin
                    if not Evaluate(IntegerValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid Integer value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, IntegerValue);
                end;
            FieldRef.Type::Option:
                begin
                    IntegerValue := FieldRef.OptionMembers.Split(',').IndexOf(Value1);

                    if IntegerValue = 0 then begin
                        this.Log(StrSubstNo('QFM: Invalid Option value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, IntegerValue - 1);
                end;
            FieldRef.Type::BigInteger:
                begin
                    if not Evaluate(BigIntegerValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid BigInteger value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, BigIntegerValue);
                end;
            FieldRef.Type::Duration:
                begin
                    if not Evaluate(DurationValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid Duration value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DurationValue);
                end;
            FieldRef.Type::GUID:
                begin
                    if not Evaluate(GuidValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid GUID value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, GuidValue);
                end;
            FieldRef.Type::DateTime:
                begin
                    if not Evaluate(DateTimeValue, Value1) then begin
                        this.Log(StrSubstNo('QFM: Invalid DateTime value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DateTimeValue);
                end;
        end;
    end;

    local procedure SetFilterWithType(FieldRef: FieldRef; Filter: Text; Value1: Text; Value2: Text)
    var
        RecordIdValue1: RecordID;
        RecordIdValue2: RecordID;
        BigIntegerValue1: BigInteger;
        BigIntegerValue2: BigInteger;
        BooleanValue1: Boolean;
        BooleanValue2: Boolean;
        DateValue1: Date;
        DateValue2: Date;
        DateTimeValue1: DateTime;
        DateTimeValue2: DateTime;
        DecimalValue1: Decimal;
        DecimalValue2: Decimal;
        DurationValue1: Duration;
        DurationValue2: Duration;
        GuidValue1: Guid;
        GuidValue2: Guid;
        IntegerValue1: Integer;
        IntegerValue2: Integer;
        TimeValue1: Time;
        TimeValue2: Time;
    begin
        case FieldRef.Type of
            FieldRef.Type::TableFilter:
                FieldRef.SetFilter(Filter, Value1, Value2);
            FieldRef.Type::RecordID:
                begin
                    if not Evaluate(RecordIdValue1, Value1) or not Evaluate(RecordIdValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid RecordID value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, RecordIdValue1, RecordIdValue2);
                end;
            FieldRef.Type::Date:
                begin
                    if not Evaluate(DateValue1, Value1) or not Evaluate(DateValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid Date value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DateValue1, DateValue2);
                end;
            FieldRef.Type::Time:
                begin
                    if not Evaluate(TimeValue1, Value1) or not Evaluate(TimeValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid Time value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, TimeValue1, TimeValue2);
                end;
            FieldRef.Type::DateFormula:
                FieldRef.SetFilter(Filter, Value1);
            FieldRef.Type::Decimal:
                begin
                    if not Evaluate(DecimalValue1, Value1) or not Evaluate(DecimalValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid Decimal value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DecimalValue1, DecimalValue2);
                end;
            FieldRef.Type::Media:
                FieldRef.SetFilter(Filter, Value1, Value2);
            FieldRef.Type::MediaSet:
                FieldRef.SetFilter(Filter, Value1, Value2);
            FieldRef.Type::Text:
                FieldRef.SetFilter(Filter, Value1, Value2);
            FieldRef.Type::Code:
                FieldRef.SetFilter(Filter, Value1, Value2);
            FieldRef.Type::BLOB:
                this.Log(StrSubstNo('QFM: Cannot set filter on BLOB field %1.', FieldRef.Name));
            FieldRef.Type::Boolean:
                begin
                    if not Evaluate(BooleanValue1, Value1) or not Evaluate(BooleanValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid Boolean value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, BooleanValue1, BooleanValue2);
                end;
            FieldRef.Type::Integer:
                begin
                    if not Evaluate(IntegerValue1, Value1) or not Evaluate(IntegerValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid Integer value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, IntegerValue1, IntegerValue2);
                end;
            FieldRef.Type::Option:
                begin
                    IntegerValue1 := FieldRef.OptionMembers.Split(',').IndexOf(Value1);
                    IntegerValue2 := FieldRef.OptionMembers.Split(',').IndexOf(Value2);

                    if (IntegerValue1 = 0) or (IntegerValue2 = 0) then begin
                        this.Log(StrSubstNo('QFM: Invalid Option value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, IntegerValue1 - 1, IntegerValue2 - 1);
                end;
            FieldRef.Type::BigInteger:
                begin
                    if not Evaluate(BigIntegerValue1, Value1) or not Evaluate(BigIntegerValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid BigInteger value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, BigIntegerValue1, BigIntegerValue2);
                end;
            FieldRef.Type::Duration:
                begin
                    if not Evaluate(DurationValue1, Value1) or not Evaluate(DurationValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid Duration value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DurationValue1, DurationValue2);
                end;
            FieldRef.Type::GUID:
                begin
                    if not Evaluate(GuidValue1, Value1) or not Evaluate(GuidValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid GUID value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, GuidValue1, GuidValue2);
                end;
            FieldRef.Type::DateTime:
                begin
                    if not Evaluate(DateTimeValue1, Value1) or not Evaluate(DateTimeValue2, Value2) then begin
                        this.Log(StrSubstNo('QFM: Invalid DateTime value for field %1.', FieldRef.Name));
                        exit;
                    end;
                    FieldRef.SetFilter(Filter, DateTimeValue1, DateTimeValue2);
                end;
        end;
    end;
}