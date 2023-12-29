defmodule Notionex do
  alias Notionex.API

  @doc feature: :api
  def request(request_params, endpoint, opts \\ []) do
    apply(API, endpoint, [request_params, opts])
  end

  @doc feature: :renderer
  def render_block(block_id, opts \\ []) do
    %{block_id: block_id}
    |> request(:retrieve_block, opts)
    |> Notionex.Renderer.HTMLRenderer.render_block()
  end

  @doc feature: :renderer
  def render_page(page_id, opts \\ []) do
    %{block_id: page_id}
    |> request(:retrieve_block_children, opts)
    |> Notionex.Renderer.HTMLRenderer.render_block()
  end
end
