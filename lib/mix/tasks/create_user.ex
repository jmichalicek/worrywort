defmodule Mix.Tasks.CreateUser do
  use Mix.Task

  # TODO: Set up to use any old user model by configuratioon
  alias Brewbase.User

  # TODO: handle password
  @switches  [first_name: :string, last_name: :string, email: :string,
              password: :string, is_active: :boolean]
  @aliases [f: :first_name, l: :last_name, e: :email, a: :is_active, p: :password]
  @shortdoc "Creates a User in the database"
  def run(args) do
    #user = User.changeset(%{})
    {options, a, errors} = OptionParser.parse(args, switches: @switches, aliases: @aliases)
    #IO.inspect(options)
    #u = User.changeset(options)
    #IO.inspect(u)
    IO.inspect(options)
    if !list_empty?(errors) do
      print_errors(errors)
    else
      IO.puts "Doing it!"
      create_user(options)
    end
  end

  def list_empty?([]) do
    true
  end

  def list_empty?(list) do
    false
  end

  def print_help() do
  end

  def print_errors(errors) do
    IO.inspect(errors)
  end

  def create_user(options) do
    IO.puts(!options[:is_active])
    # if not for the password/password confirmation we could just use
    # Enum.into(options)
    # the !options[:is_active] makes a default to true even if not specified
    params = %{
      :first_name => options[:first_name],
      :last_name => options[:last_name],
      :email => options[:email],
      :is_activte => !options[:is_active],
      :password => options[:password],
      :password_confirmation => options[:password]
    }
    User.changeset(%User{}, params)
  end
end
