using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;

public partial class ADMIN_AdminMasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList UserPermissionArr = (ArrayList)Session["UserPermissions"];
        if (Session["Id"] == null)
            Response.Redirect("../login.aspx");

        if (UserPermissionArr.Contains("AdminRettigheder"))
            HyperLinkRettigheder.Visible = true;
    }

    protected void ButtonLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("../login.aspx");
    }
}
