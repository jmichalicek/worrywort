# Brewbase

A toy project for tracking homebrew batches written using Elixir/Phoenix
with a GraphQL API and likely React front end.

## Getting Started
* Generate a secret key base - mix phoenix.gen.secret
* Generate a guardian secret key
  * Use one of the following (or any other valid secret key gen command you like)
    * JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
    * JOSE.JWS.generate_key(%{"alg" => "HS256"}) |> JOSE.JWK.to_map |> elem(1)
    * JOSE.JWS.generate_key(%{"alg" => "HS512"}) |> JOSE.JWK.to_map |> elem(1)
  * Easiest to then copy the "k" value as a string for the env

## TODO

* Test cases - any of them.  Particularly user and auth at the moment.
* Make it easier to handle the guardian key in other ways, using EC algorithms, from files, etc.
* Set up shell and batch scripts to run development docker env

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
