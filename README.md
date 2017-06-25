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
  
## Development using Docker

A docker image has been set up configured with Elixir on Debian Jessie.
This repository contains a compose.yml which starts that container as well
as a separate postgres 9.6.2 container, sets most environment variables
with sane dev defaults, and mounts your current working directory (presumed
to be the root of this repository) into the container.

You will need to start the container ones to run the commands above to generate your secret key and add them to your environment
variables for docker-compose to pick up, then run docker-compose again.

The shell script docker-dev.sh is a bash script which starts docker compose and then drops you into a shell in the container for
running phoenix, and stops both th Elixir and Postgres containers when you exit.

* Install Docker and docker-compose for your platform
* docker pull worrywort/worrywort:dev
* docker pull postgres:9.6.2
* ./docker-dev.sh

### Running the docker client under WSL
If you are developing on Windows you may choose to use Docker for Windows but use WSL for the bash and Ubuntu environment.  In
this case you will need to add a few steps on top of installing docker for windows.install the docker client and docker-compose
under WSL.

From within WSL:
* Install docker-ce and docker-compose for Ubuntu 14.04
* Bind mount /c to /mnt/c - Due to interactions between Docker, Windows, WSL, and the Moby VM access to the source directory is not straightforward.  We need to create a path in WSL which also exists on the Moby VM where the code can be accessed
  * sudo mkdir /c
  * sudo mount --bind /mnt/c /c
  * cd /c/path/to/code
  * ./docker-dev.sh

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
