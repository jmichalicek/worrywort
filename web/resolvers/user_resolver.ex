defmodule Brewbase.Resolvers.UserResolver do
  @moduledoc """
  GraphQL resolver for users
  """
  alias Brewbase.Repo

  @doc """
  GraphQL login function
  """
  def login(params, _info) do
    with {:ok, user} <- Brewbase.Session.authenticate(params, Repo),
         {:ok, jwt, _ } <- Guardian.encode_and_sign(user, :access) do
      {:ok, %{token: jwt}}
    end
  end
end
