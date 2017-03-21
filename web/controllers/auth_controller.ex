defmodule Brewbase.AuthController do
  @moduledoc """
  Handle login/logout/auth stuff using ueberauth
  """
  use Brewbase.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Brewbase.User
  alias Brewbase.Repo       

  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]


  def index(conn, _params) do
    render conn, "login.html"
  end

  @doc """
  Handle failed login attempts for Ueberauth
  """
  def callback(%{assigns: %{uerberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Invalid Email or Password")
    |> redirect(to: "/login")  # use url route thing here!
  end

  @doc """
  Handle Ueberauth login attempt using username/password (identity strategy)
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = Repo.get_by(User, email: auth.uid, is_active: true)
    credentials = auth.credentials
    case user && checkpw(credentials.other.password, user.hashed_password) do
      true ->
        conn
        |> Guardian.Plug.sign_in(conn, user)
        |> put_flash(:info, "Welcome, #{user.first_name}")
        |> redirect(to: page_path(conn, :index))
      _ ->
      conn
      |> put_flash(:error, "Invalid username or password")
      |> render("login.html")
    end
  end

  @doc """
  Log user out by ending the session
  """
  def logout(conn, _params) do
    # would it be better to clear session then renew?
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end
end

