defmodule Notionex.Renderer.HTML.RichText do
  @behaviour Notionex.Renderer.RichText

  @impl true
  def text(text) when is_list(text) do
    text
    |> Enum.map(&text/1)
    |> Enum.join("")
  end

  def text(%{"type" => "text"} = rich_text) do
    plain_text = Map.get(rich_text, "plain_text")
    "<p>#{plain_text}</p>"
  end

  def text(_), do: ""

  # defp text(%{link: %{url: url}, content: content}) do
  #   "<a href=\"#{url}\">#{text(content)}</a>"
  # end

  # defp text(%{annotations: %{bold: true}, content: content}) do
  #   "<strong>#{text(content)}</strong>"
  # end

  # defp text(%{annotations: %{italic: true}, content: content}) do
  #   "<em>#{text(content)}</em>"
  # end

  # defp text(%{annotations: %{strikethrough: true}, content: content}) do
  #   "<del>#{text(content)}</del>"
  # end

  # defp text(%{annotations: %{underline: true}, content: content}) do
  #   "<u>#{text(content)}</u>"
  # end

  # defp text(%{annotations: %{code: true}, content: content}) do
  #   "<code>#{text(content)}</code>"
  # end

  # defp text(%{annotations: %{color: color}, content: content}) do
  #   "<span style=\"color: #{color}\">#{text(content)}</span>"
  # end

  # defp text(%{annotations: %{color_background: color}, content: content}) do
  #   "<span style=\"background-color: #{color}\">#{text(content)}</span>"
  # end

  # defp text(%{annotations: %{color: color, color_background: background}, content: content}) do
  #   "<span style=\"color: #{color}; background-color: #{background}\">#{text(content)}</span>"
  # end

  # defp text(%{content: content}) do
  #   content
  # end
end
