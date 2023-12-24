defmodule Notionex.API.Databases do
  alias Notionex.Client
  alias Notionex.Object.List

  def query(database_id, opts \\ %{}) do
    filter_properties = opts |> Map.get(:filter_properties, [])
    body_params = opts |> Map.take([:sorts, :filter, :start_cursor, :page_size, :archived])

    %Notionex.Client.Request{
      method: :post,
      url: "databases/#{database_id}/query",
      params: filter_properties,
      body: body_params
    }
    |> Client.request!()
    |> List.new()
  end
end
