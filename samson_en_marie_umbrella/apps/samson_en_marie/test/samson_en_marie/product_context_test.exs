defmodule SamsonEnMarie.ProductContextTest do
  use SamsonEnMarie.DataCase

  alias SamsonEnMarie.ProductContext

  describe "products" do
    alias SamsonEnMarie.ProductContext.Products

    @valid_attrs %{kleur: "some kleur", maat: "some maat", omschrijving: "some omschrijving", prijs: "120.5", titel: "some titel"}
    @update_attrs %{kleur: "some updated kleur", maat: "some updated maat", omschrijving: "some updated omschrijving", prijs: "456.7", titel: "some updated titel"}
    @invalid_attrs %{kleur: nil, maat: nil, omschrijving: nil, prijs: nil, titel: nil}

    def products_fixture(attrs \\ %{}) do
      {:ok, products} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProductContext.create_products()

      products
    end

    test "list_products/0 returns all products" do
      products = products_fixture()
      assert ProductContext.list_products() == [products]
    end

    test "get_products!/1 returns the products with given id" do
      products = products_fixture()
      assert ProductContext.get_products!(products.id) == products
    end

    test "create_products/1 with valid data creates a products" do
      assert {:ok, %Products{} = products} = ProductContext.create_products(@valid_attrs)
      assert products.kleur == "some kleur"
      assert products.maat == "some maat"
      assert products.omschrijving == "some omschrijving"
      assert products.prijs == Decimal.new("120.5")
      assert products.titel == "some titel"
    end

    test "create_products/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductContext.create_products(@invalid_attrs)
    end

    test "update_products/2 with valid data updates the products" do
      products = products_fixture()
      assert {:ok, %Products{} = products} = ProductContext.update_products(products, @update_attrs)
      assert products.kleur == "some updated kleur"
      assert products.maat == "some updated maat"
      assert products.omschrijving == "some updated omschrijving"
      assert products.prijs == Decimal.new("456.7")
      assert products.titel == "some updated titel"
    end

    test "update_products/2 with invalid data returns error changeset" do
      products = products_fixture()
      assert {:error, %Ecto.Changeset{}} = ProductContext.update_products(products, @invalid_attrs)
      assert products == ProductContext.get_products!(products.id)
    end

    test "delete_products/1 deletes the products" do
      products = products_fixture()
      assert {:ok, %Products{}} = ProductContext.delete_products(products)
      assert_raise Ecto.NoResultsError, fn -> ProductContext.get_products!(products.id) end
    end

    test "change_products/1 returns a products changeset" do
      products = products_fixture()
      assert %Ecto.Changeset{} = ProductContext.change_products(products)
    end
  end
end
