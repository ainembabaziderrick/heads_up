defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query
  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents(filter) do
    Incident
    |> with_status( filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, nil), do: query
  defp with_status(query, status) do
    query
    |> where([i], i.status == ^status)
  end

  defp search_by(query, nil), do: query
  defp search_by(query, q) do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end


  defp sort(query, sort_by) do
    case sort_by do
      "name" -> order_by(query, [i], i.name)
      "priority" -> order_by(query, [i], i.priority)
      _any -> query
    end
  end

  def get_incident(id) do
    Repo.get(Incident, id)
  end

  def urgent_incidents(incident) do
    Incident |>
    where(status: :pending) |>
    where([i], i.id != ^incident.id) |>
    order_by(asc: :priority) |>
    limit(3) |>
    Repo.all()
  end

end
