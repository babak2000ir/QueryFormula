page 51110 "Date-Time Dialog TPE"
{
    InherentEntitlements = X;
    InherentPermissions = X;
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field("Date"; DateValue)
            {
                ApplicationArea = All;
                Caption = 'Date';
                ToolTip = 'Specifies the date.';
                Visible = not DateHidden;

                trigger OnValidate()
                begin
                    if TimeValue = 0T then
                        TimeValue := 000000T;
                end;
            }
            field("Time"; TimeValue)
            {
                ApplicationArea = All;
                Caption = 'Time';
                ToolTip = 'Specifies the time of day.';
                Visible = not TimeHidden;
            }
        }
    }


    var
        TimeHidden: Boolean;
        DateHidden: Boolean;
        DateValue: Date;
        TimeValue: Time;

    /// <summary>
    /// Setter method to initialize the Date and Time fields on the page.
    /// </summary>
    /// <param name="DateTime">The value to set.</param>
    procedure SetDateTime(DateTime: DateTime)
    begin
        DateValue := DT2Date(DateTime);
        TimeValue := DT2Time(DateTime);
    end;

    /// <summary>
    /// Getter method for the entered datetime value.
    /// </summary>
    /// <returns>The value that is set on the page.</returns>
    procedure GetDateTime(): DateTime
    begin
        exit(CreateDateTime(DateValue, TimeValue));
    end;


    /// <summary>
    /// Method for hiding the time on the page.
    /// </summary>
    procedure UseDateOnly()
    begin
        TimeHidden := true;
    end;

    /// <summary>
    /// Method for hiding the date on the page.
    /// </summary>
    procedure UseTimeOnly()
    begin
        DateHidden := true;
    end;

    /// <summary>
    /// Setter method to initialize the Date on the page.
    /// </summary>
    /// <param name="NewDate">The value to set.</param>
    procedure SetDate(NewDate: Date)
    begin
        DateValue := NewDate;
    end;

    /// <summary>
    /// Getter method for the entered date value.
    /// </summary>
    /// <returns>The value that is set on the page.</returns>
    procedure GetDate(): Date
    begin
        exit(DateValue);
    end;

    procedure SetTime(NewTime: Time)
    begin
        TimeValue := NewTime;
    end;

    /// <summary>
    /// Setter method to initialize the Time on the page.
    /// </summary>
    /// <returns>The value that is set on the page.</returns>
    procedure GetTime(): Time
    begin
        exit(TimeValue);
    end;
}