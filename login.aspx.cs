using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class login:System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {

    }

    protected void Button1_Click(object sender, EventArgs e) {

        // opret forbindelsen til databasen
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

        // opret et SqlCommand object
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;


        //SQL-Command
        cmd.CommandText = "SELECT * FROM Brugere WHERE Navn=@Navn AND Passcode=@Passcode AND Slettet = 0";
        cmd.Parameters.Add("@Navn", SqlDbType.NVarChar).Value = UserNameTextB.Text;
        cmd.Parameters.Add("@Passcode", SqlDbType.NVarChar).Value = PasswordTextB.Text;

        // åben forbindelsen til databasen
        conn.Open();

        // opret en SqlDataReader og navngiv den "reader"
        //sqldatareader er et object som kommunikerer med databasen
        // SqlDataReader er en beholder eller tabel der indeholder en kopi af det der er udtrukket fra database
        SqlDataReader reader = cmd.ExecuteReader();
        if(reader.Read()) {
            Session["Id"] = reader["Id"];
            Session["Navn"] = reader["Navn"];
            Session["UserPermissions"] = PermissionArrMet(reader["FkRolleId"].ToString());
            conn.Close();
            Response.Redirect("Default.aspx");
        } else {
            FlashMessage.Visible = true;
            conn.Close();
        }
    }
    private ArrayList PermissionArrMet(string RoleId) {
        // opret forbindelsen til databasen
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

        // opret et SqlCommand object
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;


        //SQL-Command
        cmd.CommandText = @"SELECT
                                Roller.Id, 
                                Roller.Navn, 
                                RollerFunktioner.FkRolleId, 
                                RollerFunktioner.FkFunktionerId, 
                                Funktioner.Id, 
                                Funktioner.Navn,
                                Funktioner.Kode
                            FROM
                                Roller
                            INNER JOIN
                                RollerFunktioner ON Roller.Id = RollerFunktioner.FkRolleId 
                            INNER JOIN
                                Funktioner ON RollerFunktioner.FkFunktionerId = Funktioner.Id
                            WHERE        
                                (Roller.Id = @RolleId)";
        cmd.Parameters.Add("@RolleId", SqlDbType.NVarChar).Value = RoleId;

        // åben forbindelsen til databasen
        conn.Open();

        // opret en SqlDataReader og navngiv den "reader"
        //sqldatareader er et object som kommunikerer med databasen
        // SqlDataReader er en beholder eller tabel der indeholder en kopi af det der er udtrukket fra database
        SqlDataReader reader = cmd.ExecuteReader();
        ArrayList UserPermissionArr = new ArrayList();
        while(reader.Read()) {
            UserPermissionArr.Add(reader["kode"]);
        }
        conn.Close();
        return UserPermissionArr;

    }
    protected void Button2_Click(object sender, EventArgs e) {
        Session["Id"] = "Guest";
        Session["Name"] = "Guest";
        Response.Redirect("Default.aspx");
    }
}