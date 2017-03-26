defmodule Brewbase.Resolvers.FermenterResolver do
  @moduledoc """
  GraphQL resolver for users
  """
  alias Brewbase.Repo
  alias Brewbase.Fermenter
  import Ecto.Query, only: [where: 2]

  def all(_args, %{context: %{current_user: %{id: id}}}) do
     fermenters =
       Fermenter
        |> where(user_id: ^id)
        |> Repo.all
      {:ok, fermenters}
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end
end
