defmodule Brewbase.Session do
  @moduledoc """
  Model basic session login/logout stuff.

  This could also all sanely live on the User model, it seems like
  """
  use Brewbase.Web, :model
  require Logger
  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]

  alias Brewbase.User
  alias Brewbase.Repo
 
  def authenticate(params, repo) do
    #user = repo.get_by(User, email: String.downcase(params.email))
    user = Repo.get_by(User, email: String.downcase(params.email), is_active: true)
    case check_password(user, params.password) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect login credentials"}
    end
  end
 
  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.hashed_password)
    end
  end
end
