defmodule Brewbase.BatchTest do
  use Brewbase.ModelCase

  alias Brewbase.Batch

  @valid_attrs %{bottled_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, brew_notes: "some content", brewed_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, estimated_bottling_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, estimated_drinkable_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, final_gravity: "120.5", name: "some content", original_gravity: "120.5", recipe_url: "some content", tasting_notes: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Batch.changeset(%Batch{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Batch.changeset(%Batch{}, @invalid_attrs)
    refute changeset.valid?
  end
end
