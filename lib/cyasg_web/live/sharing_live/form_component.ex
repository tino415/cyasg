defmodule CyasgWeb.SharingLive.FormComponent do
  use CyasgWeb, :live_component

  alias Cyasg.Sharings

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage sharing records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sharing-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Sharing</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sharing: sharing} = assigns, socket) do
    changeset = Sharings.change_sharing(sharing)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"sharing" => sharing_params}, socket) do
    changeset =
      socket.assigns.sharing
      |> Sharings.change_sharing(sharing_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"sharing" => sharing_params}, socket) do
    save_sharing(socket, socket.assigns.action, sharing_params)
  end

  defp save_sharing(socket, :edit, sharing_params) do
    case Sharings.update_sharing(socket.assigns.sharing, sharing_params) do
      {:ok, sharing} ->
        notify_parent({:saved, sharing})

        {:noreply,
         socket
         |> put_flash(:info, "Sharing updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_sharing(socket, :new, sharing_params) do
    case Sharings.create_sharing(sharing_params) do
      {:ok, sharing} ->
        notify_parent({:saved, sharing})

        {:noreply,
         socket
         |> put_flash(:info, "Sharing created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
