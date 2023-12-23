defmodule Notionex.Renderer.Block do
  alias Notionex.Object

  @callback blocks(%Object.List{}) :: any
  @callback block(%Object.Block{}) :: any
end
