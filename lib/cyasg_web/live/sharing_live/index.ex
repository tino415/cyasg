defmodule CyasgWeb.SharingLive.Index do
  use CyasgWeb, :live_view

  alias Cyasg.Sharings
  alias Cyasg.Sharings.Sharing

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(socket, :sharings, Sharings.list_shared_with_user(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sharing")
    |> assign(:sharing, Sharings.get_sharing!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sharing")
    |> assign(:sharing, %Sharing{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sharings")
    |> assign(:sharing, nil)
  end

  @impl true
  def handle_info({CyasgWeb.SharingLive.FormComponent, {:saved, sharing}}, socket) do
    {:noreply, stream_insert(socket, :sharings, sharing)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sharing = Sharings.get_sharing!(id)
    {:ok, _} = Sharings.delete_sharing(sharing)

    {:noreply, stream_delete(socket, :sharings, sharing)}
  end
end
