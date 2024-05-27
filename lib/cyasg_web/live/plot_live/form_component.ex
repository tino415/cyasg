defmodule CyasgWeb.PlotLive.FormComponent do
  use CyasgWeb, :live_component

  alias Cyasg.Plots

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage plot records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="plot-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:dataset]} type="text" label="Dataset" />
        <.input field={@form[:expression]} type="text" label="Expression" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Plot</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{plot: plot} = assigns, socket) do
    changeset = Plots.change_plot(plot)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"plot" => plot_params}, socket) do
    changeset =
      socket.assigns.plot
      |> Plots.change_plot(plot_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"plot" => plot_params}, socket) do
    save_plot(socket, socket.assigns.action, plot_params)
  end

  defp save_plot(socket, :edit, plot_params) do
    case Plots.update_plot(socket.assigns.plot, plot_params) do
      {:ok, plot} ->
        notify_parent({:saved, plot})

        {:noreply,
         socket
         |> put_flash(:info, "Plot updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_plot(socket, :new, plot_params) do
    case Plots.create_plot(plot_params) do
      {:ok, plot} ->
        notify_parent({:saved, plot})

        {:noreply,
         socket
         |> put_flash(:info, "Plot created successfully")
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
