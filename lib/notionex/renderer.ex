defmodule Notionex.Renderer do
  alias Notionex.Object

  @callback render_block(%Object.Block{}) :: any()
  @callback render_rich_text(map) :: any()
end
