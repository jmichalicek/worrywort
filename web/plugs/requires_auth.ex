defmodule BrewBbase.Plugs.RequiresAuth do
  @moduledoc """
  Plug which checks the session and validates the current user is real
  and is active.
  """
  import Plug.Conn
  alias Brewbase.User

  def init(opts) do
    #Keyword.fetch!(opts, :repo)
    # add option for custom message
    # Add redirect url config
  end

  def call(conn, _) do
    if !conn.assigns.current_user do
      conn
      |> Phoenix.Controller.put_flash(:error, "Login Required")
      |> Phoenix.Controller.redirect(to: "/login")  # use url route thing here!
      |> halt
    else
      conn
    end
  end
end
