defmodule Notionex do
  alias Notionex.Object

  def render_block(page_id, renderer \\ Notionex.Renderer.HTML.Block, opts \\ %{})
      when is_binary(page_id) do
    Notionex.API.Blocks.list(page_id)
    |> render_block(renderer, opts)
  end

  def render_block(
        %Object.List{object: "list", type: "block"} = blocks,
        renderer,
        opts
      ) do
    apply(renderer, :blocks, [blocks, opts])
  end
end
