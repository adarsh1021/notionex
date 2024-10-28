defmodule Notionex do
  @moduledoc """
  Notionex is a simple Elixir client for the [Notion API](https://developers.notion.com)
  that is also capable of rendering Notion pages into various formats like HTML, markdown and more.

  """

  alias Notionex.API

  @doc feature: :api
  def request(request_params, endpoint, opts \\ %{}) do
    apply(API, endpoint, [request_params, opts])
  end

  @doc feature: :renderer
  def render_block(block_id, opts \\ %{}) do
    %{block_id: block_id}
    |> request(:retrieve_block, opts)
    |> Notionex.Renderer.HTMLRenderer.render_block(opts)
  end

  @doc feature: :renderer
  def render_page(page_id, opts \\ %{}) do
    %{block_id: page_id}
    |> request(:retrieve_block_children, opts)
    |> Notionex.Renderer.HTMLRenderer.render_block(opts)
  end
end
