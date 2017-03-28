defmodule Brewbase.Fermenter do
  use Brewbase.Web, :model

  schema "fermenters" do
    field :name, :string, default: ""
    field :description, :string, default: ""
    field :volume, :decimal
    field :units, :integer
    field :type, :integer
    field :is_active, :boolean, default: true
    field :is_available, :boolean, default: true
    belongs_to :user, Brewbase.User

    timestamps()
  end

  @error_messages %{
    :name => %{
      :required => "Please include a name for this fermenter"
    },
    :units => %{
      :required => "Please specify the units of volume for this fermenter"
    },
    :volume => %{
      :required => "Please specify the volume of this fermenter"
    },
    :type => %{
      :required => "Please specify the type of fermenter"
    },
    :user => %{
      :required => "Please include a user",
      :invalid => "That is not a valid user"
    }
  }

  def error_messages,  do: @error_messages

  # stuff for managing the choices for units, type, etc.
  # It's possible these should live in their own modules and be imported
  ## UNITS
  @gallons 0
  @quarts 1
  @units_map %{@gallons => "Gallons", @quarts => "Quarts"}

  def gallons, do: @gallons
  def quarts, do: @quarts

  # Could I do metaprogramming template magic to dynamically create
  # get_FOO_display functions?
  def get_units_display(unit) do
    m = @units_map
    m[unit]
  end

  @doc """
  form select/checkbox/radio value to label mapping
  """
  def units_choices do
    @units_map
  end

  # FERMENTER TYPE
  @bucket 0
  @carboy 1
  @conical 2
  @type_map %{@bucket => "Bucket", @carboy => "Carboy", @conical => "Conical"}

  def bucket, do: @bucket
  def carboy, do: @carboy
  def conical, do: @conical

  def get_type_display(type) do
    m = @type_map
    m[type]
  end

  @doc """
  form select/checkbox/radio value to label mapping
  """
  def type_choices do
    @type_map
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :volume, :units, :type, :is_active, :is_available, :user_id])
    |> validate_required([:name, :volume, :units, :type])
    |> assoc_constraint(:user, message: @error_messages.user.invalid)
  end
end
