defmodule Notionex.Client do
  alias Notionex.Client.Request

  @default_base_url "https://api.notion.com/v1"

  @spec request!(Request.t()) :: any()
  def request!(%Request{} = request) do
    headers = [
      {"authorization", "Bearer #{Application.fetch_env!(:notionex, :bearer_token)}"},
      {"Notion-Version", "2022-06-28"},
      {"Content-Type", "application/json"},
      {"user-agent", "notionex-client"}
    ]

    url = "#{Application.get_env(:notionex, :base_url, @default_base_url)}/#{request.url}"
    body = if request.body == nil, do: "", else: Jason.encode!(request.body)

    %HTTPoison.Request{
      method: request.method,
      url: url,
      body: body,
      headers: headers,
      params: request.params
    }
    |> do_request()
    |> case do
      {:ok, body} ->
        Jason.decode!(body)

      {:error, error} ->
        raise error
    end
  end

  defp do_request(%HTTPoison.Request{} = request) do
    case HTTPoison.request(request) do
      {:ok, %{status_code: status_code, body: body}} when status_code in 200..299 ->
        {:ok, body}

      {:ok, %{status_code: status_code} = resp} when status_code >= 400 ->
        {:error, "Client error: #{inspect(resp)}"}

      {:error, resp} ->
        {:error, "HTTPoison error: #{inspect(resp)}"}
    end
  end
end
