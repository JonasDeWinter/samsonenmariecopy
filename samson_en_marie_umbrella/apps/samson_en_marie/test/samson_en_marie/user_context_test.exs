defmodule SamsonEnMarie.UserContextTest do
  use SamsonEnMarie.DataCase

  alias SamsonEnMarie.UserContext

  describe "users" do
    alias SamsonEnMarie.UserContext.User

    @valid_attrs %{achternaam: "some achternaam", email: "some email", hashed_password: "some hashed_password", huisnr: "some huisnr", land: "some land", postcode: "some postcode", role: "some role", stad: "some stad", straat: "some straat", voornaam: "some voornaam"}
    @update_attrs %{achternaam: "some updated achternaam", email: "some updated email", hashed_password: "some updated hashed_password", huisnr: "some updated huisnr", land: "some updated land", postcode: "some updated postcode", role: "some updated role", stad: "some updated stad", straat: "some updated straat", voornaam: "some updated voornaam"}
    @invalid_attrs %{achternaam: nil, email: nil, hashed_password: nil, huisnr: nil, land: nil, postcode: nil, role: nil, stad: nil, straat: nil, voornaam: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContext.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserContext.create_user(@valid_attrs)
      assert user.achternaam == "some achternaam"
      assert user.email == "some email"
      assert user.hashed_password == "some hashed_password"
      assert user.huisnr == "some huisnr"
      assert user.land == "some land"
      assert user.postcode == "some postcode"
      assert user.role == "some role"
      assert user.stad == "some stad"
      assert user.straat == "some straat"
      assert user.voornaam == "some voornaam"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserContext.update_user(user, @update_attrs)
      assert user.achternaam == "some updated achternaam"
      assert user.email == "some updated email"
      assert user.hashed_password == "some updated hashed_password"
      assert user.huisnr == "some updated huisnr"
      assert user.land == "some updated land"
      assert user.postcode == "some updated postcode"
      assert user.role == "some updated role"
      assert user.stad == "some updated stad"
      assert user.straat == "some updated straat"
      assert user.voornaam == "some updated voornaam"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
