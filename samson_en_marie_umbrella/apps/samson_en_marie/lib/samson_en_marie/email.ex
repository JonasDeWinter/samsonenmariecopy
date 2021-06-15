defmodule SamsonEnMarie.Email do
  use Bamboo.Phoenix, view: SamsonEnMarieWeb.LayoutView
  require Translations.Gettext
  @title_verification "Email verification for our website"

  def email_verification(user, conn) do

    new_email()
    |> from("sam.jacobs@gmail.com")
    |> to(user.email)
    |> subject(Translations.Gettext.gettext(@title_verification))
    |> put_html_layout({SamsonEnMarieWeb.LayoutView, "mail_template.html"})
    |> assign(:user, user)
    |> assign(:conn, conn)
    |> render("verification_email.html")
  end

  def betalingsmail(user, conn, products) do
    new_email()
    |> from("sam.jacobs@gmail.com")
    |> to(user.email)
    |> subject("bevestiging van uw bestelling")
    |> put_html_layout({SamsonEnMarieWeb.LayoutView, "mail_template.html"})
    |> assign(:user, user)
    |> assign(:products, products)
    |> assign(:conn, conn)
    |> render("betaling_mail.html")
  end

end
