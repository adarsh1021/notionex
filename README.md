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
  bearer_token: "<BEARER_TOKEN>"
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

## Notion API Client

Notionex provides a simple Elixir client for the Notion API, capable of making all the API calls listed in the [official documentation](https://developers.notion.com/reference/intro).

Requests can be made using the `Notionex.request/2` function. It takes two arguments:

1. `request_params` - A map containing all the parameters for the request. The keys and values of this map are specific to the API call being made, and can include path params, query params and body params. Notionex takes care of constructing the request and body based on the parameters provided.
2. `request_type` - An atom representing the type of request to be made. This can be one of the following:
   - Block Endpoints
     - `:append_block_children`
     - `:retrieve_block`
     - `:retrieve_block_children`
     - `:update_block`
     - `:delete_block`
   - Page Endpoints
     - `:create_page`
     - `:retrieve_page`
     - `retrieve_page_property`
     - `:update_page_property`
   - Database Endpoints
     - `:create_database`
     - `:query_database`
     - `:retrieve_database`
     - `:update_database`
3. Options:
   - `:bearer_token` - The Notion API bearer token to be used for the request. If not provided, the bearer token from the configuration will be used.
   - `:base_url` - The base URL to be used for the request. Defaults to `https://api.notion.com/v1`.
   - `:http_client` - The HTTP client to be used for the request. Defaults to `Notionex.API.HTTPoisonClient`.

## Notion Page Renderer

Notion pages can be rendered into various formats like HTML, markdown and more by implementing the `Notionex.Renderer` module. It includes two functions:

- `render_block/2`
- `render_rich_text/1`

Notionex already includes a HTML renderer that can be used to render Notion pages into HTML. It can be accessed using the `Notionex.Renderer.HTMLRenderer` module. Currently, it supports the following block types:

- [x] bookmark
- [ ] breadcrumb
- [x] bulleted_list_item
- [ ] callout
- [ ] child_database
- [ ] child_page
- [x] code
- [ ] column
- [ ] column_list
- [ ] divider
- [x] embed
- [ ] equation
- [ ] file
- [x] heading_1
- [x] heading_2
- [x] heading_3
- [x] image
- [ ] link_preview
- [ ] link_to_page
- [x] numbered_list_item
- [x] paragraph
- [ ] pdf
- [x] quote
- [ ] synced_block
- [ ] table
- [ ] table_of_contents
- [ ] table_row
- [ ] template
- [ ] to_do
- [ ] toggle
- [x] video
