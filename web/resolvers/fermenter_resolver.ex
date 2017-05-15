defmodule Brewbase.Resolvers.FermenterResolver do
  @moduledoc """
  GraphQL resolver for fermenters
  """
  alias Brewbase.Repo
  alias Brewbase.Fermenter
  import Ecto.Query, only: [where: 2]

  def get(args, %{context: %{current_user: %{id: user_id}}}) do
    # TODO: ensure user_id is not nil
    id = Map.fetch!(args, :id)
      case Fermenter |> Repo.get_by(user_id: user_id, id: id) do
        nil -> {:error, "Fermenter id #{id} not found"}
        fermenter -> {:ok, fermenter}
      end
  end

  def all(_args, %{context: %{current_user: %{id: user_id}}}) do
     fermenters =
       Fermenter
        |> where(user_id: ^user_id)
        |> Repo.all
      {:ok, fermenters}
  end
  def all(_args, _info), do: {:error, "Not Authorized"}

  def create(args=%{fermenter: changes}, info=%{context: %{current_user: %{id: user_id}}}) do
    changes = Map.put(changes, :user_id, user_id)
    %Fermenter{}
    |> Fermenter.changeset(changes)
    |> Repo.insert
  end
  def create(_, _), do: {:error, "Not Authorized"}

  def update(args=%{id: id, fermenter: changes}, info=%{context: %{current_user: %{id: user_id}}}) do
    case get(args, info) do
      {:ok, fermenter} ->
        Fermenter.changeset(fermenter, changes)
          |> Repo.update
      {:error, message} ->
        {:error, message}
    end
  end
  def update(_, _), do: {:error, "Not Authorized"}
end
