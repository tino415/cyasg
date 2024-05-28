defmodule CyasgWeb.PlotLive.FormComponent do
  use CyasgWeb, :live_component

  alias Cyasg.Datasets
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
        <.input field={@form[:dataset]} type="select" label="Dataset" options={@datasets} />
        <p>
          <%= "'#{Enum.join(@columns, "','")}'" %>
        </p>
        <.input field={@form[:expression]} type="text" label="Expression" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Plot</.button>
        </:actions>
      </.simple_form>

      <div
        id="plot"
        phx-update="ignore"
        phx-hook="Plotly"
        data-prerender={@myself}
        data-plotly={
          Jason.encode!([
            %{
              "x" => Enum.into(@datapoints, []),
              "type" => "histogram"
            }
          ])
        }
      >
      </div>
    </div>
    """
  end

  @impl true
  def update(%{plot: plot} = assigns, socket) do
    changeset = Plots.change_plot(plot)

    {:ok,
     socket
     |> assign(:datasets, Datasets.list())
     |> assign(assigns)
     |> assign(:prerendered_image, plot.prerendered_image)
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

  def handle_event("image-src", %{"src" => src}, socket) do
    # FIXME: user could push save sooner than prerendering finishes
    # but it is not as straight forward to do this
    {:noreply, assign(socket, :prerendered_image, src)}
  end

  defp save_plot(socket, :edit, plot_params) do
    user_id = socket.assigns.current_user.id
    plot_params = Map.put(plot_params, "prerendered_image", socket.assigns.prerendered_image)

    case Plots.update_user_plot(user_id, socket.assigns.plot, plot_params) do
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
    user_id = socket.assigns.current_user.id
    plot_params = Map.put(plot_params, "prerendered_image", socket.assigns.prerendered_image)

    case Plots.create_user_plot(user_id, plot_params) do
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
    datasets = socket.assigns.datasets

    dataset = Ecto.Changeset.get_field(changeset, :dataset) || List.first(datasets)
    expression = Ecto.Changeset.get_field(changeset, :expression)
    datapoints = Datasets.column(dataset, expression)

    socket
    |> assign(:form, to_form(changeset))
    |> assign(:columns, Ecto.Changeset.get_field(changeset, :columns))
    |> assign(:datapoints, datapoints)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
