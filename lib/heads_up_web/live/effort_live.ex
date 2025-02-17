defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end
    socket = assign(socket, responders: 0, minutes_per_responder: 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
  <h1>Community Love</h1>
  <section>
  <button phx-click="add" phx-value-responders = "3">
  +3
  </button>
    <div>
      <%= @responders %>
    </div>
    &times;
    <div>
      <%= @minutes_per_responder %>
    </div>
    =
    <div>
      <%= @responders * @minutes_per_responder %>
    </div>
  </section>
  <form phx-submit="recalculate">
  <label>Minutes Per Responder:</label>
  <input type="number" name="minutes" value={@responders} />
</form>
</div>
    """
  end

  def handle_event("add", %{"responders" => responders}, socket) do
     socket = update(socket, :responders, &(&1 + String.to_integer(responders)))
     {:noreply, socket}
  end

  def handle_event("recalculate", %{"minutes" => minutes}, socket) do
    socket = update(socket, :minutes_per_responder, String.to_integer(minutes))
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :responders, &(&1 + 3))}
  end
end
