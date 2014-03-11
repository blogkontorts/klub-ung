using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

/// <summary>
/// Summary description for Validering
/// </summary>
public class Validering
{
    public void ValidateUniqeness(Control Parent, string ControllerName, string TableName, string ColumnName, string SelfColumnName, object e, int Id = 0)
    {
        int Match;
        TextBox NameController = Parent.FindControl(ControllerName) as TextBox;
        if (!string.IsNullOrWhiteSpace(NameController.Text))
        {
            // Hvis e er at type ...InsertEventArgs bliver metode kaldt fra en insert event, ellers en update event
            if (e.GetType().ToString() == "FormViewInsertEventArgs")
            {
                Match = NumberOfMatches(TableName, ColumnName, NameController.Text);
            }
            else
            {
                Match = NumberOfMatchesWithoutSelf(TableName, ColumnName, SelfColumnName, Id, NameController.Text);
            }
            // Der findes andre med samme navn
            if (Match > 0)
            {
                CancelAndDisplayMessage(Parent, ControllerName, "Navnet er ikke unikt", e);
            }
            else
            {
                RemoveMessage(Parent, ControllerName);
            }
        }
        else
        {
            CancelAndDisplayMessage(Parent, ControllerName, "Skal udfyldes", e);
        }
    }

    public void CancelAndDisplayMessage(Control Parent, string ControllerName, string Message, dynamic e)
    {
        e.Cancel = true;
        string MsgLabel = ControllerName + "Msg";
        (Parent.FindControl(MsgLabel) as Label).Text = Message;
    }

    public void RemoveMessage(Control Parent, string ControllerName)
    {
        (Parent.FindControl(ControllerName + "Msg") as Label).Text = "";
    }

    public int NumberOfMatches(string TableName, string ColumnName, string Content)
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandText = "SELECT COUNT(*) FROM [" + TableName + "] WHERE [" + ColumnName + "] = @content AND Slettet = 0";
        cmd.Parameters.Add("@content", SqlDbType.NVarChar).Value = Content;
        conn.Open();
        int Match = (int)cmd.ExecuteScalar();
        conn.Close();
        return Match;
    }

    //Tæller forekomsten af et givent navn UDEN sig selv (Til at redigere produkter)
    public int NumberOfMatchesWithoutSelf(string TableName, string ColumnName, string SelfColumnName, int Id, string Content)
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandText = "SELECT COUNT(*) FROM [" + TableName + "] WHERE [" + ColumnName + "] = @content AND [" + SelfColumnName + "] != @id AND Slettet = 0";
        cmd.Parameters.Add("@content", SqlDbType.NVarChar).Value = Content;
        cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
        conn.Open();
        int Match = (int)cmd.ExecuteScalar();
        conn.Close();
        return Match;
    }

    //Validerer tomme felter (Som i: Må ikke være tomt)
    public void ValidateEmpty(string ControllerName, dynamic e, FormView FormViewName)
    {
        if (String.IsNullOrWhiteSpace((FormViewName.FindControl(ControllerName) as TextBox).Text))
        {
            CancelAndDisplayMessage(FormViewName, ControllerName, "Skal udfyldes", e);
        }
    }

    //Validerer et pattern (Regular expression)
    public void ValidatePattern(string ControllerName, dynamic e, FormView FormViewName, string Pattern, string Besked)
    {
        TextBox PatternController = FormViewName.FindControl(ControllerName) as TextBox;
        string ControlPattern = Pattern;
        RegexStringValidator PatternValidator = new RegexStringValidator(ControlPattern);
        try
        {
            PatternValidator.Validate(PatternController.Text);
            (FormViewName.FindControl(ControllerName + "Msg") as Label).Text = "";
        }
        catch (ArgumentException)
        {
            e.Cancel = true;
            (FormViewName.FindControl(ControllerName + "Msg") as Label).Text = Besked;
        }
    }

    //Validerer
    protected bool RegexValidate(string Pattern, string Content)
    {
        RegexStringValidator Validator = new RegexStringValidator(Pattern);
        try
        {
            Validator.Validate(Content);
            return true;
        }
        catch (ArgumentException)
        {
            return false;
        }
    }
}