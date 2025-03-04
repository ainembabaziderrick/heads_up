defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident

  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(incident)


      socket
      |> assign(:page_title, "New Incident")
      |> assign(:form, to_form(changeset))
      |> assign(:incident, incident)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    changeset = Admin.change_incident(incident)


      socket
      |> assign(:page_title, "Edit Incident")
      |> assign(:form, to_form(changeset))
      |> assign(:incident, incident)
  end

  def render(assigns) do
    ~H"""
    <.header>
      <h1>{@page_title}</h1>
    </.header>
    <.simple_form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:name]} label="Name" />
      <.input field={@form[:description]} label="Description" type="textarea" phx-debounce="blur" />
      <.input field={@form[:priority]} label="Priority" type="number" />
      <.input
        field={@form[:status]}
        label="Status"
        type="select"
        options={[:pending, :resolved, :canceled]}
        prompt="Choose Status"
      />
      <.input field={@form[:image_path]} label="Image Path" />
      <:actions>
        <.button phx-disable-with="Saving...">Save Incident</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/incidents"}>Back</.back>
    """
  end

  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset = Admin.change_incident(%Incident{}, incident_params)
    socket = assign(socket, form: to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  def handle_event("save", %{"incident" => incident_params}, socket) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident created successfully")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, form: to_form(changeset))
        {:noreply, socket}
    end
  end
end
