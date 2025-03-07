defmodule HeadsUpWeb.Api.IncidentController do
  alias HeadsUp.Admin
  use HeadsUpWeb, :controller

  def index(conn, _params) do
    incidents = Admin.list_incidents()
    render(conn, "index.json", incidents: incidents)
  end

  def show(conn, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    render(conn, "show.json", incident: incident)
  end

end
