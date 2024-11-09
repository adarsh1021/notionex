defmodule Notionex.API do
  alias Notionex.API.Request
  alias Notionex.Object.{Block, Page, List, Parent, Database}

  @doc endpoint: :block
  @doc """
  Append block children.
  """
  def append_block_children(%{block_id: block_id, children: _children} = params, opts \\ %{}) do
    %Request{
      method: :patch,
      url: "blocks/#{block_id}/children",
      body: Map.take(params, [:children, :after])
    }
    |> do_client_request(opts)
    |> List.new()
  end

  @doc endpoint: :block
  @doc """
  Retrieve a block.
  """
  def retrieve_block(%{block_id: block_id}, opts \\ %{}) do
    %Request{
      method: :get,
      url: "blocks/#{block_id}"
    }
    |> do_client_request(opts)
    |> Block.new()
  end

  @doc endpoint: :block
  @doc """
  Retrieve block children.
  """
  def retrieve_block_children(%{block_id: block_id} = params, opts \\ %{}) do
    %Request{
      method: :get,
      url: "blocks/#{block_id}/children",
      params: Map.take(params, [:start_cursor, :page_size])
    }
    |> do_client_request(opts)
    |> List.new()
  end

  @doc endpoint: :block
  @doc """
  Update block.
  """
  def update_block(%{block_id: block_id} = params, opts \\ %{}) do
    %Request{
      method: :patch,
      url: "blocks/#{block_id}",
      body: Map.take(params, [:archived])
    }
    |> do_client_request(opts)
    |> Block.new()
  end

  @doc endpoint: :block
  @doc """
  Delete a block.
  """
  def delete_block(%{block_id: block_id}, opts \\ %{}) do
    %Request{
      method: :delete,
      url: "blocks/#{block_id}"
    }
    |> do_client_request(opts)
    |> Block.new()
  end

  @doc endpoint: :page
  @doc """
  Create a page.
  """
  def create_page(%{parent: _parent, properties: _properties} = params, opts \\ %{}) do
    %Request{
      method: :post,
      url: "pages",
      body: Map.take(params, [:parent, :properties, :children, :icon, :cover])
    }
    |> do_client_request(opts)
    |> Page.new()
  end

  @doc endpoint: :page
  @doc """
  Retrieve a page.
  """
  def retrieve_page(%{page_id: page_id} = params, opts \\ %{}) do
    %Request{
      method: :get,
      url: "pages/#{page_id}",
      params: Map.take(params, [:filter_properties])
    }
    |> do_client_request(opts)
    |> Page.new()
  end

  @doc endpoint: :page
  @doc """
  Retrieve a page property item.
  """
  def retrieve_page_property(%{page_id: page_id, property_id: property_id} = params, opts \\ %{}) do
    %Request{
      method: :get,
      url: "pages/#{page_id}/properties/#{property_id}",
      params: Map.take(params, [:page_size, :start_cursor])
    }
    |> do_client_request(opts)
  end

  @doc endpoint: :page
  @doc """
  Update page properties.
  """
  def update_page_properties(%{page_id: page_id} = params, opts \\ %{}) do
    %Request{
      method: :patch,
      url: "pages/#{page_id}",
      body: Map.take(params, [:properties, :archived, :icon, :cover])
    }
    |> do_client_request(opts)
    |> Page.new()
  end

  @doc endpoint: :database
  @doc """
  Create a database.
  """
  def create_database(%{parent: %Parent{}, properties: _properties} = params, opts \\ %{}) do
    %Request{
      method: :post,
      url: "databases",
      body: Map.take(params, [:parent, :title, :properties])
    }
    |> do_client_request(opts)
    |> Database.new()
  end

  @doc endpoint: :database
  @doc """
  Query a database.
  """
  def query_database(%{database_id: database_id} = params, opts \\ %{}) do
    %Request{
      method: :post,
      url: "databases/#{database_id}/query",
      params: Map.take(params, [:filter_properties]),
      body: Map.take(params, [:filter, :sorts, :start_cursor, :page_size])
    }
    |> do_client_request(opts)
    |> List.new()
  end

  @doc endpoint: :database
  @doc """
  Retrieve a database.
  """
  def retrieve_database(%{database_id: database_id}, opts \\ %{}) do
    %Request{
      method: :get,
      url: "databases/#{database_id}"
    }
    |> do_client_request(opts)
    |> Database.new()
  end

  @doc endpoint: :database
  @doc """
  Update a database.
  """
  def update_database(%{database_id: database_id} = params, opts \\ %{}) do
    %Request{
      method: :patch,
      url: "databases/#{database_id}",
      body: Map.take(params, [:title, :description, :properties])
    }
    |> do_client_request(opts)
    |> Database.new()
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
    with bearer_token when is_binary(bearer_token) <- Map.get(opts, :bearer_token) do
      bearer_token
    else
      nil ->
        Application.fetch_env!(:notionex, :bearer_token)
    end
  end
end
