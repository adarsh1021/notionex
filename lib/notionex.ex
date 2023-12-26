defmodule Notionex do
  # alias Notionex.Object
  alias Notionex.API

  def request(request_params, endpoint, opts \\ []) do
    apply(API, endpoint, [request_params, opts])
  end

  def render_page(page_id, opts \\ []) do
    %{block_id: page_id}
    |> request(:retrieve_block_children, opts)
    |> Notionex.Renderer.HTMLRenderer.render_block()
  end
end
