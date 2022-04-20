defmodule SifuWeb.FormHelpers do 
    use Phoenix.HTML

    import SifuWeb.ErrorHelpers
    import Phoenix.LiveView.Helpers
 
    def render_field(f, id, input_type, opts \\ []) do
      assigns = %{
          id: id,
          label: Keyword.get(opts, :label, id),
          values: Keyword.get(opts, :values, [])
      }
      
      ~H"""
      <%= case input_type do %>
      <% :text -> %>
          <div class="fr-form-group">
              <%= label f, @id, @label, class: "fr-label" %>
              <%= text_input f, @id, class: "fr-input" %>
              <%= error_tag f, @id %>
          </div>
      <% :password -> %>
        <div class="fr-form-group">
            <%= label f, @id, @label, class: "fr-label" %>
            <%= password_input f, @id, class: "fr-input" %>
            <%= error_tag f, @id %>
        </div>          
      <% :textarea -> %>
          <div class="fr-form-group">
              <%= label f, @id, @label, class: "fr-label" %>
              <%= textarea f, @id, class: "fr-input" %>
              <%= error_tag f, @id %>
          </div>
      <% :radios -> %>
          <div class="fr-form-group">
              <fieldset class="fr-fieldset fr-fieldset--inline">
                  <legend class="fr-fieldset__legend fr-text--regular" id='radio-#{input_id(f, @id)}-legend'>
                      <%= @label %>
                  </legend>
                  <div class="fr-fieldset__content">
                      <%= for {label, value} <- @values do %>
                      <div class="fr-radio-group">
                          <%= radio_button f, @id, value %>
                          <%= label f, @id, label, class: "fr-label", for: "#{input_id(f, @id)}_#{value}"  %>
                      </div>
                      <% end %>
                  </div>
              </fieldset>
              <%= error_tag f, @id %>
          </div>
      <% :checkbox -> %>
          <div class="fr-form-group">
              <%= label f, @id, @label, class: "fr-label" %>
              <%= checkbox f, @id, class: "fr-checkbox" %>
              <%= error_tag f, @id %>
          </div>
      <% :select -> %>
          <div class="fr-form-group">
              <%= label f, @id, @label, class: "fr-label" %>
              <%= select f, @id,  @values, class: "fr-select" %>
              <%= error_tag f, @id %>
          </div>
      <% :file -> %>
          <div class="fr-form-group">
              <div class="fr-upload-group">
              <%= label f, @id, @label, class: "fr-label" %>
              <%= file_input f, @id, class: "fr-upload" %>
              <%= error_tag f, @id %>
              </div>
          </div>
      <% end %>
      """
    end
  
    def render_fields(f, fields) do
      assigns = %{}
      ~H"""
          <%= for {id, input_type, opts} <- fields do %>
              <%= render_field(f, id, input_type, opts) %>
          <% end %>
      """
    end
  end
  