defmodule Notionex.Object.Block do
  alias Notionex.Object

  @type t() ::
          Object.t()
          | %{
              parent: Object.Parent.t(),
              type: binary,
              has_children: boolean,
              # All block types
              bookmark: map(),
              breadcrumb: map(),
              bulleted_list_item: map(),
              callout: map(),
              child_database: map(),
              child_page: map(),
              column: map(),
              column_list: map(),
              divider: map(),
              embed: map(),
              equation: map(),
              file: map(),
              heading_1: map(),
              heading_2: map(),
              heading_3: map(),
              image: map(),
              link_preview: map(),
              link_to_page: map(),
              numbered_list_item: map(),
              paragraph: map(),
              pdf: map(),
              quote: map(),
              synced_block: map(),
              table: map(),
              table_of_contents: map(),
              table_row: map(),
              template: map(),
              to_do: map(),
              toggle: map(),
              unsupported: map(),
              video: map()
            }

  defstruct parent: nil, type: nil, has_children: false

  def new(%{"object" => "block"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn {key, val}, acc ->
      acc
      |> Map.put(String.to_existing_atom(key), val)
    end)
  end
end
