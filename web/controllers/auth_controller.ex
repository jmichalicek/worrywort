defmodule Brewbase.AuthController do
  @moduledoc """
  Handle login/logout/auth stuff using ueberauth
  """
  use Brewbase.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Brewbase.User

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
  #def callback(conn, %{"auth" => %{"email" => email, "password" => password}}) do
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do 
    user = Brewbase.Repo.get_by(User, email: auth.uid, is_active: true)
    credentials = auth.credentials
    # location of password seems a bit odd, but that's where it is.
    if user && checkpw(credentials.other.password, user.hashed_password) do
      conn
      |> put_flash(:info, "Welcome, #{user.first_name}")
      |> login(user)
      |> redirect(to: page_path(conn, :index))
    end
    conn
    |> put_flash(:error, "Invalid username or password")
    |> render("login.html")
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
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

