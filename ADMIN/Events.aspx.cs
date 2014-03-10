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
using System.Drawing.Imaging;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Collections;

public partial class ADMIN_Events : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (GetRights().Contains("Bypass"))
            {
                Session["Bypass"] = "1";
            }
            if (GetRights().Contains("AdminEvents"))
            {
                PanelAdminView.Visible = true;
                PanelUserView.Visible = false;
            }
        }
        catch
        {
            Response.Redirect("../login.aspx");
        }
    }

    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    Validering Validator = new Validering();

    //Hjælpemetode til at hente en given brugers rettigheder
    //Return: ArrayList m. rettigheder
    protected ArrayList GetRights()
    {
        ArrayList UserPermissionArr = (ArrayList)Session["UserPermissions"];
        return UserPermissionArr;
    }


    //Opdaterer gridviews ved ændringer
    protected void OnSqlChanged(Object source, SqlDataSourceStatusEventArgs e)
    {
        if(GetRights().Contains("AdminEvents"))
            GridViewEvents.DataBind();
        else
            GridViewEgneEvents.DataBind();
    }

    //Check om en given event er godkendt eller ej
    //Return: Bool
    protected bool IsApproved(object Eval)
    {
        return Convert.ToBoolean(Eval);
    }

    //Godkender en event
    //Return: Void
    protected void LinkButtonGodkend_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string Id = btn.CommandArgument;
        ApproveDeny("1", Id);
    }

    //Sætter en event til ikke-godkendt
    //Return: Void
    protected void LinkButtonAfvis_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string Id = btn.CommandArgument;
        ApproveDeny("0", Id);
    }

    //Hjælpemetode til at godkende/afvise en event
    //Return: Void
    //Input: string Bin - Binær: Godkendes eller afvises
    //       string Id - Id'et på eventen der skal godkendes eller afvises
    protected void ApproveDeny(string Bin, string Id)
    {
        //opret et SqlCommand object
        SqlCommand cmd = new SqlCommand("UPDATE Events SET Godkendt = @Bin WHERE Id = @Id", conn);
        cmd.Parameters.Add("@Id", SqlDbType.NVarChar).Value = Id;
        cmd.Parameters.Add("@Bin", SqlDbType.NVarChar).Value = Bin;

        // åben forbindelsen til databasen
        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
        GridViewEvents.DataBind();
        FormViewEventDetaljer.DataBind();
    }

    //---------------------------------------Tilføj event
    #region Tilføj event
    protected void ButtonAddEvent_Click(object sender, EventArgs e)
    {
        if (GetRights().Contains("AdminEvents"))
            FormViewEventDetaljer.ChangeMode(FormViewMode.Insert);
        else
            FormViewEgenEventDetaljer.ChangeMode(FormViewMode.Insert);
    }

    protected void SqlDataSourceEventDetaljer_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        FileUpload FileControl = FormViewEventDetaljer.FindControl("FileUploadInsertEventImg") as FileUpload;
        if (FileControl.HasFile)
        {
            // Gem filer
            string NytFilnavn = GemOgResize(FileControl);
            // Opdater SqlDataSourcens parametre så det Nye filnavn skrives i databasen
            e.Command.Parameters["@Img"].Value = NytFilnavn;
        }

        //Hjælper til at sikre ordentligt input til datoer
        TextBox StartDato = FormViewEventDetaljer.FindControl("TextBoxFra") as TextBox;
        e.Command.Parameters["@StartDato"].Value = DateTime.Parse(StartDato.Text);

        TextBox SlutDato = FormViewEventDetaljer.FindControl("TextBoxTil") as TextBox;
        e.Command.Parameters["@SlutDato"].Value = DateTime.Parse(SlutDato.Text);
    }

    protected void SqlDataSourceEgenEvent_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        FileUpload FileControl = FormViewEgenEventDetaljer.FindControl("FileUploadInsertEventImg") as FileUpload;
        if (FileControl.HasFile)
        {
            // Gem filer
            string NytFilnavn = GemOgResize(FileControl);
            // Opdater SqlDataSourcens parametre så det Nye filnavn skrives i databasen
            e.Command.Parameters["@Img"].Value = NytFilnavn;
        }

        //Hjælper til at sikre ordentligt input til datoer
        TextBox StartDato = FormViewEgenEventDetaljer.FindControl("TextBoxFra") as TextBox;
        e.Command.Parameters["@StartDato"].Value = DateTime.Parse(StartDato.Text);

        TextBox SlutDato = FormViewEgenEventDetaljer.FindControl("TextBoxTil") as TextBox;
        e.Command.Parameters["@SlutDato"].Value = DateTime.Parse(SlutDato.Text);

    }
    #endregion

    //---------------------------------------Slet event
    #region Slet event
    protected void SqlDataSourceEventDetaljer_Deleting(object sender, SqlDataSourceCommandEventArgs e)
    {
        // Hent Id på valgt event fra gridviewet og slet filer
        int Id = (int)GridViewEvents.SelectedValue;
        SletFiler(Id);
    }

    protected void SqlDataSourceEgenEvent_Deleting(object sender, SqlDataSourceCommandEventArgs e)
    {
        // Hent Id på valgt avatar fra gridviewet og slet filer
        int Id = (int)GridViewEgneEvents.SelectedValue;
        SletFiler(Id);
    }

    protected void LinkButtonSlet_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender as LinkButton;
        //opret et SqlCommand object
        SqlCommand cmd = new SqlCommand("UPDATE Events SET Slettet = 1 WHERE Id = @Id", conn);
        cmd.Parameters.Add("@Id", SqlDbType.NVarChar).Value = btn.CommandArgument;

        // åben forbindelsen til databasen
        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        SletFiler(Convert.ToInt32(btn.CommandArgument));
        if (GetRights().Contains("AdminEvents"))
            GridViewEvents.DataBind();
        else
            GridViewEgneEvents.DataBind();
    }
    #endregion

    //---------------------------------------Img upload
    #region Img upload
    private string GemOgResize(FileUpload f)
    {
        // Prefix filnavnet med et timestamp og gem filen
        string Tid = DateTime.Now.Ticks.ToString();
        string NytFilnavn = Tid + "_" + f.FileName;
        f.SaveAs(Server.MapPath("../Images/") + NytFilnavn);
        // Kald Metoden MakeThumbs, som laver en Thumbnail og uploader den til Thumbs mappen
        MakeThumb(NytFilnavn, "/Images/", 172, "/Thumbs/");
        return NytFilnavn;
    }

    // Metode der henter filnavnet på en event ud fra dens Id
    private string HentFilNavn(int Id)
    {
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandText = "SELECT [Img] FROM [Events] WHERE [Id] = @id";
        cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
        conn.Open();
        string FilNavn = cmd.ExecuteScalar().ToString();
        conn.Close();
        return FilNavn;
    }

    /// <summary>
    /// Opret et Thumb, baseret på en fil og en mappe
    /// </summary>
    /// <param name="Filename">Hvad hedder filen</param>
    /// <param name="UploadFolder">Hvor er den uploadet til</param>
    private void MakeThumb(string Filename, string UploadFolder, int bredde, string thumbuploadfolder)
    {
        // find det uploadede image
        System.Drawing.Image OriginalImg = System.Drawing.Image.FromFile(Server.MapPath("~/") + UploadFolder + Filename);

        // find højde og bredde på image
        int originalWidth = OriginalImg.Width;
        int originalHeight = OriginalImg.Height;

        // bestem den nye bredde på det thumbnail som skal laves
        int newWidth = bredde;

        // beregn den nye højde på thumbnailbilledet
        double ratio = newWidth / (double)originalWidth;
        int newHeight = Convert.ToInt32(ratio * originalHeight);


        Bitmap Thumb = new Bitmap(newWidth, newHeight, PixelFormat.Format24bppRgb);
        Thumb.SetResolution(OriginalImg.HorizontalResolution, OriginalImg.VerticalResolution);

        // Hvis billedet indeholder nogen form for transperans 
        //(mere eller mindre gennemsigtig, eller en gennemsigtig baggrund) bliver det gjort her
        Thumb.MakeTransparent();


        // opret det nye billede
        Graphics ThumbMaker = Graphics.FromImage(Thumb);
        ThumbMaker.InterpolationMode = InterpolationMode.HighQualityBicubic;

        ThumbMaker.DrawImage(OriginalImg,
            new Rectangle(0, 0, newWidth, newHeight),
            new Rectangle(0, 0, originalWidth, originalHeight),
            GraphicsUnit.Pixel);

        // encoding
        ImageCodecInfo encoder;
        string fileExt = System.IO.Path.GetExtension(Filename);
        switch (fileExt)
        {
            case ".png":
                encoder = GetEncoderInfo("image/png");
                break;

            case ".gif":
                encoder = GetEncoderInfo("image/gif");
                break;

            default:
                // default til JPG 
                encoder = GetEncoderInfo("image/jpeg");
                break;
        }

        EncoderParameters encoderParameters = new EncoderParameters(1);
        encoderParameters.Param[0] = new EncoderParameter(Encoder.Quality, 100L);

        // gem thumbnail i mappen /Images/Uploads/Thumbs/
        Thumb.Save(Server.MapPath("~") + thumbuploadfolder + Filename, encoder, encoderParameters);

        // Fjern originalbilledet, thumbnail mm, fra computerhukommelsen
        OriginalImg.Dispose();
        ThumbMaker.Dispose();
        Thumb.Dispose();

    }

    private static ImageCodecInfo GetEncoderInfo(String mimeType)
    {
        ImageCodecInfo[] encoders = ImageCodecInfo.GetImageEncoders();
        for (int i = 0; i < encoders.Length; i++)
        {
            if (encoders[i].MimeType == mimeType)
            {
                return encoders[i];
            }
        }
        return null;
    }
    #endregion

    //---------------------------------------Update img
    #region update img
    protected void SqlDataSourceEventDetaljer_Updating(object sender, SqlDataSourceCommandEventArgs e)
    {
        //Hjælper til at sikre ordentligt input til datoer
        TextBox StartDatoUpdate = FormViewEventDetaljer.FindControl("TextBoxUpdateFra") as TextBox;
        e.Command.Parameters["@StartDato"].Value = DateTime.Parse(StartDatoUpdate.Text);

        TextBox SlutDatoUpdate = FormViewEventDetaljer.FindControl("TextBoxUpdateTil") as TextBox;
        e.Command.Parameters["@SlutDato"].Value = DateTime.Parse(SlutDatoUpdate.Text);


        // Find ASP:FileUpload og gem den i nyt object
        FileUpload FileUploadController = FormViewEventDetaljer.FindControl("FileUploadUpdateEventImg") as FileUpload;
        // Hent Id på valgt avatar fra gridviewet
        int Id = (int)GridViewEvents.SelectedValue;

        // Der er valgt en ny fil
        if (FileUploadController.HasFile)
        {
            SletFiler(Id);
            // Gem nye filer
            string NytFilnavn = GemOgResize(FileUploadController);
            // Opdater SqlDataSourcens parametre så det Nye filnavn skrives i databasen
            e.Command.Parameters["@Img"].Value = NytFilnavn;


        }
        // Der er ikke valgt en ny fil
        else
        {
            string FilNavn = HentFilNavn(Id);
            // Opdater SqlDataSourcens parametre så det gamle filnavn skrives i databasen
            e.Command.Parameters["@Img"].Value = FilNavn;
        }
    }

    protected void SqlDataSourceEgenEvent_Updating(object sender, SqlDataSourceCommandEventArgs e)
    {
        // Find ASP:FileUpload og gem den i nyt object
        FileUpload FileUploadController = FormViewEgenEventDetaljer.FindControl("FileUploadUpdateEventImg") as FileUpload;
        // Hent Id på valgt avatar fra gridviewet
        int Id = (int)GridViewEgneEvents.SelectedValue;

        // Der er valgt en ny fil
        if (FileUploadController.HasFile)
        {
            SletFiler(Id);
            // Gem nye filer
            string NytFilnavn = GemOgResize(FileUploadController);
            // Opdater SqlDataSourcens parametre så det Nye filnavn skrives i databasen
            e.Command.Parameters["@Img"].Value = NytFilnavn;


        }
        // Der er ikke valgt en ny fil
        else
        {
            string FilNavn = HentFilNavn(Id);
            // Opdater SqlDataSourcens parametre så det gamle filnavn skrives i databasen
            e.Command.Parameters["@Img"].Value = FilNavn;
        }
    }

    #endregion

    //---------------------------------------Slet img
    #region slet img
    private void SletFiler(int Id)
    {
        // Hent filenavn fra database
        string FilNavn = HentFilNavn(Id);
        string noimg = "noimg.jpg";
        if (FilNavn != noimg)
        {
            // slet filer
            File.Delete(Server.MapPath("../Images/" + FilNavn));
            File.Delete(Server.MapPath("../Thumbs/" + FilNavn));
        }
    }
    #endregion  

    //---------------------------------------Tilføj Kategori
    #region Tilføj kategori
    protected void ButtonAddKategori_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrWhiteSpace(TextBoxAddKategori.Text))
        {
            //opret et SqlCommand object
            SqlCommand cmd = new SqlCommand("INSERT INTO Kategori (Navn) VALUES (@Navn)", conn);
            cmd.Parameters.Add("@Navn", SqlDbType.NVarChar).Value = TextBoxAddKategori.Text;

            // åben forbindelsen til databasen
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            GridViewKategorier.DataBind();
            TextBoxAddKategori.Text = "";
        }
        else
            TextBoxAddKategoriMsg.Text = "Skal udfyldes";
    }
    #endregion

    //---------------------------------------Søgning
    #region Søgning + datasource switching
    protected void LinkButtonSearch_Click(object sender, EventArgs e)
    {
        GridViewEvents.DataSourceID = null;
        GridViewEvents.DataSource = SqlDataSourceEventsSearch;
        GridViewEvents.DataBind();
        LinkButtonCancelSearch.Visible = true;
    }
    protected void LinkButtonCancelSearch_Click(object sender, EventArgs e)
    {
        GridViewEvents.DataSourceID = null;
        GridViewEvents.DataSource = SqlDataSourceEvents;
        GridViewEvents.DataBind();
        TextBoxSearch.Text = "";
        LinkButtonCancelSearch.Visible = false;
    }
    #endregion

    //---------------------------------------Validering
    #region Validering
    protected void FormViewEventDetaljer_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        FormView Form = (FormView)sender as FormView;
        Validate(Form, "Insert", e);
        
    }
    protected void FormViewEventDetaljer_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        FormView Form = (FormView)sender as FormView;
        Validate(Form, "Update", e);
    }

    protected void Validate(FormView Form, string Action, dynamic e)
    {
        //Valider unikt navn og at det er udfyldt
        Validator.ValidateUniqeness(Form, "TextBox"+Action+"EventNavn", "Events", "Navn", "Id", e);
        //Valider at adresse er udfyldt
        Validator.ValidateEmpty("TextBox"+Action+"EventAdresse", e, Form);
        //Valider at bynavn er udfyldt
        Validator.ValidateEmpty("TextBox"+Action+"EventBy", e, Form);
        //Valider at postnr er udfyldt og er et tal
        Validator.ValidatePattern("TextBox"+Action+"EventPostnr", e, Form, @"^\d{4}$", "Udfyld et postnummer");
        //Valider at beskrivelsen er udfyldt
        Validator.ValidateEmpty("TextBox"+Action+"EventBeskrivelse", e, Form);
    }
    #endregion
}