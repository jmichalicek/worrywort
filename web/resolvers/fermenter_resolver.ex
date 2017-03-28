defmodule Brewbase.Resolvers.FermenterResolver do
  @moduledoc """
  GraphQL resolver for users
  """
  alias Brewbase.Repo
  alias Brewbase.Fermenter
  import Ecto.Query, only: [where: 2]

  def get(args, %{context: %{current_user: %{id: user_id}}}) do
    # TODO: handle other args
    # TODO: ensure user_id is not nil
    id = Map.fetch!(args, :id)
      case Fermenter |> Repo.get_by(user_id: user_id, id: id) do
        nil -> {:error, "Fermenter id #{id} not found"}
        fermenter -> {:ok, fermenter}
      end
  end

  def all(_args, %{context: %{current_user: %{id: id}}}) do
     fermenters =
       Fermenter
        |> where(user_id: ^id)
        |> Repo.all
      {:ok, fermenters}
  end
  def all(_args, _info), do {:error, "Not Authorized"}

  def create(params, info=%{context: %{current_user: %{id: id}}}) do
    changes = Map.put(params, :user_id, id)
    %Fermenter{}
    |> Fermenter.changeset(changes)
    |> Repo.insert
  end
  def create(_, _), do {:error, "Not Authorized"}
end
