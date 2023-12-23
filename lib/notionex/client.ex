defmodule Notionex.Client do
  alias Notionex.Client.Request

  @spec request!(Request.t()) :: any()
  def request!(%Request{} = request) do
    headers = [
      {"authorization", "Bearer #{Application.fetch_env!(:notionex, :bearer_token)}"},
      {"Notion-Version", "2022-06-28"},
      {"user-agent", "notionex-client"}
    ]

    %HTTPoison.Request{
      method: request.method,
      url: "#{Application.fetch_env!(:notionex, :base_url)}/#{request.url}",
      body: request.body,
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
