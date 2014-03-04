using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.Security;
using System.Net;
using System.Collections;

public partial class ADMIN_Rettigheder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(Session["UserPermissions"] != null)
        {
            ArrayList UserPermissionArr = (ArrayList)Session["UserPermissions"];
            if (!UserPermissionArr.Contains("AdminRettigheder"))
                Response.Redirect("Brugere.aspx");
        }
    }

    //Check om en given rolle har en given rettighed
    #region Rettighedscheck
    protected bool HasRight(object EvalIndhold)
    {
        string Indhold = EvalIndhold.ToString();
        if (String.IsNullOrWhiteSpace(Indhold))
            return false;
        else
            return true;
    }
    #endregion

    //Tilføj rettighed til given rolle
    protected void LinkButtonTilfoej_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        int RolleId = Convert.ToInt32(GridViewRoller.SelectedValue);
        string FunktionId = btn.CommandArgument;
        //opret et SqlCommand object
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand("INSERT INTO RollerFunktioner VALUES (@RolleId, @FunktionId)", conn);
        cmd.Parameters.Add("@RolleId", SqlDbType.NVarChar).Value = RolleId;
        cmd.Parameters.Add("@FunktionId", SqlDbType.NVarChar).Value = FunktionId;

        // åben forbindelsen til databasen
        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
        GridViewRoller.DataBind();
        FormViewRolle.DataBind();
    }

    //Fjern rettighed fra given rolle
    protected void LinkButtonFjern_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        int RolleId = Convert.ToInt32(GridViewRoller.SelectedValue);
        string FunktionId = btn.CommandArgument;
        //opret et SqlCommand object
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand("DELETE FROM RollerFunktioner WHERE (FkRolleId = @RolleId AND FkFunktionerId = @FunktionId)", conn);
        cmd.Parameters.Add("@RolleId", SqlDbType.NVarChar).Value = RolleId;
        cmd.Parameters.Add("@FunktionId", SqlDbType.NVarChar).Value = FunktionId;

        // åben forbindelsen til databasen
        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
        GridViewRoller.DataBind();
        FormViewRolle.DataBind();
    }
}