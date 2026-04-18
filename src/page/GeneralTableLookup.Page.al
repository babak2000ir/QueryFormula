page 51111 "General Table Lookup TPE"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    SourceTable = "General Table Buffer TPE";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Field1; Rec.Field1)
                {
                    ApplicationArea = All;
                    Visible = Field1Visiblity;
                }
                field(Field2; Rec.Field2)
                {
                    ApplicationArea = All;
                    Visible = Field2Visiblity;
                }
                field(Field3; Rec.Field3)
                {
                    ApplicationArea = All;
                    Visible = Field3Visiblity;
                }
                field(Field4; Rec.Field4)
                {
                    ApplicationArea = All;
                    Visible = Field4Visiblity;
                }
                field(Field5; Rec.Field5)
                {
                    ApplicationArea = All;
                    Visible = Field5Visiblity;
                }
                field(Field6; Rec.Field6)
                {
                    ApplicationArea = All;
                    Visible = Field6Visiblity;
                }
                field(Field7; Rec.Field7)
                {
                    ApplicationArea = All;
                    Visible = Field7Visiblity;
                }
                field(Field8; Rec.Field8)
                {
                    ApplicationArea = All;
                    Visible = Field8Visiblity;
                }
                field(Field9; Rec.Field9)
                {
                    ApplicationArea = All;
                    Visible = Field9Visiblity;
                }
                field(Field10; Rec.Field10)
                {
                    ApplicationArea = All;
                    Visible = Field10Visiblity;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(First)
            {
                ApplicationArea = All;
                Caption = 'First';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Moves the selection to the first record.';

                trigger OnAction();
                begin
                    pageIndex := 1;
                    LoadPageForRecRef();
                end;
            }
            action(Previous)
            {
                ApplicationArea = All;
                Caption = 'Previous';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Moves the selection to the previous record.';

                trigger OnAction();
                begin
                    if PageIndex = 1 then begin
                        PageNotification.Message('First Page');
                        PageNotification.Send();
                        exit;
                    end;
                    pageIndex -= 1;
                    LoadPageForRecRef();
                end;
            }
            action("Next")
            {
                ApplicationArea = All;
                Caption = 'Next';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Moves the selection to the next record.';

                trigger OnAction();
                begin
                    if PageIndex > NumOfPages - 1 then begin
                        PageNotification.Message('Last Page');
                        PageNotification.Send();
                        exit;
                    end;
                    PageIndex += 1;
                    LoadPageForRecRef();
                end;
            }
            action(Last)
            {
                ApplicationArea = All;
                Caption = 'Last';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Moves the selection to the last record.';

                trigger OnAction();
                begin
                    PageIndex := NumOfPages;
                    LoadPageForRecRef();
                end;
            }
        }
    }

    var
        Math: Codeunit Math;
        PageNotification: Notification;
        RecRefSource: RecordRef;
        Field1Visiblity: Boolean;
        Field2Visiblity: Boolean;
        Field3Visiblity: Boolean;
        Field4Visiblity: Boolean;
        Field5Visiblity: Boolean;
        Field6Visiblity: Boolean;
        Field7Visiblity: Boolean;
        Field8Visiblity: Boolean;
        Field9Visiblity: Boolean;
        Field10Visiblity: Boolean;
        PerPage: Integer;
        PageIndex: Integer;
        NumOfPages: Integer;
        FieldCount: Integer;


    procedure LoadData(tableNo: Integer; Value: Text[250])
    begin
        Clear(Rec);
        InitUI();

        PageIndex := 1;
        PerPage := 25;

        if tableNo = 0 then
            exit;

        RecRefSource.Open(tableNo);
        FieldCount := this.Math.Min(RecRefSource.FieldCount, 10);
        NumOfPages := (RecRefSource.Count() div PerPage) + 1;

        SetUI();
        LoadPageForRecRef();

        if Rec.FindFirst() then;
        if Value <> '' then
            if Rec.FindSet() then
                repeat
                    if Rec.Field1 = Value then
                        break;
                until Rec.Next() = 0;
    end;

    procedure LoadData(EnumOptions: Text[2047]; Value: Text[250])
    begin
        Clear(Rec);
        InitUI();

        PageIndex := 1;
        PerPage := 99;

        FieldCount := 2;
        NumOfPages := 1;

        SetUI();
        LoadPageForOption(EnumOptions);

        if Rec.FindFirst() then;
        if Value <> '' then
            if Rec.FindSet() then
                repeat
                    if Rec.Field2 = Value then
                        break;
                until Rec.Next() = 0;
    end;

    local procedure InitUI()
    begin
        Field1Visiblity := false;
        Field2Visiblity := false;
        Field3Visiblity := false;
        Field4Visiblity := false;
        Field5Visiblity := false;
        Field6Visiblity := false;
        Field7Visiblity := false;
        Field8Visiblity := false;
        Field9Visiblity := false;
        Field10Visiblity := false;
    end;

    local procedure SetUI()
    begin
        Field1Visiblity := true;
        Field2Visiblity := FieldCount >= 2;
        Field3Visiblity := FieldCount >= 3;
        Field4Visiblity := FieldCount >= 4;
        Field5Visiblity := FieldCount >= 5;
        Field6Visiblity := FieldCount >= 6;
        Field7Visiblity := FieldCount >= 7;
        Field8Visiblity := FieldCount >= 8;
        Field9Visiblity := FieldCount >= 9;
        Field10Visiblity := FieldCount >= 10;
    end;

    local procedure LoadPageForRecRef()
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldRefSource: FieldRef;
        Counter: Integer;
        FieldCounter: Integer;
    begin
        Counter := 0;
        Clear(Rec);
        Rec.DeleteAll();

        if not RecRefSource.FindFirst() then
            exit;

        if PageIndex > 1 then
            RecRefSource.Next((PageIndex - 1) * PerPage);

        RecRef.GetTable(Rec);

        repeat
            Counter += 1;

            FieldRef := RecRef.FieldIndex(1);
            FieldRef.Value(Counter);

            for FieldCounter := 1 to FieldCount do begin
                FieldRefSource := RecRefSource.FieldIndex(FieldCounter);
                FieldRef := RecRef.FieldIndex(FieldCounter + 1);
                FieldRef.Value(Format(FieldRefSource.Value(), 0, 9));
            end;

            RecRef.Insert();
        until (RecRefSource.Next() = 0) or (Counter >= PerPage);
    end;

    local procedure LoadPageForOption(EnumOptions: Text[2047])
    var
        Counter: Integer;
        EnumOptionsList: List of [Text];
    begin
        Counter := 1;
        Clear(Rec);
        Rec.DeleteAll();

        if EnumOptions = '' then
            exit;

        EnumOptionsList := EnumOptions.Split(',');

        if EnumOptionsList.Count() = 0 then
            exit;

        for Counter := 1 to EnumOptionsList.Count() do begin
            Rec.Init();
            Rec."Entry No." := Counter;
            Rec.Field1 := Format(Counter - 1, 0, 9);
            Rec.Field2 := CopyStr(EnumOptionsList.Get(Counter), 1, 250);
            Rec.Insert();
        end;
    end;
}