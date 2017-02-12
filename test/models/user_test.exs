defmodule Brewbase.UserTest do
  use Brewbase.ModelCase

  alias Brewbase.User

  @valid_attrs %{email: "some content", first_name: "some content", hashed_password: "some content", is_active: true, last_login: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, last_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
