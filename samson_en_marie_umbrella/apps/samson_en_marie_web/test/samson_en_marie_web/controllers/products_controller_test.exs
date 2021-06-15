defmodule SamsonEnMarieWeb.ProductsControllerTest do
  use SamsonEnMarieWeb.ConnCase

  alias SamsonEnMarie.ProductContext

  @create_attrs %{kleur: "some kleur", maat: "some maat", omschrijving: "some omschrijving", prijs: "120.5", titel: "some titel"}
  @update_attrs %{kleur: "some updated kleur", maat: "some updated maat", omschrijving: "some updated omschrijving", prijs: "456.7", titel: "some updated titel"}
  @invalid_attrs %{kleur: nil, maat: nil, omschrijving: nil, prijs: nil, titel: nil}

  def fixture(:products) do
    {:ok, products} = ProductContext.create_products(@create_attrs)
    products
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.products_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Products"
    end
  end

  describe "new products" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.products_path(conn, :new))
      assert html_response(conn, 200) =~ "New Products"
    end
  end

  describe "create products" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.products_path(conn, :create), products: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.products_path(conn, :show, id)

      conn = get(conn, Routes.products_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Products"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.products_path(conn, :create), products: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Products"
    end
  end

  describe "edit products" do
    setup [:create_products]

    test "renders form for editing chosen products", %{conn: conn, products: products} do
      conn = get(conn, Routes.products_path(conn, :edit, products))
      assert html_response(conn, 200) =~ "Edit Products"
    end
  end

  describe "update products" do
    setup [:create_products]

    test "redirects when data is valid", %{conn: conn, products: products} do
      conn = put(conn, Routes.products_path(conn, :update, products), products: @update_attrs)
      assert redirected_to(conn) == Routes.products_path(conn, :show, products)

      conn = get(conn, Routes.products_path(conn, :show, products))
      assert html_response(conn, 200) =~ "some updated kleur"
    end

    test "renders errors when data is invalid", %{conn: conn, products: products} do
      conn = put(conn, Routes.products_path(conn, :update, products), products: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Products"
    end
  end

  describe "delete products" do
    setup [:create_products]

    test "deletes chosen products", %{conn: conn, products: products} do
      conn = delete(conn, Routes.products_path(conn, :delete, products))
      assert redirected_to(conn) == Routes.products_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.products_path(conn, :show, products))
      end
    end
  end

  defp create_products(_) do
    products = fixture(:products)
    %{products: products}
  end
end
