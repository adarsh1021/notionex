defmodule Notionex.Renderer.HTML.Block do
  @behaviour Notionex.Renderer.Block

  alias Notionex.Object
  alias Notionex.Renderer.HTML.RichText

  @impl true
  def blocks(%Object.List{object: "list", type: "block", results: results}) do
    results
    |> Enum.map(&block/1)
    |> Enum.join("\n")
  end

  @impl true
  def block(%Object.Block{object: "block", type: "paragraph", paragraph: paragraph} = block) do
    paragraph
    |> Map.get("rich_text")
    |> RichText.text()
  end

  def block(_) do
    nil
  end
end
