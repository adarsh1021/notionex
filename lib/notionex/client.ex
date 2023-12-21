defmodule Notionex.Client do
  alias Notionex.Config
  alias Notionex.Client.Request

  @spec request(Request.t()) :: {:ok, any()} | {:error, any()}
  def request(%Request{} = request) do
    headers = [
      {"authorization", "Bearer #{Config.bearer_token()}"},
      {"Notion-Version", "2022-06-28"},
      {"user-agent", "notionex-client"}
    ]

    %HTTPoison.Request{
      method: request.method,
      url: "#{Config.base_url()}/#{request.url}",
      body: request.body,
      headers: headers,
      params: request.params,
    }
    |> HTTPoison.request()
  end
end
