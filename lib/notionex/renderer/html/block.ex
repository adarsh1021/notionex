defmodule Notionex.Renderer.HTML.Block do
  @behaviour Notionex.Renderer.Block

  alias Notionex.Object
  alias Notionex.Renderer.Utils
  alias Notionex.Renderer.HTML.RichText

  @impl true
  def blocks(%Object.List{object: "list", type: "block", results: results}, opts) do
    results
    |> Enum.reduce([], fn block, acc ->
      updated_block = Utils.update_numbered_list_item_number(block, Enum.at(acc, 0))
      [updated_block | acc]
    end)
    |> Enum.reverse()
    |> Enum.map(fn b -> block(b, opts) end)
    |> Enum.join("\n")
  end

  @impl true
  def block(%Object.Block{object: "block", type: "paragraph", paragraph: paragraph}, _opts) do
    paragraph
    |> render_rich_text()
    |> then(&"<p>#{&1}</p>")
  end

  def block(%Object.Block{object: "block", type: "heading_1", heading_1: heading_1}, _opts) do
    heading_1
    |> render_rich_text()
    |> then(&"<h1>#{&1}</h1>")
  end

  def block(%Object.Block{object: "block", type: "heading_2", heading_2: heading_2}, _opts) do
    heading_2
    |> render_rich_text()
    |> then(&"<h3>#{&1}</h3>")
  end

  def block(%Object.Block{object: "block", type: "heading_3", heading_3: heading_3}, _opts) do
    heading_3
    |> render_rich_text()
    |> then(&"<h5>#{&1}</h5>")
  end

  def block(
        %Object.Block{
          object: "block",
          type: "numbered_list_item",
          numbered_list_item: numbered_list_item,
          numbered_list_item_number: numbered_list_item_number
        },
        _opts
      ) do
    numbered_list_item
    |> render_rich_text()
    # TODO: Wrap within <li> and let HTML generate the numbers
    |> then(&"#{numbered_list_item_number}. #{&1}")
    |> then(&"<ol>#{&1}</ol>")
  end

  def block(%Object.Block{object: "block", type: "code", code: code}, _opts) do
    code
    |> render_rich_text()
    |> then(&"<code>#{&1}</code>")
  end

  def block(%Object.Block{object: "block", type: type}, _) do
    raise "Block type not implemented: #{type}"
  end

  defp render_rich_text(block_type_obj) do
    block_type_obj
    |> Map.get("rich_text")
    |> RichText.text()
  end
end
