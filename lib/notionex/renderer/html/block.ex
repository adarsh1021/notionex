defmodule Notionex.Renderer.HTML.Block do
  @behaviour Notionex.Renderer.Block

  alias Notionex.Object.{Block, List}
  alias Notionex.Renderer.Utils
  alias Notionex.Renderer.HTML.RichText

  @impl true
  def blocks(%List{object: "list", type: "block", results: results}, opts) do
    results
    |> Enum.reduce([], fn block, acc ->
      updated_block = Utils.update_numbered_list_item_number(block, Enum.at(acc, 0))
      [updated_block | acc]
    end)
    |> Enum.reverse()
    |> Enum.map(fn b -> block(b, opts) end)
    |> Enum.join("<br />")
  end

  @impl true
  def block(%Block{object: "block", type: "paragraph", paragraph: paragraph}, _opts) do
    paragraph
    |> render_rich_text()
    |> then(&"<p>#{&1}</p>")
  end

  def block(%Block{object: "block", type: "heading_1", heading_1: heading_1}, _opts) do
    heading_1
    |> render_rich_text()
    |> then(&"<h1>#{&1}</h1>")
  end

  def block(%Block{object: "block", type: "heading_2", heading_2: heading_2}, _opts) do
    heading_2
    |> render_rich_text()
    |> then(&"<h3>#{&1}</h3>")
  end

  def block(%Block{object: "block", type: "heading_3", heading_3: heading_3}, _opts) do
    heading_3
    |> render_rich_text()
    |> then(&"<h5>#{&1}</h5>")
  end

  def block(
        %Block{
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

  def block(%Block{object: "block", type: "code", code: code}, _opts) do
    code
    |> render_rich_text()
    |> then(&"<pre><code>#{&1}</code></pre>")
  end

  # TODO: Handle caption
  def block(%Block{object: "block", type: "video", video: video}, _opts) do
    case Map.get(video, "type") do
      "external" ->
        video
        |> get_in(["external", "url"])
        |> then(&"<iframe src=\"#{&1}\" frameborder=\"0\" allowfullscreen></iframe>")

      _ ->
        raise "Block type video, not implemented type: #{Map.get(video, "type")}"
    end
  end

  # TODO: Handle caption
  def block(%Block{object: "block", type: "image", image: image}, _opts) do
    case Map.get(image, "type") do
      "external" ->
        image
        |> get_in(["external", "url"])
        |> then(&"<img src=\"#{&1}\" />")

      _ ->
        raise "Block type image, not implemented type: #{Map.get(image, "type")}"
    end
  end

  # TODO: Handle caption
  def block(%Block{object: "block", type: "bookmark", bookmark: bookmark}, _opts) do
    bookmark
    |> Map.get("url")
    |> then(&"<a href=\"#{&1}\">#{&1}</a>")
  end

  def block(%Block{object: "block", type: type}, _) do
    raise "Block type not implemented: #{type}"
  end

  # Helpers

  defp render_rich_text(block_type_obj) do
    block_type_obj
    |> Map.get("rich_text")
    |> RichText.text()
  end
end
