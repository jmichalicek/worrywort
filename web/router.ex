defmodule Brewbase.Router do
  use Brewbase.Web, :router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Brewbase.Plugs.SessionUser, repo: Brewbase.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Brewbase.Plugs.GraphQLContext
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/", Brewbase do
    pipe_through [:browser, :browser_auth] # Use the default browser stack
  
    get "/", PageController, :index

    # auth views
    get "/login", AuthController, :index
    post "/login", AuthController, :callback
    get "/logout", AuthController, :logout
  end

  scope "/graphql" do
    pipe_through :graphql
 
    forward "/v1", Absinthe.Plug,
      schema: Brewbase.Schema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: Brewbase.Schema

  # Other scopes may use custom stacks.
  # scope "/api", Brewbase do
  #   pipe_through :api
  # end
end
