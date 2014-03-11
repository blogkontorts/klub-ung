using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

public partial class location : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }


    // This method is used to convert datatable to json string
    public string ConvertDataTabletoString() {
        DataTable dt = new DataTable();
        using(SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString())) {
            using(SqlCommand cmd = new SqlCommand("SELECT lat,long,Navn,Beskrivelse FROM EventLocation INNER JOIN [Events] ON EventLocation.Id = [Events].FkLokationId", con)) {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                Dictionary<string, object> row;
                foreach(DataRow dr in dt.Rows) {
                    row = new Dictionary<string, object>();
                    foreach(DataColumn col in dt.Columns) {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
                return serializer.Serialize(rows);
            }
        }
    }
    protected void submit_Click(object sender, EventArgs e) {

    }
}