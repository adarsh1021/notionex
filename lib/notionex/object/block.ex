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
              video: map(),
              code: map(),
              # Metadata / helpers
              numbered_list_item_number: integer()
            }

  defstruct Object.default_properties() ++
              [
                parent: nil,
                type: nil,
                has_children: false,
                # All block types
                bookmark: %{},
                breadcrumb: %{},
                bulleted_list_item: %{},
                callout: %{},
                child_database: %{},
                child_page: %{},
                column: %{},
                column_list: %{},
                divider: %{},
                embed: %{},
                equation: %{},
                file: %{},
                heading_1: %{},
                heading_2: %{},
                heading_3: %{},
                image: %{},
                link_preview: %{},
                link_to_page: %{},
                numbered_list_item: %{},
                paragraph: %{},
                pdf: %{},
                quote: %{},
                synced_block: %{},
                table: %{},
                table_of_contents: %{},
                table_row: %{},
                template: %{},
                to_do: %{},
                toggle: %{},
                unsupported: %{},
                video: %{},
                code: %{},
                # Metadata / helpers
                numbered_list_item_number: 0
              ]

  def new(%{"object" => "block"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn {key, val}, acc ->
      acc
      |> Map.put(String.to_existing_atom(key), val)
    end)
  end
end
