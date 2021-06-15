defmodule SamsonEnMarieWeb.UserController do
  use SamsonEnMarieWeb, :controller
  require Translations.Gettext

  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.{Mailer, Email, UserContext}
  alias SamsonEnMarieWeb.WinkelkarController
  alias SamsonEnMarie.Repo


  @user_creation "User created successfully."
  @user_updated "User updated successfully."
  @user_deleted "user deleted successfully."

  def index(conn, _params) do
    users = UserContext.list_users()

    render(conn, "index.html", users: users)
  end


  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def create(conn, %{"user" => user_params}) do

    if (Map.get(user_params, "role") == "Admin") do
      changeset = UserContext.change_user(%User{})
      conn
        |> put_flash(:error, "user not created, cant be admin")
        |> render("new.html", changeset: changeset)
    end

    case UserContext.create_user(user_params) do
      {:ok, user} ->
        UserContext.set_token_on_user(user)
        UserContext.get_user_from_email(user_params["email"])
        WinkelkarController.create(conn,user)
        send_verification_mail(UserContext.get_user!(user.id), conn)
        conn
        |> put_flash(:info, Translations.Gettext.gettext(@user_creation))
        |> redirect(to: Routes.session_path(conn, :login))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp send_verification_mail(user, conn) do
    Email.email_verification(user, conn) |> Mailer.deliver_now()
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end


  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, Translations.Gettext.gettext(@user_updated))
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, Translations.Gettext.gettext(@user_deleted))
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def history(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    |> Repo.preload([:winkelkar, :history])

    totaal = UserContext.berekenTotaalprijs(Map.get(user, :history))


    render(conn, "history.html", products: Map.get(user, :history), totaal: totaal)
  end

  def create_key(conn, _params)do
    user = Guardian.Plug.current_resource(conn)
    |> Repo.preload([:winkelkar, :history])

    UserContext.set_api_token(user)

    user_with_api = UserContext.get_user_from_email(Map.get(user, :email))
    |> IO.inspect()

    render(conn, "api.html", api_key: Map.get(user_with_api, :api_token))
  end

  def edit_profiel(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)

    case UserContext.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, Translations.Gettext.gettext(@user_updated))
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit_user.html", user: user, changeset: changeset)
    end
  end

  def get_edit_profiel(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit_user.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def validate_manueel(conn, %{"id" => id}) do
    user = UserContext.get_user(id)
    |> IO.inspect()


    UserContext.validate_user(user)
    conn
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
