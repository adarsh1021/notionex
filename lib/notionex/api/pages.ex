defmodule Notionex.API.Pages do
  alias Notionex.Client

  @doc """
  Retrieve a page.
  """
  def retrieve(page_id, filter_properties \\ []) do
    struct(Notionex.Object.Page,
    %Client.Request{
      method: :get,
      url: "pages/#{page_id}",
      params: filter_properties
    }
    |> Client.request!())

  end
end
