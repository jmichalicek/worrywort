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

  @required_fields [:email, ]
  @optional_fields [:first_name, :last_name, :is_active, :last_login,
                    :password, :password_confirmation]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  #  def changeset(struct, params \\ %{}) do
  #  struct
  #  |> cast(params, [:first_name, :last_name, :email, :hashed_password, :is_active, :last_login])
  #  |> validate_required([:first_name, :last_name, :email, :hashed_password, :is_active, :last_login])
  #  |> unique_constraint(:email)
  #end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    # TODO: not sure why this casts all params twice?
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> email_changeset(params)
    #    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> set_password_changeset(params)
  end

  @doc """
  validate the email address, which is used in several changesets
  """
  def email_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(email))
    |> update_change(:email, &normalize_email/1)
    |> validate_required([:email])
    |> validate_length(:email, min: 3, max: 255, message: "That does not appear to be a valid email adress")
    |> unique_constraint(:email, message: "That email address is already in use")
  end

  @doc """
  Downcase email and trim whitespace for easier db querying
  """
  def normalize_email(email) do
    case email do
      nil -> ""
      "" -> email
      _ -> email |> String.downcase() |> String.trim()
    end
  end

  @doc """
  Changeset for base password validation comparing password and password_confirmation
  and length requirements
  """
  defp set_password_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(password password_confirmation), [])
    |> validate_confirmation(:password, message: "Password does not match confirmation")
    |> validate_length(:password, min: 6, message: "Ensure your password has at least 6 characters")
    |> put_hash_password()
  end

  @doc """
  Take the virtual input password and password_confirmation
  and ensure they match.  If so, hash and set hased_password
  """
  defp put_hash_password(changeset) do
    # might remove hashpwsalt and put my own function, from a shared lib, which hashes
    # to make it easier to change hashing methods later
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        changeset
        |> put_change(:hashed_password, hashpwsalt(pass))
      _ ->
        changeset
    end
  end

end
