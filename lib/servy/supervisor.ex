defmodule Servy.Supervisor do
  use Supervisor

  def start_link do
    IO.puts("Starting main supervisor ...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init() do
    children = [
      Servy.KickStarter,
      Servy.ServicesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
