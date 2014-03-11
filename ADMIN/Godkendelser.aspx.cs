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

public partial class ADMIN_Godkendelser : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserPermissions"] != null)
        {
            ArrayList UserPermissionArr = (ArrayList)Session["UserPermissions"];
            if (!UserPermissionArr.Contains("AdminRettigheder"))
                Response.Redirect("Brugere.aspx");
        }
    }
    protected void LinkButtonGodkend_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string EventId = btn.CommandArgument;
        ApproveDeny("UPDATE Events SET Godkendt = 1 WHERE Id = @Id", EventId);
    }

    protected void LinkButtonSlet_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string eventId = btn.CommandArgument;
        ApproveDeny("UPDATE Events SET Slettet = 1 WHERE Id = @Id", eventId);
    }

    protected void ApproveDeny(string Command, string Id)
    {
        //opret et SqlCommand object
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand(Command, conn);
        cmd.Parameters.Add("@Id", SqlDbType.NVarChar).Value = Id;

        // åben forbindelsen til databasen
        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
        GridViewEvents.DataBind();
    }
}