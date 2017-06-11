defmodule Brewbase.Batch do
  @moduledoc """
  Schema and functions for creating and managing a batch of
  brewed beer.

  This currently makes a few assumptions for simplicity.
  1. A batch goes into 1 fermenter
  2. A batch goes into either 0 or 1 secondary fermenters - not split across several
  3. Dry hopping, secondary fermenter additions, etc. are not recorded

  Multiple fermenters, multiple secondary fermenters, dry hopping, etc. are planned for
  the future if needed.

  Attributes:
    boil_volume (decimal): Amount of wort boiled before the boil started (water volume)
    bottle_date (Calecto.DateTimeUTC): Date the batch was bottled or kegged
    bottled_volume (decimal): Amount of beer transferred to bottles
    brew_date (Calector.DateTimeUTC): Date and time the batch was brewed
    brew_notes (text): Notes about the brew such as recipe, variations from
      the linked recipe, general observations, etc.
    estimated_bottling_date (Calecto.DateTimeUTC): Estimated date the batch will be bottled
    estimated_drinkable_date (Calecto.DateTimeUTC): Estimated date the batch will be drinkable
    fermenter (Brewbase.Fermenter): Foreign key/assoc to the fermenter the batch is currently in
    fermenter_volume (decimal): Volume of wort transferred to the fermenter
    final_gravity (decimal): The measured final gravity
    name (string): A name for the batch
    original_gravity (decimal): original gravity of the batch
    recipe_url (string): URL to other site where recipe is kept
    secondary_fermenter_date (Calecto.DateTimeUTC): Date batch was transferred to secondary, if done.
    tasting_notes (text): Notes about the flavor when finally tasted
    user (Brewbase.User): Foreign key/assoc to Brewbase.User who created the batch
    volume_units (integer): The enumeration for the units used for the volumes
  """
  use Brewbase.Web, :model
  alias Brewbase.Repo

  schema "batches" do
    field :name, :string, default: ""
    field :brew_notes, :string, default: ""
    field :tasting_notes, :string, default: ""
    field :brew_date, Calecto.DateTimeUTC
    field :bottle_date, Calecto.DateTimeUTC
    field :estimated_bottling_date, Calecto.DateTimeUTC
    field :estimated_drinkable_date, Calecto.DateTimeUTC
    field :secondary_fermenter_date, Calecto.DateTimeUTC
    field :original_gravity, :decimal
    field :final_gravity, :decimal
    field :recipe_url, :string, default: ""
    field :boil_volume, :decimal
    field :fermenter_volume, :decimal
    field :bottled_volume, :decimal
    field :volume_units, :integer
    belongs_to :user, Brewbase.User
    belongs_to :fermenter, Brewbase.Fermenter

    timestamps()
  end

  # stuff for managing the choices for units, type, etc.
  # It's possible these should live in their own modules and be imported
  ## UNITS
  @gallons 0
  @liters 1
  @units  [@gallons, @liters]
  @units_map %{@gallons => "Gallons", @liters => "Liters"}

  def gallons, do: @gallons
  def liters, do: @liters

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

  @doc """
  Builds a changeset with data for creating a brew batch
  """
  def changeset(struct, params \\ %{}) do
    # TODO: validate lengths of url, int/float ranges, etc.
    # TODO: Does validate_inclusion work when :units was not in the changeset?  It should just pass then,
    # at least if the units is on the model, I hope
    # TODO: add brew_date to required after figuring out the graphql for it
    struct
    |> cast(params, [:name, :brew_notes, :tasting_notes, :brew_date, :bottle_date, :estimated_bottling_date,
                     :estimated_drinkable_date, :original_gravity, :final_gravity,
                     :recipe_url, :secondary_fermenter_date, :boil_volume, :fermenter_volume, :bottled_volume,
                     :volume_units, :user_id, :fermenter_id])
    |> validate_required([:name, :user_id])
    #    |> validate_inclusion(:volume_units, @units)
    |> assoc_constraint(:user)
    |> assoc_constraint(:fermenter)
    |> validate_fermenter
  end

  @doc """
  Validate that the user specified for the Batch owns the Fermenter or
  that fermenter is not being changed.

  :user_id should be validated with validate_required and assoc_constraint
  before calling this function.  Although it makes the code a bit gross,
  the function checks that :user_id is set just in case.
  """
  defp validate_fermenter(changeset) do
    fermenter_id =
      case fetch_change(changeset, :fermenter_id) do
        :error -> nil
        {:ok, fid} -> fid
      end

    user_id =
      case fetch_field(changeset, :user_id) do
        :error -> :error
        {_, uid} -> uid
      end

    cond do
      fermenter_id && user_id ->
        case Repo.get_by(Brewbase.Fermenter, id: fermenter_id, user_id: user_id) do
          nil ->
            changeset |> add_error(:fermenter, @error_messages.fermenter.invalid)
          fermenter -> changeset
        end
      user_id == :error ->
        changeset |> add_error(:fermenter, @error_messages.fermenter.invalid)
      user_id -> changeset
    end

  end

  @doc """
  Builds a simpler changeset for setting the bottle date and, optionally,
  the estimated drinkable date of a brew batch.
  """
  def bottle_batch_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:bottle_date, :esimated_drinkable_date, :bottled_volume])
    |> validate_required([:bottle_date])
  end

  @doc """
  Simple helper changeset for setting the date a batch is transferred to
  a secondary fermenter and the fermenter it has been transferred to
  """
  def secondary_fermenter_date_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:secondary_fermenter_date, :fermenter])
    |> validate_required([:secondary_fermenter_date])
    |> cast_assoc(:fermenter, required: false)
  end
end
