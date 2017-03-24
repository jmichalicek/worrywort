defmodule Brewbase.FermenterTest do
  use Brewbase.ModelCase

  alias Brewbase.Fermenter

  @valid_attrs %{description: "some content", is_active: true, is_available: true, name: "some content", volume: "120.5", type: 42, units: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Fermenter.changeset(%Fermenter{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Fermenter.changeset(%Fermenter{}, @invalid_attrs)
    refute changeset.valid?
  end
end
