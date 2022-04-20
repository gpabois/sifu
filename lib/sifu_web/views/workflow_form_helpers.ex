defmodule SifuWeb.WorkflowFormHelpers do 
  use Phoenix.HTML
  
  alias SifuWeb.FormHelpers

  import Phoenix.LiveView.Helpers
  import Workflow.Field

  def render_field(f, field) do
    FormHelpers.render_field(
        f,
        id(field),
        input_type(field),
        values: values(field),
        label: Workflow.Field.label(field)
    )
  end

  def render_fields(f, fields) do
    assigns = %{}
    ~H"""
        <%= for field <- Enum.filter(fields, &is_form_field?/1) do %>
            <%= render_field(f, field) %>
        <% end %>
    """
  end
end
