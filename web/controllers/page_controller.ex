defmodule Brewbase.PageController do
  use Brewbase.Web, :controller
  use Guardian.Phoenix.Controller

  def index(conn, _params, user, claims) do
    render(conn, "index.html", current_user: user)
  end
end
