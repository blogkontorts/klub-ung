using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
}