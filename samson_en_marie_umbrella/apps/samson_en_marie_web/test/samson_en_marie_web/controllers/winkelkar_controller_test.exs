defmodule SamsonEnMarieWeb.WinkelkarControllerTest do
  use SamsonEnMarieWeb.ConnCase

  alias SamsonEnMarie.WinkelkarContext

  @create_attrs %{winkelkar_id: 42}
  @update_attrs %{winkelkar_id: 43}
  @invalid_attrs %{winkelkar_id: nil}

  def fixture(:winkelkar) do
    {:ok, winkelkar} = WinkelkarContext.create_winkelkar(@create_attrs)
    winkelkar
  end

  describe "index" do
    test "lists all winkelkarren", %{conn: conn} do
      conn = get(conn, Routes.winkelkar_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Winkelkarren"
    end
  end

  describe "new winkelkar" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.winkelkar_path(conn, :new))
      assert html_response(conn, 200) =~ "New Winkelkar"
    end
  end

  describe "create winkelkar" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.winkelkar_path(conn, :create), winkelkar: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.winkelkar_path(conn, :show, id)

      conn = get(conn, Routes.winkelkar_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Winkelkar"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.winkelkar_path(conn, :create), winkelkar: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Winkelkar"
    end
  end

  describe "edit winkelkar" do
    setup [:create_winkelkar]

    test "renders form for editing chosen winkelkar", %{conn: conn, winkelkar: winkelkar} do
      conn = get(conn, Routes.winkelkar_path(conn, :edit, winkelkar))
      assert html_response(conn, 200) =~ "Edit Winkelkar"
    end
  end

  describe "update winkelkar" do
    setup [:create_winkelkar]

    test "redirects when data is valid", %{conn: conn, winkelkar: winkelkar} do
      conn = put(conn, Routes.winkelkar_path(conn, :update, winkelkar), winkelkar: @update_attrs)
      assert redirected_to(conn) == Routes.winkelkar_path(conn, :show, winkelkar)

      conn = get(conn, Routes.winkelkar_path(conn, :show, winkelkar))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, winkelkar: winkelkar} do
      conn = put(conn, Routes.winkelkar_path(conn, :update, winkelkar), winkelkar: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Winkelkar"
    end
  end

  describe "delete winkelkar" do
    setup [:create_winkelkar]

    test "deletes chosen winkelkar", %{conn: conn, winkelkar: winkelkar} do
      conn = delete(conn, Routes.winkelkar_path(conn, :delete, winkelkar))
      assert redirected_to(conn) == Routes.winkelkar_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.winkelkar_path(conn, :show, winkelkar))
      end
    end
  end

  defp create_winkelkar(_) do
    winkelkar = fixture(:winkelkar)
    %{winkelkar: winkelkar}
  end
end
