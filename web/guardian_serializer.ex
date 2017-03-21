defmodule Brewbase.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Brewbase.Repo
  alias Brewbase.User

  def for_token(user = %User{}) do
    { :ok, "User:#{user.id}" }
  end
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id) do
    { :ok, Repo.get_by(User, id: id, is_active: true) }
  end

  def from_token(_) do
    { :error, "Unknown resource type" }
  end
end
