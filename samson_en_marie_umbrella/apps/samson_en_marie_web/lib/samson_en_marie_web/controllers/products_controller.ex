defmodule SamsonEnMarieWeb.ProductsController do
  use SamsonEnMarieWeb, :controller

  alias SamsonEnMarie.ProductContext
  alias SamsonEnMarie.ProductContext.Products
  alias NimbleCSV.RFC4180, as: CSV

  @product_created "Products created successfully."
  @product_updated "Products updated successfully."
  @product_deleted "Products deleted successfully."

  def index(conn, _params) do
    products = ProductContext.list_products()
    render(conn, "index.html", products: products)
  end

  def index_user(conn, _params) do
    products = ProductContext.list_products()
    render(conn, "userindex.html", products: products)
  end

  def new(conn, _params) do
    changeset = ProductContext.change_products(%Products{})
    render(conn, "new.html", changeset: changeset)
  end

  def show_minimum_prijs(conn, %{"prijs" => prijs_params}) do
      products = ProductContext.minimum_prijs(prijs_params)
      render(conn, "userindex.html", products: products)
  end

  def show_maximum_prijs(conn, %{"prijs" => prijs_params}) do
    products = ProductContext.maximum_prijs(prijs_params)
    render(conn, "userindex.html", products: products)
  end

  def show_naam(conn, %{"naam" => naam_params}) do
    products = ProductContext.zoek_naam(naam_params)
    render(conn, "userindex.html", products: products)
  end

  def show_maat(conn, %{"maat" => maat_params}) do
    products = ProductContext.zoek_maat(maat_params)
    render(conn, "userindex.html", products: products)
  end

  def show_kleur(conn, %{"kleur" => kleur_params}) do
    products = ProductContext.zoek_kleur(kleur_params)
    render(conn, "userindex.html", products: products)
  end

  def create(conn, %{"products" => products_params}) do
    case ProductContext.create_products(products_params) do
      {:ok, products} ->
        conn
        |> put_flash(:info, Translations.Gettext.gettext(@product_created))
        |> redirect(to: Routes.products_path(conn, :show, products))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_file(conn, %{"products" => products_params}) do
    IO.inspect products_params
    products_params["file"].path
    |> Path.expand()
    |> File.stream!(read_ahead: 100_000)
    |> CSV.parse_stream
    |> Stream.map(fn [title, description, stock, size, color, price] ->
      %{title: :binary.copy(title), description: :binary.copy(description), stock: String.to_integer(stock), size: :binary.copy(size), color: :binary.copy(color), price: String.to_float(price)}
    end)
    |> Enum.to_list()
    |> looplist(conn)

    conn
    |> redirect(to: Routes.products_path(conn, :index))
  end

  defp looplist([x], conn) do
    case ProductContext.create_products(x) do
      {:ok, _products} ->
        conn
        |> put_flash(:info, Translations.Gettext.gettext(@product_created))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp looplist([first | rest],conn) do
    case ProductContext.create_products(first) do
      {:ok, _products} ->
        conn
        |> put_flash(:info, Translations.Gettext.gettext(@product_created))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
    IO.inspect(first)
    looplist(rest, conn)
  end

  def show(conn, %{"id" => id}) do
    products = ProductContext.get_products!(id)
    render(conn, "show.html", products: products)
  end

  def show_user(conn, %{"id" => id}) do

    products = ProductContext.get_products!(id)

    render(conn, "usershow.html", products: products)
  end

  def edit(conn, %{"id" => id}) do
    products = ProductContext.get_products!(id)
    changeset = ProductContext.change_products(products)
    render(conn, "edit.html", products: products, changeset: changeset)
  end

  def update(conn, %{"id" => id, "products" => products_params}) do
    products = ProductContext.get_products!(id)

    case ProductContext.update_products(products, products_params) do
      {:ok, products} ->
        conn
        |> put_flash(:info, Translations.Gettext.gettext(@product_updated))
        |> redirect(to: Routes.products_path(conn, :show, products))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", products: products, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    products = ProductContext.get_products!(id)
    {:ok, _products} = ProductContext.delete_products(products)

    conn
    |> put_flash(:info, Translations.Gettext.gettext(@product_deleted))
    |> redirect(to: Routes.products_path(conn, :index))
  end


end
