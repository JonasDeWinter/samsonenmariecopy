defmodule SamsonEnMarieWeb.WinkelkarController do
  use SamsonEnMarieWeb, :controller

  alias SamsonEnMarie.WinkelkarContext
  alias SamsonEnMarie.WinkelkarContext.Winkelkar
  alias SamsonEnMarieWeb.ProductsController
  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.ProductContext
  alias SamsonEnMarie.Repo
  alias SamsonEnMarieWeb.Guardian
  alias SamsonEnMarie.{Email,Mailer}
  alias SamsonEnMarie.UserContext

  def index(conn, _params) do
    winkelkarren = WinkelkarContext.list_winkelkarren()
    render(conn, "index.html", winkelkarren: winkelkarren)
  end

  def new(conn, _params) do
    changeset = WinkelkarContext.change_winkelkar(%Winkelkar{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %User{} = user ) do
    case WinkelkarContext.create_winkelkar(user) do
      {:ok, _winkelkar} ->
        conn
        |> put_flash(:info, "Winkelkar created successfully.")


      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    winkelkar = WinkelkarContext.get_winkelkar!(id)
    render(conn, "show.html", winkelkar: winkelkar)
  end

  def edit(conn, %{"id" => id}) do
    winkelkar = WinkelkarContext.get_winkelkar!(id)
    changeset = WinkelkarContext.change_winkelkar(winkelkar)
    render(conn, "edit.html", winkelkar: winkelkar, changeset: changeset)
  end

  def update(conn, %{"id" => id, "winkelkar" => winkelkar_params}) do
    winkelkar = WinkelkarContext.get_winkelkar!(id)

    case WinkelkarContext.update_winkelkar(winkelkar, winkelkar_params) do
      {:ok, winkelkar} ->
        conn
        |> put_flash(:info, "Winkelkar updated successfully.")
        |> redirect(to: Routes.winkelkar_path(conn, :show, winkelkar))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", winkelkar: winkelkar, changeset: changeset)
    end
  end


  def add_to_cart(conn, %{"id" => product_id}) do
    IO.inspect(product_id)
    winkelkar = get_current_winkelkar(conn)
    product = ProductContext.get_products!(product_id)

    WinkelkarContext.add_to_winkelkar(winkelkar, product)

    loaded_winkelkar = Repo.preload(winkelkar,[:user, :products])
    render(conn, "show.html", winkelkar: loaded_winkelkar)

  end

  def delete_product(conn, %{"id" => product_id}) do
    integer_product = String.to_integer(product_id)
    winkelkar = get_current_winkelkar(conn)
    product = ProductContext.get_products!(integer_product)


    {:ok, _winkelkar} = WinkelkarContext.delete_product(winkelkar, product)

    loaded_winkelkar = Repo.preload(winkelkar,[:user, :products])
    render(conn, "show.html", winkelkar: loaded_winkelkar)
  end

  defp get_current_winkelkar(conn) do
    user = Guardian.Plug.current_resource(conn)
    |> Repo.preload([:winkelkar])

    Map.get(user,:winkelkar)
  end

  def betalen(conn, _params) do
    winkelkar = get_current_winkelkar(conn)
    user = Guardian.Plug.current_resource(conn)
    |> Repo.preload([:winkelkar])

    tussen_winkelkar = Repo.preload(winkelkar,[:user, :products])
    producten = Map.get(tussen_winkelkar, :products)

    send_betalingsmail(user, conn, producten)

    UserContext.add_to_history(user,producten)

    IO.inspect(Repo.preload(user,[:history]))
    WinkelkarContext.betaling(winkelkar)
    loaded_winkelkar = Repo.preload(winkelkar,[:user, :products])

    render(conn, "show.html", winkelkar: loaded_winkelkar)
  end

  defp send_betalingsmail(user, conn, products) do
    Email.betalingsmail(user, conn, products)
    |> Mailer.deliver_now()
  end
end
