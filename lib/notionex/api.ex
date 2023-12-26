defmodule Notionex.API do
  alias Notionex.API.Request
  alias Notionex.Object.{Block, Page, List}

  @doc """
  Append block children.
  """
  def append_block_children(%{block_id: block_id, children: children} = params, opts \\ []) do
    %Request{
      method: :patch,
      url: "blocks/#{block_id}/children",
      body: Map.take(params, [:children, :after])
    }
    |> do_client_request(opts)
    |> List.new()
  end

  @doc """
  Retrieve a block.
  """
  def retrieve_block(%{block_id: block_id}, opts \\ []) do
    %Request{
      method: :get,
      url: "blocks/#{block_id}"
    }
    |> do_client_request(opts)
    |> Block.new()
  end

  @doc """
  Retrieve block children.
  """
  def retrieve_block_children(%{block_id: block_id} = params, opts \\ []) do
    %Request{
      method: :get,
      url: "blocks/#{block_id}/children",
      params: Map.take(params, [:start_cursor, :page_size])
    }
    |> do_client_request(opts)
    |> List.new()
  end

  @doc """
  Update block.
  """
  def update_block(%{block_id: block_id} = params, opts \\ []) do
    %Request{
      method: :patch,
      url: "blocks/#{block_id}",
      body: Map.take(params, [:archived])
    }
    |> do_client_request(opts)
    |> Block.new()
  end

  @doc """
  Delete a block.
  """
  def delete_block(%{block_id: block_id}, opts \\ []) do
    %Request{
      method: :delete,
      url: "blocks/#{block_id}"
    }
    |> do_client_request(opts)
    |> Block.new()
  end

  @doc """
  Retrieve a page.
  """
  def retrieve_page(%{page_id: page_id} = params, opts \\ []) do
    %Request{
      method: :get,
      url: "pages/#{page_id}",
      params: Map.take(params, :filter_properties)
    }
    |> do_client_request(opts)
    |> Page.new()
  end

  @doc """
  Query a database.
  """
  def query_database(%{database_id: database_id} = params, opts \\ []) do
    %Request{
      method: :post,
      url: "databases/#{database_id}/query",
      params: Map.take(params, :filter_properties),
      body: Map.take(params, [:filter, :sorts, :start_cursor, :page_size])
    }
    |> do_client_request(opts)
    |> List.new()
  end

  @default_base_url "https://api.notion.com/v1"
  @default_http_client Notionex.API.HTTPoisonClient

  # opts
  # - bearer_token
  # - base_url
  # - http_client
  def do_client_request(request, opts) do
    # Required config
    bearer_token = get_bearer_token(opts)

    # Check for overridable configs
    base_url = Application.get_env(:notionex, :base_url, @default_base_url)
    http_client = Application.get_env(:notionex, :http_client, @default_http_client)

    url = Path.join(base_url, request.url)
    body = if request.body == nil, do: "", else: Jason.encode!(request.body)
    headers = request.headers |> Map.put("authorization", "Bearer #{bearer_token}")

    request
    |> Map.put(:url, url)
    |> Map.put(:body, body)
    |> Map.put(:headers, headers)
    |> http_client.request!(opts)
  end

  defp get_bearer_token(opts) do
    # If bearer_token is passed in, use that
    # Otherwise, use the one from the config (throws an error if not set)
    with bearer_token when is_binary(bearer_token) <- Keyword.get(opts, :bearer_token) do
      bearer_token
    else
      nil ->
        Application.fetch_env!(:notionex, :bearer_token)
    end
  end
end
