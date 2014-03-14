using System;
using System.IO;
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

public partial class ADMIN_Diverse : System.Web.UI.Page
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
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    Validering Validator = new Validering();

    //Oversætter hexkoder til farver så de kan bruges til panelets baggrund
    protected System.Drawing.Color CheckColor(object Eval)
    {
        string Color = Eval.ToString();
        if (string.IsNullOrWhiteSpace(Color))
            return System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
        else
            return System.Drawing.ColorTranslator.FromHtml("#"+Color);
    }
    //-------------------------------------------------------------------------GridViewStyring
    #region GridViewStyring
    protected void GridViewKategorier_DataBound(object sender, EventArgs e)
    {
        GridView Parent = (GridView)sender as GridView;
        HideColumn(Parent, 0);
        HideColumn(Parent, 4);
        ShowColumn(Parent, 3);
    }

    protected void HideColumn(GridView Parent, int Column)
    {
        if (Parent.EditIndex > -1)
            Parent.Columns[Column].Visible = false;
        else
            Parent.Columns[Column].Visible = true;
    }

    protected void ShowColumn(GridView Parent, int Column)
    {
        if (Parent.EditIndex > -1)
            Parent.Columns[Column].Visible = true;
        else
            Parent.Columns[Column].Visible = false;
    }
    #endregion

    protected void FormViewKategori_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        FormView Parent = (FormView)sender as FormView;
        Validator.ValidateEmpty("TextBoxAddKategori", e, Parent);
    }
    protected void GridViewKategorier_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView Parent = (GridView)sender as GridView;
        Validator.ValidateEmpty("TextBoxEditNavn", e, Parent);
    }
}