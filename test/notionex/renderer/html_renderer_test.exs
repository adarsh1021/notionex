defmodule Notionex.Renderer.HTMLRendererTest do
  use ExUnit.Case

  @paragragh_block %Notionex.Object.Block{
    object: "block",
    type: "paragraph",
    paragraph: %{
      "color" => "default",
      "rich_text" => [
        %{
          "annotations" => %{
            "bold" => false,
            "code" => false,
            "color" => "default",
            "italic" => false,
            "strikethrough" => false,
            "underline" => false
          },
          "href" => nil,
          "plain_text" => "Hello world!",
          "text" => %{"content" => "Hello world!", "link" => nil},
          "type" => "text"
        }
      ]
    }
  }

  test "custom rendering" do
    blocks = %Notionex.Object.List{object: "list", type: "block", results: [@paragragh_block]}

    assert Notionex.Renderer.HTMLRenderer.render_block(blocks, %{}) ==
             "<div><p>Hello world!</p></div>"

    custom_opts = %{
      custom: %{
        {"block", "paragraph"} => fn %Notionex.Object.Block{
                                       object: "block",
                                       type: "paragraph",
                                       paragraph: paragraph
                                     },
                                     _opts ->
          paragraph
          |> Notionex.Renderer.HTMLRenderer.render_rich_text()
          |> then(&"<custom>#{&1}</custom>")
        end
      }
    }

    assert Notionex.Renderer.HTMLRenderer.render_block(blocks, custom_opts) ==
             "<div><custom>Hello world!</custom></div>"
  end
end
