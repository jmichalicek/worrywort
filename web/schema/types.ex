defmodule Brewbase.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Brewbase.Repo
 
  object :user do
    field :id, :id
    field :first_name, :string
    field :email, :string
    #field :batches, list_of(:batch), resolve: assoc(:batches)
  end
 
  object :batch do
    field :id, :id
    field :name, :string
    field :brew_notes, :string
    field :user, :user, resolve: assoc(:user)
    field :fermenter, :fermenter, resolve: assoc(:fermenter)
    field :boil_volume, :float
    field :volume_units, :integer
    field :original_gravity, :float
    # TODO: add fermenter and other info
  end

  object :fermenter do
    field :id, :id
    field :name, :string
    field :is_active, :boolean
    field :is_available, :boolean
    field :user, :user, resolve: assoc(:user)
  end
 
  object :session do
    field :token, :string
  end
end
