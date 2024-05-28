defmodule CyasgWeb.SharingLive.Show do
  use CyasgWeb, :live_view

  alias Cyasg.Datasets
  alias Cyasg.Sharings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    sharing = Sharings.get_sharing!(id)
    datapoints = Datasets.column(sharing.plot.dataset, sharing.plot.expression)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sharing, sharing)
     |> assign(:datapoints, datapoints)}
  end

  defp page_title(:show), do: "Show Sharing"
end
