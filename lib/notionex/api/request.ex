defmodule Notionex.API.Request do
  # ref - https://github.com/edgurgel/httpoison/blob/main/lib/httpoison.ex

  @type method :: :get | :post | :patch | :delete
  @type url :: binary | any
  @type body :: binary | any
  @type headers :: map | keyword | [{binary, binary}] | any
  @type params :: map | keyword | [{binary, binary}] | any

  @type t() :: %{
          method: method,
          url: binary,
          body: body,
          headers: headers,
          params: params
        }

  @default_headers %{
    "Notion-Version" => "2022-06-28",
    "Content-Type" => "application/json",
    "user-agent" => "notionex-client"
  }

  defstruct method: :get, url: nil, body: nil, headers: @default_headers, params: %{}
end
