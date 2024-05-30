defmodule CyasgWeb.PlotLive.Index do
  use CyasgWeb, :live_view

  alias Cyasg.Plots
  alias Cyasg.Plots.Plot

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    # TODO: use user specific topic
    CyasgWeb.Endpoint.subscribe("plots")
    {:ok, stream(socket, :plots, Plots.list_user_plots(user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    user_id = socket.assigns.current_user.id

    socket
    |> assign(:page_title, "Edit Plot")
    |> assign(:plot, Plots.get_user_plot!(user_id, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Plot")
    |> assign(:plot, %Plot{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Plots")
    |> assign(:plot, nil)
  end

  @impl true
  def handle_info(%{event: "saved", payload: plot}, socket) do
    {:noreply, stream_insert(socket, :plots, plot)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_id = socket.assigns.current_user.id
    plot = Plots.get_user_plot!(user_id, id)

    {:ok, _} = Plots.delete_user_plot(user_id, plot)

    {:noreply, stream_delete(socket, :plots, plot)}
  end
end
