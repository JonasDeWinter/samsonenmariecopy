defmodule SamsonEnMarie.Repo do
  use Ecto.Repo,
    otp_app: :samson_en_marie,
    adapter: Ecto.Adapters.MyXQL
end
