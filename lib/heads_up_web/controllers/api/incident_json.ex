defmodule HeadsUpWeb.Api.IncidentJSON do

  def render("index.json", %{incidents: incidents}) do
     %{
      incidents:
      for incident <- incidents  do
        %{
          id: incident.id,
          name: incident.name,
          status: incident.status,
          priority: incident.priority
        }

      end
     }
  end

  def render("show.json", %{incident: incident}) do
       %{
        incident: data(incident)
       }
  end

  defp data(incident) do
    %{
      id: incident.id,
      name: incident.name,
      status: incident.status,
      priority: incident.priority
    }
  end

end
