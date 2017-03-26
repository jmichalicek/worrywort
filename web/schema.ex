defmodule Brewbase.Schema do
  @moduledoc """
  GraphQL schema for Brewbase
  """
  use Absinthe.Schema
  
  import_types Brewbase.Schema.Types

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
 
  # Code Omitted
  end
end
