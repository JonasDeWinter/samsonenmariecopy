defmodule SamsonEnMarieWeb.Guardian do
  use Guardian, otp_app: :samson_en_marie_web

  alias SamsonEnMarie.UserContext
  alias SamsonEnMarie.UserContext.User

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case UserContext.get_user(id) do
      %User{} = u -> {:ok, u}
      nil -> {:error, :resource_not_found}
    end
  end
end
