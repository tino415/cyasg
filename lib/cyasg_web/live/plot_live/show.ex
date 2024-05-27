defmodule CyasgWeb.PlotLive.Show do
  use CyasgWeb, :live_view

  alias Cyasg.Datasets
  alias Cyasg.Plots

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user_id = socket.assigns.current_user.id
    plot = Plots.get_user_plot!(user_id, id)
    datapoints = Datasets.column(plot.dataset, plot.expression)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:plot, plot)
     |> assign(:datapoints, datapoints)}
  end

  defp page_title(:show), do: "Show Plot"
  defp page_title(:edit), do: "Edit Plot"
end
