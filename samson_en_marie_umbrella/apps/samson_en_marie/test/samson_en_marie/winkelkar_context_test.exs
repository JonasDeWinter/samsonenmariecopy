defmodule SamsonEnMarie.WinkelkarContextTest do
  use SamsonEnMarie.DataCase

  alias SamsonEnMarie.WinkelkarContext

  describe "winkelkarren" do
    alias SamsonEnMarie.WinkelkarContext.Winkelkar

    @valid_attrs %{winkelkar_id: 42}
    @update_attrs %{winkelkar_id: 43}
    @invalid_attrs %{winkelkar_id: nil}

    def winkelkar_fixture(attrs \\ %{}) do
      {:ok, winkelkar} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WinkelkarContext.create_winkelkar()

      winkelkar
    end

    test "list_winkelkarren/0 returns all winkelkarren" do
      winkelkar = winkelkar_fixture()
      assert WinkelkarContext.list_winkelkarren() == [winkelkar]
    end

    test "get_winkelkar!/1 returns the winkelkar with given id" do
      winkelkar = winkelkar_fixture()
      assert WinkelkarContext.get_winkelkar!(winkelkar.id) == winkelkar
    end

    test "create_winkelkar/1 with valid data creates a winkelkar" do
      assert {:ok, %Winkelkar{} = winkelkar} = WinkelkarContext.create_winkelkar(@valid_attrs)
      assert winkelkar.winkelkar_id == 42
    end

    test "create_winkelkar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WinkelkarContext.create_winkelkar(@invalid_attrs)
    end

    test "update_winkelkar/2 with valid data updates the winkelkar" do
      winkelkar = winkelkar_fixture()
      assert {:ok, %Winkelkar{} = winkelkar} = WinkelkarContext.update_winkelkar(winkelkar, @update_attrs)
      assert winkelkar.winkelkar_id == 43
    end

    test "update_winkelkar/2 with invalid data returns error changeset" do
      winkelkar = winkelkar_fixture()
      assert {:error, %Ecto.Changeset{}} = WinkelkarContext.update_winkelkar(winkelkar, @invalid_attrs)
      assert winkelkar == WinkelkarContext.get_winkelkar!(winkelkar.id)
    end

    test "delete_winkelkar/1 deletes the winkelkar" do
      winkelkar = winkelkar_fixture()
      assert {:ok, %Winkelkar{}} = WinkelkarContext.delete_winkelkar(winkelkar)
      assert_raise Ecto.NoResultsError, fn -> WinkelkarContext.get_winkelkar!(winkelkar.id) end
    end

    test "change_winkelkar/1 returns a winkelkar changeset" do
      winkelkar = winkelkar_fixture()
      assert %Ecto.Changeset{} = WinkelkarContext.change_winkelkar(winkelkar)
    end
  end
end
