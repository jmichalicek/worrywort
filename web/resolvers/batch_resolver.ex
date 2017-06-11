defmodule Brewbase.Resolvers.BatchResolver do
  @moduledoc """
  GraphQL resolver for users
  """
  alias Brewbase.Repo
  alias Brewbase.Batch
  import Ecto.Query #, only: [where: 2, join: 3, preload: 2]

  def get(args, %{context: %{current_user: %{id: user_id}}}) do
    # TODO: handle other args
    # TODO: ensure user_id is not nil
    id = Map.fetch!(args, :id)
      case Batch |> Repo.get_by(user_id: user_id, id: id) do
        nil -> {:error, "Batch id #{id} not found"}
        batch -> {:ok, batch}
      end
  end

  def all(args, %{context: %{current_user: %{id: id}}}) do
    # TODO: allow filter by fermenter

    query =
      Batch
      |> join(:left, [batch], user in assoc(batch, :user))
      |> join(:left, [batch], fermenter in assoc(batch, :fermenter))
      |> where(user_id: ^id)
      |> preload([:fermenter, :user])
      |> select([batch, fermenter, user], batch)

    # now we can compose other filters, etc. based on the args
    batches = query |> Repo.all
    {:ok, batches}
  end
  def all(_args, _info), do: {:error, "Not Authorized"}

  @doc """
  Create a batch to be brewed
  """
  def create(params=%{batch: changes}, info=%{context: %{current_user: %{id: user_id}}}) do
    changes = Map.put(changes, :user_id, user_id)
    %Batch{}
    |> Batch.changeset(changes)
    |> Repo.insert
  end
  def create(_, _), do: {:error, "Not Authorized"}

  @doc """
  Update an existing batch.  Requires that the context's current user
  owns that batch.
  """
  def update(args=%{id: id, batch: changes}, info=%{context: %{current_user: %{id: user_id}}}) do
    case get(args, info) do
      {:ok, batch} ->
        Batch.changeset(batch, changes)
          |> Repo.update
      {:error, message} ->
        {:error, message}
    end
  end
  def update(_, _), do: {:error, "Not Authorized"}
end
