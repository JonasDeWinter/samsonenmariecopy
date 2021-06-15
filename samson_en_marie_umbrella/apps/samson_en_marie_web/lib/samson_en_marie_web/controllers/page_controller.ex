defmodule SamsonEnMarieWeb.PageController do
  use SamsonEnMarieWeb, :controller



  def index(conn, _params) do

    render(conn, "index.html", role: "everyone")
  end

  def user_index(conn, _params) do
    render(conn, "index.html", role: "Gast")
  end

  def manager_index(conn, _params) do
    render(conn, "index.html", role: "Geregistreerde gebruikers")
  end

  def admin_index(conn, _params) do
    render(conn, "index.html", role: "admins")
  end
end
