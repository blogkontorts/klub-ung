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

public partial class ADMIN_Brugere : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        PanelSearch.DefaultButton = "LinkButtonSearch";
        try
        {
            if (GetRights().Contains("AdminBrugere"))
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
    Validering Validator = new Validering();

    protected ArrayList GetRights()
    {
        ArrayList UserPermissionArr = (ArrayList)Session["UserPermissions"];
        return UserPermissionArr;
    }

    protected void OnSqlChanged(Object source, SqlDataSourceStatusEventArgs e)
    {
        GridViewBrugere.DataBind();
    }

    //---------------------------------------Tilføj bruger
    #region Tilføj bruger
    protected void ButtonAddBruger_Click(object sender, EventArgs e)
    {
        FormViewBrugerDetaljer.ChangeMode(FormViewMode.Insert);
    }
    protected void SqlDataSourceBrugerDetaljer_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        FileUpload FileControl = FormViewBrugerDetaljer.FindControl("FileUploadInsertBrugerImg") as FileUpload;
        if (FileControl.HasFile)
        {
            // Gem filer
            string NytFilnavn = GemOgResize(FileControl);
            // Opdater SqlDataSourcens parametre så det Nye filnavn skrives i databasen
            e.Command.Parameters["@Img"].Value = NytFilnavn;
        }
    }
    #endregion

    //---------------------------------------Slet bruger
    #region Slet bruger
    protected void SqlDataSourceBrugerDetaljer_Deleting(object sender, SqlDataSourceCommandEventArgs e)
    {
        // Hent Id på valgt avatar fra gridviewet og slet filer
        int Id = (int)GridViewBrugere.SelectedValue;
        SletFiler(Id);
    }

    protected void SqlDataSourceFormViewEgenBrugerDetaljer_Deleting(object sender, SqlDataSourceCommandEventArgs e)
    {
        // Hent Id på valgt avatar fra gridviewet og slet filer
        int Id = (int)Session["Id"];
        SletFiler(Id);
    }

    //Redirecter og logger ud når ens egen bruger slettes
    protected void SqlDataSourceEgenBruger_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Session.Abandon();
        Response.Redirect("../login.aspx");
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

    // Metode der henter filnavnet på en avatar ud fra dens Id
    private string HentFilNavn(int Id)
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandText = "SELECT [Img] FROM [Brugere] WHERE [Id] = @id";
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
    protected void SqlDataSourceBrugerDetaljer_Updating(object sender, SqlDataSourceCommandEventArgs e)
    {
        // Find ASP:FileUpload og gem den i nyt object
        FileUpload FileUploadController = FormViewBrugerDetaljer.FindControl("FileUploadUpdateBrugerImg") as FileUpload;
        // Hent Id på valgt avatar fra gridviewet
        int Id = (int)GridViewBrugere.SelectedValue;

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

    protected void SqlDataSourceFormViewEgenBrugerDetaljer_Updating(object sender, SqlDataSourceCommandEventArgs e)
    {
        // Find ASP:FileUpload og gem den i nyt object
        FileUpload FileUploadController = FormViewEgenBruger.FindControl("FileUploadUpdateBrugerImg") as FileUpload;
        // Hent Id på valgt avatar fra gridviewet
        int Id = (int)Session["Id"];

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
    
    //---------------------------------------Søgning
    #region Search + datasource switching
    protected void LinkButtonSearch_Click(object sender, EventArgs e)
    {
        GridViewBrugere.DataSourceID = null;
        GridViewBrugere.DataSource = SqlDataSourceSearch;
        GridViewBrugere.DataBind();
        LinkButtonCancelSearch.Visible = true;
    }
    protected void LinkButtonCancelSearch_Click(object sender, EventArgs e)
    {
        GridViewBrugere.DataSourceID = null;
        GridViewBrugere.DataSource = SqlDataSourceBrugere;
        GridViewBrugere.DataBind();
        TextBoxSearch.Text = "";
        LinkButtonCancelSearch.Visible = false;
    }
    #endregion

    //---------------------------------------Validering
    #region Validering
    protected void FormViewBrugerDetaljer_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        FormView Form = (FormView)sender as FormView;
        Validate(Form, "Insert", e);

    }
    protected void FormViewBrugerDetaljer_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        FormView Form = (FormView)sender as FormView;
        Validate(Form, "Update", e);
    }

    protected void Validate(FormView Form, string Action, dynamic e)
    {
        //Valider unikt navn og at det er udfyldt
        if (GetRights().Contains("AdminEvents"))
        {
            if (e.GetType() == typeof(FormViewInsertEventArgs))
            {
                Validator.ValidateUniqeness(Form, "TextBox" + Action + "BrugerNavn", "Brugere", "Navn", "Id", e);
            }
            else if (e.GetType() == typeof(FormViewUpdateEventArgs))
            {
                Validator.ValidateUniqeness(Form, "TextBox" + Action + "BrugerNavn", "Brugere", "Navn", "Id", e, Convert.ToInt32(GridViewBrugere.SelectedValue));
            }
        }
        else
        {
            Validator.ValidateUniqeness(Form, "TextBox" + Action + "BrugerNavn", "Brugere", "Navn", "Id", e, Convert.ToInt32(Session["Id"]));
        }
        //Valider at password er udfyldt
        Validator.ValidateEmpty("TextBox" + Action + "BrugerPassword", e, Form);
        //Valider at email er udfyldt og er en gyldig email
        Validator.ValidatePattern("TextBox" + Action + "BrugerEmail", e, Form, @"^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$", "Indtast gyldig email");
    }
    #endregion
}