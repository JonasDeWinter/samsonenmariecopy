defmodule SamsonEnMarieWeb.EmailVerificationController do
  use SamsonEnMarieWeb, :controller
  require Translations.Gettext

  alias SamsonEnMarie.{UserContext, Mailer, Email}

  @email_validated "your email has been validated"
  @token_expired "validation token expired check new email"
  def new(conn, _params) do
    render(conn, "new.html")
  end



  def update(conn, %{"verification_token" => token}) do
    user = UserContext.get_user_from_token(token)




    with true <- UserContext.valid_token?(user.verification_token_sent_at) do
        UserContext.validate_user(user)
         conn
         |> put_flash(:info, Translations.Gettext.gettext(@email_validated))
         |> redirect(to: Routes.session_path(conn, :new))

    else
      false ->
        send_verification_mail(user, conn)
        conn
        |> put_flash(:error, Translations.Gettext.gettext(@token_expired))
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  defp send_verification_mail(user, conn) do
    Email.email_verification(user, conn) |> Mailer.deliver_now()
  end

end
