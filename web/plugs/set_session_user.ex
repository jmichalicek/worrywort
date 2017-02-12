defmodule Brewbase.Plugs.SessionUser do
  @moduledoc """
  Plug which checks the session and validates the current user is real
  and is active.
  """
  import Plug.Conn
  alias Brewbase.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do

    # Technically, should only need the 2nd part of this case but as a kliduge
    # workaround for unclear/difficult session handling in test cases
    # where we can easily set conn.assigns and keep that yet the session data
    # gets reset when making PUT requests, we will check for conn.assigns.current_user
    # first THEN session for user id and then validate that they still exist and are active
    case conn.assigns do
      %{:current_user => _} ->
        user_id = conn.assigns.current_user.id
        put_session(conn, :user_id, conn.assigns.current_user.id)
      _ ->
        user_id = get_session(conn, :user_id)

      user = user_id && repo.get_by(User, id: user_id, is_active: true)
      assign(conn, :current_user, user)
    end
  end
end

