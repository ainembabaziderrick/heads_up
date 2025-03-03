defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Incident")
      |> assign(:form, to_form(%{}, as: "incident"))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <h1>{@page_title}</h1>
    </.header>
    <.simple_form for={@form} id="incident-form" >
    <.input field={@form[:name]} label="Name"/>
    <.input field={@form[:description]} label="Description" type="textarea"/>
    <.input field={@form[:priority]} label="Priority" type="number"/>
    <.input field={@form[:status]}
     label="Status"
      type="select"
      options={[:pending, :resolved, :canceled]}
      prompt="Choose Status"/>
      <.input field={@form[:image_path]} label="Image Path" />
      <:actions>
        <.button type="submit">Save Incident</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/incidents"}>Back</.back>
    """
  end
end
