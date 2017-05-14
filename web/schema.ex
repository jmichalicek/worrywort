defmodule Brewbase.Schema do
  @moduledoc """
  GraphQL schema for Brewbase
  """
  use Absinthe.Schema

  import_types Brewbase.Schema.Types
  alias Brewbase.Resolvers.FermenterResolver
  alias Brewbase.Resolvers.BatchResolver

  query do
    field :fermenters, list_of(:fermenter) do
      resolve &FermenterResolver.all/2
    end
    field :fermenter, type: :fermenter do
      arg :id, non_null(:id)
      resolve &FermenterResolver.get/2
    end

    field :batch, type: :batch do
      arg :id, non_null(:id)
      resolve &BatchResolver.get/2
    end
    field :batches, list_of(:batch) do
      resolve &BatchResolver.all/2
    end
  end

  mutation do
    #field :update_user, type: :user do
    #  arg :id, non_null(:integer)
    #arg :user, :update_user_params

    #resolve &Brewbase.UserResolver.update/2
    #end

    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Brewbase.Resolvers.UserResolver.login/2
    end

    # TODO: figure out how to enum these units, type, etc. ints
    field :create_fermenter, type: :fermenter do
      arg :name, non_null(:string)
      arg :description, :string
      arg :volume, non_null(:float)
      arg :units, non_null(:volume_unit)
      arg :type, non_null(:fermenter_type)
      arg :is_active, non_null(:boolean)

      resolve &FermenterResolver.create/2
    end

    field :create_batch, type: :batch do
      arg :boil_volume, non_null(:float)
      arg :brew_date, non_null(:datetime)
      arg :brew_notes, :string
      arg :estimated_bottling_date, :datetime
      arg :estimated_drinkable_date, :datetime
      arg :name, non_null(:string)
      arg :fermenter_id, non_null(:integer)
      arg :fermenter_volume, :float
      arg :boil_volume, :float
      arg :volume_units, non_null(:integer)
      arg :original_gravity, :float
      arg :recipe_url, :string

      resolve &BatchResolver.create/2
    end

  # Code Omitted
  end
end
