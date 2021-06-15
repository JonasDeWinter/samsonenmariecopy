defmodule SamsonEnMarieWeb.Api.UserController do
  use SamsonEnMarieWeb, :controller

  alias SamsonEnMarie.UserContext
  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.Repo

  def index(conn, _params) do
    IO.inspect(UserContext.api_users())
    IO.inspect(get_req_header(conn, "webshop-api-key"))
    loop_api(UserContext.api_users(), List.first(get_req_header(conn, "webshop-api-key")), conn)
    users = UserContext.list_validated()
    |> IO.inspect()
    render(conn, "index.json", %{user: users})
  end

  def loop_api([first], key, conn) do
    if (first != key) do
        render(conn, "fout.json", %{message: "not Authorised"})
    end
  end

  def loop_api([first | rest], key, conn) do
    if (first != key) do
        loop_api(rest, key, conn)
    end
  end


  def history(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    |> Repo.preload([:history])

    loop_api(UserContext.api_users(), List.first(get_req_header(conn, "webshop-api-key")), conn)
    producten = Map.get(user, :history)
    render(conn, "showcart.json", %{user: producten})
  end

end
