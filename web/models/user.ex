defmodule Brewbase.User do
  use Brewbase.Web, :model
  require Logger
  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]

  schema "users" do
    field :first_name, :string, default: ""
    field :last_name, :string, default: ""
    field :email, :string, default: ""
    field :hashed_password, :string, default: ""
    field :is_active, :boolean, default: false
    field :last_login, Calecto.DateTimeUTC

    timestamps()

    # VIRTUAL FIELDS
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    # for password updates
    field :current_password, :string, virtual: true
  end

  @required_field [:email, :first_name, :last_name]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :hashed_password, :is_active, :last_login])
    |> validate_required([:first_name, :last_name, :email, :hashed_password, :is_active, :last_login])
    |> unique_constraint(:email)
  end
end
