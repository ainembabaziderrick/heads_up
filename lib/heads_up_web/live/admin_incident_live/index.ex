defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
          out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
          time: 300
        )
      }>
        Toggle Joke
      </.button>
      <div class="joke hidden" id="joke">
        Why shouldn't you trust trees {@current_user.username}?
      </div>
      <.header class="mt-6">
        <h1>{@page_title}</h1>
        <:actions>
          <.link class="button" navigate={~p"/admin/incidents/new"}>New Incident</.link>
        </:actions>
      </.header>
      <.table id="incidents" rows={@streams.incidents} row_click={fn {_, incident} -> JS.navigate(~p"/incidents/#{incident}") end}>
        <:col :let={{_dom_id, incident}} label="Name">
          <.link navigate={~p"/incidents/#{incident}"}>
            {incident.name}
          </.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="Status">
          <.badge status={incident.status} />
        </:col>
        <:col :let={{_dom_id, incident}} label="Priority">
          {incident.priority}
        </:col>
        <:action :let={{_dom_id, incident}}>
          <.link navigate={~p"/admin/incidents/#{incident}/edit"}>
            Edit
          </.link>
        </:action>
        <:action :let={{dom_id, incident}}>
          <.link phx-click={delete_and_hide(dom_id, incident)} phx-value-id={incident.id} data-confirm="Are you sure to delete?">
            <.icon name="hero-trash" class="h-4 w-4" />
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)
    {:ok, _} = Admin.delete_incident(incident)
    {:noreply, stream_delete(socket, :incidents, incident)}
  end

  def delete_and_hide(dom_id, incident) do
    JS.push("delete",
    value: %{id: incident.id}
  )
  |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
