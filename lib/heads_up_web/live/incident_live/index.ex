defmodule HeadsUpWeb.IncidentLive.Index do
alias HeadsUp.Categories
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :category_options, Categories.category_names_and_slugs())
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign(:form, to_form(params))
      |> stream(:incidents, Incidents.filter_incidents(params), reset: true)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </.headline>
      <.filter_form form={@form} category_options={@category_options}/>
      <div class="incidents" id="incidents" phx-update="stream">
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="1000" />
      <.input
        field={@form[:status]}
        options={[:pending, :resolved, :canceled]}
        prompt="Status"
        type="select"
      />
      <.input
        field={@form[:sort_by]}
        options={[
          Name: "name",
          "Priority: High to Low": "priority_desc",
          "Priority: Low to High": "priority_asc",
          Category: "category"
        ]}
        prompt="Sort By"
        type="select"
      />
      <.input
        field={@form[:category]}
        options={@category_options}
        prompt="Category"
        type="select"
      />
      <.link patch={~p"/incidents"}>Reset</.link>
    </.form>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"}>
      <div class="card">
        <div class="category">
          {@incident.category.name}
        </div>
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by category))
      |> Map.reject(fn {_k, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/incidents?#{params}")
    {:noreply, socket}
  end
end
