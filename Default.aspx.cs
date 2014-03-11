using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        test.Text = Session["lat"].ToString();
        test.Text += Session["long"].ToString(); 
        test.Text += Session["address"].ToString();
    }
}