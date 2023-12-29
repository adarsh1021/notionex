# Notionex

A simple Elixir client for the [Notion API](https://developers.notion.com) that is also capable of rendering Notion pages into various formats like HTML, markdown and more.

## Installation

Add `notionex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:notionex, "~> 0.1.0"}
  ]
end
```

## Basic Usage

Setup the Notion API bearer token in your configuration:

```elixir
config :notionex,
  bearer_token: ""
```

Then use the `Notionex` module to make an API call to Notion:

```elixir
iex(1)> Notionex.request(%{page_id: "240db7dd3cc241fb9739d491a6016562"}, :retrieve_page)
%{
  __struct__: Notionex.Object.Page,
  archived: false,
  cover: nil,
  created_by: %{
    "id" => "a4c1f693-1e77-4ea1-9539-18869c53c164",
    "object" => "user"
  },
  created_time: "2023-12-23T09:07:00.000Z",
  icon: nil,
  id: "240db7dd-3cc2-41fb-9739-d491a6016562",
  last_edited_by: %{
    "id" => "a4c1f693-1e77-4ea1-9539-18869c53c164",
    "object" => "user"
  },
  last_edited_time: "2023-12-29T13:00:00.000Z",
  object: "page",
  parent: %{
    "database_id" => "0f45e8e6-a9a6-48cb-b234-c49445bc9910",
    "type" => "database_id"
  },
  properties: %{
    "Name" => %{
      "id" => "title",
      "title" => [
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
          "plain_text" => "Hello World",
          "text" => %{"content" => "Hello World", "link" => nil},
          "type" => "text"
        }
      ],
      "type" => "title"
    },
    "Tags" => %{
      "id" => "X%5EZs",
      "multi_select" => [],
      "type" => "multi_select"
    }
  },
  public_url: "https://faint-amaryllis-f9e.notion.site/Hello-World-240db7dd3cc241fb9739d491a6016562",
  request_id: "7418d76d-f752-4cf3-9db1-da60767b88ac",
  url: "https://www.notion.so/Hello-World-240db7dd3cc241fb9739d491a6016562"
}
```

Render a Notion page in HTML:

```elixir
iex(1)> Notionex.render_page("240db7dd3cc241fb9739d491a6016562")
"<p>Hello world!</p>"
```

Full documentation can be found at [https://hexdocs.pm/notionex](https://hexdocs.pm/notionex).
