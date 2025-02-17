defmodule HeadsUpWeb.TipHTML do
  use HeadsUpWeb, :html

  embed_templates "tip_html/*"

  def show(assigns) do
    ~H"""
    <div class="tips">
      <h1> <%= @answer %>! You Like a Tip, Yes?</h1>
    <p>
    <%= @tip.text %>
    </p>
    </div>
    """
  end

end
