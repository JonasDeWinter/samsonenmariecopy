defmodule SamsonEnMarieWeb.SessionController do
  use SamsonEnMarieWeb, :controller
  require Translations.Gettext

  alias SamsonEnMarieWeb.Guardian
  alias SamsonEnMarie.UserContext
  alias SamsonEnMarie.UserContext.User

  @welcome "welcome back"

  def new(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/user_scope")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    UserContext.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, Translations.Gettext.gettext(@welcome))
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/user_scope")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
