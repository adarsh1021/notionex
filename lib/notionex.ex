defmodule Notionex do
  alias Notionex.Object

  def render_block(
        %Object.List{object: "list", type: "block"} = blocks,
        renderer \\ Notionex.Renderer.HTML.Block,
        opts \\ %{}
      ) do
    apply(renderer, :blocks, [blocks, opts])
  end
end
