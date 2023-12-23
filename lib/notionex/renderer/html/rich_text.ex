defmodule Notionex.Renderer.HTML.RichText do
  @behaviour Notionex.Renderer.RichText

  @impl true
  def text(text) when is_list(text) do
    text
    |> Enum.map(&text/1)
    |> Enum.join("")
  end

  def text(%{"type" => "text"} = rich_text) do
    rich_text
    |> apply_annotations()
  end

  def text(_), do: ""

  defp apply_annotations(%{"type" => "text", "annotations" => annotations} = rich_text) do
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
end
