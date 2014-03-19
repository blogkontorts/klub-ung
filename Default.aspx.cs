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

    }
    protected string Truncate(int Length, object EvalIndhold)
    {
        string Indhold = EvalIndhold.ToString();
        if (Indhold.Length > Length)
            Indhold = Indhold.Substring(0, Length) + "...";
        return Indhold;
    }
}