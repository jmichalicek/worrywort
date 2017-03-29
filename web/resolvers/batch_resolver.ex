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
        fermenter -> {:ok, fermenter}
      end
  end

  def all(_args, %{context: %{current_user: %{id: id}}}) do
    # TODO: allow filter by fermenter

    # Are these two things different?  Top definitely does a join
    # whereas the lower might do an extra query each for fermenter and user?
    # I find this way more readable, really
    batches = from batch in Batch,
      left_join: user in assoc(batch, :user),
      left_join: fermenter in assoc(batch, :fermenter),
      where: batch.user_id == ^id,
      select: batch,
      preload: [fermenter: fermenter]

    batches = Repo.all(batches)
    {:ok, batches}

    # below matches all examples I can find, but the joins complain about batch
    # not being defined on the join lines
    #batches =
    #  Batch
    #  |> join(:left, [batch], user in User, batch.user_id == user.id)
    #  |> join(:left, [batch], fermenter in Fermenter,
    #          batch.fermenter_id == fermenter.id and fermenter.user_id == user.id)
    #  |> where(user_id: ^id)
    #  |> preload([:fermenter, :user])
    #  |> select([batch, fermenter, user], batch)
    #  |> Repo.all
    #{:ok, batches}
  end
  def all(_args, _info), do: {:error, "Not Authorized"}

  @doc """
  Create a bach to be brewed
  """
  def create(params, info=%{context: %{current_user: %{id: id}}}) do
    changes = Map.put(params, :user_id, id)
    %Batch{}
    |> Batch.changeset(changes)
    |> Repo.insert
  end
  def create(_, _), do: {:error, "Not Authorized"}
end
