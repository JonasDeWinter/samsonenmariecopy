defmodule SamsonEnMarie.UserContext do
  @moduledoc """
  The UserContext context.
  """
  require Translations.Gettext
  import Ecto.Query, warn: false
  alias SamsonEnMarie.Repo

  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.WinkelkarContext.Winkelkar
  alias SamsonEnMarie.WinkelkarContext

  @error_message_no_username "that username does not exists"
  @error_message_no_pass "password is wrong dumbass"
  defdelegate get_acceptable_roles(), to: User


  def get_user_from_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_from_token(token) do
    Repo.get_by(User, verification_token: token)
  end

  def valid_token?(token_sent_at) do
    current_time = NaiveDateTime.utc_now()
    Time.diff(current_time, token_sent_at) < 86400
  end
  def set_token_on_user(user) do
    attrs = %{
      "verification_token" => SecureRandom.urlsafe_base64(),
      "verification_token_sent_at" => NaiveDateTime.utc_now()
    }

    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end

  def set_api_token(user)do
    attrs = %{
      "api_token" => SecureRandom.urlsafe_base64()
    }

    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def authenticate_user(email, plain_text_password) do
    case Repo.get_by(User, email: email) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, Translations.Gettext.gettext(@error_message_no_username)}

      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, Translations.Gettext.gettext(@error_message_no_pass)}
        end
    end
  end
  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def api_users do
    Repo.all(from u in User,
            where: not is_nil(u.api_token),
            select: u.api_token)
  end

  def list_validated do
    Repo.all(from u in User,
            where: u.validated == true)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)
  @spec create_user(%{optional(:__struct__) => none, optional(atom | binary) => any}) :: any
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def validate_user(%User{} = user) do
    Ecto.Changeset.change(user, %{validated: true})
    |> Repo.update()
  end
  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def add_to_history(%User{} = user ,producten) do
    loaded_user = Repo.preload(user,[:history, :winkelkar])
    |>IO.inspect()
    attrs = Map.from_struct(loaded_user)

    history = Map.get(loaded_user,:history) ++ producten
    User.bestellen(loaded_user,attrs,history)
    |>Repo.update()
    |>IO.inspect()
  end

  def berekenTotaalprijs([]) do
    0
  end
  def berekenTotaalprijs([x]) do
    Map.get(x, :price)
  end
  def berekenTotaalprijs([first | rest]) do
    Map.get(first, :price) + berekenTotaalprijs(rest)
  end

end
