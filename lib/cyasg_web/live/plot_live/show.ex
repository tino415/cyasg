defmodule CyasgWeb.PlotLive.Show do
  use CyasgWeb, :live_view

  alias Cyasg.Plots

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:plot, Plots.get_plot!(id))}
  end

  defp page_title(:show), do: "Show Plot"
  defp page_title(:edit), do: "Edit Plot"
end
