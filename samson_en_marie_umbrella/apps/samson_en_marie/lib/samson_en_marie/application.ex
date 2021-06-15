defmodule SamsonEnMarie.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SamsonEnMarie.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SamsonEnMarie.PubSub}
      # Start a worker by calling: SamsonEnMarie.Worker.start_link(arg)
      # {SamsonEnMarie.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SamsonEnMarie.Supervisor)
  end
end
