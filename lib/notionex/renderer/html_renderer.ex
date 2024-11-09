defmodule Notionex.Renderer.HTMLRenderer do
  @behaviour Notionex.Renderer

  alias Notionex.Object.{Block, List}

  @impl true
  def render_block(
        %List{object: "list", type: "block", results: results},
        opts
      ) do
    results
    |> Enum.reduce([], fn block, acc ->
      updated_block = update_numbered_list_item_number(block, Enum.at(acc, 0))
      [updated_block | acc]
    end)
    |> Enum.reverse()
    |> Enum.map(fn b ->
      # Check for custom renderer
      # Current limitation is that custom renderer is only applied if called from the top level List block.
      # TODO: Move to different function
      custom_render_fn = Map.get(opts, :custom, %{}) |> Map.get({b.object, b.type})

      block_content =
        case custom_render_fn do
          nil -> render_block(b, opts)
          _ -> custom_render_fn.(b, opts)
        end

      # TODO: allow custom renderer for children
      child_content =
        if b.has_children do
          child_blocks = Notionex.API.retrieve_block_children(%{block_id: b.id})
          render_block(child_blocks, opts)
        else
          ""
        end

      "<div>#{block_content}#{child_content}</div>"
    end)
    |> Enum.join("<br />")
  end

  @doc """
  Renders the paragraph block into HTML.

  ## Example
      iex> Notionex.Renderer.HTMLRenderer.render_block(%Notionex.Object.Block{object: "block", type: "paragraph", paragraph: %{"color" => "default","rich_text" => [%{"annotations" => %{"bold" => false,"code" => false,"color" => "default","italic" => false,"strikethrough" => false,"underline" => false},"href" => nil,"plain_text" => "Hello world!","text" => %{"content" => "Hello world!", "link" => nil},"type" => "text"}]}}, %{})
      "<p>Hello world!</p>"
  """
  def render_block(%Block{object: "block", type: "paragraph", paragraph: paragraph}, _opts) do
    paragraph
    |> render_rich_text()
    |> then(&"<p>#{&1}</p>")
  end

  def render_block(%Block{object: "block", type: "heading_1", heading_1: heading_1}, _opts) do
    heading_1
    |> render_rich_text()
    |> then(&"<h1>#{&1}</h1>")
  end

  def render_block(%Block{object: "block", type: "heading_2", heading_2: heading_2}, _opts) do
    heading_2
    |> render_rich_text()
    |> then(&"<h3>#{&1}</h3>")
  end

  def render_block(%Block{object: "block", type: "heading_3", heading_3: heading_3}, _opts) do
    heading_3
    |> render_rich_text()
    |> then(&"<h5>#{&1}</h5>")
  end

  def render_block(
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

  def render_block(
        %Block{
          object: "block",
          type: "bulleted_list_item",
          bulleted_list_item: bullet_list_item
        },
        _opts
      ) do
    bullet_list_item
    |> render_rich_text()
    |> then(&"<ul><li>#{&1}</li></ul>")
  end

  def render_block(%Block{object: "block", type: "code", code: code}, _opts) do
    code
    |> render_rich_text()
    |> then(&"<pre><code>#{&1}</code></pre>")
  end

  # TODO: Handle caption
  def render_block(%Block{object: "block", type: "video", video: video}, _opts) do
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
  def render_block(%Block{object: "block", type: "image", image: image}, _opts) do
    case Map.get(image, "type") do
      "external" ->
        image
        |> get_in(["external", "url"])
        |> then(&"<img src=\"#{&1}\" />")

      "file" ->
        image
        |> get_in(["file", "url"])
        |> then(&"<img src=\"#{&1}\" />")

      _ ->
        raise "Block type image, not implemented type: #{Map.get(image, "type")}"
    end
  end

  # TODO: Handle caption
  def render_block(%Block{object: "block", type: "bookmark", bookmark: bookmark}, _opts) do
    bookmark
    |> Map.get("url")
    |> then(&"<a href=\"#{&1}\">#{&1}</a>")
  end

  def render_block(%Block{object: "block", type: "quote", quote: blockquote}, _opts) do
    blockquote
    |> render_rich_text()
    |> then(&"<blockquote>#{&1}</blockquote>")
  end

  def render_block(%Block{object: "block", type: "embed", embed: embed}, _opts) do
    "<iframe width=\"560px\" height=\"315px\" src=\"#{Map.get(embed, "url")}\" frameborder=\"0\" allowfullscreen></iframe>"
  end

  # Not sure what to do with these
  def render_block(%Block{object: "block", type: "column"}, _opts) do
    ""
  end

  def render_block(%Block{object: "block", type: "column_list"}, _opts) do
    ""
  end

  def render_block(%Block{object: "block", type: type}, _opts) do
    raise "Block type not implemented: #{type}"
  end

  @impl true
  def render_rich_text(%{"rich_text" => rich_text}) do
    render_rich_text(rich_text)
  end

  def render_rich_text(rich_text_list) when is_list(rich_text_list) do
    rich_text_list
    |> Enum.map(&render_rich_text/1)
    |> Enum.join("")
  end

  def render_rich_text(%{"type" => "text"} = rich_text) do
    rich_text
    |> apply_annotations()
  end

  def render_rich_text(_, _), do: ""

  def apply_annotations(%{"type" => "text", "annotations" => annotations} = rich_text) do
    content = get_in(rich_text, ["text", "content"])

    annotations
    |> Enum.reduce(content, fn
      {"bold", true}, acc -> "<strong>#{acc}</strong>"
      {"italic", true}, acc -> "<em>#{acc}</em>"
      {"strikethrough", true}, acc -> "<del>#{acc}</del>"
      {"underline", true}, acc -> "<u>#{acc}</u>"
      {"code", true}, acc -> "<code>#{acc}</code>"
      {"color", "default"}, acc -> acc
      _, acc -> acc
    end)
  end

  ## Helpers

  # Current and prev blocks are numbered_list_items
  def update_numbered_list_item_number(
        %Block{type: "numbered_list_item"} = block,
        %Block{
          type: "numbered_list_item",
          numbered_list_item_number: numbered_list_item_number
        } = _prev_block
      ) do
    block
    |> Map.put(:numbered_list_item_number, numbered_list_item_number + 1)
  end

  # Current block is numbered_list_item, prev block is not
  def update_numbered_list_item_number(
        %Block{type: "numbered_list_item"} = block,
        _prev_block
      ) do
    block
    |> Map.put(:numbered_list_item_number, 1)
  end

  def update_numbered_list_item_number(block, _prev_block), do: block
end
