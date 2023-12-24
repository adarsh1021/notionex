defmodule Notionex.Client.Request do
  # ref - https://github.com/edgurgel/httpoison/blob/main/lib/httpoison.ex

  @type method :: :get | :post | :put | :delete
  @type url :: binary | any
  @type body :: binary | any
  @type params :: map | keyword | [{binary, binary}] | any

  @type t() :: %{
          method: method,
          url: binary,
          body: body,
          params: params
        }

  defstruct method: :get, url: nil, body: nil, params: %{}
end
