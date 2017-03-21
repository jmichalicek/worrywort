defmodule Brewbase.Helpers.Auth do
  @moduledoc """
  Authentication helper functions which may be useful in various
  places such as controllers or tests and are better not as part
  of a Plug directly.
  """

  use Brewbase.Web, :controller


  @doc """
  Set a user as the currently logged in user for the connection and
  return that connection.
  """
  def login(conn, user) do
    conn = conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end

