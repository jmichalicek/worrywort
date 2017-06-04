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
      arg :is_active, :boolean
      arg :is_available, :boolean
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

    field :create_fermenter, type: :fermenter do
      arg :fermenter, :fermenter_input
      #arg :name, non_null(:string)
      #arg :description, :string
      #arg :volume, non_null(:float)
      #arg :units, non_null(:volume_unit)
      #arg :type, non_null(:fermenter_type)
      #arg :is_active, non_null(:boolean)

      resolve &FermenterResolver.create/2
    end

    field :update_fermenter, type: :fermenter do
      arg :id, non_null(:id)
      arg :fermenter, :fermenter_input

      resolve &FermenterResolver.update/2
    end

    field :create_batch, type: :batch do
      arg :batch, :batch_input

      resolve &BatchResolver.create/2
    end

    field :update_batch, type: :batch do
      arg :id, non_null(:id)
      arg :batch, :batch_input

      resolve &BatchResolver.create/2
    end

  # Code Omitted
  end
end
