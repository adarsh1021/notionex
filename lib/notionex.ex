defmodule Notionex do
  @moduledoc """
  Notionex is a simple Elixir client for the [Notion API](https://developers.notion.com)
  that is also capable of rendering Notion pages into various formats like HTML, markdown and more.

  """

  alias Notionex.API

  @doc feature: :api
  def request(request_params, endpoint, opts \\ []) do
    apply(API, endpoint, [request_params, opts])
  end

  @doc feature: :renderer
  def render_block(block_id, opts \\ []) do
    %{block_id: block_id}
    |> request(:retrieve_block, opts)
    # If upload to file store option is enabled, then
    # iterate through the blocks, and upload any file to the specified file store
    # args can be given in opts to specify the file store
    |> upload_to_file_store()
    |> Notionex.Renderer.HTMLRenderer.render_block()
  end

  @doc feature: :renderer
  def render_page(page_id, opts \\ []) do
    %{block_id: page_id}
    |> request(:retrieve_block_children, opts)
    |> Notionex.Renderer.HTMLRenderer.render_block()
  end
end
