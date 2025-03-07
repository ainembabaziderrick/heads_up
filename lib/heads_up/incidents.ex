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
    |> with_category(filter["category"])
    |> preload(:category)
    |> Repo.all()
  end

  defp with_category(query, slug) when slug in ["", nil], do: query

  defp with_category(query, slug) do
    from i in query, join: c in assoc(i, :category), where: c.slug == ^slug
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


  defp sort(query, "name") do
    order_by(query, :name)
  end

  defp sort(query, "priority_desc") do
    order_by(query, desc: :priority)
  end

  defp sort(query, "priority_asc") do
    order_by(query, asc: :priority)
  end

  defp sort(query, "category") do
    from i in query, join: c in assoc(i, :category), order_by: c.name
  end

  defp sort(query, _) do
    order_by(query, :id)
  end

  def get_incident(id) do
    Repo.get(Incident, id)
    |> Repo.preload(:category)
  end

  def urgent_incidents(incident) do
    Process.sleep(2000)
    Incident |>
    where(status: :pending) |>
    where([i], i.id != ^incident.id) |>
    order_by(asc: :priority) |>
    limit(3) |>
    Repo.all()
  end

end
