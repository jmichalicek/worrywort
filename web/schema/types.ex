defmodule Brewbase.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Brewbase.Repo


  scalar :datetime, description: "RFC 3339/ISO 8601 datetime" do
    parse &Calendar.DateTime.Parse.rfc3339_utc(&1.value)
    serialize &Calendar.DateTime.Format.rfc3339(&1)
  end

  @desc "A user on the system"
  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    #field :batches, list_of(:batch), resolve: assoc(:batches)
  end

  enum :volume_unit do
    value :gallons, as: 0
    value :liters, as: 1
  end

  @desc "Input data for a brew batch"
  input_object :batch_input do
    @desc "The date the beer was bottled"
    field :bottle_date, :datetime
    @desc "The amount of beer transferred to bottles"
    field :bottle_volume, :float
    @desc "Estimated date the beer will be fermented and ready for bottling or kegging"
    field :estimated_bottling_date, :datetime
    @desc "Estimated date the bottled or kegged beer will be drinkable"
    field :estimated_drinkable_date, :datetime
    @desc "The volume of wort transferred to the fermenter"
    field :fermenter_volume, :float
    @desc "Measured final gravity of the beer"
    field :final_gravity, :float
    @desc "A short, descriptive name for the batch"
    field :name, :string
    @desc "URL to recipe online"
    field :recipe_url, :string
    @desc "Date and time of transfer to secondary fermenter, if one was used"
    field :secondary_fermenter_date, :datetime
    @desc "Notes about the brew process"
    field :brew_notes, :string
    @desc "The fermenter CURRENTLY in use by the brew batch"
    field :fermenter_id, :id
    @desc "Volume of water boiled, before boiling started"
    field :boil_volume, :float
    @desc "Units used for volumes"
    field :volume_units, non_null(:volume_unit)
    @desc "Measured OG"
    field :original_gravity, :float
    @desc "Date of brewing"
    field :brew_date, :datetime
  end

  @desc "A batch brewed by a user"
  object :batch do
    field :id, :id
    @desc "The date the beer was bottled"
    field :bottle_date, :datetime
    @desc "The amount of beer transferred to bottles"
    field :bottle_volume, :float
    @desc "Estimated date the beer will be fermented and ready for bottling or kegging"
    field :estimated_bottling_date, :datetime
    @desc "Estimated date the bottled or kegged beer will be drinkable"
    field :estimated_drinkable_date, :datetime
    @desc "The volume of wort transferred to the fermenter"
    field :fermenter_volume, :float
    @desc "Measured final gravity of the beer"
    field :final_gravity, :float
    @desc "A short, descriptive name for the batch"
    field :name, :string
    @desc "URL to recipe online"
    field :recipe_url, :string
    @desc "Date and time of transfer to secondary fermenter, if one was used"
    field :secondary_fermenter_date, :datetime
    @desc "Notes about the brew process"
    field :brew_notes, :string
    field :user, :user, resolve: assoc(:user)
    @desc "The fermenter CURRENTLY in use by the brew batch"
    field :fermenter, :fermenter, resolve: assoc(:fermenter)
    @desc "Volume of water boiled, before boiling started"
    field :boil_volume, :float
    @desc "Units used for volumes"
    field :volume_units, non_null(:volume_unit)
    @desc "Measured OG"
    field :original_gravity, :float
    @desc "Date of brewing"
    field :brew_date, :datetime

    @desc "Date the batch was created on the system"
    field :inserted_at, :datetime
    @desc "Date the batch was last updated"
    field :updated_at, :datetime
  end

  @desc "Enum of fermenter types"
  enum :fermenter_type do
    value :bucket, as: 0
    value :carboy, as: 1
    value :conical, as: 2
  end

  @desc "A beer fermentation vessel input"
  input_object :fermenter_input do
    field :name, :string
    field :is_active, :boolean
    field :is_available, :boolean
    field :type, non_null(:fermenter_type)
    field :units, non_null(:volume_unit)
    field :volume, :float
    field :description, :string
  end

  @desc "A beer fermentation vessel"
  object :fermenter do
    field :id, :id
    field :name, :string
    field :is_active, non_null(:boolean)
    field :is_available, non_null(:boolean)
    field :type, non_null(:fermenter_type)
    field :units, non_null(:volume_unit)
    field :volume, :float
    field :description, :string
    field :user, :user, resolve: assoc(:user)
  end

  @desc "A session for an API client"
  object :session do
    field :token, :string
  end
end
