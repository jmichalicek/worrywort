defmodule Brewbase.PageController do
  use Brewbase.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
