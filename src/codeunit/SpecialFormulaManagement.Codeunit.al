codeunit 51100 "Special Formula Management TPE"
{
    procedure GetSpecialFormulas(var SpecialFormula: Record "Special Formula TPE")
    begin
        SpecialFormula.Reset();
        SpecialFormula.DeleteAll();

        SpecialFormula.Init();
        SpecialFormula."Code" := 'TODAY';
        SpecialFormula.Description := 'Today''s date';
        SpecialFormula.Insert();

        SpecialFormula.Init();
        SpecialFormula."Code" := 'WORKDATE';
        SpecialFormula.Description := 'Work Date';
        SpecialFormula.Insert();

        SpecialFormula.Init();
        SpecialFormula."Code" := 'USERID';
        SpecialFormula.Description := 'Current User ID';
        SpecialFormula.Insert();

        SpecialFormula.Init();
        SpecialFormula."Code" := 'USERGUID';
        SpecialFormula.Description := 'Current User Security ID';
        SpecialFormula.Insert();

        SpecialFormula.Init();
        SpecialFormula."Code" := 'COMPANYNAME';
        SpecialFormula.Description := 'Current Company Name';
        SpecialFormula.Insert();

        SpecialFormula.Init();
        SpecialFormula."Code" := 'COMPANYGUID';
        SpecialFormula.Description := 'Current Company GUID';
        SpecialFormula.Insert();

        this.OnGetSpecialFormulas(SpecialFormula);
    end;

    procedure ExecuteSpecialFormula(SpecialFormulaCode: Code[20]) Result: Text
    var
        IsHandled: Boolean;
    begin
        this.OnBeforeExecuteSpecialFormula(SpecialFormulaCode, Result, IsHandled);

        if IsHandled then
            exit;

        case SpecialFormulaCode of
            'TODAY':
                begin
                    Result := Format(Today(), 0, 9);
                    exit;
                end;
            'WORKDATE':
                begin
                    Result := Format(WorkDate(), 0, 9);
                    exit;
                end;
            'USERID':
                begin
                    Result := Format(UserId(), 0, 9);
                    exit;
                end;
            'USERGUID':
                begin
                    Result := Format(UserSecurityId(), 0, 9);
                    exit;
                end;
            'COMPANYNAME':
                begin
                    Result := Format(CompanyName, 0, 9);
                    exit;
                end;
            'COMPANYGUID':
                begin
                    Result := Format(CompanyProperty.ID(), 0, 9);
                    exit;
                end;
        end;

        this.OnAfterExecuteSpecialFormula(SpecialFormulaCode, Result, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetSpecialFormulas(var SpecialFormula: Record "Special Formula TPE")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExecuteSpecialFormula(SpecialFormulaCode: Code[20]; var Result: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterExecuteSpecialFormula(SpecialFormulaCode: Code[20]; var Result: Text; var IsHandled: Boolean)
    begin
    end;
}