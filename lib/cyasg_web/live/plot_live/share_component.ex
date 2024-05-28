defmodule CyasgWeb.PlotLive.ShareComponent do
  use CyasgWeb, :live_component

  alias Cyasg.Accounts
  alias Cyasg.Sharings
  alias Cyasg.Sharings.Sharing

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
        <.input field={@form[:user_id]} type="select" label="User" options={user_options(@current_user)} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Sharing</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    sharing = %Sharing{}
    changeset = Sharings.change_sharing(sharing)

    {:ok,
     socket
     |> assign(:sharing, sharing)
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
    case Sharings.create_sharing(socket.assigns.plot, sharing_params) do
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

  defp user_options(current_user) do
    Accounts.list_other_users(current_user.id)
    |> Enum.map(& {&1.email, &1.id})
  end
end
